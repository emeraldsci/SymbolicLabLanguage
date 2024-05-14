(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDynamicLightScattering*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDynamicLightScattering Options and Messages*)

DefineOptions[ExperimentDynamicLightScattering,
  Options:> {
    {
      OptionName -> AssayType,
      Default -> Automatic,
      Description -> "The Dynamic Light Scattering (DLS) assay that is run. SizingPolydispersity makes a single DLS measurement that provides information about the size and polydispersity (defined as the ratio of mass-average molar mass to number-average molar mass) of particles in the input samples. ColloidalStability makes DLS measurements at various dilutions of a sample below 25 mg/mL to calculate the diffusion interaction parameter (kD) and the second virial coefficient (B22 or A2), and does the same for a sample of mass concentration 20-100 mg/mL to calculate the Kirkwood-Buff Integral (G22) at each dilution concentration; Static Light Scattering (SLS) measurements can be used to calculate A2 and the molecular weight of the analyte. MeltingCurve makes DLS measurements over a range of temperatures in order to calculate melting temperature (Tm), temperature of aggregation (Tagg), and temperature of onset of unfolding (Tonset). IsothermalStability makes multiple DLS measurements at a single temperature over time in order to probe stability of the analyte at a particular temperature.",
      ResolutionDescription -> "The AssayType is set to IsothermalStability if any of the options in the \"Isothermal Stability\" category are specified, to MeltingCurve if any of the options in the \"Melting Curve\" category are defined, to ColloidalStability if Dilution-related options are specified, and to SizingPolydispersity otherwise.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> DynamicLightScatteringAssayTypeP
      ],
      Category -> "General"
    },
    {
      OptionName -> AssayFormFactor,
      Default -> Automatic,
      Description -> "Indicates if the sample is loaded in capillary strips, which are utilized by a Multimode Spectrophotometer, or a standard plate which is utilized by a DLS Plate Reader.",
      ResolutionDescription -> "AssayFormFactor is set to Capillary if the Instrument model is set to Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] and Plate if Instrument is set to Model[Instrument,DLSPlateReader,\"DynaPro\"]. If neither AssayFormFactor nor Instrument is defined, AssayFormFactor is set to Capillary if SampleVolume is set to 25 uL and Object[Instrument,DLSPlateReader,\"DynaPro\" if SampleVolume is set to greater than 25 uL.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Capillary, Plate]
      ],
      Category -> "General"
    },
    {
      OptionName -> Instrument,
      Default -> Automatic,
      Description -> "The instrument used for this experiment. Options comprise Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"], or any instruments of that model, which uses a capillary form factor and can perform fluorescence as well as light scattering experiments assays, and Model[Instrument,DLSPlateReader,\"DynaPro\"], or any instruments of that model, which uses a plate form factor and performs only light scattering experiments.",
      ResolutionDescription -> "Instrument is set to Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] if AssayFormFactor is set to Capillary and Model[Instrument,DLSPlateReader,\"DynaPro\"] if AssayFormFactor is set to Plate. If neither AssayFormFactor nor Instrument is defined, Instrument is set to Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] if SampleVolume is set to 25 uL or less and Model[Instrument,DLSPlateReader,\"DynaPro\"] if SampleVolume is set to greater than 25 uL.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Instrument, MultimodeSpectrophotometer], Model[Instrument, MultimodeSpectrophotometer], Object[Instrument, DLSPlateReader], Model[Instrument, DLSPlateReader]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments", "Light Scattering Devices"
          }
        }
      ],
      Category -> "General"
    },
    {
      OptionName -> SampleLoadingPlate,
      Default -> Automatic,
      Description -> "When AssayFormFactor is Capillary, the container into which input samples are transferred (or in which input sample dilutions are performed when AssayType is ColloidalStability) before centrifugation and transfer into the AssayContainer(s) for DLS measurement.",
      ResolutionDescription -> "The SampleLoadingPlate is set to Null when AssayFormFactor is Plate and to Model[Container, Plate, \"96-well PCR Plate\"] when AssayFormFactor is Capillary.",
      AllowNull -> True,
      Category -> "Sample Loading",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Container, Plate], Model[Container, Plate]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Containers", "Plates"
          }
        }
      ]
    },
    {
      OptionName -> NumberOfReplicates,
      Default -> Automatic,
      Description -> "The number of times the specified Dynamic Light Scattering (DLS) assay is run on each input sample. In practice, this refers to the number of wells of the AssayContainer(s) that each input sample occupies. For example, ExperimentDynamicLightScattering[{input1, input2}, NumberOfReplicates->2] is equivalent to ExperimentDynamicLightScattering[{input1, input1, input2, input2}]. When AssayType is SizingPolydispersity, IsothermalStability, and MeltingCurve, NumberOfReplicates refers to the number of wells for each distinct input sample. When AssayType is ColloidalStability, NumberOfReplicates refers to the replicates of each dilution concentration of each sample. At least two replicates of each dilution concentration are required for ColloidalStability, and three are recommended.",
      ResolutionDescription -> "Automatically set to 3 if AssayType is ColloidalStability and 2 otherwise.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[1, 384, 1]
      ],
      Category -> "Sample Loading"
    },

    (* ColloidalStability Options (including the Dilution Curve options) *)
    {
      OptionName -> ColloidalStabilityParametersPerSample,
      Default -> Automatic,
      Description -> "The number of dilution concentrations made for, and thus independent B22/A2 and kD or G22 parameters calculated from, each input sample.",
      ResolutionDescription -> "When AssayType is ColloidalStability, ColloidalStabilityParametersPerSample is set to 2. Otherwise, it is set to Null.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[1, 24, 1]
      ],
      Category -> "Colloidal Stability"
    },
    {
      OptionName -> ReplicateDilutionCurve, (*TODO: We said we'd delete this, but keeping for now*)
      Default -> Automatic,
      Description -> "Indicates if a NumberOfReplicates number of StandardDilutionCurves or SerialDilutionCurves are made for each input sample. When ReplicateDilutionCurve is True, the replicate DLS measurements for ColloidalStability assay are made from the same concentration of each of the StandardDilutionCurves or SerialDilutionCurves created from a given input sample. When ReplicateDilutionCurve is False, the replicate DLS measurements for the ColloidalStability assay are made from aliquots of a given concentration of the DilutionCurve or SerialDilutionCurve.",
      ResolutionDescription -> "The ReplicateDilutionCurve is set to False if the AssayType is ColloidalStability and to Null otherwise.",
      AllowNull -> True,
      Category -> "Sample Dilution",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ]
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> Analyte,
        Default -> Automatic,
        Description -> "For each input sample, the Model[Molecule] member of the Composition field whose concentration is used to calculate B22/A2 and kD or G22 when the AssayType is ColloidalStability.",
        ResolutionDescription -> "Automatically set to Null when AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, or when DilutionType is SerialDilution. When AssayType is ColloidalStability, automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
        AllowNull -> True,
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[Model[Molecule]]
        ]
      },
      {
        OptionName -> AnalyteMassConcentration,
        Default -> Automatic,
        Description -> "For each input sample, the initial mass concentration of the Analyte before any dilutions outlined by the StandardDilutionCurve or SerialDilutionCurve are performed when the AssayType is ColloidalStability.",
        ResolutionDescription -> "Automatically set to Null when AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, or when DilutionType is SerialDilution. When AssayType is ColloidalStability, automatically set to the mass concentration of the first value in the Analytes field of the input sample, or, if not populated, to that of the first analyte in the Composition field of the input sample, or if none exist, that of the first identity model of any kind in the Composition field.",
        AllowNull -> True,
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterEqualP[0 * Milligram / Milliliter] | GreaterP[0 * Molar],
          Units -> Alternatives[
            CompoundUnit[
              {1, {Gram, {Gram, Microgram, Milligram}}},
              {-1, {Liter, {Liter, Microliter, Milliliter}}}
            ],
            {1, {Micromolar, {Micromolar, Millimolar, Molar}}}
          ]
        ]
      },
      {
        OptionName -> StandardDilutionCurve,
        Default -> Automatic,
        Description -> "The collection of dilutions that are performed on each input sample in the SampleLoadingPlate or AssayContainer. For Fixed Dilution Volume Dilution Curves, the Sample Amount is the volume of the sample that is mixed with the Buffer to the Total Volume to create a desired concentration.  For Fixed Target Concentration Dilution Curves, the Target Concentration is the desired final concentration of analyte after dilution of the input samples with the Buffer.",
        ResolutionDescription -> "The Dilution is set to Null if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, or if the SerialDilutionCurve option is specified. Otherwise, when AssayFormFactor is Capillary, the option is set to be {{14 uL, 10 mg/mL},{14 uL, 8 mg/mL},{14 uL, 6 mg/mL},{14 uL, 4 mg/mL},{14 uL, 2 mg/mL}} if ReplicateDilutionCurve is True, or to be {{14 uL times NumberOfReplicates), 10 mg/mL},{14 uL times NumberOfReplicates), 8 mg/mL},{14 uL times NumberOfReplicates), 6 mg/mL},{14 uL times NumberOfReplicates), 4 mg/mL},{14 uL times NumberOfReplicates), 2 mg/mL}} if ReplicateDilutionCurve is False. When AssayFormFactor is Plate, the Sample Amount is set to 30 uL or 30 uL times NumberOfReplicates.",
        AllowNull -> True,
        Category -> "Sample Dilution",
        Widget -> Alternatives[
          Adder[
            {
              "Sample Amount" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, $MaxTransferVolume], Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}],
              "Total Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, $MaxTransferVolume], Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}]
            }
          ],
          Adder[
            {
              "Sample Amount" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, $MaxTransferVolume], Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}],
              "Target Concentration" -> Widget[
                Type -> Quantity,
                Pattern :> GreaterEqualP[0 * Milligram / Milliliter] | GreaterP[0 * Molar],
                Units -> Alternatives[
                  CompoundUnit[
                    {1, {Milligram, {Gram, Microgram, Milligram}}},
                    {-1, {Milliliter, {Liter, Microliter, Milliliter}}}
                  ],
                  {1, {Micromolar, {Micromolar, Millimolar, Molar}}}
                ]
              ]
            }
          ]
        ]
      },
      {
        OptionName -> SerialDilutionCurve,
        Default -> Automatic,
        Description -> "The collection of dilutions that are performed on each input sample in the SampleLoadingPlate or AssayContainer. For Serial Dilution Factors, the sample will be diluted with the Buffer by the dilution factor at each transfer step. For example, a SerialDilutionCurve of {36*Microliter,{1,1.25,2,2},1} for a 100 mg/mL sample will result in 4 dilutions with concentrations of 100 mg/mL, 80 mg/mL, 40 mg/mL, and 20 mg/mL. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Buffer Volume of the Buffer. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 mg/mL sample with a Transfer Volume of 30 Microliters, a Buffer Volume of 10 Microliters and a Number of Dilutions of 2 is used, it will create a SerialDilutionCurve of 75 mg/mL, 56.3 mg/mL, and 42.2 mg/mL.",
        ResolutionDescription -> "The SerialDilutionCurve is set to Null if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, or if the StandardDilutionCurve option is specified. Otherwise, when AssayFormFactor is Capillary, the option is set to be {15 uL, {1, 1.25, 1.333, 1.5, 2}, 1} if ReplicateDilutionCurve is True, or to be {(15 uL times NumberOfReplicates), {1, 1.25, 1.333, 1.5, 2}, 1} if ReplicateDilutionCurve is False. When AssayFormFactor is Plate, the Sample Volume is set to 30 uL or 30 uL times NumberOfReplicates. In both cases, the dilution factors with respect to the input sample are {1, 1.25, 1.333, 1.5, 2}, so a 10 mg/mL sample would be diluted to {10 mg/mL, 8 mg/mL, 6 mg/mL, 4 mg/mL, 2 mg/mL}.",
        AllowNull -> True,
        Category -> "Sample Dilution",
        Widget -> Alternatives[
          "Serial Dilution Volumes" ->
              {
                "Transfer Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, $MaxTransferVolume], Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}],
                "Buffer Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, $MaxTransferVolume], Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}],
                "Number Of Dilutions" -> Widget[Type -> Number, Pattern :> RangeP[1, 48, 1]]
              },
          "Serial Dilution Factor" ->
              {
                "Sample Volume" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, $MaxTransferVolume], Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}], (*TODO: throw an error if it's less than 15*)
                "Serial Dilution Factors" -> Adder[
                  Widget[
                    Type -> Number,
                    Pattern :> GreaterEqualP[1]
                  ]
                ],
                "Number Of Serial Dilutions" -> Widget[
                  Type -> Number,
                  Pattern :> GreaterEqualP[1, 1]
                ]
              }
        ]
      },
      {
        OptionName -> Buffer,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The buffer or solvent that is used to dilute the sample to make a DilutionCurve.",
        ResolutionDescription -> "The Buffer is set to Null if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve. If the AssayType is ColloidalStability, the Buffer is set to the BlankBuffer if it is specified, to the Solvent of the input sample if the BlankBuffer is not specified, and to Model[Sample, \"Milli-Q water\"] otherwise.",
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
          ObjectTypes -> {Model[Sample], Object[Sample]},
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Materials", "Reagents", "Buffers"
            },
            {
              Object[Catalog, "Root"],
              "Materials", "Reagents", "Solvents"
            }
          }
        ]
      },
      {
        OptionName -> DilutionMixType,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "Indicates the method used to mix the SampleLoadingPlate or AssayContainer used for dilution.",
        ResolutionDescription -> "Automatically set to Manual when AssayType is ColloidalStability, and to Null otherwise.",
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[Pipette, Vortex, Nutator]
        ]
      },
      {
        OptionName -> DilutionMixVolume,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The volume that is pipetted up and down from the dilution to mix the sample with the Buffer to make the mixture homogeneous.",
        ResolutionDescription -> "The DilutionMixVolume is set to Null if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve; or if either the DilutionNumberOfMixes or DilutionMixRate is specified as Null; or if MixFormFactor is set to Nutator or Vortex; and to 5 uL otherwise.",
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Microliter, $MaxPipetteVolume],
          Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
        ]
      },
      {
        OptionName -> DilutionNumberOfMixes,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The number of pipette out and in cycles that is used to mix the sample with the Buffer to make the DilutionCurve.",
        ResolutionDescription -> "The DilutionMixVolume is set to Null if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve; or if either the DilutionNumberOfMixes or DilutionMixRate is specified as Null; or if MixFormFactor is set to Vortex; and to 5 otherwise.",
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[0, 20, 1]
        ]
      },
      {
        OptionName -> DilutionMixRate,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The speed at which the DilutionMixVolume is pipetted out of and into the dilution to mix the sample with the Buffer to make the DilutionCurve.",
        ResolutionDescription -> "The DilutionMixVolume is set to Null if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve; or if either the DilutionNumberOfMixes or DilutionMixRate is specified as Null; or if MixFormFactor is set to Vortex; and to 30 uL/second otherwise.",
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0.4 Microliter / Second, 250 Microliter / Second],
          Units -> CompoundUnit[
            {1, {Microliter, {Microliter, Milliliter}}},
            {-1, {Second, {Second, Minute}}}
          ]
        ]
      },
      {
        OptionName -> DilutionMixInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Description -> "The instrument used to mix the dilutions in the SampleLoadingPlate or AssayContainer used for dilution.",
        ResolutionDescription -> "DilutionMixInstrument is automatically set to Model[Instrument,Pipette] if DilutionMixType is set to Pipette; to Model[Instrument,Vortex] if DilutionMixType is set to Vortex; to Model[Instrument,Nutator] if DilutionMixType is set to Nutator; and to Null if AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve.",
        AllowNull -> True,
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[
            {
              Model[Instrument, Pipette],
              Object[Instrument, Pipette],
              Model[Instrument, Vortex],
              Object[Instrument, Vortex],
              Model[Instrument, Nutator],
              Object[Instrument, Nutator]
            }
          ],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Instruments", "Mixing Devices"
            }
          }
        ]
      },
      {
        (*Note: this option is recommended only for the Uncle, not the DynaPro*)
        OptionName -> BlankBuffer,
        Default -> Automatic,
        Description -> "The sample that is used as a 0 mg/mL blank in ColloidalStability assays, to determine the diffusion coefficient at infinite dilution.",
        ResolutionDescription -> "The BlankBuffer is set to the Buffer if the AssayType is ColloidalStability and to Null otherwise.",
        AllowNull -> True,
        Category -> "Sample Dilution",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Materials", "Reagents", "Buffers"
            },
            {
              Object[Catalog, "Root"],
              "Materials", "Reagents", "Solvents"
            }
          }
        ]
      }
    ],
    {
      OptionName -> CalculateMolecularWeight,
      Default -> Automatic,
      Description -> "When AssayFormFactor is Plate, determines if Static Light Scattering (SLS) is used to calculate weight-average molecular weight.",
      ResolutionDescription -> "When AssayFormFactor is Plate and AssayType is ColloidalStability, automatically set to True. When CollectStaticLightScattering is False or AssayFormFactor is Capillary, automatically set to Null.",
      AllowNull -> True,
      Category -> "Colloidal Stability",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ]
    },

    (* Options shared for all AssayTypes *)
    {
      OptionName -> AssayContainerFillDirection,
      Default -> Column,
      Description -> "WhenAssayFormFactor is Capillary, controls how the capillary strip AssayContainers are filled. Column indicates that all 16 wells of an AssayContainer capillary strip (Model[Container, Plate, CapillaryStrip,\"Uncle 16-capillary strip\"]) are filled with input samples or sample dilutions before starting to fill a second capillary strip (up to 3 strips, 48 wells). Row indicates that one well of each capillary strip is filled with input samples or sample dilutions before filling the second well of each strip. Setting the AssayContainerFillDirection to Column will minimize the number of capillary strips needed for the experiment, while Row will always use three capillary strips if there are more than two input samples. Setting this option to Row will ensure that replicate dilution concentration measurements in ColloidalStability occur in separate capillary strips. When AssayFormFactor is Plate, controls the direction the AssayContainer is filled: either Row, Column, SerpentineRow, or SerpentineColumn.",
      AllowNull -> True,
      Category -> "Sample Loading",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Row, Column, SerpentineRow, SerpentineColumn]
      ]
    },
    {
      OptionName->SampleVolume,
      Default->Automatic,
      Description->"When AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability, the SampleVolume is the amount of each input sample that is transferred into the SamplePreparationPlate before the SamplePreparationPlate is centrifuged and 10 uL of each sample is transferred into the AssayContainer(s) for DLS measurement. When the AssayType is ColloidalStability, the amount of input sample required for the experiment is specified with either the DilutionCurve or SerialDilutionCurve option.",
      ResolutionDescription->"If the AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability, when the AssayFormFactor is Capillary, SampleVolume is set to 15 uL; when the AssayFormFactor is Plate, SampleVolume is set to 30 uL (for a 384-well plate) or 100 uL (for a 96-well plate); and set to Null otherwise.",
      AllowNull->True,
      Category->"Sample Loading",
      Widget->Widget[
        Type->Quantity,
        Pattern:>RangeP[15*Microliter,100*Microliter],
        Units->Microliter
      ]
    },
    {
      OptionName -> Temperature,
      Default -> 25 * Celsius,
      Description -> "The temperature to which the incubation chamber is set prior to detection.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[4 * Celsius, 95 * Celsius],
        Units -> {1 Celsius, {Celsius, Fahrenheit, Kelvin}}
      ],
      Category -> "Sample Loading"
    },
    {
      OptionName -> EquilibrationTime,
      Default -> 2 Minute,
      Description -> "The length of time for which the samples are held in the chamber which is incubated at the Temperature before the first DLS measurement is made, in order to warm or cool the samples to Temperature.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 * Second, 24 Hour], (*TODO: cannot be longer than 1 hour for Uncle but theoretically unlimited for DynaPro... throw error*)
        Units -> {Minute, {Second, Minute, Hour}}
      ],
      Category -> "Sample Loading"
    },
    {
      OptionName -> CollectStaticLightScattering,
      Default -> True,
      Description -> "Indicates whether static light scattering (SLS) data are collected along with DLS data. Reliable static light scattering data can be obtained only if the combination of plate and solvent has previously been calibrated.", (*todo: editorialize - why would user want this? if keeping this option because of laser interaction, mention this here*)
      AllowNull -> False,
      Category -> "Light Scattering",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ]
    },
    {
      OptionName -> NumberOfAcquisitions,
      Default -> 4,
      Description -> "For each Dynamic Light Scattering (DLS) measurement, the number of series of speckle patterns that are each collected over the AcquisitionTime to create the measurement's autocorrelation curve.",
      AllowNull -> False,
      Category -> "Light Scattering",
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[1, 20, 1](*TODO: this is presumably upper bound for Uncle but seems reasonable for Wyatt*)
      ]
    },
    {
      OptionName -> AcquisitionTime,
      Default -> 5 * Second,
      Description -> "For each Dynamic Light Scattering (DLS) measurement, the length of time that each acquisition generates speckle patterns to create the measurement's autocorrelation curve.",
      AllowNull -> False,
      Category -> "Light Scattering",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 * Second, 30 * Second], (*TODO: this is presumably upper bound for Uncle but seems reasonable for Wyatt*)
        Units -> Second
      ]
    },
    {
      OptionName -> AutomaticLaserSettings,
      Default -> True,
      Description -> "Indicates if the LaserPower and DiodeAttenuation are automatically set at the beginning of the assay by the Instrument to levels ideal for the samples, such that the count rate falls within an optimal, predetermined range.",
      AllowNull -> False,
      Category -> "Light Scattering",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ]
    },
    {
      OptionName -> LaserPower,
      Default -> Automatic,
      Description -> "The percent of the max laser power that is used to make Dynamic Light Scattering (DLS) measurements. The laser level is optimized at run time by the instrument software when AutomaticLaserSettings is True and LaserLevel is Null.",
      ResolutionDescription -> "The LaserPower option is set to 100% if AutomaticLaserSettings is False and to Null otherwise.",
      AllowNull -> True,
      Category -> "Light Scattering",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 * Percent, 100 * Percent],
        Units -> Percent
      ]
    },
    {
      OptionName -> DiodeAttenuation,
      Default -> Automatic,
      Description -> "The percent of scattered signal that is allowed to reach the avalanche photodiode. The attenuator level is optimized at run time by the instrument software when AutomaticLaserSettings is True and DiodeAttenuation is Null.",
      ResolutionDescription -> "The DiodeAttenuation option is set to 100% if AutomaticLaserSettings is False and to Null otherwise.",
      AllowNull -> True,
      Category -> "Light Scattering",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 * Percent, 100 * Percent],
        Units -> Percent
      ]
    },
    {
      OptionName -> CapillaryLoading,
      Default -> Automatic,
      Description -> "The loading method for capillaries. When set to Robotic, capillaries are loaded by liquid handler. When set to Manual, capillaries are loaded by a multichannel pipette. Each method presents specific mechanical challenges due to the difficulty of precise loading.",
      ResolutionDescription -> "When AssayFormFactor is Capillary, set to Manual. When AssayFormFactor is Plate, set to Null.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Robotic, Manual](*TODO: can robots do this now? Get Malav to run a robotic one again*)
      ],
      Category -> "Sample Loading"
    },
    (* - Isothermal Stability Options - *)
    {
      OptionName -> MeasurementDelayTime,
      Default -> Automatic,
      Description -> "The length of time between the consecutive Dynamic Light Scattering (DLS) measurements for a specific AssayContainer well during an IsothermalStability assay. The duration of the experiment is set either by this option or by the total IsothermalRunTime.",
      ResolutionDescription -> "When AssayType is IsothermalStability and when AssayFormFactor is Capillary, the MeasurementDelayTime option is set to a value calculated by the Instrument manufacture's proprietary algorithm (dependent on the number of input samples and the IsothermalAttenuatorAdjustment); when AssayFormFactor is Plate, MeasurementDelayTime is automatically set to 1 hour. When AssayType is SizingPolydispersity, MeltingCurve, or ColloidalStability, automatically set to Null.",
      AllowNull -> True,
      Category -> "Isothermal Stability",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[70 * Second, 3.75 Hour], (*TODO: check why this range is the way it is*)
        Units -> {Second, {Second, Minute, Hour}}
      ]
    },
    {
      OptionName -> IsothermalMeasurements,
      Default -> Automatic,
      Description -> "The number of separate DLS measurements that are made during the IsothermalStability assay, either separated by MeasurementDelayTime or distributed over IsothermalRunTime.",
      ResolutionDescription -> "The IsothermalMeasurements option is set to 10 if the AssayType is IsothermalStability and the IsothermalRunTime is Null, or to Null otherwise.",
      AllowNull -> True,
      Category -> "Isothermal Stability",
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[0, 8022, 1](*TODO: upper bound*)
      ]
    },
    {
      OptionName -> IsothermalRunTime,
      Default -> Automatic,
      Description -> "The total length of the IsothermalStability assay during which the IsothermalMeasurements number of Dynamic Light Scattering (DLS) measurements are made. The duration of the experiment is set either by this option or by the MeasurementDelayTime.",
      ResolutionDescription -> "The IsothermalRunTime is set to 10 times the MeasurementDelayTime if the AssayType is IsothermalStability and the IsothermalMeasurements option is Null, or to Null otherwise.",
      AllowNull -> True,
      Category -> "Isothermal Stability",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[70 * Second, $MaxExperimentTime],
        Units -> {Minute, {Second, Minute, Hour, Day}}
      ]
    },
    {
      OptionName -> IsothermalAttenuatorAdjustment,
      Default -> Automatic,
      Description -> "Indicates if the attenuator level is automatically set for each DLS measurement throughout the IsothermalStability assay. If First, the attenuator level is automatically set for the first DLS measurement and the same level is used throughout the assay.",
      ResolutionDescription -> "The IsothermalAttenuatorAdjustment is set to Every if the AssayType is IsothermalStability and to Null otherwise.",
      AllowNull -> True,
      Category -> "Isothermal Stability",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[First, Every]
      ]
    },

    (*MeltingCurve Options*)

    {
      OptionName -> MinTemperature,
      Default -> Automatic,
      Description -> "The low temperature of the heating or cooling curve; the starting temperature when TemperatureRampOrder is {Heating,Cooling}.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to 4 Celsius if AssayFormFactor is Plate and to 15 Celsius when AssayFormFactor is Capillary. When AssayType is SizingPolydispersity, IsothermalStability, or ColloidalStability, automatically set to Null.",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[4 Celsius, 100 Celsius],
        Units -> {1, {Celsius, {Celsius, Kelvin, Fahrenheit}}}
      ],
      Category -> "Melting Curve",
      AllowNull -> True
    },
    {
      OptionName -> MaxTemperature,
      Default -> Automatic,
      Description -> "The high temperature of the heating or cooling curve; the starting temperature when TemperatureRampOrder is {Cooling,Heating}.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to 85 Celsius if AssayFormFactor is Plate and 95 Celsius if AssayFormFactor is Capillary. When AssayType is SizingPolydispersity, IsothermalStability, or ColloidalStability, automatically set to Null.",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[4 Celsius, 100 Celsius],
        Units -> {1, {Celsius, {Celsius, Kelvin, Fahrenheit}}}
      ],
      Category -> "Melting Curve",
      AllowNull -> True
    },
    {
      OptionName -> TemperatureRampOrder,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> ThermodynamicCycleP
      ],
      Description -> "The order of temperature ramping (i.e., heating followed by cooling or vice versa) to be performed in each cycle. Heating is defined as going from MinTemperature to MaxTemperature; cooling is defined as going from MaxTemperature to MinTemperature.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to {Heating,Cooling}. When AssayType is SizingPolydispersity, IsothermalStability, or ColloidalStability, automatically set to Null.",
      Category -> "Melting Curve"
    },
    {
      OptionName -> NumberOfCycles,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "The number of instances of repeated heating and cooling (or vice versa) cycles.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to 1 cycle. When AssayType is SizingPolydispersity, IsothermalStability, or ColloidalStability, automatically set to Null.",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[0.5,1,2,3]
      ],
      Category -> "Melting Curve"
    },
    {
      OptionName -> TemperatureRamping,
      Default -> Automatic,
      Description -> "The type of temperature ramp. Linear temperature ramps increase temperature at a constant rate given by TemperatureRampRate. Step temperature ramps increase the temperature by TemperatureRampStep/TemperatureRampStepTime and holds the temperature constant for TemperatureRampStepHold before measurement.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to Step if NumberOfTemperatureRampSteps or StepHoldTime are specified and to Linear if they are not specified. When AssayType is SizingPolydispersity, IsothermalStability, or ColloidalStability, automatically set to Null.",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Linear, Step]],
      AllowNull -> True,
      Category -> "Melting Curve"
    },
    {
      OptionName -> TemperatureRampRate,
      Default -> Automatic,
      Description -> "The absolute value of the rate at which the temperature is changed in the course of one heating/cooling cycle.",
      ResolutionDescription -> "When AssayType is MeltingCurve, if TemperatureRamping is Linear, automatically set to 1 Celsius/Minute (when AssayFormFactor is Capillary) or 0.25 Celsius/Minute (when AssayFormFactor is Plate), and if TemperatureRamping is Step, automatically set to the max ramp rate available on the instrument.",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[.0015 (Celsius / Second), 3.4 (Celsius / Second)],
        Units -> CompoundUnit[
          {1, {Celsius, {Celsius, Kelvin, Fahrenheit}}},
          {-1, {Second, {Second, Minute, Hour}}}
        ]
      ],
      Category -> "Melting Curve",
      AllowNull -> True
    },
    {
      OptionName -> TemperatureResolution,
      Default -> Automatic,
      AllowNull -> True,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 * Celsius, 100 * Celsius],
        Units :> {Celsius, {Celsius, Kelvin, Fahrenheit}}
      ],
      Description -> "The amount by which the temperature is changed between each data point and the subsequent data point for a given sample during the heating/cooling curves.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to highest possible resolution available for the Instrument. When AssayType is SizingPolydispersity, IsothermalStability, or ColloidalStability, automatically set to Null.", (*TODO: refer to Field in Instrument object. Is this relevant for Step>?*)
      Category -> "Melting Curve"
    },
    {
      OptionName -> NumberOfTemperatureRampSteps,
      Default -> Automatic,
      Description -> "The number of step changes in temperature for a heating or cooling cycle.",
      ResolutionDescription -> "When AssayType is MeltingCurve, if TemperatureRamping is Step, automatically set to the absolute value of the difference in MinTemperature and MaxTemperature divided by 1 Celsius, rounded to the nearest integer; if TemperatureRamping is Linear, automatically set to Null.",
      Widget -> Widget[
        Type -> Number,
        Pattern :> RangeP[1, 100, 1]
      ],
      Category -> "Melting Curve",
      AllowNull -> True
    },
    {
      OptionName -> StepHoldTime,
      Default -> Automatic,
      Description -> "The length of time samples are held at each temperature during a stepped temperature ramp prior to light scattering measurement.",
      ResolutionDescription -> "When AssayType is MeltingCurve, automatically set to 30 Second when TemperatureRamping is set to Step and Null when TemperatureRamping is set to Linear.",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[1 Second, 3.75 Hour],
        Units -> {1, {Second, {Second, Minute, Hour}}}
      ],
      Category -> "Melting Curve",
      AllowNull -> True
    },
    (*Options specific to DLSPlateReader*)
    {
      OptionName -> WellCover,
      Default -> Automatic,
      Description -> "When AssayFormFactor is Plate, determines what covering will be used for wells. Available coverings are plate seal, and oil; other covers (e.g. lids) have not yet been evaluated for their effects on light scattering optics.",
      ResolutionDescription -> "When AssayFormFactor is Plate, automatically set to Model[Sample,\"Silicone Oil\"]. When AssayFormFactor is Capillary, automatically set to Null.",
      AllowNull -> True,
      Category -> "Sample Loading",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Item, PlateSeal], Model[Item, PlateSeal], Object[Sample], Model[Sample]}](*,
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Materials", "Dynamic Light Scattering", "Well Covers"
          }
        }*)(*Todo: uncomment this until after we UploadCatalog[]*)
      ]
    },
    {
      OptionName -> WellCoverHeating,
      Default -> Automatic,
      Description -> "When WellCover is Model[Item,PlateSeal] or any object of that model, indicates if the plate seal is heated.",
      ResolutionDescription -> "When AssayFormFactor is Plate and WellCover is set to a Model[Item,PlateSeal] or Object[Item,PlateSeal], automatically set to True. When AssayFormFactor is Capillary or WellCover is set to anything other than Model[Item,PlateSeal] or Object[Item,PlateSeal], automatically set to Null.",
      AllowNull -> True,
      Category -> "Sample Loading",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ](*TODO: add checks for plate seal exceeding max temperature; throw errors in this case*)
    },

    (* SampleLoadingPlate Storage Option *)

    {
      OptionName -> SampleLoadingPlateStorageCondition,
      Default -> Automatic,
      Description -> "The conditions under which any leftover samples from the StandardDilutionCurve or SerialDilutionCurve are stored in the SampleLoadingPlate after the samples are transferred to the AssayContainer(s).",
      ResolutionDescription -> "Automatically set to Null when AssayFormFactor is Plate and to Disposal when AssayFormFactor is Capillary.",
      AllowNull -> True,
      Category -> "Sample Storage",
      Widget -> Alternatives[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[Model[StorageCondition]],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Storage Conditions"
            }
          }
        ],
        Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[SampleStorageTypeP | Disposal]
        ]
      ]
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> SamplesInStorageCondition,
        Default -> Automatic,
        Description -> "The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed.",
        AllowNull -> True,
        Category -> "Sample Storage",
        Widget -> Alternatives[
          Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            OpenPaths -> {
              {
                Object[Catalog, "Root"],
                "Storage Conditions"
              }
            }
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[SampleStorageTypeP | Disposal]
          ]
        ]
      },
      {
        OptionName->SampleLabel,
        Default->Automatic,
        Description->"A user defined word or phrase used to identify the samples that are being measured in ExperimentDynamicLightScattering, for use in downstream unit operations.",
        AllowNull->True,
        Category->"General",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        UnitOperation->True
      },
      {
        OptionName->SampleContainerLabel,
        Default->Automatic,
        Description->"A user defined word or phrase used to identify the containers of the samples that are being measured in ExperimentDynamicLightScattering, for use in downstream unit operations.",
        AllowNull->True,
        Category->"General",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        UnitOperation->True
      }
    ],
    {
      OptionName -> SamplesOutStorageCondition,
      Default -> Automatic,
      Description -> "The non-default conditions under which the SamplesOut of this experiment should be stored after the protocol is completed.",
      ResolutionDescription-> "When AssayFormFactor is Capillary, automatically set to Disposal. When AssayFormFactor is Plate, if all of the experiment samples have the same StorageCondition, automatically set to that StorageCondition; if the experiment samples have different StorageConditions, automatically set to Disposal; if no StorageConditions are available for the experiment samples, automatically set to AmbientStorage.",
      AllowNull -> True,
      Category -> "Sample Storage",
      Widget -> Alternatives[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[Model[StorageCondition]],
          OpenPaths -> {
            {
              Object[Catalog, "Root"],
              "Storage Conditions"
            }
          }
        ],
        Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[SampleStorageTypeP | Disposal]
        ]
      ]
    }
  },
  SharedOptions:>{

    FuntopiaSharedOptions,
    SubprotocolDescriptionOption,
    SamplesInStorageOption,
    SamplesOutStorageOption,
    CacheOption,
    SimulationOption,
    PreparatoryUnitOperationsOption
  }
];(*TODO: ADD ERRORS AND WARNINGS*)

(* - Messages - *)
(* Before option resolution *)
Error::InvalidDLSInstrument="Unfortunately, the ECL does not have support for the instrument model `1` in the context of a dynamic light scattering experiment. Please consider using the supported instrument models: Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or Model[Instrument,DLSPlateReader,\"DynaPro\".";
Error::ConflictingDLSAssayTypeOptions="The resolved AssayType, `1`, is in conflict with the following options, `2`, which have been specified as `3`. These specified options are associated with the following AssayTypes, `4`.  Please ensure that the AssayType is not in conflict with other specified options, or consider letting these options resolve automatically.";
Error::ConflictingDLSAssayTypeNullOptions="The supplied AssayType, `1`, is in conflict with the following options, `2`, which have been specified as Null. These Null options are required to be non-Null values with this AssayType. Ensure that the `2` are not in conflict with the AssayType, or consider letting these options resolve automatically.";
Error::OccupiedDLSSampleLoadingPlate="The specified SampleLoadingPlate, `1`, is not empty (that is, its Contents field is not an empty list). If a specific Container Object is supplied, it must be empty.";
Error::MinMaxTemperatureMismatch="The specified MinTemperature, `1`, is greater than or equal to the MaxTemperature, `2`. The MinTemperature must be less than the MaxTemperature if they are specified.";
Warning::NonDefaultDLSSampleLoadingPlate="The specified SampleLoadingPlate, `1`, is of `2`. The default SampleLoadingPlate Model is Model[Container, Plate, \"96-well PCR Plate\"]. Using a non-default Model, particularly one with a larger MinVolume, may result in mis-loading of the AssayContainers, as the small 9uL transfers have been optimized only for the default model. Please consider using the default SampleLoadingPlate Model.";

(* After option resolution *)
Error::ConflictingDLSFormFactorInstrument="The AssayFormFactor, `1`, is in conflict with the Instrument, `2`. If AssayFormFactor is Plate, Instrument must be a member of Model[Instrument,DLSPlateReader], and if AssayFormFactor is Capillary, Instrument must be a member of Model[Instrument,MultimodeSpectrophotometer].";
Error::ConflictingDLSFormFactorLoadingPlate="The AssayFormFactor, `1`, is in conflict with the SampleLoadingPlate, `2`. If AssayFormFactor is Plate, SampleLoadingPlate must be Null, and if AssayFormFactor is Capillary, SampleLoadingPlate must not be Null.";
Error::ConflictingDLSFormFactorCapillaryLoading="The AssayFormFactor, `1`, is in conflict with the CapillaryLoading, `2`. If AssayFormFactor is Plate, CapillaryLoading must be Null, and if AssayFormFactor is Capillary, CapillaryLoading must not be Null.";
Error::ConflictingDLSFormFactorPlateStorage="The AssayFormFactor, `1`, is in conflict with the SampleLoadingPlateStorageCondition, `2`. If AssayFormFactor is Plate, SampleLoadingPlateStorageCondition must be Null, and if AssayFormFactor is Capillary, SampleLoadingPlateStorageCondition must not be Null.";
Error::ConflictingFormFactorWellCover="The AssayFormFactor, `1`, is in conflict with the WellCover, `2`. If AssayFormFactor is Plate, WellCover must not be Null, and if AssayFormFactor is Capillary, WellCover must be Null.";
Error::ConflictingFormFactorWellCoverHeating="The AssayFormFactor, `1`, is in conflict with the WellCoverHeating, `2`. If AssayFormFactor is Plate, WellCoverHeating must not be Null, and if AssayFormFactor is Capillary, WellCoverHeating must be Null.";
Error::TooLowSampleVolume="The resolved SampleVolume, `1`, is too low for the given AssayFormFactor, `2`. When AssayFormFactor is Plate, SampleVolume must not be less than 25 uL, and when AssayFormFactor is Capillary, SampleVolume must not be less than 9 uL.";
Error::ConflictingRampOptions="The TemperatureRamping, `1`, is in conflict with one or more of NumberOfTemperatureRampSteps, `2`, and StepHoldTime, `3`. If TemperatureRamping is Linear, then the latter two options must be Null, and if TemperatureRamping is Step, neither of the latter options may be Null.";
Error::ConflictingDLSDilutionMixOptions="The following samples, `1`, have DilutionMixVolume, DilutionMixRate, and DilutionNumberOfMixes options, `2`, that are in conflict. If any of these options are Null, they all must be Null, and if any are specified as non-Null values, they all must be non-Null. Please ensure that these options are not in conflict, or consider letting the options resolve automatically.";
Error::ConflictingDLSDilutionMixTypeOptions="The following samples, `1`, have DilutionMixType that is in conflict with one or more of DilutionMixVolume, DilutionMixRate, and DilutionNumberOfMixes options, `2`. If DilutionMixType is Pipette, the other options must be specified as non-Null values, and if DilutionMixType is not Pipette, the other options must all be Null. Please ensure that these options are not in conflict, or consider letting the options resolve automatically.";
Error::ConflictingDLSDilutionMixTypeInstrument="The following samples, `1`, have DilutionMixType that is in conflict with DilutionMixInstrument, `2`. The DilutionMixType must be identical to the subtype of the Model[Instrument] of DilutionMixInstrument. Please ensure that these options are not in conflict, or consider letting the options resolve automatically.";
Warning::DLSBufferNotSpecified="The Buffer option was not specified for the following samples, `1`, and an appropriate Buffer was not able to be determined from the sample's Solvent field. The Buffer for these samples has been set to `2`. For ColloidalStability assays, it is essential that the Buffer and BlankBuffer options are the same as the input sample's buffer. Please specify the Buffer option for the most accurate experimental results.";
Error::ConflictingDLSDilutionCurves="The following samples, `1`, have StandardDilutionCurve and SerialDilutionCurve options, `2`, that are in conflict. When the AssayType is ColloidalStability, for each sample, the corresponding StandardDilutionCurve and SerialDilutionCurve options cannot both be Null, or both be specified. Please ensure that these options are not in conflict, or consider letting these options resolve automatically.";
Warning::DLSBufferAndBlankBufferDiffer="For the following samples, `1`, the Buffer and BlankBuffer options, `2`, are not identical. For ColloidalStability assays, it is highly recommended that the Buffer and BlankBuffer options are the same, otherwise the resultant B22, kD, and G22 values will not be accurate. Please confirm that the options are specified as desired, or consider letting the BlankBuffer option resolve automatically.";
Error::ConflictingDLSIsothermalOptions="The AssayType is IsothermalStability, and the supplied IsothermalMeasurements, `1`, and IsothermalRunTime, `2`, are in conflict. When the AssayType is IsothermalStability, these options cannot both be Null or both be specified. Please ensure that these options are not in conflict, or consider letting these options resolve automatically.";
Warning::LowDLSReplicateConcentrations="The NumberOfReplicates is set to 2. It is recommended to have 3 or more replicates per dilution curve concentration for ColloidalStability assays.";
Error::ConflictingDLSAssayTypeSampleVolumeOptions="The AssayType, `1`, and SampleVolume, `2`, are in conflict. When the AssayType is ColloidalStability, the SampleVolume must not be specified. In these cases, the amount of input sample used is set using either the SerialDilutionCurve or StandardDilutionCurve options. When the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, the SampleVolume must be specified. Please ensure that the SampleVolume and AssayType options are not in conflict.";
Error::DLSMeasurementDelayTimeTooLow="The following options, `1`, which have been set to `2`, are in conflict with the number of input samples (including replicate samples), `3`. When the number of samples is `3` and the IsothermalAttenuatorAdjustment option is `4`, the minimum required MeasurementDelayTime is `5`. Please raise the MeasurementDelayTime, or consider letting the option resolve automatically.";(*todo: Definitely different for DynaPro... when these adjustments are made, resolvedInstrument needs to be included in the error*)
Error::ConflictingDLSIsothermalTimeOptions="The AssayType is IsothermalStability, and the MeasurementDelayTime, `1`, and the IsothermalRunTime, `2`, are in conflict. If the MeasurementDelayTime and IsothermalRunTime are both specified, the MeasurementDelayTime cannot be larger than the IsothermalRunTime. Please ensure that these options are not in conflict, or consider letting these options resolve automatically.";
Error::DLSIsothermalAssayTooLong="Please ensure that the length of the assay, `3`, which is the product of the MeasurementDelayTime, `1`, and IsothermalMeasurements, `2`, is less than 6.5 days as this the maximum time for a dynamic light scattering experiment.";(*possibly different on DynaPro???*)
Error::DLSDilutionCurveLoadingPlateMismatch="The following samples, `1`, have options, `2`, with values of `3`, which are in conflict with the SampleLoadingPlate, `4`. The MaxVolume of `4` is `5`, but the dilution curve options require a maximum volume of `6` be placed in a well, which exceeds the MaxVolume of the plate. Please either choose a larger SampleLoadingPlate, or, ideally, change the dilution option to require less volume per well.";
Error::DLSDilutionCurveMixVolumeMismatch="The following samples, `1`, have options, `2`, with values of `3`. These options are in conflict with the DilutionMixVolume, which has a value of `4`. The dilution curve options indicate that a well of the SampleLoadingPlate will have a total volume of `5`, which is smaller than the DilutionMixVolume. The DilutionMixVolume must be smaller than the lowest volume in the SampleLoadingPlate. Please ensure that these options are not in conflict, either by reducing the DilutionMixVolume or changing the dilution curve option.";
Error::DLSNotEnoughDilutionCurveVolume="The following samples, `1`, have options, `2`, with values of `3`. Because the NumberOfReplicates is `4` and the ReplicateDilutionCurve is `5`, the minimum required volume for each concentration of the dilution curve is `6`. The given dilution curve options result in a minimum volume of `7` in at least one well of the SampleLoadingPlate after sample dilution. Please ensure that there is at least `6` in each dilution concentration, or consider letting these options resolve automatically. ";
Error::DLSOnlyOneDilutionCurveConcentration="The following samples, `1`, have invalid option, `2`, with values of `3`. At least two unique dilutions of each input sample are required for ColloidalStability assays. Please ensure the dilution options are valid, or consider letting these options resolve automatically.";
Error::TooManyDLSInputs="The input samples, `1`, are invalid. The number of wells required (the number of input samples times the NumberOfReplicates) is `2`, which exceeds the maximum allowed for the Instrument, `3`. Please reduce the number of input samples, or the NumberOfReplicates.";
Error::DLSTooManyDilutionWellsRequired="The combination of the number of input samples, `1`, and the following options, `2`, are invalid. The combination of input samples and specified invalid options require `3` wells, which exceeds the number of wells available for the Instrument, `4`. The number of required wells is calculated by adding the number of samples (including replicates) to the product of the number of samples (including replicates) and the number of wells required for each dilution curve (number of dilutions times the NumberOfReplicates). Please ensure that the number of required wells is fewer than 48 (when AssayFormFactor is Capillary) or 384 (when AssayFormFactor is Plate). A typical ColloidalStability experiment has 3 input samples, with 5 dilutions per sample, and NumberOfReplicates set to 3.";
Error::DLSInputSampleNoAnalyte="The AssayType is `1` and the Analyte options for the following samples, `2`, are Null. Please ensure that the Analyte option is specified when the AssayType is ColloidalStability. The Analyte option may have been automatically set to Null if there are no Model[Molecule,Protein]s present in the Composition field. The Compositions associated with `2` are `3`. Please either specify the Analyte option, or use DefineComposition to ensure that the input samples' Composition fields are accurate. If there are no Analytes present in the input sample, SizingPolydispersity may be a more suitable AssayType than `1`.";
Error::DLSInputSampleNoAnalyteMolecularWeight="The AssayType is ColloidalStability and none of the Analytes, `1`, have associated MolecularWeights, which are required when AssayFormFactor is Capillary. Please ensure that the provided Analyte option has an associated MolecularWeight for ColloidalStability assays with an AssayFormFactor of Capillary.";(*Uncle only*)
Error::DLSInputSampleNoAnalyteMassConcentration="The AssayType is `1` and the AnalyteMassConcentration options for the following samples, `2` are Null. Please ensure that the AnalyteMassConcentration option is specified when the AssayType is ColloidalStability. The AnalyteMassConcentration may have been automatically set to Null if the Analyte has no associated amount in the Composition field. The Compositions associated with `2` are `3`. The instrument needs to know the MassConcentration of the Analytes - if the MolecularWeight of the Analyte is not informed, or the volume or mass of the input sample is not known, this also prevents calculation of the concentration. Please either specify the AnalyteMassConcentration option, or use DefineComposition to ensure that the Composition of the input samples are accurate.";
Warning::DLSMoreThanOneCompositionAnalyte="The AssayType is `1` and the following samples, `2`, have Compositions, `3`, with more than one Model[Molecule,Protein]. ColloidalStability assays should be run on samples which have one Analyte in the Composition. For this experiment, the the most concentrated Analytes of `2`, `4`, will be used for concentration calculations. Please ensure that the input samples' Compositions are populated correctly.";
(*Warning::DLSAnalyteConcentrationHigh="The AssayType is ColloidalStability, but the following samples, `1`, have Composition fields with the following Analyte molecules, `2`, with mass concentrations of `3`. The highest recommended concentration of Analyte for ColloidalStability assays is 25 mg/mL. Please ensure that the Composition fields of the input samples are populated correctly, and that ColloidalStability is the desired AssayType.";*)
Error::DLSConflictingLaserSettings="The following laser setting related options, `1`, which have values of `2` are in conflict with each other. When AutomaticLaserSettings is True, the LaserPower and DiodeAttenuation must both be Null. When AutomaticLaserSettings is False, the LaserPower and DiodeAttenuation should be specified as a percentage. Please ensure that these options are not in conflict, or consider letting them resolve automatically.";
Error::InvalidDLSTemperature="The AssayType, `1`, and the Temperature, `2`, are in conflict. The Temperature must be 25 Celsius if the AssayType is ColloidalStability and the Instrument is of Model[Instrument,MultimodeSpectrophotometer]. Please ensure that the Temperature and AssayType options are specified as desired.";
Error::DLSManualLoadingByRow="CapillaryLoading is set to Manual while AssayContainerFillDirection is set to Row. Manual loading can only be done by Column when the Instrument is of Model[Instrument,MultimodeSpectrophotometer]. Please consider setting AssayContainerFillDirection to Column or Automatic.";(*Uncle only*)
Error::ConflictingFormFactorTemperatureRamp="The given AssayFormFactor, `1`, is incompatible with the MinTemperature and MaxTemperature, `2`. When AssayFormFactor is Plate, MaxTemperature cannot exceed 85 Celsius, and when AssayFormFactor is Capillary, MinTemperature cannot be less than 15 Celsius.";

(*Define available assay containers*)
dlsAssayContainerP=Alternatives[
  ObjectP[Model[Container, Plate, "id:rea9jlaPWNGx"]],(*"96 well Flat Bottom DLS Plate"*)
  ObjectP[Model[Container, Plate, "id:N80DNj09z91D"]],(*"96 well Clear Flat Bottom DLS Plate"*)
  ObjectP[Model[Container, Plate, "id:4pO6dMOlqJLw"]],(*"384-well Aurora Flat Bottom DLS Plate"*)
  ObjectP[Model[Container, Plate, CapillaryStrip, "id:R8e1Pjp9Kjjj"]](*"Uncle 16-capillary strip"*)
];


(* ::Subsubsection:: *)
(* ExperimentDynamicLightScattering *)

(* --- Container and PreparatoryPrimitives overload --- *)
ExperimentDynamicLightScattering[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {
    listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult,containerToSampleOutput,containerToSampleSimulation, containerToSampleTests, validSamplePreparationResult, samplesWithPreparedSamples, optionsWithPreparedSamples,
    samples,sampleOptions, updatedSimulation, sampleContainerPackets, preloadedQ, numberOfReplicatesSetQ
  },

  (* determine the requested return value from the function *)
  outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
  output = ToList[outputSpecification];

  (* determine if we should keep a running list of tests; if True, then silence messages *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = sanitizeInputs[ToList[myInputs], ToList[myOptions]];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {samplesWithPreparedSamples,optionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentDynamicLightScattering,
      listedContainers,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
  ];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentDynamicLightScattering,
      samplesWithPreparedSamples,
      optionsWithPreparedSamples,
      Output->{Result,Tests,Simulation},
      Simulation->updatedSimulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
        ExperimentDynamicLightScattering,
        samplesWithPreparedSamples,
        optionsWithPreparedSamples,
        Output->{Result, Simulation},
        Simulation->updatedSimulation
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
      Simulation->Null,
      InvalidInputs->{},
      InvalidOptions->{}
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions}=containerToSampleOutput;

    (* Do a little download for info on the containers of the samples *)
    sampleContainerPackets=Download[
      samples,
      Packet[Container][Model],
      Simulation->updatedSimulation
    ];

    (* Figure out if the samples are pre-loaded in the same DLS-able container *)
    preloadedQ=And[
      MatchQ[Lookup[sampleContainerPackets,Model],{dlsAssayContainerP..}],
      Length[Union[Lookup[sampleContainerPackets,Object]]]==1
    ];

    numberOfReplicatesSetQ=MatchQ[Lookup[ToList[myOptions], NumberOfReplicates], Automatic];

    (* Call our main function with our samples and converted options. *)
    If[preloadedQ && !numberOfReplicatesSetQ,
      Quiet[
        ExperimentDynamicLightScattering[samples,ReplaceRule[sampleOptions,{Simulation -> containerToSampleSimulation,NumberOfReplicates->1}]],
          {Warning::LowDLSReplicateConcentrations}
      ],
      ExperimentDynamicLightScattering[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
    ]
  ]
];


(* --- Main Sample overload --- *)
ExperimentDynamicLightScattering[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    listedOptions,listedSamples,outputSpecification,output,gatherTests,messages,validSamplePreparationResult,samplesWithPreparedSamples,optionsWithPreparedSamples,
    samplesWithPreparedSamplesNamed,optionsWithPreparedSamplesNamed,
    samplePreparationCache,safeOps,safeOpsNamed,safeOpsTests,validLengths,validLengthTests,
    templatedOptions,templateTests,inheritedOptions,expandedSafeOps,
    optionsWithObjects,specifiedObjects,simulatedSampleQ,objectsExistQs,objectsExistTests,
    suppliedInstrument,suppliedSampleLoadingPlate,suppliedAnalyte,
    instrumentDownloadOption,uncleDynaProDownload,uncleDynaProDownloadFields,instrumentDownloadFields,sampleLoadingPlateDownloadOption,sampleLoadingPlateModelDownloadFields,uniqueAnalytes,
    liquidHandlerContainers,
    objectSamplePacketFields,modelSamplePacketFields,objectContainerPacketFields,modelContainerPacketFields,liquidHandlerContainerPackets,
    listedSampleContainerPackets,instrumentPacket,uncleDynaProPackets,inputsInOrder,sampleLoadingPlateModelPacket,
    sampleLoadingPlateObjectPacket,listedAnalytePackets,
    cacheBall,inputObjects,resolvedOptionsResult,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,updatedSimulation,upload,confirm,fastTrack,parentProtocol,cache,resolvedPreparation,returnEarlyQ,performSimulationQ,protocolPacketWithResources,simulatedProtocol,simulation,postProcessingOptions,unitOperationPacket,samplesInPackets
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Remove temporal links and named objects. *)
  {listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {samplesWithPreparedSamplesNamed,optionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentDynamicLightScattering,
      listedSamples,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentDynamicLightScattering,optionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentDynamicLightScattering,optionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  {samplesWithPreparedSamples,safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed,safeOpsNamed, optionsWithPreparedSamplesNamed];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation->Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentDynamicLightScattering,{samplesWithPreparedSamples},optionsWithPreparedSamples,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentDynamicLightScattering,{samplesWithPreparedSamples},optionsWithPreparedSamples],Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation->Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentDynamicLightScattering,{ToList[samplesWithPreparedSamples]},optionsWithPreparedSamples,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentDynamicLightScattering,{ToList[samplesWithPreparedSamples]},optionsWithPreparedSamples],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation->Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* get assorted hidden options *)
  {upload, confirm, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];


  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentDynamicLightScattering,{ToList[samplesWithPreparedSamples]},inheritedOptions]];

  (* - Throw an error and return failed if any of the specified Objects are not members of the database - *)
  (* Any options whose values _could_ be an object *)
  optionsWithObjects = {
    Instrument,
    SampleLoadingPlate,
    Buffer,
    BlankBuffer,
    Analyte
  };

  (* Extract any objects that the user has explicitly specified *)
  specifiedObjects = DeleteDuplicates@Cases[
    {ToList[mySamples],ToList[KeyDrop[Association[myOptions], {Cache, Simulation}]]},
    ObjectReferenceP[],
    Infinity
  ];

  (* Check that the specified objects exist or are visible to the current user *)
  objectsExistQs=Quiet[DatabaseMemberQ[specifiedObjects,Simulation->updatedSimulation],{Download::ObjectDoesNotExist}];

  (* Build tests for object existence *)
  objectsExistTests = If[gatherTests,
    MapThread[
      Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
      {specifiedObjects,objectsExistQs}
    ],
    {}
  ];

  (* If objects do not exist, return failure *)
  If[!(And@@objectsExistQs),
    If[!gatherTests,
      Message[Error::ObjectDoesNotExist,PickList[specifiedObjects,objectsExistQs,False]];
      Message[Error::InvalidInput,PickList[specifiedObjects,objectsExistQs,False]]
    ];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
  (* Pull the info out of the options that we need to download from *)
  {
    suppliedInstrument,suppliedSampleLoadingPlate,suppliedAnalyte
  }=Lookup[expandedSafeOps,
    {
      Instrument,SampleLoadingPlate,Analyte
    }
  ];
  (* - Instrument - *)
  instrumentDownloadOption=If[
    (* Only downloading from the instrument option if it is not Automatic *)
    MatchQ[suppliedInstrument,Automatic],
    {},
    {suppliedInstrument}
  ];

  (* Download all relevant instruments *)
  uncleDynaProDownload=Search[{Model[Instrument, MultimodeSpectrophotometer],Model[Instrument,DLSPlateReader]}];
  uncleDynaProDownloadFields = Packet[Object, WettedMaterials, Name, MinTemperature, MaxTemperature, MaxTemperatureRamp];

  instrumentDownloadFields=Which[
    (* If instrument left as automatic, don't download anything *)
    MatchQ[suppliedInstrument,Automatic],
    {},

    (* If instrument is an object, download fields from the Model and the Object *)
    MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
    {Packet[Model[{Object, WettedMaterials, Name, MinTemperature, MaxTemperature, MaxTemperatureRamp}]],Packet[Object,Name,Model]},

    (* If instrument is a Model, download fields*)
    MatchQ[suppliedInstrument,ObjectP[Model[Instrument]]],
    {Packet[Object, WettedMaterials, Name, MinTemperature, MaxTemperature, MaxTemperatureRamp]},

    True,
    {}
  ];

  (* - SampleLoadingPlate - *)
  sampleLoadingPlateDownloadOption=If[
    (* Only downloading from the instrument option if it is not Automatic *)
    MatchQ[suppliedSampleLoadingPlate,Automatic],
    {},
    {suppliedSampleLoadingPlate}
  ];

  sampleLoadingPlateModelDownloadFields=Which[

    (* IF the SampleLoadingPlate has not been specified, this is Nothing*)
    MatchQ[suppliedSampleLoadingPlate,Automatic|Null],
    {},

    (* IF the SamplePreprationPlate is a Model *)
    MatchQ[suppliedSampleLoadingPlate,ObjectP[Model[Container,Plate]]],

    (* THEN we download fields from the specified Model *)
    {Packet[Object, MaxVolume, Name]},

    (* ELSE, we download fields from the Model of the specified Object *)
    True,
    {Packet[Model[{Object, MaxVolume, Name}]]}
  ];

  (* - Analyte - *)
  (* Download from unique Model[Molecules] in the Analyte option *)
  uniqueAnalytes=DeleteDuplicates[Cases[ToList[suppliedAnalyte],ObjectP[Model[Molecule]]]];

  (* - All liquid handler compatible containers (for resources and Aliquot) - *)
  liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

  (* - Determine which fields we need to download from the input Objects - *)
  (* Create the Packet Download syntax for our Object and Model samples. *)
  objectSamplePacketFields=Packet@@Flatten[{Solvent,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
  modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
  objectContainerPacketFields=SamplePreparationCacheFields[Object[Container]];
  modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

  (* --- Assemble Download --- *)

  {
    listedSampleContainerPackets,instrumentPacket,uncleDynaProPackets,inputsInOrder,sampleLoadingPlateModelPacket,sampleLoadingPlateObjectPacket,
    listedAnalytePackets,liquidHandlerContainerPackets,samplesInPackets
  }  =Quiet[
    Download[
      {
        (* Inputs *)
        ToList[samplesWithPreparedSamples],
        (* Instrument *)
        instrumentDownloadOption,
        uncleDynaProDownload,
        ToList[samplesWithPreparedSamples],
        sampleLoadingPlateDownloadOption,
        sampleLoadingPlateDownloadOption,
        uniqueAnalytes,
        liquidHandlerContainers,
        ToList[mySamples]
      },
      {
        {
          objectSamplePacketFields,
          modelSamplePacketFields,
          Packet[Container[objectContainerPacketFields]],
          Packet[Composition[[All, 2]][{Object,MolecularWeight,Name}]],
          Packet[Analytes[{Object,MolecularWeight}]]
        },
        instrumentDownloadFields,
        {uncleDynaProDownloadFields},
        {Packet[Object]},
        sampleLoadingPlateModelDownloadFields,
        {Packet[Object,Model,Contents]},
        {Packet[Object,Name,MolecularWeight]},
        {modelContainerPacketFields},
        {Packet[Object,StorageCondition]}

      },
      Cache->cache,
      Simulation->updatedSimulation,
      Date->Now
    ],
    {Download::FieldDoesntExist,Download::ObjectDoesNotExist}
  ];

  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cacheBall = FlattenCachePackets[{cache, {
    listedSampleContainerPackets,instrumentPacket,uncleDynaProPackets,inputsInOrder,sampleLoadingPlateModelPacket,sampleLoadingPlateObjectPacket,
    listedAnalytePackets,liquidHandlerContainerPackets,samplesInPackets
  }}];

  (*TODO: delete if function still works*)(*inputsInOrder=Download[ToList[samplesWithPreparedSamples],Packet[Object]];

  (* Get a list of the inputs by ID *)
  inputObjects=Lookup[Flatten[inputsInOrder],Object];*)

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveDynamicLightScatteringOptions[samplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation,Output->{Result,Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveDynamicLightScatteringOptions[samplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation,Output->Result],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentDynamicLightScattering,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentDynamicLightScattering,collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed], True,
    gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True, False
  ];

  (* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
  (* need to return some type of simulation to our parent function that called us. *)
  (*performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];*)
  performSimulationQ = MemberQ[output, Result|Simulation] && MatchQ[Lookup[resolvedOptions, PreparatoryPrimitives], Null|{}];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
      Options -> If[MatchQ[resolvedPreparation, Robotic],
        resolvedOptions,
        RemoveHiddenOptions[ExperimentDynamicLightScattering, collapsedResolvedOptions]
      ],
      Preview -> Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[resolvedOptions, Preparation];

    (* Build packets with resources *)
  {{protocolPacketWithResources,unitOperationPacket}, resourcePacketTests} = Which[
    returnEarlyQ,
    {$Failed, {}},
    gatherTests,
    dynamicLightScatteringResourcePackets[
      samplesWithPreparedSamples,
      templatedOptions,
      resolvedOptions,
      collapsedResolvedOptions,
      Cache -> cacheBall,
      Simulation -> updatedSimulation,
      Output -> {Result, Tests}
    ],
    True,
    {
      dynamicLightScatteringResourcePackets[
        samplesWithPreparedSamples,
        templatedOptions,
        resolvedOptions,
        collapsedResolvedOptions,
        Cache -> cacheBall,
        Simulation -> updatedSimulation,
        Output -> Result
      ],
      {}
    }
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  {simulatedProtocol, simulation} = If[performSimulationQ,
    simulateExperimentDynamicLightScattering[
      If[MatchQ[protocolPacketWithResources, $Failed],
        $Failed,
        protocolPacketWithResources (* protocolPacket *)
      ],
      If[MatchQ[unitOperationPacket, $Failed],
        $Failed,
        Flatten[ToList[unitOperationPacket]] (* unitOperationPackets *)
      ],
      ToList[samplesWithPreparedSamples],
      resolvedOptions,
      Cache -> cacheBall,
      Simulation -> updatedSimulation
    ],
    {Null, Null}
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output, Result],
    Return[outputSpecification /. {
      Result -> Null,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> If[MatchQ[resolvedPreparation, Robotic],
        resolvedOptions,
        RemoveHiddenOptions[ExperimentDynamicLightScattering, collapsedResolvedOptions]
      ],
      Preview -> Null,
      Simulation -> simulation
    }]
  ];

  postProcessingOptions=Map[
    If[
      MatchQ[Lookup[safeOps,#],Except[Automatic]],
      #->Lookup[safeOps,#],
      Nothing
    ]&,
    {ImageSample, MeasureVolume, MeasureWeight}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentDynamicLightScattering,collapsedResolvedOptions],
      Preview -> Null
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = If[!MatchQ[protocolPacketWithResources,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
    UploadProtocol[
      protocolPacketWithResources,
      Upload->Lookup[resolvedOptions,Upload],
      Confirm->Lookup[resolvedOptions,Confirm],
      ParentProtocol->Lookup[resolvedOptions,ParentProtocol],
      ConstellationMessage->Object[Protocol,DynamicLightScattering],
      Cache->cacheBall
    ],
    $Failed
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests(*,resourcePacketTests*)}],
    Options -> RemoveHiddenOptions[ExperimentDynamicLightScattering,collapsedResolvedOptions],
    Preview -> Null
  }
];


(* ::Subsection::Closed:: *)
(* resolveDynamicLightScatteringOptions *)


DefineOptions[resolveDynamicLightScatteringOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveDynamicLightScatteringOptions[mySamples:{ObjectP[Object[Sample]]..}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveDynamicLightScatteringOptions]]:=Module[
  {
    outputSpecification,output,gatherTests,messages,notInEngine,cache,cacheBall,fastAssoc,simulation,samplePrepOptions,experimentOptions,simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,
    suppliedAssayType,suppliedAssayFormFactor,suppliedInstrument,numberOfReplicates,suppliedSampleLoadingPlate,suppliedColloidalStabilityParametersPerSample,suppliedIsothermalAttenuatorAdjustment,
    suppliedReplicateDilutionCurve,suppliedBuffer,suppliedDilutionMixType,suppliedDilutionMixInstrument,suppliedBlankBuffer,suppliedCalculateMolecularWeight,suppliedSampleLoadingPlateStorageCondition,
    suppliedAssayContainerFillDirection,suppliedName,suppliedAnalyte,suppliedCollectStaticLightScattering,suppliedNumberOfAcquisitions,SuppliedAutomaticLaserSettings,suppliedCapillaryLoading,suppliedTemperatureRampOrder,suppliedTemperatureRamping,suppliedWellCover,suppliedWellCoverHeating,suppliedSamplesInStorageCondition,suppliedSamplesOutStorageCondition,

    instrumentDownloadOption,instrumentDownloadFields,sampleLoadingPlateDownloadOption,sampleLoadingPlateModelDownloadFields,liquidHandlerContainers,

    objectSamplePacketFields,modelSamplePacketFields,objectContainerPacketFields,modelContainerPacketFields,
    listedSampleContainerPackets,instrumentPacket,sampleLoadingPlateModelPacket,
    sampleLoadingPlateObjectPacket,liquidHandlerContainerPackets,
    samplePackets,sampleContainerPackets,sampleCompositionPackets,sampleAnalytesPackets,numberOfSamples,intNumberOfReplicates,numberOfSamplesWithReplicates,
    loadingPlateMaxVolume,loadingPlateModelID,loadingPlateContents,sampleCompositions,
    discardedSamplePackets,discardedInvalidInputs,discardedTests,unroundedStandardDilutionCurve,separatedUnroundedStandardDilutionCurve,
    roundedStandardDilutionCurveOption, standardDilutionCurvePrecisionTests,roundedStandardDilutionCurveOptions,unroundedSerialDilutionCurve,roundedSerialDilutionCurveOptions,
    doublyRoundedSerialDilutionCurveOptions,serialDilutionPrecisionTests,



    optionPrecisions,roundedOtherExperimentOptions,optionPrecisionTests,roundedExperimentOptions,

    suppliedSampleVolume,suppliedAcquisitionTime,suppliedTemperature,invalidTemperatureOptions,invalidTemperatureTests,
    suppliedEquilibrationTime,suppliedAutomaticLaserSettings,suppliedLaserPower,suppliedDiodeAttenuation,
    suppliedMeasurementDelayTime,suppliedIsothermalRunTime,
    suppliedDilutionMixVolume,suppliedDilutionMixRate,suppliedNumberOfCycles,
    suppliedIsothermalMeasurements,suppliedStandardDilutionCurve,suppliedSerialDilutionCurve,suppliedDilutionNumberOfMixes,suppliedNumberOfReplicates,
    suppliedAnalyteMassConcentration,suppliedMinTemperature,suppliedMaxTemperature,suppliedTemperatureRampRate,suppliedTemperatureResolution,suppliedNumberOfTemperatureRampSteps,suppliedStepHoldTime,
    roundedExperimentOptionsList,allOptionsRounded,compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,validNameQ,nameInvalidOption,
    validNameTest,suppliedInstrumentModel,validInstrumentP,invalidUnsupportedInstrumentOption,validInstrumentTests,dilutionAssayTypeP,
    nonDilutionAssayTypeP,isothermalStabilityOptionNames,
    isothermalStabilitySuppliedOptions,colloidalStabilityOptionNames,colloidalStabilitySuppliedOptions,isothermalStabilityOptionsSpecifiedQ,colloidalStabilityOptionsSpecifiedQ,
    specifiedIsothermalStabilityOptions,specifiedColloidalStabilityOptions,specifiedIsothermalStabilityOptionNames,specifiedColloidalStabilityOptionNames,meltingCurveOptionNames,meltingCurveSuppliedOptions,meltingCurveOptionsSpecifiedQ,specifiedMeltingCurveOptions,specifiedMeltingCurveOptionNames,
    assayTypeInvalidOptions,assayTypeInvalidOptionsExceptType,suppliedAssayTypeInvalidOptionsExceptType,suggestedAssayTypes,invalidAssayTypeTests,
    essentialIsothermalStabilityOptionNames,essentialIsothermalStabilitySuppliedOptions,essentialColloidalStabilityOptionNames,essentialColloidalStabilitySuppliedOptions,
    essentialIsothermalStabilityOptionsNullQ,essentialColloidalStabilityOptionsNullQ,nullEssentialIsothermalStabilityOptions,nullEssentialColloidalStabilityOptions,
    nullEssentialIsothermalStabilityOptionNames,nullEssentialColloidalStabilityOptionNames,essentialMeltingCurveOptionNames,essentialMeltingCurveSuppliedOptions,essentialMeltingCurveOptionsNullQ,nullEssentialMeltingCurveOptions,nullEssentialMeltingCurveOptionNames,assayTypeInvalidNullOptions,assayTypeInvalidNullOptionsExceptType,
    suppliedAssayTypeInvalidNullOptionsExceptType,invalidAssayTypeNullOptionsTests,
    sampleLoadingPlateOccupiedQ,
    invalidOccupiedPlateOptions,occupiedSampleLoadingPlateTests,nonDefaultLoadingPlateWarningQ,nonDefaultLoadingPlateTests,
    resolvedAssayFormFactor,resolvedInstrument,resolvedInstrumentPacket,resolvedAssayType,resolvedLaserPower,resolvedDiodeAttenuation,resolvedAssayContainerFillDirection,
    resolvedSampleVolume,resolvedIsothermalAttenuatorAdjustment,requiredMinimumDelayTime,resolvedMeasurementDelayTime,
    resolvedIsothermalMeasurements,resolvedIsothermalRunTime,resolvedNumberOfReplicates,resolvedReplicateDilutionCurve,
    mapThreadFriendlyOptions,inputSolventFields,resolvedAnalyte,resolvedAnalyteMassConcentration,expectedNumberOfWells,
    resolvedStandardDilutionCurve,resolvedSerialDilutionCurve,resolvedBuffer,resolvedDilutionMixVolume,resolvedDilutionNumberOfMixes,
    resolvedDilutionMixRate,resolvedBlankBuffer,bufferNotSpecifiedWarnings,conflictingDilutionMixOptionsErrors,conflictingDilutionCurveErrors,
    analyteMolecularWeights,nonNullAnalyteMolecularWeights,invalidAnalyteOptions,noAnalyteMWTests,
    conflictingDilutionMixOptionsErrorQ,invalidFormFactorInstrumentOptions,conflictingDLSFormFactorInstrumentTest,invalidFormFactorCapillaryOptions,conflictingDLSFormFactorCapillaryLoadingTest,
    failingDilutionMixSamples,passingDilutionMixSamples,resolvedDilutionOptionsPerSample,failingDilutionMixOptionValues,invalidConflictingDilutionMixOptions,
    conflictingDilutionMixTests,bufferNotSpecifiedWarningQ,failingBufferSpecifiedSamples,passingBufferSpecifiedSamples,unspecifiedBuffers,
    bufferNotSpecifiedTests,conflictingDilutionCurveErrorQ,failingConflictingDilutionCurveSamples,passingConflictingDilutionCurveSamples,
    resolvedDilutionCurveOptionsPerSample,failingDilutionCurveOptionValues,conflictingDilutionCurveOptions,conflictingDilutionCurveTests,
    bufferBlankBufferWarnings,bufferBlankBufferWarningQ,failingBufferBlankBufferSamples,
    failingBufferBlankBufferOptionValues,bufferBlankBufferTests,standardDilutionCurveVolumes,serialDilutionCurveVolumes,maxDilutionVolumes,minDilutionVolumes,
    dilutionCurveOptionNamePerSample,dilutionCurveOptionValuePerSample,dilutionVolumePlateMismatchErrors,dilutionVolumePlateMismatchErrorQ,
    failingVolumePlateMismatchSamples,passingVolumePlateMismatchSamples,failingPlateMaxVolumeOptionNames,failingPlateMaxVolumeOptionValues,
    failingDilutionMaxVolumes,invalidPlateMaxVolumeOptions,dilutionVolumePlateMismatchTests,dilutionMixVolumeErrors,dilutionMixVolumeErrorQ,
    failingDilutionMixVolumeSamples,passingDilutionMixVolumeSamples,failingDilutionMixVolumeOptionNames,failingDilutionMixVolumeOptionValues,
    failingDilutionMixMinVolumes,failingDilutionMixVolumes,invalidDilutionMixMinVolumeOptions,dilutionCurveMixVolumeMismatchTests,dilutionAssayRequiredVolume,
    notEnoughDilutionVolumeErrors,notEnoughDilutionVolumeErrorQ,failingNotEnoughDilutionVolumeSamples,passingNotEnoughDilutionVolumeSamples,
    failingNotEnoughDilutionVolumeOptionNames,failingNotEnoughDilutionVolumeOptionValues,failingDilutionVolumeMinVolumes,notEnoughDilutionVolumeInvalidOptions,
    notEnoughDilutionVolumeTests,onlyOneDilutionConcentrationErrors,onlyOneDilutionConcentrationErrorQ,failingOneConcentrationSamples,
    passingOneConcentrationSamples,failingOneConcentrationDilutionOptionNames,failingOneConcentrationDilutionOptionValues,onlyOneDilutionCurveOptions,
    onlyOneDilutionConcentrationTests,tooManyInvalidInputs,tooManySamplesTests,assayContainerWellsPerSample,requiredDilutionAssayContainerWells,
    invalidTooManyDilutionSamplesOptions,tooManyDilutionSamplesTests,
    invalidConflictingIsothermalRunOptions,conflictingIsothermalRunOptionsTests,numberOfReplicatesWarningQ,lowReplicateConcentrationTests,
    invalidSampleVolumeOptions,invalidSampleVolumeTests,resolvedAssayTypeNullInvalidOptions,invalidResolvedAssayTypeNullOptionsTests,invalidDelayTimeOptionNames,invalidDelayTimeOptionValues,
    invalidMeasurementDelayTimeTests,invalidIsothermalMeasurementTimeOptions,conflictingIsothermalIsothermalTimeTests,totalIsothermalTime,
    invalidTooLongIsothermalOptions,tooLongIsothermalAssayTests,passingBufferBlankBufferSamples,resolvedBufferBlankBufferOptionsPerSample,
    compositionAnalytesAndMassConcentrations,noAnalyteErrors,noAnalyteMassConcentrationErrors,
    noAnalyteErrorQ,failingNoAnalyteSamples,passingNoAnalyteSamples,failingNoAnalyteCompositions,noAnalyteInvalidOptions,noAnalyteTests,noAnalyteMassConcentrationErrorQ,
    failingNoAnalyteConcentrationSamples,passingNoAnalyteConcentrationSamples,failingNoAnalyteConcentrationCompositions,invalidNoAnalyteConcentrationOptions,
    noAnalyteConcentrationTests,invalidLaserSettingsOptionNames,invalidLaserSettingOptionValues,conflictingLaserSettingsTests,
    tooManyAnalytesWarnings,tooManyAnalytesWarningQ,failingTooManyAnalytesSamples,passingTooManyAnalytesSamples,
    failingTooManyAnalytesCompositions,mostConcentratedAnalytes,failingMostConcentratedAnalytes,tooManyAnalytesTests,tooConcentratedAnalyteWarnings,
    tooConcentratedAnalytes,highAnalyteConcentrations,tooConcentratedAnalyteTests,
    invalidInputs,invalidOptions,
    conflictingDLSManualLoadingDirectionOptionsTests, invalidDLSManualLoadingDirectionOptions,
    simulatedSamplesContainerModels,minimumRequiredVolumePerSample,requiredAliquotVolumes,liquidHandlerContainerModels,
    liquidHandlerContainerMaxVolumes,potentialAliquotContainers,requiredAliquotContainers,
    resolvedAliquotOptions,aliquotTests,

    resolvedPostProcessingOptions,resolvedOptions,

    invalidMinMaxTemperatureOptions,minMaxTemperatureMismatchTests,resolvedSampleLoadingPlate,invalidFormFactorLoadingPlateOptions,conflictingDLSFormFactorLoadingPlateTest,resolvedCapillaryLoading,resolvedSampleLoadingPlateStorageCondition,invalidFormFactorPlateStorageOptions,conflictingDLSFormFactorPlateStorageTest,resolvedWellCover,invalidFormFactorWellCoverOptions,conflictingFormFactorWellCoverTest,resolvedWellCoverHeating,invalidFormFactorWellCoverHeatingOptions,conflictingFormFactorWellCoverHeatingTest,invalidTooLowSampleVolumeOptions,tooLowSampleVolumeTest,resolvedMinTemperature,resolvedMaxTemperature,resolvedTemperatureRampOrder,resolvedNumberOfCycles,resolvedTemperatureRamping,resolvedTemperatureRampRate,resolvedTemperatureResolution,resolvedNumberOfTemperatureRampSteps,resolvedStepHoldTime,resolvedColloidalStabilityParametersPerSample,resolvedCalculateMolecularWeight,resolvedDilutionMixType,resolvedDilutionMixInstrument,conflictingDilutionMixTypeOptionsErrors,conflictingDilutionMixTypeInstrumentErrors,bufferAndBlankBufferDifferWarnings,conflictingDilutionMixTypeOptionsErrorQ,failingDilutionMixTypeOptionsSamples,passingDilutionMixTypeOptionsSamples,resolvedDilutionTypeOptionsPerSample,failingDilutionMixTypeOptionsValues,invalidConflictingDilutionMixTypeOptions,conflictingDilutionMixTypeInstrumentErrorQ,failingDilutionMixTypeInstrumentSamples,passingDilutionMixTypeInstrumentSamples,resolvedDilutionTypeInstrumentPerSample,failingDilutionMixTypeInstrumentValues,invalidConflictingDilutionMixTypeInstrument,invalidConflictingRampOptions,conflictingRampOptionsTest,conflictingDilutionMixTypeInstrumentTests,conflictingDilutionMixTypeOptionsTests,totalReadTime,maxRes,preparationResult,allowedPreparation, preparationTest,resolvedPreparation,resolvedInstrumentModelPacket,sampleLoadingPlateModel,sampleContainerModelPackets,resolvedNumberOfAcquisitions,resolvedSamplesInStorageConditions,
    preexistingSamplesStorageConditions,resolvedSamplesOutStorageCondition,experimentOptionsAssociation


  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages=!gatherTests;

  (* Determine if we are in Engine or not, in Engine we silence warnings *)
  notInEngine=Not[MatchQ[$ECLApplication,Engine]];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

  (* Separate out our <Type> options from our Sample Prep options. *)
  {samplePrepOptions,experimentOptions}=splitPrepOptions[myOptions];

  (* Resolve our sample prep options (only if the sample prep option is not true) *)
  {{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentDynamicLightScattering, mySamples, samplePrepOptions, EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation], Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
    {resolveSamplePrepOptionsNew[ExperimentDynamicLightScattering, mySamples, samplePrepOptions, EnableSamplePreparation -> Lookup[myOptions, EnableSamplePreparation], Cache -> cache, Simulation -> simulation, Output -> Result], {}}
  ];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  experimentOptionsAssociation = Association[experimentOptions];

  (* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
  (* Pull out information from the non-quantity or number options that we might need - later, after rounding, we will Lookup the rounded options *)
  {
    suppliedAssayType,suppliedAssayFormFactor,suppliedInstrument,numberOfReplicates,suppliedSampleLoadingPlate,suppliedColloidalStabilityParametersPerSample,
    suppliedReplicateDilutionCurve,suppliedIsothermalAttenuatorAdjustment,suppliedBuffer,suppliedDilutionMixType,suppliedDilutionNumberOfMixes,suppliedDilutionMixInstrument,suppliedBlankBuffer,suppliedCalculateMolecularWeight,suppliedSampleLoadingPlateStorageCondition,
    suppliedAssayContainerFillDirection,suppliedName,suppliedAnalyte,suppliedCollectStaticLightScattering,suppliedNumberOfAcquisitions,suppliedAutomaticLaserSettings(*todo: check...*),suppliedCapillaryLoading(*todo: check...*),suppliedIsothermalMeasurements,suppliedIsothermalAttenuatorAdjustment,suppliedTemperatureRampOrder,suppliedTemperatureRamping,suppliedNumberOfTemperatureRampSteps,suppliedWellCover,suppliedWellCoverHeating,suppliedSamplesInStorageCondition,suppliedSamplesOutStorageCondition
  }=
      Lookup[experimentOptionsAssociation,
        {
          AssayType,AssayFormFactor,Instrument,NumberOfReplicates,SampleLoadingPlate,ColloidalStabilityParametersPerSample,ReplicateDilutionCurve,IsothermalAttenuatorAdjustment,Buffer,DilutionMixType,DilutionNumberOfMixes,DilutionMixInstrument,
          BlankBuffer,CalculateMolecularWeight,SampleLoadingPlateStorageCondition,AssayContainerFillDirection,Name,Analyte,CollectStaticLightScattering,NumberOfAcquisitions,AutomaticLaserSettings,CapillaryLoading,IsothermalMeasurements,IsothermalAttenuatorAdjustment,TemperatureRampOrder,TemperatureRamping,NumberOfTemperatureRampSteps,WellCover,WellCoverHeating,SamplesInStorageCondition,SamplesOutStorageCondition
        },
        Null
      ];

  (* Define Patterns for the Dilution assay types (ColloidalStability) and the non-Dilution Assay Types (SizingPolydispersity,IsothermalStability,MeltingCurve *)
  dilutionAssayTypeP = Alternatives[ColloidalStability];
  nonDilutionAssayTypeP = Alternatives[SizingPolydispersity,IsothermalStability,MeltingCurve];

  (* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION - just for simulation --- *)

  (* - Determine which fields we need to download from the input Objects - *)
  (* Create the Packet Download syntax for our Object and Model samples. *)
  objectSamplePacketFields=Packet@@Flatten[{Solvent,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
  modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
  objectContainerPacketFields=SamplePreparationCacheFields[Object[Container]];
  modelContainerPacketFields=SamplePreparationCacheFields[Object[Container[Model]]];

  (* --- Assemble Download --- *)
  listedSampleContainerPackets=Quiet[
    Download[
      simulatedSamples,
      {
        objectSamplePacketFields,
        modelSamplePacketFields,
        Packet[Container[objectContainerPacketFields]],
        Packet[Composition[[All, 2]][{Object,MolecularWeight,Name}]],
        Packet[Analytes[{Object,MolecularWeight}]],
        Packet[Container[Model[modelContainerPacketFields]]]
      },
      Simulation->updatedSimulation,
      Date->Now
    ],
    {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* combine the cache together *)
  cacheBall = FlattenCachePackets[{
    cache,
    updatedSimulation,
    listedSampleContainerPackets
  }];

  (* generate a fast cache association *)
  fastAssoc = makeFastAssocFromCache[cacheBall];

  (* --- Extract out the packets from the download --- *)
  (* -- Sample Packets -- *)
  samplePackets=listedSampleContainerPackets[[All,1]];
  sampleContainerPackets=listedSampleContainerPackets[[All,3]];
  sampleCompositionPackets=listedSampleContainerPackets[[All,4]];
  sampleAnalytesPackets=listedSampleContainerPackets[[All,5]];
  sampleContainerModelPackets=listedSampleContainerPackets[[All,6]];

  (* Define a variable that is the number of samples *)
  numberOfSamples=Length[simulatedSamples];

  (*Make variable for Model of SampleLoadingPlate if user has specified it*)
  sampleLoadingPlateModel=Which[
    MatchQ[suppliedSampleLoadingPlate,ObjectP[Model]],
      suppliedSampleLoadingPlate,
    MatchQ[suppliedSampleLoadingPlate,ObjectP[Object]],
      fastAssocLookup[fastAssoc,suppliedSampleLoadingPlate,Model],
    True,
      Null
  ];

  (* Get information from the sampleLoadingPlateModelPacket *)
  {loadingPlateMaxVolume,loadingPlateModelID}=If[
    Not[NullQ[sampleLoadingPlateModel]],
      {
        fastAssocLookup[fastAssoc,sampleLoadingPlateModel,MaxVolume],
        fastAssocLookup[fastAssoc,sampleLoadingPlateModel,Object]
      },
      {Null,Null}
  ];

  (* Get information about the SampleLoadingPlate if user has specified it *)
  loadingPlateContents=If[
    MatchQ[suppliedSampleLoadingPlate,ObjectP[Object]],
    fastAssocLookup[fastAssoc,suppliedSampleLoadingPlate,Contents],
    {}
  ];

  (* Get the Compositions out of the samplePackets *)
  sampleCompositions=Lookup[samplePackets,Composition,{}];

  (* === INPUT VALIDATION CHECKS === *)
  (* Get the samples from simulatedSamples that are discarded. *)
  discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

  (* If there are discarded invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&messages,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Cache->cacheBall]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[discardedInvalidInputs]==0,
        Nothing,
        Test["The input samples "<>ObjectToString[discardedInvalidInputs,Cache->cacheBall]<>" are not discarded:",True,False]
      ];

      passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
        Nothing,
        Test["The input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Cache->cacheBall]<>" are not discarded:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* --- Resolve the sample preparation method --- *)
  (* -- Always need to be false -- *)
  preparationResult=Check[
    {allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
      {
        resolveDynamicLightScatteringMethod[simulatedSamples, ReplaceRule[myOptions, {Cache->cacheBall,Simulation->simulation, Output->Result}]],
        {}
      },
      resolveDynamicLightScatteringMethod[simulatedSamples, ReplaceRule[myOptions, {Cache->cacheBall,Simulation->simulation, Output->{Result, Tests}}]]
    ],
    $Failed
  ];

  (* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
  (* options so that OptimizeUnitOperations can perform primitive grouping. *)
  resolvedPreparation=If[MatchQ[allowedPreparation, _List],
    First[allowedPreparation],
    allowedPreparation
  ];

  (* === OPTION PRECISION CHECKS === *)
  (* -- We will round the StandardDilutionCurve and SerialDilutionCurve Options separately cause they're strange --*)
  (* - StandardDilutionCurve - *)
  (* First, get the unrounded StandardDilutionCurves *)
  unroundedStandardDilutionCurve=Lookup[experimentOptions,StandardDilutionCurve];

  (* Make a list of Associations *)
  separatedUnroundedStandardDilutionCurve=Map[Association[StandardDilutionCurve -> #] &, unroundedStandardDilutionCurve];

  (* Round each Association *)
  {roundedStandardDilutionCurveOption, standardDilutionCurvePrecisionTests} = Transpose[If[gatherTests,
    MapThread[
      RoundOptionPrecision[#1, StandardDilutionCurve,
        If[MatchQ[#2, {{VolumeP, VolumeP} ..}],
          {10^-1*Microliter, 10^-1*Microliter},
          {10^-1*Microliter, 10^-3*(Milligram/Microliter)}
        ],
        Output -> {Result, Tests}
      ]&,
      {separatedUnroundedStandardDilutionCurve,unroundedStandardDilutionCurve}
    ],
    MapThread[
      {
        RoundOptionPrecision[#1, StandardDilutionCurve,
          If[MatchQ[#2, {{VolumeP, VolumeP} ..}],
            {10^-1*Microliter, 10^-1*Microliter},
            {10^-1*Microliter, 10^-3*(Milligram/Microliter)}]
        ],
        {}
      }&,
      {separatedUnroundedStandardDilutionCurve,unroundedStandardDilutionCurve}]
  ]];

  (* Put them back together *)
  roundedStandardDilutionCurveOptions=Merge[roundedStandardDilutionCurveOption,Join];

  (* - SerialDilutionCurve - *)
  (* Get the unrounded SerialDilutionCurve values *)
  unroundedSerialDilutionCurve=If[
    MatchQ[Lookup[experimentOptions,SerialDilutionCurve],{VolumeP,VolumeP,_Integer}|Automatic|{VolumeP,{_Real..},_Integer}|{VolumeP,{_Real,_Integer}}|{VolumeP,{_Real..}}],
    {Lookup[experimentOptions,SerialDilutionCurve]},
    Lookup[experimentOptions,SerialDilutionCurve]
  ];

  (* Round the Volume portion of each SerialDilutionCurve *)
  roundedSerialDilutionCurveOptions=Map[
    Which[
      (* If the option is Automatic or Null, we don't need to round *)
      MatchQ[#,Automatic|Null],
        #,

      MatchQ[#,{VolumeP, VolumeP, _Integer}],
        RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1*Microliter];
        Join[{SafeRound[First[#],10^-1*Microliter]},{SafeRound[#[[2]],10^-1*Microliter]},{Last[#]}],

      True,
        RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1*Microliter];
        Join[{SafeRound[First[#],10^-1*Microliter]},Rest[#]]
    ]&,
    unroundedSerialDilutionCurve
  ];

  (* Round the dilution factor portion of each SerialDilutionCurve *)
  doublyRoundedSerialDilutionCurveOptions=Map[
    Which[
      (* If the option is Automatic or Null, we don't need to round *)
      MatchQ[#,Automatic|Null|{VolumeP, VolumeP, _Integer}],
        #,

      True,
        RoundOptionPrecision[<|SerialDilutionCurve->First[Rest[#]]|>, SerialDilutionCurve, 10^-3];
        Join[{First[#]},{SafeRound[First[Rest[#]],10^-3],Last[#]}]
    ]&,
    roundedSerialDilutionCurveOptions
  ];

  (* Gather the tests for the SerialDilutionCurve option precision *)
  serialDilutionPrecisionTests=Map[
    Which[
      MatchQ[#,Automatic|Null],
        {},
      MatchQ[#,{VolumeP, VolumeP, _Integer}],
        If[gatherTests,
          Last[RoundOptionPrecision[<|SerialDilutionCurve->Most[#]|>, SerialDilutionCurve, 10^-1*Microliter,Output->{Result,Tests}]],
          {}
        ],
      True,
        If[gatherTests,
          Last[RoundOptionPrecision[<|SerialDilutionCurve->First[#]|>, SerialDilutionCurve, 10^-1*Microliter,Output->{Result,Tests}]],
          {}
        ]
    ]&,
    unroundedSerialDilutionCurve
  ];

  (* - Round all of the other experiment options - *)
  (* First, define the option precisions that need to be checked for DynamicLightScattering *)
  optionPrecisions={
    {SampleVolume,10^-1*Microliter},
    {AcquisitionTime,10^0*Second},
    {Temperature,10^0*Celsius},
    {EquilibrationTime,10^0*Second},
    {LaserPower,10^0*Percent},
    {DiodeAttenuation,10^0*Percent},
    {MeasurementDelayTime,10^0*Second},
    {IsothermalRunTime,10^0*Second},
    {DilutionMixVolume,10^-1*Microliter},
    {DilutionMixRate,10^-1*(Microliter/Second)},
    {AnalyteMassConcentration,10^-2*(Milligram/Milliliter)},
    {MinTemperature,10^0*Celsius},
    {MaxTemperature,10^0*Celsius},
    {TemperatureRampRate,10^-4*(Celsius/Second)},
    {TemperatureResolution,10^-4*Celsius},
    {StepHoldTime,10^0*Second}
  };

  (* Verify that the experiment options are not overly precise *)
  {roundedOtherExperimentOptions,optionPrecisionTests}=If[gatherTests,

    (*If we are gathering tests *)
    RoundOptionPrecision[Association[experimentOptions],optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

    (* Otherwise *)
    {RoundOptionPrecision[Association[experimentOptions],optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];

  roundedExperimentOptions=Join[roundedOtherExperimentOptions,roundedStandardDilutionCurveOptions,<|SerialDilutionCurve->doublyRoundedSerialDilutionCurveOptions|>];

  (* For option resolution below, Lookup the options that can be quantities or numbers from roundedExperimentOptions *)
  {
    suppliedSampleVolume,suppliedAcquisitionTime,suppliedTemperature,suppliedEquilibrationTime,suppliedLaserPower,
    suppliedDiodeAttenuation,suppliedMeasurementDelayTime,suppliedIsothermalRunTime,suppliedDilutionMixVolume,suppliedDilutionMixRate,
    suppliedNumberOfAcquisitions,suppliedNumberOfCycles,suppliedIsothermalMeasurements,suppliedStandardDilutionCurve,
    suppliedSerialDilutionCurve,suppliedDilutionNumberOfMixes,suppliedNumberOfReplicates,suppliedAnalyteMassConcentration,suppliedMinTemperature,suppliedMaxTemperature,suppliedTemperatureRampRate,suppliedTemperatureResolution,suppliedNumberOfTemperatureRampSteps,suppliedStepHoldTime
  }=
      Lookup[
        roundedExperimentOptions,
        {
          SampleVolume,AcquisitionTime,Temperature,EquilibrationTime,LaserPower,DiodeAttenuation,MeasurementDelayTime,
          IsothermalRunTime,DilutionMixVolume,DilutionMixRate,NumberOfAcquisitions,NumberOfCycles,IsothermalMeasurements,
          StandardDilutionCurve,SerialDilutionCurve,DilutionNumberOfMixes,NumberOfReplicates,AnalyteMassConcentration,MinTemperature,MaxTemperature,TemperatureRampRate,TemperatureResolution,NumberOfTemperatureRampSteps,StepHoldTime
        }
      ];

  (* Turn the output of RoundOptionPrecision[experimentOptions] into a list *)
  roundedExperimentOptionsList=Normal[roundedExperimentOptions];

  (* Replace the rounded options in myOptions *)
  allOptionsRounded=ReplaceRule[
    myOptions,
    roundedExperimentOptionsList,
    Append->False
  ];

  (* === CONFLICTING OPTIONS CHECKS === *)


  (* -- Check that MaxTemperature is not higher than MinTemperature -- *)
  invalidMinMaxTemperatureOptions=If[
    Or[
      suppliedMinTemperature<suppliedMaxTemperature,
      MatchQ[suppliedMinTemperature,Automatic|Null],
      MatchQ[suppliedMaxTemperature,Automatic|Null]
    ],
      {},
    (
      Message[Error::MinMaxTemperatureMismatch,ObjectToString[suppliedMinTemperature],ObjectToString[suppliedMaxTemperature]];
      {suppliedMinTemperature,suppliedMaxTemperature}
    )
  ];

  (* Generate Tests for MinMaxTemperatureMismatch *)
  minMaxTemperatureMismatchTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidMinMaxTemperatureOptions]==0,
        Nothing,
        Test["The supplied MinTemperature "<>ToString[suppliedMinTemperature]<>" is greater than or equal to the supplied MaxTemperature "<>ToString[suppliedMinTemperature]<>".",True,False]
      ];
      passingTest=If[Length[invalidMinMaxTemperatureOptions]==0,
        Test["The supplied MinTemperature "<>ToString[suppliedMinTemperature]<>" is less than the supplied MaxTemperature "<>ToString[suppliedMinTemperature]<>".",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];



  (* -- Check that the protocol name is unique -- *)
  validNameQ=If[MatchQ[suppliedName,_String],

    (* If the name was specified, make sure its not a duplicate name *)
    Not[DatabaseMemberQ[Object[Protocol,DynamicLightScattering,suppliedName]]],

    (* Otherwise, its all good *)
    True
  ];

  (* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
  nameInvalidOption=If[!validNameQ&&messages,
    (
      Message[Error::DuplicateName,"DynamicLightScattering protocol"];
      {Name}
    ),
    {}
  ];

  (* Generate Test for Name check *)
  validNameTest=If[gatherTests&&MatchQ[suppliedName,_String],
    Test["If specified, Name is not already an DynamicLightScattering protocol object name:",
      validNameQ,
      True
    ],
    Nothing
  ];

  (* -- Check that the Instrument is one of the accepted Models -- *)
  (* - Find the Model of the instrument, if it was specified - *)
  suppliedInstrumentModel=Which[
    (*If user supplied a Model, we take it*)
    MatchQ[suppliedInstrument,ObjectP[Model[Instrument]]],
      suppliedInstrument,

    (*If user supplied an Object, we take its Model*)
    MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
      fastAssocLookup[fastAssoc,fastAssocLookup[fastAssoc,suppliedInstrument,Model],Object],

    (*If nothing was specified, we leave this as Null*)
    True,
      Null
  ];

  (* Pattern containing the instruments that are currently supported in DLS *)
  validInstrumentP=Alternatives[
    Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"],(*Uncle*)
    Model[Instrument, DLSPlateReader, "id:mnk9jOkYvNpK"](*DynaPro*)
  ];

  (* Check to see if the instrument option is set and valid *)
  invalidUnsupportedInstrumentOption=Which[

    (* IF the instrument is not specified, the option is fine *)
    MatchQ[suppliedInstrumentModel,Null],
      {},

    (* IF the instrument model matches validInstrumentP, then the option is valid *)
    MatchQ[suppliedInstrumentModel,validInstrumentP],
      {},

    (* OTHERWISE, the Instrument option is invalid *)
    True,
      {Instrument}
  ];

  (* If the instrument option is invalid, and we are throwing messages, throw an Error message *)
  If[Length[invalidUnsupportedInstrumentOption]>0&&messages,
    Message[Error::InvalidDLSInstrument,ObjectToString[suppliedInstrument,Cache->cacheBall]]
  ];

  (* Define the tests for the above error *)
  validInstrumentTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidUnsupportedInstrumentOption]==0,
        Nothing,
        Test["The Instrument option "<>ObjectToString[suppliedInstrument,Cache->cacheBall]<>" is either of the Model Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or Model[Instrument,DLSPlateReader,\"DynaPro\"]",True,False]
      ];
      passingTest=If[Length[invalidUnsupportedInstrumentOption]>0&&MatchQ[suppliedInstrument,Except[Automatic]],
        Nothing,
        Test["The Instrument option "<>ObjectToString[suppliedInstrument,Cache->cacheBall]<>" is either of the Model Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or Model[Instrument,DLSPlateReader,\"DynaPro\"]",True,True]
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Define Patterns for the Dilution assay types (ColloidalStability) and the non-Dilution Assay Types (SizingPolydispersity, IsothermalStability, MeltingCurve *)
  (* --- Tests to ensure that supplied AssayType is not in conflict with any other supplied options --- *)

  (* - Throw an Error if the SampleLoadingPlate is occupied - *)
  (* Determine if the Plate has Contents *)
  sampleLoadingPlateOccupiedQ=Not[MatchQ[loadingPlateContents,{}|$Failed]];

  (* Define the invalid option variable *)
  invalidOccupiedPlateOptions=If[sampleLoadingPlateOccupiedQ,
    {SampleLoadingPlate},
    {}
  ];

  (* If the supplied SampleLoadingPlate has any Contents and we are throwing Messages, throw an Error *)
  invalidOccupiedPlateOptions=If[sampleLoadingPlateOccupiedQ&&messages,
    (
      Message[Error::OccupiedDLSSampleLoadingPlate, ObjectToString[suppliedSampleLoadingPlate, Cache -> cacheBall], ObjectToString[loadingPlateContents]];
      {SampleLoadingPlate}
    ),
    {}
  ];

  (* Define the tests the user will see for the above message *)
  occupiedSampleLoadingPlateTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidOccupiedPlateOptions]==0,
        Nothing,
        Test["The SampleLoadingPlate "<>ObjectToString[suppliedSampleLoadingPlate,Cache->cacheBall]<>", is not empty. If the SampleLoadingPlate is specified as an Object, its Contents field must not be populated:",True,False]
      ];
      passingTest=If[Length[invalidOccupiedPlateOptions]>0,
        Nothing,
        Test["The SampleLoadingPlate is either a Model, or an Object with no Contents:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw a Warning if the SampleLoadingPlate is not of the default Model - *)
  (* Determine if we need to throw the Warning *)
  nonDefaultLoadingPlateWarningQ=Not[MatchQ[suppliedSampleLoadingPlate,Automatic|Null]||MatchQ[loadingPlateModelID,Model[Container, Plate, "id:01G6nvkKrrYm"]]];

  (* If the supplied SampleLoadingPlate has any Contents and we are throwing Messages, throw an Error *)
  If[nonDefaultLoadingPlateWarningQ&&messages&&notInEngine,
    Message[Warning::NonDefaultDLSSampleLoadingPlate,ObjectToString[suppliedSampleLoadingPlate,Cache->cacheBall],ObjectToString[loadingPlateModelID,Cache->cacheBall]]
  ];

  (* Define the tests the user will see for the above message *)
  nonDefaultLoadingPlateTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[nonDefaultLoadingPlateWarningQ,
        Warning["The SampleLoadingPlate, "<>ObjectToString[suppliedSampleLoadingPlate,Cache->cacheBall]<>", is of the Model "<>ObjectToString[loadingPlateModelID,Cache->cacheBall]<>". The default SampleLoadingPlate Model is Model[Container, Plate, \"96-well PCR Plate\"]. Using a non-default Model, particularly one with a larger MinVolume, may result in mis-loading of the AssayContainers, as the small 9uL transfers have been optimized only for the default model:",True,False],
        Nothing
      ];
      passingTest=If[nonDefaultLoadingPlateWarningQ,
        Nothing,
        Warning["The SampleLoadingPlate is of the default Model:",True,True]
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* === RESOLVE EXPERIMENT OPTIONS === *)

  (* --- Resolve AssayFormFactor, a primary master switch --- *)
  resolvedAssayFormFactor=Which[
    (*If the user has specified an AssayFormFactor, we accept it, and do error checking before and after option resolution*)
    MatchQ[suppliedAssayFormFactor,Except[Automatic]],
      suppliedAssayFormFactor,

    (*If the user has specified an instrument, we'll use the corresponding AssayFormFactor*)
    MatchQ[suppliedInstrumentModel,ObjectP[Model[Instrument,MultimodeSpectrophotometer]]|ObjectP[Object[Instrument,MultimodeSpectrophotometer]]],
      Capillary,
    MatchQ[suppliedInstrumentModel,ObjectP[Model[Instrument,DLSPlateReader]]|ObjectP[Model[Instrument,DLSPlateReader]]],
      Plate,

    (*If the user has specified any Uncle-specific fields, we'll go with Capillary*)
    Or[
      MatchQ[suppliedSampleLoadingPlate,Except[Automatic|Null]],
      MatchQ[suppliedCapillaryLoading,Except[Automatic|Null]],
      MatchQ[suppliedSampleLoadingPlateStorageCondition,Except[Automatic|Null]]
    ],
      Capillary,

    (*If the user has specified any DynaPro-specific fields, we'll go with Plate*)
    Or[
      MatchQ[suppliedWellCover,Except[Automatic|Null]],
      MatchQ[suppliedWellCoverHeating,Except[Automatic|Null]]
    ],
      Plate,

    (*If the user has set the Sample Volume...*)
    VolumeQ[suppliedSampleVolume]&&suppliedSampleVolume<=(25*Microliter),
      Capillary,
    VolumeQ[suppliedSampleVolume],
      Plate,

    (*If the user has left no clues, go with Plate*)
    True,
      Plate
  ];

  (* --- Resolve Instrument, which HOPEFULLY should be tied to AssayFormFactor --- *)
  resolvedInstrument=Which[
    (*If the user has specified an Instrument, we accept it, and do error checking before and after option resolution*)
    MatchQ[suppliedInstrument,Except[Automatic]],
      suppliedInstrument,

    (*Otherwise, we use resolvedAssayFormFactor*)
    MatchQ[resolvedAssayFormFactor,Plate],
      Model[Instrument, DLSPlateReader, "id:mnk9jOkYvNpK"](*DynaPro*),
    MatchQ[resolvedAssayFormFactor,Capillary],
      Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"](*Uncle*)
  ];

  (* Set instrument packet - we'll need this later *)
  resolvedInstrumentPacket=fetchPacketFromFastAssoc[resolvedInstrument,fastAssoc];

  (*Set Instrument Model packet if Instrument is an Object*)
  resolvedInstrumentModelPacket=If[MatchQ[resolvedInstrument,ObjectP[Model[Instrument]]],
    resolvedInstrumentPacket,
    fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc,resolvedInstrument,Model],fastAssoc]
  ];

  (* Throw ConflictingDLSFormFactorInstrument Error *)
  invalidFormFactorInstrumentOptions=If[
    Or[
      MatchQ[resolvedAssayFormFactor,Plate]&&MatchQ[resolvedInstrument,ObjectP[Model[Instrument, MultimodeSpectrophotometer]]],
      MatchQ[resolvedAssayFormFactor,Capillary]&&MatchQ[resolvedInstrument,ObjectP[Model[Instrument,DLSPlateReader]]]
    ],
    (
      Message[Error::ConflictingDLSFormFactorInstrument,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedInstrument]];
      {AssayFormFactor,Instrument}
    ),
    {}
  ];

  (* If we are gathering tests, create a test for ConflictingDLSFormFactorInstrument *)
  conflictingDLSFormFactorInstrumentTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidFormFactorInstrumentOptions,{}],
        Nothing,
        Test["The AssayFormFactor "<>resolvedAssayFormFactor<>" and Instrument "<>resolvedInstrument<>" are not in agreement. If AssayFormFactor is Plate, Instrument must be a member of Model[Instrument,DLSPlateReader], and if AssayFormFactor is Capillary, Instrument must be a member of Model[Instrument,MultimodeSpectrophotometer]:",True,False]
      ];
      passingTest=If[MatchQ[invalidFormFactorInstrumentOptions,{}],
        Test["Either the AssayFormFactor is Plate and Instrument is a member of Model[Instrument,DLSPlateReader], or AssayFormFactor is Capillary and Instrument is a member of Model[Instrument,MultimodeSpectrophotometer]:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* --- Resolve AssayType, the Master Switch --- *)
  (* -- First, we are going to set a bunch of booleans to indicate whether any of the specified options suggest how the AssayType will be specified -- *)
  (* - To do this, we will set variables that are lists of the options that indicate a certain AssayType - *)
  (* Isothermal Stability Options *)
  isothermalStabilityOptionNames={
    MeasurementDelayTime,IsothermalMeasurements,IsothermalRunTime,IsothermalAttenuatorAdjustment
  };
  isothermalStabilitySuppliedOptions={
    suppliedMeasurementDelayTime,suppliedIsothermalMeasurements,suppliedIsothermalRunTime,suppliedIsothermalAttenuatorAdjustment
  };

  (* ColloidalStability Options *)
  colloidalStabilityOptionNames={
    ReplicateDilutionCurve,StandardDilutionCurve,SerialDilutionCurve,Buffer,DilutionMixType,DilutionMixVolume,DilutionNumberOfMixes,
    DilutionMixRate,DilutionMixInstrument,BlankBuffer,Analyte,AnalyteMassConcentration
  };
  colloidalStabilitySuppliedOptions={
    suppliedReplicateDilutionCurve,suppliedStandardDilutionCurve,suppliedSerialDilutionCurve,suppliedBuffer,suppliedDilutionMixType,
    suppliedDilutionMixVolume,suppliedDilutionNumberOfMixes,suppliedDilutionMixRate,suppliedDilutionMixInstrument,suppliedBlankBuffer,suppliedAnalyte,
    suppliedAnalyteMassConcentration
  };

  (* Melting Curve Options*)
  meltingCurveOptionNames={
    MinTemperature,
    MaxTemperature,
    TemperatureRampOrder,
    NumberOfCycles,
    TemperatureRamping,
    TemperatureRampRate,
    TemperatureResolution,
    NumberOfTemperatureRampSteps,
    StepHoldTime
  };
  meltingCurveSuppliedOptions={
    suppliedMinTemperature,
    suppliedMaxTemperature,
    suppliedTemperatureRampOrder,
    suppliedNumberOfCycles,
    suppliedTemperatureRamping,
    suppliedTemperatureRampRate,
    suppliedTemperatureResolution,
    suppliedNumberOfTemperatureRampSteps,
    suppliedStepHoldTime
  };

  (* - Set Booleans if any of the options that indicate a specific AssayType will be set are specified as non Null/Automatic - *)
  isothermalStabilityOptionsSpecifiedQ=MemberQ[isothermalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic]]];
  colloidalStabilityOptionsSpecifiedQ=MemberQ[colloidalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic,{Alternatives[Null,Automatic]..}]]];
  meltingCurveOptionsSpecifiedQ=MemberQ[meltingCurveSuppliedOptions,Except[Alternatives[Null,Automatic]]];

  resolvedAssayType=Which[

    (* If the user has specified an AssayType, we accept it (and do error checking before and after option resolution to make sure its cool *)
    MatchQ[suppliedAssayType,Except[Automatic]],
      suppliedAssayType,

    (* If any of the IsothermalStability-specific options are user-specified, we resolve to IsothermalStability *)
    isothermalStabilityOptionsSpecifiedQ,
      IsothermalStability,

    (* If any of the Colloidal Stability-specific options are user-specified, we resolve to ColloidalStability *)
    colloidalStabilityOptionsSpecifiedQ,
      ColloidalStability,

    (*If any of the Melting Curve-specific options are user-specified, we set to MeltingCurve*)
    meltingCurveOptionsSpecifiedQ,
      MeltingCurve,

    (* Otherwise, we set AssayType to SizingPolydispersity *)
    True,
      SizingPolydispersity
  ];

  (*Uncle-specific options*)

  (* Resolve sample loading plate - only for Capillary *)
  resolvedSampleLoadingPlate=Which[
    (*If the user has specified a SampleLoadingPlate, go with it*)
    MatchQ[suppliedSampleLoadingPlate,Except[Automatic]],
      suppliedSampleLoadingPlate,

    (*If AssayFormFactor is Capillary, set to 96-well plate; if Plate, Null*)
    MatchQ[resolvedAssayFormFactor,Capillary],
      Model[Container,Plate,"96-well PCR Plate"],
    True,Null
  ];

  (* Throw ConflictingDLSFormFactorLoadingPlate Error *)
  invalidFormFactorLoadingPlateOptions=Switch[{resolvedAssayFormFactor,resolvedSampleLoadingPlate},

    (*If AssayFormFactor is Plate and SampleLoadingPlate is *not* null, throw the error*)
    {Plate,Except[Null]},
    (
      Message[Error::ConflictingDLSFormFactorLoadingPlate,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedSampleLoadingPlate]];
      {AssayFormFactor,SampleLoadingPlate}
    ),

    (*If AssayFormFactor is Capillary and SampleLoadingPlate is Null, throw the error*)
    {Capillary,Null},
    (
      Message[Error::ConflictingDLSFormFactorLoadingPlate,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedSampleLoadingPlate]];
      {AssayFormFactor,SampleLoadingPlate}
    ),

    (*Otherwise, no conflict*)
    {_,_},
    {}
  ];

  (* If we are gathering tests, create test for ConflictingDLSFormFactorLoadingPlate *)
  conflictingDLSFormFactorLoadingPlateTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidFormFactorLoadingPlateOptions,{}],
        Nothing,
        Test["The AssayFormFactor "<>resolvedAssayFormFactor<>" and SampleLoadingPlate "<>resolvedSampleLoadingPlate<>" are not in agreement. If AssayFormFactor is Plate, SampleLoadingPlate must be Null, and if AssayFormFactor is Capillary, SampleLoadingPlate must not be Null:",True,False]
      ];
      passingTest=If[MatchQ[invalidFormFactorLoadingPlateOptions,{}],
        Test["SampleLoadingPlate is Null if AssayFormFactor is Plate and not Null otherwise:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (*Resolve Capillary Loading - only for Capillary*)
  resolvedCapillaryLoading=Which[
    (*If the user has specified Capillary Loading, go with it*)
    MatchQ[suppliedCapillaryLoading,Except[Automatic]],
      suppliedCapillaryLoading,

    (*If AssayFormFactor is Capillary, set to Manual; if Plate, Null*)
    MatchQ[resolvedAssayFormFactor,Capillary],
      Manual,
    True,Null
  ];

  (* Throw ConflictingDLSFormFactorCapillaryLoading Error *)
  invalidFormFactorCapillaryOptions=Switch[{resolvedAssayFormFactor,resolvedCapillaryLoading},

    (*If AssayFormFactor is Plate and CapillaryLoading is *not* null, throw the error*)
    {Plate,Except[Null]},
    (
      Message[Error::ConflictingDLSFormFactorCapillaryLoading,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedCapillaryLoading]];
      {AssayFormFactor,CapillaryLoading}
    ),

    (*If AssayFormFactor is Capillary and CapillaryLoading is Null, throw the error*)
    {Capillary,Null},
    (
      Message[Error::ConflictingDLSFormFactorCapillaryLoading,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedCapillaryLoading]];
      {AssayFormFactor,CapillaryLoading}
    ),

    (*Otherwise, no conflict*)
    {_,_},
    {}
  ];

  (* If we are gathering tests, create test for ConflictingDLSFormFactorCapillaryLoading *)
  conflictingDLSFormFactorCapillaryLoadingTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidFormFactorCapillaryOptions,{}],
        Nothing,
        Test["The AssayFormFactor "<>resolvedAssayFormFactor<>" and CapillaryLoading "<>resolvedCapillaryLoading<>" are not in agreement. If AssayFormFactor is Plate, CapillaryLoading must be Null, and if AssayFormFactor is Capillary, CapillaryLoading must not be Null:",True,False]
      ];
      passingTest=If[MatchQ[invalidFormFactorCapillaryOptions,{}],
        Test["CapillaryLoading is Null if AssayFormFactor is Plate and not Null otherwise:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Resolve sample loading plate storage condition - only for Capillary *)
  resolvedSampleLoadingPlateStorageCondition=Which[
    (*If the user has specified a SampleLoadingPlateStorageCondition, go with it*)
    MatchQ[suppliedSampleLoadingPlateStorageCondition,Except[Automatic]],
    suppliedSampleLoadingPlateStorageCondition,

    (*If AssayFormFactor is Capillary, set to Disposal; if Plate, Null*)
    MatchQ[resolvedAssayFormFactor,Capillary],
      Disposal,
    True,Null
  ];

  (* Throw ConflictingDLSFormFactorPlateStorage Error *)
  invalidFormFactorPlateStorageOptions=Switch[{resolvedAssayFormFactor,resolvedSampleLoadingPlateStorageCondition},

    (*If AssayFormFactor is Plate and SampleLoadingPlate is *not* null, throw the error*)
    {Plate,Except[Null]},
    (
      Message[Error::ConflictingDLSFormFactorPlateStorage,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedSampleLoadingPlateStorageCondition]];
      {resolvedAssayFormFactor,resolvedSampleLoadingPlateStorageCondition}
    ),

    (*If AssayFormFactor is Capillary and SampleLoadingPlate is Null, throw the error*)
    {Capillary,Null},
    (
      Message[Error::ConflictingDLSFormFactorPlateStorage,ObjectToString[resolvedAssayFormFactor],ObjectToString[resolvedSampleLoadingPlateStorageCondition]];
      {resolvedAssayFormFactor,resolvedSampleLoadingPlateStorageCondition}
    ),

    (*Otherwise, no conflict*)
    {_,_},
    {}
  ];

  (* If we are gathering tests, create test for ConflictingDLSFormFactorPlateStorage *)
  conflictingDLSFormFactorPlateStorageTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidFormFactorPlateStorageOptions,{}],
        Nothing,
        Test["The AssayFormFactor "<>resolvedAssayFormFactor<>" and SampleLoadingPlateStorageCondition "<>resolvedSampleLoadingPlateStorageCondition<>" are not in agreement. If AssayFormFactor is Plate, SampleLoadingPlateStorageCondition must be Null, and if AssayFormFactor is Capillary, SampleLoadingPlateStorageCondition must not be Null:",True,False]
      ];
      passingTest=If[MatchQ[invalidFormFactorPlateStorageOptions,{}],
        Test["SampleLoadingPlate is Null if AssayFormFactor is Plate and not Null otherwise:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (*DynaPro-specific options*)

  (*Resolve WellCover*)
  resolvedWellCover=Which[

    (*If the user has specified WellCover, accept it*)
    MatchQ[suppliedWellCover,Except[Automatic]],
      suppliedWellCover,

    (*If the user has not specified WellCover and AssayFormFactor is Plate, set to Model[Sample,"Silicone Oil"]*)
    MatchQ[resolvedAssayFormFactor,Plate],
      Model[Sample,"id:E8zoYvzJWDd7"],(*Silicone Oil*)

    (*If AssayFormFactor is Capillary, set to Null*)
    True,
      Null
  ];

  (* Throw ConflictingFormFactorWellCover Error *)
  invalidFormFactorWellCoverOptions=Switch[{resolvedAssayFormFactor,resolvedWellCover},

    (*Throw error if AssayFormFactor is Plate and WellCover is Null...*)
    {Plate,Null},
    (
      Message[Error::ConflictingFormFactorWellCover, ObjectToString[resolvedAssayFormFactor], ObjectToString[resolvedWellCover]];
      {resolvedAssayFormFactor,resolvedWellCover}
    ),

    (* or if AssayFormFactor is Capillary and WellCover is NOT Null*)
    {Capillary,Except[Null]},
    (
      Message[Error::ConflictingFormFactorWellCover, ObjectToString[resolvedAssayFormFactor], ObjectToString[resolvedWellCover]];
      {resolvedAssayFormFactor,resolvedWellCover}
    ),

    (* Otherwise, do not throw an error *)
    {_,_},
    {}
  ];

  (* Create test for ConflictingFormFactorWellCover *)
  conflictingFormFactorWellCoverTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidFormFactorWellCoverOptions,{}],
        Nothing,
        Test["The AssayFormFactor "<>resolvedAssayFormFactor<>" and WellCover "<>resolvedWellCover<>" are not in agreement. If AssayFormFactor is Plate, WellCover must not be Null, and if AssayFormFactor is Capillary, WellCover must be Null:",True,False]
      ];
      passingTest=If[MatchQ[invalidFormFactorWellCoverOptions,{}],
        Test["WellCover is not Null if AssayFormFactor is Plate and Null if AssayFormFactor is Capillary:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (*Resolve WellCoverHeating*)
  resolvedWellCoverHeating=Which[

    (*If the user has specified WellCoverHeating, accept it*)
    MatchQ[suppliedWellCoverHeating,Except[Automatic]],
    suppliedWellCoverHeating,

    (*If the user has not specified WellCoverHeating and AssayFormFactor is Plate and the well cover is a plate seal, set to True*)
    MatchQ[resolvedAssayFormFactor,Plate]&&MatchQ[resolvedWellCover,ObjectP[{Model[Item,PlateSeal],Object[Item,PlateSeal]}]],
      True,

    (* If AssayFormFactor is Plate and the well cover is not a plate seal, set to True *)
    MatchQ[resolvedAssayFormFactor,Plate],
      False,

    (*If AssayFormFactor is Capillary, set to Null*)
    True,
      Null
  ];

  (* Throw ConflictingFormFactorWellCoverHeating Error *)
  invalidFormFactorWellCoverHeatingOptions=Switch[{resolvedAssayFormFactor,resolvedWellCoverHeating},

    (*Throw error if AssayFormFactor is Plate and WellCoverHeating is Null...*)
    {Plate,Null},
    (
      Message[Error::ConflictingFormFactorWellCoverHeating, ObjectToString[resolvedAssayFormFactor], ObjectToString[resolvedWellCoverHeating]];
      {resolvedAssayFormFactor,resolvedWellCoverHeating}
    ),

    (* or if AssayFormFactor is Capillary and WellCoverHeating is NOT Null*)
    {Capillary,Except[Null]},
    (
      Message[Error::ConflictingFormFactorWellCoverHeating, ObjectToString[resolvedAssayFormFactor], ObjectToString[resolvedWellCoverHeating]];
      {resolvedAssayFormFactor,resolvedWellCoverHeating}
    ),

    (* Otherwise, do not throw an error *)
    {_,_},
    {}
  ];

  (* Create test for ConflictingFormFactorWellCover *)
  conflictingFormFactorWellCoverHeatingTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidFormFactorWellCoverHeatingOptions,{}],
        Nothing,
        Test["The AssayFormFactor "<>resolvedAssayFormFactor<>" and WellCoverHeating "<>resolvedWellCoverHeating<>" are not in agreement. If AssayFormFactor is Plate, WellCoverHeating must not be Null, and if AssayFormFactor is Capillary, WellCoverHeating must be Null:",True,False]
      ];
      passingTest=If[MatchQ[invalidFormFactorWellCoverHeatingOptions,{}],
        Test["WellCoverHeating is not Null if AssayFormFactor is Plate and Null if AssayFormFactor is Capillary:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (*Resolve Number of Replicates*)
  resolvedNumberOfReplicates=Which[
    (*If user has specified NumberOfReplicates, go with it*)
    MatchQ[suppliedNumberOfReplicates,Except[Automatic]],
      suppliedNumberOfReplicates,

    (*If AssayType is Colloidal Stability, set to 3*)
    MatchQ[resolvedAssayType,ColloidalStability],
      3,

    (*Otherwise, set to 2*)
    True,
      2
  ];

  (* Define a variable for the NumberOfReplicates with Null replaced with 1 *)
  intNumberOfReplicates=resolvedNumberOfReplicates/.{Null->1};
  numberOfSamplesWithReplicates=(numberOfSamples*intNumberOfReplicates);

  (* --- Resolve other non index-matched options --- *)
  (* -- Laser options -- *)
  (* - LaserPower - *)
  resolvedLaserPower=Which[

    (* If the user has specified the LaserPower, we accept it (already did error checking) *)
    MatchQ[suppliedLaserPower,Except[Automatic]],
      suppliedLaserPower,

    (* Otherwise, resolve based on the AutomaticLaserSettings - set to Null if True and to 100% otherwise *)
    MatchQ[suppliedAutomaticLaserSettings,True],
      Null,
    True,
      100*Percent
  ];

  (* - DiodeAttenuation - *)
  resolvedDiodeAttenuation=Which[

    (* If the user has specified the LaserPower, we accept it (already did error checking) *)
    MatchQ[suppliedDiodeAttenuation,Except[Automatic]],
      suppliedDiodeAttenuation,

    (* Otherwise, resolve based on the AutomaticLaserSettings - set to Null if True and to 100% otherwise *)
    MatchQ[suppliedAutomaticLaserSettings,True],
      Null,
    True,
      100*Percent
  ];

  (*Resolve NumberOfAcquisitions*)
  resolvedNumberOfAcquisitions=Which[

    (*If user has supplied NumberOfAcquisitions, accept it*)
    MatchQ[suppliedNumberOfAcquisitions,Except[Automatic]],
    suppliedNumberOfAcquisitions,

    (*If AssayFormFactor is Capillary, set to 4*)
    MatchQ[resolvedAssayFormFactor,Capillary],
    4,

    (*If AssayFormFactor is Plate, set to 5*)
    True,
    5
  ];

  (* Resolve ColloidalStabilityParametersPerSample - need to do this a little early for the next section *)
  resolvedColloidalStabilityParametersPerSample=Which[

    (*If user has set option, accept it*)
    MatchQ[suppliedColloidalStabilityParametersPerSample,Except[Automatic]],
    suppliedColloidalStabilityParametersPerSample,

    (*If we're NOT in ColloidalStability and user has not set option, set to Null and don't trigger error Boolean*)
    MatchQ[resolvedAssayType,Except[ColloidalStability]],
    Null,

    (*If user has not set option, set to 5*)
    True,
    2
  ];

  (* - SampleVolume - *)

  (* Before we actually resolve the sampleVolume, we need to first get the expected size of the well plate if we're in Plate. *)
  (* We should be able to do this on the basis of supplied options without needing to actually resolve them first. *)
  expectedNumberOfWells=Which[

    (*For the sake of completeness, we'll include Capillary here, even though it's pretty much irrelevant and not fully accurate*)
    MatchQ[resolvedAssayFormFactor,Capillary],
      48,

    (* If the user's given us a sample volume below 30 uL, I don't think we can do 96-well plates at all, so we'll go with 384*)
    !MatchQ[suppliedSampleVolume,Automatic]&&LessEqualQ[suppliedSampleVolume,30*Microliter],
      384,

    (* If we're doing an assay type other than ColloidalStability, we have to check if we need more than 96 wells *)
    !MatchQ[resolvedAssayType,ColloidalStability] && GreaterQ[Length[mySamples]*intNumberOfReplicates,96],
      384,

    (* If the user wants to do ColloidalStability assays, we have to check if they need more than 96 wells *)
    (* First, we'll see if user has supplied an actual dilutioncurve *)
    (* With a standard dilution curve, this involves getting the number of dilutions and multiplying by the number of replicates *)
    !MatchQ[suppliedStandardDilutionCurve,{Automatic..}] && !NullQ[suppliedStandardDilutionCurve] && GreaterQ[Length[Flatten[suppliedStandardDilutionCurve,1]]*intNumberOfReplicates*resolvedColloidalStabilityParametersPerSample,96],
      384,

    (* For serial dilution curves, we need to do the same, but we get the number of dilutions directly from the curve itself *)
    !MatchQ[suppliedSerialDilutionCurve,{Automatic..}] && !NullQ[suppliedSerialDilutionCurve] && GreaterQ[Plus[Last/@suppliedSerialDilutionCurve]*intNumberOfReplicates*resolvedColloidalStabilityParametersPerSample,96],
      384,

    (* If we're in ColloidalStability and no dilution curve has been specified, we'll be doing a standard dilution curve; *)
    (* The default standard dilution curve is 5 dilutions, so we'll multiply the number of samples by 5 and then again by *)
    (* the number of replicates *)
    MatchQ[resolvedAssayType,ColloidalStability] && GreaterQ[Length[mySamples]*5*intNumberOfReplicates*resolvedColloidalStabilityParametersPerSample,96],
      384,

    (* If none of the above conditions are met, we're going with a 96-well plate *)
    True,
      96
  ];

  resolvedSampleVolume=Which[

    (* If the user has specified the SampleVolume, we accept it (will check later that its okay) *)
    !MatchQ[suppliedSampleVolume,Automatic],
      suppliedSampleVolume,

    (* Cases where option has not been specified *)
    (* If the AssayType is ColloidalStability, we resolve to Null (initial volume will be set by the DilutionCurve options) *)
    MatchQ[resolvedAssayType,ColloidalStability],
      Null,

    (* Otherwise, we resolve to 15 uL for Capillary... *)
    MatchQ[resolvedAssayFormFactor,Capillary],
      15*Microliter,

    (* If we're expecting a 384-well plate, 30 uL *)
    MatchQ[expectedNumberOfWells,384],
      30*Microliter,

    (* If we're expecting a 96-well plate, 100 uL *)
    True,
      100*Microliter
  ];

  (* Error boolean for incompatible sample volume and instrument *)
  invalidTooLowSampleVolumeOptions=Switch[{resolvedAssayFormFactor,resolvedSampleVolume},

    (*If AssayFormFactor is Plate, minimum sample volume is 25 uL*)
    {Plate,LessEqualP[25*Microliter]},
    (
      Message[Error::TooLowSampleVolume,ObjectToString[resolvedSampleVolume],ObjectToString[resolvedAssayFormFactor]];
      {resolvedSampleVolume,resolvedAssayFormFactor}
    ),

    (*If AssayFormFactor is Capillary, minimum sample volume is 9 uL*)
    {Capillary,LessEqualP[9*Microliter]},
    (
      Message[Error::TooLowSampleVolume,ObjectToString[resolvedSampleVolume],ObjectToString[resolvedAssayFormFactor]];
      {resolvedSampleVolume,resolvedAssayFormFactor}
    ),

    {_,_},
    {}
  ];

  (* If we are gathering tests, create a test for TooLowSampleVolume *)
  tooLowSampleVolumeTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidTooLowSampleVolumeOptions,{}],
        Nothing,
        Test["The SampleVolume "<>resolvedSampleVolume<>" is too low for the given AssayFormFactor "<>resolvedAssayFormFactor<>". If AssayFormFactor is Plate, SampleVolume must exceed 25 uL, and if AssayFormFactor is Capillary, SampleVolume must exceed 9 uL:",True,False]
      ];
      passingTest=If[MatchQ[invalidTooLowSampleVolumeOptions,{}],
        Test["The SampleVolume is not too low for the given AssayFormFactor:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Resolve IsothermalAttenuatorAdjustment - *)
  resolvedIsothermalAttenuatorAdjustment=Which[

    (*If user has specified a value, accept it*)
    MatchQ[suppliedIsothermalAttenuatorAdjustment,Except[Automatic]],
      suppliedIsothermalAttenuatorAdjustment,

    (*If AssayType is not IsothermalStability, set to Null*)
    MatchQ[resolvedAssayType,Except[IsothermalStability]],
      Null,

    (*Otherwise, set to Every*)
    True,
      Every
  ];

  (* - MeasurementDelayTime - *)
  (* First, set a variable that is the minimum required MeasurementDelayTime (used for resolution and later error checking) *)(*todo: this needs to be redone for DynaPro*)
  requiredMinimumDelayTime=Which[

    (* In the case that the resolvedAssayType is not IsothermalStability, we set the variable to Null *)
    MatchQ[resolvedAssayType,Except[IsothermalStability]],
      Null,

    (* Otherwise, we resolve based on the IsothermalAttenuatorAdjustment, the number of samples, and the Number of Replicates *)
    (* When the IsothermalAttenuatorAdjustment is True *)
    MatchQ[resolvedIsothermalAttenuatorAdjustment,Every],
      RoundOptionPrecision[(((47*numberOfSamples*intNumberOfReplicates)+30)*Second),10^0*Second,Round->Up],

    (* In all other cases *)
    True,
      RoundOptionPrecision[(((39.4*numberOfSamples*intNumberOfReplicates)+30)*Second),10^0*Second,Round->Up]
  ];

  (*Resolve MeasurementDelayTime*)
  resolvedMeasurementDelayTime=Which[
    (*If user has specified a value, accept it*)
    MatchQ[suppliedMeasurementDelayTime,Except[Automatic]],
      suppliedMeasurementDelayTime,

    (*If AssayType is not IsothermalStability, set to Null*)
    MatchQ[resolvedAssayType,Except[IsothermalStability]],
      Null,

    (*Otherwise, set to requiredMinimumDelayTime*)
    True,
      requiredMinimumDelayTime
  ];

  (* Resolve IsothermalMeasurements *)

  resolvedIsothermalMeasurements=Which[
    (*If user has supplied IsothermalMeasurements, accept it*)
    MatchQ[suppliedIsothermalMeasurements,Except[Automatic]],
      suppliedIsothermalMeasurements,

    (*If AssayType is not IsothermalStability, set to Null*)
    MatchQ[resolvedAssayType,Except[IsothermalStability]],
      Null,

    (*If IsothermalRunTime is not supplied, set IsothermalMeasurements to 10*)
    MatchQ[suppliedIsothermalRunTime,(Automatic|Null)],
      10,

    (*If IsothermalRunTime is set, IsothermalMeasurements is Null*)
    True,
      Null
  ];

  (*Resolve IsothermalRunTime*)
  resolvedIsothermalRunTime=Which[

    (*If user has supplied IsothermalRunTime, accept it*)
    MatchQ[suppliedIsothermalRunTime,Except[Automatic]],
      suppliedIsothermalRunTime,

    (*If AssayType is not IsothermalStability, set to Null*)
    MatchQ[resolvedAssayType,Except[IsothermalStability]],
      Null,

    (*If IsothermalMeasurements is not Null, set IsothermalRunTime to 10*MeasurementDelayTime*)
    MatchQ[resolvedIsothermalMeasurements,Null],
      RoundOptionPrecision[(10*(resolvedMeasurementDelayTime/.{Null->300})),10^0*Second],

    (*If IsothermalMeasurements is set, IsothermalRunTime is Null*)
    True,
      Null
  ];

  (* --- MELTING CURVE RESOLVER --- *)
  (* Resolve MinTemperature *)
  resolvedMinTemperature=Which[

    (*If user set MinTemperature, accept it*)
    MatchQ[suppliedMinTemperature,Except[Automatic]],
      suppliedMinTemperature,

    (*If we're not in MeltingCurve, MinTemperature is Null*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*If not set, resolve based on Instrument*)
    True,
      Lookup[resolvedInstrumentModelPacket,MinTemperature]
  ];

  (* Resolve MaxTemperature *)
  resolvedMaxTemperature=Which[

    (*If user set MaxTemperature, accept it*)
    MatchQ[suppliedMaxTemperature,Except[Automatic]],
      suppliedMaxTemperature,

    (*If we're not in MeltingCurve, MaxTemperature is Null*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*If not set, resolve based on Instrument*)
    True,
      Lookup[resolvedInstrumentModelPacket,MaxTemperature]
  ];

  (*Resolve TemperatureRampOrder*)
  resolvedTemperatureRampOrder=Which[

    (*If user specified the option, accept it*)
    MatchQ[suppliedTemperatureRampOrder,Except[Automatic]],
      suppliedTemperatureRampOrder,

    (*If AssayType is NOT MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*If not specified, go with {Heating,Cooling}*)
    True,
      {Heating,Cooling}
  ];

  (*Resolve NumberOfCycles*)
  resolvedNumberOfCycles=Which[

    (*If user has set the option, accept it*)
    MatchQ[suppliedNumberOfCycles,Except[Automatic]],
      suppliedNumberOfCycles,

    (*If we're in MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*If user has not set the option, set to 1*)
    True,
      1
  ];

  (*Resolve TemperatureRamping*)
  resolvedTemperatureRamping=Which[

    (*If user has set the option, accept it*)
    MatchQ[suppliedTemperatureRamping,Except[Automatic]],
      suppliedTemperatureRamping,

    (*If we're in MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*If user has not set the option, set TemperatureRamping to Step if NumberOfTemperatureRampSteps or StepHoldTime are set*)
    Or[MatchQ[suppliedNumberOfTemperatureRampSteps,Except[Automatic|Null]],MatchQ[suppliedStepHoldTime,Except[Automatic|Null]]],
      Step,

    (*If neither NumberOfTemperatureRampSteps or StepHoldTime is set, TemperatureRamping is set to Linear*)
    True,
      Linear
  ];

  (*Resolve TemperatureRampRate*)
  resolvedTemperatureRampRate=Which[

    (*If user has set a value, accept it*)
    MatchQ[suppliedTemperatureRampRate,Except[Automatic]],
      suppliedTemperatureRampRate,

    (*If we're NOT in MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*If TemperatureRamping is Step, ramp rate should be max available for instrument*)
    MatchQ[resolvedTemperatureRamping,Step],
      RoundOptionPrecision[
        Lookup[resolvedInstrumentModelPacket,MaxTemperatureRamp],
        10^-4*(Celsius/Second)
      ],

    (*If TemperatureRamping is Linear, if AssayFormFactor is Capillary, set to 1 Celsius/Minute (max available for Uncle)*)
    MatchQ[resolvedAssayFormFactor,Capillary],
      1*(Celsius/Minute),

    (*If Plate, set to 0.25 Celsius/Minute (max recommended for DynaPro*)
    True,
      0.25*(Celsius/Minute)
  ];

  totalReadTime = (numberOfSamples*intNumberOfReplicates)*(3.4*Second);(*todo: redo for dynapro*)
  maxRes = SafeRound[Convert[resolvedTemperatureRampRate,Celsius/Second]*Convert[totalReadTime,Second],0.001];

  (*Resolve TemperatureResolution*)
  resolvedTemperatureResolution=Which[

    (*If user has set a value, accept it*)
    MatchQ[suppliedTemperatureResolution,Except[Automatic]],
      suppliedTemperatureResolution,

    (*If we're NOT in MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*Otherwise, set to max available for instrument*)
    True,
      maxRes
  ];

  (*Resolve NumberOfTemperatureRampSteps*)
  resolvedNumberOfTemperatureRampSteps=Which[

    (*If user has set a value, accept it*)
    MatchQ[suppliedNumberOfTemperatureRampSteps,Except[Automatic]],
      suppliedNumberOfTemperatureRampSteps,

    (*If we're NOT in MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
    Null,

    (*Otherwise, if TemperatureRamping is Step, resolve it based on MaxTemperature, MinTemperature, and TemperatureResolution*)
    MatchQ[resolvedTemperatureRamping,Step],
      IntegerPart[RoundOptionPrecision[(Abs[resolvedMaxTemperature-resolvedMinTemperature]/(1*Celsius)),10^0]],

    (*If TemperatureRamping is Linear, Null it*)
    True,
      Null
  ];

  (*Resolve StepHoldTime*)

  resolvedStepHoldTime=Which[

    (*If user has set a value, accept it*)
    MatchQ[suppliedStepHoldTime,Except[Automatic]],
      suppliedStepHoldTime,

    (*If we're NOT in MeltingCurve, Null it*)
    MatchQ[resolvedAssayType,Except[MeltingCurve]],
      Null,

    (*Otherwise, if TemperatureRamping is Step, resolve it based on MaxTemperature, MinTemperature, and TemperatureResolution*)
    MatchQ[resolvedTemperatureRamping,Step],
      30*Second,

    (*If TemperatureRamping is Linear, Null it*)
    True,
      Null
  ];

  (* Throw Error for ConflictingRampOptions *)
  invalidConflictingRampOptions=Which[

    (*If TemperatureRamping is Step and either NumberOfTemperatureRampSteps or StepHoldTime is Null, throw the Error*)
    (* Note that we need to explicitly specify the AssayType here, because otherwise some of these options will have resolved to Null *)
    MatchQ[resolvedAssayType,MeltingCurve] && MatchQ[resolvedTemperatureRamping,Step]&&Or[MatchQ[resolvedNumberOfTemperatureRampSteps,Null],MatchQ[resolvedStepHoldTime,Null]],
      Message[Error::ConflictingRampOptions,ObjectToString[resolvedTemperatureRamping],ObjectToString[resolvedNumberOfTemperatureRampSteps],ObjectToString[resolvedStepHoldTime]];
      {resolvedTemperatureRamping,resolvedNumberOfTemperatureRampSteps,resolvedStepHoldTime},

    (*If TemperatureRamping is Linear and either NumberOfTemperatureRampSteps or StepHoldTime is NOT Null, throw the Error*)
    MatchQ[resolvedAssayType,MeltingCurve] && MatchQ[resolvedTemperatureRamping,Linear]&&Or[MatchQ[resolvedNumberOfTemperatureRampSteps,Except[Null]],MatchQ[resolvedStepHoldTime,Except[Null]]],
      Message[Error::ConflictingRampOptions,ObjectToString[resolvedTemperatureRamping],ObjectToString[resolvedNumberOfTemperatureRampSteps],ObjectToString[resolvedStepHoldTime]];
      {resolvedTemperatureRamping,resolvedNumberOfTemperatureRampSteps,resolvedStepHoldTime},

    (*Otherwise, do not trigger error*)
    True,
      {}
  ];

  (* Create test for ConflictingRampOptions *)
  conflictingRampOptionsTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[invalidConflictingRampOptions,{}],
        Nothing,
        Test["The resolved TemperatureRamping, "<>ToString[resolvedTemperatureRamping]<>" is in conflict with one or more of NumberOfTemperatureRampSteps, "<>ToString[resolvedNumberOfTemperatureRampSteps]<>", or StepHoldTime, "<>ToString[resolvedStepHoldTime]<>". If TemperatureRamping is Step, both of the latter options must not be Null, and if TemperatureRamping is Linear, both of the latter options must be Null.",True,False]
      ];
      passingTest=If[MatchQ[invalidConflictingRampOptions,{}],
        Test["The TemperatureRamping is not in conflict with either the NumberOfTemperatureRampSteps or StepHoldTime:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Resolve ReplicateDilutionCurve *)
  resolvedReplicateDilutionCurve=Which[

    (*If user has set option, accept it*)
    MatchQ[suppliedReplicateDilutionCurve,Except[Automatic]],
      suppliedReplicateDilutionCurve,

    (*If we're NOT in ColloidalStability, set to Null*)
    MatchQ[resolvedAssayType,Except[ColloidalStability]],
      Null,

    (*If user has not set option, set to False*)
    True,
      False
  ];

  (* Resolve CalculateMolecularWeight and error Boolean *)
  resolvedCalculateMolecularWeight=Which[

    (*If user has set option, accept it*)
    MatchQ[suppliedCalculateMolecularWeight,Except[Automatic]],
      suppliedCalculateMolecularWeight,

    (*If we're NOT in ColloidalStability, set to Null*)
    MatchQ[resolvedAssayType,Except[ColloidalStability]],
      Null,

    (*If user has not set option, set to True if AssayFormFactor is Plate, and False otherwise (Uncle can't do this properly)*)
    MatchQ[resolvedAssayFormFactor,Plate],
      True,
    True,
      False
  ];

  (* --- Resolve Index-Matched options --- *)

  (* -- Get information about the Model[Molecule,Protein]s and Model[Molecule,Polymer]s present in the Composition fields and their associated MassConcentrations -- *)
  (* This whole MapThread is to get the MassConcentration of each Analyte in each Sample's Composition *)
  compositionAnalytesAndMassConcentrations=MapThread[
    Function[{packets,compositionPackets},
      Module[
        {
          sampleComposition,volume,mass,density,volumeToUse,massToUse,
          compositionOnlyAnalytes,analyteCompositionAmounts,analyteCompositionModels,onlyAnalytesCompositionPackets,
          analyteMolecularWeights,analyteMassConcentrations,convertedMassConcentrations
        },

        (* Find the Composition, Volume, Mass, and Density of each input sample *)
        sampleComposition=Lookup[packets,Composition,{}];
        {volume,mass,density}=Lookup[packets,{Volume,Mass,Density},Null];

        (* Make assumptions about the Mass and Volume for calculations below (so that we dont need an enormous Switch Statement) *)
        volumeToUse=Switch[{volume,mass,density},

          (* If Volume isn't Null, just use that, duh *)
          {VolumeP,_,_},
          volume,

          (* If only Mass is known, assume density of 1 g/mL *)
          {Null,MassP,Null},
          (mass/(Gram/Milliliter)),

          (* If we know the Mass and the Density, calculate the Volume *)
          {Null,MassP,DensityP},
          (mass/density),

          (* Only other cases are where we only know the density, or know nothing, either way, Null *)
          {_,_,_},
          Null
        ];

        (* Set the Mass for calculations below *)
        massToUse=Switch[{volume,mass,density},

          (* If Mass isn't Null, just use that, duh *)
          {_,MassP,_},
          mass,

          (* If only the Volume is known, assume density of 1 g/mL *)
          {VolumeP,Null,Null},
          (volume*(Gram/Milliliter)),

          (* If the Volume and Density are both known, do math *)
          {VolumeP,Null,DensityP},
          (volume*density),

          (* In any other case, set to Null *)
          {_,_,_},
          Null
        ];

        (* Get the members of the sampleComposition that are Model[Molecule,Protein]s or Model[Molecule,Polymer]s *)
        compositionOnlyAnalytes=Cases[sampleComposition,{_,ObjectP[{Model[Molecule, Protein] , Model[Molecule, Polymer], Model[Molecule, Oligomer]}]},2];

        (* Get the Amount of each member of compositionOnlyAnalytes (Null,MassPercent,etc)*)
        analyteCompositionAmounts=compositionOnlyAnalytes[[All,1]];
        analyteCompositionModels=Download[compositionOnlyAnalytes[[All,2]],Object];

        (* Get the corresponding members of the sampleCompositionPackets *)
        onlyAnalytesCompositionPackets=PickList[compositionPackets,sampleComposition,{_,ObjectP[{Model[Molecule, Protein] , Model[Molecule, Polymer], Model[Molecule, Oligomer]}]}];

        (* Find the MolecularWeights of the Analytes present in the Composition *)
        analyteMolecularWeights=Lookup[onlyAnalytesCompositionPackets,MolecularWeight,{}];

        (* Using the list of analyteCompositionAmounts and analyteMolecularWeights, find the MassConcentration of each Analyte *)
        analyteMassConcentrations=MapThread[
          Function[{compositionAmounts,molecularWeights},
            Switch[{compositionAmounts,molecularWeights,massToUse},

              (* If the CompositionAmount is a MassConcentration, awesome, return that *)
              {MassConcentrationP,_,_},
              compositionAmounts,

              (* If the massToUse is Null (and thus the volumeToUse is also Null) we cant do any calculations, set to Null *)
              {_,_,Null},
              Null,

              (* If the CompositionAmount is a MassPercent and the Mass and Volume both exist, do math *)
              {MassPercentP,_,Except[Null]},
              ((Unitless[compositionAmounts,Milligram/Milliliter]*0.01*massToUse)/volumeToUse),

              (* If the CompositionAmount is a MassPercent and we dont know the Mass (or Volume), set to Null *)
              {MassPercentP,_,_},
              Null,

              (* If the CompositionAmount is a VolumePercent and the Volume is known, do math *)
              {VolumePercentP,_,Except[Null]},
              ((massToUse*Unitless[compositionAmounts,VolumePercent]*0.01)/volumeToUse),

              (* If the CompositionAmount is a VolumePercent and the Volume is unknown, set to Null *)
              {VolumePercentP,_,_},
              Null,

              (* If the CompositionAmount is a Concentration, we need to know the AnalyteMolecularWeight *)
              {ConcentrationP,Null,_},
              Null,

              (* If we know the AnalyteMolecularWeight, do the math *)
              {ConcentrationP,_,_},
              (compositionAmounts*molecularWeights),

              (* All other cases (just PercentConfluency), return Null *)
              {_,_,_},
              Null
            ]
          ],
          {analyteCompositionAmounts,analyteMolecularWeights}
        ];

        (* Convert the calculated MassConcentrations to mg/mL *)
        convertedMassConcentrations=Map[
          If[
            MatchQ[#,Null],
            #,
            Convert[#,(Milligram/Milliliter)]
          ]&,
          analyteMassConcentrations
        ];

        (* Return a list of lists with the inner lists being {MassConcentration,AnalyteModel} *)
        Transpose[{convertedMassConcentrations,analyteCompositionModels}]
      ]
    ],
    {samplePackets,sampleCompositionPackets}
  ];

  (* Convert our options into a MapThread friendly version. so we can do our big MapThread *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentDynamicLightScattering,roundedExperimentOptions];

  (* Lookup the Solvent from each sample *)
  inputSolventFields=Download[Lookup[samplePackets,Solvent],Object];

  (* -- Big MapThread -- *)
  {
    (*1*)resolvedAnalyte,
    (*2*)resolvedAnalyteMassConcentration,
    (*3*)resolvedStandardDilutionCurve,
    (*4*)resolvedSerialDilutionCurve,
    (*5*)resolvedBuffer,
    (*6*)resolvedDilutionMixType,
    (*7*)resolvedDilutionMixVolume,
    (*8*)resolvedDilutionNumberOfMixes,
    (*9*)resolvedDilutionMixRate,
    (*10*)resolvedDilutionMixInstrument,
    (*11*)resolvedBlankBuffer,
    (*12*)bufferNotSpecifiedWarnings,
    (*13*)conflictingDilutionMixOptionsErrors,
    (*14*)conflictingDilutionMixTypeOptionsErrors,
    (*15*)conflictingDilutionCurveErrors,
    (*16*)conflictingDilutionMixTypeInstrumentErrors,
    (*17*)bufferAndBlankBufferDifferWarnings,
    (*18*)noAnalyteErrors,
    (*19*)noAnalyteMassConcentrationErrors
  }=Transpose[MapThread[
    Function[{options,inputSolventField,compositionMoleculeAnalyteAndConcentrations},
      Module[
        {
          initialStandardDilutionCurve,initialSerialDilutionCurve,initialBuffer,initialDilutionMixType,initialDilutionMixVolume,initialDilutionNumberOfMixes,
          initialDilutionMixRate,initialDilutionMixInstrument,initialBlankBuffer,initialAnalyte,initialAnalyteMassConcentration,
          bufferNotSpecifiedWarning,conflictingDilutionMixOptionsError, conflictingDilutionCurveError,noAnalyteError,
          noAnalyteMassConcentrationError,analyte,analyteMassConcentration,standardDilutionCurve,serialDilutionCurve,sampleSolvent,
          buffer,dilutionMixType,dilutionMixVolume,dilutionNumberOfMixes,dilutionMixRate,dilutionMixInstrument,blankBuffer,conflictingDilutionMixTypeInstrumentError,
          conflictingDilutionMixTypeOptionsError,bufferAndBlankBufferDifferWarning,concentrationlessAnalytes,analytesWithConcentrations,
          maxConcentration
        },

        (* Set up the error tracking variables *)
        {
          bufferNotSpecifiedWarning,conflictingDilutionMixOptionsError,conflictingDilutionCurveError,noAnalyteError,
          noAnalyteMassConcentrationError,conflictingDilutionMixTypeInstrumentError,conflictingDilutionMixTypeOptionsError,bufferAndBlankBufferDifferWarning
        }=ConstantArray[False,8];

        (* Lookup the initial value of each option for this index *)
        {
          initialStandardDilutionCurve,initialSerialDilutionCurve,initialBuffer,initialDilutionMixType,initialDilutionMixVolume,initialDilutionNumberOfMixes,
          initialDilutionMixRate,initialDilutionMixInstrument,initialBlankBuffer,initialAnalyte,initialAnalyteMassConcentration
        }=Lookup[options,
          {
            StandardDilutionCurve,SerialDilutionCurve,Buffer,DilutionMixType,DilutionMixVolume,DilutionNumberOfMixes,DilutionMixRate,DilutionMixInstrument,BlankBuffer,Analyte,
            AnalyteMassConcentration
          }
        ];

        (* -- Resolve the options -- *)
        (* - Analyte - *)
        (* Find the members of compositionMoleculeAnalyteandConcentrations that have no associated Concentration *)
        concentrationlessAnalytes=Cases[compositionMoleculeAnalyteAndConcentrations,{Null,_}];

        (* Find the members of compositionMoleculeAnalyteAndConcentrations that do have Concentrations *)
        analytesWithConcentrations=Cases[compositionMoleculeAnalyteAndConcentrations,Except[Alternatives@@concentrationlessAnalytes]];

        analyte=Which[
          (* If the user has specified the Analyte, we accept it *)
          Not[MatchQ[initialAnalyte,Automatic]],
            initialAnalyte,

          (* Otherwise, we resolve based on the AssayType *)
          (* If the AssayType is SizingPolydispersity or IsothermalStability, resolve to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If the AssayType is ColloidalStability, we try to find the Model[Molecule,Protein] or Model[Molecule,Polymer] or Model[Molecule,Oligomer] that makes the most sense *)
          (* If there are any analytesWithConcentrations, choose the most concentrated Analyte *)
          Not[MatchQ[analytesWithConcentrations,{}]],
            LastOrDefault[LastOrDefault[Sort[analytesWithConcentrations]]],

          (* If there are no analytesWithConcentrations, but there are concentrationlessAnalytes, choose the first one *)
          Not[MatchQ[concentrationlessAnalytes,{}]],
            LastOrDefault[FirstOrDefault[concentrationlessAnalytes]],

          (* Otherwise, return Null *)
          True,
            Null
        ];

        (* Set the noAnalyteError boolean *)
        noAnalyteError=MatchQ[resolvedAssayType,ColloidalStability]&&Not[NullQ[initialAnalyte]]&&NullQ[analyte];

        (* - AnalyteMassConcentration - *)
        analyteMassConcentration=Switch[{initialAnalyteMassConcentration,analyte,resolvedAssayType},

          (* If the user has specified the AnalyteMassConcentration, we accept it *)
          {Except[Automatic],_,_},
            initialAnalyteMassConcentration,

          (* Otherwise, we resolve based on the AssayType *)
          (* If the AssayType is SizingPolydispersity or IsothermalStability, resolve to Null *)
          {_,_,Except[ColloidalStability]},
            Null,

          (* If the Analyte is Null, we set the AnalyteMassConcentration to Null *)
          {_,Null,_},
            Null,

          (* In all other cases, we try to find the concentration that makes the most sense *)
          {_,_,_},
            Module[
              {
                concentrationlessAnalytes,analytesWithConcentrations,analyteTuples,
                analyteConcentrations,chosenConcentration
              },

              (* Find the members of compositionMoleculeAnalyteandConcentrations that have no associated Concentration *)
              concentrationlessAnalytes=Cases[compositionMoleculeAnalyteAndConcentrations,{Null,_}];

              (* Find the members of compositionMoleculeAnalyteAndConcentrations that do have Concentrations *)
              analytesWithConcentrations=Cases[compositionMoleculeAnalyteAndConcentrations,Except[Alternatives@@concentrationlessAnalytes]];

              (* Find members of analytesWithConcentrations that include the Analyte *)
              analyteTuples=Cases[analytesWithConcentrations,{_,ObjectP[analyte]}];

              (* Get the list of concentrations from the analyteTuples *)
              analyteConcentrations=FirstOrDefault[#]&/@analyteTuples;

              (* Add up the Concentrations, or return Null, depending on the situation *)
              chosenConcentration=If[

                (* IF the analyteConcentrations is {} or a list of Nulls *)
                MatchQ[analyteConcentrations,Alternatives[{},{Null..}]],

                (* THEN we set the concentration to Null *)
                Null,

                (* ELSE, sum the concentrations, replacing Null with 0*Milligram/Milliliter *)
                SafeRound[Total[ReplaceAll[analyteConcentrations, {Null -> 0*Milligram/Milliliter}]],10^-2*Milligram/Milliliter]
              ];

              (* Return the concentration *)
              chosenConcentration
            ]
        ];

        (* Set the noAnalyteMassConcentrationError boolean *)
        noAnalyteMassConcentrationError=MatchQ[resolvedAssayType,ColloidalStability]&&Not[NullQ[analyte]]&&Not[NullQ[initialAnalyteMassConcentration]]&&NullQ[analyteMassConcentration];

        (* For our dilution curves, we don't want to try to specify a higher concentration than is already present in the analyte. *)
        (* So we'll make our "max concentration" equal to the analyte concentration or 10 mg/mL, whichever is lower *)
        maxConcentration = If[GreaterEqualQ[analyteMassConcentration, 10 Milligram/Milliliter],
          10 Milligram/Milliliter,
          analyteMassConcentration
        ];

        (* - StandardDilutionCurve - *)
        standardDilutionCurve=Which[

          (* If the user has specified the StandardDilutionCurve, we accept it, and do error checking later (and/or earlier) *)
          Not[MatchQ[initialStandardDilutionCurve,Automatic]],
            initialStandardDilutionCurve,

          (* - If the user has not specified the StandardDilutionCurve, we resolve it - *)
          (* If the AssayType is SizingPolydispersity or IsothermalStability, we resolve the StandardDilutionCurve to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If the SerialDilutionCurve was specified, we resolve the StandardDilutionCurve to Null *)
          Not[MatchQ[initialSerialDilutionCurve,Null|Automatic]],
            Null,

          (* If the maxConcentration here is Null, we need to manually Null out of here *)
          NullQ[maxConcentration],
            Null,

          (* If the SerialDilutionCurve is not specified, we resolve based on the ReplicateDilutionCurve  *)
          (* Aiming for a dilution that is over a 5-fold range of concentrations, with 5 data points *)
          (* When ReplicateDilutionCurve is False and AssayFormFactor is Capillary, we aim for 45 uL a well *)
          MatchQ[resolvedReplicateDilutionCurve,False]&&MatchQ[resolvedAssayFormFactor,Capillary],
          {
            {15 * Microliter * resolvedNumberOfReplicates, 1.0 * maxConcentration},
            {15 * Microliter * resolvedNumberOfReplicates, 0.8 * maxConcentration},
            {15 * Microliter * resolvedNumberOfReplicates, 0.6 * maxConcentration},
            {15 * Microliter * resolvedNumberOfReplicates, 0.4 * maxConcentration},
            {15 * Microliter * resolvedNumberOfReplicates, 0.2 * maxConcentration}
          },

          (* When ReplicateDilutionCurve is True (or Null) and AssayFormFactor is Capillary, we aim for 15 uL a well *)
          MatchQ[resolvedAssayFormFactor,Capillary],
          {
            {15 * Microliter, 1.0 * maxConcentration},
            {15 * Microliter, 0.8 * maxConcentration},
            {15 * Microliter, 0.6 * maxConcentration},
            {15 * Microliter, 0.4 * maxConcentration},
            {15 * Microliter, 0.2 * maxConcentration}
          },

          (* When ReplicateDilutionCurve is False and AssayFormFactor is Plate, we aim for 90 uL a well *)
          MatchQ[resolvedReplicateDilutionCurve,False]&&MatchQ[resolvedAssayFormFactor,Plate],
          {
            {30 * Microliter * resolvedNumberOfReplicates, 1.0 * maxConcentration},
            {30 * Microliter * resolvedNumberOfReplicates, 0.8 * maxConcentration},
            {30 * Microliter * resolvedNumberOfReplicates, 0.6 * maxConcentration},
            {30 * Microliter * resolvedNumberOfReplicates, 0.4 * maxConcentration},
            {30 * Microliter * resolvedNumberOfReplicates, 0.2 * maxConcentration}
          },

          (* When ReplicateDilutionCurve is True (or Null) and AssayFormFactor is Capillary, we aim for 30 uL a well *)
          True,
          {
            {30 * Microliter, 1.0 * maxConcentration},
            {30 * Microliter, 0.8 * maxConcentration},
            {30 * Microliter, 0.6 * maxConcentration},
            {30 * Microliter, 0.4 * maxConcentration},
            {30 * Microliter, 0.2 * maxConcentration}
          }
        ];

        (* - SerialDilutionCurve - *)
        serialDilutionCurve=Which[

          (* If the user has specified the SerialDilutionCurve, we accept it, and do error checking later (and/or earlier) *)
          Not[MatchQ[initialSerialDilutionCurve,Automatic]],
          initialSerialDilutionCurve,

          (* - If the user has not specified the SerialDilutionCurve, we resolve it - *)
          (* If the AssayType is SizingPolydispersity or IsothermalStability, we resolve the SerialDilutionCurve to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If the StandardDilutionCurve was specified, we resolve the SerialDilutionCurve to Null *)
          Not[MatchQ[standardDilutionCurve,Null]],
            Null,

          (* If the DilutionCurve is Null, we resolve based on the ReplicateDilutionCurve  *)
          (* Aiming for a dilution that is over a 5-fold range of concentrations, with 5 data points (so 4 dilutions)  *)
          (* When ReplicateDilutionCurve is False and AssayFormFactor is Capillary, we aim for 45 uL per well *)
          MatchQ[resolvedReplicateDilutionCurve,False]&&MatchQ[resolvedAssayFormFactor,Capillary],
            {
              (15*resolvedNumberOfReplicates)*Microliter,
              {1, 1.25, 1.333, 1.5, 2},
              1
            },

          (* When ReplicateDilutionCurve is True (or Null), we aim for 15 uL per well *)
          MatchQ[resolvedAssayFormFactor,Capillary],
            {
              15*Microliter,
                {1, 1.25, 1.333, 1.5, 2},
                1
            },

          (* When ReplicateDilutionCurve is False and AssayFormFactor is Capillary, we aim for 90 uL per well *)
          MatchQ[resolvedReplicateDilutionCurve,False]&&MatchQ[resolvedAssayFormFactor,Plate],
            {
              (30*resolvedNumberOfReplicates)*Microliter,
                {1, 1.25, 1.333, 1.5, 2},
                1
            },

          (* When ReplicateDilutionCurve is True (or Null), we aim for 30 uL per well *)
          True,
            {
              30*Microliter,
                {1, 1.25, 1.333, 1.5, 2},
                1
            }
        ];

        (* Set the conflictingDilutionCurveError *)
        conflictingDilutionCurveError=Switch[{resolvedAssayType,standardDilutionCurve,serialDilutionCurve},

          (* If the AssayType is SizingPolydispersity or IsothermalStability, these can't be in conflict with each other *)
          {Except[ColloidalStability],_,_},
            False,

          (* If the options have both resolved to Null or both resolved to non-Null values, they are in conflict *)
          {_,Null,Null},
            True,
          {_,Except[Null],Except[Null]},
            True,

          (* In all other cases when one is specified and the other is Null, they are not in conflict *)
          {_,_,_},
            False
        ];

        (* - Buffer - *)
        (* Resolve the Buffer *)
        {buffer,bufferNotSpecifiedWarning}=Switch[{initialBuffer,resolvedAssayType,inputSolventField},

          (* If the user has specified the Buffer, we accept it (and rejoice) *)
          {Except[Automatic],_,_},
            {initialBuffer,False},

          (* If the user has not specified the Buffer, we resolve based on the AssayType and the sampleSolvent *)
          {Automatic,Except[ColloidalStability],_},
            {Null,False},

          (* If we are in ColloidalStability, and there are no Model[Sample]s in the Solvent field, default to water *)
          {Automatic,_,Null},
            {Model[Sample, "id:8qZ1VWNmdLBD"](*"Milli-Q water"*),True},

          (* If there is an acceptable Model[Sample] in the Solvent field, we pick the sampleSolvent, and do not set the Warning *)
          {Automatic,_,_},
            {inputSolventField,False}
        ];

        (* - DilutionMixType - *)
        dilutionMixType=Which[

          (* If the user has specified the DilutionMixType, we accept it, and will do error checking after *)
          Not[MatchQ[initialDilutionMixType,Automatic]],
            initialDilutionMixType,

          (* If the AssayType is SizingPolydiserpsity, IsothermalStability, or MeltingCurve, we resolve the DilutionMixType to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If the dilutionMixInstrument is specified, we resolve the DilutionMixType based on it *)
          MatchQ[initialDilutionMixInstrument,ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}]],
            Pipette,
          MatchQ[initialDilutionMixInstrument,ObjectP[{Model[Instrument,Vortex],Object[Instrument,Vortex]}]],
            Vortex,
          MatchQ[initialDilutionMixInstrument,ObjectP[{Model[Instrument,Nutator],Object[Instrument,Nutator]}]],
            Nutator,

          (* If any of DilutionMixVolume, DilutionNumberOfMixes, or DilutionMixRate is Null, DilutionMixType is set to Vortex; otherwise, set to Pipette *)
          NullQ[initialDilutionMixVolume],
            Vortex,
          NullQ[initialDilutionNumberOfMixes],
            Vortex,
          NullQ[initialDilutionMixRate],
            Vortex,
          True,
            Pipette
        ];

        (* - DilutionMixVolume - *)
        dilutionMixVolume=Which[

          (* If the user has specified the DilutionMixVolume, we accept it, and will do error checking after *)
          Not[MatchQ[initialDilutionMixVolume,Automatic]],
            initialDilutionMixVolume,

          (* If the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, we resolve the DilutionMixVolume to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If dilutionMixType is not Pipette, we resolve to Null *)
          Not[MatchQ[dilutionMixType,Pipette]],
            Null,

          (* If the DilutionNumberOfMixes and DilutionMixRate are both Null, we resolve to Null *)
          NullQ[initialDilutionNumberOfMixes]&&NullQ[initialDilutionMixRate],
            Null,

          (* Otherwise, we resolve based on the resolvedReplicateDilutionCurve *)
          (* If the resolvedReplicateDilutionCurve is False, we resolve to 15 uL *)
          MatchQ[resolvedReplicateDilutionCurve,False],
            15*Microliter,

          (* If the resolvedReplicateDilutionCurve is True (or Null), we resolve to 7 uL *)
          True,
            7*Microliter
        ];

        (* - DilutionNumberOfMixes - *)
        dilutionNumberOfMixes=Which[

          (* If the user has specified the DilutionNumberOfMixes, we accept it, and will do error checking after *)
          Not[MatchQ[initialDilutionNumberOfMixes,Automatic]],
            initialDilutionNumberOfMixes,

          (* If the AssayType is SizingPolydispersity or IsothermalStability, we resolve the DilutionMixVolume to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If dilutionMixType is not Pipette, we resolve to Null *)
          Not[MatchQ[dilutionMixType,Pipette]],
            Null,

          (* If the DilutionMixVolume is not Null, resolve to 5 *)
          Not[NullQ[dilutionMixVolume]],
            5,

          (* Otherwise, if the DilutionMixVolume is Null, resolve to Null *)
          True,
            Null
        ];

        (* - DilutionMixRate - *)
        dilutionMixRate=Which[

          (* If the user has specified the DilutionMixRate, we accept it, and will do error checking after *)
          Not[MatchQ[initialDilutionMixRate,Automatic]],
            initialDilutionMixRate,

          (* If the AssayType is SizingPolydispersity or IsothermalStability, we resolve the DilutionMixRate to Null *)
          Not[MatchQ[resolvedAssayType,ColloidalStability]],
            Null,

          (* If dilutionMixType is not Pipette, we resolve to Null *)
          Not[MatchQ[dilutionMixType,Pipette]],
            Null,

          (* If the DilutionMixVolume is not Null, resolve to 30 uL/s *)
          Not[NullQ[dilutionMixVolume]],
            30*Microliter/Second,

          (* Otherwise, if the DilutionMixVolume is Null, resolve to Null *)
          True,
            Null
        ];

        (* - DilutionMixInstrument - *)
        dilutionMixInstrument=Switch[{initialDilutionMixInstrument,resolvedAssayType,dilutionMixType},

          (* If the user has specified the DilutionMixInstrument, we accept it, and will do error checking after *)
          {Except[Automatic],_,_},
            initialDilutionMixInstrument,

          (* If the AssayType is not ColloidalStability, we resolve DilutionMixInstrument to Null *)
          {Automatic,Except[ColloidalStability],_},
            Null,

          (* Otherwise, we resolve based on dilutionMixType *)
          {Automatic,ColloidalStability,Pipette},
            Model[Instrument,Pipette,"id:1ZA60vL547EM"],(*"Eppendorf Research Plus P1000"*)
          {Automatic,ColloidalStability,Vortex},
            Model[Instrument,Vortex,"id:dORYzZn0o45q"],(*"Microplate Genie"*)
          {Automatic,ColloidalStability,Nutator},
            Model[Instrument,Nutator,"id:1ZA60vLBzwGq"](*"Fisherbrand Nutating Mixer with Precision Low Temperature BOD Refrigerated Incubator"*)
        ];

        (* - Set the ConflictingDilutionMixTypeOptionsError boolean - *)
        conflictingDilutionMixTypeOptionsError=Switch[{dilutionMixType,dilutionMixVolume,dilutionNumberOfMixes,dilutionMixRate},

          (* If the DilutionMixType is Pipette and none of these are Null, they are not in conflict *)
          {Pipette,Except[Null],Except[Null],Except[Null]},
            False,

          (* If the DilutionMixType is not Pipette and all of the others are Null, they are not in conflict *)
          {Except[Pipette],Null,Null,Null},
            False,

          (* In all other cases, they are in conflict *)
          {_,_,_,_},
            True
        ];

        (* - Set the ConflictingDilutionMixTypeInstrumentError boolean - *)
        conflictingDilutionMixTypeInstrumentError=Switch[{dilutionMixType,dilutionMixInstrument},

          (* If both the DilutionMixType and DilutionMixInstrument are Null, they are not in conflict *)
          {Null,Null},
            False,

          (* If the DilutionMixType matches the DilutionMixInstrument, they are not in conflict *)
          {Pipette,ObjectP[Model[Instrument,Pipette]]|ObjectP[Object[Instrument,Pipette]]},
            False,
          {Vortex,ObjectP[Model[Instrument,Vortex]]|ObjectP[Object[Instrument,Vortex]]},
            False,
          {Nutator,ObjectP[Model[Instrument,Nutator]]|ObjectP[Object[Instrument,Nutator]]},
            False,

          (* Otherwise, they are in conflict *)
          {_,_},
            True
        ];

        (* - Set the DilutionMixMismatchError boolean - *)
        conflictingDilutionMixOptionsError=Switch[{resolvedAssayType,dilutionMixVolume,dilutionNumberOfMixes,dilutionMixRate},

          (* If the AssayType is SizingPolydispersity or IsothermalStability, these can't be in conflict with eachother *)
          {Except[ColloidalStability],_,_,_},
            False,

          (* If the options have all resolved to Null or all resolved to non-Null values, they are not in conflict *)
          {_,Null,Null,Null},
            False,
          {_,Except[Null],Except[Null],Except[Null]},
            False,

          (* In all other cases (when some are Null and some are specified), they are in conflict *)
          {_,_,_,_},
            True
        ];

        (* - BlankBuffer - *)
        blankBuffer=Switch[{initialBlankBuffer,resolvedAssayType},

          (* If the user has specified the BlankBuffer, we accept it *)
          {Except[Automatic],_},
            initialBlankBuffer,

          (* If the user has not specified the BlankBuffer, we resolve it based on the AssayType *)
          {Automatic,dilutionAssayTypeP},
            buffer,
          {Automatic,_},
            Null
        ];

        (* Trigger BufferAndBlankBufferDifferWarning Boolean if they do not match*)
        bufferAndBlankBufferDifferWarning=Not[MatchQ[buffer,blankBuffer]];



        (* -- Return the MapThread variables in order -- *)
        {
          (*1*)analyte,
          (*2*)analyteMassConcentration,
          (*3*)standardDilutionCurve,
          (*4*)serialDilutionCurve,
          (*5*)buffer,
          (*6*)dilutionMixType,
          (*7*)dilutionMixVolume,
          (*8*)dilutionNumberOfMixes,
          (*9*)dilutionMixRate,
          (*10*)dilutionMixInstrument,
          (*11*)blankBuffer,
          (*12*)bufferNotSpecifiedWarning,
          (*13*)conflictingDilutionMixOptionsError,
          (*14*)conflictingDilutionMixTypeOptionsError,
          (*15*)conflictingDilutionCurveError,
          (*16*)conflictingDilutionMixTypeInstrumentError,
          (*17*)bufferAndBlankBufferDifferWarning,
          (*18*)noAnalyteError,
          (*19*)noAnalyteMassConcentrationError
        }
      ]
    ],
    {mapThreadFriendlyOptions,inputSolventFields,compositionAnalytesAndMassConcentrations}
  ]];

  (* Resolve SamplesInStorageCondition *)
  resolvedSamplesInStorageConditions=MapThread[
    Function[{suppliedSISC,sampleIn},
      Which[
        (* If user supplied SISC, take it *)
        !MatchQ[suppliedSISC,Automatic],
          suppliedSISC,

        (* If the sample has no storage condition yet, we'll do Disposal *)
        NullQ[fastAssocLookup[fastAssoc,sampleIn,StorageCondition]],
          Disposal,

          (* If not, go with the preexisting SC for sample, strip it of its link, and download the symbol *)
        True,
          Download[First[fastAssocLookup[fastAssoc,sampleIn,StorageCondition]],StorageCondition]
      ]
    ],
    {suppliedSamplesInStorageCondition,mySamples}
  ];

  (* Quickly peek at the pre-existing storage conditions for all the SamplesIn *)
  preexistingSamplesStorageConditions=FirstOrDefault[fastAssocLookup[fastAssoc,#,StorageCondition],Null]&/@mySamples;

  (* Resolve SamplesOutStorageCondition *)
  resolvedSamplesOutStorageCondition=Which[

    (* If user supplied SOSC, take it *)
    !MatchQ[suppliedSamplesOutStorageCondition,Automatic],
      suppliedSamplesOutStorageCondition,

    (* If we're doing capillary, we'll get rid of it *)
    MatchQ[resolvedAssayFormFactor,Capillary],
      Disposal,

    (* If we're in plate, we'll quickly look for clues from our preexisting sample SCs, but only if they all have the same SC - otherwise, dispose *)
    !NullQ[preexistingSamplesStorageConditions] && Length[Union[preexistingSamplesStorageConditions]]==1,
      Download[First[preexistingSamplesStorageConditions],StorageCondition],
    !NullQ[preexistingSamplesStorageConditions],
      Disposal,

    (* If we have no clues, we will store ambiently *)
    True,
      AmbientStorage

  ];

  (* === UNRESOLVABLE OPTION CHECKS === *)
  (* - Throw Error for conflictingDilutionMixOptionsErrors - *)
	(* First, determine if we need to throw this Error *)
  conflictingDilutionMixOptionsErrorQ=MemberQ[conflictingDilutionMixOptionsErrors,True];

	(* Create lists of the input samples that have the conflictingDilutionMixOptionsError set to True and to False *)
	failingDilutionMixSamples=PickList[simulatedSamples,conflictingDilutionMixOptionsErrors,True];
  passingDilutionMixSamples=PickList[simulatedSamples,conflictingDilutionMixOptionsErrors,False];

  (* Create a list of lists index-matched to the simulated samples of form {{dilutionMixVolume,dilutionMixRate,dilutionNumberOfMixes}..} *)
  resolvedDilutionOptionsPerSample=Transpose[{resolvedDilutionMixVolume,resolvedDilutionMixRate,resolvedDilutionNumberOfMixes}];

	(* Create lists of the Dilution Mix Options that are failing (for Error message and Tests) *)
  failingDilutionMixOptionValues=PickList[resolvedDilutionOptionsPerSample,conflictingDilutionMixOptionsErrors,True];

  (* Define the invalid option variable *)
  invalidConflictingDilutionMixOptions=If[conflictingDilutionMixOptionsErrorQ,
    {DilutionMixVolume,DilutionMixRate,DilutionNumberOfMixes},
    {}
  ];

	(* Throw an Error if we are throwing messages, and there are some input samples that caused conflictingDilutionMixOptionsErrors to be set to True *)
	If[conflictingDilutionMixOptionsErrorQ&&messages,
		Message[Error::ConflictingDLSDilutionMixOptions,ObjectToString[failingDilutionMixSamples,Cache->cacheBall],ObjectToString[failingDilutionMixOptionValues]]
	];

	(* Define the tests the user will see for the above message *)
	conflictingDilutionMixTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[conflictingDilutionMixOptionsErrorQ,
				Test["The following samples, "<>ObjectToString[failingDilutionMixSamples,Cache->cacheBall]<>", have DilutionMixVolume, DilutionMixRate, and DilutionNumberOfMixes options, "<>ToString[failingDilutionMixOptionValues]<>", which are in conflict with each other. For any given sample, if any of the options are Null, they all must be Null. If any of the options are specified as non-Null values, they all must be non-Null:",True,False],
				Nothing
			];
			passingTest=If[Length[passingDilutionMixSamples]>0,
				Test["The following samples have dilution mix-related options which are not in conflict, "<>ObjectToString[passingDilutionMixSamples,Cache->cacheBall]<>":",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

  (* - Throw Error for conflictingDilutionMixOptionsErrors - *)
  (* First, determine if we need to throw this Error *)
  conflictingDilutionMixTypeOptionsErrorQ=MemberQ[conflictingDilutionMixTypeOptionsErrors,True];

  (* Create lists of the input samples that have the conflictingDilutionMixOptionsError set to True and to False *)
  failingDilutionMixTypeOptionsSamples=PickList[simulatedSamples,conflictingDilutionMixTypeOptionsErrors,True];
  passingDilutionMixTypeOptionsSamples=PickList[simulatedSamples,conflictingDilutionMixTypeOptionsErrors,False];

  (* Create a list of lists index-matched to the simulated samples of form {{dilutionMixVolume,dilutionMixRate,dilutionNumberOfMixes}..} *)
  resolvedDilutionTypeOptionsPerSample=Transpose[{resolvedDilutionMixType,resolvedDilutionMixVolume,resolvedDilutionMixRate,resolvedDilutionNumberOfMixes}];

  (* Create lists of the Dilution Mix Options that are failing (for Error message and Tests) *)
  failingDilutionMixTypeOptionsValues=PickList[resolvedDilutionTypeOptionsPerSample,conflictingDilutionMixTypeOptionsErrors,True];

  (* Define the invalid option variable *)
  invalidConflictingDilutionMixTypeOptions=If[conflictingDilutionMixTypeOptionsErrorQ,
    {DilutionMixType,DilutionMixVolume,DilutionMixRate,DilutionNumberOfMixes},
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused conflictingDilutionMixOptionsErrors to be set to True *)
  If[conflictingDilutionMixTypeOptionsErrorQ&&messages,
    Message[Error::ConflictingDLSDilutionMixTypeOptions,ObjectToString[failingDilutionMixTypeOptionsSamples,Cache->cacheBall],ObjectToString[failingDilutionMixTypeOptionsValues]]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingDilutionMixTypeOptionsTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[conflictingDilutionMixTypeOptionsErrorQ,
        Test["The following samples, "<>ObjectToString[failingDilutionMixTypeOptionsSamples,Cache->cacheBall]<>", have DilutionMixType, DilutionMixVolume, DilutionMixRate, and DilutionNumberOfMixes options, "<>ToString[failingDilutionMixTypeOptionsValues]<>", which are in conflict with each other. For any given sample, if DilutionMixType is Pipette, the other options must be Null. If any of the other options are specified as non-Null values, the DilutionMixType must be Pipette:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingDilutionMixTypeOptionsSamples]>0,
        Test["The following samples have DilutionMixType and other dilution mix-related options which are not in conflict, "<>ObjectToString[passingDilutionMixTypeOptionsSamples,Cache->cacheBall]<>":",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw Error for conflictingDilutionMixInstrumentErrors - *)
  (* First, determine if we need to throw this Error *)
  conflictingDilutionMixTypeInstrumentErrorQ=MemberQ[conflictingDilutionMixTypeInstrumentErrors,True];

  (* Create lists of the input samples that have the conflictingDilutionMixInstrumentError set to True and to False *)
  failingDilutionMixTypeInstrumentSamples=PickList[simulatedSamples,conflictingDilutionMixTypeInstrumentErrors,True];
  passingDilutionMixTypeInstrumentSamples=PickList[simulatedSamples,conflictingDilutionMixTypeInstrumentErrors,False];

  (* Create a list of lists index-matched to the simulated samples of form {{dilutionMixVolume,dilutionMixRate,dilutionNumberOfMixes}..} *)
  resolvedDilutionTypeInstrumentPerSample=Transpose[{resolvedDilutionMixType,resolvedDilutionMixVolume,resolvedDilutionMixRate,resolvedDilutionNumberOfMixes}];

  (* Create lists of the Dilution Mix Type and Instrument that are failing (for Error message and Tests) *)
  failingDilutionMixTypeInstrumentValues=PickList[resolvedDilutionTypeInstrumentPerSample,conflictingDilutionMixTypeInstrumentErrors,True];

  (* Define the invalid option variable *)
  invalidConflictingDilutionMixTypeInstrument=If[conflictingDilutionMixTypeInstrumentErrorQ,
    {DilutionMixType,DilutionMixInstrument},
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused conflictingDilutionMixInstrumentErrors to be set to True *)
  If[conflictingDilutionMixTypeInstrumentErrorQ&&messages,
    Message[Error::ConflictingDLSDilutionMixTypeInstrument,ObjectToString[failingDilutionMixTypeInstrumentSamples,Cache->cacheBall],ObjectToString[conflictingDilutionMixTypeInstrumentErrors]]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingDilutionMixTypeInstrumentTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[conflictingDilutionMixTypeInstrumentErrorQ,
        Test["The following samples, "<>ObjectToString[failingDilutionMixTypeInstrumentSamples,Cache->cacheBall]<>", have DilutionMixType and DilutionMixInstrument options, "<>ToString[failingDilutionMixTypeInstrumentValues]<>", which are in conflict with each other. For any given sample, DilutionMixType must match the subtype of the Model[Instrument] or Object[Instrument] of DilutionMixInstrument:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingDilutionMixTypeInstrumentSamples]>0,
        Test["The following samples have DilutionMixType and DilutionMixInstrument which are not in conflict, "<>ObjectToString[passingDilutionMixTypeInstrumentSamples,Cache->cacheBall]<>":",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw a Warning for bufferNotSpecifiedWarnings - *)
  (* First, determine if we need to throw this Warning *)
  bufferNotSpecifiedWarningQ=MemberQ[bufferNotSpecifiedWarnings,True];

  (* Create lists of the input samples that have the bufferNotSpecifiedWarning set to True and to False *)
  failingBufferSpecifiedSamples=PickList[simulatedSamples,bufferNotSpecifiedWarnings,True];
  passingBufferSpecifiedSamples=PickList[simulatedSamples,bufferNotSpecifiedWarnings,False];

  (* Create a list of the resolved Buffers for the failing samples *)
  unspecifiedBuffers=PickList[resolvedBuffer,bufferNotSpecifiedWarnings,True];

  (* Throw a Warning if we are throwing messages, and there are some input samples that caused bufferNotSpecifiedWarnings to be set to True *)
  If[bufferNotSpecifiedWarningQ&&messages&&notInEngine,
    Message[Warning::DLSBufferNotSpecified,ObjectToString[failingBufferSpecifiedSamples,Cache->cacheBall],ObjectToString[unspecifiedBuffers,Cache->cacheBall]]
  ];

  (* Define the tests the user will see for the above message *)
  bufferNotSpecifiedTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[bufferNotSpecifiedWarningQ,
        Warning["The Buffer is not specified for the following samples, "<>ObjectToString[failingBufferSpecifiedSamples,Cache->cacheBall]<>". The Buffer for these samples has been set to "<>ToString[unspecifiedBuffers]<>". For ColloidalStability assays, it is essential that the Buffer and BlankBuffer options are the same as the input sample's buffer. Please specify the Buffer option for the most accurate experimental results:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingBufferSpecifiedSamples]>0,
        Warning["For the following samples, "<>ObjectToString[passingBufferSpecifiedSamples,Cache->cacheBall]<>", the Buffer option was specified, or the AssayType is SizingPolydispersity or IsothermalStability:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error for the conflictingDilutionCurveErrors - *)
  (* First, determine if we need to throw this Error *)
  conflictingDilutionCurveErrorQ=MemberQ[conflictingDilutionCurveErrors,True];

  (* Create lists of the input samples that have the conflictingDilutionCurveError set to True and to False *)
  failingConflictingDilutionCurveSamples=PickList[simulatedSamples,conflictingDilutionCurveErrors,True];
  passingConflictingDilutionCurveSamples=PickList[simulatedSamples,conflictingDilutionCurveErrors,False];

  (* Create a list of lists index-matched to the simulated samples of form {{StandardDilutionCurve,SerialDilutionCurve}..} *)
  resolvedDilutionCurveOptionsPerSample=Transpose[{resolvedStandardDilutionCurve,resolvedSerialDilutionCurve}];

  (* Create a lists of the resolved DilutionCurve options that are invalid *)
  failingDilutionCurveOptionValues=PickList[resolvedDilutionCurveOptionsPerSample,conflictingDilutionCurveErrors,True];

  (* Define the invalid option variable *)
  conflictingDilutionCurveOptions=If[conflictingDilutionCurveErrorQ,
    {StandardDilutionCurve,SerialDilutionCurve},
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused conflictingDilutionCurveErrors to be set to True *)
  If[conflictingDilutionCurveErrorQ&&messages,
    Message[Error::ConflictingDLSDilutionCurves,ObjectToString[failingConflictingDilutionCurveSamples,Cache->cacheBall],ObjectToString[failingDilutionCurveOptionValues]]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingDilutionCurveTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[conflictingDilutionCurveErrorQ,
        Test["The following samples, "<>ObjectToString[failingConflictingDilutionCurveSamples,Cache->cacheBall]<>", have StandardDilutionCurve and SerialDilutionCurve options, "<>ToString[failingDilutionCurveOptionValues]<>", which are in conflict with each other. For any given sample (when the AssayType is ColloidalStability), these options cannot both be Null or both be specified:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingConflictingDilutionCurveSamples]>0,
        Test["The following samples have StandardDilutionCurve and SerialDilutionCurves options which are not in conflict, "<>ObjectToString[passingDilutionMixSamples,Cache->cacheBall]<>":",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw a Warning for if the Buffer and BlankBuffer are not the same - *)
  (* Set Warning booleans *)
  bufferBlankBufferWarnings=MapThread[
    Not[MatchQ[#1,#2]]&,
    {resolvedBuffer,resolvedBlankBuffer}
  ];

  (* First, determine if we need to throw this Warning *)
  bufferBlankBufferWarningQ=MemberQ[bufferBlankBufferWarnings,True];

  (* Create lists of the input samples that have the bufferNotSpecifiedWarning set to True and to False *)
  failingBufferBlankBufferSamples=PickList[simulatedSamples,bufferBlankBufferWarnings,True];
  passingBufferBlankBufferSamples=PickList[simulatedSamples,bufferBlankBufferWarnings,False];

  (* Create a list of lists index-matched to the simulated samples of form {{Buffer,BlankBuffer}..} *)
  resolvedBufferBlankBufferOptionsPerSample=Transpose[{resolvedBuffer,resolvedBlankBuffer}];

  (* Create a lists of the resolved DilutionCurve options that are invalid *)
  failingBufferBlankBufferOptionValues=PickList[resolvedBufferBlankBufferOptionsPerSample,bufferBlankBufferWarnings,True];

  (* Throw a Warning if we are throwing messages, and there are some input samples that caused bufferBlankBufferWarnings to be set to True *)
  If[bufferBlankBufferWarningQ&&messages&&notInEngine&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Message[Warning::DLSBufferAndBlankBufferDiffer,ObjectToString[failingBufferBlankBufferSamples,Cache->cacheBall],failingBufferBlankBufferOptionValues]
  ];

  (* Define the tests the user will see for the above message *)
  bufferBlankBufferTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[bufferBlankBufferWarningQ,
        Warning["For the following samples, "<>ObjectToString[failingBufferBlankBufferSamples,Cache->cacheBall]<>". The Buffer and BlankBuffer options, "<>ToString[failingBufferBlankBufferOptionValues]<>", are not identical. For ColloidalStability assays, it is highly recommended that the Buffer and BlankBuffer options are the same:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingBufferSpecifiedSamples]>0,
        Warning["For the following samples, "<>ObjectToString[passingBufferBlankBufferSamples,Cache->cacheBall]<>", the Buffer and BlankBuffer options are identical, or the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the IsothermalStability options are in conflict - *)
  invalidConflictingIsothermalRunOptions=Switch[{resolvedAssayType,resolvedIsothermalMeasurements,resolvedIsothermalRunTime},

    (* If the AssayType is not IsothermalStability, the options cannot be in conflict *)
    {Except[IsothermalStability],_,_},
      {},

    (* If the AssayType is IsothermalStability, and both the IsothermalMeasurements and IsothermalRunTime are Null, they are in conflict *)
    {IsothermalStability,Null,Null},
      {IsothermalMeasurements,IsothermalRunTime},

    (* If the AssayType is IsothermalStability, and both the IsothermalMeasurements and IsothermalRunTime are specified, they are in conflict *)
    {IsothermalStability,Except[Null],Except[Null]},
      {IsothermalMeasurements,IsothermalRunTime},

    (* Otherwise, the options are not in conflict *)
    {_,_,_},
      {}
  ];

  (* If there are any invalidConflictingIsothermalRunOptions and we are throwing Messages, throw an Error *)
  If[Length[invalidConflictingIsothermalRunOptions]>0&&messages,
    Message[Error::ConflictingDLSIsothermalOptions,ObjectToString[resolvedIsothermalMeasurements],ObjectToString[resolvedIsothermalRunTime]]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingIsothermalRunOptionsTests=If[gatherTests&&MatchQ[resolvedAssayType,IsothermalStability],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidConflictingIsothermalRunOptions]==0,
        Nothing,
        Test["The AssayType is IsothermalStability and the IsothermalMeasurements option, "<>ToString[resolvedIsothermalMeasurements]<>", is in conflict with the IsothermalRunTime option, "<>ToString[resolvedIsothermalRunTime]<>". When the AssayType is IsothermalStability, these two options must not both be Null or both be specified.",True,False]
      ];
      passingTest=If[Length[invalidConflictingIsothermalRunOptions]>0,
        Nothing,
        Test["The AssayType is IsothermalStability and the IsothermalMeasurements and IsothermalRunTime options are not in conflict:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw a Warning if AssayType is ColloidalStability and NumberOfReplicates is 2 - *)
  numberOfReplicatesWarningQ=MatchQ[resolvedAssayType,dilutionAssayTypeP]&&MatchQ[resolvedNumberOfReplicates,2];

  (* If numberOfReplicatesWarningQ is True and we are throwing Messages, throw a Warning *)
  If[numberOfReplicatesWarningQ&&messages&&notInEngine,
    Message[Warning::LowDLSReplicateConcentrations]
  ];

  (* Define the tests the user will see for the above message *)
  lowReplicateConcentrationTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Not[numberOfReplicatesWarningQ],
        Nothing,
        Warning["The NumberOfReplicates is set to 2. It is recommended to have 3 or more replicates per dilution curve concentration for ColloidalStability assays:",True,False]
      ];
      passingTest=If[numberOfReplicatesWarningQ,
        Nothing,
        Warning["The NumberOfReplicates is set to at least 3 or the AssayType is not ColloidalStability:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the SampleVolume is specified and the AssayType is ColloidalStability - *)
  invalidSampleVolumeOptions=If[

    (* IF the SampleVolume is not Null and the AssayType is ColloidalStability *)
    Or[
      MatchQ[resolvedSampleVolume,Except[Null]]&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
      MatchQ[resolvedSampleVolume,Null]&&MatchQ[resolvedAssayType,nonDilutionAssayTypeP]
    ],

    (* THEN the options are invalid *)
    {AssayType,SampleVolume},

    (* ELSE they're not *)
    {}
  ];

  (* If there are any invalidConflictingIsothermalRunOptions and we are throwing Messages, throw an Error *)
  If[Length[invalidSampleVolumeOptions]>0&&messages,
    Message[Error::ConflictingDLSAssayTypeSampleVolumeOptions,ObjectToString[resolvedAssayType],ObjectToString[resolvedSampleVolume]]
  ];

  (* Define the tests the user will see for the above message *)
  invalidSampleVolumeTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidSampleVolumeOptions]==0,
        Nothing,
        Test["The AssayType and the SampleVolume options are in conflict. When the AssayType is ColloidalStability, the SampleVolume cannot be specified. When the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, the SampleVolume must be specified:",True,False]
      ];
      passingTest=If[Length[invalidSampleVolumeOptions]>0,
        Nothing,
        Test["The AssayType and the SampleVolume options are not in conflict:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an error if the MeasurementDelayTime is too short for the number of samples and the IsothermalAttenuator Adjustment - *)
  {invalidDelayTimeOptionNames,invalidDelayTimeOptionValues}=Which[

    (*If the AssayType isn't IsothermalStability, the MeasurementDelayTime is Null, or the IsothermalAttenuatorAdjustment is Null, then this check is unnecessary*)
    Not[MatchQ[resolvedAssayType,IsothermalStability]]||NullQ[resolvedMeasurementDelayTime]||NullQ[resolvedIsothermalAttenuatorAdjustment],
      {{},{}},

    (* When the resolvedMeasurementDelayTime is smaller than the minimum required, and the NumberOfReplicates is not Null *)
    LessQ[resolvedMeasurementDelayTime,requiredMinimumDelayTime]&&Not[NullQ[numberOfReplicates]],
      {
        {MeasurementDelayTime,IsothermalAttenuatorAdjustment,NumberOfReplicates},
        {resolvedMeasurementDelayTime,resolvedIsothermalAttenuatorAdjustment,numberOfReplicates}
      },

    (* When the resolvedMeasurementDelayTime is smaller than the minimum required, and the NumberOfReplicates is Null *)
    LessQ[resolvedMeasurementDelayTime,requiredMinimumDelayTime],
      {
        {MeasurementDelayTime,IsothermalAttenuatorAdjustment},
        {resolvedMeasurementDelayTime,resolvedIsothermalAttenuatorAdjustment}
      },

    (* Otherwise, the MeasurementDelayTime is fine *)
    True,
      {{},{}}
    ];

  (* If there are any invalidDelayTimeOptionNames and we are throwing Messages, throw an Error *)
  If[Length[invalidDelayTimeOptionNames]>0&&messages,
    Message[Error::DLSMeasurementDelayTimeTooLow, ObjectToString[invalidDelayTimeOptionNames],ObjectToString[invalidDelayTimeOptionValues],ObjectToString[numberOfSamplesWithReplicates],ObjectToString[resolvedIsothermalAttenuatorAdjustment],ObjectToString[requiredMinimumDelayTime]]
  ];

  (* Define the tests the user will see for the above message *)
  invalidMeasurementDelayTimeTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidDelayTimeOptionNames]==0,
        Nothing,
        Test["The following options, "<>ToString[invalidDelayTimeOptionNames]<>", which have been set to "<>ToString[invalidDelayTimeOptionValues]<>" are in conflict with the number of input samples (including replicate samples), "<>ToString[numberOfSamplesWithReplicates]<>". With this number of samples and the IsothermalAttenuatorAdjustment set to "<>ToString[resolvedIsothermalAttenuatorAdjustment]<>", the minimum allowable MeasurementDelayTime is "<>ToString[requiredMinimumDelayTime]<>":",True,False]
      ];
      passingTest=If[Length[invalidDelayTimeOptionNames]>0,
        Nothing,
        Test["The AssayType is either not IsothermalStability or the MeasurementDelayTime is not too short:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the MeasurementDelayTime is larger than the IsothermalRunTime - *)
  invalidIsothermalMeasurementTimeOptions=If[

    (* IF the AssayType is IsothermalStability AND neither the MeasurementDelayTime nor the IsothermalRunTime are Null AND the MeasurementDelayTime is larger than the IsothermalRunTime *)
    And[
      MatchQ[resolvedAssayType,IsothermalStability],
      MatchQ[resolvedMeasurementDelayTime,Except[Null]],
      MatchQ[resolvedIsothermalRunTime,Except[Null]],
      resolvedMeasurementDelayTime>resolvedIsothermalRunTime
    ],

    (* *THEN the options are invalid* *)
    {MeasurementDelayTime,IsothermalRunTime},

    (* ELSE, in all other cases, we do not need to check *)
    {}
  ];

  (* If there are any invalidIsothermalMeasurementTimeOptions and we are throwing Messages, throw an Error *)
  If[Length[invalidIsothermalMeasurementTimeOptions]>0&&messages,
    Message[Error::ConflictingDLSIsothermalTimeOptions,ObjectToString[resolvedMeasurementDelayTime],ObjectToString[resolvedIsothermalRunTime]]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingIsothermalIsothermalTimeTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidIsothermalMeasurementTimeOptions]==0,
        Nothing,
        Test["The AssayType is IsothermalStability and the MeasurementDelayTime, "<>ToString[resolvedMeasurementDelayTime]<>", and the IsothermalRunTime, "<>ToString[resolvedIsothermalRunTime]<>", are in conflict. The MeasurementDelayTime cannot be larger than the IsothermalRunTime:",True,False]
      ];
      passingTest=If[Length[invalidIsothermalMeasurementTimeOptions]>0,
        Nothing,
        Test["The AssayType is either not IsothermalStability or the MeasurementDelayTime and IsothermalRunTime are not in conflict:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an error if the total length of an IsothermalStability run is over 6.5 days - *)
  (* Define a variable that is the length of time *)
  totalIsothermalTime=Switch[{resolvedAssayType,resolvedMeasurementDelayTime,resolvedIsothermalMeasurements},

    (* When the AssayType is not IsothermalStability, we set this variable to Null *)
    {Except[IsothermalStability],_,_},
      Null,

    (* If the MeasurementDelayTime and the IsothermalMeasurements are both specified, we multiply them *)
    {_,Except[Null],Except[Null]},
      RoundOptionPrecision[(resolvedMeasurementDelayTime*resolvedIsothermalMeasurements),10^0*Second],

    (* In all other cases (one of the variables is Null and so an error was thrown already, we set it to Null *)
    {_,_,_},
      Null
  ];

  (* Define the invalid options variable, as well as the variable used in the error message *)
  invalidTooLongIsothermalOptions=Which[

    (* If the totalIsothermalTime is Null, then there are no invalid options *)
    MatchQ[totalIsothermalTime,Null],
      {},

    (* If the totalIsothermalTime is longer than 6.5 days, then the MeasurementDelayTime and IsothermalMeasurements options are invalid *)
    totalIsothermalTime>6.5*Day,
      {MeasurementDelayTime,IsothermalMeasurements},

    (* In all other cases (either totalIsothermalTime is shorter than 6.5 days, or is Null (and error already thrown), they're fine *)
    True,
      {}
  ];


  (* If there are any invalidDelayTimeOptionNames and we are throwing Messages, throw an Error *)
  If[Length[invalidTooLongIsothermalOptions]>0&&messages,
    Message[Error::DLSIsothermalAssayTooLong,ObjectToString[resolvedMeasurementDelayTime],ObjectToString[resolvedIsothermalMeasurements],ObjectToString[totalIsothermalTime]]
  ];

  (* Define the tests the user will see for the above message *)
  tooLongIsothermalAssayTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidTooLongIsothermalOptions]==0,
        Nothing,
        Test["The AssayType is IsothermalStability and the MeasurementDelayTime, "<>ToString[resolvedMeasurementDelayTime]<>", and the IsothermalMeasurements, "<>ToString[resolvedIsothermalMeasurements]<>", are in conflict. The product of these two options is "<>ToString[totalIsothermalTime]<>", but the longest possible IsothermalStability assay is 6.5 days:",True,False]
      ];
      passingTest=If[Length[invalidTooLongIsothermalOptions]>0,
        Nothing,
        Test["The AssayType is either not IsothermalStability or the MeasurementDelayTime and IsothermalMeasurements options are not in conflict:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- Throw a series of Errors having to do with the Dilution Curve Volumes -- *)

  (* - First, make lists of the StandardDilutionCurve and SerialDilution curve options by SampleVolume/TransferVolume/BufferVolume - *)
  standardDilutionCurveVolumes=calculatedDLSDilutionCurveVolumes[#]&/@Transpose[{resolvedStandardDilutionCurve,resolvedAnalyteMassConcentration}];
  serialDilutionCurveVolumes=calculatedDLSDilutionCurveVolumes[#]&/@resolvedSerialDilutionCurve;

  (* - For each sample, find the maximum volume required in a well at any one time, and the minimum volume present in any well at end - *)
  {minDilutionVolumes,maxDilutionVolumes}=Transpose[
    MapThread[
      Function[{standardVolumes,serialVolumes},
        If[
          (* IF both the StandardDilutionCurve and SerialDilutionCurve are Null *)
          MatchQ[standardVolumes,{Null,Null}]&&MatchQ[serialVolumes,{Null,Null}],

          (* THEN the Min and Max Volumes required in any one well will be set to Null *)
          {Null,Null},

          (* ELSE, we need to do MATH *)
          Module[{maxWellVolume,minWellVolume},

            (* Determine the maximum volume that will be present in any one well of the SampleLoadingPlate during the dilution *)
            maxWellVolume=If[

              (* *IF the StandardDilutionCurve is specified* *)
              MatchQ[standardVolumes,Except[{Null,Null}]],

              (* *THEN we take the maximum of the sum of the SampleVolumes and BufferVolumes of the StandardDilutionCurve* *)
              Max[First[standardVolumes]+Last[standardVolumes]],

              (* ELSE, we take the maximum of the sum of the TransferVolumes and BufferVolumes of the SerialDilutionCurve *)
              Max[First[serialVolumes]+Last[serialVolumes]]
            ];

            (* Determine the minimum volume that will be present in any one well of the SampleLoadingPlate after the dilution *)
            minWellVolume=If[

              (* IF the StandardDilutionCurve is specified *)
              MatchQ[standardVolumes,Except[{Null,Null}]],

              (* THEN we pick the minimum of the sum of the SampleVolumes and BufferVolumes *)
              Min[First[standardVolumes]+Last[standardVolumes]],

              (* ELSE, we add the last TransferVolume to the last BufferVolume (this is the SampleVolume, all wells will have the same volume) *)
              (Last[First[serialVolumes]]+Last[Last[serialVolumes]])
            ];

            (* Return the Max and Min Volumes *)
            {minWellVolume,maxWellVolume}
          ]
        ]
      ],
      {standardDilutionCurveVolumes,serialDilutionCurveVolumes}
    ]
  ];

  (* - Define two variables, one that is which of the StandardDilutionCurve or SerialDilutionCurve has been specified for each sample,
  the other is the value of this option, with StandardDilutionCurve taking precedence over SerialDilutionCurve - *)
  {dilutionCurveOptionNamePerSample,dilutionCurveOptionValuePerSample}=Transpose[
    MapThread[

      Switch[{#1,#2},

        (* Case where the StandardDilutionCurve and SerialDilutionCurve are both specified, choose the StandardDilutionCurve *)
        {Except[Null],Except[Null]},
          {StandardDilutionCurve,#1},

        (* Case where only the StandardDilutionCurve is specified *)
        {Except[Null],Null},
          {StandardDilutionCurve,#1},

        (* Case where only the SerialDilutionCurve is specified *)
        {Null,Except[Null]},
          {SerialDilutionCurve,#2},

        (* Case where neither are specified *)
        {Null,Null},
          {Null,Null}
      ]&,
      {resolvedStandardDilutionCurve,resolvedSerialDilutionCurve}
    ]
  ];

  (* - Throw an Error if the MaxDilutionVolume is larger than the MaxVolume of the SampleLoadingPlate for any sample - *)
  (* Define the index-matched warning booleans *)
  dilutionVolumePlateMismatchErrors=Map[
    Switch[#,

      (* If maxDilutionVolume is Null, there are no DilutionCurves, and so no Error *)
      Null,
        False,

      (* If the maxDilutionVolume is larger than the MaxVolume of the SampleLoadingPlate, we throw an Error *)
      GreaterP[loadingPlateMaxVolume],
        True,

      (* In all other cases, we do not throw this error *)
      _,
        False
    ]&,
    maxDilutionVolumes
  ];

  (* Determine if we need to throw this Error *)
  dilutionVolumePlateMismatchErrorQ=MemberQ[dilutionVolumePlateMismatchErrors,True];

  (* Create lists of the input samples that have the dilutionVolumePlateMismatchErrors set to True and to False *)
  failingVolumePlateMismatchSamples=PickList[simulatedSamples,dilutionVolumePlateMismatchErrors,True];
  passingVolumePlateMismatchSamples=PickList[simulatedSamples,dilutionVolumePlateMismatchErrors,False];

  (* Create lists of DilutionCurveOptions and their values for the failing samples, as well as the MaxVolumes *)
  failingPlateMaxVolumeOptionNames=PickList[dilutionCurveOptionNamePerSample,dilutionVolumePlateMismatchErrors,True];
  failingPlateMaxVolumeOptionValues=PickList[dilutionCurveOptionValuePerSample,dilutionVolumePlateMismatchErrors,True];
  failingDilutionMaxVolumes=PickList[maxDilutionVolumes,dilutionVolumePlateMismatchErrors,True];

  (* Define the invalid option variable *)
  invalidPlateMaxVolumeOptions=If[dilutionVolumePlateMismatchErrorQ,
    DeleteDuplicates[Join[failingPlateMaxVolumeOptionNames,{SampleLoadingPlate}]],
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused dilutionVolumePlateMismatchErrorQ to be set to True *)
  If[dilutionVolumePlateMismatchErrorQ&&messages,
    Message[Error::DLSDilutionCurveLoadingPlateMismatch,ObjectToString[failingVolumePlateMismatchSamples,Cache->cacheBall],ObjectToString[failingPlateMaxVolumeOptionNames],ObjectToString[failingPlateMaxVolumeOptionValues],ObjectToString[suppliedSampleLoadingPlate],ObjectToString[loadingPlateMaxVolume],ObjectToString[failingDilutionMaxVolumes]]
  ];

  (* Define the tests the user will see for the above message *)
  dilutionVolumePlateMismatchTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidPlateMaxVolumeOptions]==0,
        Nothing,
        Test["The following input samples, "<>ToString[failingVolumePlateMismatchSamples]<>", have dilution-related options, "<>ToString[failingPlateMaxVolumeOptionNames]<>", with values of "<>ToString[failingPlateMaxVolumeOptionValues]<>".These options are in conflict with the SampleLoadingPlate, "<>ObjectToString[suppliedSampleLoadingPlate,Cache->cacheBall]<>", which has a MaxVolume of "<>ToString[loadingPlateMaxVolume]<>". The dilution curve options require a maximum volume of "<>ToString[failingDilutionMaxVolumes]<>" be placed in a well, which exceeds the MaxVolume of the plate. Please either choose a larger SampleLoadingPlate, or, ideally, change the dilution option to require less volume per well:",True,False]
      ];
      passingTest=If[Length[passingVolumePlateMismatchSamples]==0,
        Nothing,
        Test["The following input samples "<>ToString[passingVolumePlateMismatchSamples]<>" have dilution curve options do not require more volume to occupy a well than the MaxVolume of the SampleLoadingPlate:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the MinDilutionVolume is smaller than the DilutionMixVolume for any sample - *)
  (* Define the index-matched Error booleans *)
  dilutionMixVolumeErrors=MapThread[
    Not[NullQ[#1]]&&Not[NullQ[#2]] && #1>#2 &,
    {resolvedDilutionMixVolume,minDilutionVolumes}
  ];

  (* Determine if we need to throw this Error *)
  dilutionMixVolumeErrorQ=MemberQ[dilutionMixVolumeErrors,True];

  (* Create lists of the input samples that have the dilutionVolumePlateMismatchErrors set to True and to False *)
  failingDilutionMixVolumeSamples=PickList[simulatedSamples,dilutionMixVolumeErrors,True];
  passingDilutionMixVolumeSamples=PickList[simulatedSamples,dilutionMixVolumeErrors,False];

  (* Create lists of DilutionCurveOptions and their values for the failing samples, as well as the MinVolumes and DilutionMixVolumes *)
  failingDilutionMixVolumeOptionNames=PickList[dilutionCurveOptionNamePerSample,dilutionMixVolumeErrors,True];
  failingDilutionMixVolumeOptionValues=PickList[dilutionCurveOptionValuePerSample,dilutionMixVolumeErrors,True];
  failingDilutionMixMinVolumes=PickList[minDilutionVolumes,dilutionMixVolumeErrors,True];
  failingDilutionMixVolumes=PickList[resolvedDilutionMixVolume,dilutionMixVolumeErrors,True];

  (* Define the invalid option variable *)
  invalidDilutionMixMinVolumeOptions=If[dilutionMixVolumeErrorQ,
    DeleteDuplicates[Join[failingDilutionMixVolumeOptionNames,{DilutionMixVolume}]],
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused dilutionMixVolumeErrorQ to be set to True *)
  If[dilutionMixVolumeErrorQ&&messages,
    Message[Error::DLSDilutionCurveMixVolumeMismatch,ObjectToString[failingDilutionMixVolumeSamples,Cache->cacheBall],ObjectToString[failingDilutionMixVolumeOptionNames],ObjectToString[failingDilutionMixVolumeOptionValues],ObjectToString[failingDilutionMixVolumes],ObjectToString[failingDilutionMixMinVolumes]]
  ];

  (* Define the tests the user will see for the above message *)
  dilutionCurveMixVolumeMismatchTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidDilutionMixMinVolumeOptions]==0,
        Nothing,
        Test["The following input samples, "<>ToString[failingDilutionMixVolumeSamples]<>", have dilution-related options, "<>ToString[failingDilutionMixVolumeOptionNames]<>", with values of "<>ToString[failingDilutionMixVolumeOptionValues]<>". These options are in conflict with the corresponding DlutionMixVolume option, "<>ObjectToString[failingDilutionMixVolumes,Cache->cacheBall]<>". The dilution curve options indicate that a well of the SampleLoadingPlate will have a total volume of "<>ToString[failingDilutionMixMinVolumes]<>", which is smaller than the DilutionMixVolume. The DilutionMixVolume must be smaller than the lowest volume in the SampleLoadingPlate. Please ensure that these options are not in conflict, either by reducing the DilutionMixVolume or changing the dilution curve option:",True,False]
      ];
      passingTest=If[Length[passingDilutionMixVolumeSamples]==0,
        Nothing,
        Test["The following input samples "<>ToString[passingDilutionMixVolumeSamples]<>" have dilution curve options that indicate all wells of the SampleLoadingPlate will have larger volumes than the DilutionMixVolume:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an error if the dilutionMinVolume is smaller than the amount that is required to load the uncle capillary strips - *)
  (* First, define a variable that is the amount of volume that is required to load the strips for ColloidalStability assays *)
  dilutionAssayRequiredVolume=Which[

    (* If the AssayType is SizingPolydispersity or IsothermalStability, set this variable to Null (we use SampleVolume for this) *)
    Not[MatchQ[resolvedAssayType,ColloidalStability]],
      Null,

    (* If the NumberOfReplicates is Null, we've already thrown an error, no need to check this *)
    NullQ[resolvedNumberOfReplicates],
      Null,

    (* In the case where there are no StandardDilutionCurves or SerialDilutionCurves specified, we've already thrown an error, no need to check this *)
    MatchQ[resolvedStandardDilutionCurve,Null|{{}...}]&&MatchQ[resolvedSerialDilutionCurve,Null|{{}...}],
      Null,

    (* In the case where the ReplicateDilutionCurve has been specified as Null, we've already thrown an error, no need to check this *)
    NullQ[resolvedReplicateDilutionCurve],
      Null,

    (* If the ReplicateDilutionCurve option is False, we multiply 11 uL by the NumberOfReplicates *)
    MatchQ[resolvedReplicateDilutionCurve,False],
      (11*Microliter*resolvedNumberOfReplicates),

    (* If the ReplicateDilutionCurve option is True, the min required volume is 11 uL *)
    True,
      11*Microliter
  ];

  (* Define the Error Booleans for each sample *)
  notEnoughDilutionVolumeErrors=Map[
    Which[

      (* If the dilutionAssayRequiredVolume is Null, set the boolean to False *)
      MatchQ[dilutionAssayRequiredVolume,Null],
        False,

      (* If the minDilutionVolume is greater or equal to the dilutionAssayRequiredVolume, set the boolean to False *)
      #>=dilutionAssayRequiredVolume,
        False,

      (* Otherwise, set the boolean to True *)
      True,
        True
    ]&,
    minDilutionVolumes
  ];

  (* Determine if we need to throw this Error *)
  notEnoughDilutionVolumeErrorQ=MemberQ[notEnoughDilutionVolumeErrors,True];

  (* Create lists of the input samples that have the dilutionVolumePlateMismatchErrors set to True and to False *)
  failingNotEnoughDilutionVolumeSamples=PickList[simulatedSamples,notEnoughDilutionVolumeErrors,True];
  passingNotEnoughDilutionVolumeSamples=PickList[simulatedSamples,notEnoughDilutionVolumeErrors,False];

  (* Create lists of DilutionCurveOptions and their values for the failing samples, as well as the MinVolumes *)
  failingNotEnoughDilutionVolumeOptionNames=PickList[dilutionCurveOptionNamePerSample,notEnoughDilutionVolumeErrors,True];
  failingNotEnoughDilutionVolumeOptionValues=PickList[dilutionCurveOptionValuePerSample,notEnoughDilutionVolumeErrors,True];
  failingDilutionVolumeMinVolumes=PickList[minDilutionVolumes,notEnoughDilutionVolumeErrors,True];

  (* Define the invalid options for this error *)
  notEnoughDilutionVolumeInvalidOptions=If[notEnoughDilutionVolumeErrorQ,
    DeleteDuplicates[Join[failingNotEnoughDilutionVolumeOptionNames,{ReplicateDilutionCurve,NumberOfReplicates}]],
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused notEnoughDilutionVolumeErrorQ to be set to True *)
  If[notEnoughDilutionVolumeErrorQ&&messages,
    Message[Error::DLSNotEnoughDilutionCurveVolume,ObjectToString[failingNotEnoughDilutionVolumeSamples,Cache->cacheBall],ObjectToString[failingNotEnoughDilutionVolumeOptionNames],ObjectToString[failingNotEnoughDilutionVolumeOptionValues],ObjectToString[resolvedNumberOfReplicates],ObjectToString[resolvedReplicateDilutionCurve],ObjectToString[dilutionAssayRequiredVolume],ObjectToString[failingDilutionVolumeMinVolumes]]
  ];

  (* Define the tests the user will see for the above message *)
  notEnoughDilutionVolumeTests=If[gatherTests&&MatchQ[dilutionAssayRequiredVolume,Except[Null]],
    Module[{failingTest,passingTest},
      failingTest=If[Length[notEnoughDilutionVolumeInvalidOptions]==0,
        Nothing,
        Test["The following input samples, "<>ToString[failingNotEnoughDilutionVolumeSamples]<>", have dilution-related options, "<>ToString[failingNotEnoughDilutionVolumeOptionNames]<>", with values of "<>ToString[failingNotEnoughDilutionVolumeOptionValues]<>". Because the NumberOfReplicates is "<>ToString[resolvedNumberOfReplicates]<>" and the ReplicateDilutionCurve is "<>ToString[resolvedReplicateDilutionCurve]<>", the minimum required volume for each concentration of the dilution curve is "<>ToString[dilutionAssayRequiredVolume]<>". The given dilution curve options result in a minimum volume of "<>ToString[failingDilutionVolumeMinVolumes]<>" in at least one well of the SampleLoadingPlate after sample dilution:",True,False]
      ];
      passingTest=If[Length[passingNotEnoughDilutionVolumeSamples]==0,
        Nothing,
        Test["The following input samples "<>ToString[passingNotEnoughDilutionVolumeSamples]<>" have dilution curve options that indicate all wells of the SampleLoadingPlate will have enough volume to load the AssayContainer:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if any of the StandardDilutionCurve or SerialDilutionCurves contain only one Concentration - *)
  (* Set Error boolean for each input sample *)
  onlyOneDilutionConcentrationErrors=MapThread[
    Which[

      (* If there is no dilution curve, then set the Error boolean to False *)
      MatchQ[#1,Null],
        False,

      (* If the DilutionCurveOption is specified, make sure that there is actually more than one unique concentration *)
      MatchQ[#2,Except[Null]],
        If[
          Length[DeleteDuplicates[#2]]==1,
          True,
          False
        ],

      (* Otherwise, there is a SerialDilutionCurve specified, make sure it has a length longer than 1 by checking the serialDilutionCurveVolume *)
      True,
        If[
          MatchQ[#3,{{VolumeP},{VolumeP}}],
          True,
          False
        ]
    ]&,
    {minDilutionVolumes,resolvedStandardDilutionCurve,serialDilutionCurveVolumes}
  ];

  (* Determine if we need to throw this Error *)
  onlyOneDilutionConcentrationErrorQ=MemberQ[onlyOneDilutionConcentrationErrors,True];

  (* Create lists of the input samples that have the dilutionVolumePlateMismatchErrors set to True and to False *)
  failingOneConcentrationSamples=PickList[simulatedSamples,onlyOneDilutionConcentrationErrors,True];
  passingOneConcentrationSamples=PickList[simulatedSamples,onlyOneDilutionConcentrationErrors,False];

  (* Create lists of DilutionCurveOptions and their values for the failing samples *)
  failingOneConcentrationDilutionOptionNames=PickList[dilutionCurveOptionNamePerSample,onlyOneDilutionConcentrationErrors,True];
  failingOneConcentrationDilutionOptionValues=PickList[dilutionCurveOptionValuePerSample,onlyOneDilutionConcentrationErrors,True];

  (* Set the invalid Options variable *)
  onlyOneDilutionCurveOptions=If[onlyOneDilutionConcentrationErrorQ,
    DeleteDuplicates[failingOneConcentrationDilutionOptionNames],
    {}
  ];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused onlyOneDilutionConcentrationErrorQ to be set to True *)
  If[onlyOneDilutionConcentrationErrorQ&&messages,
    Message[Error::DLSOnlyOneDilutionCurveConcentration,ObjectToString[failingOneConcentrationSamples,Cache->cacheBall],ObjectToString[failingOneConcentrationDilutionOptionNames],ObjectToString[failingOneConcentrationDilutionOptionValues]]
  ];

  (* Define the tests the user will see for the above message *)
  onlyOneDilutionConcentrationTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[onlyOneDilutionCurveOptions]==0,
        Nothing,
        Test["The following input samples, "<>ToString[failingOneConcentrationSamples]<>", have invalid dilution-related options, "<>ToString[failingOneConcentrationDilutionOptionNames]<>", with values of "<>ToString[failingOneConcentrationDilutionOptionValues]<>". At least two unique dilutions of each input sample are required for ColloidalStability Assays:",True,False]
      ];
      passingTest=If[Length[passingOneConcentrationSamples]==0,
        Nothing,
        Test["The following input samples "<>ToString[passingOneConcentrationSamples]<>" have dilution curve options with at least two unique dilutions per input sample:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an error if we have too many input samples and the AssayType is SizingPolydispersity or IsothermalStability  *)
  (* Set a variable that is the invalid inputs if we are going to throw this error *)
  tooManyInvalidInputs=Switch[{numberOfSamplesWithReplicates,resolvedAssayType,resolvedAssayFormFactor},

    (* IF there are more than 48 required wells of the AssayContainer AND the AssayType is not ColloidalStability AND AssayFormFactor is Capillary *)
    {GreaterP[48],nonDilutionAssayTypeP,Capillary},

    (* THEN the input samples are invalid *)
    simulatedSamples,

    (* IF there are more than 384 required wells of the AssayContainer AND the AssayType is not ColloidalStability AND AssayFormFactor is Plate *)
    {GreaterP[384],nonDilutionAssayTypeP,Plate},

    (* THEN the input samples are invalid *)
    simulatedSamples,

    (* ELSE no inputs are invalid *)
    {_,_,_},
    {}
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[tooManyInvalidInputs]>0&&messages,
    Message[Error::TooManyDLSInputs,ObjectToString[simulatedSamples,Cache->cacheBall],ObjectToString[numberOfSamplesWithReplicates],ObjectToString[resolvedInstrument]]
  ];

  (* Define the tests the user will see for the above message *)
  tooManySamplesTests=If[gatherTests&&MatchQ[resolvedAssayType,nonDilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[tooManyInvalidInputs]==0,
        Nothing,
        Test["The NumberOfReplicates times the number of input samples, "<>ToString[numberOfSamplesWithReplicates]<>", is larger than the maximum available wells of the AssayContainers for one protocol on the given instrument "<>ToString[resolvedInstrument]<>":",True,False]
      ];
      passingTest=If[Length[tooManyInvalidInputs]>0,
        Nothing,
        Test["The number of input samples times the NumberOfReplicates is not larger than the maximum allowed for the instrument:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the AssayType is B22kD or G22 and we require more than 48 wells of the AssayContainer - *)
  (* Define a variable that is a list of the number of AssayContainer wells required for each sample's dilution curve *)
  assayContainerWellsPerSample=MapThread[
    Switch[{resolvedAssayType,#1,#2,resolvedNumberOfReplicates},

      (* If the resolvedAssayType is IsothermalStability or SizingPolydispersity, we set this to 0 *)
      {nonDilutionAssayTypeP,_,_,_},
        0,

      (* If the NumberOfReplicates is Null, we have already thrown an error, set to 0 *)
      {_,_,_,Null},
        0,

      (* If both the StandardDilutionCurve and the SerialDilutionCurves are Null, or specified, an error was already thrown, set to 0 *)
      {_,{Null,Null},{Null,Null},_},
        0,
      {_,Except[{Null,Null}],Except[{Null,Null}],_},
        0,

      (* If only the StandardDilutionCurve is specified, then take the Length of the SampleVolumes times the NumberOfReplicates *)
      {_,Except[{Null,Null}],_,_},
        (Length[First[#1]]*resolvedNumberOfReplicates),

      (* If only the SerialDilutionCurve is specified, take the Length of the TransferVolumes times the NumberOfReplicates *)
      {_,_,Except[{Null,Null}],_},
        (Length[First[#2]]*resolvedNumberOfReplicates)
    ]&,
    {standardDilutionCurveVolumes,serialDilutionCurveVolumes}
  ];

  (* Figure out how many total AssayContainer wells the protocol needs. This is done by adding the numberOfSamplesWithReplicates
  (which corresponds to the BlankBuffer wells, one for each sample), to the product of the NumberOfReplicates times the sum of the
  assayContainerWellsPerSample (which already takes into account the NumberOfReplicates *)
  requiredDilutionAssayContainerWells=(numberOfSamplesWithReplicates+(resolvedColloidalStabilityParametersPerSample*Total[assayContainerWellsPerSample]));

  (* Set the invalid options variable *)
  invalidTooManyDilutionSamplesOptions=If[

    (* IF the AssayType is SizingPolydispersity or IsothermalStability, OR there are fewer than 48 wells required for Capillary or 384 for Plate: *)
    Or[
      MatchQ[resolvedAssayType,nonDilutionAssayTypeP],
      requiredDilutionAssayContainerWells<=48&&MatchQ[resolvedAssayFormFactor,Capillary],
      requiredDilutionAssayContainerWells<=384&&MatchQ[resolvedAssayFormFactor,Plate]
    ],

    (* THEN these options are not invalid *)
    {},

    (* ELSE, the options that are invalid are the ones that are specified *)
    If[MatchQ[numberOfReplicates,Null],
      DeleteDuplicates[Join[dilutionCurveOptionNamePerSample,{NumberOfReplicates}]],
      DeleteDuplicates[Join[dilutionCurveOptionNamePerSample,{NumberOfReplicates,NumberOfReplicates}]]
    ]
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[invalidTooManyDilutionSamplesOptions]>0&&messages,
    Message[Error::DLSTooManyDilutionWellsRequired,ObjectToString[numberOfSamples],ObjectToString[invalidTooManyDilutionSamplesOptions],ObjectToString[requiredDilutionAssayContainerWells],ObjectToString[resolvedInstrument]]
  ];

  (* Define the tests the user will see for the above message *)
  tooManyDilutionSamplesTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidTooManyDilutionSamplesOptions]==0,
        Nothing,
        Test["The combination of the number of input samples, "<>ToString[numberOfSamples]<>", and the following options, "<>ToString[invalidTooManyDilutionSamplesOptions]<>", is invalid. The combination of input samples and specified invalid options require "<>ToString[requiredDilutionAssayContainerWells]<>" wells, which is greater than the maximum allowed for the Instrument, "<>ToString[resolvedInstrument]<>":",True,False]
      ];
      passingTest=If[Length[invalidTooManyDilutionSamplesOptions]>0,
        Nothing,
        Test["The number of required AssayContainer wells is not greater than the maximum allowed for the Instrument:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- Throw Errors and Warnings based on these Analyte MassConcentrations -- *)
  (* - Throw Error if we are in a ColloidalStability Assay and there in an input sample with no Analyte in its Composition - *)
  (* Figure out if we need to throw this Error *)
  noAnalyteErrorQ=MemberQ[noAnalyteErrors,True];

  (* Create lists of the input samples that have the noAnalyteErrors set to True and to False *)
  failingNoAnalyteSamples=PickList[simulatedSamples,noAnalyteErrors,True];
  passingNoAnalyteSamples=PickList[simulatedSamples,noAnalyteErrors,False];

  (* Create a list of the failing samples' Compositions *)
  failingNoAnalyteCompositions=PickList[sampleCompositions,noAnalyteErrors,True];

  (* Define the invalid input variable *)
  noAnalyteInvalidOptions=If[noAnalyteErrorQ,
    {Analyte},
    {}
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[noAnalyteInvalidOptions]>0&&messages,
    Message[Error::DLSInputSampleNoAnalyte,resolvedAssayType,ObjectToString[failingNoAnalyteSamples,Cache->cacheBall],ObjectToString[failingNoAnalyteCompositions,Cache->cacheBall]]
  ];

  (* Define the tests the user will see for the above message *)
  noAnalyteTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[failingNoAnalyteSamples]==0,
        Nothing,
        Test["The following input samples, "<>ObjectToString[failingNoAnalyteSamples,Cache->cacheBall]<>", do not have a Model[Molecule,Protein] in their Composition Field:",True,False]
      ];
      passingTest=If[Length[passingNoAnalyteSamples]==0,
        Nothing,
        Test["The following input samples, "<>ObjectToString[passingNoAnalyteSamples,Cache->cacheBall]<>", have a Model[Molecule,Analyte] in their Composition Field:",True,True]
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- Throw an Error if we are in a G22 Assay but none of the Analytes have associated MolecularWeights --*)
  (* - From the resolvedAnalytes, get the corresponding MolecularWeights (need this information for G22 Assays)- *)
  analyteMolecularWeights=If[

    (* IF the resolvedAnalyte is just a list of Null *)
    MatchQ[resolvedAnalyte,{Null..}],

    (* THEN just set this to an empty list *)
    {},

    (* ELSE, look up the MolecularWeight of each non-Null Analyte *)
    fastAssocLookup[fastAssoc,#,MolecularWeight]&/@DeleteCases[resolvedAnalyte,Null]
  ];

  (* Get rid of any Nulls in the list *)
  nonNullAnalyteMolecularWeights=Cases[analyteMolecularWeights,Except[Null]];

  (* Set the invalid Options variable *)
  invalidAnalyteOptions=If[

    (* IF the AssayType is ColloidalStability AND none of the resolved Analytes have associated MolecularWeights AND AssayFormFactor is Capillary *)
    MatchQ[resolvedAssayType,ColloidalStability]&&MatchQ[nonNullAnalyteMolecularWeights,{}]&&MatchQ[resolvedAssayFormFactor,Capillary],
    (* THEN the Analyte is invalid *)
    {Analyte},

    (* ELSE, not invalid *)
    {}
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[invalidAnalyteOptions]>0&&messages,
    Message[Error::DLSInputSampleNoAnalyteMolecularWeight,ObjectToString[resolvedAnalyte,Cache->cacheBall]]
  ];

  (* Define the tests the user will see for the above message *)
  noAnalyteMWTests=If[gatherTests&&MatchQ[resolvedAssayType,ColloidalStability],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidAnalyteOptions]==0,
        Nothing,
        Test["The AssayType is ColloidalStability, the AssayFormFactor is Capillary, and none of the Analytes, "<>ObjectToString[resolvedAnalyte,Cache->cacheBall]<>", have associated MolecularWeights. A MolecularWeight is required for ColloidalStability assays:",True,False]
      ];
      passingTest=If[Length[invalidAnalyteOptions]==0,
        Test["The AssayType is ColloidalStability, the AssayFormFactor is Capillary, and at least one of the Analytes, "<>ObjectToString[resolvedAnalyte,Cache->cacheBall]<>", has an associated MolecularWeight. A MolecularWeight is required for ColloidalStability assays:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- Throw Error if we are in a ColloidalStability assay and there in an input sample with a Analyte in its Composition but we dont know how much -- *)
  (* Figure out if we need to throw this Error *)
  noAnalyteMassConcentrationErrorQ=MemberQ[noAnalyteMassConcentrationErrors,True]&&MatchQ[resolvedAssayType,dilutionAssayTypeP];

  (* Create lists of the input samples that have the noAnalyteErrors set to True and to False *)
  failingNoAnalyteConcentrationSamples=PickList[simulatedSamples,noAnalyteMassConcentrationErrors,True];
  passingNoAnalyteConcentrationSamples=PickList[simulatedSamples,noAnalyteMassConcentrationErrors,False];

  (* Create a list of the failing samples' Compositions *)
  failingNoAnalyteConcentrationCompositions=PickList[sampleCompositions,noAnalyteMassConcentrationErrors,True];

  (* Define the invalid input variable *)
  invalidNoAnalyteConcentrationOptions=If[noAnalyteMassConcentrationErrorQ,
    {AnalyteMassConcentration},
    {}
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[invalidNoAnalyteConcentrationOptions]>0&&messages,
    Message[Error::DLSInputSampleNoAnalyteMassConcentration,ObjectToString[resolvedAssayType],ObjectToString[failingNoAnalyteConcentrationSamples,Cache->cacheBall],ObjectToString[failingNoAnalyteConcentrationCompositions,Cache->cacheBall]]
  ];

  (* Define the tests the user will see for the above message *)
  noAnalyteConcentrationTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[failingNoAnalyteConcentrationSamples]==0,
        Nothing,
        Test["The following input samples, "<>ObjectToString[failingNoAnalyteConcentrationSamples,Cache->cacheBall]<>", have a Model[Molecule,Protein] or Model[Molecule,Polymer] or Model[Molecule,Oligomer] in the Composition Field but the MassConcentration of the Analyte is not able to be calculated:",True,False]
      ];
      passingTest=If[Length[passingNoAnalyteConcentrationSamples]==0,
        Nothing,
        Test["The following input samples, "<>ObjectToString[passingNoAnalyteConcentrationSamples,Cache->cacheBall]<>", either have no Model[Molecule,Protein] or Model[Molecule,Polymer] or Model[Molecule,Oligomer] in their Composition or have Amounts associated with the Model[Molecule,Protein]s:",True,True]
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the Temperature is not 25*Celsius and the AssayType is ColloidalStability and AssayFormFactor is Capillary - *)
  (* Define the invalid option names *)
  invalidTemperatureOptions=If[

    (* IF the AssayType is ColloidalStability AND the Temperature is NOT 25 C AND AssayFormFactor is Capillary *)
    And[
      MatchQ[resolvedAssayType,dilutionAssayTypeP],
      Not[EqualQ[suppliedTemperature,25*Celsius]],
      MatchQ[resolvedAssayFormFactor,Capillary]
    ],

    (* THEN the AssayType and Temperature options are invalid *)
    {AssayType,Temperature},

    (* ELSE they're fine *)
    {}
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[invalidTemperatureOptions]>0&&messages,
    Message[Error::InvalidDLSTemperature,ObjectToString[resolvedAssayType],ObjectToString[suppliedTemperature],ObjectToString[resolvedInstrument]]
  ];

  (* Define the tests the user will see for the above message *)
  invalidTemperatureTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidTemperatureOptions]==0,
        Nothing,
        Test["The AssayType, "<>ToString[resolvedAssayType]<>", and the Temperature, "<>ToString[suppliedTemperature]<>", are in conflict. The Temperature must be set to 25 Celsius for ColloidalStability assays when the Instrument is of Model[Instrument,MultimodeSpectrophotometer]:",True,False]
      ];
      passingTest=If[Length[invalidTemperatureOptions]>0,
        Nothing,
        Test["The AssayType is ColloidalStability and the Temperature is 25 Celsius or the Instrument is not of Model[Instrument,MultimodeSpectrophotometer]:",True,True]
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];




  (* - Throw an Error if AutomaticLaserSettings is in conflict with the LaserPower or  DiodeAttenuation options - *)
  {invalidLaserSettingsOptionNames,invalidLaserSettingOptionValues}=Switch[{suppliedAutomaticLaserSettings,resolvedLaserPower,resolvedDiodeAttenuation},

    (* First, test cases where they are fine *)
    (* If AutomaticLaserSettings is True, the other two options must be Null *)
    {True,Null,Null},
      {{},{}},

    (* If AutomaticLaserSettings is False, the other top options cant be Null *)
    {False,Except[Null],Except[Null]},
      {{},{}},

    (* Otherwise there are some invalid options *)
    (* If the AutomaticLaserSettings is True, the options that are not Null are invalid *)
    {True,_,_},
      {
        Join[
          {AutomaticLaserSettings},
          PickList[{LaserPower,DiodeAttenuation},{resolvedLaserPower,resolvedDiodeAttenuation},Except[Null]]
        ],
        Join[
          {suppliedAutomaticLaserSettings},
          Cases[{resolvedLaserPower,resolvedDiodeAttenuation},Except[Null]]
        ]
      },

    (* If the AutomaticLaserSettings is False, the options that are Null are invalid *)
    {False,_,_},
      {
        Join[
          {AutomaticLaserSettings},
          PickList[{LaserPower,DiodeAttenuation},{resolvedLaserPower,resolvedDiodeAttenuation},Null]
        ],
        Join[
          {suppliedAutomaticLaserSettings},
          Cases[{resolvedLaserPower,resolvedDiodeAttenuation},Null]
        ]
      }
  ];

  (* If we are throwing messages, throw the Error *)
  If[Length[invalidLaserSettingsOptionNames]>0&&messages,
    Message[Error::DLSConflictingLaserSettings,ObjectToString[invalidLaserSettingsOptionNames],ObjectToString[invalidLaserSettingOptionValues]]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingLaserSettingsTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidLaserSettingsOptionNames]==0,
        Nothing,
        Test["The following laser settings related options, "<>ToString[invalidLaserSettingsOptionNames]<>", with values of "<>ToString[invalidLaserSettingOptionValues]<>", are in conflict. When AutomaticLaserSettings is True, the LaserPower and DiodeAttenuation must both be Null. When AutomaticLaserSettings is False, the LaserPower and DiodeAttenuation should be specified as a percentage. Please ensure that these options are not in conflict, or consider letting them resolve automatically:",True,False]
      ];
      passingTest=If[Length[passingNoAnalyteConcentrationSamples]==0,
        Nothing,
        Test["The AutomaticLaserSettings, LaserPower, and DiodeAttenuation options are not in conflict:",True,True]
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw a Warning if there is more than one Analyte with a concentration present in the Composition - *)
  (* Set the Warning Booleans *)
  tooManyAnalytesWarnings=MapThread[
      Switch[{#1,#2},

        (* If the user has specified the Analyte, we do not throw the Warning *)
        {Except[Automatic],_},
          False,

        (* If we more than one Analyte, and the user has not specified the Analyte, we throw the Warning *)
        {_,{{MassConcentrationP,_},{MassConcentrationP,_}..}},
          True,

        (* In all other cases, we don't *)
        {_,_},
          False
      ]&,
    {suppliedAnalyte,compositionAnalytesAndMassConcentrations}
  ];

  (* Figure out if we need to throw this Warning *)
  tooManyAnalytesWarningQ=MemberQ[tooManyAnalytesWarnings,True]&&MatchQ[resolvedAssayType,dilutionAssayTypeP];

  (* Create lists of the input samples that have the tooManyAnalytesWarnings set to True and to False *)
  failingTooManyAnalytesSamples=PickList[simulatedSamples,tooManyAnalytesWarnings,True];
  passingTooManyAnalytesSamples=PickList[simulatedSamples,tooManyAnalytesWarnings,False];

  (* Create a list of the failing samples' Compositions *)
  failingTooManyAnalytesCompositions=PickList[sampleCompositions,tooManyAnalytesWarnings,True];

  (* Create a list of the most concentrated Analytes when there are multiple Analytes *)
  mostConcentratedAnalytes=Switch[{resolvedAssayType,#},

    (* IF we are not in a dilution Assay Type, return set to Null *)
    {nonDilutionAssayTypeP,_},
      Null,

    (* If we more than one Analyte, and they each have an associated mass concentration, then find the Analyte with the highest concentration *)
    {_,{{MassConcentrationP,_},{MassConcentrationP,_}..}},
      LastOrDefault[LastOrDefault[Sort[#]]],

    (* In all other cases, set to Null *)
    {_,_},
      Null
  ]&/@compositionAnalytesAndMassConcentrations;

  (* From this list of mostConcentratedAnalytes, choose the ones (should be all non-Null) for which tooManyAnalytesWarnings is True *)
  failingMostConcentratedAnalytes=PickList[mostConcentratedAnalytes,tooManyAnalytesWarnings,True];

  (* If tooManyAnalytesWarningQ is True and we are throwing Messages, throw a Warning *)
  If[tooManyAnalytesWarningQ&&messages&&notInEngine,
    Message[Warning::DLSMoreThanOneCompositionAnalyte,resolvedAssayType,ObjectToString[failingTooManyAnalytesSamples,Cache->cacheBall],ObjectToString[failingTooManyAnalytesCompositions,Cache->cacheBall],ObjectToString[failingMostConcentratedAnalytes,Cache->cacheBall]]
  ];

  (* Define the tests the user will see for the above message *)
  tooManyAnalytesTests=If[gatherTests&&MatchQ[resolvedAssayType,dilutionAssayTypeP],
    Module[{failingTest,passingTest},
      failingTest=If[Not[tooManyAnalytesWarningQ],
        Nothing,
        Warning["The AssayType is ColloidalStability and for the following input samples, "<>ObjectToString[failingTooManyAnalytesSamples,Cache->cacheBall]<>", the Analyte option has not been specified, and they have more than one Analyte in their Composition fields:",True,False]
      ];
      passingTest=If[Length[passingTooManyAnalytesSamples]==0,
        Nothing,
        Warning["The AssayType is ColloidalStability, and the following input samples, "<>ObjectToString[passingTooManyAnalytesSamples,Cache->cacheBall]<>", have only one Analyte in their Composition fields:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw a Warning if the AssayType is ColloidalStability and any of the Analyte components are more concentrated than 25 mg/mL - *)
  (* Figure out if we need to throw the warning, and which Analytes are too concentrated for each input *)
  {tooConcentratedAnalyteWarnings,tooConcentratedAnalytes,highAnalyteConcentrations}=Transpose[
    Map[
      Module[{concentratedTuples,warningBool,concentratedAnalytes,highConcentrations},

        (* Find the Cases of the list   *)
        concentratedTuples=Cases[#,{GreaterP[25*(Milligram/Milliliter)],_}];

        (* Set the Warning Bool *)
        warningBool=If[Length[concentratedTuples]==0,
          False,
          True
        ];

        (* Find the Analytes that have larger than 25 mg/mL concentrations, and their corresponding concentrations*)
        {highConcentrations,concentratedAnalytes}=If[

          (* If there are no Analytes that are too concentrated *)
          MatchQ[concentratedTuples,{}],

          (* THEN return Null for each *)
          {Null,Null},

          (* ELSE, get the Analytes and their concentrations *)
          {
            concentratedTuples[[All,1]],
            concentratedTuples[[All,2]]
          }
        ];

        (* Return the boolean, the Analytes, and their concentrations *)
        {warningBool,concentratedAnalytes,highConcentrations}
      ]&,
      compositionAnalytesAndMassConcentrations
    ]
  ];

  (* --- Tests to ensure that supplied AssayType is not in conflict with any other supplied options --- *)
  (* -- First, we are going to set a bunch of booleans to indicate whether any of the specified options suggest how the AssayType will be specified -- *)
  (* - To do this, we will set variables that are lists of the options that indicate a certain AssayType - *)
  (* Isothermal Stability Options *)
  isothermalStabilityOptionNames={
    MeasurementDelayTime,IsothermalMeasurements,IsothermalRunTime,IsothermalAttenuatorAdjustment
  };
  isothermalStabilitySuppliedOptions=Lookup[roundedExperimentOptions,isothermalStabilityOptionNames];

  (* ColloidalStability Options *)
  colloidalStabilityOptionNames={
    ReplicateDilutionCurve,StandardDilutionCurve,SerialDilutionCurve,Buffer,DilutionMixType,DilutionMixVolume,DilutionNumberOfMixes,
    DilutionMixRate,DilutionMixInstrument,BlankBuffer,Analyte,AnalyteMassConcentration
  };
  colloidalStabilitySuppliedOptions=Lookup[roundedExperimentOptions,colloidalStabilityOptionNames];

  (* Melting Curve Options*)
  meltingCurveOptionNames={
    MinTemperature,
    MaxTemperature,
    TemperatureRampOrder,
    NumberOfCycles,
    TemperatureRamping,
    TemperatureRampRate,
    TemperatureResolution,
    NumberOfTemperatureRampSteps,
    StepHoldTime
  };
  meltingCurveSuppliedOptions=Lookup[roundedExperimentOptions,meltingCurveOptionNames];

  (* - Set Booleans if any of the options that indicate a specific AssayType will be set are specified as non Null/Automatic - *)
  isothermalStabilityOptionsSpecifiedQ=MemberQ[isothermalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic]]];
  colloidalStabilityOptionsSpecifiedQ=MemberQ[colloidalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic,{Alternatives[Null,Automatic]..}]]];
  meltingCurveOptionsSpecifiedQ=MemberQ[meltingCurveSuppliedOptions,Except[Alternatives[Null,Automatic]]];

  (* -- Next, we are going to make lists of the option names and the supplied options of the above groups of options that are specified as non Null|Automatic -- *)
  (* Specified options *)
  specifiedIsothermalStabilityOptions=Cases[isothermalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic]]];
  specifiedColloidalStabilityOptions=Cases[colloidalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic,{Alternatives[Null,Automatic]..}]]];
  specifiedMeltingCurveOptions=Cases[meltingCurveSuppliedOptions,Except[Alternatives[Null,Automatic]]];

  (* Specified option Names *)
  specifiedIsothermalStabilityOptionNames=PickList[isothermalStabilityOptionNames,isothermalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic]]];
  specifiedColloidalStabilityOptionNames=PickList[colloidalStabilityOptionNames,colloidalStabilitySuppliedOptions,Except[Alternatives[Null,Automatic,{Alternatives[Null,Automatic]..}]]];
  specifiedMeltingCurveOptionNames=PickList[meltingCurveOptionNames,meltingCurveSuppliedOptions,Except[Alternatives[Null,Automatic]]];

  (* --- Tests to ensure that supplied AssayType is not in conflict with any other Null options --- *)
  (* -- First, we are going to set a bunch of booleans to indicate whether any of the Null options suggest how the AssayType will be specified -- *)
  (* - To do this, we will set variables that are lists of the options that are specific to a given AssayType and CANNOT BE NULL - *)
  (* IsothermalStability Options *)
  essentialIsothermalStabilityOptionNames={
    MeasurementDelayTime,IsothermalAttenuatorAdjustment
  };
  essentialIsothermalStabilitySuppliedOptions={
    suppliedMeasurementDelayTime,suppliedIsothermalAttenuatorAdjustment
  };

  (* Colloidal Stability Options *)
  essentialColloidalStabilityOptionNames={
    NumberOfReplicates,ReplicateDilutionCurve,Buffer,BlankBuffer,Analyte,AnalyteMassConcentration
  };
  essentialColloidalStabilitySuppliedOptions={
    suppliedNumberOfReplicates,suppliedReplicateDilutionCurve,suppliedBuffer,suppliedBlankBuffer,suppliedAnalyte,
    suppliedAnalyteMassConcentration
  };

  (* Melting Curve Options *)
  essentialMeltingCurveOptionNames={
    MinTemperature,MaxTemperature,TemperatureRampOrder,NumberOfCycles,TemperatureRamping,TemperatureRampRate,TemperatureResolution
  };
  essentialMeltingCurveSuppliedOptions={
    suppliedMinTemperature,suppliedMaxTemperature,suppliedTemperatureRampOrder,suppliedNumberOfCycles,suppliedTemperatureRamping,suppliedTemperatureRampRate,suppliedTemperatureResolution
  };

  (* - Set Booleans if any of the options that indicate if any options that are essential for a given AssayType have been set by the User as Null - *)
  essentialIsothermalStabilityOptionsNullQ=MemberQ[essentialIsothermalStabilitySuppliedOptions,Null];
  essentialColloidalStabilityOptionsNullQ=MemberQ[essentialColloidalStabilitySuppliedOptions,Alternatives[Null,{___,Null,___}]];
  essentialMeltingCurveOptionsNullQ=MemberQ[essentialMeltingCurveSuppliedOptions,Null];

  (* -- Next, we are going to make lists of the option names and the supplied options of the above essential groups of options that are specified as Null -- *)
  (* Specified options *)
  nullEssentialIsothermalStabilityOptions=Cases[essentialIsothermalStabilitySuppliedOptions,Null];
  nullEssentialColloidalStabilityOptions=Cases[essentialColloidalStabilitySuppliedOptions,Alternatives[Null,{___,Null,___}]];
  nullEssentialMeltingCurveOptions=Cases[essentialMeltingCurveSuppliedOptions,Null];

  (* Specified option Names *)
  nullEssentialIsothermalStabilityOptionNames=PickList[essentialIsothermalStabilityOptionNames,essentialIsothermalStabilitySuppliedOptions,Null];
  nullEssentialColloidalStabilityOptionNames=PickList[essentialColloidalStabilityOptionNames,essentialColloidalStabilitySuppliedOptions,Alternatives[Null,{___,Null,___}]];
  nullEssentialMeltingCurveOptionNames=PickList[essentialMeltingCurveOptionNames,essentialMeltingCurveSuppliedOptions,Null];

  (* -- Throw an Error if the resolved AssayType is in conflict with any of the supplied (or resolved?) options -- *)
  (* - Set the lists of invalid options and option names for when a resolved AssayType and other specified options are in conflict - *)
  {assayTypeInvalidOptions,assayTypeInvalidOptionsExceptType,suppliedAssayTypeInvalidOptionsExceptType}=Module[
    {
      allInvalidOptionNames,invalidOptionNamesExceptType,invalidSuppliedOptionsExceptType
    },

    (* Define any of the supplied options that are in conflict with the supplied AssayType *)
    {invalidOptionNamesExceptType,invalidSuppliedOptionsExceptType}=Switch[resolvedAssayType,

      (* When AssayType is SizingPolydispersity, any options that are specified suggesting a different AssayType are in conflict with it *)
      SizingPolydispersity,
      {
        Join[specifiedIsothermalStabilityOptionNames,specifiedColloidalStabilityOptionNames,specifiedMeltingCurveOptionNames],
        Join[specifiedIsothermalStabilityOptions,specifiedColloidalStabilityOptions,specifiedMeltingCurveOptions]
      },

      (* When AssayType is Isothermal stability, any of the ColloidalStability or MeltingCurve options that are specified are in conflict with it *)
      IsothermalStability,
      {
        Join[specifiedColloidalStabilityOptionNames,specifiedMeltingCurveOptionNames],
        Join[specifiedColloidalStabilityOptions,specifiedMeltingCurveOptions]
      },

      (* When AssayType is ColloidalStability, any of the MeltingCurve or IsothermalStability options that are specified are in conflict with it *)
      dilutionAssayTypeP,
      {
        Join[specifiedIsothermalStabilityOptionNames,specifiedMeltingCurveOptionNames],
        Join[specifiedIsothermalStabilityOptions,specifiedMeltingCurveOptions]
      },

      (* When AssayType is MeltingCurve, any of the ColloidalStability or IsothermalStability options that are specified are in conflict with it *)
      MeltingCurve,
      {
        Join[specifiedColloidalStabilityOptionNames,specifiedIsothermalStabilityOptionNames],
        Join[specifiedColloidalStabilityOptions,specifiedIsothermalStabilityOptions]
      }
    ];

    (* If any of the options are invalid, add the AssayType to the list of invalid names for the Error message *)
    allInvalidOptionNames=If[Length[invalidOptionNamesExceptType]>0,
      Prepend[invalidOptionNamesExceptType,AssayType],
      invalidOptionNamesExceptType
    ];

    (* Return the lists in order *)
    {allInvalidOptionNames,invalidOptionNamesExceptType,invalidSuppliedOptionsExceptType}
  ];

  (* Create a list of the AssayTypes that are suggested from the invalidOptionNamesExceptType *)
  suggestedAssayTypes=Which[

    (* If there are none of these invalid options, set as Null, there will be no error thrown *)
    MatchQ[assayTypeInvalidOptionsExceptType,{}],
      Null,

    (* ELSE, figure out which AssayTypes are suggested by the other options *)
    (* Case where some specified options suggest both IsothermalStability and ColloidalStability *)
    MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@isothermalStabilityOptionNames]&&MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@colloidalStabilityOptionNames],
      {IsothermalStability,ColloidalStability},

    (* Case where some specified options suggest both IsothermalStability and MeltingCurve *)
    MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@isothermalStabilityOptionNames]&&MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@meltingCurveOptionNames],
    {IsothermalStability,MeltingCurve},

    (* Case where some specified options suggest both ColloidalStability and MeltingCurve *)
    MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@colloidalStabilityOptionNames]&&MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@meltingCurveOptionNames],
    {ColloidalStability,MeltingCurve},

    (* Case where some specified options suggest IsothermalStability *)
    MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@isothermalStabilityOptionNames],
      {IsothermalStability},

    (* Case where some specified options suggest ColloidalStability *)
    MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@colloidalStabilityOptionNames],
      {ColloidalStability},

    (* Case where some specified options suggest MeltingCurve *)
    MemberQ[assayTypeInvalidOptionsExceptType,Alternatives@@meltingCurveOptionNames],
      {MeltingCurve}
  ];

  (* If there are any assayTypeInvalidOptions and we are throwing Messages, throw an Error *)
  If[Length[assayTypeInvalidOptions]>0&&messages,
    Message[Error::ConflictingDLSAssayTypeOptions,ObjectToString[resolvedAssayType],ObjectToString[assayTypeInvalidOptionsExceptType],ObjectToString[suppliedAssayTypeInvalidOptionsExceptType],ObjectToString[suggestedAssayTypes]]
  ];

  (* Define the tests the user will see for the above message *)
  invalidAssayTypeTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[assayTypeInvalidOptions]==0,
        Nothing,
        Test["The resolved AssayType, "<>ToString[suppliedAssayType]<>", is in conflict with the following options which suggest a different AssayType, "<>ToString[assayTypeInvalidOptionsExceptType]<>", which have been specified as "<>ToString[suppliedAssayTypeInvalidOptionsExceptType]<>". Ensure that the specified AssayType is not in conflict with other specified options, or consider letting these options resolve automatically.",True,False]
      ];
      passingTest=If[Length[assayTypeInvalidOptions]>0,
        Nothing,
        Test["The AssayType is either not in conflict with any other specified options:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- Set the lists of invalid options and option names for when a resolved AssayType and related options specified as Null are in conflict -- *)
  {assayTypeInvalidNullOptions,assayTypeInvalidNullOptionsExceptType,suppliedAssayTypeInvalidNullOptionsExceptType}=Module[
    {
      allInvalidOptionNames,invalidOptionNamesExceptType,invalidSuppliedOptionsExceptType
    },

    (* Define any of the supplied options that are in conflict with the supplied AssayType *)
    {invalidOptionNamesExceptType,invalidSuppliedOptionsExceptType}=Switch[resolvedAssayType,

      (* When AssayType is SizingPolydispersity, no Null options are in conflict with it *)
      SizingPolydispersity,
      {{},{}},

      (* When AssayType is Isothermal stability, any essential IsothermalStability options set to Null are in conflict with it *)
      IsothermalStability,
      {nullEssentialIsothermalStabilityOptionNames,nullEssentialIsothermalStabilityOptions},

      (* When AssayType is ColloidalStability, any essential ColloidalStability options set to Null are in conflict with it *)
      ColloidalStability,
      {nullEssentialColloidalStabilityOptionNames,nullEssentialColloidalStabilityOptions},

      (* When AssayType is MeltingCurve, any essential MeltingCurve options set to Null are in conflict with it *)
      MeltingCurve,
      {nullEssentialMeltingCurveOptionNames,nullEssentialMeltingCurveOptions}
    ];

    (* If any of the options are invalid, add the AssayType to the list of invalid names for the Error message *)
    allInvalidOptionNames=If[Length[invalidOptionNamesExceptType]>0,
      Prepend[invalidOptionNamesExceptType,AssayType],
      invalidOptionNamesExceptType
    ];

      (* Return the lists in order *)
      {allInvalidOptionNames,invalidOptionNamesExceptType,invalidSuppliedOptionsExceptType}
    ];

  (* If there are any assayTypeInvalidNullOptions and we are throwing Messages, throw an Error *)
  If[Length[assayTypeInvalidNullOptions]>0&&messages,
    Message[Error::ConflictingDLSAssayTypeNullOptions, ObjectToString[resolvedAssayType],ObjectToString[assayTypeInvalidNullOptionsExceptType]]
  ];

  (* Define the tests the user will see for the above message *)
  invalidAssayTypeNullOptionsTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[assayTypeInvalidNullOptions]==0,
        Nothing,
        Test["The resolved AssayType, "<>ToString[resolvedAssayType]<>", is in conflict with the following options which must not be Null, "<>ToString[assayTypeInvalidNullOptionsExceptType]<>", which have been specified as "<>ToString[suppliedAssayTypeInvalidNullOptionsExceptType]<>". Ensure that the specified AssayType is not in conflict with other Null options, or consider letting these options resolve automatically.",True,False]
      ];
      passingTest=If[Length[assayTypeInvalidNullOptions]>0,
        Nothing,
        Test["The AssayType is not in conflict with any Null options:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw an Error if the suppliedAssayContainerFillDirection and suppliedCapillaryLoading options are in conflict - *)
  invalidDLSManualLoadingDirectionOptions=If[
    (* If CapillaryLoading is Manual and AssayFormFactor is Capillary, we can't load by Row *)
    MatchQ[resolvedCapillaryLoading,Manual] && MatchQ[suppliedAssayContainerFillDirection,Row] && MatchQ[resolvedAssayFormFactor,Capillary],
      {CapillaryLoading, AssayContainerFillDirection},
      {}
  ];

  (* If there are any invalidDLSManualLoadingDirectionOptions and we are throwing Messages, throw an Error *)
  If[Length[invalidDLSManualLoadingDirectionOptions]>0&&messages,
    Message[Error::DLSManualLoadingByRow]
  ];

  (* Define the tests the user will see for the above message *)
  conflictingDLSManualLoadingDirectionOptionsTests=If[gatherTests&&MatchQ[suppliedCapillaryLoading, Manual],
    Module[{failingTest,passingTest},
      failingTest=If[Length[invalidDLSManualLoadingDirectionOptions]==0,
        Nothing,
        Test["AssayContainerFillDirection is compatible with CapillaryLoading, when CapillaryLoading is set to Manual and the Instrument is of Model[Instrument,MultimodeSpectrophotometer]",True,False]
      ];
      passingTest=If[Length[invalidDLSManualLoadingDirectionOptions]>0,
        Nothing,
        Test["AssayContainerFillDirection is compatible with CapillaryLoading, when CapillaryLoading is set to Manual and the Instrument is of Model[Instrument,MultimodeSpectrophotometer].",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument -- *)
  {compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
    CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Cache->cacheBall,Output->{Result,Tests}],
    {CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Cache->cacheBall,Messages->messages],{}}
  ];

  (* If the materials are incompatible, then the Instrument is invalid *)
  compatibleMaterialsInvalidOption=If[Not[compatibleMaterialsBool]&&messages,
    {Instrument},
    {}
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs=DeleteDuplicates[Flatten[
    {
      discardedInvalidInputs,tooManyInvalidInputs
    }
  ]];
  invalidOptions=DeleteDuplicates[Flatten[
    {
      compatibleMaterialsInvalidOption,nameInvalidOption,invalidUnsupportedInstrumentOption,assayTypeInvalidOptions,
      assayTypeInvalidNullOptions,invalidConflictingIsothermalRunOptions,
      invalidSampleVolumeOptions,invalidDelayTimeOptionNames,invalidIsothermalMeasurementTimeOptions,
      invalidTooLongIsothermalOptions,invalidConflictingDilutionMixOptions,conflictingDilutionCurveOptions,invalidPlateMaxVolumeOptions,
      invalidDilutionMixMinVolumeOptions,notEnoughDilutionVolumeInvalidOptions,invalidOccupiedPlateOptions,onlyOneDilutionCurveOptions,
      invalidTooManyDilutionSamplesOptions,invalidLaserSettingsOptionNames,noAnalyteInvalidOptions,invalidAnalyteOptions,
      invalidNoAnalyteConcentrationOptions,invalidTemperatureOptions,invalidDLSManualLoadingDirectionOptions,invalidMinMaxTemperatureOptions,invalidFormFactorInstrumentOptions,invalidFormFactorLoadingPlateOptions,invalidFormFactorCapillaryOptions,invalidFormFactorPlateStorageOptions,invalidFormFactorWellCoverOptions,invalidFormFactorWellCoverHeatingOptions,invalidTooLowSampleVolumeOptions,invalidConflictingRampOptions,invalidConflictingDilutionMixTypeInstrument,invalidConflictingDilutionMixTypeOptions
    }
  ]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* --- CONTAINER GROUPING RESOLUTION --- *)
  (* - Figure out the minimum amount of each input sample that we need to perform the experiment - *)
  minimumRequiredVolumePerSample=If[

    (* IF the AssayType is SizingPolyDispersity or IsothermalStability *)
    MatchQ[resolvedAssayType,nonDilutionAssayTypeP],

    (* THEN, we make a list index-matched to samples in that is the SampleVolume, with Null replaced by 0 uL *)
    ConstantArray[resolvedSampleVolume,numberOfSamples]/.{Null->0*Microliter},

    (* ELSE, we need to calculate how much sample we need *)
    MapThread[
      Switch[{#1,#2,resolvedReplicateDilutionCurve,resolvedNumberOfReplicates},

        (* If NumberOfReplicates is Null, we have thrown an error, set to 0 uL *)
        {_,_,_,Null},
          0*Microliter,

        (* If ReplicateDilutionCurve is Null, we have thrown an error, set to 0 uL *)
        {_,_,Null,_},
          0*Microliter,

        (* If both the StandardDilutionCurve and SerialDilutionCurve are Null, we will have thrown an error, set to 0 uL *)
        {{Null,Null},{Null,Null},_,_},
          0*Microliter,

        (* *Cases where the StandardDilutionCurve is specified* *)
        (* And the ReplicateDilutionCurve is False, Add up the SampleVolumes *)
        {Except[{Null,Null}],_,False,_},
          Total[First[#1]],

        (* And the ReplicateDilutionCurve is True (or Null), Add up the SampleVolumes and multiply by the NumberOfReplicates *)
        {Except[{Null,Null}],_,_,_},
          (Total[First[#1]]*resolvedNumberOfReplicates),

        (* *Cases where the SerialDilutionCurve is specified* *)
        (* And the ReplicateDilutionCurve is False, the amount needed is the first TransferVolume *)
        {_,Except[{Null,Null}],False,_},
          First[First[#2]],

        (* And the ReplicateDilutionCurve is True (or Null), the amount needed is the first TransferVolume times the NumberOfReplicates *)
        {_,Except[{Null,Null}],_,_},
          (First[First[#2]]*resolvedNumberOfReplicates)
      ]&,
      {standardDilutionCurveVolumes,serialDilutionCurveVolumes}
    ]
  ];

  (* Next, add a fixed amount (10 uL for now) to each volume to give a buffer *)
  requiredAliquotVolumes=(minimumRequiredVolumePerSample+10*Microliter);

  (* - Make a list of the smallest liquid handler compatible container that can potentially hold the needed volume for each sample - *)
  (*Make a list of liquid handler compatible containers*)
  liquidHandlerContainers = hamiltonAliquotContainers["Memoization"];

  (* First, find the Models and the MaxVolumes of the liquid handler compatible containers *)
  liquidHandlerContainerModels=fastAssocLookup[fastAssoc,#,Object]&/@liquidHandlerContainers;
  liquidHandlerContainerMaxVolumes=fastAssocLookup[fastAssoc,#,MaxVolume]&/@liquidHandlerContainers;

  (* Define the container we would transfer into for each sample, if Aliquotting needed to happen *)
  potentialAliquotContainers=First[
    PickList[
      liquidHandlerContainerModels,
      liquidHandlerContainerMaxVolumes,
      GreaterEqualP[#]
    ]
  ]&/@requiredAliquotVolumes;

  (* Find the ContainerModel for each input sample *)
  simulatedSamplesContainerModels=Lookup[#,Object,{}]&/@Flatten[sampleContainerModelPackets];

  (* Define the RequiredAliquotContainers - we have to aliquot if the samples are not in a liquid handler compatible container *)
  requiredAliquotContainers=MapThread[
    If[
      MatchQ[#1,Alternatives@@liquidHandlerContainerModels],
      Automatic,
      #2
    ]&,
    {simulatedSamplesContainerModels,potentialAliquotContainers}
  ];

  (* -- Resolve Aliquot Options -= *)
  (* Call resolveAliquotOptions *)
  {resolvedAliquotOptions,aliquotTests}=Which[

    (*If we're already in the assay container, we should not be running this*)
    MatchQ[simulatedSamplesContainerModels,{dlsAssayContainerP..}],
    {
      {
        Aliquot->{False},
        AliquotSampleLabel->Null,
        AliquotAmount->ConstantArray[Null,Length[mySamples]],
        TargetConcentration->Null,
        TargetConcentrationAnalyte->Null,
        AssayVolume->Null,
        ConcentratedBuffer->Null,
        BufferDilutionFactor->Null,
        BufferDiluent->Null,
        AssayBuffer->Null,
        AliquotSampleStorageCondition->Null,
        DestinationWell->Null,
        AliquotContainer->Null,
        AliquotPreparation->Null,
        ConsolidateAliquots->Null
      },
      {}
    },

    gatherTests,
    (* Case where output includes tests *)
    resolveAliquotOptions[
      ExperimentDynamicLightScattering,
      mySamples,
      simulatedSamples,
      ReplaceRule[allOptionsRounded,Join[resolvedSamplePrepOptions, {NumberOfReplicates -> If[MatchQ[resolvedAssayType,ColloidalStability],1,resolvedNumberOfReplicates], ConsolidateAliquots->True}]],
      Cache->cacheBall,
      RequiredAliquotContainers->requiredAliquotContainers,
      RequiredAliquotAmounts->requiredAliquotVolumes,
      AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
      AllowSolids->False,
      Output->{Result,Tests}
    ],

    (* Case where we are not gathering tests  *)
    True,
    {
      resolveAliquotOptions[
        ExperimentDynamicLightScattering,
        mySamples,
        simulatedSamples,
        ReplaceRule[allOptionsRounded,Join[resolvedSamplePrepOptions, {NumberOfReplicates -> If[MatchQ[resolvedAssayType,ColloidalStability],1,resolvedNumberOfReplicates], ConsolidateAliquots->True}]],
        Cache->cacheBall,
        RequiredAliquotContainers->requiredAliquotContainers,
        RequiredAliquotAmounts->requiredAliquotVolumes,
        AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
        AllowSolids->False,
        Output->Result
      ],{}
    }
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

  (* Define the Resolved Options *)
  resolvedOptions=ReplaceRule[
    allOptionsRounded,
    Join[
      resolvedSamplePrepOptions,
      resolvedAliquotOptions,
      resolvedPostProcessingOptions,
      {
        AssayType->resolvedAssayType,
        AssayFormFactor->resolvedAssayFormFactor,
        Instrument->resolvedInstrument,
        SampleLoadingPlate->resolvedSampleLoadingPlate,
        LaserPower->resolvedLaserPower,
        DiodeAttenuation->resolvedDiodeAttenuation,
        NumberOfAcquisitions->resolvedNumberOfAcquisitions,
        CapillaryLoading->resolvedCapillaryLoading,
        SampleLoadingPlateStorageCondition->resolvedSampleLoadingPlateStorageCondition,
        NumberOfReplicates->resolvedNumberOfReplicates,
        ColloidalStabilityParametersPerSample->resolvedColloidalStabilityParametersPerSample,
        SampleVolume->resolvedSampleVolume,
        ReplicateDilutionCurve->resolvedReplicateDilutionCurve,
        Analyte->resolvedAnalyte,
        AnalyteMassConcentration->resolvedAnalyteMassConcentration,
        StandardDilutionCurve->resolvedStandardDilutionCurve,
        SerialDilutionCurve->resolvedSerialDilutionCurve,
        Buffer->resolvedBuffer,
        DilutionMixType->resolvedDilutionMixType,
        DilutionMixVolume->resolvedDilutionMixVolume,
        DilutionNumberOfMixes->resolvedDilutionNumberOfMixes,
        DilutionMixRate->resolvedDilutionMixRate,
        DilutionMixInstrument->resolvedDilutionMixInstrument,
        BlankBuffer->resolvedBlankBuffer,
        CalculateMolecularWeight->resolvedCalculateMolecularWeight,
        MeasurementDelayTime->resolvedMeasurementDelayTime,
        IsothermalMeasurements->resolvedIsothermalMeasurements,
        IsothermalRunTime->resolvedIsothermalRunTime,
        IsothermalAttenuatorAdjustment->resolvedIsothermalAttenuatorAdjustment,
        MinTemperature->resolvedMinTemperature,
        MaxTemperature->resolvedMaxTemperature,
        TemperatureRampOrder->resolvedTemperatureRampOrder,
        NumberOfCycles->resolvedNumberOfCycles,
        TemperatureRamping->resolvedTemperatureRamping,
        TemperatureRampRate->resolvedTemperatureRampRate,
        TemperatureResolution->resolvedTemperatureResolution,
        NumberOfTemperatureRampSteps->resolvedNumberOfTemperatureRampSteps,
        StepHoldTime->resolvedStepHoldTime,
        WellCover->resolvedWellCover,
        WellCoverHeating->resolvedWellCoverHeating,
        SamplesInStorageCondition->resolvedSamplesInStorageConditions,
        SamplesOutStorageCondition->resolvedSamplesOutStorageCondition
      }
    ]
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Cases[
      Flatten[
        {
          discardedTests,standardDilutionCurvePrecisionTests,serialDilutionPrecisionTests,optionPrecisionTests,compatibleMaterialsTests,
          validNameTest,validInstrumentTests,invalidAssayTypeTests,
          invalidAssayTypeNullOptionsTests,conflictingIsothermalRunOptionsTests,
          lowReplicateConcentrationTests,invalidSampleVolumeTests,invalidResolvedAssayTypeNullOptionsTests,invalidMeasurementDelayTimeTests,
          conflictingIsothermalIsothermalTimeTests,tooLongIsothermalAssayTests,conflictingDilutionMixTests,bufferNotSpecifiedTests,
          conflictingDilutionCurveTests,bufferBlankBufferTests,dilutionVolumePlateMismatchTests,dilutionCurveMixVolumeMismatchTests,
          notEnoughDilutionVolumeTests,occupiedSampleLoadingPlateTests,nonDefaultLoadingPlateTests,onlyOneDilutionConcentrationTests,
          tooManySamplesTests,tooManyDilutionSamplesTests,noAnalyteTests,noAnalyteConcentrationTests,tooManyAnalytesTests,
          noAnalyteMWTests,tooConcentratedAnalyteTests,conflictingLaserSettingsTests,invalidTemperatureTests,
          conflictingDLSManualLoadingDirectionOptionsTests,aliquotTests,minMaxTemperatureMismatchTests,conflictingDLSFormFactorInstrumentTest,conflictingDLSFormFactorLoadingPlateTest,conflictingDLSFormFactorCapillaryLoadingTest,conflictingDLSFormFactorPlateStorageTest,conflictingFormFactorWellCoverTest,conflictingFormFactorWellCoverHeatingTest,tooLowSampleVolumeTest,conflictingRampOptionsTest,conflictingDilutionMixTypeOptionsTests,conflictingDilutionMixTypeInstrumentTests
        }
      ]
      ,_EmeraldTest
    ]
  }
];

(* ::Subsubsection:: *)
(* resolveDynamicLightScatteringMethod *)

(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveDynamicLightScatteringMethod,
  SharedOptions:>{
    ExperimentDynamicLightScattering,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

(* Error message for resolveDynamicLightScatteringMethod*)
Error::ConflictingDynamicLightScatteringMethodRequirements="The following option(s)/input(s) were specified that require a Manual Preparation method, `1`. However, the following option(s)/input(s) were specified that require a Robotic Preparation method, `2`. Please resolve this conflict in order to submit a valid DynamicLightScattering protocol.";

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with *)
(* the given options. *)
resolveDynamicLightScatteringMethod[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}]|Automatic], myOptions : OptionsPattern[]] := Module[
  {outputSpecification,output,safeOps,gatherTests,resolvedPreparation,manualRequirementStrings,roboticRequirementStrings,result,tests},

  (* Generate the output specification*)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Check if we gather test *)
  gatherTests = MemberQ[output,Tests];

  (* get the safe options *)
  safeOps = SafeOptions[resolveDynamicLightScatteringMethod, ToList[myOptions]];

  (* Resolve the sample preparation methods *)
  resolvedPreparation=If[
    MatchQ[Lookup[safeOps,Preparation],Except[Automatic]],
    Lookup[safeOps,Preparation],
    {Manual}
  ];


  (* make a boolean for if it is ManualSamplePreparation or not *)
  (* Create a list of reasons why we need Preparation->Manual. *)
  manualRequirementStrings={
    "ExperimentDynamicLightScattering can only be done manually."
  };

  (* Create a list of reasons why we need Preparation->Robotic. *)
  roboticRequirementStrings={
    If[MemberQ[ToList[Lookup[safeOps, Preparation]], Robotic],
      "the Preparation option is set to Robotic by the user",
      Nothing
    ]
  };

  (* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
  If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
    Block[{$MessagePrePrint},
      Message[
        Error::ConflictingUnitOperationMethodRequirements,
        listToString[manualRequirementStrings],
        listToString[roboticRequirementStrings]
      ]
    ]
  ];

  (* Return our result and tests. *)
  result=Which[
    MatchQ[Lookup[safeOps, Preparation], Except[Automatic]], Lookup[safeOps, Preparation],
    Length[manualRequirementStrings]>0,	Manual,
    Length[roboticRequirementStrings]>0, Robotic,
    True,{Manual, Robotic}
  ];
  tests=If[MatchQ[gatherTests, False],
    {},
    {
      Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the DynamicLightScattering primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
    }
  ];

  outputSpecification/.{Result->result, Tests->tests}

];


(* ::Subsection:: *)
(*dynamicLightScatteringResourcePackets*)

DefineOptions[
  dynamicLightScatteringResourcePackets,
  Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

(* Create the protocol with resources included *)
dynamicLightScatteringResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, myCollapsedResolvedOptions : {___Rule}, myOptions : OptionsPattern[]] := Module[
  {
    safeOps, expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, cache, simulation, fastAssoc,
    protocolID, liquidHandlerContainers, numberOfReplicates, instrument, name, assayType, sampleLoadingPlate,
    sampleVolume, replicateDilutionCurve, assayContainerFillDirection, temperature, equilibrationTime, numberOfAcquisitions, acquisitionTime,
    laserPower, diodeAttenuation, capillaryLoading, measurementDelayTime, isothermalMeasurements, isothermalRunTime, isothermalAttenuatorAdjustment,
    sampleLoadingPlateStorageCondition, parentProtocol, automaticLaserSettings, objectSamplePacketFields,
    listedSamplePackets, liquidHandlerContainerDownload, samplePackets, sampleCompositionPackets,
    listedSampleContainers, sampleContainersIn, liquidHandlerContainerMaxVolumes,
    samplesWithReplicates,
    optionsWithReplicates, expandedAliquotAmounts, expandedBuffer, expandedBlankBuffer, expandedStandardDilutionCurve,
    expandedSerialDilutionCurve, expandedSamplesInStorageCondition, samplesOutStorageCondition, expandedDilutionMixVolume, expandedDilutionNumberOfMixes, expandedDilutionMixRate,
    expandedAnalytes, expandedAnalyteMassConcentrations,
    numberOfSamplesWithReplicates, intNumberOfReplicates, expandedStandardDilutionCurveVolumes, expandedSerialDilutionCurveVolumes,
    expandedRequiredSampleVolumes, sampleVolumeRules, uniqueSampleVolumeRules, sampleResourceReplaceRules, samplesInResources,
    expandedRequiredBufferVolumes, bufferVolumeRules, blankBufferVolumeRules, allVolumeRules, uniqueObjectsAndVolumesAssociation,
    uniqueResources, uniqueObjects, uniqueObjectResourceReplaceRules, bufferResources, blankBufferResources, instrumentTime,
    instrumentResource, capillaryLoadingVolume, runTime, sampleLoadingPlateResource, manualLoadingPlateResource, numberOfAssayContainerWellsPerSample,
    requiredDilutionAssayContainerWells, numberOfAssayContainers, assayContainerResources, capillaryStripLoadingRack, capillaryClipResource,
    capillaryClipGasketResource, sampleStageLid, manualLoadingPipetteResource, manualLoadingTipsResource,
    standardDilutionCurveVolumes, serialDilutionCurveVolumes, transposedStandardDilutionCurves, transposedSerialDilutionCurves, dilutionSampleVolumes,
    dilutionFactors, dilutionConcentrations, analyteMolecularWeights, nonNullAnalyteMolecularWeights,
    analyteMolecularWeightString, protocolPacket, prepPacket, finalizedPacket, allResourceBlobs, resourcesOk, resourceTests, previewRule,
    optionsRule, testsRule, resultRule, assayFormFactor, colloidalStabilityParametersPerSample, calculateMolecularWeight,
    collectStaticLightScattering, minTemperature, maxTemperature, temperatureRampOrder, numberOfCycles, temperatureRamping,
    temperatureRampRate, temperatureResolution, numberOfTemperatureRampSteps, stepHoldTime, wellCover, wellCoverHeating,
    dilutionMixType, dilutionMixInstrument, storageConditionSymbolToModel, modelLoadingPlateStorage,unitOperationPacket,
    sampleLoadingPlateStorageConditionModel, expandedSamplesInStorageConditionSymbols, sampleContainerModelPackets,
    buffer, blankBuffer, standardDilutionCurve, serialDilutionCurve, aliquotAmounts, siscToUse, aliquotAmountsOrNulls,
    dilutionMixVolume, dilutionNumberOfMixes, dilutionMixRate, analyte, analyteMassConcentration, samplesInStorageCondition
  },

  (* get the safe options for this function *)
  safeOps = SafeOptions[dynamicLightScatteringResourcePackets, ToList[myOptions]];

  (* Expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentDynamicLightScattering, {mySamples}, myResolvedOptions];

  (* get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentDynamicLightScattering,
    RemoveHiddenOptions[ExperimentDynamicLightScattering, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  (* pull out the Output option and make it a list *)
  outputSpecification = Lookup[safeOps, Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests; if True, then silence the messages *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* lookup helper options *)
  {cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

  (* make the fast association *)
  fastAssoc = makeFastAssocFromCache[cache];

  (* Generate an ID for the new protocol *)(*todo: come back to this for Unit Operations*)
  protocolID = CreateID[Object[Protocol, DynamicLightScattering]];

  (* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
  (* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
  liquidHandlerContainers = hamiltonAliquotContainers["Memoization"];

  (* Pull out relevant non-index matched options from the re-expanded options *)
  {
    instrument, name, assayType, sampleLoadingPlate, sampleVolume, replicateDilutionCurve,
    assayContainerFillDirection, temperature, equilibrationTime, numberOfAcquisitions, acquisitionTime, laserPower, diodeAttenuation, capillaryLoading,
    measurementDelayTime, isothermalMeasurements, isothermalRunTime, isothermalAttenuatorAdjustment, sampleLoadingPlateStorageCondition,
    parentProtocol, automaticLaserSettings, assayFormFactor, colloidalStabilityParametersPerSample, calculateMolecularWeight, collectStaticLightScattering, minTemperature,
    maxTemperature, temperatureRampOrder, numberOfCycles, temperatureRamping, temperatureRampRate, temperatureResolution, numberOfTemperatureRampSteps, stepHoldTime,
    wellCover, wellCoverHeating, dilutionMixType, dilutionMixInstrument, samplesOutStorageCondition, buffer, blankBuffer, standardDilutionCurve, serialDilutionCurve,
    dilutionMixVolume, dilutionNumberOfMixes, dilutionMixRate, analyte, analyteMassConcentration, aliquotAmounts, samplesInStorageCondition
  } =
      Lookup[expandedResolvedOptions,
        {
          Instrument, Name, AssayType, SampleLoadingPlate, SampleVolume, ReplicateDilutionCurve,
          AssayContainerFillDirection, Temperature, EquilibrationTime, NumberOfAcquisitions, AcquisitionTime, LaserPower, DiodeAttenuation, CapillaryLoading,
          MeasurementDelayTime, IsothermalMeasurements, IsothermalRunTime, IsothermalAttenuatorAdjustment, SampleLoadingPlateStorageCondition,
          ParentProtocol, AutomaticLaserSettings, AssayFormFactor, ColloidalStabilityParametersPerSample, CalculateMolecularWeight, CollectStaticLightScattering, MinTemperature, MaxTemperature, TemperatureRampOrder, NumberOfCycles, TemperatureRamping, TemperatureRampRate, TemperatureResolution, NumberOfTemperatureRampSteps, StepHoldTime, WellCover, WellCoverHeating, DilutionMixType, DilutionMixInstrument, SamplesOutStorageCondition, Buffer, BlankBuffer, StandardDilutionCurve, SerialDilutionCurve,
          DilutionMixVolume, DilutionNumberOfMixes, DilutionMixRate, Analyte, AnalyteMassConcentration, AliquotAmounts, SamplesInStorageCondition
        },
        Null
      ];

  objectSamplePacketFields = Packet @@ Flatten[{Solvent, IncompatibleMaterials, SamplePreparationCacheFields[Object[Sample]]}];

  (* - Make a Download call to get the containers of the input samples - *)
  {listedSamplePackets, liquidHandlerContainerDownload} = Quiet[
    Download[
      {
        mySamples,
        liquidHandlerContainers
      },
      {
        {
          objectSamplePacketFields,
          Packet[Composition[[All, 2]][{Object, MolecularWeight, Name}]],
          Packet[Container][Model]
        },
        {MaxVolume}
      },
      Cache -> cache,
      Date -> Now
    ],
    {Download::FieldDoesntExist}
  ];

  (* Pull out the Sample and Composition Packets from the download *)
  samplePackets = listedSamplePackets[[All, 1]];
  sampleCompositionPackets = listedSamplePackets[[All, 2]];
  sampleContainerModelPackets = listedSamplePackets[[All, 3]];

  (* Find the list of input sample and antibody containers *)
  listedSampleContainers = Lookup[sampleContainerModelPackets, Object];
  sampleContainersIn = DeleteDuplicates[Flatten[listedSampleContainers]];

  (* Find the MaxVolume of all of the liquid handler compatible containers *)
  liquidHandlerContainerMaxVolumes = Flatten[liquidHandlerContainerDownload, 1];

  (* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
  (* - Expand the index-matched inputs for the NumberOfReplicates - *)
  {samplesWithReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentDynamicLightScattering, mySamples, expandedResolvedOptions];

  {
    expandedAliquotAmounts, expandedBuffer, expandedBlankBuffer, expandedStandardDilutionCurve, expandedSerialDilutionCurve,
    expandedSamplesInStorageCondition, expandedDilutionMixVolume, expandedDilutionNumberOfMixes,
    expandedDilutionMixRate, expandedAnalytes, expandedAnalyteMassConcentrations
  } =
      Lookup[optionsWithReplicates,
        {
          AliquotAmount, Buffer, BlankBuffer, StandardDilutionCurve, SerialDilutionCurve, SamplesInStorageCondition,
          DilutionMixVolume, DilutionNumberOfMixes, DilutionMixRate, Analyte, AnalyteMassConcentration
        },
        Null
      ];

  (* Silly download of storage condition symbols because I can't figure out another workaround *)
  siscToUse=If[MatchQ[assayType,ColloidalStability],samplesInStorageCondition,expandedSamplesInStorageCondition];
  expandedSamplesInStorageConditionSymbols=Which[

    (* If these are all Model[StorageCondition]s, download the StorageCondition field *)
    MatchQ[siscToUse,{ObjectP[Model[StorageCondition]]..}],
      Download[siscToUse,StorageCondition],

    (* If they're all symbols, keep them *)
    MatchQ[siscToUse,{_Symbol..}],
    siscToUse,

    (* If we've got a mix for some odd reason, go one by one, downloading from the models and keeping symbols *)
    True,
      Map[
        If[
          MatchQ[#,ObjectP[Model[StorageCondition]]],
            Download[#,StorageCondition],
            #
        ]&,
        siscToUse
      ]
  ];

  (* Define a variable that is the number of samples including replicates *)
  numberOfSamplesWithReplicates = Length[samplesWithReplicates];
  intNumberOfReplicates = Lookup[myResolvedOptions,NumberOfReplicates] /. {Null -> 1};

  (* - For resources below, we will need to know how much volume will be needed for samples / buffers - *)
  (* Run calculatedDilutionCurveVolumes on the standardDilutionCurve and serialDilutionCurve to get this information *)
  expandedStandardDilutionCurveVolumes = calculatedDLSDilutionCurveVolumes[#]& /@ Transpose[{standardDilutionCurve, ToList[analyteMassConcentration]}];
  expandedSerialDilutionCurveVolumes = calculatedDLSDilutionCurveVolumes[#]& /@ serialDilutionCurve;

  (* Make quasi-expanded aliquot amounts *)
  aliquotAmountsOrNulls = If[
    !NullQ[aliquotAmounts],
      aliquotAmounts,
      aliquotAmounts/.{Null->ConstantArray[{Null,Null},Length[expandedStandardDilutionCurveVolumes]]}
  ];

  (* === To make resources, we need to find the input Objects and Models that are unique, and to request the total volume of them that is needed === *)
  (* ---  For each index-matched input or option object/volume pair, make a list of rules - ask for a bit more than requested in the cases it makes sense to, to take into account dead volumes etc --- *)
  (* -- SamplesIn -- *)
  (* - First, we need to make a list of volumes that are index matched to the expanded samples - *)
  (* For SizingPolydispersity, MeltingCurve, and IsothermalStability Assays, this will be either the AliquotAmount or the SampleVolume *)
  (* For ColloidalStability Assays, this will be either the AliquotAmount or the amount needed for the dilution curves *)
  expandedRequiredSampleVolumes = If[

    (* - Cases where AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability - *)
    (* If the AliquotAmount is specified, use that; else, use the SampleVolume. *)
    (* We have to do nested Ifs because the MapThreads would be of unequal length otherwise. *)
    Not[MatchQ[assayType,ColloidalStability]],
      If[NullQ[#],sampleVolume,#]&/@expandedAliquotAmounts,

      MapThread[
        Function[{aliquotAmounts,standardVolumes,serialVolumes},
          Which[

            (* - Cases where the AssayType is ColloidalStability (doing some dilution) - *)
            (* If the AliquotAmount is specified, use that *)
            Not[NullQ[aliquotAmounts]],
            aliquotAmounts,

            (* If the StandardDilutionCurve is specified and ReplicateDilutionCurve is False, add up the SampleVolumes *)
            Not[MatchQ[standardVolumes,{Null,Null}]] && MatchQ[replicateDilutionCurve,False],
            (Total[First[standardVolumes]]*colloidalStabilityParametersPerSample),

            (* If the StandardDilutionCurve is specified and ReplicateDilutionCurve is True, add up the SampleVolumes and multiply by NumberOfReplicates *)
            Not[MatchQ[standardVolumes,{Null,Null}]] && MatchQ[replicateDilutionCurve,True],
            (Total[First[standardVolumes]] * intNumberOfReplicates * colloidalStabilityParametersPerSample),

            (* If the SerialDilutionCurve is specified and ReplicateDilutionCurve is False, the amount needed is the first TransferVolume *)
            Not[MatchQ[serialVolumes,{Null,Null}]] && MatchQ[replicateDilutionCurve,False],
            (First[First[serialVolumes]] * colloidalStabilityParametersPerSample ),

            (* If the SerialDilutionCurve is specified and ReplicateDilutionCurve is True, the amount needed is the first TransferVolume times the NumberOfReplicates *)
            Not[MatchQ[serialVolumes,{Null,Null}]] && MatchQ[replicateDilutionCurve,True],
            (First[First[serialVolumes]] * intNumberOfReplicates * colloidalStabilityParametersPerSample),

            (* Catch-all that should never exist (Errors would have been thrown in resolver) *)
            True,
            0 * Microliter
          ]
        ],
        {aliquotAmountsOrNulls, expandedStandardDilutionCurveVolumes, expandedSerialDilutionCurveVolumes}
      ]
  ];

  (* Then, we use this list to create the volume rules for the input samples *)
  sampleVolumeRules = MapThread[
    (#1 -> #2)&,
    {If[MatchQ[assayType,ColloidalStability],mySamples,samplesWithReplicates], (expandedRequiredSampleVolumes + 10 * Microliter)}
  ];

  (* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
  uniqueSampleVolumeRules = Merge[sampleVolumeRules, Total];

  (* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
  sampleResourceReplaceRules = KeyValueMap[
    Function[{sample, volume},
      If[VolumeQ[volume],
        sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume ],
        sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
      ]
    ],
    uniqueSampleVolumeRules
  ];

  (* Use the replace rules to get the sample resources *)
  samplesInResources = Replace[If[MatchQ[assayType,ColloidalStability],mySamples,samplesWithReplicates], sampleResourceReplaceRules, {1}];

  (* -- Buffer -- *)
  (* - Determine the minimum amount of each Buffer needed - *)
  expandedRequiredBufferVolumes = MapThread[
    Switch[{assayType, #1, #2, replicateDilutionCurve},

      (* If the AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability, set to 0 uL (no buffer) *)
      {Except[ColloidalStability], _, _, _},
      0 * Microliter,

      (* If the StandardDilutionCurve is specified and ReplicateDilutionCurve is False, sum of Buffer Volumes *)
      {_, Except[{Null, Null}], _, False},
      (Total[Last[#1]]*colloidalStabilityParametersPerSample),

      (* If the StandardDilutionCurve is specified and ReplicateDilutionCurve is True, sum of Buffer Volumes times NumberOfReplicates *)
      {_, Except[{Null, Null}], _, True},
      (Total[Last[#1]] * intNumberOfReplicates * colloidalStabilityParametersPerSample),

      (* If the SerialDilutionCurve is specified and ReplicateDilutionCurve is False, sum of Buffer Volumes *)
      {_, _, Except[{Null, Null}], False},
      (Total[Last[#2]] * colloidalStabilityParametersPerSample),

      (* If the SerialDilutionCurve is specified and ReplicateDilutionCurve is True, sum of Buffer volumes times NumberOfReplicates *)
      {_, _, Except[{Null, Null}], True},
      (Total[Last[#2]] * intNumberOfReplicates * colloidalStabilityParametersPerSample),

      (* Catch-all that should never exist (Errors would have been thrown in resolver) *)
      {_, _, _, _},
      0 * Microliter

    ]&,
    {expandedStandardDilutionCurveVolumes, expandedSerialDilutionCurveVolumes}
  ];

  (* Define the volume rules for the Buffer *)
  bufferVolumeRules = MapThread[
    (#1 -> #2)&,
    {buffer, expandedRequiredBufferVolumes}
  ];

  (* - BlankBuffer - only for ColloidalStability assays - *)
  blankBufferVolumeRules = If[MatchQ[assayType, ColloidalStability],
    Map[
      (# -> 30 * Microliter)&,
      blankBuffer
    ],
    {}
  ];

  (* Combine the VolumeRules *)
  allVolumeRules = Cases[
    Join[
      bufferVolumeRules, blankBufferVolumeRules
    ],
    Except[Alternatives[_ -> 0 * Microliter, Null -> _]]
  ];

  (* - Make an association whose keys are the unique Object and Model Keys in the list of allVolumeRules, and whose values are the total volume of each of those unique keys - *)
  uniqueObjectsAndVolumesAssociation = Merge[allVolumeRules, Total];

  (* - Use this association to make Resources for each unique Object or Model Key - *)
  uniqueResources = KeyValueMap[
    Module[{containers},
      containers = PickList[liquidHandlerContainers, liquidHandlerContainerMaxVolumes, GreaterEqualP[#2]];
      Resource[Sample -> #1, Amount -> #2, Container -> containers, Name -> ToString[#1]]
    ]&,
    uniqueObjectsAndVolumesAssociation
  ];

  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  uniqueObjects = Keys[uniqueObjectsAndVolumesAssociation];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  uniqueObjectResourceReplaceRules = MapThread[
    (#1 -> #2)&,
    {uniqueObjects, uniqueResources}
  ];

  (* -- Use the unique object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
  {bufferResources, blankBufferResources} = Map[
    Replace[#, uniqueObjectResourceReplaceRules, {1}]&,
    {buffer, blankBuffer}
  ];

  (* -- Make Resources for Instrument / Containers / Consumables  -- *)
  (* - Instrument - *)
  (* First, figure out how long we need the instrument for *)
  instrumentTime = Switch[{assayType, isothermalRunTime, measurementDelayTime, isothermalMeasurements},

    (* When the AssayType is MeltingCurve, we set this for two hours *)
    {MeltingCurve, _, _, _},
    2 * Hour,

    (* When the AssayType is not IsothermalStability, we set this variable to 1 Hour *)
    {Except[IsothermalStability], _, _, _},
    1 * Hour,

    (* If the MeasurementDelayTime and the IsothermalMeasurements are both specified, we multiply them *)
    {_, _, Except[Null], Except[Null]},
    Convert[RoundOptionPrecision[((measurementDelayTime * isothermalMeasurements) + 1 * Hour), 10^0 * Hour], Hour],

    (* If the IsothermalRunTime is specified, add it to 1 hour *)
    {_, Except[Null], _, _},
    Convert[RoundOptionPrecision[(isothermalRunTime + 1 * Hour), 10^0 * Hour], Hour],

    (* In all other cases (should never happen) *)
    {_, _, _, _},
    1 * Hour
  ];

  (* Make Instrument Resource *)
  instrumentResource = Resource[
    Instrument -> instrument,
    Time -> instrumentTime
  ];

  (*Define CapillaryLoadingVolume*)
  capillaryLoadingVolume=If[MatchQ[assayFormFactor,Capillary],
    10*Microliter,
    Null
  ];

  (* - Define the RunTime field value (will be used for processing) - *)
  runTime = Which[

    (* When the AssayType is SizingPolydispersity, we add the EquilibrationTime to 45 seconds times the number of input samples *)
    MatchQ[assayType,SizingPolydispersity],
    Convert[RoundOptionPrecision[(equilibrationTime + (45 * Second * numberOfSamplesWithReplicates)), 10^0 * Minute], Minute],

    (* When the AsasyType is ColloidalStability, set to 45 min *)
    MatchQ[assayType,ColloidalStability],
    45 * Minute,

    (* If the IsothermalRunTime is specified, round it to the nearest Minute and use it to set the runTime *)
    MatchQ[assayType,IsothermalStability] && Not[NullQ[isothermalRunTime]],
    Convert[RoundOptionPrecision[isothermalRunTime, 10^0 * Minute], Minute],

    MatchQ[assayType,IsothermalStability],
    (* If assayType is IsothermalStability but isothermalRunTime is not specified, multiply the MeasurementDelayTime by the number of IsothermalMeasurements *)
    Convert[RoundOptionPrecision[((measurementDelayTime * isothermalMeasurements)), 10^0 * Minute], Minute],

    (* When AssayType is MeltingCurve, we can evaluate this from either the (((MaxTemperature-MinTemperature)/TemperatureRampRate)+(StepHoldTime*NumberOfSteps))*NumberOfCycles*samples (if Step) or ((MaxTemperature-MinTemperature)/TemperatureRampRate) * NumberOfCycles * samples (if Linear) *)
    MatchQ[temperatureRamping,Step],
      (*This is (((MaxTemperature-MinTemperature)/TemperatureRampRate)+(StepHoldTime*NumberOfSteps))*NumberOfCycles*samples*)
      (((maxTemperature-minTemperature)/temperatureRampRate)+(stepHoldTime*numberOfTemperatureRampSteps))*numberOfCycles*numberOfSamplesWithReplicates,

    (*If TemperatureRamping is Linear, it's the same without the stepHoldTime term*)
    True,
      ((maxTemperature-minTemperature)/temperatureRampRate)*numberOfCycles*numberOfSamplesWithReplicates
  ];

  (* - SampleLoadingPlate - only set if assayFormFactor is Capillary - *)
  sampleLoadingPlateResource = If[
    MatchQ[assayFormFactor,Capillary],
    Resource[
      Sample -> sampleLoadingPlate
    ],
    Null
  ];

  (* -- For the AssayContainer-related Resources, first, figure out how many assay containers we need -- *)
  numberOfAssayContainerWellsPerSample = MapThread[
    Switch[{assayType, #1, #2},

      (* If the resolvedAssayType is IsothermalStability or SizingPolydispersity, we set this to 1 *)
      {Except[ColloidalStability], _, _},
      1,

      (* If the StandardDilutionCurve is specified, then take the Length of the SampleVolumes times the NumberOfReplicates *)
      {_, Except[{Null, Null}], _},
      ((Length[First[#1]] * intNumberOfReplicates * colloidalStabilityParametersPerSample) + 1),

      (* If only the SerialDilutionCurve is specified, take the Length of the TransferVolumes times the NumberOfReplicates *)
      {_, _, Except[{Null, Null}]},
      ((Length[First[#2]] * intNumberOfReplicates * colloidalStabilityParametersPerSample) + 1)
    ]&,
    {expandedStandardDilutionCurveVolumes, expandedSerialDilutionCurveVolumes}
  ];

  (* Figure out how many total AssayContainer wells the protocol needs. This is done by adding the numberOfSamplesWithReplicates
  (which corresponds to the BlankBuffer wells, one for each sample), to the product of the NumberOfReplicates times the sum of the
  assayContainerWellsPerSample (which already takes into account the NumberOfReplicates *)
  requiredDilutionAssayContainerWells = Total[numberOfAssayContainerWellsPerSample];

  (* We are going to make two branches here: one for Capillary and one for Plate, because there will only ever be one AssayContainer for Plate *)
  (* Using the number of required wells, determine how many AssayContainers we need *)
  numberOfAssayContainers = Which[

    (* IF we're using Capillary and the AssayContainerFillDirection is Vertical *)
    MatchQ[assayFormFactor,Capillary] && MatchQ[assayContainerFillDirection, Column],

      (* THEN we round up from the number of wells divided by 16 *)
      Ceiling[(requiredDilutionAssayContainerWells / 16)],

    (* If we're in Capillary and Row, we are loading one well of each capillary before moving to next, choose 3 unless there are only 1 or 2 samples *)
    MatchQ[assayFormFactor,Capillary],

      (* We are loading one well of each capillary before moving to next, choose 3 unless there are only 1 or 2 samples *)
      requiredDilutionAssayContainerWells/.{Null|GreaterP[3]->3},

    (* For Plate, there's only ever 1 assay container *)
    True,
      1
  ];

  (* - AssayContainer - *)
  (* First, the branch for AssayType -> Capillary *)
  assayContainerResources = Which[
    MatchQ[assayFormFactor,Capillary],
      Table[
        Resource[
          Sample -> Model[Container, Plate, CapillaryStrip, "id:R8e1Pjp9Kjjj"],(*"Uncle 16-capillary strip"*)
          Name -> ToString[Unique[]]
        ],
        numberOfAssayContainers
      ],

    (* Brief interlude here - if we've got preloaded samples, we'll just take that plate *)
    MatchQ[ToList[Lookup[sampleContainerModelPackets,Model]],{dlsAssayContainerP..}&&Length[sampleContainersIn]==1],
      Resource[
        Sample->First[sampleContainersIn],
        Name->ToString[Unique[]]
      ],

    (* Next, the branch for AssayType -> Plate. We have to use both (a) number of wells and (b) sample volume *)
    (* If there are more than 96 wells required, or the max SampleVolume is less than 50 Microliter, go with a 384-well plate *)
      GreaterQ[requiredDilutionAssayContainerWells,96] || LessQ[Max[sampleVolume],30*Microliter],
        {
          Resource[
            Sample->Model[Container, Plate, "id:4pO6dMOlqJLw"],(*"384-well Aurora Flat Bottom DLS Plate"*)(*TODO: THIS IS NOT PARAMETERIZED YET!!!!!!!!!!*)
            Name->ToString[Unique[]]
          ]
        },

    (* ELSE, go with a 96-well plate. First search for our preferred one and make sure we have at least one stocked onsite *)
    Length[Search[Object[Container, Plate],Model == Link[Model[Container, Plate, "id:rea9jlaPWNGx"], Objects] && Status == Stocked && Site == Link[$Site]]]>=1,
      {
        Resource[
          Sample->Model[Container, Plate, "id:rea9jlaPWNGx"],(*"96 well Flat Bottom DLS Plate"*)
          Name->ToString[Unique[]]
        ]
      },

    (* If none of those, specify our non-preferred 96-well plate *)
    True,
      {
        Resource[
          Sample->Model[Container, Plate, "id:N80DNj09z91D"],(*"96 well Clear Flat Bottom DLS Plate"*)
          Name->ToString[Unique[]]
        ]
      }
  ];

  (* - Capillary Loading Rack - only if Capillary - *)
  capillaryStripLoadingRack = Which[
    MatchQ[capillaryLoading, Manual]&&MatchQ[assayFormFactor,Capillary],
      Link[Resource[Sample -> Model[Container, Plate, "Uncle 16-capillary strip plate loader V3.0"], Rent -> True, Name -> ToString[Unique[]]]],
    MatchQ[assayFormFactor,Capillary],
      Link[Resource[Sample -> Model[Container, Plate, "Uncle 16-capillary strip plate loader"], Rent -> True, Name -> ToString[Unique[]]]],
    True,
      Null
  ];

  (* - Capillary Clips - only if Capillary *)
  capillaryClipResource = If[
    MatchQ[assayFormFactor,Capillary],
      Link[#]& /@ Table[Resource[Sample -> Model[Container, Rack, "Uncle capillary strip clip"], Rent -> True, Name -> ToString[Unique[]]], numberOfAssayContainers],
      Null
  ];

  (* - Gaskets - only for Capillary *)
  capillaryClipGasketResource = If[
    MatchQ[assayFormFactor,Capillary],
      Link[
        Resource[
          Sample -> Model[Item, Consumable, "Uncle capillary strip clip gaskets"],
          Amount -> 2 * numberOfAssayContainers,
          Name -> ToString[Unique[]]
        ]
      ],
      Null
  ];

  (* - Sample Stage Lid - only for Capillary *)
  sampleStageLid = If[
    MatchQ[assayFormFactor,Capillary],
      Link[
        Resource[
          Sample -> Model[Part, "Uncle sample stage lid"],
          Rent -> True,
          Name -> ToString[Unique[]]
        ]
      ],
      Null
    ];

  (* - ManualLoadingPlate - only if we are loading manual and AssayFormFactor is Capillary. I am not a huge fan of this solution, but its a simpler fix than to rearrange how the sample prep plate is set *)
  manualLoadingPlateResource = If[MatchQ[capillaryLoading, Manual],
    Resource[
      Sample -> Model[Container, Plate, "96-well PCR Plate"]
    ],
    Null
  ];

  (* - ManualLoadingPipette - only if we are loading manual and AssayFormFactor is Capillary. I am not a huge fan of this solution, but its a simpler fix than to rearrange how the sample prep plate is set *)
  manualLoadingPipetteResource = If[MatchQ[capillaryLoading, Manual],
    Resource[
      Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus, 8-channel 10uL"]
    ],
    Null
  ];

  (* - ManualLoadingTips - only if we are loading manual and AssayFormFactor is Capillary. I am not a huge fan of this solution, but its a simpler fix than to rearrange how the sample prep plate is set *)
  manualLoadingTipsResource = If[MatchQ[capillaryLoading, Manual],
    Resource[
      Sample -> Model[Item, Tips, "0.1 - 10 uL Tips, Low Retention, Non-Sterile"],
      Amount -> requiredDilutionAssayContainerWells
    ],
    Null
  ];

  (* -- A bunch of logic to figure out the concentrations of the input samples, and the dilution factors, and dilution concentrations -- *)
  (* - Dilutions and SerialDilutions - *)
  standardDilutionCurveVolumes = calculatedDLSDilutionCurveVolumes[#]& /@ Transpose[{standardDilutionCurve,ToList[analyteMassConcentration]}];
  serialDilutionCurveVolumes = calculatedDLSDilutionCurveVolumes[#]& /@ serialDilutionCurve;

  (* Transpose the lists of dilution volumes to get them in the correct format for the protocol packet *)
  transposedStandardDilutionCurves = If[

    (* IF there is a SampleDilution *)
    MatchQ[#, Except[{Null, Null}]],

    (* THEN Transpose it to get it into {{SampleVolume,BufferVolume}..} format *)
    Transpose[#],

    (* ELSE, just return Null *)
    Null
  ]& /@ standardDilutionCurveVolumes;

  (* Transpose the lists of serial dilution volumes to get them in the correct format for the protocol packet *)
  transposedSerialDilutionCurves = Map[
    If[

      (* IF there is a SampleDilution *)
      MatchQ[#, Except[{Null, Null}]],

      (* THEN Transpose it to get it into {{TransferVolume,BufferVolume}..} format *)
      Transpose[#],

      (* ELSE, just return Null *)
      Null
    ]&,
    serialDilutionCurveVolumes
  ];

  (* - Determine how much of each input sample we use for the dilution curves - *)
  dilutionSampleVolumes = MapThread[
    Switch[{assayType, #1, #2, replicateDilutionCurve},

      (* If the AssayType is SizingPolydispersity or IsothermalStability, set to Null *)
      {Except[ColloidalStability], _, _, _},
      Null,

      (* If the StandardDilutionCurve is specified and ReplicateDilutionCurve is False, add up the SampleVolumes *)
      {ColloidalStability, Except[{Null, Null}], _, False},
      (Total[First[#1]] * colloidalStabilityParametersPerSample),

      (* If the StandardDilutionCurve is specified and ReplicateDilutionCurve is True, add up the SampleVolumes and multiply by NumberOfReplicates *)
      {ColloidalStability, Except[{Null, Null}], _, True},
      (Total[First[#1]] * intNumberOfReplicates * colloidalStabilityParametersPerSample),

      (* If the SerialDilutionCurve is specified and ReplicateDilutionCurve is False, the amount needed is the first TransferVolume *)
      {ColloidalStability, _, Except[{Null, Null}], False},
      (First[First[#2]] * colloidalStabilityParametersPerSample),

      (* If the SerialDilutionCurve is specified and ReplicateDilutionCurve is True, the amount needed is the first TransferVolume times the NumberOfReplicates *)
      {ColloidalStability, _, Except[{Null, Null}], True},
      (First[First[#2]] * intNumberOfReplicates * colloidalStabilityParametersPerSample),

      (* Catch-all that should never exist (Errors would have been thrown in resolver) *)
      {_, _, _, _, _},
      Null
    ]&,
    {standardDilutionCurveVolumes, serialDilutionCurveVolumes}
  ];

  (* - Figure out the dilution factors (compared to the input sample concentration) for each for each input sample - *)
  dilutionFactors = MapThread[
    Switch[{assayType, #1, #2},

      (* If the AssayType is SizingPolydispersity or IsothermalStability, set as Null *)
      {Except[ColloidalStability], _, _},
      Null,

      (* If the StandardDilutionCurve is specified, divide the SampleVolume by the sum of the SampleVolume and BufferVolume *)
      {ColloidalStability, Except[{Null, Null}], _},
      MapThread[
        Function[{sampleVolume, bufferVolume},
          SafeRound[(sampleVolume / (sampleVolume + bufferVolume)), 10^-5]
        ],
        {First[#1], Last[#1]}
      ],

      (* If the SerialDilutionCurve is specified, need to calculate the dilution factor of each transfer, which requires a Fold,
       since the dilution factor of the previous dilutions is required for calculation *)
      {ColloidalStability, _, Except[{Null, Null}]},
      Fold[
        Function[{growingDilutionFactorList, nextTuple},
          Module[{newDilutionFactor},

            (* Calculate the dilution factor of the current iteration *)
            newDilutionFactor = If[

              (* IF this is the first round of the Fold *)
              MatchQ[growingDilutionFactorList, {}],

              (* THEN, we take the ratio of the TransferVolume to the sum of the TransferVolume and BufferVolume *)
              SafeRound[(First[nextTuple] / (First[nextTuple] + Last[nextTuple])), 10^-5],

              (* ELSE, multiply the last calculated dilution factor by the ratio of TransferVolume/(TransferVolume+BufferVolume) *)
              SafeRound[Last[growingDilutionFactorList] * (First[nextTuple] / (First[nextTuple] + Last[nextTuple])), 10^-5]
            ];

            (* For this round, return a list of the previous dilution factors appended with the new one *)
            Append[growingDilutionFactorList, newDilutionFactor]
          ]
        ],
        {},
        Transpose[#2]
      ],

      (* Catch-all that will never be reached *)
      {_, _, _},
      Null
    ]&,
    {standardDilutionCurveVolumes, serialDilutionCurveVolumes}
  ];

  (* - Using the dilution factors above, calculate the Analyte Concentration of each dilution - *)
  dilutionConcentrations = MapThread[
    If[
      (* IF either the list of dilution factors or the initial Analyte concentration is Null *)
      Or[
        MatchQ[#1, Null],
        MatchQ[#2, Null]
      ],

      (* THEN return Null for this sample *)
      Null,

      (* ELSE, multiply the dilution factors times the initlaAnalyteConcentration *)
      SafeRound[(#1 * #2), 10^-2 * (Milligram / Milliliter)]
    ]&,
    {dilutionFactors, ToList[analyteMassConcentration]}
  ];

  (* -- Figure out what we are going to set the AnalyteMassConcentration field to (needed for ColloidalStability assays) -- *)
  (* - From the resolvedAnalytes, get the corresponding MolecularWeights (need this information for ColloidalStability Assays)- *)
  analyteMolecularWeights = If[

    (* IF the resolvedAnalyte is just a list of Null *)
    MatchQ[analyte, {Null..}],

    (* THEN just set this to an empty list *)
    {},

    (* ELSE, look up the MolecularWeight of each non-Null Analyte *)
    fastAssocLookup[fastAssoc,#,MolecularWeight]&/@DeleteCases[analyte,Null]
  ];

  (* Get rid of any Nulls in the list *)
  nonNullAnalyteMolecularWeights = Cases[analyteMolecularWeights, Except[Null]];

  (* - If the list is not empty, get the First member of the list as a string, without units - *)
  analyteMolecularWeightString = If[

    (* IF the list is empty *)
    Or[
      MatchQ[nonNullAnalyteMolecularWeights, {}],
      MatchQ[assayType, Except[ColloidalStability]]
    ],

    (* THEN set the variable to Null *)
    Null,

    (* ELSE, get the first MolecularWeight as an Integer String *)
    ToString[
      Round[
        Unitless[
          FirstOrDefault[nonNullAnalyteMolecularWeights]
        ]
      ]
    ]
  ];

  (* --- Create the protocol packet ---*)
  (* -- Create a packet for fields that exist in both protocol objects -- *)
  protocolPacket = <|
    Type -> Object[Protocol, DynamicLightScattering],
    Object -> protocolID,

    Author -> If[MatchQ[parentProtocol, Null],
      Link[$PersonID, ProtocolsAuthored]
    ],
    ParentProtocol -> If[MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]],
      Link[parentProtocol, Subprotocols]
    ],
    Name -> name,

    Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ sampleContainersIn,
    Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
    UnresolvedOptions -> RemoveHiddenOptions[ExperimentDynamicLightScattering, myUnresolvedOptions],
    ResolvedOptions -> myResolvedOptions,

    Instrument -> Link[instrumentResource],
    CapillaryLoadingVolume -> capillaryLoadingVolume,

    AssayType -> assayType,
    AssayFormFactor -> assayFormFactor,
    SampleLoadingPlate -> Link[sampleLoadingPlateResource],
    SampleVolume -> sampleVolume,
    Temperature -> temperature,
    EquilibrationTime -> equilibrationTime,
    NumberOfAcquisitions -> numberOfAcquisitions,
    AcquisitionTime -> acquisitionTime,
    AutomaticLaserSettings -> automaticLaserSettings,
    LaserPower -> laserPower,
    DiodeAttenuation -> diodeAttenuation,
    CapillaryLoading -> capillaryLoading,
    DLSRunTime -> runTime,
    MeasurementDelayTime -> measurementDelayTime,
    IsothermalMeasurements -> isothermalMeasurements,
    IsothermalRunTime -> isothermalRunTime,
    IsothermalAttenuatorAdjustment -> isothermalAttenuatorAdjustment,
    SampleLoadingPlateStorageCondition -> sampleLoadingPlateStorageCondition,
    Replace[SamplesInStorageCondition]->expandedSamplesInStorageConditionSymbols,
    SamplesOutStorageCondition->samplesOutStorageCondition,
    WellCover -> Link[wellCover],
    WellCoverHeating -> wellCoverHeating,
    CollectStaticLightScattering -> collectStaticLightScattering,

    (* Manual loading stuff *)
    ManualLoadingPlate -> Link[manualLoadingPlateResource],
    ManualLoadingPipette -> Link[manualLoadingPipetteResource],
    ManualLoadingTips -> Link[manualLoadingTipsResource],

    (* Dilution stuff *)
    Replace[Dilutions] -> transposedStandardDilutionCurves,
    Replace[SerialDilutions] -> transposedSerialDilutionCurves,
    Replace[Buffers] -> (Link[#]& /@ bufferResources),
    Replace[BlankBuffers] -> (Link[#]& /@ blankBufferResources),
    Replace[DilutionMixVolumes] -> dilutionMixVolume,
    Replace[DilutionMixRates] -> dilutionMixRate,
    Replace[DilutionNumberOfMixes] -> dilutionNumberOfMixes,
    DilutionMixType->First[dilutionMixType],
    DilutionMixInstrument->Link[First[dilutionMixInstrument]],
    ReplicateDilutionCurve->replicateDilutionCurve,

    (* Calculated stuff from the Dilutions *)
    Replace[DilutionSampleVolumes] -> dilutionSampleVolumes,
    Replace[DilutionFactors] -> dilutionFactors,
    Replace[DilutionConcentrations] -> dilutionConcentrations,
    Replace[Analytes] -> (Link[#]& /@ analyte),
    Replace[AnalyteMassConcentrations] -> analyteMassConcentration,
    Replace[AnalyteStoredMolecularWeight] -> analyteMolecularWeights,

    (*MeltingCurveStuff*)
    MinTemperature->minTemperature,
    MaxTemperature->maxTemperature,
    TemperatureRampOrder->temperatureRampOrder,
    NumberOfCycles->numberOfCycles,
    TemperatureRampRate->temperatureRampRate,
    TemperatureRamping->temperatureRamping,
    TemperatureResolution->temperatureResolution,
    NumberOfTemperatureRampSteps->numberOfTemperatureRampSteps,
    StepHoldTime->stepHoldTime,

    Replace[AssayContainers] -> Map[Link[#]&, ToList[assayContainerResources]],
    Replace[CapillaryClips] -> capillaryClipResource,
    Replace[CapillaryGaskets] -> capillaryClipGasketResource,
    CapillaryStripLoadingRack -> capillaryStripLoadingRack,
    SampleStageLid -> sampleStageLid,
    AssayContainerFillDirection -> assayContainerFillDirection,

    (* Storage Stuff - I think we don't need this but let's do it anyhow *)
    Replace[SamplesInStorage] -> expandedSamplesInStorageConditionSymbols,

    (* Checkpoints *)
    Replace[Checkpoints] -> {
      {"Preparing Samples", 5 * Minute, "Preprocessing, such as incubation, centrifugation, filtration, and aliquotting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 5 Minute]]},
      {"Picking Resources", 20 * Minute, "Samples, plates, and items required to perform this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 20 Minute]]},
      {"Preparing Assay Containers", 1 * Hour, "The SampleLoadingPlate is loaded and centrifuged, then the AssayContainers are loaded.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1Hour]]},
      {"Preparing Instrumentation", 30 * Minute, "The instrument is configured for the protocol.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 30 Minute]]},
      {"Acquiring Data", instrumentTime, "Samples in the AssayContainers are interrogated in a dynamic light scattering assay.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> instrumentTime]]},
      {"Returning Materials", 30 * Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 30 Minute]]}
    }
  |>;

  (* --- Create a unit operations packet --- *)
  (* -- Generate the packet -- *)
  unitOperationPacket=UploadUnitOperation[
    DynamicLightScattering@@ {
      Sample->mySamples,
      AssayType -> assayType,
      AssayFormFactor -> assayFormFactor,
      Instrument -> Link[instrument],
      SampleLoadingPlate -> Link[sampleLoadingPlateResource],
      WellCover -> Link[wellCover],
      WellCoverHeating -> wellCoverHeating,
      Temperature -> temperature,
      EquilibrationTime -> equilibrationTime,
      CollectStaticLightScattering -> collectStaticLightScattering,
      NumberOfAcquisitions -> numberOfAcquisitions,
      AcquisitionTime -> acquisitionTime,
      AutomaticLaserSettings -> automaticLaserSettings,
      LaserPower -> laserPower,
      DiodeAttenuation -> diodeAttenuation,
      DLSRunTime -> runTime,
      CapillaryLoading -> capillaryLoading,
      AssayContainerFillDirection -> assayContainerFillDirection,
      ColloidalStabilityParametersPerSample -> colloidalStabilityParametersPerSample,
      Analyte -> (Link[#]& /@ analyte),
      AnalyteMassConcentration -> analyteMassConcentration,
      Buffer->(Link[#]& /@ bufferResources),
      DilutionMixType->dilutionMixType,
      DilutionMixVolumes->dilutionMixVolume,
      DilutionNumberOfMixes->dilutionNumberOfMixes,
      DilutionMixRates->dilutionMixRate,
      DilutionMixInstrument->dilutionMixInstrument,
      BlankBuffer->(Link[#]& /@ blankBufferResources),
      CalculateMolecularWeight->calculateMolecularWeight,
      MeasurementDelayTime->measurementDelayTime,
      IsothermalMeasurements->isothermalMeasurements,
      IsothermalRunTime->isothermalRunTime,
      IsothermalAttenuatorAdjustment->isothermalAttenuatorAdjustment,
      MinTemperature->minTemperature,
      MaxTemperature->maxTemperature,
      TemperatureRampOrder->temperatureRampOrder,
      NumberOfCycles->numberOfCycles,
      TemperatureRamping->temperatureRamping,
      TemperatureRampRate->temperatureRampRate,
      TemperatureResolution->temperatureResolution,
      NumberOfTemperatureRampSteps->numberOfTemperatureRampSteps,
      StepHoldTime->stepHoldTime,
      SampleLoadingPlateStorageCondition->sampleLoadingPlateStorageCondition,
      SamplesInStorageCondition->expandedSamplesInStorageConditionSymbols
    },
    UnitOperationType->Output,
    FastTrack->True,
    Upload->False
  ];

  (* - Populate prep field - send in initial samples and options since this handles NumberOfReplicates on its own - *)
  prepPacket = populateSamplePrepFields[mySamples, Normal[KeyDrop[myResolvedOptions,SamplesOutStorageCondition]]];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[protocolPacket, KeyDrop[prepPacket,Replace[SamplesInStorage]]];

  allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

  (* Verify we can satisfy all our resources *)
  {resourcesOk, resourceTests} = Which[
    MatchQ[$ECLApplication, Engine],
    {True, {}},
    gatherTests,
    Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Cache -> cache, Simulation->simulation],
    True,
    {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Messages -> messages, Cache -> cache, Simulation->simulation], Null}
  ];


  (* --- Output --- *)
  (* Generate the Preview output rule *)
  previewRule = Preview -> Null;

  (* Generate the options output rule *)
  optionsRule = Options -> If[MemberQ[output, Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    resourceTests,
    {}
  ];

  (* generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[resourcesOk],
    {finalizedPacket,unitOperationPacket},
    $Failed
  ];

  (* Return the output as we desire it *)
  outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
  simulateExperimentDynamicLightScattering,
  Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentDynamicLightScattering[
  myProtocolPacket:(PacketP[Object[Protocol, DynamicLightScattering], {Object, ResolvedOptions}]|$Failed|Null),
  myUnitOperationPackets:({PacketP[]..}|$Failed),
  mySamples : {ObjectP[Object[Sample]]..},
  myResolvedOptions : {_Rule...},
  myResolutionOptions : OptionsPattern[simulateExperimentDynamicLightScattering]
]:=Module[
  {
    cache,simulation,fastAssoc,protocolObject,samplePackets,currentSimulation,unitOperationField,primitivePacketFieldSpec,simulationWithLabels,modifiedProtocolPacket
  },

  (* Lookup our cache and simulation and make our fast association *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
  fastAssoc = makeFastAssocFromCache[cache];


  (* Download containers from our sample packets. *)
  samplePackets=Download[
    mySamples,
    Packet[Container],
    Cache->cache,
    Simulation->simulation
  ];

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject = Which[
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
    MatchQ[myProtocolPacket, $Failed],
      SimulateCreateID[Object[Protocol, DynamicLightScattering]],
    True,
      Lookup[myProtocolPacket, Object]
  ];

  (* Do a weird thing with NumberOfReplicates, because it means something different in ColloidalStability *)
  modifiedProtocolPacket = If[
    MatchQ[Lookup[myProtocolPacket,AssayType],ColloidalStability],
      Join[
        myProtocolPacket,
        <|ResolvedOptions->ReplaceRule[Lookup[myProtocolPacket,ResolvedOptions],NumberOfReplicates->1]|>
      ],
      myProtocolPacket
  ];

  (* Simulate the fulfillment of all resources by the procedure. *)
  (* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
  (* just make a shell of a protocol object so that we can return something back. *)
  currentSimulation = Which[
    MatchQ[myProtocolPacket, $Failed],

      (*Shell protocol object*)
      Module[{protocolPacket},
        protocolPacket = <|
          Object -> protocolObject,
          Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
          (*Replace[OutputUnitOperations] -> (Link[#, Protocol]&) /@ Lookup[myUnitOperationPackets, Object],*)
          (* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
          (* simulate resources will NOT simulate them for you. *)
          (* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
          Replace[RequiredInstruments] -> DeleteDuplicates[
            Cases[myProtocolPacket, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
          ],
          ResolvedOptions -> {}
        |>;

        SimulateResources[protocolPacket, Null, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]]
      ],

    (*If option resolution went okay, we can do the actual simulation*)
    True,
      SimulateResources[modifiedProtocolPacket, Null, Simulation -> simulation]
  ];

  (* Uploaded Labels *)
  simulationWithLabels=Simulation[
    Labels->Join[
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Lookup[samplePackets, Container]}],
        {_String, ObjectP[]}
      ]
    ],
    LabelFields->Join[
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
        {_String, _}
      ],
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
        {_String, _}
      ]
    ]
  ];
  (* Merge our packets with our labels. *)
  {
    protocolObject,
    UpdateSimulation[currentSimulation, simulationWithLabels]
  }
];

(*== calculatedDLSDilutionCurveVolumes ==*)

(*Need new verions of this function found in MeasureSurfaceTension*)
(*for a non-serial dilution with Sample Amount and Total Volume given*)
calculatedDLSDilutionCurveVolumes[myCurveAndConc : {{{VolumeP, VolumeP}..},GreaterEqualP[0*Milligram/Milliliter]}] :=
  Module[{myCurve,massConc,sampleVolumes, diluentVolumes},

    (*separate dilution curve and mass concentration*)
    myCurve=First[myCurveAndConc];
    massConc=Last[myCurveAndConc];

    (*make arrays of all the volumes*)
    sampleVolumes = First[#]&/@myCurve;
    diluentVolumes = (Last[#]-First[#])&/@myCurve;

    (*return the transfer volumes and diluentvolumes*)
    {sampleVolumes, diluentVolumes}
  ];

(*for a non-serial dilution with Sample Amount and Target Concentrations given*)
calculatedDLSDilutionCurveVolumes[myCurveAndConc : {{{VolumeP, GreaterEqualP[0*Milligram/Milliliter]}..},GreaterEqualP[0*Milligram/Milliliter]}] :=
  Module[{myCurve,massConc,sampleVolumes, diluentVolumes},

    (*separate dilution curve and mass concentration*)
    myCurve=First[myCurveAndConc];
    massConc=Last[myCurveAndConc];

    (*make arrays of all the volumes*)
    (*DF=sample /sample +diluent, Volume=sample+diluent*)
    sampleVolumes = First[#]&/@myCurve;
    diluentVolumes = (Unitless[(massConc/Last[#])]*First[#])-First[#] & /@ myCurve;

    (*return the transfer volumes and diluentvolumes*)
    {sampleVolumes, diluentVolumes}
  ];

(*for a non-serial dilution with Sample Amount and Target Concentrations given but no mass concentration - this will throw an error later but need to put placeholder values*)
calculatedDLSDilutionCurveVolumes[myCurveAndConc : {{{VolumeP, GreaterEqualP[0*Milligram/Milliliter]}..},Null}] :=
  Module[{myCurve,massConc,sampleVolumes, diluentVolumes},

    (*separate dilution curve and mass concentration*)
    myCurve=First[myCurveAndConc];
    massConc=Last[myCurveAndConc];

    (*make arrays of all the volumes*)
    (*DF=sample /sample +diluent, Volume=sample+diluent*)
    sampleVolumes = First[#]&/@myCurve;
    diluentVolumes = ConstantArray[0*Microliter,Length[sampleVolumes]];

    (*return the transfer volumes and diluentvolumes*)
    {sampleVolumes, diluentVolumes}
  ];

(*for a serial dilution with Sample Amount, Serial Dilution Factors, and Number Of Serial Dilutions given*)
calculatedDLSDilutionCurveVolumes[myCurve: {VolumeP,{GreaterEqualP[1]..},GreaterEqualP[1,1]}]:=
  Module[{sampleVolume,dilutionFactorCurve,lastTransferVolume,recTransferVolumeFunction,transferVolumes,diluentVolumes},

    (*make arrays of all the volumes*)
    sampleVolume=First[myCurve];

    (*Get the list of dilution factors*)
    dilutionFactorCurve=First[Rest[myCurve]];

    (*Calculate the last transfer volume performed DilutionFactors=transferIn/Totalvolume*)
    lastTransferVolume = SafeRound[sampleVolume/Last[dilutionFactorCurve],10^-1 Microliter];

    (*Calculate the rest of the transfers with recursion TotalVolume=TransferIn+Diluent-transferOut, Dilutionfactor=transferin/(tranferIn+diluent)*)
    recTransferVolumeFunction[{_Real | _Integer}]:={lastTransferVolume};
    recTransferVolumeFunction[factorList_List]:=
      Join[
        {SafeRound[(sampleVolume + First[recTransferVolumeFunction[Rest[factorList]]])/First[factorList],10^-1 Microliter]},
        recTransferVolumeFunction[Rest[factorList]]
      ];
    transferVolumes = recTransferVolumeFunction[dilutionFactorCurve]*Last[myCurve];

    (*calculate the corresponding diluent volumes, DilutionFactors=transferIn/(transferIn + diluent*)
    diluentVolumes =
      SafeRound[
        MapThread[
          If[MatchQ[#1, 0],
            sampleVolume,
            #2*(1 - (1/#1))*#1] &,
          {dilutionFactorCurve, transferVolumes}
        ],
        10^-1 Microliter
      ]*Last[myCurve];

    (*return the transfer volumes and diluentvolumes*)
    {transferVolumes, diluentVolumes}
  ];

(*for constant dilution volumes*)
calculatedDLSDilutionCurveVolumes[myCurve : {VolumeP, VolumeP, GreaterEqualP[1, 1]}] :=
  Module[{transferVolumes, diluentVolumes},

    (*make arrays of all the volumes*)
    transferVolumes = ConstantArray[First[myCurve], Last[myCurve]];
    diluentVolumes = ConstantArray[myCurve[[2]], Last[myCurve]];

    (*return the transfer volumes and diluentvolumes*)
    {transferVolumes, diluentVolumes}
  ];

(*If a dilution is Null, return Null*)
calculatedDLSDilutionCurveVolumes[Null]:={Null,Null};
calculatedDLSDilutionCurveVolumes[{Null,GreaterEqualP[0*Milligram/Milliliter]}]:={Null,Null};
calculatedDLSDilutionCurveVolumes[{Null,Null}]:={Null,Null};
calculatedDLSDilutionCurveVolumes[{{Null},Null}]:={Null,Null};


