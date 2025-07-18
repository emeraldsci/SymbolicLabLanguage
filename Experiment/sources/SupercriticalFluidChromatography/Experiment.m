(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Options *)


DefineOptions[ExperimentSupercriticalFluidChromatography,
  Options :> {
    {
      OptionName -> Instrument,
      Default -> Model[Instrument,SupercriticalFluidChromatography,"Waters UPC2 PDA QDa"],
      Description -> "The measurement and collection device on which the protocol is to be run.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, SupercriticalFluidChromatography], Object[Instrument, SupercriticalFluidChromatography]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Chromatography",
            "Supercritical Fluid Chromatography"
          }
        }
      ],
      Category->"Protocol"
    },
    {
      OptionName -> Scale,
      Default -> Analytical,
      Description -> "Indicates if the experiment is intended purify or analyze material. Analytical indicates that specific measurements will be employed (e.g the absorbance of the flow with injected sample for a given wavelength) and is amendable for quantification.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Analytical]
      ],
      Category->"Protocol"
    },
    {
      OptionName -> SeparationMode,
      Default -> NormalPhase,
      Description -> "The category of separation to be used. This option is used to resolve the column, cosolvents, and column temperatures.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> SeparationModeP
      ],
      Category->"Protocol"
    },
    {
      OptionName -> Detector,
      Default -> {Temperature,Pressure,PhotoDiodeArray,MassSpectrometry},
      Description -> "The type measurement to employ. Currently, we offer PhotoDiodeArray (measures the absorbance of a range of wavelengths) and MassSpectrometry (ionizes the analytes and measures the abundance of a given mass to charge ratio).",
      AllowNull -> False,
      Widget -> Alternatives[
        Widget[
          Type -> Enumeration,
          Pattern :> (Temperature|Pressure|PhotoDiodeArray|MassSpectrometry)
        ],
        Adder[
          Widget[
            Type -> Enumeration,
            Pattern :> (Temperature|Pressure|PhotoDiodeArray|MassSpectrometry)
          ]
        ]
      ],
      Category->"Protocol"
    },

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> Column,
        Default -> Automatic,
        Description -> "Item containing the stationary phase through which the CO2, Cosolvent, and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the mobile phase, Samples, Column material, and ColumnTemperature.",
        ResolutionDescription -> "Automatically set to a column model ideal for the specified SeparationMode.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Materials",
              "Liquid Chromatography",
              "Supercritical Fluid Chromatography Columns"
            }
          }
        ],
        Category->"Protocol"
      }
    ],
    IndexMatching[
      IndexMatchingParent -> ColumnSelector,
      {
        OptionName->ColumnSelector,
        Default -> Automatic,
        Description -> "All the columns loaded into the Instrument's column selector and referenced in Column, StandardColumn, and BlankColumn options.",
        ResolutionDescription -> "Automatically set by running DeleteDuplicates on the Column, StandardColumn, and BlankColumn option.",
        AllowNull -> True,
        Widget ->Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Materials",
              "Liquid Chromatography",
              "Supercritical Fluid Chromatography Columns"
            }
          }
        ],
        Category->"Protocol"
      }
    ],
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName->ColumnTemperature,
        Default -> Automatic,
        Description -> "The temperature of the Column throughout the measurement.",
        ResolutionDescription -> "Automatically set from the temperature within the Gradient option; otherwise, set to 30 Celsius.",
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[20 Celsius, 90 Celsius, 1 Celsius],
            Units -> Celsius
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ],
        Category->"Protocol"
      }
    ],
    IndexMatching[
      IndexMatchingParent -> ColumnSelector,
      {
        OptionName -> ColumnOrientation,
        Default -> Automatic,
        Description -> "The direction of the Column with respect to the flow. Forward indicates that the Column will be placed in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the Column will be placed in the opposite direction indicated by the column manufacturer for standard operation and is typically used to clean the column.",
        ResolutionDescription -> "Automatically set to Forward for each column available; otherwise, set to Null.",
        AllowNull -> True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>ColumnOrientationP (*Forward|Reverse*)
        ],
        Category->"Protocol"
      }
    ],

    {
      OptionName -> NumberOfReplicates,
      Default -> Null,
      Description -> "The number of times to repeat measurements on each provided sample(s). If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterP[0,1]
      ],
      Category->"Protocol"
    },

    {
      OptionName -> CosolventA,
      Default -> Automatic,
      Description -> "The solvent pumped through the first channel to supplement the supercritical CO2 mobile phase.",
      ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Reagents"
          }
        }
      ],
      Category->"Protocol"
    },
    {
      OptionName -> CosolventB,
      Default -> Automatic,
      Description -> "The solvent pumped through the second channel to supplement the supercritical CO2 mobile phase.",
      ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Reagents"
          }
        }
      ],
      Category->"Protocol"
    },
    {
      OptionName -> CosolventC,
      Default -> Automatic,
      Description -> "The solvent pumped through the third channel to supplement the supercritical CO2 mobile phase.",
      ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Reagents"
          }
        }
      ],
      Category->"Protocol"
    },
    {
      OptionName -> CosolventD,
      Default -> Automatic,
      Description -> "The solvent pumped through the fourth channel to supplement the supercritical CO2 mobile phase.",
      ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Reagents"
          }
        }
      ],
      Category->"Protocol"
    },
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
              Pattern :> Standard|Sample|Blank
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
            "InjectionVolume" -> Alternatives[
              Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Microliter, 50 Microliter, 1 Microliter],
                Units :> Microliter
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ],
            "Column" -> Alternatives[
              Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
                OpenPaths -> {
                  {
                    Object[Catalog, "Root"],
                    "Materials",
                    "Liquid Chromatography",
                    "Supercritical Fluid Chromatography Columns"
                  }
                }
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ],
            "Gradient" -> Alternatives[
                Widget[
                Type -> Object,
                Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]
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
              Pattern :> ColumnPrime|ColumnFlush
            ],
            "Sample" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[Automatic|Null] (*TODO: doesn't work if just have Null*)
            ],
            "InjectionVolume" -> Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[Automatic|Null]
            ],
            "Column" -> Alternatives[
              Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
                OpenPaths -> {
                  {
                    Object[Catalog, "Root"],
                    "Materials",
                    "Liquid Chromatography",
                    "Supercritical Fluid Chromatography Columns"
                  }
                }
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ],
            "Gradient" -> Alternatives[
              Widget[
                Type -> Object,
                Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ]

          }
        ],
        Orientation->Vertical
      ],
      Category -> "Sample Parameters"
    },
    {
      OptionName -> SampleTemperature,
      Default -> Ambient,
      Description->"The temperature at which the samples, Standard, and Blank are kept in the instrument's autosampler prior to injection on the column.",
      AllowNull -> False,
      Widget -> Alternatives[
        Widget[
          Type -> Quantity,
          Pattern :> RangeP[5 Celsius, 40 Celsius, 1 Celsius],
          Units -> Celsius
        ],
        Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[Ambient]
        ]
      ],
      Category->"Sample Parameters"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> InjectionVolume,
        Default -> Automatic,
        Description -> "The physical quantity of sample loaded into the flow path for measurement and/or collection.",
        ResolutionDescription -> "Automatically set to 3 uL.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, 50 Microliter],
          Units -> Microliter
        ],
        Category->"Sample Parameters"
      }
    ],

    {
      OptionName -> NeedleWashSolution,
      Default -> Model[Sample, "Methanol - LCMS grade"],
      Description -> "The solvent used to wash the injection needle before each sample measurement.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
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
      Category->"Sample Parameters"
    },

    IndexMatching[
      IndexMatchingInput -> "experiment samples",

      (* --- Gradient Specification Parameters --- *)
      {
        OptionName -> CO2Gradient,
        Default -> Automatic,
        Description -> "The composition of the supercritical CO2 within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for CO2Gradient->{{0 Minute, 90 Percent},{30 Minute, 100 Percent}}, the percentage of CO2Gradient in the flow will rise such that at 15 minutes, the composition should be 95*Percent.",
        ResolutionDescription -> "Automatically set from Gradient option or implicitly set from GradientA, GradientB, GradientC, and GradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> GradientA,
        Default -> Automatic,
        Description -> "The composition of CosolventA within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientA->{{0 Minute, 0 Percent},{30 Minute, 10 Percent}}, the percentage of CosolventA in the flow will rise such that at 15 minutes, the composition should be 5*Percent.",
        ResolutionDescription -> "Automatically set from Gradient option or implicitly set from CO2Gradient, GradientB, GradientC, and GradientD options.",
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
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> GradientB,
        Default -> Automatic,
        Description -> "The composition of CosolventB within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 0 Percent},{30 Minute, 10 Percent}}, the percentage of CosolventB in the flow will rise such that at 15 minutes, the composition should be 5*Percent.",
        ResolutionDescription -> "Automatically set from Gradient option or implicitly set from CO2Gradient, GradientA, GradientC, and GradientD options. If no other gradient options are specified, will default to 0 Percent for the run.",
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
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> GradientC,
        Default -> Automatic,
        Description -> "The composition of CosolventC within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientC->{{0 Minute, 0 Percent},{30 Minute, 10 Percent}}, the percentage of CosolventC in the flow will rise such that at 15 minutes, the composition should be 5*Percent.",
        ResolutionDescription -> "Automatically set from Gradient option or implicitly set from CO2Gradient, GradientA, GradientB, and GradientD options. If no other gradient options are specified, will default to 0 Percent for the run.",
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
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> GradientD,
        Default -> Automatic,
        Description -> "The composition of CosolventD within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientD->{{0 Minute, 0 Percent},{30 Minute, 10 Percent}}, the percentage of CosolventD in the flow will rise such that at 15 minutes, the composition should be 5*Percent.",
        ResolutionDescription -> "Automatically set from Gradient option or implicitly set from CO2Gradient, GradientA, GradientB, and GradientC options. If no other gradient options are specified, will default to 0 Percent for the run.",
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
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> FlowRate,
        Default -> Automatic,
        Description -> "The speed of the fluid through the pump. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
        ResolutionDescription -> "Automatically set from Type and Scale or inherited from the method given in the Gradient option.",
        AllowNull -> False,
        Category -> "Gradient",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Milliliter/Minute,4 Milliliter/Minute],
            Units -> CompoundUnit[
              {1,{Milliliter,{Milliliter,Liter}}},
              {-1,{Minute,{Minute,Second}}}
            ]
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Milliliter/Minute,4 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      }
    ],
    {
      OptionName -> MaxAcceleration,
      Default -> 50 (Milliliter/Minute/Minute),
      Description -> "The maximum allowed change per time in MakeupFlowRate.",
      Category -> "General",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0.067 (Milliliter/Minute/Minute),200 (Milliliter/Minute/Minute)],
        Units -> CompoundUnit[
          {1, {Milliliter, {Milliliter,Liter}}},
          {-2, {Minute,{Minute,Second}}}
        ]
      ]
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> GradientStart,
        Default -> Null,
        Description -> "A shorthand option to specify the starting CosolventA composition in the fluid flow. This option must be specified with GradientEnd and GradientDuration.",
        ResolutionDescription -> "Automatically set to Null, if not specified.",
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
        Description -> "A shorthand option to specify the final CosolventA composition in the fluid flow. This option must be specified with GradientStart and GradientDuration.",
        ResolutionDescription -> "Automatically set to Null, if not specified.",
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
        Description -> "A shorthand option to specify the duration of GradientA.",
        ResolutionDescription -> "Automatically set to Null, if not specified.",
        AllowNull -> True,
        Category -> "Gradient",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> EquilibrationTime,
        Default -> Automatic,
        Description -> "A shorthand option to specify the duration of equilibration at the starting buffer composition at the start of a GradientA.",
        ResolutionDescription -> "Automatically set to Null, if not specified.",
        AllowNull -> True,
        Category -> "Gradient",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> FlushTime,
        Default -> Automatic,
        Description -> "A shorthand option to specify the duration of equilibration at the final buffer composition at the end of a GradientA.",
        ResolutionDescription -> "Automatically set to Null, if not specified.",
        AllowNull -> True,
        Category -> "Gradient",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> BackPressure,
        Default -> Automatic,
        Description -> "The pressure differential between the outlet of the system and the atmosphere. Higher BackPressure will increase the density of the supercritical CO2 mobile phase, thereby affecting analyte retention.
        Furthermore, higher BackPressure increases flow rate of the column effluent into the mass spectrometer. BackPressure can be changed at different timepoints during the measurement; however, unlike CO2Gradient and FlowRate, BackPressure is not linearly interpolated and, rather, changes stepwise.",
        ResolutionDescription -> "Automatically set to specification within Gradient option. If Gradient option is not specified, defaults to 1800*PSI.",
        AllowNull -> False,
        Category -> "Gradient",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[1000*PSI,6000*PSI],
            Units -> PSI
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "BackPressure" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[1000*PSI,6000*PSI],
                Units -> PSI
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> Gradient,
        Default -> Automatic,
        Description -> "The composition over time in the fluid flow. Specific parameters of an object can be overridden by specific options.",
        ResolutionDescription -> "Automatically set to best meet all the Gradient options (e.g. CO2Gradient, GradientA, GradientB, GradientC, GradientD, FlowRate, GradientStart, GradientEnd, GradientDuration, EquilibrateTime, BackPressure).",
        AllowNull -> False,
        Category -> "Gradient",
        Widget -> Alternatives[
          Widget[Type -> Object,Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Back Pressure" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 PSI],
                Units -> PSI
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },


      (*--- Mass spec options ---*)
      {
        OptionName -> IonMode,
        Default -> Automatic,
        Description -> "Indicates if positively or negatively charged ions are analyzed.",
        ResolutionDescription -> "Automatically set to positive ion mode, unless the sample is acidic (pH<=5 or pKa<=8).",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> IonModeP
        ],
        Category->"Detector Parameters"
      }
    ],
    {
      OptionName -> MakeupSolvent,
      Default -> Model[Sample,StockSolution,"90% Methanol with 0.1% formic acid and 0.1% ammonium acetate"], (*Model[Sample, StockSolution, "id:O81aEBZmMjve"]*)
      Description -> "The buffer mixed with column effluent in flow path to mass spectrometer. Facilitates molecular ionization.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Reagents"
          }
        }
      ],
      Category->"Detector Parameters"
    },
    {
      OptionName -> Calibrant,
      Default -> Model[Sample,"qDa Detector Calibrant solution"], (*Model[Sample, "id:XnlV5jK8B08P"]*)
      Description -> "A sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer. In the chosen ion polarity mode, the calibrant should contain at least 3 masses spread over the mass range of interest.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials",
            "Mass Spectrometry",
            "Calibrants"
          }
        }
      ],
      Category->"Detector Parameters"
    },

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* --- MassSpec Specific Parameters --- *)
      {
        OptionName -> MakeupFlowRate,
        Default -> 200 * Microliter/Minute,
        Description -> "The speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter/Minute,1 Milliliter/Minute],
          Units -> CompoundUnit[
            {1,{Microliter,{Microliter,Milliliter}}},
            {-1,{Minute,{Minute,Second}}}
          ]
        ],
        Category->"Detector Parameters"
      },
      {
        OptionName -> MassDetection,
        Default -> All,
        Description -> "The mass-to-charge ratios (m/z) to be recorded during analysis.",
        AllowNull -> False,
        Category->"Detector Parameters",
        Widget -> Alternatives[
          "Specific"->Adder[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[30 Gram / Mole,1200 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[30 Gram / Mole,1199 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[31 Gram / Mole, 1200 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ]
        ]
      },
      {
        OptionName -> ScanTime,
        Default -> 1 Second,
        Description -> "The duration of time allowed to pass between each spectral acquisition. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired during the measurement.",
        AllowNull -> False,
        Category -> "Detector Parameters",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.05 Second,  1 Second], (*can only be specific values {1., 0.5, 0.2, 0.125, 0.1, 0.0666667, 0.05} second*)
          Units -> Second
        ]
      },
      {
        OptionName -> ProbeTemperature,
        Default -> 100*Celsius,
        Description -> "The temperature setting of the tube that supplies column effluent into the mass spectrometer.",
        AllowNull -> False,
        Category -> "Detector Parameters",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$AmbientTemperature,  150 Celsius, 1 Celsius],
          Units -> Celsius
        ]
      },
      {
        OptionName -> ESICapillaryVoltage,
        Default -> 0.5 Kilo*Volt,
        Description -> "The applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
        AllowNull -> False,
        Category -> "Detector Parameters",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.3 Kilovolt, 1.5 Kilovolt],
          Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
        ]
      },
      {
        OptionName -> SamplingConeVoltage,
        Default -> 40 Volt,
        Description -> "The voltage differential between ion spray entry and the quadrupole mass analyzer. SamplingConeVoltage facilitates ionization of the molecules.
        This voltage normally optimizes between 25 and 100 V and should be adjusted for sensitivity depending on compound and charge state.
        For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. SamplingConeVoltage can be specified as constant value for all m/z species or
        as a ramp that linearly maps to the range specified for MassDetection. For example, if MassDetection is 100 to 1000 Da, and SamplingConeVoltage is 10 to 100 Volt, then 50 volts will be
        applied to ions with m/z of 500 Da. The ramp option is only available when MassDetection is a range.",
        AllowNull -> False,
        Category -> "Detector Parameters",
        Widget -> Alternatives[
          "Constant"->Widget[
            Type -> Quantity,
            Pattern :> RangeP[0.1 Volt, 100 Volt],
            Units -> {Volt, {Millivolt, Volt, Kilovolt}}
          ],
          "Ramp"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ]
          ]
        ]
      },
      {
        OptionName -> MassDetectionGain,
        Default -> 5,
        Description -> "The arbitrarily-scaled signal amplification for the mass spectrometry measurement.",
        AllowNull -> False,
        Category -> "Detector Parameters",
        Widget -> Widget[
          Type->Number,
          Pattern:>RangeP[1,10,1]
        ]
      },


      (* --- PDA Specific Parameters --- *)
      {
        OptionName -> AbsorbanceWavelength,
        Default -> All,
        Description -> "The physical properties of light passed through the flow for the PhotoDiodeArray Detector.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Single" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
            Units -> Nanometer
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 790 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[200 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ]
          ]
        ],
        Category->"Detector Parameters"
      },
      {
        OptionName -> WavelengthResolution,
        Default -> Automatic,
        Description -> "The increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector.",
        ResolutionDescription -> "Automatically set to 1.2*Nanometer if AbsorbanceWavelength is a range; otherwise, set to Null.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern:>RangeP[1.2*Nanometer,12.0*Nanometer],
          Units -> Nanometer
        ],
        Category->"Detector Parameters"
      },
      {
        OptionName -> UVFilter,
        Default->False,
        AllowNull->False,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors.",
        Category->"Detector Parameters"
      },
      {
        OptionName -> AbsorbanceSamplingRate,
        Default->40*1/Second,
        AllowNull->False,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[1*1/Second,80*1/Second,1*1/Second], (*can be only specific values*)
          Units->{-1,{Minute,{Minute,Second}}}
        ],
        Description -> "Indicates the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
        Category->"Detector Parameters"
      }
    ],

    IndexMatching[
      IndexMatchingParent -> Standard,
      {
        OptionName -> Standard,
        Default -> Automatic,
        Description -> "A reference compound to inject to the instrument, often used for quantification or to check internal measurement consistency.",
        ResolutionDescription -> "Automatically set from SeparationMode when any other Standard option is specified, otherwise set to Null.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
          OpenPaths -> {
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
        Description -> "The volume of each Standard to inject.",
        ResolutionDescription -> "Automatically set to the InjectionVolume, if enough volume.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, 50 Microliter],
          Units -> Microliter
        ]
      }
    ],
    {
      OptionName -> StandardFrequency,
      Default -> Automatic,
      Description -> "Specify the frequency at which Standard measurements will be inserted in the measurement sequence. If specified to a number, indicates how often the Standard measurements will run among the analyte samples; for example, if 5 input samples are measured and StandardFrequency is 2, then Standard measurement will occur after the first two samples and again after the third and fourth.",
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
        OptionName -> StandardColumn,
        Default -> Automatic,
        Description -> "The corresponding column to use for each standard sample. Null indicates to bypass any column.",
        ResolutionDescription -> "Automatically set to the first column.",
        AllowNull -> True,
        Widget -> Alternatives[
          Adder[
            Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
              OpenPaths -> {
                {
                  Object[Catalog, "Root"],
                  "Materials",
                  "Liquid Chromatography",
                  "Supercritical Fluid Chromatography Columns"
                }
              }
            ]
          ],
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Materials",
                "Liquid Chromatography",
                "Supercritical Fluid Chromatography Columns"
              }
            }
          ]
        ],
        Category->"Standard"
      },
      {
        OptionName -> StandardColumnTemperature,
        Default -> Automatic,
        Description -> "The column's temperature at which the Standard gradient and measurement is run.",
        ResolutionDescription -> "Automatically set from ColumnTemperature. Automatic resolution can be inherited from the StandardGradient option.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[20 Celsius, 90 Celsius, 1 Celsius],
            Units -> Celsius
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ]
      },
      {
        OptionName -> StandardCO2Gradient,
        Default -> Automatic,
        Description -> "The composition of the supercritical CO2 within the flow, defined for specific time points for standard samples.",
        ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardGradientA, StandardGradientB, StandardGradientC, and StandardGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardGradientA,
        Default -> Automatic,
        Description -> "The composition of CosolventA within the flow, defined for specific time points for Standard measurement.",
        ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardCO2Gradient, StandardGradientB, StandardGradientC, and StandardGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardGradientB,
        Default -> Automatic,
        Description -> "The composition of CosolventB within the flow, defined for specific time points for Standard measurement.",
        ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardCO2Gradient, StandardGradientA, StandardGradientC, and StandardGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardGradientC,
        Default -> Automatic,
        Description -> "The composition of CosolventC within the flow, defined for specific time points for Standard measurement.",
        ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardCO2Gradient, StandardGradientA, StandardGradientB, and StandardGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardGradientD,
        Default -> Automatic,
        Description -> "The composition of CosolventD within the flow, defined for specific time points for Standard measurement.",
        ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardCO2Gradient, StandardGradientA, StandardGradientB, and StandardGradientC options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
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
            Pattern :> GreaterEqualP[0 Milliliter/Minute],
            Units -> CompoundUnit[
              {1,{Milliliter,{Milliliter,Liter}}},
              {-1,{Minute,{Minute,Second}}}
            ]
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardBackPressure,
        Default -> Automatic,
        Description -> "The pressure differential between the outlet of the system and the atmosphere for Standard sample measurement.
        StandardBackPressure can be changed at different timepoints during the measurement; however, unlike StandardCO2Gradient and StandardFlowRate, StandardBackPressure is not linearly interpolated and, rather, changes stepwise.",
        ResolutionDescription -> "Automatically set to specification within Gradient option; otherwise, set to the same as the first entry in BackPressure.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[1000*PSI,6000*PSI],
            Units -> PSI
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "BackPressure" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[1000*PSI,6000*PSI],
                Units -> PSI
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardGradient,
        Default -> Automatic,
        Description -> "The composition over time in the fluid flow for Standard samples. Specific parameters of an object can be overridden by specific options.",
        ResolutionDescription -> "Automatically set to best meet all the Gradient options (e.g. StandardCO2Gradient, StandardGradientA, StandardGradientB, StandardGradientC, StandardGradientD, StandardFlowRate, GradientDuration, StandardBackPressure).",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Alternatives[
          Widget[Type -> Object,Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Back Pressure" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 PSI],
                Units -> PSI
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> StandardGradientDuration,
        Default -> Null,
        Description -> "A shorthand option to specify the duration of the Standard gradient.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> StandardIonMode,
        Default -> Automatic,
        Description -> "Indicates if positively or negatively charged ions are analyzed for Standard saples.",
        ResolutionDescription -> "Automatically set to the first entry in IonMode.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> IonModeP
        ],
        Category->"Standard"
      },
      {
        OptionName -> StandardMakeupFlowRate,
        Default -> Automatic,
        Description -> "The speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of Standard samples.",
        ResolutionDescription -> "Automatically set to the first entry in MakeupFlowRate.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter/Minute,1 Milliliter/Minute],
          Units -> CompoundUnit[
            {1,{Microliter,{Microliter,Milliliter}}},
            {-1,{Minute,{Minute,Second}}}
          ]
        ],
        Category->"Standard"
      },
      {
        OptionName -> StandardMassDetection,
        Default -> Automatic,
        Description -> "The mass-to-charge ratios (m/z) to be recorded during analysis for Standard sample measurement.",
        ResolutionDescription -> "Automatically set to the first entry in MassDetection.",
        AllowNull -> True,
        Category->"Standard",
        Widget -> Alternatives[
          "Specific"->Adder[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[100 Gram / Mole,1200 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[30 Gram / Mole,1199 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[31 Gram / Mole, 1200 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ]
        ]
      },
      {
        OptionName -> StandardScanTime,
        Default -> Automatic,
        Description -> "The duration of time allowed to pass between each spectral acquisition for Standard sample measurement. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired during the measurement.",
        ResolutionDescription -> "Automatically set to the first entry in ScanTime.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.05 Second,  1 Second],
          Units -> Second
        ]
      },
      {
        OptionName -> StandardProbeTemperature,
        Default -> Automatic,
        Description -> "The temperature setting of the tube that supplies column effluent into the mass spectrometer.",
        ResolutionDescription -> "Automatically set to the first entry in ProbeTemperature.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$AmbientTemperature,  150 Celsius, 1 Celsius],
          Units -> Celsius
        ]
      },
      {
        OptionName -> StandardESICapillaryVoltage,
        Default -> Automatic,
        Description -> "The applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
        ResolutionDescription -> "Automatically set to the first entry in ESICapillaryVoltage.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.3 Kilovolt, 1.5 Kilovolt],
          Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
        ]
      },
      {
        OptionName -> StandardSamplingConeVoltage,
        Default -> Automatic,
        Description -> "The voltage differential between ion spray entry and the quadrupole mass analyzer for Standard sample measurement.",
        ResolutionDescription -> "Automatically set to the first entry in SamplingConeVoltage.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Alternatives[
          "Constant"->Widget[
            Type -> Quantity,
            Pattern :> RangeP[0.1 Volt, 100 Volt],
            Units -> {Volt, {Millivolt, Volt, Kilovolt}}
          ],
          "Ramp"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ]
          ]
        ]
      },
      {
        OptionName -> StandardMassDetectionGain,
        Default -> Automatic,
        Description -> "The arbitrarily-scaled signal amplification for the mass spectrometry measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in MassDetectionGain.",
        AllowNull -> True,
        Category -> "Standard",
        Widget -> Widget[
          Type->Number,
          Pattern:>RangeP[1,10,1]
        ]
      },
      {
        OptionName -> StandardAbsorbanceWavelength,
        Default -> Automatic,
        Description -> "The physical properties of light passed through the flow for the PhotoDiodeArray Detector for Standard measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Single" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
            Units -> Nanometer
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ]
          ]
        ],
        Category->"Standard"
      },
      {
        OptionName -> StandardWavelengthResolution,
        Default -> Automatic,
        Description -> "The increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for Standard measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern:>RangeP[1.2*Nanometer,12.0*Nanometer], (*this can only go to specific values*)
          Units -> Nanometer
        ],
        Category->"Standard"
      },
      {
        OptionName -> StandardUVFilter,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for Standard measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
        Category->"Standard"
      },
      {
        OptionName -> StandardAbsorbanceSamplingRate,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[1*1/Second,80*1/Second,1*1/Second], (*can be only specific values*)
          Units->{-1,{Minute,{Minute,Second}}}
        ],
        Description -> "Indicates the frequency of Standard measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
        Category->"Standard"
      },
      {
        OptionName -> StandardStorageCondition,
        Default -> Null,
        Description -> "The non-default conditions under which any standards used by this experiment should be stored after the protocol is completed. If left unset, the standard samples will be stored according to their Models' DefaultStorageCondition.",
        AllowNull -> True,
        Category -> "Standard",
        (* Null indicates the storage conditions will be inherited from the model *)
        Widget -> Alternatives[
          Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
        ]
      }
    ],
    
    (*--- Blanks ---*)

    IndexMatching[
      IndexMatchingParent -> Blank,
      {
        OptionName -> Blank,
        Default -> Automatic,
        Description -> "A sample containing just buffer and no analytes, often used to check for background compounds present in the buffer or coming off the column.",
        ResolutionDescription -> "Automatically set from SeparationMode when any other Blank option is specified, otherwise set to Null.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample],Object[Sample]}],
          OpenPaths -> {
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
        OptionName -> BlankInjectionVolume,
        Default -> Automatic,
        Description -> "The volume of each Blank to inject.",
        ResolutionDescription -> "Automatically set to the first entry in InjectionVolume.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, 50 Microliter],
          Units -> Microliter
        ]
      }
    ],
    {
      OptionName -> BlankFrequency,
      Default -> Automatic,
      Description -> "Specify the frequency at which Blank measurements will be inserted in the measurement sequence. If specified to a number, indicates how often the Blank measurements will run among the analyte samples; for example, if 5 input samples are measured and BlankFrequency is 2, then Blank measurement will occur after the first two samples and again after the third and fourth.",
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
    IndexMatching[
      IndexMatchingParent -> Blank,
      {
        OptionName -> BlankColumn,
        Default -> Automatic,
        Description -> "The corresponding column to use for each Blank sample. Null indicates to bypass any column.",
        ResolutionDescription -> "Automatically set to the first column.",
        AllowNull -> True,
        Widget -> Alternatives[
          Adder[
            Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
              OpenPaths -> {
                {
                  Object[Catalog, "Root"],
                  "Materials",
                  "Liquid Chromatography",
                  "Supercritical Fluid Chromatography Columns"
                }
              }
            ]
          ],
          Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Item,Column], Object[Item,Column]}],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Materials",
                "Liquid Chromatography",
                "Supercritical Fluid Chromatography Columns"
              }
            }
          ]
        ],
        Category->"Blanks"
      },
      {
        OptionName -> BlankColumnTemperature,
        Default -> Automatic,
        Description -> "The column's temperature at which the Blank gradient and measurement is run.",
        ResolutionDescription -> "Automatically set from ColumnTemperature. Automatic resolution can be inherited from the BlankGradient option.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[20 Celsius, 90 Celsius, 1 Celsius],
            Units -> Celsius
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ]
      },
      {
        OptionName -> BlankCO2Gradient,
        Default -> Automatic,
        Description -> "The composition of the supercritical CO2 within the flow, defined for specific time points for Blank samples.",
        ResolutionDescription -> "Automatically set from BlankGradient option or implicitly set from BlankGradientA, BlankGradientB, BlankGradientC, and BlankGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankGradientA,
        Default -> Automatic,
        Description -> "The composition of CosolventA within the flow, defined for specific time points for Blank measurement.",
        ResolutionDescription -> "Automatically set from BlankGradient option or implicitly set from BlankCO2Gradient, BlankGradientB, BlankGradientC, and BlankGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankGradientB,
        Default -> Automatic,
        Description -> "The composition of CosolventB within the flow, defined for specific time points for Blank measurement.",
        ResolutionDescription -> "Automatically set from BlankGradient option or implicitly set from BlankCO2Gradient, BlankGradientA, BlankGradientC, and BlankGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankGradientC,
        Default -> Automatic,
        Description -> "The composition of CosolventC within the flow, defined for specific time points for Blank measurement.",
        ResolutionDescription -> "Automatically set from BlankGradient option or implicitly set from BlankCO2Gradient, BlankGradientA, BlankGradientB, and BlankGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankGradientD,
        Default -> Automatic,
        Description -> "The composition of CosolventD within the flow, defined for specific time points for Blank measurement.",
        ResolutionDescription -> "Automatically set from BlankGradient option or implicitly set from BlankCO2Gradient, BlankGradientA, BlankGradientB, and BlankGradientC options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankFlowRate,
        Default -> Automatic,
        Description -> "The speed of the fluid through the system for Blank measurement.",
        ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the BlankGradient option.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> GreaterEqualP[0 Milliliter/Minute],
            Units -> CompoundUnit[
              {1,{Milliliter,{Milliliter,Liter}}},
              {-1,{Minute,{Minute,Second}}}
            ]
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankBackPressure,
        Default -> Automatic,
        Description -> "The pressure differential between the outlet of the system and the atmosphere for Blank sample measurement.
        BlankBackPressure can be changed at different timepoints during the measurement; however, unlike BlankCO2Gradient and BlankFlowRate, BlankBackPressure is not linearly interpolated and, rather, changes stepwise.",
        ResolutionDescription -> "Automatically set to specification within Gradient option; otherwise, set to the same as the first entry in BackPressure.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[1000*PSI,6000*PSI],
            Units -> PSI
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "BackPressure" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[1000*PSI,6000*PSI],
                Units -> PSI
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> BlankGradient,
        Default -> Automatic,
        Description -> "The composition over time in the fluid flow for Blank samples. Specific parameters of an object can be overridden by specific options.",
        ResolutionDescription -> "Automatically set to best meet all the BlankGradient options (e.g. BlankCO2Gradient, BlankGradientA, BlankGradientB, BlankGradientC, BlankGradientD, BlankFlowRate, BlankGradientDuration, BlankBackPressure).",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Alternatives[
          Widget[Type -> Object,Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Back Pressure" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 PSI],
                Units -> PSI
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
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
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> BlankIonMode,
        Default -> Automatic,
        Description -> "Indicates if positively or negatively charged ions are analyzed for Blank samples.",
        ResolutionDescription -> "Automatically set to the first entry in IonMode.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> IonModeP
        ],
        Category->"Blanks"
      },
      {
        OptionName -> BlankMakeupFlowRate,
        Default -> Automatic,
        Description -> "The speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of Blank samples.",
        ResolutionDescription -> "Automatically set to the first entry in MakeupFlowRate.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter/Minute,1 Milliliter/Minute],
          Units -> CompoundUnit[
            {1,{Microliter,{Microliter,Milliliter}}},
            {-1,{Minute,{Minute,Second}}}
          ]
        ],
        Category->"Blanks"
      },
      {
        OptionName -> BlankMassDetection,
        Default -> Automatic,
        Description -> "The mass-to-charge ratios (m/z) to be recorded during analysis for Blank sample measurement.",
        ResolutionDescription -> "Automatically set to the first entry in MassDetection.",
        AllowNull -> True,
        Category->"Blanks",
        Widget -> Alternatives[
          "Specific"->Adder[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[100 Gram / Mole,1200 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[30 Gram / Mole,1199 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[31 Gram / Mole, 1200 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ]
        ]
      },
      {
        OptionName -> BlankScanTime,
        Default -> Automatic,
        Description -> "The duration of time allowed to pass between each spectral acquisition for Blank sample measurement. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired during the measurement.",
        ResolutionDescription -> "Automatically set to the first entry in ScanTime.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.05 Second,  1 Second],
          Units -> Second
        ]
      },
      {
        OptionName -> BlankProbeTemperature,
        Default -> Automatic,
        Description -> "The temperature setting of the tube that supplies column effluent into the mass spectrometer.",
        ResolutionDescription -> "Automatically set to the first entry in ProbeTemperature.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$AmbientTemperature,  150 Celsius, 1 Celsius],
          Units -> Celsius
        ]
      },
      {
        OptionName -> BlankESICapillaryVoltage,
        Default -> Automatic,
        Description -> "The applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
        ResolutionDescription -> "Automatically set to the first entry in ESICapillaryVoltage.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.3 Kilovolt, 1.5 Kilovolt],
          Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
        ]
      },
      {
        OptionName -> BlankSamplingConeVoltage,
        Default -> Automatic,
        Description -> "The voltage differential between ion spray entry and the quadrupole mass analyzer for Blank sample measurement.",
        ResolutionDescription -> "Automatically set to the first entry in SamplingConeVoltage.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Alternatives[
          "Constant"->Widget[
            Type -> Quantity,
            Pattern :> RangeP[0.1 Volt, 100 Volt],
            Units -> {Volt, {Millivolt, Volt, Kilovolt}}
          ],
          "Ramp"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ]
          ]
        ]
      },
      {
        OptionName -> BlankMassDetectionGain,
        Default -> Automatic,
        Description -> "The arbitrarily-scaled signal amplification for the mass spectrometry measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in MassDetectionGain.",
        AllowNull -> True,
        Category -> "Blanks",
        Widget -> Widget[
          Type->Number,
          Pattern:>RangeP[1,10,1]
        ]
      },
      {
        OptionName -> BlankAbsorbanceWavelength,
        Default -> Automatic,
        Description -> "The physical properties of light passed through the flow for the PhotoDiodeArray Detector for Blank measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Single" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
            Units -> Nanometer
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ]
          ]
        ],
        Category->"Blanks"
      },
      {
        OptionName -> BlankWavelengthResolution,
        Default -> Automatic,
        Description -> "The increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for Blank measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern:>RangeP[1.2*Nanometer,12.0*Nanometer], (*this can only go to specific values*)
          Units -> Nanometer
        ],
        Category->"Blanks"
      },
      {
        OptionName -> BlankUVFilter,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for Blank measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
        Category->"Blanks"
      },
      {
        OptionName -> BlankAbsorbanceSamplingRate,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[1*1/Second,80*1/Second,1*1/Second], (*can be only specific values*)
          Units->{-1,{Minute,{Minute,Second}}}
        ],
        Description -> "Indicates the frequency of Blank measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
        Category->"Blanks"
      },
      {
        OptionName -> BlankStorageCondition,
        Default -> Null,
        Description -> "The non-default conditions under which any Blank samples used by this experiment should be stored after the protocol is completed. If left unset, the standard samples will be stored according to their Models' DefaultStorageCondition.",
        AllowNull -> True,
        Category -> "Blanks",
        (* Null indicates the storage conditions will be inherited from the model *)
        Widget -> Alternatives[
          Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
        ]
      }
    ],
    {
      OptionName -> ColumnRefreshFrequency,
      Default -> Automatic,
      Description -> "Specify the frequency at which procedures to clear out and re-prime the column will be inserted into the order of analyte injections. If specified to a number, indicates how often the column prime runs will run among the analyte samples; for example, if 5 input samples are measured and ColumnRefreshFrequency is 2, then a column prime will occur after the first two samples and again after the third and fourth.",
      ResolutionDescription -> "Set to Null when InjectionTable option is specified (meaning that this option is inconsequential); otherwise, set to FirstAndLast (meaning initial column prime before the measurements and final column flush after measurements.) when there is a Column. Set to None if there is no Column (meaning no column flush).",
      AllowNull -> True,
      Category -> "ColumnPrime",
      Widget -> Alternatives[
        Widget[
          Type -> Enumeration,
          Pattern :> None | FirstAndLast
        ],
        Widget[
          Type -> Number,
          Pattern :> GreaterP[0, 1]
        ]
      ]
    },
    IndexMatching[
      IndexMatchingParent -> ColumnSelector,
      {
        OptionName -> ColumnPrimeColumnTemperature,
        Default -> Automatic,
        Description -> "The column's temperature at which the ColumnPrime gradient and measurement is run.",
        ResolutionDescription -> "Automatically set from ColumnTemperature. Automatic resolution can be inherited from the ColumnPrimeGradient option.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[20 Celsius, 90 Celsius, 1 Celsius],
            Units -> Celsius
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeCO2Gradient,
        Default -> Automatic,
        Description -> "The composition of the supercritical CO2 within the flow, defined for specific time points for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly set from ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, and ColumnPrimeGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeGradientA,
        Default -> Automatic,
        Description -> "The composition of CosolventA within the flow, defined for specific time points for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly set from ColumnPrimeCO2Gradient, ColumnPrimeGradientB, ColumnPrimeGradientC, and ColumnPrimeGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeGradientB,
        Default -> Automatic,
        Description -> "The composition of CosolventB within the flow, defined for specific time points for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly set from ColumnPrimeCO2Gradient, ColumnPrimeGradientA, ColumnPrimeGradientC, and ColumnPrimeGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeGradientC,
        Default -> Automatic,
        Description -> "The composition of CosolventC within the flow, defined for specific time points for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly set from ColumnPrimeCO2Gradient, ColumnPrimeGradientA, ColumnPrimeGradientB, and ColumnPrimeGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeGradientD,
        Default -> Automatic,
        Description -> "The composition of CosolventD within the flow, defined for specific time points for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly set from ColumnPrimeCO2Gradient, ColumnPrimeGradientA, ColumnPrimeGradientB, and ColumnPrimeGradientC options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeFlowRate,
        Default -> Automatic,
        Description -> "The speed of the fluid through the system for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the ColumnPrimeGradient option.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> GreaterEqualP[0 Milliliter/Minute],
            Units -> CompoundUnit[
              {1,{Milliliter,{Milliliter,Liter}}},
              {-1,{Minute,{Minute,Second}}}
            ]
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeGradientDuration,
        Default -> Null,
        Description -> "A shorthand option to specify the duration of the ColumnPrime runs.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> ColumnPrimeGradient,
        Default -> Automatic,
        Description -> "The composition over time in the fluid flow for ColumnPrime runs. Specific parameters of an object can be overridden by specific options.",
        ResolutionDescription -> "Automatically set to best meet all the ColumnPrimeGradient options (e.g. ColumnPrimeCO2Gradient, ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, ColumnPrimeGradientD, ColumnPrimeFlowRate, ColumnPrimeGradientDuration, ColumnPrimeBackPressure).",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Alternatives[
          Widget[Type -> Object,Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Back Pressure" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 PSI],
                Units -> PSI
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeBackPressure,
        Default -> Automatic,
        Description -> "The pressure differential between the outlet of the system and the atmosphere for ColumnPrime runs.
        ColumnPrimeBackPressure can be changed at different timepoints during the measurement; however, unlike ColumnPrimeCO2Gradient and ColumnPrimeFlowRate, ColumnPrimeBackPressure is not linearly interpolated and, rather, changes stepwise.",
        ResolutionDescription -> "Automatically set to specification within Gradient option; otherwise, set to the same as the first entry in BackPressure.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[1000*PSI,6000*PSI],
            Units -> PSI
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "BackPressure" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[1000*PSI,6000*PSI],
                Units -> PSI
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeIonMode,
        Default -> Automatic,
        Description -> "Indicates if positively or negatively charged ions are analyzed for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the first entry in IonMode.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> IonModeP
        ],
        Category->"ColumnPrime"
      },
      {
        OptionName -> ColumnPrimeMakeupFlowRate,
        Default -> Automatic,
        Description -> "The speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the first entry in MakeupFlowRate.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter/Minute,1 Milliliter/Minute],
          Units -> CompoundUnit[
            {1,{Microliter,{Microliter,Milliliter}}},
            {-1,{Minute,{Minute,Second}}}
          ]
        ],
        Category->"ColumnPrime"
      },
      {
        OptionName -> ColumnPrimeMassDetection,
        Default -> Automatic,
        Description -> "The mass-to-charge ratios (m/z) to be recorded during analysis for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the first entry in MassDetection.",
        AllowNull -> True,
        Category->"ColumnPrime",
        Widget -> Alternatives[
          "Specific"->Adder[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[100 Gram / Mole,1200 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[30 Gram / Mole,1199 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[31 Gram / Mole, 1200 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeScanTime,
        Default -> Automatic,
        Description -> "The duration of time allowed to pass between each spectral acquisition for ColumnPrime runs. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired during the measurement.",
        ResolutionDescription -> "Automatically set to the first entry in ScanTime.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.05 Second,  1 Second],
          Units -> Second
        ]
      },
      {
        OptionName -> ColumnPrimeProbeTemperature,
        Default -> Automatic,
        Description -> "The temperature setting of the tube that supplies column effluent into the mass spectrometer.",
        ResolutionDescription -> "Automatically set to the first entry in ProbeTemperature.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$AmbientTemperature,  150 Celsius, 1 Celsius],
          Units -> Celsius
        ]
      },
      {
        OptionName -> ColumnPrimeESICapillaryVoltage,
        Default -> Automatic,
        Description -> "The applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules for each column prime.",
        ResolutionDescription -> "Automatically set to the first entry in ESICapillaryVoltage.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.3 Kilovolt, 1.5 Kilovolt],
          Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
        ]
      },
      {
        OptionName -> ColumnPrimeSamplingConeVoltage,
        Default -> Automatic,
        Description -> "The voltage differential between ion spray entry and the quadrupole mass analyzer for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the first entry in SamplingConeVoltage.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Alternatives[
          "Constant"->Widget[
            Type -> Quantity,
            Pattern :> RangeP[0.1 Volt, 100 Volt],
            Units -> {Volt, {Millivolt, Volt, Kilovolt}}
          ],
          "Ramp"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ]
          ]
        ]
      },
      {
        OptionName -> ColumnPrimeMassDetectionGain,
        Default -> Automatic,
        Description -> "The arbitrarily-scaled signal amplification for the mass spectrometry measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in MassDetectionGain.",
        AllowNull -> True,
        Category -> "ColumnPrime",
        Widget -> Widget[
          Type->Number,
          Pattern:>RangeP[1,10,1]
        ]
      },
      {
        OptionName -> ColumnPrimeAbsorbanceWavelength,
        Default -> Automatic,
        Description -> "The physical properties of light passed through the flow for the PhotoDiodeArray Detector for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Single" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
            Units -> Nanometer
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ]
          ]
        ],
        Category->"ColumnPrime"
      },
      {
        OptionName -> ColumnPrimeWavelengthResolution,
        Default -> Automatic,
        Description -> "The increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern:>RangeP[1.2*Nanometer,12.0*Nanometer], (*this can only go to specific values*)
          Units -> Nanometer
        ],
        Category->"ColumnPrime"
      },
      {
        OptionName -> ColumnPrimeUVFilter,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for ColumnPrime runs.",
        ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
        Category->"ColumnPrime"
      },
      {
        OptionName -> ColumnPrimeAbsorbanceSamplingRate,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[1*1/Second,80*1/Second,1*1/Second], (*can be only specific values*)
          Units->{-1,{Minute,{Minute,Second}}}
        ],
        Description -> "Indicates the frequency of ColumnPrime runs. Lower values will be less susceptible to noise but will record less frequently across time.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
        Category->"ColumnPrime"
      },

      {
        OptionName -> ColumnFlushColumnTemperature,
        Default -> Automatic,
        Description -> "The column's temperature at which the ColumnFlush gradient and measurement is run.",
        ResolutionDescription -> "Automatically set from ColumnTemperature. Automatic resolution can be inherited from the ColumnFlushGradient option.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[20 Celsius, 90 Celsius, 1 Celsius],
            Units -> Celsius
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Ambient]
          ]
        ]
      },
      {
        OptionName -> ColumnFlushCO2Gradient,
        Default -> Automatic,
        Description -> "The composition of the supercritical CO2 within the flow, defined for specific time points for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly set from ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, and ColumnFlushGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushGradientA,
        Default -> Automatic,
        Description -> "The composition of CosolventA within the flow, defined for specific time points for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly set from ColumnFlushCO2Gradient, ColumnFlushGradientB, ColumnFlushGradientC, and ColumnFlushGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushGradientB,
        Default -> Automatic,
        Description -> "The composition of CosolventB within the flow, defined for specific time points for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly set from ColumnFlushCO2Gradient, ColumnFlushGradientA, ColumnFlushGradientC, and ColumnFlushGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushGradientC,
        Default -> Automatic,
        Description -> "The composition of CosolventC within the flow, defined for specific time points for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly set from ColumnFlushCO2Gradient, ColumnFlushGradientA, ColumnFlushGradientB, and ColumnFlushGradientD options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushGradientD,
        Default -> Automatic,
        Description -> "The composition of CosolventD within the flow, defined for specific time points for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly set from ColumnFlushCO2Gradient, ColumnFlushGradientA, ColumnFlushGradientB, and ColumnFlushGradientC options.",
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
                Units -> {Minute,{Second,Minute}}
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushFlowRate,
        Default -> Automatic,
        Description -> "The speed of the fluid through the system for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the ColumnFlushGradient option.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> GreaterEqualP[0 Milliliter/Minute],
            Units -> CompoundUnit[
              {1,{Milliliter,{Milliliter,Liter}}},
              {-1,{Minute,{Minute,Second}}}
            ]
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushGradientDuration,
        Default -> Null,
        Description -> "A shorthand option to specify the duration of the ColumnFlush runs.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 Minute],
          Units -> {Minute,{Minute,Second}}
        ]
      },
      {
        OptionName -> ColumnFlushGradient,
        Default -> Automatic,
        Description -> "The composition over time in the fluid flow for ColumnFlush runs. Specific parameters of an object can be overridden by specific options.",
        ResolutionDescription -> "Automatically set to best meet all the ColumnFlushGradient options (e.g. ColumnFlushCO2Gradient, ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, ColumnFlushGradientD, ColumnFlushFlowRate, ColumnFlushGradientDuration, ColumnFlushBackPressure).",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Alternatives[
          Widget[Type -> Object,Pattern :> ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "CO2 Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent A Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent B Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent C Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Cosolvent D Composition" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[0 Percent, 100 Percent],
                Units -> Percent
              ],
              "Back Pressure" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 PSI],
                Units -> PSI
              ],
              "Flow Rate" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Milliliter/Minute],
                Units -> CompoundUnit[
                  {1,{Milliliter,{Milliliter,Liter}}},
                  {-1,{Minute,{Minute,Second}}}
                ]
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushBackPressure,
        Default -> Automatic,
        Description -> "The pressure differential between the outlet of the system and the atmosphere for ColumnFlush runs.
        ColumnFlushBackPressure can be changed at different timepoints during the measurement; however, unlike ColumnFlushCO2Gradient and ColumnFlushFlowRate, ColumnFlushBackPressure is not linearly interpolated and, rather, changes stepwise.",
        ResolutionDescription -> "Automatically set to specification within Gradient option; otherwise, set to the same as the first entry in BackPressure.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[1000*PSI,6000*PSI],
            Units -> PSI
          ],
          Adder[
            {
              "Time" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 Minute],
                Units -> {Minute,{Second,Minute}}
              ],
              "BackPressure" -> Widget[
                Type -> Quantity,
                Pattern :> RangeP[1000*PSI,6000*PSI],
                Units -> PSI
              ]
            },
            Orientation->Vertical
          ]
        ]
      },
      {
        OptionName -> ColumnFlushIonMode,
        Default -> Automatic,
        Description -> "Indicates if positively or negatively charged ions are analyzed for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the first entry in IonMode.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> IonModeP
        ],
        Category->"ColumnFlush"
      },
      {
        OptionName -> ColumnFlushMakeupFlowRate,
        Default -> Automatic,
        Description -> "The speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the first entry in MakeupFlowRate.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter/Minute,1 Milliliter/Minute],
          Units -> CompoundUnit[
            {1,{Microliter,{Microliter,Milliliter}}},
            {-1,{Minute,{Minute,Second}}}
          ]
        ],
        Category->"ColumnFlush"
      },
      {
        OptionName -> ColumnFlushMassDetection,
        Default -> Automatic,
        Description -> "The mass-to-charge ratios (m/z) to be recorded during analysis for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the first entry in MassDetection.",
        AllowNull -> True,
        Category->"ColumnFlush",
        Widget -> Alternatives[
          "Specific"->Adder[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[100 Gram / Mole,1200 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[30 Gram / Mole,1199 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[31 Gram / Mole, 1200 Gram/Mole, 1 Gram/Mole],
              Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram,Kilogram}}},{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
            ]
          ]
        ]
      },
      {
        OptionName -> ColumnFlushScanTime,
        Default -> Automatic,
        Description -> "The duration of time allowed to pass between each spectral acquisition for ColumnFlush runs. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired during the measurement.",
        ResolutionDescription -> "Automatically set to the first entry in ScanTime.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.05 Second,  1 Second],
          Units -> Second
        ]
      },
      {
        OptionName -> ColumnFlushProbeTemperature,
        Default -> Automatic,
        Description -> "The temperature setting of the tube that supplies column effluent into the mass spectrometer.",
        ResolutionDescription -> "Automatically set to the first entry in ProbeTemperature.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[$AmbientTemperature,  150 Celsius, 1 Celsius],
          Units -> Celsius
        ]
      },
      {
        OptionName -> ColumnFlushESICapillaryVoltage,
        Default -> Automatic,
        Description -> "The applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules for each column flush.",
        ResolutionDescription -> "Automatically set to the first entry in ESICapillaryVoltage.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.3 Kilovolt, 1.5 Kilovolt],
          Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
        ]
      },
      {
        OptionName -> ColumnFlushSamplingConeVoltage,
        Default -> Automatic,
        Description -> "The voltage differential between ion spray entry and the quadrupole mass analyzer for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the first entry in SamplingConeVoltage.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Alternatives[
          "Constant"->Widget[
            Type -> Quantity,
            Pattern :> RangeP[0.1 Volt, 100 Volt],
            Units -> {Volt, {Millivolt, Volt, Kilovolt}}
          ],
          "Ramp"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0.1 Volt, 100 Volt],
              Units -> {Volt, {Millivolt, Volt, Kilovolt}}
            ]
          ]
        ]
      },
      {
        OptionName -> ColumnFlushMassDetectionGain,
        Default -> Automatic,
        Description -> "The arbitrarily-scaled signal amplification for the mass spectrometry measurement.",
        ResolutionDescription -> "Automatically set to the same as the first entry in MassDetectionGain.",
        AllowNull -> True,
        Category -> "ColumnFlush",
        Widget -> Widget[
          Type->Number,
          Pattern:>RangeP[1,10,1]
        ]
      },
      {
        OptionName -> ColumnFlushAbsorbanceWavelength,
        Default -> Automatic,
        Description -> "The physical properties of light passed through the flow for the PhotoDiodeArray Detector for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
        AllowNull -> True,
        Widget -> Alternatives[
          "Single" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
            Units -> Nanometer
          ],
          "All" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ],
          "Range"->Span[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ],
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[190 Nanometer, 800 Nanometer, 1 Nanometer],
              Units -> Nanometer
            ]
          ]
        ],
        Category->"ColumnFlush"
      },
      {
        OptionName -> ColumnFlushWavelengthResolution,
        Default -> Automatic,
        Description -> "The increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern:>RangeP[1.2*Nanometer,12.0*Nanometer], (*this can only go to specific values*)
          Units -> Nanometer
        ],
        Category->"ColumnFlush"
      },
      {
        OptionName -> ColumnFlushUVFilter,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>BooleanP
        ],
        Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for ColumnFlush runs.",
        ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
        Category->"ColumnFlush"
      },
      {
        OptionName -> ColumnFlushAbsorbanceSamplingRate,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[1*1/Second,80*1/Second,1*1/Second], (*can be only specific values*)
          Units->{-1,{Minute,{Minute,Second}}}
        ],
        Description -> "Indicates the frequency of ColumnFlush runs. Lower values will be less susceptible to noise but will record less frequently across time.",
        ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
        Category->"ColumnFlush"
      }
    ],
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
    NonBiologyFuntopiaSharedOptions,
    SamplesInStorageOptions,
    SimulationOption
  }
];



(* ::Subsubsection::Closed:: *)
(*ExperimentSupercriticalFluidChromatography error messages*)


(*
The following errors are already defined in other experiment functions (primarily ExperimentHPLC)

Error::DiscardedSamples
Warning::InstrumentalPrecision
Warning::ColumnTypeIncompatible
Error::DuplicateName
Error::RetiredChromatographyInstrument
Error::DeprecatedInstrumentModel
Warning::IncompatibleColumnTechnique
Error::IncompatibleColumnSize
Error::IncompatibleSolventpH
Error::HPLCTooManySamples
Error::IncompatibleInjectonVolume
Error::IncompatibleSampleContainers
Error::DiscardedSampleForOption
Error::ColumnSelectorConflict
Error::GradientStartEndDurationConflict
Error::InjectionTableColumnGradientConflict
Error::InjectionTableGradientConflict
Error::WavelengthResolutionConflict
Warning::AbsorbanceRateAdjusted
Warning::WavelengthResolutionAdjusted
*)
Error::InjectionTableColumnConflictSFC="The specified columns in InjectionTable do not match other column options. Consider allowing these column options to set automatically.";
Error::NonbinaryGradientDefined="No more than one cosolvent can be specified for each gradient.";
Error::SelectorInjectionTableConflict="The specified ColumnSelector does not match the columns within the InjectionTable. Consider allowing ColumnSelector to set automatically.";
Error::GradientStartEndDurationConflict = "If GradientStart and GradientEnd are specified, GradientDuration must be specified as well in `1` options for `2`.";
Error::GradientStartEndConflict = "GradientStart and GradientEnd must be specified simultaneously or not at all in `1` options for `2`.";
Error::GradientCO2PressureConflict = "The following ABPR pressures (CO2 gradient pressures) were specified: `1`. However, the resolved instrument model `2` requires that those pressures be between `3` and `4`. Please specify pressures withing that range.";

Warning::CosolventConflict="The resolution of `1` differ from provided gradient methods' respective cosolvents. Nonetheless, the experiment will commence as directed.";
Warning::ScanTimeAdjusted="The scan time specified in the following options do not match the acceptable values and will have to be rounded to proceed: `1`. If you don't wish rounding to occur automatically, please supply a value from the following list: `2`.";


(* ::Subsubsection:: *)
(*ExperimentSupercriticalFluidChromatography main function*)


ExperimentSupercriticalFluidChromatography[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
    safeOps,safeOpsTests,validLengths,validLengthTests,availableInstruments,allObjects,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
    safeOpsNamed, objectSampleFields, analyteFields, objectContainerFields, modelContainerFieldsPacket,listedSamples,
    modelInstrumentFields,columnFields,modelColumnFields,gradientFields,sampleFields,modelContainerFields,optionsWithObjects,
    sampleObjects,modelContainerObjects,instrumentObjects,modelInstrumentObjects,columnObjects,modelColumnObjects,gradientObjects,
    templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cache,cacheBall,resolvedOptionsResult,instrumentFields,injectionTableLookup,injectionTableObjects,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests, updatedSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  {listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentSupercriticalFluidChromatography,
      listedSamples,
      listedOptions
    ],
    $Failed,
    {Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
    Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentSupercriticalFluidChromatography,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentSupercriticalFluidChromatography,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentSupercriticalFluidChromatography,{mySamplesWithPreparedSamplesNamed},myOptionsWithPreparedSamplesNamed,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentSupercriticalFluidChromatography,{mySamplesWithPreparedSamplesNamed},myOptionsWithPreparedSamplesNamed],Null}
  ];

  (* Sanitize the samples and options using sanitizInput funciton*)
  {mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];


  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentSupercriticalFluidChromatography,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentSupercriticalFluidChromatography,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentSupercriticalFluidChromatography,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

  (* Fields to download from any instrument objects *)
  instrumentFields = {
    Packet[Model,Status],
    Packet[Model[{
      Detectors,
      Scale,
      MassAnalyzer,
      IonSources,
      IonModes,
      AcquisitionModes,
      MaxNumberOfColumns,
      MinMass,
      MaxMass,
      MinAbsorbanceWavelength,
      MaxAbsorbanceWavelength,
      AbsorbanceResolution,
      MinAcceleration,
      MaxAcceleration,
      MinSampleVolume,
      MaxSampleVolume,
      MinSampleTemperature,
      MaxSampleTemperature,
      MinFlowRate,
      MaxFlowRate,
      MinBackPressure,
      MaxBackPressure,
      MinMakeupFlowRate,
      MaxMakeupFlowRate,
      MinpH,
      MaxpH,
      MinColumnTemperature,
      MaxColumnTemperature,
      MaxColumnLength,
      MaxColumnInternalDiameter,
      MinFlowPressure,
      MaxFlowPressure,
      MinCO2Pressure,
      MaxCO2Pressure,
      MinSpectrometerSamplingRate,
      MaxSpectrometerSamplingRate,
      MinESICapillaryVoltage,
      MaxESICapillaryVoltage,
      MinSamplingConeVoltage,
      MaxSamplingConeVoltage,
      MinSourceTemperature,
      MaxSourceTemperature,
      MinDesolvationTemperature,
      MaxDesolvationTemperature,
      Manufacturer,
      AutosamplerDeckModel,
      Deprecated
    }]],
    Packet[Model[Field[AutosamplerDeckModel]][{Positions}]]
  };

  (* Fields to download from any model instrument objects *)
  modelInstrumentFields = {
    Packet[
      Detectors,
      Scale,
      MassAnalyzer,
      IonSources,
      IonModes,
      AcquisitionModes,
      MaxNumberOfColumns,
      MinMass,
      MaxMass,
      MinAbsorbanceWavelength,
      MaxAbsorbanceWavelength,
      AbsorbanceResolution,
      MinAcceleration,
      MaxAcceleration,
      MinSampleVolume,
      MaxSampleVolume,
      MinSampleTemperature,
      MaxSampleTemperature,
      MinFlowRate,
      MaxFlowRate,
      MinBackPressure,
      MaxBackPressure,
      MinMakeupFlowRate,
      MaxMakeupFlowRate,
      MinpH,
      MaxpH,
      MinColumnTemperature,
      MaxColumnTemperature,
      MaxColumnLength,
      MaxColumnInternalDiameter,
      MinFlowPressure,
      MaxFlowPressure,
      MinCO2Pressure,
      MaxCO2Pressure,
      MinSpectrometerSamplingRate,
      MaxSpectrometerSamplingRate,
      MinESICapillaryVoltage,
      MaxESICapillaryVoltage,
      MinSamplingConeVoltage,
      MaxSamplingConeVoltage,
      MinSourceTemperature,
      MaxSourceTemperature,
      MinDesolvationTemperature,
      MaxDesolvationTemperature,
      Manufacturer,
      AutosamplerDeckModel,
      Deprecated,
      WettedMaterials
    ],
    Packet[Field[AutosamplerDeckModel][{Positions}]]
  };

  (* Fields to download from any column objects *)
  columnFields = {
    Packet[Model],
    Packet[Model[{ChromatographyType,ChromatographyTechnique,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature,PreferredGuardCartridge}]]
  };

  (* Fields to download from any column model objects *)
  modelColumnFields = {
    Packet[ChromatographyType,ChromatographyTechnique,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature,PreferredGuardCartridge]
  };

  (* Set fields to download from gradient objects *)
  gradientFields = {Packet[CosolventA,CosolventB,CosolventC,CosolventD,Gradient,EquilibrationTime,FlushTime]};

  (*define all the fields that we want*)
  objectSampleFields=Union[SamplePreparationCacheFields[Object[Sample]],{Analytes,Density,LightSensitive,State}];
  analyteFields={Object,PolymerType,MolecularWeight};
  objectContainerFields=Union[SamplePreparationCacheFields[Object[Container]]];
  modelContainerFields=Union[SamplePreparationCacheFields[Model[Container]]];

  (* Set fields to download from mySamples *)
  sampleFields = {
    Packet[Sequence@@objectSampleFields],
    Packet[Analytes[analyteFields]],
    Packet[Field[Composition[[All, 2]]][{Object, Name, MolecularWeight}]],
    Packet[Container[objectContainerFields]],
    Packet[Container[Model][modelContainerFields]]
  };

  (* Container Model fields to download *)
  modelContainerFieldsPacket = {Packet[Sequence@@modelContainerFields]};

  (* Any options whose values _could_ be an object *)
  optionsWithObjects = {
    Column,
    ColumnSelector,
    Instrument,
    CosolventA,
    CosolventB,
    CosolventC,
    CosolventD,
    MakeupSolvent,
    Gradient,
    Standard,
    StandardGradient,
    Blank,
    BlankGradient,
    ColumnPrimeGradient,
    ColumnFlushGradient
  };

  (*we also need to the check the objects within the injection table*)
  injectionTableLookup=Lookup[ToList[myOptions],InjectionTable,Null];

  (*if injection table is specified, need to check all of the column and gradient objects within*)
  injectionTableObjects=If[MatchQ[injectionTableLookup,Except[Automatic|Null]],
    (*get the samples, Gradient and Columns*)
    Flatten[injectionTableLookup[[All,{2,4,5}]]],
    (*otherwise, we can just say Null*)
    Null
  ];

  (*all the instruments to use*)
  availableInstruments={Model[Instrument, SupercriticalFluidChromatography, "Waters UPC2 PDA QDa"]};

  (* Flatten and merge all possible objects needed into a list *)
  allObjects = DeleteDuplicates@Download[
    Cases[
      Flatten@Join[
        mySamplesWithPreparedSamples,
        (* Default objects *)
        {
          (* various columns *)
          Model[Item, Column, "id:P5ZnEjdmGDoE"],
          Model[Item, Column, "id:4pO6dM5kPeoX"],
          Model[Item, Column, "id:4pO6dM5ZbjrB"],
          (* containers *)
          Model[Container, Vessel, "HPLC vial (high recovery)"],
          Model[Container, Vessel, "HPLC vial (flat bottom)"],
          (* Instruments *)
          availableInstruments,
          Model[Container, Rack, "Waters Acquity UPLC Autosampler Rack"],
          (* Default Buffers *)
          Model[Sample, "id:lYq9jRxWD1OB"],
          Model[Sample, "id:01G6nvkKrrPd"],
          Model[Sample, "id:Z1lqpMGjeev0"],
          Model[Sample, "id:wqW9BP7E5Ge9"],
          (*system prime and flush gradients*)
          Object[Method, SupercriticalFluidGradient, "ExperimentSupercriticalFluidChromatography System Prime Gradient"],
          (*default standard mix*)
          Model[Sample, StockSolution, "SFC MS Standard Mix 1"]
        },
        (* All options that _could_ have an object *)
        Lookup[expandedSafeOps,optionsWithObjects],
        (*also include anything within the injection table*)
        If[!NullQ[injectionTableObjects],injectionTableObjects,{}]
      ],
      ObjectP[]
    ],
    Object
  ];

  (* Isolate objects of particular types so we can build a indexed-download call *)
  sampleObjects = Cases[allObjects,NonSelfContainedSampleP];
  modelContainerObjects = Cases[allObjects,ObjectP[Model[Container]]];
  instrumentObjects = Cases[allObjects,ObjectP[Object[Instrument,SupercriticalFluidChromatography]]];
  modelInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument,SupercriticalFluidChromatography]]];
  columnObjects = Cases[allObjects,ObjectP[Object[Item,Column]]];
  modelColumnObjects = Cases[allObjects,ObjectP[Model[Item,Column]]];
  gradientObjects = Cases[allObjects,ObjectP[Object[Method,SupercriticalFluidGradient]]];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cache = Lookup[safeOps, Cache];
  cacheBall=DeleteCases[
    FlattenCachePackets@Quiet[
      {
        cache,
        Download[
          {sampleObjects,modelContainerObjects,instrumentObjects,modelInstrumentObjects,columnObjects,modelColumnObjects,gradientObjects},
          {sampleFields,modelContainerFieldsPacket,instrumentFields,modelInstrumentFields,columnFields,modelColumnFields,gradientFields},
          Cache->cache,
          Simulation -> updatedSimulation,
          Date -> Now
        ]
      },
      {Download::FieldDoesntExist}
    ],
    Null
  ];

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentSupercriticalFluidChromatographyOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentSupercriticalFluidChromatographyOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentSupercriticalFluidChromatography,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentSupercriticalFluidChromatography,collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* Build packets with resources *)
  {resourcePackets,resourcePacketTests} = If[gatherTests,
    sfcResourcePackets[ToList[mySamplesWithPreparedSamples],templatedOptions,resolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation,Output->{Result,Tests}],
    {sfcResourcePackets[ToList[mySamplesWithPreparedSamples],templatedOptions,resolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation],{}}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentSupercriticalFluidChromatography,collapsedResolvedOptions],
      Preview -> Null
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
        ConstellationMessage->Object[Protocol,SupercriticalFluidChromatography],
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
        ConstellationMessage->Object[Protocol,SupercriticalFluidChromatography],
        Simulation -> updatedSimulation
      ]
    ],
    $Failed
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
    Options -> RemoveHiddenOptions[ExperimentSupercriticalFluidChromatography,collapsedResolvedOptions],
    Preview -> Null
  }
];

(*container overload*)
ExperimentSupercriticalFluidChromatography[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
    updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,containerToSampleSimulation},

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentSupercriticalFluidChromatography,
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
    (* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
    Return[$Failed]
  ];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentSupercriticalFluidChromatography,
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
      {containerToSampleOutput, containerToSampleSimulation}=containerToSampleOptions[
        ExperimentSupercriticalFluidChromatography,
        mySamplesWithPreparedSamples,
        myOptionsWithPreparedSamples,
        Output-> {Result,Simulation},
        Simulation -> updatedSimulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification /. {
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },

    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentSupercriticalFluidChromatography[samples,ReplaceRule[sampleOptions,Simulation -> containerToSampleSimulation]]
  ]
];

DefineOptions[
  resolveExperimentSupercriticalFluidChromatographyOptions,
  Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentSupercriticalFluidChromatographyOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentSupercriticalFluidChromatographyOptions]]:=Module[
  {outputSpecification,output,gatherTests,cache,samplePrepOptions,supercriticalFluidChromatographyOptions,simulatedSamples,resolvedSamplePrepOptions,
    samplePrepTests,supercriticalFluidChromatographyOptionsAssociation,invalidInputs,invalidOptions,resolvedAliquotOptions,
    resolvedPostProcessingOptions,gatherTestsQ,messagesQ,engineQ,samplePackets,sampleStatuses,discardedSamples,discardedSamplesTest,resolvedExperimentOptions,resolvedOptions,
    roundedOptionsAssociation,simulatedSamplePackets,sampleContainers,simulatedSampleContainers,simulatedSampleContainerModels,containerlessSamples,containersExistTest,
    validNameQ,validNameTest,specifiedInstrumentPacket,specifiedInstrumentModelPacket,notRetiredInstrumentQ,retiredInstrumentTest,notDeprecatedInstrumentQ,
    injectionTableSampleConflictQ,foreignSamplesOptions,foreignSamplesTest,aliquotOptions,validAliquotContainerOptions,compatibleMaterialsBool,incompatibleSamplesTest,
    deprecatedInstrumentTest,specifiedColumnModelPackets,specifiedGuardCartridgeModelPacket,specifiedGuardColumnModelPacket,specifiedColumnTypes,typeColumnCompatibleQ,
    typeColumnTest,specifiedColumnTechniques,columnTechniqueCompatibleQ,columnTechniqueTest,columnTests,columnTemperatureOptions,compatibleColumnTemperatureRanges,
    compatibleColumnTemperatureRange,specifiedColumnTemperatures,incompatibleColumnTemperatures,injectionTableLookup,injectionTableSpecifiedQ,gradientOptions,
    roundedGradientOptions,roundedGradientTests,allRoundingTests,volumeOptions,voltageOptions,invalidInstrumentOption,allAliquotOptionValues,
    wavelengthResolutionOptions,massDetectionOptions,absorbanceRateOptions,maxAccelerationRoundedAssociation,maxAccelerationRoundedTests, compatibleMaterialsInvalidOption,
    maxAccelerationOption,possibleAbsorbanceRateValues,roundedInjectionTable,onlyVoltageAssociation, onlyKiloVoltageAssociation,multiplePrimeSameColumnBool, multipleFlushSameColumnBool,
    volumeRoundedAssociation,volumeRoundedTests,roundedInjectionTableAssociation,injectionTableRoundedTests,voltageRoundedAssociation,voltageRoundedTests,kiloVoltageOptions,
    kiloVoltageRoundedAssociation,kiloVoltageRoundedTests,standardOptions,injectionTableTypes,standardOptionSpecifiedBool,
    standardExistsQ, specifiedMethodGradient, injectionTableMethodGradientList, instrumentModel, minBackPressure, maxBackPressure, eachABPRConflictQ, invalidABPRMethodList, injectionTableCO2PressureConflictQ, injectionTableCO2PressureOptions,
    injectionTableCO2PressureTest,resolvedStandardFrequency,resolvedStandard,preexpandedBlankOptions, preexpandedStandardOptions,
    blankOptions,blankOptionSpecifiedBool,blankExistsQ,columnSelectorSampleConflictBool,tableColumnSampleConflictBool,
    resolvedBlankFrequency,resolvedBlank,columnSelectorSampleConflictQ,tableColumnSampleConflictQ,columnFlushExistQ,autosamplerDeckModel, availableAutosamplerRacks,
    allTests,expandedStandardOptions,expandedBlankOptions, columnLookup,resolvedOptionsForInjectionTable,injectionTableColumnFlushGradientsInitial,
    columnSelectorLookup,separationModeLookup,injectionTableColumnLookup,resolvedColumn,resolvedStandardColumn,resolvedBlankColumn,columnSelectorConflictQ,tableColumnConflictQ,
    columnSelectorStandardConflictQ,tableColumnStandardConflictQ,columnSelectorBlankConflictQ,tableColumnBlankConflictQ,multipleGradientsColumnPrimeFlushOptions, multipleGradientsColumnPrimeFlushTest,
    columnSelectorConflictOptions,columnSelectorConflictTest,tableColumnConflictOptions,tableColumnConflictTest,resolvedColumnRefreshFrequency,
    resolvedColumnSelector,selectorInjectionTableConflictQ,selectorInjectionTableConflictOptions,selectorInjectionTableConflictTest,resolvedColumnOrientation,
    resolvedGradients,resolvedCO2Gradients,resolvedGradientAs,resolvedGradientBs,resolvedGradientCs,resolvedGradientDs,resolvedGradientStarts,resolvedGradientEnds,
    resolvedGradientDurations,resolvedEquilibrationTimes,resolvedFlushTimes,injectionTableSampleRoundedGradients,resolvedFlowRates,resolvedBackPressures,
    gradientStartEndSpecifiedBool,
    gradientShortcutConflictBool,gradientShortcutOverallQ,gradientShortcutOptions,gradientShortcutTest,
    gradientStartEndAConflictBool,gradientStartEndAConflictOverallQ,gradientStartEndAConflictTests,
    gradientInjectionTableSpecifiedDifferentlyBool,resolvedAnalyteGradients,invalidGradientCompositionBool,columnPrimeOptions,
    columnFlushOptions,columnSelectorQ,expandedColumnPrimeOptions, expandedColumnFlushOptions,injectionTableStandardGradients,injectionTableBlankGradients,injectionTableObjectified,
    columnSelectorObjectified,injectionTableColumnPrimeGradients,injectionTableColumnFlushGradients,multiplePrimeSameColumnQ, multipleFlushSameColumnQ,
    nonBinaryCompositionOptionsBool, nonBinaryCompositionQ, nonBinaryCompositionOptions, nonBinaryCompositionTest,
    resolvedStandardAnalyticalGradients,standardGradientInjectionTableSpecifiedDifferentlyBool,standardInvalidGradientCompositionBool,
    resolvedBlankAnalyticalGradients,blankGradientInjectionTableSpecifiedDifferentlyBool,blankInvalidGradientCompositionBool,
    resolvedColumnPrimeAnalyticalGradients,columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,columnPrimeInvalidGradientCompositionBool,
    resolvedColumnFlushAnalyticalGradients,columnFlushGradientInjectionTableSpecifiedDifferentlyBool,columnFlushInvalidGradientCompositionBool,
    resolvedStandardCO2Gradients,resolvedStandardGradientAs,resolvedStandardGradientBs,resolvedStandardGradientCs,resolvedStandardGradientDs,
    resolvedStandardBackPressures,resolvedStandardFlowRates,resolvedStandardGradients,resolvedBlankCO2Gradients,resolvedBlankGradientAs,
    resolvedBlankGradientBs,resolvedBlankGradientCs,resolvedBlankGradientDs,resolvedBlankBackPressures,resolvedBlankFlowRates,
    resolvedBlankGradients,resolvedColumnPrimeCO2Gradients,resolvedColumnPrimeGradientAs,resolvedColumnPrimeGradientBs,
    resolvedColumnPrimeGradientCs,resolvedColumnPrimeGradientDs,resolvedColumnPrimeBackPressures,resolvedColumnPrimeFlowRates,
    resolvedColumnPrimeGradients,resolvedColumnFlushCO2Gradients,resolvedColumnFlushGradientAs,resolvedColumnFlushGradientBs,
    resolvedColumnFlushGradientCs,resolvedColumnFlushGradientDs,resolvedColumnFlushBackPressures,resolvedColumnFlushFlowRates,resolvedColumnFlushGradients,
    gradientStartEndSpecifiedAdverselyQ,gradientStartEndSpecifiedAdverselyOptions,gradientStartEndSpecifiedAdverselyTest,
    gradientInjectionTableSpecifiedDifferentlyOptionsBool,gradientInjectionTableSpecifiedDifferentlyQ,gradientInjectionTableSpecifiedDifferentlyOptions,
    gradientInjectionTableSpecifiedDifferentlyTest,invalidGradientCompositionOptionsBool,invalidGradientCompositionQ,invalidGradientCompositionOptions,invalidGradientCompositionTest,
    allResolvedGradientMethods,allGradientMethodPackets,anyGradientAQ,anyGradientBQ,anyGradientCQ,anyGradientDQ,resolvedCosolventA,resolvedCosolventB,resolvedCosolventC,resolvedCosolventD,
    resolvedColumnTemperatures,resolvedStandardColumnTemperatures,resolvedBlankColumnTemperatures,resolvedPrimeColumnTemperatures,resolvedFlushColumnTemperatures,
    resolvedIonModes,resolvedMakeupFlowRates,resolvedMassDetections,resolvedScanTimes,resolvedProbeTemperatures,resolvedESICapillaryVoltages,resolvedSamplingConeVoltages,
    resolvedMassDetectionGains,scanTimeRoundingBool,scanTimeSampleRoundingBool,acceptableScanTimes,invalidContainerCountSamples,
    resolvedStandardIonModes,resolvedStandardMakeupFlowRates,resolvedStandardMassDetections,resolvedStandardScanTimes,resolvedStandardProbeTemperatures,
    resolvedStandardESICapillaryVoltages,resolvedStandardSamplingConeVoltages,resolvedStandardMassDetectionGains,scanTimeStandardRoundingBool,
    resolvedBlankIonModes,resolvedBlankMakeupFlowRates,resolvedBlankMassDetections,resolvedBlankScanTimes,resolvedBlankProbeTemperatures,resolvedBlankESICapillaryVoltages,
    resolvedBlankSamplingConeVoltages,resolvedBlankMassDetectionGains,scanTimeBlankRoundingBool,resolvedColumnPrimeIonModes,resolvedColumnPrimeMakeupFlowRates,
    resolvedColumnPrimeMassDetections,resolvedColumnPrimeScanTimes,resolvedColumnPrimeProbeTemperatures,resolvedColumnPrimeESICapillaryVoltages,resolvedColumnPrimeSamplingConeVoltages,
    resolvedColumnPrimeMassDetectionGains,scanTimeColumnPrimeRoundingBool,resolvedColumnFlushIonModes,resolvedColumnFlushMakeupFlowRates,resolvedColumnFlushMassDetections,
    resolvedColumnFlushScanTimes,resolvedColumnFlushProbeTemperatures,resolvedColumnFlushESICapillaryVoltages,resolvedColumnFlushSamplingConeVoltages,resolvedColumnFlushMassDetectionGains,
    scanTimeColumnFlushRoundingBool,scanTimeRoundingOptions,resolvedAbsorbanceWavelengths, resolvedWavelengthResolutions, resolvedUVFilters, resolvedAbsorbanceSamplingRates,
    wavelengthResolutionSampleConflictBool, roundedSamplingSampleRateBool, roundedWavelengthSampleResolutionBool, possibleWavelengthResolutions,
    resolvedStandardAbsorbanceWavelengths, resolvedStandardWavelengthResolutions, resolvedStandardUVFilters, resolvedStandardAbsorbanceSamplingRates,
    wavelengthResolutionStandardConflictBool, roundedSamplingStandardRateBool, roundedWavelengthStandardResolutionBool, resolvedBlankAbsorbanceWavelengths,
    resolvedBlankWavelengthResolutions, resolvedBlankUVFilters, resolvedBlankAbsorbanceSamplingRates, wavelengthResolutionBlankConflictBool,
    roundedSamplingBlankRateBool, roundedWavelengthBlankResolutionBool, resolvedColumnPrimeAbsorbanceWavelengths, resolvedColumnPrimeWavelengthResolutions,
    resolvedColumnPrimeUVFilters, resolvedColumnPrimeAbsorbanceSamplingRates, wavelengthResolutionColumnPrimeConflictBool, roundedSamplingColumnPrimeRateBool,
    roundedWavelengthColumnPrimeResolutionBool, resolvedColumnFlushAbsorbanceWavelengths, resolvedColumnFlushWavelengthResolutions, resolvedColumnFlushUVFilters,
    resolvedColumnFlushAbsorbanceSamplingRates, wavelengthResolutionColumnFlushConflictBool, roundedSamplingColumnFlushRateBool, roundedWavelengthColumnFlushResolutionBool,
    roundedSamplingRateRoundingBool, roundedSamplingRateRoundingOptions, roundedWavelengthResolutionBool, roundedWavelengthResolutionBoolOptions,injectionTableSampleInjectionVolumes,
    wavelengthResolutionConflictBool, wavelengthResolutionConflictOptions, wavelengthResolutionConflictTests,maxInjectionVolume,autosamplerDeadVolume,resolvedInjectionVolumes,
    injectionTableStandardInjectionVolumes,resolvedStandardInjectionVolumes,injectionTableBlankInjectionVolumes,resolvedBlankInjectionVolumes,
    preresolvedStandard, preresolvedBlank,resolvedInjectionTable,resolvedEmail, standardNonBinaryCompositionBool, blankNonBinaryCompositionBool, columnPrimeNonBinaryCompositionBool,
    columnFlushNonBinaryCompositionBool,namedCompatibleContainers,specifiedAliquotBools,invalidContainerModelBools,
    uniqueAliquotableSamples,uniqueNonAliquotablePlates,uniqueNonAliquotableVessels,defaultStandardBlankContainer,
    standardBlankContainerMaxVolume,standardBlankSampleMaxVolume,gatheredStandardInjectionTuples,gatheredBlankInjectionTuples,standardPartitions,blankPartitions,
    standardInjectionVolumeTuples,blankInjectionVolumeTuples,nonBinaryCompositionBool,cosolventAMethodList, cosolventBMethodList, cosolventCMethodList, cosolventDMethodList,
    cosolventAClashQ, cosolventBClashQ, cosolventCClashQ, cosolventDClashQ,defaultBlank, resolvedStandardBlankOptions,invalidStandardBlankOptions,invalidStandardBlankTests,
    numberOfStandardBlankContainersRequired,validContainerCountQ,containerCountTest,preresolvedAliquotBools,validAliquotContainerBools,validAliquotContainerTest,
    aliquotOptionSpecifiedBools,resolvedAliquotContainers,requiredAliquotVolumes,resolvedInjectionTableResult, invalidInjectionTableOptions, invalidInjectionTableTests,
    preresolvedAliquotOptions,resolveAliquotOptionsResult,resolveAliquotOptionTests,validSampleStorageConditionQ,invalidStorageConditionOptions,invalidStorageConditionTest,
    specifiedSampleStorageCondition, simulation, updatedSimulation
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

  (* Separate out our SupercriticalFluidChromatography options from our Sample Prep options. *)
  {samplePrepOptions,supercriticalFluidChromatographyOptions}=splitPrepOptions[myOptions];

  (* Resolve our sample prep options *)
  {{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentSupercriticalFluidChromatography,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
    {resolveSamplePrepOptionsNew[ExperimentSupercriticalFluidChromatography,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
  ];

  (* Determine if we should keep a running list of tests *)
  gatherTestsQ = MemberQ[output,Tests];

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
  supercriticalFluidChromatographyOptionsAssociation = Association[supercriticalFluidChromatographyOptions];

  (* Extract the packets that we need from our downloaded cache. *)
  (* Remember to download from simulatedSamples, using our simulation blob *)
  (* Quiet[Download[...],Download::FieldDoesntExist] *)

  {
    simulatedSamplePackets,
    simulatedSampleContainerModels
  } = Transpose@Quiet[Download[
    simulatedSamples,
    {
      Packet[Container, Volume, pH, IncompatibleMaterials],
      Container[Model][Object]
    },
    Simulation -> updatedSimulation,
    Cache -> cache
  ],{Download::FieldDoesntExist}];

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

  (*-- INPUT VALIDATION CHECKS --*)

  (* Extract downloaded mySamples packets *)
  samplePackets = fetchPacketFromCache[#,cache]&/@mySamples;

  (* Extract sample statuses *)
  sampleStatuses = Lookup[samplePackets,Status];

  (* Find any samples that are discarded *)
  discardedSamples = PickList[mySamples,sampleStatuses,Discarded];

  (* Test that all samples are in a container *)
  discardedSamplesTest = If[Length[discardedSamples] > 0,
    (
      If[messagesQ,
        Message[Error::DiscardedSamples,ObjectToString/@discardedSamples]
      ];
      testOrNull["Input samples are not discarded:",False]
    ),
    testOrNull["Input samples are not discarded:",True]
  ];

  (*check for incompatible samples*)


  (* Extract containers *)
  sampleContainers = Download[Lookup[samplePackets,Container],Object];

  (* Extract simulated sample containers *)
  simulatedSampleContainers = Download[Lookup[simulatedSamplePackets,Container],Object];

  (* Extract any samples without a container *)
  containerlessSamples = PickList[mySamples,sampleContainers,Null];

  (* Test that all samples are in a container *)
  containersExistTest = If[Length[containerlessSamples] > 0,
    testOrNull["Input samples are all in containers:",False],
    testOrNull["Input samples are all in containers:",True]
  ];

  (* If a sample is not in a container, throw error *)
  If[messagesQ&&Length[containerlessSamples]>0,
    Message[Error::ContainerlessSamples,ObjectToString/@containerlessSamples];
  ];

  (* If the specified Name is not in the database, it is valid *)
  validNameQ = If[MatchQ[Lookup[supercriticalFluidChromatographyOptionsAssociation,Name],_String],
    !DatabaseMemberQ[Object[Protocol,SupercriticalFluidChromatography,Lookup[supercriticalFluidChromatographyOptionsAssociation,Name]]],
    True
  ];

  (* Generate Test for Name check *)
  validNameTest = If[validNameQ,
    testOrNull["If specified, Name is not already an HPLC object name:",True],
    testOrNull["If specified, Name is not already an HPLC object name:",False]
  ];

  (* If Name is invalid, throw error *)
  If[messagesQ&&!validNameQ,
    Message[Error::DuplicateName,Lookup[supercriticalFluidChromatographyOptionsAssociation,Name]];
  ];

  (* Fetch instrument packet if specified *)
  specifiedInstrumentPacket = If[MatchQ[Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument],ObjectP[Object[Instrument,SupercriticalFluidChromatography]]],
    fetchPacketFromCache[Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument],cache],
    Null
  ];

  (* Fetch model instrument packet if specified *)
  specifiedInstrumentModelPacket = Switch[Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument],
    ObjectP[Object[Instrument,SupercriticalFluidChromatography]],
      fetchModelPacketFromCacheHPLC[Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument],cache],
    ObjectP[Model[Instrument,SupercriticalFluidChromatography]],
      fetchPacketFromCache[Download[Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument],Object],cache],
    _, Null
  ];

  (* Bool tracking if specified instrument is retired *)
  notRetiredInstrumentQ = Or[
    NullQ[specifiedInstrumentPacket],
    !MatchQ[Lookup[specifiedInstrumentPacket,Status],Retired]
  ];

  retiredInstrumentTest=If[notRetiredInstrumentQ,
    testOrNull["If specified, Instrument is not retired:",True],
    If[messagesQ,
      Message[Error::RetiredChromatographyInstrument,ObjectToString@Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument],ObjectToString@Lookup[specifiedInstrumentModelPacket,Object]]
    ];
    testOrNull["If specified, Instrument is not retired:",False]
  ];

  (* Bool tracking if specified instrument model is deprecated *)
  notDeprecatedInstrumentQ = Or[
    NullQ[specifiedInstrumentModelPacket],
    !TrueQ[Lookup[specifiedInstrumentModelPacket,Deprecated]]
  ];

  deprecatedInstrumentTest=If[notDeprecatedInstrumentQ,
    testOrNull["Instrument model is not deprecated:",True],
    If[messagesQ,
      Message[Error::DeprecatedInstrumentModel,ObjectToString@Lookup[supercriticalFluidChromatographyOptionsAssociation,Instrument]]
    ];
    testOrNull["Instrument model is not deprecated:",False]
  ];

  invalidInstrumentOption=If[Or[!notRetiredInstrumentQ,!notDeprecatedInstrumentQ],{Instrument},{}];

  (*get boolean for which sample/instrument combinations are incompatible (based on material). *)
  {compatibleMaterialsBool, incompatibleSamplesTest}=If[gatherTestsQ,
    CompatibleMaterialsQ[specifiedInstrumentModelPacket,Flatten[simulatedSamplePackets],Cache -> cache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
    {CompatibleMaterialsQ[specifiedInstrumentModelPacket,Flatten[simulatedSamplePackets],Cache -> cache, Simulation -> updatedSimulation, Output -> Result], {}}
  ];

  (* if the materials are incompatible, then the Instrument is invalid *)
  compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && messagesQ,
    {Instrument},
    {}
  ];

  (* Extract column model packets if option is specified *)
  specifiedColumnModelPackets = Map[
    Switch[#,
      ObjectP[Model],
      fetchPacketFromCache[#,cache],
      ObjectP[],
      fetchModelPacketFromCacheHPLC[#,cache],
      _,
      Null
    ]&,ToList[Lookup[supercriticalFluidChromatographyOptionsAssociation,Column]]
  ];

  (* Extract cartridge model packet if guard column option is specified as a cartridge *)
  specifiedGuardCartridgeModelPacket = Switch[Lookup[supercriticalFluidChromatographyOptionsAssociation,GuardColumn],
    ObjectP[Model[Item,Cartridge,Column]],
    fetchPacketFromCache[Download[Lookup[supercriticalFluidChromatographyOptionsAssociation,GuardColumn],Object],cache],
    ObjectP[Object[Item,Cartridge,Column]],
    fetchModelPacketFromCacheHPLC[Download[Lookup[supercriticalFluidChromatographyOptionsAssociation,GuardColumn],Object],cache],
    _,
    Null
  ];

  (* Extract guard column model packet if guard column option is specified. If the option was specified as a cartridge, use the first GuardColumn that the cartridge points to. *)
  specifiedGuardColumnModelPacket = Switch[Lookup[supercriticalFluidChromatographyOptionsAssociation,GuardColumn],
    ObjectP[Model[Item,Column]],
    fetchPacketFromCache[Download[Lookup[supercriticalFluidChromatographyOptionsAssociation,GuardColumn],Object],cache],
    ObjectP[Object[Item,Column]],
    fetchModelPacketFromCacheHPLC[Download[Lookup[supercriticalFluidChromatographyOptionsAssociation,GuardColumn],Object],cache],
    ObjectP[{Model[Item,Cartridge,Column],Object[Item,Cartridge,Column]}],
    fetchPacketFromCache[Download[FirstOrDefault[Lookup[specifiedGuardCartridgeModelPacket, GuardColumns]], Object], cache],
    _,
    Null
  ];

  (* - Column's ChromatographyType Check - *)

  (* If a column object is specified, fetch its ChromatographyType *)
  specifiedColumnTypes = If[!NullQ[#],
    Lookup[#,ChromatographyType],
    Null
  ]&/@specifiedColumnModelPackets;

  (* If Type and a column are specified, the column type should match the type of column *)
  typeColumnCompatibleQ = If[
    And[
      MatchQ[Lookup[supercriticalFluidChromatographyOptionsAssociation,SeparationMode],ChromatographyTypeP],
      MatchQ[specifiedColumnTypes,{ChromatographyTypeP..}]
    ],
    MatchQ[specifiedColumnTypes,{Lookup[supercriticalFluidChromatographyOptionsAssociation,SeparationMode]..}],
    True
  ];

  (* Build test for Column-Type compatibility  *)
  typeColumnTest = If[typeColumnCompatibleQ,
    warningOrNull["If Type and Column are specified, the separation mode of the column is the same as the specified Type:",True],
    warningOrNull["If Type and Column are specified, the separation mode of the column is the same as the specified Type:",False]
  ];

  (* Throw warning if Type and Column are incompatible *)
  If[messagesQ&&!typeColumnCompatibleQ&&!engineQ,
    Message[Warning::IncompatibleColumnType,Column,ObjectToString@Lookup[supercriticalFluidChromatographyOptionsAssociation,Column],specifiedColumnTypes,Lookup[supercriticalFluidChromatographyOptionsAssociation,SeparationMode]];
  ];

  (* If a column object is specified, fetch its ChromatographyTechnique *)
  specifiedColumnTechniques = If[!NullQ[#],
    Lookup[#,ChromatographyType,Null],
    Null
  ]&/@specifiedColumnModelPackets;

  (* Column technique should be HPLC or Null *)
  columnTechniqueCompatibleQ = MatchQ[specifiedColumnTechniques,{(SupercriticalFluidChromatography|Null)..}];

  (* Build test for technique compatibility  *)
  columnTechniqueTest = If[columnTechniqueCompatibleQ,
    warningOrNull["If Column is specified, its ChromatographyTechnique is HPLC:",True],
    warningOrNull["If Column is specified, its ChromatographyTechnique is HPLC:",False]
  ];

  (* Throw warning if technique is not HPLC *)
  If[messagesQ&&!columnTechniqueCompatibleQ&&!engineQ,
    Message[Warning::IncompatibleColumnTechnique,Column,ObjectToString@Lookup[supercriticalFluidChromatographyOptionsAssociation,Column],specifiedColumnTechniques, SupercriticalFluidChromatography];
  ];

  (* Options which reference temperatures *)
  columnTemperatureOptions = {
    ColumnTemperature,
    StandardColumnTemperature,
    BlankColumnTemperature,
    ColumnPrimeTemperature,
    ColumnFlushTemperature
  };

  (* If column(s) are specified, fetch the compatible temperature range for each column*)
  compatibleColumnTemperatureRanges = If[!NullQ[#],
    Replace[
      Lookup[#,{MinTemperature,MaxTemperature}],
      {
        {Null,max:TemperatureP}:>{-Infinity Celsius,max},
        {min:TemperatureP,Null}:>{min, Infinity Celsius},
        {Null,Null}:>{-Infinity Celsius, Infinity Celsius}
      },
      {1}
    ],
    Null
  ]&/@specifiedColumnModelPackets;

  (* Get the most restrictive min and max range for the columns. (We can only set one column temperature, so we don't need to consider each range separately.) *)
  compatibleColumnTemperatureRange = If[NullQ[compatibleColumnTemperatureRanges],
    Null,
    {
      Max[DeleteCases[compatibleColumnTemperatureRanges[[All,1]], Null]] /. (Infinity -> Null),
      Min[DeleteCases[compatibleColumnTemperatureRanges[[All,2]], Null]] /. (Infinity -> Null)
    }
  ];

  (* Fetch any specified temperatures from options *)
  specifiedColumnTemperatures = Map[
    Cases[ToList@Lookup[supercriticalFluidChromatographyOptionsAssociation,#],TemperatureP]&,
    columnTemperatureOptions
  ];

  (* Extract any specified temperatures for each option that is not within the Column's compatible range *)
  incompatibleColumnTemperatures = Map[
    Which[
      MatchQ[compatibleColumnTemperatureRange,{TemperatureP,TemperatureP}],
      Cases[#,Except[RangeP@@compatibleColumnTemperatureRange]],
      MatchQ[compatibleColumnTemperatureRange,{Null,TemperatureP}],
      Cases[#,GreaterP@@(compatibleColumnTemperatureRange[[2]])],
      MatchQ[compatibleColumnTemperatureRange,{TemperatureP,Null}],
      Cases[#,LessP@@(compatibleColumnTemperatureRange[[1]])],
      True,
      {}
    ]&,
    specifiedColumnTemperatures
  ];

  (* Throw warning if column temperatures are incompatible *)
  columnTests = MapThread[
    If[Length[#2] > 0,
      If[messagesQ&&!engineQ,
        Message[Warning::IncompatibleColumnTemperature,#1,#2,Column,ObjectToString@Lookup[roundedOptionsAssociation,Column],compatibleColumnTemperatureRange[[1]],compatibleColumnTemperatureRange[[2]]]
      ];
      warningOrNull[StringTemplate["If Column and `1` is specified, all specified column temperatures are within the column's MinTemperature/MaxTemperature range:"][#1],False],
      warningOrNull[StringTemplate["If Column and `1` is specified, all specified column temperatures are within the column's MinTemperature/MaxTemperature range:"][#1],True]
    ]&,
    {columnTemperatureOptions,incompatibleColumnTemperatures}
  ];

  (*-- OPTION PRECISION CHECKS --*)

  (*we have to break apart our options so that it's easier to tackle this part*)

  (*get the injection table option and see if need consider the suboptions within it*)
  injectionTableLookup=Lookup[supercriticalFluidChromatographyOptionsAssociation,InjectionTable,Null];

  (*is the injection specified (meaning that it has tuples within it)?*)
  injectionTableSpecifiedQ=MatchQ[injectionTableLookup,Except[Automatic|Null]];

  (*we need to make sure that if the injection table is specified that the samples and the input are compatible*)
  injectionTableSampleConflictQ=If[injectionTableSpecifiedQ,
    !MatchQ[Download[Cases[injectionTableLookup,{Sample,___}]/.{Sample,x_,___}:>x,Object,Cache->cache],Download[mySamples,Object,Cache->cache]],
    (**)
    False
  ];

  (*do all of our error accounting and test building*)
  {foreignSamplesOptions,foreignSamplesTest} = If[injectionTableSampleConflictQ,
    (
      If[messagesQ,
        Message[Error::InjectionTableForeignSamples]
      ];
      {{InjectionTable},testOrNull["If specified, the input samples match the order and repetition within InjectionTable:",False]}
    ),
    {{},testOrNull["If specified, the input samples match the order and repetition within InjectionTable:",True]}
  ];


  (* All options that specify gradients *)
  gradientOptions = {
    Gradient,
    CO2Gradient,
    GradientA,
    GradientB,
    GradientC,
    GradientD,
    GradientStart,
    GradientEnd,
    GradientDuration,
    FlowRate,
    StandardGradient,
    StandardCO2Gradient,
    StandardGradientA,
    StandardGradientB,
    StandardGradientC,
    StandardGradientD,

    StandardFlowRate,
    BlankGradient,
    BlankCO2Gradient,
    BlankGradientA,
    BlankGradientB,
    BlankGradientC,
    BlankGradientD,

    BlankFlowRate,
    ColumnPrimeGradient,
    ColumnPrimeCO2Gradient,
    ColumnPrimeGradientA,
    ColumnPrimeGradientB,
    ColumnPrimeGradientC,
    ColumnPrimeGradientD,

    ColumnPrimeFlowRate,
    ColumnFlushGradient,
    ColumnFlushCO2Gradient,
    ColumnFlushGradientA,
    ColumnFlushGradientB,
    ColumnFlushGradientC,
    ColumnFlushGradientD,

    ColumnFlushFlowRate,
    MakeupFlowRate,
    StandardMakeupFlowRate,
    BlankMakeupFlowRate,
    ColumnPrimeMakeupFlowRate,
    ColumnFlushMakeupFlowRate,
    BackPressure,
    StandardBackPressure,
    BlankBackPressure,
    ColumnPrimeBackPressure,
    ColumnFlushBackPressure,

    EquilibrationTime,
    FlushTime
  };

  (*use the helper function to round all of the gradient options collectively*)
  {roundedGradientOptions,roundedGradientTests}=Experiment`Private`roundGradientOptions[gradientOptions,supercriticalFluidChromatographyOptionsAssociation,gatherTestsQ];
  
  (* Check whether valid Object[Method, SupercriticalFluidGradient] is specified. *)
  If[injectionTableSpecifiedQ,
    (* Exclude 'Automatic' from the specified method list *)
    specifiedMethodGradient = Cases[injectionTableLookup[[All,5]], Except[ListableP[(Null|None|Automatic)]]];
    
    injectionTableMethodGradientList = Map[Lookup[fetchPacketFromCache[Download[#, Object], cache], Gradient]&, specifiedMethodGradient];
    
    (* Get min/max back pressure. This is related to ABPR error *)
    {instrumentModel, minBackPressure, maxBackPressure} = Lookup[specifiedInstrumentModelPacket, {Object, MinBackPressure, MaxBackPressure}];
    
    (* Check each gradient method's ABPR pressure (CO2) pressure is valid. *)
    eachABPRConflictQ = Map[MatchQ[#, {False..}] &, Map[RangeQ[#[[All, 7]], {1600 PSI, maxBackPressure}] &, injectionTableMethodGradientList]];
    
    (* Get invalid methods *)
    invalidABPRMethodList = PickList[specifiedMethodGradient, eachABPRConflictQ, True];
    
    (* Check whether CO2 pressure is between MinBackPressure and MaxBackPressure of the instrument model. Outside of the range will cause an instrument error *)
    injectionTableCO2PressureConflictQ = AnyTrue[eachABPRConflictQ, TrueQ],
    injectionTableCO2PressureConflictQ = False
  ];

  injectionTableCO2PressureOptions = If[injectionTableCO2PressureConflictQ,
    If[messagesQ, Message[Error::GradientCO2PressureConflict, invalidABPRMethodList, instrumentModel, minBackPressure, maxBackPressure]];
    {InjectionTable},
    {}
  ];

  injectionTableCO2PressureTest = If[injectionTableCO2PressureConflictQ,
    testOrNull["The specified CO2 Pressure for Object[Method] is not within the range:", False],
    testOrNull["The specified CO2 Pressure for Object[Method] is within the range:", True]
  ];

  (* Options which reference volumes *)
  volumeOptions = {
    InjectionVolume,
    StandardInjectionVolume,
    BlankInjectionVolume
  };

  (* Fetch association with volumes rounded *)
  {volumeRoundedAssociation,volumeRoundedTests} = If[gatherTestsQ,
    RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,volumeOptions,Table[10^-1 Microliter,Length[volumeOptions]],Output->{Result,Tests}],
    {RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,volumeOptions,Table[10^-1 Microliter,Length[volumeOptions]]],{}}
  ];

  roundedInjectionTable=injectionTableLookup;


  roundedInjectionTableAssociation=Association[InjectionTable->roundedInjectionTable];

  (*options with voltages*)
  voltageOptions={
    SamplingConeVoltage,StandardSamplingConeVoltage,BlankSamplingConeVoltage,ColumnPrimeSamplingConeVoltage,ColumnFlushSamplingConeVoltage
  };

  (* Fetch association with volumes rounded *)
  {voltageRoundedAssociation,voltageRoundedTests} = If[gatherTestsQ,
    RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,voltageOptions,Table[10^-1 Volt,Length[voltageOptions]],Output->{Result,Tests}],
    {RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,voltageOptions,Table[10^-1 Volt,Length[voltageOptions]]],{}}
  ];

  onlyVoltageAssociation=Association[Map[#->(#/.voltageRoundedAssociation)&,voltageOptions]];

  (*options with kilovolts*)
  kiloVoltageOptions={ESICapillaryVoltage,StandardESICapillaryVoltage,BlankESICapillaryVoltage,ColumnPrimeESICapillaryVoltage,ColumnFlushESICapillaryVoltage};

  (* Fetch association with volumes rounded *)
  {kiloVoltageRoundedAssociation,kiloVoltageRoundedTests} = If[gatherTestsQ,
    RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,kiloVoltageOptions,Table[10^-1 Kilovolt,Length[kiloVoltageOptions]],Output->{Result,Tests}],
    {RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,kiloVoltageOptions,Table[10^-1 Kilovolt,Length[kiloVoltageOptions]]],{}}
  ];

  onlyKiloVoltageAssociation=Association[Map[#->(#/.kiloVoltageRoundedAssociation)&,kiloVoltageOptions]];

  (*have to round the wavelength resolution options. These also can only be a specific value*)
  wavelengthResolutionOptions={
    WavelengthResolution,StandardWavelengthResolution,BlankWavelengthResolution,ColumnPrimeWavelengthResolution,ColumnFlushWavelengthResolution
  };


  (*mass detection options*)
  massDetectionOptions={MassDetection,StandardMassDetection,BlankMassDetection,ColumnPrimeMassDetection,ColumnFlushMassDetection};

  maxAccelerationOption=MaxAcceleration;

  (* Fetch association with volumes rounded *)
  {maxAccelerationRoundedAssociation,maxAccelerationRoundedTests} = If[gatherTestsQ,
    RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,maxAccelerationOption,10^-2 Milliliter/(Minute^2),Output->{Result,Tests}],
    {RoundOptionPrecision[supercriticalFluidChromatographyOptionsAssociation,maxAccelerationOption,10^-2 Milliliter/(Minute^2)],{}}
  ];

  (* Join all rounded associations together, with rounded values overwriting existing values *)
  roundedOptionsAssociation = Join[
    supercriticalFluidChromatographyOptionsAssociation,
    roundedGradientOptions,
    roundedInjectionTableAssociation,
    onlyVoltageAssociation,
    onlyKiloVoltageAssociation,
    <|MaxAcceleration->(MaxAcceleration/.maxAccelerationRoundedAssociation)|>
  ];

  (* Join all tests together *)
  allRoundingTests = Join[
    roundedGradientTests,
    injectionTableRoundedTests,
    voltageRoundedTests,
    kiloVoltageRoundedTests,
    maxAccelerationRoundedTests
  ];

  (*-- CONFLICTING OPTIONS CHECKS --*)

  (*-- RESOLVE EXPERIMENT OPTIONS --*)

  (*first resolve the standard frequency and standard option*)

  (*articulate all the standard options*)
  standardOptions={Standard,StandardInjectionVolume,StandardFrequency,StandardColumn,
    StandardColumnTemperature,StandardCO2Gradient,StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD,
    StandardFlowRate,StandardGradient,StandardGradientDuration,StandardBackPressure,StandardIonMode,StandardMakeupFlowRate,StandardMassDetection,
    StandardScanTime,StandardProbeTemperature,StandardESICapillaryVoltage,StandardSamplingConeVoltage,StandardMassDetectionGain,
    StandardAbsorbanceWavelength,StandardWavelengthResolution,StandardUVFilter,StandardAbsorbanceSamplingRate,StandardStorageCondition};

  (*if the injection table is specified, get the types of all of the samples*)
  injectionTableTypes=If[injectionTableSpecifiedQ,
    injectionTableLookup[[All,1]],
    {}
  ];

  (*first we ask if any of the standard options are defined*)
  standardOptionSpecifiedBool=Map[MatchQ[Lookup[roundedOptionsAssociation,#],Except[ListableP[(Null|None|Automatic)]]]&,standardOptions];

  (*now we ask whether any standards are to exist or already do*)
  standardExistsQ=Or[Or@@standardOptionSpecifiedBool,MemberQ[injectionTableTypes,Standard]];
  
  
  (*now do the same with the blank options*)
  blankOptions={Blank,BlankInjectionVolume,BlankFrequency,BlankColumn,BlankColumnTemperature,BlankCO2Gradient,BlankGradientA,
    BlankGradientB,BlankGradientC,BlankGradientD,BlankFlowRate,BlankGradient,BlankGradientDuration,BlankBackPressure,BlankIonMode,BlankMakeupFlowRate,
    BlankMassDetection,BlankScanTime,BlankProbeTemperature,BlankESICapillaryVoltage,BlankSamplingConeVoltage,BlankMassDetectionGain,
    BlankAbsorbanceWavelength,BlankWavelengthResolution,BlankUVFilter,BlankAbsorbanceSamplingRate,BlankStorageCondition};

  (*first we ask if any of the standard options are defined*)
  blankOptionSpecifiedBool=Map[MatchQ[Lookup[roundedOptionsAssociation,#],Except[ListableP[(Null|None|Automatic)]]]&,blankOptions];

  (*now we ask whether any standards are to exist or already do*)
  blankExistsQ=Or[Or@@blankOptionSpecifiedBool,MemberQ[injectionTableTypes,Blank]];

  (*define our default blank model*)
  defaultBlank=If[MatchQ[Lookup[roundedOptionsAssociation,CosolventA],ObjectP[Model[Sample]]],
    (*default to cosolvent A if around*)
    Lookup[roundedOptionsAssociation,CosolventA],
    (*otherwise, default to methanol*)
    Model[Sample, "id:01G6nvkKrrPd"]
  ];

  (*call our shared helper in order to resolve common options related to the Standard and Blank*)
  {{resolvedStandardBlankOptions,invalidStandardBlankOptions},invalidStandardBlankTests}= If[gatherTestsQ,
    resolveChromatographyStandardsAndBlanks[mySamples,roundedOptionsAssociation, standardExistsQ, Model[Sample, StockSolution, "SFC MS Standard Mix 1"], blankExistsQ, defaultBlank, Output -> {Result,Tests}],
    {resolveChromatographyStandardsAndBlanks[mySamples,roundedOptionsAssociation, standardExistsQ, Model[Sample, StockSolution, "SFC MS Standard Mix 1"], blankExistsQ, defaultBlank],{}}
  ];

  {resolvedStandardFrequency,preresolvedStandard,resolvedBlankFrequency,preresolvedBlank}=Lookup[resolvedStandardBlankOptions,{StandardFrequency,Standard,BlankFrequency,Blank}];

  (*now resolve the columns and the type*)

  (*look up the column*)

  {columnLookup,columnSelectorLookup,separationModeLookup}=Lookup[roundedOptionsAssociation,{Column,ColumnSelector,SeparationMode}];

  (*if the injection table is specified, then grab the column with column information*)
  injectionTableColumnLookup=If[injectionTableSpecifiedQ&&!injectionTableSampleConflictQ,
    Cases[injectionTableLookup,{Sample,___}][[All,4]],
    (*in the case where no injection table or if it's misaligned to the samples, we just pad automatics*)
    ConstantArray[Automatic,Length[columnLookup]]
  ];

  {resolvedColumn,columnSelectorSampleConflictBool,tableColumnSampleConflictBool}=Transpose@MapThread[
    Function[{specifiedColumn,injectionTableColumn},
      Which[
        (*if specified column is not automatic, use that, otherwise, use the injection table one*)
        MatchQ[specifiedColumn,Except[Automatic]],{
          specifiedColumn,
          (*do all of our error checking*)
          If[MatchQ[columnSelectorLookup,Except[Automatic]],
            !MemberQ[Download[columnSelectorLookup,Object],Download[specifiedColumn,Object]],
            False],
          If[MatchQ[injectionTableColumn, ObjectP[]],
            !MatchQ[Download[specifiedColumn, Object], ObjectP[Download[injectionTableColumn, Object]]],
            False
          ]
       },
        (*otherwise, go with the injection column one*)
        MatchQ[injectionTableColumn,Except[Automatic]],{injectionTableColumn,False,False},
        (*otherwise take the first in the column selector*)
        MatchQ[columnSelectorLookup,Except[Automatic]],{First@ToList[columnSelectorLookup],False,False},
        (*otherwise do it based on the separation mode*)
        MatchQ[separationModeLookup,NormalPhase],{Model[Item, Column, "Viridis BEH Column, 5 um 4.6 x 50 mm"], False, False}, (*the viridis column*)
        (*perhaps chiral*)
        MatchQ[separationModeLookup,Chiral],{Model[Item, Column, "Lux 5 Angstrom Amylose"], False, False},
        (*otherwise true*)
        True,{Model[Item, Column, "Viridis BEH Column, 5 um 4.6 x 50 mm"],False,False}
      ]
    ],
    {
      columnLookup,
      (*if we have an injection table, then should map with it*)
      injectionTableColumnLookup
    }
  ];

  columnSelectorSampleConflictQ=Or@@columnSelectorSampleConflictBool;
  tableColumnSampleConflictQ=Or@@tableColumnSampleConflictBool;

  (*we need to expand out Blank and Standard Options respectively because we've resolved them*)

  preexpandedStandardOptions = If[!standardExistsQ,
    Association[#->{}&/@standardOptions],
    (*we need to wrap all the values in in list if not already*)
    Last[ExpandIndexMatchedInputs[
      ExperimentSupercriticalFluidChromatography,
      {mySamples},
      Normal@Append[
        KeyTake[roundedOptionsAssociation,standardOptions],
        Standard -> preresolvedStandard
      ],
      Messages -> False
    ]]
  ];

  preexpandedBlankOptions = If[!blankExistsQ,
    Association[#->{}&/@blankOptions],
    (*we need to wrap in list if not already*)
    Last[ExpandIndexMatchedInputs[
      ExperimentSupercriticalFluidChromatography,
      {mySamples},
      Normal@Append[
        KeyTake[roundedOptionsAssociation,blankOptions],
        Blank -> preresolvedBlank
      ],
      Messages -> False
    ]]
  ];

  (*if we have the singleton blank/standard, we need to wrap with a list for the rest of the experiment functon*)
  {resolvedBlank,expandedBlankOptions}=If[And[
    Depth[Lookup[preexpandedBlankOptions,Blank]]<=2,
    MatchQ[Lookup[preexpandedBlankOptions,Blank],Except[{}]]
  ],
    {
      ToList[Lookup[preexpandedBlankOptions,Blank]],
      Map[(First[#] -> List[Last[#]]) &,preexpandedBlankOptions]
    },
    (*if not the singleton case, then nothing to change*)
    {
      Lookup[preexpandedBlankOptions,Blank],
      preexpandedBlankOptions
    }
  ];

  {resolvedStandard,expandedStandardOptions}=If[And[
    Depth[Lookup[preexpandedStandardOptions,Standard]]<=2,
    MatchQ[Lookup[preexpandedStandardOptions,Standard],Except[{}]]
  ],
    {
      ToList[Lookup[preexpandedStandardOptions,Standard]],
      Map[(First[#] -> List[Last[#]]) &,preexpandedStandardOptions]
    },
    (*if not the singleton case, then nothing to change*)
    {
      Lookup[preexpandedStandardOptions,Standard],
      preexpandedStandardOptions
    }
  ];

  (*now we'll resolve the blank and standard column options*)
  {
    {resolvedStandardColumn,tableColumnStandardConflictQ,columnSelectorStandardConflictQ},
    {resolvedBlankColumn,tableColumnBlankConflictQ,columnSelectorBlankConflictQ}
  }=Map[
    Function[{columnTuple},Module[{innerResult,injectionTableColumns},
      (
       injectionTableColumns=If[injectionTableSpecifiedQ,
         (*if we have an injection table, look up any of the specified type*)
         Cases[injectionTableLookup,{Last@columnTuple,___}][[All,4]],
         (*otherwise, just pad some Automatics*)
         ConstantArray[Automatic,Length[First@columnTuple]]
       ];

        (*we'll need to thread through each standard column and injection table specification to do this correctly*)
       innerResult=MapThread[
         Function[{eachColumn,eachInjectionTableColumn},
           Which[
             (*if it's specified, then we go with it, but need to check if okay*)
             MatchQ[eachColumn,Except[Automatic]],
             {
               (*we got with it*)
               eachColumn,
               (*check whether both the injection table and option are specified and matching*)
               If[MatchQ[eachInjectionTableColumn,ObjectP[]],
                 !MatchQ[Download[fetchPacketFromCache[eachColumn,cache],Object],ObjectP[Download[fetchPacketFromCache[eachInjectionTableColumn,cache],Object]]],
                 False
               ],
               (*also need to check whether the column selection is specified and whether this is in there*)
               If[MatchQ[columnSelectorLookup,Except[Automatic]],MemberQ[ToList[columnSelectorLookup],eachColumn],False]
             },
            (*otherwise check the injection table*)
             MatchQ[eachInjectionTableColumn,Except[Automatic]],
             {
               eachInjectionTableColumn,
               False,
               If[MatchQ[columnSelectorLookup,Except[Automatic]],MemberQ[ToList[columnSelectorLookup],eachInjectionTableColumn],False]
             },
             (*otherwise take the first resolved column*)
             True,{First@ToList[resolvedColumn],False,False}
           ]
          ]
        ,{First@columnTuple,injectionTableColumns}
       ];

       (*if there is something in our inner result, we tranpose and modify further*)
       If[MatchQ[innerResult,{}],
         {Null,False,False},
         {
           Transpose[innerResult][[1]],
           Or@@Transpose[innerResult][[2]],
           Or@@Transpose[innerResult][[3]]
         }
       ]
      )
    ]],
    {
      {ToList@Lookup[expandedStandardOptions,StandardColumn],Standard},
      {ToList@Lookup[expandedBlankOptions,BlankColumn],Blank}
    }
  ];

  (*throw our errors and tabulate our tests from this resolution*)

  (*figure out if we have a column selector conflict*)
  columnSelectorConflictQ=Or[columnSelectorSampleConflictQ,columnSelectorStandardConflictQ,columnSelectorBlankConflictQ];

  columnSelectorConflictOptions=If[columnSelectorConflictQ,
    If[messagesQ,Message[Error::ColumnSelectorConflict]];
    Append[PickList[{Column,StandardColumn,BlankColumn},{columnSelectorSampleConflictQ,columnSelectorStandardConflictQ,columnSelectorBlankConflictQ}],ColumnSelector],
    {}
  ];

  columnSelectorConflictTest = If[columnSelectorConflictQ,
    testOrNull["If ColumnSelector and any of Column, BlankColumn, and StandardColumn are specified, the ColumnSelector includes the columns within the other options:",True],
    testOrNull["If ColumnSelector and any of Column, BlankColumn, and StandardColumn are specified, the ColumnSelector includes the columns within the other options:",False]
  ];

  (*see if we have any conflicts with the injection table columns*)

  tableColumnConflictQ=Or[tableColumnSampleConflictQ,tableColumnStandardConflictQ,tableColumnBlankConflictQ];

  tableColumnConflictOptions=If[tableColumnConflictQ,
    If[messagesQ,Message[Error::InjectionTableColumnConflictSFC]];
    Append[PickList[{Column,StandardColumn,BlankColumn},{tableColumnSampleConflictQ,tableColumnStandardConflictQ,tableColumnBlankConflictQ}],InjectionTable],
    {}
  ];

  tableColumnConflictTest = If[tableColumnConflictQ,
    testOrNull["If ColumnSelector and any of Column, BlankColumn, and StandardColumn are specified, they are compatible:",True],
    testOrNull["If ColumnSelector and any of Column, BlankColumn, and StandardColumn are specified, they are compatible:",False]
  ];

  (*now resolve the column selector and check that it's good with the injection Table*)
  {resolvedColumnSelector,selectorInjectionTableConflictQ}=Which[
    (*if specifed, go with it*)
    MatchQ[columnSelectorLookup,Except[Automatic]],{columnSelectorLookup,
      If[injectionTableSpecifiedQ,
        (*check whether there is anything extraneous in the Injection table that's not represented in the selector*)
        Length[Complement[Cases[injectionTableLookup[[All,4]],Except[Automatic|Null]],columnSelectorLookup]]>0,
        False
      ]
    },
    (*otherwise take the delete duplicates of all of the columns*)
    True,
    {
      (*if it's an empty list, convert to Null*)
      (DeleteDuplicates@Cases[Flatten[{resolvedColumn, resolvedStandardColumn, resolvedBlankColumn}],Except[Null]])/.{{}->Null},
      False
    }
  ];

  (*error checking*)
  selectorInjectionTableConflictOptions=If[selectorInjectionTableConflictQ,
    If[messagesQ,Message[Error::SelectorInjectionTableConflict]];
    {InjectionTable,ColumnSelector},
    {}
  ];

  selectorInjectionTableConflictTest = If[selectorInjectionTableConflictQ,
    testOrNull["If ColumnSelector and columns within InjectionTable are specified, they are compatible:",True],
    testOrNull["If ColumnSelector and columns within InjectionTable are specified, they are compatible:",False]
  ];

  (*resolved column refresh frequency*)
  resolvedColumnRefreshFrequency=Which[
    (*always accede to the user*)
    MatchQ[Lookup[roundedOptionsAssociation,ColumnRefreshFrequency],Except[Automatic]],Lookup[roundedOptionsAssociation,ColumnRefreshFrequency],
    (*check whether we have an InjectionTable. If so, Null.*)
    MatchQ[Lookup[roundedOptionsAssociation,InjectionTable],Except[Automatic]],Null,
    (*check if there is no column*)
    MatchQ[resolvedColumnSelector,ListableP[Null]],None,
    (*otherwise, we'll do first and last*)
    True,FirstAndLast
  ];

  (*now we resolve the gradients, oh boy. We do something like the Master map thread here*)

  (*first get the injection table gradients*)
  injectionTableSampleRoundedGradients=If[MatchQ[Lookup[roundedOptionsAssociation,InjectionTable],Except[Automatic]]&&!injectionTableSampleConflictQ,
    Cases[Lookup[roundedOptionsAssociation,InjectionTable],{Sample,___}][[All,5]],
    (*otherwise just pad away with Automatics*)
    ConstantArray[Automatic,Length[mySamples]]
  ];

  (* Helper to collapse gradient into single percentage value if the option is Automatic
	and all values are the same at each timepoint *)
  collapseGradient[gradientTimepoints:{{TimeP,PercentP|FlowRateP|PressureP}...}]:=If[
    SameQ@@(gradientTimepoints[[All,2]]),
    gradientTimepoints[[1,2]],
    gradientTimepoints
  ];

  {
    resolvedAnalyteGradients,
    resolvedGradientStarts,
    resolvedGradientEnds,
    resolvedGradientDurations,
    resolvedEquilibrationTimes,
    resolvedFlushTimes,
    resolvedCO2Gradients,
    resolvedGradientAs,
    resolvedGradientBs,
    resolvedGradientCs,
    resolvedGradientDs,
    resolvedBackPressures,
    resolvedFlowRates,
    resolvedGradients,
    gradientStartEndSpecifiedBool,
    gradientInjectionTableSpecifiedDifferentlyBool,
    invalidGradientCompositionBool,
    nonBinaryCompositionBool,
    gradientShortcutConflictBool,
    gradientStartEndAConflictBool
  }=Transpose@MapThread[Function[
      {gradient,co2gradient,gradientA,gradientB,gradientC,gradientD,gradientStart,gradientEnd,gradientDuration,equilibrationTime,flushTime,flowRate,backPressure,injectionTableGradient},Module[
        {gradientStartEndSpecifiedQ,gradientInjectionTableSpecifiedDifferentlyQ,resolvedGradientStart,resolvedGradientEnd,
          resolvedEquilibrationTime,resolvedFlushTime,analyteGradientOptionTuple, defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,analyteGradient,
          invalidGradientCompositionQ,resolvedCO2Gradient,resolvedGradientA,resolvedGradientB,resolvedGradientC,resolvedGradientD,resolvedBackPressure,resolvedFlowRate,
          resolvedGradient,nonBinaryQ,gradientShortcutConflictQ,gradientStartEndAConflictQ},

      (*make sure that the start and end options are either all specified or not *)
      gradientStartEndSpecifiedQ = MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP} | {Automatic | Null, Automatic | Null}];

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
      gradientStartEndAConflictQ=Which[
        (* Ignore this error if we already give shortcut conflict error *)
        gradientShortcutConflictQ,False,
        MatchQ[gradientA,Automatic|Null],False,
        MatchQ[gradientStart,Automatic|Null]||MatchQ[gradientEnd,Automatic|Null],False,
        MatchQ[gradientA,PercentP],!(MatchQ[gradientStart,gradientA]&&MatchQ[gradientEnd,gradientA]),
        True,True
      ];

        (*check whether both gradient and the injection table are specified and are the same object*)
        gradientInjectionTableSpecifiedDifferentlyQ=If[And[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]]],
          !MatchQ[Download[gradient,Object],ObjectP[Download[injectionTableGradient,Object]]],
          False
        ];

        (* Extract or default GradientStart and GradientEnd values *)
        {resolvedGradientStart,resolvedGradientEnd}=Switch[{gradientStart,gradientEnd,gradientDuration},
          {PercentP,PercentP,_}|{Null,Null,Null|TimeP},{gradientStart,gradientEnd},
          (* Default to gradientStart if something is wrong with gradientEnd *)
          {PercentP,_,_},{gradientStart,gradientStart},
          (* Default to 0 if something is wrong with gradeintStart *)
          {_,PercentP,_},{0 Percent,gradientEnd},
          (*otherwise, both Null*)
          _,{Null,Null}
        ];

        (* Resolve equilibration times from option value or gradient or injection table object *)
        resolvedEquilibrationTime = If[MatchQ[equilibrationTime,Automatic],
          If[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
            Lookup[
              fetchPacketFromCache[Download[gradient,Object],cache],
              EquilibrationTime
            ],
            If[MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
              Lookup[
                fetchPacketFromCache[Download[injectionTableGradient,Object],cache],
                EquilibrationTime
              ],
              Null
            ]
          ],
         equilibrationTime
        ];

        (* Resolve flush times from option value or gradient object *)
        resolvedFlushTime = If[MatchQ[flushTime,Automatic],
          If[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
            Lookup[
              fetchPacketFromCache[Download[gradient,Object],cache],
              FlushTime
            ],
            If[MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
              Lookup[
                fetchPacketFromCache[Download[injectionTableGradient,Object],cache],
                FlushTime
              ],
              Null
            ]
          ],
          flushTime
        ];

        (* If Gradient option is an object, pull Gradient value from packet *)
        analyteGradientOptionTuple = If[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Lookup[fetchPacketFromCache[Download[gradient,Object],cache],Gradient],
          (*otherwise if the gradient is automatic and the injection table is set, should use that*)
          If[MatchQ[gradient,Automatic]&&MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
            Lookup[fetchPacketFromCache[Download[injectionTableGradient,Object],cache],Gradient],
            (*otherwise, it should be a tuple or automatic*)
            gradient
          ]
        ];

        (* Default FlowRate to option value, gradient tuple values, or 1mL/min *)
        defaultedAnalyteFlowRate =If[!MatchQ[flowRate,Automatic],
          flowRate,
          If[MatchQ[analyteGradientOptionTuple,sfcGradientP],
            analyteGradientOptionTuple[[All,{1,8}]],
            1.5 Milliliter/Minute
          ]
        ];

        (* Default FlowRate to option value, gradient tuple values, or 1mL/min *)
        defaultedAnalyteBackPressure =If[!MatchQ[backPressure,Automatic],
          backPressure,
          If[MatchQ[analyteGradientOptionTuple,sfcGradientP],
            analyteGradientOptionTuple[[All,{1,7}]],
            2000 PSI
          ]
        ];

        (*finally run our helper resoluton function*)
        analyteGradient=If[MatchQ[{analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,resolvedGradientStart,resolvedGradientEnd,gradientDuration},{(Null|Automatic)..}],
          resolveSFCGradient[defaultSFCGradient[defaultedAnalyteFlowRate,defaultedAnalyteBackPressure],co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,resolvedGradientStart,resolvedGradientEnd,gradientDuration],
          resolveSFCGradient[analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,resolvedGradientStart,resolvedGradientEnd,gradientDuration]
        ];

        (*check whether the gradient composition adds up to 100 okay*)
        invalidGradientCompositionQ = !AllTrue[analyteGradient,(Total[#[[{2,3,4,5,6}]]]==100 Percent)&];

        (*check whether the gradient was non-binary*)
        (*we total over the tuples and see if more than one of cosolvent elements are defined*)
        nonBinaryQ=Count[Total[analyteGradient[[All, 3;;6]]],GreaterP[0*Percent]]>1;

        (*now resolve all of the individual gradients, flow rate, and back pressure*)
        resolvedCO2Gradient = If[MatchQ[co2gradient,Automatic],
          collapseGradient[analyteGradient[[All,{1,2}]]],
          co2gradient
        ];

        resolvedGradientA = If[MatchQ[gradientA,Automatic],
          collapseGradient[analyteGradient[[All,{1,3}]]],
          gradientA
        ];

        resolvedGradientB = If[MatchQ[gradientB,Automatic],
          collapseGradient[analyteGradient[[All,{1,4}]]],
          gradientB
        ];

        resolvedGradientC = If[MatchQ[gradientC,Automatic],
          collapseGradient[analyteGradient[[All,{1,5}]]],
          gradientC
        ];

        resolvedGradientD = If[MatchQ[gradientD,Automatic],
          collapseGradient[analyteGradient[[All,{1,6}]]],
          gradientD
        ];

        resolvedBackPressure = If[MatchQ[backPressure,Automatic],
          collapseGradient[analyteGradient[[All,{1,7}]]],
          backPressure
        ];

        resolvedFlowRate = If[MatchQ[flowRate,Automatic],
          collapseGradient[analyteGradient[[All,{1,8}]]],
          flowRate
        ];

        (*finally resolve the gradient*)
        resolvedGradient = If[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
          Download[gradient,Object],
          (*otherwise if the gradient is automatic and the injection table is set, should use that*)
          If[MatchQ[gradient,Automatic]&&MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
            Download[injectionTableGradient,Object],
            (*otherwise, it should be a tuple*)
            analyteGradient
          ]
        ];

        (*return everything*)
        {
          analyteGradient,
          resolvedGradientStart,
          resolvedGradientEnd,
          gradientDuration,
          resolvedEquilibrationTime,
          resolvedFlushTime,
          resolvedCO2Gradient,
          resolvedGradientA,
          resolvedGradientB,
          resolvedGradientC,
          resolvedGradientD,
          resolvedBackPressure,
          resolvedFlowRate,
          resolvedGradient,
          gradientStartEndSpecifiedQ,
          gradientInjectionTableSpecifiedDifferentlyQ,
          invalidGradientCompositionQ,
          nonBinaryQ,
          gradientShortcutConflictQ,
          gradientStartEndAConflictQ
        }

      ]],
    Append[
      Lookup[roundedOptionsAssociation,
        {
          Gradient,
          CO2Gradient,
          GradientA,
          GradientB,
          GradientC,
          GradientD,
          GradientStart,
          GradientEnd,
          GradientDuration,
          EquilibrationTime,
          FlushTime,
          FlowRate,
          BackPressure
        }
      ],
      injectionTableSampleRoundedGradients
    ]
  ];

  (*okay now we need to do expand the column flush and column prime*)
  columnPrimeOptions={ColumnSelector,ColumnPrimeColumnTemperature,ColumnPrimeCO2Gradient,ColumnPrimeGradientA,
    ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD,ColumnPrimeFlowRate,
    ColumnPrimeGradientDuration,ColumnPrimeGradient,ColumnPrimeBackPressure,ColumnPrimeIonMode,
    ColumnPrimeMakeupFlowRate,ColumnPrimeMassDetection,ColumnPrimeScanTime,ColumnPrimeProbeTemperature,
    ColumnPrimeESICapillaryVoltage,ColumnPrimeSamplingConeVoltage,ColumnPrimeMassDetectionGain,
    ColumnPrimeAbsorbanceWavelength,ColumnPrimeWavelengthResolution,ColumnPrimeUVFilter,ColumnPrimeAbsorbanceSamplingRate,
    ColumnOrientation};

  (*if there are columns in the selector*)
  columnSelectorQ=Length[resolvedColumnSelector]>0;

  expandedColumnPrimeOptions = If[!columnSelectorQ,
    Association[#->{}&/@columnPrimeOptions],
    Last[ExpandIndexMatchedInputs[
      ExperimentSupercriticalFluidChromatography,
      {mySamples},
      Normal@Append[
        KeyTake[roundedOptionsAssociation,columnPrimeOptions],
        ColumnSelector -> resolvedColumnSelector
      ],
      Messages -> False
    ]]
  ];

  columnFlushOptions={ColumnSelector,ColumnFlushColumnTemperature,ColumnFlushCO2Gradient,ColumnFlushGradientA,ColumnFlushGradientB,
    ColumnFlushGradientC,ColumnFlushGradientD,ColumnFlushFlowRate,ColumnFlushGradientDuration,ColumnFlushGradient,
    ColumnFlushBackPressure,ColumnFlushIonMode,ColumnFlushMakeupFlowRate,ColumnFlushMassDetection,ColumnFlushScanTime,
    ColumnFlushProbeTemperature,ColumnFlushESICapillaryVoltage,ColumnFlushSamplingConeVoltage,ColumnFlushMassDetectionGain,
    ColumnFlushAbsorbanceWavelength,ColumnFlushWavelengthResolution,ColumnFlushUVFilter,ColumnFlushAbsorbanceSamplingRate};

  (*first ask the question if the column flush should exist*)
  columnFlushExistQ=Which[
    !columnSelectorQ, False,
    (*if the column refresh frequency is a number or just First, then we also don't need this*)
    MatchQ[resolvedColumnRefreshFrequency,First|GreaterP[0]], False,
    (*otherwise true*)
    True,True
  ];

  expandedColumnFlushOptions = If[!columnFlushExistQ,
    Association[#->Null&/@columnFlushOptions],
    Last[ExpandIndexMatchedInputs[
      ExperimentSupercriticalFluidChromatography,
      {mySamples},
      Normal@Append[
        KeyTake[roundedOptionsAssociation,columnFlushOptions],
        ColumnSelector -> resolvedColumnSelector
      ],
      Messages -> False
    ]]
  ];

  (*resolve the column orientation*)
  resolvedColumnOrientation=If[Length[resolvedColumnSelector]>0,
    (*have to do for each column. if the user doesn't specify, then we default to Forward*)
    Map[
      If[MatchQ[#,Except[Automatic]],#,Forward]&
    ,Lookup[expandedColumnPrimeOptions,ColumnOrientation]]
  ];

  (*we need to get all of the injection table gradients*)
  injectionTableStandardGradients=If[standardExistsQ&&injectionTableSpecifiedQ,
    (*grab the gradients column of the injection table for standard samples*)
    Cases[injectionTableLookup,{Standard,___}][[All,5]],
    (*otherwise, just pad automatics*)
    If[standardExistsQ,
      ConstantArray[Automatic,Length[ToList[resolvedStandard]]],
      Null
    ]
  ];

  injectionTableBlankGradients=If[blankExistsQ&&injectionTableSpecifiedQ,
    (*grab the gradients column of the injection table for blank samples*)
    Cases[injectionTableLookup,{Blank,___}][[All,5]],
    (*otherwise, just pad automatics*)
    If[blankExistsQ,
      ConstantArray[Automatic,Length[ToList[resolvedBlank]]],
      Null
    ]
  ];

  (*the column prime and column flush are a little more tricky because it depends on the specific column. we have to each one separately*)

  (*first dereference the injection column and gradient option to objects. *)
  injectionTableObjectified=If[injectionTableSpecifiedQ,
    MapThread[Function[{type,currentColumn,gradient},
      {
        type,
        If[MatchQ[currentColumn, ObjectP[]], Download[currentColumn, Object],currentColumn],
        If[MatchQ[gradient, ObjectP[]], Download[gradient, Object],gradient]
      }
    ]
    ,Transpose@(injectionTableLookup[[All,{1,4,5}]])]
  ];

  (*also do the same for the resolvedColumn selector*)
  columnSelectorObjectified=If[columnSelectorQ,
    Download[resolvedColumnSelector,Object]
  ];

  (*we need to grab the gradients from the injection table if they're defined*)
  (*otherwise, we pad with Automatics*)
  {
    injectionTableColumnPrimeGradients,
    injectionTableColumnFlushGradientsInitial,
    multiplePrimeSameColumnBool,
    multipleFlushSameColumnBool
  }=If[columnSelectorQ&&injectionTableSpecifiedQ,
    (*now we map through each element in the column selector*)
    Transpose@Map[Function[{currentColumn},Module[
      {columnPrimeResult,columnFlushResult,bestColumnPrimeGradient,bestColumnFlushGradient},

      (*see what column prime options we have*)
      columnPrimeResult=Cases[injectionTableObjectified,{ColumnPrime,ObjectP[currentColumn],_}][[All,3]];

      (*likewise, let's get the flush options*)
      columnFlushResult=Cases[injectionTableObjectified,{ColumnFlush,ObjectP[currentColumn],_}][[All,3]];

      (*find the best column prime gradient*)
      (*if there is a gradient object, we take that; otherwise, we go automatic or Null if there is nothing*)
      bestColumnPrimeGradient=If[Length[columnPrimeResult]>0,FirstOrDefault[Cases[columnPrimeResult,ObjectP[]],Automatic]];

      (*we also check whether the same column is defined multiple times for different gradients*)

      (*same for the flush*)
      bestColumnFlushGradient=If[Length[columnFlushResult]>0,
        FirstOrDefault[Cases[columnFlushResult,ObjectP[]],
          Automatic
        ]
      ];

      (*return the best candidates*)
      (*we also make sure that multiple different flush/prime gradients weren't defined for the same columms*)
      {
        bestColumnPrimeGradient,
        bestColumnFlushGradient,
        Length[DeleteDuplicates@DeleteCases[columnPrimeResult,Automatic]]>1,
        Length[DeleteDuplicates@DeleteCases[columnFlushResult,Automatic]]>1
      }
      ]]
      ,columnSelectorObjectified],
    If[columnSelectorQ,
      (*if no injection table, pad automatics*)
      Join[
        ConstantArray[ConstantArray[Automatic,Length[ToList[resolvedColumnSelector]]],2],
        {{False},{False}}
      ],
      (*with no columns, nothing to worry about*)
      {Null,Null,{False},{False}}
    ]
  ];

  (*we replace the column flush value with a null if we're not actually measuring column flush*)
  injectionTableColumnFlushGradients=If[!columnFlushExistQ&&MatchQ[injectionTableColumnFlushGradientsInitial,{Automatic}],Null,injectionTableColumnFlushGradientsInitial];

  (*do some error checking*)

  multiplePrimeSameColumnQ=Or@@multiplePrimeSameColumnBool;
  multipleFlushSameColumnQ=Or@@multipleFlushSameColumnBool;

  (*if so, then get the offending options*)
  multipleGradientsColumnPrimeFlushOptions=If[Or[multiplePrimeSameColumnQ,multipleFlushSameColumnQ],
    If[messagesQ,Message[Error::InjectionTableColumnGradientConflict]];
    {InjectionTable},
    {}
  ];

  multipleGradientsColumnPrimeFlushTest=If[Or[multiplePrimeSameColumnQ,multipleFlushSameColumnQ],
    testOrNull["If InjectionTable is defined, the ColumnPrime and ColumnFlush entries have the same gradient for each column:",True],
    testOrNull["If InjectionTable is defined, the ColumnPrime and ColumnFlush entries have the same gradient for each column:",False]
  ];

  (*now resolve all of the other gradients*)
  {
    {
      resolvedStandardAnalyticalGradients,
      resolvedStandardCO2Gradients,
      resolvedStandardGradientAs,
      resolvedStandardGradientBs,
      resolvedStandardGradientCs,
      resolvedStandardGradientDs,
      resolvedStandardBackPressures,
      resolvedStandardFlowRates,
      resolvedStandardGradients,
      standardGradientInjectionTableSpecifiedDifferentlyBool,
      standardInvalidGradientCompositionBool,
      standardNonBinaryCompositionBool
    },
    {
      resolvedBlankAnalyticalGradients,
      resolvedBlankCO2Gradients,
      resolvedBlankGradientAs,
      resolvedBlankGradientBs,
      resolvedBlankGradientCs,
      resolvedBlankGradientDs,
      resolvedBlankBackPressures,
      resolvedBlankFlowRates,
      resolvedBlankGradients,
      blankGradientInjectionTableSpecifiedDifferentlyBool,
      blankInvalidGradientCompositionBool,
      blankNonBinaryCompositionBool
    },
    {
      resolvedColumnPrimeAnalyticalGradients,
      resolvedColumnPrimeCO2Gradients,
      resolvedColumnPrimeGradientAs,
      resolvedColumnPrimeGradientBs,
      resolvedColumnPrimeGradientCs,
      resolvedColumnPrimeGradientDs,
      resolvedColumnPrimeBackPressures,
      resolvedColumnPrimeFlowRates,
      resolvedColumnPrimeGradients,
      columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
      columnPrimeInvalidGradientCompositionBool,
      columnPrimeNonBinaryCompositionBool
    },
    {
      resolvedColumnFlushAnalyticalGradients,
      resolvedColumnFlushCO2Gradients,
      resolvedColumnFlushGradientAs,
      resolvedColumnFlushGradientBs,
      resolvedColumnFlushGradientCs,
      resolvedColumnFlushGradientDs,
      resolvedColumnFlushBackPressures,
      resolvedColumnFlushFlowRates,
      resolvedColumnFlushGradients,
      columnFlushGradientInjectionTableSpecifiedDifferentlyBool,
      columnFlushInvalidGradientCompositionBool,
      columnFlushNonBinaryCompositionBool
    }
  }=Map[
    Function[{entry},Module[{co2gradients,gradientAs,gradientBs,gradientCs,gradientDs,gradients,gradientDurations,flowRates,backPressures,injectionTableGradients,type},

      (*split up the entry variable*)
      {co2gradients,gradientAs,gradientBs,gradientCs,gradientDs,gradients,gradientDurations,flowRates,backPressures,injectionTableGradients,type}=entry;

      (*first check whether these options are completely empty or Null (e.g. no standards)*)
      If[MatchQ[{co2gradients,gradientAs,gradientBs,gradientCs,gradientDs,gradients,gradientDurations,injectionTableGradients},{(Null|{})..}],
        (*in which case, we return all nulls and empties*)
        {Sequence@@ConstantArray[Null,9],{},{},{}},
        (*otherwise, we'll resolve the gradient and map through*)

        Transpose@MapThread[Function[{co2gradient,gradientA,gradientB,gradientC,gradientD,gradient,gradientDuration,flowRate,backPressure,injectionTableGradient},
          Module[{gradientInjectionTableSpecifiedDifferentlyQ,analyteGradientOptionTuple,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,defaultGradient,
              analyteGradient,invalidGradientCompositionQ,resolvedCO2Gradient,resolvedGradientA,resolvedGradientB,resolvedGradientC,resolvedGradientD,resolvedBackPressure,
            resolvedFlowRate,resolvedGradient,nonBinaryQ},

            (*check whether both gradient and the injection table are specified and are the same object*)
            gradientInjectionTableSpecifiedDifferentlyQ=If[And[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]]],
              !MatchQ[Download[gradient,Object],ObjectP[Download[injectionTableGradient,Object]]],
              False
            ];

            (* If Gradient option is an object, pull Gradient value from packet *)
            analyteGradientOptionTuple = If[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
              Lookup[fetchPacketFromCache[Download[gradient,Object],cache],Gradient],
              (*otherwise if the gradient is automatic and the injection table is set, should use that*)
              If[MatchQ[gradient,Automatic]&&MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
                Lookup[fetchPacketFromCache[Download[injectionTableGradient,Object],cache],Gradient],
                (*otherwise, it should be a tuple or automatic*)
                gradient
              ]
            ];

            (* Default FlowRate to option value, gradient tuple values*)
            defaultedAnalyteFlowRate =If[!MatchQ[flowRate,Automatic],
              flowRate,
              If[MatchQ[analyteGradientOptionTuple,sfcGradientP],
                analyteGradientOptionTuple[[All,{1,8}]],
                (*otherwise default the first one in the analyte tuple*)
                First[resolvedAnalyteGradients][[1,8]]
              ]
            ];

            (* Default FlowRate to option value, gradient tuple values, or 1mL/min *)
            defaultedAnalyteBackPressure =If[!MatchQ[backPressure,Automatic],
              backPressure,
              If[MatchQ[analyteGradientOptionTuple,sfcGradientP],
                analyteGradientOptionTuple[[All,{1,7}]],
                (*otherwise default to the first in the analyte tuple*)
                First[resolvedAnalyteGradients][[1,7]]
              ]
            ];

            (*create the default gradient based on the first resolved analyte gradient*)
            defaultGradient=First[resolvedAnalyteGradients];
            defaultGradient[[All,8]]=ConstantArray[defaultedAnalyteFlowRate,Length[defaultGradient]];
            defaultGradient[[All,7]]=ConstantArray[defaultedAnalyteBackPressure,Length[defaultGradient]];


            (*finally run our helper resolution function*)
            analyteGradient=Switch[type,
              (*if we have a standard or blank, we want to default to the first sample gradient, if a standard or blank*)
              (Standard|Blank),If[MatchQ[{analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,gradientDuration},{(Null|Automatic)..}],
                resolveSFCGradient[defaultGradient,co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,gradientDuration],
                resolveSFCGradient[analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,gradientDuration]
              ],
              (*otherwise, we have a column prime*)
              ColumnPrime,If[MatchQ[{analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,gradientDuration},{(Null|Automatic)..}],
                resolveSFCGradient[defaultSFCPrimeGradient[defaultedAnalyteFlowRate,defaultedAnalyteBackPressure],co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,gradientDuration],
                resolveSFCGradient[analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,gradientDuration]
              ],
              (*otherwise, we have a column flush*)
              _,If[MatchQ[{analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,gradientDuration},{(Null|Automatic)..}],
                resolveSFCGradient[defaultSFCFlushGradient[defaultedAnalyteFlowRate,defaultedAnalyteBackPressure],co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,gradientDuration],
                resolveSFCGradient[analyteGradientOptionTuple,co2gradient,gradientA,gradientB,gradientC,gradientD,defaultedAnalyteFlowRate,defaultedAnalyteBackPressure,gradientDuration]
              ]
            ];

            (*check whether the gradient composition adds up to 100 okay*)
            invalidGradientCompositionQ =  !AllTrue[analyteGradient,(Total[#[[{2,3,4,5,6}]]]==100 Percent)&];

            (*check whether the gradient was non-binary*)
            (*we totoal over the tuples and see if more than one of cosolvent elements are defined*)
            nonBinaryQ=Count[Total[analyteGradient[[All, 3;;6]]],GreaterP[0*Percent]]>1;

            (*now resolve all of the individual gradients, flow rate, and back pressure*)
            resolvedCO2Gradient = If[MatchQ[co2gradient,Automatic],
              collapseGradient[analyteGradient[[All,{1,2}]]],
              co2gradient
            ];

            resolvedGradientA = If[MatchQ[gradientA,Automatic],
              collapseGradient[analyteGradient[[All,{1,3}]]],
              gradientA
            ];

            resolvedGradientB = If[MatchQ[gradientB,Automatic],
              collapseGradient[analyteGradient[[All,{1,4}]]],
              gradientB
            ];

            resolvedGradientC = If[MatchQ[gradientC,Automatic],
              collapseGradient[analyteGradient[[All,{1,5}]]],
              gradientC
            ];

            resolvedGradientD = If[MatchQ[gradientD,Automatic],
              collapseGradient[analyteGradient[[All,{1,6}]]],
              gradientD
            ];

            resolvedBackPressure = If[MatchQ[backPressure,Automatic],
              collapseGradient[analyteGradient[[All,{1,7}]]],
              backPressure
            ];

            resolvedFlowRate = If[MatchQ[flowRate,Automatic],
              collapseGradient[analyteGradient[[All,{1,8}]]],
              flowRate
            ];

            (*finally resolve the gradient*)
            resolvedGradient = If[MatchQ[gradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
              Download[gradient,Object],
              (*otherwise if the gradient is automatic and the injection table is set, should use that*)
              If[MatchQ[gradient,Automatic]&&MatchQ[injectionTableGradient,ObjectP[Object[Method,SupercriticalFluidGradient]]],
                Download[injectionTableGradient,Object],
                (*otherwise, it should be the tuple*)
                analyteGradient
              ]
            ];

            (*return everything*)
            {
              analyteGradient,
              resolvedCO2Gradient,
              resolvedGradientA,
              resolvedGradientB,
              resolvedGradientC,
              resolvedGradientD,
              resolvedBackPressure,
              resolvedFlowRate,
              resolvedGradient,
              gradientInjectionTableSpecifiedDifferentlyQ,
              invalidGradientCompositionQ,
              nonBinaryQ
            }

          ]], {co2gradients,gradientAs,gradientBs,gradientCs,gradientDs,gradients,gradientDurations,flowRates,backPressures,injectionTableGradients}
        ]
      ]]
    ],
    {
      Join[Lookup[expandedStandardOptions,{StandardCO2Gradient,StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD,StandardGradient,StandardGradientDuration,StandardFlowRate,StandardBackPressure}],{injectionTableStandardGradients,Standard}],
      Join[Lookup[expandedBlankOptions,{BlankCO2Gradient,BlankGradientA,BlankGradientB,BlankGradientC,BlankGradientD,BlankGradient,BlankGradientDuration,BlankFlowRate,BlankBackPressure}],{injectionTableBlankGradients,Blank}],
      Join[Lookup[expandedColumnPrimeOptions,{ColumnPrimeCO2Gradient,ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD,ColumnPrimeGradient,ColumnPrimeGradientDuration,ColumnPrimeFlowRate,ColumnPrimeBackPressure}],{injectionTableColumnPrimeGradients,ColumnPrime}],
      Join[Lookup[expandedColumnFlushOptions,{ColumnFlushCO2Gradient,ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD,ColumnFlushGradient,ColumnFlushGradientDuration,ColumnFlushFlowRate,ColumnFlushBackPressure}],{injectionTableColumnFlushGradients,ColumnFlush}]
    }
  ];

  (*now do all of our gradient error checking*)

  (*any conflicts between the gradient start, end, or duration?*)
  gradientStartEndSpecifiedAdverselyQ=!(Or@@gradientStartEndSpecifiedBool);

  gradientStartEndSpecifiedAdverselyOptions=If[gradientStartEndSpecifiedAdverselyQ,
    If[messagesQ,
      Message[
        Error::GradientStartEndConflict,
        {GradientStart,GradientEnd},
        ""
      ]
    ];
    {GradientStart,GradientEnd},
    {}
  ];

  gradientStartEndSpecifiedAdverselyTest = If[gradientStartEndSpecifiedAdverselyQ,
    testOrNull["GradientStart and GradientEnd options must be specified together or both kept Null:",False],
    testOrNull["GradientStart and GradientEnd options must be specified together or both kept Null:",True]
  ];

  (*check for collisions between the injection table and the gradient specifications*)

  (*which BlahGradient options conflict to the InjectionTable?*)
  gradientInjectionTableSpecifiedDifferentlyOptionsBool=Map[(Or@@#)&,{
    gradientInjectionTableSpecifiedDifferentlyBool,
    standardGradientInjectionTableSpecifiedDifferentlyBool,
    blankGradientInjectionTableSpecifiedDifferentlyBool,
    columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
    columnFlushGradientInjectionTableSpecifiedDifferentlyBool
  }];

  (*are any of these true*)
  gradientInjectionTableSpecifiedDifferentlyQ=Or@@gradientInjectionTableSpecifiedDifferentlyOptionsBool;

  (*if so, then get the offending options*)
  gradientInjectionTableSpecifiedDifferentlyOptions=If[gradientInjectionTableSpecifiedDifferentlyQ,
    Append[PickList[{Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient},gradientInjectionTableSpecifiedDifferentlyOptionsBool],InjectionTable],
    {}
  ];

  If[messagesQ&&gradientInjectionTableSpecifiedDifferentlyQ,Message[Error::InjectionTableGradientConflict,ObjectToString@Drop[gradientInjectionTableSpecifiedDifferentlyOptions]]];

  gradientInjectionTableSpecifiedDifferentlyTest=If[gradientInjectionTableSpecifiedDifferentlyQ,
    testOrNull["If InjectionTable is specified as well as Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient, they are compatible:",True],
    testOrNull["If InjectionTable is specified as well as Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient, they are compatible:",False]
  ];

  (*check if the gradient short cut options are conflicting*)
  (*are any of these true*)
  gradientShortcutOverallQ = MemberQ[gradientShortcutConflictBool, True];

  (*if so, then get the offending options (and throw the error) *)
  gradientShortcutOptions = If[gradientShortcutOverallQ && messagesQ,
    {GradientStart, GradientEnd, GradientA, GradientB, GradientC, GradientD},
    {}
  ];

  If[messagesQ && gradientShortcutOverallQ,
    Message[
      Error::GradientShortcutConflict,
      GradientDuration,
      {GradientStart,GradientEnd},
      "Gradient"
    ]
  ];

  (* generate the test testing for this issue *)
  gradientShortcutTest = If[gatherTestsQ,
    Test["If GradientDuration option is specified, GradientStart and GradientEnd cannot be specified with the corresponding Gradient A/B/C/D options:",
      gradientShortcutOverallQ,
      False
    ],
    Nothing
  ];

  (*check if the gradient start/end/B options are conflicting*)
  (*are any of these true*)
  gradientStartEndAConflictOverallQ = MemberQ[gradientStartEndAConflictBool, True];

  If[messagesQ && gradientStartEndAConflictOverallQ && !engineQ,
    Message[
      Warning::GradientShortcutAmbiguity,
      {GradientStart,GradientEnd},
      "Gradient"
    ]
  ];

  (* generate the test testing for this issue *)
  gradientStartEndAConflictTests = If[gatherTestsQ,
    Test["If GradientStart, GradientEnd and Gradient A/B/C/D options are specified, they must match each other:",
      gradientStartEndAConflictOverallQ,
      False
    ],
    Nothing
  ];

  (*check that all of the gradient compositions are okay (add up to 100%)*)

  (*which BlahGradient options conflict are invalid?*)
  invalidGradientCompositionOptionsBool=Map[(Or@@#)&,{
    invalidGradientCompositionBool,
    standardInvalidGradientCompositionBool,
    blankInvalidGradientCompositionBool,
    columnPrimeInvalidGradientCompositionBool,
    columnFlushInvalidGradientCompositionBool
  }];

  (*any of these true?*)
  invalidGradientCompositionQ=Or@@invalidGradientCompositionOptionsBool;

  (*if so, then get the offending options*)
  invalidGradientCompositionOptions=If[invalidGradientCompositionQ,
    If[messagesQ,Message[Error::InvalidGradientComposition,""]];
    PickList[{Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient},invalidGradientCompositionOptionsBool],
    {}
  ];

  invalidGradientCompositionTest=If[invalidGradientCompositionQ,
    testOrNull["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are valid gradients (add up to 100% for each time point):",True],
    testOrNull["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are valid gradients (add up to 100% for each time point):",False]
  ];

  (*check that all of the gradient compositions will work for a binary pump*)

  (*which BlahGradient options conflict are invalid?*)
  nonBinaryCompositionOptionsBool=Map[(Or@@#)&,{
    nonBinaryCompositionBool,
    standardNonBinaryCompositionBool,
    blankNonBinaryCompositionBool,
    columnPrimeNonBinaryCompositionBool,
    columnFlushNonBinaryCompositionBool
  }];

  (*any of these true?*)
  nonBinaryCompositionQ=Or@@nonBinaryCompositionOptionsBool;

  (*if so, then get the offending options*)
  nonBinaryCompositionOptions=If[nonBinaryCompositionQ,
    If[messagesQ,Message[Error::NonbinaryGradientDefined]];
    PickList[{Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient},nonBinaryCompositionOptionsBool],
    {}
  ];

  nonBinaryCompositionTest=If[nonBinaryCompositionQ,
    testOrNull["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are binary gradients:",True],
    testOrNull["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are binary gradients:",False]
  ];

  (*resolve the cosolvents*)

  (*bundle all the resolved gradients together so that it'll be helpful*)
  allResolvedGradientMethods=Cases[
    Join[
      resolvedGradients,
      resolvedStandardGradients/.{Null->{}},
      resolvedBlankGradients/.{Null->{}},
      resolvedColumnPrimeGradients/.{Null->{}},
      resolvedColumnFlushGradients/.{Null->{}}
    ],
    ObjectP[Object[Method,SupercriticalFluidGradient]]
  ];

  (*get the packets for any associated gradient method objects*)
  allGradientMethodPackets=Map[
    fetchPacketFromCache[Download[#,Object],cache]&
    ,allResolvedGradientMethods];

  (*should see if any of the gradients have been specified by seeing if there are *)
  anyGradientAQ=Or@@Map[Count[#,GreaterP[0 Percent]|{{GreaterEqualP[0 Minute],GreaterEqualP[0 Percent]}..}]>0&,
    {resolvedGradientAs,resolvedStandardGradientAs,resolvedBlankGradientAs,resolvedColumnPrimeGradientAs,resolvedColumnFlushGradientAs}];

  anyGradientBQ=Or@@Map[Count[#,GreaterP[0 Percent]|{{GreaterEqualP[0 Minute],GreaterEqualP[0 Percent]}..}]>0&,
    {resolvedGradientBs,resolvedStandardGradientBs,resolvedBlankGradientBs,resolvedColumnPrimeGradientBs,resolvedColumnFlushGradientBs}];

  anyGradientCQ=Or@@Map[Count[#,GreaterP[0 Percent]|{{GreaterEqualP[0 Minute],GreaterEqualP[0 Percent]}..}]>0&,
    {resolvedGradientCs,resolvedStandardGradientCs,resolvedBlankGradientCs,resolvedColumnPrimeGradientCs,resolvedColumnFlushGradientCs}];

  anyGradientDQ=Or@@Map[Count[#,GreaterP[0 Percent]|{{GreaterEqualP[0 Minute],GreaterEqualP[0 Percent]}..}]>0&,
    {resolvedGradientDs,resolvedStandardGradientDs,resolvedBlankGradientDs,resolvedColumnPrimeGradientDs,resolvedColumnFlushGradientDs}];

  (*get all the method cosolvents and dereference*)
  {
    cosolventAMethodList,
    cosolventBMethodList,
    cosolventCMethodList,
    cosolventDMethodList
  }=Transpose[
    Download[#,Object]&/@Lookup[allGradientMethodPackets,
      {
        CosolventA,
        CosolventB,
        CosolventC,
        CosolventD
      },
      {Null,Null,Null,Null}
    ]
  ];

  resolvedCosolventA=If[MatchQ[Lookup[roundedOptionsAssociation,CosolventA],Except[Automatic]],
    (*first check whether resolved cosolvent A is specified, if so go with it*)
    Lookup[roundedOptionsAssociation,CosolventA],
    (*otherwise check whether any gradient As are specified*)
    (*otherwise check the resolved gradient for any gradient objects and check those packets to see if there a suitable Cosolvent A*)
    If[anyGradientAQ,
        FirstCase[cosolventAMethodList, ObjectP[Model[Sample]],
          (*otherwise, we default based on the separation mode*)
          If[MatchQ[separationModeLookup, Chiral], Model[Sample, "id:lYq9jRxWD1OB"] (*IPA*), Model[Sample, "id:01G6nvkKrrPd"] (*methanol*)]
      ],
      (*otherwise, there is no gradient A*)
      Null
    ]
  ];

  resolvedCosolventB=If[MatchQ[Lookup[roundedOptionsAssociation,CosolventB],Except[Automatic]],
    (*first check whether resolved cosolvent B is specified, if so go with it*)
    Lookup[roundedOptionsAssociation,CosolventB],
    (*otherwise check the resolved gradient for any gradient objects and check those packets to see if there a suitable Cosolvent B*)
    If[anyGradientBQ,
      FirstCase[cosolventBMethodList, ObjectP[Model[Sample]],
      (*otherwise, we default based on the separation mode*)
        If[MatchQ[separationModeLookup, Chiral], Model[Sample, "id:01G6nvkKrrPd"] (*methanol*), Model[Sample, "id:lYq9jRxWD1OB"] (*IPA*)]
      ],
      (*otherwise, there is no gradient B*)
      Null
    ]
  ];

  resolvedCosolventC=If[MatchQ[Lookup[roundedOptionsAssociation,CosolventC],Except[Automatic]],
    (*first check whether resolved cosolvent C is specified, if so go with it*)
    Lookup[roundedOptionsAssociation,CosolventC],
    (*otherwise check the resolved gradient for any gradient objects and check those packets to see if there a suitable Cosolvent C*)
    If[anyGradientCQ,
      FirstCase[cosolventCMethodList, ObjectP[Model[Sample]],
        (*otherwise default Acetonitrile*)
        Model[Sample, "id:Z1lqpMGjeev0"]
      ],
      (*otherwise, there is no gradient C*)
      Null
    ]
  ];

  resolvedCosolventD=If[MatchQ[Lookup[roundedOptionsAssociation,CosolventD],Except[Automatic]],
    (*first check whether resolved cosolvent D is specified, if so go with it*)
    Lookup[roundedOptionsAssociation,CosolventD],
    (*otherwise check the resolved gradient for any gradient objects and check those packets to see if there a suitable Cosolvent D*)
    If[anyGradientDQ,
      FirstCase[cosolventDMethodList, ObjectP[],
        (*otherwise default to heptane*)
        Model[Sample, "id:wqW9BP7E5Ge9"]
      ],
      (*otherwise, there is no gradient D*)
      Null
    ]
  ];

  (*check whether we resolved to a cosolvent that clashes with what was in the specified gradient methods*)
  {
    cosolventAClashQ,
    cosolventBClashQ,
    cosolventCClashQ,
    cosolventDClashQ
  }=MapThread[Function[{resolved,methodList},
      (*check whether the resolved matches all the gradient methods *)
      If[!NullQ[resolved]&&MatchQ[methodList,Except[ListableP[Null]]],
        Length[Complement[methodList,{Download[resolved,Object]}]]>0,
        False
      ]
    ],
    {
      {resolvedCosolventA, resolvedCosolventB, resolvedCosolventC, resolvedCosolventD},
      {cosolventAMethodList, cosolventBMethodList, cosolventCMethodList, cosolventDMethodList}
    }
  ];

  (*throw a warning if we have any clashes*)
  If[messagesQ&&Or[cosolventAClashQ, cosolventBClashQ, cosolventCClashQ, cosolventDClashQ],
    Message[Warning::CosolventConflict,ToString@PickList[{CosolventA,CosolventB,CosolventC,CosolventD},{cosolventAClashQ, cosolventBClashQ, cosolventCClashQ, cosolventDClashQ}]]
  ];

  (*now resolve all of the column temperatures*)

  (*first we do the analyte sample column temperatures*)
  resolvedColumnTemperatures=If[MatchQ[Lookup[roundedOptionsAssociation,ColumnTemperature],Except[ListableP[Automatic]]],
    Lookup[roundedOptionsAssociation,ColumnTemperature],
    (*otherwise, we check whether there is a column and if so, do 30, otherwise Null*)
    Map[If[MatchQ[#,ObjectP[]],30 Celsius]&,ToList@resolvedColumn]
  ];

  (*same for standard and blank. although we'll default to the first analyte temp*)
  resolvedStandardColumnTemperatures= If[standardExistsQ,
    If[MatchQ[Lookup[expandedStandardOptions, StandardColumnTemperature], Except[ListableP[Automatic]]],
      Lookup[expandedStandardOptions, StandardColumnTemperature],
      (*otherwise, we check whether there is a column and if so, do 30, otherwise Null*)
      Map[
        If[MatchQ[#, ObjectP[]], FirstCase[resolvedColumnTemperatures, TemperatureP, Null]]&,
        resolvedStandardColumn
      ]
    ]
  ];

  resolvedBlankColumnTemperatures= If[blankExistsQ,
    If[MatchQ[Lookup[expandedBlankOptions,BlankColumnTemperature],Except[ListableP[Automatic]]],
      Lookup[expandedBlankOptions,BlankColumnTemperature],
      (*otherwise, we check whether there is a column and if so, do 30, otherwise Null*)
      Map[
        If[MatchQ[#,ObjectP[]],FirstCase[resolvedColumnTemperatures,TemperatureP,Null]]&,
        resolvedBlankColumn
      ]
    ]
  ];

  (*now do the same for the column prime and flush temperatures*)

  resolvedPrimeColumnTemperatures= If[columnSelectorQ,
    If[MatchQ[Lookup[expandedColumnPrimeOptions, ColumnPrimeColumnTemperature], Except[ListableP[Automatic]]],
      Lookup[expandedColumnPrimeOptions, ColumnPrimeColumnTemperature],
      (*otherwise, we check whether there is a column and if so, do 30, otherwise Null*)
      Map[
        If[MatchQ[#, ObjectP[]], FirstCase[resolvedColumnTemperatures, TemperatureP, Null]]&,
        resolvedColumnSelector
      ]
    ]
  ];
  
  resolvedFlushColumnTemperatures= If[columnSelectorQ,
    If[MatchQ[Lookup[expandedColumnFlushOptions, ColumnFlushColumnTemperature], Except[ListableP[Automatic]]],
      Lookup[expandedColumnFlushOptions, ColumnFlushColumnTemperature],
      (*otherwise, we check whether there is a column and if so, do 30, otherwise Null*)
      Map[
        If[MatchQ[#, ObjectP[]], FirstCase[resolvedColumnTemperatures, TemperatureP, Null]]&,
        resolvedColumnSelector
      ]
    ]
  ];

  (*now resolve the injection volumes*)

  (*we need to extract our the injection volume from the injection table*)
  injectionTableSampleInjectionVolumes=If[injectionTableSpecifiedQ&&!injectionTableSampleConflictQ,
    Cases[roundedInjectionTable,{Sample,___}][[All,3]],
    (*otherwise pad automatic*)
    ConstantArray[Automatic,Length[mySamples]]
  ];

  (*now we must do our require aliquot if necessary*)

  (*declaring some globals*)
  maxInjectionVolume=50 Microliter;

  autosamplerDeadVolume=20 Microliter;

  (* Resolve InjectionVolume for analyte runs based on:
	 	- Input option value
	 	- Whether it's in the injection Table
		- aliquot volume
		- default 3ul *)
  resolvedInjectionVolumes = MapThread[
    Function[{samplePacket,aliquotQ,aliquotVolume,assayVolume,injectionVolume,injectionTableVolume},
      Which[
        (*user specified*)
        MatchQ[injectionVolume,VolumeP],
        injectionVolume,
        (*injectionTable specified*)
        MatchQ[injectionTableVolume,VolumeP],injectionTableVolume,
        TrueQ[aliquotQ&&MatchQ[aliquotVolume,GreaterP[0*Microliter]]],
          Min[aliquotVolume - autosamplerDeadVolume,maxInjectionVolume - autosamplerDeadVolume],
        True,
        If[MatchQ[Lookup[samplePacket,Volume],VolumeP],
          Min[Lookup[samplePacket,Volume], 3 Microliter],
          3 Microliter
        ]
      ]
    ],
    {
      simulatedSamplePackets,
      Lookup[samplePrepOptions,Aliquot],
      Lookup[samplePrepOptions,AliquotAmount],
      Lookup[samplePrepOptions,AssayVolume],
      Lookup[roundedOptionsAssociation,InjectionVolume],
      injectionTableSampleInjectionVolumes
    }
  ];

  (*resolve the standard injection volumes*)
  (*we need to extract our the injection volume from the injection table*)
  injectionTableStandardInjectionVolumes=If[injectionTableSpecifiedQ,
    Cases[roundedInjectionTable,{Standard,___}][[All,3]],
    (*otherwise pad automatic*)
    ConstantArray[Automatic,Length[ToList@resolvedStandard]]
  ];

  resolvedStandardInjectionVolumes = If[standardExistsQ,
    MapThread[
      Function[{standard,injectionVolumeValue,injectionTableValue},
        Which[
          (*user specified*)
          MatchQ[injectionVolumeValue,VolumeP],injectionVolumeValue,
          (*injectionTable specified*)
          MatchQ[injectionTableValue,VolumeP],injectionTableValue,
          (*otherwise default to the first resolution*)
          True,First@resolvedInjectionVolumes
        ]
      ],
      {
        Lookup[expandedStandardOptions,Standard],
        Lookup[expandedStandardOptions,StandardInjectionVolume],
        injectionTableStandardInjectionVolumes
      }
    ],Null
  ];

  (*resolve the blank injection volumes*)
  (*we need to extract our the injection volume from the injection table*)
  injectionTableBlankInjectionVolumes=If[injectionTableSpecifiedQ,
    Cases[roundedInjectionTable,{Blank,___}][[All,3]],
    (*otherwise pad automatic*)
    ConstantArray[Automatic,Length[ToList@resolvedBlank]]
  ];

  resolvedBlankInjectionVolumes = If[blankExistsQ,
    MapThread[
      Function[{injectionVolumeValue,injectionTableValue},
        Which[
          (*user specified*)
          MatchQ[injectionVolumeValue,VolumeP],injectionVolumeValue,
          (*injectionTable specified*)
          MatchQ[injectionTableValue,VolumeP],injectionTableValue,
          (*otherwise default to the first resolution*)
          True,First@resolvedInjectionVolumes
        ]
      ],
      {
        Lookup[expandedBlankOptions,BlankInjectionVolume],
        injectionTableBlankInjectionVolumes
      }
    ],Null
  ];


  (*finally we resolve our injection table using the helper function*)

  (*we'll need to combine all of the relevant options for the injection table*)
  resolvedOptionsForInjectionTable=Association[
    Column->resolvedColumn,
    InjectionVolume->resolvedInjectionVolumes,
    Gradient->resolvedGradients,
    Standard->resolvedStandard,
    StandardColumn->resolvedStandardColumn,
    StandardFrequency->resolvedStandardFrequency,
    StandardInjectionVolume->resolvedStandardInjectionVolumes,
    StandardGradient->resolvedStandardGradients,
    Blank->resolvedBlank,
    BlankColumn->resolvedBlankColumn,
    BlankFrequency->resolvedBlankFrequency,
    BlankInjectionVolume->resolvedBlankInjectionVolumes,
    BlankGradient->resolvedBlankGradients,
    ColumnRefreshFrequency->resolvedColumnRefreshFrequency,
    ColumnPrimeGradient->resolvedColumnPrimeGradients,
    ColumnFlushGradient->resolvedColumnFlushGradients,
    InjectionTable->roundedInjectionTable,
    ColumnSelector->resolvedColumnSelector
  ];

  (*call our shared helper function*)
  {{resolvedInjectionTableResult, invalidInjectionTableOptions}, invalidInjectionTableTests} = If[gatherTests,
    resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentSupercriticalFluidChromatography, Object[Method,SupercriticalFluidGradient], Output -> {Result, Tests}],
    {resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentSupercriticalFluidChromatography, Object[Method,SupercriticalFluidGradient]], {}}
  ];

  (*call our shared helper function*)
  resolvedInjectionTable=Lookup[resolvedInjectionTableResult,InjectionTable];

  (*define the acceptable scan times*)
  acceptableScanTimes=1 Second/# & /@ ({1, 2, 5, 8, 10, 15, 20}*1.);

  (*resolve the mass spec options for the samples in*)

  {
    resolvedIonModes,
    resolvedMakeupFlowRates,
    resolvedMassDetections,
    resolvedScanTimes,
    resolvedProbeTemperatures,
    resolvedESICapillaryVoltages,
    resolvedSamplingConeVoltages,
    resolvedMassDetectionGains,
    scanTimeSampleRoundingBool
  }=Transpose@MapThread[
    Function[{ionMode,makeupFlowRate,massDetection,scanTime,probeTemperature,esiCapillaryVoltage,samplingConeVoltage,massDetectionGain,samplePacket},
      Module[
        {samplepH,resolvedIonMode,resolvedMakeupFlowRate,resolvedMassDetection,resolvedScanTime,resolvedProbeTemperature,resolvedESICapillaryVoltage,
          resolvedSamplingConeVoltage,resolvedMassDetectionGain,scanTimeRoundingQ},

        (*first get the sample pH*)
        samplepH=Lookup[samplePacket,pH];

        (*with ion mode we simply just see if acidic, otherwise, go positive*)
        resolvedIonMode= If[MatchQ[ionMode,Automatic],
          If[MatchQ[samplepH,LessP[5]],Negative,Positive],
          ionMode
        ];

        (*we may need to round the scan time*)
        {resolvedScanTime,scanTimeRoundingQ}=If[
          (*if it's exact then we're okay*)
          Count[Abs[acceptableScanTimes - scanTime], LessEqualP[0 Second]]>0,{scanTime,False},
          (*otherwise, we need to find the closest value in our array*)
          {First@MinimalBy[acceptableScanTimes,Abs[#-scanTime]&],True}
        ];

        (*no resolution with anything else, can just equate to the option*)
        resolvedMakeupFlowRate=makeupFlowRate;
        resolvedMassDetection=massDetection;
        resolvedProbeTemperature=probeTemperature;
        resolvedESICapillaryVoltage=esiCapillaryVoltage;
        resolvedSamplingConeVoltage=samplingConeVoltage;
        resolvedMassDetectionGain=massDetectionGain;

        (*return everything*)
        {
          resolvedIonMode,
          resolvedMakeupFlowRate,
          resolvedMassDetection,
          resolvedScanTime,
          resolvedProbeTemperature,
          resolvedESICapillaryVoltage,
          resolvedSamplingConeVoltage,
          resolvedMassDetectionGain,
          scanTimeRoundingQ
        }
      ]
    ],
    Append[
      Lookup[
        roundedOptionsAssociation,
        {
          IonMode,
          MakeupFlowRate,
          MassDetection,
          ScanTime,
          ProbeTemperature,
          ESICapillaryVoltage,
          SamplingConeVoltage,
          MassDetectionGain
        }
      ],
      simulatedSamplePackets
    ]
  ];

  (*now we resolve for mass spec options for the standard, blank, column flush, column flush*)
  {
    {
      resolvedStandardIonModes,
      resolvedStandardMakeupFlowRates,
      resolvedStandardMassDetections,
      resolvedStandardScanTimes,
      resolvedStandardProbeTemperatures,
      resolvedStandardESICapillaryVoltages,
      resolvedStandardSamplingConeVoltages,
      resolvedStandardMassDetectionGains,
      scanTimeStandardRoundingBool
    },
    {
      resolvedBlankIonModes,
      resolvedBlankMakeupFlowRates,
      resolvedBlankMassDetections,
      resolvedBlankScanTimes,
      resolvedBlankProbeTemperatures,
      resolvedBlankESICapillaryVoltages,
      resolvedBlankSamplingConeVoltages,
      resolvedBlankMassDetectionGains,
      scanTimeBlankRoundingBool
    },
    {
      resolvedColumnPrimeIonModes,
      resolvedColumnPrimeMakeupFlowRates,
      resolvedColumnPrimeMassDetections,
      resolvedColumnPrimeScanTimes,
      resolvedColumnPrimeProbeTemperatures,
      resolvedColumnPrimeESICapillaryVoltages,
      resolvedColumnPrimeSamplingConeVoltages,
      resolvedColumnPrimeMassDetectionGains,
      scanTimeColumnPrimeRoundingBool
    },
    {
      resolvedColumnFlushIonModes,
      resolvedColumnFlushMakeupFlowRates,
      resolvedColumnFlushMassDetections,
      resolvedColumnFlushScanTimes,
      resolvedColumnFlushProbeTemperatures,
      resolvedColumnFlushESICapillaryVoltages,
      resolvedColumnFlushSamplingConeVoltages,
      resolvedColumnFlushMassDetectionGains,
      scanTimeColumnFlushRoundingBool
    }
  }=Map[
    Function[{entry},Module[
      {ionModes,makeupFlowRates,massDetections,scanTimes,probeTemperatures,esiCapillaryVoltages,samplingConeVoltages,massDetectionGains},

      (*split our input*)
      {ionModes,makeupFlowRates,massDetections,scanTimes,probeTemperatures,esiCapillaryVoltages,samplingConeVoltages,massDetectionGains}=entry;

      (*is there anything here? if not, just return Nulls*)
      (*first check whether these options are completely empty or Null (e.g. no standards)*)
      If[MatchQ[{ionModes,makeupFlowRates,massDetections,scanTimes,probeTemperatures,esiCapillaryVoltages,samplingConeVoltages,massDetectionGains},{(Null|{})..}],
        (*in which case, we return all nulls and empties*)
        {Sequence@@ConstantArray[Null,8],{}},
        (*otherwise, we'll resolve the gradient and map through*)
        Transpose@MapThread[Function[{ionMode,makeupFlowRate,massDetection,scanTime,probeTemperature,esiCapillaryVoltage,samplingConeVoltage,massDetectionGain},Module[
            {resolvedIonMode,resolvedMakeupFlowRate,resolvedMassDetection,resolvedScanTime,resolvedProbeTemperature,resolvedESICapillaryVoltage,resolvedSamplingConeVoltage,
              resolvedMassDetectionGain,scanTimeRoundingQ},

            (*for most of these options we can just take it if specified, otherwise we default to the first resolution*)
            {
              resolvedIonMode,
              resolvedMakeupFlowRate,
              resolvedMassDetection,
              resolvedProbeTemperature,
              resolvedESICapillaryVoltage,
              resolvedSamplingConeVoltage,
              resolvedMassDetectionGain
            }=MapThread[Function[{currentOption,sampleOption},
                If[MatchQ[currentOption,Except[Automatic]],currentOption,First@sampleOption]
              ],
              {
                {ionMode,makeupFlowRate,massDetection,probeTemperature,esiCapillaryVoltage,samplingConeVoltage,massDetectionGain},
                (*just so that there is no confusion, the following are the already resolved options for the samples!*)
                {resolvedIonModes,resolvedMakeupFlowRates,resolvedMassDetections,resolvedProbeTemperatures,resolvedESICapillaryVoltages,resolvedSamplingConeVoltages,resolvedMassDetectionGains}
              }            
            ];

            (*we may need to round the scan time*)
            {resolvedScanTime,scanTimeRoundingQ}= If[MatchQ[scanTime,Except[Automatic]],
              If[
                (*if it's exact then we're okay*)
                Count[Abs[acceptableScanTimes - scanTime], LessEqualP[0 Second]]>0,{scanTime,False},
                (*otherwise, we need to find the closest value in our array*)
                {First@MinimalBy[acceptableScanTimes,Abs[#-scanTime]&],True}
              ],
              (*otherwise return the first resolved sample one*)
              {First@resolvedScanTimes,False}
            ];

            (*return everything*)
            {
              resolvedIonMode,
              resolvedMakeupFlowRate,
              resolvedMassDetection,
              resolvedScanTime,
              resolvedProbeTemperature,
              resolvedESICapillaryVoltage,
              resolvedSamplingConeVoltage,
              resolvedMassDetectionGain,
              scanTimeRoundingQ
            }
          ]],{ionModes,makeupFlowRates,massDetections,scanTimes,probeTemperatures,esiCapillaryVoltages,samplingConeVoltages,massDetectionGains}
        ]
      ]
      ]],
    {
      Lookup[expandedStandardOptions,{StandardIonMode,StandardMakeupFlowRate,StandardMassDetection,StandardScanTime,StandardProbeTemperature,StandardESICapillaryVoltage,StandardSamplingConeVoltage,StandardMassDetectionGain}],
      Lookup[expandedBlankOptions,{BlankIonMode,BlankMakeupFlowRate,BlankMassDetection,BlankScanTime,BlankProbeTemperature,BlankESICapillaryVoltage,BlankSamplingConeVoltage,BlankMassDetectionGain}],
      Lookup[expandedColumnPrimeOptions,{ColumnPrimeIonMode,ColumnPrimeMakeupFlowRate,ColumnPrimeMassDetection,ColumnPrimeScanTime,ColumnPrimeProbeTemperature,ColumnPrimeESICapillaryVoltage,ColumnPrimeSamplingConeVoltage,ColumnPrimeMassDetectionGain}],
      Lookup[expandedColumnFlushOptions,{ColumnFlushIonMode,ColumnFlushMakeupFlowRate,ColumnFlushMassDetection,ColumnFlushScanTime,ColumnFlushProbeTemperature,ColumnFlushESICapillaryVoltage,ColumnFlushSamplingConeVoltage,ColumnFlushMassDetectionGain}]
    }
  ];

  (*do throw warnings for the rounded ScanTime*)

  (*find which options were offending*)
  scanTimeRoundingBool=(Or@@#&)/@{scanTimeSampleRoundingBool,scanTimeStandardRoundingBool,scanTimeBlankRoundingBool,scanTimeColumnPrimeRoundingBool,scanTimeColumnFlushRoundingBool};

  scanTimeRoundingOptions=PickList[{ScanTime,StandardScanTime,BlankScanTime,ColumnPrimeScanTime,ColumnFlushScanTime},scanTimeRoundingBool];

  If[Length[scanTimeRoundingOptions]>0&&messagesQ,
    Message[Warning::ScanTimeAdjusted,scanTimeRoundingOptions,acceptableScanTimes]
  ];

  (*define the exact absorbance rate values that we can have*)
  possibleAbsorbanceRateValues={1/Second,2*1/Second,5*1/Second,10*1/Second,20*1/Second,40*1/Second,80*1/Second}*1.;

  (*define the possible *)
  possibleWavelengthResolutions={1.2*Nanometer,2.4*Nanometer,3.6*Nanometer,4.8*Nanometer,6.0*Nanometer,7.2*Nanometer,8.4*Nanometer,9.6*Nanometer,10.8*Nanometer,12.0*Nanometer};

  (*now do the photo diode array detector options*)
  {
    resolvedAbsorbanceWavelengths,
    resolvedWavelengthResolutions,
    resolvedUVFilters,
    resolvedAbsorbanceSamplingRates,
    wavelengthResolutionSampleConflictBool,
    roundedSamplingSampleRateBool,
    roundedWavelengthSampleResolutionBool
  }=Transpose@MapThread[Function[{absorbanceWavelength,wavelengthResolution,uvFilter,absorbanceSampleRate},Module[
    {wavelengthResolutionConflictQ, roundedSamplingRateQ, roundedResolutionQ, resolvedAbsorbanceWavelength, resolvedWavelengthResolution, resolvedUVFilter, resolvedAbsorbanceSamplingRate},

    (*the absorbanceWavelength and UV filter just comes from the input options*)
    resolvedUVFilter=uvFilter;
    resolvedAbsorbanceWavelength=absorbanceWavelength;

    (*for for the sampling rate, need to make sure that it's rounded to one of the sensible options*)
    {resolvedAbsorbanceSamplingRate, roundedSamplingRateQ}=If[
      (*if it's exact then we're okay*)
      Count[Abs[possibleAbsorbanceRateValues - absorbanceSampleRate], LessEqualP[0*1/Second]]>0,{absorbanceSampleRate,False},
      (*otherwise, we need to find the closest value in our array*)
      {First@MinimalBy[possibleAbsorbanceRateValues,Abs[#-absorbanceSampleRate]&],True}
    ];

    (*the wavelength resolution needs to be resolved, and the errors must be checked*)
    {resolvedWavelengthResolution,wavelengthResolutionConflictQ,roundedResolutionQ}=Switch[{wavelengthResolution,resolvedAbsorbanceWavelength},
      (*check if automatic, and if so depends on the absorbance wavelength*)
      {Automatic,_Span|All},{1.2 Nanometer,False,False},
      {Automatic,GreaterP[0*Nanometer]},{Null,False,False},
      (*if it's set, we need to make sure compatible*)
      {Null,_Span|All},{Null,True,False},
      (*need to round to one of the values potentially*)
      {GreaterP[0*Nanometer],_},If[Count[Abs[possibleWavelengthResolutions - wavelengthResolution], LessEqualP[0*Nanometer]]>0,
        (*we're good, but also need to make sure that resolvedAbsorbance wavelength isn't just a singelton*)
        {wavelengthResolution,MatchQ[resolvedAbsorbanceWavelength,GreaterP[0*Nanometer]],False},
        (*otherwise, we need to find the closest value in our array*)
        {First@MinimalBy[possibleWavelengthResolutions,Abs[#-wavelengthResolution]&],MatchQ[resolvedAbsorbanceWavelength,GreaterP[0*Nanometer]],True}
      ]
    ];

    (*return everything*)
    {
      resolvedAbsorbanceWavelength,
      resolvedWavelengthResolution,
      resolvedUVFilter,
      resolvedAbsorbanceSamplingRate,
      wavelengthResolutionConflictQ,
      roundedSamplingRateQ,
      roundedResolutionQ
    }
    ]],Lookup[roundedOptionsAssociation,{AbsorbanceWavelength,WavelengthResolution,UVFilter,AbsorbanceSamplingRate}]
  ];

  (*now do all of the other options simultaneously*)
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
  }=Map[Function[{entry},Module[
    {absorbanceWavelengths,wavelengthResolutions,uvFilters,absorbanceSampleRates},

    (*split the entry variable*)
    {absorbanceWavelengths,wavelengthResolutions,uvFilters,absorbanceSampleRates}=entry;

    (*first we check whether there is actually anything (i.e. no standards)*)
    If[MatchQ[{absorbanceWavelengths,wavelengthResolutions,uvFilters,absorbanceSampleRates},{(Null|{})..}],
      (*in which case, we return all nulls and empties*)
      {Sequence@@ConstantArray[Null,4],{},{},{}},
      (*otherwise, we'll resolve the detector options and map through*)
      Transpose@MapThread[Function[{absorbanceWavelength,wavelengthResolution,uvFilter,absorbanceSampleRate},Module[
        {wavelengthResolutionConflictQ, roundedSamplingRateQ, roundedResolutionQ, resolvedAbsorbanceWavelength, resolvedWavelengthResolution, resolvedUVFilter, resolvedAbsorbanceSamplingRate},

        (*for most of these options we can just take it if specified, otherwise we default to the first resolution*)
        {
          resolvedUVFilter,
          resolvedAbsorbanceWavelength
        }=MapThread[Function[{currentOption,sampleOption},
          If[MatchQ[currentOption,Except[Automatic]],currentOption,First@sampleOption]
        ],
          {
            {uvFilter,absorbanceWavelength},
            (*just so that there is no confusion, the following are the already resolved options for the samples!*)
            {resolvedUVFilters,resolvedAbsorbanceWavelengths}
          }
        ];



        (*for for the sampling rate, need to make sure that it's rounded to one of the sensible options, if specified*)
        {resolvedAbsorbanceSamplingRate, roundedSamplingRateQ}= If[MatchQ[absorbanceSampleRate, Except[Automatic]],
          If[
            (*if it's exact then we're okay*)
            Count[Abs[possibleAbsorbanceRateValues - absorbanceSampleRate], LessEqualP[0 * 1 / Second]] > 0,
            {absorbanceSampleRate, False},
            (*otherwise, we need to find the closest value in our array*)
            {First@MinimalBy[possibleAbsorbanceRateValues, Abs[# - absorbanceSampleRate]&], True}
          ],
          (*if automatic, take the first resolved*)
          {First@resolvedAbsorbanceSamplingRates,False}
        ];

        (*the wavelength resolution needs to be resolved, and the errors must be checked*)
        {resolvedWavelengthResolution,wavelengthResolutionConflictQ,roundedResolutionQ}=Switch[{wavelengthResolution,resolvedAbsorbanceWavelength},
          (*check if automatic, and if so depends on the absorbance wavelength*)
          {Automatic,_Span|All},{First@resolvedWavelengthResolutions,False,False},
          {Automatic,GreaterP[0*Nanometer]},{Null,False,False},
          (*if it's set, we need to make sure compatible*)
          {Null,_Span|All},{Null,True,False},
          (*need to round to one of the values potentially*)
          {GreaterP[0*Nanometer],_},If[Count[Abs[possibleWavelengthResolutions - wavelengthResolution], LessEqualP[0*Nanometer]]>0,
            (*we're good, but also need to make sure that resolvedAbsorbance wavelength isn't just a singelton*)
            {wavelengthResolution,MatchQ[resolvedAbsorbanceWavelength,GreaterP[0*Nanometer]],False},
            (*otherwise, we need to find the closest value in our array*)
            {First@MinimalBy[possibleWavelengthResolutions,Abs[#-wavelengthResolution]&],MatchQ[resolvedAbsorbanceWavelength,GreaterP[0*Nanometer]],True}
          ]
        ];

        (*return everything*)
        {
          resolvedAbsorbanceWavelength,
          resolvedWavelengthResolution,
          resolvedUVFilter,
          resolvedAbsorbanceSamplingRate,
          wavelengthResolutionConflictQ,
          roundedSamplingRateQ,
          roundedResolutionQ
        }
      ]],{absorbanceWavelengths,wavelengthResolutions,uvFilters,absorbanceSampleRates}
      ]
    ]

    ]],
    {
      Lookup[expandedStandardOptions,{StandardAbsorbanceWavelength,StandardWavelengthResolution,StandardUVFilter,StandardAbsorbanceSamplingRate}],
      Lookup[expandedBlankOptions,{BlankAbsorbanceWavelength,BlankWavelengthResolution,BlankUVFilter,BlankAbsorbanceSamplingRate}],
      Lookup[expandedColumnPrimeOptions,{ColumnPrimeAbsorbanceWavelength,ColumnPrimeWavelengthResolution,ColumnPrimeUVFilter,ColumnPrimeAbsorbanceSamplingRate}],
      Lookup[expandedColumnFlushOptions,{ColumnFlushAbsorbanceWavelength,ColumnFlushWavelengthResolution,ColumnFlushUVFilter,ColumnFlushAbsorbanceSamplingRate}]
    }
  ];

  (*do the error check from the option absorbance detector option resolution*)
  (*rate options*)
  absorbanceRateOptions={AbsorbanceSamplingRate,StandardAbsorbanceSamplingRate,BlankAbsorbanceSamplingRate,ColumnPrimeAbsorbanceSamplingRate,ColumnFlushAbsorbanceSamplingRate};

  (*find which options were offending*)
  roundedSamplingRateRoundingBool=(Or@@#&)/@{roundedSamplingSampleRateBool,roundedSamplingStandardRateBool,roundedSamplingBlankRateBool,roundedSamplingColumnPrimeRateBool,roundedSamplingColumnFlushRateBool};

  roundedSamplingRateRoundingOptions=PickList[absorbanceRateOptions,roundedSamplingRateRoundingBool];

  If[Length[roundedSamplingRateRoundingOptions]>0&&messagesQ,
    Message[Warning::AbsorbanceRateAdjusted,ObjectToString[roundedSamplingRateRoundingOptions]]
  ];

  (*do the same with the *)
  roundedWavelengthResolutionBool=(Or@@#&)/@{roundedWavelengthSampleResolutionBool,roundedWavelengthStandardResolutionBool,roundedWavelengthBlankResolutionBool,roundedWavelengthColumnPrimeResolutionBool,roundedWavelengthColumnFlushResolutionBool};

  roundedWavelengthResolutionBoolOptions=PickList[wavelengthResolutionOptions,roundedWavelengthResolutionBool];

  If[Length[roundedWavelengthResolutionBoolOptions]>0&&messagesQ,
    Message[Warning::WavelengthResolutionAdjusted,ObjectToString[roundedWavelengthResolutionBoolOptions]]
  ];


  (*check for a conflict between the wavelength resolution and absorbance wavelength*)
  wavelengthResolutionConflictBool=(Or@@#&)/@{wavelengthResolutionSampleConflictBool,wavelengthResolutionStandardConflictBool,wavelengthResolutionBlankConflictBool,wavelengthResolutionColumnPrimeConflictBool,wavelengthResolutionColumnFlushConflictBool};

  wavelengthResolutionConflictOptions=PickList[wavelengthResolutionOptions,wavelengthResolutionConflictBool];

  If[Length[wavelengthResolutionConflictOptions]>0&&messagesQ,
    Message[Error::WavelengthResolutionConflict,ObjectToString[wavelengthResolutionConflictOptions]]
  ];

  wavelengthResolutionConflictTests=If[Length[wavelengthResolutionConflictOptions]>0,
    testOrNull["If WavelengthResolution, StandardWavelengthResolution, BlankWavelengthResolution, ColumnPrimeWavelengthResolution, and/or ColumnFlushWavelengthResolution are specified, they are compatible to the corresponding _AbsorbanceWavelength specification:",True],
    testOrNull["If WavelengthResolution, StandardWavelengthResolution, BlankWavelengthResolution, ColumnPrimeWavelengthResolution, and/or ColumnFlushWavelengthResolution are specified, they are compatible to the corresponding _AbsorbanceWavelength specification:",False]
  ];

  (* resolve the Email option if Automatic *)
  resolvedEmail = If[!MatchQ[Lookup[roundedOptionsAssociation,Email], Automatic],
    (* If Email!=Automatic, use the supplied value *)
    Lookup[roundedOptionsAssociation,Email],
    (* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
    If[And[TrueQ[Lookup[roundedOptionsAssociation,Upload]], MemberQ[outputSpecification, Result]],
      True,
      False
    ]
  ];

  (*do the required aliquot resolution*)
  (* Extract shared options relevant for aliquotting *)
  aliquotOptions = KeySelect[samplePrepOptions,And[MatchQ[#,Alternatives@@ToExpression[Options[AliquotOptions][[All,1]]]],MemberQ[Keys[samplePrepOptions],#]]&];

  (* The containers that wil fit on the instrument's autosampler *)
  namedCompatibleContainers = {Model[Container, Plate, "96-well 2mL Deep Well Plate"],Model[Container, Vessel, "HPLC vial (high recovery)"]};

  (* Extract list of bools *)
  specifiedAliquotBools = Lookup[aliquotOptions,Aliquot];

  (*get the instrument autosampler deck*)
  autosamplerDeckModel=Lookup[specifiedInstrumentModelPacket,AutosamplerDeckModel];

  (*get all of the associated racks with the instrument*)
  availableAutosamplerRacks=List[Model[Container, Rack, "Waters Acquity UPLC Autosampler Rack"]];

  (* If the sample's container model is not compatible with the instrument,
  it will not be possible to run the samples. *)
  (* TODO this seems like it must be super slow; figure out a way to not map like this *)
  invalidContainerModelBools = Map[
    (*check if we have plate, if so, check if it can fit on the autosampler*)
    Function[{currentContainer}, If[MatchQ[currentContainer,ObjectP[Model[Container,Plate]]],
      !CompatibleFootprintQ[autosamplerDeckModel,currentContainer,ExactMatch->False,Cache->cache,Simulation -> updatedSimulation],
      (*otherwise, see if it fits into no rack*)
      Not[Or@@Map[CompatibleFootprintQ[#,currentContainer,ExactMatch->False,Cache->cache,Simulation -> updatedSimulation]&,availableAutosamplerRacks]]
    ]],
    simulatedSampleContainerModels
  ];

  (* Extract all samples that could be aliquotted (ie: definitely cannot be aliquotted) *)
  (* NOTE: this doesnt consider samples that are aliquotted and NOT consolidated.. Therefore the number could be higher! *)
  uniqueAliquotableSamples = DeleteDuplicates@PickList[simulatedSamples,specifiedAliquotBools,True|Automatic];

  (* Find containers for samples that definitely cannot be aliquoted *)
  uniqueNonAliquotablePlates = DeleteDuplicates@Cases[
    PickList[simulatedSampleContainers,specifiedAliquotBools,False],
    ObjectP[Object[Container,Plate]]
  ];
  uniqueNonAliquotableVessels = DeleteDuplicates@Cases[
    PickList[simulatedSampleContainers,specifiedAliquotBools,False],
    ObjectP[Object[Container,Vessel]]
  ];

  (* Since checks for too-many-samples could depend on how many standard and blank
  containers will be required, we need to determine these container counts based
  on how many standards/blanks exist, their injection volumes, and injection frequency.
  Standards/blanks specified by models may have to run across multiple containers if
  their total injection volume is greater than the max volume of the default standard/blank
  container. *)

  (* Define the default container used for standards/blanks *)
  defaultStandardBlankContainer = Model[Container, Vessel, "HPLC vial (high recovery)"];

  (* Fetch the max volume of the standard/blank container *)
  standardBlankContainerMaxVolume = Lookup[fetchPacketFromCache[defaultStandardBlankContainer,cache],MaxVolume];

  (* Define the max useable volume in the standard/blank containers when considering dead volume *)
  standardBlankSampleMaxVolume = (standardBlankContainerMaxVolume - autosamplerDeadVolume);

  (*get the columns of the injection table pertinent for this resolution*)
  standardInjectionVolumeTuples=Cases[resolvedInjectionTable,{Standard,___}][[All,{2,3}]];
  blankInjectionVolumeTuples=Cases[resolvedInjectionTable,{Blank,___}][[All,{2,3}]];

  (* Gather tuples of standard/blank and its injection volume by the standard model/sample requested.
  In the form {{{standard1, volume1}, {standard1, volume2}, {standard1, volume3}}, {{standard2, volume1}}..} *)
  {gatheredStandardInjectionTuples,gatheredBlankInjectionTuples} = Map[
    GatherBy[#,First]&,
    {standardInjectionVolumeTuples,blankInjectionVolumeTuples}
  ];

  (* Group each set of tuples of a given standard/blank into sets whose total injection volume
  is less than the max useable volume of the standard/blank container. Output partitions will
  be in the form: {{{standard1, volume1}, {standard1, volume2}}, {{standard1, volume2}}, {{standard2, volume3}}..}
  where volume1+volume2 <= max volume but volume1+volume2+volume3 > max volume (therefore volume3 spills
  over into another container) *)
  {standardPartitions,blankPartitions} = Map[
    (Join@@(GroupByTotal[Replace[#[[All,2]],Null -> 0 Microliter,{1}],standardBlankSampleMaxVolume]&/@#))&,
    {gatheredStandardInjectionTuples,gatheredBlankInjectionTuples}
  ];

  (* The number of standard container we'll require is the number of partitions *)
  numberOfStandardBlankContainersRequired = Length[Join[standardPartitions,blankPartitions]];

  (* see if we have a valid number*)
  (* Waters has room for:
      - 96 vials, 0 plates
      - 48 vials, 1 plate
      (One vial rack is reserved for standards & blanks) *)
  validContainerCountQ = Or[
    (* If non-aliquotable samples and aliquotable samples exist, the non-aliquotable samples
    must be in at-most 1 plate and the aliquotable samples must be already- in or transferred to vials,
    therefore there must be <= (48 - number of standard vials - number of blank vials - non aliquotable vials) *)
    And[
      Length[uniqueNonAliquotablePlates] <= 1,
      Length[uniqueAliquotableSamples] <= (48 - numberOfStandardBlankContainersRequired - Length[uniqueNonAliquotableVessels])
    ],
    (* If non-aliquotable samples are all in vials, then the number of aliquottable samples must fit in 1 plate *)
    And[Length[uniqueNonAliquotablePlates] == 0, Length[uniqueAliquotableSamples] <= 96]
  ];


  (* Build test for container count validity *)
  containerCountTest = If[!validContainerCountQ,
    (
      If[messagesQ,
        Message[Error::HPLCTooManySamples]
      ];
      testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:",False]
    ),
    testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:",True]
  ];

  invalidContainerCountSamples=If[!validContainerCountQ,mySamples,{}];

  (*  if sample plate count >1, aliquot.
  We're already throwing an error if the container count is invalid so we know we can just blindly
  flip all Aliquot -> Automatic to True if Aliquot is needed to make the samples fit.

  If the container count is invalid, don't modify any values *)
  preresolvedAliquotBools = If[
    And[
      validContainerCountQ,
      Length[DeleteDuplicates[simulatedSampleContainers]] > 1
    ],
    Replace[specifiedAliquotBools,Automatic->True,{1}],
    specifiedAliquotBools
  ];

  (* Enforce that _if_ AliquotContainer is specified, they are compatible *)
  validAliquotContainerBools = MapThread[
    Function[{aliquotQ,aliquotContainer},
      Or[
        (* If Aliquot is not explicitly False, we don't need this check *)
        MatchQ[Lookup[aliquotOptions,Aliquot],False],
        (*otherwise, check on the specific aliquot container*)
        Switch[aliquotContainer,
          Except[ObjectP[]],True,
          ObjectP[Model[Container,Plate]],CompatibleFootprintQ[autosamplerDeckModel,aliquotContainer,ExactMatch->False,Cache->cache],
          _,Or@@Map[CompatibleFootprintQ[#,aliquotContainer,ExactMatch->False,Cache->cache]&,availableAutosamplerRacks]
        ]
      ]
    ],
    {specifiedAliquotBools,Lookup[aliquotOptions,AliquotContainer]}
  ];

  validAliquotContainerOptions=If[!(And@@validAliquotContainerBools),{AliquotContainer},{}];

  (* Build test for aliquot container specification validity *)
  validAliquotContainerTest = If[!(And@@validAliquotContainerBools),
    (
      If[messagesQ,
        Message[Error::HPLCIncompatibleAliquotContainer,ObjectToString/@namedCompatibleContainers]
      ];
      testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:",False]
    ),
    testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:",True]
  ];

  allAliquotOptionValues=Values[aliquotOptions];

      (* Build list of booleans representing if an aliquot option is specified explicitly *)
  aliquotOptionSpecifiedBools = Map[
    MemberQ[allAliquotOptionValues,Except[ListableP[Automatic|Null]]]&,
    Transpose[Values[KeyDrop[aliquotOptions,{ConsolidateAliquots,AliquotPreparation}]]]
  ];

  (* If Aliquot option is not specifically set to False, we may need to use the aliquotting system to move them *)
  resolvedAliquotContainers = Map[
    If[TrueQ[#],
      Model[Container,Plate,"96-well 2mL Deep Well Plate"],
      Null
    ]&,
    invalidContainerModelBools
  ];


  (* If we end up aliquoting and AliquotAmount is not specified, it is possible we need to force
  AliquotVolume to be the appropriate InjectionVolume. *)
  requiredAliquotVolumes = MapThread[
    Function[
      {samplePacket,injectionVolume},
      Which[
        MatchQ[injectionVolume,VolumeP],
        (* Distribute autosampler dead volume across all instances of an identical aliquots *)
        injectionVolume + (autosamplerDeadVolume/Count[Download[mySamples,Object],Lookup[samplePacket,Object]]),
        True,25 Microliter
      ]
    ],
    {
      samplePackets,
      resolvedInjectionVolumes
    }
  ];

  (* Combine all options we've "pre-resolved" *)
  preresolvedAliquotOptions = Append[
    aliquotOptions,
    {
      Aliquot -> preresolvedAliquotBools,
      ConsolidateAliquots -> True
    }
  ];

  (* Resolve aliquot options. Since we want the samples packed as
  tightly as possible, put them all in a single target grouping *)
  {resolveAliquotOptionsResult,resolveAliquotOptionTests} = If[gatherTestsQ,
    Quiet[resolveAliquotOptions[
      ExperimentSupercriticalFluidChromatography,
      mySamples,
      simulatedSamples,
      ReplaceRule[Normal@preresolvedAliquotOptions,resolvedSamplePrepOptions],
      RequiredAliquotAmounts -> requiredAliquotVolumes,
      RequiredAliquotContainers -> resolvedAliquotContainers,
      AliquotWarningMessage -> "because the given samples are not in containers that are compatible with SupercriticalFluidChromatography instruments.",
      Output -> {Result,Tests},
      Cache -> cache,
      Simulation->updatedSimulation
    ],{Warning::InstrumentPrecision}],
    {
      Quiet[resolveAliquotOptions[
        ExperimentSupercriticalFluidChromatography,
        mySamples,
        simulatedSamples,
        ReplaceRule[Normal@preresolvedAliquotOptions,resolvedSamplePrepOptions],
        RequiredAliquotAmounts -> requiredAliquotVolumes,
        RequiredAliquotContainers -> resolvedAliquotContainers,
        AliquotWarningMessage -> "because the given samples are not in containers that are compatible with SupercriticalFluidChromatography instruments.",
        Cache -> cache,
        Simulation->updatedSimulation
      ],{Warning::InstrumentPrecision}],
      {}
    }
  ];

    (* If none of our aliquot booleans are turned on, turn off the ConsolidateAliquots option (we turned it on manually). *)
  resolvedAliquotOptions=If[MatchQ[Lookup[resolveAliquotOptionsResult,Aliquot],{False...}|False],
      resolveAliquotOptionsResult/.{
        (ConsolidateAliquots->_):>(ConsolidateAliquots->Null)
      },
      resolveAliquotOptionsResult
    ];

  (* collect invalid storage condition option using helper function *)
  specifiedSampleStorageCondition=Lookup[supercriticalFluidChromatographyOptionsAssociation,SamplesInStorageCondition];
  validSampleStorageConditionQ=If[!MatchQ[specifiedSampleStorageCondition,ListableP[Automatic|Null]],
    If[messagesQ,
      ValidContainerStorageConditionQ[mySamples,specifiedSampleStorageCondition, Simulation -> updatedSimulation],
      Quiet[ValidContainerStorageConditionQ[mySamples,specifiedSampleStorageCondition, Simulation -> updatedSimulation]]
    ],
    True
  ];

  (* if the test above passes, there's no invalid option, otherwise, SamplesInStorageCondition will be an invalid option *)
  invalidStorageConditionOptions=If[Not[And@@validSampleStorageConditionQ],
    {SamplesInStorageCondition},
    {}
  ];

  (* generate test for storage condition *)
  invalidStorageConditionTest=testOrNull["The specified SamplesInStorageCondition can be filled for sample in a particular container or for samples sharing a container:",And@@validSampleStorageConditionQ,True];


  (* Set all non-shared Experiment options to be resolved *)
  resolvedExperimentOptions=Association[
    Instrument->Lookup[roundedOptionsAssociation,Instrument],
    Scale->Lookup[roundedOptionsAssociation,Scale],
    SeparationMode->Lookup[roundedOptionsAssociation,SeparationMode],
    Detector->Lookup[roundedOptionsAssociation,Detector],
    Column->resolvedColumn,
    ColumnSelector->resolvedColumnSelector,
    ColumnTemperature->resolvedColumnTemperatures,
    ColumnOrientation->resolvedColumnOrientation,
    NumberOfReplicates->Lookup[roundedOptionsAssociation,NumberOfReplicates],
    CosolventA->resolvedCosolventA,
    CosolventB->resolvedCosolventB,
    CosolventC->resolvedCosolventC,
    CosolventD->resolvedCosolventD,
    InjectionTable->resolvedInjectionTable,
    SampleTemperature->Lookup[roundedOptionsAssociation,SampleTemperature],
    InjectionVolume->resolvedInjectionVolumes,
    NeedleWashSolution->Lookup[roundedOptionsAssociation,NeedleWashSolution],
    CO2Gradient->resolvedCO2Gradients,
    GradientA->resolvedGradientAs,
    GradientB->resolvedGradientBs,
    GradientC->resolvedGradientCs,
    GradientD->resolvedGradientDs,
    FlowRate->resolvedFlowRates,
    MaxAcceleration->Lookup[roundedOptionsAssociation,MaxAcceleration],
    GradientStart->resolvedGradientStarts,
    GradientEnd->resolvedGradientEnds,
    GradientDuration->resolvedGradientDurations,
    EquilibrationTime->resolvedEquilibrationTimes,
    FlushTime->resolvedFlushTimes,
    Gradient->resolvedGradients,
    BackPressure->resolvedBackPressures,
    IonMode->resolvedIonModes,
    MakeupSolvent->Lookup[roundedOptionsAssociation,MakeupSolvent],
    Calibrant->Lookup[roundedOptionsAssociation,Calibrant],
    MakeupFlowRate->resolvedMakeupFlowRates,
    MassDetection->resolvedMassDetections,
    ScanTime->resolvedScanTimes,
    ProbeTemperature->resolvedProbeTemperatures,
    ESICapillaryVoltage->resolvedESICapillaryVoltages,
    SamplingConeVoltage->resolvedSamplingConeVoltages,
    MassDetectionGain->resolvedMassDetectionGains,
    AbsorbanceWavelength->resolvedAbsorbanceWavelengths,
    WavelengthResolution->resolvedWavelengthResolutions,
    UVFilter->resolvedUVFilters,
    AbsorbanceSamplingRate->resolvedAbsorbanceSamplingRates,
    Standard-> If[standardExistsQ,resolvedStandard],
    StandardInjectionVolume->resolvedStandardInjectionVolumes,
    StandardFrequency->resolvedStandardFrequency,
    StandardColumn->resolvedStandardColumn,
    StandardColumnTemperature->resolvedStandardColumnTemperatures,
    StandardCO2Gradient->resolvedStandardCO2Gradients,
    StandardGradientA->resolvedStandardGradientAs,
    StandardGradientB->resolvedStandardGradientBs,
    StandardGradientC->resolvedStandardGradientCs,
    StandardGradientD->resolvedStandardGradientDs,
    StandardFlowRate->resolvedStandardFlowRates,
    StandardGradient->resolvedStandardGradients,
    StandardBackPressure->resolvedStandardBackPressures,
    StandardIonMode->resolvedStandardIonModes,
    StandardMakeupFlowRate->resolvedStandardMakeupFlowRates,
    StandardMassDetection->resolvedStandardMassDetections,
    StandardScanTime->resolvedStandardScanTimes,
    StandardProbeTemperature->resolvedStandardProbeTemperatures,
    StandardESICapillaryVoltage->resolvedStandardESICapillaryVoltages,
    StandardSamplingConeVoltage->resolvedStandardSamplingConeVoltages,
    StandardMassDetectionGain->resolvedStandardMassDetectionGains,
    StandardAbsorbanceWavelength->resolvedStandardAbsorbanceWavelengths,
    StandardWavelengthResolution->resolvedStandardWavelengthResolutions,
    StandardUVFilter->resolvedStandardUVFilters,
    StandardAbsorbanceSamplingRate->resolvedStandardAbsorbanceSamplingRates,
    StandardStorageCondition->Lookup[roundedOptionsAssociation,StandardStorageCondition],
    Blank-> If[blankExistsQ,resolvedBlank],
    BlankInjectionVolume->resolvedBlankInjectionVolumes,
    BlankFrequency->resolvedBlankFrequency,
    BlankColumn->resolvedBlankColumn,
    BlankColumnTemperature->resolvedBlankColumnTemperatures,
    BlankCO2Gradient->resolvedBlankCO2Gradients,
    BlankGradientA->resolvedBlankGradientAs,
    BlankGradientB->resolvedBlankGradientBs,
    BlankGradientC->resolvedBlankGradientCs,
    BlankGradientD->resolvedBlankGradientDs,
    BlankFlowRate->resolvedBlankFlowRates,
    BlankGradient->resolvedBlankGradients,
    BlankBackPressure->resolvedBlankBackPressures,
    BlankIonMode->resolvedBlankIonModes,
    BlankMakeupFlowRate->resolvedBlankMakeupFlowRates,
    BlankMassDetection->resolvedBlankMassDetections,
    BlankScanTime->resolvedBlankScanTimes,
    BlankProbeTemperature->resolvedBlankProbeTemperatures,
    BlankESICapillaryVoltage->resolvedBlankESICapillaryVoltages,
    BlankSamplingConeVoltage->resolvedBlankSamplingConeVoltages,
    BlankMassDetectionGain->resolvedBlankMassDetectionGains,
    BlankAbsorbanceWavelength->resolvedBlankAbsorbanceWavelengths,
    BlankWavelengthResolution->resolvedBlankWavelengthResolutions,
    BlankUVFilter->resolvedBlankUVFilters,
    BlankAbsorbanceSamplingRate->resolvedBlankAbsorbanceSamplingRates,
    BlankStorageCondition->Lookup[roundedOptionsAssociation,BlankStorageCondition],
    ColumnRefreshFrequency->resolvedColumnRefreshFrequency,
    ColumnPrimeColumnTemperature->resolvedPrimeColumnTemperatures,
    ColumnPrimeCO2Gradient->resolvedColumnPrimeCO2Gradients,
    ColumnPrimeGradientA->resolvedColumnPrimeGradientAs,
    ColumnPrimeGradientB->resolvedColumnPrimeGradientBs,
    ColumnPrimeGradientC->resolvedColumnPrimeGradientCs,
    ColumnPrimeGradientD->resolvedColumnPrimeGradientDs,
    ColumnPrimeFlowRate->resolvedColumnPrimeFlowRates,
    ColumnPrimeGradientDuration->Lookup[roundedOptionsAssociation,ColumnPrimeGradientDuration],
    ColumnPrimeGradient->resolvedColumnPrimeGradients,
    ColumnPrimeBackPressure->resolvedColumnPrimeBackPressures,
    ColumnPrimeIonMode->resolvedColumnPrimeIonModes,
    ColumnPrimeMakeupFlowRate->resolvedColumnPrimeMakeupFlowRates,
    ColumnPrimeMassDetection->resolvedColumnPrimeMassDetections,
    ColumnPrimeScanTime->resolvedColumnPrimeScanTimes,
    ColumnPrimeProbeTemperature->resolvedColumnPrimeProbeTemperatures,
    ColumnPrimeESICapillaryVoltage->resolvedColumnPrimeESICapillaryVoltages,
    ColumnPrimeSamplingConeVoltage->resolvedColumnPrimeSamplingConeVoltages,
    ColumnPrimeMassDetectionGain->resolvedColumnPrimeMassDetectionGains,
    ColumnPrimeAbsorbanceWavelength->resolvedColumnPrimeAbsorbanceWavelengths,
    ColumnPrimeWavelengthResolution->resolvedColumnPrimeWavelengthResolutions,
    ColumnPrimeUVFilter->resolvedColumnPrimeUVFilters,
    ColumnPrimeAbsorbanceSamplingRate->resolvedColumnPrimeAbsorbanceSamplingRates,
    ColumnFlushColumnTemperature->resolvedFlushColumnTemperatures,
    ColumnFlushCO2Gradient->resolvedColumnFlushCO2Gradients,
    ColumnFlushGradientA->resolvedColumnFlushGradientAs,
    ColumnFlushGradientB->resolvedColumnFlushGradientBs,
    ColumnFlushGradientC->resolvedColumnFlushGradientCs,
    ColumnFlushGradientD->resolvedColumnFlushGradientDs,
    ColumnFlushFlowRate->resolvedColumnFlushFlowRates,
    ColumnFlushGradientDuration->Lookup[roundedOptionsAssociation,ColumnFlushGradientDuration],
    ColumnFlushGradient->resolvedColumnFlushGradients,
    ColumnFlushBackPressure->resolvedColumnFlushBackPressures,
    ColumnFlushIonMode->resolvedColumnFlushIonModes,
    ColumnFlushMakeupFlowRate->resolvedColumnFlushMakeupFlowRates,
    ColumnFlushMassDetection->resolvedColumnFlushMassDetections,
    ColumnFlushScanTime->resolvedColumnFlushScanTimes,
    ColumnFlushProbeTemperature->resolvedColumnFlushProbeTemperatures,
    ColumnFlushESICapillaryVoltage->resolvedColumnFlushESICapillaryVoltages,
    ColumnFlushSamplingConeVoltage->resolvedColumnFlushSamplingConeVoltages,
    ColumnFlushMassDetectionGain->resolvedColumnFlushMassDetectionGains,
    ColumnFlushAbsorbanceWavelength->resolvedColumnFlushAbsorbanceWavelengths,
    ColumnFlushWavelengthResolution->resolvedColumnFlushWavelengthResolutions,
    ColumnFlushUVFilter->resolvedColumnFlushUVFilters,
    ColumnFlushAbsorbanceSamplingRate->resolvedColumnFlushAbsorbanceSamplingRates,
    Cache->Lookup[roundedOptionsAssociation,Cache],
    FastTrack->Lookup[roundedOptionsAssociation,FastTrack],
    Template->Lookup[roundedOptionsAssociation,Template],
    ParentProtocol->Lookup[roundedOptionsAssociation,ParentProtocol],
    Operator->Lookup[roundedOptionsAssociation,Operator],
    Confirm->Lookup[roundedOptionsAssociation,Confirm],
    CanaryBranch->Lookup[roundedOptionsAssociation,CanaryBranch],
    Name->Lookup[roundedOptionsAssociation,Name],
    Upload->Lookup[roundedOptionsAssociation,Upload],
    Output->Lookup[roundedOptionsAssociation,Output],
    Email->resolvedEmail
  ];

  (*-- UNRESOLVABLE OPTION CHECKS --*)

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)

  invalidInputs=DeleteDuplicates[Flatten[{discardedSamples,containerlessSamples,invalidContainerCountSamples}]];

  invalidOptions=DeleteDuplicates[Flatten[{
    invalidInstrumentOption,
    invalidStandardBlankOptions,
    foreignSamplesOptions,
    columnSelectorConflictOptions,
    tableColumnConflictOptions,
    selectorInjectionTableConflictOptions,
    gradientStartEndSpecifiedAdverselyOptions,
    gradientInjectionTableSpecifiedDifferentlyOptions,
    invalidGradientCompositionOptions,
    injectionTableCO2PressureOptions,
    nonBinaryCompositionOptions,
    gradientShortcutOptions,
    wavelengthResolutionConflictOptions,
    multipleGradientsColumnPrimeFlushOptions,
    validAliquotContainerOptions,
    invalidInjectionTableOptions,
    invalidStorageConditionOptions,
    compatibleMaterialsInvalidOption
  }]];

  (*combine all of the tests*)
  allTests=Flatten@{
    allRoundingTests,
    containersExistTest,
    validNameTest,
    retiredInstrumentTest,
    invalidStandardBlankTests,
    foreignSamplesTest,
    columnSelectorConflictTest,
    tableColumnConflictTest,
    selectorInjectionTableConflictTest,
    gradientStartEndSpecifiedAdverselyTest,
    gradientInjectionTableSpecifiedDifferentlyTest,
    invalidGradientCompositionTest,
    injectionTableCO2PressureTest,
    wavelengthResolutionConflictTests,
    nonBinaryCompositionTest,
    gradientStartEndAConflictTests,
    gradientStartEndAConflictTests,
    containerCountTest,
    validAliquotContainerTest,
    resolveAliquotOptionTests,
    incompatibleSamplesTest,
    multipleGradientsColumnPrimeFlushTest,
    invalidInjectionTableTests,
    invalidStorageConditionTest
  };

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation -> updatedSimulation]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (*-- CONTAINER GROUPING RESOLUTION --*)

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

  (* Join all resolved options *)
  resolvedOptions = Normal@Join[
    roundedOptionsAssociation,
    resolvedExperimentOptions,
    Association@resolvedSamplePrepOptions,
    Association@resolvedAliquotOptions,
    Association@resolvedPostProcessingOptions
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Flatten[{}]
  }
];



(* ::Subsection:: *)
(*sfcResourcePackets*)


(* ::Subsubsection:: *)
(*sfcResourcePackets*)


DefineOptions[
  sfcResourcePackets,
  Options:>{OutputOption,CacheOption,SimulationOption}
];


sfcResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},ops:OptionsPattern[sfcResourcePackets]]:=Module[
  {
    outputSpecification,output,gatherTests,messages,numReplicates,protocolPacket,sharedFieldPacket,finalizedPacket,
    allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,samplesWithReplicates,optionsWithReplicates,totalRunTime,
    unCollapsedResolvedOptions,uniqueGradientPackets, allPackets, injectionTable,instrumentModel, instrumentModelPacket,
    systemPrimeGradientMethod, systemFlushGradientMethod, systemPrimeGradientPacket, systemFlushGradientPacket, systemPrimeBufferContainer,
    systemFlushBufferContainer, bufferDeadVolume,systemPrimeGradient, systemFlushGradient,systemPrimeMakeupSolventResource,
    systemPrimeBufferAVolume,systemPrimeBufferBVolume,systemPrimeBufferCVolume,systemPrimeBufferDVolume,mappingGradientTuple,
    cosolventAmodel,cosolventBmodel,cosolventCmodel,cosolventDmodel,uniqueSamplePackets, sampleContainers, uniquePlateContainers,
    systemPrimeCosolventAResource,systemPrimeCosolventBResource,systemPrimeCosolventCResource,systemPrimeCosolventDResource,
    uniqueSamples,uniqueSampleResources,sampleResources,samplePositions, sampleTuples, insertionAssociation, injectionTableInserted, injectionTableWithReplicates,
    systemFlushBufferAVolume,systemFlushBufferBVolume,systemFlushBufferCVolume,systemFlushBufferDVolume,innerTimes,
    tableGradients,sampleGradient,standardGradient,blankGradient,columnPrimeGradient,columnFlushGradient,
    resolvedGradients,gradientMethodInPlace,gradientObjectsToMake,injectionTableFull,cache,bufferContainer,
    systemFlushBufferAResource,systemFlushBufferBResource,systemFlushBufferCResource,systemFlushBufferDResource,
    systemFlushMakeupSolventResource,columns,standardColumns,blankColumns,columnResources,standardColumnResources,blankColumnResources,
    columnSelector,columnSelectorResources,standardPositions,blankPositions,columnPrimePositions,columnFlushPositions,
    standardLookup,blankLookup,standardMappingAssociation,blankMappingAssociation,columnPrimeMappingAssociation,columnFlushMappingAssociation,
    standardReverseAssociation,blankReverseAssociation,columnPrimeReverseAssociation,columnFlushReverseAssociation,
    columnPrimeColumns,columnFlushColumns,columnPrimeResources,columnFlushResources,sampleReverseAssociation,
    vialSampleMaxVolume,vialDeadVolume,preferredVialContainer,standardTuples,assignedStandardTuples,groupedStandardsTuples,
    groupedStandardsPositionVolumes,groupedStandardShared,groupedStandard,flatStandardResources,linkedStandardResources,
    blankTuples,assignedBlankTuples,groupedBlanksTuples,linkedSampleResources,injectionTableWithLinks,
    groupedBlanksPositionVolumes,groupedBlankShared,groupedBlank,flatBlankResources,linkedBlankResources,
    standardPositionsCorresponded,blankPositionsCorresponded,columnPrimePositionsCorresponded,columnFlushPositionsCorresponded,
    columnPrimeCO2Gradient, columnPrimeGradientA, columnPrimeGradientB, columnPrimeGradientC, columnPrimeGradientD, columnPrimeBackPressure,
    columnPrimeFlowRates, columnPrimeTemperatures, columnPrimeIonModes, columnPrimeMakeupFlowRates, columnPrimeProbeTemperatures,
    columnPrimeESICapillaryVoltages, columnPrimeSamplingConeVoltages, columnPrimeScanTimes, columnPrimeMassDetectionGains,
    columnPrimeWavelengthResolutions, columnPrimeUVFilter, columnPrimeAbsorbanceSamplingRates,
    sampleCO2Gradient, sampleGradientA, sampleGradientB, sampleGradientC, sampleGradientD, sampleBackPressure, sampleFlowRates,
    sampleColumnTemperatures, sampleIonModes, sampleMakeupFlowRates, sampleProbeTemperatures, sampleESICapillaryVoltages, sampleSamplingConeVoltages,
    sampleScanTimes, sampleMassDetectionGains, sampleWavelengthResolutions, sampleUVFilter, sampleAbsorbanceSamplingRates,
    standardCO2Gradient, standardGradientA, standardGradientB, standardGradientC, standardGradientD, standardBackPressure, standardFlowRates,
    standardTemperatures, standardIonModes, standardMakeupFlowRates, standardProbeTemperatures, standardESICapillaryVoltages, standardSamplingConeVoltages,
    standardScanTimes, standardMassDetectionGains, standardWavelengthResolutions, standardUVFilter, standardAbsorbanceSamplingRates,
    blankCO2Gradient, blankGradientA, blankGradientB, blankGradientC, blankGradientD, blankBackPressure, blankFlowRates, blankTemperatures,
    blankIonModes, blankMakeupFlowRates, blankProbeTemperatures, blankESICapillaryVoltages, blankSamplingConeVoltages, blankScanTimes,
    blankMassDetectionGains, blankWavelengthResolutions, blankUVFilter, blankAbsorbanceSamplingRates,
    columnFlushCO2Gradient, columnFlushGradientA, columnFlushGradientB, columnFlushGradientC, columnFlushGradientD, columnFlushBackPressure,
    columnFlushFlowRates, columnFlushTemperatures, columnFlushIonModes, columnFlushMakeupFlowRates, columnFlushProbeTemperatures,
    columnFlushESICapillaryVoltages, columnFlushSamplingConeVoltages, columnFlushScanTimes, columnFlushMassDetectionGains, columnFlushWavelengthResolutions,
    columnFlushUVFilter, columnFlushAbsorbanceSamplingRates,columnPrimeMinMasses,columnPrimeMaxMasses,columnPrimeMassSelections,
    sampleMinMasses,sampleMaxMasses,sampleMassSelections, standardMinMasses,standardMaxMasses,standardMassSelections, blankMinMasses,
    blankMaxMasses,blankMassSelections, columnFlushMinMasses,columnFlushMaxMasses,columnFlushMassSelections,
    columnPrimeAbsorbanceSelection, columnPrimeMinAbsorbanceWavelengths, columnPrimeMaxAbsorbanceWavelengths,
    sampleAbsorbanceSelection, sampleMinAbsorbanceWavelengths, sampleMaxAbsorbanceWavelengths,
    standardAbsorbanceSelection, standardMinAbsorbanceWavelengths, standardMaxAbsorbanceWavelengths,
    blankAbsorbanceSelection, blankMinAbsorbanceWavelengths, blankMaxAbsorbanceWavelengths,injectionTableUploadable,
    columnFlushAbsorbanceSelection, columnFlushMinAbsorbanceWavelengths, columnFlushMaxAbsorbanceWavelengths,
    allMakeupSolvents,makeupSolventVolumes,totalMakeupVolumeNeeded,makeSolventResource,operatorResource,
    cosolventAResource,cosolventBResource,cosolventCResource,cosolventDResource,allGradients,allGradientTuples,
    sampleTimes,standardTimes,blankTimes,columnPrimeTimes,columnFlushTimes,allTimes, columnOrientations, simulation,
    systemPrimeBufferPlacements, systemFlushBufferPlacements,needleWashSolution, externalNeedleWashSolution, needleWashSolutionPlacements
  },

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (*get the cache*)
  cache=Lookup[ToList[ops], Cache, {}];
  simulation=Lookup[ToList[ops], Simulation, Simulation[]];


  (* Pull out the number of replicates; make sure all Nulls become 1 *)
  numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

  (*expand the options based on the number of replicates*)
  {samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentSupercriticalFluidChromatography,(mySamples/.x_Link:>Download[x,Object]),myResolvedOptions];

  (* Delete any duplicate input samples to create a single resource per unique sample *)
  uniqueSamples = DeleteDuplicates[mySamples];

  (* Extract packets for sample objects *)
  uniqueSamplePackets = fetchPacketFromCache[#,cache]&/@Download[uniqueSamples,Object];

  (*get the unique sample containers*)
  sampleContainers = Download[Lookup[uniqueSamplePackets,Container],Object];

  (*get the number of unique plate containers*)
  uniquePlateContainers=DeleteDuplicates[Cases[sampleContainers,ObjectP[Object[Container,Plate]]]];

  (* Create Resource for SamplesIn *)
  uniqueSampleResources = Resource[Sample->#,Name->CreateUUID[]]&/@uniqueSamples;

  (* Expand sample resources to index match mySamples *)
  sampleResources = Map[
    uniqueSampleResources[[First[FirstPosition[uniqueSamples,#]]]]&,
    mySamples
  ];

  (*look up the column for the column selector*)
  columnSelector=Lookup[myResolvedOptions,ColumnSelector];

  (*make the column resources*)
  columnSelectorResources= If[MatchQ[columnSelector, Except[Null | {} | {Null}]], Map[Resource[Sample -> #, Name->CreateUUID[]]&, columnSelector]];

  (*make the column orientation expanded*)
  columnOrientations= If[!NullQ[columnSelector],
    If[Length[ToList@Lookup[optionsWithReplicates,ColumnOrientation]]==Length[columnSelector],
      ToList@Lookup[optionsWithReplicates,ColumnOrientation],
      (*otherwise replicate out*)
      Flatten@ConstantArray[Lookup[optionsWithReplicates,ColumnOrientation], Length[columnSelector]/Length[ToList@Lookup[optionsWithReplicates,ColumnOrientation]]]
    ]
  ];

  (*get the resolved injection table because that will actually determine much that we do here*)
  injectionTable=Lookup[myResolvedOptions,InjectionTable];

  (*get all of the positions so that it's easy to update the injection table*)
  {samplePositions,standardPositions,blankPositions,columnPrimePositions,columnFlushPositions}=Map[
    Sequence@@@Position[injectionTable,{#,___}]&
    ,{Sample,Standard,Blank,ColumnPrime,ColumnFlush}];

  (*look up the standards and the blanks*)
  {standardLookup,blankLookup}=ToList/@Lookup[myResolvedOptions,{Standard,Blank}];

  (*we need to create a mapping association so the index matching from the types goes to the positions with the table
  for example, the resolvedBlank maybe length 2 (e.g. {blank1,blank2}; However this may be repeated in the injectiontable
  based on the set BlankFrequency. For example BlankFrequency -> FirstAndLast will place at the beginning at the end
  therefore, we need to have associations for each that points to the locations within the table so that it's easier to update
  the resources*)

  (*a helper function used to make the reverse dictionary so that we can go from the injection table positon to the other variables*)
  makeReverseAssociation[inputAssociation:Null]:=Null;
  makeReverseAssociation[inputAssociation_Association]:=Association[
    SortBy[Flatten@Map[
      Function[{rule},
        Map[#->First[rule]&,Last[rule]]
        ],Normal@inputAssociation]
      ,First]
  ];

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

  (*for the column prime and flush, it's a bit easier because we can simply considering by the column*)
  columnPrimeMappingAssociation= If[MatchQ[columnSelector, Except[Null | {} | {Null}]],
    Association@MapIndexed[Function[{column, index},
      First[index]->Sequence@@@Position[injectionTable,{ColumnPrime,_,_,ObjectP[column],_}]
    ]
    ,ToList@columnSelector]
  ];

  columnFlushMappingAssociation= If[MatchQ[columnSelector, Except[Null | {} | {Null}]],
    Association@MapIndexed[Function[{column, index},
      First[index]->Sequence@@@Position[injectionTable,{ColumnFlush,_,_,ObjectP[column],_}]
    ]
    ,ToList@columnSelector]
  ];

  (*make the reverse associations*)
  {standardReverseAssociation,blankReverseAssociation,columnPrimeReverseAssociation,columnFlushReverseAssociation}=Map[makeReverseAssociation,
    {standardMappingAssociation,blankMappingAssociation,columnPrimeMappingAssociation,columnFlushMappingAssociation}
  ];

  (*also make the one for the samples*)
  sampleReverseAssociation=Association@MapIndexed[
    Function[{position,index},
      position->First[index]
    ],samplePositions
  ];

  (*we can use this to expand out the various column fields within Columns, StandardColumns, and BlankColumns*)
  {columns,standardColumns,blankColumns,columnPrimeColumns,columnFlushColumns}=Map[Function[{type},
    If[Length[Cases[injectionTable,{type,___}]]>0,
      Cases[injectionTable,{type,___}][[All,4]],
      {}
    ]
  ],{Sample,Standard,Blank,ColumnPrime,ColumnFlush}];

  (*for each one, we want to associate to the corresponding resource*)
  {columnResources,standardColumnResources,blankColumnResources,columnPrimeResources,columnFlushResources}=Map[
    Function[{columnSet},
      Map[
        Link@columnSelectorResources[[First[FirstPosition[columnSelectorResources,#]]]]&,
        columnSet]
    ]
   ,{columns,standardColumns,blankColumns,columnPrimeColumns,columnFlushColumns}];

  (*we need to figure out which gradients to make*)
  (*dereference any named objects*)
  tableGradients=injectionTable[[All,5]]/.{x : ObjectP[Object[Method]] :> Download[x,Object]};

  (*get all of the other gradients and see how many of them are objects*)
  {sampleGradient,standardGradient,blankGradient,columnPrimeGradient,columnFlushGradient}=Lookup[myResolvedOptions,
    {Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient}
  ];

  (*all resolved gradient*)
  resolvedGradients=Join[Cases[{sampleGradient,standardGradient,blankGradient,columnPrimeGradient,columnFlushGradient},Except[Null|{Null}]]];

  (*find all of the gradients where there is already a method*)
  gradientMethodInPlace=Flatten@Cases[resolvedGradients,ListableP[ObjectP[Object[Method]]]];

  (*take the complement of the table gradients and the ones already in place*)
  (*we'll need to create packets for all of these gradient objects*)
  gradientObjectsToMake=Complement[tableGradients,gradientMethodInPlace];

  (*all standards and blanks will be in vials, so we use the same value*)
  vialSampleMaxVolume=1.8 Milliliter;
  vialDeadVolume=50 Microliter;
  preferredVialContainer = Model[Container, Vessel, "HPLC vial (high recovery)"];

  (*now we figure out injected resources*)

  (*get the standard samples out*)
  standardTuples=injectionTable[[standardPositions]];

  (*assign the position to these *)
  assignedStandardTuples=MapThread[#1->#2&,{standardPositions,standardTuples}];

  (*then group by the sample sample type (e.g. <|standard1->{1->{Standard,standard1,10 Microliter,__},2->{Standard,standard1, 5 Microliter,__}}, standard2 ->... |>*)
  groupedStandardsTuples=GroupBy[assignedStandardTuples,Last[#][[2]]&];

  (*then simplify further by selecting out the positoin and the injection volume <|standard1->{{1,10 Microliter},{2,5 Microliter}}*)
  groupedStandardsPositionVolumes=Map[Function[{eachUniqueStandard},
    Transpose[{Keys[eachUniqueStandard],Values[eachUniqueStandard][[All,3]]}]
    ],
    groupedStandardsTuples];

  (*we do a further grouping based on the total injection volume for example: <|Model[Sample, StockSolution, Standard,
   "id:N80DNj1rWzaq"] -> {{{3, Quantity[2, "Microliters"]}}, {{7,  Quantity[2, "Microliters"]}}}, ...|>*)
  groupedStandardShared=Map[GroupByTotal[#,(vialSampleMaxVolume-vialDeadVolume)]&,groupedStandardsPositionVolumes];

  (*huff huff huff... now we can finally make the resources*)
  (*we'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2}*)
  groupedStandard = Map[Function[{rule},
    Sequence@@Map[
      (*this is all of the positions*)
      (#[[All,1]]->
          Resource[
            Sample->First[rule],
            (*total the volume for the given group*)
            Amount->Total[#[[All,2]]]+vialDeadVolume,
            Container->preferredVialContainer,
            Name -> CreateUUID[]
          ])&
      ,Last[rule]
    ]],
    (*convert to a list*)
    Normal@groupedStandardShared];

  (*gasp... now we can flatten this list to our standards, index matched to the samples {1->Resource1, 2->Resource1, ... }*)
  flatStandardResources=SortBy[Map[Function[{rule},
    Sequence@@Map[#->Last[rule]&,First[rule]]
  ],groupedStandard],First];

  (*take the values and surround with link*)
  linkedStandardResources=Map[Link,Values[flatStandardResources]];

  (*now do the same with the blanks*)

  (*get the blank samples out*)
  blankTuples=injectionTable[[blankPositions]];

  (*assign the position to these *)
  assignedBlankTuples=MapThread[#1->#2&,{blankPositions,blankTuples}];

  (*then group by the sample sample type (e.g. <|blank1->{1->{Blank,blank1,10 Microliter,__},2->{Blank,blank1, 5 Microliter,__}}, blank2 ->... |>*)
  groupedBlanksTuples=GroupBy[assignedBlankTuples,Last[#][[2]]&];

  (*then simplify further by selecting out the positoin and the injection volume <|blank1->{{1,10 Microliter},{2,5 Microliter}}*)
  groupedBlanksPositionVolumes=Map[Function[{eachUniqueBlank},
    Transpose[{Keys[eachUniqueBlank],Values[eachUniqueBlank][[All,3]]}]
  ],
    groupedBlanksTuples];

  (*we do a further grouping based on the total injection volume for example: <|Model[Sample, StockSolution,
   "id:N80DNj1rWzaq"] -> {{{3, Quantity[2, "Microliters"]}}, {{7,  Quantity[2, "Microliters"]}}}, ...|>*)
  groupedBlankShared=Map[GroupByTotal[#,(vialSampleMaxVolume-vialDeadVolume)]&,groupedBlanksPositionVolumes];

  (*huff huff huff... now we can finally make the resources*)
  (*we'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2}*)
  groupedBlank = Map[Function[{rule},
    Sequence@@Map[
      (*this is all of the positions*)
      (#[[All,1]]->
          Resource[
            Sample->First[rule],
            (*total the volume for the given group*)
            Amount->Total[#[[All,2]]]+vialDeadVolume,
            Container->preferredVialContainer,
            Name -> CreateUUID[]
          ])&
      ,Last[rule]
    ]],
    (*convert to a list*)
    Normal@groupedBlankShared];

  (*gasp... now we can flatten this list to our blanks, index matched to the samples {1->Resource1, 2->Resource1, ... }*)
  flatBlankResources=SortBy[Map[Function[{rule},
    Sequence@@Map[#->Last[rule]&,First[rule]]
  ],groupedBlank],First];

  (*take the values and surround with link*)
  linkedBlankResources=Map[Link,Values[flatBlankResources]];

  (*now let's update everything within our injection table*)
  linkedSampleResources=Link/@sampleResources;

  (*initialize our injectionTable with links*)
  injectionTableWithLinks=injectionTable;

  (*update all of the samples*)
  injectionTableWithLinks[[samplePositions,2]]=linkedSampleResources;
  injectionTableWithLinks[[standardPositions,2]]=linkedStandardResources;
  injectionTableWithLinks[[blankPositions,2]]=linkedBlankResources;

  (*update all of the columns*)
  injectionTableWithLinks[[samplePositions,4]]=columnResources;
  injectionTableWithLinks[[standardPositions,4]]=standardColumnResources;
  injectionTableWithLinks[[blankPositions,4]]=blankColumnResources;
  injectionTableWithLinks[[columnFlushPositions,4]]=columnFlushResources;
  injectionTableWithLinks[[columnPrimePositions,4]]=columnPrimeResources;

  (*change all of the gradients to links*)
  injectionTableWithLinks[[All,5]]=(Link/@tableGradients);

  (*now let's add the extra columns to the injection table (dilution factor and column temperature*)

  (*to fill in the parameters we just need the injection table positions corresponded to the pertinent ones*)
  standardPositionsCorresponded=If[Length[standardPositions]>0,Last/@SortBy[Normal@standardReverseAssociation,First]];
  blankPositionsCorresponded=If[Length[blankPositions]>0,Last/@SortBy[Normal@blankReverseAssociation,First]];
  columnPrimePositionsCorresponded=If[Length[columnPrimePositions]>0,Last/@SortBy[Normal@columnPrimeReverseAssociation,First]];
  columnFlushPositionsCorresponded=If[Length[columnFlushPositions]>0,Last/@SortBy[Normal@columnFlushReverseAssociation,First]];

  (*first append Nulls to all of the rows to initialize*)
  injectionTableFull=Map[PadRight[#,7,Null]&,injectionTableWithLinks];

  (*get the dilution factors and inform that first*)
  injectionTableFull[[samplePositions,6]]=Lookup[myResolvedOptions,BufferDilutionFactor];

  (*then we'll do the column temperature*)
  injectionTableFull[[samplePositions,7]]=Lookup[myResolvedOptions,ColumnTemperature];
  injectionTableFull[[standardPositions,7]]=If[Length[standardPositions]>0,Lookup[myResolvedOptions,StandardColumnTemperature][[standardPositionsCorresponded]],{}];
  injectionTableFull[[blankPositions,7]]=If[Length[blankPositions]>0,Lookup[myResolvedOptions,BlankColumnTemperature][[blankPositionsCorresponded]],{}];
  injectionTableFull[[columnPrimePositions,7]]=If[Length[columnPrimePositions]>0,Lookup[myResolvedOptions,ColumnPrimeColumnTemperature][[columnPrimePositionsCorresponded]],{}];
  injectionTableFull[[columnFlushPositions,7]]=If[Length[columnFlushPositions]>0,Lookup[myResolvedOptions,ColumnFlushColumnTemperature][[columnFlushPositionsCorresponded]],{}];

  (*we'll need to use number of replicates to expand the effective injection table*)

  (*then get all of the sample tuples*)
  sampleTuples=injectionTableFull[[samplePositions]];

  (*make our insertion association (e.g. in the format of position to be inserted (P) and list to be inserted <|2 -> {{Sample,sample1,___}...}, *)
  insertionAssociation=MapThread[Function[{position,tuple},
    position->ConstantArray[tuple,numReplicates-1]
  ],{samplePositions,sampleTuples}];

  (*fold through and insert these tuples into our injection table*)
  injectionTableInserted= If[Length[numReplicates] > 1, Fold[Insert[#1, Last[#2], First[#2]] &, injectionTableFull, insertionAssociation], injectionTableFull];

  (*flatten and reform our injection table*)
  injectionTableWithReplicates=Partition[Flatten[injectionTableInserted],7];

  (*finally make our uploadable injection table*)
  injectionTableUploadable=MapThread[Function[{type,sample,injectionVolume,column,gradient,dilutionFactor,columnTemperature},
      Association[
        Type->type,
        Sample->sample,
        InjectionVolume->injectionVolume,
        Column->column,
        Gradient->gradient,
        DilutionFactor->dilutionFactor,
        ColumnTemperature->columnTemperature,
        Data->Null
      ]
    ],Transpose[injectionTableWithReplicates]
  ];

  (*get the instrument model*)
  instrumentModel=If[MatchQ[Lookup[myResolvedOptions,Instrument],ObjectP[Object[Instrument]]],
    Lookup[fetchPacketFromCache[Download[Lookup[myResolvedOptions,Instrument],Object],cache],Model],
    Download[Lookup[myResolvedOptions,Instrument],Object]
  ];

  (*get the instrument model packet*)
  instrumentModelPacket=fetchPacketFromCache[instrumentModel,cache];

  (*for the system prime and flush we will defer to the default method*)
  systemPrimeGradientMethod=Object[Method,SupercriticalFluidGradient,"ExperimentSupercriticalFluidChromatography System Prime Gradient"];
  systemFlushGradientMethod=Object[Method,SupercriticalFluidGradient,"ExperimentSupercriticalFluidChromatography System Prime Gradient"];

  (*get the packet from the cache*)
  systemPrimeGradientPacket=fetchPacketFromCache[Download[systemPrimeGradientMethod,Object],cache];
  systemFlushGradientPacket=fetchPacketFromCache[Download[systemFlushGradientMethod,Object],cache];

  (*get the gradient tuple*)
  systemPrimeGradient=Lookup[systemPrimeGradientPacket,Gradient];
  systemFlushGradient=Lookup[systemFlushGradientPacket,Gradient];

  (*define the suitable containers for the priming*)
  systemPrimeBufferContainer=Model[Container, Vessel, "id:zGj91aR3ddXJ"]; (* Model[Container, Vessel, "id:4pO6dM5l83Vz"]; 1 liter detergent senstitive bottles*)
  systemFlushBufferContainer=Model[Container, Vessel, "id:zGj91aR3ddXJ"]; (* Model[Container, Vessel, "id:4pO6dM5l83Vz"]; 1 liter detergent senstitive bottles*)
  bufferContainer=Model[Container, Vessel, "id:zGj91aR3ddXJ"]; (* Model[Container, Vessel, "id:4pO6dM5l83Vz"]; 1 liter detergent senstitive bottles*)

  bufferDeadVolume=600*Milliliter;

  (* Determine volume of CosolventA required for system prime run *)
  systemPrimeBufferAVolume = calculateBufferUsage[
    systemPrimeGradient[[All,{1,3}]], (*the specific gradient*)
    Max[systemPrimeGradient[[All,1]]], (*the last time*)
    systemPrimeGradient[[All,{1,8}]], (*the flow rate profile*)
    Last[systemPrimeGradient[[All,3]]] (*the last percentage*)
  ];

  (* Determine volume of CosolventB required for system prime run *)
  systemPrimeBufferBVolume = calculateBufferUsage[
    systemPrimeGradient[[All,{1,4}]], (*the specific gradient*)
    Max[systemPrimeGradient[[All,1]]], (*the last time*)
    systemPrimeGradient[[All,{1,8}]], (*the flow rate profile*)
    Last[systemPrimeGradient[[All,4]]] (*the last percentage*)
  ];

  (* Determine volume of CosolventC required for system prime run *)
  systemPrimeBufferCVolume = calculateBufferUsage[
    systemPrimeGradient[[All,{1,5}]], (*the specific gradient*)
    Max[systemPrimeGradient[[All,1]]], (*the last time*)
    systemPrimeGradient[[All,{1,8}]], (*the flow rate profile*)
    Last[systemPrimeGradient[[All,5]]] (*the last percentage*)
  ];

  (* Determine volume of CosolventD required for system prime run *)
  systemPrimeBufferDVolume = calculateBufferUsage[
    systemPrimeGradient[[All,{1,6}]], (*the specific gradient*)
    Max[systemPrimeGradient[[All,1]]], (*the last time*)
    systemPrimeGradient[[All,{1,8}]], (*the flow rate profile*)
    Last[systemPrimeGradient[[All,6]]] (*the last percentage*)
  ];

  (* Create resource for SystemPrime's BufferA *)
  systemPrimeCosolventAResource =  Resource[
    Sample -> Lookup[systemPrimeGradientPacket,CosolventA],
    Amount -> systemPrimeBufferAVolume + bufferDeadVolume,
    Container -> systemPrimeBufferContainer,
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (* Create resource for SystemPrime's BufferA *)
  systemPrimeCosolventBResource =  Resource[
    Sample -> Lookup[systemPrimeGradientPacket,CosolventB],
    Amount -> systemPrimeBufferBVolume + bufferDeadVolume,
    Container -> systemPrimeBufferContainer,
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (* Create resource for SystemPrime's BufferA *)
  systemPrimeCosolventCResource =  Resource[
    Sample -> Lookup[systemPrimeGradientPacket,CosolventC],
    Amount -> systemPrimeBufferCVolume + bufferDeadVolume,
    Container -> systemPrimeBufferContainer,
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (* Create resource for SystemPrime's BufferA *)
  systemPrimeCosolventDResource =  Resource[
    Sample -> Lookup[systemPrimeGradientPacket,CosolventD],
    Amount -> systemPrimeBufferDVolume + bufferDeadVolume,
    Container -> systemPrimeBufferContainer,
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (*we also make a resource for the Makeup Solvent that's not defined by the gradient*)
  (*we'll use methanol as well*)
  systemPrimeMakeupSolventResource = Resource[
    Sample->Model[Sample, "Methanol - LCMS grade"],
    Amount->400*Milliliter,
    Container -> systemPrimeBufferContainer,
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (*do the same for the system flushes*)
  {systemFlushBufferAVolume,systemFlushBufferBVolume,systemFlushBufferCVolume,systemFlushBufferDVolume} = Map[calculateBufferUsage[
    systemPrimeGradient[[All,{1,#}]], (*the specific gradient*)
    Max[systemPrimeGradient[[All,1]]], (*the last time*)
    systemPrimeGradient[[All,{1,8}]], (*the flow rate profile*)
    Last[systemPrimeGradient[[All,#]]] (*the last percentage*)
  ]&,Range[3,6]];

  (*create the resources for the system flush buffers*)
  {systemFlushBufferAResource,systemFlushBufferBResource,systemFlushBufferCResource,systemFlushBufferDResource}=MapThread[
    Function[{cosolvent,volume},
      Resource[
        Sample -> Lookup[systemFlushGradientPacket,cosolvent],
        Amount -> volume + bufferDeadVolume,
        Container -> systemPrimeBufferContainer,
        RentContainer -> True,
        Name -> CreateUUID[]
      ]
    ],
    {{CosolventA,CosolventB,CosolventC,CosolventD},{systemFlushBufferAVolume,systemFlushBufferBVolume,systemFlushBufferCVolume,systemFlushBufferDVolume}}
  ];

  (*we also make a resource for the Makeup Solvent that's not defined by the gradient*)
  (*we'll use methanol as well*)
  systemFlushMakeupSolventResource = Resource[
    Sample->Model[Sample, "Methanol - LCMS grade"],
    Amount->400*Milliliter,
    Container -> systemFlushBufferContainer,
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (* Create placement field value for SystemPrime buffers *)
  systemPrimeBufferPlacements = {
    {Link[systemPrimeCosolventAResource],{"Buffer A Slot"}},
    {Link[systemPrimeCosolventBResource],{"Buffer B Slot"}},
    {Link[systemPrimeCosolventCResource],{"Buffer C Slot"}},
    {Link[systemPrimeCosolventDResource],{"Buffer D Slot"}},
    {Link[systemPrimeMakeupSolventResource],{"Buffer E Slot"}}
  };

  (* Create placement field value for SystemFlush buffers *)
  systemFlushBufferPlacements = {
    {Link[systemFlushBufferAResource],{"Buffer A Slot"}},
    {Link[systemFlushBufferBResource],{"Buffer B Slot"}},
    {Link[systemFlushBufferCResource],{"Buffer C Slot"}},
    {Link[systemFlushBufferDResource],{"Buffer D Slot"}},
    {Link[systemFlushMakeupSolventResource],{"Buffer E Slot"}}
  };

  (*make the resources for the needle wash solution*)
  needleWashSolution= Resource[
    Sample -> Lookup[myResolvedOptions,NeedleWashSolution],
    Amount -> 300 Milli Liter,
    (*1000 mL bottle*)
    Container -> Model[Container, Vessel, "id:zGj91aR3ddXJ"],
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  externalNeedleWashSolution=Resource[
    Sample -> Lookup[myResolvedOptions,NeedleWashSolution],
    Amount -> 300 Milli Liter,
    (*1000 mL bottle*)
    Container -> Model[Container, Vessel, "id:zGj91aR3ddXJ"],
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (*create the placement fields for the needle wash solution*)
  needleWashSolutionPlacements={
    {Link[needleWashSolution],{"Strong Needle Wash In Reservoir Slot"}},
    {Link[externalNeedleWashSolution],{"Weak Needle Wash In Reservoir Slot"}}
  };

  (*start with the column prime*)
  {
    columnPrimeCO2Gradient,
    columnPrimeGradientA,
    columnPrimeGradientB,
    columnPrimeGradientC,
    columnPrimeGradientD,
    columnPrimeBackPressure,
    columnPrimeFlowRates,
    columnPrimeTemperatures,
    columnPrimeIonModes,
    columnPrimeMakeupFlowRates,
    columnPrimeProbeTemperatures,
    columnPrimeESICapillaryVoltages,
    columnPrimeSamplingConeVoltages,
    columnPrimeScanTimes,
    columnPrimeMassDetectionGains,
    columnPrimeWavelengthResolutions,
    columnPrimeUVFilter,
    columnPrimeAbsorbanceSamplingRates
  }=Map[
    Function[{optionLookup},
      If[!NullQ[columnPrimePositionsCorresponded],optionLookup[[columnPrimePositionsCorresponded]]]
    ]
    ,Lookup[myResolvedOptions,
      {
        ColumnPrimeCO2Gradient,
        ColumnPrimeGradientA,
        ColumnPrimeGradientB,
        ColumnPrimeGradientC,
        ColumnPrimeGradientD,
        ColumnPrimeBackPressure,
        ColumnPrimeFlowRate,
        ColumnPrimeColumnTemperature,
        ColumnPrimeIonMode,
        ColumnPrimeMakeupFlowRate,
        ColumnPrimeProbeTemperature,
        ColumnPrimeESICapillaryVoltage,
        ColumnPrimeSamplingConeVoltage,
        ColumnPrimeScanTime,
        ColumnPrimeMassDetectionGain,
        ColumnPrimeWavelengthResolution,
        ColumnPrimeUVFilter,
        ColumnPrimeAbsorbanceSamplingRate
      }
    ]
  ];

  (*now get the samples, which will always be there, so no mapping checks/positioning needed*)
  {
    sampleCO2Gradient,
    sampleGradientA,
    sampleGradientB,
    sampleGradientC,
    sampleGradientD,
    sampleBackPressure,
    sampleFlowRates,
    sampleColumnTemperatures,
    sampleIonModes,
    sampleMakeupFlowRates,
    sampleProbeTemperatures,
    sampleESICapillaryVoltages,
    sampleSamplingConeVoltages,
    sampleScanTimes,
    sampleMassDetectionGains,
    sampleWavelengthResolutions,
    sampleUVFilter,
    sampleAbsorbanceSamplingRates
  }=Lookup[myResolvedOptions,
    {
      CO2Gradient,
      GradientA,
      GradientB,
      GradientC,
      GradientD,
      BackPressure,
      FlowRate,
      ColumnTemperature,
      IonMode,
      MakeupFlowRate,
      ProbeTemperature,
      ESICapillaryVoltage,
      SamplingConeVoltage,
      ScanTime,
      MassDetectionGain,
      WavelengthResolution,
      UVFilter,
      AbsorbanceSamplingRate
    }
  ];

  (*now the standard samples*)
  {
    standardCO2Gradient,
    standardGradientA,
    standardGradientB,
    standardGradientC,
    standardGradientD,
    standardBackPressure,
    standardFlowRates,
    standardTemperatures,
    standardIonModes,
    standardMakeupFlowRates,
    standardProbeTemperatures,
    standardESICapillaryVoltages,
    standardSamplingConeVoltages,
    standardScanTimes,
    standardMassDetectionGains,
    standardWavelengthResolutions,
    standardUVFilter,
    standardAbsorbanceSamplingRates
  }=Map[
    Function[{optionLookup},
      If[!NullQ[standardPositionsCorresponded],optionLookup[[standardPositionsCorresponded]]]
    ]
    ,Lookup[myResolvedOptions,
      {
        StandardCO2Gradient,
        StandardGradientA,
        StandardGradientB,
        StandardGradientC,
        StandardGradientD,
        StandardBackPressure,
        StandardFlowRate,
        StandardColumnTemperature,
        StandardIonMode,
        StandardMakeupFlowRate,
        StandardProbeTemperature,
        StandardESICapillaryVoltage,
        StandardSamplingConeVoltage,
        StandardScanTime,
        StandardMassDetectionGain,
        StandardWavelengthResolution,
        StandardUVFilter,
        StandardAbsorbanceSamplingRate
      }
    ]
  ];

  (*now the blank samples*)
  {
    blankCO2Gradient,
    blankGradientA,
    blankGradientB,
    blankGradientC,
    blankGradientD,
    blankBackPressure,
    blankFlowRates,
    blankTemperatures,
    blankIonModes,
    blankMakeupFlowRates,
    blankProbeTemperatures,
    blankESICapillaryVoltages,
    blankSamplingConeVoltages,
    blankScanTimes,
    blankMassDetectionGains,
    blankWavelengthResolutions,
    blankUVFilter,
    blankAbsorbanceSamplingRates
  }=Map[
    Function[{optionLookup},
      If[!NullQ[blankPositionsCorresponded],optionLookup[[blankPositionsCorresponded]]]
    ]
    ,Lookup[myResolvedOptions,
      {
        BlankCO2Gradient,
        BlankGradientA,
        BlankGradientB,
        BlankGradientC,
        BlankGradientD,
        BlankBackPressure,
        BlankFlowRate,
        BlankColumnTemperature,
        BlankIonMode,
        BlankMakeupFlowRate,
        BlankProbeTemperature,
        BlankESICapillaryVoltage,
        BlankSamplingConeVoltage,
        BlankScanTime,
        BlankMassDetectionGain,
        BlankWavelengthResolution,
        BlankUVFilter,
        BlankAbsorbanceSamplingRate
      }
    ]
  ];

  (*start with the column flush*)
  {
    columnFlushCO2Gradient,
    columnFlushGradientA,
    columnFlushGradientB,
    columnFlushGradientC,
    columnFlushGradientD,
    columnFlushBackPressure,
    columnFlushFlowRates,
    columnFlushTemperatures,
    columnFlushIonModes,
    columnFlushMakeupFlowRates,
    columnFlushProbeTemperatures,
    columnFlushESICapillaryVoltages,
    columnFlushSamplingConeVoltages,
    columnFlushScanTimes,
    columnFlushMassDetectionGains,
    columnFlushWavelengthResolutions,
    columnFlushUVFilter,
    columnFlushAbsorbanceSamplingRates
  }=Map[
    Function[{optionLookup},
      If[!NullQ[columnFlushPositionsCorresponded],optionLookup[[columnFlushPositionsCorresponded]]]
    ]
    ,Lookup[myResolvedOptions,
      {
        ColumnFlushCO2Gradient,
        ColumnFlushGradientA,
        ColumnFlushGradientB,
        ColumnFlushGradientC,
        ColumnFlushGradientD,
        ColumnFlushBackPressure,
        ColumnFlushFlowRate,
        ColumnFlushColumnTemperature,
        ColumnFlushIonMode,
        ColumnFlushMakeupFlowRate,
        ColumnFlushProbeTemperature,
        ColumnFlushESICapillaryVoltage,
        ColumnFlushSamplingConeVoltage,
        ColumnFlushScanTime,
        ColumnFlushMassDetectionGain,
        ColumnFlushWavelengthResolution,
        ColumnFlushUVFilter,
        ColumnFlushAbsorbanceSamplingRate
      }
    ]
  ];

  (*now we figure out how much buffer to make for the cosolvent and make up solvent*)

  (*get all of hte gradients used*)
  allGradients=Download[injectionTableInserted[[All,5]],Object];

  (*get all of the buffer models for the cosolvents*)
  {cosolventAmodel,cosolventBmodel,cosolventCmodel,cosolventDmodel}=Map[
    If[MatchQ[#,ObjectP[Object[Sample]]],
      Lookup[fetchPacketFromCache[Download[#,Object],cache],Model],
      (*if not an object. keep the same*)
      #
    ]&
    ,Lookup[myResolvedOptions,{CosolventA,CosolventB,CosolventC,CosolventD}]
  ];

  (*will map through and make a gradient for each based on the object ID*)
  uniqueGradientPackets=Map[Function[{gradientObjectID},Module[{injectionTablePosition,currentType,currentGradientTuple},

    (*find the injection Table position*)
    injectionTablePosition=First@FirstPosition[tableGradients,gradientObjectID];

    (*figure out the type, based on which, look up the gradient tuple*)
    currentType=First[injectionTable[[injectionTablePosition]]];

    (*get the gradient based on the type and the position*)
    currentGradientTuple=Switch[currentType,
      Sample, ToList[sampleGradient][[injectionTablePosition/.sampleReverseAssociation]],
      Standard, ToList[standardGradient][[injectionTablePosition/.standardReverseAssociation]],
      Blank, ToList[blankGradient][[injectionTablePosition/.blankReverseAssociation]],
      ColumnPrime, ToList[columnPrimeGradient][[injectionTablePosition/.columnPrimeReverseAssociation]],
      ColumnFlush, ToList[columnFlushGradient][[injectionTablePosition/.columnFlushReverseAssociation]]
    ];

    (*make the gradient packet*)
    <|
      Object->gradientObjectID,
      Type->Object[Method,SupercriticalFluidGradient],
      CosolventA->Link@cosolventAmodel,
      CosolventB->Link@cosolventBmodel,
      CosolventC->Link@cosolventCmodel,
      CosolventD->Link@cosolventDmodel,
      Replace[Gradient]->currentGradientTuple,
      Replace[CO2Gradient]->currentGradientTuple[[All,{1,2}]],
      Replace[GradientA]->currentGradientTuple[[All,{1,3}]],
      Replace[GradientB]->currentGradientTuple[[All,{1,4}]],
      Replace[GradientC]->currentGradientTuple[[All,{1,5}]],
      Replace[GradientD]->currentGradientTuple[[All,{1,6}]],
      Replace[BackPressure]->currentGradientTuple[[All,{1,7}]],
      Replace[FlowRate]->currentGradientTuple[[All,{1,8}]],
      InitialFlowRate->currentGradientTuple[[1,8]],
      (*we also need our column temperature*)
      Temperature->injectionTableFull[[injectionTablePosition]][[7]]
    |>
  ]],gradientObjectsToMake
  ];

  (*look everything up in the cache and extract out the gradient tuple*)
  allGradientTuples=Map[
    Function[{gradientObject},
      Lookup[fetchPacketFromCache[gradientObject,Join[cache,uniqueGradientPackets]],Gradient,
        (*otherwise check if there is a replace*)
        Lookup[fetchPacketFromCache[gradientObject,Join[cache,uniqueGradientPackets]],Replace[Gradient]]
      ]
    ],allGradients
  ];

  {cosolventAResource,cosolventBResource,cosolventCResource,cosolventDResource}=Map[
    Function[{entry},Module[{cosolventOption,gradientIndex},

      (*split our entry*)
      {cosolventOption,gradientIndex}=entry;

      (*first check if Null, if so, we resource pick some methanol just for priming*)
      If[NullQ[cosolventOption],
        Resource[
          (*methanol for the rinse*)
          Sample -> Model[Sample, "id:01G6nvkKrrPd"],
          Amount -> 200 Milli Liter,
          (*1 L bottle*)
          Container -> Model[Container, Vessel, "id:zGj91aR3ddXJ"],
          RentContainer -> True,
          Name -> CreateUUID[]
        ],
        (*otherwise we need to figure out exactly how much we need*)
        Module[{cosolventVolumes,totalVolumeNeeded},

          cosolventVolumes=Map[Function[{currentGradientTuple},
            calculateBufferUsage[
              currentGradientTuple[[All,{1,gradientIndex}]],
              Max[currentGradientTuple[[All, 1]]], (*last time point*)
              currentGradientTuple[[All,{1,8}]],
              Last[currentGradientTuple[[All, gradientIndex]]] (*last percentage*)
            ]
          ],allGradientTuples];

          totalVolumeNeeded=Total[cosolventVolumes];

          (*now make our resource*)
          Resource[
            Sample -> cosolventOption,
            (*can't supply more than the volume of the container*)
            Amount -> Min[1 Liter, bufferDeadVolume+totalVolumeNeeded],
            (*1 L bottle*)
            Container -> bufferContainer,
            RentContainer -> True,
            Name -> CreateUUID[]
          ]
        ]
      ]
    ]]
    ,{
      {Lookup[myResolvedOptions,CosolventA],3},
      {Lookup[myResolvedOptions,CosolventB],4},
      {Lookup[myResolvedOptions,CosolventC],5},
      {Lookup[myResolvedOptions,CosolventD],6}
    }
  ];

  (*figure out our make up solvent resource*)
  allMakeupSolvents=Join@Cases[{Sequence@@ConstantArray[sampleMakeupFlowRates,numReplicates], columnPrimeMakeupFlowRates, standardMakeupFlowRates, blankMakeupFlowRates, columnFlushMakeupFlowRates},Except[Null]];

  (*we will need to get the times for each run*)
  {sampleTimes,standardTimes,blankTimes,columnPrimeTimes,columnFlushTimes}=MapThread[
    Function[{gradientOption,correspondingPositions},
      If[!NullQ[gradientOption],
        (*map through and get the tuple*)
        innerTimes=Map[
          Function[{gradientElement},
            mappingGradientTuple=If[MatchQ[gradientElement,ObjectP[Object[Method]]],
              (*fetch if a method*)
              Lookup[fetchPacketFromCache[gradientElement,Join[cache,uniqueGradientPackets]],Gradient],
              gradientElement
            ];
            (*we'll want the last time point*)
            mappingGradientTuple[[-1,1]]
          ],
          gradientOption];

        (*expand out by the corresponding positions*)
        innerTimes[[correspondingPositions]]
      ]
    ]
    ,{
      Lookup[myResolvedOptions,{Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient}],
      {Range[1,Length[mySamples]],standardPositionsCorresponded,blankPositionsCorresponded,columnPrimePositionsCorresponded,columnFlushPositionsCorresponded}
    }
  ];

  (*make an array of all the times*)
  allTimes=Join@Cases[{Sequence@@ConstantArray[sampleTimes,numReplicates], columnPrimeTimes,standardTimes,blankTimes,columnFlushTimes},Except[Null]];

  (*use this to calculate the total run time*)
  totalRunTime=Total[Total/@allTimes] + 120 Minute;

  (*go through and calculate the usage. flow rate is passed here just to provide time values*)
  makeupSolventVolumes=MapThread[Function[{currentMakeupFlowRate,time},
    currentMakeupFlowRate*time
  ],{allMakeupSolvents,allTimes}];

  totalMakeupVolumeNeeded=Total[Total/@makeupSolventVolumes];

  makeSolventResource=Resource[
    Sample -> Lookup[myResolvedOptions,MakeupSolvent],
    (*can't supply more than the volume of the container*)
    Amount -> Min[1 Liter, bufferDeadVolume+totalMakeupVolumeNeeded],
    (*1 L bottle*)
    Container -> Model[Container, Vessel, "id:4pO6dM5l83Vz"], (*detergent sentitive bottle*)
    RentContainer -> True,
    Name -> CreateUUID[]
  ];

  (*resolve the range parameters for the mass spec detection options*)
  {
    {columnPrimeMinMasses,columnPrimeMaxMasses,columnPrimeMassSelections},
    {sampleMinMasses,sampleMaxMasses,sampleMassSelections},
    {standardMinMasses,standardMaxMasses,standardMassSelections},
    {blankMinMasses,blankMaxMasses,blankMassSelections},
    {columnFlushMinMasses,columnFlushMaxMasses,columnFlushMassSelections}
  }=Map[Function[{entry},Module[{detectionOptions,correspondingPositions},

      (*split our entry variable*)
      {detectionOptions,correspondingPositions}=entry;

      (*check whether our corresponding positions is Null, if so return nulls*)
      If[NullQ[correspondingPositions],
        {Null,Null,Null},
        (*otherwise will need to map through the option and break apart what's relevant. we'll also need to expand out by the corresponding positions*)
        #[[correspondingPositions]]&/@
        (Transpose@Map[Function[{detectorOption},
          Switch[detectorOption,
            (*check if All was specified, then it's easy*)
            All,{30 Gram/Mole, 1200 Gram/Mole, Range[30 Gram/Mole, 1200 Gram/Mole, 1 Gram/Mole]},
            (*then check if it's a span, and if so, split it up for the min and max*)
            _Span,Append[detectorOption/.Span[x_, y_] :> {x, y},detectorOption/.Span[x_, y_]:>Range[x,y]],
            (*otherwise it's specific*)
            _,{Min@detectorOption,Max@detectorOption,detectorOption}
          ]
        ],detectionOptions])
      ]

  ]],{
    List[Lookup[myResolvedOptions,ColumnPrimeMassDetection],columnPrimePositionsCorresponded],
    List[Lookup[myResolvedOptions,MassDetection],Range[1,Length[mySamples]]],
    List[Lookup[myResolvedOptions,StandardMassDetection],standardPositionsCorresponded],
    List[Lookup[myResolvedOptions,BlankMassDetection],blankPositionsCorresponded],
    List[Lookup[myResolvedOptions,ColumnFlushMassDetection],columnFlushPositionsCorresponded]
    }
  ];

  (*resolve the range parameters for the absorbance detection*)
  {
    {columnPrimeAbsorbanceSelection, columnPrimeMinAbsorbanceWavelengths, columnPrimeMaxAbsorbanceWavelengths},
    {sampleAbsorbanceSelection, sampleMinAbsorbanceWavelengths, sampleMaxAbsorbanceWavelengths},
    {standardAbsorbanceSelection, standardMinAbsorbanceWavelengths, standardMaxAbsorbanceWavelengths},
    {blankAbsorbanceSelection, blankMinAbsorbanceWavelengths, blankMaxAbsorbanceWavelengths},
    {columnFlushAbsorbanceSelection, columnFlushMinAbsorbanceWavelengths, columnFlushMaxAbsorbanceWavelengths}
  }=Map[Function[{entry},Module[{detectionOptions,resolutions,correspondingPositions},

    (*split our entry variable*)
    {detectionOptions,resolutions,correspondingPositions}=entry;

    (*check whether our corresponding positions is Null, if so return nulls*)
    If[NullQ[correspondingPositions],
      {Null,Null,Null},
      (*otherwise will need to map through the option and break apart what's relevant. we'll also need to expand out by the corresponding positions*)
      #[[correspondingPositions]]&/@
          (Transpose@MapThread[Function[{detectorOption,resolutionOption},
            Switch[detectorOption,
              (*check if All was specified, then it's easy*)
              All,{Range[190 Nanometer, 800 Nanometer, resolutionOption], 190 Nanometer, 800 Nanometer},
              (*then check if it's a span, and if so, split it up for the min and max*)
              _Span,Prepend[detectorOption/.Span[x_, y_] :> {x, y},detectorOption/.Span[x_, y_]:>Range[x,y,resolutionOption]],
              (*otherwise it's specific wavelength*)
              _,{{detectorOption},detectorOption,detectorOption}
            ]
          ],{detectionOptions,resolutions}])
    ]

  ]],{
    Append[Lookup[myResolvedOptions,{ColumnPrimeAbsorbanceWavelength,ColumnPrimeWavelengthResolution}],columnPrimePositionsCorresponded],
    Append[Lookup[myResolvedOptions,{AbsorbanceWavelength,WavelengthResolution}],Range[1,Length[mySamples]]],
    Append[Lookup[myResolvedOptions,{StandardAbsorbanceWavelength,StandardWavelengthResolution}],standardPositionsCorresponded],
    Append[Lookup[myResolvedOptions,{BlankAbsorbanceWavelength,BlankWavelengthResolution}],blankPositionsCorresponded],
    Append[Lookup[myResolvedOptions,{ColumnFlushAbsorbanceWavelength,ColumnFlushWavelengthResolution}],columnFlushPositionsCorresponded]
  }];

  (* Use Level 2 Operators *)
  operatorResource = $BaselineOperator;

  (* --- Generate the protocol packet --- *)
  protocolPacket=<|
    Type -> Object[Protocol,SupercriticalFluidChromatography],
    Object -> CreateID[Object[Protocol,SupercriticalFluidChromatography]],
    Replace[SamplesIn] ->(Link[#,Protocols]&/@sampleResources),
    Replace[SamplesInStorage] -> Lookup[myResolvedOptions,SamplesInStorageCondition],
    Replace[ContainersIn] -> (Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[sampleContainers],
    UnresolvedOptions -> myUnresolvedOptions,
    ResolvedOptions -> myResolvedOptions,
    NumberOfReplicates -> numReplicates,
    Instrument -> Link[
      Resource[
        Instrument -> Lookup[myResolvedOptions,Instrument],
        Time -> totalRunTime
      ]
    ],
    Scale->Lookup[myResolvedOptions,Scale],
    SeparationMode->Lookup[myResolvedOptions,SeparationMode],
    Replace[Detectors]->Lookup[instrumentModelPacket,Detectors],
    AcquisitionMode->First@Lookup[instrumentModelPacket,AcquisitionModes],
    MassAnalyzer->Lookup[instrumentModelPacket,MassAnalyzer],
    IonSource->First@Lookup[instrumentModelPacket,IonSources],

    (* We will create Cover resources in the compiler, when we have the WorkingContainers and can prepare resources that are index matched to the WorkingContainers field *)

    (*currently, we're not resource picking this, we'll just use whatever the instrument has*)
    Calibrant->Link@Lookup[myResolvedOptions,Calibrant],

    SeparationTime->totalRunTime,

    (*this is dumb and will only lead to issues with measurement*)
    (*TubingRinseSolution->Link[
      Resource[
        (* ethanol reagent grade *)
        Sample -> Model[Sample, "id:Y0lXejGKdEDW"],
        Amount -> 500 Milli Liter,
        (* 1000 mL Glass Beaker *)
        Container -> Model[Container, Vessel, "id:O81aEB4kJJJo"],
        RentContainer -> True
      ]
    ],*)
    NeedleWashSolution->Link[needleWashSolution],
    ExternalNeedleWashSolution->Link[externalNeedleWashSolution],
    Replace[NeedleWashPlacements]->needleWashSolutionPlacements,

    SystemPrimeBufferA->Link@(systemPrimeCosolventAResource),
    SystemPrimeBufferB->Link@(systemPrimeCosolventBResource),
    SystemPrimeBufferC->Link@(systemPrimeCosolventCResource),
    SystemPrimeBufferD->Link@(systemPrimeCosolventDResource),
    SystemPrimeMakeupSolvent->Link[systemPrimeMakeupSolventResource],
    SystemPrimeGradient->Link@systemPrimeGradientMethod,
    Replace[SystemPrimeBufferPlacements] -> systemPrimeBufferPlacements,

    Replace[ColumnSelection]->columnSelectorResources,
    Replace[ColumnOrientation]->columnOrientations,

    CosolventA->Link@cosolventAResource,
    CosolventB->Link@cosolventBResource,
    CosolventC->Link@cosolventCResource,
    CosolventD->Link@cosolventDResource,
    MakeupSolvent->Link@makeSolventResource,

    MaxAcceleration->Lookup[myResolvedOptions,MaxAcceleration],

    Replace[InjectionTable]->injectionTableUploadable,

    Replace[ColumnPrimeGradientMethods]->If[Length[columnPrimePositions]>0,injectionTableWithLinks[[columnPrimePositions,5]]],
    Replace[ColumnPrimeCO2Gradient]->columnPrimeCO2Gradient,
    Replace[ColumnPrimeGradientA]->columnPrimeGradientA,
    Replace[ColumnPrimeGradientB]->columnPrimeGradientB,
    Replace[ColumnPrimeGradientC]->columnPrimeGradientC,
    Replace[ColumnPrimeGradientD]->columnPrimeGradientD,
    Replace[ColumnPrimeBackPressure]->columnPrimeBackPressure,
    Replace[ColumnPrimeFlowRates]->columnPrimeFlowRates,
    Replace[ColumnPrimeTemperatures]->columnPrimeTemperatures,
    Replace[ColumnPrimeIonModes]->columnPrimeIonModes,
    Replace[ColumnPrimeMakeupFlowRates]->columnPrimeMakeupFlowRates,
    Replace[ColumnPrimeMassSelections]->columnPrimeMassSelections,
    Replace[ColumnPrimeMinMasses]->columnPrimeMinMasses,
    Replace[ColumnPrimeMaxMasses]->columnPrimeMaxMasses,
    Replace[ColumnPrimeProbeTemperatures]->columnPrimeProbeTemperatures,
    Replace[ColumnPrimeSourceTemperatures]->If[Length[columnPrimePositions]>0,ConstantArray[120 Celsius,Length[columnPrimePositions]]],
    Replace[ColumnPrimeESICapillaryVoltages]->columnPrimeESICapillaryVoltages,
    Replace[ColumnPrimeSamplingConeVoltages]->columnPrimeSamplingConeVoltages,
    Replace[ColumnPrimeScanTimes]->columnPrimeScanTimes,
    Replace[ColumnPrimeMassDetectionGains]->columnPrimeMassDetectionGains,
    Replace[ColumnPrimeAbsorbanceSelection]->columnPrimeAbsorbanceSelection,
    Replace[ColumnPrimeMinAbsorbanceWavelengths]->columnPrimeMinAbsorbanceWavelengths,
    Replace[ColumnPrimeMaxAbsorbanceWavelengths]->columnPrimeMaxAbsorbanceWavelengths,
    Replace[ColumnPrimeWavelengthResolutions]->columnPrimeWavelengthResolutions,
    Replace[ColumnPrimeUVFilter]->columnPrimeUVFilter,
    Replace[ColumnPrimeAbsorbanceSamplingRates]->columnPrimeAbsorbanceSamplingRates,

    SampleTemperature->Lookup[myResolvedOptions,SampleTemperature]/.(Ambient->22*Celsius),

    Replace[SampleVolumes]->sampleTuples[[All,3]],
    Replace[GradientMethods]->injectionTableWithLinks[[samplePositions,5]],
    Replace[CO2Gradient]->sampleCO2Gradient,
    Replace[GradientA]->sampleGradientA,
    Replace[GradientB]->sampleGradientB,
    Replace[GradientC]->sampleGradientC,
    Replace[GradientD]->sampleGradientD,
    Replace[BackPressures]->sampleBackPressure,
    Replace[FlowRate]->sampleFlowRates,
    Replace[Columns]->columnResources,
    Replace[ColumnTemperatures]->sampleColumnTemperatures,
    Replace[IonModes]->sampleIonModes,
    Replace[MakeupFlowRates]->sampleMakeupFlowRates,
    Replace[MassSelection]->sampleMassSelections,
    Replace[MinMasses]->sampleMinMasses,
    Replace[MaxMasses]->sampleMaxMasses,
    Replace[SourceTemperatures]->ConstantArray[120 Celsius,Length[samplePositions]],
    Replace[ProbeTemperatures]->sampleProbeTemperatures,
    Replace[ESICapillaryVoltages]->sampleESICapillaryVoltages,
    Replace[SamplingConeVoltages]->sampleSamplingConeVoltages,
    Replace[ScanTimes]->sampleScanTimes,
    Replace[MassDetectionGains]->sampleMassDetectionGains,
    Replace[AbsorbanceSelection]->sampleAbsorbanceSelection,
    Replace[MinAbsorbanceWavelengths]->sampleMinAbsorbanceWavelengths,
    Replace[MaxAbsorbanceWavelengths]->sampleMaxAbsorbanceWavelengths,
    Replace[WavelengthResolutions]->sampleWavelengthResolutions,
    Replace[UVFilters]->sampleUVFilter,
    Replace[AbsorbanceSamplingRates]->sampleAbsorbanceSamplingRates,

    Replace[Standards]->linkedStandardResources,

    Replace[StandardSampleVolumes]->If[Length[standardPositions]>0,standardTuples[[All,3]]],
    Replace[StandardGradientMethods]->If[Length[standardPositions]>0,injectionTableWithLinks[[standardPositions,5]]],
    Replace[StandardCO2Gradient]->standardCO2Gradient,
    Replace[StandardGradientA]->standardGradientA,
    Replace[StandardGradientB]->standardGradientB,
    Replace[StandardGradientC]->standardGradientC,
    Replace[StandardGradientD]->standardGradientD,
    Replace[StandardBackPressures]->standardBackPressure,
    Replace[StandardFlowRates]->standardFlowRates,
    Replace[StandardColumns]->standardColumnResources,
    Replace[StandardColumnTemperatures]->standardTemperatures,
    Replace[StandardIonModes]->standardIonModes,
    Replace[StandardMakeupFlowRates]->standardMakeupFlowRates,
    Replace[StandardMassSelection]->standardMassSelections,
    Replace[StandardMinMasses]->standardMinMasses,
    Replace[StandardMaxMasses]->standardMaxMasses,
    Replace[StandardProbeTemperatures]->standardProbeTemperatures,
    Replace[StandardSourceTemperatures]->If[Length[standardPositions]>0,ConstantArray[120 Celsius,Length[standardPositions]]],
    Replace[StandardESICapillaryVoltages]->standardESICapillaryVoltages,
    Replace[StandardSamplingConeVoltages]->standardSamplingConeVoltages,
    Replace[StandardScanTimes]->standardScanTimes,
    Replace[StandardMassDetectionGains]->standardMassDetectionGains,
    Replace[StandardAbsorbanceSelection]->standardAbsorbanceSelection,
    Replace[StandardMinAbsorbanceWavelengths]->standardMinAbsorbanceWavelengths,
    Replace[StandardMaxAbsorbanceWavelengths]->standardMaxAbsorbanceWavelengths,
    Replace[StandardWavelengthResolutions]->standardWavelengthResolutions,
    Replace[StandardUVFilters]->standardUVFilter,
    Replace[StandardAbsorbanceSamplingRates]->standardAbsorbanceSamplingRates,
    Replace[StandardsStorageConditions]->If[Length[standardPositions]>0&&!NullQ[Lookup[myResolvedOptions,StandardStorageCondition]],
      ToList[Lookup[myResolvedOptions,StandardStorageCondition]][[standardPositionsCorresponded]]
    ],

    Replace[Blanks]->linkedBlankResources,

    Replace[BlankSampleVolumes]->If[Length[blankPositions]>0,blankTuples[[All,3]]],
    Replace[BlankGradientMethods]->If[Length[blankPositions]>0,injectionTableWithLinks[[blankPositions,5]]],
    Replace[BlankCO2Gradient]->blankCO2Gradient,
    Replace[BlankGradientA]->blankGradientA,
    Replace[BlankGradientB]->blankGradientB,
    Replace[BlankGradientC]->blankGradientC,
    Replace[BlankGradientD]->blankGradientD,
    Replace[BlankBackPressures]->blankBackPressure,
    Replace[BlankFlowRates]->blankFlowRates,
    Replace[BlankColumns]->blankColumnResources,
    Replace[BlankColumnTemperatures]->blankTemperatures,
    Replace[BlankIonModes]->blankIonModes,
    Replace[BlankMakeupFlowRates]->blankMakeupFlowRates,
    Replace[BlankMassSelection]->blankMassSelections,
    Replace[BlankMinMasses]->blankMinMasses,
    Replace[BlankMaxMasses]->blankMaxMasses,
    Replace[BlankProbeTemperatures]->blankProbeTemperatures,
    Replace[BlankSourceTemperatures]->If[Length[blankPositions]>0,ConstantArray[120 Celsius,Length[blankPositions]]],
    Replace[BlankESICapillaryVoltages]->blankESICapillaryVoltages,
    Replace[BlankSamplingConeVoltages]->blankSamplingConeVoltages,
    Replace[BlankScanTimes]->blankScanTimes,
    Replace[BlankMassDetectionGains]->blankMassDetectionGains,
    Replace[BlankAbsorbanceSelection]->blankAbsorbanceSelection,
    Replace[BlankMinAbsorbanceWavelengths]->blankMinAbsorbanceWavelengths,
    Replace[BlankMaxAbsorbanceWavelengths]->blankMaxAbsorbanceWavelengths,
    Replace[BlankWavelengthResolutions]->blankWavelengthResolutions,
    Replace[BlankUVFilters]->blankUVFilter,
    Replace[BlankAbsorbanceSamplingRates]->blankAbsorbanceSamplingRates,
    Replace[BlanksStorageConditions]->If[
      Length[blankPositions]>0&&!NullQ[Lookup[myResolvedOptions,BlankStorageCondition]],
      ToList[Lookup[myResolvedOptions,BlankStorageCondition]][[blankPositionsCorresponded]]
    ],

    Replace[ColumnFlushGradientMethods]->If[Length[columnFlushPositions]>0,injectionTableWithLinks[[columnFlushPositions,5]]],
    Replace[ColumnFlushCO2Gradient]->columnFlushCO2Gradient,
    Replace[ColumnFlushGradientA]->columnFlushGradientA,
    Replace[ColumnFlushGradientB]->columnFlushGradientB,
    Replace[ColumnFlushGradientC]->columnFlushGradientC,
    Replace[ColumnFlushGradientD]->columnFlushGradientD,
    Replace[ColumnFlushBackPressures]->columnFlushBackPressure,
    Replace[ColumnFlushFlowRates]->columnFlushFlowRates,
    Replace[ColumnFlushTemperatures]->columnFlushTemperatures,
    Replace[ColumnFlushIonModes]->columnFlushIonModes,
    Replace[ColumnFlushMakeupFlowRates]->columnFlushMakeupFlowRates,
    Replace[ColumnFlushMassSelections]->columnFlushMassSelections,
    Replace[ColumnFlushMinMasses]->columnFlushMinMasses,
    Replace[ColumnFlushMaxMasses]->columnFlushMaxMasses,
    Replace[ColumnFlushProbeTemperatures]->columnFlushProbeTemperatures,
    Replace[ColumnFlushSourceTemperatures]->If[Length[columnFlushPositions]>0,ConstantArray[120 Celsius,Length[columnFlushPositions]]],
    Replace[ColumnFlushESICapillaryVoltages]->columnFlushESICapillaryVoltages,
    Replace[ColumnFlushSamplingConeVoltages]->columnFlushSamplingConeVoltages,
    Replace[ColumnFlushScanTimes]->columnFlushScanTimes,
    Replace[ColumnFlushMassDetectionGains]->columnFlushMassDetectionGains,
    Replace[ColumnFlushAbsorbanceSelection]->columnFlushAbsorbanceSelection,
    Replace[ColumnFlushMinAbsorbanceWavelengths]->columnFlushMinAbsorbanceWavelengths,
    Replace[ColumnFlushMaxAbsorbanceWavelengths]->columnFlushMaxAbsorbanceWavelengths,
    Replace[ColumnFlushWavelengthResolutions]->columnFlushWavelengthResolutions,
    Replace[ColumnFlushUVFilters]->columnFlushUVFilter,
    Replace[ColumnFlushAbsorbanceSamplingRates]->columnFlushAbsorbanceSamplingRates,

    SystemFlushCosolventA->systemFlushBufferAResource,
    SystemFlushCosolventB->systemFlushBufferBResource,
    SystemFlushCosolventC->systemFlushBufferCResource,
    SystemFlushCosolventD->systemFlushBufferDResource,
    SystemFlushMakeupSolvent->systemFlushMakeupSolventResource,
    SystemFlushGradient->Link@systemPrimeGradientMethod,
    Replace[SystemFlushContainerPlacements] -> systemFlushBufferPlacements,

    Replace[Checkpoints] -> 		{
      {"Picking Resources", 1 Hour, "Buffers and columns required to run Supercritical Fluid Chromatography experiments are gathered.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
      {"Purging Instrument",3 Hour, "System priming buffers are connected to an Supercritical Fluid Chromatography instrument and the instrument's buffer lines, needle and pump seals are purged at a high flow rates.",Link[Resource[Operator -> operatorResource, Time -> 3 Hour]]},
      {"Preparing Instrument", 90 Minute, "An instrument is configured for the protocol.",Link[Resource[Operator -> operatorResource, Time -> 90 Minute]]},
      {"Running Samples", totalRunTime, "Samples are injected onto an Supercritical Fluid Chromatography and subject to buffer gradients.",Link[Resource[Operator -> operatorResource, Time -> totalRunTime]]},
      {"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
      {"Flushing Instrument", 2 Hour, "Buffers are connected to an Supercritical Fluid Chromatography instrument and the instrument is flushed with each buffer at a high flow rate.",Link[Resource[Operator -> operatorResource, Time -> 2 Hour]]},
      {"Exporting Data", 20 Minute, "Acquired chromatography data is exported.",Link[Resource[Operator -> operatorResource, Time -> 20 Minute]]},
      {"Returning Materials", 15 Minute, "Samples are returned to storage.",Link[Resource[Operator -> operatorResource, Time -> 15 Minute]]}
    }
  |>;

  (* Expand the resolved options if they weren't expanded already *)
  unCollapsedResolvedOptions=Last[ExpandIndexMatchedInputs[ExperimentSupercriticalFluidChromatography,{mySamples},myResolvedOptions]];

  (* generate a packet with the shared fields *)
  sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache->cache,Simulation -> simulation];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[protocolPacket,sharedFieldPacket];

  (* Return all generated packets *)
  allPackets = Join[
    {finalizedPacket},
    uniqueGradientPackets
  ];

  (* get all the resource symbolic representations *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

  (* call fulfillableResourceQ on all the resources we created *)
  {fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication, Engine], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->cache, Simulation -> simulation],
    True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->cache, Simulation -> simulation], Null}
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
    {$Failed,$Failed}
  ];

  (* return the output as we desire it *)
  outputSpecification /. {resultRule, testsRule}
];


(* ::Subsection::Closed:: *)
(*ExperimentSupercriticalFluidChromatographyPreview*)


(* ::Subsubsection:: *)
(*ExperimentSupercriticalFluidChromatographyPreview*)


DefineOptions[ExperimentSupercriticalFluidChromatographyPreview,
  SharedOptions :> {ExperimentSupercriticalFluidChromatography}
];

ExperimentSupercriticalFluidChromatographyPreview[myObjects:ListableP[ObjectP[{Object[Container], Model[Sample]}]]|ListableP[(ObjectP[Object[Sample]]|_String)],myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (* return only the preview for ExperimentSupercriticalFluidChromatography *)
  ExperimentSupercriticalFluidChromatography[myObjects, Append[noOutputOptions, Output -> Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentSupercriticalFluidChromatographyOptions*)


(* ::Subsubsection:: *)
(*ExperimentSupercriticalFluidChromatographyOptions*)


DefineOptions[ExperimentSupercriticalFluidChromatographyOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
      Description -> "Determines whether the function returns a table or a list of the options.",
      Category->"Protocol"
    }
  },
  SharedOptions :> {ExperimentSupercriticalFluidChromatography}
];

ExperimentSupercriticalFluidChromatographyOptions[myObjects:ListableP[ObjectP[{Object[Container], Model[Sample]}]]|ListableP[(ObjectP[Object[Sample]]|_String)],myOptions:OptionsPattern[]]:=Module[
  {listedOptions, noOutputOptions, options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, (Output -> _) | (OutputFormat->_)];

  (* return only the preview for ExperimentSupercriticalFluidChromatography *)
  options = ExperimentSupercriticalFluidChromatography[myObjects, Append[noOutputOptions, Output -> Options]];

  (* If options fail, return failure *)
  If[MatchQ[options,$Failed],
    Return[$Failed]
  ];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentSupercriticalFluidChromatography],
    options
  ]
];



(* ::Subsection:: *)
(*ValidExperimentSupercriticalFluidChromatographyQ*)


(* ::Subsubsection:: *)
(*ValidExperimentSupercriticalFluidChromatographyQ*)


DefineOptions[ValidExperimentSupercriticalFluidChromatographyQ,
  Options :> {
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentSupercriticalFluidChromatography}
];


ValidExperimentSupercriticalFluidChromatographyQ[myObject:(ObjectP[{Object[Sample], Model[Sample]}]|_String),myOptions:OptionsPattern[]]:=ValidExperimentSupercriticalFluidChromatographyQ[{myObject},myOptions];

ValidExperimentSupercriticalFluidChromatographyQ[myObjects:{(ObjectP[{Object[Sample], Model[Sample]}]|_String)...},myOptions:OptionsPattern[]]:=Module[
  {listedOptions,preparedOptions,hplcTests,validObjectBooleans,voqWarnings,
    allTests,verbose,outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentSupercriticalFluidChromatography *)
  hplcTests = ExperimentSupercriticalFluidChromatography[myObjects, Append[preparedOptions, Output -> Tests]];

  (* Create warnings for invalid objects *)
  validObjectBooleans = ValidObjectQ[DeleteCases[myObjects,_String], OutputFormat -> Boolean];
  voqWarnings = MapThread[
    Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
      #2,
      True
    ]&,
    {DeleteCases[myObjects,_String], validObjectBooleans}
  ];

  (* Make a list of all the tests *)
  allTests = Join[hplcTests,voqWarnings];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  (* like if I ran OptionDefault[OptionValue[ValidExperimentSupercriticalFluidChromatographyQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentSupercriticalFluidChromatographyQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentSupercriticalFluidChromatographyQ"]
];


(*helper functions*)

(*injectionTableFrequencyDetermination*)

(*this is a general function that helps determine the frequency of a Standard, Blank, ColumnPrime|ColumnFlush in the injection table*)
injectionTableFrequencyDetermination[injectionTable_,type_]:=Module[{subInjectionTable,typePositions,onlySamplesTable,gradientChangePositions,
    clusteredPositions,clusterLengths,clusteredQ,convertedTypePositions},

  (*first get the injection table that's only the samples and the standards (because the frequency is always determined with respect to the samples)*)
  subInjectionTable=Cases[injectionTable,{Sample | type, _, _, _, _}];
  (*get all of the type positions*)
  typePositions=Sequence@@@Position[subInjectionTable,{type, _, _, _, _}];
  (*some times we may have contiguous groups of the specified type. in which, case we actually care about the position of each group. otherwise, we need to adjust the type positions with respect to the samples*)
  clusteredPositions=FindClusters[typePositions];
  (*get the lengths of each clusters*)
  clusterLengths=Map[Length,clusteredPositions];
  (*now we ask if all the groups have the same length and if that length is greater than 1*)
  clusteredQ=First[clusterLengths]>1&&And@@(SameQ[First[clusterLengths],#]&/@clusterLengths);
  (*now we need to convert the positions with respect to the samples*)
  convertedTypePositions=(Null); (*TODO: finish this mental pretzel*)
  (*get the sub sample table*)
  onlySamplesTable=Cases[injectionTableLookup,{Sample , _, _, _, _}];
  (*get the sample gradients and split into separate groups and take the length of each one*)
  gradientChangePositions=Length/@Gather[onlySamplesTable[[All,5]]];
  (*now we make a judgement of which one it is*)
  Which[
    MatchQ[convertedTypePositions,{0,Length[onlySamplesTable]}],FirstAndLast,
    MatchQ[convertedTypePositions,{Length[onlySamplesTable]}],Last,
    MatchQ[convertedTypePositions,{0}],First,
    (*gradient change case*)
    (*integer case*)
    (*ultimatley, it's a custom solution, so we set the InjectionTable to Null*)
    True,Null
  ]
];


(* ::Subsubsection::Closed:: *)
(*resolveSFCGradient*)


(*we need to use a separate resolving function here because the SFC gradient also has the CO2 gradient and the backpressure in its gradient*)


sfcGradientP:={{TimeP,PercentP,PercentP,PercentP,PercentP,PercentP,PressureP,FlowRateP}...};

(*this overload runs for no gradient start/end and if the gradient duration is Null*)
resolveSFCGradient[myGradientValue:(Automatic|sfcGradientP|Null),myCO2GradientValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),myBackPressureValue:({{TimeP,PressureP}..}|PressureP),myGradientDuration:(Null)]:=resolveSFCGradient[
  myGradientValue,
  myCO2GradientValue,
  myGradientAValue,
  myGradientBValue,
  myGradientCValue,
  myGradientDValue,
  myFlowRateValue,
  myBackPressureValue,
  Null,
  Null,
  myGradientDuration
];

(*this one runs is the same as above but when the gradient duration is specified*)
resolveSFCGradient[myGradientValue:(Automatic|sfcGradientP|Null),myCO2GradientValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),myBackPressureValue:({{TimeP,PressureP}..}|PressureP),myGradientDuration:(TimeP)]:=resolveSFCGradient[
  myGradientValue,
  myCO2GradientValue,
  myGradientAValue,
  myGradientBValue,
  myGradientCValue,
  myGradientDValue,
  myFlowRateValue,
  myBackPressureValue,
  0*Percent,
  0*Percent,
  myGradientDuration
];

resolveSFCGradient[myGradientValue:(Automatic|sfcGradientP|Null),myCO2GradientValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientAValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientBValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientCValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myGradientDValue:(Null|Automatic|{{TimeP,PercentP}..}|PercentP),myFlowRateValue:({{TimeP,FlowRateP}..}|FlowRateP),myBackPressureValue:({{TimeP,PressureP}..}|PressureP),myGradientStart:(PercentP|Null),myGradientEnd:(PercentP|Null),myGradientDuration:(TimeP|Null)]:=Module[
  {co2GradientTimepoints,gradientATimepoints,gradientBTimepoints,gradientCTimepoints,gradientDTimepoints,gradientASpecifiedTimes,
    gradientBSpecifiedTimes,gradientCSpecifiedTimes,gradientDSpecifiedTimes,co2GradientSpecifiedTimes,minCO2Time,maxCO2Time,minATime,maxATime,minBTime,maxBTime,
    minCTime,maxCTime,minDTime,maxDTime,specifiedTimes,maxTime,minTime,interpolationTimepointsA,interpolationTimepointsB,
    interpolationTimepointsC,interpolationTimepointsD,interpolatedGradientALookup,interpolatedGradientBLookup,interpolationTimepointsCO2,allBackPressures,
    interpolatedGradientCO2Lookup,interpolatedGradientCLookup,interpolatedGradientDLookup,compositionTuples,allCompositionTuples,allTimes,allFlowRates},

  (* If a full gradient is specified, use that gradient *)
  If[MatchQ[myGradientValue,sfcGradientP],
    Return[myGradientValue]
  ];

  co2GradientTimepoints = Switch[myCO2GradientValue,
    (* If timepoints are specified, use them *)
    {{TimeP,PercentP}...},myCO2GradientValue,
    (* If a single isocratic percent is specified, build gradient
    as a constant percentage from 0 min to gradient duration *)
    PercentP,
    {
      {0. Minute, myCO2GradientValue},
      (* If GradientDuration is Null, then default to 0 min
      (full CO2Gradient will be expanded below to the max time)*)
      If[NullQ[myGradientDuration],
        Nothing,
        {myGradientDuration,myCO2GradientValue}
      ]
    },
    _,
    (* If Gradient option is specified, inherit CO2Gradient from its value *)
    Switch[myGradientValue,
      (* If gradient tuples are specified, take the first index (time) and second (CO2 %) *)
      sfcGradientP,
      myGradientValue[[All,{1,2}]],
      _,
      (* If start/end/duration is specified, they specify cosolvent A composition,
        Fill the remaining composition with CO2*)
      If[MatchQ[myGradientStart,PercentP],
        {
          {0. Minute,100. Percent - myGradientStart},
          (* If GradientDuration is Null, then default to 0 min
          (full CO2Gradient will be expanded below to the max time)*)
          If[NullQ[myGradientDuration],
            Nothing,
            {myGradientDuration,100. Percent - myGradientEnd}
          ]
        },
        (* If nothing is specified, CosolventA is not used *)
        {}
      ]
    ]
  ];

  gradientATimepoints = Switch[myGradientAValue,
    (* If timepoints are specified, use them *)
    {{TimeP,PercentP}...},myGradientAValue,
    (* If a single isocratic percent is specified, build gradient
    as a constant percentage from 0 min to gradient duration *)
    PercentP,
    {
      {0. Minute, myGradientAValue},
      (* If GradientDuration is Null, then default to 0 min
      (full GradientA will be expanded below to the max time)*)
      If[NullQ[myGradientDuration],
        Nothing,
        {myGradientDuration,myGradientAValue}
      ]
    },
    _,
    (* If Gradient option is specified, inherit GradientA from its value *)
    Switch[myGradientValue,
      (* If gradient tuples are specified, take the first index (time) and second (buffer A %) *)
      sfcGradientP,
      myGradientValue[[All,{1,3}]],
      _,
      (* If start/end/duration is specified, they specify Cosolvent A composition,
        Fill the remaining composition with CO2 *)
      If[MatchQ[myGradientStart,PercentP],
        {
          {0. Minute,myGradientStart},
          (* If GradientDuration is Null, then default to 0 min
          (full GradientA will be expanded below to the max time)*)
          If[NullQ[myGradientDuration],
            Nothing,
            {myGradientDuration,myGradientEnd}
          ]
        },
        (* If nothing is specified, CosolventA is not used *)
        {}
      ]
    ]
  ];

  gradientBTimepoints = Switch[myGradientBValue,
    (* If timepoints are specified, use them *)
    {{TimeP,PercentP}...},myGradientBValue,
    (* If a single isocratic percent is specified, build gradient
    as a constant percentage from 0 min to gradient duration *)
    PercentP,
    {
      {0. Minute, myGradientBValue},
      (* If GradientDuration is Null, then default to 0 min
      (full GradientB will be expanded below to the max time)*)
      If[NullQ[myGradientDuration],
        Nothing,
        {myGradientDuration,myGradientBValue}
      ]
    },
    _,
    (* If Gradient option is specified, inherit GradientB from its value *)
    Switch[myGradientValue,
      (* If gradient tuples are specified, take the first index (time) and third (cosolvent B %) *)
      sfcGradientP,
        myGradientValue[[All,{1,4}]],
      _,
      (* If nothing is specified, CosolventB is not used *)
       {}
    ]
  ];

  gradientCTimepoints = Switch[myGradientCValue,
    (* If timepoints are specified, use them *)
    {{TimeP,PercentP}...},myGradientCValue,
    (* If a single isocratic percent is specified, build gradient
    as a constant percentage from 0 min to gradient duration *)
    PercentP,
    {
      {0. Minute, myGradientCValue},
      (* If GradientDuration is Null, then default to 0 min
      (full GradientC will be expanded below to the max time)*)
      If[NullQ[myGradientDuration],
        Nothing,
        {myGradientDuration,myGradientCValue}
      ]
    },
    _,
    (* If Gradient option is specified, inherit GradientC from its value *)
    Switch[myGradientValue,
      (* If gradient tuples are specified, take the first index (time) and fourth (buffer C %) *)
      sfcGradientP,
      myGradientValue[[All,{1,5}]],
      _,
      (* If nothing is specified, BufferC is not used *)
      {}
    ]
  ];

  gradientDTimepoints = Switch[myGradientDValue,
    (* If timepoints are specified, use them *)
    {{TimeP,PercentP}...},myGradientDValue,
    (* If a single isocratic percent is specified, build gradient
    as a constant percentage from 0 min to gradient duration *)
    PercentP,
    {
      {0. Minute, myGradientDValue},
      (* If GradientDuration is Null, then default to 0 min
      (full GradientD will be expanded below to the max time)*)
      If[NullQ[myGradientDuration],
        Nothing,
        {myGradientDuration,myGradientDValue}
      ]
    },
    _,
    (* If Gradient option is specified, inherit GradientD from its value *)
    Switch[myGradientValue,
      (* If gradient tuples are specified, take the first index (time) and fifth (cosolvent D %) *)
      sfcGradientP,
      myGradientValue[[All,{1,6}]],
      _,
      (* If nothing is specified, Cosolvent D is not used *)
      {}
    ]
  ];

  (* Fetch the times explicitly specified for each option *)
  co2GradientSpecifiedTimes = DeleteDuplicates[Sort[Convert[co2GradientTimepoints[[All,1]],Minute]],(#1==#2)&];
  gradientASpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientATimepoints[[All,1]],Minute]],(#1==#2)&];
  gradientBSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientBTimepoints[[All,1]],Minute]],(#1==#2)&];
  gradientCSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientCTimepoints[[All,1]],Minute]],(#1==#2)&];
  gradientDSpecifiedTimes = DeleteDuplicates[Sort[Convert[gradientDTimepoints[[All,1]],Minute]],(#1==#2)&];

  (* Extract the min and max times (the doman specified) *)
  {minCO2Time,maxCO2Time} = {Min[co2GradientSpecifiedTimes],Max[co2GradientSpecifiedTimes]};
  {minATime,maxATime} = {Min[gradientASpecifiedTimes],Max[gradientASpecifiedTimes]};
  {minBTime,maxBTime} = {Min[gradientBSpecifiedTimes],Max[gradientBSpecifiedTimes]};
  {minCTime,maxCTime} = {Min[gradientCSpecifiedTimes],Max[gradientCSpecifiedTimes]};
  {minDTime,maxDTime} = {Min[gradientDSpecifiedTimes],Max[gradientDSpecifiedTimes]};

  (* Get all specified times (such that we can interpolate values for all times) *)
  specifiedTimes = DeleteDuplicates[
    Sort[
      Convert[
        Join[
          co2GradientSpecifiedTimes,
          gradientASpecifiedTimes,
          gradientBSpecifiedTimes,
          gradientCSpecifiedTimes,
          gradientDSpecifiedTimes
        ],
        Minute
      ]
    ],
    (* Use == for the case where equivalent numbers like 0 and 0. are compared *)
    (#1 == #2)&
  ];

  (* Fetch final time *)
  maxTime = Max[specifiedTimes];

  (* Fetch initial time *)
  minTime = If[Length[specifiedTimes]>0, Min[specifiedTimes], 0 Minute];

  (* Find all the specified times within the domain for each buffer gradient
  (these times we will interpolate to find the value of) *)
  interpolationTimepointsCO2 = Cases[specifiedTimes,RangeP[minCO2Time,maxCO2Time]];
  interpolationTimepointsA = Cases[specifiedTimes,RangeP[minATime,maxATime]];
  interpolationTimepointsB = Cases[specifiedTimes,RangeP[minBTime,maxBTime]];
  interpolationTimepointsC = Cases[specifiedTimes,RangeP[minCTime,maxCTime]];
  interpolationTimepointsD = Cases[specifiedTimes,RangeP[minDTime,maxDTime]];

  (* Interpolate points that are not specified for CO2Gradient *)
  interpolatedGradientCO2Lookup = AssociationThread[interpolationTimepointsCO2->getInterpolationValuesForTimes[co2GradientTimepoints,interpolationTimepointsCO2]];

  (* Interpolate points that are not specified for GradientA *)
  interpolatedGradientALookup = AssociationThread[interpolationTimepointsA->getInterpolationValuesForTimes[gradientATimepoints,interpolationTimepointsA]];

  (* Interpolate points that are not specified for GradientB *)
  interpolatedGradientBLookup = AssociationThread[interpolationTimepointsB->getInterpolationValuesForTimes[gradientBTimepoints,interpolationTimepointsB]];

  (* Interpolate points that are not specified for GradientC *)
  interpolatedGradientCLookup = AssociationThread[interpolationTimepointsC->getInterpolationValuesForTimes[gradientCTimepoints,interpolationTimepointsC]];

  (* Interpolate points that are not specified for GradientD *)
  interpolatedGradientDLookup = AssociationThread[interpolationTimepointsD->getInterpolationValuesForTimes[gradientDTimepoints,interpolationTimepointsD]];

  (* Build tuples of each buffer composition for each specified time in the form {CO2%, %A,%B,%C,%D} *)
  compositionTuples = Map[
    Function[time,
      Module[
        {gradientCO2Value,gradientAValue,gradientBValue,gradientCValue,gradientDValue,defaultedCompositionTuple,
          totalComposition,bufferCompositions},

        (* Fetch value for each gradient at the current time. If the value is not specified,
        it means the timepoint is outside the gradient's specified range *)
        gradientCO2Value = Lookup[interpolatedGradientCO2Lookup,time,Null];
        gradientAValue = Lookup[interpolatedGradientALookup,time,Null];
        gradientBValue = Lookup[interpolatedGradientBLookup,time,Null];
        gradientCValue = Lookup[interpolatedGradientCLookup,time,Null];
        gradientDValue = Lookup[interpolatedGradientDLookup,time,Null];

        (* By default, set the gradient composition outside the specified range to 0 *)
        defaultedCompositionTuple = Replace[{gradientCO2Value,gradientAValue,gradientBValue,gradientCValue,gradientDValue},Null->0 Percent,{1}];

        (* Calculate the total specified composition (ie: the summed percentages for each gradient) *)
        totalComposition = Total[defaultedCompositionTuple];

        (* Decide how to default the gradient values (if needed) *)
        bufferCompositions = Which[
          (* If the composition at the current timepoint is already 100% then we don't need to fill in any extra composition.
          If it is > 100% then the gradient specified is invalid and an error will be thrown downstream *)
          totalComposition >= 100 Percent, defaultedCompositionTuple,
          (* If the composition is < 100% and CO2 is unspecified at this timepoint, then fill in the remaining composition with CO2 *)
          NullQ[gradientCO2Value],  ReplacePart[defaultedCompositionTuple,1->(100 Percent - totalComposition)],
          (* If the composition is < 100% and A is unspecified at this timepoint, then fill in the remaining composition with A *)
          NullQ[gradientAValue],  ReplacePart[defaultedCompositionTuple,2->(100 Percent - totalComposition)],
          (* If A is specified and B is not, fill in the remaining composition with B *)
          NullQ[gradientBValue],  ReplacePart[defaultedCompositionTuple,3->(100 Percent - totalComposition)],
          (* If A and B are specified and C is not, fill in the remaining composition with C *)
          NullQ[gradientCValue],  ReplacePart[defaultedCompositionTuple,4->(100 Percent - totalComposition)],
          (* If gradient D is being used, A, B, and C are specified, and D is not, fill in the remaining composition with D  *)
          (Length[gradientDTimepoints]>0)&&NullQ[gradientDValue],  ReplacePart[defaultedCompositionTuple,5->(100 Percent - totalComposition)],
          (* Everything was specified and it still doesn't add to 100%  (in this case we throw error downstream) *)
          True,  defaultedCompositionTuple
        ];

        (* Add time to first index of gradient timepoint *)
        Prepend[bufferCompositions,time]
      ]
    ],
    specifiedTimes
  ];

  (* If the minimum specified time is not 0 min, then extend the composition at the minimum time to 0 min *)
  allCompositionTuples = If[minTime != 0 Minute,
    Prepend[
      compositionTuples,
      ReplacePart[First[compositionTuples],1 -> 0 Minute]
    ],
    compositionTuples
  ];

  (* Fetch all times for FlowRate and BackPressure interpolation *)
  allTimes = allCompositionTuples[[All,1]];

  (* If the flowrate is a constant value, set same flow rate to all timepoints
  Otherwise, like the gradients above, interpolate its value and append the final timepoint *)
  allFlowRates = If[MatchQ[myFlowRateValue,FlowRateP],
    Table[myFlowRateValue,Length[allTimes]],
    getInterpolationValuesForTimes[
      DeleteDuplicates@Append[myFlowRateValue,{maxTime,Last[myFlowRateValue[[All,2]]]}],
      allTimes
    ]
  ];

  (* If the backpressure is a constant value, set same backpressure to all timepoints
  Otherwise, like the gradients above, interpolate its value and append the final timepoint *)
  allBackPressures = If[MatchQ[myBackPressureValue,PressureP],
    Table[myBackPressureValue,Length[allTimes]],
    getInterpolationValuesForTimes[
      DeleteDuplicates@Append[myBackPressureValue,{maxTime,Last[myBackPressureValue[[All,2]]]}],
      allTimes
    ]
  ];

  MapThread[
    Append[Append[#1,#2],#3]&,
    {allCompositionTuples,allBackPressures,allFlowRates}
  ]
];


(*articulate the default gradients*)
defaultSFCGradient[myDefaultFlowRate:FlowRateP,myDefaultBackPressure:PressureP]:={
  {Quantity[0., Minute], Quantity[96., Percent], Quantity[4., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate},
  {Quantity[10., Minute], Quantity[50., Percent], Quantity[50., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate}
};

defaultSFCPrimeGradient[myDefaultFlowRate:FlowRateP,myDefaultBackPressure:PressureP]:={
  {Quantity[0., Minute], Quantity[50., Percent], Quantity[50., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate},
  {Quantity[10., Minute], Quantity[96., Percent], Quantity[4., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate},
  {Quantity[15., Minute], Quantity[96., Percent], Quantity[4., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate}
};

defaultSFCFlushGradient[myDefaultFlowRate:FlowRateP,myDefaultBackPressure:PressureP]:={
  {Quantity[0., Minute], Quantity[96., Percent], Quantity[4., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate},
  {Quantity[2., Minute], Quantity[50., Percent], Quantity[50., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate},
  {Quantity[15., Minute], Quantity[50., Percent], Quantity[50., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultBackPressure, myDefaultFlowRate}
};
