(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* Source Code *)

(* ::Subsection:: *)
(* DilutionSharedOptions - Options *)
DefineOptionSet[DilutionSharedOptions:>
  {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",

      (* ----- Sample Dilution ----- *)
      {
        OptionName -> DilutionType,
        Default -> Linear,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> DilutionTypeP (* Serial | Linear *)
        ],
        Description -> "Indicates the type of dilution performed on the sample. Linear dilution represents a single stage dilution of the Analyte in the sample to a specified concentration or by a specified dilution factor. Serial dilution represents a stepwise dilution of the Analyte in the sample resulting in multiple samples and a geometric progression of the concentration. The progression can be described by either a series of target concentrations or a series of dilution factors. In a serial dilution the source of a dilution round is the resulting sample of the previous dilution round. The first source sample is the original sample provided.",
        Category -> "Dilution"
      },
      {
        OptionName->DilutionStrategy,
        Default->Automatic,
        Description->"Indicates if only the final sample (Endpoint) or all diluted samples (Series) produced by serial dilution are used for following electrical resistance measurement. If set to Series, electrical resistance measurement options are automatically expanded to be the same across all diluted samples.",
        ResolutionDescription->"Automatically set to Endpoint if Dilute is True and DilutionType is Serial.",
        AllowNull->True,
        Widget->Widget[
          Type->Enumeration,
          Pattern:>DilutionStrategyP
        ],
        Category->"Preparatory Dilution"
      },
      {
        OptionName -> NumberOfDilutions,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1,500,1]
        ],
        Description -> "For each sample, the number of diluted samples to prepare.",
        ResolutionDescription -> "Automatically set to the length of TargetAnalyteConcentration, CumulativeDilutionFactor, or SerialDilutionFactor if provided, otherwise set to 1.",
        Category -> "Sample Dilution"
      },
      {
        OptionName -> TargetAnalyte,
        Default -> Automatic,
        AllowNull -> False,
        Widget ->Widget[
          Type -> Object,
          Pattern :> ObjectP[IdentityModelTypes]
        ],
        Description-> "For each sample, the component in the Composition of the input sample whose concentration is being reduced to TargetAnalyteConcentration.",
        ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
        Category -> "Sample Dilution"
      },
      {
        OptionName -> CumulativeDilutionFactor,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1,10^23]
        ],
        Description -> "For each sample, the factor by which the concentration of the TargetAnalyte in the original sample is reduced during the dilution. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Sample Dilution"
      },
      {
        OptionName -> SerialDilutionFactor,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> RangeP[1,10^23]
        ],
        Description -> "For each sample, the factor by which the concentration of the TargetAnalyte in the resulting sample of the previous dilution step is reduced. For example, if the CumulativeDilutionFactor is equal to {10,100,1000}. SerialDilutionFactor will resolve to {10,10,10}. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Sample Dilution"
      },
      {
        OptionName -> TargetAnalyteConcentration,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> Alternatives[
            (*1*)GreaterP[0 Molar],
            (*2*)GreaterP[0 Gram/Liter],
            (*3*)GreaterP[0 EmeraldCell/Milliliter],
            (*4*)GreaterP[0 OD600],
            (*5*)GreaterP[0 CFU/Milliliter],
            (*6*)GreaterP[0 RelativeNephelometricUnit],
            (*7*)GreaterP[0 NephelometricTurbidityUnit],
            (*8*)GreaterP[0 FormazinTurbidityUnit]
          ],
          Units -> Alternatives[
            (*1*){1,{Micromolar,{Nanomolar,Micromolar,Millimolar,Molar}}},
            (*2*)CompoundUnit[{1,{Milligram,{Microgram,Milligram,Gram}}},{-1,{Liter,{Microliter,Milliliter,Liter}}}],
            (*3*)CompoundUnit[EmeraldCell,{-1,{Milliliter,{Microliter,Milliliter,Liter}}}],
            (*4*)OD600,
            (*5*)CompoundUnit[CFU,{-1,{Milliliter,{Microliter,Milliliter,Liter}}}],
            (*6*)RelativeNephelometricUnit,
            (*7*)NephelometricTurbidityUnit,
            (*8*)FormazinTurbidityUnit
          ]
        ],
        Description -> "For each sample, the desired concentration of TargetAnalyte in the final diluted sample. The length of this list must match the corresponding value in NumberOfDilutions. For example, if SerialDilutionFactor is {10,10,10} and the initial concentration of TargetAnalyte is 10 M. The value of TargetAnalyteConcentration will resolve to {1 M, 0.1 M, 0.01 M}.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Sample Dilution"
      },
      {
        OptionName -> TransferVolume,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type->Quantity,
          Pattern:>RangeP[0 Milliliter,$MaxTransferVolume],
          Units->{1,{Milliliter,{Microliter,Milliliter,Liter}}}
        ],
        Description -> "For each sample, if DilutionType is set to LinearDilution, the amount of sample that is diluted with Buffer. If DilutionType is set to Serial, the amount of sample transferred from the resulting sample of one round of the dilution series to the next sample in the series. The first transfer source is the original sample provided. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Sample Dilution"
      },
      {
        OptionName -> TotalDilutionVolume,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type->Quantity,
          Pattern:>RangeP[0Milliliter,$MaxTransferVolume],
          Units->{1,{Milliliter,{Microliter,Milliliter,Liter}}}
        ],
        Description -> "For each sample, the total volume of sample, buffer, concentrated buffer, and concentrated buffer diluent. If DilutionType is set to Serial, this is also the volume of the resulting sample before TransferVolume has been removed for use in the next dilution in the series. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Sample Dilution"
      },
      {
        OptionName -> FinalVolume,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type->Quantity,
          Pattern:>RangeP[0Milliliter,$MaxTransferVolume],
          Units->{1,{Milliliter,{Microliter,Milliliter,Liter}}}
        ],
        Description -> "For each sample, if DilutionType is set to Serial, the volume of the resulting diluted sample after TransferVolume has been removed for use in the next dilution in the series. To control the volume of the final sample in the series, see the DiscardFinalTransfer option. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Sample Dilution"
      },
      {
        OptionName -> DiscardFinalTransfer,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "For each sample, if DilutionType is Serial, indicates if, after the final dilution is complete, TransferVolume should be removed from the final dilution container.",
        ResolutionDescription->"If DilutionType is Serial, automatically set to False.",
        Category -> "Sample Dilution"
      },

      (* Diluent Preparation *)
      {
        OptionName -> Diluent,
        Default -> Automatic,
        (* This is AllowNull -> True because in the Linear case if you just use
        ConcentratedBuffer/ConcentratedBufferDiluent it is possible there is no corresponding Diluent sample *)
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents", "Water"},
            {Object[Catalog, "Root"], "Materials", "Reagents", "Solvents"},
            {Object[Catalog, "Root"], "Materials", "Reagents", "Buffers"},
            {Object[Catalog, "Root"], "Materials", "Cell Culture", "Lysis Buffers"},
            {Object[Catalog, "Root"], "Materials", "Cell Culture", "Media"}
          }
        ],
        Description -> "For each sample, the solution used to reduce the concentration of the sample.",
        ResolutionDescription -> "Automatically set to the Media field of the input sample, if it is populated. If it is not populated, automatically set to the Solvent field of the input sample.",
        Category -> "Diluent Preparation"
      },
      {
        OptionName -> DiluentVolume,
        Default -> Automatic,
        (* AllowNull->True logic is the same as Diluent *)
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Milliliter,$MaxTransferVolume],
          Units -> {1,{Milliliter,{Microliter,Milliliter,Liter}}}
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the amount of diluent added to dilute the sample. If DilutionType is set to Serial, the amount of diluent added to dilute the sample at each stage of the dilution. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Diluent Preparation"
      },
      {
        OptionName -> ConcentratedBuffer,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents", "Solvents"},
            {Object[Catalog, "Root"], "Materials", "Reagents", "Buffers"}
          }
        ],
        Description -> "For each sample, a concentrated version of Buffer that has the same BaselineStock and can be used in place of Buffer if Buffer is not fulfillable but ConcentratedBuffer and ConcentratedBufferDiluent are. Additionally, if DilutionType is set to Serial and the sample Solvent does not match Buffer, but is the ConcentratedBufferDiluent of ConcentratedBuffer, this sample can also be used as a component in an initial mixture to change the Solvent of the input sample to the desired target Buffer.",
        ResolutionDescription -> "If Diluent is not fulfillable or Diluent does not match the Media/Solvent of the input sample, automatically set to a concentrated version of Diluent that is fulfillable. See the documentation for SampleFulfillableQ for more information about when a sample is fulfillable.",
        Category -> "Diluent Preparation"
      },
      {
        OptionName -> ConcentratedBufferVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0Microliter,$MaxTransferVolume],
          Units -> {1,{Milliliter,{Microliter,Milliliter,Liter}}}
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the amount of concentrated buffer added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer added to dilute the sample at each stage of the dilution. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Diluent Preparation"
      },
      {
        OptionName -> ConcentratedBufferDiluent,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample],Model[Sample]}],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Materials", "Reagents", "Water"},
            {Object[Catalog, "Root"], "Materials", "Reagents", "Solvents"},
            {Object[Catalog, "Root"], "Materials", "Reagents", "Buffers"},
            {Object[Catalog, "Root"], "Materials", "Cell Culture", "Lysis Buffers"},
            {Object[Catalog, "Root"], "Materials", "Cell Culture", "Media"}
          }
        ],
        Description -> "For each sample, the solution used to reduce the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor. The ConcentratedBuffer and ConcentratedBufferDiluent are combined and then mixed with the sample.",
        ResolutionDescription -> "Automatically set to the ConcentratedBufferDiluent of the ConcentratedBuffer.",
        Category -> "Diluent Preparation"
      },
      {
        OptionName -> ConcentratedBufferDilutionFactor,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[0,1]
        ],
        Description -> "For each sample, the factor by which to reduce ConcentratedBuffer before it is combined with the sample.  The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "If Diluent is set, automatically set to ConcentratedBufferDilutionFactor of ConcentratedBuffer / ConcentratedBufferDilutionFactor of Diluent. If Diluent is not set, automatically set to ConcentratedBufferDilutionFactor of ConcentratedBuffer.",
        NestedIndexMatching -> True,
        Category -> "Diluent Preparation"
      },
      {
        OptionName -> ConcentratedBufferDiluentVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0Microliter,$MaxTransferVolume],
          Units -> {1,{Milliliter,{Microliter,Milliliter,Liter}}}
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the amount of concentrated buffer diluent added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer diluent added to dilute the sample at each stage of the dilution. The length of this list must match the corresponding value in NumberOfDilutions.",
        ResolutionDescription -> "Automatically set based on the systems of equations specified under the DilutionType option.",
        NestedIndexMatching -> True,
        Category -> "Diluent Preparation"
      },

      (* ----- Mixing ----- *)
      {
        OptionName -> Incubate,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "For each sample, if DilutionType is set to Linear, indicates if the sample is incubated following the dilution. If DilutionType is set to Serial, indicates if the resulting sample after a round of dilution is incubated before moving to the next stage in the dilution.",
        ResolutionDescription -> "Automatically set to True if any of the corresponding Incubation or Mixing options are set.",
        Category -> "Mixing"
      },
      {
        OptionName -> IncubationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Minute,$MaxExperimentTime],
          Units->{1,{Minute,{Second,Minute,Hour}}}
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the duration of time for which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the duration of time for which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
        ResolutionDescription -> "Automatically set to 30 minutes if MixType is set to Roll, Vortex, Sonicate, Stir, Shake, Homogenize, Swirl, Disrupt, or Nutate.",
        Category -> "Mixing"
      },
      {
        OptionName -> IncubationInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
          OpenPaths -> {
            {Object[Catalog, "Root"], "Instruments", "Mixing Devices"},
            {Object[Catalog, "Root"], "Instruments", "Heating", "Heat Blocks"},
            {Object[Catalog, "Root"], "Instruments", "Thermocyclers"},
            {Object[Catalog, "Root"], "Instruments", "Liquid Handling","Serological Pipettes"},
            {Object[Catalog, "Root"], "Instruments", "Liquid Handling","Pipettes"}
          }
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the instrument used to mix/incubate the sample following the dilution. If DilutionType is set to Serial, the instrument used to mix/incubate the resulting sample after a round of dilution before the next stage of dilution.",
        ResolutionDescription -> "Automatically set based on the options MixType, IncubationTemperature, and the container of the sample. Consult the MixDevices function for more specific information.",
        Category -> "Mixing"
      },
      {
        OptionName -> IncubationTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Temperature" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
            Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
          ],
          "Ambient" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the temperature at which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the temperature at which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
        ResolutionDescription -> "Automatically set to Ambient, if Incubation is set to True.",
        Category -> "Mixing"
      },
      {
        OptionName -> MixType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> MixTypeP
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the style of motion used to mix the sample following the dilution. If DilutionType is set to Serial, the style of motion used to mix the resulting sample after a round of dilution before the next stage of dilution.",
        ResolutionDescription -> "Automatically set based on the options IncubationInstrument, IncubationTemperature, and the container of the sample. Consult the MixDevices function for more specific information.",
        Category -> "Mixing"
      },
      {
        OptionName->NumberOfMixes,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Number,
          Pattern:>RangeP[1, $MaxNumberOfMixes, 1]
        ],
        Description->"For each sample, if DilutionType is set to Linear, the number of times the sample is mixed following the dilution. If DilutionType is set to Serial, the number of times the resulting sample after a round of dilution is mixed before the next stage of dilution. In both cases, this option applies to discrete mixing processes such as Pipette or Invert.",
        ResolutionDescription -> "If MixType is either Invert, Swirl, or Pipette, automatically set to 15.",
        Category->"Mixing"
      },
      {
        OptionName -> MixRate,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "RPM" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[$MinMixRate, $MaxMixRate],
            Units->RPM
          ],
          "Gravitational Acceleration (Acoustic Shaker Only)" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 GravitationalAcceleration, 100 GravitationalAcceleration],
            Units->GravitationalAcceleration
          ]
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the frequency of rotation the mixing instrument should use to mix the sample following the dilution. If DilutionType is set to Serial, the frequency of rotation the mixing instrument should use to mix the resulting sample after a round of dilution before the next stage of dilution. In both cases, this option applies to discrete mixing processes such as Pipette or Invert.",
        ResolutionDescription -> "If MixType is set to Vortex, Roll, Shake, Stir, Disrupt, or Nutate, MixDevices is used to find an instrument that can support the container footprint. MixRate is then automatically set to the average of the minimum rate and maximum rate of the chosen instrument.",
        Category -> "Mixing"
      },
      {
        OptionName -> MixOscillationAngle,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 AngularDegree, 15 AngularDegree],
          Units :> AngularDegree
        ],
        Description -> "For each sample, if DilutionType is set to Linear, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the sample following the dilution. If DilutionType is set to Serial, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the resulting sample after a round of dilution before the next stage of dilution.",
        ResolutionDescription -> "Automatically set to 15 AngularDegree if a wrist action shaker or orbital shaker is specified as the IncubationInstrument.",
        Category -> "Mixing"
      }
    ]
  }
];

(* ::Subsection:: *)
(* DilutionSharedOptions - Messages *)
Error::InvalidNumberOfDilutions = "For the sample(s), `1`, at indices, `4`, the inner length of the option(s) `2` do not match the value of NumberOfDilutions, `3`. Please change the inner length of `2` or the value of NumberOfDilutions to make them equal.";
Warning::NoDiluentSpecified = "For the sample(s), `1`, at indices, `2`, neither a Diluent or ConcentratedBuffer was specified. Model[Sample,Milli-Q water] will be used as the Diluent.";
Warning::MissingTargetAnalyteInitialConcentration = "For the sample(s), `1`, at indices, `2`, a concentration for the TargetAnalyte could not be found in the sample composition. TargetAnalyteConcentration could not be calculated and set to Null as a result.";
Error::ConflictingFactorsAndVolumes = "For the sample(s), `1`, at indices, `2`, the provided dilution factors and volumes are mathematically conflicting. Please refer to the equations in the help file and make sure the values provided are mathematically possible.";
Warning::NoSampleVolume = "For the sample(s), `1`, at indices, `2`, a sample volume could not be found or calculated. The volume of the sample is assumed to be 1 Milliliter. If this is not correct, please measure the volume or mass of the sample.";
Error::DilutionTypeAndStrategyMismatch = "The sample(s) `1`, at indices `4`, have conflicting dilution type and strategy. DilutionType is set to `2`, but DilutionStrategy is set to `3`. If DilutionType is Linear, DilutionStrategy must be Null. If DilutionType is Serial, DilutionStrategy must be Series or Endpoint. Please fix these conflicting options to specify a valid experiment.";
Error::OverspecifiedDilution = "The sample(s) `1`, at indices `4`, have overspecified dilutions. Diluent is set to `2` and ConcentratedBuffer is set to `3`. Only one of Diluent and ConcentratedBuffer can be specified. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingConcentratedBufferParameters = "The sample(s), `1`, at indices, `7`, have conflicting ConcentratedBuffer options. ConcentratedBuffer is set to `2`, but ConcentratedBufferVolume -> `3`, ConcentratedBufferDiluentVolume -> `4`, ConcentratedBufferDiluent -> `5`, and ConcentratedBufferDilutionFactor -> `6`. If ConcentratedBuffer is not Null, ConcentratedBufferVolume, ConcentratedBufferDiluentVolume, ConcentratedBufferDiluent, and ConcentratedBufferDilutionFactor must be specified. If ConcentratedBuffer is set to Null, ConcentratedBufferVolume, ConcentratedBufferDiluentVolume, ConcentratedBufferDiluent, and ConcentratedBufferDilutionFactor cannot be specified. Please fix these conflicting options to specify a valid experiment.";
Error::ConflictingDiluentParameters = "The sample(s), `1`, at indices, `4`, have conflicting Diluent options. Diluent is set to `2`, but DiluentVolume -> `3`. If Diluent is not Null, DiluentVolume must be specified. If Diluent is set to Null, DiluentVolume cannot be specified. Please fix these conflicting options to specify a valid experiment.";
Error::VolumesTooLarge = "The sample(s), `1`, at indices, `6`, have provided dilution factors and volumes that are not possible in ECL. All volumes must be between 0.1 Microliter and 20 Liter. The following volume options are TransferVolume -> `2`, DiluentVolume -> `3`, ConcentratedBufferVolume -> `4`, ConcentratedBufferDiluentVolume -> `5`. Please adjust the specified volumes and dilution factors to specify a valid experiment.";
Error::MultipleTargetAnalyteConcentrationUnitsError = "The sample(s), `1`, at indices, `3`, have multiple different units specified for the values in TargetAnalyteConcentration. The unit `2` will be used. Please only specify a single unit for the values of this option.";
Error::ConflictingTargetAnalyteConcentrationUnitsError = "For the sample(s), `1`, at the indices, `5`, the units of TargetAnalyteConcentration, `2`, are not compatible with the units of the TargetAnalyte in the sample composition, `3`. Please change the units of TargetAnalyteConcentration or add a StandardCurve to the TargetAnalyte Model, `4`, that can convert between the two units.";

(* ::Subsection:: *)
(* DilutionSharedOptions - OptionResolver *)

DefineOptions[ResolveDilutionSharedOptions,
  Options :> {
    DilutionSharedOptions,
    CacheOption,
    SimulationOption,
    HelperOutputOption,
    PreparationOption
  }
];

ResolveDilutionSharedOptions[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[]] := Module[
  {
    outputSpecification,output,gatherTests,messages,warnings,cache,simulation,
    validLengths,validLengthTests,expandedSafeOps,validExpandedLengths,validExpandedLengthErrors,validExpandedLengthTests,
    listedSamplesNamed,listedOptionsNamed,safeOpsNamed,safeOpsTests,listedSamples,
    safeOps,listedOptions,currentSimulation,

    (* Options to download from *)
    diluent,concentratedBuffer,concentratedBufferDiluent,diluentObjects,
    diluentModels, concentratedBufferObjects,concentratedBufferModels,
    concentratedBufferDiluentObjects, concentratedBufferDiluentModels,

    (* Packets to download packets *)
    objectSampleFields,objectSamplePacketFields,modelSampleFields,modelSamplePacketFields,

    (* Downloaded Packets *)
    (* 1 *)samplePackets,
    (* 2 *)diluentObjectPackets,
    (* 3 *)diluentModelPackets,
    (* 4 *)concentratedBufferObjectPackets,
    (* 5 *)concentratedBufferModelPackets,
    (* 6 *)concentratedBufferDiluentObjectPackets,
    (* 7 *)concentratedBufferDiluentModelPackets,
    (* 8 *)sampleSolventPackets,
    (* 9 *)sampleMediaPackets,

    (* Caching *)
    combinedCache,fastAssoc,mapThreadFriendlyOptions,

    (* Rounding *)
    optionPrecisions,roundedDilutionSharedOptions,optionPrecisionTests,

    (* Preparation *)
    preparationResult,allowedPreparation,preparationTest,resolvedPreparation,

    (* Errors and warnings *)
    noDiluentSpecifiedWarnings,
    missingTargetAnalyteInitialConcentrationWarnings,
    conflictingFactorsAndVolumesErrors,
    noSampleVolumeWarnings,
    multipleTargetAnalyteConcentrationUnitsErrors,
    conflictingTargetAnalyteConcentrationUnitsErrors,
    targetAnalyteTests,

    (* Resolved mapthread options *)
    resolvedDilutionTypes,
    resolvedDilutionStrategies,
    resolvedNumberOfDilutions,
    resolvedTargetAnalytes,
    resolvedDiluents,
    resolvedConcentratedBuffers,
    resolvedConcentratedBufferDiluents,
    resolvedCumulativeDilutionFactors,
    resolvedSerialDilutionFactors,
    resolvedTargetAnalyteConcentrations,
    resolvedTransferVolumes,
    resolvedTotalDilutionVolumes,
    resolvedDiscardFinalTransfers,
    resolvedFinalVolumes,
    resolvedDiluentVolumes,
    resolvedConcentratedBufferVolumes,
    resolvedConcentratedBufferDiluentVolumes,
    resolvedConcentratedBufferDilutionFactors,
    resolvedIncubates,

    (* Sample creation for mix *)
    simulatedSamples,simulatedSampleAndContainerSimulation,

    (* Mix options *)
    resolvedIncubationTimes,
    resolvedIncubationInstruments,
    resolvedIncubationTemperatures,
    resolvedMixTypes,
    resolvedNumberOfMixes,
    resolvedMixRates,
    resolvedMixOscillationAngles,

    (* Mix tests *)
    experimentMixTests,

    (* Invalid options and tests *)
    conflictingFactorsAndVolumesOptions,conflictingFactorsAndVolumesTests,
    multipleTargetAnalyteConcentrationUnitsOptions,multipleTargetAnalyteConcentrationUnitsTests,
    conflictingTargetAnalyteConcentrationUnitsOptions,conflictingTargetAnalyteConcentrationUnitsTests,

    (* Resolved options *)
    resolvedOptions,collapsedResolvedOptions,

    (* Conflicting option checks *)
    dilutionTypeStrategyMismatch,dilutionTypeStrategyMismatchTests,
    overspecifiedDilutionMismatch,overspecifiedDilutionMismatchTests,
    conflictingConcentratedBufferOptionsResult,conflictingConcentratedBufferOptionsTests,
    conflictingDiluentOptionsResult,conflictingDiluentOptionsTests,
    invalidResolvedVolumes,invalidResolvedVolumeTests,invalidMixOptions,
    invalidOptions, invalidInputs, allTests
  },

  (* Set up user specified options and cache *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  (* warnings assume we're not in engine; if we are they are not surfaced *)
  gatherTests = MemberQ[output,Tests];
  messages = !gatherTests;
  warnings = !gatherTests && !MatchQ[$ECLApplication, Engine];

  (* Remove all Temporal links *)
  {listedSamplesNamed, listedOptionsNamed} = removeLinks[mySamples, ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ResolveDilutionSharedOptions,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ResolveDilutionSharedOptions,listedOptionsNamed,AutoCorrect->False],{}}
  ];

  (*change all Names to objects *)
  {listedSamples, safeOps, listedOptions} = sanitizeInputs[ToList[listedSamplesNamed], safeOpsNamed, listedOptionsNamed, Simulation -> Lookup[safeOpsNamed, Simulation]];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[safeOps, Cache, {}];
  simulation = Lookup[safeOps, Simulation, Null];
  currentSimulation = If[NullQ[simulation],
    Simulation[],
    simulation
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ResolveDilutionSharedOptions,{listedSamples},listedOptions,Output->{Result,Tests}],
    {ValidInputLengthsQ[ResolveDilutionSharedOptions,{listedSamples},listedOptions],{}}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests
    }]
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests]
    }]
  ];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ResolveDilutionSharedOptions, {listedSamples},safeOps]];

  (* Do an extra check to make sure that any nested index matching options have the proper length *)
  (* NOTE: Their length needs to be the value of NumberOfDilutions *)

  (* Get the options that are invalid for each sample *)
  validExpandedLengths = MapThread[
    Function[
      {
        numberOfDilutions,cumulativeDilutionFactors,serialDilutionFactors,targetAnalyteConcentrations,
        transferVolumes,totalDilutionVolumes,finalVolumes,diluentVolumes,concentratedBufferVolumes,
        concentratedBufferDiluentVolumes,concentratedBufferDilutionFactors
      },
      Module[{invalidOptionsForSample},

        invalidOptionsForSample = {};

        (* We know we are always good if numberOfDilutions is Automatic *)
        If[MatchQ[numberOfDilutions,Automatic],
          Null,
          Map[
            Function[{optionInfo},
              If[!(MatchQ[optionInfo[[2]],{Automatic..}] || MatchQ[optionInfo[[2]],Except[_List]] || (MatchQ[optionInfo[[2]],_List] && MatchQ[Length[optionInfo[[2]]],numberOfDilutions])),
                invalidOptionsForSample = Append[invalidOptionsForSample,optionInfo[[1]]]
              ]],
            {
              {CumulativeDilutionFactor,cumulativeDilutionFactors},
              {SerialDilutionFactor,serialDilutionFactors},
              {TargetAnalyteConcentration,targetAnalyteConcentrations},
              {TransferVolume,transferVolumes},
              {TotalDilutionVolume,totalDilutionVolumes},
              {FinalVolume,finalVolumes},
              {DiluentVolume,diluentVolumes},
              {ConcentratedBufferVolume,concentratedBufferVolumes},
              {ConcentratedBufferDiluentVolume,concentratedBufferDiluentVolumes},
              {ConcentratedBufferDilutionFactor,concentratedBufferDilutionFactors}
            }
          ]
        ];

        invalidOptionsForSample
      ]
    ],
    {
      Lookup[expandedSafeOps, NumberOfDilutions],
      Lookup[expandedSafeOps, CumulativeDilutionFactor],
      Lookup[expandedSafeOps, SerialDilutionFactor],
      Lookup[expandedSafeOps, TargetAnalyteConcentration],
      Lookup[expandedSafeOps, TransferVolume],
      Lookup[expandedSafeOps, TotalDilutionVolume],
      Lookup[expandedSafeOps, FinalVolume],
      Lookup[expandedSafeOps, DiluentVolume],
      Lookup[expandedSafeOps, ConcentratedBufferVolume],
      Lookup[expandedSafeOps, ConcentratedBufferDiluentVolume],
      Lookup[expandedSafeOps, ConcentratedBufferDilutionFactor]
    }
  ];

  (* Create a list of booleans so we can pick list *)
  validExpandedLengthErrors = (Length[#] > 0)&/@validExpandedLengths;

  (* Create tests for this check *)
  validExpandedLengthTests = If[gatherTests,
    Module[{failingSamples,passingSamples,failingSampleTests,passingSampleTests},
      (*Get the inputs that fail this test*)
      failingSamples=PickList[listedSamples,validExpandedLengthErrors];

      (*Get the inputs that pass this test*)
      passingSamples=PickList[listedSamples,validExpandedLengthErrors,False];

      (*Create a test for the non-passing inputs*)
      failingSampleTests=If[Length[failingSamples]>0,
        Test["For the following samples "<>ObjectToString[failingSamples,Cache->cache]<>", the provided nested lengths align with NumberOfDilutions:",False,True],
        Nothing
      ];

      (*Create a test for the passing inputs*)
      passingSampleTests=If[Length[passingSamples]>0,
        Test["For the following samples "<>ObjectToString[passingSamples,Cache->cache]<>", the provided nested lengths align with NumberOfDilutions:",True,True],
        Nothing
      ];

      (*Return the created tests*)
      {failingSampleTests,passingSampleTests}
    ],
    {}
  ];

  (* Throw a message if we are throwing messages and have invalid options *)
  If[MemberQ[validExpandedLengthErrors,True] && messages,
    Message[Error::InvalidNumberOfDilutions,
      ObjectToString[PickList[listedSamples,validExpandedLengthErrors]],
      validExpandedLengths,
      PickList[Lookup[expandedSafeOps,NumberOfDilutions],validExpandedLengthErrors],
      PickList[Range[Length[listedSamples]],validExpandedLengthErrors]
    ]
  ];

  (* If nested option lengths are invalid, return $Failed or tests up until this point *)
  If[Or@@validExpandedLengthErrors,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,validExpandedLengthTests]
    }]
  ];

  (* Pull the info out of the options that we need to download from *)
  {
    diluent,concentratedBuffer,concentratedBufferDiluent
  } = Lookup[expandedSafeOps,
    {
      Diluent,ConcentratedBuffer,ConcentratedBufferDiluent
    }
  ];

  (* Split the fields to download into objects and models *)
  diluentObjects = DeleteDuplicates@Cases[diluent,ObjectP[Object[Sample]]];
  diluentModels= DeleteDuplicates@Cases[diluent,ObjectP[Model[Sample]]];
  concentratedBufferObjects = DeleteDuplicates@Cases[concentratedBuffer,ObjectP[Object[Sample]]];
  concentratedBufferModels = DeleteDuplicates@Cases[concentratedBuffer,ObjectP[Model[Sample]]];
  concentratedBufferDiluentObjects = DeleteDuplicates@Cases[concentratedBufferDiluent,ObjectP[Object[Sample]]];
  concentratedBufferDiluentModels = DeleteDuplicates@Cases[concentratedBufferDiluent,ObjectP[Model[Sample]]];

  objectSampleFields = DeleteDuplicates[{Media,Solvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,SamplePreparationCacheFields[Object[Sample],Format->Sequence]}];
  objectSamplePacketFields = Packet@@objectSampleFields;

  modelSampleFields = DeleteDuplicates[{Media,Solvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock,SamplePreparationCacheFields[Model[Sample],Format->Sequence]}];
  modelSamplePacketFields = Packet@@modelSampleFields;

  (* - Big Download to make cacheBall and get cache packets *)
  {
    (* 1 *)samplePackets,
    (* 2 *)diluentObjectPackets,
    (* 3 *)diluentModelPackets,
    (* 4 *)concentratedBufferObjectPackets,
    (* 5 *)concentratedBufferModelPackets,
    (* 6 *)concentratedBufferDiluentObjectPackets,
    (* 7 *)concentratedBufferDiluentModelPackets,
    (* 8 *)sampleSolventPackets,
    (* 9 *)sampleMediaPackets
  } = Quiet[
    Download[
      {
        listedSamples,
        diluentObjects,
        diluentModels,
        concentratedBufferObjects,
        concentratedBufferModels,
        concentratedBufferDiluentObjects,
        concentratedBufferDiluentModels,
        listedSamples,
        listedSamples
      },
      {
        {objectSamplePacketFields},
        {objectSamplePacketFields},
        {modelSamplePacketFields},
        {objectSamplePacketFields},
        {modelSamplePacketFields},
        {objectSamplePacketFields},
        {modelSamplePacketFields},
        {Solvent[modelSamplePacketFields]},
        {Media[modelSamplePacketFields]}
      },
      Cache->cache,
      Simulation->currentSimulation
    ],
    {Download::FieldDoesntExist, Download::NotLinkField, Download::ObjectDoesNotExist}
  ];

  (* Set up caches/fast assocs *)
  combinedCache = Experiment`Private`FlattenCachePackets[{
    (* 1 *)samplePackets,
    (* 2 *)diluentObjectPackets,
    (* 3 *)diluentModelPackets,
    (* 4 *)concentratedBufferObjectPackets,
    (* 5 *)concentratedBufferModelPackets,
    (* 6 *)concentratedBufferDiluentObjectPackets,
    (* 7 *)concentratedBufferDiluentModelPackets,
    (* 8 *)sampleSolventPackets,
    (* 9 *)sampleMediaPackets}
  ];

  (* Set up fast assoc *)
  fastAssoc = Experiment`Private`makeFastAssocFromCache[combinedCache];

  (* Do options precision checks *)
  optionPrecisions = {
    TransferVolume -> 0.1 Microliter,
    TotalDilutionVolume -> 0.1 Microliter,
    FinalVolume -> 0.1 Microliter,
    DiluentVolume -> 0.1 Microliter,
    ConcentratedBufferVolume -> 0.1 Microliter,
    ConcentratedBufferDiluentVolume -> 0.1 Microliter,
    IncubationTime -> 1 Second,
    IncubationTemperature -> 1 Celsius,
    MixRate -> 1 RPM,
    MixOscillationAngle -> 1 AngularDegree
  };

  (* There are still a few options that we need to check the precisions of though. *)
  {roundedDilutionSharedOptions,optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[Association@@listedOptions,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];

  (* Resolve our preparation option. *)
  preparationResult=Check[
    {allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
      {
        resolveDilutionSharedOptionsMethod[listedSamples, ReplaceRule[listedOptions, {Cache->combinedCache, Output->Result}]],
        {}
      },
      resolveDilutionSharedOptionsMethod[listedSamples, ReplaceRule[listedOptions, {Cache->combinedCache, Output->{Result, Tests}}]]
    ],
    $Failed
  ];

  (* If Robotic is possible, use it *)
  resolvedPreparation = If[MemberQ[allowedPreparation,Robotic],
    Robotic,
    Manual
  ];

  (* Map thread our options *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ResolveDilutionSharedOptions,expandedSafeOps];

  (* Resolve the options inside the mapthread *)
  {
    noDiluentSpecifiedWarnings,
    missingTargetAnalyteInitialConcentrationWarnings,
    conflictingFactorsAndVolumesErrors,
    noSampleVolumeWarnings,
    multipleTargetAnalyteConcentrationUnitsErrors,
    conflictingTargetAnalyteConcentrationUnitsErrors,
    targetAnalyteTests,

    resolvedDilutionTypes,
    resolvedDilutionStrategies,
    resolvedNumberOfDilutions,
    resolvedTargetAnalytes,
    resolvedDiluents,
    resolvedConcentratedBuffers,
    resolvedConcentratedBufferDiluents,
    resolvedCumulativeDilutionFactors,
    resolvedSerialDilutionFactors,
    resolvedTargetAnalyteConcentrations,
    resolvedTransferVolumes,
    resolvedTotalDilutionVolumes,
    resolvedDiscardFinalTransfers,
    resolvedFinalVolumes,
    resolvedDiluentVolumes,
    resolvedConcentratedBufferVolumes,
    resolvedConcentratedBufferDiluentVolumes,
    resolvedConcentratedBufferDilutionFactors,
    resolvedIncubates
  } = Transpose[MapThread[Function[{mySample,myMapThreadOptions},
    Module[
      {
        (* Warnings and Errors *)
        noDiluentSpecifiedWarning,noTargetAnalyteFound,noTargetAnalyteInitialConcentrationFound,missingTargetAnalyteInitialConcentrationWarning,
        conflictingFactorsAndVolumesError,noSampleVolumeWarning,unableToConvertError,multipleTargetAnalyteConcentrationUnitsError,
        conflictingTargetAnalyteConcentrationUnitsError,

        (* User Specified options *)
        specifiedDilutionType, specifiedDilutionStrategy, specifiedNumberOfDilutions, specifiedTargetAnalyte,
        specifiedDiluent, specifiedConcentratedBuffer, specifiedConcentratedBufferDiluent, specifiedCumulativeDilutionFactor,
        specifiedSerialDilutionFactor, specifiedTargetAnalyteConcentration,
        specifiedTransferVolume, specifiedTotalDilutionVolume, specifiedDiscardFinalTransfer,
        specifiedFinalVolume, specifiedDiluentVolume, specifiedConcentratedBufferVolume, specifiedConcentratedBufferDiluentVolume,
        specifiedConcentratedBufferDilutionFactor, specifiedIncubate, specifiedIncubationTime, specifiedIncubationInstrument,
        specifiedIncubationTemperature, specifiedMixType, specifiedNumberOfMixes, specifiedMixRate, specifiedMixOscillationAngle,

        (* Other Variables *)
        targetAnalyteTests,diluentCase,targetAnalyteInitialConcentration,
        expandedSpecifiedCumulativeDilutionFactor,
        expandedSpecifiedSerialDilutionFactor,
        expandedSpecifiedTargetAnalyteConcentration,
        expandedSpecifiedTransferVolume,
        expandedSpecifiedTotalDilutionVolume,
        expandedSpecifiedFinalVolume,
        expandedSpecifiedDiluentVolume,
        expandedSpecifiedConcentratedBufferVolume,
        expandedSpecifiedConcentratedBufferDiluentVolume,
        expandedSpecifiedConcentratedBufferDilutionFactor,
        concentrationUnits,convertedTargetAnalyteInitialConcentration,
        intermediateFinalVolume,intermediateSerialDilutionFactor,
        intermediateConcentratedBufferVolume,intermediateConcentratedBufferDiluentVolume,
        intermediateTransferVolume,intermediateDiluentVolume,intermediateTotalDilutionVolume,
        roundedResolvedFinalVolume,

        (* Resolved options *)
        resolvedDilutionType, resolvedDilutionStrategy, resolvedNumberOfDilutions, resolvedTargetAnalyte,
        resolvedDiluent, resolvedConcentratedBuffer, resolvedConcentratedBufferDiluent, resolvedCumulativeDilutionFactor,
        resolvedSerialDilutionFactor, resolvedTargetAnalyteConcentration, resolvedTransferVolume, resolvedTotalDilutionVolume,
        resolvedDiscardFinalTransfer, resolvedFinalVolume, resolvedDiluentVolume, resolvedConcentratedBufferVolume,
        resolvedConcentratedBufferDiluentVolume, resolvedConcentratedBufferDilutionFactor, resolvedIncubate
      },

      (* Set up error tracking variables *)
      {
        noDiluentSpecifiedWarning,
        noTargetAnalyteFound,
        noTargetAnalyteInitialConcentrationFound,
        missingTargetAnalyteInitialConcentrationWarning,
        conflictingFactorsAndVolumesError,
        noSampleVolumeWarning,
        unableToConvertError
      } = ConstantArray[False,7];

      multipleTargetAnalyteConcentrationUnitsError = {False,Null};
      conflictingTargetAnalyteConcentrationUnitsError = {False,Null,Null};

      (* Lookup specified options *)
      {
        specifiedDilutionType, specifiedDilutionStrategy, specifiedNumberOfDilutions, specifiedTargetAnalyte,
        specifiedDiluent, specifiedConcentratedBuffer, specifiedConcentratedBufferDiluent, specifiedCumulativeDilutionFactor,
        specifiedSerialDilutionFactor, specifiedTargetAnalyteConcentration,
        specifiedTransferVolume, specifiedTotalDilutionVolume, specifiedDiscardFinalTransfer,
        specifiedFinalVolume, specifiedDiluentVolume, specifiedConcentratedBufferVolume, specifiedConcentratedBufferDiluentVolume,
        specifiedConcentratedBufferDilutionFactor, specifiedIncubate, specifiedIncubationTime, specifiedIncubationInstrument,
        specifiedIncubationTemperature, specifiedMixType,specifiedNumberOfMixes, specifiedMixRate, specifiedMixOscillationAngle
      } = Lookup[myMapThreadOptions,
        {
          DilutionType, DilutionStrategy, NumberOfDilutions, TargetAnalyte,
          Diluent, ConcentratedBuffer, ConcentratedBufferDiluent, CumulativeDilutionFactor,
          SerialDilutionFactor, TargetAnalyteConcentration, TransferVolume, TotalDilutionVolume,
          DiscardFinalTransfer, FinalVolume, DiluentVolume, ConcentratedBufferVolume,
          ConcentratedBufferDiluentVolume, ConcentratedBufferDilutionFactor, Incubate, IncubationTime,
          IncubationInstrument, IncubationTemperature, MixType, NumberOfMixes, MixRate, MixOscillationAngle
        }
      ];

      (* Resolve DilutionType - just leave it as it is (Defaults to Linear in option def) *)
      resolvedDilutionType = specifiedDilutionType;

      (* Resolve DilutionStrategy *)
      (* If the option is specified - leave it *)
      resolvedDilutionStrategy = If[MatchQ[specifiedDilutionStrategy,Except[Automatic]],
        specifiedDilutionStrategy,

        (* If it is Automatic, resolve based on DilutionType *)
        If[MatchQ[resolvedDilutionType,Serial],
          Endpoint,
          Null
        ]
      ];

      (* Resolve NumberOfDilutions *)
      resolvedNumberOfDilutions = Module[{lengths,lengthToUse},

        (* If any of TargetAnalyteConcentration, CumulativeDilutionFactor, SerialDilutionFactor, or TransferVolume *)
        (* are set, get the length *)
        lengths = Length[ToList[#]]&/@{specifiedTargetAnalyteConcentration,specifiedCumulativeDilutionFactor,specifiedSerialDilutionFactor,specifiedTransferVolume};

        (* Default to length 1 if none of the options are set *)
        lengthToUse = FirstOrDefault[Select[lengths,IntegerQ[#]&&GreaterQ[#,1]&],1];

        (* Keep the option if it is specified, otherwise use our found value *)
        If[MatchQ[specifiedNumberOfDilutions,Except[Automatic]],
          specifiedNumberOfDilutions,
          lengthToUse
        ]
      ];

      (* Resolve TargetAnalyte *)
      {resolvedTargetAnalyte,targetAnalyteTests} = If[MatchQ[specifiedTargetAnalyte,Except[Automatic]],
        (* If the target analyte was specified, keep it *)
        {specifiedTargetAnalyte,Null},

        (* TODO: Make sure these tests get surfaced properly *)
        (* Otherwise, find the best analyte possible *)
        Module[{potentialAnalytesToUse,potentialAnalyteTests},
          (* Get the possible analytes to use *)
          {potentialAnalytesToUse, potentialAnalyteTests} = If[gatherTests,
            selectAnalyteFromSample[mySample, Cache -> combinedCache, Output -> {Result, Tests}],
            {selectAnalyteFromSample[mySample, Cache -> combinedCache, Output -> Result], {}}
          ];

          (* Return the first potential analyte and the tests *)
          {First[potentialAnalytesToUse],potentialAnalyteTests}
        ]
      ];

      (* If no target analyte could be found, mark an error *)
      If[MatchQ[resolvedTargetAnalyte,Null],
        noTargetAnalyteFound = True
      ];

      (* Determine the dilution case we are in for this sample (Diluent vs ConcentratedBuffer) *)
      diluentCase = Module[{diluentOptionSetBool,concentratedBufferOptionSetBool},

        (* Do we have any diluent options set? *)
        diluentOptionSetBool = Or[
          MatchQ[specifiedDiluent,ObjectP[{Object[Sample],Model[Sample]}]],
          MatchQ[specifiedDiluentVolume,ListableP[VolumeP]]
        ];

        (* Did the user specify a ConcentratedBuffer? *)
        concentratedBufferOptionSetBool = Or[
          MatchQ[specifiedConcentratedBuffer,ObjectP[{Object[Sample],Model[Sample]}]],
          MatchQ[specifiedConcentratedBufferVolume,ListableP[VolumeP]],
          MatchQ[specifiedConcentratedBufferDiluent,ObjectP[{Object[Sample],Model[Sample]}]],
          MatchQ[specifiedConcentratedBufferDilutionFactor,ListableP[_?NumericQ]],
          MatchQ[specifiedConcentratedBufferDiluentVolume,ListableP[VolumeP]]
        ];

        (* Determine the case *)
        Which[
          (* If both are set - error *)
          diluentOptionSetBool && concentratedBufferOptionSetBool,
            "Not Possible",

          (* If only Diluent, use it *)
          diluentOptionSetBool && !concentratedBufferOptionSetBool,
            "Diluent",

          (* If only ConcentratedBuffer, use it *)
          concentratedBufferOptionSetBool && !diluentOptionSetBool,
            "Concentrated Buffer",

          (* If none of them are specified, then default to diluent case *)
          True,
            "Diluent"
        ]
      ];

      (* Resolve Diluent *)
      resolvedDiluent = If[MatchQ[diluentCase,"Concentrated Buffer"],
        (* If the case is "Concentrated Buffer", then we are only using the concentrated buffer and its diluent to do the dilutions *)
        Null,

        (* If we are in any other case, we need to determine a diluent *)
        Which[
          (* If Diluent is specified, keep it *)
          MatchQ[specifiedDiluent,Except[Automatic]],
          specifiedDiluent,

          (* If the Media field of the sample is populated, use it *)
          MatchQ[fastAssocLookup[fastAssoc,mySample,Media],ObjectP[Model[Sample]]],
          Download[fastAssocLookup[fastAssoc,mySample,Media],Object],

          (* If the Solvent field of the sample is populated, use it *)
          MatchQ[fastAssocLookup[fastAssoc,mySample,Solvent],ObjectP[Model[Sample]]],
          Download[fastAssocLookup[fastAssoc,mySample,Solvent],Object],

          (* Finally, resolve to water *)
          True,
          Module[{},
            (* Mark a warning *)
            noDiluentSpecifiedWarning = True;
            (* Resolve to water *)
            Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
          ]
        ]
      ];

      (* Resolve ConcentratedBuffer *)
      resolvedConcentratedBuffer = If[
        (* If we have a concentrated buffer, use it *)
        MatchQ[specifiedConcentratedBuffer,Except[Automatic]],
        specifiedConcentratedBuffer,

        (* Otherwise set to Null (we are not using a concentrated buffer) *)
        Null
      ];

      (* Resolve concentrated buffer diluent *)
      resolvedConcentratedBufferDiluent = Which[
        (* If we have a concentrated buffer diluent, keep it *)
        MatchQ[specifiedConcentratedBufferDiluent,Except[Automatic]],
        specifiedConcentratedBufferDiluent,

        (* If we are not using concentrated buffer, set to Null *)
        NullQ[resolvedConcentratedBuffer],
        Null,

        (* If we are using concentrated buffer, see if the buffer has a concentrated buffer diluent *)
        MatchQ[fastAssocLookup[fastAssoc,resolvedConcentratedBuffer,ConcentratedBufferDiluent],ObjectP[Model[Sample]]],
        Download[fastAssocLookup[fastAssoc,resolvedConcentratedBuffer,ConcentratedBufferDiluent],Object],

        (* Otherwise, default to water *)
        True,
        Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
      ];

      (* Resolve DiscardFinalTransfer *)
      resolvedDiscardFinalTransfer = Which[
        (* If the option is specified, keep it *)
        MatchQ[specifiedDiscardFinalTransfer,Except[Automatic]],
        specifiedDiscardFinalTransfer,

        (* If DilutionType is Serial, default to True *)
        MatchQ[resolvedDilutionType,Serial],
        True,

        (* Otherwise, (If DilutionType is Linear) resolve to Null *)
        True,
        Null
      ];

      (* Extract the initial concentration of the TargetAnalyte from the composition *)
      targetAnalyteInitialConcentration = If[!NullQ[resolvedTargetAnalyte],
        FirstCase[fastAssocLookup[fastAssoc,mySample,Composition], {conc : ConcentrationP | CellConcentrationP | CFUConcentrationP | OD600P, ObjectP[resolvedTargetAnalyte], _} :> conc, Null],
        Null
      ];

      (* Did we find a concentration? *)
      If[NullQ[targetAnalyteInitialConcentration],
        noTargetAnalyteInitialConcentrationFound = True;
      ];

      (* Make sure all of the nested index matching options are fully expanded before resolving them *)
      {
        expandedSpecifiedCumulativeDilutionFactor,
        expandedSpecifiedSerialDilutionFactor,
        expandedSpecifiedTargetAnalyteConcentration,
        expandedSpecifiedTransferVolume,
        expandedSpecifiedTotalDilutionVolume,
        expandedSpecifiedFinalVolume,
        expandedSpecifiedDiluentVolume,
        expandedSpecifiedConcentratedBufferVolume,
        expandedSpecifiedConcentratedBufferDiluentVolume,
        expandedSpecifiedConcentratedBufferDilutionFactor
      } = Map[
        Function[{optionValue},

          Which[
            (* If the option value is a list of Automatic, expand it *)
            MatchQ[optionValue,{Automatic..}],
            ConstantArray[Automatic, resolvedNumberOfDilutions],
            (* Otherwise, if the option value is a list - keep it *)
            MatchQ[optionValue,_List],
            optionValue,
            (* If the option is not a list, do a constant array of NumberOfDilutions *)
            True,
            ConstantArray[optionValue,resolvedNumberOfDilutions]
          ]
        ],
        {
          specifiedCumulativeDilutionFactor,
          specifiedSerialDilutionFactor,
          specifiedTargetAnalyteConcentration,
          specifiedTransferVolume,
          specifiedTotalDilutionVolume,
          specifiedFinalVolume,
          specifiedDiluentVolume,
          specifiedConcentratedBufferVolume,
          specifiedConcentratedBufferDiluentVolume,
          specifiedConcentratedBufferDilutionFactor
        }
      ];

      (* As long as we found a concentration - make sure we can convert between our initial concentration and any TargetConcentrations *)
      {concentrationUnits,convertedTargetAnalyteInitialConcentration} = Module[{unitFromTargetAnalyteConcentration,initialTargetAnalyteUnits,cellUnits},

        (* Define the units that are "Cell Units" can could potentially be converted between using ConvertCellConcentration *)
        cellUnits = {OD600P, CFUConcentrationP, CellConcentrationP};

        (* Go through the TargetAnalyteConcentration option and extract the unit we want to convert to there *)
        unitFromTargetAnalyteConcentration = Switch[expandedSpecifiedTargetAnalyteConcentration,
          (* If automatic or Null, stay Automatic or Null *)
          {Automatic..},
            Automatic,
          {Null..},
            Null,
          {Automatic | Null..},
            Null,
          (* If there is a consistent unit, use it *)
          {ConcentrationP..} | {OD600P..} | {CFUConcentrationP..} | {CellConcentrationP..},
            Units[First[expandedSpecifiedTargetAnalyteConcentration]],

          (* If there is a mixed list of Automatic/Nulls and concentration units take the first unit *)
          Alternatives[
            {Automatic|Null|ConcentrationP..},
            {Automatic|Null|CellConcentrationP..},
            {Automatic|Null|CFUConcentrationP..},
            {Automatic|Null|OD600P..}
          ],
          Units[FirstCase[expandedSpecifiedTargetAnalyteConcentration,ConcentrationP|Alternatives@@cellUnits]],

          (* If there are multiple units, take the first and mark an error *)
          _,
            Module[{},
              multipleTargetAnalyteConcentrationUnitsError = {True,unitFromTargetAnalyteConcentration};
              Units[FirstCase[expandedSpecifiedTargetAnalyteConcentration,ConcentrationP|Alternatives@@cellUnits,Null]]
            ]
        ];

        (* Get the initial units from the composition *)
        initialTargetAnalyteUnits = If[noTargetAnalyteInitialConcentrationFound,
          Null,
          Units[targetAnalyteInitialConcentration]
        ];

        (* Switch off of the target unit and the initial unit *)
        Switch[{initialTargetAnalyteUnits,unitFromTargetAnalyteConcentration},

          (* If both Automatic and/or Null, resolve based on the TargetAnalyte *)
          {Automatic|Null,Automatic|Null},
            Which[
              MatchQ[resolvedTargetAnalyte,ObjectP[Model[Cell]]],
                {Cell / Milliliter, Null},
              MatchQ[resolvedTargetAnalyte,ObjectP[]],
                {Mole / Liter, Null},
              True,
                {Mole / Liter, Null}
            ],

          (* If only initial units are populated, use our canonical form of that unit *)
          {ConcentrationP,Automatic|Null}, {Mole/Liter,Convert[targetAnalyteInitialConcentration,Mole/Liter]},
          {CellConcentrationP,Automatic|Null}, {Cell / Milliliter,Convert[targetAnalyteInitialConcentration,Cell / Milliliter]},
          {CFUConcentrationP,Automatic|Null}, {CFU / Millliliter,Convert[targetAnalyteInitialConcentration,CFU / Millliliter]},
          {OD600P,Automatic|Null}, {OD600,targetAnalyteInitialConcentration},

          (* If only target units are populated, use our canonical form of that unit *)
          {Automatic|Null,ConcentrationP}, {Mole/Liter,Convert[targetAnalyteInitialConcentration,Mole/Liter]},
          {Automatic|Null,CellConcentrationP}, {EmeraldCell / Milliliter,Convert[targetAnalyteInitialConcentration,EmeraldCell / Milliliter]},
          {Automatic|Null,CFUConcentrationP}, {CFU / Millliliter,Convert[targetAnalyteInitialConcentration,CFU / Millliliter]},
          {Automatic|Null,OD600P}, {OD600,targetAnalyteInitialConcentration},

          (* If they are both Concentrations, return Mole/Liter *)
          {ConcentrationP,ConcentrationP}, {Mole/Liter,Convert[targetAnalyteInitialConcentration,Mole/Liter]},

          (* If they are both CellConcentration, return Cell/Milliliter *)
          {CellConcentrationP,CellConcentrationP}, {EmeraldCell / Milliliter,Convert[targetAnalyteInitialConcentration,EmeraldCell / Milliliter]},

          (* If they are both CFUConcentration, return CFU/Milliliter *)
          {CFUConcentrationP,CFUConcentrationP}, {CFU / Millliliter,Convert[targetAnalyteInitialConcentration,CFU / Millliliter]},

          (* If they are both OD600, return OD600 *)
          {OD600P,OD600P}, {OD600,targetAnalyteInitialConcentration},

          (* If they are both cell units, see if we have a standard curve to convert between them *)
          {Alternatives@@cellUnits,Alternatives@@cellUnits},
            Module[{canConvertBool},

              (* Create a boolean to track if we are able to convert *)
              canConvertBool = True;

              Quiet[
                Check[
                  ConvertCellConcentration[initialTargetAnalyteUnits,unitFromTargetAnalyteConcentration,resolvedTargetAnalyte],
                  (* If an error is detected, we can't convert *)
                  canConvertBool = False,
                  {Error::NoCompatibleStandardCurveInCellModel,Error::StandardCurveFitFunctionNotFound}
                ]
              ];

              (* If can convert, convert the initial target analyte concentration *)
              If[canConvertBool,
                {unitFromTargetAnalyteConcentration,ConvertCellConcentration[targetAnalyteInitialConcentration,unitFromTargetAnalyteConcentration,resolvedTargetAnalyte]},
                (* If we can't convert, mark an error, and just strip the units *)
                Module[{},
                  conflictingTargetAnalyteConcentrationUnitsError = {True,unitFromTargetAnalyteConcentration,initialTargetAnalyteUnits};
                  {unitFromTargetAnalyteConcentration,QuantityMagnitude[targetAnalyteInitialConcentration] * unitFromTargetAnalyteConcentration}
                ]
              ]
            ],

          (* If we have a Cell unit and a concentration, mark an error, and resolve to Mole/Liter. *)
          (* Just strip the units of the initial concentration - the math will always be wrong we just need to not crash *)
          {Alternatives@@cellUnits,ConcentrationP} | {ConcentrationP,Alternatives@@cellUnits},
            Module[{},
              conflictingTargetAnalyteConcentrationUnitsError = {True,unitFromTargetAnalyteConcentration,initialTargetAnalyteUnits};
              {Mole / Liter,If[ConcentrationQ[targetAnalyteInitialConcentration],
                targetAnalyteInitialConcentration,
                QuantityMagnitude[targetAnalyteInitialConcentration] * Mole/Liter
              ]}
            ],

          (* Have a failsafe so the code doesn't crash in a wall of red *)
          _,
            Module[{},
              conflictingTargetAnalyteConcentrationUnitsError = {True,unitFromTargetAnalyteConcentration,initialTargetAnalyteUnits};
              {Mole / Liter,If[NullQ[targetAnalyteInitialConcentration],Null,QuantityMagnitude[targetAnalyteInitialConcentration] * Mole/Liter]}
            ]
        ]
      ];

      (* The following options resolve differently if the dilution case is Diluent or ConcentratedBuffer *)
      Switch[diluentCase,

        "Diluent",
        Module[{currentTotalSerialDilutionFactor,currentSampleVolume,currentSampleAnalyteConcentration},
          (* We first know that the concentrated buffer options resolve to Null in this case - so do that*)
          (* Resolve ConcentratedBufferVolume *)
          intermediateConcentratedBufferVolume = Map[
            If[MatchQ[#,Except[Automatic]],
              #,
              Null
            ]&,
            expandedSpecifiedConcentratedBufferVolume
          ];

          (* ResolveConcentratedBufferDiluentVolume *)
          intermediateConcentratedBufferDiluentVolume = Map[
            If[MatchQ[#,Except[Automatic]],
              #,
              Null
            ]&,
            expandedSpecifiedConcentratedBufferDiluentVolume
          ];

          (* Resolve ConcentratedBufferDilutionFactor *)
          resolvedConcentratedBufferDilutionFactor = Map[
            If[MatchQ[#,Except[Automatic]],
              #,
              Null
            ]&,
            expandedSpecifiedConcentratedBufferDilutionFactor
          ];

          (* These options are all very interdependent on each other - do a first pass to calculate anything we can *)
          (* from the specified values. Then if needed, do as second pass, using defaults along the way *)

          (* Initialize some variables to keep track of values throughout the mapthread *)
          (* NOTE: this variables are reset in the case of Linear dilution *)
          (* Keep Track of the total serial dilution Factor (For linear this always starts at 1) *)
          currentTotalSerialDilutionFactor = 1;

          (* Keep track of the current sample volume *)
          (* Keep track of the current sample volume *)
          currentSampleVolume = Module[{sampleVolume,sampleMass,sampleDensity,volToUse},
            (* Get sample, volume, mass, and density *)
            {sampleVolume,sampleMass,sampleDensity} = {
              fastAssocLookup[fastAssoc,mySample,Volume],
              fastAssocLookup[fastAssoc,mySample,Mass],
              fastAssocLookup[fastAssoc,mySample,Density]
            };

            (* Get the volume to use *)
            volToUse = Which[
              (* If Volume is populated, use it! *)
              MatchQ[sampleVolume,VolumeP],
              sampleVolume,
              (* If Mass and Density are provided, use them! *)
              MatchQ[sampleMass,MassP] && MatchQ[sampleDensity,DensityP],
              sampleMass / sampleDensity,
              (* If just mass is provided, convert with water density *)
              MatchQ[sampleMass,MassP],
              sampleMass / Quantity[0.997 Gram/Milliliter],
              (* Otherwise, Mark an error and resolve to 1mL *)
              True,
              Module[{},
                noSampleVolumeWarning = True;
                1Milliliter
              ]
            ];

            (* Get into a form usable by Solve *)
            QuantityMagnitude[Convert[volToUse,Liter]]
          ];

          (* Keep track of the analyte concentration in the sample as we go through the dilutions *)
          currentSampleAnalyteConcentration = QuantityMagnitude[convertedTargetAnalyteInitialConcentration];

          (* Map over our expanded values *)
          {
            intermediateTransferVolume,
            intermediateDiluentVolume,
            intermediateFinalVolume,
            intermediateTotalDilutionVolume,
            resolvedTargetAnalyteConcentration,
            resolvedCumulativeDilutionFactor,
            intermediateSerialDilutionFactor
          }=Transpose@MapThread[
            Function[{diluentVolume,finalVolume,transferVolume,totalDilutionVolume,targetAnalyteConcentration,serialDilutionFactor,cumulativeDilutionFactor},
              Module[
                {
                  myEquations,scaledDiluentVolume,scaledFinalVolume,scaledTransferVolume,scaledTotalDilutionVolume,
                  scaledTargetAnalyteInitialConcentration, scaledTargetAnalyteConcentration, scaledCumulativeDilutionFactor,
                  scaledSerialDilutionFactor,scaledSDFTilNow,solvedEquationsNoDefaults,allOptionsSolvedForBool
                },

                (* Set up our system of equations *)
                myEquations = {
                  scaledTotalDilutionVolume == scaledTransferVolume + scaledDiluentVolume,
                  scaledSerialDilutionFactor == scaledCumulativeDilutionFactor / scaledSDFTilNow,
                  scaledCumulativeDilutionFactor == scaledTargetAnalyteInitialConcentration / scaledTargetAnalyteConcentration,
                  scaledTransferVolume == scaledTotalDilutionVolume / scaledSerialDilutionFactor,
                  (* FinalVolume and TotalDilutionVolume are related in a different way when there is only one-step dilution with DiscardFinalTransfer->False *)
                  If[
                    Or[
                      (* Linear dilution *)
                      MatchQ[resolvedDilutionType, Linear],
                      (* single step serial dilution with DiscardFinalTransfer set to False *)
                      And[
                        MatchQ[resolvedDilutionType, Serial],
                        MatchQ[resolvedDiscardFinalTransfer, False|Null],
                        MatchQ[resolvedNumberOfDilutions, 1]
                      ]
                    ],
                    scaledFinalVolume == scaledTotalDilutionVolume,
                    scaledFinalVolume == scaledTotalDilutionVolume - scaledTransferVolume
                  ]
                };

                (* Get everything into consistent units to make Solve happy. We will do the following: *)
                (* Volumes -> Liter *)
                (* Concentrations -> units as found above *)
                (* Factors -> unitless *)
                scaledDiluentVolume = If[MatchQ[diluentVolume,Null|Automatic],
                  scaledDiluentVolume,
                  QuantityMagnitude[Convert[diluentVolume,Liter]]
                ];
                scaledFinalVolume = If[MatchQ[finalVolume,Null|Automatic],
                  scaledFinalVolume,
                  QuantityMagnitude[Convert[finalVolume,Liter]]
                ];
                scaledTransferVolume = If[MatchQ[transferVolume,Null|Automatic],
                  scaledTransferVolume,
                  QuantityMagnitude[Convert[transferVolume,Liter]]
                ];
                scaledTotalDilutionVolume = If[MatchQ[totalDilutionVolume,Null|Automatic],
                  scaledTotalDilutionVolume,
                  QuantityMagnitude[Convert[totalDilutionVolume,Liter]]
                ];
                scaledTargetAnalyteInitialConcentration = If[MatchQ[convertedTargetAnalyteInitialConcentration,Null|Automatic],
                  scaledTargetAnalyteInitialConcentration,
                  QuantityMagnitude[Convert[convertedTargetAnalyteInitialConcentration,concentrationUnits]]
                ];
                scaledTargetAnalyteConcentration = Which[
                  MatchQ[targetAnalyteConcentration,Null|Automatic],
                    scaledTargetAnalyteConcentration,
                  TrueQ[multipleTargetAnalyteConcentrationUnitsError[[1]]],
                    QuantityMagnitude[targetAnalyteConcentration],
                  True,
                  QuantityMagnitude[Convert[targetAnalyteConcentration,concentrationUnits]]
                ];
                scaledCumulativeDilutionFactor = If[MatchQ[cumulativeDilutionFactor,Null|Automatic],
                  scaledCumulativeDilutionFactor,
                  cumulativeDilutionFactor
                ];
                scaledSerialDilutionFactor = If[MatchQ[serialDilutionFactor,Null|Automatic],
                  scaledSerialDilutionFactor,
                  serialDilutionFactor
                ];
                scaledSDFTilNow = currentTotalSerialDilutionFactor;

                (* Solve the equations *)
                solvedEquationsNoDefaults = Quiet[FirstOrDefault[Solve[myEquations],{}]];

                (* See if everything has a value *)
                (* An option has a value if it is numeric *)
                allOptionsSolvedForBool = MatchQ[solvedEquationsNoDefaults[[All,2]],{NumericP..}];

                Which[
                  (* WOO we solved everything *)
                  TrueQ[allOptionsSolvedForBool],
                  Module[{},
                    (* Only update our "current" variables if we are in serial dilution *)
                    (* In the case of Linear dilution they are left untouched and always use their initial values *)
                    If[MatchQ[resolvedDilutionType,Serial],
                      currentSampleVolume = If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,scaledTotalDilutionVolume/.solvedEquationsNoDefaults];
                      currentTotalSerialDilutionFactor = If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,scaledCumulativeDilutionFactor/.solvedEquationsNoDefaults];
                      currentSampleAnalyteConcentration = If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,scaledTargetAnalyteConcentration/.solvedEquationsNoDefaults];
                    ];

                    (* Gather our resolved options in reasonable units *)
                    {
                      If[MatchQ[transferVolume,Except[Automatic]],transferVolume,UnitScale[(scaledTransferVolume/.solvedEquationsNoDefaults) * Liter]],
                      If[MatchQ[diluentVolume,Except[Automatic]],diluentVolume,UnitScale[(scaledDiluentVolume/.solvedEquationsNoDefaults) * Liter]],
                      If[MatchQ[finalVolume,Except[Automatic]],finalVolume,UnitScale[(scaledFinalVolume/.solvedEquationsNoDefaults)* Liter]],
                      If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,UnitScale[(scaledTotalDilutionVolume/.solvedEquationsNoDefaults)* Liter]],
                      If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,UnitScale[(scaledTargetAnalyteConcentration/.solvedEquationsNoDefaults) * concentrationUnits]],
                      If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,N[scaledCumulativeDilutionFactor/.solvedEquationsNoDefaults]],
                      If[NumericQ[serialDilutionFactor],serialDilutionFactor,N[scaledSerialDilutionFactor/.solvedEquationsNoDefaults]]
                    }
                  ],

                  (* Further resolve with second solve and defaults *)
                  !MatchQ[solvedEquationsNoDefaults,{}],
                  Module[{varsNeededToSolve,solvedEquationsWithDefaults},

                    (* Extract the variables that are still needed to solve the equations *)
                    varsNeededToSolve = DeleteDuplicates@Cases[solvedEquationsNoDefaults[[All,2]],_Symbol,Infinity];

                    (* Set the extra variables we need based on how many are needed/what was set originally *)
                    Which[
                      (* Case 1: Both the volume and factor/concentration are missing *)
                      Length[varsNeededToSolve] > 1,
                      Module[{},
                        (* Set the volume to 1/10th of the sample volume *)
                        scaledTransferVolume = N[currentSampleVolume / 10];

                        (* Set the SerialDilutionFactor to 10 *)
                        scaledSerialDilutionFactor = 10;
                      ],

                      (* Case 2: If only missing scaledTargetAnalyteInitialConcentration b/c of no noTargetAnalyteInitialConcentrationFound *)
                      (* We do not need to set anything else b/c that would work fine *)
                      ContainsOnly[varsNeededToSolve,{scaledTargetAnalyteInitialConcentration,scaledTargetAnalyteConcentration}]&&(noTargetAnalyteInitialConcentrationFound),
                      Nothing,

                      (* Case 3: Only one more variable is needed - TransferVolume was specified *)
                      MatchQ[transferVolume,Except[Null|Automatic]],
                      Module[{},
                        (* Set the SerialDilutionFactor to 10 *)
                        scaledSerialDilutionFactor = 10;
                      ],

                      (* Case 4: 1 var missing, transfer volume not set *)
                      True,
                      Module[{},

                        (* Set the TransferVolume based on a provided option (scaling so that we are doing a 10x dilution) *)
                        scaledTransferVolume = Which[
                          MatchQ[diluentVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[diluentVolume / 9, Liter]],

                          MatchQ[finalVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[finalVolume / 9, Liter]],

                          MatchQ[totalDilutionVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[totalDilutionVolume / 10, Liter]],

                          MatchQ[targetAnalyteConcentration,Except[Null|Automatic]],
                          Module[{targetAnalyteConcentrationToUse},
                            (* Get the given targetAnalyteConcentration in a usable form *)
                            targetAnalyteConcentrationToUse = If[TrueQ[multipleTargetAnalyteConcentrationUnitsError[[1]]],
                              QuantityMagnitude[targetAnalyteConcentration],
                              QuantityMagnitude[Convert[targetAnalyteConcentration,concentrationUnits]]
                            ];
                            (currentSampleVolume / (currentSampleAnalyteConcentration / targetAnalyteConcentrationToUse))
                          ],

                          MatchQ[cumulativeDilutionFactor,Except[Null|Automatic]],
                          (currentSampleVolume / cumulativeDilutionFactor),

                          MatchQ[serialDilutionFactor,Except[Null|Automatic]],
                          (currentSampleVolume / serialDilutionFactor)
                        ];
                      ]
                    ];

                    (* Resolve the equations *)
                    solvedEquationsWithDefaults = Quiet[FirstOrDefault[Solve[myEquations],{}]];

                    (* Do a final check to see if we have solved everything *)
                    Module[{varsNeededToSolve},

                      (* Extract the variables that are still needed to solve the equations *)
                      varsNeededToSolve = DeleteDuplicates@Cases[solvedEquationsWithDefaults[[All,2]],_Symbol,Infinity];

                      Which[
                        (* If we have solved for everything or we just missing TargetAnalyteInitialConcentration for noTargetAnalyteInitialConcentrationFound *)
                        ContainsOnly[varsNeededToSolve,{scaledTargetAnalyteInitialConcentration,scaledTargetAnalyteConcentration}],
                        Module[{},
                          (* Mark a warning if necessary *)
                          (* If noTargetAnalyteInitialConcentrationFound, only set concentration related options to Null or initial value *)
                          If[noTargetAnalyteInitialConcentrationFound,
                            missingTargetAnalyteInitialConcentrationWarning=True
                          ];

                          (* Only update our "current" variables if we are in serial dilution *)
                          (* In the case of Linear dilution they are left untouched and always use their initial values *)
                          If[MatchQ[resolvedDilutionType,Serial],
                            currentSampleVolume=If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,scaledTotalDilutionVolume/.solvedEquationsWithDefaults];
                            currentTotalSerialDilutionFactor=If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,scaledCumulativeDilutionFactor/.solvedEquationsWithDefaults];
                            currentSampleAnalyteConcentration=If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,If[noTargetAnalyteInitialConcentrationFound,Null,scaledTargetAnalyteConcentration/.solvedEquationsWithDefaults]];
                          ];

                          (* Gather our resolved options in reasonable units *)
                          {
                            If[MatchQ[transferVolume,Except[Automatic]],transferVolume,UnitScale[(scaledTransferVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[diluentVolume,Except[Automatic]],diluentVolume,UnitScale[(scaledDiluentVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[finalVolume,Except[Automatic]],finalVolume,UnitScale[(scaledFinalVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,UnitScale[(scaledTotalDilutionVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,If[noTargetAnalyteInitialConcentrationFound,Null,UnitScale[(scaledTargetAnalyteConcentration/.solvedEquationsWithDefaults)*concentrationUnits]]],
                            If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,N[scaledCumulativeDilutionFactor/.solvedEquationsWithDefaults]],
                            If[NumericQ[serialDilutionFactor],serialDilutionFactor,N[scaledSerialDilutionFactor/.solvedEquationsWithDefaults]]
                          }
                        ],

                        (* Otherwise, the math must still be impossible *)
                        True,
                        Module[{},
                          conflictingFactorsAndVolumesError=True;

                          (* Only update our "current" variables if we are in serial dilution *)
                          (* In the case of Linear dilution they are left untouched and always use their initial values *)
                          If[MatchQ[resolvedDilutionType,Serial],
                            currentSampleVolume=If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,Null];
                            currentTotalSerialDilutionFactor=If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,Null];
                            currentSampleAnalyteConcentration=If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,Null];
                          ];

                          (* Gather our resolved options in reasonable units *)
                          {
                            If[MatchQ[transferVolume,Except[Automatic]],transferVolume,Null],
                            If[MatchQ[diluentVolume,Except[Automatic]],diluentVolume,Null],
                            If[MatchQ[finalVolume,Except[Automatic]],finalVolume,Null],
                            If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,Null],
                            If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,Null],
                            If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,Null],
                            If[NumericQ[serialDilutionFactor],serialDilutionFactor,Null]
                          }

                        ]
                      ]
                    ]
                  ],

                  (* The math was is not possible given our current values - set everything to Null if it was not specified *)
                  True,
                  Module[{},
                    conflictingFactorsAndVolumesError = True;
                    (* Only update our "current" variables if we are in serial dilution *)
                    (* In the case of Linear dilution they are left untouched and always use their initial values *)
                    If[MatchQ[resolvedDilutionType,Serial],
                      currentSampleVolume = If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,Null];
                      currentTotalSerialDilutionFactor = If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,Null];
                      currentSampleAnalyteConcentration = If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,Null];
                    ];

                    (* Gather our resolved options in reasonable units *)
                    {
                      If[MatchQ[transferVolume,Except[Automatic]],transferVolume,Null],
                      If[MatchQ[diluentVolume,Except[Automatic]],diluentVolume,Null],
                      If[MatchQ[finalVolume,Except[Automatic]],finalVolume,Null],
                      If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,Null],
                      If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,Null],
                      If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,Null],
                      If[NumericQ[serialDilutionFactor],serialDilutionFactor,Null]
                    }
                  ]
                ]
              ]
            ],
            {
              expandedSpecifiedDiluentVolume,
              expandedSpecifiedFinalVolume,
              expandedSpecifiedTransferVolume,
              expandedSpecifiedTotalDilutionVolume,
              expandedSpecifiedTargetAnalyteConcentration,
              expandedSpecifiedSerialDilutionFactor,
              expandedSpecifiedCumulativeDilutionFactor
            }
          ];
        ],

        "Concentrated Buffer",
        Module[{currentTotalSerialDilutionFactor,currentSampleVolume,currentSampleSolventDilutionFactor,currentSampleAnalyteConcentration,resolvedConcentratedBufferCBDF},
          (* We first know that the diluent options resolve to Null in this case - so do that*)
          (* Resolve DiluentVolume *)
          intermediateDiluentVolume = Map[
            If[MatchQ[#,Except[Automatic]],
              #,
              Null
            ]&,
            expandedSpecifiedDiluentVolume
          ];

          (* Lookup the ConcentratedBufferDilutionFactor of the resolvedConcentratedBuffer for use in the dilution calculations *)
          resolvedConcentratedBufferCBDF = fastAssocLookup[fastAssoc,resolvedConcentratedBuffer,ConcentratedBufferDilutionFactor]/.{$Failed->10,Null->10};

          (* Initialize a total serial dilution factor variable *)
          currentTotalSerialDilutionFactor = 1;

          (* Keep track of the current sample volume *)
          currentSampleVolume = Module[{sampleVolume,sampleMass,sampleDensity,volToUse},
            (* Get sample, volume, mass, and density *)
            {sampleVolume,sampleMass,sampleDensity} = {
              fastAssocLookup[fastAssoc,mySample,Volume],
              fastAssocLookup[fastAssoc,mySample,Mass],
              fastAssocLookup[fastAssoc,mySample,Density]
            };

            (* Get the volume to use *)
            volToUse = Which[
              (* If Volume is populated, use it! *)
              MatchQ[sampleVolume,VolumeP],
              sampleVolume,
              (* If Mass and Density are provided, use them! *)
              MatchQ[sampleMass,MassP] && MatchQ[sampleDensity,DensityP],
              sampleMass / sampleDensity,
              (* If just pass is provided, convert with water density *)
              MatchQ[sampleMass,MassP],
              sampleMass / Quantity[0.997 Gram/Milliliter],
              (* Otherwise, Mark an error and resolve to 1mL *)
              True,
                Module[{},
                  noSampleVolumeWarning = True;
                  1Milliliter
                ]
            ];

            (* Get into a form usable by Solve *)
            QuantityMagnitude[Convert[volToUse,Liter]]
          ];

          (* Keep track of the sample Solvent/Media ConcentratedBufferDilutionFactor *)
          currentSampleSolventDilutionFactor = fastAssocLookup[fastAssoc,mySample,ConcentratedBufferDilutionFactor]/.{$Failed -> 1, Null -> 1};

          (* Keep track of the analyte concentration in the sample as we go through the dilutions *)
          currentSampleAnalyteConcentration = QuantityMagnitude[convertedTargetAnalyteInitialConcentration];

          (* Map over our expanded values *)
          {
            intermediateTransferVolume,
            intermediateConcentratedBufferVolume,
            intermediateConcentratedBufferDiluentVolume,
            intermediateFinalVolume,
            intermediateTotalDilutionVolume,
            resolvedTargetAnalyteConcentration,
            resolvedCumulativeDilutionFactor,
            intermediateSerialDilutionFactor,
            resolvedConcentratedBufferDilutionFactor
          }=Transpose@MapThread[
            Function[{concentratedBufferVolume,concentratedBufferDiluentVolume,finalVolume,transferVolume,totalDilutionVolume,targetAnalyteConcentration,serialDilutionFactor,cumulativeDilutionFactor,concentratedBufferDilutionFactor,index},
              Module[
                {
                  firstDilutionSolventNotConcBool,sameBaselineStockBool,myEquations,scaledConcentratedBufferVolume,scaledConcentratedBufferDiluentVolume,scaledFinalVolume,scaledTransferVolume,scaledTotalDilutionVolume,
                  scaledTargetAnalyteInitialConcentration, scaledTargetAnalyteConcentration, scaledCumulativeDilutionFactor,
                  scaledSerialDilutionFactor,scaledConcentratedBufferDilutionFactor,scaledSDFTilNow,scaledSolventConcentrationFactor,solvedEquationsNoDefaults,allOptionsSolvedForBool
                },

                (* We have a special scenario if this is the first dilution in the series and the sample Solvent does not have ConcentratedBufferDilutionFactor *)
                firstDilutionSolventNotConcBool = MatchQ[index,1] && !MatchQ[fastAssocLookup[fastAssoc,mySample,ConcentratedBufferDilutionFactor],NumericP];

                (* Create a bool checking if the sample solvent and ConcentratedBuffer have the same BaselineStock (and are not Null) *)
                sameBaselineStockBool = And[
                  MatchQ[Download[fastAssocLookup[fastAssoc,mySample,{Solvent,BaselineStock}],Object],Download[fastAssocLookup[fastAssoc,resolvedConcentratedBuffer,{BaselineStock}],Object]],
                  !MatchQ[Download[fastAssocLookup[fastAssoc,mySample,{Solvent,BaselineStock}],Object],Null],
                  !MatchQ[Download[fastAssocLookup[fastAssoc,resolvedConcentratedBuffer,{BaselineStock}],Object],Null]
                ];

                (* Set up our system of equations *)
                myEquations = If[firstDilutionSolventNotConcBool || !sameBaselineStockBool || MatchQ[resolvedDilutionType, Linear],
                  {
                    scaledTotalDilutionVolume == scaledTransferVolume + scaledConcentratedBufferVolume + scaledConcentratedBufferDiluentVolume,
                    scaledSerialDilutionFactor == scaledCumulativeDilutionFactor / scaledSDFTilNow,
                    scaledCumulativeDilutionFactor == scaledTargetAnalyteInitialConcentration / scaledTargetAnalyteConcentration,
                    scaledTransferVolume == scaledTotalDilutionVolume / scaledSerialDilutionFactor,
                    (* FinalVolume and TotalDilutionVolume are related in a different way when there is only one-step dilution with DiscardFinalTransfer->False *)
                    If[
                      Or[
                        (* Linear dilution *)
                        MatchQ[resolvedDilutionType, Linear],
                        (* single step serial dilution with DiscardFinalTransfer set to False *)
                        And[
                          MatchQ[resolvedDilutionType, Serial],
                          MatchQ[resolvedDiscardFinalTransfer, False|Null],
                          MatchQ[resolvedNumberOfDilutions, 1]
                        ]
                      ],
                      scaledFinalVolume == scaledTotalDilutionVolume,
                      scaledFinalVolume == scaledTotalDilutionVolume - scaledTransferVolume
                    ],
                    scaledConcentratedBufferVolume == scaledTotalDilutionVolume / scaledConcentratedBufferDilutionFactor
                  },
                  {
                    scaledTotalDilutionVolume == scaledTransferVolume + scaledConcentratedBufferVolume + scaledConcentratedBufferDiluentVolume,
                    scaledSerialDilutionFactor == scaledCumulativeDilutionFactor / scaledSDFTilNow,
                    scaledCumulativeDilutionFactor == scaledTargetAnalyteInitialConcentration / scaledTargetAnalyteConcentration,
                    scaledTransferVolume == scaledTotalDilutionVolume / scaledSerialDilutionFactor,
                    (* FinalVolume and TotalDilutionVolume are related in a different way when there is only one-step dilution with DiscardFinalTransfer->False *)
                    If[
                      Or[
                        (* Linear dilution *)
                        MatchQ[resolvedDilutionType, Linear],
                        (* single step serial dilution with DiscardFinalTransfer set to False *)
                        And[
                          MatchQ[resolvedDilutionType, Serial],
                          MatchQ[resolvedDiscardFinalTransfer, False|Null],
                          MatchQ[resolvedNumberOfDilutions, 1]
                        ]
                      ],
                      scaledFinalVolume == scaledTotalDilutionVolume,
                      scaledFinalVolume == scaledTotalDilutionVolume - scaledTransferVolume
                    ],
                    scaledConcentratedBufferVolume == (scaledTotalDilutionVolume - scaledTransferVolume) * (scaledSolventConcentrationFactor / scaledConcentratedBufferDilutionFactor)
                  }
                ];

                (* Get everything into consistent units to make Solve happy. We will do the following: *)
                (* Volumes -> Liter *)
                (* Concentrations -> units as found above *)
                (* Factors -> unitless *)
                scaledConcentratedBufferVolume = If[MatchQ[concentratedBufferVolume,Null|Automatic],
                  scaledConcentratedBufferVolume,
                  QuantityMagnitude[Convert[concentratedBufferVolume,Liter]]
                ];
                scaledConcentratedBufferDiluentVolume = If[MatchQ[concentratedBufferDiluentVolume,Null|Automatic],
                  scaledConcentratedBufferDiluentVolume,
                  QuantityMagnitude[Convert[concentratedBufferDiluentVolume,Liter]]
                ];
                scaledFinalVolume = If[MatchQ[finalVolume,Null|Automatic],
                  scaledFinalVolume,
                  QuantityMagnitude[Convert[finalVolume,Liter]]
                ];
                scaledTransferVolume = If[MatchQ[transferVolume,Null|Automatic],
                  scaledTransferVolume,
                  QuantityMagnitude[Convert[transferVolume,Liter]]
                ];
                scaledTotalDilutionVolume = If[MatchQ[totalDilutionVolume,Null|Automatic],
                  scaledTotalDilutionVolume,
                  QuantityMagnitude[Convert[totalDilutionVolume,Liter]]
                ];
                scaledTargetAnalyteInitialConcentration = If[MatchQ[convertedTargetAnalyteInitialConcentration,Null|Automatic],
                  scaledTargetAnalyteInitialConcentration,
                  QuantityMagnitude[Convert[convertedTargetAnalyteInitialConcentration,concentrationUnits]]
                ];
                scaledTargetAnalyteConcentration = Which[
                  MatchQ[targetAnalyteConcentration,Null|Automatic],
                  scaledTargetAnalyteConcentration,
                  TrueQ[multipleTargetAnalyteConcentrationUnitsError[[1]]],
                  QuantityMagnitude[targetAnalyteConcentration],
                  True,
                  QuantityMagnitude[Convert[targetAnalyteConcentration,concentrationUnits]]
                ];
                scaledCumulativeDilutionFactor = If[MatchQ[cumulativeDilutionFactor,Null|Automatic],
                  scaledCumulativeDilutionFactor,
                  cumulativeDilutionFactor
                ];
                scaledSerialDilutionFactor = If[MatchQ[serialDilutionFactor,Null|Automatic],
                  scaledSerialDilutionFactor,
                  serialDilutionFactor
                ];
                scaledSDFTilNow = currentTotalSerialDilutionFactor;
                scaledSolventConcentrationFactor = currentSampleSolventDilutionFactor;
                scaledConcentratedBufferDilutionFactor = If[MatchQ[concentratedBufferDilutionFactor,Null|Automatic],
                  scaledConcentratedBufferDilutionFactor,
                  concentratedBufferDilutionFactor
                ];

                (* Solve the equations *)
                solvedEquationsNoDefaults = Quiet[FirstOrDefault[Solve[myEquations],{}]];

                (* See if everything has a value *)
                (* An option has a value if it is numeric *)
                allOptionsSolvedForBool = MatchQ[solvedEquationsNoDefaults[[All,2]],{NumericP..}];

                Which[
                  (* WOO we solved everything *)
                  TrueQ[allOptionsSolvedForBool],
                  Module[{},
                    (* Only update our "current" variables if we are in serial dilution *)
                    (* In the case of Linear dilution they are left untouched and always use their initial values *)
                    If[MatchQ[resolvedDilutionType,Serial],
                      currentSampleVolume = If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,scaledTotalDilutionVolume/.solvedEquationsNoDefaults];
                      currentTotalSerialDilutionFactor = If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,scaledCumulativeDilutionFactor/.solvedEquationsNoDefaults];
                      currentSampleAnalyteConcentration = If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,scaledTargetAnalyteConcentration/.solvedEquationsNoDefaults];
                      currentSampleSolventDilutionFactor = Module[{transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume},
                        (* Get our needed values *)
                        {
                          transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume
                        } = Map[
                          If[NumericQ[#],
                            #,
                            #/.solvedEquationsNoDefaults
                          ]&,
                          {
                            scaledTransferVolume,scaledConcentratedBufferVolume,scaledConcentratedBufferDiluentVolume,scaledConcentratedBufferDilutionFactor,scaledTotalDilutionVolume
                          }
                        ];

                        (* Do a dilution calculation - M1V1 + M2V2 = M3V3 => M3 = (M1V1 + M2V2) / V3 *)
                        ((currentSampleSolventDilutionFactor * transferVolume) + ((concentratedBufferVolume + concentratedBufferDiluentVolume) * (resolvedConcentratedBufferCBDF/concentratedBufferDilutionFactor))) / totalDilutionVolume

                      ];
                    ];

                    (* Gather our resolved options in reasonable units *)
                    {
                      If[MatchQ[transferVolume,Except[Automatic]],transferVolume,UnitScale[(scaledTransferVolume/.solvedEquationsNoDefaults) * Liter]],
                      If[MatchQ[concentratedBufferVolume,Except[Automatic]],concentratedBufferVolume,UnitScale[(scaledConcentratedBufferVolume/.solvedEquationsNoDefaults) * Liter]],
                      If[MatchQ[concentratedBufferDiluentVolume,Except[Automatic]],concentratedBufferDiluentVolume,UnitScale[(scaledConcentratedBufferDiluentVolume/.solvedEquationsNoDefaults) * Liter]],
                      If[MatchQ[finalVolume,Except[Automatic]],finalVolume,UnitScale[(scaledFinalVolume/.solvedEquationsNoDefaults)* Liter]],
                      If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,UnitScale[(scaledTotalDilutionVolume/.solvedEquationsNoDefaults)* Liter]],
                      If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,UnitScale[(scaledTargetAnalyteConcentration/.solvedEquationsNoDefaults) * concentrationUnits]],
                      If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,N[scaledCumulativeDilutionFactor/.solvedEquationsNoDefaults]],
                      If[NumericQ[serialDilutionFactor],serialDilutionFactor,N[scaledSerialDilutionFactor/.solvedEquationsNoDefaults]],
                      If[MatchQ[concentratedBufferDilutionFactor,Except[Automatic]],concentratedBufferDilutionFactor,N[scaledConcentratedBufferDilutionFactor/.solvedEquationsNoDefaults]]
                    }
                  ],

                  (* Further resolve with second solve and defaults *)
                  !MatchQ[solvedEquationsNoDefaults,{}],
                  Module[{varsNeededToSolve,solvedEquationsWithDefaults},

                    (* Extract the variables that are still needed to solve the equations *)
                    varsNeededToSolve = DeleteDuplicates@Cases[solvedEquationsNoDefaults[[All,2]],_Symbol,Infinity];

                    (* Set the extra variables we need based on how many are needed/what was set originally *)
                    Which[
                      (* Case 1: Nothing was provided *)
                      Length[varsNeededToSolve] > 2,
                      Module[{},
                        (* Set the volume to 1/10th of the sample volume *)
                        scaledTransferVolume = N[currentSampleVolume / 10];

                        (* Set the SerialDilutionFactor to 10 *)
                        scaledSerialDilutionFactor = 10;

                        (* Set the ConcentratedBufferDilutionFactor to the value in the field (else 10) *)
                        scaledConcentratedBufferDilutionFactor = resolvedConcentratedBufferCBDF;
                      ],

                      (* Case 2: Only TransferVolume was provided *)
                      Length[varsNeededToSolve] > 1 && MatchQ[transferVolume,Except[Null|Automatic]],
                      Module[{},
                        (* Set the SerialDilutionFactor to 10 *)
                        scaledSerialDilutionFactor = 10;

                        (* Set the ConcentratedBufferDilutionFactor to the value in the field (else 10) *)
                        scaledConcentratedBufferDilutionFactor = resolvedConcentratedBufferCBDF;
                      ],

                      (* Case 3: Only an option pertaining to the ConcentratedBuffer was provided *)
                      And[
                        Length[varsNeededToSolve] > 1,
                        Or[
                          MatchQ[concentratedBufferVolume,Except[Null|Automatic]],
                          MatchQ[concentratedBufferDiluentVolume,Except[Null|Automatic]],
                          MatchQ[concentratedBufferDilutionFactor,Except[Null|Automatic]]
                        ]
                      ],
                      Module[{},
                        (* Set the TransferVolume to 1/10th of the sample volume - case on which option was set *)
                        Which[
                          (* ConcentratedBufferVolume was set *)
                          MatchQ[concentratedBufferVolume,Except[Null|Automatic]],
                          If[firstDilutionSolventNotConcBool,
                            scaledTransferVolume = resolvedConcentratedBufferCBDF/10*QuantityMagnitude[Convert[concentratedBufferVolume,Liter]],
                            scaledTransferVolume = QuantityMagnitude[Convert[concentratedBufferVolume,Liter]] * (resolvedConcentratedBufferCBDF)/9
                          ],
                          MatchQ[concentratedBufferDiluentVolume,Except[Null|Automatic]],
                          If[firstDilutionSolventNotConcBool,
                            scaledTransferVolume = (QuantityMagnitude[Convert[concentratedBufferDiluentVolume,Liter]] * resolvedConcentratedBufferCBDF) / (9 * resolvedConcentratedBufferCBDF - 10),
                            scaledTransferVolume = (QuantityMagnitude[Convert[concentratedBufferDiluentVolume,Liter]] * resolvedConcentratedBufferCBDF) / (9 * (resolvedConcentratedBufferCBDF - 1))
                          ],
                          MatchQ[concentratedBufferDilutionFactor,Except[Null|Automatic]],
                          (* Here we can just set to 1/10th of the sample volume because we have no other volume info *)
                          scaledTransferVolume = N[currentSampleVolume / 10];
                        ];

                        (* Set the total dilution volume *)
                        scaledTotalDilutionVolume = 10 * scaledTransferVolume;
                      ],

                      (* Case 4: If only missing scaledTargetAnalyteInitialConcentration b/c of no noTargetAnalyteInitialConcentrationFound *)
                      (* We do not need to set anything else b/c that would work fine *)
                      ContainsOnly[varsNeededToSolve,{scaledTargetAnalyteInitialConcentration,scaledTargetAnalyteConcentration}]&&(noTargetAnalyteInitialConcentrationFound),
                      Nothing,

                      (* Case 5: Only one option pertaining to the DilutionFactor or Total volume was provided *)
                      Length[varsNeededToSolve] > 1,
                      Module[{},
                        (* Set the TransferVolume based on a provided option (scaling so that we are doing a 10x dilution) *)
                        scaledTransferVolume = Which[
                          MatchQ[finalVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[finalVolume / 9, Liter]],

                          MatchQ[totalDilutionVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[totalDilutionVolume / 10, Liter]],

                          MatchQ[targetAnalyteConcentration,Except[Null|Automatic]],
                          Module[{targetAnalyteConcentrationToUse},
                            (* Get the given targetAnalyteConcentration in a usable form *)
                            targetAnalyteConcentrationToUse = If[TrueQ[multipleTargetAnalyteConcentrationUnitsError[[1]]],
                              QuantityMagnitude[targetAnalyteConcentration],
                              QuantityMagnitude[Convert[targetAnalyteConcentration,concentrationUnits]]
                            ];
                            (currentSampleVolume / (currentSampleAnalyteConcentration / targetAnalyteConcentrationToUse))
                          ],

                          MatchQ[cumulativeDilutionFactor,Except[Null|Automatic]],
                          (currentSampleVolume / cumulativeDilutionFactor),

                          MatchQ[serialDilutionFactor,Except[Null|Automatic]],
                          (currentSampleVolume / serialDilutionFactor)
                        ];

                        (* Set the ConcentratedBufferDilutionFactor *)
                        scaledConcentratedBufferDilutionFactor = resolvedConcentratedBufferCBDF;
                      ],

                      (* Case 6: One variable missing. TransferVolume and ConcentratedBuffer option specified *)
                      And[
                        Length[varsNeededToSolve] == 1,
                        MatchQ[transferVolume,Except[Null|Automatic]],
                        Or[
                          MatchQ[concentratedBufferVolume,Except[Null|Automatic]],
                          MatchQ[concentratedBufferDiluentVolume,Except[Null|Automatic]],
                          MatchQ[concentratedBufferDilutionFactor,Except[Null|Automatic]]
                        ]
                      ],
                      Module[{},
                        (* In this case, we need to set TotalDilutionVolume - it will just be 10x of transferVolume *)
                        scaledTotalDilutionVolume = 10 * QuantityMagnitude[Convert[transferVolume,Liter]]
                      ],

                      (* Case 7: One variable missing. TransferVolume is set *)
                      And[
                        Length[varsNeededToSolve] == 1,
                        MatchQ[transferVolume,Except[Null|Automatic]]
                      ],
                      Module[{},
                        (* In this case we need to set ConcentratedBufferDilutionFactor *)

                        (* Divide it by the concentratedBufferDilutionFactor of the solvent of the sample *)
                        scaledConcentratedBufferDilutionFactor = resolvedConcentratedBufferCBDF/scaledSolventConcentrationFactor
                      ],

                      (* Case 8: One variable missing. No ConcentratedBuffer options set *)
                      And[
                        Length[varsNeededToSolve] == 1,
                        And[
                          !MatchQ[concentratedBufferVolume,Except[Null|Automatic]],
                          !MatchQ[concentratedBufferDiluentVolume,Except[Null|Automatic]],
                          !MatchQ[concentratedBufferDilutionFactor,Except[Null|Automatic]]
                        ]
                      ],
                      Module[{},
                        (* In this case we need to set ConcentratedBufferDilutionFactor *)
                        (* Divide it by the concentratedBufferDilutionFactor of the solvent of the sample *)
                        scaledConcentratedBufferDilutionFactor = resolvedConcentratedBufferCBDF/scaledSolventConcentrationFactor
                      ],

                      (* Case 9: The only left over cases are missing a TransferVolume *)
                      True,
                      Module[{},
                        (* Set the TransferVolume based on a provided option (scaling so that we are doing a 10x dilution) *)
                        scaledTransferVolume = Which[
                          MatchQ[finalVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[finalVolume / 9, Liter]],

                          MatchQ[totalDilutionVolume,Except[Null|Automatic]],
                          QuantityMagnitude[Convert[totalDilutionVolume / 10, Liter]],

                          MatchQ[targetAnalyteConcentration,Except[Null|Automatic]],
                          Module[{targetAnalyteConcentrationToUse},
                            (* Get the given targetAnalyteConcentration in a usable form *)
                            targetAnalyteConcentrationToUse = If[TrueQ[multipleTargetAnalyteConcentrationUnitsError[[1]]],
                              QuantityMagnitude[targetAnalyteConcentration],
                              QuantityMagnitude[Convert[targetAnalyteConcentration,concentrationUnits]]
                            ];
                            (currentSampleVolume / (currentSampleAnalyteConcentration / targetAnalyteConcentrationToUse))
                          ],

                          MatchQ[cumulativeDilutionFactor,Except[Null|Automatic]],
                          (currentSampleVolume / cumulativeDilutionFactor),

                          MatchQ[serialDilutionFactor,Except[Null|Automatic]],
                          (currentSampleVolume / serialDilutionFactor),

                          (* If we made it this far, we know we are only given info about the concentrated buffer *)
                          And[
                            MatchQ[concentratedBufferVolume,Except[Null|Automatic]],
                            MatchQ[concentratedBufferDiluentVolume,Except[Null|Automatic]]
                          ],
                          QuantityMagnitude[Convert[(concentratedBufferVolume+concentratedBufferDiluentVolume) / 9, Liter]],

                          And[
                            MatchQ[concentratedBufferVolume,Except[Null|Automatic]],
                            MatchQ[concentratedBufferDilutionFactor,Except[Null|Automatic]]
                          ],
                          If[firstDilutionSolventNotConcBool,
                            scaledTransferVolume = concentratedBufferDilutionFactor/10*QuantityMagnitude[Convert[concentratedBufferVolume,Liter]],
                            scaledTransferVolume = QuantityMagnitude[Convert[concentratedBufferVolume,Liter]] * (concentratedBufferDilutionFactor)/9
                          ],
                          And[
                            MatchQ[concentratedBufferDiluentVolume,Except[Null|Automatic]],
                            MatchQ[concentratedBufferDilutionFactor,Except[Null|Automatic]]
                          ],
                          If[firstDilutionSolventNotConcBool,
                            scaledTransferVolume = (QuantityMagnitude[Convert[concentratedBufferDiluentVolume,Liter]] * concentratedBufferDilutionFactor) / (9 * concentratedBufferDilutionFactor - 10),
                            scaledTransferVolume = (QuantityMagnitude[Convert[concentratedBufferDiluentVolume,Liter]] * concentratedBufferDilutionFactor) / (9 * (concentratedBufferDilutionFactor - 1))
                          ]
                        ]
                      ]
                    ];
                    (* Resolve the equations *)
                    solvedEquationsWithDefaults = Quiet[FirstOrDefault[Solve[myEquations],{}]];

                    Module[{varsNeededToSolve},

                      (* Extract the variables that are still needed to solve the equations *)
                      varsNeededToSolve = DeleteDuplicates@Cases[solvedEquationsWithDefaults[[All,2]],_Symbol,Infinity];

                      Which[
                        (* If we have solved for everything or we just missing TargetAnalyteInitialConcentration for noTargetAnalyteInitialConcentrationFound *)
                        ContainsOnly[varsNeededToSolve,{scaledTargetAnalyteInitialConcentration,scaledTargetAnalyteConcentration}],
                        Module[{},
                          (* Mark a warning if necessary *)
                          (* If noTargetAnalyteInitialConcentrationFound, only set concentration related options to Null or initial value *)
                          If[noTargetAnalyteInitialConcentrationFound,
                            missingTargetAnalyteInitialConcentrationWarning=True
                          ];

                          (* Only update our "current" variables if we are in serial dilution *)
                          (* In the case of Linear dilution they are left untouched and always use their initial values *)
                          If[MatchQ[resolvedDilutionType,Serial],
                            currentSampleVolume=If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,scaledTotalDilutionVolume/.solvedEquationsWithDefaults];
                            currentTotalSerialDilutionFactor=If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,scaledCumulativeDilutionFactor/.solvedEquationsWithDefaults];
                            currentSampleAnalyteConcentration=If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,If[noTargetAnalyteInitialConcentrationFound,Null,scaledTargetAnalyteConcentration/.solvedEquationsWithDefaults]];
                            currentSampleSolventDilutionFactor=Module[{transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume},
                              (* Get our needed values *)
                              {
                                transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume
                              }=Map[
                                If[NumericQ[#],#,#/.solvedEquationsWithDefaults]&,
                                {
                                  scaledTransferVolume,scaledConcentratedBufferVolume,scaledConcentratedBufferDiluentVolume,scaledConcentratedBufferDilutionFactor,scaledTotalDilutionVolume
                                }
                              ];

                              (* Do a dilution calculation - M1V1 + M2V2 = M3V3 => M3 = (M1V1 + M2V2) / V3 *)
                              ((currentSampleSolventDilutionFactor*transferVolume)+((concentratedBufferVolume+concentratedBufferDiluentVolume)*(resolvedConcentratedBufferCBDF/concentratedBufferDilutionFactor)))/totalDilutionVolume

                            ];
                          ];

                          (* Gather our resolved options in reasonable units *)
                          {
                            If[MatchQ[transferVolume,Except[Automatic|Null]],transferVolume,UnitScale[(scaledTransferVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[concentratedBufferVolume,Except[Automatic|Null]],concentratedBufferVolume,UnitScale[(scaledConcentratedBufferVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[concentratedBufferDiluentVolume,Except[Automatic|Null]],concentratedBufferDiluentVolume,UnitScale[(scaledConcentratedBufferDiluentVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[finalVolume,Except[Automatic|Null]],finalVolume,UnitScale[(scaledFinalVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[totalDilutionVolume,Except[Automatic|Null]],totalDilutionVolume,UnitScale[(scaledTotalDilutionVolume/.solvedEquationsWithDefaults)*Liter]],
                            If[MatchQ[targetAnalyteConcentration,Except[Automatic|Null]],targetAnalyteConcentration,If[noTargetAnalyteInitialConcentrationFound,Null,UnitScale[(scaledTargetAnalyteConcentration/.solvedEquationsWithDefaults)*concentrationUnits]]],
                            If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,N[scaledCumulativeDilutionFactor/.solvedEquationsWithDefaults]],
                            If[NumericQ[serialDilutionFactor],serialDilutionFactor,N[scaledSerialDilutionFactor/.solvedEquationsWithDefaults]],
                            If[MatchQ[concentratedBufferDilutionFactor,Except[Automatic|Null]],concentratedBufferDilutionFactor,N[scaledConcentratedBufferDilutionFactor/.solvedEquationsWithDefaults]]
                          }
                        ],

                        (* Otherwise, the math must still be impossible *)
                        True,
                        Module[{},
                          conflictingFactorsAndVolumesError=True;
                          (* Only update our "current" variables if we are in serial dilution *)
                          (* In the case of Linear dilution they are left untouched and always use their initial values *)
                          If[MatchQ[resolvedDilutionType,Serial],
                            currentSampleVolume=If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,Null];
                            currentTotalSerialDilutionFactor=If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,Null];
                            currentSampleAnalyteConcentration=If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,Null];
                            currentSampleSolventDilutionFactor=Module[{transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume,calculatedNewDilutionFactor},
                              (* Get our needed values *)
                              {
                                transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume
                              }=Map[
                                If[NumericQ[#],
                                  #,
                                  Null
                                ]&,
                                {
                                  scaledTransferVolume,scaledConcentratedBufferVolume,scaledConcentratedBufferDiluentVolume,scaledConcentratedBufferDilutionFactor,scaledTotalDilutionVolume
                                }
                              ];

                              (* Do a dilution calculation - M1V1 + M2V2 = M3V3 => M3 = (M1V1 + M2V2) / V3 *)
                              calculatedNewDilutionFactor=((currentSampleSolventDilutionFactor*transferVolume)+((concentratedBufferVolume+concentratedBufferDiluentVolume)*(resolvedConcentratedBufferCBDF/concentratedBufferDilutionFactor)))/totalDilutionVolume;

                              (* If calculatedNewDilutionFactor is still a value, use it, otherwise set to Null *)
                              If[NumericQ[calculatedNewDilutionFactor],
                                calculatedNewDilutionFactor,
                                Null
                              ]
                            ];
                          ];

                          (* Gather our resolved options in reasonable units *)
                          {
                            If[MatchQ[transferVolume,Except[Automatic]],transferVolume,Null],
                            If[MatchQ[concentratedBufferVolume,Except[Automatic]],concentratedBufferVolume,Null],
                            If[MatchQ[concentratedBufferDiluentVolume,Except[Automatic]],concentratedBufferDiluentVolume,Null],
                            If[MatchQ[finalVolume,Except[Automatic]],finalVolume,Null],
                            If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,Null],
                            If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,Null],
                            If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,Null],
                            If[NumericQ[serialDilutionFactor],serialDilutionFactor,Null],
                            If[MatchQ[concentratedBufferDilutionFactor,Except[Automatic]],concentratedBufferDilutionFactor,Null]
                          }
                        ]
                      ]
                    ]
                  ],

                  True,
                  Module[{},
                    conflictingFactorsAndVolumesError = True;
                    (* Only update our "current" variables if we are in serial dilution *)
                    (* In the case of Linear dilution they are left untouched and always use their initial values *)
                    If[MatchQ[resolvedDilutionType,Serial],
                      currentSampleVolume = If[NumericQ[scaledTotalDilutionVolume],scaledTotalDilutionVolume,Null];
                      currentTotalSerialDilutionFactor = If[NumericQ[scaledCumulativeDilutionFactor],scaledCumulativeDilutionFactor,Null];
                      currentSampleAnalyteConcentration = If[NumericQ[scaledTargetAnalyteConcentration],scaledTargetAnalyteConcentration,Null];
                      currentSampleSolventDilutionFactor = Module[{transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume,calculatedNewDilutionFactor},
                        (* Get our needed values *)
                        {
                          transferVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDilutionFactor,totalDilutionVolume
                        } = Map[
                          If[NumericQ[#],
                            #,
                            Null
                          ]&,
                          {
                            scaledTransferVolume,scaledConcentratedBufferVolume,scaledConcentratedBufferDiluentVolume,scaledConcentratedBufferDilutionFactor,scaledTotalDilutionVolume
                          }
                        ];

                        (* Do a dilution calculation - M1V1 + M2V2 = M3V3 => M3 = (M1V1 + M2V2) / V3 *)
                        calculatedNewDilutionFactor = ((currentSampleSolventDilutionFactor * transferVolume) + ((concentratedBufferVolume + concentratedBufferDiluentVolume) * (resolvedConcentratedBufferCBDF/concentratedBufferDilutionFactor))) / totalDilutionVolume;

                        (* If calculatedNewDilutionFactor is still a value, use it, otherwise set to Null *)
                        If[NumericQ[calculatedNewDilutionFactor],
                          calculatedNewDilutionFactor,
                          Null
                        ]
                      ];
                    ];

                    (* Gather our resolved options in reasonable units *)
                    {
                      If[MatchQ[transferVolume,Except[Automatic]],transferVolume,Null],
                      If[MatchQ[concentratedBufferVolume,Except[Automatic]],concentratedBufferVolume,Null],
                      If[MatchQ[concentratedBufferDiluentVolume,Except[Automatic]],concentratedBufferDiluentVolume,Null],
                      If[MatchQ[finalVolume,Except[Automatic]],finalVolume,Null],
                      If[MatchQ[totalDilutionVolume,Except[Automatic]],totalDilutionVolume,Null],
                      If[MatchQ[targetAnalyteConcentration,Except[Automatic]],targetAnalyteConcentration,Null],
                      If[NumericQ[cumulativeDilutionFactor],cumulativeDilutionFactor,Null],
                      If[NumericQ[serialDilutionFactor],serialDilutionFactor,Null],
                      If[MatchQ[concentratedBufferDilutionFactor,Except[Automatic]],concentratedBufferDilutionFactor,Null]
                    }
                  ]
                ]
              ]
            ],
            {
              expandedSpecifiedConcentratedBufferVolume,
              expandedSpecifiedConcentratedBufferDiluentVolume,
              expandedSpecifiedFinalVolume,
              expandedSpecifiedTransferVolume,
              expandedSpecifiedTotalDilutionVolume,
              expandedSpecifiedTargetAnalyteConcentration,
              expandedSpecifiedSerialDilutionFactor,
              expandedSpecifiedCumulativeDilutionFactor,
              expandedSpecifiedConcentratedBufferDilutionFactor,
              Range[Length[expandedSpecifiedConcentratedBufferDilutionFactor]]
            }
          ]
        ],

        "Not Possible",
        Module[{},
          (* Resolve all Automatics to Null *)
          {
            intermediateTransferVolume,
            intermediateDiluentVolume,
            intermediateConcentratedBufferVolume,
            intermediateConcentratedBufferDiluentVolume,
            intermediateFinalVolume,
            intermediateTotalDilutionVolume,
            resolvedTargetAnalyteConcentration,
            resolvedCumulativeDilutionFactor,
            intermediateSerialDilutionFactor,
            resolvedConcentratedBufferDilutionFactor
          } = {
            expandedSpecifiedTransferVolume,
            expandedSpecifiedDiluentVolume,
            expandedSpecifiedConcentratedBufferVolume,
            expandedSpecifiedConcentratedBufferDiluentVolume,
            expandedSpecifiedFinalVolume,
            expandedSpecifiedTotalDilutionVolume,
            expandedSpecifiedTargetAnalyteConcentration,
            expandedSpecifiedCumulativeDilutionFactor,
            expandedSpecifiedSerialDilutionFactor,
            expandedSpecifiedConcentratedBufferDilutionFactor
          } /. {Automatic -> Null}
        ]
      ];

      (* Round any volume values to a valid precision *)
      {
        resolvedDiluentVolume,
        resolvedTransferVolume,
        resolvedConcentratedBufferVolume,
        resolvedConcentratedBufferDiluentVolume,
        roundedResolvedFinalVolume,
        resolvedTotalDilutionVolume
      } = Module[{optionsToRound,roundedResolvedVolumeOptions},

        (* Gather the options that need to be rounded *)
        optionsToRound = {
          If[MatchQ[intermediateDiluentVolume, {VolumeP..}],
            DiluentVolume -> intermediateDiluentVolume,
            Nothing
          ],
          If[MatchQ[intermediateTransferVolume,{VolumeP..}],
            TransferVolume -> intermediateTransferVolume,
            Nothing
          ],
          If[MatchQ[intermediateConcentratedBufferVolume,{VolumeP..}],
            ConcentratedBufferVolume -> intermediateConcentratedBufferVolume,
            Nothing
          ],
          If[MatchQ[intermediateConcentratedBufferDiluentVolume,{VolumeP..}],
            ConcentratedBufferDiluentVolume -> intermediateConcentratedBufferDiluentVolume,
            Nothing
          ],
          If[MatchQ[intermediateFinalVolume,{VolumeP..}],
            FinalVolume -> intermediateFinalVolume,
            Nothing
          ],
          If[MatchQ[intermediateTotalDilutionVolume,{VolumeP..}],
            TotalDilutionVolume -> intermediateTotalDilutionVolume,
            Nothing
          ]
        };

        (* Round the resolved options *)
        (* Use KeyValueMap[...] to Map SafeRound[...] to round the resolved values to a proper precision instead of using RoundOptionPrecisions b/c the warning messages may be picked by high level ModifyFunctionMessages[...] and got spit out unexpectedly *)
        roundedResolvedVolumeOptions = KeyValueMap[#1->SafeRound[#2,Lookup[optionPrecisions,#1]]&,Association[optionsToRound]];

        (* Extract the rounded options into final resolved variables *)
        {
          If[!MatchQ[Lookup[roundedResolvedVolumeOptions,DiluentVolume],_Missing],
            Lookup[roundedResolvedVolumeOptions, DiluentVolume],
            intermediateDiluentVolume
          ],
          If[!MatchQ[Lookup[roundedResolvedVolumeOptions,TransferVolume],_Missing],
            Lookup[roundedResolvedVolumeOptions, TransferVolume],
            intermediateTransferVolume
          ],
          If[!MatchQ[Lookup[roundedResolvedVolumeOptions,ConcentratedBufferVolume],_Missing],
            Lookup[roundedResolvedVolumeOptions, ConcentratedBufferVolume],
            intermediateConcentratedBufferVolume
          ],
          If[!MatchQ[Lookup[roundedResolvedVolumeOptions,ConcentratedBufferDiluentVolume],_Missing],
            Lookup[roundedResolvedVolumeOptions, ConcentratedBufferDiluentVolume],
            intermediateConcentratedBufferDiluentVolume
          ],
          If[!MatchQ[Lookup[roundedResolvedVolumeOptions,FinalVolume],_Missing],
            Lookup[roundedResolvedVolumeOptions, FinalVolume],
            intermediateFinalVolume
          ],
          If[!MatchQ[Lookup[roundedResolvedVolumeOptions,TotalDilutionVolume],_Missing],
            Lookup[roundedResolvedVolumeOptions, TotalDilutionVolume],
            intermediateTotalDilutionVolume
          ]
        }
      ];

      (* The resolution above makes the assumption that DiscardFinalTransfer -> True *)
      (* We have to adjust this, if DiscardFinalTransfer -> False, or if DilutionType is Linear (nothing is ever taken away) *)
      resolvedFinalVolume = MapThread[
        Function[{transferVolume,finalVolume,discardFinalTransfer,index},
          Module[{},
            Which[
              (* If final volume or TransferVolume are currently Null, it means we had a failure during resolution, so keep the value as is *)
              NullQ[transferVolume] || NullQ[finalVolume],
              Null,

              (* If we are doing a serial dilution and discardFinalTransfer is False, add the final volume back in if we are checking the final sample *)
              MatchQ[resolvedDilutionType,Serial] && discardFinalTransfer == False && index == Length[resolvedTransferVolume] && Length[resolvedTransferVolume]>1,
              finalVolume + transferVolume,

              (* In all other cases, leave it as is *)
              True,
              finalVolume
            ]
          ]
        ],
        {
          resolvedTransferVolume,
          roundedResolvedFinalVolume,
          ConstantArray[resolvedDiscardFinalTransfer,Length[resolvedTransferVolume]],
          Range[Length[resolvedTransferVolume]]
        }
      ];

      (* The resolution above resolves SerialDilutionFactor regardless of if we are doing Linear or Serial Dilution *)
      (* We need to correct for that if we are doing Linear *)
      resolvedSerialDilutionFactor = If[MatchQ[resolvedDilutionType,Linear],
        Map[
          Function[{specifiedSDF},
            If[MatchQ[specifiedSDF,Except[Automatic]],
              specifiedSDF,
              Null
            ]
          ],
          expandedSpecifiedSerialDilutionFactor
        ],
        intermediateSerialDilutionFactor
      ];

      (* Resolve Incubate and partially resolve MixType *)
      resolvedIncubate = If[
        (* If the option is specified, keep it *)
        MatchQ[specifiedIncubate,Except[Automatic]],
        specifiedIncubate,

        (* Otherwise, if there are any other mix options set, resolve to True *)
        Or[
          MatchQ[specifiedIncubationTime,Except[Automatic]],
          MatchQ[specifiedIncubationInstrument,Except[Automatic]],
          MatchQ[specifiedIncubationTemperature,Except[Automatic]],
          MatchQ[specifiedMixType,Except[Automatic]],
          MatchQ[specifiedNumberOfMixes,Except[Automatic]],
          MatchQ[specifiedMixRate,Except[Automatic]],
          MatchQ[specifiedMixOscillationAngle,Except[Automatic]]
        ]
      ];

      (* Gather mapthread results *)
      {
        noDiluentSpecifiedWarning,missingTargetAnalyteInitialConcentrationWarning,conflictingFactorsAndVolumesError,noSampleVolumeWarning,
        multipleTargetAnalyteConcentrationUnitsError,conflictingTargetAnalyteConcentrationUnitsError,targetAnalyteTests,
        resolvedDilutionType, resolvedDilutionStrategy, resolvedNumberOfDilutions, resolvedTargetAnalyte,
        resolvedDiluent, resolvedConcentratedBuffer, resolvedConcentratedBufferDiluent, resolvedCumulativeDilutionFactor,
        resolvedSerialDilutionFactor, resolvedTargetAnalyteConcentration, resolvedTransferVolume, resolvedTotalDilutionVolume,
        resolvedDiscardFinalTransfer, resolvedFinalVolume, resolvedDiluentVolume, resolvedConcentratedBufferVolume,
        resolvedConcentratedBufferDiluentVolume, resolvedConcentratedBufferDilutionFactor, resolvedIncubate
      }
    ]
  ],
    {listedSamples,mapThreadFriendlyOptions}
  ]];

  (* Now that the dilution options are resolved - we have to simulate samples for each dilution in order to resolve the mix options *)
  (* simulatedSamples is a nested list of samples *)
  {simulatedSamples,simulatedSampleAndContainerSimulation} = Module[{sampleMaxTotalVolumes,preferredContainersForSimulatedSamples,flattenedSimulatedSamplesAndContainers},

    (* Get a nested list of the volumes of each sample *)
    sampleMaxTotalVolumes = MapThread[
      Function[{mySample,resolvedTransferVolumes,resolvedDiluentVolumes,resolvedConcentratedBufferVolumes,resolvedConcentratedBufferDiluentVolumes,resolvedNumberOfDilutions},
        Module[
          {
            sanitizedTransferVolume,sanitizedDiluentVolume,sanitizedConcentratedBufferVolume,sanitizedConcentratedBufferDiluentVolume,
            totalVolumes
          },

          (* Little helper function to get rid of nulls in volumes *)
          sanitizeVolumes[nestedVolumeList:ListableP[Null|VolumeP]] := Module[{},

            (* If nested volume list is Null, replace with constant array of 0 Milliliter for length of number of dilutions *)
            If[MatchQ[nestedVolumeList,Null],
              ConstantArray[0 Milliliter, resolvedNumberOfDilutions],
              (* Otherwise, just replace nulls with 0 mL *)
              nestedVolumeList/.{Null->0Milliliter}
            ]
          ];

          (* Do a little sanitization of the options to get rid of any Nulls *)
          sanitizedTransferVolume = sanitizeVolumes[resolvedTransferVolumes];
          sanitizedDiluentVolume = sanitizeVolumes[resolvedDiluentVolumes];
          sanitizedConcentratedBufferVolume = sanitizeVolumes[resolvedConcentratedBufferVolumes];
          sanitizedConcentratedBufferDiluentVolume = sanitizeVolumes[resolvedConcentratedBufferDiluentVolumes];

          (* Get the total volumes for each intermediate dilution sample *)
          totalVolumes = MapThread[
            Total[{#1,#2,#3,#4}]&,
            {sanitizedTransferVolume,sanitizedDiluentVolume,sanitizedConcentratedBufferVolume,sanitizedConcentratedBufferDiluentVolume}
          ];

          (* Get the max of each set of volumes - we want all of the samples to be in the same container type so we can *)
          (* do the same type of mixing on all of them *)
          (* NOTE: This will be a little weird if there are drastic volume differences, but we are assuming that should  *)
          (* not be the case for dilutions *)
          Max[totalVolumes]
        ]
      ],
      {listedSamples,resolvedTransferVolumes,resolvedDiluentVolumes,resolvedConcentratedBufferVolumes,resolvedConcentratedBufferDiluentVolumes,resolvedNumberOfDilutions}
    ];

    (* Get the preferred container of each volume and property combo *)
    preferredContainersForSimulatedSamples = Module[{sterileContainerBools,cellTypeValues},

      (* If any of the samples, diluents, or buffers are sterile we need our container to be sterile *)
      sterileContainerBools = MapThread[
        Or@@{#1,#2,#3,#4}&,
        {
          fastAssocLookup[fastAssoc,#,Sterile]/.{$Failed|Null->False}&/@listedSamples,
          fastAssocLookup[fastAssoc,#,Sterile]/.{$Failed|Null->False}&/@resolvedDiluents,
          fastAssocLookup[fastAssoc,#,Sterile]/.{$Failed|Null->False}&/@resolvedConcentratedBuffers,
          fastAssocLookup[fastAssoc,#,Sterile]/.{$Failed|Null->False}&/@resolvedConcentratedBufferDiluents
        }
      ];

      (* If we have any bit of MicrobialCellTypeP sample, it's Bacterial (Currently there is no distinction for containers among the Microbial cell types). Otherwise, it's Mammalian if we have any bit of a Mammalian sample. *)
      cellTypeValues = MapThread[
        Which[
          MemberQ[{#1,#2,#3,#4},MicrobialCellTypeP],
          Bacterial,
          MemberQ[{#1,#2,#3,#4},NonMicrobialCellTypeP],
          Mammalian,
          True,
          Null
        ]&,
        {
          fastAssocLookup[fastAssoc,#,CellType]/.{$Failed|Null->False}&/@listedSamples,
          fastAssocLookup[fastAssoc,#,CellType]/.{$Failed|Null->False}&/@resolvedDiluents,
          fastAssocLookup[fastAssoc,#,CellType]/.{$Failed|Null->False}&/@resolvedConcentratedBuffers,
          fastAssocLookup[fastAssoc,#,CellType]/.{$Failed|Null->False}&/@resolvedConcentratedBufferDiluents
        }
      ];

      (* Find a valid container *)
      MapThread[
        Module[{possiblePlate,possibleVessel},
          (* See if that volume can fit in a plate (also meeting our other conditions) - we want to prioritize plates if possible because *)
          (* that will reduce the amount of labware, if the dilution series can happen in one plate *)
          possiblePlate = PreferredContainer[
            Sequence@@{#1,
              Sterile -> #2,
              CellType -> #3,
              Type -> Plate,
              If[MatchQ[resolvedPreparation, Robotic],
                LiquidHandlerCompatible -> True,
                Nothing
              ],
              Messages -> False}
          ];

          possibleVessel = PreferredContainer[
            Sequence@@{#1,
              Sterile -> #2,
              CellType -> #3,
              Type -> Vessel,
              If[MatchQ[resolvedPreparation, Robotic],
                LiquidHandlerCompatible -> True,
                Nothing
              ],
              Messages -> False}
          ];

          Which[
            (* If we found a plate, use it *)
            !MatchQ[possiblePlate,$Failed],
            possiblePlate,

            (* If we couldn't find a plate but can find a vessel *)
            !MatchQ[possibleVessel,$Failed],
            possibleVessel,

            (* Default to a 50 mL Tube - Another error will have been thrown - we just need to not crash *)
            True,
            Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* Model[Container, Vessel, "50mL Tube"] *)

          ]
        ]&,
        {
          sampleMaxTotalVolumes,
          sterileContainerBools,
          cellTypeValues
        }
      ]
    ];

    (* Simulate our samples *)
    flattenedSimulatedSamplesAndContainers = SimulateSample[
      {Model[Sample, "id:8qZ1VWNmdLBD"]},(* Model[Sample, "Milli-Q water"] *)
      "Dilution",
      {"A1"},
      #[[1]],
      {Volume -> #[[2]]}
    ]&/@Transpose@{preferredContainersForSimulatedSamples,sampleMaxTotalVolumes};

    (* Isolate our new sample objects and combine the rest of the packets into a simulation *)
    {
      Lookup[flattenedSimulatedSamplesAndContainers[[All,1,1]],Object],
      Simulation[Flatten[flattenedSimulatedSamplesAndContainers]]
    }
  ];

  (* Combine our simulation *)
  currentSimulation = UpdateSimulation[currentSimulation,simulatedSampleAndContainerSimulation];

  (* Resolve the Mix options with a Single Mix call *)
  {
    resolvedIncubationTimes,
    resolvedIncubationInstruments,
    resolvedIncubationTemperatures,
    resolvedMixTypes,
    resolvedNumberOfMixes,
    resolvedMixRates,
    resolvedMixOscillationAngles,
    experimentMixTests
  } = Module[
    {
      dilutionLabels,dilutionLabelsNoNull,
      specifiedIncubationTimes,
      specifiedIncubationInstruments,
      specifiedIncubationTemperatures,
      specifiedMixTypes,
      specifiedNumberOfMixes,
      specifiedMixRates,
      specifiedMixOscillationAngles,
      incubationTimeWithLabels,incubationTimeToMix,incubationInstrumentWithLabels,incubationInstrumentToMix,
      incubationTemperatureWithLabels,incubationTemperatureToMix,mixTypeWithLabels,mixTypeWithToMix,
      numberOfMixesWithLabels,numberOfMixesToMix,
      mixRateWithLabels,mixRateToMix,mixOscillationAngleWithLabels,mixOscillationAngleToMix,
      samplesForMix,optionsForMix
    },

    (* Lookup the options we are going to resolve *)
    {
      specifiedIncubationTimes,
      specifiedIncubationInstruments,
      specifiedIncubationTemperatures,
      specifiedMixTypes,
      specifiedNumberOfMixes,
      specifiedMixRates,
      specifiedMixOscillationAngles
    } = Lookup[expandedSafeOps,
      {
        IncubationTime,
        IncubationInstrument,
        IncubationTemperature,
        MixType,
        NumberOfMixes,
        MixRate,
        MixOscillationAngle
      }
    ];

    (* Create unique labels for each sample we are mixing *)
    dilutionLabels = (If[#,CreateUniqueLabel["dilution index"]])&/@resolvedIncubates;
    dilutionLabelsNoNull = dilutionLabels/.Null->Nothing;

    (* Create a helper to split the option lists *)
    splitList[boolList_,optionOrSampleList_,labelList_] := Transpose@MapThread[
      Function[{bool,option,label},
        If[bool,
          {label,option},
          {option,None}
        ]
      ],
      {boolList, optionOrSampleList, labelList}
    ];

    (* Use the helper to split the option lists *)
    {incubationTimeWithLabels,incubationTimeToMix} = splitList[resolvedIncubates,specifiedIncubationTimes,dilutionLabels]/.{None->Nothing};
    {incubationInstrumentWithLabels,incubationInstrumentToMix} = splitList[resolvedIncubates,specifiedIncubationInstruments,dilutionLabels]/.{None->Nothing};
    {incubationTemperatureWithLabels,incubationTemperatureToMix} = splitList[resolvedIncubates,specifiedIncubationTemperatures,dilutionLabels]/.{None->Nothing};
    {mixTypeWithLabels,mixTypeWithToMix} = splitList[resolvedIncubates,specifiedMixTypes,dilutionLabels]/.{None->Nothing};
    {numberOfMixesWithLabels,numberOfMixesToMix} = splitList[resolvedIncubates,specifiedNumberOfMixes,dilutionLabels]/.{None->Nothing};
    {mixRateWithLabels,mixRateToMix} = splitList[resolvedIncubates,specifiedMixRates,dilutionLabels]/.{None->Nothing};
    {mixOscillationAngleWithLabels,mixOscillationAngleToMix} = splitList[resolvedIncubates,specifiedMixOscillationAngles,dilutionLabels]/.{None->Nothing};

    (* Gather the samples to send to Mix *)
    samplesForMix = PickList[simulatedSamples,resolvedIncubates];

    (* Gather the options to send to mix *)
    optionsForMix = {
      Time -> incubationTimeToMix,
      Instrument -> incubationInstrumentToMix,
      Temperature -> incubationTemperatureToMix,
      MixType -> mixTypeWithToMix,
      NumberOfMixes -> numberOfMixesToMix,
      MixRate -> mixRateToMix,
      OscillationAngle -> mixOscillationAngleToMix,
      Preparation -> resolvedPreparation
    };

    (* Call Mix!! - if we have samples to mix *)
    If[MatchQ[Length[samplesForMix],0],
      (* No samples to Mix  - everything resolves to Null *)
      invalidMixOptions = {};
      Append[
        ConstantArray[
          ConstantArray[Null,Length[listedSamples]],
          7 (* This is the number of mix options - Preparation *)
        ],
        {}
      ],
      (* We have samples to mix! *)
      Module[{mixResult,mixTests},
        (* Call ExperimentMix *)
        {mixResult,mixTests}=If[gatherTests,
          ExperimentMix[simulatedSamples, Sequence@@optionsForMix, OptionsResolverOnly -> True, Output->{Options,Tests},Simulation->currentSimulation],
          {
            Module[{invalidOptionsBool,resolvedOptions},

              (* Run the analysis function to get the resolved options *)
              {resolvedOptions,invalidOptionsBool,invalidMixOptions} = ModifyFunctionMessages[
                ExperimentMix,
                {samplesForMix},
                "",
                {},
                {Sequence@@optionsForMix, OptionsResolverOnly -> True, Output -> Options},
                Simulation -> currentSimulation,
                Cache -> combinedCache,
                Output -> {Result,Boolean,InvalidOptions}
              ];

              (* Return the options *)
              resolvedOptions
            ],
            {}
          }
        ];

        (* Translate the resolved mix options back into their proper index in our options *)
        Append[
          Map[
            Function[{mixOption},
              Module[{resolvedMixOption,labledResolvedMixOption,mixOptionToDilutionOptionWithLabels},

                (* Lookup the mix option from the result *)
                (* NOTE: Have to have {}->Null because in the robotic case, Mix returns {} for Instrument *)
                resolvedMixOption = Lookup[mixResult,mixOption]/.{{}->Null};

                (* Thread the labels with the resolved option *)
                labledResolvedMixOption = Thread[dilutionLabelsNoNull -> resolvedMixOption];

                (* Define a list of Mix option to specified dilution option with labels *)
                mixOptionToDilutionOptionWithLabels = {
                  Time -> incubationTimeWithLabels,
                  Instrument -> incubationInstrumentWithLabels,
                  Temperature -> incubationTemperatureWithLabels,
                  MixType -> mixTypeWithLabels,
                  NumberOfMixes -> numberOfMixesWithLabels,
                  MixRate -> mixRateWithLabels,
                  OscillationAngle -> mixOscillationAngleWithLabels
                };

                (* Use the label rules to reinsert the resolved options at the correct indices *)
                (mixOption/.mixOptionToDilutionOptionWithLabels)/.labledResolvedMixOption/.Automatic->Null
              ]
            ],
            {
              Time,
              Instrument,
              Temperature,
              MixType,
              NumberOfMixes,
              MixRate,
              OscillationAngle
            }
          ],
          mixTests
        ]
      ]
    ]
  ];

  (* Throw Warnings and Error Messages From the MapThread *)
  (* Warning::NoDiluentSpecified *)
  If[MemberQ[noDiluentSpecifiedWarnings,True]&&messages,
    Message[
      Warning::NoDiluentSpecified,
      ObjectToString[PickList[listedSamples,noDiluentSpecifiedWarnings],Cache->combinedCache],
      PickList[Range[Length[listedSamples]],noDiluentSpecifiedWarnings]
    ]
  ];

  (* Warning::MissingTargetAnalyteInitialConcentration *)
  (*If there are missingTargetAnalyteInitialConcentrationWarnings and we are throwing warnings, throw a warning message*)
  If[MemberQ[missingTargetAnalyteInitialConcentrationWarnings,True]&&warnings,
    Message[
      Warning::MissingTargetAnalyteInitialConcentration,
      ObjectToString[PickList[listedSamples,missingTargetAnalyteInitialConcentrationWarnings],Cache->combinedCache],
      PickList[Range[Length[listedSamples]],missingTargetAnalyteInitialConcentrationWarnings]
    ]
  ];

  (* Error::ConflictingFactorsAndVolumes *)
  (*If there are conflictingFactorsAndVolumesErrors and we are throwing messages, throw an error message*)
  conflictingFactorsAndVolumesOptions = If[MemberQ[conflictingFactorsAndVolumesErrors,True]&&messages,
    (
      Message[
        Error::ConflictingFactorsAndVolumes,
        ObjectToString[PickList[listedSamples,conflictingFactorsAndVolumesErrors],Cache -> combinedCache],
        PickList[Range[Length[listedSamples]],conflictingFactorsAndVolumesErrors]
      ];
      {
        CumulativeDilutionFactor,SerialDilutionFactor,TargetAnalyteConcentration,
        TransferVolume,TotalDilutionVolume,FinalVolume,DiluentVolume,
        ConcentratedBufferVolume,ConcentratedBufferDiluentVolume,ConcentratedBufferDiluentFactor
      }
    ),
    {}
  ];

  (* If we are gathering tests, create a test *)
  conflictingFactorsAndVolumesTests = If[gatherTests,
    Module[
      {failingSamples,passingSamples,failingSampleTests,passingSampleTests},

      (*Get the inputs that fail this test*)
      failingSamples=PickList[listedSamples,conflictingFactorsAndVolumesErrors];

      (*Get the inputs that pass this test*)
      passingSamples=PickList[listedSamples,conflictingFactorsAndVolumesErrors,False];

      (*Create a test for the non-passing inputs*)
      failingSampleTests=If[Length[failingSamples]>0,
        Test["There were not mathematical inconsistencies in the provided dilution factor and volume options for the provided samples "<>ObjectToString[failingSamples]<>":",True,False],
        Nothing
      ];

      (*Create a test for the passing inputs*)
      passingSampleTests=If[Length[passingSamples]>0,
        Test["There were not mathematical inconsistencies in the provided dilution factor and volume options for the provided samples "<>ObjectToString[passingSamples]<>":",True,True],
        Nothing
      ];

      (*Return the created tests*)
      {failingSampleTests,passingSampleTests}
    ],
    {}
  ];

  (* Warning::NoSampleVolume *)
  If[MemberQ[noSampleVolumeWarnings,True]&&messages,
    Message[
      Warning::NoSampleVolume,
      ObjectToString[PickList[listedSamples,noSampleVolumeWarnings],Cache->combinedCache],
      PickList[Range[Length[listedSamples]],noSampleVolumeWarnings]
    ]
  ];

  (* Error::MultipleTargetAnalyteConcentrationUnitsError *)
  multipleTargetAnalyteConcentrationUnitsOptions = If[MemberQ[multipleTargetAnalyteConcentrationUnitsErrors[[All,1]], True] && messages,
    Message[
      Error::MultipleTargetAnalyteConcentrationUnitsError,
      ObjectToString[PickList[listedSamples,multipleTargetAnalyteConcentrationUnitsErrors[[All,1]]], Cache -> combinedCache],
      multipleTargetAnalyteConcentrationUnitsErrors[[All,2]],
      PickList[Range[Length[listedSamples]],multipleTargetAnalyteConcentrationUnitsErrors[[All,1]]]
    ];
    {TargetAnalyteConcentration},
    {}
  ];

  (* If we are gathering tests, create a test *)
  multipleTargetAnalyteConcentrationUnitsTests = If[gatherTests,
    Module[
      {failingSamples,passingSamples,failingSampleTests,passingSampleTests},

      (*Get the inputs that fail this test*)
      failingSamples=PickList[listedSamples,multipleTargetAnalyteConcentrationUnitsErrors[[All,1]]];

      (*Get the inputs that pass this test*)
      passingSamples=PickList[listedSamples,multipleTargetAnalyteConcentrationUnitsErrors[[All,1]],False];

      (*Create a test for the non-passing inputs*)
      failingSampleTests=If[Length[failingSamples]>0,
        Test["For the samples "<>ObjectToString[failingSamples]<>"there were not multiple different units in the TargetAnalyteConcentrationOption:",True,False],
        Nothing
      ];

      (*Create a test for the passing inputs*)
      passingSampleTests=If[Length[passingSamples]>0,
        Test["For the samples "<>ObjectToString[passingSamples]<>"there were not multiple different units in the TargetAnalyteConcentrationOption::",True,True],
        Nothing
      ];

      (*Return the created tests*)
      {failingSampleTests,passingSampleTests}
    ],
    {}
  ];

  (* Error::ConflictingTargetAnalyteConcentrationUnitsError *)
  conflictingTargetAnalyteConcentrationUnitsOptions = If[MemberQ[conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]],True] && messages,
    Message[
      Error::ConflictingTargetAnalyteConcentrationUnitsError,
      ObjectToString[PickList[listedSamples,conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]]], Cache -> combinedCache],
      PickList[conflictingTargetAnalyteConcentrationUnitsErrors[[All,2]],conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]]],
      PickList[conflictingTargetAnalyteConcentrationUnitsErrors[[All,3]],conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]]],
      ObjectToString[PickList[resolvedTargetAnalytes,conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]]],Cache->combinedCache],
      PickList[Range[Length[listedSamples]],conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]]]
    ];
    {TargetAnalyteConcentration},
    {}
  ];

  (* If we are gathering tests, create a test *)
  conflictingTargetAnalyteConcentrationUnitsTests = If[gatherTests,
    Module[
      {failingSamples,passingSamples,failingSampleTests,passingSampleTests},

      (*Get the inputs that fail this test*)
      failingSamples=PickList[listedSamples,conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]]];

      (*Get the inputs that pass this test*)
      passingSamples=PickList[listedSamples,conflictingTargetAnalyteConcentrationUnitsErrors[[All,1]],False];

      (*Create a test for the non-passing inputs*)
      failingSampleTests=If[Length[failingSamples]>0,
        Test["For the samples "<>ObjectToString[failingSamples]<>"the unit of TargetAnalyte in the composition of the sample could be converted to the unit in TargetAnalyteConcentration:",True,False],
        Nothing
      ];

      (*Create a test for the passing inputs*)
      passingSampleTests=If[Length[passingSamples]>0,
        Test["For the samples "<>ObjectToString[passingSamples]<>"the unit of TargetAnalyte in the composition of the sample could be converted to the unit in TargetAnalyteConcentration:",True,True],
        Nothing
      ];

      (*Return the created tests*)
      {failingSampleTests,passingSampleTests}
    ],
    {}
  ];

  (* THROW CONFLICTING OPTION ERRORS *)

  (* DilutionStrategy and DilutionType *)
  dilutionTypeStrategyMismatch = MapThread[
    Function[{sample,dilutionType,dilutionStrategy, index},
      If[
        Or[
          And[
            MatchQ[dilutionType,Linear],
            MatchQ[dilutionStrategy,Series|Endpoint]
          ],
          And[
            MatchQ[dilutionType,Serial],
            NullQ[dilutionStrategy]
          ]
        ],
        {sample, dilutionType, dilutionStrategy, index},
        Nothing
      ]
    ],
    {listedSamples,resolvedDilutionTypes,resolvedDilutionStrategies,Range[Length[listedSamples]]}
  ];

  If[Length[dilutionTypeStrategyMismatch] > 0 && messages,
    Message[
      Error::DilutionTypeAndStrategyMismatch,
      ObjectToString[dilutionTypeStrategyMismatch[[All,1]], Cache -> combinedCache],
      dilutionTypeStrategyMismatch[[All,2]],
      dilutionTypeStrategyMismatch[[All,3]],
      dilutionTypeStrategyMismatch[[All,4]]
    ]
  ];

  dilutionTypeStrategyMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = dilutionTypeStrategyMismatch[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have conflicting DilutionType and DilutionStrategy options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[listedSamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[listedSamples, affectedSamples], Cache -> combinedCache] <> " do not have conflicting DilutionType and DilutionStrategy options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    {}
  ];

  overspecifiedDilutionMismatch = MapThread[
    Function[{sample, diluent, concentratedBuffer, index},
      If[
        And[
          MatchQ[diluent,ObjectP[{Object[Sample],Model[Sample]}]],
          MatchQ[concentratedBuffer,ObjectP[{Object[Sample],Model[Sample]}]]
        ],
        {sample,diluent,concentratedBuffer,index},
        Nothing
      ]
    ],
    {listedSamples, resolvedDiluents,resolvedConcentratedBuffers, Range[Length[listedSamples]]}
  ];

  If[Length[overspecifiedDilutionMismatch] > 0,
    Message[
      Error::OverspecifiedDilution,
      ObjectToString[overspecifiedDilutionMismatch[[All,1]], Cache -> combinedCache],
      ObjectToString[overspecifiedDilutionMismatch[[All,2]], Cache -> combinedCache],
      ObjectToString[overspecifiedDilutionMismatch[[All,3]], Cache -> combinedCache],
      overspecifiedDilutionMismatch[[All,4]]
    ]
  ];

  overspecifiedDilutionMismatchTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = overspecifiedDilutionMismatch[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have both Diluent and ConcentratedBuffer specified:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[listedSamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[listedSamples, affectedSamples], Cache -> combinedCache] <> " do not have both Diluent and ConcentratedBuffer specified:", True, True]
      ];

      {failingTest, passingTest}
    ],
    {}
  ];

  conflictingConcentratedBufferOptionsResult = MapThread[
    Function[{sample, concentratedBuffer, concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDiluent,concentratedBufferDilutionFactor, index},
      If[
        Or[
          And[
            MatchQ[concentratedBuffer,ObjectP[{Object[Sample],Model[Sample]}]],
            Or[
              NullQ[concentratedBufferVolume],
              NullQ[concentratedBufferDiluentVolume],
              NullQ[concentratedBufferDiluent],
              NullQ[concentratedBufferDilutionFactor]
            ]
          ],
          And[
            NullQ[concentratedBuffer],
            Or[
              MatchQ[concentratedBufferVolume,VolumeP],
              MatchQ[concentratedBufferDiluentVolume,VolumeP],
              MatchQ[concentratedBufferDiluent,ObjectP[{Object[Sample],Model[Sample]}]],
              MatchQ[concentratedBufferDilutionFactor,NumericP]
            ]
          ]
        ],
        {sample, concentratedBuffer, concentratedBufferVolume,concentratedBufferDiluentVolume,concentratedBufferDiluent,concentratedBufferDilutionFactor, index},
        Nothing
      ]
    ],
    {listedSamples, resolvedConcentratedBuffers,resolvedConcentratedBufferVolumes,resolvedConcentratedBufferDiluentVolumes,resolvedConcentratedBufferDiluents,resolvedConcentratedBufferDilutionFactors, Range[Length[listedSamples]]}
  ];

  If[Length[conflictingConcentratedBufferOptionsResult] > 0,
    Message[
      Error::ConflictingConcentratedBufferParameters,
      ObjectToString[conflictingConcentratedBufferOptionsResult[[All,1]], Cache -> combinedCache],
      ObjectToString[conflictingConcentratedBufferOptionsResult[[All,2]], Cache -> combinedCache],
      conflictingConcentratedBufferOptionsResult[[All,3]],
      conflictingConcentratedBufferOptionsResult[[All,4]],
      ObjectToString[conflictingConcentratedBufferOptionsResult[[All,5]], Cache -> combinedCache],
      conflictingConcentratedBufferOptionsResult[[All,6]],
      conflictingConcentratedBufferOptionsResult[[All,7]]
    ]
  ];

  conflictingConcentratedBufferOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingConcentratedBufferOptionsResult[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have conflicting Concentrated Buffer options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[listedSamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[listedSamples, affectedSamples], Cache -> combinedCache] <> " do not have conflicting Concentrated Buffer options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    {}
  ];

  (* Error::ConflictingDiluentParameters *)
  conflictingDiluentOptionsResult = MapThread[
    Function[{sample, Diluent, DiluentVolume, index},
      If[
        Or[
          And[
            MatchQ[Diluent,ObjectP[{Object[Sample],Model[Sample]}]],
            NullQ[DiluentVolume]
          ],
          And[
            NullQ[Diluent],
            MatchQ[DiluentVolume,VolumeP]
          ]
        ],
        {sample, Diluent, DiluentVolume,index},
        Nothing
      ]
    ],
    {listedSamples, resolvedDiluents,resolvedDiluentVolumes,Range[Length[listedSamples]]}
  ];

  If[Length[conflictingDiluentOptionsResult] > 0,
    Message[
      Error::ConflictingDiluentParameters,
      ObjectToString[conflictingDiluentOptionsResult[[All,1]], Cache -> combinedCache],
      ObjectToString[conflictingDiluentOptionsResult[[All,2]], Cache -> combinedCache],
      conflictingDiluentOptionsResult[[All,3]],
      conflictingDiluentOptionsResult[[All,4]]
    ]
  ];

  conflictingDiluentOptionsTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = conflictingDiluentOptionsResult[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " do not have conflicting Diluent options:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[listedSamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[listedSamples, affectedSamples], Cache -> combinedCache] <> " do not have conflicting Diluent options:", True, True]
      ];

      {failingTest, passingTest}
    ],
    {}
  ];

  (* We need to check our resolved volumes - this is because we don't put any constraints on our Solve calls earlier, so volumes could resolve to values *)
  (* Outside of what we can handle in the lab *)
  invalidResolvedVolumes = MapThread[
    Function[{sample,transferVolume,diluentVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,index},
      If[
        Or[
          Or@@((Which[NullQ[#],False,RangeQ[#,{0.1 Microliter,$MaxTransferVolume}],False,True,True])&/@transferVolume),
          Or@@((Which[NullQ[#],False,RangeQ[#,{0.1 Microliter,$MaxTransferVolume}],False,True,True])&/@diluentVolume),
          Or@@((Which[NullQ[#],False,RangeQ[#,{0.1 Microliter,$MaxTransferVolume}],False,True,True])&/@concentratedBufferVolume),
          Or@@((Which[NullQ[#],False,RangeQ[#,{0.1 Microliter,$MaxTransferVolume}],False,True,True])&/@concentratedBufferDiluentVolume)
        ],
        {sample,transferVolume,diluentVolume,concentratedBufferVolume,concentratedBufferDiluentVolume,index},
        Nothing
      ]
    ],
    {
      listedSamples,
      resolvedTransferVolumes,
      resolvedDiluentVolumes,
      resolvedConcentratedBufferVolumes,
      resolvedConcentratedBufferDiluentVolumes,
      Range[Length[listedSamples]]
    }
  ];

  If[Length[invalidResolvedVolumes] > 0,
    Message[
      Error::VolumesTooLarge,
      ObjectToString[invalidResolvedVolumes[[All,1]], Cache -> combinedCache],
      invalidResolvedVolumes[[All,2]],
      invalidResolvedVolumes[[All,3]],
      invalidResolvedVolumes[[All,4]],
      invalidResolvedVolumes[[All,5]],
      invalidResolvedVolumes[[All,6]]
    ]
  ];

  invalidResolvedVolumeTests = If[gatherTests,
    Module[{affectedSamples, failingTest, passingTest},
      affectedSamples = invalidResolvedVolumes[[All,1]];

      failingTest = If[Length[affectedSamples] == 0,
        Nothing,
        Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> combinedCache] <> " have specified inputs that simplify to valid volume values in ECL:", True, False]
      ];

      passingTest = If[Length[affectedSamples] == Length[listedSamples],
        Nothing,
        Test["The sample(s) " <> ObjectToString[Complement[listedSamples, affectedSamples], Cache -> combinedCache] <> " have specified inputs that simplify to valid volume values in ECL:", True, True]
      ];

      {failingTest, passingTest}
    ],
    {}
  ];


  (* Gather Resolved options *)
  resolvedOptions = {
    DilutionType -> resolvedDilutionTypes,
    DilutionStrategy -> resolvedDilutionStrategies,
    NumberOfDilutions -> resolvedNumberOfDilutions,
    TargetAnalyte -> resolvedTargetAnalytes,
    CumulativeDilutionFactor -> resolvedCumulativeDilutionFactors,
    SerialDilutionFactor -> resolvedSerialDilutionFactors,
    TargetAnalyteConcentration -> resolvedTargetAnalyteConcentrations,
    TransferVolume -> resolvedTransferVolumes,
    TotalDilutionVolume -> resolvedTotalDilutionVolumes,
    FinalVolume -> resolvedFinalVolumes,
    DiscardFinalTransfer -> resolvedDiscardFinalTransfers,
    Diluent -> resolvedDiluents,
    DiluentVolume -> resolvedDiluentVolumes,
    ConcentratedBuffer -> resolvedConcentratedBuffers,
    ConcentratedBufferVolume -> resolvedConcentratedBufferVolumes,
    ConcentratedBufferDiluent -> resolvedConcentratedBufferDiluents,
    ConcentratedBufferDilutionFactor -> resolvedConcentratedBufferDilutionFactors,
    ConcentratedBufferDiluentVolume -> resolvedConcentratedBufferDiluentVolumes,
    Incubate -> resolvedIncubates,
    IncubationTime -> resolvedIncubationTimes,
    IncubationInstrument -> resolvedIncubationInstruments,
    IncubationTemperature -> resolvedIncubationTemperatures,
    MixType -> resolvedMixTypes,
    NumberOfMixes -> resolvedNumberOfMixes,
    MixRate -> resolvedMixRates,
    MixOscillationAngle -> resolvedMixOscillationAngles,
    Preparation -> resolvedPreparation
  };

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ResolveDilutionSharedOptions,
    resolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* Gather the invalid options *)
  invalidOptions = DeleteDuplicates[Flatten[{
    conflictingFactorsAndVolumesOptions,
    multipleTargetAnalyteConcentrationUnitsOptions,
    conflictingTargetAnalyteConcentrationUnitsOptions,
    If[Length[conflictingFactorsAndVolumesOptions]>0,
      {CumulativeDilutionFactor, SerialDilutionFactor, TargetAnalyteConcentration, TransferVolume, TotalDilutionVolume, FinalVolume,DiluentVolume, ConcentratedBufferVolume, ConcentratedBufferDiluentVolume,ConcentratedBufferDilutionFactor},
      {}
    ],
    If[Length[dilutionTypeStrategyMismatch]>0,
      {DilutionType, DilutionStrategy},
      {}
    ],
    If[Length[overspecifiedDilutionMismatch]>0,
      {Diluent, ConcentratedBuffer},
      {}
    ],
    If[Length[conflictingConcentratedBufferOptionsResult]>0,
      {ConcentratedBuffer,ConcentratedBufferVolume, ConcentratedBufferDiluentVolume,ConcentratedBufferDilutionFactor},
      {}
    ],
    If[Length[conflictingDiluentOptionsResult]>0,
      {Diluent,DiluentVolume},
      {}
    ],
    If[Length[invalidResolvedVolumes] > 0,
      {TransferVolume,DiluentVolume,ConcentratedBufferVolume,ConcentratedBufferDiluentVolume},
      {}
    ],
    invalidMixOptions
  }]];

  (* Gather the invalid inputs *)
  invalidInputs = DeleteDuplicates[Flatten[{

  }]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* Gather the tests *)
  allTests = Flatten[{
    optionPrecisionTests,
    validExpandedLengthTests,
    validLengthTests,
    safeOpsTests,
    invalidResolvedVolumeTests,
    conflictingDiluentOptionsTests,
    conflictingConcentratedBufferOptionsTests,
    overspecifiedDilutionMismatchTests,
    dilutionTypeStrategyMismatchTests,
    multipleTargetAnalyteConcentrationUnitsTests,
    conflictingFactorsAndVolumesTests,
    conflictingTargetAnalyteConcentrationUnitsTests,
    targetAnalyteTests,
    experimentMixTests
  }];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> collapsedResolvedOptions,
    Tests -> allTests
  }
];

(* ::Subsection:: *)
(* DilutionSharedOptions - MethodResolver *)
DefineOptions[resolveDilutionSharedOptionsMethod,
  SharedOptions:>{
    ResolveDilutionSharedOptions,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveDilutionSharedOptionsMethod[mySamples:{ObjectP[Object[Sample]]..},myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification,output,cache,simulation,currentSimulation,gatherTests,manualRequirementStrings,
    roboticRequirementStrings,result,tests
  },

  (* Set up user specified options and cache *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[myOptions, Cache, {}];
  simulation = Lookup[myOptions, Simulation, Null];
  currentSimulation = If[NullQ[simulation],
    Simulation[],
    simulation
  ];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Detect any options that mean we have to perform the dilution manuallu *)
  manualRequirementStrings = {
    If[MemberQ[ToList[Lookup[ToList[myOptions], MixType, {}]], Except[Automatic|Pipette|Shake]],
      "the MixType(s) "<>ToString[Cases[ToList[Lookup[ToList[myOptions], MixType, {}]], Except[Automatic|Pipette|Shake]]]<>" can only be performed manually",
      Nothing
    ],
    Module[{manualInstrumentTypes},
      manualInstrumentTypes=Cases[Join[MixInstrumentModels,MixInstrumentObjects], Except[Model[Instrument, HeatBlock]|Object[Instrument, HeatBlock]|Model[Instrument, Shaker]|Object[Instrument, Shaker]]];

      If[MemberQ[ToList[Lookup[ToList[myOptions], IncubationInstrument, {}]], ObjectP[manualInstrumentTypes]],
        "the Instrument(s) "<>ToString[Cases[ToList[Lookup[ToList[myOptions], IncubationInstrument, {}]], ObjectP[manualInstrumentTypes]]]<>" can only be used manually",
        Nothing
      ]
    ],
    Module[{manualOnlyOptions},
      manualOnlyOptions=Select[
        {
          MixOscillationAngle
        },
        (!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic]|{}]&)];

      If[Length[manualOnlyOptions]>0,
        "the following Manual-only options were specified "<>ToString[manualOnlyOptions],
        Nothing
      ]
    ],
    If[MatchQ[Lookup[myOptions, Preparation], Manual],
      "the Preparation option is set to Manual by the user",
      Nothing
    ]
  };

  (* Detect any options that mean we have to perform the dilution robotically *)
  roboticRequirementStrings = {
    If[MatchQ[Lookup[myOptions, Preparation], Robotic],
      "the Preparation option is set to Robotic by the user",
      Nothing
    ]
  };

  (* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
  If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
    (* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
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
    !MatchQ[Lookup[myOptions, Preparation], Automatic],
    Lookup[myOptions, Preparation],
    Length[manualRequirementStrings]>0,
    Manual,
    Length[roboticRequirementStrings]>0,
    Robotic,
    True,
    {Robotic,Manual}
  ];

  tests=If[MatchQ[gatherTests, False],
    {},
    {
      Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
    }
  ];

  outputSpecification/.{Result->result, Tests->tests}
];