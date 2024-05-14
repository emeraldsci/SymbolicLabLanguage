(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Bioconjugation], {
  Description -> "A protocol to covalently couple molecules together.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (*********************************************** GENERAL FIELDS *************************************************)
    ReactionType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> NHSester|Carbodiimide|Maleimide|ObjectP[{Model[ReactionMechanism]}],
      Relation->None|Model[ReactionMechanism],
      Description -> "For each member of PooledSamplesIn, the reactive group that forms the covalent bond between conjugation samples.",
      Category -> "General",
      IndexMatching -> PooledSamplesIn
    },
    ReactantsStoichiometricCoefficients->{
      Format->Multiple,
      Class->Expression,
      Pattern:> {GreaterP[0]..},
      Description->"For each member of PooledSamplesIn, the stoichiometric coefficient of the analyte in the balanced conjugation reaction.",
      Category->"General",
      IndexMatching->PooledSamplesIn
    },
    ProductStoichiometricCoefficient->{
      Format->Multiple,
      Class->Real,
      Pattern:> GreaterP[0],
      Description->"For each member of PooledSamplesIn, the stoichiometric coefficient of the product in the balanced conjugation reaction.",
      Category->"General",
      IndexMatching->PooledSamplesIn
    },
    ProductIdentityModels->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->IdentityModelTypes/.List->Alternatives,
      Description->"For each member of PooledSamplesIn, the identity models of the product resulting from conjugation of the reactants.",
      Category->"General",
      IndexMatching->PooledSamplesIn
    },
    ExpectedYield -> {
      Format->Multiple,
      Class->Real,
      Pattern:> RangeP[0,100],
      Units-> Percent,
      Description->"For each member of PooledSamplesIn, the percentage of input molecules anticipated to be converted into conjugated product upon completion of the experiment.",
      Category->"General",
      IndexMatching -> PooledSamplesIn
    },
    ProcessingOrder -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[Parallel, Grouped, Serial],
      Description -> "The order for processing the conjugation reactions, where Parallel indicates all samples are processed together from activation to quenching. Batch indicates certain groups of samples are processed together such that all reactions from activation to quenching are completed for a given group before processing the next group of samples defined in ProcessingBatches. Serial indicates samples are processed sequentially such at all reactions from activation to quenching are completed for a given sample before proceeding to the next sample.",
      Category -> "General"
    },
    ProcessingBatches -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{ObjectP[{Model[Sample], Object[Sample]}]..}..},
      Description -> "The groups of sample pools to process together in the experiment when ProcessingOrder is Batch.",
      Category -> "General"
    },

    (*********************************************** PREWASH FIELDS *************************************************)

    PreWashMethods -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Magnetic | Pellet | Filter,
      Description -> "For each member of SamplesIn, the method used to wash the solid phase samples prior to activation or conjugation.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashNumberOfWashes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Description -> "For each member of SamplesIn, the number of times the sample is repeatedly mixed with wash buffer and wash buffer is removed.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashBuffers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of SamplesIn, the reagent used to wash the sample prior to activation or conjugation.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashBufferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of the PreWashBuffer used to wash the sample prior to activation or conjugation.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashMix -> {
      Format -> Multiple,
      Class -> {
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Boolean,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        IncubationTime -> GreaterP[0],
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType -> MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of SamplesIn, parameters describing the incubation method of the PreWash.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashFilter->{
      Format->Multiple,
      Class->{
        Filtration -> Boolean,
        Type->Expression,
        Instrument->Link,
        Filter->Link,
        FilterStorageCondition->Expression,
        MembraneMaterial->Expression,
        PrefilterMembraneMaterial->Expression,
        PoreSize->Expression,
        MolecularWeightCutoff->Expression,
        PrefilterPoreSize->Expression,
        Syringe->Link,
        Sterile->Expression,
        FilterHousing->Link,
        Intensity->Real,
        Time->Real,
        Temperature->Expression
      },
      Pattern:>{
        Filtration->BooleanP,
        Type->FiltrationTypeP,
        Instrument->_Link,
        Filter->_Link,
        FilterStorageCondition->SampleStorageTypeP|Disposal,
        MembraneMaterial->FilterMembraneMaterialP,
        PrefilterMembraneMaterial->FilterMembraneMaterialP,
        PoreSize->GreaterP[0],
        MolecularWeightCutoff->FilterMolecularWeightCutoffP,
        PrefilterPoreSize->GreaterP[0],
        Syringe->_Link,
        Sterile->BooleanP,
        FilterHousing->_Link,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient
      },
      Relation->{
        Filtration->Null,
        Type->Null,
        Instrument->Model[Instrument]|Object[Instrument],
        Filter->Alternatives[
          Object[Container],
          Model[Container],
          Object[Sample],
          Model[Sample],
          Object[Item],
          Model[Item]
        ],
        FilterStorageCondition->Null,
        MembraneMaterial->Null,
        PrefilterMembraneMaterial->Null,
        PoreSize->Null,
        MolecularWeightCutoff->Null,
        PrefilterPoreSize->Null,
        Syringe->Model[Container,Syringe]|Object[Container,Syringe],
        Sterile->Null,
        FilterHousing-> Model[Instrument, FilterHousing]|Object[Instrument, FilterHousing],
        Intensity->Null,
        Time->Null,
        Temperature->Null
      },
      Units->{
        Filtration->None,
        Type->None,
        Instrument->None,
        Filter->None,
        FilterStorageCondition->None,
        MembraneMaterial->None,
        PrefilterMembraneMaterial->None,
        PoreSize->Micrometer,
        MolecularWeightCutoff->None,
        PrefilterPoreSize->Micrometer,
        Syringe->None,
        Sterile->None,
        FilterHousing->None,
        Intensity->GravitationalAcceleration,
        Time->Minute,
        Temperature->Celsius|None
      },
      Description -> "For each member of SamplesIn, parameters describing the filtration method of the PreWash.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashPellet->{
      Format->Multiple,
      Class->{
        Pellet->Boolean,
        Instrument->Link,
        Intensity->Real,
        Time->Real,
        Temperature->Expression
      },
      Pattern:>{
        Pellet->BooleanP,
        Instrument->_Link,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient
      },
      Relation->{
        Pellet->Null,
        Instrument->Model[Instrument]|Object[Instrument],
        Intensity->Null,
        Time->Null,
        Temperature->Null
      },
      Units->{
        Pellet->None,
        Instrument->None,
        Intensity->GravitationalAcceleration,
        Time->Minute,
        Temperature->Celsius|None
      },
      Description -> "For each member of SamplesIn, parameters describing the pelleting method of the PreWash.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashMagneticSeparator->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container, Rack]|Object[Container,Rack],
      Description->"For each member of SamplesIn, the magnetic device used to separate the sample during PreWash.",
      Category->"PreWash",
      IndexMatching->SamplesIn
    },
    PreWashResuspensionDiluents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of SamplesIn, the reagent used to resuspend the sample after the PreWash complete.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashResuspensionDiluentVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of the PreWashResuspensionDiluent used to resuspend the sample after the PreWash is complete.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashResuspensionParameters -> {
      Format -> Multiple,
      Class -> {
        Resuspend->Boolean,
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        Resuspend->BooleanP,
        IncubationTime -> Real,
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType -> MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        Resuspend->None,
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of SamplesIn, parameters describing the incubation method of the PreWashResuspension.",
      Category -> "PreWash",
      IndexMatching -> SamplesIn
    },
    PreWashPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {SampleManipulationP..},
      Description -> "A set of instructions specifying sample washing and resuspension prior to activation or conjugation.",
      Category -> "PreWash"
    },
    PreWashSampleManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, SampleManipulation],
      Description -> "The sample manipulation protocols used to wash and resuspend the samples prior to activation or conjugation.",
      Category -> "PreWash"
    },
    (*********************************************** ACTIVATION FIELDS *************************************************)

    ActivationReactionVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the total volume of the activation reaction including ActivationSampleVolume, ActivationReagentVolume, and ActivationDiluentVolume.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationSampleConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> GreaterP[0Micromolar]|GreaterP[0Microgram/Milliliter],
      Description -> "For each member of SamplesIn, the concentration of the sample in the activation reaction.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationSampleVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of each conjugation sample that is used in the activation reaction.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationReagents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "For each member of SamplesIn, the reagent that activates functional groups on the sample prior to reaction with the conjugate sample.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationReagentVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of the ActivationReagent sample added to the Activation reaction.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationReagentConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> GreaterP[0Micromolar]|GreaterP[0Microgram/Milliliter],
      Description -> "For each member of SamplesIn, the concentration of ActivationReagent in the activation reaction.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationParameters -> {
      Format -> Multiple,
      Class -> {
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        IncubationTime -> GreaterP[0],
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType ->MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of SamplesIn, parameters describing the incubation method of the Activation reaction.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationDiluents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of SamplesIn, the reagent used to dilute the ActivationVolume + ActivationReagentVolume to the final ActivationReactionVolume.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationDiluentVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of the ActivationDiluent that is used in the activation reaction.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationContainers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container] | Object[Container],
      Description -> "For each member of SamplesIn, the container in which each sample is activated by mixing and incubation with ActivationReagent and ActivationDiluent.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationReactionPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {SampleManipulationP..},
      Description -> "A set of instructions specifying the transfer of reagents into the Activation reaction and subsequent incubation. Includes any washing steps before or after activation.",
      Category -> "Activation"
    },
    ActivationSampleManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, SampleManipulation],
      Description -> "The sample manipulation protocol used to assemble and incubate the activation reaction.",
      Category -> "Activation"
    },
    PostActivationWashMethod -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Magnetic | Pellet | Filter,
      Description -> "For each member of SamplesIn, the method used to wash the samples following activation and prior to conjugation.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationNumberOfWashes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Description -> "For each member of SamplesIn, the number of times the sample is repeatedly mixed with wash buffer and wash buffer is removed.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashBuffers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of SamplesIn, the reagent used to wash the sample following activation and prior to conjugation.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashBufferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of the PostActivationWashBuffer used to wash the sample following activation and prior to conjugation.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashMix -> {
      Format -> Multiple,
      Class -> {
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        IncubationTime -> GreaterP[0],
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType ->MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of SamplesIn, parameters describing the mixing and incubation method of the PostActivationWash.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },

    PostActivationWashFilter->{
      Format->Multiple,
      Class->{
        Filtration->Boolean,
        Type->Expression,
        Filter->Link,
        FilterHousing->Link,
        Instrument->Link,
        FilterStorageCondition->Expression,
        MembraneMaterial->Expression,
        PrefilterMembraneMaterial->Expression,
        PoreSize->Expression,
        PrefilterPoreSize->Expression,
        MolecularWeightCutoff->Expression,
        Syringe->Link,
        Sterile->Expression,
        Intensity->Real,
        Time->Real,
        Temperature->Expression
      },
      Pattern:>{
        Filtration->BooleanP,
        Type->FiltrationTypeP,
        Filter->_Link,
        FilterHousing->_Link,
        Instrument->_Link,
        FilterStorageCondition->SampleStorageTypeP|Disposal,
        MembraneMaterial->FilterMembraneMaterialP,
        PrefilterMembraneMaterial->FilterMembraneMaterialP,
        PoreSize->GreaterP[0],
        PrefilterPoreSize->GreaterP[0],
        MolecularWeightCutoff->FilterMolecularWeightCutoffP,
        Syringe->_Link,
        Sterile->BooleanP,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient
      },
      Relation->{
        Filtration->Null,
        Type->Null,
        Filter->Alternatives[Model[Container, Plate, Filter], Object[Container, Plate, Filter],
          Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
          Model[Item, Filter], Object[Item, Filter]],
        FilterHousing->Alternatives[Object[Instrument,FilterHousing],Model[Instrument,FilterHousing]],
        Instrument->Model[Instrument]|Object[Instrument],
        FilterStorageCondition->Null,
        MembraneMaterial->Null,
        PrefilterMembraneMaterial->Null,
        PoreSize->Null,
        PrefilterPoreSize->Null,
        MolecularWeightCutoff->Null,
        Syringe->Model[Container,Syringe]|Object[Container,Syringe],
        Sterile->Null,
        Intensity->Null,
        Time->Null,
        Temperature->Null
      },
      Units->{
        Filtration->None,
        Type->None,
        Filter->None,
        FilterHousing->None,
        Instrument->None,
        FilterStorageCondition->None,
        MembraneMaterial->None,
        PrefilterMembraneMaterial->None,
        PoreSize->Micrometer,
        PrefilterPoreSize->Micrometer,
        MolecularWeightCutoff->None,
        Syringe->None,
        Sterile->None,
        Intensity->GravitationalAcceleration,
        Time->Minute,
        Temperature->Celsius|None
      },
      Description -> "For each member of SamplesIn, parameters describing the filtration method of the PostActivationWash.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashPellet->{
      Format->Multiple,
      Class->{
        Pellet->Boolean,
        Instrument->Link,
        Intensity->Real,
        Time->Real,
        Temperature->Expression
      },
      Pattern:>{
        Pellet->BooleanP,
        Instrument->_Link,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient
      },
      Relation->{
        Pellet->Null,
        Instrument->Model[Instrument]|Object[Instrument],
        Intensity->Null,
        Time->Null,
        Temperature->Null
      },
      Units->{
        Pellet->None,
        Instrument->None,
        Intensity->GravitationalAcceleration,
        Time->Minute,
        Temperature->Celsius|None
      },
      Description -> "For each member of SamplesIn, parameters describing the pelleting method of the PostActivationWash.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashMagneticSeparator->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container,Rack]|Object[Container,Rack],
      Description->"For each member of SamplesIn, the magnetic device used to separate the sample during PostActivationWash.",
      Category->"Activation",
      IndexMatching->SamplesIn
    },
    PostActivationWashResuspensionDiluents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of SamplesIn, the reagent used to resuspend the sample after the PostActivationWash complete.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashResuspensionDiluentVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume of the PostActivationWashResuspensionDiluent used to resuspend the sample after the PostActivationWash is complete.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    PostActivationWashResuspensionParameters -> {
      Format -> Multiple,
      Class -> {
        Resuspend->Boolean,
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        Resuspend->BooleanP,
        IncubationTime -> Real,
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType ->MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        Resuspend->None,
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of SamplesIn, parameters describing the incubation method of the PostActivationWashResuspension.",
      Category -> "Activation",
      IndexMatching -> SamplesIn
    },
    ActivationSamplesOut -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The samples leftover from the activation reaction after the conjugation reaction assembly.",
      Category -> "Activation"
    },
    ActivationSamplesOutStorageCondition -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SampleStorageTypeP | Disposal,
      Description -> "The conditions under which any leftover samples from the activation reaction are stored after the conjugation reaction assembly.",
      Category -> "Activation"
    },


    (*********************************************** CONJUGATION FIELDS *************************************************)
    ConjugationReactionVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of PooledSamplesIn, the total volume of the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    ConjugationSampleConcentrations -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Micromolar,
      Description -> "For each member of SamplesIn, the concentration of each sample in the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> SamplesIn
    },
    ConjugationSampleAmounts -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> GreaterP[0Microliter]|GreaterP[0Microgram],
      Description -> "For each member of SamplesIn, the amount of each sample that is used in the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> SamplesIn
    },
    ConjugationReactionBuffers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "For each member of PooledSamplesIn, the reagent used to dilute or resuspend the sample during the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    ConjugationReactionBufferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of PooledSamplesIn, the volume of the ConjugationBuffer sample added to the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    ConcentratedConjugationReactionBuffers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of PooledSamplesIn, the concentrated reagent used to dilute or resuspend the sample during the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    ConcentratedConjugationReactionBufferDilutionFactors -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of PooledSamplesIn, the relative amount that the ConcentratedConjugateBuffer should be diluted prior to use in the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    ConjugationReactionBufferDiluents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of PooledSamplesIn, the diluent used to decrease the ConcentratedConjugationBuffer concentration by ConjugationBufferDilutionFactor prior to use in the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
		},
		ConjugationDiluentVolumes->{
      Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->Microliter,
			Description -> "For each member of PooledSamplesIn, the volume of the ConjugationBufferDiluent that is mixed with ConcentratedConjugateBuffer prior to use in the conjugation reaction.",
      Category -> "Conjugation",
			IndexMatching->PooledSamplesIn
    },
		ReactionVessels-> {
      Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container]|Object[Container],
      Description -> "For each member of PooledSamplesIn, the container in which samples are mixed with ConjugationReactionBuffer and incubated to covalently link the samples.",
      Category -> "Conjugation",
			IndexMatching->PooledSamplesIn
    },
    ConjugationParameters -> {
      Format -> Multiple,
      Class -> {
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        IncubationTime -> GreaterP[0],
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType ->MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of PooledSamplesIn, parameters describing the assembly and incubation method of the conjugation reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    ConjugationReactionPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {SampleManipulationP..},
      Description -> "A set of instructions specifying the transfer of reagents into the conjugation reaction and subsequent incubation.",
      Category -> "Conjugation"
    },
    ConjugationSampleManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, SampleManipulation],
      Description -> "The sample manipulation protocol used assemble and incubate the conjugation reaction.",
      Category -> "Conjugation"
    },

    (*********************************************** QUENCH FIELDS *************************************************)
    PredrainReactionMixtureMethod -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Magnetic | Pellet,
      Description -> "For each member of PooledSamplesIn, the method used to drain the aqueous reaction components following conjugation.",
      Category -> "Quenching",
      IndexMatching -> PooledSamplesIn
    },
    PredrainPellet->{
      Format->Multiple,
      Class->{
        Pellet->Boolean,
        Instrument->Link,
        Intensity->Real,
        Time->Real,
        Temperature->Expression,
        Target->Expression
      },
      Pattern:>{
        Pellet->BooleanP,
        Instrument->_Link,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient,
        Target->{Pellet|Supernatant..}
      },
      Relation->{
        Pellet->Null,
        Instrument->Model[Instrument]|Object[Instrument],
        Intensity->Null,
        Time->Null,
        Temperature->Null,
        Target->Null
      },
      Units->{
        Pellet->None,
        Instrument->None,
        Intensity->GravitationalAcceleration,
        Time->Minute,
        Temperature->Celsius|None,
        Target->None
      },
      Description -> "For each member of PooledSamplesIn, parameters describing the pelleting method of the PostConjugationWorkup.",
      Category -> "Quenching",
      IndexMatching -> PooledSamplesIn
    },
    PredrainMagneticSeparator->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container,Rack]|Object[Container,Rack],
      Description->"For each member of PooledSamplesIn, the magnetic device used to separate the sample during PredrainReactionMixture.",
      Category->"Quenching",
      IndexMatching->PooledSamplesIn
    },
    PredrainMagneticSeparationTime->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterP[0],
      Units->Minute,
      Description->"For each member of PooledSamplesIn, the time the sample container is in the magnetic device used to separate the sample during PredrainReactionMixture.",
      Category->"Quenching",
      IndexMatching->PooledSamplesIn
    },
    QuenchReactionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> Microliter,
			Description -> "For each member of PooledSamplesIn, the total volume of the quench reaction.",
			Category -> "Quenching",
			IndexMatching -> PooledSamplesIn
		},
    QuenchReagents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "For each member of PooledSamplesIn, the reagent that quenches any unbound functional groups remaining on the sample after conjugation.",
      Category -> "Quenching",
      IndexMatching -> PooledSamplesIn
    },
    QuenchReagentDilutionFactors -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of PooledSamplesIn, the relative amount that the QuenchReagent should be diluted in the quenching reaction.",
      Category -> "Conjugation",
      IndexMatching -> PooledSamplesIn
    },
    QuenchReagentVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of PooledSamplesIn, the volume of the QuenchReagent added to the quenching reaction.",
      Category -> "Quenching",
      IndexMatching -> PooledSamplesIn
    },
		QuenchParameters -> {
			Format -> Multiple,
			Class -> {
				IncubationTime -> Real,
				IncubationTemperature -> Expression,
				Mix -> Expression,
				MixType -> Expression,
				MixRate -> Real,
				MixVolume -> Real,
				NumberOfMixes -> Integer
			},
			Pattern :> {
				IncubationTime -> GreaterP[0],
				IncubationTemperature -> GreaterP[0]|Ambient,
				Mix -> BooleanP,
				MixType -> MixTypeP,
				MixRate -> GreaterP[0],
				MixVolume -> GreaterP[0],
				NumberOfMixes -> GreaterP[0]
			},
			Units -> {
				IncubationTime -> Minute,
				IncubationTemperature -> Celsius|None,
				Mix -> None,
				MixType -> None,
				MixRate -> RPM,
				MixVolume -> Microliter,
				NumberOfMixes -> None
			},
			Description -> "For each member of PooledSamplesIn, parameters describing the assembly and incubation method of the quenching reaction.",
			Category -> "Quenching",
			IndexMatching -> PooledSamplesIn
		},
    QuenchReactionPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {SampleManipulationP..},
      Description -> "A set of instructions specifying the assembly and incubation of the quenching reaction.",
      Category -> "Quenching"
    },
    QuenchSampleManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, SampleManipulation],
      Description -> "The sample manipulation protocol used assemble and incubate the quenching reaction.",
      Category -> "Quenching"
    },

    (*********************************************** POST CONJUGATION WORKUP FIELDS *************************************************)
    PostConjugationWorkupMethod -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Magnetic | Pellet | Filter,
      Description -> "For each member of PooledSamplesIn, the method used to process the samples following conjugation.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationWorkupBuffers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of PooledSamplesIn, the reagent used to process the sample after the conjugation and quenching reactions are complete.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationWorkupBufferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of PooledSamplesIn, the volume of the PostConjugationWorkupBuffer used to process the sample after the conjugation and quenching reactions are complete.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationMix -> {
      Format -> Multiple,
      Class -> {
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer
      },
      Pattern :> {
        IncubationTime -> GreaterP[0],
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType -> MixTypeP,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0]
      },
      Units -> {
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None
      },
      Description -> "For each member of PooledSamplesIn, parameters describing the assembly method of the Post-Conjugation Workup prior to subsequent processing.",
      Category -> "Quenching",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationFilter->{
      Format->Multiple,
      Class->{
        Filtration->Boolean,
        Type->Expression,
        Filter->Link,
        FilterHousing->Link,
        Instrument->Link,
        FilterStorageCondition->Expression,
        MembraneMaterial->Expression,
        PrefilterMembraneMaterial->Expression,
        PoreSize->Expression,
        PrefilterPoreSize->Expression,
        MolecularWeightCutoff->Expression,
        Syringe->Link,
        Sterile->Expression,
        Intensity->Real,
        Time->Real,
        Temperature->Expression,
        Target->Expression
      },
      Pattern:>{
        Filtration->BooleanP,
        Type->FiltrationTypeP,
        Filter->_Link,
        FilterHousing->_Link,
        Instrument->_Link,
        FilterStorageCondition->SampleStorageTypeP|Disposal,
        MembraneMaterial->FilterMembraneMaterialP,
        PrefilterMembraneMaterial->FilterMembraneMaterialP,
        PoreSize->GreaterP[0],
        PrefilterPoreSize->GreaterP[0],
        MolecularWeightCutoff->FilterMolecularWeightCutoffP,
        Syringe->_Link,
        Sterile->BooleanP,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient,
        Target->Retentate
      },
      Relation->{
        Filtration->Null,
        Type->Null,
        Filter->Alternatives[Model[Container, Plate, Filter], Object[Container, Plate, Filter],
          Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
          Model[Item, Filter], Object[Item, Filter]],
        FilterHousing->Alternatives[Object[Instrument,FilterHousing],Model[Instrument,FilterHousing]],
        Instrument->Model[Instrument]|Object[Instrument],
        FilterStorageCondition->Null,
        MembraneMaterial->Null,
        PrefilterMembraneMaterial->Null,
        PoreSize->Null,
        PrefilterPoreSize->Null,
        MolecularWeightCutoff->Null,
        Syringe->Model[Container,Syringe]|Object[Container,Syringe],
        Sterile->Null,
        Intensity->Null,
        Time->Null,
        Temperature->Null,
        Target->Null
      },
      Units->{
        Filtration->None,
        Type->None,
        Filter->None,
        FilterHousing->None,
        Instrument->None,
        FilterStorageCondition->None,
        MembraneMaterial->None,
        PrefilterMembraneMaterial->None,
        PoreSize->Micrometer,
        PrefilterPoreSize->Micrometer,
        MolecularWeightCutoff->None,
        Syringe->None,
        Sterile->None,
        Intensity->GravitationalAcceleration,
        Time->Minute,
        Temperature->Celsius|None,
        Target->None
      },
      Description -> "For each member of PooledSamplesIn, parameters describing the filtration method of the PostConjugationWorkup.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationPellet->{
      Format->Multiple,
      Class->{
        Pellet->Boolean,
        Instrument->Link,
        Intensity->Real,
        Time->Real,
        Temperature->Expression,
        Target->Expression
      },
      Pattern:>{
        Pellet->BooleanP,
        Instrument->_Link,
        Intensity->GreaterP[0],
        Time->GreaterP[0],
        Temperature->GreaterP[-10]|Ambient,
        Target->{Pellet|Supernatant..}
      },
      Relation->{
        Pellet->Null,
        Instrument->Model[Instrument]|Object[Instrument],
        Intensity->Null,
        Time->Null,
        Temperature->Null,
        Target->Null
      },
      Units->{
        Pellet->None,
        Instrument->None,
        Intensity->None,
        Time->Minute,
        Temperature->Celsius|None,
        Target->None
      },
      Description -> "For each member of PooledSamplesIn, parameters describing the pelleting method of the PostConjugationWorkup.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationMagneticSeparator->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container,Rack]|Object[Container,Rack],
      Description->"For each member of PooledSamplesIn, the magnetic device used to separate the sample during PostConjugationWorkup.",
      Category->"Post-Conjugation Workup",
      IndexMatching->PooledSamplesIn
    },
    PostConjugationMagneticSeparationTime->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterP[0],
      Units->Minute,
      Description->"For each member of PooledSamplesIn, the time the sample container is in the magnetic device used to separate the sample during PostConjugationWorkup.",
      Category->"Post-Conjugation Workup",
      IndexMatching->PooledSamplesIn
    },
    PostConjugationResuspensionDiluent -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample] | Object[Sample],
      Description -> "For each member of PooledSamplesIn, the reagent used to resuspend the sample after the PostConjugation complete.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationResuspensionDiluentVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> Microliter,
      Description -> "For each member of PooledSamplesIn, the volume of the PostConjugationResuspensionDiluent used to resuspend the sample after the PostConjugation is complete.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationResuspensionParameters -> {
      Format -> Multiple,
      Class -> {
        Resuspend->Boolean,
        IncubationTime -> Real,
        IncubationTemperature -> Expression,
        Mix -> Expression,
        MixType -> Expression,
        MixRate -> Real,
        MixVolume -> Real,
        NumberOfMixes -> Integer,
        MixUntilDissolved->Expression,
        MaxNumberOfMixes->Integer,
        MaxTime->Real
      },
      Pattern :> {
        Resuspend->BooleanP,
        IncubationTime -> Real,
        IncubationTemperature -> GreaterP[0]|Ambient,
        Mix -> BooleanP,
        MixType -> Vortex | Shake | Roll | Stir | Pipette | Invert,
        MixRate -> GreaterP[0],
        MixVolume -> GreaterP[0],
        NumberOfMixes -> GreaterP[0],
        MixUntilDissolved->BooleanP,
        MaxNumberOfMixes->GreaterP[0],
        MaxTime->GreaterP[0]
      },
      Units -> {
        Resuspend->None,
        IncubationTime -> Minute,
        IncubationTemperature -> Celsius|None,
        Mix -> None,
        MixType -> None,
        MixRate -> RPM,
        MixVolume -> Microliter,
        NumberOfMixes -> None,
        MixUntilDissolved->None,
        MaxNumberOfMixes->None,
        MaxTime->Minute
      },
      Description -> "For each member of PooledSamplesIn, parameters describing the incubation method of the PostConjugationResuspension.",
      Category -> "Post-Conjugation Workup",
      IndexMatching -> PooledSamplesIn
    },
    PostConjugationPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SampleManipulationP,
      Description -> "A set of instructions specifying the post-conjugation workup.",
      Category -> "Post-Conjugation Workup"
    },
   PostConjugationSampleManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, SampleManipulation],
      Description -> "The sample manipulation protocol used execute the post-conjugation workup.",
      Category -> "Post-Conjugation Workup"
    },
    (*Batching Loop fields*)
    BatchConjugationPrimitives -> {
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP,
      Description->"The set of instructions specifying the conjugation reaction for the current batch.",
      Category->"Conjugation",
      Developer->True
    },
    BatchQuenchPrimitives -> {
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP,
      Description->"The set of instructions specifying the quenching reaction for the current batch.",
      Category->"Quenching",
      Developer->True
    },
    BatchPostConjugationPrimitives -> {
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP,
      Description->"The set of instructions specifying the post-conjugation workup reaction for the current batch.",
      Category->"Post-Conjugation Workup",
      Developer->True
    }
	}
}];
