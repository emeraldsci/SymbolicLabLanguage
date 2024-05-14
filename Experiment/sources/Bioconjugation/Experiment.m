(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentBioconjugation*)


(* ::Subsubsection::Closed:: *)
(*ExperimentBioconjugation Options and Messages*)
(*This experiment function takes in a nested list of samples.
Samples contained in a nested list will be pooled in the conjugation step to create the conjugated molecule.
Any of the samples can be activated or modified prior to conjugation by index-matched Activate options.
*)

DefineOptions[ExperimentBioconjugation,
  Options :> {

    (*********************************************** GENERAL OPTIONS *************************************************)

    IndexMatching[
      IndexMatchingInput->"experiment samples",
      {
        OptionName->ReactionChemistry,
        Default->Null,
        Description->"Indicates the reactive group that forms the covalent bond between conjugation samples. Null indicates a custom reaction chemistry.",
        AllowNull->True,
        Category->"General",
        Widget->Alternatives[
          Widget[Type->Enumeration,Pattern:> NHSester|Carbodiimide|Maleimide],
          Widget[Type -> Object, Pattern :> ObjectP[{Model[ReactionMechanism]}]] (*TODO make the resolver be able to take this as in input*)
        ]
      },
      {
        OptionName->ReactantsStoichiometricCoefficients,
        Default->Automatic,
        Description->"The number of reactant molecules that participate in the balanced conjugation reaction.",
        AllowNull->False,
        Category->"General",
        Widget->Widget[Type -> Number, Pattern :> RangeP[1, 1000]],
        NestedIndexMatching->True
      },
      {
        OptionName->ProductStoichiometricCoefficient,
        Default->Automatic,
        Description->"The number of conjugated molecules created by reaction of input molecules at the ratio indicated by ReactantsStoichiometricCoefficients.",
        AllowNull->False,
        Category->"General",
        Widget-> Widget[Type -> Number, Pattern :> RangeP[1, 1000]]
      },
      {
        OptionName->ExpectedYield,
        Default->100Percent,
        Description->"The percentage of input molecules that will be converted into conjugated product upon completion of the experiment.",
        AllowNull->False,
        Category->"General",
        Widget->Widget[Type->Quantity, Pattern:>RangeP[0Percent,100Percent], Units->Percent]
      }
    ],
    {
      OptionName -> ProcessingOrder,
      Default -> Parallel,
      Description -> "The order for processing the conjugation reactions, where Parallel indicates all samples are processed together from activation to quenching. Parallel processing is ideal for experiments with long reaction times where precision is not a concern and/or when instrumentation that can accommodate all reactions simultaneously is used. Batch indicates certain groups of samples are processed together such that all reactions from activation to quenching are completed for a given group before processing the next group of samples. Grouped processing is ideal for experiments where the instrumentation used cannot accommodate all samples simultaneously. Serial indicates samples are processed sequentially such at all reactions from activation to quenching are completed for a given sample before proceeding to the next sample. Sequential processing is ideal when reaction times are short and must be precise and/or the instruments used can only process one sample at a time.",
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Parallel, Batch, Serial]],
      Category -> "General"
    },
    {
      OptionName -> ProcessingBatchSize,
      Default -> Automatic,
      Description -> "The number of samples to be simultaneously processed when ProcessingOrder is Batch.",
      ResolutionDescription -> "Automatically set to 1 if ProcessingOrder is Batch otherwise set to Null. ",
      AllowNull -> True,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 1000, 1]],
      Category -> "General"
    },
    {
      OptionName -> ProcessingBatches,
      Default -> Automatic,
      Description -> "The groups of sample pools to process together in the experiment, applicable if ProcessingOrder->Batch.",
      ResolutionDescription -> "Automatically set based on ProcessingOrder and ProcessingBatchSize.",
      AllowNull -> True,
      Widget -> Adder[
         Adder[
          Adder[
            Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Object[Sample]}]]
          ]
        ]
      ],
      Category -> "General"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> ReactionVessel,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[Type -> Object, Pattern :> ObjectP[{Object[Container], Model[Container]}]],
          {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Container], Object[Container]}],
              ObjectTypes -> {Model[Container], Object[Container]}
            ]
          }
        ],
        Description -> "The containers in which samples are mixed with ConjugationReactionBuffer and incubated to covalently link the samples. Indices indicate specific grouping of samples if desired. Solid phase sample containers will be prioritized such that solid phase samples are not moved during conjugation reaction assembly.",
        ResolutionDescription->"Automatically set to the smallest tube that will fit all the reaction components.",
        Category -> "General"
      },
      (*TODO: add Atmosphere -> Nitrogen|Argon, option? when the glove box is up and running. For now just use sealed containers or septa.*)
      (*TODO add reaction monitoring options*)

      (*********************************************** PREWASH OPTIONS *************************************************)

      {
        OptionName -> PreWash,
        Default -> Automatic,
        Description -> "Indicates if the solid phase samples should be washed before the activation and/or conjugation reaction.",
        ResolutionDescription->"Automatically set to True if any PreWash options are specified, otherwise set to False.",
        AllowNull -> False,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashMethod,
        Default -> Automatic,
        Description -> "The method used to wash the solid phase samples prior to activation or conjugation.",
        ResolutionDescription -> "When PreWash is True, automatically set based on PreWash method options. If filtration related options are specified will resolve to Filter, if pellet related options are specified will resolve to Pellet, and if magnetic transfer options are specified will resolve to Magnetic. Otherwise defaults to Pellet.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> Magnetic | Pellet | Filter], (*TODO allow for magnetic sep when the Transfer primitive is updated to allow for magnetic sep options. currently running off of old ExperimentTransfer which does not accept magnetic transfer options. Must use primitives here otherwise washing via ExperimentTransfer will require multiple resource gathering/storage tasks that make multiple washes untenable. We also need filter to be updated to allwo for keeping the retentate.*)
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashNumberOfWashes,
        Default -> Automatic,
        Description -> "The number of times the sample is repeatedly mixed with wash buffer and wash buffer is removed.",
        ResolutionDescription -> "Automatically set to 3 if PreWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashTime,
        Default -> Automatic,
        Description -> "The length of the PreWash incubation.",
        ResolutionDescription -> "Automatically, set to 1 Minute when PreWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashTemperature,
        Default -> Automatic,
        Description -> "The temperature the sample is held at during the PreWash.",
        ResolutionDescription -> "Automatically, set to Ambient when PreWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashBuffer,
        Default -> Automatic,
        Description -> "The reagent used to wash the sample prior to activation or conjugation.",
        ResolutionDescription -> "Automatically set to 1x PBS if PreWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashBufferVolume,
        Default -> Automatic,
        Description -> "The volume of the PreWashBuffer used to wash the sample prior to activation or conjugation.",
        ResolutionDescription -> "Automatically set to half the sample container volume PreWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> {Microliter,{Microliter,Milliliter,Liter}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashMix,
        Default -> Automatic,
        Description -> "Indicates if the sample should be mixed after dispensing of the wash buffer.",
        ResolutionDescription -> "Automatically set to True if PreWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashMixType,
        Default -> Automatic,
        Description -> "The method used to mix the samples and wash buffer. Mixing methods Pipette and Invert with occur only at the start of the PreWashTime. All other methods will occur continuously for the duration of the PreWashTime.",
        ResolutionDescription -> "Automatically, set to Pipette if PreWashMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples by pipetting after dispensing of the wash buffer.",
        ResolutionDescription -> "Automatically set to half the PreWashBufferVolume if PreWashMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense  or inversion cycles used to mix the sample during washing.",
        ResolutionDescription -> "Automatically set to 5 if PreWashMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashMixRate,
        Default -> Automatic,
        Description -> "The intensity at which the sample and wash buffer are mixed during incubation.",
        ResolutionDescription -> "Automatically, set to based on the PreWashMixType.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFiltrationType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FiltrationTypeP],
        Description -> "The method that should be used to perform the prewash filtration.",
        ResolutionDescription -> "Automatically set to a filtration type appropriate for the volume of sample being filtered when PreWashMethod is Filter.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, FilterBlock],
          Object[Instrument, FilterBlock],
          Model[Instrument, PeristalticPump],
          Object[Instrument, PeristalticPump],
          Model[Instrument, VacuumPump],
          Object[Instrument, VacuumPump],
          Model[Instrument, Centrifuge],
          Object[Instrument, Centrifuge],
          Model[Instrument, SyringePump],
          Object[Instrument, SyringePump]
        }]],
        Description -> "The instrument that should be used to perform the PreWash.",
        ResolutionDescription -> "Will automatically resolve to an instrument appropriate for the PreWashMethod.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFilter,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Container, Plate, Filter], Object[Container, Plate, Filter],
          Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
          Model[Item, Filter], Object[Item, Filter]
        }]],
        Description -> "The filter that should be used to remove impurities from the sample.",
        ResolutionDescription -> "Automatically set to a filter appropriate for the filtration type and instrument if PreWashMethod is Filter.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFilterStorageCondition,
        Default -> Disposal,
        AllowNull -> False,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> SampleStorageTypeP | Disposal
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            PreparedSample -> False,
            PreparedContainer -> False
          ]
        ],
        Description -> "The conditions under which any filters used for PreWash should be stored after the wash is completed.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
        Description -> "The material from which the filtration membrane should be made of.",
        ResolutionDescription -> "Will automatically resolve to PES or to the MembraneMaterial of Filter if it is specified.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashPrefilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
        Description -> "The material from which the prefilter filtration membrane should be made of.",
        ResolutionDescription -> "Will automatically resolve to GxF if a prefilter pore size is specified.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
        Description -> "The pore size of the filter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to .22 Micron or to the PoreSize of Filter if it is specified. Will automatically resolve to Null if MolecularWeightCutoff is specified.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFilterMolecularWeightCutoff,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMolecularWeightCutoffP],
        Description -> "The molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to Null or to the MolecularWeightCutoff of Filter if it is specified.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashPrefilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
        Description -> "The pore size of the prefilter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to .45 Micron if a prefilter membrane material is specified",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFiltrationSyringe,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Container, Syringe],
          Object[Container, Syringe]
        }]],
        Description -> "The syringe used to force that sample through a filter.",
        ResolutionDescription -> "Resolves to an syringe appropriate to the volume of sample being filtered.",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashSterileFiltration,
        Default -> False,
        Description -> "Indicates if the filtration of the samples should be done in a sterile environment.",
        AllowNull -> False,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashFilterHousing,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, FilterHousing],
          Object[Instrument, FilterHousing],
          Model[Instrument, FilterBlock],
          Object[Instrument, FilterBlock]
        }]],
        Description -> "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane, or a filter plate for vacuum filtration..",
        ResolutionDescription -> "Resolves to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used, or a filter plate for vacuum filtration..",
        Category -> "PreWash",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashCentrifugationIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Speed" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
          "Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
        ],
        Category -> "PreWash",
        Description -> "The rotational speed or force at which the samples will be centrifuged during PreWash.",
        ResolutionDescription -> "Will automatically resolve to 2000 GravitationalAcceleration if filtering type is Centrifuge or PreWashMethod is Pellet.",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashCentrifugationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
        Category -> "PreWash",
        Description -> "The amount of time for which the samples will be centrifuged during PreWash.",
        ResolutionDescription -> "Will automatically resolve to 5 Minute if filtering type is Centrifuge or PreWashMethod is Pellet.",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashCentrifugationTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[-10 Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}],
        Category -> "PreWash",
        Description -> "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during PreWash.",
        ResolutionDescription -> "Will automatically resolve to 22 Celsius if filtering type is Centrifuge or PreWashMethod is Pellet.",
        NestedIndexMatching -> True
      },
      {
        OptionName->PreWashMagnetizationRack,
        Default->Automatic,
        ResolutionDescription -> "Automatically set to a magnetized rack that can hold the source/intermediate container, if PreWashMethod->Magnetic is specified.",
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Container, Rack],
            Object[Container, Rack]
          }]
        ],
        Description->"The magnetized rack that the source/intermediate container will be placed in during the PreWash.",
        Category->"PreWash",
        NestedIndexMatching->True
      },
      {
        OptionName -> PreWashResuspension,
        Default -> Automatic,
        Description -> "Indicates if samples should be resuspended in PreWashResuspensionBuffer after washing and before activation or conjugation reactions.",
        ResolutionDescription -> "Automatically set based on PreWash and prewash resuspension options. If PreWash is False, set to False.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionTime,
        Default -> Automatic,
        Description -> "The length of the PreWashResuspension incubation.",
        ResolutionDescription -> "Automatically, set to 1 Minute when PreWashResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionTemperature,
        Default -> Automatic,
        Description -> "The temperature the sample is held at during the PreWashResuspension.",
        ResolutionDescription -> "Automatically, set to Ambient when PreWashResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionDiluent,
        Default -> Automatic,
        Description -> "The reagent used to resuspend the sample after the PreWash complete.",
        ResolutionDescription -> "Automatically set to 1xPBS if PreWashResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionDiluentVolume,
        Default -> Automatic,
        Description -> "The volume of the PreWashResuspensionDiluent used to resuspend the sample after the PreWash is complete.",
        ResolutionDescription -> "Automatically set to the original sample volume PreWashResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionMix,
        Default -> Automatic,
        Description -> "Indicates if the sample should be mixed by pipetting after dispensing of the resuspension buffer.",
        ResolutionDescription -> "Automatically set to True if PreWashResuspenion is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionMixType,
        Default -> Automatic,
        Description -> "The method used to mix the resuspended samples in PreWashResuspensionDiluent.",
        ResolutionDescription -> "Automatically, set to Pipette if PreWashResuspensionMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples by pipetting after dispensing of the PreWashResuspensionDiluent.",
        ResolutionDescription -> "Automatically set to half the PreWashResuspensionDiluentVolume if PreWashResuspensionMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense cycles or inversions cycles used to mix the sample during resuspension.",
        ResolutionDescription -> "Automatically set to 5 if PreWashResuspensionMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PreWashResuspensionMixRate,
        Default -> Automatic,
        Description -> "The rate at which the sample and PreWashResuspensionDiluent are mixed during incubation.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on PreWashResuspensionMixType.",
        AllowNull -> True,
        Category -> "PreWash",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM],
        NestedIndexMatching -> True
      },

      (*********************************************** ACTIVATION OPTIONS *************************************************)

      {
        OptionName -> Activate,
        Default -> Automatic,
        Description -> "Indicates if functional groups on each of the conjugation samples need to be activated of modified prior to conjugation.",
        ResolutionDescription->"Automatically set to True if ReactionChemistry is Maleimide and the sample is a protein or if any Activation options are specified.",
        AllowNull -> False,
        Category -> "Activation",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationReactionVolume,
        Default -> Automatic,
        Description -> "The total volume of the activation reaction including ActivationSampleVolume, ActivationReagentVolume, and ActivationDiluentVolume.",
        ResolutionDescription -> "When Activate is True, automatically set to 0.5 mL. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 1000 Milliliter], Units -> {1, {Microliter, {Microliter, Milliliter}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> TargetActivationSampleConcentration,
        Default -> Automatic,
        Description -> "The desired concentration of each conjugation sample in the activation reaction.",
        ResolutionDescription -> "Automatically, set to 1 mg/mL when Activate is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milligram / Milliliter] | GreaterP[0 Micromolar],
        Units -> Alternatives[
          {1, {Micromolar, {Micromolar, Millimolar, Molar}}},
          CompoundUnit[
            {1, {Milligram, {Gram, Microgram, Milligram}}},
            {-1, {Milliliter, {Liter, Microliter, Milliliter}}}]
        ]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationSampleVolume,
        Default -> Automatic,
        Description -> "The volume of each conjugation sample that is used in the activation reaction.",
        ResolutionDescription -> "When Activate is True, automatically set to the sample volume that results in TargetActivationSampleConcentration when added to ActivationReactionVolume. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 1000 Milliliter], Units -> {1, {Microliter, {Microliter, Milliliter}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationReagent,
        Default -> Automatic,
        Description -> "The reagent that activates or modifies functional groups on the corresponding sample in preparation for conjugation. For Maleimide reactions, 100X molar excess of TCEP is recommended to reduce protein cysteine disulfide bonds.",
        ResolutionDescription->"Automatically set to 10mM TCEP in 50mM Tris-HCL pH 7.5 if ReactionChemsitry is Maleimide. TCEP unlike other reducing agents does not contain thiols that may interfere with conjugation, therefore it is not necessary to remove this reagent prior to the maleimide conjugation reaction.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> TargetActivationReagentConcentration,
        Default -> Automatic,
        Description -> "The desired concentration of ActivationReagent in the activation reaction.",
        ResolutionDescription -> "Automatically, set to 1 mg/mL when Activate is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milligram / Milliliter] | GreaterP[0 Micromolar],
        Units -> Alternatives[
          {1, {Micromolar, {Micromolar, Millimolar, Molar}}},
          CompoundUnit[
            {1, {Milligram, {Gram, Microgram, Milligram}}},
            {-1, {Milliliter, {Liter, Microliter, Milliliter}}}
          ]
        ]
          ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationReagentVolume,
        Default -> Automatic,
        Description -> "The volume of the ActivationReagent that is used in the activation reaction.",
        ResolutionDescription -> "When Activate is True, automatically set to the volume of ActivationReagent that results in TargetActivationReagentConcentration when added to ActivationVolume. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 1000 Milliliter], Units -> {1, {Microliter, {Microliter, Milliliter}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationDiluent,
        Default -> Automatic,
        Description -> "The reagent used to dilute the ActivationSampleVolume + ActivationReagentVolume to the final ActivationReactionVolume.",
        ResolutionDescription -> "Automatically set to 1X PBS.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationDiluentVolume,
        Default -> Automatic,
        Description -> "The volume of the ActivationDiluent that is used in the activation reaction.",
        ResolutionDescription -> "When Activate is True, automatically set to the difference in volume between (ActivationVolume + ActivationReagentVolume) and ActivationReactionVolume. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 1000 Milliliter], Units -> {1, {Microliter, {Microliter, Milliliter}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationContainer,
        NestedIndexMatching -> True,
        Default -> Null,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[Type -> Object, Pattern :> ObjectP[{Object[Container], Model[Container]}]],
          {
            "Index" -> Widget[
              Type -> Number,
              Pattern :> GreaterEqualP[1, 1]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Model[Container], Object[Container]}],
              ObjectTypes -> {Model[Container], Object[Container]}
            ]
          }
        ],
        Description -> "The containers in which each sample is activated by mixing and incubation with ActivationReagent and ActivationDiluent, with indices indicating specific grouping of samples if desired. If Null, the activation reaction will occur in the sample's current container.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationTime,
        Default -> Automatic,
        Description -> "The length of the activation reaction incubation. To mix the activation reagent and sample immediately prior to addition to the conjugation reaction set this value to zero.",
        ResolutionDescription -> "Automatically, set to 15 Minutes when Activate is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationTemperature,
        Default -> Automatic,
        Description -> "The temperature the sample is held at during the activation reaction.",
        ResolutionDescription -> "Automatically, set to Ambient when Activate is True and ActivationTime is greater than zero. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationMix,
        Default -> Automatic,
        Description -> "Indicates if the activation reaction should be mixed.",
        ResolutionDescription -> "Automatically, set to True when Activate is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationMixType,
        Default -> Automatic,
        Description -> "The method used to mix the activation reaction before or during incubation. Mixing methods Pipette and Invert with occur only at the start of the ActivationTime. All other methods will occur continuously for the duration of the ActivationTime.",
        ResolutionDescription -> "Automatically, set to Shake if Activate is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationMixRate,
        Default -> Automatic,
        Description -> "The rate at which the activation reaction is mixed during incubation.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on ActivationMixType.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the activation reaction.",
        ResolutionDescription -> "Automatically, set to half the activation reaction volume if ActivationMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 50000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense cycles or inversion cycles used to mix the activation reaction.",
        ResolutionDescription -> "Automatically, set to 5 if ActivationMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0,100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWash,
        Default -> Automatic,
        Description -> "Indicates if samples should be washed after the activation reaction and before the conjugation reaction.",
        ResolutionDescription -> "Automatically set to True if Activate is True and the sample is a solid phase support. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashMethod,
        Default -> Automatic,
        Description -> "The method used to wash the samples after activation.",
        ResolutionDescription -> "If PostActivationWash is True, automatically set based on method specific PostActivationWash options.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :>Magnetic |Pellet | Filter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationNumberOfWashes,
        Default -> Automatic,
        Description -> "The number of times the sample is repeatedly mixed with wash buffer and wash buffer is removed.",
        ResolutionDescription -> "Automatically set to 3 if PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashTime,
        Default -> Automatic,
        Description -> "The length of the post activation wash incubation.",
        ResolutionDescription -> "Automatically, set to 1 Minute when PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashTemperature,
        Default -> Automatic,
        Description -> "The temperature the sample is held at during the post-activation wash.",
        ResolutionDescription -> "Automatically, set to Ambient when PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashBuffer,
        Default -> Automatic,
        Description -> "The reagent used to wash the sample after the activation reaction is complete.",
        ResolutionDescription -> "Automatically set to 1X PBS if PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashBufferVolume,
        Default -> Automatic,
        Description -> "The volume of the PostActivationWashBuffer used to wash the sample after the activation reaction is complete.",
        ResolutionDescription -> "Automatically set to 200 Microliter PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashMix,
        Default -> Automatic,
        Description -> "Indicates if the sample should be mixed after dispensing of the wash buffer.",
        ResolutionDescription -> "Automatically set to True if PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashMixType,
        Default -> Automatic,
        Description -> "The method used to mix the samples and wash buffer. Mixing methods Pipette and Invert with occur only at the start of the PostActivationWashTime. All other methods will occur continuously for the duration of the PostActivationWashTime.",
        ResolutionDescription -> "Automatically, set to Pipette if PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples by pipetting after dispensing of the wash buffer.",
        ResolutionDescription -> "Automatically set to half the PostActivationWashBufferVolume if PostActivationWashMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense cycles or inversion cycles used to mix the sample during washing.",
        ResolutionDescription -> "Automatically set to 5 if PostActivationWashMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashMixRate,
        Default -> Automatic,
        Description -> "The rate at which the sample and wash buffer are mixed during incubation.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on PostActivationWashMixType.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFiltrationType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FiltrationTypeP],
        Description -> "The method that should be used to perform the PostActivationwash filtration.",
        ResolutionDescription -> "Automatically set to a filtration type appropriate for the volume of sample being filtered when PostActivationWashMethod is Filter.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, FilterBlock],
          Object[Instrument, FilterBlock],
          Model[Instrument, PeristalticPump],
          Object[Instrument, PeristalticPump],
          Model[Instrument, VacuumPump],
          Object[Instrument, VacuumPump],
          Model[Instrument, Centrifuge],
          Object[Instrument, Centrifuge],
          Model[Instrument, SyringePump],
          Object[Instrument, SyringePump]
        }]],
        Description -> "The instrument that should be used to perform the PostActivationWash.",
        ResolutionDescription -> "Will automatically resolve to an instrument appropriate for the PostActivationWashMethod.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFilter,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Container, Plate, Filter], Object[Container, Plate, Filter],
          Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
          Model[Item, Filter], Object[Item, Filter]
        }]],
        Description -> "The filter that should be used to remove impurities from the sample.",
        ResolutionDescription -> "Automatically set to a filter appropriate for the filtration type and instrument if PostActivationWashType is Filter.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFilterStorageCondition,
        Default -> Disposal,
        AllowNull -> False,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> SampleStorageTypeP | Disposal
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            PreparedSample -> False,
            PreparedContainer -> False
          ]
        ],
        Description -> "The conditions under which any filters used for PostActivationWash should be stored after the wash is completed.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
        Description -> "The material from which the filtration membrane should be made of.",
        ResolutionDescription -> "Will automatically resolve to PES or to the MembraneMaterial of Filter if it is specified.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashPrefilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
        Description -> "The material from which the Prefilter filtration membrane should be made of.",
        ResolutionDescription -> "Will automatically resolve to GxF if a Prefilter pore size is specified.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
        Description -> "The pore size of the filter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to .22 Micron or to the PoreSize of Filter if it is specified. Will automatically resolve to Null if MolecularWeightCutoff is specified.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFilterMolecularWeightCutoff,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMolecularWeightCutoffP],
        Description -> "The molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to Null or to the MolecularWeightCutoff of Filter if it is specified.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashPrefilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
        Description -> "The pore size of the Prefilter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to .45 Micron if a Prefilter membrane material is specified",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFiltrationSyringe,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Container, Syringe],
          Object[Container, Syringe]
        }]],
        Description -> "The syringe used to force that sample through a filter.",
        ResolutionDescription -> "Resolves to an syringe appropriate to the volume of sample being filtered.",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashSterileFiltration,
        Default -> False,
        Description -> "Indicates if the filtration of the samples should be done in a sterile environment.",
        AllowNull -> False,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashFilterHousing,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, FilterHousing],
          Object[Instrument, FilterHousing],
          Model[Instrument, FilterBlock],
          Object[Instrument, FilterBlock]
        }]],
        Description -> "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane, or a filter plate for vacuum filtration..",
        ResolutionDescription -> "Resolves to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used, or a filter plate for vacuum filtration..",
        Category -> "Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashCentrifugationIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Speed" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
          "Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
        ],
        Category -> "Activation",
        Description -> "The rotational speed or force at which the samples will be centrifuged during PostActivationWash.",
        ResolutionDescription -> "Will automatically resolve to 2000 GravitationalAcceleration if filtering type is Centrifuge or PostActivationWashMethod is Pellet.",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashCentrifugationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
        Category -> "Activation",
        Description -> "The amount of time for which the samples will be centrifuged during PostActivationWash.",
        ResolutionDescription -> "Will automatically resolve to 5 Minute if filtering type is Centrifuge or PostActivationWashMethod is Pellet.",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationWashCentrifugationTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[-10 Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}],
        Category -> "Activation",
        Description -> "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during PostActivationWash.",
        ResolutionDescription -> "Will automatically resolve to 22 Celsius if filtering type is Centrifuge or PostActivationWashMethod is Pellet.",
        NestedIndexMatching -> True
      },
      {
        OptionName->PostActivationWashMagnetizationRack,
        Default->Automatic,
        ResolutionDescription -> "Automatically set to a magnetized rack that can hold the source/intermediate container, if PostActivationWashMethod->Magnetic is specified.",
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Container, Rack],
            Object[Container, Rack]
          }]
        ],
        Description->"The magnetized rack that the source/intermediate container will be placed in during the PostActivationWash.",
        Category->"Activation",
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspension,
        Default -> Automatic,
        Description -> "Indicates if samples should be resuspended in PostActivationResuspensionDiluent after washing and before the conjugation reaction.",
        ResolutionDescription->"Automatically set based on other PostActivationResuspension.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionTime,
        Default -> Automatic,
        Description -> "The length of the PostActivationResuspension incubation.",
        ResolutionDescription -> "Automatically, set to 1 Minute when PostActivationResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionTemperature,
        Default -> Automatic,
        Description -> "The temperature the sample is held at during the PostActivationResuspension.",
        ResolutionDescription -> "Automatically, set to Ambient when PostActivationResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionDiluent,
        Default -> Automatic,
        Description -> "The reagent used to resuspend the sample after the PostActivationWash complete.",
        ResolutionDescription -> "Automatically set to 1X PBS if PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionDiluentVolume,
        Default -> Automatic,
        Description -> "The volume of the PostActivationResuspensionDiluent used to resuspend the sample after the PostActivationWash is complete.",
        ResolutionDescription -> "Automatically set to 200 Microliter PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionMix,
        Default -> Automatic,
        Description -> "Indicates if the sample should be mixed after dispensing of the resuspension buffer.",
        ResolutionDescription -> "Automatically set to True if PostActivationWash is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionMixType,
        Default -> Automatic,
        Description -> "The method used to resuspend the samples in PostActivationResuspensionDiluent.",
        ResolutionDescription -> "Automatically, set to Pipette if PostActivationResuspensionMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples by pipetting after dispensing of the PostActivationResuspensionDiluent.",
        ResolutionDescription -> "Automatically set to half the PostActivationResuspensionDiluentVolume if PostActivationResuspensionMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense cycles or inversion cycles used to mix the sample during resuspension.",
        ResolutionDescription -> "Automatically set to 5 if PostActivationResuspensionMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]],
        NestedIndexMatching -> True
      },
      {
        OptionName -> PostActivationResuspensionMixRate,
        Default -> Automatic,
        Description -> "The rate at which the sample and PostActivationResuspensionDiluent are mixed during incubation.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on PostActivationResuspensionMixType.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ActivationSamplesOutStorageCondition,
        Default -> Automatic,
        Description -> "The conditions under which any leftover samples from the activation reaction are stored after the samples are transferred to the ConjugationContainer.",
        ResolutionDescription -> "Automatically set to Disposal.",
        AllowNull -> True,
        Category -> "Activation",
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
        ],
        NestedIndexMatching -> True
      },

      (*********************************************** CONJUGATION OPTIONS *************************************************)

      {
        OptionName -> ConjugationReactionVolume,
        Default -> Automatic,
        Description -> "The total volume of the conjugation reaction including ConjugationAmount and ConjugationReactionBufferVolume.",
        ResolutionDescription -> "Automatically, set to the full volume of the conjugate samples or 500 uL if all samples are solid.",
        AllowNull -> False,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> TargetConjugationSampleConcentration,
        Default -> Automatic,
        AllowNull->True,
        Description -> "The desired concentration of each sample in the total ConjugationReactionVolume.",
        ResolutionDescription -> "Automatically set to the concentration given by ConjugationAmount/ConjugationReactionVolume.",
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milligram / Milliliter] | GreaterP[0 Micromolar],
          Units -> Alternatives[
            {1, {Micromolar, {Micromolar, Millimolar, Molar}}},
            CompoundUnit[
              {1, {Milligram, {Gram, Microgram, Milligram}}},
              {-1, {Milliliter, {Liter, Microliter, Milliliter}}}]
          ]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ConjugationAmount,
        Default -> All,
        Description -> "The volume or mass of each sample that is used in the conjugation reaction. By default the entire volume or mass of the sample is used. If ConjugationAmount is All and the sample is solid, the aqueous samples and reagents for the conjugation reaction will be transferred into the solid sample container.",
        AllowNull -> False,
        Category -> "Conjugation",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 50 Milliliter], Units ->  {Microliter, {Microliter, Milliliter}}],
          Widget[Type -> Quantity, Pattern :> RangeP[0 Microgram, 50 Gram], Units -> {Microgram, {Microgram, Milligram, Gram}}],
          Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
        ],
        NestedIndexMatching -> True
      },
      {
        OptionName -> ConjugationReactionBuffer,
        Default -> Null,
        Description -> "Indicates the reagent used to dilute or resuspend the conjugate sample during the conjugation reaction.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]
      },
      {
        OptionName -> ConjugationReactionBufferVolume,
        Default -> Automatic,
        Description -> "The volume of the ConjugationReactionBuffer that is mixed with the corresponding conjugation samples to assemble the conjugation reaction.",
        ResolutionDescription -> "Automatically, set to the conjugation reaction volume such that the sample is diluted 2-fold.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> ConcentratedConjugationReactionBuffer,
        Default -> Null,
        Description -> "Indicates the concentrated reagent used to dilute or resuspend the conjugate sample during the conjugation reaction.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]
      },
      {
        OptionName -> ConcentratedConjugationReactionBufferDilutionFactor,
        Default -> Automatic,
        Description -> "The relative amount that the ConcentratedConjugateBuffer should be diluted prior to use in the conjugation reaction.",
        ResolutionDescription -> "Automatically, set to 1 when ConcentratedConjugationBuffer is specified.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 5000]]
      },
      {
        OptionName -> ConjugationReactionBufferDiluent,
        Default -> Automatic,
        Description -> "The diluent used to decrease the ConcentratedConjugationBuffer concentration by ConjugationBufferDilutionFactor prior to use in the conjugation reaction.",
        ResolutionDescription -> "If ConcentratedConjugationReactionBuffer is specified, automatically resolves to 1x PBS.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]
      },
      {
        OptionName -> ConjugationDiluentVolume,
        Default -> Automatic,
        Description -> "The volume of the ConjugationBufferDiluent that is mixed with ConcentratedConjugateBuffer prior to use in the conjugation reaction.",
        ResolutionDescription->"Automatically set to the ConjugationBufferVolume*(1 - ConjugationReactionBufferVolume/ConcentratedConjugationReactionBufferDilutionFactor).",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> ConjugationTime,
        Default -> Automatic,
        Description -> "The incubation time of the conjugation reaction.",
        ResolutionDescription->"Automatically set based on the reaction chemistry to a literature-based recommended value.",
        AllowNull -> False,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Minute, 4000Minute], Units -> {1, {Minute, {Minute, Hour}}}]
      },
      {
        OptionName -> ConjugationTemperature,
        Default -> Automatic,
        Description -> "The incubation temperature of the conjugation reaction.",
        ResolutionDescription->"Automatically set based on the reaction chemistry to a literature-based recommended value.",
        AllowNull -> False,
        Category -> "Conjugation",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ]
      },
      {
        OptionName -> ConjugationMix,
        Default -> True,
        Description -> "Indicates if the conjugation reaction should be mixed.",
        AllowNull -> False,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> ConjugationMixType,
        Default -> Automatic,
        Description -> "The method used to mix the samples for conjugation. Mixing methods Pipette and Invert with occur only at the start of the ConjugationTime. All other methods will occur continuously for the duration of the ConjugationTime.",
        ResolutionDescription -> "Automatically, set to based on mix options when ConjugationMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP]
      },
      {
        OptionName -> ConjugationMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples by pipetting at the start of the conjugation reaction.",
        ResolutionDescription -> "Automatically set to half the ConjugationReactionVolume if ConjugationMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> ConjugationNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense or inversion cycles used to mix the sample at the start of the conjugation reaction.",
        ResolutionDescription -> "Automatically set to 5 if ConjugationMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]]
      },
      {
        OptionName -> ConjugationMixRate,
        Default -> Automatic,
        Description -> "The rate at which the samples are mixed during ConjugationTime.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on ConjugationMixType.",
        AllowNull -> True,
        Category -> "Conjugation",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM]
      },


      (*********************************************** QUENCHING OPTIONS *************************************************)

      {
        OptionName -> QuenchConjugation,
        Default -> Automatic,
        Description -> "Indicates if the conjugation reaction should be quenched after the desired incubation time.",
        ResolutionDescription->"Automatically, set based on the ReactionChemistry.",
        AllowNull -> False,
        Category -> "Quenching",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PredrainReactionMixture,
        Default -> False,
        Description -> "Indicates if the aqueous reaction reagents should be removed from any solid phase samples or precipitates after the conjugation reaction is complete to prepare the sample for quenching or subsequent workup.",
        AllowNull -> False,
        Category -> "Quenching",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PredrainMethod,
        Default -> Automatic,
        Description -> "The method used to separate the aqueous and solid reaction components when PredrainReactionMixture is True.",
        ResolutionDescription -> "Automatically set to Pellet if PredrainReactionMixture is True. Otherwise set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Enumeration, Pattern :> Pellet|Magnetic ]
      },
      {
        OptionName -> PredrainInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, Centrifuge],
          Object[Instrument, Centrifuge]
        }]],
        Description -> "The instrument that should be used to perform the PredrainReactionReagents.",
        ResolutionDescription -> "Will automatically resolve to an instrument appropriate for the PredrainMethod.",
        Category -> "Quenching"
      },
      {
        OptionName -> PredrainCentrifugationIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Speed" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
          "Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
        ],
        Category -> "Quenching",
        Description -> "The rotational speed or force at which the samples will be centrifuged during PredrainReactionReagents.",
        ResolutionDescription -> "Will automatically resolve to 2000 GravitationalAcceleration if PredrainMethod is Pellet."
      },
      {
        OptionName -> PredrainCentrifugationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
        Category -> "Quenching",
        Description -> "The amount of time for which the samples will be centrifuged during PredrainReactionReagents.",
        ResolutionDescription -> "Will automatically resolve to 5 Minute if PredrainMethod is Pellet."
      },
      {
        OptionName -> PredrainTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> GreaterEqualP[-10 Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Category -> "Quenching",
        Description -> "The temperature at which the samples will be held during centrifugation or magnetic separation when PredrainReactionReagents is True.",
        ResolutionDescription -> "Will automatically resolve to Ambient if PredrainReactionReagents is True."
      },
      {
        OptionName->PredrainMagnetizationRack,
        Default->Automatic,
        ResolutionDescription -> "Automatically set to a magnetized rack that can hold the source/intermediate container, if PredrainMethod->Magnetic is specified.",
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Container, Rack],
            Object[Container, Rack]
          }]
        ],
        Description->"The magnetized rack that the source/intermediate container will be placed in during the PredrainReactionMixture.",
        Category->"Quenching"
      },
      {
        OptionName->PredrainMagnetizationTime,
        Default->Automatic,
        ResolutionDescription -> "Automatically set to 15 Second if PredrainMethod->Magnetic. Otherwise, set to Null.",
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern :> RangeP[0 Minute,$MaxExperimentTime],
          Units -> {Minute,{Minute,Second}}
        ],
        Description->"The time that the source sample should be left on the magnetic rack until the magnetic components are settled at the side of the container.",
        Category->"Quenching"
      },
      {
        OptionName -> QuenchReactionVolume,
        Default -> Automatic,
        Description -> "The total volume of the quenching reaction including the ConjugationReactionVolume + QuenchReagentVolume.",
        ResolutionDescription -> "Automatically, based on the QuenchReagentDilutionFactor. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 1000 Milliliter], Units -> {1, {Microliter, {Microliter, Milliliter}}}]
      },
      {
        OptionName -> QuenchReagent,
        Default -> Automatic,
        Description -> "The reagent that should be used to stop the conjugation reaction and render any unbound functional groups inactive.",
        ResolutionDescription -> "Automatically set based on the ReactionChemistry.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]
      },
      {
        OptionName -> QuenchReagentDilutionFactor,
        Default -> Automatic,
        Description -> "The relative amount that the QuenchReagent should be diluted in QuenchReaction to reach its final active concentration.",
        ResolutionDescription -> "Automatically, set to 1 when QuenchReagent is specified.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 5000]]
      },
      {
        OptionName -> QuenchReagentVolume,
        Default -> Automatic,
        Description -> "The volume of the QuenchReagent that is used in the quenching reaction.",
        ResolutionDescription -> "Automatically, set to 1 uL QuenchReagent when QuenchConjugation is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Microliter, 1000 Milliliter], Units -> {1, {Microliter, {Microliter, Milliliter}}}]
      },
      {
        OptionName -> QuenchTime,
        Default -> Automatic,
        Description -> "The length of the quenching reaction incubation.",
        ResolutionDescription -> "Automatically, set to 5 Minutes when QuenchConjugation is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}]
      },
      {
        OptionName -> QuenchTemperature,
        Default -> Automatic,
        Description -> "The temperature of the sample is held at during the quenching reaction.",
        ResolutionDescription -> "Automatically, set to Ambient QuenchConjugation is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ]
      },
      {
        OptionName -> QuenchMix,
        Default -> Automatic,
        Description -> "Indicates if the quenching reaction should be mixed during incubation.",
        ResolutionDescription -> "Automatically, set to True QuenchConjugation is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> QuenchMixType,
        Default -> Automatic,
        Description -> "The method used to mix the samples with QuenchReagent. Mixing methods Pipette and Invert with occur only at the start of the QuenchTime. All other methods will occur continuously for the duration of the QuenchTime.",
        ResolutionDescription -> "Automatically, set to Shake if QuenchMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP]
      },
      {
        OptionName -> QuenchMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the sample and QuenchReagent by pipetting at the start of the quench reaction.",
        ResolutionDescription -> "Automatically set to half the QuenchReactionVolume if QuenchMixType is Pipette. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> QuenchNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense or inversion cycles used to mix the sample at the start of the quench reaction.",
        ResolutionDescription -> "Automatically set to 5 if QuenchMixType is Pipette or Invert. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]]
      },
      {
        OptionName -> QuenchMixRate,
        Default -> Automatic,
        Description -> "The rate at which the samples are mixed during QuenchTime.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on QuenchMixType.",
        AllowNull -> True,
        Category -> "Quenching",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM]
      },

      (*********************************************** POST-CONJUGATION OPTIONS *************************************************)

      {
        OptionName -> PostConjugationWorkup,
        Default -> False,
        Description -> "Indicates if samples should be processed after the conjugation reaction.",
        AllowNull -> False,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PostConjugationWorkupMethod,
        Default -> Automatic,
        Description -> "The method used to process the samples after conjugation.",
        ResolutionDescription->"Automatically set to Pellet if PostConjugationWorkup is True.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :>Magnetic | Pellet | Filter]
      },
      {
        OptionName -> PostConjugationWorkupBuffer,
        Default -> Null,
        Description -> "Indicates the reagent used to process the sample after the conjugation and quenching reactions are complete.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]
      },
      {
        OptionName -> PostConjugationWorkupBufferVolume,
        Default -> Null,
        Description -> "The volume of the PostConjugationWashBuffer used to wash the sample after the conjugation reaction is complete.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> PostConjugationWorkupIncubationTime,
        Default -> Null,
        Description -> "The incubation time of the sample with the PostConjugationWorkupBuffer.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, 4000 Minute], Units -> {1, {Minute, {Minute, Hour}}}]
      },
      {
        OptionName -> PostConjugationWorkupIncubationTemperature,
        Default -> Null,
        Description -> "The temperature the sample is held at during the PostConjugationWorkupIncubationTime.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Alternatives[
          Widget[Type -> Quantity, Pattern :> RangeP[0 Celsius, 100 Celsius], Units -> Celsius],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ]
      },
      {
        OptionName -> PostConjugationWorkupMix,
        Default -> Automatic,
        Description -> "Indicates if the sample should be mixed the PostConjugationWorkupBuffer.",
        ResolutionDescription -> "Automatically set to True if PostConjugationWorkupBuffer is specified. Otherwise, set to False.",
        AllowNull -> False,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PostConjugationWorkupMixType,
        Default -> Automatic,
        Description -> "The method used to mix the samples and PostConjugationWorkupBuffer.",
        ResolutionDescription -> "Automatically, set to Pipette if PostConjugationWorkup is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP]
      },
      {
        OptionName -> PostConjugationWorkupMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples after dispensing of the PostConjugationWorkupBuffer.",
        ResolutionDescription -> "Automatically set to half the sample volume if PostConjugationWorkupMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> PostConjugationWorkupNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense cycles or inversion cycles used to mix the sample prior to PostConjugationWorkupIncubationTime.",
        ResolutionDescription -> "Automatically set to 5 if PostConjugationWorkupMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]]
      },
      {
        OptionName -> PostConjugationWorkupMixRate,
        Default -> Automatic,
        Description -> "The rate at which the sample and PostConjugationWorkupBuffer are mixed during incubation.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on PostConjugationWorkupMixType.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM]
      },
      {
        OptionName -> PostConjugationFiltrationType,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FiltrationTypeP],
        Description -> "The method that should be used to perform the filtration.",
        ResolutionDescription -> "Will automatically resolve to a filtration type appropriate for the volume of sample being filtered.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationWorkupInstrument,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, FilterBlock],
          Object[Instrument, FilterBlock],
          Model[Instrument, PeristalticPump],
          Object[Instrument, PeristalticPump],
          Model[Instrument, VacuumPump],
          Object[Instrument, VacuumPump],
          Model[Instrument, Centrifuge],
          Object[Instrument, Centrifuge],
          Model[Instrument, SyringePump],
          Object[Instrument, SyringePump]
        }]],
        Description -> "The instrument that should be used to perform the PostConjugationWorkup.",
        ResolutionDescription -> "Will automatically resolve to an instrument appropriate for the PostConjugationWorkupMethod.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationFilter,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Container, Plate, Filter], Object[Container, Plate, Filter],
          Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
          Model[Item, Filter], Object[Item, Filter]
        }]],
        Description -> "The filter that should be used to remove impurities from the sample.",
        ResolutionDescription -> "Will automatically resolve to a filter appropriate for the filtration type and instrument.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationFilterStorageCondition,
        Default -> Disposal,
        AllowNull -> False,
        Widget -> Alternatives[
          "Storage Type" -> Widget[
            Type -> Enumeration,
            Pattern :> SampleStorageTypeP | Disposal
          ],
          "Storage Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[StorageCondition]],
            PreparedSample -> False,
            PreparedContainer -> False
          ]
        ],
        Description -> "The conditions under which any filters used by this experiment should be stored after the protocol is completed.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationFilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
        Description -> "The material from which the filtration membrane should be made of.",
        ResolutionDescription -> "Will automatically resolve to PES or to the MembraneMaterial of Filter if it is specified.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationPrefilterMembraneMaterial,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMembraneMaterialP],
        Description -> "The material from which the prefilter filtration membrane should be made of.",
        ResolutionDescription -> "Will automatically resolve to GxF if a prefilter pore size is specified.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationFilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
        Description -> "The pore size of the filter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to .22 Micron or to the PoreSize of Filter if it is specified. Will automatically resolve to Null if MolecularWeightCutoff is specified.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationFilterMolecularWeightCutoff,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterMolecularWeightCutoffP],
        Description -> "The molecular weight cutoff of the filter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to Null or to the MolecularWeightCutoff of Filter if it is specified.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationPrefilterPoreSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> FilterSizeP],
        Description -> "The pore size of the prefilter; all particles larger than this should be removed during the filtration.",
        ResolutionDescription -> "Will automatically resolve to .45 Micron if a prefilter membrane material is specified",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationFiltrationSyringe,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Container, Syringe],
          Object[Container, Syringe]
        }]],
        Description -> "The syringe used to force that sample through a filter.",
        ResolutionDescription -> "Resolves to an syringe appropriate to the volume of sample being filtered.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationSterileFiltration,
        Default -> False,
        Description -> "Indicates if the filtration of the samples should be done in a sterile environment.",
        AllowNull -> False,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PostConjugationFilterHousing,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{
          Model[Instrument, FilterHousing],
          Object[Instrument, FilterHousing],
          Model[Instrument, FilterBlock],
          Object[Instrument, FilterBlock]
        }]],
        Description -> "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane, or a filter plate for vacuum filtration.",
        ResolutionDescription -> "Resolves to an housing capable of holding the size of the membrane being used, if filter with Membrane FilterType is being used, or a filter plate for vacuum filtration.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationCentrifugationIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Speed" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 RPM], Units -> {RPM, {RPM}}],
          "Force" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 GravitationalAcceleration], Units -> {GravitationalAcceleration, {GravitationalAcceleration}}]
        ],
        Category -> "Post-Conjugation Workup",
        Description -> "The rotational speed or force at which the samples will be centrifuged during PostConjugationWorkup.",
        ResolutionDescription -> "Will automatically resolve to 2000 GravitationalAcceleration if filtering type is Centrifuge or PostConjugationWorkupMethod is Pellet."
      },
      {
        OptionName -> PostConjugationCentrifugationTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Minute], Units -> {Second, {Second, Minute, Hour}}],
        Category -> "Post-Conjugation Workup",
        Description -> "The amount of time for which the samples will be centrifuged during PostConjugationWorkup.",
        ResolutionDescription -> "Will automatically resolve to 5 Minute if filtering type is Centrifuge or PostConjugationWorkupMethod is Pellet."
      },
      {
        OptionName -> PostConjugationCentrifugationTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[-10 Celsius], Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}],
        Category -> "Post-Conjugation Workup",
        Description -> "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during PostConjugationWorkup.",
        ResolutionDescription -> "Will automatically resolve to 22 Celsius if filtering type is Centrifuge or PostConjugationWorkupMethod is Pellet."
      },
      (*TODO update this option once ExperimentFilter/Filter and ExperimentPellet/Pellet have been updated to accomodate this. Scheduled to happen as part of Cell-ebration*)(*
      {
        OptionName->Target,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type->Enumeration,Pattern:> Pellet | Supernantant | Filtrate | Retentate | {Pellet, Supernantant} | {Filtrate , Retentate} | {Supernantant, Pellet} | {Retentate, Filtrate} ],
        Category->"Post-Conjugation Workup",
        Description->"The sample that is retained as SamplesOut when PostConjugationWorkup is used to separate the conjugation reaction via magnetic separation, pelleting, or filtering.",
        ResolutionDescription->"Automatically set based on the PostConjugationWorkupMethod."
      },*)
      {
        OptionName->PostConjugationMagnetizationRack,
        Default->Automatic,
        ResolutionDescription -> "Automatically set to a magnetized rack that can hold the source/intermediate container, if PostConjugationWorkupMethod->Magnetic is specified.",
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            Model[Container, Rack],
            Object[Container, Rack]
          }]
        ],
        Description->"The magnetized rack that the source/intermediate container will be placed in during the PostConjugationWorkup.",
        Category->"Post-Conjugation Workup"
      },
     {
        OptionName -> PostConjugationResuspension,
        Default -> Automatic,
        Description -> "Indicates whether the sample should be resuspended in PostConjugationResuspensionDiluent after PostConjugationWorkup is complete.",
        ResolutionDescription -> "Automatically set to True if any resuspension options are specified. Otherwise set to False.",
        AllowNull -> False,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PostConjugationResuspensionDiluent,
        Default -> Automatic,
        Description -> "The reagent used to resuspend the sample after the PostConjugationWorkup is complete.",
        ResolutionDescription -> "Automatically set to 1X PBS if PostConjugationResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Sample], Model[Sample]}]]
      },
      {
        OptionName -> PostConjugationResuspensionDiluentVolume,
        Default -> Automatic,
        Description -> "The volume of the PostConjugationResuspensionDiluent used to resuspend the sample after the PostConjugationWash is complete.",
        ResolutionDescription -> "Automatically set to 200 Microliter PostConjugationResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> PostConjugationResuspensionMix,
        Default -> Automatic,
        Description -> "Indicates if the sample should be mixed after dispensing of the resuspension buffer.",
        ResolutionDescription -> "Automatically set to True if PostConjugationResuspension is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      },
      {
        OptionName -> PostConjugationResuspensionMixType,
        Default -> Automatic,
        Description -> "The method used to mix the samples with PostConjugationResuspensionDiluent.",
        ResolutionDescription -> "Automatically, set to Pipette if PostConjugationResuspensionMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Enumeration, Pattern :> MixTypeP]
      },
      {
        OptionName -> PostConjugationResuspensionMixRate,
        Default -> Automatic,
        Description -> "The rate at which the sample and PostConjugationResuspensionDiluent are mixed during incubation.",
        ResolutionDescription -> "Automatically, set to 800 RPM based on PostConjugationResuspensionMixType.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0RPM, 10000RPM], Units -> RPM]
      },
      {
        OptionName -> PostConjugationResuspensionMixVolume,
        Default -> Automatic,
        Description -> "The volume used to mix the samples by pipetting after dispensing of the resuspension buffer.",
        ResolutionDescription -> "Automatically set to half the PostConjugationResuspensionDiluentVolume if PostConjugationResuspensionMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1Microliter, 1000000Microliter], Units -> Microliter]
      },
      {
        OptionName -> PostConjugationResuspensionNumberOfMixes,
        Default -> Automatic,
        Description -> "The number of aspirate and dispense cycles used to mix the sample during resuspension.",
        ResolutionDescription -> "Automatically set to 5 if PostConjugationResuspensionMix is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]]
      },
      {
        OptionName -> PostConjugationResuspensionMixUntilDissolved,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates if the sample should be mixed in an attempt to completed dissolve any solid components following addition of liquid.",
        ResolutionDescription -> "Automatically set to True if MaxMixTime or MaxNumberOfMixes are specified, or False otherwise.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationResuspensionMaxNumberOfMixes,
        Default -> Automatic,
        Description -> "The maximum number of aspirate and dispense cycles used to mix the sample during resuspension.",
        ResolutionDescription -> "Automatically set to 50 if PostConjugationResuspensionMixUntilDissolved is True. Otherwise, set to Null.",
        AllowNull -> True,
        Category -> "Post-Conjugation Workup",
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 100,1]]
      },
      {
        OptionName -> PostConjugationResuspensionTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[0 Hour, 72 Hour],
          Units -> {1, {Minute, {Second, Minute, Hour}}}
        ],
        Description -> "The duration for which the sample should be mixed/incubated following addition of liquid.",
        ResolutionDescription -> "Automatically set to 30 minutes unless MixType is set to Pipette or Invert, in which case it is set to Null.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationResuspensionMaxTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[1 Second, 72 Hour],
          Units -> {1, {Minute, {Second, Minute, Hour}}}
        ],
        Description -> "The maximum duration for which the samples should be mixed/incubated in an attempt to dissolve any solid components following addition of liquid.",
        ResolutionDescription -> "Automatically set based on the MixType if PostConjugationResuspensionMixUntilDissolved is set to True. If PostConjugationResuspensionMixUntilDissolved is False, resolves to Null.",
        Category -> "Post-Conjugation Workup"
      },
      {
        OptionName -> PostConjugationResuspensionTemperature,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          Widget[
            Type -> Quantity,
            Pattern :> RangeP[22 Celsius, $MaxIncubationTemperature],
            Units -> {1, {Celsius, {Celsius, Fahrenheit}}}
          ],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
        ],
        Description -> "Temperature at which the sample should be incubated during PostConjugationResuspension.",
        Category -> "Post-Conjugation Workup"
      }
    ],
    (*===Shared Options===*)
    SimulationOption,
    FuntopiaSharedOptionsNestedIndexMatching,
    SubprotocolDescriptionOption,
    SamplesOutStorageOptions,
    MeasureWeightOption,
    MeasureVolumeOption
  }
];

(*--- MESSAGES ---*)
Error::DuplicatedBioconjugationSample = "The conjugation group `1` contains duplicated samples. Samples cannot be duplicated in the conjugation reaction. Please only supply one instance of each sample in the conjugation group.";
Error::InvalidBatchProcessingOptions = "When ProcessingOrder is `1`, `2` cannot be `3`. Please update ProcessingOrder or `2` such that the options are compatible.";
Error::ConflictingPreWashOptions = "The following samples have conflicting PreWash options: `1`. Please update PreWash, PreWashMethod, PreWashNumberOfWashes, PreWashInstrument, PreWashTemperature,PreWashBuffer, or PreWashBufferVolume to be compatible. When PreWash->True, the remaining PreWash options must be Automatic or specified. When PreWash->False, the remaining PreWash options must be Automatic or Null.";
Error::ConflictingPreWashMixOptions = "The following samples have conflicting PreWashMix options: `1`. Please update PreWashMix, PreWashMixType,PreWashMixVolume,PreWashNumberOfMixes, or PreWashMixRate to be compatible.";
Error::ConflictingPreWashResuspensionOptions = "The following samples have conflicting PreWashResuspension options: `1`. Please update PreWashResuspension, PreWashResuspensionTime, PreWashResuspensionTemperature, PreWashResuspensionDiluent, or PreWashResuspensionDiluentVolume to be compatible.";
Error::ConflictingPreWashResuspensionMixOptions="The following samples have conflicting PreWashResuspensionMix options: `1`. Please update PreWashResuspensionMix, PreWashResuspensionMixType, PreWashResuspensionMixVolume, PreWashResuspensionNumberOfMixes, or PreWashResuspensionMixRate to be compatible.";
Error::ConflictingActivationOptions="The following samples have conflicting Activation options: `1`. Please update the Activation options to be compatible.";
Error::ConflictingActivationMixOptions="The following samples have conflicting ActivationMix options: `1`. Please update ActivationMix, ActivationMixType, ActivationMixVolume, ActivationNumberOfMixes, or ActivationMixRate to be compatible.";
Error::ConflictingPostActivationWashOptions= "The following samples have conflicting PostActivationWash options: `1`. Please update the PostActivationWash options to be compatible.";
Error::ConflictingPostActivationWashMixOptions= "The following samples have conflicting PostActivationWashMix options: `1`. Please update PostActivationWashMix, PostActivationWashMixType, PostActivationWashMixVolume, PostActivationWashNumberOfMixes, or PostActivationWashMixRate to be compatible.";
Error::ConflictingPostActivationResuspensionOptions="The following samples have conflicting PostActivationWashResuspension options: `1`. Please update PostActivationWashResuspension, PostActivationWashResuspensionTime, PostActivationResuspensionTemperature, PostActivationWashResuspensionDiluent, or PostActivationWashResuspensionDiluentVolume to be compatible.";
Error::ConflictingPostActivationResuspensionMixOptions="The following samples have conflicting PostActivationResuspensionMix options: `1`. Please update PostActivationResuspensionMix, PostActivationResuspensionMixType, PostActivationResuspensionMixVolume, PostActivationResuspensionNumberOfMixes, or PostActivationResuspensionMixRate to be compatible.";
Error::TooManyConjugationBuffers="The following samples have both ConjugationReactionBuffer and ConcentratedConjugationReactionBuffer specified: `1`. Please choose either ConjugationReactionBuffer or ConcentratedConjugationReactionBuffer.";
Error::TooManyConjugationBufferOptions="The following samples have both ConjugationReactionBuffer and ConcentratedConjugationReactionBuffer options specified: `1`. Please only use option related to either the ConjugationReactionBuffer or ConcentratedConjugationReactionBuffer 9ConcentratedConjugationReactionBufferDilutionFactor,ConjugationReactionBufferDiluent,ConjugationDiluentVolume).";
Error::TooFewConjugationBuffers = "The following samples have niether ConjugationReactionBuffer nor ConcentratedConjugationReactionBuffer options specified but have a specified ConjugationReactionBufferVolume: `1`. Please specify a buffer compatible with the conjugation reaction.";
Error::ConflictingConcentratedConjugationBufferOptions="The following samples have conflicting ConcentratedConjugationReactionBuffer options: `1`. Please update options related to ConcentratedConjugationReactionBuffer to be compatible.";
Error::ConflictingConjugationMixOptions="The following samples have conflicting ConjugationMix options: `1`. Please update ConjugationMix, ConjugationMixType, ConjugationMixVolume, ConjugationNumberOfMixes, or ConjugationMixRate to be compatible.";
Error::ConflictingQuenchOptions="The following samples have conflicting Quench options: `1`. Please update QuenchConjugation, PredrainReactionMixture, QuenchReactionVolume,QuenchReagent, QuenchReagentDilutionFactor, QuenchReagentVolume, QuenchTime, QuenchTemperature, and QuenchMix to be compatible.";
Error::ConflictingPredrainReactionMixtureOptions="The following samples have conflicting Quench options: `1`. Please update PredrainReactionMixture, PredrainMethod,PredrainInstrument, PredrainCentrifugationIntensity, PredrainCentrifugationTime, and PredrainTemperature to be compatible.";
Error::ConflictingQuenchMixOptions="The following samples have conflicting QuenchMix options: `1`. Please update QuenchnMix, QuenchMixType, QuenchMixVolume, QuenchNumberOfMixes, or QuenchMixRate to be compatible.";
Error::ConflictingPostConjugationWorkupOptions="The following samples have conflicting Post-Conjugation Workup options: `1`. Please update PostConjugationWorkup, PostConjugationWorkupMethod, PostConjugationWorkupBuffer, PostConjugationWorkupBufferVolume, PostConjugationWorkupIncubationTime, and PostConjugationWorkupIncubationTemperature to be compatible. If PostConjugationWorkup->True, PostConjugationWorkupBuffer, PostConjugationWorkupBufferVolume, PostConjugationIncubationTime and PostConjugationIncubationTemperature must be specified.";
Error::ConflictingPostConjugationWorkupMixOptions="The following samples have conflicting PostConjugationWorkupMix options: `1`. Please update PostConjugationWorkupMix, PostConjugationWorkupMixType, PostConjugationWorkupMixVolume, PostConjugationWorkupNumberOfMixes, and PostConjugationWorkupMixRate to be compatible.";
Error::ConflictingPostConjugationResuspensionOptions="The following samples have conflicting PostConjugationResuspension options: `1`. Please update PostConjugationResuspension, PostConjugationResuspensionDiluent, PostConjugationResuspensionDiluentVolume, PostConjugationResuspensionMix, and PostConjugationResuspensionTemperature to be compatible.";
Error::ConflictingPostConjugationResuspensionMixOptions="The following samples have conflicting PostConjugationResuspensionMix options: `1`. Please update PostConjugationResuspensionMix, PostConjugationResuspensionMixType, PostConjugationResuspensionNumberOfMixes, PostConjugationResuspensionMixVolume, PostConjugationResuspensionMixRate, and PostConjugationResuspensionTime to be compatible.";
Error::ConflictingPostConjugationMixUntilDissolvedOptions="The following samples have conflicting PostConjugationMixUntilDissolved options: `1`. Please update PostConjugationResuspensionMixUntilDissolved, PostConjugationResuspensionMaxNumberOfMixes, and PostConjugationResuspensionMaxTime to be compatible";
Error::EmptyBioconjugationSampleContainer = "The following supplied input containers `1` are empty. Please specify input containers with contents.";
Error::EmptyBioconjugationSample = "The following supplied input samples have no volume or mass `1`. Please supply input samples that contain non-zero volume or mass.";

Error::InvalidPreWashOptions="The following samples have invalid PreWash options: `1`. When PreWash -> False, the options PreWashMix, PreWashResuspension, and PreWashResuspensionMix cannot be True. Please update the corresponding options to be compatible.";
Error::InvalidActivateOptions="The following samples have invalid Activate options: `1`. When Activate-> False, the options ActivationMix, PostActivationWash, PostActivationWashMix, PostActivationResuspension, and PostActivationResuspensionMix cannot be True. Please update the corresponding options to be compatible.";
Error::InvalidActivationSampleVolumes="The ActivationSampleVolume could not be automatically determined for the following samples: `1`. Please provide the desired ActivationSampleVolume or update the sample Analytes field to automatically calculate the desired volume.";
Error::InvalidActivationReagentVolumes="The ActivationReagentVolume could not be automatically determined for the following samples: `1`. Please provide the desired ActivationReagentVolume.";
Error::InvalidActivationDiluentVolumes="The ActivationDiluentVolume could not be automatically determined for the following samples: `1`. Please provide the desired ActivationDiluentVolume.";
Error::InvalidConjugationReactionVolumes="The ConjugationReactionVolume could not be automatically determined for the following samples: `1`. Please provide the desired ConjugationReactionVolume or update the sample Analytes field to automatically calculate the desired volume.";
Error::InvalidConjugationBufferVolumes="The ConjugationReactionBufferVolume could not be automatically determined for the following samples: `1`. Please provide the desired ConjugationBufferVolume.";
Error::InvalidConjugationMixVolumes="The following samples have invalid ConjugationMixVolumes: `1`. Please verify that the ConjugationMixVolume is compatible with the ConjugationMixType and is a valid volume.";
Error::InvalidConjugationDiluentVolumes="The following samples have invalid ConjugationDiluentVolumes:`1`. Please provide a valid volume or specify Null if no conjugation diluent is used.";
Error::InvalidQuenchReagentVolumes="The QuenchReagentVolume could not be automatically determined for the following samples: `1`. Please provide the desired QuenchReagentVolume.";
Error::InvalidQuenchMixVolumes="The following samples have invalid QuenchMixVolume: `1`. Please verify that the QuenchMixVolume is compatible with the QuenchMixType and is a valid volume.";
Error::InvalidPostConjugationMixVolumes="The following samples have invalid PostConjugationMixVolume: `1`. Please verify that the PostConjugationMixVolume is compatible with the PostConjugationMixVolume and is a valid volume.";
Error::InvalidQuenchingOptions="The following samples have invalid Quench options: `1`. When Quench -> False, the options QuenchMix and PredrainReactionMixture cannot be True. Please update the corresponding options to be compatible.";
Error::InvalidPostConjugationOptions="The following samples have invalid PostConjugationWorkup options: `1`. When PostConjugationWorkup -> False, the options PostConjugationWorkupMix and PostConjugationResuspension cannot be True. Please update the corresponding options to be compatible.";
Error::InvalidPostConjugationResuspensionDiluentVolumes="The following samples have invalid PostConjugationResuspensionDiluentVolumes:`1`. Please provide a valid volume or leave the option as Automatic.";
Error::InvalidPostConjugationResuspensionMixVolumes="The following samples have invalid PostConjugationResuspensionMixVolumes: `1`. Please verify that the PostConjugationResuspensionMixVolume is compatible with the PostConjugationResuspensionMixType and is a valid volume.";
Warning::InvalidSampleAnalyteConcentrations="The analyte concentration could not be determined for the following samples: `1`. Without the Analyte concentration, the resulting sample composition cannot be accurately determined. Please update the sample object Analyte field and ensure that all MolecularWeights are informed.";
Error::InvalidReactionVessel="The following samples have invalid ReactionVessels: `1`. Please provide a reaction vessel that can accommodate the requested conjugation reaction volume and any quenching or post-conjugation workup samples specified.";
Warning::UnknownReactantsStoichiometry = "The following samples do not have defined ReactantsStoichiometricCoefficients: `1`. The stoichiometric coefficient will default to 1 for each reactant. If this is not accurate please update ReactantsStoichiometricCoefficients.";
Warning::UnknownProductStoichiometry = "The following samples do not have defined ProductStoichiometricCoefficient: `1`. The stoichiometric coefficient will default to 1 for the corresponding product. If this is not accurate please update ProductStoichiometricCoefficient.";

(* ::Subsection:: *)
(* ExperimentBioconjugation *)

(*--- SEMI-POOLED, CONTAINER, and PREP PRIMITIVES OVERLOAD ---**)

(* Overload for mixed input like {s1,{s2,s3}} -> We assume the first sample is going to be inside a pool and turn this into {{s1},{s2,s3}} *)

ExperimentBioconjugation[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[Object[Sample]],ObjectP[Object[Container]],_String]]], myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]],myOptions:OptionsPattern[]]:=Module[
  {listedContainers, emptyContainers, listedOptions, listedInputs,
    outputSpecification, output, gatherTests, containerToSampleResult,
    containerToSampleOutput, containerToSampleTests, samples,
    sampleOptions, validSamplePreparationResult,
    mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
    samplePreparationCache, updatedCache, listedInputsNoTemporalLinks,
    defineAssociations, definedContainerRules, sampleCache,labelContainerPrimitives, prepUnitOperations,
    updatedSimulation, prepPrim, contentsPerDefinedContainerObject,
    uniqueSampleTransfersPerDefinedContainer,
    totalSampleCountsPerDefinedContainerRules,
    totalSampleCountsPerDefinedContainer, identityModels, sampleObjects,
    identityModelExistQs},

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* check if our identity models exist in the database *)
  identityModelExistQs=DatabaseMemberQ[ToList[myNewIdentityModels]];

  (*Return early if identity model does not exist *)
  If[Not[And@@identityModelExistQs],
    Message[Error::ObjectDoesNotExist,PickList[ToList[myNewIdentityModels],identityModelExistQs,False]];
    Return[$Failed]
  ];

  (*--Check for empty containers--*)

  (* put all containers specified as inputs into a list *)
  listedContainers=Cases[Flatten@ToList[mySemiPooledInputs],ObjectP[Object[Container]]];

  (* get container that doesn't have a content *)
  emptyContainers=If[MatchQ[listedContainers,{}],
    {},
    PickList[listedContainers,Download[listedContainers,Contents],{}]
  ];

  (*Return early if empty containers*)
  If[Length[emptyContainers]>0,
    Message[Error::EmptyBioconjugationSampleContainer,emptyContainers];
    Return[$Failed]
  ];

  (* in the next step we will be wrapping a list around any single sample inputs except plates. in order to not pool all the samples in a Defined container that has more than one sample, we need to get the containers for the defined inputs and wrap a list only around ones that do not have more than one sample in them.*)
  prepPrim = Lookup[ToList[myOptions],PreparatoryPrimitives];
  defineAssociations = Cases[prepPrim, DefineP]/. Define -> Sequence;

  prepUnitOperations = Lookup[ToList[myOptions],PreparatoryUnitOperations];
  labelContainerPrimitives = If[MatchQ[prepUnitOperations, _List],
    Cases[prepUnitOperations, _LabelContainer],
    {}
  ];

  definedContainerRules = Join[
    If[MatchQ[defineAssociations,{}|Null],
      {},
      MapThread[#1->#2&,{Lookup[defineAssociations,Name],Lookup[defineAssociations,Container]}]
    ],
    If[MatchQ[labelContainerPrimitives,{}|Null],
      {},
      MapThread[#1->#2&,{Lookup[labelContainerPrimitives[[All,1]],Label],Lookup[labelContainerPrimitives[[All,1]],Container]}]
    ]
  ];

  contentsPerDefinedContainerObject = Association@Thread[
    PickList[Keys[definedContainerRules],Values[definedContainerRules],ObjectP[Object[Container]]] -> Length/@Download[Cases[Values[definedContainerRules],ObjectP[Object[Container]]],Contents]
  ];

  uniqueSampleTransfersPerDefinedContainer = Counts@DeleteDuplicates[Cases[Flatten[Lookup[Cases[prepPrim, _?Patterns`Private`transferQ] /. Transfer -> Sequence, Destination], 1], {_String, WellP}]][[All, 1]];

  totalSampleCountsPerDefinedContainerRules = Normal@Merge[{contentsPerDefinedContainerObject,uniqueSampleTransfersPerDefinedContainer},Total];

  totalSampleCountsPerDefinedContainer = ToList[mySemiPooledInputs]/.totalSampleCountsPerDefinedContainerRules;

  (* Wrap a list around any single sample inputs except single plate objects to convert flat input into a nested list *)
  (* Leave any non-list plate objects as single inputs because wrapping list around a single plate object signals pooling of all samples in plate.
  In the case that a user wants to run every sample in a plate independently, the plate object is supplied as a single input.*)
  listedInputs=MapThread[
    If[
      MatchQ[#1, ObjectP[Object[Container,Plate]]] || MatchQ[#2, GreaterP[1]],
      #1, ToList[#1]
    ]&,
    {ToList[mySemiPooledInputs],totalSampleCountsPerDefinedContainer}
  ];

  (* TODO: update this line when merged *)
  (*Remove temporal links*)
  {listedInputsNoTemporalLinks, listedOptions}=removeLinks[listedInputs, ToList[myOptions]];

  (* First, simulate our sample preparation and check if MissingDefineNames, InvalidInput, InvalidOption error messages are thrown.
  If none of these messages are thrown, returns mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache*)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentBioconjugation,
      listedInputsNoTemporalLinks,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
  ];

  (* If we are given MissingDefineNames, InvalidInput, InvalidOption error messages, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* For each group, map containerToSampleOptions over each sample or simulated sample group to get the object samples from the contents of the container *)
  (* ignoring the options, since we will use the ones from from ExpandIndexMatchedInputs *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests}=pooledContainerToSampleOptions[
      ExperimentBioconjugation,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
      Output->{Result,Tests},
      Simulation->updatedSimulation
    ];

    (* Therefore,we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::EmptyContainers. *)
    {
      Check[
        containerToSampleOutput=pooledContainerToSampleOptions[
          ExperimentBioconjugation,
          mySamplesWithPreparedSamples,
          myOptionsWithPreparedSamples,
          Output->Result,
          Simulation->updatedSimulation
        ],
        $Failed,
        {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
      ],
      {}
    }
  ];

  (*If all above checks pass, update our cache with our new simulated values. *)
  updatedCache=Flatten[{
    Lookup[listedOptions,Cache,{}]
  }];

  (* If we were given an empty container,return early. *)
  If[ContainsAny[containerToSampleResult,{$Failed}],

    (* if containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result->$Failed,
      Tests->containerToSampleTests,
      Options->$Failed,
      Preview->Null,
      Simulation->Null
    },

    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions}=containerToSampleOutput;

    (* take the samples from the mapped containerToSampleOptions, and the options from expandedOptions *)
    (* this way we'll end up index matching each grouping to an option *)
    identityModels = Flatten@Download[myNewIdentityModels,Object];

    ExperimentBioconjugationCore[samples,identityModels,ReplaceRule[sampleOptions, {Cache -> updatedCache, Simulation->updatedSimulation}]]
  ]
];

(*--- SAMPLE OVERLOAD ---*)
(* This is the core function taking only clean pooled lists of samples in the form -> {{s1},{s2},{s3,s4},{s5,s6,s7}} *)
ExperimentBioconjugationCore[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]],myOptions:OptionsPattern[ExperimentBioconjugation]]:=Module[
  {listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,mySamplesWithPreparedSamples,updatedSimulation,safeOpsNamed,
    myOptionsWithPreparedSamples,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,
    templateTests,inheritedOptions,expandedSafeOps,allPackets,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,
    collapsedResolvedOptions,protocolObject,sampleManipulationContainerModels,sampleManipulationSampleModels,upload,confirm,
    fastTrack,parentProtocol,cache,preferredContainers,resourcePacketTests,resourcePackets,listedPooledSamples,preferredActivationReagents,
    preferredWashReagents,preferredConjugationReagents,preferredQuenchReagents,semiExpandedSafeOps,aliquotContainerOptions,
    expandedAliquotContainerOptions,

    (* new variables *)
    optionsWithObjects,rawObjectsToDownload,objectsToDownload,sampleFields,sampleModelFields,objectContainerFields,
    modelContainerFields,sampleIdentityModelFields,packetsToDownload
  },

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove Temporal Links *)
  {listedPooledSamples, listedOptions}=removeLinks[ToList[myPooledSamples], ToList[myOptions]];

  (* Simulate our sample preparation and check if any prepared samples are not defined using the PreparatoryUnitOperations option. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentBioconjugation,
      listedPooledSamples,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentBioconjugation,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentBioconjugation,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  (* Call sanitize-inputs to clean any named objects *)
  {mySamplesWithPreparedSamples,safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed, myOptionsWithPreparedSamplesNamed];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentBioconjugation,{mySamplesWithPreparedSamples,myNewIdentityModels},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentBioconjugation,{mySamplesWithPreparedSamples,myNewIdentityModels},myOptionsWithPreparedSamples],{}}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->safeOpsTests,
      Options->$Failed,
      Preview->Null,
      Simulation -> Null
    }]
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->Join[safeOpsTests,validLengthTests],
      Options->$Failed,
      Preview->Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions*)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentBioconjugation,{mySamplesWithPreparedSamples,myNewIdentityModels},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentBioconjugation,{mySamplesWithPreparedSamples,myNewIdentityModels},myOptionsWithPreparedSamples],{}}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests],
      Options->$Failed,
      Preview->Null,
      Simulation -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* get assorted hidden options *)
  {upload,confirm,fastTrack,parentProtocol,cache} = Lookup[inheritedOptions,{Upload,Confirm,FastTrack,ParentProtocol,Cache}];

  (* Expand index-matching options *)
  (* For some very odd reason the helper function does not properly expand the DestinationWell and AliquotContainer options (does not indexmatch to samples just to pools). This leads to downstream issues in resolvePooledAliquotOptions.*)
  (* We must therefore expand here and check that the options are properly indexmatched if specified. *)
  semiExpandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentBioconjugation,{mySamplesWithPreparedSamples, myNewIdentityModels},inheritedOptions]];
  aliquotContainerOptions = FilterRules[semiExpandedSafeOps,{DestinationWell, AliquotContainer}];

  Error::NestedIndexMatchingAliquotOption = "The option `1` is not index-matched to the input samples. Please ensure that each input sample within the pool has a corresponding value for the option `1` and the option format matches the pooled sample format.";
  expandedAliquotContainerOptions = Module[{expandedAutomaticOptions, expandedNullOptions, specifiedIndexMatchError},
    expandedAutomaticOptions = Map[ConstantArray[Automatic,Length[#]]&,mySamplesWithPreparedSamples];
    expandedNullOptions = Map[ConstantArray[Null,Length[#]]&,mySamplesWithPreparedSamples];
    specifiedIndexMatchError = If[!MatchQ[Length/@Values[#],Length/@mySamplesWithPreparedSamples]&&MemberQ[Flatten@Values[#],Except[Automatic|Null]],
      Message[Error::NestedIndexMatchingAliquotOption,#],
      {}
    ]&/@aliquotContainerOptions;

    Switch[Values[#],
      ConstantArray[Automatic,Length@mySamplesWithPreparedSamples], (Keys[#]/.List->Sequence)->expandedAutomaticOptions,
      ConstantArray[Null,Length@mySamplesWithPreparedSamples], (Keys[#]/.List->Sequence)->expandedNullOptions,
      Null, (Keys[#]/.List->Sequence)->expandedNullOptions,
      _, #
    ]&/@aliquotContainerOptions
  ];

  expandedSafeOps = ReplaceRule[semiExpandedSafeOps,expandedAliquotContainerOptions];

  (*== DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION ==*)

  (* all possible containers that the resolver might use; these are qPCR plates, Uncle capillary strips, aliquot plates, and also ContainerOut options *)
  preferredContainers=DeleteDuplicates[
    Flatten[{
      PreferredContainer[All,Type->All],
      PreferredContainer[All,Sterile->True,Type->All],
      PreferredContainer[All,LightSensitive->True,Type->All],
      Search[Model[Container, Plate], Treatment === NonTreated && Type != Model[Container, Plate, Filter] && Type != Model[Container, Plate, Irregular] && (ContainerMaterials === Polypropylene || ContainerMaterials === Polystyrene) && Footprint != Null]
    }]
  ];

  (* get all preferred reagents to download *)

  (*Activation reagent objects*)
  preferredActivationReagents={Model[Sample,StockSolution,"id:mnk9jOREABbw"],Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (*Wash reagent objects*)
  preferredWashReagents={Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (*Conjugation reagent objects*)
  preferredConjugationReagents={Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (*Quench reagent objects*)
  preferredQuenchReagents={Model[Sample,StockSolution,"id:vXl9j57VMNLk"],Model[Sample,StockSolution,"id:54n6evLZAB49"],Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (* container models to pass to simulateSM *)
  sampleManipulationContainerModels={Model[Container,Plate,"id:54n6evLWKqbG"]};
  (* sample models to pass to simulateSM *)
  sampleManipulationSampleModels={Model[Sample, "id:8qZ1VWNmdLBD"]};

  (* Pull out the options that may have models/objects whose information we need to download *)
  optionsWithObjects=Lookup[expandedSafeOps,{ContainersIn,WorkingContainers,TargetContainer,ContainersOut,DispenserContainers,
    AliquotContainers,ReactionVessel,ActivationContainers,AliquotContainer,ActivationReagent,ActivationDiluent,PreWashBuffer,
    PreWashResuspensionDiluent,PostActivationWashBuffer,PostActivationResuspensionDiluent,ConjugationReactionBuffer,
    ConcentratedConjugationReactionBuffer,ConjugationReactionBufferDiluent,QuenchReagent,PostConjugationWorkupBuffer,
    PostConjugationResuspensionDiluent}];

  (* get all objects we want to download *)
  rawObjectsToDownload=Flatten[{
    mySamplesWithPreparedSamples,
    preferredContainers,
    optionsWithObjects,
    preferredActivationReagents,
    preferredWashReagents,
    preferredConjugationReagents,
    preferredQuenchReagents,
    sampleManipulationContainerModels,
    sampleManipulationSampleModels
  }]/.link_Link:>Download[link,Object];

  (* get all objects to download witout duplicates *)
  (* assumming that all object refs are now in ID and non-link form *)
  objectsToDownload=DeleteDuplicates@Cases[rawObjectsToDownload,ObjectReferenceP[]];

  (* get all the fields to download *)
  sampleFields=SamplePreparationCacheFields[Object[Sample],Format->Sequence];
  sampleModelFields=SamplePreparationCacheFields[Model[Sample],Format->Sequence];
  objectContainerFields=SamplePreparationCacheFields[Object[Container],Format->Sequence];
  modelContainerFields=Sequence[SamplePreparationCacheFields[Model[Container],Format->Sequence],AllowedPositions];
  sampleIdentityModelFields=Sequence[State,MolecularWeight,IncompatibleMaterials,LiquidHandlerIncompatible,Ventilated];

  (* assemble packets to download according to object type *)
  packetsToDownload=Map[
    Switch[#,
      ObjectReferenceP[Object[Sample]],
      {
        Packet[sampleFields],
        Packet[Model[{sampleModelFields}]],
        Packet[Container[{objectContainerFields}]],
        Packet[Container[Model][{modelContainerFields}]],
        Packet[Field[Composition[[All,2]]][{sampleIdentityModelFields}]]
      },
      ObjectReferenceP[Model[Sample]],
      {
        Packet[sampleModelFields]
      },
      ObjectReferenceP[Object[Container]],
      {
        Packet[objectContainerFields],
        Packet[Model[{modelContainerFields}]]
      },
      ObjectReferenceP[Model[Container]],
      {
        Packet[modelContainerFields]
      },
      _,{}
    ]&,
    objectsToDownload
  ];

  (* big download call *)
  allPackets=Check[
    Quiet[
      Download[
        objectsToDownload,
        Evaluate[packetsToDownload],
        Cache->Flatten[cache],
        Simulation->updatedSimulation,
        Date->Now
      ],
      {Download::FieldDoesntExist,Download::NotLinkField}
    ],
    $Failed,
    {Download::ObjectDoesNotExist}
  ];

  (* Return early if objects do not exist *)
  If[MatchQ[allPackets,$Failed],
    Return[$Failed]
  ];

  (* combine our downloaded packets and caches into cache ball *)
  cacheBall=FlattenCachePackets[{cache,allPackets}];

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (*If we are gathering tests silence any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentBioconjugationOptions[mySamplesWithPreparedSamples, myNewIdentityModels,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

    (* Because messages are silenced, we have to run the tests to see if we encountered a failure. If no failures were encountered return the result from above*)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* If we are not gathering tests simply check for Error::InvalidInput and Error::InvalidOption. If any of these messages were generated return failed.*)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentBioconjugationOptions[mySamplesWithPreparedSamples, myNewIdentityModels,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentBioconjugation,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentBioconjugation,collapsedResolvedOptions],
      Preview->Null,
      Simulation -> Null
    }]
  ];

  (* Build packets with resources *)
  {resourcePackets,resourcePacketTests} = If[gatherTests,
    experimentBioconjugationResourcePackets[ToList[mySamplesWithPreparedSamples], myNewIdentityModels,expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
    {experimentBioconjugationResourcePackets[ToList[mySamplesWithPreparedSamples], myNewIdentityModels,expandedSafeOps,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentBioconjugation,collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
    UploadProtocol[
      resourcePackets,
      Upload->upload,
      Confirm->confirm,
      ParentProtocol->parentProtocol,
      Priority->Lookup[inheritedOptions,Priority],
      StartDate->Lookup[inheritedOptions,StartDate],
      HoldOrder->Lookup[inheritedOptions,HoldOrder],
      QueuePosition->Lookup[inheritedOptions,QueuePosition],
      ConstellationMessage->Object[Protocol,Bioconjugation],
      Simulation->updatedSimulation
    ],
    $Failed
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentBioconjugation,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> Null
  }
];



(* ========== resolveExperimentBioconjugationOptions Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)

DefineOptions[
  resolveExperimentBioconjugationOptions,
  Options:>{HelperOutputOption,CacheOption, SimulationOption}
];

resolveExperimentBioconjugationOptions[myPooledSamples:ListableP[{ObjectP[Object[Sample]]...}],myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentBioconjugationOptions]]:=Module[
  {outputSpecification,output,gatherTests,cache,simulation,updatedSimulation,samplePrepOptions,bioconjugationOptions,simulatedSamples,resolvedSamplePrepOptions,
    simulatedCache,samplePrepTests,messages,flatSamplePrepOptionValues,flatSamplePrepOptions,resolvedSamplePrepOptionValues,
    flatResolvedSamplePrepOptions,conjugationBuffersAndVolume,invalidConjugationBufferVolume,tooFewConjugationBuffersSamples,
    tooFewConjugationBuffersOptions,tooFewConjugationBufferTest,solidSamplePackets,liquidSamplePackets,simulatedQuenchingSamples,
    workupPickListFilterBoolean,workupPickListPelletBoolean,workupPickListMagnetBoolean,activationFlatSamples,flatOptionValues,flatAliquotOptionSet,
    nestedResolvedAliquotOptionValues,nestedResolvedAliquotOptions,expandedReactionChemistry,

    (*Download Variables*)
    flatSimulatedSamples,poolingLengths,preferredContainers,specifiedContainerModels,specifiedContainerObjects,preferredActivationReagents,
    preferredWashReagents,preferredConjugationReagents,preferredQuenchReagents,sampleObjectPacketFields,sampleModelPacketFields,
    sampleIdentityModelPacketFields,sampleContainerPacketFields,sampleContainerModelPacketFields,containerObjectPacketFields,
    containerModelPacketFields,samplePackets,sampleIdentityModelPackets,containerModelPackets,containerObjectPackets,containerObjectsModelsPackets,
    containerObjectModelPacketFields,reagentModelPackets,sampleContainerPackets,sampleContainerModelPackets,regeantModelIdentityModelPackets,
    reagentObjectPackets,reagentObjectIdentityModelPackets,downloadedPackets,pooledSamplePackets,engineQ,sampleFields,
    sampleModelFields,objectContainerFields,modelContainerFields,sampleIdentityModelFields,optionsWithContainers,containerModelsToDownload,
    optionsWithSamples,reagentObjectsToDownload,reagentModels,allReagentModelsToDownload,rawSamplePackets,

    (*Input Validation Checks*)
    discardedSamplePackets,discardedInvalidInputs,discardedTest,

    (*Option Prescision Check*)
    roundedBioconjugationOptions,precisionTests,

    (*Conflicting Options Check*)
    mapThreadFriendlyOptions,flatSamplesMapThreadFriendlyOptions,suppliedNullBatchOptions,suppliedBatchOptions, invalidProcessingOrderOptions,invalidProcessingOrderTest,invalidPreWashOptionsMapThread,filteredInvalidPreWashList,
    invalidPreWashSamples,invalidPrewWashOptions,invalidPreWashTest,invalidPreWashMixOptionsMapThread,invalidPreWashMixSamples, invalidPreWashMixOptions,invalidPreWashMixTest,invalidPreWashResuspensionOptionsMapThread,filteredInvalidPreWashResuspensionList,
    invalidPreWashResuspensionSamples,invalidPrewWashResuspensionOptions,invalidPreWashResuspensionTest,invalidPreWashResuspensionMixOptionsMapThread, invalidPreWashResuspensionMixSamples,invalidPreWashResuspensionMixOptions,invalidPreWashResuspensionMixTest,invalidActivationOptionsMapThread,
    filteredInvalidActivateList,invalidActivateSamples,invalidActivateOptions,invalidActivationTest,invalidActivationMixOptionsMapThread, invalidActivationMixSamples,invalidActivationMixOptions,invalidActivationMixTest,invalidPostActivationWashOptionsMapThread,
    filteredInvalidPostActivationWashList,invalidPostActivationWashSamples,invalidPostActivationwWashOptions,invalidPostActivationWashTest, invalidPostActivationWashMixOptionsMapThread,invalidPostActivationWashMixSamples,invalidPostActivationWashMixOptions,
    invalidPostActivationWashMixTest,invalidPostActivationResuspensionOptionsMapThread,filteredInvalidPostActivationResuspensionList, invalidPostActivationResuspensionSamples,invalidPostActivationResuspensionOptions,invalidPostActivationResuspensionTest,
    invalidPostActivationResuspensionMixOptionsMapThread,invalidPostActivationResuspensionMixSamples,invalidPostActivationResuspensionMixOptions, invalidPostActivationResuspensionMixTest,conjugationBuffers,tooManyBuffersBool,tooManyBuffersSamples,tooManyBuffersOptions,
    invalidConjugationBufferTest,conjugationBufferOptions,concConjugationBufferOptions,tooManyBufferOptionsBool,tooManyBufferOptionsSamples, tooManyBufferOptionsOptions,invalidConjugationBufferOptionsTest,concConjugationBuffer,
    conflictingConcBufferOptionsBool, conflictingConcBufferSamples,conflictingConcBufferOptions,invalidConcentratedConjugationBufferTest,conjugationMixOption, conjugationMixTypeOption,conjugationMixParameters,conflictingMixOptionsBool,conflictingConjugationMixSamples,conflictingConjugationMixOptions,
    invalidConjugationMixTest,quenchOption,quenchParameters,conflictingQuenchBool,conflictingQuenchSamples,conflictingQuenchOptions, invalidQuenchOptionsTest,predrainOption,predrainParameters,conflictingPredrainBool,conflictingPredrainSamples,conflictingPredrainOptions,
    invalidPredrainOptionsTest,quenchMixOption,quenchMixTypeOption,quenchMixParameters,conflictingQuenchMixOptionsBool,conflictingQuenchMixSamples, conflictingQuenchMixOptions,invalidQuenchMixTest,postConjugationWorkupOption,postConjugationWorkupParameters,conflictingWorkupBool,
    conflictingWorkupSamples,conflictingWorkupOptions,invalidPostConjugationWorkupOptionsTest,workupMixOption,workupMixTypeOption, workupMixParameters,conflictingWorkupMixOptionsBool,conflictingWorkupMixSamples,conflictingWorkupMixOptions,invalidPostConjugationMixTest,
    postConjugationResuspensionOption,postConjugationResuspensionParameters,conflictingPostConjugationResuspensionBool,conflictingPostConjugationResuspensionSamples, conflictingPostConjugationResuspensionOptions,invalidPostConjugationResuspensionOptionsTest,workupResuspensionMixOption,workupResuspensionMixTypeOption,
    workupResuspensionInvertParameters,workupResuspensionPipetteParameters,workupResuspensionMixParameters,conflictingInvertMixBool,conflictingPipetteMixBool, conflictingMixBool,conflictingWorkupResuspensionInvertSamples,conflictingWorkupResuspensionPipetteSamples,conflictingWorkupResuspensionMixSamples,
    conflictingWorkupResuspensionMixSamplesFull,conflictingWorkupResuspensionMixOptions,invalidPostConjugationResuspensionMixTest,postConjugationDissolveOption,postConjugationDissolveParameters,conflictingPostConjugationDissolveBool,
    conflictingPostConjugationDissolveSamples,conflictingPostConjugationDissolveOptions,invalidPostConjugationMixUntilDissolvedOptionsTest,samplesInStorageCondition,invalidContainerStorageConditionBool, invalidContainerStorageConditionTests,invalidContainerStorageConditionOptions,activationSamplesStorageCondition,invalidActivationContainerStorageConditionBool, invalidActivationContainerStorageConditionTests,
    invalidActivationContainerStorageConditionOptions,invalidSamplesOutStorageConditionBool, invalidSamplesOutStorageConditionTests,conjugationSamplesStorageCondition,invalidSamplesOutStorageConditionOptions,simulatedSamplesDuplicatesQ,poolsWithDuplicates,invalidDuplicatedInput, invalidDuplicatedInputTest,

    (*Resolve sample MapThread Options*)
    resolvedBatchSize,resolvedProcessingBatches,resolvedPreWashMethods, resolvedPreWashWashNumbers, resolvedPreWashTimes, resolvedPreWashTemperatures, resolvedPreWashBuffers, resolvedPreWashBufferVolumes,
    resolvedPreWashMixes, resolvedPreWashMixTypes, resolvedPreWashMixVolumes, resolvedPreWashMixNumbers, resolvedPreWashMixRates,resolvedPreWashResuspensions, resolvedPreWashResuspensionTimes, resolvedPreWashResuspensionTemperatures, resolvedPreWashResuspensionDiluents,
    resolvedPreWashResuspensionDiluentVolumes, resolvedPreWashResuspensionMixes, resolvedPreWashResuspensionMixTypes, resolvedPreWashResuspensionMixVolumes, resolvedPreWashResuspensioMixNumbers,
    resolvedPreWashResuspensionMixRates,resolvedActivateBools, resolvedActivationReactionVolumes, resolvedTargetActivationSampleConcentrations, resolvedActivationSampleVolumes, resolvedActivationReagents,
    resolvedTargetActivationReagentConcentrations, resolvedActivationReagentVolumes, resolvedActivationDiluents, resolvedActivationDiluentVolumes, resolvedActivationTimes, resolvedActivationTemperatures, resolvedActivationMixes,
    resolvedActivationMixTypes, resolvedActivationMixRates, resolvedActivationMixVolumes, resolvedActivationMixNumbers, resolvedPostActivationWashes, resolvedPostActivationWashMethods, resolvedPostActivationWashNumbers,
    resolvedPostActivationWashTimes, resolvedPostActivationWashTemperatures, resolvedPostActivationWashBuffers, resolvedPostActivationWashBufferVolumes, resolvedPostActivationWashMixes, resolvedPostActivationWashMixTypes,
    resolvedPostActivationWashMixVolumes, resolvedPostActivationWashMixNumbers, resolvedPostActivationWashMixRates,resolvedPostActivationResuspensions, resolvedPostActivationResuspensionTimes, resolvedPostActivationResuspensionTemperatures, resolvedPostActivationResuspensionDiluents, resolvedPostActivationResuspensionDiluentVolumes, resolvedPostActivationResuspensionMixes,
    resolvedPostActivationResuspensionMixTypes, resolvedPostActivationResuspensionMixVolumes, resolvedPostActivationResuspensionMixNumbers, resolvedPostActivationResuspensionMixRates, resolvedActivationSamplesOutStorageConditions,
    invalidPreWashBooleans,invalidActivationBooleans,invalidActivationSampleVolumes,invalidActivationReagentVolumes,invalidActivationDiluentVolumes,filterOptionNames,pelletOptionNames,magneticTransferOptionNames,preWashFilterOptionNames,
    preWashPelletOptionNames,preWashMagneticTransferOptionNames,preWashFilterSamples,preWashPelletSamples,preWashMagneticTransferSamples, preWashFilterOptions,preWashPelletOptions,preWashMagnetizeOptions,prewashFilterResolveFailure,
    resolvedPreWashFilterOptions,preWashFilterTests,prewashPelletResolveFailure,resolvedPreWashPelletOptions,preWashPelletTests,prewashMagneticTransferResolveFailure,resolvedPreWashMagneticTransferOptions,preWashMagneticTransferTests,prewashFilterPositions,prewashPelletPositions,
    prewashMagneticTransferPositions,resolvedPreWashFilterOptionsFull,resolvedPreWashPelletOptionsFull,resolvedPreWashMagnetOptionsFull,filterPrimOptions,pelletPrimOptions,prewashFilterPrimitive,prewashPelletPrimitive,transferOutVolumes,
    prewashMagneticTransferPrimitive,preWashResuspendSamples,preWashResuspendDiluents,preWashResuspendDiluentVolumes,prewashTransferPrimitive,activationVolumes,activationSamples,activationContainers,activationDestinations,definePrimitives,consolidatePrimitives,
    activatedSamplesSimulation,simulatedActivatedSamples,updatedActivatedContents,defineLookup,activationUpdatedCache,simulationReplacePositions,simulatedActivationSamples,postActivationWashFilterOptionNames,postActivationWashPelletOptionNames,postActivationWashMagneticTransferOptionNames,
    postActivationWashFilterSamples,postActivationWashPelletSamples,postActivationWashMagneticTransferSamples,postActivationWashFilterOptions,postActivationWashPelletOptions,postActivationWashMagnetizeOptions,postActivationWashFilterResolveFailure,
    resolvedPostActivationWashFilterOptions,postActivationWashFilterTests,postActivationWashPelletResolveFailure,resolvedPostActivationWashPelletOptions,postActivationWashPelletTests,postActivationWashMagneticTransferResolveFailure,resolvedPostActivationWashMagneticTransferOptions,postActivationWashMagneticTransferTests,
    postActivationWashFilterPositions,postActivationWashPelletPositions,postActivationWashMagneticTransferPositions,resolvedPostActivationWashFilterOptionsFull,resolvedPostActivationWashPelletOptionsFull,resolvedPostActivationWashMagnetOptionsFull,
    pooledResolvedOptions,preWashPelletOptionsWithTime,postActivationWashPelletOptionsWithTime,resolvedPreWashes,

    (*Resolve pool mapthread Options*)
    resolvedConjugationReactionVolumes, resolvedTargetConjugationSampleConcentrations, resolvedConjugationReactionBufferVolumes, resolvedConcentratedConjugationReactionBufferDilutionFactors,
    resolvedConjugationReactionBufferDiluents, resolvedConjugationDiluentVolumes, resolvedConjugationTimes, resolvedConjugationTemperatures, resolvedConjugationMixTypes, resolvedConjugationMixVolumes, resolvedConjugationMixNumbers,
    resolvedConjugationMixRates,  resolvedQuenchBooleans, resolvedQuenchReactionVolumes, resolvedQuenchReagents, resolvedQuenchReagentDilutionFactors, resolvedQuenchReagentVolumes, resolvedQuenchTimes, resolvedQuenchTemperatures,
    resolvedQuenchMixes, resolvedQuenchMixTypes, resolvedQuenchMixVolumes, resolvedQuenchMixNumbers, resolvedQuenchMixRates, resolvedPostConjugationWorkupMethods, resolvedPostConjugationWorkupMixes, resolvedPostConjugationWorkupMixTypes, resolvedPostConjugationWorkupMixVolumes,
    resolvedPostConjugationWorkupMixNumbers, resolvedPostConjugationWorkupMixRates, resolvedPostConjugationResuspensions, resolvedPostConjugationResuspensionDiluents, resolvedPostConjugationResuspensionDiluentVolumes,
    resolvedPostConjugationResuspensionMixes, resolvedPostConjugationResuspensionMixTypes, resolvedPostConjugationResuspensionMixRates, resolvedPostConjugationResuspensionMixVolumes,
    resolvedPostConjugationResuspensionMixNumbers, resolvedPostConjugationResuspensionMixUntilDissolvedBools, resolvedPostConjugationResuspensionMaxMixNumbers, resolvedPostConjugationResuspensionTimes,
    resolvedPostConjugationResuspensionMaxTimes, resolvedPostConjugationResuspensionTemperatures, resolvedPredrainMethods, resolvedReactionVessels, invalidConjugationReactionVolumes,invalidConjugationReactionBufferVolumes,invalidConjugationMixVolumes,
    invalidDiluentVolumes,invalidQuenchReagentVolumes, invalidQuenchMixVolumes,
    invalidPostConjugationWorkupMixVolumes,invalidQuenchBooleans, invalidPostConjugationBooleans, invalidPostConjugationResuspensionVolumes,
    invalidPostConjugationResuspensionMixVolumes, invalidAnalyteConcentrations, invalidReactionVessels,postActivationFilterPrimOptions,postActivationPelletPrimOptions,postActivationWashFilterPrimitive,postActivationWashPelletPrimitive,postActivationTransferOutVolumes,
    postActivationWashMagneticTransferPrimitive,postActivationWashResuspendSamples,postActivationWashResuspendDiluents,postActivationWashResuspendDiluentVolumes,postActivationWashTransferPrimitive,conjugationAmounts,conjugationSamples,conjugationDestinations,
    conjugationDefinePrimitives,consolidateConjugationPrimitives,simulatedConjugatedSamples,samplePrepSimulation,conjugationDefineLookup,conjugationUpdatedCache,updatedConjugatedContents,simulatedConjugationSamples,predrainPelletOptionNames,predrainMagneticTransferOptionNames,predrainPelletSamples,
    predrainPickListPelletBoolean,predrainPickListMagnetBoolean,predrainMagneticTransferSamples,predrainPelletOptions,predrainMagnetizeOptions,predrainPelletResolveFailure,resolvedPredrainPelletOptions,predrainPelletTests,predrainMagneticTransferResolveFailure,resolvedPredrainMagneticTransferOptions,predrainMagneticTransferTests,
    predrainPelletPositions,predrainMagneticTransferPositions,resolvedPredrainPelletOptionsFull,resolvedPredrainMagnetOptionsFull,predrainSamples,quenchSamples,predrainTransferOutVolumes,predrainTransferOutPrimitives,quenchReagents,quenchReagentVolumes,
    transferQuenchPrimitives,workupSamples,workupBuffer,workupBufferVolume,transferWorkupPrimitives,simulatedQuenchedSamples,postConjugationSimulation,quenchDefineLookup,updatedQuenchedContents,quenchUpdatedCache,workupFilterOptionNames,workupPelletOptionNames,workupMagneticTransferOptionNames,workupFilterSamples,
    workupPelletSamples,workupMagneticTransferSamples,workupFilterOptions,workupPelletOptions,workupMagnetizeOptions,workupFilterResolveFailure,resolvedWorkupFilterOptions,workupFilterTests,workupPelletResolveFailure,resolvedWorkupPelletOptions,workupPelletTests,
    workupMagneticTransferResolveFailure,resolvedWorkupMagneticTransferOptions,workupMagneticTransferTests,workupFilterPositions,workupPelletPositions,workupMagneticTransferPositions,resolvedWorkupFilterOptionsFull,resolvedWorkupPelletOptionsFull,resolvedWorkupMagnetOptionsFull,
    reactionVesselModels,quenchSimulationReplacePositions,workupPelletOptionsWithTime,resolvedReactantCoefficients,unknownReactantCoefficients,resolvedProductCoefficients, unknownProductCoefficients,

    (*Error Checking*)
    invalidPreWashBooleanSamples,invalidPreWashBooleanOptions,invalidPreWashBooleansTest,invalidActivationBooleanSamples,invalidActivationBooleanOptions,invalidActivationBooleansTest,invalidActivationVolumeSamples,invalidActivationVolumeOptions,invalidActivationVolumesTest,
    invalidActivationReagentVolumeSamples,invalidActivationReagentVolumeOptions,invalidActivationReagentVolumesTest,invalidActivationDiluentVolumeSamples,invalidActivationDiluentVolumeOptions,invalidActivationDiluentVolumesTest,invalidConjugationReactionVolumeSamples,invalidConjugationReactionVolumeOptions,
    invalidConjugationReactionVolumesTest,invalidConjugationBufferVolumeSamples,invalidConjugationBufferVolumeOptions,invalidConjugationBufferVolumesTest,invalidConjugationMixVolumeSamples,invalidConjugationMixVolumeOptions,invalidConjugationMixVolumesTest,invalidConjugationDiluentVolumeSamples,
    invalidConjugationDiluentVolumeOptions,invalidConjugationDiluentVolumesTest,invalidQuenchReagentVolumeSamples,invalidQuenchReagentVolumeOptions,invalidQuenchReagentVolumesTest,invalidQuenchMixVolumeSamples,invalidQuenchMixVolumeOptions,invalidQuenchMixVolumesTest,
    invalidWorkupMixVolumeSamples,invalidWorkupMixVolumeOptions,invalidWorkupMixVolumesTest,invalidQuenchBooleanSamples,invalidQuenchBooleanOptions,invalidQuenchBooleansTest,
    invalidWorkupBooleanSamples,invalidWorkupBooleanOptions,invalidWorkupBooleansTest,invalidPostConjugationResuspensionVolumeSamples,invalidPostConjugationResuspensionVolumeOptions,invalidPostConjugationResuspensionVolumesTest,invalidPostConjugationResuspensionMixVolumeSamples,invalidPostConjugationResuspensionMixVolumeOptions,
    invalidPostConjugationResuspensionMixVolumesTest,invalidAnalyteConcentrationSamples,invalidAnalyteConcentrationOptions,invalidAnalyteConcentrationTest,invalidReactionVesselSamples,invalidReactionVesselOptions,invalidReactionVesselTest,
    invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,resolvedOptions,allTests,resultRule,testsRule,predrainPelletOptionsWithTime,sampleConjugationAmounts,    unknownReactantCoefficientTest,
    unknownProductCoefficientTest, unknownReactantCoefficientSamples,unknownReactantCoefficientOptions,unknownProductCoefficientSamples,unknownProductCoefficientOptions,liquidSampleWithNoVolume,solidSampleWithNoMass, emptySampleInputTest,liquidSample,solidSample,liquidSampleVolume,solidSampleMass,

    (*for rewriting ExpSamplePrep with UploadSample*)
    labelSimulation, labelsToObjectRules, conjugationCompositions,conjugationTransferPackets,conjugationLabelDestinations,conjugationDestinationsWithWell,
    updatedConjugationDestinations,updatedConjugationPackets,updatedConjugationSimulation,washMagTransferSim,washTransferSim,conjugationAmountsForTransfer,
    sourcesFromPrimitives, sourceSamplePacketsFlattened, transposedList, rules, flattenedSourcesFromPrims, sourcesStillNeedComposition, remainingCompositions,
    remainingCompositionRules, newRules,containerVesselSourcesPackets,containerVesselSources,
    flattenedVesselSourcePackets,secondTransposedList,containerToContentsRules,

    containerSources,containerContents,containerContentsSamples,containerToContentsSamplesRules,noContainerSources,
    flatSources,flatAmounts,flatDestinations,flatDestinationsNoLabels,sourceContainers,
    newCache,sourceContainerPackets,sourceSamplesFromContainers,containerToSampleLookup,
    flatSourcesNoContainers,pooledSourcesNoContainers,pooledAmounts,pooledDestinations,destStatusSim,
    fakeDestinationPackets,destContainerToSampleLookup,flatDestinationSamples,ustSim,ustPackets,
    sourceModels,flatSourcesNoContainersNoModels,finalSim,newNewCache
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

  (* Separate out our bioconjugation options from our Sample Prep options. *)
  (*Get the number of samples combined in each pooledSample*)
  poolingLengths=Length/@myPooledSamples;

  {samplePrepOptions,bioconjugationOptions}=splitPrepOptions[
    myOptions,
    PrepOptionSets->{CentrifugePrepOptionsNew,IncubatePrepOptionsNew,FilterPrepOptionsNew,AliquotOptions}
  ];

  flatSamplePrepOptionValues = If[ListQ[#],Flatten[#,1],#]&/@Values[samplePrepOptions];
  flatSamplePrepOptions = Thread[Keys[samplePrepOptions]->flatSamplePrepOptionValues];

  (* Resolve our sample prep options *)
  (* We want the sample prep to happen on each sample not the conjugation pools. We are not using aliquoting sample prep to pool samples. So we need to give resoleSamplePrepOptions a flat list of options/smaples.*)
  {{flatSimulatedSamples,flatResolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentBioconjugation,Flatten@myPooledSamples,flatSamplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
    {resolveSamplePrepOptionsNew[ExperimentBioconjugation,Flatten@myPooledSamples,flatSamplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
  ];

  resolvedSamplePrepOptionValues = If[ListQ[#],TakeList[#,poolingLengths],#]&/@Values[flatResolvedSamplePrepOptions];
  resolvedSamplePrepOptions = Thread[Keys[flatResolvedSamplePrepOptions]->resolvedSamplePrepOptionValues];
  simulatedSamples = TakeList[flatSimulatedSamples,poolingLengths];

  (*-- DOWNLOAD CALL --*)
  (*== DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION ==*)

  (* all possible containers that the resolver might use *)
  preferredContainers=DeleteDuplicates[
    Flatten[{
      PreferredContainer[All,Type->All],
      PreferredContainer[All,Sterile->True,Type->All],
      PreferredContainer[All,LightSensitive->True,Type->All],
      Search[Model[Container, Plate], Treatment === NonTreated && Type != Model[Container, Plate, Filter] && Type != Model[Container, Plate, Irregular] && (ContainerMaterials === Polypropylene || ContainerMaterials === Polystyrene) && Footprint != Null]
    }]
  ];

  (* get all preferred reagents to download *)
  (*Activation reagent objects*)
  preferredActivationReagents={Model[Sample,StockSolution,"id:mnk9jOREABbw"],Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (*Wash reagent objects*)
  preferredWashReagents={Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (*Conjugation reagent objects*)
  preferredConjugationReagents={Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};
  (*Quench reagent objects*)
  preferredQuenchReagents={Model[Sample,StockSolution,"id:vXl9j57VMNLk"],Model[Sample,StockSolution,"id:54n6evLZAB49"],Model[Sample,StockSolution,"id:J8AY5jwzPdaB"]};

  (* any containers the user provided (in case it's not not he PreferredContainer list) *)
  optionsWithContainers=Flatten@Lookup[bioconjugationOptions,{ContainersIn,WorkingContainers,TargetContainer,ContainersOut,
    DispenserContainers,AliquotContainers,ReactionVessel,ActivationContainer}]/.link_Link:>Download[link,Object];
  specifiedContainerModels=Cases[optionsWithContainers,ObjectReferenceP[Model[Container]]];
  specifiedContainerObjects=Cases[optionsWithContainers,ObjectReferenceP[Object[Container]]];

  (* get all the container models to download *)
  containerModelsToDownload=DeleteDuplicates@Flatten[{preferredContainers,specifiedContainerModels}];

  (* lookup all options that might have sample models/objects *)
  optionsWithSamples=Flatten@Lookup[bioconjugationOptions,{ActivationReagent,ActivationDiluent,PreWashBuffer,PreWashResuspensionDiluent,
    PostActivationWashBuffer,PostActivationResuspensionDiluent,ConjugationReactionBuffer,ConcentratedConjugationReactionBuffer,
    ConjugationReactionBufferDiluent,QuenchReagent,PostConjugationWorkupBuffer,PostConjugationResuspensionDiluent}]/.link_Link:>Download[link,Object];

  (* separate samples into model or object to download *)
  reagentObjectsToDownload=DeleteDuplicates@Cases[optionsWithSamples,ObjectReferenceP[Object[Sample]]];
  reagentModels=Cases[optionsWithSamples,ObjectReferenceP[Model[Sample]]];

  (* combine all reagent models and remove duplicates *)
  allReagentModelsToDownload=DeleteDuplicates@Flatten[{reagentModels,preferredActivationReagents,preferredWashReagents,preferredConjugationReagents,preferredQuenchReagents}];

  (* get all the fields to download *)
  sampleFields=SamplePreparationCacheFields[Object[Sample],Format->Sequence];
  sampleModelFields=SamplePreparationCacheFields[Model[Sample],Format->Sequence];
  objectContainerFields=SamplePreparationCacheFields[Object[Container],Format->Sequence];
  modelContainerFields=Sequence[SamplePreparationCacheFields[Model[Container],Format->Sequence],AllowedPositions];
  sampleIdentityModelFields=Sequence[State,MolecularWeight,IncompatibleMaterials,LiquidHandlerIncompatible,Ventilated];

  (* Create the Packet Download syntax for our sample Objects and Identity Models. *)
  sampleObjectPacketFields=Packet[sampleFields];
  sampleModelPacketFields=Packet[sampleModelFields];
  sampleIdentityModelPacketFields=Packet[Field[Composition[[All,2]]][{sampleIdentityModelFields}]];

  (*Create the Packet Download syntax for all relevant container objects and models*)
  sampleContainerPacketFields=Packet[Field[Container][{objectContainerFields}]];
  sampleContainerModelPacketFields=Packet[Container[Model][{modelContainerFields}]];
  containerObjectPacketFields=Packet[objectContainerFields];
  containerObjectModelPacketFields=Packet[Model[{modelContainerFields}]];
  containerModelPacketFields=Packet[modelContainerFields];

  (* download from our cache *)
  downloadedPackets = Quiet[
      Download[
        {
          flatSimulatedSamples,
          flatSimulatedSamples,
          flatSimulatedSamples,
          flatSimulatedSamples,
          containerModelsToDownload,
          specifiedContainerObjects,
          specifiedContainerObjects,
          allReagentModelsToDownload,
          allReagentModelsToDownload,
          reagentObjectsToDownload,
          reagentObjectsToDownload
        },
        Evaluate[{
          (*sample object packets*)
          {sampleObjectPacketFields},

          (*sample identity model packets*)
          {sampleIdentityModelPacketFields},

          (*sample container packets*)
          {sampleContainerPacketFields},

          (*sample container model packets*)
          {sampleContainerModelPacketFields},

          (*preferred container model packets*)
          {containerModelPacketFields},

          (*specified container object packets*)
          {containerObjectPacketFields},

          (*specified container object's model packets*)
          {containerObjectModelPacketFields},

          (* reagent model packets*)
          {sampleModelPacketFields},

          (* reagent model identity model packets*)
          {sampleIdentityModelPacketFields},

          (* reagent object packets*)
          {sampleObjectPacketFields},

          (* reagent object identity model packets*)
          {sampleIdentityModelPacketFields}

        }],
      Cache->cache,
      Simulation->updatedSimulation,
      Date->Now
    ],
    {Download::FieldDoesntExist,Download::NotLinkField}
  ];


  (*Since multiple of the same sample can be used during pooling, delete any duplicated cache packets*)
  (* this is just because simulated cache is used a lot later *)
  simulatedCache=FlattenCachePackets[{cache, Flatten[downloadedPackets]}];

  (* Deconstruct the downloaded packets *)
  {
    rawSamplePackets,
    sampleIdentityModelPackets,
    sampleContainerPackets,
    sampleContainerModelPackets,
    containerModelPackets,
    containerObjectPackets,
    containerObjectsModelsPackets,
    reagentModelPackets,
    regeantModelIdentityModelPackets,
    reagentObjectPackets,
    reagentObjectIdentityModelPackets
  } = downloadedPackets;

  samplePackets=Flatten[rawSamplePackets];

  pooledSamplePackets = TakeList[samplePackets,poolingLengths];

  (*-- INPUT VALIDATION CHECKS --*)
  (*Check if we are executing in Engine, if so we don't want to throw warnings*)
  engineQ = MatchQ[$ECLApplication,Engine];

  (*1. DISCARDED SAMPLES ARE NOT OKAY*)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
    {},
    Lookup[discardedSamplePackets,Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&!gatherTests,
    Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->simulatedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[discardedInvalidInputs]>0,
        Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->simulatedCache]<>" are not discarded:",True,False],
        Nothing
      ];

      passingTest=If[Length[discardedInvalidInputs]==0,
        Test["Our input samples "<>ObjectToString[Complement[myPooledSamples,discardedInvalidInputs],Cache->simulatedCache]<>" are not discarded:",True,True],
        Nothing
      ];

      {failingTest,passingTest}
    ],
    {}
  ];

  (*-- OPTION PRECISION CHECKS --*)

  (*Verify that the options are not overly precise*)
  {roundedBioconjugationOptions,precisionTests}=If[gatherTests,

    RoundOptionPrecision[Association[bioconjugationOptions],
      {
        (*Volumes*)
        PreWashBufferVolume,PreWashMixVolume,PreWashResuspensionDiluentVolume,PreWashResuspensionMixVolume,ActivationReactionVolume,ActivationSampleVolume,
        ActivationReagentVolume,ActivationDiluentVolume,ActivationMixVolume,PostActivationWashBufferVolume,PostActivationWashMixVolume,
        PostActivationResuspensionDiluentVolume,PostActivationResuspensionMixVolume,ConjugationReactionVolume,ConjugationReactionBufferVolume,
        ConjugationDiluentVolume,ConjugationMixVolume,QuenchReactionVolume,QuenchReagentVolume,QuenchMixVolume,PostConjugationWorkupBufferVolume,
        PostConjugationWorkupMixVolume,PostConjugationResuspensionDiluentVolume,PostConjugationResuspensionMixVolume,
        (*Times*)
        PreWashTime,PreWashCentrifugationTime,PreWashResuspensionTime,ActivationTime,PostActivationWashTime,PostActivationWashCentrifugationTime,
        PostActivationResuspensionTime,ConjugationTime,PredrainCentrifugationTime,QuenchTime,PostConjugationWorkupIncubationTime,
        PostConjugationCentrifugationTime,PostConjugationResuspensionTime,PostConjugationResuspensionMaxTime,
        (*Temperatures*)
        PreWashTemperature,PreWashCentrifugationTemperature,PreWashResuspensionTemperature,ActivationTemperature,PostActivationWashTemperature,
        PostActivationWashCentrifugationTemperature,PostActivationResuspensionTemperature,ConjugationTemperature,PredrainTemperature,QuenchTemperature,
        PostConjugationWorkupIncubationTemperature,PostConjugationCentrifugationTemperature,PostConjugationResuspensionTemperature,
        (*Mix Rates*)
        PreWashMixRate,PreWashResuspensionMixRate,ActivationMixRate,PostActivationWashMixRate,PostActivationResuspensionMixRate,ConjugationMixRate,QuenchMixRate,
        PostConjugationWorkupMixRate,PostConjugationResuspensionMixRate
      },
     Flatten@{
        ConstantArray[0.1*Microliter,24],
        ConstantArray[1*Second,14],
        ConstantArray[0.1*Celsius,13],
        ConstantArray[1*RPM,9]
      },
      Output->{Result,Tests}],

    {RoundOptionPrecision[Association[bioconjugationOptions],
      {
        (*Volumes*)
        PreWashBufferVolume,PreWashMixVolume,PreWashResuspensionDiluentVolume,PreWashResuspensionMixVolume,ActivationReactionVolume,ActivationSampleVolume,
        ActivationReagentVolume,ActivationDiluentVolume,ActivationMixVolume,PostActivationWashBufferVolume,PostActivationWashMixVolume,
        PostActivationResuspensionDiluentVolume,PostActivationResuspensionMixVolume,ConjugationReactionVolume,ConjugationReactionBufferVolume,
        ConjugationDiluentVolume,ConjugationMixVolume,QuenchReactionVolume,QuenchReagentVolume,QuenchMixVolume,PostConjugationWorkupBufferVolume,
        PostConjugationWorkupMixVolume,PostConjugationResuspensionDiluentVolume,PostConjugationResuspensionMixVolume,
        (*Times*)
        PreWashTime,PreWashCentrifugationTime,PreWashResuspensionTime,ActivationTime,PostActivationWashTime,PostActivationWashCentrifugationTime,
        PostActivationResuspensionTime,ConjugationTime,PredrainCentrifugationTime,QuenchTime,PostConjugationWorkupIncubationTime,
        PostConjugationCentrifugationTime,PostConjugationResuspensionTime,PostConjugationResuspensionMaxTime,
        (*Temperatures*)
        PreWashTemperature,PreWashCentrifugationTemperature,PreWashResuspensionTemperature,ActivationTemperature,PostActivationWashTemperature,
        PostActivationWashCentrifugationTemperature,PostActivationResuspensionTemperature,ConjugationTemperature,PredrainTemperature,QuenchTemperature,
        PostConjugationWorkupIncubationTemperature,PostConjugationCentrifugationTemperature,PostConjugationResuspensionTemperature,
        (*Mix Rates*)
        PreWashMixRate,PreWashResuspensionMixRate,ActivationMixRate,PostActivationWashMixRate,PostActivationResuspensionMixRate,ConjugationMixRate,QuenchMixRate,
        PostConjugationWorkupMixRate,PostConjugationResuspensionMixRate
      },
      Flatten@{
        ConstantArray[0.1*Microliter,24],
        ConstantArray[1*Second,14],
        ConstantArray[0.1*Celsius,13],
        ConstantArray[1*RPM,9]
      }],{}}
  ];

  (*-- CONFLICTING OPTIONS CHECKS --*)

  (*Get the mapthreadfriendly options excluding the dilution options*)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentBioconjugation,roundedBioconjugationOptions];
  flatSamplesMapThreadFriendlyOptions = Module[{optionList, transposedList, expandedOptions, filteredExpandedOptions, retransposedList, result},

    (*Reformat the option association to a rule list for easy manipulation*)
    optionList = Normal@mapThreadFriendlyOptions;

    (*Transpose the options so that each list contains the same option for each sample*)
    transposedList = Transpose@optionList;

    (*Create new rules for the pooled samples such that {OptionA->{a1,a2}} becomes {OptionA->a1,Option->a2}*)
    expandedOptions = Map[Flatten@Map[Thread[#] &, #] &, transposedList];
    filteredExpandedOptions = PickList[expandedOptions,Length/@expandedOptions,Length@flatSimulatedSamples];

    (*Transpose the option so that all options for one sample are in a list*)
    retransposedList = Transpose@filteredExpandedOptions;

    (*Reformat the option rule list back into an association*)
    result = Association[#]&/@retransposedList
  ];

  (*--1 . Check that the ProcessingOrder and processing order options are compatible. --*)
  suppliedNullBatchOptions = Select[FilterRules[Normal@roundedBioconjugationOptions,{ProcessingBatches,ProcessingBatchSize}], MatchQ[Values[#],Null]&];
  suppliedBatchOptions = Select[FilterRules[Normal@roundedBioconjugationOptions,{ProcessingBatches,ProcessingBatchSize}], MatchQ[Values[#],Except[Null|Automatic]]&];

  invalidProcessingOrderOptions = Switch[Lookup[roundedBioconjugationOptions,ProcessingOrder],
    Batch, suppliedNullBatchOptions,
    _, suppliedBatchOptions
  ];

  (*Throw an error if invalidProcessingOrderOptions is not {}*)
  If[
    Length[invalidProcessingOrderOptions]>0&&messages,
    Message[Error::InvalidBatchProcessingOptions,Lookup[roundedBioconjugationOptions,ProcessingOrder],Keys[invalidProcessingOrderOptions],Values[invalidProcessingOrderOptions]],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidProcessingOrderTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidProcessingOrderOptions] > 0,
                Test["Our user specified processing order options are compatible:", True, False],
                Nothing];

          passingTest =
              If[Length[invalidProcessingOrderOptions] == 0,
                Test["Our user specified processing order options are compatible:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}];

  (*--2. Check that PreWash boolean and PreWash options are compatible--*)

  (*Map over all input pools to check if prewash options are compatible*)
  invalidPreWashOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{preWashOption,preWashParameters,suppliedPreWashOptions,suppliedNullPreWashOptions},

        (*Find prewash boolean value*)
        preWashOption = Lookup[sampleOptions,PreWash];

        (*Gather other prewash options*)
        preWashParameters=FilterRules[Normal@sampleOptions,{PreWashMethod,PreWashNumberOfWashes,PreWashInstrument,PreWashTime,PreWashTemperature,PreWashBuffer,PreWashBufferVolume}];

        (*Find any pooled incubate options that are user specified*)
        suppliedNullPreWashOptions = Select[preWashParameters, MatchQ[Values[#],Null]&];
        suppliedPreWashOptions = Select[preWashParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

        (*Return the appropriate invalid options given the PreWash option*)
        Switch[preWashOption,
          (*If PreWash is True return Null options and input sample*)
          True, {sample,Keys@suppliedNullPreWashOptions},
          (*If PreWash is False return non-Null options and input sample*)
          False,{sample,Keys@suppliedPreWashOptions},
          _, {{},{}}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  (*Filter out samples with {} invalid options*)
  filteredInvalidPreWashList = Select[invalidPreWashOptionsMapThread,!MatchQ[#[[2]],{}]&];

  (*Separate out invalid prewash options map thread output*)
  If[Length[filteredInvalidPreWashList]>0,
    {
      invalidPreWashSamples = filteredInvalidPreWashList[[All, 1]];
      invalidPrewWashOptions = filteredInvalidPreWashList[[All, 2]];
    },
    {
      invalidPreWashSamples = {};
      invalidPrewWashOptions = {};
    }
  ];

  (*Throw an error if invalidPreWash Options is not {}*)
  If[
    Length[invalidPreWashSamples]>0&&messages,
    Message[Error::ConflictingPreWashOptions,invalidPreWashSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPreWashTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPreWashSamples] > 0,
                Test["Our prewash options are compatible for the inputs "<>ObjectToString[invalidPreWashSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPreWashSamples] == 0,
                Test["Our prewash options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--3. Check that PreWashMix boolean and PreWashMix options are compatible--*)

  (*Map over all input pools to check if prewash mix options are compatible*)
  invalidPreWashMixOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{preWashOption,preWashMixTypeOption,preWashParameters},

        (*Find prewash mix boolean value and mix type*)
        preWashOption = Lookup[sampleOptions,PreWashMix];
        preWashMixTypeOption = Lookup[sampleOptions, PreWashMixType];

        (*Gather other prewash mix options*)
        preWashParameters=FilterRules[Normal@sampleOptions,{PreWashMixVolume,PreWashNumberOfMixes,PreWashMixRate}];

        (*Return the appropriate invalid options given the PreWash option*)
        Switch[{preWashOption,preWashMixTypeOption},

          {True,Invert}, If[MatchQ[Values[preWashParameters],{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],sample,{}],

          {True,Pipette}, If[MatchQ[Values[preWashParameters],{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],sample,{}],

          {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[Values[preWashParameters],{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],sample,{}],

          {True, Null}, sample,

          {False, Except[Null|Automatic]}, sample,

          {_,_}, {}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  invalidPreWashMixSamples = Flatten@invalidPreWashMixOptionsMapThread;
  invalidPreWashMixOptions = If[Length[invalidPreWashMixSamples]>0,{PreWashMix,PreWashMixType,PreWashMixVolume,PreWashNumberOfMixes,PreWashMixRate},{}];

  (*Throw an error if invalidPreWash Mix Options is not {}*)
  If[
    Length[invalidPreWashMixSamples]>0&&messages,
    Message[Error::ConflictingPreWashMixOptions,invalidPreWashMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPreWashMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPreWashMixSamples] > 0,
                Test["Our prewash mix options are compatible for the inputs "<>ObjectToString[invalidPreWashMixSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPreWashMixSamples] == 0,
                Test["Our prewash mix options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];


  (*--4. Check that PreWashResuspension boolean and PreWashResuspension options are compatible--*)

  (*Map over all input pools to check if prewash resuspension options are compatible*)
  invalidPreWashResuspensionOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{preWashResuspensionOption,preWashResuspensionParameters,suppliedPreWashResuspensionOptions,suppliedNullPreWashResuspensionOptions},

        (*Find resuspension boolean value*)
        preWashResuspensionOption = Lookup[sampleOptions,PreWashResuspension];

        (*Gather other resuspensoin options*)
        preWashResuspensionParameters=FilterRules[Normal@sampleOptions,{PreWashResuspensionTime, PreWashResuspensionTemperature, PreWashResuspensionDiluent, PreWashResuspensionDiluentVolume}];

        (*Find any resuspension options that are user specified*)
        suppliedNullPreWashResuspensionOptions = Select[preWashResuspensionParameters, MatchQ[Values[#],Null]&];
        suppliedPreWashResuspensionOptions = Select[preWashResuspensionParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

        (*Return the appropriate invalid options given the PreWashResuspension option*)
        Switch[preWashResuspensionOption,
          (*If PreWashResuspension is True return Null options and input sample*)
          True, {sample,Keys@suppliedNullPreWashResuspensionOptions},
          (*If PreWashResuspension is False return non-Null options and input sample*)
          False,{sample,Keys@suppliedPreWashResuspensionOptions},
          (*If PreWashResuspension is Automatic, return empty lists*)
          Automatic,  {{},{}}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  (*Filter out samples with {} invalid options*)
  filteredInvalidPreWashResuspensionList = Select[invalidPreWashResuspensionOptionsMapThread,!MatchQ[#[[2]],{}]&];

  (*Separate out invalid incubate options map thread output*)
  If[Length[filteredInvalidPreWashResuspensionList]>0,
    {
      invalidPreWashResuspensionSamples = filteredInvalidPreWashResuspensionList[[All, 1]];
      invalidPrewWashResuspensionOptions = filteredInvalidPreWashResuspensionList[[All, 2]];
    },
    {
      invalidPreWashResuspensionSamples = {};
      invalidPrewWashResuspensionOptions = {};
    }
  ];

  (*Throw an error if invalidPreWashResuspension Options is not {}*)
  If[
    Length[invalidPreWashResuspensionSamples]>0&&messages,
    Message[Error::ConflictingPreWashResuspensionOptions,invalidPreWashResuspensionSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPreWashResuspensionTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPreWashResuspensionSamples] > 0,
                Test["Our prewash resuspension options are compatible for the inputs "<>ObjectToString[invalidPreWashResuspensionSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPreWashResuspensionSamples] == 0,
                Test["Our prewash options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--5. Check that PreWashResuspensionMix boolean and PreWashResuspenionMix options are compatible--*)

  (*Map over all input pools to check if prewash resuspension mix options are compatible*)
  invalidPreWashResuspensionMixOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{preWashResuspensionMixOption,preWashMixTypeOption,preWashParameters},

        (*Find prewash mix boolean value and mix type*)
        preWashResuspensionMixOption = Lookup[sampleOptions,PreWashResuspensionMix];
        preWashMixTypeOption = Lookup[sampleOptions, PreWashResuspensionMixType];

        (*Gather other prewash mix options*)
        preWashParameters=FilterRules[Normal@sampleOptions,{PreWashResuspensionMixVolume,PreWashResuspensionNumberOfMixes,PreWashResuspensionMixRate}];

        (*Return the appropriate invalid options given the PreWash option*)
        Switch[{preWashResuspensionMixOption,preWashMixTypeOption},

          {True,Invert}, If[MatchQ[Values[preWashParameters],{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],sample,{}],

          {True,Pipette}, If[MatchQ[Values[preWashParameters],{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],sample,{}],

          {True, Except[Invert|Pipette|Null]}, If[MatchQ[Values[preWashParameters],{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],sample,{}],

          {True, Null}, sample,

          {False, Except[Null]}, sample,

          {_,_}, {}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  invalidPreWashResuspensionMixSamples = Flatten@invalidPreWashResuspensionMixOptionsMapThread;
  invalidPreWashResuspensionMixOptions = If[Length[invalidPreWashResuspensionMixSamples]>0,{PreWashResuspensionMix,PreWashResuspensionMixType,PreWashResuspensionMixVolume,PreWashResuspensionNumberOfMixes,PreWashResuspensionMixRate},{}];

  (*Throw an error if invalidPreWashResuspension Mix Options is not {}*)
  If[
    Length[invalidPreWashResuspensionMixSamples]>0&&messages,
    Message[Error::ConflictingPreWashResuspensionMixOptions,invalidPreWashResuspensionMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPreWashResuspensionMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPreWashMixSamples] > 0,
                Test["Our prewash resuspension mix options are compatible for the inputs "<>ObjectToString[invalidPreWashResuspensionMixSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPreWashResuspensionMixSamples] == 0,
                Test["Our prewash mix options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--6. Check that Activate boolean and activation options are compatible--*)

  (*Map over all input pools to check if activation options are compatible*)
  invalidActivationOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{activateOption,activationParameters,suppliedActivationOptions,suppliedNullActivationOptions},

        (*Find activate boolean value*)
        activateOption = Lookup[sampleOptions,Activate];

        (*Gather other activation options*)
        activationParameters=FilterRules[Normal@sampleOptions,{ActivationReactionVolume, TargetActivationSampleConcentration,ActivationSampleVolume,ActivationReagent,TargetActivationReagentConcentration, ActivationReagentVolume, ActivationDiluent,ActivationDiluentVolume, ActivationTime,ActivationTemperature}];

        (*Find any activation options that are user specified*)
        suppliedNullActivationOptions = Select[activationParameters, MatchQ[Values[#],Null]&];
        suppliedActivationOptions = Select[activationParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

        (*Return the appropriate invalid options given the Activate option*)
        Switch[activateOption,
          (*If Activate is True return Null options and input sample*)
          True, {sample,Keys@suppliedNullActivationOptions},
          (*If Activate is False return non-Null options and input sample*)
          False,{sample,Keys@suppliedActivationOptions},
          Automatic, {{},{}}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  (*Filter out samples with {} invalid options*)
  filteredInvalidActivateList = Select[invalidActivationOptionsMapThread,!MatchQ[#[[2]],{}]&];

  (*Separate out invalid options map thread output*)
  If[Length[filteredInvalidActivateList]>0,
    {
      invalidActivateSamples = filteredInvalidActivateList[[All, 1]];
      invalidActivateOptions = filteredInvalidActivateList[[All, 2]];
    },
    {
      invalidActivateSamples = {};
      invalidActivateOptions = {};
    }
  ];

  (*Throw an error if invalidPreWashResuspension Options is not {}*)
  If[
    Length[invalidActivateSamples]>0&&messages,
    Message[Error::ConflictingActivationOptions,invalidActivateSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidActivationTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidActivateSamples] > 0,
                Test["Our activation options are compatible for the inputs "<>ObjectToString[invalidActivateSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidActivateSamples] == 0,
                Test["Our activation options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--7. Check that ActivationMix boolean and ActivationMix options are compatible--*)

  (*Map over all input pools to check if activation mix options are compatible*)
  invalidActivationMixOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{activationMixOption,activationMixTypeOption,activationMixParameters},

        (*Find activation mix boolean value and mix type*)
        activationMixOption = Lookup[sampleOptions,ActivationMix];
        activationMixTypeOption = Lookup[sampleOptions, ActivationMixType];

        (*Gather other activation mix options*)
        activationMixParameters=FilterRules[Normal@sampleOptions,{ActivationMixVolume,ActivationNumberOfMixes,ActivationMixRate}];

        (*Return the appropriate invalid options given the Activate option*)
        Switch[{activationMixOption,activationMixTypeOption},

          {True,Invert}, If[MatchQ[Values[activationMixParameters],{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],sample,{}],

          {True,Pipette}, If[MatchQ[Values[activationMixParameters],{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],sample,{}],

          {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[Values[activationMixParameters],{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],sample,{}],

          {True, Null}, sample,

          {False, Except[Null|Automatic]}, sample,

          {_,_}, {}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  invalidActivationMixSamples = Flatten@invalidActivationMixOptionsMapThread;
  invalidActivationMixOptions = If[Length[invalidActivationMixSamples]>0,{ActivationMix,ActivationMixType,ActivationMixVolume,ActivationNumberOfMixes,ActivationMixRate},{}];

  (*Throw an error if invalidActivationMixSamples is not {}*)
  If[
    Length[invalidActivationMixSamples]>0&&messages,
    Message[Error::ConflictingActivationMixOptions,invalidActivationMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidActivationMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidActivationMixSamples] > 0,
                Test["Our activation mix options are compatible for the inputs "<>ObjectToString[invalidActivationMixSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidActivationMixSamples] == 0,
                Test["Our activation mix options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--8. Check that PostActivationWash boolean and PostActivationWash options are compatible--*)

  (*Map over all input pools to check if postactivationwash options are compatible*)
  invalidPostActivationWashOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{postActivationWashOption,postActivationWashParameters,suppliedPostActivationWashOptions,suppliedNullPostActivationWashOptions},

        (*Find postactivationwash boolean value*)
        postActivationWashOption = Lookup[sampleOptions,PostActivationWash];

        (*Gather other postactivation wash options*)
        postActivationWashParameters=FilterRules[Normal@sampleOptions,{PostActivationWashMethod,PostActivationNumberOfWashes,PostActivationWashInstrument,PostActivationWashTime,PostActivationWashTemperature,PostActivationWashBuffer,PostActivationWashBufferVolume}];

        (*Find any post activation wash options that are user specified*)
        suppliedNullPostActivationWashOptions = Select[postActivationWashParameters, MatchQ[Values[#],Null]&];
        suppliedPostActivationWashOptions = Select[postActivationWashParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

        (*Return the appropriate invalid options given the PostActivationWash option*)
        Switch[postActivationWashOption,
          (*If PostActivation is True return Null options and input sample*)
          True, {sample,Keys@suppliedNullPostActivationWashOptions},
          (*If PostActivation is False return non-Null options and input sample*)
          False,{sample,Keys@suppliedPostActivationWashOptions},
          Automatic,{{},{}}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  (*Filter out samples with {} invalid options*)
  filteredInvalidPostActivationWashList = Select[invalidPostActivationWashOptionsMapThread,!MatchQ[#[[2]],{}]&];

  (*Separate out invalid PostActivationWash options map thread output*)
  If[Length[filteredInvalidPostActivationWashList]>0,
    {
      invalidPostActivationWashSamples = filteredInvalidPostActivationWashList[[All, 1]];
      invalidPostActivationwWashOptions = filteredInvalidPostActivationWashList[[All, 2]];
    },
    {
      invalidPostActivationWashSamples = {};
      invalidPostActivationwWashOptions = {};
    }
  ];

  (*Throw an error if invalidPostActivationWashSamples is not {}*)
  If[
    Length[invalidPostActivationWashSamples]>0&&messages,
    Message[Error::ConflictingPostActivationWashOptions,invalidPostActivationWashSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostActivationWashTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPostActivationWashSamples] > 0,
                Test["Our PostActivationWash options are compatible for the inputs "<>ObjectToString[invalidPostActivationWashSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPostActivationWashSamples] == 0,
                Test["Our PostActivationWash options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--9. Check that PostActivationWashMix boolean and PostActivationWashMix options are compatible--*)

  (*Map over all input pools to check if PostActivationWashMix options are compatible*)
  invalidPostActivationWashMixOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{postActivationWashMixOption,postActivationWashMixTypeOption,postActivationWashParameters},

        (*Find prewash mix boolean value and mix type*)
        postActivationWashMixOption = Lookup[sampleOptions,PostActivationWashMix];
        postActivationWashMixTypeOption = Lookup[sampleOptions, PostActivationWashMixType];

        (*Gather other prewash mix options*)
        postActivationWashParameters=FilterRules[Normal@sampleOptions,{PostActivationWashMixVolume,PostActivationWashNumberOfMixes,PostActivationWashMixRate}];

        (*Return the appropriate invalid options given the PostActivationMix and PostActivationMixType options*)
        Switch[{postActivationWashMixOption,postActivationWashMixTypeOption},

          {True,Invert}, If[MatchQ[Values[postActivationWashParameters],{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],sample,{}],

          {True,Pipette}, If[MatchQ[Values[postActivationWashParameters],{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],sample,{}],

          {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[Values[postActivationWashParameters],{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],sample,{}],

          {True, Null}, sample,

          {False, Except[Null|Automatic]}, sample,

          {_,_}, {}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  invalidPostActivationWashMixSamples = Flatten@invalidPostActivationWashMixOptionsMapThread;
  invalidPostActivationWashMixOptions = If[Length[invalidPostActivationWashMixSamples]>0,{PostActivationWashMix,PostActivationWashMixType,PostActivationWashMixVolume,PostActivationWashNumberOfMixes,PostActivationWashMixRate},{}];

  (*Throw an error if invalidPostActivationWashMix Options is not {}*)
  If[
    Length[invalidPostActivationWashMixSamples]>0&&messages,
    Message[Error::ConflictingPostActivationWashMixOptions,invalidPostActivationWashMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostActivationWashMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPostActivationWashMixSamples] > 0,
                Test["Our PostActivationWashMix options are compatible for the inputs "<>ObjectToString[invalidPostActivationWashMixSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPostActivationWashMixSamples] == 0,
                Test["Our PostActivationWashMix options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--10. Check that PostActivationResuspension boolean and PostActivationResuspension options are compatible--*)

  (*Map over all input pools to check if PostActivationResuspension options are compatible*)
  invalidPostActivationResuspensionOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{postActivationResuspensionOption,postActivationResuspensionParameters,suppliedPostActivationResuspensionOptions,suppliedNullPostActivationResuspensionOptions},

        (*Find resuspension boolean value*)
        postActivationResuspensionOption = Lookup[sampleOptions,PostActivationResuspension];

        (*Gather other resuspensoin options*)
        postActivationResuspensionParameters=FilterRules[Normal@sampleOptions,{PostActivationResuspensionTime, PostActivationResuspensionTemperature, PostActivationResuspensionDiluent, PostActivationResuspensionDiluentVolume}];

        (*Find any resuspension options that are user specified*)
        suppliedNullPostActivationResuspensionOptions = Select[postActivationResuspensionParameters, MatchQ[Values[#],Null]&];
        suppliedPostActivationResuspensionOptions = Select[postActivationResuspensionParameters, !MatchQ[Values[#],Alternatives[Automatic,Null]]&];

        (*Return the appropriate invalid options given the PostActivationResuspension option*)
        Switch[postActivationResuspensionOption,
          (*If postActivationResuspensionOption is True return Null options and input sample*)
          True, {sample,Keys@suppliedNullPostActivationResuspensionOptions},
          (*If PreWashResuspension is False return non-Null options and input sample*)
          False,{sample,Keys@suppliedPostActivationResuspensionOptions},
          Automatic, {{},{}}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  (*Filter out samples with {} invalid options*)
  filteredInvalidPostActivationResuspensionList = Select[invalidPostActivationResuspensionOptionsMapThread,!MatchQ[#[[2]],{}]&];

  (*Separate out invalid resuspension options map thread output*)
  If[Length[filteredInvalidPostActivationResuspensionList]>0,
    {
      invalidPostActivationResuspensionSamples = filteredInvalidPostActivationResuspensionList[[All, 1]];
      invalidPostActivationResuspensionOptions = filteredInvalidPostActivationResuspensionList[[All, 2]];
    },
    {
      invalidPostActivationResuspensionSamples = {};
      invalidPostActivationResuspensionOptions = {};
    }
  ];

  (*Throw an error if invalidPostActivationResuspensionSamples is not {}*)
  If[
    Length[invalidPostActivationResuspensionSamples]>0&&messages,
    Message[Error::ConflictingPostActivationResuspensionOptions,invalidPostActivationResuspensionSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostActivationResuspensionTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPostActivationResuspensionSamples] > 0,
                Test["Our PostActivationResuspension options are compatible for the inputs "<>ObjectToString[invalidPostActivationResuspensionSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPostActivationResuspensionSamples] == 0,
                Test["Our PostActivationResuspension options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--11. Check that PostActivationResuspensionMix boolean and PostActivationResuspenionMix options are compatible--*)

  (*Map over all input pools to check if postactivation resuspension mix options are compatible*)
  invalidPostActivationResuspensionMixOptionsMapThread=MapThread[
    Function[ {sampleOptions,sample},
      Module[{postActivationResuspensionMixOption,postActivationResuspensionMixTypeOption,postActivationResuspensionMixParameters},

        (*Find postactivationresuspension mix boolean value and mix type*)
        postActivationResuspensionMixOption = Lookup[sampleOptions,PostActivationResuspensionMix];
        postActivationResuspensionMixTypeOption = Lookup[sampleOptions, PostActivationResuspensionMixType];

        (*Gather other postactivation mix options*)
        postActivationResuspensionMixParameters=FilterRules[Normal@sampleOptions,{PostActivationResuspensionMixVolume,PostActivationResuspensionNumberOfMixes,PostActivationResuspensionMixRate}];

        (*Return the appropriate invalid options given the PostActivationResuspensionMix option*)
        Switch[{postActivationResuspensionMixOption,postActivationResuspensionMixTypeOption},

          {True,Invert}, If[MatchQ[Values[postActivationResuspensionMixParameters],{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],sample,{}],

          {True,Pipette}, If[MatchQ[Values[postActivationResuspensionMixParameters],{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],sample,{}],

          {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[Values[postActivationResuspensionMixParameters],{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],sample,{}],

          {True, Null}, sample,

          {False, Except[Null|Automatic]}, sample,

          {_,_}, {}
        ]
      ]
    ],
    {flatSamplesMapThreadFriendlyOptions,Flatten@myPooledSamples}
  ];

  invalidPostActivationResuspensionMixSamples = Flatten@invalidPostActivationResuspensionMixOptionsMapThread;
  invalidPostActivationResuspensionMixOptions = If[Length[invalidPostActivationResuspensionMixSamples]>0,{PostActivationResuspensionMix,PostActivationResuspensionMixType,PostActivationResuspensionMixVolume,PostActivationResuspensionNumberOfMixes,PostActivationResuspensionMixRate},{}];

  (*Throw an error if invalidPostActivationResuspensionMixSamples is not {}*)
  If[
    Length[invalidPostActivationResuspensionMixSamples]>0&&messages,
    Message[Error::ConflictingPostActivationResuspensionMixOptions,invalidPostActivationResuspensionMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostActivationResuspensionMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPostActivationResuspensionMixSamples] > 0,
                Test["Our PostActivationResuspensionMix options are compatible for the inputs "<>ObjectToString[invalidPostActivationResuspensionMixSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPostActivationResuspensionMixSamples] == 0,
                Test["Our PostActivationResuspensionMix options are compatible for the inputs "<>ObjectToString[Flatten@myPooledSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 12. Check that both ConjugationReactionBuffer  and ConcentratedConjugationReactionBuffer options are not specified. We can only have one buffer option or no buffer options suggesting the samples are pooled together and no addition reagents are added. --*)

  (*Find ConjugationReactionBuffer and ConcentratedConjugationReactionBuffer values*)
  conjugationBuffers = Lookup[mapThreadFriendlyOptions,{ConjugationReactionBuffer,ConcentratedConjugationReactionBuffer}];

  (*Find which options pairs have both ConjugationReactionBuffer and ConcentratedConjugationBuffer specified.*)
  tooManyBuffersBool =MatchQ[#,{Except[Null],Except[Null]}]&/@conjugationBuffers;

  (*Get the conjugation pools that have too many buffer options*)
  tooManyBuffersSamples = PickList[myPooledSamples,tooManyBuffersBool,True];
  tooManyBuffersOptions = If[Length[tooManyBuffersSamples]>0,{ConjugationReactionBuffer,ConcentratedConjugationReactionBuffer},{}];

  (*Throw an error if tooManyBufferOptionsSamples is not {}*)
  If[
    Length[tooManyBuffersSamples]>0&&messages,
    Message[Error::TooManyConjugationBuffers,tooManyBuffersSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationBufferTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[tooManyBuffersSamples] > 0,
                Test["For each conjugation pool only ConjugationReactionBuffer or ConcentratedConjugationReactionBuffer are specified and not both:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[tooManyBuffersSamples] == 0,
                Test["For each conjugation pool only ConjugationReactionBuffer or ConcentratedConjugationReactionBuffer are specified and not both:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 12.1. Check both ConjugationReactionBuffer and ConcentrationConjugationReactionBuffer are Null, that ConjugationReactionBufferVolume is also Null. --*)

  (*Find ConjugationReactionBuffer and ConcentratedConjugationReactionBuffer values*)
  conjugationBuffersAndVolume = Lookup[mapThreadFriendlyOptions,{ConjugationReactionBuffer,ConcentratedConjugationReactionBuffer,ConjugationReactionBufferVolume}];

  (*Find which options pairs have both ConjugationReactionBuffer and ConcentratedConjugationBuffer specified.*)
  invalidConjugationBufferVolume =If[MatchQ[#,{Null,Null, Except[Null|Automatic]}],True,False]&/@conjugationBuffersAndVolume;

  (*Get the conjugation pools that have too many buffer options*)
  tooFewConjugationBuffersSamples = PickList[myPooledSamples,invalidConjugationBufferVolume,True];
  tooFewConjugationBuffersOptions = If[Length[tooFewConjugationBuffersSamples]>0,{ConjugationReactionBuffer,ConcentratedConjugationReactionBuffer, ConjugationReactionBufferVolume},{}];

  (*Throw an error if tooManyBufferOptionsSamples is not {}*)
  If[
    Length[tooFewConjugationBuffersSamples]>0&&messages,
    Message[Error::TooFewConjugationBuffers,tooFewConjugationBuffersSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  tooFewConjugationBufferTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[tooFewConjugationBuffersSamples] > 0,
                Test["For each conjugation pool either ConjugationReactionBuffer or ConcentratedConjugationReactionBuffer are specified when ConjugationReactionBufferVolume is specified:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[tooFewConjugationBuffersSamples] == 0,
                Test["For each conjugation pool either ConjugationReactionBuffer or ConcentratedConjugationReactionBuffer are specified when ConjugationReactionBufferVolume is specified:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 13. Check if ConjugationReactionBuffer  is specifed that ConcentratedConjugationReactionBuffer options are not specified.*)

  (*Find ConjugationReactionBuffer*)
  conjugationBufferOptions = Lookup[mapThreadFriendlyOptions,ConjugationReactionBuffer];

  (*Find the ConcentratedConjugationReactionBufferCptions*)
  concConjugationBufferOptions = Lookup[mapThreadFriendlyOptions,{ConcentratedConjugationReactionBufferDilutionFactor,ConjugationReactionBufferDiluent,ConjugationDiluentVolume}];

  (*Create PickList booleans.*)
  tooManyBufferOptionsBool = MapThread[
    Switch[{#1,MemberQ[#2,Except[Null|Automatic]]},
      {Except[Null],True}, True,
      {_,_}, False
    ]&,
    {conjugationBufferOptions,concConjugationBufferOptions}
  ];

  (*Get the conjugation pools that have too many buffer options*)
  tooManyBufferOptionsSamples = PickList[myPooledSamples,tooManyBufferOptionsBool,True];
  tooManyBufferOptionsOptions = If[Length[tooManyBufferOptionsSamples]>0,{ConjugationReactionBuffer,ConcentratedConjugationReactionBufferDilutionFactor,ConjugationReactionBufferDiluent,ConjugationDiluentVolume},{}];

  (*Throw an error if tooManyBufferOptionsSamples is not {}*)
  If[
    Length[tooManyBufferOptionsSamples]>0&&messages,
    Message[Error::TooManyConjugationBufferOptions,tooManyBufferOptionsSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationBufferOptionsTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[tooManyBufferOptionsSamples] > 0,
                Test["For each conjugation pool with a specified ConjugationReactionBuffer, no ConcentratedConjugationReactionBuffer options are specified:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[tooManyBufferOptionsSamples] == 0,
                Test["For each conjugation pool with a specified ConjugationReactionBuffer, no ConcentratedConjugationReactionBuffer options are specified:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 14. Check if ConcentratedConjugationReactionBuffer  is specifed that ConcentratedConjugationReactionBuffer options are not Null and vice versa.*)

  (*Find ConcentratedConjugationReactionBuffer option*)
  concConjugationBuffer = Lookup[mapThreadFriendlyOptions,ConcentratedConjugationReactionBuffer];

  (*Find the ConcentratedConjugationReactionBufferCptions*)
  concConjugationBufferOptions = Lookup[mapThreadFriendlyOptions,{ConcentratedConjugationReactionBufferDilutionFactor,ConjugationReactionBufferDiluent,ConjugationDiluentVolume}];

  (*Create PickList booleans.*)
  conflictingConcBufferOptionsBool = MapThread[
    Switch[{#1,MemberQ[#2,Null],MemberQ[#2,Except[Null|Automatic]]},
      {Except[Null],True,_}, True,
      {Null,_,True}, True,
      {_,_}, False
    ]&,
    {concConjugationBuffer,concConjugationBufferOptions}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingConcBufferSamples = PickList[myPooledSamples,conflictingConcBufferOptionsBool,True];
  conflictingConcBufferOptions = If[Length[conflictingConcBufferSamples]>0,{ConcentratedConjugationReactionBuffer,ConcentratedConjugationReactionBufferDilutionFactor,ConjugationReactionBufferDiluent,ConjugationDiluentVolume},{}];

  (*Throw an error if conflictingConcBufferSamples is not {}*)
  If[
    Length[conflictingConcBufferSamples]>0&&messages,
    Message[Error::ConflictingConcentratedConjugationBufferOptions,conflictingConcBufferSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConcentratedConjugationBufferTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingConcBufferSamples] > 0,
                Test["For each conjugation pool ConcentratedConjugationReactionBuffer and ConcentrationConjugationReactionBuffer options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingConcBufferSamples] == 0,
                Test["For each conjugation pool ConcentratedConjugationReactionBuffer and ConcentrationConjugationReactionBuffer options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];


  (*-- 15. Check that ConjugationMix is compatible with ConjugationMix options.*)

  (*Find ConjugationMix option*)
  conjugationMixOption = Lookup[mapThreadFriendlyOptions,ConjugationMix];
  conjugationMixTypeOption = Lookup[mapThreadFriendlyOptions,ConjugationMixType];

  (*Find the mix related parameters*)
  conjugationMixParameters = Lookup[mapThreadFriendlyOptions,{ConjugationMixVolume,ConjugationNumberOfMixes,ConjugationMixRate}];

  (*Create PickList booleans.*)
  conflictingMixOptionsBool = MapThread[
    Switch[{#1,#2},
      {True,Invert}, If[MatchQ[#3,{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],True,False],

      {True,Pipette}, If[MatchQ[#3,{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],True,False],

      {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[#3,{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],True,False],

      {True, Null}, True,

      {False, Except[Null|Automatic]}, True,

      {_,_}, False
    ]&,
    {conjugationMixOption,conjugationMixTypeOption,conjugationMixParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingConjugationMixSamples = PickList[myPooledSamples,conflictingMixOptionsBool,True];
  conflictingConjugationMixOptions = If[Length[conflictingConjugationMixSamples]>0,{ConjugationMix,ConjugationMixType,ConjugationMixVolume,ConjugationNumberOfMixes,ConjugationMixRate},{}];

  (*Throw an error if conflictingConjugationMixSamples is not {}*)
  If[
    Length[conflictingConjugationMixSamples]>0&&messages,
    Message[Error::ConflictingConjugationMixOptions,conflictingConjugationMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingConjugationMixSamples] > 0,
                Test["For each conjugation pool ConjugationMix and corresponding mix options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingConjugationMixSamples] == 0,
                Test["For each conjugation pool ConjugationMix and corresponding mix options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 15. Check that QuenchConjugation boolean is compatible with QuenchConjugation options.*)

  (*Find QuenchConjugation option*)
  quenchOption = Lookup[mapThreadFriendlyOptions,QuenchConjugation];

  (*Find the quenching related parameters*)
  quenchParameters = Lookup[mapThreadFriendlyOptions,{ QuenchReactionVolume,QuenchReagent, QuenchReagentDilutionFactor, QuenchReagentVolume, QuenchTime,QuenchTemperature}];

  (*Create PickList booleans.*)
  conflictingQuenchBool = MapThread[
    Switch[{#1,MemberQ[#2,Null],MemberQ[#2,Except[Null|Automatic]]},
      {True,True,_}, True,

      {False,_,True}, True,

      {_,_,_}, False
    ]&,
    {quenchOption,quenchParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingQuenchSamples = PickList[myPooledSamples,conflictingQuenchBool,True];
  conflictingQuenchOptions = If[Length[conflictingQuenchSamples]>0,{QuenchConjugation, QuenchReactionVolume,QuenchReagent, QuenchReagentDilutionFactor, QuenchReagentVolume, QuenchTime,QuenchTemperature},{}];

  (*Throw an error if conflictingQuenchSamples is not {}*)
  If[
    Length[conflictingQuenchSamples]>0&&messages,
    Message[Error::ConflictingQuenchOptions,conflictingQuenchSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidQuenchOptionsTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingQuenchSamples] > 0,
                Test["For each conjugation pool QuenchConjugation and corresponding quenching options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingQuenchSamples] == 0,
                Test["For each conjugation pool QuenchConjugation and corresponding quenching options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 16. Check that PredrainReactionMixture boolean is compatible with Predrain options.*)

  (*Find PredrainReactionMixture option*)
  predrainOption = Lookup[mapThreadFriendlyOptions,PredrainReactionMixture];

  (*Find the Predrain related parameters*)
  predrainParameters = Lookup[mapThreadFriendlyOptions,{PredrainMethod,PredrainInstrument,PredrainCentrifugationIntensity,PredrainCentrifugationTime,PredrainTemperature}];

  (*Create PickList booleans.*)
  conflictingPredrainBool = MapThread[
    Switch[{#1,MemberQ[#2,Null],MemberQ[#2,Except[Null|Automatic]]},
      {True,True,_}, True,

      {False,_,True}, True,

      {_,_,_}, False
    ]&,
    {predrainOption,predrainParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingPredrainSamples = PickList[myPooledSamples,conflictingPredrainBool,True];
  conflictingPredrainOptions = If[Length[conflictingPredrainSamples]>0,{PredrainReactionMixture,PredrainMethod,PredrainInstrument,PredrainCentrifugationIntensity,PredrainCentrifugationTime,PredrainTemperature},{}];

  (*Throw an error if conflictingPredrainSamples is not {}*)
  If[
    Length[conflictingPredrainSamples]>0&&messages,
    Message[Error::ConflictingPredrainReactionMixtureOptions,conflictingPredrainSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPredrainOptionsTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingPredrainSamples] > 0,
                Test["For each conjugation pool PredrainReactionMixture and corresponding predrain options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingPredrainSamples] == 0,
                Test["For each conjugation pool PredrainReactionMixture and corresponding predrain options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];


  (*-- 17. Check that QuenchMix is compatible with QuenchMix options.*)

  (*Find QuenchMix option*)
  quenchMixOption = Lookup[mapThreadFriendlyOptions,QuenchMix];
  quenchMixTypeOption = Lookup[mapThreadFriendlyOptions,QuenchMixType];

  (*Find the mix related parameters*)
  quenchMixParameters = Lookup[mapThreadFriendlyOptions,{QuenchMixVolume,QuenchNumberOfMixes,QuenchMixRate}];

  (*Create PickList booleans.*)
  conflictingQuenchMixOptionsBool = MapThread[
    Switch[{#1,#2},
      {True,Invert}, If[MatchQ[#3,{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],True,False],

      {True,Pipette}, If[MatchQ[#3,{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],True,False],

      {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[#3,{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],True,False],

      {True, Null, _}, True,

      {False, Except[Null|Automatic], _}, True,

      {_,_,_}, False
    ]&,
    {quenchMixOption,quenchMixTypeOption,quenchMixParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingQuenchMixSamples = PickList[myPooledSamples,conflictingQuenchMixOptionsBool,True];
  conflictingQuenchMixOptions = If[Length[conflictingQuenchMixSamples]>0,{QuenchMix,QuenchMixType,QuenchMixVolume,QuenchNumberOfMixes,QuenchMixRate},{}];

  (*Throw an error if conflictingQuenchMixSamples is not {}*)
  If[
    Length[conflictingQuenchMixSamples]>0&&messages,
    Message[Error::ConflictingQuenchMixOptions,conflictingQuenchMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidQuenchMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingQuenchMixSamples] > 0,
                Test["For each conjugation pool ConjugationMix and corresponding mix options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingQuenchMixSamples] == 0,
                Test["For each conjugation pool ConjugationMix and corresponding mix options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 18. Check that PostConjugationWorkup boolean is compatible with PostConjugation options.*)

  (*Find PostConjugationWorkup option*)
  postConjugationWorkupOption = Lookup[mapThreadFriendlyOptions,PostConjugationWorkup];

  (*Find the PostConjugationWorkup related parameters*)
  postConjugationWorkupParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationWorkupMethod, PostConjugationWorkupIncubationTime, PostConjugationWorkupIncubationTemperature}];

  (*Create PickList booleans.*)
  conflictingWorkupBool = MapThread[
    Switch[{#1,MemberQ[#2,Null],MemberQ[#2,Except[Null|Automatic]]},
      {True,True,_}, True,

      {False,_,True}, True,

      {_,_,_}, False
    ]&,
    {postConjugationWorkupOption,postConjugationWorkupParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingWorkupSamples = PickList[myPooledSamples,conflictingWorkupBool,True];
  conflictingWorkupOptions = If[Length[conflictingWorkupSamples]>0,{PostConjugationWorkup,PostConjugationWorkupMethod, PostConjugationWorkupIncubationTime, PostConjugationWorkupIncubationTemperature},{}];

  (*Throw an error if conflictingWorkupSamples is not {}*)
  If[
    Length[conflictingWorkupSamples]>0&&messages,
    Message[Error::ConflictingPostConjugationWorkupOptions,conflictingWorkupSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationWorkupOptionsTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingWorkupSamples] > 0,
                Test["For each conjugation pool PostConjugationWorkup and corresponding workup options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingWorkupSamples] == 0,
                Test["For each conjugation pool PostConjugationWorkup and corresponding workup options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 19. Check that PostConjugationWorkupMix is compatible with PostConjugationWorkupMix options.*)

  (*Find PostConjugationWorkupMix option*)
  workupMixOption = Lookup[mapThreadFriendlyOptions,PostConjugationWorkupMix];
  workupMixTypeOption = Lookup[mapThreadFriendlyOptions,PostConjugationWorkupMixType];

  (*Find the mix related parameters*)
  workupMixParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationWorkupMixVolume,PostConjugationWorkupNumberOfMixes,PostConjugationWorkupMixRate}];

  (*Create PickList booleans.*)
  conflictingWorkupMixOptionsBool = MapThread[
    Switch[{#1,#2},
      {True,Invert}, If[MatchQ[#3,{Except[Null|Automatic],_,_}|{_,_,Except[Null|Automatic]}|{_,Null,_}],True,False],

      {True,Pipette}, If[MatchQ[#3,{_,_,Except[Null|Automatic]}|{_,Null,_}|{Null,_,_}],True,False],

      {True, Except[Invert|Pipette|Null|Automatic]}, If[MatchQ[#3,{_,Except[Null|Automatic],_}|{Except[Null|Automatic],_,_}|{_,_,Null}],True,False],

      {True, Null}, True,

      {False, Except[Null|Automatic]}, True,

      {_,_,_}, False
    ]&,
    {workupMixOption,workupMixTypeOption,workupMixParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingWorkupMixSamples = PickList[myPooledSamples,conflictingWorkupMixOptionsBool,True];
  conflictingWorkupMixOptions = If[Length[conflictingWorkupMixSamples]>0,{PostConjugationWorkupMix,PostConjugationWorkupMixType,PostConjugationWorkupMixVolume,PostConjugationWorkupNumberOfMixes,PostConjugationWorkupMixRate},{}];

  (*Throw an error if conflictingQuenchMixSamples is not {}*)
  If[
    Length[conflictingWorkupMixSamples]>0&&messages,
    Message[Error::ConflictingPostConjugationWorkupMixOptions,conflictingWorkupMixSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingWorkupMixSamples] > 0,
                Test["For each conjugation pool PostConjugationWorkupMix and corresponding mix options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingWorkupMixSamples] == 0,
                Test["For each conjugation pool PostConjugationWorkupMix and corresponding mix options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 20. Check that PostConjugationResuspension boolean is compatible with PostConjugationResuspension options.*)

  (*Find PostConjugationResuspension option*)
  postConjugationResuspensionOption = Lookup[mapThreadFriendlyOptions,PostConjugationResuspension];

  (*Find the PostConjugationResuspension related parameters*)
  postConjugationResuspensionParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationResuspensionDiluent,PostConjugationResuspensionDiluentVolume,PostConjugationResuspensionMix,PostConjugationResuspensionTemperature}];

  (*Create PickList booleans.*)
  conflictingPostConjugationResuspensionBool = MapThread[
    Switch[{#1,MemberQ[#2,Null],MemberQ[#2,Except[Null|Automatic]]},
      {True,True,_}, True,

      {False,_,True}, True,

      {_,_,_}, False
    ]&,
    {postConjugationResuspensionOption,postConjugationResuspensionParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingPostConjugationResuspensionSamples = PickList[myPooledSamples,conflictingPostConjugationResuspensionBool,True];
  conflictingPostConjugationResuspensionOptions = If[Length[conflictingPostConjugationResuspensionSamples]>0,{PostConjugationResuspension,PostConjugationResuspensionDiluent,PostConjugationResuspensionDiluentVolume,PostConjugationResuspensionMix,PostConjugationResuspensionTemperature},{}];

  (*Throw an error if conflictingWorkupSamples is not {}*)
  If[
    Length[conflictingPostConjugationResuspensionSamples]>0&&messages,
    Message[Error::ConflictingPostConjugationResuspensionOptions,conflictingPostConjugationResuspensionSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationResuspensionOptionsTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingPostConjugationResuspensionSamples] > 0,
                Test["For each conjugation pool PostConjugationResuspension and corresponding resuspension options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingPostConjugationResuspensionSamples] == 0,
                Test["For each conjugation pool PostConjugationResuspension and corresponding resuspension options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 21. Check that PostConjugationResuspensionMix is compatible with PostConjugationResuspensionMix options.*)

  (*Find PostConjugationResuspensionMix option*)
  workupResuspensionMixOption = Lookup[mapThreadFriendlyOptions,PostConjugationResuspensionMix];
  workupResuspensionMixTypeOption = Lookup[mapThreadFriendlyOptions,PostConjugationResuspensionMixType];

  (*Find the mix related parameters*)
  workupResuspensionInvertParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationResuspensionNumberOfMixes}];
  workupResuspensionPipetteParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationResuspensionMixVolume,PostConjugationResuspensionNumberOfMixes}];
  workupResuspensionMixParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationResuspensionMixRate,PostConjugationResuspensionTime}];

  (*Create PickList booleans.*)
  conflictingInvertMixBool = MapThread[
    Switch[{#1,#2,MemberQ[#3,Null],MemberQ[#4,Except[Null|Automatic]],MemberQ[#5,Except[Null|Automatic]]},

      {True,Invert,True,_,_}, True,

      {True,Invert,_,True,_}, True,

      {True,Invert,_,_,True}, True,

      {False,Invert,_,_,_}, True,

      {_,_,_,_,_}, False

    ]&,
    {workupResuspensionMixOption,workupResuspensionMixTypeOption,workupResuspensionInvertParameters,workupResuspensionPipetteParameters,workupResuspensionMixParameters}
  ];

  conflictingPipetteMixBool = MapThread[
    Switch[{#1,#2,MemberQ[#3,Except[Null|Automatic]],MemberQ[#4,Null],MemberQ[#5,Except[Null|Automatic]]},

      {True,Pipette,True,_,_}, True,

      {True,Pipette,_,True,_}, True,

      {True,Pipette,_,_,True}, True,

      {False, Pipette, _, _, _}, True,

      {_,_,_,_,_}, False

    ]&,
    {workupResuspensionMixOption,workupResuspensionMixTypeOption,workupResuspensionInvertParameters,workupResuspensionPipetteParameters,workupResuspensionMixParameters}
  ];

  conflictingMixBool = MapThread[
    Switch[{#1,#2,MemberQ[#3,Except[Null|Automatic]],MemberQ[#4,Except[Null|Automatic]],MemberQ[#5,Null]},

      {True,Except[Pipette|Invert|Automatic],True,_,_}, True,

      {True,Except[Pipette|Invert|Automatic],_,True,_}, True,

      {True,Except[Pipette|Invert|Automatic],_,_,True}, True,

      {False,Except[Pipette|Invert|Automatic],_,_,_}, True,

      {_,_,_,_,_}, False

    ]&,
    {workupResuspensionMixOption,workupResuspensionMixTypeOption,workupResuspensionInvertParameters,workupResuspensionPipetteParameters,workupResuspensionMixParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingWorkupResuspensionInvertSamples = PickList[myPooledSamples,conflictingInvertMixBool,True];
  conflictingWorkupResuspensionPipetteSamples = PickList[myPooledSamples,conflictingPipetteMixBool,True];
  conflictingWorkupResuspensionMixSamples = PickList[myPooledSamples,conflictingMixBool,True];
  conflictingWorkupResuspensionMixSamplesFull = DeleteDuplicates@Join[conflictingWorkupResuspensionInvertSamples,conflictingWorkupResuspensionPipetteSamples,conflictingWorkupResuspensionMixSamples];
  conflictingWorkupResuspensionMixOptions = If[Length[conflictingWorkupResuspensionMixSamplesFull]>0,{PostConjugationResuspensionMix,PostConjugationResuspensionMixType,PostConjugationResuspensionNumberOfMixes,PostConjugationResuspensionMixVolume,PostConjugationResuspensionMixRate,PostConjugationResuspensionTime},{}];

  (*Throw an error if conflictingWorkupResuspensionMixSamplesFull is not {}*)
  If[
    Length[conflictingWorkupResuspensionMixSamplesFull]>0&&messages,
    Message[Error::ConflictingPostConjugationResuspensionMixOptions,conflictingWorkupResuspensionMixSamplesFull],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationResuspensionMixTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingWorkupResuspensionMixSamplesFull] > 0,
                Test["For each conjugation pool PostConjugationResuspensionMix and corresponding mix options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingWorkupResuspensionMixSamplesFull] == 0,
                Test["For each conjugation pool PostConjugationResuspensionMix and corresponding mix options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*-- 22. Check that PostConjugationResuspensionMixUntilDissolved boolean is compatible with PostConjugationResuspensionMixUntilDissolved options.*)

  (*Find PostConjugationResuspensionMixUntilDissolved option*)
  postConjugationDissolveOption = Lookup[mapThreadFriendlyOptions,PostConjugationResuspensionMixUntilDissolved];

  (*Find the PostConjugationResuspensionMixUntilDissolved related parameters*)
  postConjugationDissolveParameters = Lookup[mapThreadFriendlyOptions,{PostConjugationResuspensionMaxNumberOfMixes,PostConjugationResuspensionMaxTime}];

  (*Create PickList booleans.*)
  conflictingPostConjugationDissolveBool = MapThread[
    Switch[{#1,MemberQ[#2,Null],MemberQ[#2,Except[Null|Automatic]]},
      {True,True,_}, True,

      {False,_,True}, True,

      {_,_,_}, False
    ]&,
    {postConjugationDissolveOption,postConjugationDissolveParameters}
  ];

  (*Get the conjugation pools that have conflicting options*)
  conflictingPostConjugationDissolveSamples = PickList[myPooledSamples,conflictingPostConjugationDissolveBool,True];
  conflictingPostConjugationDissolveOptions = If[Length[conflictingPostConjugationDissolveSamples]>0,{PostConjugationResuspensionMixUntilDissolved,PostConjugationResuspensionMaxNumberOfMixes,PostConjugationResuspensionMaxTime},{}];

  (*Throw an error if conflictingPostConjugationDissolveSamples is not {}*)
  If[
    Length[conflictingPostConjugationDissolveSamples]>0&&messages,
    Message[Error::ConflictingPostConjugationMixUntilDissolvedOptions,conflictingPostConjugationDissolveSamples],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationMixUntilDissolvedOptionsTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[conflictingPostConjugationDissolveSamples] > 0,
                Test["For each conjugation pool PostConjugationResuspensionMixUntilDissolved and corresponding mix until dissolved options do not conflict:", True, False],
                Nothing
              ];
          passingTest =
              If[Length[conflictingPostConjugationDissolveSamples] == 0,
                Test["For each conjugation pool PostConjugationResuspensionMixUntilDissolved and corresponding mix until dissolved options do not conflict:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*--23 . Check that there are no duplicated sample in a conjugation pool. --*)
  simulatedSamplesDuplicatesQ = DuplicateFreeQ[#]&/@simulatedSamples;
  poolsWithDuplicates = PickList[simulatedSamples,simulatedSamplesDuplicatesQ,False];
  invalidDuplicatedInput =  MemberQ[simulatedSamplesDuplicatesQ,False];

  (*Throw an error if simulatedSamplesDuplicatesQ contains True*)
  If[
   invalidDuplicatedInput&&messages,
    Message[Error::DuplicatedBioconjugationSample,poolsWithDuplicates],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidDuplicatedInputTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[invalidDuplicatedInput,
                Test["Our the specified conjugation pools do not contain duplicated samples:", True, False],
                Nothing];

          passingTest =
              If[invalidDuplicatedInput,
                Test["Our the specified conjugation pools do not contain duplicated samples:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}];

  (*--24 . Check that any samples do not have a Null or 0 volume/mass. --*)
  solidSamplePackets = Cases[samplePackets,KeyValuePattern[State->Solid]];
  liquidSamplePackets = Cases[samplePackets,KeyValuePattern[State->Liquid]];
  liquidSample = If[MatchQ[liquidSamplePackets,{}],
    {},
    Lookup[liquidSamplePackets,Object]
  ];
  solidSample = If[MatchQ[solidSamplePackets,{}],
    {},
    Lookup[solidSamplePackets,Object]
  ];
  liquidSampleVolume =If[MatchQ[liquidSamplePackets,{}],
    {},
    Lookup[liquidSamplePackets,Volume]
  ];
  solidSampleMass = If[MatchQ[solidSamplePackets,{}],
    {},
    Lookup[solidSamplePackets,Mass]
  ];
  liquidSampleWithNoVolume = PickList[liquidSample,QuantityMagnitude[liquidSampleVolume],Null|0.|0];
  solidSampleWithNoMass = PickList[solidSample,QuantityMagnitude[solidSampleMass],Null|0.|0];

  (*Throw an error if we have a liquid sample with no volume*)
  If[
    Length[Flatten@{liquidSampleWithNoVolume,solidSampleWithNoMass}]>0&&messages,
    Message[Error::EmptyBioconjugationSample,Flatten@{liquidSampleWithNoVolume,solidSampleWithNoMass}],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  emptySampleInputTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[Flatten@{liquidSampleWithNoVolume,solidSampleWithNoMass}]>0,
                Test["Our the specified conjugation samples are not empty:", True, False],
                Nothing];

          passingTest =
              If[Length[Flatten@{liquidSampleWithNoVolume,solidSampleWithNoMass}]==0,
                Test["Our the specified conjugation samples are not empty:", True, True],
                Nothing
              ];
          {failingTest, passingTest}
        ],
        {}];


  (* ---- RESOLVE AUTOMATIC OPTIONS ---- *)
  (* -- Resolve non-index matched options -- *)

  (*Resolve ProcessingBatchSize*)
  resolvedBatchSize = Switch[Lookup[roundedBioconjugationOptions,{ProcessingOrder,ProcessingBatchSize}],

    (*If user specified, keep*)
    {Batch, Except[Automatic|Null]}, Lookup[roundedBioconjugationOptions,ProcessingBatchSize],

    (*If Automatic & ProcessingOrder is Batch -> 1*)
    {Batch, Automatic}, 1,

    (*Catch all*)
    {_,_}, Null
  ];

  (*Resolve ProcessingBatches*)
  resolvedProcessingBatches = Switch[Lookup[roundedBioconjugationOptions,{ProcessingOrder,ProcessingBatches}],

    (*If Batch and user specified, keep*)
    {Batch,Except[Automatic|Null]}, Lookup[roundedBioconjugationOptions,ProcessingBatches],

    (*If Batch and Automatic -> partition the conjugation pools based on ProcessingBatchSize*)
    {Batch, Automatic}, PartitionRemainder[myPooledSamples,resolvedBatchSize],

    (*If not Batch and Automatic -> Null. This is also just the catch all case*)
    {_,_}, Null
  ];

  (* -- Resolve SAMPLE index matched options -- *)

  (* Helper to return the user-specified value if provided or resolve the Automatic to a given default value *)
  resolveAutomaticOptions[option_, valueToResolveTo_] := MapThread[#1/.{Automatic->#2} &, {option, valueToResolveTo}];

  (*Expand the reaction chemistry option so it can be used in the mapthread*)
  expandedReactionChemistry =If[MatchQ[Lookup[mapThreadFriendlyOptions,ReactionChemistry],Null],
  ConstantArray[Null,Length[flatSimulatedSamples]],
  Flatten@MapThread[ConstantArray[#1,Length[#2]]&,{Lookup[mapThreadFriendlyOptions,ReactionChemistry],simulatedSamples}]
  ];

  {resolvedPreWashes,resolvedPreWashMethods, resolvedPreWashWashNumbers, resolvedPreWashTimes, resolvedPreWashTemperatures, resolvedPreWashBuffers, resolvedPreWashBufferVolumes,
    resolvedPreWashMixes, resolvedPreWashMixTypes, resolvedPreWashMixVolumes, resolvedPreWashMixNumbers, resolvedPreWashMixRates,resolvedPreWashResuspensions, resolvedPreWashResuspensionTimes, resolvedPreWashResuspensionTemperatures, resolvedPreWashResuspensionDiluents,
    resolvedPreWashResuspensionDiluentVolumes, resolvedPreWashResuspensionMixes, resolvedPreWashResuspensionMixTypes, resolvedPreWashResuspensionMixVolumes, resolvedPreWashResuspensioMixNumbers,
    resolvedPreWashResuspensionMixRates,resolvedActivateBools, resolvedActivationReactionVolumes, resolvedTargetActivationSampleConcentrations, resolvedActivationSampleVolumes, resolvedActivationReagents,
    resolvedTargetActivationReagentConcentrations, resolvedActivationReagentVolumes, resolvedActivationDiluents, resolvedActivationDiluentVolumes, resolvedActivationTimes, resolvedActivationTemperatures, resolvedActivationMixes,
    resolvedActivationMixTypes, resolvedActivationMixRates, resolvedActivationMixVolumes, resolvedActivationMixNumbers, resolvedPostActivationWashes, resolvedPostActivationWashMethods, resolvedPostActivationWashNumbers,
    resolvedPostActivationWashTimes, resolvedPostActivationWashTemperatures, resolvedPostActivationWashBuffers, resolvedPostActivationWashBufferVolumes, resolvedPostActivationWashMixes, resolvedPostActivationWashMixTypes,
    resolvedPostActivationWashMixVolumes, resolvedPostActivationWashMixNumbers, resolvedPostActivationWashMixRates,resolvedPostActivationResuspensions, resolvedPostActivationResuspensionTimes, resolvedPostActivationResuspensionTemperatures, resolvedPostActivationResuspensionDiluents, resolvedPostActivationResuspensionDiluentVolumes, resolvedPostActivationResuspensionMixes,
    resolvedPostActivationResuspensionMixTypes, resolvedPostActivationResuspensionMixVolumes, resolvedPostActivationResuspensionMixNumbers, resolvedPostActivationResuspensionMixRates, resolvedActivationSamplesOutStorageConditions,
    invalidPreWashBooleans,invalidActivationBooleans,invalidActivationSampleVolumes,invalidActivationReagentVolumes,invalidActivationDiluentVolumes, resolvedReactantCoefficients, unknownReactantCoefficients
  } = Transpose[
    MapThread[
      Function[{sample, sampleOptions,sampleContainerModelPacket,samplePacket,sampleIMPacket, reactionChemistry},
        Module[ {
          preWashOptions,defaultPreWashBoolean,containerMaxVolume,
          (*resolved options*)
          resolvedPreWash, resolvedPreWashMethod, resolvedPreWashNumberOfWashes, resolvedPreWashTime, resolvedPreWashTemperature, resolvedPreWashBuffer, resolvedPreWashBufferVolume,
          resolvedPreWashMix, resolvedPreWashMixType, resolvedPreWashMixVolume, resolvedPreWashNumberOfMixes, resolvedPreWashMixRate,resolvedPreWashResuspension,
          resolvedPreWashResuspensionTime, resolvedPreWashResuspensionTemperature, resolvedPreWashResuspensionDiluent, resolvedPreWashResuspensionDiluentVolume, resolvedPreWashResuspensionMix, resolvedPreWashResuspensionMixType,
          resolvedPreWashResuspensionMixVolume, resolvedPreWashResuspensionNumberOfMixes, resolvedPreWashResuspensionMixRate,resolvedActivate, resolvedActivationReactionVolume,
          resolvedTargetActivationSampleConcentration, resolvedActivationSampleVolume, resolvedActivationReagent, resolvedTargetActivationReagentConcentration, resolvedActivationReagentVolume, resolvedActivationDiluent,
          resolvedActivationDiluentVolume, resolvedActivationTime, resolvedActivationTemperature, resolvedActivationMix, resolvedActivationMixType, resolvedActivationMixRate, resolvedActivationMixVolume, resolvedActivationNumberOfMixes,
          resolvedPostActivationWash, resolvedPostActivationWashMethod, resolvedPostActivationNumberOfWashes, resolvedPostActivationWashTime,
          resolvedPostActivationWashTemperature, resolvedPostActivationWashBuffer, resolvedPostActivationWashBufferVolume, resolvedPostActivationWashMix, resolvedPostActivationWashMixType,
          resolvedPostActivationWashMixVolume, resolvedPostActivationWashNumberOfMixes, resolvedPostActivationWashMixRate,resolvedPostActivationResuspension, resolvedPostActivationResuspensionTime, resolvedPostActivationResuspensionTemperature, resolvedPostActivationResuspensionDiluent, resolvedPostActivationResuspensionDiluentVolume,
          resolvedPostActivationResuspensionMix, resolvedPostActivationResuspensionMixType, resolvedPostActivationResuspensionMixVolume, resolvedPostActivationResuspensionNumberOfMixes, resolvedPostActivationResuspensionMixRate, resolvedActivationSamplesOutStorageCondition,
          invalidPreWashBoolean,invalidActivationBoolean,invalidActivationSampleVolume,invalidActivationReagentVolume, invalidActivationDiluentVolume,samplePattern, activationReagentPattern,defaultReactantCoefficient,resolvedReactantCoefficient,unknownReactantCoefficient,
          (*defaults*)
          defaultPreWashMethod,defaultPreWashNumberOfWashes, defaultPreWashTime, defaultPreWashTemperature,defaultPreWashBuffer, defaultPreWashMix,
          defaultPreWashBufferVolume,defaultPreWashMixType,defaultPreWashMixVolume, defaultPreWashNumberOfMixes,defaultPreWashMixRate,defaultPreWashResuspension,defaultPreWashResuspensionTime, defaultPreWashResuspensionTemperature,defaultPreWashResuspensionDiluent, defaultPreWashResuspensionMix,
          defaultPreWashResuspensionDiluentVolume,defaultPreWashResuspensionMixType, defaultActivate,defaultActivationReactionVolume, defaultTargetActivationSampleConcentration,
          defaultTargetActivationReagentConcentration, defaultActivationTime,sampleAnalytes,activationReagentAnalytes,
          defaultActivationTemperature, defaultActivationMix,defaultActivationReagent,activationReagentPacket,sampleAnalyteConcentration,sampleAnalyteObject,activationReagentAnalyteConcentration,activationReagentAnalyteObject,
          convertedSampleConcentration,convertedActivationReagentConcentration,calculatedActivationSampleVolume,calculatedActivationReagentVolume, defaultActivationSampleVolume,
          defaultActivationReagentVolume,calculatedReactionVolumeRemainder,defaultActivationDiluentVolume,defaultActivationDiluent,
          defaultActivationMixType,defaultActivationMixVolume, defaultActivationNumberOfMixes,defaultActivationMixRate,defaultPostActivationWash,defaultPostActivationWashMethod,
          defaultPostActivationWashNumberOfWashes, defaultPostActivationWashTime, defaultPostActivationWashTemperature,defaultPostActivationWashBuffer, defaultPostActivationWashMix,
          defaultPostActivationWashBufferVolume,defaultPostActivationWashMixType,defaultPostActivationWashMixVolume, defaultPostActivationNumberOfMixes,defaultPostActivationWashMixRate,
          defaultPostActivationResuspension,defaultPostActivationResuspensionTime, defaultPostActivationResuspensionTemperature,defaultPostActivationResuspensionDiluent, defaultPostActivationResuspensionMix,
          defaultPostActivationResuspensionDiluentVolume,defaultPostActivationResuspensionMixType,defaultPostActivationResuspensionMixVolume, defaultPostActivationResuspensionNumberOfMixes,defaultPostActivationResuspensionMixRate,
          defaultPreWashResuspensionMixVolume,defaultPreWashResuspensionNumberOfMixes,defaultPreWashResuspensionMixRate
        },

          (*---Initialize error checking variables---*)
          {invalidPreWashBoolean,invalidActivationBoolean,invalidActivationSampleVolume,invalidActivationReagentVolume,invalidActivationDiluentVolume}=ConstantArray[False,5];

          (*---REACTION COEFFICIENTS---*)
          (*set the default options*)
          defaultReactantCoefficient = 1;

          (*Resolve automatic options or accept user specified options*)
          {resolvedReactantCoefficient} = resolveAutomaticOptions[
            Lookup[sampleOptions,{ReactantsStoichiometricCoefficients}],
            {defaultReactantCoefficient}
          ];

          (*If the coefficients were left as automatic give the user a warning that we will assume a 1:1:1... reaction which may not be accurate.*)
          unknownReactantCoefficient = If[MatchQ[Lookup[sampleOptions,ReactantsStoichiometricCoefficients], Automatic|{Automatic}], True, False];

          (*---PREWASH---*)

          (*Set the default options*)
          preWashOptions = Lookup[sampleOptions, {PreWashMethod,PreWashNumberOfWashes,PreWashTime,PreWashTemperature,PreWashBuffer,PreWashBufferVolume}];
          defaultPreWashBoolean = If[
            MemberQ[Flatten@preWashOptions,Except[Automatic|Null]],
            True,
            False
          ];

          (*Resolve the option*)
          {resolvedPreWash}=resolveAutomaticOptions[
            Flatten@{Lookup[sampleOptions,PreWash]},
            {defaultPreWashBoolean}
          ];

          (*Set the default options*)

          defaultPreWashMethod = If[

            (*if prewash boolean is true*)
            resolvedPreWash,

            (*set the method to be consistent with any other wash methods specified otherwise set to Pellet*)
            Switch[
              {
                MemberQ[Flatten@Lookup[sampleOptions,{PreWashFiltrationType, PreWashFilter, PreWashFilterMembraneMaterial, PreWashPrefilterMembraneMaterial, PreWashFilterPoreSize, PreWashFilterMolecularWeightCutoff, PreWashPrefilterPoreSize, PreWashFiltrationSyringe, PreWashFilterHousing}],Except[Null|Automatic]],
                MemberQ[Flatten@Lookup[sampleOptions,{PreWashMagnetizationRack}],Except[Null|Automatic]]
              },
              {True,False}, Filter,
              {False,True}, Magnetic,
              {_,_}, Pellet
            ],
            (*If PreWash is False the defaultPreWashMethod is Null*)
            Null
          ];

          {defaultPreWashNumberOfWashes, defaultPreWashTime, defaultPreWashTemperature,defaultPreWashBuffer, defaultPreWashMix}= If[

            (*if prewash boolean is true*)
            resolvedPreWash,

            (*set the number of washes to 3, time to 1 minute, temperature to Ambient, buffer to 1xPBS, and mix to True*)
            {3, 1*Minute, Ambient,Model[Sample,StockSolution,"id:J8AY5jwzPdaB"], True},
            (*If PreWash is False set to Null*)
            {Null,Null,Null,Null,Null}
          ];

          (* set default value for PreWashBufferVolume *)
          defaultPreWashBufferVolume=If[resolvedPreWash,
            With[{containerMaxVolume=Lookup[sampleContainerModelPacket,MaxVolume,Null]},
              (* is MaxVolume populated? *)
              If[MatchQ[containerMaxVolume,Except[Null]],
                (* set the Volume to half the MaxVolume of the sample container *)
                SafeRound[Convert[0.5*containerMaxVolume,Microliter],0.1*Microliter],
                (* else: default to 200 uL *)
                200*Microliter
              ]
            ],
            (*If PreWash is False set to Null*)
            Null
          ];

          (*Resolve automatic options or accept user specified options*)
          {resolvedPreWashMethod, resolvedPreWashNumberOfWashes, resolvedPreWashTime,
            resolvedPreWashTemperature, resolvedPreWashBuffer, resolvedPreWashBufferVolume, resolvedPreWashMix} = resolveAutomaticOptions[
            Flatten@Lookup[sampleOptions,{PreWashMethod,PreWashNumberOfWashes,PreWashTime,PreWashTemperature,PreWashBuffer,PreWashBufferVolume,PreWashMix}],
            {defaultPreWashMethod,defaultPreWashNumberOfWashes,defaultPreWashTime,defaultPreWashTemperature,defaultPreWashBuffer,defaultPreWashBufferVolume,defaultPreWashMix}
          ];

          (*---PREWASHMIX---*)

          (*Set the default options*)
          defaultPreWashMixType = Switch[Join[{resolvedPreWashMix},Lookup[sampleOptions,{PreWashMixVolume,PreWashNumberOfMixes,PreWashMixRate}]],

            (*If number of mixes is specified but volume is Null default to Invert*)
            {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

            (*If a mix rate is specified but no other parameters are specified default to Vortex*)
            {True, Null|Automatic, Null|Automatic, Except[Null|Automatic]}, Vortex,

            (*In any other case when PreWashMix is True, default to Pipette*)
            {True,_,_,_}, Pipette,

            (*In any other case when PreWashMix is False, default to Null*)
            {_,_,_,_}, Null
          ];

          (*resolve the MixType so the defaults can be set based on the resolved value*)
          {resolvedPreWashMixType} = resolveAutomaticOptions[Lookup[sampleOptions,{PreWashMixType}],{defaultPreWashMixType}];

          {defaultPreWashMixVolume, defaultPreWashNumberOfMixes,defaultPreWashMixRate}= Switch[resolvedPreWashMixType,

            (*if prewashmixtype is pipette, set volume to half the buffer volume, number of mixes to 5, and rate to Null*)
            Pipette, {SafeRound[Convert[0.5*resolvedPreWashBufferVolume,Microliter],0.1*Microliter], 5, Null},

            (*If prewashmixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
            Invert, {Null, 5, Null},

            (*If prewashmixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
            Except[Null], {Null, Null, 800*RPM},

            (*if prewash mixtype is Null set all options to Null*)
            Null, {Null, Null, Null}
          ];

          {resolvedPreWashMixVolume, resolvedPreWashNumberOfMixes, resolvedPreWashMixRate} = resolveAutomaticOptions[Lookup[sampleOptions,{PreWashMixVolume,PreWashNumberOfMixes,PreWashMixRate}], {defaultPreWashMixVolume, defaultPreWashNumberOfMixes,defaultPreWashMixRate}];

          (*---PREWASHRESUSPENSION---*)

          (* Set the default options *)
          defaultPreWashResuspension = If[
            (*If PreWash is True and any resuspension options are specified set to True*)
            resolvedPreWash && MemberQ[Lookup[sampleOptions,{PreWashResuspensionTime,PreWashResuspensionTime,PreWashResuspensionDiluent,PreWashResuspensionDiluentVolume}],Except[Null|Automatic]],
            True,
            (*In all other cases set to False*)
            False
          ];

          {resolvedPreWashResuspension} = resolveAutomaticOptions[Lookup[sampleOptions,{PreWashResuspension}],{defaultPreWashResuspension}];

          {defaultPreWashResuspensionTime, defaultPreWashResuspensionTemperature,defaultPreWashResuspensionDiluent, defaultPreWashResuspensionMix}= If[

            (*if prewash resuspension boolean is true*)
            resolvedPreWashResuspension,

            (*set time to 1 minute, temperature to Ambient, diluent to 1xPBS, and mix to True*)
            {1*Minute, Ambient,Model[Sample,StockSolution,"id:J8AY5jwzPdaB"], True},

            (*If PreWashResuspension is False set to Null*)
            {Null,Null,Null,Null}
          ];

          defaultPreWashResuspensionDiluentVolume = If[

            (*if prewashresuspension boolean is true*)
            resolvedPreWashResuspension,

            (*set the Volume to the original sample volume*)
            If[MatchQ[Lookup[samplePacket,Volume],Except[Null]], Lookup[samplePacket,Volume], 200*Microliter],

            (*If PreWashResuspension is False set to Null*)
            Null
          ];

          (*Resolve automatic options or accept user specified options*)
          { resolvedPreWashResuspensionTime, resolvedPreWashResuspensionTemperature, resolvedPreWashResuspensionDiluent, resolvedPreWashResuspensionDiluentVolume, resolvedPreWashResuspensionMix} = resolveAutomaticOptions[
            Flatten@Lookup[sampleOptions,{PreWashResuspensionTime,PreWashResuspensionTemperature,PreWashResuspensionDiluent,PreWashResuspensionDiluentVolume,PreWashResuspensionMix}],
            {defaultPreWashResuspensionTime, defaultPreWashResuspensionTemperature,defaultPreWashResuspensionDiluent, defaultPreWashResuspensionDiluentVolume, defaultPreWashResuspensionMix}
          ];

          (*---PREWASHRESUSPENSION MIX---*)
          (*Set the default options*)
          defaultPreWashResuspensionMixType = Switch[Join[{resolvedPreWashResuspensionMix},Lookup[sampleOptions,{PreWashResuspensionMixVolume,PreWashResuspensionNumberOfMixes,PreWashResuspensionMixRate}]],

            (*If number of mixes is specified but volume is Null default to Invert*)
            {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

            (*If a mix rate is specified but no other parameters are specified default to Vortex*)
            {True, Null|Automatic, Null|Automatic, Except[Null|Automatic]}, Vortex,

            (*In any other case when PreWashMix is True, default to Pipette*)
            {True,_,_,_}, Pipette,

            (*In any other case when PreWashMix is False, default to Null*)
            {_,_,_,_}, Null
          ];

          (*resolve the MixType so the defaults can be set based on the resolved value*)
          {resolvedPreWashResuspensionMixType} = resolveAutomaticOptions[Lookup[sampleOptions,{PreWashResuspensionMixType}],{defaultPreWashResuspensionMixType}];

          {defaultPreWashResuspensionMixVolume, defaultPreWashResuspensionNumberOfMixes,defaultPreWashResuspensionMixRate}= Switch[resolvedPreWashResuspensionMixType,

            (*if prewashresuspensionmixtype is pipette, set volume to half the buffer volume, number of mixes to 5, and rate to Null*)
            Pipette, {SafeRound[Convert[0.5*resolvedPreWashBufferVolume,Microliter],0.1*Microliter], 5, Null},

            (*If prewashresuspensionmixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
            Invert, {Null, 5, Null},

            (*If prewashresuspensionmixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
            Except[Null], {Null, Null, 800*RPM},

            (*if prewash resuspension mixtype is Null set all options to Null*)
            Null, {Null, Null, Null}
          ];

          {resolvedPreWashResuspensionMixVolume, resolvedPreWashResuspensionNumberOfMixes, resolvedPreWashResuspensionMixRate} = resolveAutomaticOptions[Lookup[sampleOptions,{PreWashResuspensionMixVolume,PreWashResuspensionNumberOfMixes,PreWashResuspensionMixRate}], {defaultPreWashResuspensionMixVolume, defaultPreWashResuspensionNumberOfMixes,defaultPreWashResuspensionMixRate}];

          (*---ACTIVATION---*)
          (*Set default options*)
          defaultActivate = If[
            (*If ReactionChemistry is Maleimide or any activation options are specified set to True*)
            MatchQ[reactionChemistry,Maleimide] || MemberQ[Lookup[sampleOptions,{ActivationReactionVolume, TargetActivationSampleConcentration, ActivationSampleVolume, ActivationReagent, TargetActivationReagentConcentration, ActivationReagentVolume, ActivationDiluent, ActivationDiluentVolume, ActivationTime, ActivationTemperature}],Except[Null|Automatic]],
            True,
            (*In all other cases set to False*)
            False
          ];

          {resolvedActivate} = resolveAutomaticOptions[Lookup[sampleOptions,{Activate}],{defaultActivate}];

          {defaultActivationReactionVolume, defaultTargetActivationSampleConcentration,
            defaultTargetActivationReagentConcentration, defaultActivationTime,
            defaultActivationTemperature, defaultActivationMix} = If[
            resolvedActivate,
            (*If Activate is True set defaults as below*)
            {0.5*Milliliter,1*Milligram/Milliliter,1*Milligram/Milliliter,15*Minute,Ambient,True},

            (*Otherise set all to Null*)
            ConstantArray[Null,6]
          ];

          defaultActivationReagent = Switch[{reactionChemistry,Cases[Flatten@Lookup[(Flatten@sampleIMPacket)/.Null->Nothing,Type],TypeP[Model[Molecule,Protein]]],resolvedActivate},
            (*If we are doing a maleimide reaction and the sample is a protein use TCEP to reduce disulfides*)
            {Maleimide,Except[{}],True},Model[Sample,StockSolution,"id:mnk9jOREABbw"],

            (*For any other contexts where activate is true, we cannot intelligently predict the reagent so give a PBS sample.*)
            {_,_,True},Model[Sample,StockSolution,"id:J8AY5jwzPdaB"],

            (*If Activate is False set to Null*)
            {_,_,False}, Null
          ];

          {resolvedActivationReactionVolume, resolvedTargetActivationSampleConcentration, resolvedTargetActivationReagentConcentration, resolvedActivationTime,
            resolvedActivationTemperature, resolvedActivationMix,resolvedActivationReagent} = resolveAutomaticOptions[
            Lookup[sampleOptions,{ActivationReactionVolume,TargetActivationSampleConcentration,TargetActivationReagentConcentration,ActivationTime,ActivationTemperature,ActivationMix,ActivationReagent}],
            {defaultActivationReactionVolume, defaultTargetActivationSampleConcentration, defaultTargetActivationReagentConcentration, defaultActivationTime,
            defaultActivationTemperature, defaultActivationMix,defaultActivationReagent}
          ];

          (*Get the analyte concentration*)


          (*First find all the anaylte objects*)
          sampleAnalytes = Flatten@Download[Lookup[samplePacket,Analytes],Object];
          activationReagentPacket = If[MatchQ[resolvedActivationReagent,ObjectP[]],
            Cases[DeleteDuplicates@Flatten@reagentObjectPackets, KeyValuePattern[Object->Download[resolvedActivationReagent,Object]]],
            {}
          ];

          activationReagentAnalytes = If[MatchQ[resolvedActivationReagent,ObjectP[]],Flatten@Download[Lookup[activationReagentPacket,Analytes,{}],Object], {}];

          (*Then find the concentration - if there is more than one analyte just pick the first analyte with a non-Null concentration*)
          (*If the sample has been prewashed and resuspended the use the resuspension volume to calculate an approx concentration after prewashing*)
          samplePattern = If[MatchQ[Flatten@sampleAnalytes,{}], ObjectP[{Model[Molecule,Protein],Model[Molecule,Oligomer],Model[Resin]}], ObjectP[Flatten@sampleAnalytes]];
          {sampleAnalyteConcentration,sampleAnalyteObject} = If[MatchQ[resolvedPreWashResuspension,True],
           {
             First[Flatten[FirstCase[Lookup[samplePacket,Composition], {Except[Null], samplePattern},{}]]/.{}->{{},{}}]*Lookup[samplePacket,Volume]/resolvedPreWashResuspensionDiluentVolume,
             Last[Flatten[FirstCase[Lookup[samplePacket,Composition], {Except[Null], samplePattern},{}]]/.{}->{{},{}}]
           },
            Flatten[FirstCase[Lookup[samplePacket,Composition], {Except[Null], samplePattern},{}]]/.{}->{{},{}}
          ];

          activationReagentPattern = If[MatchQ[Flatten@activationReagentAnalytes,{}], ObjectP[], ObjectP[Flatten@activationReagentAnalytes]];
          {activationReagentAnalyteConcentration,activationReagentAnalyteObject} = If[MatchQ[resolvedActivationReagent,ObjectP[]],Flatten@FirstCase[Flatten[Lookup[activationReagentPacket,Composition],1], {Except[Null], activationReagentPattern},{}]/.{}->{{},{}}, {{},{}}];

          (*find the desired sample volume*)
          convertedSampleConcentration = Switch[{MassConcentrationQ[resolvedTargetActivationSampleConcentration],MassConcentrationQ[sampleAnalyteConcentration],VolumePercentQ[sampleAnalyteConcentration],MassPercentQ[sampleAnalyteConcentration]},
            (*If the concentrations do not match convert using the molecular weight*)
            {True, False,False,False}, Convert[sampleAnalyteConcentration*Lookup[Cases[DeleteDuplicates@Flatten@sampleIMPacket, KeyValuePattern[Object->Download[sampleAnalyteObject,Object]]],MolecularWeight], QuantityUnit[resolvedTargetActivationSampleConcentration]],
            {False,True,False,False}, Convert[sampleAnalyteConcentration/Lookup[Cases[DeleteDuplicates@Flatten@sampleIMPacket, KeyValuePattern[Object->Download[sampleAnalyteObject,Object]]],MolecularWeight], QuantityUnit[resolvedTargetActivationSampleConcentration]],
            {True, False,True,False}, Convert[sampleAnalyteConcentration*Lookup[samplePacket,Volume]*Lookup[Cases[DeleteDuplicates@Flatten@sampleIMPacket, KeyValuePattern[Object->Download[sampleAnalyteObject,Object]]],MolecularWeight], QuantityUnit[resolvedTargetActivationSampleConcentration]],
            {_,_,_,_}, sampleAnalyteConcentration
          ];

          convertedActivationReagentConcentration = Switch[{MassConcentrationQ[resolvedTargetActivationReagentConcentration],MassConcentrationQ[activationReagentAnalyteConcentration], VolumePercentQ[activationReagentAnalyteConcentration],MassPercentQ[activationReagentAnalyteConcentration]},
            (*If the concentrations do not match convert using the molecular weight*)
            {True, False,False,False}, Convert[activationReagentAnalyteConcentration*Lookup[Cases[DeleteDuplicates@Flatten@reagentObjectIdentityModelPackets, KeyValuePattern[Object->Download[activationReagentAnalyteObject,Object]]],MolecularWeight], QuantityUnit[resolvedTargetActivationReagentConcentration]],
            {False,True,False,False}, Convert[activationReagentAnalyteConcentration/Lookup[Cases[DeleteDuplicates@Flatten@reagentObjectIdentityModelPackets, KeyValuePattern[Object->Download[activationReagentAnalyteObject,Object]]],MolecularWeight], QuantityUnit[resolvedTargetActivationReagentConcentration]],
            {True, False,True,False}, Convert[activationReagentAnalyteConcentration*Lookup[samplePacket,Volume]*Lookup[Cases[DeleteDuplicates@Flatten@reagentObjectIdentityModelPackets, KeyValuePattern[Object->Download[activationReagentAnalyteObject,Object]]],MolecularWeight], QuantityUnit[resolvedTargetActivationReagentConcentration]],
            {_,_,_,_}, sampleAnalyteConcentration
          ];

          calculatedActivationSampleVolume = If[
            !MatchQ[sampleAnalyteConcentration,{}]&&!MassPercentQ[sampleAnalyteConcentration],
            SafeRound[Convert[resolvedTargetActivationSampleConcentration*resolvedActivationReactionVolume/convertedSampleConcentration, Microliter],0.1*Microliter],
            Null
          ];

          calculatedActivationReagentVolume = If[
            !MatchQ[activationReagentAnalyteConcentration,{}]&&!MassPercentQ[activationReagentAnalyteConcentration],
            SafeRound[Convert[resolvedTargetActivationReagentConcentration*resolvedActivationReactionVolume/convertedActivationReagentConcentration, Microliter],0.1*Microliter],
            Null
          ];

          defaultActivationSampleVolume = If[MatchQ[resolvedTargetActivationSampleConcentration,Except[Null]],calculatedActivationSampleVolume,Null];
          defaultActivationReagentVolume = If[MatchQ[resolvedTargetActivationReagentConcentration,Except[Null]],calculatedActivationReagentVolume,Null];

          {resolvedActivationSampleVolume,resolvedActivationReagentVolume} = resolveAutomaticOptions[
            Lookup[sampleOptions,{ActivationSampleVolume,ActivationReagentVolume}],
            {defaultActivationSampleVolume,defaultActivationReagentVolume}
          ];

          calculatedReactionVolumeRemainder = resolvedActivationReactionVolume-(resolvedActivationSampleVolume + resolvedActivationReagentVolume);

          defaultActivationDiluentVolume = If[MatchQ[calculatedReactionVolumeRemainder,_Quantity] && QuantityMagnitude[calculatedReactionVolumeRemainder]>0,
            SafeRound[Convert[calculatedReactionVolumeRemainder,Microliter],0.1*Microliter],
            Null
          ];

          defaultActivationDiluent = If[
            MatchQ[defaultActivationDiluentVolume,_Quantity],
            Model[Sample,StockSolution,"id:J8AY5jwzPdaB"],
            Null
          ];

          {resolvedActivationDiluent,resolvedActivationDiluentVolume} = resolveAutomaticOptions[Lookup[sampleOptions,{ActivationDiluent,ActivationDiluentVolume}],{defaultActivationDiluent,defaultActivationDiluentVolume}];

          (*---ACTIVATION MIX---*)
          (*Set the default options*)
          defaultActivationMixType = Switch[Join[{resolvedActivationMix},Lookup[sampleOptions,{ActivationMixVolume,ActivationNumberOfMixes,ActivationMixRate}]],

            (*If number of mixes is specified but volume is Null default to Invert*)
            {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

            (*If a mix rate is specified but no other parameters are specified default to Vortex*)
            {True, Null|Automatic, Null|Automatic, Except[Null|Automatic]}, Vortex,

            (*In any other case when ActivationMix is True, default to Shake*)
            {True,_,_,_}, Shake,

            (*In any other case when PreWashMix is False, default to Null*)
            {_,_,_,_}, Null
          ];

          (*resolve the MixType so the defaults can be set based on the resolved value*)
          {resolvedActivationMixType} = resolveAutomaticOptions[Lookup[sampleOptions,{ActivationMixType}],{defaultActivationMixType}];

          {defaultActivationMixVolume, defaultActivationNumberOfMixes,defaultActivationMixRate}= Switch[resolvedActivationMixType,

            (*if mix type is pipette, set volume to half the reaction volume, number of mixes to 5, and rate to Null*)
            Pipette, {SafeRound[Convert[0.5*resolvedActivationReactionVolume,Microliter],0.1Microliter], 5, Null},

            (*If mix type is invert, set volume to Null, number of mixes to 5, and rate to Null*)
            Invert, {Null, 5, Null},

            (*If mix type is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
            Except[Null], {Null, Null, 800*RPM},

            (*if mixtype is Null set all options to Null*)
            Null, {Null, Null, Null}
          ];

          {resolvedActivationMixVolume, resolvedActivationNumberOfMixes, resolvedActivationMixRate} = resolveAutomaticOptions[Lookup[sampleOptions,{ActivationMixVolume,ActivationNumberOfMixes,ActivationMixRate}], {defaultActivationMixVolume, defaultActivationNumberOfMixes,defaultActivationMixRate}];

          (*---POST ACTIVATION WASH---*)
          (*Set the default options*)
          defaultPostActivationWash = If[
            (*If the sample is a solid phase support we will wash after activation*)
            Length@Cases[sampleAnalytes,ObjectP[Model[Resin,SolidPhaseSupport]]]>0,
            True,
            False
          ];

          {resolvedPostActivationWash} = resolveAutomaticOptions[Lookup[sampleOptions,{PostActivationWash}],{defaultPostActivationWash}];

          defaultPostActivationWashMethod = If[

            (*if prewash boolean is true*)
            resolvedPostActivationWash,

            (*set the method to be consistent with any other wash methods specified otherwise set to Pellet*)
            Switch[
              {
                MemberQ[Lookup[sampleOptions,{PostActivationWashFiltrationType, PostActivationWashFilter, PostActivationWashFilterMembraneMaterial, PostActivationWashPrefilterMembraneMaterial, PostActivationWashFilterPoreSize, PostActivationWashFilterMolecularWeightCutoff, PostActivationWashPrefilterPoreSize, PostActivationWashFiltrationSyringe, PostActivationWashFilterHousing}],Except[Null|Automatic]],
                MemberQ[Lookup[sampleOptions,{PostActivationWashMagnetizationRack}],Except[Null|Automatic]]
              },
              {True,False}, Filter,
              {False,True}, Magnetic,
              {_,_}, Pellet
            ],
            (*If PostActivationWash is False the defaultPostActivationWashMethod is Null*)
            Null
          ];

          {defaultPostActivationWashNumberOfWashes, defaultPostActivationWashTime, defaultPostActivationWashTemperature,defaultPostActivationWashBuffer, defaultPostActivationWashMix}= If[

            (*if PostActivationWash boolean is true*)
            resolvedPostActivationWash,

            (*set the number of washes to 3, time to 1 minute, temperature to Ambient, buffer to 1xPBS, and mix to True*)
            {3, 1*Minute, Ambient, Model[Sample,StockSolution,"id:J8AY5jwzPdaB"], True},

            (*If PostActivationWash is False set to Null*)
            {Null,Null,Null,Null,Null}
          ];

          (* set defualt value for PostActivationWashBufferVolume *)
          defaultPostActivationWashBufferVolume = If[resolvedPostActivationWash,
            With[{containerMaxVolume=Lookup[sampleContainerModelPacket,MaxVolume,Null]},
              (* is MaxVolume populated? *)
              If[MatchQ[containerMaxVolume,Except[Null]],
                (* set the Volume to half the MaxVolume of the sample container *)
                SafeRound[Convert[0.5*containerMaxVolume,Microliter],0.1*Microliter],
                (* else: default to 200 uL *)
                200*Microliter
              ]
            ],
            (*If PostActivationWash is False set to Null*)
            Null
          ];

          (*Resolve automatic options or accept user specified options*)
          {resolvedPostActivationWashMethod, resolvedPostActivationNumberOfWashes, resolvedPostActivationWashTime,
            resolvedPostActivationWashTemperature, resolvedPostActivationWashBuffer, resolvedPostActivationWashBufferVolume, resolvedPostActivationWashMix} = resolveAutomaticOptions[
            Flatten@Lookup[sampleOptions,{PostActivationWashMethod,PostActivationNumberOfWashes,PostActivationWashTime,PostActivationWashTemperature,PostActivationWashBuffer,PostActivationWashBufferVolume,PostActivationWashMix}],
            {defaultPostActivationWashMethod,defaultPostActivationWashNumberOfWashes,defaultPostActivationWashTime,defaultPostActivationWashTemperature,defaultPostActivationWashBuffer,defaultPostActivationWashBufferVolume,defaultPostActivationWashMix}
          ];

          (*---PostActivationWashMIX---*)

          (*Set the default options*)
          defaultPostActivationWashMixType = Switch[Join[{resolvedPostActivationWashMix},Lookup[sampleOptions,{PostActivationWashMixVolume,PostActivationWashNumberOfMixes,PostActivationWashMixRate}]],

            (*If number of mixes is specified but volume is Null default to Invert*)
            {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

            (*If a mix rate is specified but no other parameters are specified default to Vortex*)
            {True, Null|Automatic, Null|Automatic, Except[Null|Automatic]}, Vortex,

            (*In any other case when PostActivationWashMix is True, default to Pipette*)
            {True,_,_,_}, Pipette,

            (*In any other case when PostActivationWashMix is False, default to Null*)
            {_,_,_,_}, Null
          ];

          (*resolve the MixType so the defaults can be set based on the resolved value*)
          {resolvedPostActivationWashMixType} = resolveAutomaticOptions[Lookup[sampleOptions,{PostActivationWashMixType}],{defaultPostActivationWashMixType}];

          {defaultPostActivationWashMixVolume, defaultPostActivationNumberOfMixes,defaultPostActivationWashMixRate}= Switch[resolvedPostActivationWashMixType,

            (*if PostActivationWashmixtype is pipette, set volume to half the buffer volume, number of mixes to 5, and rate to Null*)
            Pipette, {SafeRound[Convert[0.5*resolvedPostActivationWashBufferVolume,Microliter],0.1*Microliter], 5, Null},

            (*If PostActivationWashmixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
            Invert, {Null, 5, Null},

            (*If PostActivationWashmixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
            Except[Null], {Null, Null, 800*RPM},

            (*if PostActivationWash mixtype is Null set all options to Null*)
            Null, {Null, Null, Null}
          ];

          {resolvedPostActivationWashMixVolume, resolvedPostActivationWashNumberOfMixes, resolvedPostActivationWashMixRate} = resolveAutomaticOptions[Lookup[sampleOptions,{PostActivationWashMixVolume,PostActivationWashNumberOfMixes,PostActivationWashMixRate}], {defaultPostActivationWashMixVolume, defaultPostActivationNumberOfMixes,defaultPostActivationWashMixRate}];

          (*---POST ACTIVATION RESUSPENSION---*)

          (* Set the default options *)
          defaultPostActivationResuspension = If[
            (*If PostActivationWash is True and any resuspension options are specified set to True*)
            resolvedPostActivationWash && MemberQ[Lookup[sampleOptions,{PostActivationResuspensionTime,PostActivationResuspensionTime,PostActivationResuspensionDiluent,PostActivationResuspensionDiluentVolume}],Except[Null|Automatic]],
            True,
            (*In all other cases set to False*)
            False
          ];

          {resolvedPostActivationResuspension} = resolveAutomaticOptions[Lookup[sampleOptions,{PostActivationResuspension}],{defaultPostActivationResuspension}];

          {defaultPostActivationResuspensionTime, defaultPostActivationResuspensionTemperature,defaultPostActivationResuspensionDiluent, defaultPostActivationResuspensionMix}= If[

            (*if PostActivationWash resuspension boolean is true*)
            resolvedPostActivationResuspension,

            (*set time to 1 minute, temperature to Ambient, diluent to 1xPBS, and mix to True*)
            {1*Minute, Ambient,Model[Sample,StockSolution,"id:J8AY5jwzPdaB"], True},

            (*If PostActivationResuspension is False set to Null*)
            {Null,Null,Null,Null}
          ];

          defaultPostActivationResuspensionDiluentVolume = If[

            (*if PostActivationResuspension boolean is true*)
            resolvedPostActivationResuspension,

            (*set the Volume to the original sample volume*)
            If[MatchQ[Lookup[samplePacket,Volume],Except[Null]], Lookup[samplePacket,Volume], 200*Microliter],

            (*If PostActivationResuspension is False set to Null*)
            Null
          ];

          (*Resolve automatic options or accept user specified options*)
          { resolvedPostActivationResuspensionTime, resolvedPostActivationResuspensionTemperature, resolvedPostActivationResuspensionDiluent, resolvedPostActivationResuspensionDiluentVolume, resolvedPostActivationResuspensionMix} = resolveAutomaticOptions[
            Flatten@Lookup[sampleOptions,{PostActivationResuspensionTime,PostActivationResuspensionTemperature,PostActivationResuspensionDiluent,PostActivationResuspensionDiluentVolume,PostActivationResuspensionMix}],
            {defaultPostActivationResuspensionTime, defaultPostActivationResuspensionTemperature,defaultPostActivationResuspensionDiluent, defaultPostActivationResuspensionDiluentVolume, defaultPostActivationResuspensionMix}
          ];

          (*---POST ACTIVATION RESUSPENSION MIX---*)
          (*Set the default options*)
          defaultPostActivationResuspensionMixType = Switch[Join[{resolvedPostActivationResuspensionMix},Lookup[sampleOptions,{PostActivationResuspensionMixVolume,PostActivationWashResuspesionNumberOfMixes,PostActivationResuspensionMixRate}]],

            (*If number of mixes is specified but volume is Null default to Invert*)
            {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

            (*If a mix rate is specified but no other parameters are specified default to Vortex*)
            {True, Null|Automatic, Null|Automatic, Except[Null|Automatic]}, Vortex,

            (*In any other case when PostActivationWashMix is True, default to Pipette*)
            {True,_,_,_}, Pipette,

            (*In any other case when PostActivationWashMix is False, default to Null*)
            {_,_,_,_}, Null
          ];

          (*resolve the MixType so the defaults can be set based on the resolved value*)
          {resolvedPostActivationResuspensionMixType} = resolveAutomaticOptions[Lookup[sampleOptions,{PostActivationResuspensionMixType}],{defaultPostActivationResuspensionMixType}];

          {defaultPostActivationResuspensionMixVolume, defaultPostActivationResuspensionNumberOfMixes,defaultPostActivationResuspensionMixRate}= Switch[resolvedPostActivationResuspensionMixType,

            (*if PostActivationResuspensionmixtype is pipette, set volume to half the buffer volume, number of mixes to 5, and rate to Null*)
            Pipette, {SafeRound[Convert[0.5*resolvedPostActivationWashBufferVolume,Microliter],0.1*Microliter], 5, Null},

            (*If PostActivationResuspensionmixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
            Invert, {Null, 5, Null},

            (*If PostActivationResuspensionmixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
            Except[Null], {Null, Null, 800*RPM},

            (*if PostActivationWash resuspension mixtype is Null set all options to Null*)
            Null, {Null, Null, Null}
          ];

          {resolvedPostActivationResuspensionMixVolume, resolvedPostActivationResuspensionNumberOfMixes, resolvedPostActivationResuspensionMixRate} = resolveAutomaticOptions[Lookup[sampleOptions,{PostActivationResuspensionMixVolume,PostActivationResuspensionNumberOfMixes,PostActivationResuspensionMixRate}], {defaultPostActivationResuspensionMixVolume, defaultPostActivationResuspensionNumberOfMixes,defaultPostActivationResuspensionMixRate}];

          {resolvedActivationSamplesOutStorageCondition} = resolveAutomaticOptions[Lookup[sampleOptions,{ActivationSamplesOutStorageCondition}],{Disposal}];

          (*---ERROR CHECKING---*)
          (*If we are not prewashing we should not be prewashmixing or prewashresuspending*)
          invalidPreWashBoolean = Switch[{resolvedPreWash,MemberQ[{resolvedPreWashMix,resolvedPreWashResuspension},True] },
            {False,True}, True,
            {_,_}, False
          ];

          (*If we are not activating we should not be activationmixing postactivationwashing or postactivationresuspending*)
          invalidActivationBoolean = Switch[{resolvedActivate, MemberQ[{resolvedActivationMix,resolvedPostActivationWash,resolvedPostActivationWashMix,resolvedPostActivationResuspension,resolvedPostActivationResuspensionMix},True]},
            {False,True}, True,
            {_,_}, False
          ];

          (*Our Sample volumes must not be invalid volumes if activate is true*)
          invalidActivationSampleVolume = If[
            resolvedActivate,
            Not[MatchQ[resolvedActivationSampleVolume,_Quantity] && MatchQ[QuantityMagnitude[resolvedActivationSampleVolume], GreaterP[0]]],
           False
          ];

          (*Our activation reagent volume must not be invalid if activation reagent is a sample*)
          invalidActivationReagentVolume = If[
            ObjectQ[resolvedActivationReagent],
            Not[MatchQ[resolvedActivationReagentVolume,_Quantity] && MatchQ[QuantityMagnitude[resolvedActivationReagentVolume], GreaterP[0]]],
            False
          ];

          (*Our activation diluent volume must not be invalid if activation diluent is a sample*)
          invalidActivationDiluentVolume = If[
            ObjectQ[resolvedActivationDiluent],
            Not[MatchQ[resolvedActivationDiluentVolume,_Quantity] && MatchQ[QuantityMagnitude[resolvedActivationDiluentVolume], GreaterP[0]]],
            False
          ];


          (*Final output*)
          {resolvedPreWash, resolvedPreWashMethod, resolvedPreWashNumberOfWashes, resolvedPreWashTime, resolvedPreWashTemperature, resolvedPreWashBuffer, resolvedPreWashBufferVolume,
            resolvedPreWashMix, resolvedPreWashMixType, resolvedPreWashMixVolume, resolvedPreWashNumberOfMixes, resolvedPreWashMixRate,resolvedPreWashResuspension,
            resolvedPreWashResuspensionTime, resolvedPreWashResuspensionTemperature, resolvedPreWashResuspensionDiluent, resolvedPreWashResuspensionDiluentVolume, resolvedPreWashResuspensionMix, resolvedPreWashResuspensionMixType,
            resolvedPreWashResuspensionMixVolume, resolvedPreWashResuspensionNumberOfMixes, resolvedPreWashResuspensionMixRate, resolvedActivate, resolvedActivationReactionVolume,
            resolvedTargetActivationSampleConcentration, resolvedActivationSampleVolume, resolvedActivationReagent, resolvedTargetActivationReagentConcentration, resolvedActivationReagentVolume, resolvedActivationDiluent,
            resolvedActivationDiluentVolume, resolvedActivationTime, resolvedActivationTemperature, resolvedActivationMix, resolvedActivationMixType, resolvedActivationMixRate, resolvedActivationMixVolume, resolvedActivationNumberOfMixes,
            resolvedPostActivationWash, resolvedPostActivationWashMethod, resolvedPostActivationNumberOfWashes, resolvedPostActivationWashTime,
            resolvedPostActivationWashTemperature, resolvedPostActivationWashBuffer, resolvedPostActivationWashBufferVolume, resolvedPostActivationWashMix, resolvedPostActivationWashMixType,
            resolvedPostActivationWashMixVolume, resolvedPostActivationWashNumberOfMixes, resolvedPostActivationWashMixRate,resolvedPostActivationResuspension, resolvedPostActivationResuspensionTime, resolvedPostActivationResuspensionTemperature, resolvedPostActivationResuspensionDiluent, resolvedPostActivationResuspensionDiluentVolume,
            resolvedPostActivationResuspensionMix, resolvedPostActivationResuspensionMixType, resolvedPostActivationResuspensionMixVolume, resolvedPostActivationResuspensionNumberOfMixes, resolvedPostActivationResuspensionMixRate, resolvedActivationSamplesOutStorageCondition,
            invalidPreWashBoolean,invalidActivationBoolean,invalidActivationSampleVolume,invalidActivationReagentVolume,invalidActivationDiluentVolume,resolvedReactantCoefficient,unknownReactantCoefficient
          }
        ]
      ],
      {flatSimulatedSamples,flatSamplesMapThreadFriendlyOptions,Flatten[sampleContainerModelPackets],samplePackets,sampleIdentityModelPackets,expandedReactionChemistry}
    ]
  ];

  (*Resolve sample index matched options by calling ExperimentFilter, ExperimentPellet, ExperimentTransfer as needed*)
  (*The resolved options will then be used to assemble primitives in the compiler*)
  (*TODO consider using experimentSM resolver to find the options for filter because Pressure is unique to the filter primitive since it is done on the LH deck. In order to support this, the Pressure option can only be used if the samples are in LH compatible containers (error checking) and would require a transfer step into the appropriate filter plate. We would need two additional options for Pressure and FilterPlate.*)
  (*TODO when selecting the retentate becomes available for Filter/ExperimentFilter will need update option list here and provide that option to ExperimentBioconjugation*)

  (*---PREWASH---*)

  (*Compile a list of the function option names*)

  filterOptionNames = {
    FiltrationType, Instrument, Filter, FilterStorageCondition, MembraneMaterial,
    PrefilterMembraneMaterial, PoreSize, MolecularWeightCutoff,
    PrefilterPoreSize, Syringe, Sterile, FilterHousing,
    Intensity, Time, Temperature
  };

  pelletOptionNames = {
    Instrument, Intensity, Time, Temperature
  };

  (*Currently there is no primitive for magnetic bead separation. It can only be used through ExperimentTransfer. This would be really cumbersome here because it would require a separate ExperimentTransfer call for each wash including resource gathering and parsing etc.*)
  (*TODO make magnetic separation available when it is part of a SM primitive. Currently Transfer is still using the old ExperimentTransfer and does not have these options. We need these options in order to simulate the sample manipulation for downstream steps.*)
   magneticTransferOptionNames = {MagnetizationTime, DestinationTemperature, MagnetizationRack};

  preWashFilterOptionNames = {
    PreWashFiltrationType, PreWashInstrument, PreWashFilter,PreWashFilterStorageCondition, PreWashFilterMembraneMaterial,
    PreWashPrefilterMembraneMaterial, PreWashFilterPoreSize, PreWashFilterMolecularWeightCutoff,
    PreWashPrefilterPoreSize, PreWashFiltrationSyringe, PreWashSterileFiltration, PreWashFilterHousing,
    PreWashCentrifugationIntensity, PreWashCentrifugationTime, PreWashCentrifugationTemperature
  };

  preWashPelletOptionNames ={
    PreWashInstrument,PreWashCentrifugationIntensity, PreWashCentrifugationTime, PreWashCentrifugationTemperature
  };

  preWashMagneticTransferOptionNames = {PreWashTime, PreWashTemperature, PreWashMagnetizationRack};

  (*Find the split up all the samples and options by their wash or workup method*)
  preWashFilterSamples = PickList[flatSimulatedSamples,resolvedPreWashMethods,Filter];
  preWashPelletSamples = PickList[flatSimulatedSamples,resolvedPreWashMethods,Pellet];
  preWashMagneticTransferSamples = PickList[flatSimulatedSamples,resolvedPreWashMethods,Magnetic];

  preWashFilterOptions = MapThread[#2->PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,#1],resolvedPreWashMethods,Filter]&,{preWashFilterOptionNames,filterOptionNames}];
  preWashPelletOptions = MapThread[#2->PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,#1],resolvedPreWashMethods,Pellet]&,{preWashPelletOptionNames,pelletOptionNames}];
  preWashMagnetizeOptions = MapThread[#2->PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,#1],resolvedPreWashMethods,Magnetic]&,{preWashMagneticTransferOptionNames,magneticTransferOptionNames}];

  (*Use the respective experiment functions to resolve and throw any errors necessary*)
  (*TODO currently ExperimentFilter doesnot support choosing to keep the retentate. We will need to update this option once cell-ebration framework is done. Until then this option can only be used to remove precipitates from the aqueous solution prior to moving to the next step.*)
  prewashFilterResolveFailure = Check[
    {resolvedPreWashFilterOptions,preWashFilterTests} = If[Length@preWashFilterSamples>0,
      If[gatherTests,
        Quiet[ExperimentFilter[preWashFilterSamples,Sequence@@preWashFilterOptions,Cache->simulatedCache,Simulation->updatedSimulation,OptionsResolverOnly -> True, Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentFilter[preWashFilterSamples,Sequence@@preWashFilterOptions,Cache->simulatedCache,Simulation->updatedSimulation,OptionsResolverOnly -> True, Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[filterOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (*ExperimentPellet cannot take Time->Automatic or Temperature->Automatic so we must first replace those with the default options value*)
  preWashPelletOptionsWithTime = ReplaceRule[preWashPelletOptions, {Time -> Lookup[preWashPelletOptions /. Automatic -> 5 Minute, Time], Temperature -> Lookup[preWashPelletOptions /. Automatic -> Ambient, Temperature]}];
  prewashPelletResolveFailure = Check[
    {resolvedPreWashPelletOptions,preWashPelletTests} = If[Length@preWashPelletSamples>0,
      If[gatherTests,
        Quiet[ExperimentPellet[preWashPelletSamples,Sequence@@preWashPelletOptionsWithTime,Cache->simulatedCache,Simulation->updatedSimulation,OptionsResolverOnly -> True, Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentPellet[preWashPelletSamples,Sequence@@preWashPelletOptionsWithTime,Cache->simulatedCache,Simulation->updatedSimulation,OptionsResolverOnly -> True, Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[pelletOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  prewashMagneticTransferResolveFailure = Check[
    {resolvedPreWashMagneticTransferOptions,preWashMagneticTransferTests} = If[Length@preWashMagneticTransferSamples>0,
      If[gatherTests,
        Quiet[ExperimentTransfer[preWashMagneticTransferSamples,Waste,All,Sequence@@preWashMagnetizeOptions,Magnetization->True,Cache->simulatedCache,Simulation->updatedSimulation,OptionsResolverOnly -> True, Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentTransfer[preWashMagneticTransferSamples,Waste,All,Sequence@@preWashMagnetizeOptions,Magnetization->True,Cache->simulatedCache,Simulation->updatedSimulation,OptionsResolverOnly -> True, Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[magneticTransferOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (*Helper function to convert the resolved options to the format needed for the protocol object.*)
  reformatResolvedOptions[positions_, resolvedOptions_, optionNames_, protocolOptionNames_, numberOfSamples_] := Module[{optionVals,resolvedOptionsWithNulls,newResolvedOptions},

    (*Get all the option values as a list*)
    optionVals = Lookup[resolvedOptions,optionNames];

    (*reformat the resolved options such that samples not being filtered/pelleted have null options*)
    resolvedOptionsWithNulls = ReplacePart[ConstantArray[Null,numberOfSamples],Thread[Flatten[positions]->#]]&/@optionVals;

    (*Return the options as a list of rules*)
    newResolvedOptions = Thread[protocolOptionNames->resolvedOptionsWithNulls]

  ];

  (*Get the resolved options and assemble the index-matched list of options with the bioconjugation specific optionnames. Samples that are not getting filtered should have Filtration->False and all other options Null. Same for pellet*)
  prewashFilterPositions = Position[resolvedPreWashMethods,Filter];
  prewashPelletPositions = Position[resolvedPreWashMethods, Pellet];
  prewashMagneticTransferPositions = Position[resolvedPreWashMethods,Magnetic];

  resolvedPreWashFilterOptionsFull = reformatResolvedOptions[prewashFilterPositions,resolvedPreWashFilterOptions,filterOptionNames,preWashFilterOptionNames,Length@flatSimulatedSamples];
  resolvedPreWashPelletOptionsFull = reformatResolvedOptions[prewashPelletPositions,resolvedPreWashPelletOptions,pelletOptionNames,preWashPelletOptionNames,Length@flatSimulatedSamples];
  resolvedPreWashMagnetOptionsFull = reformatResolvedOptions[prewashMagneticTransferPositions, resolvedPreWashMagneticTransferOptions, magneticTransferOptionNames, preWashMagneticTransferOptionNames, Length@flatSimulatedSamples];

  (*---POST ACTIVATION WASH---*)
  (*In order to properly resolve the PostActivationWash options we need to simulate the Activation of the samples.*)

  (*Simulate PreWash and activation*)
  (*We really only need to simulate the "final wash", resuspension, and activation reaction*)
  (*First we need to put together the Filter, Pellet, and transfer primitives*)
  filterPrimOptions = FilterRules[resolvedPreWashFilterOptions, Keys@Options[Filter]];
  pelletPrimOptions = FilterRules[resolvedPreWashPelletOptions, Keys@Options[Pellet]];

  prewashFilterPrimitive = If[Length@preWashFilterSamples>0,Filter[Sample->preWashFilterSamples, Sequence@@filterPrimOptions],{}];
  prewashPelletPrimitive = If[Length@preWashPelletSamples>0,Pellet[Sample->preWashPelletSamples, Sequence@@pelletPrimOptions],{}];
  transferOutVolumes = PickList[Lookup[samplePackets,Volume],resolvedPreWashMethods,Magnetic];
  prewashMagneticTransferPrimitive = If[Length@preWashMagneticTransferSamples>0,Transfer[Source->preWashMagneticTransferSamples, Amount-> transferOutVolumes, Destination->Model[Container,Plate,"id:54n6evLWKqbG"]],{}];

  preWashResuspendSamples = PickList[flatSimulatedSamples,resolvedPreWashResuspensions,True];
  preWashResuspendDiluents = PickList[resolvedPreWashResuspensionDiluents,resolvedPreWashResuspensions,True];
  preWashResuspendDiluentVolumes = PickList[resolvedPreWashResuspensionDiluentVolumes,resolvedPreWashResuspensions,True];
  prewashTransferPrimitive = If[Length@preWashResuspendDiluents>0,Transfer[Source->preWashResuspendDiluents,Amount->preWashResuspendDiluentVolumes,Destination->preWashResuspendSamples],{}];

  activationVolumes = PickList[Transpose[{resolvedActivationSampleVolumes, resolvedActivationReagentVolumes, resolvedActivationDiluentVolumes} /. Null -> 0Microliter],resolvedActivateBools,True];
  activationSamples = PickList[Transpose[{flatSimulatedSamples, resolvedActivationReagents, resolvedActivationDiluents}/.Null->Model[Sample,"id:8qZ1VWNmdLBD"]], resolvedActivateBools,True];
  activationContainers =  PickList[Lookup[flatSamplesMapThreadFriendlyOptions,ActivationContainer],resolvedActivateBools,True];
  activationDestinations = MapThread[
    If[MatchQ[#1,Null], #2, CreateUUID[]]&,
    {
      activationContainers,
      PickList[flatSimulatedSamples, resolvedActivateBools, True]
    }
  ];
  definePrimitives = MapThread[LabelContainer[Label->#1,Container->#2]&,{Cases[activationDestinations,_String],Cases[activationContainers,Except[Null]]}];
  consolidatePrimitives = If[Length@activationSamples>0,
    MapThread[
      Function[{samples, amounts, destination},
        MapThread[
          If[#2>0Microliter,Transfer[Source->#1, Amount->#2, Destination->destination], Nothing]&,
          {Flatten@samples, Flatten@amounts}]],
      {
        activationSamples,
        activationVolumes,
        activationDestinations
      }
    ],
    {}
  ];

  (*Simulate sample activation*)
  (* If there are no manipulations to simulate return the simulated cache*)
  activatedSamplesSimulation = If[MatchQ[Flatten@{prewashFilterPrimitive, prewashPelletPrimitive, prewashMagneticTransferPrimitive, prewashTransferPrimitive, consolidatePrimitives}, {}],
    updatedSimulation,
    Quiet@ExperimentSamplePreparation[
      Flatten@{definePrimitives, prewashFilterPrimitive, prewashPelletPrimitive, prewashMagneticTransferPrimitive, prewashTransferPrimitive, consolidatePrimitives},
      Cache -> simulatedCache,
      Simulation->updatedSimulation,
      Output->Simulation
    ]];

  (* make sure there's a way to escape without bugging out if ExperimentSamplPreparation isnt happy*)
  {simulatedActivatedSamples, defineLookup} = If[MatchQ[activatedSamplesSimulation, _Simulation],
    Lookup[activatedSamplesSimulation[[1]], {Packets, Labels}],
    {{},{}}
  ];

  (*Create the simulated sample list and updated cache*)
  (* first, we need to update the contents and contents log in the simulated container *)
  updatedActivatedContents=Map[
    Function[{containerAssociation},
      Module[{simulatedContainerWithUpdatedContents},
        (* obtain the container packet that have updated contents compared to the previous cache *)
        simulatedContainerWithUpdatedContents=SelectFirst[simulatedActivatedSamples,MatchQ[Lookup[#,Object],ObjectP[Lookup[containerAssociation,Object]]]&,{}];

        (* if there is simulated container in the new cache, update its contents; otherwise, keep as it is *)
        If[!MatchQ[simulatedContainerWithUpdatedContents,{}],
          Association@ReplaceRule[Normal@containerAssociation,
            {
              Contents->Lookup[simulatedContainerWithUpdatedContents,Contents,{}],
              ContentsLog->Join[Lookup[containerAssociation,ContentsLog,{}],Lookup[simulatedContainerWithUpdatedContents,ContentsLog,{}]]
            }
          ],
          containerAssociation
        ]
      ]
    ],
    Cases[simulatedCache,ObjectP[Object[Container]]]
  ];
  (* next, combined all the caches *)
  (* the order matters here: the container with updated contents needs to come first *)
  activationUpdatedCache=FlattenCachePackets[{updatedActivatedContents,simulatedCache,simulatedActivatedSamples}];

  simulationReplacePositions = Flatten@Position[resolvedActivateBools,True];
  simulatedActivationSamples = ReplacePart[flatSimulatedSamples,Thread[simulationReplacePositions->activationDestinations/.defineLookup]];

  (*resolve the Post activation wash options using the simulated samples. Make sure the pass the simulated sample packets in the cache*)
  postActivationWashFilterOptionNames = {
    PostActivationWashFiltrationType, PostActivationWashInstrument, PostActivationWashFilter,PostActivationWashFilterStorageCondition, PostActivationWashFilterMembraneMaterial,
    PostActivationWashPrefilterMembraneMaterial, PostActivationWashFilterPoreSize, PostActivationWashFilterMolecularWeightCutoff,
    PostActivationWashPrefilterPoreSize, PostActivationWashFiltrationSyringe, PostActivationWashSterileFiltration, PostActivationWashFilterHousing,
    PostActivationWashCentrifugationIntensity, PostActivationWashCentrifugationTime, PostActivationWashCentrifugationTemperature
  };

  postActivationWashPelletOptionNames ={
    PostActivationWashInstrument,PostActivationWashCentrifugationIntensity, PostActivationWashCentrifugationTime, PostActivationWashCentrifugationTemperature
  };

  postActivationWashMagneticTransferOptionNames = {PostActivationWashTime, PostActivationWashTemperature, PostActivationWashMagnetizationRack};

  postActivationWashFilterSamples = PickList[simulatedActivationSamples,resolvedPostActivationWashMethods,Filter];
  postActivationWashPelletSamples = PickList[simulatedActivationSamples,resolvedPostActivationWashMethods,Pellet];
  postActivationWashMagneticTransferSamples = PickList[simulatedActivationSamples,resolvedPostActivationWashMethods,Magnetic];

  postActivationWashFilterOptions = MapThread[#2->PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,#1],resolvedPostActivationWashMethods,Filter]&,{postActivationWashFilterOptionNames,filterOptionNames}];
  postActivationWashPelletOptions = MapThread[#2->PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,#1],resolvedPostActivationWashMethods,Pellet]&,{postActivationWashPelletOptionNames,pelletOptionNames}];
  postActivationWashMagnetizeOptions = MapThread[#2->PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,#1],resolvedPostActivationWashMethods,Magnetic]&,{postActivationWashMagneticTransferOptionNames,magneticTransferOptionNames}];

  postActivationWashFilterResolveFailure = Check[
    {resolvedPostActivationWashFilterOptions,postActivationWashFilterTests} = If[Length@postActivationWashFilterSamples>0,
      If[gatherTests,
        Quiet[ExperimentFilter[postActivationWashFilterSamples,Sequence@@postActivationWashFilterOptions,Cache->activationUpdatedCache,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentFilter[postActivationWashFilterSamples,Sequence@@postActivationWashFilterOptions,Cache->activationUpdatedCache,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[filterOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (*ExperimentPellet cannot take Time->Automatic or Temperature->Automatic so we must first replace those with the default options value*)
  postActivationWashPelletOptionsWithTime = ReplaceRule[postActivationWashPelletOptions, {Time -> Lookup[postActivationWashPelletOptions /. Automatic -> 5 Minute, Time], Temperature -> Lookup[postActivationWashPelletOptions /. Automatic -> Ambient, Temperature]}];
  postActivationWashPelletResolveFailure = Check[
    {resolvedPostActivationWashPelletOptions,postActivationWashPelletTests} = If[Length@postActivationWashPelletSamples>0,
      If[gatherTests,
        Quiet[ExperimentPellet[postActivationWashPelletSamples,Sequence@@postActivationWashPelletOptionsWithTime,Cache->activationUpdatedCache,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentPellet[postActivationWashPelletSamples,Sequence@@postActivationWashPelletOptionsWithTime,Cache->activationUpdatedCache,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[pelletOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  postActivationWashMagneticTransferResolveFailure = Check[
    {resolvedPostActivationWashMagneticTransferOptions,postActivationWashMagneticTransferTests} = If[Length@postActivationWashMagneticTransferSamples>0,
      If[gatherTests,
        Quiet[ExperimentTransfer[postActivationWashMagneticTransferSamples,Waste,All,Magnetization->True,Sequence@@postActivationWashMagnetizeOptions,Cache->activationUpdatedCache,Simulation->activatedSamplesSimulation,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentTransfer[postActivationWashMagneticTransferSamples,Waste,All,Magnetization->True,Sequence@@postActivationWashMagnetizeOptions,Cache->activationUpdatedCache,Simulation->activatedSamplesSimulation,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[magneticTransferOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (*Get the resolved options and assemble the index-matched list of options with the bioconjugation specific optionnames. Samples that are not getting filtered should have Filtration->False and all other options Null. Same for pellet*)
  postActivationWashFilterPositions = Position[resolvedPostActivationWashMethods,Filter];
  postActivationWashPelletPositions = Position[resolvedPostActivationWashMethods, Pellet];
  postActivationWashMagneticTransferPositions = Position[resolvedPostActivationWashMethods,Magnetic];

  resolvedPostActivationWashFilterOptionsFull = reformatResolvedOptions[postActivationWashFilterPositions,resolvedPostActivationWashFilterOptions,filterOptionNames,postActivationWashFilterOptionNames,Length@flatSimulatedSamples];
  resolvedPostActivationWashPelletOptionsFull = reformatResolvedOptions[postActivationWashPelletPositions,resolvedPostActivationWashPelletOptions,pelletOptionNames,postActivationWashPelletOptionNames,Length@flatSimulatedSamples];
  resolvedPostActivationWashMagnetOptionsFull = reformatResolvedOptions[postActivationWashMagneticTransferPositions, resolvedPostActivationWashMagneticTransferOptions, magneticTransferOptionNames, postActivationWashMagneticTransferOptionNames, Length@flatSimulatedSamples];

  (*Gather the resolved options we need for the pooled map thread option resolution below.*)
  pooledResolvedOptions = TakeList[Transpose[
    {resolvedPreWashResuspensions,resolvedPreWashResuspensionDiluentVolumes,resolvedActivateBools,
      resolvedActivationReactionVolumes,resolvedActivationSampleVolumes,resolvedPostActivationResuspensions,
      resolvedPostActivationResuspensionDiluentVolumes}
  ],poolingLengths];

(* -- Resolve CONJUGATION POOL index matched options -- *)

{resolvedConjugationReactionVolumes, resolvedTargetConjugationSampleConcentrations, resolvedConjugationReactionBufferVolumes, resolvedConcentratedConjugationReactionBufferDilutionFactors,
  resolvedConjugationReactionBufferDiluents, resolvedConjugationDiluentVolumes, resolvedConjugationTimes, resolvedConjugationTemperatures, resolvedConjugationMixTypes, resolvedConjugationMixVolumes, resolvedConjugationMixNumbers,
  resolvedConjugationMixRates,  resolvedQuenchBooleans, resolvedQuenchReactionVolumes, resolvedQuenchReagents, resolvedQuenchReagentDilutionFactors, resolvedQuenchReagentVolumes, resolvedQuenchTimes, resolvedQuenchTemperatures,
  resolvedQuenchMixes, resolvedQuenchMixTypes, resolvedQuenchMixVolumes, resolvedQuenchMixNumbers, resolvedQuenchMixRates, resolvedPostConjugationWorkupMethods, resolvedPostConjugationWorkupMixes, resolvedPostConjugationWorkupMixTypes, resolvedPostConjugationWorkupMixVolumes,
  resolvedPostConjugationWorkupMixNumbers, resolvedPostConjugationWorkupMixRates, resolvedPostConjugationResuspensions, resolvedPostConjugationResuspensionDiluents, resolvedPostConjugationResuspensionDiluentVolumes,
  resolvedPostConjugationResuspensionMixes, resolvedPostConjugationResuspensionMixTypes, resolvedPostConjugationResuspensionMixRates, resolvedPostConjugationResuspensionMixVolumes,
  resolvedPostConjugationResuspensionMixNumbers, resolvedPostConjugationResuspensionMixUntilDissolvedBools, resolvedPostConjugationResuspensionMaxMixNumbers, resolvedPostConjugationResuspensionTimes,
  resolvedPostConjugationResuspensionMaxTimes, resolvedPostConjugationResuspensionTemperatures, resolvedPredrainMethods, resolvedReactionVessels, invalidConjugationReactionVolumes,invalidConjugationReactionBufferVolumes,invalidConjugationMixVolumes,
  invalidDiluentVolumes,invalidQuenchReagentVolumes, invalidQuenchMixVolumes,
  invalidPostConjugationWorkupMixVolumes,invalidQuenchBooleans, invalidPostConjugationBooleans, invalidPostConjugationResuspensionVolumes,
  invalidPostConjugationResuspensionMixVolumes, invalidAnalyteConcentrations, invalidReactionVessels,resolvedProductCoefficients, unknownProductCoefficients} = Transpose[
  MapThread[
    Function[{samplePool, samplePoolOptions,samplePoolContainerModelPacket,samplePoolPacket,samplePoolIMPacket, poolResolvedOptions},
      Module[{resolvedConjugationReactionVolume, resolvedTargetConjugationSampleConcentration, resolvedConjugationReactionBufferVolume, resolvedConcentratedConjugationReactionBufferDilutionFactor,
        resolvedConjugationReactionBufferDiluent, resolvedConjugationDiluentVolume, resolvedConjugationTime, resolvedConjugationTemperature, resolvedConjugationMixType, resolvedConjugationMixVolume, resolvedConjugationNumberOfMixes,
        resolvedConjugationMixRate, resolvedPostConjugationWorkupMethod, resolvedPostConjugationWorkupMix, resolvedPostConjugationWorkupMixType, resolvedPostConjugationWorkupMixVolume,
        resolvedPostConjugationWorkupNumberOfMixes, resolvedPostConjugationWorkupMixRate, resolvedPostConjugationResuspension, resolvedPostConjugationResuspensionDiluent, resolvedPostConjugationResuspensionDiluentVolume,
        resolvedPostConjugationResuspensionMix, resolvedPostConjugationResuspensionMixType, resolvedPostConjugationResuspensionMixRate, resolvedPostConjugationResuspensionMixVolume,
        resolvedPostConjugationResuspensionNumberOfMixes, resolvedPostConjugationResuspensionMixUntilDissolved, resolvedPostConjugationResuspensionMaxNumberOfMixes, resolvedPostConjugationResuspensionTime,
        resolvedPostConjugationResuspensionMaxTime, resolvedQuenchBoolean, resolvedQuenchReactionVolume, resolvedQuenchReagent, resolvedQuenchReagentDilutionFactor, resolvedQuenchReagentVolume, resolvedQuenchTime, resolvedQuenchTemperature,
        resolvedQuenchMix, resolvedQuenchMixType, resolvedQuenchMixVolume, resolvedQuenchNumberOfMixes,resolvedPostConjugationResuspensionTemperature, resolvedQuenchMixRate, resolvedPredrainMethod,
        resolvedReactionVessel, invalidConjugationReactionVolume,invalidConjugationReactionBufferVolume,invalidConjugationMixVolume,
        invalidDiluentVolume,invalidQuenchReagentVolume, invalidQuenchMixVolume,
        invalidPostConjugationWorkupMixVolume,invalidQuenchBoolean, invalidPostConjugationBoolean, invalidPostConjugationResuspensionVolume,defaultPostConjugationMixUntilDissolved,
        invalidPostConjugationResuspensionMixVolume, invalidAnalyteConcentration, invalidReactionVessel,resolvedProductCoefficient, unknownProductCoefficient,defaultProductCoefficient,calculatedConjugationAmounts,postConjugationSampleVolume,

        (*Defaults*)
        defaultConjugationReactionVolume,sampleAnalytes,sampleAnalyteConcentration, sampleAnalyteObject,convertedSampleAnalyeConcentration,sampleConjugationAmount,prewashConcentrationAdjustment,activationConcentrationAdjustment,postActivationConcentrationAdjustment,
        updatedAnalyteConcentration,defaultTargetSampleConcentration,defaultConjugationReactionBufferVolume,defaultConcentratedConjugationReactionBufferDilutionFactor,defaultConjugationReactionBufferDiluent,conjugationDiluentVolume,defaultConjugationTime, defaultConjugationTemperature,
        defaultConjugationMixType,defaultConjugationMixVolume, defaultConjugationNumberOfMixes,defaultConjugatonMixRate,defaultQuenchBoolean,defaultQuenchReagent, defaultQuenchReagentDilutionFactor, defaultQuenchTime,defaultQuenchTemperature,defaultQuenchMix,
        defaultQuenchReactionVolume, defaultQuenchReagentVolume,defaultQuenchMixType,defaultQuenchMixVolume, defaultQuenchNumberOfMixes,defaultQuenchMixRate,defaultPredrainMethod,defaultPostConjugationWorkupMethod,defaultPostConjugationMix,defaultPostConjugationWorkupMixType,
        defaultPostConjugationWorkupMixVolume, defaultPostConjugationWorkupNumberOfMixes,defaultPostConjugationWorkupMixRate,defaultPostConjugationResuspension,defaultPostConjugationResuspensionTime, defaultPostConjugationResuspensionTemperature,defaultPostConjugationResuspensionDiluent, defaultPostConjugationResuspensionMix,
        defaultPostConjugationResuspensionDiluentVolume,defaultPostConjugationResuspensionMixType,defaultPostConjugationResuspensionMixVolume, defaultPostConjugationResuspensionNumberOfMixes,defaultPostConjugationResuspensionMaxNumberOfMixes,
        defaultPostConjugationResuspensionMixRate,defaultPostConjugationResuspensionMaxTime,maxReactionVolume,solidPhaseSampleContainers,preferredContainerPickListBoolean,preferredSampleContainers,defaultReactionVessel,
        resolvedReactionVesselMaxVolume,defaultConjugationSamplePoolVolume
      },

        (*--- PRODUCT COEFFICIENT ---*)
        (*Set the default value*)
        defaultProductCoefficient = 1;

        (*Resolve the product coefficient*)
        {resolvedProductCoefficient} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ProductStoichiometricCoefficient}],{defaultProductCoefficient}];

        (*If the option is automatic warn the user that we are setting the coefficient to 1 and this may not be accurate*)
        unknownProductCoefficient = If[MatchQ[Lookup[samplePoolOptions,{ProductStoichiometricCoefficient}], Automatic|{Automatic}], True, False];

        (*--- CONJUGATION ---*)
        (*Resolve conjugation reaction volumes*)

        (*Set default values*)

        (*Set the default reaction volumes to the sum of the total volume of all samples being conjugated*)
       calculatedConjugationAmounts = MapThread[If[MatchQ[#1,All],Lookup[#2,Volume] ,#1]&,{Lookup[samplePoolOptions,ConjugationAmount],samplePoolPacket}];

        defaultConjugationSamplePoolVolume = Total[Flatten@MapThread[Switch[{#2[[6]],#2[[3]],#2[[1]]},
          (*If the sample has been activated and resuspended use the resuspension volume*)
          {True,_,_}, Convert[#2[[7]],Microliter],

          (*If the sample has been activated use the activation volume*)
          {_,True,_}, Convert[#2[[4]],Microliter],

          (*If the sample has been prewashed use the prewash resuspension volume*)
          {_,_,True}, Convert[#2[[2]],Microliter],

          (*If none of the above use the full original sample volume*)
          {_,_,_}, Convert[#3,Microliter]
        ]&,
          {samplePool, poolResolvedOptions,calculatedConjugationAmounts}
        ]/.Null->0*Microliter];

        defaultConjugationReactionVolume = If[
          MatchQ[Lookup[samplePoolOptions,ConjugationReactionBufferVolume],Null|Automatic|{Null}|{Automatic}],
          defaultConjugationSamplePoolVolume,
          Total[Flatten@{defaultConjugationSamplePoolVolume,Lookup[samplePoolOptions,ConjugationReactionBufferVolume]}]
        ];

        {resolvedConjugationReactionVolume} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ConjugationReactionVolume}],{defaultConjugationReactionVolume}];

        (*Set the target concentration default to the value of concentration* sample volume/conjugation reaction volume*)
        (*First we must find or calculate the sample concentration*)
        (*First find all the anaylte objects*)
        sampleAnalytes = Map[
          If[MatchQ[Download[Lookup[#,Analytes],Object], {}],
            Download[FirstCase[Lookup[#,Composition],{Except[Null], ObjectP[{Model[Molecule,Protein],Model[Molecule,Oligomer], Model[Molecule, Polymer], Model[Resin], Model[ProprietaryFormulation]}]},{Null,Null}][[2]],Object],
            Download[Lookup[#,Analytes],Object]
          ]&,
          Flatten[samplePoolPacket]
        ];

        {sampleAnalyteConcentration, sampleAnalyteObject} = Transpose@MapThread[
          Flatten[
            FirstCase[
              Lookup[#1,Composition],
              {Except[Null], ObjectP[Flatten[{#2}]]},
              {}
            ]/.{}->{Null,Null}
          ]&,
          {Flatten@samplePoolPacket,sampleAnalytes}
        ];

        convertedSampleAnalyeConcentration =MapThread[
          Switch[{MassConcentrationQ[#1],MassPercentQ[#1],VolumePercentQ[#1],MassQ[#1]},
          (*If given a mass concentration convert using the molecular weight*)
            {True, False, False,False}, Convert[#1/Lookup[Cases[DeleteDuplicates@Flatten@#2, KeyValuePattern[Object->Download[#3,Object]]],MolecularWeight], Micromolar],
            {_, False, False,False}, Convert[#1,Micromolar],
            {_,_,_,_}, Null
        ]&,
          {sampleAnalyteConcentration,samplePoolIMPacket,sampleAnalyteObject}
        ];

        invalidAnalyteConcentration = If[QuantityQ[#],False,True]&/@Flatten[convertedSampleAnalyeConcentration];

        (*Look up what the ConjugationAmount is*)
        sampleConjugationAmount = Lookup[samplePoolOptions,ConjugationAmount];

        (*Find the concentration adjustment factors from any previous steps*)
        prewashConcentrationAdjustment = Lookup[Flatten@samplePoolPacket,Volume]/poolResolvedOptions[[All,2]];
        activationConcentrationAdjustment = poolResolvedOptions[[All,5]]/poolResolvedOptions[[All,4]];
        postActivationConcentrationAdjustment = poolResolvedOptions[[All,4]]/poolResolvedOptions[[All,7]];

        (*make the necessary concentration adjustments from the previous steps*)
        updatedAnalyteConcentration = MapThread[
          #1*Times[Cases[{#2,#3,#4},NumberP]/.List->Sequence]&,
          {convertedSampleAnalyeConcentration,prewashConcentrationAdjustment,activationConcentrationAdjustment,postActivationConcentrationAdjustment}
        ];

        (*set the default target sample concentration*)
        defaultTargetSampleConcentration = MapThread[
          Switch[{#1,QuantityQ[#2],GreaterQ[QuantityMagnitude[resolvedConjugationReactionVolume],0]},
            {MassP,True,True}, Convert[#1/resolvedConjugationReactionVolume,Milligram/Milliliter],
            {VolumeP,True,True}, #2*#1/resolvedConjugationReactionVolume,
            {_,True,True}, #2*#3/resolvedConjugationReactionVolume,
            {_,False,_}, Null,
            {_,_,False}, Null
          ]&,
          {sampleConjugationAmount,updatedAnalyteConcentration,ConstantArray[defaultConjugationReactionVolume,Length@samplePool]}
        ];

        resolvedTargetConjugationSampleConcentration = resolveAutomaticOptions[Flatten@Lookup[samplePoolOptions,{TargetConjugationSampleConcentration}],defaultTargetSampleConcentration];

        (*Set the default conjugation reaction buffer options*)
        defaultConjugationReactionBufferVolume = If[
          MatchQ[Lookup[samplePoolOptions,ConjugationReactionBuffer], ObjectP[]|{ObjectP[]}]||MatchQ[Lookup[samplePoolOptions,ConcentratedConjugationReactionBuffer],ObjectP[]|{ObjectP[]}],
          resolvedConjugationReactionVolume-defaultConjugationReactionVolume,
          Null
        ];

        defaultConcentratedConjugationReactionBufferDilutionFactor = If[
          MatchQ[Lookup[samplePoolOptions,ConcentratedConjugationReactionBuffer],ObjectP[]],
          1,
          Null
        ];

        {resolvedConjugationReactionBufferVolume,resolvedConcentratedConjugationReactionBufferDilutionFactor} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ConjugationReactionBufferVolume,ConcentratedConjugationReactionBufferDilutionFactor}],{defaultConjugationReactionBufferVolume,defaultConcentratedConjugationReactionBufferDilutionFactor}];

        {defaultConjugationReactionBufferDiluent,conjugationDiluentVolume} = If[
          MatchQ[Lookup[samplePoolOptions,ConcentratedConjugationReactionBuffer],ObjectP[]|{ObjectP[]}],
          {Model[Sample, StockSolution, "1x PBS from 10X stock"],Convert[resolvedConjugationReactionBufferVolume*(1-1/resolvedConcentratedConjugationReactionBufferDilutionFactor),Microliter] },
          {Null,Null}
        ];
        {resolvedConjugationReactionBufferDiluent,resolvedConjugationDiluentVolume} = resolveAutomaticOptions[Flatten@Lookup[samplePoolOptions,{ConjugationReactionBufferDiluent,ConjugationDiluentVolume}],{defaultConjugationReactionBufferDiluent,conjugationDiluentVolume}];

        {defaultConjugationTime, defaultConjugationTemperature} = Switch[Lookup[samplePoolOptions,ReactionChemistry],
          NHSester, {4*Hour, Ambient},
          Carbodiimide, {2*Hour, Ambient},
          Maleimide, {2*Hour, Ambient},
          _, {18*Hour, 4Celsius}
        ];

        {resolvedConjugationTime, resolvedConjugationTemperature} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ConjugationTime,ConjugationTemperature}],{defaultConjugationTime, defaultConjugationTemperature}];

        (*---CONJUGATION MIX---*)
        (*Set the default options*)
        defaultConjugationMixType = Switch[Flatten@Join[Lookup[samplePoolOptions,{ConjugationMix}],Lookup[samplePoolOptions,{ConjugationMixVolume,ConjugationNumberOfMixes,ConjugationMixRate}]],

          (*If number of mixes is specified but volume is Null default to Invert*)
          {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

          (*If a mix volume and number are specified default to Pipette*)
          {True, Except[Null|Automatic], Except[Null|Automatic], Null|Automatic}, Pipette,

          (*In any other case when ConjugationMix is True, default to Shake*)
          {True,_,_,_}, Shake,

          (*In any other case when ConjugationMix is False, default to Null*)
          {_,_,_,_}, Null
        ];

        (*resolve the MixType so the defaults can be set based on the resolved value*)
        {resolvedConjugationMixType} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ConjugationMixType}],{defaultConjugationMixType}];

        {defaultConjugationMixVolume, defaultConjugationNumberOfMixes,defaultConjugatonMixRate}= Switch[resolvedConjugationMixType,

          (*if ConjugationMixtype is pipette, set volume to half the reaction volume, number of mixes to 5, and rate to Null*)
          Pipette, {SafeRound[Convert[0.5*resolvedConjugationReactionVolume,Microliter],0.1*Microliter], 5, Null},

          (*If ConjugationMixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
          Invert, {Null, 5, Null},

          (*If ConjugationMixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
          Except[Null], {Null, Null, 800*RPM},

          (*if ConjugationMixtype is Null set all options to Null*)
          Null, {Null, Null, Null}
        ];

        {resolvedConjugationMixVolume, resolvedConjugationNumberOfMixes, resolvedConjugationMixRate} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ConjugationMixVolume,ConjugationNumberOfMixes,ConjugationMixRate}], {defaultConjugationMixVolume, defaultConjugationNumberOfMixes,defaultConjugatonMixRate}];

        (*---QUENCH---*)

        (*Set defaults*)
        defaultQuenchBoolean = Switch[{Lookup[samplePoolOptions,ReactionChemistry],MemberQ[Lookup[samplePoolOptions,{QuenchReagent, QuenchReagentDilutionFactor, QuenchTime,QuenchTemperature,QuenchMix}],Except[Null|Automatic]]},
          {NHSester,_} , True,
          {Carbodiimide,_}, True,
          {_,True}, True,
          _, False
        ];

        {resolvedQuenchBoolean} = resolveAutomaticOptions[Lookup[samplePoolOptions,{QuenchConjugation}], {defaultQuenchBoolean}];

        {defaultQuenchReagent, defaultQuenchReagentDilutionFactor,
          defaultQuenchTime,defaultQuenchTemperature,defaultQuenchMix} = Switch[{Lookup[samplePoolOptions,ReactionChemistry],resolvedQuenchBoolean,Lookup[samplePoolOptions,QuenchReagentVolume]},
          {NHSester,True,_} , { Model[Sample, StockSolution, "500 mM TrisHCl, pH 7.4"], 5, 15Minute, Ambient , True},
          {Carbodiimide,True,_}, { Model[Sample, StockSolution, "10x PBS with 5% BSA, pH 7.4"], 10 , 15*Minute , Ambient , True},
          {_,True,_}, {Model[Sample, StockSolution, "1x PBS from 10X stock"],1,15*Minute,Ambient,True},
          {_,False,_}, {Null,Null,Null,Null,Null}
        ];

        {resolvedQuenchReagent, resolvedQuenchReagentDilutionFactor,
          resolvedQuenchTime,resolvedQuenchTemperature,resolvedQuenchMix} = resolveAutomaticOptions[
          Lookup[samplePoolOptions,{QuenchReagent, QuenchReagentDilutionFactor, QuenchTime,QuenchTemperature,QuenchMix}],
          {defaultQuenchReagent, defaultQuenchReagentDilutionFactor, defaultQuenchTime,defaultQuenchTemperature,defaultQuenchMix}
        ];

        {defaultQuenchReactionVolume, defaultQuenchReagentVolume} = Switch[{resolvedQuenchReagentDilutionFactor,Lookup[samplePoolOptions,PredrainReactionMixture]},
          {GreaterP[1],False} , { resolvedConjugationReactionVolume + resolvedConjugationReactionVolume/(resolvedQuenchReagentDilutionFactor-1) ,resolvedConjugationReactionVolume/(resolvedQuenchReagentDilutionFactor-1)},
          {EqualP[1], False}, { 2*resolvedConjugationReactionVolume, resolvedConjugationReactionVolume },
          {GreaterP[1],True} , { 500*Microliter , 500*Microliter/(resolvedQuenchReagentDilutionFactor-1)},
          {EqualP[1], True}, { 500Microliter, 500*Microliter },
          {EqualP[0], False}, { resolvedConjugationReactionVolume+Lookup[samplePoolOptions,QuenchReagentVolume], 500*Microliter },
          {EqualP[0], True}, { Lookup[samplePoolOptions,QuenchReagentVolume], 500*Microliter },
          {Null,_}, {Null,Null}
        ];

        {resolvedQuenchReactionVolume, resolvedQuenchReagentVolume} = resolveAutomaticOptions[Lookup[samplePoolOptions,{QuenchReactionVolume,QuenchReagentVolume}],{defaultQuenchReactionVolume, defaultQuenchReagentVolume}];

        (*---QUENCH MIX---*)
        (*Set the default options*)
        defaultQuenchMixType = Switch[Join[{resolvedQuenchMix},Lookup[samplePoolOptions,{QuenchMixVolume,QuenchNumberOfMixes,QuenchMixRate}]],

          (*If number of mixes is specified but volume is Null default to Invert*)
          {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

          (*If a mix volume and number are specified default to Pipette*)
          {True, Except[Null|Automatic], Except[Null|Automatic], Null|Automatic}, Pipette,

          (*In any other case when QuenchMix is True, default to Shake*)
          {True,_,_,_}, Shake,

          (*In any other case when QuenchMix is False, default to Null*)
          {_,_,_,_}, Null
        ];

        (*resolve the MixType so the defaults can be set based on the resolved value*)
        {resolvedQuenchMixType} = resolveAutomaticOptions[Lookup[samplePoolOptions,{QuenchMixType}],{defaultQuenchMixType}];

        {defaultQuenchMixVolume, defaultQuenchNumberOfMixes,defaultQuenchMixRate}= Switch[resolvedQuenchMixType,

          (*if Mixtype is pipette, set volume to half the reaction volume, number of mixes to 5, and rate to Null*)
          Pipette, {SafeRound[Convert[0.5*resolvedQuenchReactionVolume,Microliter],0.1*Microliter], 5, Null},

          (*If Mixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
          Invert, {Null, 5, Null},

          (*If Mixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
          Except[Null], {Null, Null, 800*RPM},

          (*if Mixtype is Null set all options to Null*)
          Null, {Null, Null, Null}
        ];

        {resolvedQuenchMixVolume, resolvedQuenchNumberOfMixes, resolvedQuenchMixRate} = resolveAutomaticOptions[Lookup[samplePoolOptions,{QuenchMixVolume,QuenchNumberOfMixes,QuenchMixRate}], {defaultQuenchMixVolume, defaultQuenchNumberOfMixes,defaultQuenchMixRate}];

        (*---PREDRAIN METHOD---*)

        defaultPredrainMethod = If[Lookup[samplePoolOptions,PredrainReactionMixture],
          If[MemberQ[Flatten@Lookup[samplePoolOptions,{PredrainMagnetizationRack,PredrainMagnetizationTime}],Except[Null|Automatic]],
            Magnetic,
            Pellet
          ],
          Null
        ];
        {resolvedPredrainMethod} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PredrainMethod}],{defaultPredrainMethod}];

       (*---POST CONJUGATION WORKUP---*)

        (*Set defaults*)
        defaultPostConjugationWorkupMethod = If[Lookup[samplePoolOptions,PostConjugationWorkup],
          (*set the method to be consistent with any other methods specified otherwise set to Pellet*)
          Switch[
            {
              MemberQ[Flatten@Lookup[samplePoolOptions,{PostConjugationFiltrationType, PostConjugationFilter, PostConjugationFilterMembraneMaterial, PostConjugationPrefilterMembraneMaterial, PostConjugationFilterPoreSize, PostConjugationFilterMolecularWeightCutoff, PostConjugationPrefilterPoreSize, PostConjugationFiltrationSyringe, PostConjugationFilterHousing}],Except[Null|Automatic]],
              MemberQ[Flatten@Lookup[samplePoolOptions,{PostConjugationMagnetizationRack}],Except[Null|Automatic]]
            },
            {True,False}, Filter,
            {False,True}, Magnetic,
            {_,_}, Pellet
          ],
          Null
        ];
        {resolvedPostConjugationWorkupMethod} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationWorkupMethod}],{defaultPostConjugationWorkupMethod}];

        defaultPostConjugationMix = If[MatchQ[Lookup[samplePoolOptions,PostConjugationWorkupBuffer],ObjectP[]],True,False];
        {resolvedPostConjugationWorkupMix} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationWorkupMix}],{defaultPostConjugationMix}];

        (*---POST CONJUGATION MIX---*)
        (*Set the default options*)
        defaultPostConjugationWorkupMixType = Switch[Join[{resolvedPostConjugationWorkupMix},Lookup[samplePoolOptions,{PostConjugationWorkupMixVolume,PostConjugationWorkupNumberOfMixes,PostConjugationWorkupMixRate}]],

          (*If number of mixes is specified but volume is Null default to Invert*)
          {True, Null, Except[Null|Automatic], Null|Automatic}, Invert,

          (*If a mix rate is specified default to Shake*)
          {True, Null|Automatic, Null|Automatic, Except[Null|Automatic]}, Shake,

          (*In any other case when Mix is True, default to Pipette*)
          {True,_,_,_}, Pipette,

          (*In any other case when Mix is False, default to Null*)
          {_,_,_,_}, Null
        ];

        (*resolve the MixType so the defaults can be set based on the resolved value*)
        {resolvedPostConjugationWorkupMixType} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationWorkupMixType}],{defaultPostConjugationWorkupMixType}];

        (*The default mix volume should be ~half the current sample volume after mixing with post-conjugation buffer*)
        postConjugationSampleVolume = If[MatchQ[resolvedQuenchReactionVolume,Null],

          (*If we are not quenching then add conjugation reaction volume and post-conjugation buffer volume*)
          (resolvedConjugationReactionVolume + Lookup[samplePoolOptions,PostConjugationWorkupBufferVolume])/.Null->0Microliter,

          (*If we are quenching, then add quenchreaction volume and post-conjugation buffer volume*)
          (resolvedQuenchReactionVolume + Lookup[samplePoolOptions,PostConjugationWorkupBufferVolume])/.Null->0Microliter
        ]/.List->Sequence;

        {defaultPostConjugationWorkupMixVolume, defaultPostConjugationWorkupNumberOfMixes,defaultPostConjugationWorkupMixRate}= Switch[resolvedPostConjugationWorkupMixType,

          (*if Mixtype is pipette, set volume to half the reaction volume, number of mixes to 5, and rate to Null*)
          Pipette, {SafeRound[Convert[0.5*postConjugationSampleVolume,Microliter],0.1Microliter], 5, Null},

          (*If Mixtype is invert, set volume to Null, number of mixes to 5, and rate to Null*)
          Invert, {Null, 5, Null},

          (*If Mixtype is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
          Except[Null], {Null, Null, 800*RPM},

          (*if Mixtype is Null set all options to Null*)
          Null, {Null, Null, Null}
        ];

        {resolvedPostConjugationWorkupMixVolume, resolvedPostConjugationWorkupNumberOfMixes, resolvedPostConjugationWorkupMixRate} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationWorkupMixVolume,PostConjugationWorkupNumberOfMixes,PostConjugationWorkupMixRate}], {defaultPostConjugationWorkupMixVolume, defaultPostConjugationWorkupNumberOfMixes,defaultPostConjugationWorkupMixRate}];

        (*---POST CONJUGATION RESUSPENSION---*)

        (* Set the default options *)
        defaultPostConjugationResuspension = If[
          (*If PostConjugationWorkup is True and any resuspension options are specified set to True*)
          Lookup[samplePoolOptions,PostConjugationWorkup] && MemberQ[Lookup[samplePoolOptions,{PostConjugationResuspensionTime,PostConjugationResuspensionTime,PostConjugationResuspensionDiluent,PostConjugationResuspensionDiluentVolume}],Except[Null|Automatic]],
          True,
          (*In all other cases set to False*)
          False
        ];

        {resolvedPostConjugationResuspension} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationResuspension}],{defaultPostConjugationResuspension}];

        {defaultPostConjugationResuspensionTime, defaultPostConjugationResuspensionTemperature,defaultPostConjugationResuspensionDiluent, defaultPostConjugationResuspensionMix}= If[

          (*if PostConjugation resuspension boolean is true*)
          resolvedPostConjugationResuspension,

          (*set time to 1 minute, temperature to Ambient, diluent to 1xPBS, and mix to True*)
          {1*Minute, Ambient,Model[Sample,StockSolution,"id:J8AY5jwzPdaB"], True},

          (*If resolvedPostConjugationResuspension is False set to Null*)
          {Null,Null,Null,Null}
        ];

        defaultPostConjugationResuspensionDiluentVolume = If[

          (*if PostConjugationResuspension boolean is true*)
          resolvedPostConjugationResuspension,

          (*set the Volume to the conjugation reaction volume*)
         resolvedConjugationReactionVolume,

          (*If PostConjugationResuspension is False set to Null*)
          Null
        ];

        (*Resolve automatic options or accept user specified options*)
        { resolvedPostConjugationResuspensionTime, resolvedPostConjugationResuspensionTemperature, resolvedPostConjugationResuspensionDiluent, resolvedPostConjugationResuspensionDiluentVolume, resolvedPostConjugationResuspensionMix} = resolveAutomaticOptions[
          Flatten@Lookup[samplePoolOptions,{PostConjugationResuspensionTime,PostConjugationResuspensionTemperature,PostConjugationResuspensionDiluent,PostConjugationResuspensionDiluentVolume,PostConjugationResuspensionMix}],
          {defaultPostConjugationResuspensionTime, defaultPostConjugationResuspensionTemperature,defaultPostConjugationResuspensionDiluent, defaultPostConjugationResuspensionDiluentVolume, defaultPostConjugationResuspensionMix}
        ];

        (*---POST CONJUGATION RESUSPENSION MIX---*)
        (*Set the default options*)
        defaultPostConjugationResuspensionMixType = Switch[
          Join[
            {resolvedPostConjugationResuspensionMix},
            Lookup[samplePoolOptions,{PostConjugationResuspensionMixVolume}],
            {MemberQ[Lookup[samplePoolOptions,{PostConjugationResuspesionNumberOfMixes,PostConjugationResuspensionMaxNumberOfMixes}],Except[Null]]},
            {MemberQ[Lookup[samplePoolOptions,{PostConjugationResuspensionMixRate,PostConjugationResuspensionTime,PostConjugationResuspensionMaxTime}],Except[Null]]}
          ],

          (*If number of mixes or max mixes is specified but volume is Null default to Invert*)
          {True, Null, True, False}, Invert,

          (*If a mix rate or Time or maxTime are specified but no other parameters are specified default to Vortex*)
          {True, Null|Automatic, False, True}, Vortex,

          (*In any other case when PostConjugationMix is True, default to Pipette*)
          {True,_,_,_}, Pipette,

          (*In any other case when PostConjugationMix is False, default to Null*)
          {_,_,_,_}, Null
        ];

        (*resolve the MixType so the defaults can be set based on the resolved value*)
        {resolvedPostConjugationResuspensionMixType} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationResuspensionMixType}],{defaultPostConjugationResuspensionMixType}];

        {defaultPostConjugationResuspensionMixVolume, defaultPostConjugationResuspensionNumberOfMixes,defaultPostConjugationResuspensionMaxNumberOfMixes,
          defaultPostConjugationResuspensionMixRate,defaultPostConjugationResuspensionTime,defaultPostConjugationResuspensionMaxTime}= Switch[resolvedPostConjugationResuspensionMixType,

          (*if resolvedPostConjugationResuspensionMixType is pipette, set volume to half the buffer volume, number of mixes to 5, and rate to Null*)
          Pipette, {SafeRound[Convert[0.5*resolvedPostConjugationResuspensionDiluentVolume,Microliter],0.1Microliter], 5, 20, Null, Null, Null},

          (*If resolvedPostConjugationResuspensionMixType is invert, set volume to Null, number of mixes to 5, and rate to Null*)
          Invert, {Null, 5, 20, Null, Null, Null},

          (*If resolvedPostConjugationResuspensionMixType is anything else but not Null, set volume to Null, number of mixes to Null, and rate to 800RPM*)
          Except[Null], {Null, Null, Null, 800*RPM, 15Minute, 30Minute},

          (*if resolvedPostConjugationResuspensionMixType is Null set all options to Null*)
          Null, {Null, Null, Null, Null, Null, Null}
        ];

        {resolvedPostConjugationResuspensionMixVolume, resolvedPostConjugationResuspensionNumberOfMixes,resolvedPostConjugationResuspensionMaxNumberOfMixes,
          resolvedPostConjugationResuspensionMixRate,resolvedPostConjugationResuspensionTime,resolvedPostConjugationResuspensionMaxTime} = resolveAutomaticOptions[
          Lookup[samplePoolOptions,{PostConjugationResuspensionMixVolume, PostConjugationResuspensionNumberOfMixes,PostConjugationResuspensionMaxNumberOfMixes,
          PostConjugationResuspensionMixRate,PostConjugationResuspensionTime,PostConjugationResuspensionMaxTime}],
          {defaultPostConjugationResuspensionMixVolume, defaultPostConjugationResuspensionNumberOfMixes,defaultPostConjugationResuspensionMaxNumberOfMixes,
            defaultPostConjugationResuspensionMixRate,defaultPostConjugationResuspensionTime,defaultPostConjugationResuspensionMaxTime}
        ];


        defaultPostConjugationMixUntilDissolved = Switch[{resolvedPostConjugationResuspensionMaxNumberOfMixes, resolvedPostConjugationResuspensionMaxTime},
          {Except[Null], _}, True,
          {_,Except[Null]}, True,
          {_,_}, False
        ];

        {resolvedPostConjugationResuspensionMixUntilDissolved} = resolveAutomaticOptions[Lookup[samplePoolOptions,{PostConjugationResuspensionMixUntilDissolved}],{defaultPostConjugationMixUntilDissolved}];

        (*--REACTION VESSEL---*)

        (* Set default vessel *)
        maxReactionVolume = Switch[Lookup[samplePoolOptions,PredrainReactionMixture],
          True, Max[Total@Cases[Flatten@{resolvedConjugationReactionVolume},_Quantity],Total@Cases[Flatten@{resolvedQuenchReactionVolume, Lookup[samplePoolOptions,PostConjugationWorkupBufferVolume]},_Quantity]],
          False, Total@Cases[Flatten@{resolvedConjugationReactionVolume,resolvedQuenchReagentVolume,Lookup[samplePoolOptions,PostConjugationWorkupBufferVolume]},_Quantity]
        ];

        (*If the pool contains a solid phase sample and the ConjugationAmout is All, we want to add the reaction components to its container so that the solidphase sample is not moved. Trying to move a slurry around results in sample loss so we want to minimize that.*)
        (*Instead of using the State of the identity models we will use the type and select for SolidPhaseSupports. The State of an identity model can be Solid but the sample be Liquid because the protein or molecule is dissolved in a buffer so it would be much harder to discern the current state of the sample.*)
        (*If more than one conjugation sample is a solidphase support just take the first one.*)

        solidPhaseSampleContainers = Flatten[MapThread[
          Switch[{#1, MemberQ[Lookup[Flatten@#2/.Null->Nothing,Object], ObjectP[Model[Resin,SolidPhaseSupport]]]||MatchQ[#4,Solid|Slurry]},
            {All, True}, #3,
            {_,_}, {}
          ]&,
          {Lookup[samplePoolOptions,ConjugationAmount],samplePoolIMPacket, Lookup[Flatten@samplePoolPacket,Container],Lookup[Flatten@samplePoolPacket,State]}
         ]
        ];

        (*If the pool does not contain a solidphasesupport choose the smallest sample container the can accomodate the maxreactionvolume.*)
        preferredContainerPickListBoolean = MapThread[
          If[
          MatchQ[#1,_Quantity]&&(!MemberQ[#2,Except[All]])&&MatchQ[#3,!True],
          #1 >= maxReactionVolume,
          False
        ]&,
          {Lookup[Flatten@samplePoolContainerModelPacket,MaxVolume], Lookup[samplePoolOptions,ConjugationAmount],Lookup[Flatten@samplePoolContainerModelPacket,Deprecated]}
        ];

        preferredSampleContainers = If[Length@solidPhaseSampleContainers>0,
          {},
          PickList[samplePoolContainerModelPacket,preferredContainerPickListBoolean,True]
        ];

        defaultReactionVessel = Switch[{Length@solidPhaseSampleContainers>0, Length@preferredSampleContainers>0},
          {True,_}, First@solidPhaseSampleContainers,
          {_,True}, Sequence@@Lookup[TakeSmallestBy[Flatten@samplePoolContainerModelPacket,Lookup[#,MaxVolume]&,1],Object],
          {_,_}, PreferredContainer[maxReactionVolume,Type->Vessel]
        ];
        

        {resolvedReactionVessel} = resolveAutomaticOptions[Lookup[samplePoolOptions,{ReactionVessel}],{defaultReactionVessel}];

        (*---ERROR CHECKING---*)

        invalidConjugationReactionVolume = If[QuantityQ[resolvedConjugationReactionVolume/.List->Sequence]&&GreaterQ[QuantityMagnitude[resolvedConjugationReactionVolume/.List->Sequence],0], False, True];
        invalidConjugationReactionBufferVolume = Switch[{Lookup[samplePoolOptions,ConjugationReactionBuffer],Lookup[samplePoolOptions,ConcentratedConjugationReactionBuffer], QuantityQ[resolvedConjugationReactionBufferVolume], QuantityMagnitude[resolvedConjugationReactionBufferVolume]},
          {ObjectP[],_, False, _}, True,
          {ObjectP[],_, True, LessP[0]}, True,
          {_,ObjectP[], False, _}, True,
          {_,ObjectP[], True, LessP[0]}, True,
          {_,_,_,_}, False
        ];

        invalidConjugationMixVolume = Switch[{Lookup[samplePoolOptions,ConjugationMix],resolvedConjugationMixType},
          {True, Pipette}, !QuantityQ[resolvedConjugationMixVolume] || LessEqualQ[QuantityMagnitude[resolvedConjugationMixVolume],0] || GreaterQ[resolvedConjugationMixVolume,resolvedConjugationReactionVolume/.List->Sequence],
          {True, _ }, MatchQ[resolvedConjugationMixVolume,Except[Null]],
          {False, _ },  MatchQ[resolvedConjugationMixVolume,Except[Null]],
          {_,_}, False
        ];

        invalidDiluentVolume = Switch[Lookup[samplePoolOptions,ConcentratedConjugationReactionBuffer],
          ObjectP[], !QuantityQ[resolvedConjugationDiluentVolume] || LessEqualQ[QuantityMagnitude[resolvedConjugationDiluentVolume],0],
          Null, MatchQ[resolvedConjugationDiluentVolume,Except[Null]],
          _, False
        ];

        invalidQuenchReagentVolume = Switch[resolvedQuenchReagent,
          ObjectP[], !QuantityQ[resolvedQuenchReagentVolume] || LessEqualQ[QuantityMagnitude[resolvedQuenchReagentVolume],0],
          Null, MatchQ[resolvedQuenchReagentVolume,Except[Null]],
          _, False
        ];

        invalidQuenchMixVolume = Switch[{resolvedQuenchMix,resolvedQuenchMixType},
          {True, Pipette}, !QuantityQ[resolvedQuenchMixVolume] || LessEqualQ[QuantityMagnitude[resolvedQuenchMixVolume],0]||GreaterQ[resolvedQuenchMixVolume,resolvedQuenchReactionVolume],
          {True, _ }, MatchQ[resolvedQuenchMixVolume,Except[Null]],
          {False, _ },  MatchQ[resolvedQuenchMixVolume,Except[Null]],
          {_,_}, False
        ];

        invalidPostConjugationWorkupMixVolume = Switch[{resolvedPostConjugationWorkupMix,resolvedPostConjugationWorkupMixType},
          {True, Pipette}, !QuantityQ[resolvedPostConjugationWorkupMixVolume] || LessEqualQ[QuantityMagnitude[resolvedPostConjugationWorkupMixVolume],0],
          {True, _ }, MatchQ[resolvedPostConjugationWorkupMixVolume,Except[Null]],
          {False, _ },  MatchQ[resolvedPostConjugationWorkupMixVolume,Except[Null]],
          {_,_}, False
        ];

        (*If we are not quenching we should not be quenchmixing or predraining*)
        invalidQuenchBoolean = Switch[{resolvedQuenchBoolean, MemberQ[Flatten@{resolvedQuenchMix,Lookup[samplePoolOptions,PredrainReactionMixture]},True]},
          {False,True}, True,
          {_,_}, False
        ];

        (*If we are not doing PostConjugationWorkup we should not be postconjugationmixing or postconjugationresuspending*)
        invalidPostConjugationBoolean = Switch[Flatten@{Lookup[samplePoolOptions,PostConjugationWorkup], MemberQ[Flatten@{resolvedPostConjugationWorkupMix,resolvedPostConjugationResuspension},True]},
          {False,True}, True,
          {_,_}, False
        ];

        invalidPostConjugationResuspensionVolume =  Switch[resolvedPostConjugationResuspensionDiluent,
          ObjectP[], !QuantityQ[resolvedPostConjugationResuspensionDiluentVolume] || LessEqualQ[QuantityMagnitude[resolvedPostConjugationResuspensionDiluentVolume],0],
          Null, MatchQ[resolvedPostConjugationResuspensionDiluentVolume,Except[Null]],
          _, False
        ];

        invalidPostConjugationResuspensionMixVolume =  Switch[{resolvedPostConjugationResuspensionMix,resolvedPostConjugationResuspensionMixType},
          {True, Pipette}, !QuantityQ[resolvedPostConjugationResuspensionMixVolume] || LessEqualQ[QuantityMagnitude[resolvedPostConjugationResuspensionMixVolume],0]||GreaterQ[resolvedPostConjugationResuspensionMixVolume,resolvedPostConjugationResuspensionDiluentVolume],
          {True, _ }, MatchQ[resolvedPostConjugationResuspensionMixVolume,Except[Null]],
          {False, _ },  MatchQ[resolvedPostConjugationResuspensionMixVolume,Except[Null]],
          {_,_}, False
        ];

        (*If make sure the reaction vessel can accept the volume of the conjugation reaction and any quenching and workup following.*)
        resolvedReactionVesselMaxVolume = First[Lookup[Cases[DeleteDuplicates@Flatten[{containerModelPackets,containerObjectsModelsPackets,sampleContainerModelPackets}],KeyValuePattern[Object->Download[resolvedReactionVessel,Object]]], MaxVolume]];
        invalidReactionVessel = If[maxReactionVolume>resolvedReactionVesselMaxVolume, True, False];

        (*Final output*)
        { resolvedConjugationReactionVolume, resolvedTargetConjugationSampleConcentration, resolvedConjugationReactionBufferVolume, resolvedConcentratedConjugationReactionBufferDilutionFactor,
          resolvedConjugationReactionBufferDiluent, resolvedConjugationDiluentVolume, resolvedConjugationTime, resolvedConjugationTemperature, resolvedConjugationMixType, resolvedConjugationMixVolume, resolvedConjugationNumberOfMixes,
          resolvedConjugationMixRate, resolvedQuenchBoolean, resolvedQuenchReactionVolume, resolvedQuenchReagent, resolvedQuenchReagentDilutionFactor, resolvedQuenchReagentVolume, resolvedQuenchTime, resolvedQuenchTemperature,
          resolvedQuenchMix, resolvedQuenchMixType, resolvedQuenchMixVolume, resolvedQuenchNumberOfMixes, resolvedQuenchMixRate,
          resolvedPostConjugationWorkupMethod, resolvedPostConjugationWorkupMix, resolvedPostConjugationWorkupMixType, resolvedPostConjugationWorkupMixVolume,
          resolvedPostConjugationWorkupNumberOfMixes, resolvedPostConjugationWorkupMixRate, resolvedPostConjugationResuspension, resolvedPostConjugationResuspensionDiluent, resolvedPostConjugationResuspensionDiluentVolume,
          resolvedPostConjugationResuspensionMix, resolvedPostConjugationResuspensionMixType, resolvedPostConjugationResuspensionMixRate, resolvedPostConjugationResuspensionMixVolume,
          resolvedPostConjugationResuspensionNumberOfMixes, resolvedPostConjugationResuspensionMixUntilDissolved, resolvedPostConjugationResuspensionMaxNumberOfMixes, resolvedPostConjugationResuspensionTime,
          resolvedPostConjugationResuspensionMaxTime,resolvedPostConjugationResuspensionTemperature,resolvedPredrainMethod, resolvedReactionVessel, invalidConjugationReactionVolume,invalidConjugationReactionBufferVolume,invalidConjugationMixVolume,
          invalidDiluentVolume,invalidQuenchReagentVolume, invalidQuenchMixVolume,
          invalidPostConjugationWorkupMixVolume,invalidQuenchBoolean, invalidPostConjugationBoolean, invalidPostConjugationResuspensionVolume,
          invalidPostConjugationResuspensionMixVolume, invalidAnalyteConcentration, invalidReactionVessel,resolvedProductCoefficient, unknownProductCoefficient }
      ]
    ],
    {myPooledSamples,mapThreadFriendlyOptions,TakeList[sampleContainerModelPackets,poolingLengths],TakeList[samplePackets,poolingLengths],TakeList[sampleIdentityModelPackets,poolingLengths],pooledResolvedOptions}
  ]
];

  (*PREDRAIN and POSTCONJUGATION RESOLVING*)
  (*Simulate post activation wash and conjugation*)
  postActivationFilterPrimOptions = FilterRules[resolvedPostActivationWashFilterOptions, Keys@Options[Filter]];
  postActivationPelletPrimOptions = FilterRules[resolvedPostActivationWashPelletOptions, Keys@Options[Pellet]];

  postActivationWashFilterPrimitive = If[Length@postActivationWashFilterSamples>0,Filter[Sample->postActivationWashFilterSamples, Sequence@@postActivationFilterPrimOptions],{}];
  postActivationWashPelletPrimitive = If[Length@postActivationWashPelletSamples>0,Pellet[Sample->postActivationWashPelletSamples, Sequence@@postActivationPelletPrimOptions],{}];
  postActivationTransferOutVolumes = PickList[resolvedActivationReactionVolumes,resolvedPostActivationWashMethods,Magnetic];
  postActivationWashMagneticTransferPrimitive = If[Length@postActivationWashMagneticTransferSamples>0,Transfer[Source->postActivationWashMagneticTransferSamples, Amount-> postActivationTransferOutVolumes, Destination->Model[Container,Plate,"id:54n6evLWKqbG"]],{}];

  postActivationWashResuspendSamples = PickList[simulatedActivationSamples,resolvedPostActivationResuspensions,True];
  postActivationWashResuspendDiluents = PickList[resolvedPostActivationResuspensionDiluents,resolvedPostActivationResuspensions,True];
  postActivationWashResuspendDiluentVolumes = PickList[resolvedPostActivationResuspensionDiluentVolumes,resolvedPostActivationResuspensions,True];
  postActivationWashTransferPrimitive =If[Length@postActivationWashResuspendDiluents>0,Transfer[Source->postActivationWashResuspendDiluents,Amount->postActivationWashResuspendDiluentVolumes,Destination->postActivationWashResuspendSamples],{}];

  sampleConjugationAmounts = MapThread[
    Switch[{MatchQ[#1,All],MatchQ[Lookup[#2,State],Solid]},
      {True,True}, Lookup[#2,Mass],
      {True,_}, Lookup[#2,Volume],
      {_,_}, #1
    ]&,
    {Flatten[Lookup[mapThreadFriendlyOptions,ConjugationAmount]],samplePackets}
  ];

  conjugationAmounts = Transpose[{TakeList[sampleConjugationAmounts,poolingLengths], resolvedConjugationReactionBufferVolumes, resolvedConjugationReactionBufferVolumes/(resolvedConcentratedConjugationReactionBufferDilutionFactors/.Null->1) , resolvedConjugationDiluentVolumes} /. Null -> 0*Microliter];
  conjugationSamples = Transpose[{TakeList[simulatedActivationSamples,poolingLengths], Lookup[mapThreadFriendlyOptions,ConjugationReactionBuffer], Lookup[mapThreadFriendlyOptions,ConcentratedConjugationReactionBuffer], resolvedConjugationReactionBufferDiluents}/.Null->Model[Sample,"id:8qZ1VWNmdLBD"]];
  conjugationDestinations = ConstantArray[CreateUUID[],Length@resolvedReactionVessels];
  (* updated to make sure we capture all models since resolvedReactionVessels can have both models and objects *)
  reactionVesselModels = Map[
    If[MatchQ[#,ObjectP[Model[Container]]],
      #,
      Lookup[fetchPacketFromCache[#,simulatedCache],Model]
    ]&,
    resolvedReactionVessels
  ];

  conjugationDefinePrimitives = MapThread[LabelContainer[Label->#2, Container->#1]&,{Flatten@reactionVesselModels,conjugationDestinations}];

  consolidateConjugationPrimitives = MapThread[
    Function[{samples, amounts, destination},
      MapThread[
          If[#2>0Microliter,Transfer[Source->#1, Amount->#2, Destination->destination], Nothing]&,
        {Flatten@samples, Flatten@amounts}]],
    {
      conjugationSamples,
      conjugationAmounts,
      conjugationDestinations
    }
  ];


  (*1.labelSimulation = ExpSamplePrep on label primitive, Simulation->activatedSamplesSimulation, Output->Simulation, Cache->activationUpdatedCache]*)
  labelSimulation = Quiet@ExperimentSamplePreparation[Flatten[{definePrimitives,conjugationDefinePrimitives}],Cache->activationUpdatedCache,Simulation->activatedSamplesSimulation,Output->Simulation];

  (*2. create replace rules in the from label -> obj from and replace all labels in the pellet/transfer primitives with simulated obj id *)
  labelsToObjectRules = labelSimulation[[1]][Labels];

  (*3. samplePackets=UploadSample[everything transfer primitive related,Upload->False,Simulation->labelSimulation]*)
  (*3a. for postActivationWashMagneticTransferPrimitive, follow the notebook to create a fake bench for the model[plate,reservoir], and uploadsample, Upload->False, Sim->etc, and updatesim calls*)

  washMagTransferSim=
      If[!MatchQ[postActivationWashMagneticTransferPrimitive,{}],
        (*If postActivationWashMagneticTransferPrimitive is actually something, update the simulation *)
        Module[{fakeBench,firstPostWashMagTransferSim,containerPacket,secondPostWashMagTransferSim,postWashMagTransferSamplePackets,compositions,numOfSources,packets,
          destinationsAndWells},
          numOfSources = Length[postActivationWashMagneticTransferPrimitive[Source]];
          (*first create IDs for fake Object[Container,Bench]s*)
          fakeBench = Table[CreateID[Object[Container,Bench]],numOfSources];

          (*create packets for updating simulation*)
          packets = Map[<|Object->#,Model->Link[Model[Container,Bench,"id:n0k9mGzRaajW"],Objects]|>&,fakeBench];

          (*update labelSimulation with above fake Object[Container,Bench] with Model->Link[Model[Container,Bench,"id:n0k9mGzRaajW"],Objects]*)
          firstPostWashMagTransferSim = UpdateSimulation[labelSimulation,Simulation[packets]];

          (*create containerPacket*)
          containerPacket = UploadSample[
            Table[Model[Container,Plate,"id:54n6evLWKqbG"],numOfSources],
            Map[{"Bench Top Slot",#}&,fakeBench],
            Simulation ->  firstPostWashMagTransferSim,
            Upload -> False,
            SimulationMode -> True
          ];

          (*update firstPostWashMagTransferSim with containerPacket*)
          secondPostWashMagTransferSim = UpdateSimulation[firstPostWashMagTransferSim,Simulation[containerPacket]];

          (*create postWashMagTransferSamplePackets*)
          (*first get compositions and destination+wells*)
          compositions = Map[#[Composition] &, postActivationWashMagneticTransferPrimitive[Source]];
          destinationsAndWells = Map[Prepend[{Lookup[#,Object]},"A1"]&,containerPacket[[1;;numOfSources]]];

          (*create UploadSample packets for actual destination of postActivationWashMagneticTransferPrimitive *)
          postWashMagTransferSamplePackets = UploadSample[
            compositions,
            destinationsAndWells,
            InitialAmount->postActivationWashMagneticTransferPrimitive[Amount],
            Simulation->secondPostWashMagTransferSim,
            Upload->False,
            SimulationMode -> True
          ];

          (*return the updated simulation*)
          UpdateSimulation[secondPostWashMagTransferSim,Simulation[postWashMagTransferSamplePackets]]
        ],
        (*if postActivationWashMagneticTransferPrimitive is empty, just return the old labelSimulation*)
        labelSimulation
  ];

  (*3b. for postActivationWashTransferPrimitive, use UploadTransferSample to transfer from source samples to destination samples, use Simulation, Upload->False, and updatesim after*)
  washTransferSim=washMagTransferSim;

  If[!MatchQ[postActivationWashTransferPrimitive,{}],
    (*If postActivationWashMagneticTransferPrimitive is actually something, update the simulation *)
    (*MapThread over the postActivationWashMagneticTransferPrimitive Source, Amount and Destinations*)
    MapThread[
      Function[{source,amount,destination},
        If[MatchQ[source,ObjectP[Object[Sample]]],

          (*If source is Object[Sample], just do UploadSampleTransfer immediately*)
          Module[{transferPackets},

            transferPackets=UploadSampleTransfer[source,destination,amount,Upload->False,Simulation->washTransferSim];
            washTransferSim=UpdateSimulation[washTransferSim,Simulation[transferPackets]];
          ],

          (* else: If destination is Model[Sample], 1. create fake container with Amount of that model using UploadSample, then use that to UploadSampleTransfer*)
          Module[{fakeBench, packet, updatedWashTransferSim, containerModel,containerPacket,containerSubclass,packetWithSourceModelSample,simulationWithSourceInfo,transferPackets,sourceSample},

            (*first create IDs for fake Object[Container,Bench]s*)
            fakeBench = CreateID[Object[Container,Bench]];

            (*create packets for updating simulation*)
            packet = <|Object->fakeBench,Model->Link[Model[Container,Bench,"id:n0k9mGzRaajW"],Objects]|>;

            (*update washTransferSim with above fake Object[Container,Bench] with Model->Link[Model[Container,Bench,"id:n0k9mGzRaajW"],Objects]*)
            updatedWashTransferSim = UpdateSimulation[labelSimulation,Simulation[packet]];

            (*get containerModel for the amount of source sample and the container subclass*)
            containerModel=PreferredContainer[amount];
            (*create containerPacket*)
            containerPacket = UploadSample[
              containerModel,
              {"Bench Top Slot",fakeBench},
              Simulation ->  updatedWashTransferSim,
              Upload -> False,
              SimulationMode -> True
            ];

            (*update updatedWashTransferSim with containerPacket*)
            updatedWashTransferSim = UpdateSimulation[updatedWashTransferSim,Simulation[containerPacket]];

            (*get packet information of source for UploadSampleTransfer*)
            packetWithSourceModelSample=UploadSample[source[Composition],{"A1",Lookup[containerPacket[[1]],Object]},Simulation->updatedWashTransferSim,Upload->False,SimulationMode -> True];

            (*source sample*)
            sourceSample=Select[DeleteDuplicates[packetWithSourceModelSample[Object]],MatchQ[#,ObjectP[Object[Sample]]]&][[1]];
            (*update simulation with packetWithModelSample*)
            simulationWithSourceInfo=UpdateSimulation[updatedWashTransferSim,Simulation[packetWithSourceModelSample]];

            (*call UploadTransferSample with Upload->False*)
            transferPackets=UploadSampleTransfer[sourceSample,destination,amount,Upload->False,Simulation->simulationWithSourceInfo];

            (*update the return simulation with transferPackets, transfer done*)
            washTransferSim=UpdateSimulation[simulationWithSourceInfo,Simulation[transferPackets]];
          ]
        ]
      ],{postActivationWashTransferPrimitive[Source],postActivationWashTransferPrimitive[Amount],postActivationWashTransferPrimitive[Destination]}
    ]
  ];

  (*3c. consolidateConjugationPrimitives*)

  (*flatten all sources from primitives*)
  flatSources = Flatten[consolidateConjugationPrimitives][[All,1]][Source];

  (*flatten all amounbts from primitives*)
  flatAmounts = Flatten[consolidateConjugationPrimitives][[All,1]][Amount];

  (*flatten all destinations from primitives*)
  flatDestinations = Flatten[consolidateConjugationPrimitives][[All,1]][Destination];

  (*replace any destinations that have labels with actual object from simulation*)
  flatDestinationsNoLabels = flatDestinations /. (washTransferSim[[1]][Labels]);

  (*get any source that is a container*)
  sourceContainers = Cases[flatSources,ObjectReferenceP[Object[Container]]];

  (*get any source that is a model[sample]*)
  sourceModels = Cases[flatSources,ObjectReferenceP[Model[Sample]]];

  (*combine packets of current simulation with simulatedCache*)
  newCache = Experiment`Private`FlattenCachePackets[{Lookup[washTransferSim[[1]],Packets,{}],simulatedCache}];

  (*if there are any containers in the sources, replace them with the samples in them, otherwise just return original flatSources*)
  flatSourcesNoContainers = If[Length[sourceContainers]>0,
    Module[{},
      (*get packets of the source containers*)
      sourceContainerPackets  = fetchPacketFromCache[#,newCache]&/@sourceContainers;

      (*get the samples in each conntainer from the above packets*)
      sourceSamplesFromContainers = Download[Lookup[sourceContainerPackets,Contents][[All,1]][[All,2]],Object];

      (*create rules of object container -> sample in container*)
      containerToSampleLookup = Normal@AssociationThread[sourceContainers -> sourceSamplesFromContainers];

      (*replace any container sources with their samples*)
      flatSources /. containerToSampleLookup
    ],
    flatSources
  ];

  (*if there are any models in the sources, create object samples of them with UploadSample with initialamount->corresponding amount*)
  {flatSourcesNoContainersNoModels,finalSim} = If[Length[sourceModels]>0,
    Module[{sourceModelPackets,modelSourcesNoDuplicates,startingVolumes,modelSourcesToAmounts,fakeBench,packets,simWithFakeBenches,
      preferredContainerModelsForNewObjSamples,containerPacket,simWithFakeContainersForModels,preferredContainersLinkObject,
      destContainerObjects,destContainerObjectsWithWell,simToReturn,modelSourcesWithLink,samplePacketsWithModels,modelToObjectSample,
      moreRules,modelsAndObjects,samplePackesForSim},
      (*get packets of the source containers*)
      sourceModelPackets  = fetchPacketFromCache[#,newCache]&/@sourceModels;

      (*create an association of model sources->amounts, need to combine them because some model sources are the same*)
      modelSourcesNoDuplicates = DeleteDuplicates[sourceModels];

      (*create rules of object container -> sample in container*)
      containerToSampleLookup = Normal@AssociationThread[sourceContainers -> sourceSamplesFromContainers];
      startingVolumes =ConstantArray[0 Milliliter, Length[modelSourcesNoDuplicates]];
      modelSourcesToAmounts = AssociationThread[modelSourcesNoDuplicates -> startingVolumes];

      Map[
        Function[{modelSource},
          Module[{indicesOfModelSource, amountsOfModelSource},

            indicesOfModelSource = Flatten[Position[flatSources, modelSource]];
            amountsOfModelSource = flatAmounts[[indicesOfModelSource]];

            modelSourcesToAmounts[modelSource] = Total[amountsOfModelSource];
          ]
        ],
        modelSourcesNoDuplicates
      ];

      (*create fake bench for the fake object containers about to create for the object samples of the model samples*)
      (*first create IDs for fake Object[Container,Bench]s*)
      fakeBench = Table[CreateID[Object[Container,Bench]],Length[modelSourcesNoDuplicates]];

      (*create packets for updating simulation*)
      packets = Map[<|Object->#,Model->Link[Model[Container,Bench,"id:n0k9mGzRaajW"],Objects]|>&,fakeBench];

      (*update simulation with above fake Object[Container,Bench] with Model->Link[Model[Container,Bench,"id:n0k9mGzRaajW"],Objects]*)
      simWithFakeBenches = UpdateSimulation[washTransferSim,Simulation[packets]];

      (*get the preferred model containers for each model in modelSourcesNoDuplicates*)
      preferredContainerModelsForNewObjSamples=Map[
        Function[{modelSource},
          Module[{correspondingVolume,containerModelForModelSample},
            correspondingVolume = Lookup[modelSourcesToAmounts,modelSource];
            containerModelForModelSample = PreferredContainer[correspondingVolume];
            containerModelForModelSample
          ]
        ]
      ,modelSourcesNoDuplicates
      ];

      (*create containerPacket, fake containers for model samples*)
      containerPacket = UploadSample[
        preferredContainerModelsForNewObjSamples,
        Map[{"Bench Top Slot",#}&,fakeBench],
        Simulation ->  simWithFakeBenches,
        Upload -> False,
        Name->Table["Container object " <> ToString[i], {i, 1, Length[preferredContainerModelsForNewObjSamples]}],
        SimulationMode -> True
      ];

      (*update sim with containerPacket*)
      simWithFakeContainersForModels = UpdateSimulation[simWithFakeBenches,Simulation[containerPacket]];

      (*preferredContainers with Link to Objects*)
      preferredContainersLinkObject =Map[Link[#, Objects] &,preferredContainerModelsForNewObjSamples];

      (*grab the object containers from containerPacket*)
      destContainerObjects = Lookup[DeleteDuplicates@Cases[
        containerPacket,
        KeyValuePattern[{Model -> model:Alternatives@@preferredContainersLinkObject}]],Object];

      destContainerObjectsWithWell = Map[Prepend[{#},"A1"]&,destContainerObjects];

      (*use uploadsample with preferredContainerModels as destination and modelSourcesNoDuplicates as sources and lookup modelSourcesToAmounts for amount*)
      samplePackesForSim =
        UploadSample[
          modelSourcesNoDuplicates,
          destContainerObjectsWithWell,
          InitialAmount->Map[Lookup[modelSourcesToAmounts,#]&,modelSourcesNoDuplicates],
          Upload->False,
          Simulation->simWithFakeContainersForModels,
          SimulationMode -> True
      ];

      (*update the simulation with samplePackesForSim*)
      simToReturn = UpdateSimulation[simWithFakeContainersForModels,Simulation[samplePackesForSim]];

      (*add two-way link to modelSources*)
      modelSourcesWithLink = Map[Link[Download[#,Object], Objects] &,modelSourcesNoDuplicates];

      (*make rule of modelSourcesWithLink->modelSourcesNoDupes*)
      moreRules = AssociationThread[modelSourcesWithLink->modelSourcesNoDuplicates];

      (*create a lookup of Model[]->Sample[] from samplePackesForSim*)
      samplePacketsWithModels = DeleteDuplicates@Cases[
        samplePackesForSim,
        KeyValuePattern[{Model -> model:Alternatives@@modelSourcesWithLink}]];

      modelsAndObjects = Transpose[Replace[Lookup[samplePacketsWithModels,{Model,Object}],moreRules,{2}]];

      modelToObjectSample = AssociationThread[modelsAndObjects[[1]]->modelsAndObjects[[2]]];

      (*replace any container sources with their samples*)
      {flatSourcesNoContainers /. modelToObjectSample,simToReturn}
    ],
    {flatSourcesNoContainers,washTransferSim}
  ];

  (*reconstruct pooled structures*)
  pooledAmounts = TakeList[flatAmounts,poolingLengths];

  pooledDestinations = TakeList[flatDestinationsNoLabels,poolingLengths];

  (*update simulation with updating destinations' status to Available*)
  destStatusSim = UpdateSimulation[finalSim, Simulation[UploadSampleStatus[DeleteDuplicates[flatDestinationsNoLabels],Available, Simulation -> finalSim,Force -> True, Upload -> False]]];

  (*create fake compositions for destinations for use in UploadSampleTransfer*)
  fakeDestinationPackets = UploadSample[
    ConstantArray[{{Null,Null}}, Length[poolingLengths]],
    Transpose[{ConstantArray["A1", Length[poolingLengths]],pooledDestinations[[All,1]]}],
    Upload -> False,
    Simulation -> destStatusSim,
    SimulationMode -> True
  ];

  (*create rules where each destination goes to the first thing in its contents*)
  destContainerToSampleLookup = DeleteDuplicates@Cases[
    fakeDestinationPackets,
    KeyValuePattern[{Object -> obj:Alternatives@@flatDestinationsNoLabels, Append[Contents] -> cont_}]:> Rule[obj,Download[First[cont[[All,2]]],Object]]
  ];

  (*replace destiations with sample created above with rules*)
  flatDestinationSamples = flatDestinationsNoLabels /. destContainerToSampleLookup;

  (*update simulation*)
  ustSim = UpdateSimulation[destStatusSim,Simulation[fakeDestinationPackets]];

  (*combine packets of current simulation with newCache*)
  newNewCache = Experiment`Private`FlattenCachePackets[{Lookup[ustSim[[1]],Packets,{}],newCache}];

  (*upload sample trannsfer from source samples to destinnation samples*)
  ustPackets = UploadSampleTransfer[
    flatSourcesNoContainersNoModels,
    flatDestinationSamples,
    flatAmounts,
    Cache -> newNewCache,
    Simulation -> ustSim,
    Upload -> False
  ];

  samplePrepSimulation = UpdateSimulation[ustSim,Simulation[ustPackets]];

  (*
  (*compile the compositions UploadSample*)
  (*grab the lists of sources from the primitives*)
  sourcesFromPrimitives = Replace[Map[#[Source] &, consolidateConjugationPrimitives, {2}],labelsToObjectRules];
  (*flatten the source packets from downloadedPackets and activated simulated sources from activatedSamplesSimulation*)
  sourceSamplePacketsFlattened = Flatten[{downloadedPackets[[1]],downloadedPackets[[8]],washTransferSim[[1]][Packets]}];
  (*transpose the list from above to make it easier to make replacement rules*)
  transposedList = Transpose[Lookup[sourceSamplePacketsFlattened, {Object, Composition}]];
  (*make replacement rules*)
  rules = Normal[AssociationThread[transposedList[[1]] -> transposedList[[2]]]];

  (*flatten sourcesFromPrimitives*)
  flattenedSourcesFromPrims = Flatten[sourcesFromPrimitives];
  (*get all the sources that are Object[Container,Vessel]*)
  containerVesselSources = Select[flattenedSourcesFromPrims,MatchQ[#,ObjectP[Object[Container, Vessel]]]&];
  (*get anything that's Object[Container,Vessel] that's in flattenedSourcesFromPrims*)
  containerVesselSourcesPackets =
      Map[
        Function[{source},
          Map[
            Function[{packet},
              If[MatchQ[Lookup[packet,Object],source],packet,Nothing]
            ],
            sourceSamplePacketsFlattened
          ]
        ],
        containerVesselSources
   ];
  flattenedVesselSourcePackets = Flatten[containerVesselSourcesPackets];
  (*make container->contents rules*)
  {containerSources,containerContents} = Transpose[Lookup[flattenedVesselSourcePackets,{Object,Contents}]];
  (*only get the sample thats in the contents*)
  containerContentsSamples = Flatten[containerContents[[All, All, 2, 1]]];

  containerToContentsSamplesRules = Normal[AssociationThread[containerSources->containerContentsSamples]];

  (*get the sources that DBMQ but are not in keys of rules*)
  (*create boolean map and mapthread*)
  sourcesStillNeedComposition = Select[flattenedSourcesFromPrims, (DatabaseMemberQ[#] && !MemberQ[Keys[rules], #]) &];
  (*get the compositions of each source in sourcesStillNeedComposition, turn into rules*)
  (*do download with listable input, not mapping*)
  remainingCompositions = Map[Download[#, Composition] &, sourcesStillNeedComposition];
  remainingCompositionRules = Normal[AssociationThread[sourcesStillNeedComposition->remainingCompositions]];
  newRules = Join[rules,remainingCompositionRules];
  (*append rules with rulesOfSourcesDBMQ*)

  (*get rid of any container references*)
  noContainerSources = Flatten[Replace[sourcesFromPrimitives,containerToContentsSamplesRules,{2}]];

  (*replace the objects in the lists of sources with the compositions, then flatten to desired nested dimensions*)
  conjugationCompositions = noContainerSources/.newRules;

  (*compile the destiations UploadSample*)
  conjugationLabelDestinations = Map[
    Function[{currentTransfersGroup},
      #[Destination]&/@currentTransfersGroup
    ],
    consolidateConjugationPrimitives
  ];

  (*add all the amounts from each group of transfers*)
  conjugationAmountsForTransfer = Map[
    Function[{groupOfTransfers},
      Module[{amountsToAddUp},
        amountsToAddUp = #[Amount]&/@groupOfTransfers;
        Total[amountsToAddUp]
      ]
    ],consolidateConjugationPrimitives];

  (*replace conjugation destination labels with their actual object destinations*)
  conjugationDestinations = Flatten[DeleteDuplicates/@(Replace[conjugationLabelDestinations,labelsToObjectRules,Infinity])];

  (*Add well to destination object for UploadSample*)
  conjugationDestinationsWithWell = Prepend[{#},"A1"]&/@conjugationDestinations;

  (*update the status of all the conjugationDestinations to Available so UploadSample can use them*)
  updatedConjugationPackets=UploadSampleStatus[conjugationDestinations,ConstantArray[Available,Length[conjugationDestinations]],Simulation->washTransferSim,Force->True,Upload->False];

  (*update the simulation with the updates statuses*)
  updatedConjugationSimulation = UpdateSimulation[washTransferSim,Simulation[updatedConjugationPackets]];

  (*call uploadsample on the gathered compositions, destinations and most recent simulation*)
  conjugationTransferPackets = UploadSample[conjugationCompositions,conjugationDestinationsWithWell,InitialAmount->conjugationAmountsForTransfer,State->Liquid,Upload->False,Simulation->updatedConjugationSimulation,SimulationMode->True];

  (*new simulation for future use*)
  samplePrepSimulation = UpdateSimulation[updatedConjugationSimulation,Simulation[conjugationTransferPackets]];
  *)

  (*Simulate sample conjugation - To avoid having to rewrite large chunks here, we're using both cache and simulation to make sure things work as unit tests want them to. not the best way to do things, but works for now. until this experiment is revisited.. *)
  (*samplePrepSimulation = Quiet@ExperimentSamplePreparation[
    Flatten@{conjugationDefinePrimitives,postActivationWashPelletPrimitive,postActivationWashMagneticTransferPrimitive,postActivationWashTransferPrimitive,consolidateConjugationPrimitives},
    Cache->activationUpdatedCache, Simulation->activatedSamplesSimulation, Output->Simulation];*)

  (* make sure there's a way to escape without bugging out if ExperimentSamplPreparation isnt happy*)
  {simulatedConjugatedSamples,conjugationDefineLookup} = If[MatchQ[samplePrepSimulation, _Simulation],
    Lookup[samplePrepSimulation[[1]], {Packets, Labels}],
    {{},{}}
  ];

  (*Create the simulated sample list and updated cache*)
  (* first, we need to update the contents and contents log in the simulated container *)
  updatedConjugatedContents=Map[
    Function[{containerAssociation},
      Module[{simulatedContainerWithUpdatedContents},
        (* obtain the container packet that have updated contents compared to the previous cache *)
        simulatedContainerWithUpdatedContents=SelectFirst[simulatedConjugatedSamples,MatchQ[Lookup[#,Object],ObjectP[Lookup[containerAssociation,Object]]]&,{}];

        (* if there is simulated container in the new cache, update its contents; otherwise, keep as it is *)
        If[!MatchQ[simulatedContainerWithUpdatedContents,{}],
          Association@ReplaceRule[Normal@containerAssociation,
            {
              Contents->Lookup[simulatedContainerWithUpdatedContents,Contents,{}],
              ContentsLog->Join[Lookup[containerAssociation,ContentsLog,{}],Lookup[simulatedContainerWithUpdatedContents,ContentsLog,{}]]
            }
          ],
          containerAssociation
        ]
      ]
    ],
    Cases[activationUpdatedCache,ObjectP[Object[Container]]]
  ];
  (* next, combined all the caches *)
  (* the order matters here: the container with updated contents needs to come first *)
  conjugationUpdatedCache=FlattenCachePackets[{updatedConjugatedContents,activationUpdatedCache,simulatedConjugatedSamples}];

  simulatedConjugationSamples = conjugationDestinations/.conjugationDefineLookup;

  (*resolve the Predrain options using the simulated samples. Make sure the pass the simulated sample packets in the cache*)
  predrainPelletOptionNames ={
    PredrainInstrument,PredrainCentrifugationIntensity, PredrainCentrifugationTime, PredrainTemperature
  };

  predrainMagneticTransferOptionNames = {PredrainMagnetizationTime, PredrainTemperature, PredrainMagnetizationRack};

  predrainPickListPelletBoolean = MatchQ[#,{Pellet,True}]&/@Transpose[{resolvedPredrainMethods,Lookup[mapThreadFriendlyOptions,PredrainReactionMixture]}];
  predrainPickListMagnetBoolean = MatchQ[#,{Magnetic,True}]&/@Transpose[{resolvedPredrainMethods,Lookup[mapThreadFriendlyOptions,PredrainReactionMixture]}];
  predrainPelletSamples = PickList[simulatedConjugationSamples,predrainPickListPelletBoolean,True];
  predrainMagneticTransferSamples = PickList[simulatedConjugationSamples,predrainPickListMagnetBoolean,True];
  predrainPelletOptions = MapThread[#2->PickList[Flatten@Lookup[mapThreadFriendlyOptions,#1],resolvedPredrainMethods,Pellet]&,{predrainPelletOptionNames,pelletOptionNames}];
  predrainMagnetizeOptions = MapThread[#2->PickList[Flatten@Lookup[mapThreadFriendlyOptions,#1],resolvedPredrainMethods,Magnetic]&,{predrainMagneticTransferOptionNames,magneticTransferOptionNames}];

  (*ExperimentPellet cannot take Time->Automatic or Temperature->Automatic so we must first replace those with the default options value*)
  predrainPelletOptionsWithTime = ReplaceRule[predrainPelletOptions, {Time -> Lookup[predrainPelletOptions /. Automatic -> 5 Minute, Time], Temperature -> Lookup[predrainPelletOptions /. Automatic -> Ambient, Temperature]}];
  predrainPelletResolveFailure = Quiet[Check[
    {resolvedPredrainPelletOptions,predrainPelletTests} = If[Length@predrainPelletSamples>0,
      If[gatherTests,
        ExperimentPellet[predrainPelletSamples,Sequence@@predrainPelletOptionsWithTime,Cache->conjugationUpdatedCache,Simulation->samplePrepSimulation,OptionsResolverOnly -> True,Output->{Options,Tests}],
        {ExperimentPellet[predrainPelletSamples,Sequence@@predrainPelletOptionsWithTime,Cache->conjugationUpdatedCache,Simulation->samplePrepSimulation,OptionsResolverOnly -> True,Output->Options],{}}
      ],
      {Thread[pelletOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ],OptionValue::nodef];

  (* FIXME: specifying tips as an immediate fix until pellet/transfer calls get replaced with ExperimentMagneticbeadSeparation *)
  predrainMagneticTransferResolveFailure = Check[
    {resolvedPredrainMagneticTransferOptions,predrainMagneticTransferTests} = If[Length@predrainMagneticTransferSamples>0,
      If[gatherTests,
        Quiet[ExperimentTransfer[predrainMagneticTransferSamples, Waste,All,Sequence@@predrainMagnetizeOptions,Magnetization->True,Tips->Model[Item,Tips,"id:rea9jl1or6YL"],Cache->conjugationUpdatedCache,Simulation->samplePrepSimulation,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentTransfer[predrainMagneticTransferSamples, Waste,All,Sequence@@predrainMagnetizeOptions,Magnetization->True,Tips->Model[Item,Tips,"id:rea9jl1or6YL"],Cache->conjugationUpdatedCache,Simulation->samplePrepSimulation,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[magneticTransferOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

 (*Get the resolved options and assemble the index-matched list of options with the bioconjugation specific optionnames.*)
  predrainPelletPositions = Position[resolvedPredrainMethods, Pellet];
  predrainMagneticTransferPositions = Position[resolvedPredrainMethods,Magnetic];

  resolvedPredrainPelletOptionsFull = reformatResolvedOptions[predrainPelletPositions,resolvedPredrainPelletOptions,pelletOptionNames,predrainPelletOptionNames,Length@simulatedSamples];
  resolvedPredrainMagnetOptionsFull = reformatResolvedOptions[predrainMagneticTransferPositions, resolvedPredrainMagneticTransferOptions, magneticTransferOptionNames, predrainMagneticTransferOptionNames, Length@simulatedSamples];

  (*Simulate Quenching*)
  (*Find the samples that are being predrained and quenched. Use the simulated samples from above.*)
  predrainSamples = PickList[simulatedConjugationSamples, Lookup[mapThreadFriendlyOptions,PredrainReactionMixture], True];
  quenchSamples = PickList[simulatedConjugationSamples, resolvedQuenchBooleans, True];

  (*If the sample is being Predrained create a transfer out primitive.*)
  predrainTransferOutVolumes = PickList[resolvedConjugationReactionVolumes,Lookup[mapThreadFriendlyOptions,PredrainReactionMixture], True];
  predrainTransferOutPrimitives = If[Length@predrainSamples>0,Transfer[Source->predrainSamples, Amount-> predrainTransferOutVolumes, Destination->Model[Container,Plate,"id:54n6evLWKqbG"]],{}];

  (*If the sample is being quenched create a transfer primitive.*)
  quenchReagents = PickList[resolvedQuenchReagents,resolvedQuenchBooleans,True ];
  quenchReagentVolumes = PickList[resolvedQuenchReagentVolumes,resolvedQuenchBooleans,True ];
  transferQuenchPrimitives = If[Length@quenchReagents>0,Transfer[
    Source->quenchReagents,
    Amount->quenchReagentVolumes,
    Destination->quenchSamples
  ],
    {}
  ];

  (*If the a post-conjugation workup buffer is being added to a sample after quenching create a transfer primitive.*)
  workupSamples = PickList[simulatedConjugationSamples, Lookup[mapThreadFriendlyOptions,PostConjugationWorkupBuffer], Except[Null]];
  workupBuffer = Cases[Lookup[mapThreadFriendlyOptions,PostConjugationWorkupBuffer],Except[Null]];
  workupBufferVolume = Cases[Lookup[mapThreadFriendlyOptions,PostConjugationWorkupBufferVolume],Except[Null]];
  transferWorkupPrimitives = If[Length@workupBuffer>0,Transfer[Source->workupBuffer,Amount->workupBufferVolume,Destination->workupSamples],{}];

  (*Simulate sample post-conjugation*)
   postConjugationSimulation = If[MatchQ[Flatten@{predrainTransferOutPrimitives, transferQuenchPrimitives, transferWorkupPrimitives}, {}],
     samplePrepSimulation,
     Quiet@ExperimentSamplePreparation[
       Flatten[{predrainTransferOutPrimitives, transferQuenchPrimitives, transferWorkupPrimitives}],
       Cache -> conjugationUpdatedCache,Simulation->samplePrepSimulation, Output->Simulation]
     ];

  (* make sure there's a way to escape without bugging out if ExperimentSamplPreparation isnt happy*)
  {simulatedQuenchedSamples, quenchDefineLookup} = If[MatchQ[postConjugationSimulation, _Simulation],
    Lookup[postConjugationSimulation[[1]], {Packets, Labels}],
    {{},{}}
  ];

  (*Create the simulated sample list and updated cache*)
  (* first, we need to update the contents and contents log in the simulated container *)
  updatedQuenchedContents=Map[
    Function[{containerAssociation},
      Module[{simulatedContainerWithUpdatedContents},
        (* obtain the container packet that have updated contents compared to the previous cache *)
        simulatedContainerWithUpdatedContents=SelectFirst[simulatedQuenchedSamples,MatchQ[Lookup[#,Object],ObjectP[Lookup[containerAssociation,Object]]]&,{}];

        (* if there is simulated container in the new cache, update its contents; otherwise, keep as it is *)
        If[!MatchQ[simulatedContainerWithUpdatedContents,{}],
          Association@ReplaceRule[Normal@containerAssociation,
            {
              Contents->Lookup[simulatedContainerWithUpdatedContents,Contents,{}],
              ContentsLog->Join[Lookup[containerAssociation,ContentsLog,{}],Lookup[simulatedContainerWithUpdatedContents,ContentsLog,{}]]
            }
          ],
          containerAssociation
        ]
      ]
    ],
    Cases[conjugationUpdatedCache,ObjectP[Object[Container]]]
  ];
  (* next, combined all the caches *)
  (* the order matters here: the container with updated contents needs to come first *)
  quenchUpdatedCache=FlattenCachePackets[{updatedQuenchedContents,conjugationUpdatedCache,simulatedQuenchedSamples}];

  quenchSimulationReplacePositions = Flatten@Position[resolvedQuenchBooleans,True];
  simulatedQuenchingSamples = ReplacePart[simulatedConjugationSamples,Thread[quenchSimulationReplacePositions->quenchSamples/.quenchDefineLookup]];

  (*Resolve postconjugation options*)
  workupFilterOptionNames ={
    PostConjugationFiltrationType,PostConjugationWorkupInstrument, PostConjugationFilter,PostConjugationFilterStorageCondition,
    PostConjugationFilterMembraneMaterial, PostConjugationPrefilterMembraneMaterial, PostConjugationFilterPoreSize,
    PostConjugationFilterMolecularWeightCutoff, PostConjugationPrefilterPoreSize, PostConjugationFiltrationSyringe,
    PostConjugationSterileFiltration, PostConjugationFilterHousing, PostConjugationCentrifugationIntensity,
    PostConjugationCentrifugationTime, PostConjugationCentrifugationTemperature
  };

  workupPelletOptionNames ={
    PostConjugationWorkupInstrument, PostConjugationCentrifugationIntensity,
    PostConjugationCentrifugationTime, PostConjugationCentrifugationTemperature
  };

  workupMagneticTransferOptionNames = {PostConjugationWorkupIncubationTime, PostConjugationWorkupIncubationTemperature, PostConjugationMagnetizationRack};

  workupPickListFilterBoolean = MatchQ[#,{Filter,True}]&/@Transpose[{resolvedPostConjugationWorkupMethods,Lookup[mapThreadFriendlyOptions,PostConjugationWorkup]}];
  workupPickListPelletBoolean = MatchQ[#,{Pellet,True}]&/@Transpose[{resolvedPostConjugationWorkupMethods,Lookup[mapThreadFriendlyOptions,PostConjugationWorkup]}];
  workupPickListMagnetBoolean = MatchQ[#,{Magnetic,True}]&/@Transpose[{resolvedPostConjugationWorkupMethods,Lookup[mapThreadFriendlyOptions,PostConjugationWorkup]}];

  workupFilterSamples = PickList[simulatedQuenchingSamples,workupPickListFilterBoolean,True];
  workupPelletSamples = PickList[simulatedQuenchingSamples,workupPickListPelletBoolean,True];
  workupMagneticTransferSamples = PickList[simulatedQuenchingSamples,workupPickListMagnetBoolean,True];

  workupFilterOptions = MapThread[#2->PickList[Flatten@Lookup[mapThreadFriendlyOptions,#1],resolvedPostConjugationWorkupMethods,Filter]&,{workupFilterOptionNames,filterOptionNames}];
  workupPelletOptions = MapThread[#2->PickList[Flatten@Lookup[mapThreadFriendlyOptions,#1],resolvedPostConjugationWorkupMethods,Pellet]&,{workupPelletOptionNames,pelletOptionNames}];
  workupMagnetizeOptions = MapThread[#2->PickList[Flatten@Lookup[mapThreadFriendlyOptions,#1],resolvedPostConjugationWorkupMethods,Magnetic]&,{workupMagneticTransferOptionNames,magneticTransferOptionNames}];
  
  workupFilterResolveFailure = Check[
    {resolvedWorkupFilterOptions,workupFilterTests} = If[Length@workupFilterSamples>0,
      If[gatherTests,
        Quiet[ExperimentFilter[workupFilterSamples,Sequence@@workupFilterOptions,Cache->quenchUpdatedCache,Simulation->postConjugationSimulation,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentFilter[workupFilterSamples,Sequence@@workupFilterOptions,Cache->quenchUpdatedCache,Simulation->postConjugationSimulation,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[filterOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (*ExperimentPellet cannot take Time->Automatic or Temperature->Automatic so we must first replace those with the default options value*)
  workupPelletOptionsWithTime = ReplaceRule[workupPelletOptions, {Time -> Lookup[workupPelletOptions /. Automatic -> 5 Minute, Time], Temperature -> Lookup[workupPelletOptions /. Automatic -> Ambient, Temperature]}];

  workupPelletResolveFailure = Quiet[Check[
    {resolvedWorkupPelletOptions,workupPelletTests} = If[Length@workupPelletSamples>0,
      If[gatherTests,
        Quiet[ExperimentPellet[workupPelletSamples,Sequence@@workupPelletOptionsWithTime,Cache->quenchUpdatedCache,Simulation->postConjugationSimulation,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentPellet[workupPelletSamples,Sequence@@workupPelletOptionsWithTime,Cache->quenchUpdatedCache,Simulation->postConjugationSimulation,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[pelletOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ],OptionValue::nodef];

  workupMagneticTransferResolveFailure = Check[
    {resolvedWorkupMagneticTransferOptions,workupMagneticTransferTests} = If[Length@workupMagneticTransferSamples>0,
      If[gatherTests,
        Quiet[ExperimentTransfer[workupMagneticTransferSamples,Waste,All,Sequence@@workupMagnetizeOptions,Cache->quenchUpdatedCache,Simulation->postConjugationSimulation,OptionsResolverOnly -> True,Output->{Options,Tests}],{Download::MissingCacheField,Download::MissingField}],
        {Quiet[ExperimentTransfer[workupMagneticTransferSamples,Waste,All,Sequence@@workupMagnetizeOptions,Cache->quenchUpdatedCache,Simulation->postConjugationSimulation,OptionsResolverOnly -> True,Output->Options],{Download::MissingCacheField,Download::MissingField}],{}}
      ],
      {Thread[magneticTransferOptionNames->Null],{}}
    ],
    $Failed,
    {Error::InvalidInput, Error::InvalidOption}
  ];

  (*Get the resolved options and assemble the index-matched list of options with the bioconjugation specific optionnames.*)
  workupFilterPositions = Position[resolvedPostConjugationWorkupMethods, Filter];
  workupPelletPositions = Position[resolvedPostConjugationWorkupMethods, Pellet];
  workupMagneticTransferPositions = Position[resolvedPostConjugationWorkupMethods,Magnetic];

  resolvedWorkupFilterOptionsFull = reformatResolvedOptions[workupFilterPositions,resolvedWorkupFilterOptions,filterOptionNames,workupFilterOptionNames,Length@simulatedSamples];
  resolvedWorkupPelletOptionsFull = reformatResolvedOptions[workupPelletPositions,resolvedWorkupPelletOptions,pelletOptionNames,workupPelletOptionNames,Length@simulatedSamples];
  resolvedWorkupMagnetOptionsFull = reformatResolvedOptions[workupMagneticTransferPositions, resolvedWorkupMagneticTransferOptions, magneticTransferOptionNames, workupMagneticTransferOptionNames, Length@simulatedSamples];


  (*RESOLVED OPTIONS ERROR CHECKING*)
  (* Invalid sample mapthread error checking *)

  (* 1. Check that if PreWash is False, all the remaining PreWash booleans are also False*)

  (*Retrieve the samples that have invalid prewash boolean*)
  invalidPreWashBooleanSamples = PickList[Flatten@myPooledSamples,invalidPreWashBooleans, True];
  invalidPreWashBooleanOptions = If[Length@invalidPreWashBooleanSamples>0, {PreWash, PreWashMix, PreWashResuspension, PreWashResuspensionMix}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidPreWashBooleanSamples>0&&messages,
    Message[Error::InvalidPreWashOptions,ObjectToString[invalidPreWashBooleanSamples],invalidPreWashBooleanOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPreWashBooleansTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPreWashBooleanSamples]>0,
                Test["Our PreWash master switch does not conflict with subsequent PreWash booleans for the inputs"<>ObjectToString[invalidPreWashBooleanSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPreWashBooleanSamples]==0,
                Test["Our PreWash master switch does not conflict with subsequent PreWash booleans for the inputs"<>ObjectToString[invalidPreWashBooleanSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 2. Check that if Activate is False, all the remaining Activation booleans are also False*)

  (*Retrieve the samples that have invalid activate booleans*)
  invalidActivationBooleanSamples = PickList[Flatten@myPooledSamples,invalidActivationBooleans, True];
  invalidActivationBooleanOptions = If[Length@invalidActivationBooleanSamples>0, {ActivationMix, PostActivationWash, PostActivationWashMix, PostActivationResuspension, PostActivationResuspensionMix}, {}];

  (*Throw an error if there are invalid samples*)
  If[!MatchQ[invalidActivationBooleanSamples,{}]&&messages,
    Message[Error::InvalidActivateOptions,ObjectToString[invalidActivationBooleanSamples],invalidActivationBooleanOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidActivationBooleansTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidActivationBooleanSamples]>0,
                Test["Our Activate master switch does not conflict with subsequent Activation booleans for the inputs"<>ObjectToString[invalidActivationBooleanSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidActivationBooleanSamples]==0,
                Test["Our Activate master switch does not conflict with subsequent Activation booleans for the inputs"<>ObjectToString[invalidActivationBooleanSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 3. Check that the Activation sample volumes are valid*)

  (*Retrieve the samples that have invalid activation sample volumes*)
  invalidActivationVolumeSamples = PickList[Flatten@myPooledSamples,invalidActivationSampleVolumes, True];
  invalidActivationVolumeOptions = If[Length@invalidActivationVolumeSamples>0, {ActivationSampleVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidActivationVolumeSamples>0&&messages,
    Message[Error::InvalidActivationSampleVolumes,ObjectToString[invalidActivationVolumeSamples]],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidActivationVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidActivationVolumeSamples]>0,
                Test["Our activation sample volumes are valid for the inputs"<>ObjectToString[invalidActivationVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidActivationVolumeSamples]==0,
                Test["Our activation sample volumes are valid for the inputs"<>ObjectToString[invalidActivationVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 4. Check that the Activation reagent volumes are valid*)

  (*Retrieve the samples that have invalid activation reagent volumes*)
  invalidActivationReagentVolumeSamples = PickList[Flatten@myPooledSamples,invalidActivationReagentVolumes, True];
  invalidActivationReagentVolumeOptions = If[Length@invalidActivationReagentVolumeSamples>0, {ActivationReagentVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidActivationReagentVolumeSamples>0&&messages,
    Message[Error::InvalidActivationReagentVolumes,ObjectToString[invalidActivationReagentVolumeSamples],invalidActivationReagentVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidActivationReagentVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidActivationReagentVolumeSamples]>0,
                Test["Our activation reagent volumes are valid for the inputs"<>ObjectToString[invalidActivationReagentVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidActivationReagentVolumeSamples]==0,
                Test["Our activation reagent volumes are valid for the inputs"<>ObjectToString[invalidActivationReagentVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 5. Check that the Activation diluent volumes are valid*)

  (*Retrieve the samples that have invalid activation diluent volumes*)
  invalidActivationDiluentVolumeSamples = PickList[Flatten@myPooledSamples,invalidActivationDiluentVolumes, True];
  invalidActivationDiluentVolumeOptions = If[Length@invalidActivationDiluentVolumeSamples>0, {ActivationDiluentVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidActivationDiluentVolumeSamples>0&&messages,
    Message[Error::InvalidActivationDiluentVolumes,ObjectToString[invalidActivationDiluentVolumeSamples],invalidActivationDiluentVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidActivationDiluentVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidActivationDiluentVolumeSamples]>0,
                Test["Our activation diluent volumes are valid for the inputs"<>ObjectToString[invalidActivationDiluentVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidActivationDiluentVolumeSamples]==0,
                Test["Our activation diluent volumes are valid for the inputs"<>ObjectToString[invalidActivationDiluentVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (*Invalid sample pool mapthread error checking *)
  (* 6. Check that the conjugation reaction volumes are valid*)

  (*Retrieve the samples that have invalid conjugation reaction volumes*)
  invalidConjugationReactionVolumeSamples = PickList[myPooledSamples,invalidConjugationReactionVolumes, True];
  invalidConjugationReactionVolumeOptions = If[Length@invalidConjugationReactionVolumeSamples>0, {ConjugationReactionVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidConjugationReactionVolumeSamples>0&&messages,
    Message[Error::InvalidConjugationReactionVolumes,ObjectToString[invalidConjugationReactionVolumeSamples],invalidConjugationReactionVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationReactionVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidConjugationReactionVolumeSamples]>0,
                Test["Our conjugation reaction volumes are valid for the inputs"<>ObjectToString[invalidConjugationReactionVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidConjugationReactionVolumeSamples]==0,
                Test["Our conjugation reaction volumes are valid for the inputs"<>ObjectToString[invalidConjugationReactionVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 7. Check that the conjugation buffer volumes are valid*)

  (*Retrieve the samples that have invalid conjugation buffer volumes*)
  invalidConjugationBufferVolumeSamples = PickList[myPooledSamples,invalidConjugationReactionBufferVolumes, True];
  invalidConjugationBufferVolumeOptions = If[Length@invalidConjugationBufferVolumeSamples>0, {ConjugationReactionBuffer, ConjugationReactionBufferVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidConjugationBufferVolumeSamples>0&&messages,
    Message[Error::InvalidConjugationBufferVolumes,ObjectToString[invalidConjugationBufferVolumeSamples],invalidConjugationBufferVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationBufferVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidConjugationBufferVolumeSamples]>0,
                Test["Our conjugation buffer volumes are valid for the inputs"<>ObjectToString[invalidConjugationBufferVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidConjugationBufferVolumeSamples]==0,
                Test["Our conjugation buffer volumes are valid for the inputs"<>ObjectToString[invalidConjugationBufferVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 8. Check that the conjugation mix volumes are valid*)

  (*Retrieve the samples that have invalid conjugation mix volumes*)
  invalidConjugationMixVolumeSamples = PickList[myPooledSamples,invalidConjugationMixVolumes, True];
  invalidConjugationMixVolumeOptions = If[Length@invalidConjugationMixVolumeSamples>0, {ConjugationMixVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidConjugationMixVolumeSamples>0&&messages,
    Message[Error::InvalidConjugationMixVolumes,ObjectToString[invalidConjugationMixVolumeSamples],invalidConjugationMixVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationMixVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidConjugationMixVolumeSamples]>0,
                Test["Our conjugation mix volumes are valid for the inputs"<>ObjectToString[invalidConjugationMixVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidConjugationMixVolumeSamples]==0,
                Test["Our conjugation mix volumes are valid for the inputs"<>ObjectToString[invalidConjugationMixVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 9. Check that the conjugation diluent volumes are valid*)

  (*Retrieve the samples that have invalid conjugation diluent volumes*)
  invalidConjugationDiluentVolumeSamples = PickList[myPooledSamples,invalidDiluentVolumes, True];
  invalidConjugationDiluentVolumeOptions = If[Length@invalidConjugationDiluentVolumeSamples>0, {ConjugationDiluentVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidConjugationDiluentVolumeSamples>0&&messages,
    Message[Error::InvalidConjugationDiluentVolumes,ObjectToString[invalidConjugationDiluentVolumeSamples],invalidConjugationDiluentVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidConjugationDiluentVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidConjugationDiluentVolumeSamples]>0,
                Test["Our conjugation diluent volumes are valid for the inputs"<>ObjectToString[invalidConjugationDiluentVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidConjugationDiluentVolumeSamples]==0,
                Test["Our conjugation diluent volumes are valid for the inputs"<>ObjectToString[invalidConjugationDiluentVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 10. Check that the quench reagent volumes are valid*)

  (*Retrieve the samples that have invalid quench reagent volumes*)
  invalidQuenchReagentVolumeSamples = PickList[myPooledSamples,invalidQuenchReagentVolumes, True];
  invalidQuenchReagentVolumeOptions = If[Length@invalidQuenchReagentVolumeSamples>0, {QuenchReactionVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidQuenchReagentVolumeSamples>0&&messages,
    Message[Error::InvalidQuenchReagentVolumes,ObjectToString[invalidQuenchReagentVolumeSamples],invalidQuenchReagentVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidQuenchReagentVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidQuenchReagentVolumeSamples]>0,
                Test["Our quench reagent volumes are valid for the inputs"<>ObjectToString[invalidQuenchReagentVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidQuenchReagentVolumeSamples]==0,
                Test["Our quench reagent volumes are valid for the inputs"<>ObjectToString[invalidQuenchReagentVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 11. Check that the quench mix volumes are valid*)

  (*Retrieve the samples that have invalid quench mix volumes*)
  invalidQuenchMixVolumeSamples = PickList[myPooledSamples,invalidQuenchMixVolumes, True];
  invalidQuenchMixVolumeOptions = If[Length@invalidQuenchMixVolumeSamples>0, {QuenchMixVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidQuenchMixVolumeSamples>0&&messages,
    Message[Error::InvalidQuenchMixVolumes,ObjectToString[invalidQuenchMixVolumeSamples],invalidQuenchMixVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidQuenchMixVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidQuenchMixVolumeSamples]>0,
                Test["Our quench mix volumes are valid for the inputs"<>ObjectToString[invalidQuenchMixVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidQuenchMixVolumeSamples]==0,
                Test["Our quench mix volumes are valid for the inputs"<>ObjectToString[invalidQuenchMixVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 13. Check that the post conjugation workup mix volumes are valid*)

  (*Retrieve the samples that have invalid mix volumes*)
  invalidWorkupMixVolumeSamples = PickList[myPooledSamples,invalidPostConjugationWorkupMixVolumes, True];
  invalidWorkupMixVolumeOptions = If[Length@invalidWorkupMixVolumeSamples>0, {PostConjugationWorkupMixVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidWorkupMixVolumeSamples>0&&messages,
    Message[Error::InvalidPostConjugationMixVolumes,ObjectToString[invalidWorkupMixVolumeSamples],invalidWorkupMixVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidWorkupMixVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidWorkupMixVolumeSamples]>0,
                Test["Our post-conjugation mix volumes are valid for the inputs"<>ObjectToString[invalidWorkupMixVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidWorkupMixVolumeSamples]==0,
                Test["Our post-conjugation mix volumes are valid for the inputs"<>ObjectToString[invalidWorkupMixVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 14. Check that the Quench booleans are valid*)

  (*Retrieve the samples that have invalid quench booleans*)
  invalidQuenchBooleanSamples = PickList[myPooledSamples,invalidQuenchBooleans, True];
  invalidQuenchBooleanOptions = If[Length@invalidQuenchBooleanSamples>0, {QuenchMix,PredrainReactionMixture}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidQuenchBooleanSamples>0&&messages,
    Message[Error::InvalidQuenchingOptions,ObjectToString[invalidQuenchBooleanSamples],invalidQuenchBooleanOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidQuenchBooleansTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidQuenchBooleanSamples]>0,
                Test["Our quench booleans do not conflict for the inputs"<>ObjectToString[invalidQuenchBooleanSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidQuenchBooleanSamples]==0,
                Test["Our quench booleans do not conflict for the inputs"<>ObjectToString[invalidQuenchBooleanSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 15. Check that the Post-conjugation booleans are valid*)

  (*Retrieve the samples that have invalid post-conjugation booleans*)
  invalidWorkupBooleanSamples = PickList[myPooledSamples,invalidPostConjugationBooleans, True];
  invalidWorkupBooleanOptions = If[Length@invalidWorkupBooleanSamples>0, {PostConjugationWorkupMix,PostConjugationResuspension}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidWorkupBooleanSamples>0&&messages,
    Message[Error::InvalidPostConjugationOptions,ObjectToString[invalidWorkupBooleanSamples],invalidWorkupBooleanOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidWorkupBooleansTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidWorkupBooleanSamples]>0,
                Test["Our post-conjugation booleans do not conflict for the inputs"<>ObjectToString[invalidWorkupBooleanSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidWorkupBooleanSamples]==0,
                Test["Our post-conjugation booleans do not conflict for the inputs"<>ObjectToString[invalidWorkupBooleanSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 16. Check that the Post-conjugation resuspension volumes are valid*)

  (*Retrieve the samples that have invalid post-conjugation resuspension volumes*)
  invalidPostConjugationResuspensionVolumeSamples = PickList[myPooledSamples,invalidPostConjugationResuspensionVolumes, True];
  invalidPostConjugationResuspensionVolumeOptions = If[Length@invalidPostConjugationResuspensionVolumeSamples>0, {PostConjugationResuspensionDiluentVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidPostConjugationResuspensionVolumeSamples>0&&messages,
    Message[Error::InvalidPostConjugationResuspensionDiluentVolumes,ObjectToString[invalidPostConjugationResuspensionVolumeSamples],invalidPostConjugationResuspensionVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationResuspensionVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPostConjugationResuspensionVolumeSamples]>0,
                Test["Our post-conjugation resuspension volumes are valid for the inputs "<>ObjectToString[invalidPostConjugationResuspensionVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPostConjugationResuspensionVolumeSamples]==0,
                Test["Our post-conjugation resuspension volumes are valid for the inputs "<>ObjectToString[invalidPostConjugationResuspensionVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 17. Check that the Post-conjugation resuspension mix volumes are valid*)

  (*Retrieve the samples that have invalid post-conjugation resuspension mix volumes*)
  invalidPostConjugationResuspensionMixVolumeSamples = PickList[myPooledSamples,invalidPostConjugationResuspensionMixVolumes, True];
  invalidPostConjugationResuspensionMixVolumeOptions = If[Length@invalidPostConjugationResuspensionMixVolumeSamples>0, {PostConjugationResuspensionMixVolume}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidPostConjugationResuspensionMixVolumeSamples>0&&messages,
    Message[Error::InvalidPostConjugationResuspensionMixVolumes,ObjectToString[invalidPostConjugationResuspensionMixVolumeSamples],invalidPostConjugationResuspensionMixVolumeOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidPostConjugationResuspensionMixVolumesTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidPostConjugationResuspensionMixVolumeSamples]>0,
                Test["Our post-conjugation resuspension mix volumes are valid for the inputs "<>ObjectToString[invalidPostConjugationResuspensionMixVolumeSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidPostConjugationResuspensionMixVolumeSamples]==0,
                Test["Our post-conjugation resuspension mix volumes are valid for the inputs "<>ObjectToString[invalidPostConjugationResuspensionMixVolumeSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 18. Check that the analyte concentrations are valid*)

  (*Retrieve the samples that have invalid analyte concentrations*)
  invalidAnalyteConcentrationSamples = PickList[Flatten@myPooledSamples,Flatten@invalidAnalyteConcentrations, True];
  invalidAnalyteConcentrationOptions = If[Length@invalidAnalyteConcentrationSamples>0, {TargetConjugationSampleConcentration}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidAnalyteConcentrationSamples>0&&messages,
    Message[Warning::InvalidSampleAnalyteConcentrations,ObjectToString[invalidAnalyteConcentrationSamples],invalidAnalyteConcentrationOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidAnalyteConcentrationTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidAnalyteConcentrationSamples]>0,
                Test["Our analyte concentrations are valid for the inputs "<>ObjectToString[invalidAnalyteConcentrationSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidAnalyteConcentrationSamples]==0,
                Test["Our analyte concentrations are valid for the inputs "<>ObjectToString[invalidAnalyteConcentrationSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 19. Check that the reaction vessel can accommodate all conjugation and quenching components*)

  (*Retrieve the samples that have invalid reaction vessel*)
  invalidReactionVesselSamples = PickList[myPooledSamples,invalidReactionVessels, True];
  invalidReactionVesselOptions = If[Length@invalidReactionVesselSamples>0, {ReactionVessel}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@invalidReactionVesselSamples>0&&messages,
    Message[Error::InvalidReactionVessel,ObjectToString[invalidReactionVesselSamples],invalidReactionVesselOptions],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  invalidReactionVesselTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[invalidReactionVesselSamples]>0,
                Test["Our reaction vessel can accommodate all reaction and workup components for the inputs "<>ObjectToString[invalidReactionVesselSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[invalidReactionVesselSamples]==0,
                Test["Our reaction vessel can accommodate all reaction and workup components for the inputs "<>ObjectToString[invalidReactionVesselSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 20. Check that the activation containers and storage condtions are compatible. *)
  activationSamplesStorageCondition=PickList[Flatten@Lookup[flatSamplesMapThreadFriendlyOptions,ActivationSamplesOutStorageCondition], resolvedActivateBools,True];
  activationFlatSamples = PickList[flatSimulatedSamples, resolvedActivateBools, True];

  {invalidActivationContainerStorageConditionBool, invalidActivationContainerStorageConditionTests} = If[gatherTests,
    ValidContainerStorageConditionQ[activationFlatSamples, activationContainers, activationSamplesStorageCondition, Output -> {Result, Tests}, Cache -> simulatedCache],
    {ValidContainerStorageConditionQ[activationFlatSamples, activationContainers, activationSamplesStorageCondition, Output -> Result, Cache ->simulatedCache], {}}
  ];

  invalidActivationContainerStorageConditionOptions = If[MemberQ[invalidActivationContainerStorageConditionBool, False], ActivationSamplesOutStorageCondition, Nothing];

  (* 21. Check that the samples out storage conditions are compatible *)
  conjugationSamplesStorageCondition=Flatten@Lookup[mapThreadFriendlyOptions,SamplesOutStorageCondition];

  {invalidSamplesOutStorageConditionBool, invalidSamplesOutStorageConditionTests} = If[gatherTests,
    ValidContainerStorageConditionQ[simulatedSamples[[All,1]], resolvedReactionVessels, conjugationSamplesStorageCondition, Output -> {Result, Tests}, Cache -> simulatedCache],
    {ValidContainerStorageConditionQ[simulatedSamples[[All,1]], resolvedReactionVessels, conjugationSamplesStorageCondition, Output -> Result, Cache ->simulatedCache], {}}
  ];

  invalidSamplesOutStorageConditionOptions = If[MemberQ[invalidSamplesOutStorageConditionBool, False], SamplesOutStorageCondition, Nothing];

  (* 22. Give a warning if the reactants stoichiometry is not known.*)

  (*Retrieve the samples that have unknown coefficents*)
  unknownReactantCoefficientSamples = PickList[Flatten@myPooledSamples,unknownReactantCoefficients, True];
  unknownReactantCoefficientOptions = If[Length@unknownReactantCoefficientSamples>0, {ReactantsStoichiometricCoefficients}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@unknownReactantCoefficientSamples>0&&messages,
    Message[Warning::UnknownReactantsStoichiometry,ObjectToString[unknownReactantCoefficientSamples,Cache->simulatedCache]],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  unknownReactantCoefficientTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[unknownReactantCoefficientSamples]>0,
                Test["The balanced reaction stoichiometry is provided for the inputs"<>ObjectToString[unknownReactantCoefficientSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[unknownReactantCoefficientSamples]==0,
                Test["The balanced reaction stoichiometry is provided for the inputs"<>ObjectToString[unknownReactantCoefficientSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];

  (* 23. Give a warning if the products stoichiometry is not known*)

  (*Retrieve the samples that have invalid reaction vessel*)
  unknownProductCoefficientSamples = PickList[myPooledSamples,unknownProductCoefficients, True];
  unknownProductCoefficientOptions = If[Length@unknownProductCoefficientSamples>0, {ProductStoichiometricCoefficient}, {}];

  (*Throw an error if there are invalid samples*)
  If[ Length@unknownProductCoefficientSamples>0&&messages,
    Message[Warning::UnknownProductStoichiometry,ObjectToString[unknownProductCoefficientSamples,Cache->simulatedCache]],
    Nothing
  ];

  (*If we are gathering tests,create a passing and/or failing test with the appropriate result.*)
  unknownProductCoefficientTest =
      If[gatherTests,
        Module[{failingTest, passingTest},
          failingTest =
              If[Length[unknownProductCoefficientSamples]>0,
                Test["The balanced reaction product stoichiometry is provided for the inputs "<>ObjectToString[unknownProductCoefficientSamples,Cache->simulatedCache]<>" :", True, False],
                Nothing
              ];
          passingTest =
              If[Length[unknownProductCoefficientSamples]==0,
                Test["The balanced reaction product stoichiometry is provided for the inputs "<>ObjectToString[unknownProductCoefficientSamples,Cache->simulatedCache]<>" :", True, True],
                Nothing];
          {failingTest, passingTest}
        ],
        {}
      ];



  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,poolsWithDuplicates,liquidSampleWithNoVolume,solidSampleWithNoMass}]];
  invalidOptions=DeleteDuplicates[Flatten[{
    invalidProcessingOrderOptions,
    invalidPrewWashOptions,
    invalidPreWashMixOptions,
    invalidPrewWashResuspensionOptions,
    invalidPreWashResuspensionMixOptions,
    invalidActivateOptions,
    invalidActivationMixOptions,
    invalidPostActivationwWashOptions,
    invalidPostActivationWashMixOptions,
    invalidPostActivationResuspensionOptions,
    invalidPostActivationResuspensionMixOptions,
    tooManyBuffersOptions,
    tooManyBufferOptionsOptions,
    conflictingConcBufferOptions,
    conflictingConjugationMixOptions,
    conflictingQuenchOptions,
    conflictingPredrainOptions,
    conflictingQuenchMixOptions,
    conflictingWorkupOptions,
    conflictingWorkupMixOptions,
    conflictingPostConjugationResuspensionOptions,
    conflictingWorkupResuspensionMixOptions,
    conflictingPostConjugationDissolveOptions,
    invalidPreWashBooleanOptions,
    invalidActivationBooleanOptions,
    invalidActivationVolumeOptions,
    invalidActivationReagentVolumeOptions,
    invalidActivationDiluentVolumeOptions,
    invalidConjugationReactionVolumeOptions,
    invalidConjugationBufferVolumeOptions,
    invalidConjugationMixVolumeOptions,
    invalidConjugationDiluentVolumeOptions,
    invalidQuenchReagentVolumeOptions,
    invalidQuenchMixVolumeOptions,
    invalidWorkupMixVolumeOptions,
    invalidQuenchBooleanOptions,
    invalidWorkupBooleanOptions,
    invalidPostConjugationResuspensionVolumeOptions,
    invalidPostConjugationResuspensionMixVolumeOptions,
    invalidReactionVesselOptions,
    invalidActivationContainerStorageConditionOptions,
    invalidSamplesOutStorageConditionOptions,
    tooFewConjugationBuffersOptions
  }]];

  (* Throw Error::InvalidInput if there are invalid inputs and we're throwing messages. *)
  If[Length[invalidInputs]>0&&messages,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options and we're throwing messages. *)
  If[Length[invalidOptions]>0&&messages,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (*-- CONTAINER GROUPING RESOLUTION --*)
  (* Resolve RequiredAliquotContainers *)
  (* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
  (* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
  (* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)
  (*Because we are accepting all container types and when needed the experiment function itself will move samples to the requested containers, set targetContainers = Null and RequiredAliquotAmounts = Null.*)
  targetContainers=Null;

  (*Resolve aliquot options and make tests*) (*some is broken with test output for resolvePooledAliquotOptions*)
  flatOptionValues = If[ListQ[#],Flatten[#,1],#]&/@Values[ReplaceRule[myOptions,resolvedSamplePrepOptions]];
  flatAliquotOptionSet = Thread[Keys[ReplaceRule[myOptions,resolvedSamplePrepOptions]]->flatOptionValues];

  {resolvedAliquotOptions,aliquotTests}=If[gatherTests,
      resolveAliquotOptions[
        ExperimentBioconjugation,
        Flatten@myPooledSamples,
        Flatten@simulatedSamples,
        flatAliquotOptionSet,
        Cache->simulatedCache,
        AllowSolids->True,
        RequiredAliquotAmounts->Null,
        RequiredAliquotContainers->targetContainers,
        Output->{Result,Tests}],
    {
      resolveAliquotOptions[
        ExperimentBioconjugation,
        Flatten@myPooledSamples,
        Flatten@simulatedSamples,
        flatAliquotOptionSet,
        Cache->simulatedCache,
        AllowSolids->True,
        RequiredAliquotAmounts->Null,
        RequiredAliquotContainers->targetContainers,
        Output->Result],
      {}
    }
  ];

  (*Re-nest the aliquot options so they matched the pooled formatting of the samples*)
  nestedResolvedAliquotOptionValues = If[ListQ[#],TakeList[#,poolingLengths],#]&/@Values[resolvedAliquotOptions];
  nestedResolvedAliquotOptions = Thread[Keys[resolvedAliquotOptions]->nestedResolvedAliquotOptionValues];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];
  
  (*-- CONSTRUCT THE RESOLVED OPTIONS AND TESTS OUTPUTS --*)
  (* construct the final resolved options. We don't collapse here - that is happening in the main function *)

  (*Helper function to combine shared subprotocol options*)
  combineSubprotocolSharedOptions[resolvedFilterOption_,resolvedPelletOption_, pattern_]:= Module[{pelletPositions, selectedOptions ,combinedOptionList},
    pelletPositions = Flatten[Position[resolvedPelletOption, pattern]];
    selectedOptions = Cases[resolvedPelletOption,pattern];
    combinedOptionList = ReplacePart[resolvedFilterOption,Thread[pelletPositions->selectedOptions]]
  ];

  resolvedOptions=ReplaceRule[
    Normal[roundedBioconjugationOptions],
    Join[
      {
        (*General options*)
        ProcessingBatchSize -> resolvedBatchSize,
        ProcessingBatches -> resolvedProcessingBatches,
        ReactantsStoichiometricCoefficients->TakeList[resolvedReactantCoefficients,poolingLengths],
        ProductStoichiometricCoefficient->resolvedProductCoefficients,
        ReactionVessel -> resolvedReactionVessels,

        (*Sample index matched options*)
        PreWash->TakeList[resolvedPreWashes,poolingLengths],
        PreWashMethod -> TakeList[resolvedPreWashMethods, poolingLengths],
        PreWashNumberOfWashes -> TakeList[resolvedPreWashWashNumbers, poolingLengths],
        PreWashTime -> TakeList[resolvedPreWashTimes, poolingLengths],
        PreWashTemperature -> TakeList[resolvedPreWashTemperatures, poolingLengths],
        PreWashBuffer -> TakeList[resolvedPreWashBuffers, poolingLengths],
        PreWashBufferVolume -> TakeList[resolvedPreWashBufferVolumes, poolingLengths],
        PreWashMix -> TakeList[resolvedPreWashMixes, poolingLengths],
        PreWashMixType -> TakeList[resolvedPreWashMixTypes, poolingLengths],
        PreWashMixVolume -> TakeList[resolvedPreWashMixVolumes, poolingLengths],
        PreWashNumberOfMixes -> TakeList[resolvedPreWashMixNumbers, poolingLengths],
        PreWashMixRate -> TakeList[resolvedPreWashMixRates, poolingLengths],
        PreWashResuspension -> TakeList[resolvedPreWashResuspensions, poolingLengths],
        PreWashResuspensionTime -> TakeList[resolvedPreWashResuspensionTimes, poolingLengths],
        PreWashResuspensionTemperature -> TakeList[resolvedPreWashResuspensionTemperatures, poolingLengths],
        PreWashResuspensionDiluent -> TakeList[resolvedPreWashResuspensionDiluents, poolingLengths],
        PreWashResuspensionDiluentVolume -> TakeList[resolvedPreWashResuspensionDiluentVolumes, poolingLengths],
        PreWashResuspensionMix -> TakeList[resolvedPreWashResuspensionMixes, poolingLengths],
        PreWashResuspensionMixType -> TakeList[resolvedPreWashResuspensionMixTypes, poolingLengths],
        PreWashResuspensionMixVolume -> TakeList[resolvedPreWashResuspensionMixVolumes, poolingLengths],
        PreWashResuspensionNumberOfMixes -> TakeList[resolvedPreWashResuspensioMixNumbers, poolingLengths],
        PreWashResuspensionMixRate -> TakeList[resolvedPreWashResuspensionMixRates, poolingLengths],
        Activate -> TakeList[resolvedActivateBools, poolingLengths],
        ActivationReactionVolume -> TakeList[resolvedActivationReactionVolumes, poolingLengths],
        TargetActivationSampleConcentration -> TakeList[resolvedTargetActivationSampleConcentrations, poolingLengths],
        ActivationSampleVolume -> TakeList[resolvedActivationSampleVolumes, poolingLengths],
        ActivationReagent -> TakeList[resolvedActivationReagents, poolingLengths],
        TargetActivationReagentConcentration -> TakeList[resolvedTargetActivationReagentConcentrations, poolingLengths],
        ActivationReagentVolume -> TakeList[resolvedActivationReagentVolumes, poolingLengths],
        ActivationDiluent -> TakeList[resolvedActivationDiluents, poolingLengths],
        ActivationDiluentVolume -> TakeList[resolvedActivationDiluentVolumes, poolingLengths],
        ActivationTime -> TakeList[resolvedActivationTimes, poolingLengths],
        ActivationTemperature -> TakeList[resolvedActivationTemperatures, poolingLengths],
        ActivationMix -> TakeList[resolvedActivationMixes, poolingLengths],
        ActivationMixType -> TakeList[resolvedActivationMixTypes, poolingLengths],
        ActivationMixRate -> TakeList[resolvedActivationMixRates, poolingLengths],
        ActivationMixVolume -> TakeList[resolvedActivationMixVolumes, poolingLengths],
        ActivationNumberOfMixes -> TakeList[resolvedActivationMixNumbers, poolingLengths],
        PostActivationWash -> TakeList[resolvedPostActivationWashes, poolingLengths],
        PostActivationWashMethod -> TakeList[resolvedPostActivationWashMethods, poolingLengths],
        PostActivationNumberOfWashes -> TakeList[resolvedPostActivationWashNumbers, poolingLengths],
        PostActivationWashTime -> TakeList[resolvedPostActivationWashTimes, poolingLengths],
        PostActivationWashTemperature -> TakeList[resolvedPostActivationWashTemperatures, poolingLengths],
        PostActivationWashBuffer -> TakeList[resolvedPostActivationWashBuffers, poolingLengths],
        PostActivationWashBufferVolume -> TakeList[resolvedPostActivationWashBufferVolumes, poolingLengths],
        PostActivationWashMix -> TakeList[resolvedPostActivationWashMixes, poolingLengths],
        PostActivationWashMixType -> TakeList[resolvedPostActivationWashMixTypes, poolingLengths],
        PostActivationWashMixVolume -> TakeList[resolvedPostActivationWashMixVolumes, poolingLengths],
        PostActivationWashNumberOfMixes -> TakeList[resolvedPostActivationWashMixNumbers, poolingLengths],
        PostActivationWashMixRate -> TakeList[resolvedPostActivationWashMixRates, poolingLengths],
        PostActivationResuspension -> TakeList[resolvedPostActivationResuspensions, poolingLengths],
        PostActivationResuspensionTime -> TakeList[resolvedPostActivationResuspensionTimes, poolingLengths],
        PostActivationResuspensionTemperature -> TakeList[resolvedPostActivationResuspensionTemperatures, poolingLengths],
        PostActivationResuspensionDiluent -> TakeList[resolvedPostActivationResuspensionDiluents, poolingLengths],
        PostActivationResuspensionDiluentVolume -> TakeList[resolvedPostActivationResuspensionDiluentVolumes, poolingLengths],
        PostActivationResuspensionMix -> TakeList[resolvedPostActivationResuspensionMixes, poolingLengths],
        PostActivationResuspensionMixType -> TakeList[resolvedPostActivationResuspensionMixTypes, poolingLengths],
        PostActivationResuspensionMixVolume -> TakeList[resolvedPostActivationResuspensionMixVolumes, poolingLengths],
        PostActivationResuspensionNumberOfMixes -> TakeList[resolvedPostActivationResuspensionMixNumbers, poolingLengths],
        PostActivationResuspensionMixRate -> TakeList[resolvedPostActivationResuspensionMixRates, poolingLengths],
        ActivationSamplesOutStorageCondition -> TakeList[resolvedActivationSamplesOutStorageConditions, poolingLengths],

        (*Sample pool index-matched options*)
        ConjugationReactionVolume -> resolvedConjugationReactionVolumes,
        TargetConjugationSampleConcentration -> TakeList[Flatten@resolvedTargetConjugationSampleConcentrations,poolingLengths],
        ConjugationReactionBufferVolume -> resolvedConjugationReactionBufferVolumes,
        ConcentratedConjugationReactionBufferDilutionFactor -> resolvedConcentratedConjugationReactionBufferDilutionFactors,
        ConjugationReactionBufferDiluent -> resolvedConjugationReactionBufferDiluents,
        ConjugationDiluentVolume -> resolvedConjugationDiluentVolumes,
        ConjugationTime -> resolvedConjugationTimes,
        ConjugationTemperature -> resolvedConjugationTemperatures,
        ConjugationMixType -> resolvedConjugationMixTypes,
        ConjugationMixVolume -> resolvedConjugationMixVolumes,
        ConjugationNumberOfMixes -> resolvedConjugationMixNumbers,
        ConjugationMixRate -> resolvedConjugationMixRates,
        QuenchConjugation -> resolvedQuenchBooleans,
        QuenchReactionVolume -> resolvedQuenchReactionVolumes,
        QuenchReagent -> resolvedQuenchReagents,
        QuenchReagentDilutionFactor -> resolvedQuenchReagentDilutionFactors,
        QuenchReagentVolume -> resolvedQuenchReagentVolumes,
        QuenchTime -> resolvedQuenchTimes,
        QuenchTemperature -> resolvedQuenchTemperatures,
        QuenchMix -> resolvedQuenchMixes,
        QuenchMixType -> resolvedQuenchMixTypes,
        QuenchMixVolume -> resolvedQuenchMixVolumes,
        QuenchNumberOfMixes -> resolvedQuenchMixNumbers,
        QuenchMixRate -> resolvedQuenchMixRates,
        PostConjugationWorkupMethod -> resolvedPostConjugationWorkupMethods,
        PostConjugationWorkupMix -> resolvedPostConjugationWorkupMixes,
        PostConjugationWorkupMixType -> resolvedPostConjugationWorkupMixTypes,
        PostConjugationWorkupMixVolume -> resolvedPostConjugationWorkupMixVolumes,
        PostConjugationWorkupNumberOfMixes -> resolvedPostConjugationWorkupMixNumbers,
        PostConjugationWorkupMixRate -> resolvedPostConjugationWorkupMixRates,
        PostConjugationResuspension -> resolvedPostConjugationResuspensions,
        PostConjugationResuspensionDiluent -> resolvedPostConjugationResuspensionDiluents,
        PostConjugationResuspensionDiluentVolume -> resolvedPostConjugationResuspensionDiluentVolumes,
        PostConjugationResuspensionMix -> resolvedPostConjugationResuspensionMixes,
        PostConjugationResuspensionMixType -> resolvedPostConjugationResuspensionMixTypes,
        PostConjugationResuspensionMixRate -> resolvedPostConjugationResuspensionMixRates,
        PostConjugationResuspensionMixVolume -> resolvedPostConjugationResuspensionMixVolumes,
        PostConjugationResuspensionNumberOfMixes -> resolvedPostConjugationResuspensionMixNumbers,
        PostConjugationResuspensionMixUntilDissolved -> resolvedPostConjugationResuspensionMixUntilDissolvedBools,
        PostConjugationResuspensionMaxNumberOfMixes -> resolvedPostConjugationResuspensionMaxMixNumbers,
        PostConjugationResuspensionTime -> resolvedPostConjugationResuspensionTimes,
        PostConjugationResuspensionMaxTime -> resolvedPostConjugationResuspensionMaxTimes,
        PostConjugationResuspensionTemperature -> resolvedPostConjugationResuspensionTemperatures,
        PredrainMethod -> resolvedPredrainMethods,


        (*Sample index matched subprotocol options*)
        PreWashFiltrationType->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFiltrationType],poolingLengths],
        PreWashInstrument->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPreWashFilterOptionsFull,PreWashInstrument],Lookup[resolvedPreWashPelletOptionsFull,PreWashInstrument],ObjectP[]],
          poolingLengths
          ],
        PreWashFilter->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFilter],poolingLengths],
        PreWashFilterMembraneMaterial->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFilterMembraneMaterial],poolingLengths],
        PreWashPrefilterMembraneMaterial->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashPrefilterMembraneMaterial],poolingLengths],
        PreWashFilterPoreSize->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFilterPoreSize],poolingLengths],
        PreWashFilterMolecularWeightCutoff->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFilterMolecularWeightCutoff],poolingLengths],
        PreWashPrefilterPoreSize->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashPrefilterPoreSize],poolingLengths],
        PreWashFiltrationSyringe->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFiltrationSyringe],poolingLengths],
        PreWashFilterHousing->TakeList[Lookup[resolvedPreWashFilterOptionsFull,PreWashFilterHousing],poolingLengths],
        PreWashCentrifugationIntensity->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPreWashFilterOptionsFull,PreWashCentrifugationIntensity],Lookup[resolvedPreWashPelletOptionsFull,PreWashCentrifugationIntensity],_Quantity],
          poolingLengths
        ],
        PreWashCentrifugationTime->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPreWashFilterOptionsFull,PreWashCentrifugationTime],Lookup[resolvedPreWashPelletOptionsFull,PreWashCentrifugationTime],_Quantity],
          poolingLengths
        ],
        PreWashCentrifugationTemperature->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPreWashFilterOptionsFull,PreWashCentrifugationTemperature],Lookup[resolvedPreWashPelletOptionsFull,PreWashCentrifugationTemperature],_Quantity],
          poolingLengths
        ],
        PreWashMagnetizationRack->TakeList[Lookup[resolvedPreWashMagnetOptionsFull,PreWashMagnetizationRack],poolingLengths],

        PostActivationWashFiltrationType->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFiltrationType],poolingLengths],
        PostActivationWashInstrument->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashInstrument],Lookup[resolvedPostActivationWashPelletOptionsFull,PostActivationWashInstrument],ObjectP[]],
          poolingLengths
        ],
        PostActivationWashFilter->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFilter],poolingLengths],
        PostActivationWashFilterMembraneMaterial->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFilterMembraneMaterial],poolingLengths],
        PostActivationWashPrefilterMembraneMaterial->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashPrefilterMembraneMaterial],poolingLengths],
        PostActivationWashFilterPoreSize->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFilterPoreSize],poolingLengths],
        PostActivationWashFilterMolecularWeightCutoff->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFilterMolecularWeightCutoff],poolingLengths],
        PostActivationWashPrefilterPoreSize->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashPrefilterPoreSize],poolingLengths],
        PostActivationWashFiltrationSyringe->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFiltrationSyringe],poolingLengths],
        PostActivationWashFilterHousing->TakeList[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashFilterHousing],poolingLengths],
        PostActivationWashCentrifugationIntensity->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashCentrifugationIntensity],Lookup[resolvedPostActivationWashPelletOptionsFull,PostActivationWashCentrifugationIntensity],_Quantity],
          poolingLengths
        ],
        PostActivationWashCentrifugationTime->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashCentrifugationTime],Lookup[resolvedPostActivationWashPelletOptionsFull,PostActivationWashCentrifugationTime],_Quantity],
          poolingLengths
        ],
        PostActivationWashCentrifugationTemperature->TakeList[
          combineSubprotocolSharedOptions[Lookup[resolvedPostActivationWashFilterOptionsFull,PostActivationWashCentrifugationTemperature],Lookup[resolvedPostActivationWashPelletOptionsFull,PostActivationWashCentrifugationTemperature],_Quantity],
          poolingLengths
        ],
        PostActivationWashMagnetizationRack->TakeList[Lookup[resolvedPostActivationWashMagnetOptionsFull,PostActivationWashMagnetizationRack],poolingLengths],


        (*Sample pool index matched subprotocol options*)
        PredrainInstrument-> Lookup[resolvedPredrainPelletOptionsFull,PredrainInstrument],
        PredrainCentrifugationIntensity-> Lookup[resolvedPredrainPelletOptionsFull,PredrainCentrifugationIntensity],
        PredrainCentrifugationTime-> Lookup[resolvedPredrainPelletOptionsFull,PredrainCentrifugationTime],
        PredrainTemperature-> combineSubprotocolSharedOptions[Lookup[resolvedPredrainPelletOptionsFull,PredrainTemperature],Lookup[resolvedPredrainMagnetOptionsFull,PredrainTemperature],_Quantity],
        PredrainMagnetizationRack->Lookup[resolvedPredrainMagnetOptionsFull,PredrainMagnetizationRack],
        PredrainMagnetizationTime->Lookup[resolvedPredrainMagnetOptionsFull,PredrainMagnetizationTime],

        PostConjugationFiltrationType->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFiltrationType],
        PostConjugationWorkupInstrument-> combineSubprotocolSharedOptions[Lookup[resolvedWorkupFilterOptionsFull,PostConjugationWorkupInstrument], Lookup[resolvedWorkupPelletOptionsFull,PostConjugationWorkupInstrument], ObjectP[]],
        PostConjugationFilter->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFilter],
        PostConjugationFilterMembraneMaterial->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFilterMembraneMaterial],
        PostConjugationPrefilterMembraneMaterial->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationPrefilterMembraneMaterial],
        PostConjugationFilterPoreSize->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFilterPoreSize],
        PostConjugationFilterMolecularWeightCutoff->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFilterMolecularWeightCutoff],
        PostConjugationPrefilterPoreSize->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationPrefilterPoreSize],
        PostConjugationFiltrationSyringe->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFiltrationSyringe],
        PostConjugationFilterHousing->Lookup[resolvedWorkupFilterOptionsFull,PostConjugationFilterHousing],
        PostConjugationCentrifugationIntensity->combineSubprotocolSharedOptions[Lookup[resolvedWorkupFilterOptionsFull,PostConjugationCentrifugationIntensity], Lookup[resolvedWorkupPelletOptionsFull,PostConjugationCentrifugationIntensity], _Quantity],
        PostConjugationCentrifugationTime->combineSubprotocolSharedOptions[Lookup[resolvedWorkupFilterOptionsFull,PostConjugationCentrifugationTime], Lookup[resolvedWorkupPelletOptionsFull,PostConjugationCentrifugationTime], _Quantity],
        PostConjugationCentrifugationTemperature->combineSubprotocolSharedOptions[Lookup[resolvedWorkupFilterOptionsFull,PostConjugationCentrifugationTemperature], Lookup[resolvedWorkupPelletOptionsFull,PostConjugationCentrifugationTemperature], _Quantity],
        PostConjugationMagnetizationRack->Lookup[resolvedWorkupMagnetOptionsFull,PostConjugationMagnetizationRack]
      },
      resolvedSamplePrepOptions,
      nestedResolvedAliquotOptions,
      resolvedPostProcessingOptions
    ]
  ];

(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
  allTests= Cases[Flatten[{
    discardedTest,
    precisionTests,
    invalidProcessingOrderTest,
    invalidPreWashTest,
    invalidPreWashMixTest,
    invalidPreWashResuspensionTest,
    invalidPreWashResuspensionMixTest,
    invalidActivationTest,
    invalidActivationMixTest,
    invalidPostActivationWashTest,
    invalidPostActivationWashMixTest,
    invalidPostActivationResuspensionTest,
    invalidPostActivationResuspensionMixTest,
    invalidConjugationBufferTest,
    invalidConjugationBufferOptionsTest,
    invalidConcentratedConjugationBufferTest,
    invalidConjugationMixTest,
    invalidQuenchOptionsTest,
    invalidPredrainOptionsTest,
    invalidQuenchMixTest,
    invalidPostConjugationWorkupOptionsTest,
    invalidPostConjugationMixTest,
    invalidPostConjugationResuspensionOptionsTest,
    invalidPostConjugationResuspensionMixTest,
    invalidPostConjugationMixUntilDissolvedOptionsTest,
    preWashFilterTests,
    preWashPelletTests,
    preWashMagneticTransferTests,
    postActivationWashFilterTests,
    postActivationWashPelletTests,
    postActivationWashMagneticTransferTests,
    predrainPelletTests,
    predrainMagneticTransferTests,
    workupFilterTests,
    workupPelletTests,
    workupMagneticTransferTests,
    invalidPreWashBooleansTest,
    invalidActivationBooleansTest,
    invalidActivationVolumesTest,
    invalidActivationReagentVolumesTest,
    invalidActivationDiluentVolumesTest,
    invalidConjugationReactionVolumesTest,
    invalidConjugationBufferVolumesTest,
    invalidConjugationMixVolumesTest,
    invalidConjugationDiluentVolumesTest,
    invalidQuenchReagentVolumesTest,
    invalidQuenchMixVolumesTest,
    invalidWorkupMixVolumesTest,
    invalidQuenchBooleansTest,
    invalidWorkupBooleansTest,
    invalidPostConjugationResuspensionVolumesTest,
    invalidPostConjugationResuspensionMixVolumesTest,
    invalidReactionVesselTest,
    invalidContainerStorageConditionTests,
    invalidActivationContainerStorageConditionTests,
    invalidSamplesOutStorageConditionTests,
    invalidDuplicatedInputTest,
    emptySampleInputTest,
    tooFewConjugationBufferTest
  }], _EmeraldTest ];

  (* generate the Result output rule *)
  (* if we're not returning results, Results rule is just Null *)
  resultRule = Result -> If[MemberQ[output,Result],
    resolvedOptions,
    Null
  ];

  (* generate the tests rule. If we're not gathering tests, the rule is just Null *)
  testsRule = Tests -> If[gatherTests,
    allTests,
    Null
  ];

  (* Return our resolved options and/or tests, as desired *)
  outputSpecification/. {resultRule,testsRule}

];

(* ==========Resource packets Helper function ========== *)
DefineOptions[experimentBioconjugationResourcePackets,
  Options:>{CacheOption,HelperOutputOption,SimulationOption}
];
experimentBioconjugationResourcePackets[myPooledSamples : ListableP[{ObjectP[Object[Sample]]..}], myNewIdentityModels:ListableP[ObjectP[IdentityModelTypes]], myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, ops : OptionsPattern[]] := Module[
  {
    expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, simulation,inheritedCache,
    sampleResourceReplaceRules, samplesInResources, protocolPacket, flatResolvedOptionValues,flatResolvedOptions,sharedFieldPacket, finalizedPacket,newIMLinks,productIdentityModels,
    allResourceBlobs, fulfillable, frqTests, testsRule, resultRule, poolLengths, optionsWithReplicates,reactantCoefficients,productCoefficients,
    allSamplePackets, containerPackets, expandedAliquotAmount, expandedPreWash, expandedActivate, expandedActivationSampleVolume, expandedConjugationAmount,
    sampleAmounts, samplesInAmountRules, uniqueSampleAmountRules, containersIn, containersInResource, expandedReactionVessels, requestedContainerCount,
    reactionVesselPositions, reactionContainerReplaceRules, reactionVesselResources, expandedPreWashBuffer, expandedPreWashBufferVolume, preWashBufferVolumeRules,
    preWashBufferResourceReplaceRules, preWashBufferResources, expandedPreWashResuspensionDiluent, expandedPreWashResuspensionDiluentVolume, preWashResuspensionDiluentVolumeRules,
    preWashResuspensionDiluentResourceReplaceRules, preWashResuspensionDiluentResources, expandedActivationReagent, expandedActivationReagentVolume, activationReagentVolumeRules,
    activationReagentResourceReplaceRules, activationReagentResources, expandedActivationDiluent, expandedActivationDiluentVolume, activationDiluentVolumeRules,
    activationDiluentResourceReplaceRules, activationDiluentResources, expandedActivationContainer, requestedActivationContainerCount, activationContainerPositions,
    activationContainerResourceRules, activationContainerFlatResources, expandedPostActivationWashBuffer, expandedPostActivationWashBufferVolume, postActivationWashBufferVolumeRules,
    postActivationWashBufferResourceReplaceRules,postActivationWashBufferResources, expandedPostActivationResuspensionDiluent, expandedPostActivationResuspensionDiluentVolume,
    postActivationResuspensionDiluentVolumeRules, postActivationResuspensionDiluentResourceReplaceRules, postActivationResuspensionDiluentResources,
    expandedConjugationReactionBuffer, expandedConjugationReactionBufferVolume, expandedConjugationReactionBufferVolumeRules, conjugationReactionBufferResourceReplaceRules,
    conjugationReactionBufferResources, expandedConcConjugationReactionBuffer, expandedConcConjugationReactionDilutionFactor, expandedConcConjugationBufferVolume,
    expandedConcConjugationReactionBufferVolumeRules, concConjugationReactionBufferResourceReplaceRules, concConjugationReactionBufferResources,
    expandedConjugationReactionBufferDiluent, expandedConjugationDiluentVolume, expandedConjugationDiluentVolumeRules, conjugationDiluentResourceReplaceRules,
    conjugationDiluentResources, expandedQuenchReagent, expandedQuenchReagentVolume, expandedQuenchReagentVolumeRules, quenchReagentResourceReplaceRules, quenchReagentResources,
    expandedPostConjugationWorkupBuffer, expandedPostConjugationWorkupBufferVolume,expandedPostConjugationBufferVolumeRules, postConjugationBufferResourceReplaceRules,
    postConjugationBufferResources,expandedPostConjugationResuspensionDiluent, expandedPostConjugationResuspensionDiluentVolume,expandedPostConjugationResuspensionDiluentVolumeRules,
    postConjugationResuspensionDiluentResourceReplaceRules,postConjugationResuspensionDiluentResources, expectedYield,processingOrder,processingBatches,preWashMethods,
    preWashNumberOfWashes, preWashBufferVolumes, preWashMagneticSeparator, preWashResuspensionDiluentVolumes, activationReactionVolumes, activationSampleConcentrations, activationSampleVolumes, activationReagentVolumes,
    activationReagentConcentrations,activationDiluentVolumes, postActivationWashMethod, postActivationNumberOfWashes, postActivationWashBufferVolumes, postActivationMagneticSeparator,
    postActivationResuspensionDiluentVolumes, activationSamplesOutStorageCondition, conjugationReactionVolumes, conjugationSampleConcentrations, conjugationAmounts, conjugationReactionBufferVolumes,
    concConjugationReactionBufferDilutionFactor, conjugationDiluentVolumes, predrainMethod, predrainMagneticSeparator, predrainMagneticSeparationTime, quenchReactionVolumes, quenchReagentDilutionFactors, quenchReagentVolumes, postConjugationWorkupMethod,
    postConjugationBufferVolumes, postConjugationMagneticSeparator, postConjugationDiluentVolume, convertedActivationSampleConcentrations, convertedActivationReagentConcentrations, reactionChemistry,flatPreWashMixOptions,
    preWashMix, flatPreWashFilterOptions, flatPreWashFilterBooleans, preWashFilter, flatPreWashPelletOptions, flatPreWashPelletBooleans, preWashPellet, flatPreWashResuspensionOptions, preWashResuspension,
    flatActivationOptions,activation, flatPostActivationWashMixOptions, postActivationWashMix, flatPostActivationWashFilterOptions, flatPostActivationWashFilterBooleans, postActivationWashFilter,
    flatPostActivationWashPelletOptions, flatPostActivationWashPelletBooleans, postActivationWashPellet, flatPostActivationWashResuspensionOptions, postActivationWashResuspension,
    convertedConjugationSampleConcentrations, convertedConjugationSampleAmounts, flatConjugationOptions, conjugation, flatPredrainPelletOptions, flatPredrainPelletBooleans, predrainPellet,
    convertedPredrainMagneticSeparationTime, flatQuenchOptions, quenching, flatPostConjugationMixOptions, postConjugationMix, flatPostConjugationFilterOptions, flatPostConjugationFilterBooleans,
    postConjugationFilter, flatPostConjugationPelletOptions, flatPostConjugationPelletBooleans, postConjugationPellet, flatPostConjugationResuspensionOptions, postConjugationResuspension, processingBatchSize, preWashTime, preWashNumber, preWashCentrifugationTime, preWashResuspensionTime, activationTime,
    postActivationWashNumber, postActivationWashTime, postActivationCentrifugationTime, postActivationResuspensionTime, conjugationTime, predrainCentrifugationTime, predrainMagnetizationTime, quenchTime,
    postConjugationTime, postConjugationCentrifugationTime, postConjugationResuspensionTime,preWashTotalTime,activationTotalTime, postActivationWashTotalTime, activationCheckpoint,conjugationTotalTime, quenchingTotalTime, quenchingCheckpoint,
    postConjugationTotalTime,convertedPostConjugationMagneticSeparationTime,postConjugationCheckpoint, sampleObjectState,sampleObjectAmount,experimentContainers,samplePacketFields,samplesInStorageCondition, samplesOutStorageCondition,samplesWithReplicates
  },

  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* lookup the cache *)
  inheritedCache = Lookup[ToList[ops], Cache];
  simulation=Lookup[ToList[ops],Simulation, Null];

  (* determine the pool lenghts*)
  poolLengths = Map[Length[#]&, myPooledSamples];

  (* -- Expand inputs and index-matched options to take into account the NumberOfReplicates option -- *)
  (* - Expand the index-matched inputs for the NumberOfReplicates - *)
  {samplesWithReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentBioconjugation, {myPooledSamples, myNewIdentityModels}, myResolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentBioconjugation,
    RemoveHiddenOptions[ExperimentBioconjugation, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  experimentContainers = Cases[DeleteDuplicates@Flatten[Lookup[optionsWithReplicates,{ActivationContainer,ReactionVessel}]],Except[Null]];
  samplePacketFields = Packet[SamplePreparationCacheFields[Object[Sample],Format->Sequence]];

  (* --- Make our one big Download call --- *)
  {allSamplePackets, containerPackets} = Quiet[
    Download[
      {
        Flatten@myPooledSamples,
        experimentContainers
      },
      {
        {samplePacketFields},
        {Packet[AllowedPositions]}
      },
      Cache -> inheritedCache,
      Simulation->simulation,
      Date -> Now
    ],
    {Download::FieldDoesntExist}
  ];

  (* --- Make all the resources needed in the experiment --- *)

  (* -- Generate resources for the SamplesIn -- *)
  (* pull out the options needed to make the SamplesIn resources *)
  {expandedAliquotAmount, expandedPreWash, expandedActivate, expandedActivationSampleVolume, expandedConjugationAmount} = Lookup[optionsWithReplicates, {AliquotAmount, PreWash, Activate, ActivationSampleVolume, ConjugationAmount}];
  sampleObjectState = Lookup[fetchPacketFromCache[#,Flatten@allSamplePackets], State]& /@ Flatten[myPooledSamples];

  sampleObjectAmount = MapThread[
    If[MatchQ[#2, Solid],
      Lookup[fetchPacketFromCache[#1,Flatten@allSamplePackets],Mass],
      Lookup[fetchPacketFromCache[#1,Flatten@allSamplePackets],Volume]
    ]&,
    {Flatten[myPooledSamples], Flatten@sampleObjectState}
  ];

  (* Get the sample volume;
    if we're aliquoting, use that amount;
    if we're not aliquoting, PreWashing or Activating use the ConjugationAmount;
    if we're Activating but not aliquoting or PreWashing use the ActivationSampleVolume;
    in all other cases use the entire sample volume/mass. *)

  sampleAmounts = MapThread[
    Switch[{QuantityQ[#1], #2, #3},
      {True, _, _}, #1,
      {False, False, False}, #5,
      {False, False, True}, #4,
      {_, _, _}, #6
    ]&,
    {Flatten@expandedAliquotAmount, Flatten@expandedPreWash, Flatten@expandedActivate, Flatten@expandedActivationSampleVolume, Flatten@expandedConjugationAmount, Flatten@sampleObjectAmount}
  ];

  (* Pair the SamplesIn and their amounts *)
  samplesInAmountRules = MapThread[
    (#1 -> #2)&,
    {Flatten@myPooledSamples, sampleAmounts}
  ];

  (* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
  uniqueSampleAmountRules = Merge[samplesInAmountRules, Total];

  (* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
  sampleResourceReplaceRules = KeyValueMap[
    Function[{sample, amount},
      If[VolumeQ[amount] || MassQ[amount],
        sample -> Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount],
        sample -> Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]]]
      ]
    ],
    uniqueSampleAmountRules
  ];

  (* Use the replace rules to get the sample resources *)
  samplesInResources = Replace[Flatten@myPooledSamples, sampleResourceReplaceRules, {1}];

  (* -- Generate the containers in resource -- *)
  (*Get the containers for all input samples and find the unique containers.*)
  containersIn = DeleteDuplicates[Lookup[Flatten@allSamplePackets, Container]];

  (*Create ContainersIn resource*)
  containersInResource = (Resource[Sample -> #, Name -> ToString[Unique[]]]&) /@ containersIn;


  (* -- Generate resources for the ReactionVessels -- *)
  expandedReactionVessels = Lookup[optionsWithReplicates, ReactionVessel];
  requestedContainerCount = Tally[expandedReactionVessels];
  reactionVesselPositions = Position[expandedReactionVessels, #]& /@ requestedContainerCount[[All, 1]];

  (*Find the number of required containers and make the resources*)
  reactionContainerReplaceRules = Flatten[
    MapThread[
      Module[{container, containerPacket, containerCapacity, reqWells, overFlow, resources, replaceRules,containerNum,expandedResources},
        (*get the container object for this group*)
        container = First[#1];
        (*get the corresponding packet for the container*)
        containerPacket = Cases[Flatten@containerPackets, KeyValuePattern[Object -> Download[container, Object]]];
        (*get the container capacity*)
        containerCapacity = Length[Lookup[containerPacket, AllowedPositions] /. Alternatives -> List];
        (*get the calculated required wells*)
        reqWells = Last[#1];
        (*find the number of containers needed*)
        containerNum = Floor[reqWells/containerCapacity];
        (*find the number of overflow wells if any*)
        overFlow = reqWells - (containerCapacity*containerNum);
        (*Make the resources*)
        resources = ConstantArray[Link[Resource[Sample -> container, Name -> ToString[Unique[]]]], containerNum+1];
        (*expand the resources for each conjugation*)
        expandedResources = MapThread[ConstantArray[#1, #2]&,{resources, Flatten[{ConstantArray[containerCapacity,containerNum],overFlow}]}];
        (*Make the replace part rules so that we get index matched containers in our protocol object*)
        replaceRules = Thread[Flatten[#2] -> Flatten@expandedResources]
      ]&,
      {requestedContainerCount, reactionVesselPositions}
    ]
  ];

  (*Make the resources*)
  reactionVesselResources = ReplacePart[expandedReactionVessels, reactionContainerReplaceRules];

  (* -- Generate resources for the PreWashBuffer -- *)

  (*Get the necessary options*)
  {expandedPreWashBuffer, expandedPreWashBufferVolume} = Lookup[optionsWithReplicates, {PreWashBuffer, PreWashBufferVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  preWashBufferVolumeRules = Merge[Thread[ (Flatten[expandedPreWashBuffer]/.Null->Nothing) -> (Flatten[expandedPreWashBufferVolume]/.Null->Nothing)], Total];

  (*Make the resource replace rules*)
  preWashBufferResourceReplaceRules = If[MatchQ[preWashBufferVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, preWashBufferVolumeRules]
  ];
  preWashBufferResources = expandedPreWashBuffer /. preWashBufferResourceReplaceRules;


  (* -- Generate resources for the PreWashResuspensionDiluent -- *)
  (*Get the necessary options*)
  {expandedPreWashResuspensionDiluent, expandedPreWashResuspensionDiluentVolume} = Lookup[optionsWithReplicates, {PreWashResuspensionDiluent, PreWashResuspensionDiluentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  preWashResuspensionDiluentVolumeRules = Normal[Merge[Thread[(Flatten[expandedPreWashResuspensionDiluent]/.Null->Nothing) -> (Flatten[expandedPreWashResuspensionDiluentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  preWashResuspensionDiluentResourceReplaceRules = If[MatchQ[preWashResuspensionDiluentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@preWashResuspensionDiluentVolumeRules]
  ];
  preWashResuspensionDiluentResources = expandedPreWashResuspensionDiluent /. preWashResuspensionDiluentResourceReplaceRules;


  (* -- Generate resources for the ActivationReagent -- *)
  (*Get the necessary options*)
  {expandedActivationReagent, expandedActivationReagentVolume} = Lookup[optionsWithReplicates, {ActivationReagent, ActivationReagentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  activationReagentVolumeRules = Normal[Merge[Thread[(Flatten[expandedActivationReagent]/.Null->Nothing) ->( Flatten[expandedActivationReagentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  activationReagentResourceReplaceRules = If[MatchQ[activationReagentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@activationReagentVolumeRules]
  ];
  activationReagentResources = expandedActivationReagent /. activationReagentResourceReplaceRules;


  (* -- Generate resources for the ActivationDiluent -- *)
  (*Get the necessary options*)
  {expandedActivationDiluent, expandedActivationDiluentVolume} = Lookup[optionsWithReplicates, {ActivationDiluent, ActivationDiluentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  activationDiluentVolumeRules = Normal[Merge[Thread[(Flatten[expandedActivationDiluent]/.Null->Nothing) -> (Flatten[expandedActivationDiluentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  activationDiluentResourceReplaceRules = If[MatchQ[activationDiluentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@activationDiluentVolumeRules]
  ];
  activationDiluentResources = expandedActivationDiluent /. activationDiluentResourceReplaceRules;


  (* -- Generate resources for the ActivationContainer -- *)
  expandedActivationContainer = Lookup[optionsWithReplicates, ActivationContainer];
  requestedActivationContainerCount = Tally[Flatten[(expandedActivationContainer/.Null->Nothing), 1]];
  activationContainerPositions = If[MatchQ[requestedActivationContainerCount,{}],
    {},
    Position[Flatten[expandedActivationContainer, 1], #]& /@ requestedActivationContainerCount[[All, 1]]
  ];

  (*Find the number of required containers and make the resources*)
  activationContainerResourceRules = If[MatchQ[requestedActivationContainerCount, {}],
    {},
    Flatten[
      MapThread[
        Module[{container, containerPacket, containerCapacity, reqWells, overFlow, resources, replaceRules},
          (*get the container object for this group*)
          {container} = Cases[Flatten@#1,ObjectP[]];
          (*get the corresponding packet for the container*)
          containerPacket = Cases[Flatten@containerPackets, KeyValuePattern[Object -> ObjectP[Download[container, Object]]]];
          (*get the container capacity*)
          containerCapacity = Length[Lookup[containerPacket, AllowedPositions] /. Alternatives -> List];
          (*get the calculated required wells*)
          reqWells = Last[#1];
          (*find the number of overflow wells if any*)
          overFlow = Mod[reqWells , containerCapacity];
          (*Make the resources*)
          resources =Map[ ConstantArray[Link[Resource[Sample -> container, Name -> ToString[Unique[]]]], #]&, {reqWells - overFlow, overFlow}];
          (*Make the replace part rules so that we get index matched containers in our protocol object*)
          replaceRules = Thread[Flatten[#2] -> Flatten@resources]
        ]&,
        {requestedActivationContainerCount, activationContainerPositions}
      ]
    ]
  ];

  (*Make the resources*)
  activationContainerFlatResources = ReplacePart[Flatten[expandedActivationContainer, 1], activationContainerResourceRules];


  (* -- Generate resources for the PostActivationWashBuffer -- *)
  (*Get the necessary options*)
  {expandedPostActivationWashBuffer, expandedPostActivationWashBufferVolume} = Lookup[optionsWithReplicates, {PostActivationWashBuffer, PostActivationWashBufferVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  postActivationWashBufferVolumeRules = Normal[Merge[Thread[(Flatten[expandedPostActivationWashBuffer]/.Null->Nothing) -> (Flatten[expandedPostActivationWashBufferVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  postActivationWashBufferResourceReplaceRules =If[MatchQ[postActivationWashBufferVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@postActivationWashBufferVolumeRules]
  ];
  postActivationWashBufferResources = expandedPostActivationWashBuffer /. postActivationWashBufferResourceReplaceRules;


  (* -- Generate resources for the PostActivationResuspensionDiluent -- *)
  (*Get the necessary options*)
  {expandedPostActivationResuspensionDiluent, expandedPostActivationResuspensionDiluentVolume} = Lookup[optionsWithReplicates, {PostActivationResuspensionDiluent, PostActivationResuspensionDiluentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  postActivationResuspensionDiluentVolumeRules = Normal[Merge[Thread[(Flatten[expandedPostActivationResuspensionDiluent]/.Null->Nothing) -> (Flatten[expandedPostActivationResuspensionDiluentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  postActivationResuspensionDiluentResourceReplaceRules = If[MatchQ[postActivationResuspensionDiluentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@postActivationResuspensionDiluentVolumeRules]
  ];
  postActivationResuspensionDiluentResources = expandedPostActivationResuspensionDiluent /. postActivationResuspensionDiluentResourceReplaceRules;


  (* -- Generate resources for the ConjugationReactionBuffer -- *)
  (*Get the necessary options*)
  {expandedConjugationReactionBuffer, expandedConjugationReactionBufferVolume} = Lookup[optionsWithReplicates, {ConjugationReactionBuffer, ConjugationReactionBufferVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  expandedConjugationReactionBufferVolumeRules = If[MemberQ[Flatten[expandedConjugationReactionBuffer],Except[Null]],
    Normal[Merge[Thread[(Flatten[expandedConjugationReactionBuffer]/.Null->Nothing) -> (Flatten[expandedConjugationReactionBufferVolume]/.Null->Nothing)], Total]],
    {}
  ];

  (*Make the resource replace rules*)
  conjugationReactionBufferResourceReplaceRules = If[MatchQ[expandedConjugationReactionBufferVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@expandedConjugationReactionBufferVolumeRules]
  ];
  conjugationReactionBufferResources = expandedConjugationReactionBuffer /. conjugationReactionBufferResourceReplaceRules;


  (* -- Generate resources for the ConcentratedConjugationReactionBuffer -- *)
  (*Get the necessary options*)
  {expandedConcConjugationReactionBuffer, expandedConcConjugationReactionDilutionFactor} = Lookup[optionsWithReplicates, {ConcentratedConjugationReactionBuffer, ConcentratedConjugationReactionBufferDilutionFactor}];
  expandedConcConjugationBufferVolume = MapThread[If[MatchQ[#1,Null], Null, #2/#3]&,{expandedConcConjugationReactionBuffer,expandedConjugationReactionBufferVolume, expandedConcConjugationReactionDilutionFactor}];

  (*Find the unique buffers and how much total volume is required for each*)
  expandedConcConjugationReactionBufferVolumeRules = Merge[Thread[(Flatten[expandedConcConjugationReactionBuffer]/.Null->Nothing) -> (Flatten[expandedConcConjugationBufferVolume]/.Null->Nothing)], Total];

  (*Make the resource replace rules*)
  concConjugationReactionBufferResourceReplaceRules = If[MatchQ[expandedConcConjugationReactionBufferVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, expandedConcConjugationReactionBufferVolumeRules]
  ];
  concConjugationReactionBufferResources = expandedConcConjugationReactionBuffer /. concConjugationReactionBufferResourceReplaceRules;


  (* -- Generate resources for the ConjugationReactionBufferDiluent -- *)
  (*Get the necessary options*)
  {expandedConjugationReactionBufferDiluent, expandedConjugationDiluentVolume} = Lookup[optionsWithReplicates, {ConjugationReactionBufferDiluent, ConjugationDiluentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  expandedConjugationDiluentVolumeRules = Normal[Merge[Thread[(Flatten[expandedConjugationReactionBufferDiluent]/.Null->Nothing) -> (Flatten[expandedConjugationDiluentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  conjugationDiluentResourceReplaceRules = If[MatchQ[expandedConjugationDiluentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@expandedConjugationDiluentVolumeRules]
  ];
  conjugationDiluentResources = expandedConjugationReactionBufferDiluent /. conjugationDiluentResourceReplaceRules;


  (* -- Generate resources for the QuenchReagent -- *)
  (*Get the necessary options*)
  {expandedQuenchReagent, expandedQuenchReagentVolume} = Lookup[optionsWithReplicates, {QuenchReagent, QuenchReagentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  expandedQuenchReagentVolumeRules = Normal[Merge[Thread[(Flatten[expandedQuenchReagent]/.Null->Nothing) -> (Flatten[expandedQuenchReagentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  quenchReagentResourceReplaceRules = If[MatchQ[expandedQuenchReagentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@expandedQuenchReagentVolumeRules]
  ];
  quenchReagentResources = expandedQuenchReagent /. quenchReagentResourceReplaceRules;


  (* -- Generate resources for the PostConjugationWorkupBuffer -- *)
  (*Get the necessary options*)
  {expandedPostConjugationWorkupBuffer, expandedPostConjugationWorkupBufferVolume} = Lookup[optionsWithReplicates, {PostConjugationWorkupBuffer, PostConjugationWorkupBufferVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  expandedPostConjugationBufferVolumeRules = Normal[Merge[Thread[(Flatten[expandedPostConjugationWorkupBuffer]/.Null->Nothing) -> (Flatten[expandedPostConjugationWorkupBufferVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  postConjugationBufferResourceReplaceRules = If[MatchQ[expandedPostConjugationBufferVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@expandedPostConjugationBufferVolumeRules]
  ];
  postConjugationBufferResources = expandedPostConjugationWorkupBuffer /. postConjugationBufferResourceReplaceRules;


  (* -- Generate resources for the PostConjugationResuspensionDiluent -- *)
  (*Get the necessary options*)
  {expandedPostConjugationResuspensionDiluent, expandedPostConjugationResuspensionDiluentVolume} = Lookup[optionsWithReplicates, {PostConjugationResuspensionDiluent, PostConjugationResuspensionDiluentVolume}];

  (*Find the unique buffers and how much total volume is required for each*)
  expandedPostConjugationResuspensionDiluentVolumeRules = Normal[Merge[Thread[(Flatten[expandedPostConjugationResuspensionDiluent]/.Null->Nothing) -> (Flatten[expandedPostConjugationResuspensionDiluentVolume]/.Null->Nothing)], Total]];

  (*Make the resource replace rules*)
  postConjugationResuspensionDiluentResourceReplaceRules = If[MatchQ[expandedPostConjugationResuspensionDiluentVolumeRules,{}],
    {},
    KeyValueMap[#1 -> Link[Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2] , Name -> ToString[Unique[]]]]&, Association@expandedPostConjugationResuspensionDiluentVolumeRules]
  ];
  postConjugationResuspensionDiluentResources = expandedPostConjugationResuspensionDiluent /. postConjugationResuspensionDiluentResourceReplaceRules;


  (*---Format the resolved options and resources for the protocol packet---*)

  (*Create the conjugation product Identity models field value*)
  newIMLinks = Link/@Download[Flatten[myNewIdentityModels],Object];

  (*Giant lookup for resolved options for the protocol object*)
  {
    expectedYield,processingBatches,preWashMethods,
    preWashNumberOfWashes, preWashBufferVolumes, preWashMagneticSeparator,
    preWashResuspensionDiluentVolumes, activationReactionVolumes,
    activationSampleConcentrations, activationSampleVolumes, activationReagentVolumes,
    activationReagentConcentrations,activationDiluentVolumes, postActivationWashMethod,
    postActivationNumberOfWashes, postActivationWashBufferVolumes, postActivationMagneticSeparator,
    postActivationResuspensionDiluentVolumes, activationSamplesOutStorageCondition, conjugationReactionVolumes,
    conjugationSampleConcentrations, conjugationAmounts, conjugationReactionBufferVolumes,
    concConjugationReactionBufferDilutionFactor, conjugationDiluentVolumes, predrainMethod,
    predrainMagneticSeparator, predrainMagneticSeparationTime, quenchReactionVolumes,
    quenchReagentDilutionFactors, quenchReagentVolumes, postConjugationWorkupMethod,
    postConjugationBufferVolumes, postConjugationMagneticSeparator,
    postConjugationDiluentVolume, samplesOutStorageCondition,
    reactantCoefficients, productCoefficients

  } = Lookup[optionsWithReplicates,
    {
      ExpectedYield, ProcessingBatches, PreWashMethod,
      PreWashNumberOfWashes, PreWashBufferVolume, PreWashMagnetizationRack,
      PreWashResuspensionDiluentVolume, ActivationReactionVolume, TargetActivationSampleConcentration,
      ActivationSampleVolume, ActivationReagentVolume, TargetActivationReagentConcentration, ActivationDiluentVolume,
      PostActivationWashMethod, PostActivationNumberOfWashes,PostActivationWashBufferVolume, PostActivationWashMagnetizationRack,
      PostActivationResuspensionDiluentVolume, ActivationSamplesOutStorageCondition, ConjugationReactionVolume,
      TargetConjugationSampleConcentration, ConjugationAmount, ConjugationReactionBufferVolume,
      ConcentratedConjugationReactionBufferDilutionFactor, ConjugationDiluentVolume, PredrainMethod,
      PredrainMagnetizationRack, PredrainMagnetizationTime, QuenchReactionVolume, QuenchReagentDilutionFactor,
      QuenchReagentVolume, PostConjugationWorkupMethod, PostConjugationWorkupBufferVolume, PostConjugationMagnetizationRack,
      PostConjugationResuspensionDiluentVolume, SamplesOutStorageCondition, ReactantsStoichiometricCoefficients,
      ProductStoichiometricCoefficient
    }
  ];

  (*Convert the Concentrations depending on unit type (Mass Concentration vs Molar Concentration*)
  convertedActivationSampleConcentrations = Switch[
   {#, MassConcentrationQ[#]},
    {Except[Null],True}, Convert[#,Microgram/Milliliter],
    {Except[Null],False}, Convert[#,Micromolar],
    {_,_}, #
  ]&/@Flatten[activationSampleConcentrations];

  convertedActivationReagentConcentrations = Switch[
    {#, MassConcentrationQ[#]},
    {Except[Null],True}, Convert[#,Microgram/Milliliter],
    {Except[Null],False}, Convert[#,Micromolar],
    {_,_}, #
  ]&/@Flatten[activationReagentConcentrations];

  (*Create links for reaction chemistry objects*)
  reactionChemistry = If[MatchQ[#, ObjectP[]], Link[#], #]& /@ Lookup[optionsWithReplicates, ReactionChemistry];

  (*Create named fields for the subprotocol options*)

  (*PreWash Mix*)
  flatPreWashMixOptions = Flatten/@Lookup[optionsWithReplicates,{PreWashTime, PreWashTemperature, PreWashMix, PreWashMixType, PreWashMixRate, PreWashMixVolume, PreWashNumberOfMixes}];

  preWashMix =MapThread[ <|
    IncubationTime ->#1,
    IncubationTemperature->If[MatchQ[#2,Null|Ambient], #2, SafeRound[Convert[#2, Celsius],0.1Celsius]],
    Mix->#3,
    MixType->#4,
    MixRate->#5,
    MixVolume->If[MatchQ[#6,Null], #6, SafeRound[Convert[#6,Microliter], 0.1 Microliter]],
    NumberOfMixes->#7
  |>&,flatPreWashMixOptions];

  (*PreWash Filter*)
    flatPreWashFilterOptions = Flatten/@Lookup[optionsWithReplicates,{
      PreWashFiltrationType, PreWashInstrument, PreWashFilter, PreWashFilterStorageCondition, PreWashFilterMembraneMaterial,
      PreWashPrefilterMembraneMaterial, PreWashFilterPoreSize, PreWashFilterMolecularWeightCutoff, PreWashPrefilterPoreSize,
      PreWashFiltrationSyringe,PreWashSterileFiltration, PreWashFilterHousing, PreWashCentrifugationIntensity, PreWashCentrifugationTime,
      PreWashCentrifugationTemperature
    }];

    flatPreWashFilterBooleans = MatchQ[#,Filter]&/@Flatten[Lookup[optionsWithReplicates,PreWashMethod]];

    preWashFilter = MapThread[<|
      Filtration->#1,
      Type->#2,
      Instrument->If[MatchQ[#3,Null], #3,Link[#3]],
      Filter->If[MatchQ[#4,Null],#4,Link[#4]],
      FilterStorageCondition->#5,
      MembraneMaterial->#6,
      PrefilterMembraneMaterial->#7,
      PoreSize->#8,
      MolecularWeightCutoff->#9,
      PrefilterPoreSize->#10,
      Syringe->If[MatchQ[#11,Null],#11,Link[#11]],
      Sterile->#12,
      FilterHousing->#13,
      Intensity->#14,
      Time->If[MatchQ[#15,Null], #15, SafeRound[Convert[#15,Minute],1Second]],
      Temperature->If[MatchQ[#16,Null|Ambient], #16, SafeRound[Convert[#16,Celsius],0.1Celsius]]
    |>&, Join[{flatPreWashFilterBooleans},flatPreWashFilterOptions]];

  (*PreWash Pellet*)
  flatPreWashPelletOptions = Flatten/@Lookup[optionsWithReplicates,
    {PreWashInstrument,PreWashCentrifugationIntensity, PreWashCentrifugationTime, PreWashCentrifugationTemperature}
  ];

  flatPreWashPelletBooleans = MatchQ[#,Pellet]&/@Flatten[Lookup[optionsWithReplicates,PreWashMethod]];

  preWashPellet = MapThread[<|
    Pellet ->#1,
    Instrument->If[MatchQ[#2,Null],#2,Link[#2]],
    Intensity->#3,
    Time->If[MatchQ[#4,Null],#4, SafeRound[Convert[#4,Minute],1Second]],
    Temperature->If[MatchQ[#5,Null|Ambient], #5, SafeRound[Convert[#5,Celsius],0.1Celsius]]
  |>&,Join[{flatPreWashPelletBooleans},flatPreWashPelletOptions]];

  (*PreWash resuspension*)
  flatPreWashResuspensionOptions = Flatten/@Lookup[optionsWithReplicates,
    {PreWashResuspension,PreWashResuspensionTime,PreWashResuspensionTemperature,PreWashResuspensionMix,
      PreWashResuspensionMixType,PreWashResuspensionMixRate,PreWashResuspensionMixVolume,PreWashResuspensionNumberOfMixes}
  ];

  preWashResuspension = MapThread[<|
    Resuspend ->#1,
    IncubationTime->If[MatchQ[#2,Null], #2, SafeRound[Convert[#2,Minute], 1Second]],
    IncubationTemperature->If[MatchQ[#3,Null|Ambient], #3, SafeRound[Convert[#3,Celsius], 0.1Celsius]],
    Mix->#4,
    MixType->#5,
    MixRate->#6,
    MixVolume->If[MatchQ[#7,Null],#7, SafeRound[Convert[#7,Microliter], 0.1 Microliter]],
    NumberOfMixes->#8
  |>&, flatPreWashResuspensionOptions];

  (*Activation Incubation*)
  flatActivationOptions = Flatten/@Lookup[optionsWithReplicates,
    {ActivationTime,ActivationTemperature,ActivationMix,ActivationMixType,
      ActivationMixRate,ActivationMixVolume,ActivationNumberOfMixes}
  ];

  activation = MapThread[<|
    IncubationTime->If[MatchQ[#1,Null], #1, SafeRound[Convert[#1,Minute], 1Second]],
    IncubationTemperature->If[MatchQ[#2,Null|Ambient], #2, SafeRound[Convert[#2,Celsius], 0.1 Celsius]],
    Mix->#3,
    MixType->#4,
    MixRate->#5,
    MixVolume->If[MatchQ[#6,Null], #6, SafeRound[Convert[#6,Microliter], 0.1 Microliter]],
    NumberOfMixes->#7
  |>&,flatActivationOptions];

  (*PostActivationWash Mix*)
  flatPostActivationWashMixOptions = Flatten/@Lookup[optionsWithReplicates,{PostActivationWashTime, PostActivationWashTemperature, PostActivationWashMix, PostActivationWashMixType, PostActivationWashMixRate, PostActivationWashMixVolume, PostActivationWashNumberOfMixes}];

  postActivationWashMix = MapThread[<|
    IncubationTime ->#1,
    IncubationTemperature->If[MatchQ[#2,Null|Ambient], #2, SafeRound[Convert[#2, Celsius],0.1Celsius]],
    Mix->#3,
    MixType->#4,
    MixRate->#5,
    MixVolume->If[MatchQ[#6,Null], #6, SafeRound[Convert[#6,Microliter], 0.1 Microliter]],
    NumberOfMixes->#7
  |>&,flatPostActivationWashMixOptions];

  (*PostActivationWash Filter*)
  flatPostActivationWashFilterOptions = Flatten/@Lookup[optionsWithReplicates,{
    PostActivationWashFiltrationType, PostActivationWashInstrument, PostActivationWashFilter, PostActivationWashFilterStorageCondition, PostActivationWashFilterMembraneMaterial,
    PostActivationWashPrefilterMembraneMaterial, PostActivationWashFilterPoreSize, PostActivationWashFilterMolecularWeightCutoff, PostActivationWashPrefilterPoreSize,
    PostActivationWashFiltrationSyringe,PostActivationWashSterileFiltration, PostActivationWashFilterHousing, PostActivationWashCentrifugationIntensity, PostActivationWashCentrifugationTime,
    PostActivationWashCentrifugationTemperature
  }];

  flatPostActivationWashFilterBooleans = MatchQ[#,Filter]&/@Flatten[Lookup[optionsWithReplicates,PostActivationWashMethod]];

  postActivationWashFilter = MapThread[<|
    Filtration->#1,
    Type->#2,
    Instrument->If[MatchQ[#3,Null],#3,Link[#3]],
    Filter->If[MatchQ[#4,Null],#4,Link[#4]],
    FilterStorageCondition->#5,
    MembraneMaterial->#6,
    PrefilterMembraneMaterial->#7,
    PoreSize->#8,
    MolecularWeightCutoff->#9,
    PrefilterPoreSize->#10,
    Syringe->If[MatchQ[#11,Null],#11,Link[#11]],
    Sterile->#12,
    FilterHousing->#13,
    Intensity->#14,
    Time->If[MatchQ[#15,Null], #15, SafeRound[Convert[#15,Minute],1Second]],
    Temperature->If[MatchQ[#16,Null|Ambient], #16, SafeRound[Convert[#16,Celsius],0.1Celsius]]
  |>&,Join[{flatPostActivationWashFilterBooleans},flatPostActivationWashFilterOptions]];

  (*PostActivationWash Pellet*)
  flatPostActivationWashPelletOptions = Flatten/@Lookup[optionsWithReplicates,
    {PostActivationWashInstrument,PostActivationWashCentrifugationIntensity, PostActivationWashCentrifugationTime,
      PostActivationWashCentrifugationTemperature}
  ];

  flatPostActivationWashPelletBooleans = MatchQ[#,Pellet]&/@Flatten[Lookup[optionsWithReplicates,PostActivationWashMethod]];

  postActivationWashPellet = MapThread[<|
    Pellet ->#1,
    Instrument->If[MatchQ[#2,Null],#2,Link[#2]],
    Intensity->#3,
    Time->If[MatchQ[#4,Null],#4, SafeRound[Convert[#4,Minute],1Second]],
    Temperature->If[MatchQ[#5,Null|Ambient], #5, SafeRound[Convert[#5,Celsius],0.1Celsius]]
  |>&, Join[{flatPostActivationWashPelletBooleans},flatPostActivationWashPelletOptions]];

  (*PostActivationWash resuspension*)
  flatPostActivationWashResuspensionOptions = Flatten/@Lookup[optionsWithReplicates,
    {PostActivationResuspension,PostActivationResuspensionTime,PostActivationResuspensionTemperature,PostActivationResuspensionMix,
      PostActivationResuspensionMixType,PostActivationResuspensionMixRate,PostActivationResuspensionMixVolume,PostActivationResuspensionNumberOfMixes}
  ];

  postActivationWashResuspension = MapThread[<|
    Resuspend ->#1,
    IncubationTime->If[MatchQ[#2,Null], #2, SafeRound[Convert[#2,Minute], 1Second]],
    IncubationTemperature->If[MatchQ[#3,Null|Ambient], #3, SafeRound[Convert[#3,Celsius], 0.1Celsius]],
    Mix->#4,
    MixType->#5,
    MixRate->#6,
    MixVolume->If[MatchQ[#7,Null],#7, SafeRound[Convert[#7,Microliter], 0.1 Microliter]],
    NumberOfMixes->#8
  |>&, flatPostActivationWashResuspensionOptions];

  (*Conjugation*)
    convertedConjugationSampleConcentrations =  Switch[
      {#, MassConcentrationQ[#]},
      {Except[Null],True}, Convert[#,Microgram/Milliliter],
      {Except[Null],False}, Convert[#,Micromolar],
      {_,_}, #
    ]&/@Flatten[conjugationSampleConcentrations];

  convertedConjugationSampleAmounts = MapThread[Switch[
    {#1, MassQ[#2]},
    {All,True},  Convert[#2,Microgram],
    {All,False},  Convert[#2,Microliter],
    {Except[Null],True}, Convert[#1,Microgram],
    {Except[Null],False}, Convert[#1,Microliter],
    {_,_}, #1
  ]&, {Flatten[conjugationAmounts], Flatten[sampleObjectAmount]}];

  (*Conjugation Incubation*)
  flatConjugationOptions = Lookup[optionsWithReplicates,
    {ConjugationTime,ConjugationTemperature,ConjugationMix,ConjugationMixType,
      ConjugationMixRate,ConjugationMixVolume,ConjugationNumberOfMixes}
  ];

  conjugation = MapThread[<|
    IncubationTime->If[MatchQ[#1,Null], #1, SafeRound[Convert[#1,Minute], 1Second]],
    IncubationTemperature->If[MatchQ[#2,Null|Ambient], #2, SafeRound[Convert[#2,Celsius], 0.1 Celsius]],
    Mix->#3,
    MixType->#4,
    MixRate->#5,
    MixVolume->If[MatchQ[#6,Null], #6, SafeRound[Convert[#6,Microliter], 0.1 Microliter]],
    NumberOfMixes->#7
  |>&,flatConjugationOptions];

  (*Predrain Pellet*)
  flatPredrainPelletOptions = Lookup[optionsWithReplicates,
    {PredrainInstrument,PredrainCentrifugationIntensity, PredrainCentrifugationTime,
      PredrainTemperature}
  ];

  flatPredrainPelletBooleans = MatchQ[#,Pellet]&/@Lookup[optionsWithReplicates,PredrainMethod];

  predrainPellet =MapThread[ <|
    Pellet ->#1,
    Instrument->If[MatchQ[#2,Null],#2,Link[#2]],
    Intensity->#3,
    Time->If[MatchQ[#4,Null],#4, SafeRound[Convert[#4,Minute],1Second]],
    Temperature->If[MatchQ[#5,Null|Ambient], #5, SafeRound[Convert[#5,Celsius],0.1Celsius]],
    Target->Null
  |>&, Join[{flatPredrainPelletBooleans},flatPredrainPelletOptions]];

  convertedPredrainMagneticSeparationTime = If[MatchQ[#,Null], #, SafeRound[Convert[#,Minute],1Second]]&/@predrainMagneticSeparationTime;

  (*Quenching Incubation*)
  flatQuenchOptions = Lookup[optionsWithReplicates,
    {QuenchTime,QuenchTemperature,QuenchMix,QuenchMixType,
      QuenchMixRate,QuenchMixVolume,QuenchNumberOfMixes}
  ];

  quenching = MapThread[<|
    IncubationTime->If[MatchQ[#1,Null], #1, SafeRound[Convert[#1,Minute], 1Second]],
    IncubationTemperature->If[MatchQ[#2,Null|Ambient], #2, SafeRound[Convert[#2,Celsius], 0.1 Celsius]],
    Mix->#3,
    MixType->#4,
    MixRate->#5,
    MixVolume->If[MatchQ[#6,Null], #6, SafeRound[Convert[#6,Microliter], 0.1 Microliter]],
    NumberOfMixes->#7
  |>&,flatQuenchOptions];

  (*PostConjugation Mix*)
  flatPostConjugationMixOptions = Lookup[optionsWithReplicates,{PostConjugationWorkupIncubationTime, PostConjugationWorkupIncubationTemperature, PostConjugationWorkupMix, PostConjugationWorkupMixType, PostConjugationWorkupMixRate, PostConjugationWorkupMixVolume, PostConjugationWorkupNumberOfMixes}];

  postConjugationMix = MapThread[<|
    IncubationTime ->#1,
    IncubationTemperature->If[MatchQ[#2,Null|Ambient], #2, SafeRound[Convert[#2, Celsius],0.1Celsius]],
    Mix->#3,
    MixType->#4,
    MixRate->#5,
    MixVolume->If[MatchQ[#6,Null], #6, SafeRound[Convert[#6,Microliter], 0.1 Microliter]],
    NumberOfMixes->#7
  |>&,flatPostConjugationMixOptions];

  (*PostConjugation Filter*)
  flatPostConjugationFilterOptions = Lookup[optionsWithReplicates,{
    PostConjugationFiltrationType, PostConjugationWorkupInstrument, PostConjugationFilter, PostConjugationFilterStorageCondition, PostConjugationFilterMembraneMaterial,
    PostConjugationPrefilterMembraneMaterial, PostConjugationFilterPoreSize, PostConjugationFilterMolecularWeightCutoff, PostConjugationPrefilterPoreSize,
    PostConjugationFiltrationSyringe,PostConjugationSterileFiltration, PostConjugationFilterHousing, PostConjugationCentrifugationIntensity, PostConjugationCentrifugationTime,
    PostConjugationCentrifugationTemperature
  }];

  flatPostConjugationFilterBooleans = MatchQ[#,Filter]&/@Lookup[optionsWithReplicates,PostConjugationWorkupMethod];

  postConjugationFilter = MapThread[<|
    Filtration->#1,
    Type->#2,
    Instrument->If[MatchQ[#3,Null],#3,Link[#3]],
    Filter->If[MatchQ[#4,Null],#4,Link[#4]],
    FilterStorageCondition->#5,
    MembraneMaterial->#6,
    PrefilterMembraneMaterial->#7,
    PoreSize->#8,
    MolecularWeightCutoff->#9,
    PrefilterPoreSize->#10,
    Syringe->If[MatchQ[#11,Null],#11,Link[#11]],
    Sterile->#12,
    FilterHousing->#13,
    Intensity->#14,
    Time->If[MatchQ[#15,Null], #15, SafeRound[Convert[#15,Minute],1Second]],
    Temperature->If[MatchQ[#16,Null|Ambient], #16, SafeRound[Convert[#16,Celsius],0.1Celsius]],
    Target->Null
  |>&, Join[{flatPostConjugationFilterBooleans},flatPostConjugationFilterOptions]];

  (*PostConjugation Pellet*)
  flatPostConjugationPelletOptions = Lookup[optionsWithReplicates,
    {PostConjugationWorkupInstrument,PostConjugationCentrifugationIntensity, PostConjugationCentrifugationTime,
      PostConjugationCentrifugationTemperature}
  ];

  flatPostConjugationPelletBooleans = MatchQ[#,Pellet]&/@Lookup[optionsWithReplicates,PostConjugationWorkupMethod];

  postConjugationPellet = MapThread[<|
    Pellet ->#1,
    Instrument->If[MatchQ[#2,Null],#2,Link[#2]],
    Intensity->#3,
    Time->If[MatchQ[#4,Null],#4, SafeRound[Convert[#4,Minute],1Second]],
    Temperature->If[MatchQ[#5,Null|Ambient], #5, SafeRound[Convert[#5,Celsius],0.1Celsius]],
    Target->Null
  |>&, Join[{flatPostConjugationPelletBooleans},flatPostConjugationPelletOptions]];

  convertedPostConjugationMagneticSeparationTime = If[MatchQ[#,Null], #, SafeRound[Convert[#,Minute],1Second]]&/@Lookup[optionsWithReplicates,PostConjugationWorkupIncubationTime];

  (*Postconjugation resuspension*)
  flatPostConjugationResuspensionOptions = Lookup[optionsWithReplicates,
    {PostConjugationResuspension,PostConjugationResuspensionTime, PostConjugationResuspensionMaxTime, PostConjugationResuspensionTemperature,PostConjugationResuspensionMix,
      PostConjugationResuspensionMixType,PostConjugationResuspensionMixRate,PostConjugationResuspensionMixVolume,PostConjugationResuspensionNumberOfMixes,
      PostConjugationResuspensionMixUntilDissolved, PostConjugationResuspensionMaxNumberOfMixes
    }
  ];

  postConjugationResuspension = MapThread[<|
    Resuspend ->#1,
    IncubationTime->If[MatchQ[#2,Null], #2, SafeRound[Convert[#2,Minute], 1Second]],
    MaxTime->If[MatchQ[#3,Null], #3, SafeRound[Convert[#3,Minute], 1Second]],
    IncubationTemperature->If[MatchQ[#4,Null|Ambient], #4, SafeRound[Convert[#4,Celsius], 0.1Celsius]],
    Mix->#5,
    MixType->#6,
    MixRate->#7,
    MixVolume->If[MatchQ[#8,Null],#8, SafeRound[Convert[#8,Microliter], 0.1 Microliter]],
    NumberOfMixes->#9,
    MixUntilDissolved->#10,
    MaxNumberOfMixes->#11
  |>&, flatPostConjugationResuspensionOptions];


  (*helper function to convert and round volume fields*)
    convertVolume[optionList_List]:= If[MatchQ[#,Null], #, SafeRound[Convert[#,Microliter],0.1Microliter]]&/@optionList;

  (*Build Check points and timing*)

  (*The timing will depend on the processing order.*)
  (*If the processing order is parallel - find the max time of all samples*)
  (*If the processing order is batch - gather the times into the batches and find the max time*)
  (*If the processing order is serial - add the times together*)

  {processingOrder, processingBatchSize} = Lookup[myResolvedOptions,{ProcessingOrder, ProcessingBatchSize}];

  calculateRunTime[sampleTimes_, processingOrder_, processingBatchSize_] := Switch[processingOrder,
    Parallel, Max[sampleTimes/.Null->Nothing]/.-Infinity->0Minute,
    Batch, Total[(Max[#/.Null->Nothing]&/@PartitionRemainder[sampleTimes,processingBatchSize])/.-Infinity->0Minute],
    Serial, Replace[Total[sampleTimes/.Null->Nothing], {0->0Minute}]
  ];

  (*Look up all the timing options*)
  {
    preWashTime, preWashNumber, preWashCentrifugationTime, preWashResuspensionTime,
    activationTime,
    postActivationWashNumber, postActivationWashTime,
    postActivationCentrifugationTime, postActivationResuspensionTime,
    conjugationTime,
    predrainCentrifugationTime, predrainMagnetizationTime, quenchTime,
    postConjugationTime, postConjugationCentrifugationTime, postConjugationResuspensionTime

  } =  Flatten/@Lookup[optionsWithReplicates,
    {
      PreWashTime, PreWashNumberOfWashes, PreWashCentrifugationTime, PreWashResuspensionTime,
      ActivationTime,
      PostActivationNumberOfWashes, PostActivationWashTime,
      PostActivationWashCentrifugationTime, PostActivationResuspensionTime,
      ConjugationTime,
      PredrainCentrifugationTime, PredrainMagnetizationTime, QuenchTime,
      PostConjugationWorkupIncubationTime, PostConjugationCentrifugationTime, PostConjugationResuspensionTime
    }
  ];

  (*Calculate the total time, make sure the account for repeated washes.*)
  preWashTotalTime = Total[
    Flatten[MapThread[ #2* calculateRunTime[#1,processingOrder,processingBatchSize]&,
      {
        {preWashTime, preWashCentrifugationTime, preWashResuspensionTime},
        {preWashNumber,preWashNumber,1}
      }
    ]]/.Null->Nothing
  ];

  activationTotalTime = Total[(calculateRunTime[#,processingOrder,processingBatchSize]&/@{activationTime})/.Null->Nothing];

  postActivationWashTotalTime = Total[
    Flatten[MapThread[ #2* calculateRunTime[#1,processingOrder,processingBatchSize]&,
      {
        {postActivationWashTime, postActivationCentrifugationTime, postActivationResuspensionTime},
        {postActivationWashNumber,postActivationWashNumber,1}
      }
    ]]/.Null->Nothing
  ];


  activationCheckpoint = {"Activation", preWashTotalTime + activationTotalTime + postActivationWashTotalTime, "Pre-conjugation sample preparation such as prewashing, activation, and post-activation washing are performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> preWashTotalTime + activationTotalTime + postActivationWashTotalTime]]};

  conjugationTotalTime = Total[Flatten@{calculateRunTime[conjugationTime,processingOrder,processingBatchSize]}/.Null->Nothing];

  quenchingTotalTime = Total[(calculateRunTime[#,processingOrder,processingBatchSize]&/@{predrainCentrifugationTime, predrainMagnetizationTime, quenchTime})/.Null->Nothing];

  quenchingCheckpoint = {"Quenching", quenchingTotalTime, "Post-conjugation reaction termination by sample reaction mixture draining and quenching are performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> quenchingTotalTime]]};

  postConjugationTotalTime = Total[(calculateRunTime[#,processingOrder,processingBatchSize]&/@{postConjugationTime, postConjugationCentrifugationTime, postConjugationResuspensionTime})/.Null->Nothing];

  postConjugationCheckpoint =  {"Post-Conjugation Workup", postConjugationTotalTime, "Post-conjugation sample processing including incubation, filtering, pelleting, and magnetic separation are performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> postConjugationTotalTime]]};

  (* --- Generate the protocol packet --- *)
  protocolPacket = <|
    Object -> CreateID[Object[Protocol, Bioconjugation]],
    Type -> Object[Protocol, Bioconjugation],
    UnresolvedOptions -> myUnresolvedOptions,
    ResolvedOptions -> myResolvedOptions,
    Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
    Replace[ContainersIn]->(Link[#,Protocols]&)/@containersInResource,

    (*General fields*)
    Replace[ReactionType] -> reactionChemistry,
    Replace[ReactantsStoichiometricCoefficients]->reactantCoefficients,
    Replace[ProductStoichiometricCoefficient]->productCoefficients,
    Replace[ProductIdentityModels] -> newIMLinks,
    Replace[ExpectedYield] -> expectedYield,
    ProcessingOrder -> processingOrder,
    Replace[ProcessingBatches] -> Flatten[processingBatches/.Null->{Null},1],

    (*PreWash Fields*)
    Replace[PreWashMethods]->Flatten@preWashMethods,
    Replace[PreWashNumberOfWashes]->Flatten@preWashNumberOfWashes,
    Replace[PreWashBuffers] -> Flatten[preWashBufferResources],
    Replace[PreWashBufferVolumes] -> convertVolume[Flatten@preWashBufferVolumes],
    Replace[PreWashMix]->preWashMix,
    Replace[PreWashFilter]->preWashFilter,
    Replace[PreWashPellet] -> preWashPellet,
    Replace[PreWashMagneticSeparator]->Function[{resource},If[MatchQ[resource,Null],Null,Link[resource]]]/@Flatten[preWashMagneticSeparator],
    Replace[PreWashResuspensionDiluents]->Flatten[preWashResuspensionDiluentResources],
    Replace[PreWashResuspensionDiluentVolumes]->convertVolume[Flatten[preWashResuspensionDiluentVolumes]],
    Replace[PreWashResuspensionParameters]->preWashResuspension,

    (*Activation Fields*)
    Replace[ActivationReactionVolumes]->convertVolume[Flatten[activationReactionVolumes]],
    Replace[ActivationSampleConcentrations] -> convertedActivationSampleConcentrations,
    Replace[ActivationSampleVolumes] -> convertVolume[Flatten[activationSampleVolumes]],
    Replace[ActivationReagents]->Flatten[activationReagentResources],
    Replace[ActivationReagentVolumes]->convertVolume[Flatten[activationReagentVolumes]],
    Replace[ActivationReagentConcentrations]->convertedActivationReagentConcentrations,
    Replace[ActivationParameters]->activation,
    Replace[ActivationDiluents]->Flatten[activationDiluentResources],
    Replace[ActivationDiluentVolumes]->convertVolume[Flatten[activationDiluentVolumes]],
    Replace[ActivationContainers]->Flatten[activationContainerFlatResources],
    Replace[ActivationSamplesOutStorageCondition] -> Flatten[activationSamplesOutStorageCondition],

    (*Post Activation Wash Fields*)
    Replace[PostActivationWashMethod]->Flatten[postActivationWashMethod],
    Replace[PostActivationNumberOfWashes]->Flatten[postActivationNumberOfWashes],
    Replace[PostActivationWashBuffers]->Flatten[postActivationWashBufferResources],
    Replace[PostActivationWashBufferVolumes]->convertVolume[Flatten[postActivationWashBufferVolumes]],
    Replace[PostActivationWashMix]->postActivationWashMix,
    Replace[PostActivationWashFilter]->postActivationWashFilter,
    Replace[PostActivationWashPellet]->postActivationWashPellet,
    Replace[PostActivationWashMagneticSeparator]->Function[{resource},If[MatchQ[resource,Null],Null,Link[resource]]]/@Flatten[postActivationMagneticSeparator],
    Replace[PostActivationWashResuspensionDiluents]->Flatten[postActivationResuspensionDiluentResources],
    Replace[PostActivationWashResuspensionDiluentVolumes]->convertVolume[Flatten[postActivationResuspensionDiluentVolumes]],
    Replace[PostActivationWashResuspensionParameters]->postActivationWashResuspension,

    (*Conjugation Fields*)
    Replace[ConjugationReactionVolumes]->convertVolume[Flatten[conjugationReactionVolumes]],
    Replace[ConjugationSampleConcentrations]->convertedConjugationSampleConcentrations,
    Replace[ConjugationSampleAmounts]->convertedConjugationSampleAmounts,
    Replace[ConjugationReactionBuffers]->conjugationReactionBufferResources,
    Replace[ConjugationReactionBufferVolumes]->convertVolume[Flatten@conjugationReactionBufferVolumes],
    Replace[ConcentratedConjugationReactionBuffers]->Flatten@concConjugationReactionBufferResources,
    Replace[ConcentratedConjugationReactionBufferDilutionFactors]->Flatten@concConjugationReactionBufferDilutionFactor,
    Replace[ConjugationReactionBufferDiluents]->Flatten@conjugationDiluentResources,
    Replace[ConjugationDiluentVolumes]->convertVolume[Flatten@conjugationDiluentVolumes],
    Replace[ReactionVessels]->reactionVesselResources,
    Replace[ConjugationParameters]->conjugation,

    (*Quenching Fields*)
    Replace[PredrainReactionMixtureMethod]->predrainMethod,
    Replace[PredrainPellet]->predrainPellet,
    Replace[PredrainMagneticSeparator]->Function[{resource},If[MatchQ[resource,Null],Null,Link[resource]]]/@Flatten[predrainMagneticSeparator],
    Replace[PredrainMagneticSeparationTime]->convertedPredrainMagneticSeparationTime,
    Replace[QuenchReactionVolumes]->convertVolume[quenchReactionVolumes],
    Replace[QuenchReagents]->quenchReagentResources,
    Replace[QuenchReagentDilutionFactors]->Replace[quenchReagentDilutionFactors,0->Null,All],
    Replace[QuenchReagentVolumes] -> convertVolume[quenchReagentVolumes],
    Replace[QuenchParameters]-> quenching,

    (*Post Conjugation Fields*)
    Replace[PostConjugationWorkupMethod]->postConjugationWorkupMethod,
    Replace[PostConjugationWorkupBuffers]->postConjugationBufferResources,
    Replace[PostConjugationWorkupBufferVolumes]->convertVolume[postConjugationBufferVolumes],
    Replace[PostConjugationMix]->postConjugationMix,
    Replace[PostConjugationFilter]->postConjugationFilter,
    Replace[PostConjugationPellet]->postConjugationPellet,
    Replace[PostConjugationMagneticSeparator]->Function[{resource},If[MatchQ[resource,Null],Null,Link[resource]]]/@Flatten[postConjugationMagneticSeparator],
    Replace[PostConjugationMagneticSeparationTime]->convertedPostConjugationMagneticSeparationTime,
    Replace[PostConjugationResuspensionDiluent]->postConjugationResuspensionDiluentResources,
    Replace[PostConjugationResuspensionDiluentVolume]->convertVolume[postConjugationDiluentVolume],
    Replace[PostConjugationResuspensionParameters]->postConjugationResuspension,

    (*Storage Fields*)
    Replace[SamplesOutStorage] -> samplesOutStorageCondition,

    (*Additional tracking fields*)
    Replace[Checkpoints] -> {
      {"Preparing Samples", 15 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 15 Minute]]},
      {"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
      activationCheckpoint,
      {"Conjugation", conjugationTotalTime, "Samples are chemically linked through incubation.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> conjugationTotalTime]]},
      quenchingCheckpoint,
      postConjugationCheckpoint,
      {"Sample Post-Processing", 10 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
      {"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 * Minute]]}
    }/.{}->Nothing
|>;


(* generate a packet with the shared fields *)
  flatResolvedOptionValues = If[ListQ[#],Flatten[#,1],#]&/@Values[myResolvedOptions];
  flatResolvedOptions = Thread[Keys[myResolvedOptions]->flatResolvedOptionValues];
  sharedFieldPacket = populateSamplePrepFields[Flatten@myPooledSamples, flatResolvedOptions, Cache -> inheritedCache,Simulation->simulation];

(* Merge the shared fields with the specific fields *)
finalizedPacket = Join[sharedFieldPacket, protocolPacket];

(* get all the resource symbolic representations *)
(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

(* call fulfillableResourceQ on all the resources we created *)
{fulfillable, frqTests} = Which[
  MatchQ[$ECLApplication, Engine], {True, {}},
  gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> inheritedCache,Simulation->simulation],
  True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache -> inheritedCache,Simulation->simulation], Null}
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
  frqTests,
  Null
];

(* generate the Result output rule *)
(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
  finalizedPacket,
  $Failed
];

(* return the output as we desire it *)
outputSpecification /. {previewRule,optionsRule,resultRule,testsRule}
];
