(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

DefineObjectType[Object[Protocol,InoculateLiquidMedia],{
  Description -> "A protocol for transferring cells in a liquid culture or an agar stab to another liquid media.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* General *)
    InoculationSource -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> InoculationSourceProtocolObjectP, (* LiquidMedia|AgarStab *)
      Description -> "The type of the media (Liquid or AgarStab) where the source cells are stored before the experiment.",
      Category -> "General"
    },
    TransferEnvironments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Instrument, BiosafetyCabinet],Object[Instrument, BiosafetyCabinet]],
      Description -> "For each member of SamplesIn, the environment in which the inoculation will be performed. Containers involved in the inoculation will first be moved into the TransferEnvironment (with covers on), uncovered inside of the TransferEnvironment, then covered after the inoculation has finished -- before they're moved back onto the operator cart.",
      Category -> "General"
    },
    Instruments -> {
      Format -> Multiple,
      Class -> Link,
      Relation -> Alternatives[Model[Instrument,LiquidHandler],Object[Instrument,LiquidHandler],Object[Instrument,Pipette],Model[Instrument,Pipette]],
      Pattern :> _Link,
      Description -> "For each member of SamplesIn, the instrument that is used to move cells to fresh liquid media from solid media, liquid media, or a bacterial stab.",
      IndexMatching -> SamplesIn,
      Category -> "General"
    },

    (* Stab *)
    StabTips -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item,Tips],Object[Item,Tips]],
      Description -> "The tips used to pick from an agar stab and deposit into liquid media by hand.",
      Category -> "Stab"
    },
    StabTipTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SamplesIn, the type of pipette tips used to aspirate and dispense the cells during the inoculation.",
      IndexMatching -> SamplesIn,
      Category -> "Stab"
    },
    StabTipMaterials -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the cells during the inoculation.",
      IndexMatching -> SamplesIn,
      Category -> "Stab"
    },

    (* Aspirate *)
    TransferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SamplesIn, the amount of source cells to transfer to the destination container.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    Tips -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item,Tips], Object[Item,Tips]],
      Description -> "For each member of SamplesIn, the tips used to transfer cells from liquid media and deposit into liquid media by hand.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    TipTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SamplesIn, the type of pipette tips used to transfer cells from liquid media and deposit into liquid media by hand.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    TipMaterials -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SamplesIn, the material of the pipette tips used to transfer cells from liquid media and deposit into liquid media by hand.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    PipettingMethods -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Method,Pipetting]],
      Description -> "For each member of SamplesIn, the pipetting parameters used to manipulate the source cells.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    SourceMixTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Pipette|Swirl,
      Description -> "For each member of SamplesIn, the type of mixing of the cells that will occur immediately before aspiration from the source container. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform DestinationNumberOfMixes clockwise rotations of the container.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    NumberOfSourceMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0,1],
      Description -> "For each member of SamplesIn, the number of times that the source cells will be swirled or pipetted up and down just prior to aspiration.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },
    SourceMixVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume that will be repeatedly aspirated and dispensed via pipette from the source cells in order to mix the source cells immediately before the inoculation occurs. The same pipette and tips used in the inoculation will be used to mix the source cells.",
      IndexMatching -> SamplesIn,
      Category -> "Aspirate"
    },

    (* Deposit *)
    DestinationMedia -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample],Model[Sample]],
      Description -> "For each member of SamplesIn, the media in which the picked cells are deposited.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    MediaVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the starting amount of liquid media in which the picked cells are deposited prior to the cells being added.", (* If doing Nulls and volumes doesnt work just do 0 Microliter for solid and explain in description *)
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationMediaContainers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container],Model[Container]],
      Description -> "For each member of SamplesIn, the container containing liquid media into which the cells are deposited.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationWells -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> WellPositionP | LocationPositionP,
      Description -> "For each member of SamplesIn, the position in the DestinationMediaContainer to move the source cells.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationMixTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> InoculationMixTypeP,
      Description -> "For each member of SamplesIn, the type of mixing that will occur immediately after the cells are dispensed into the destination container. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform DestinationNumberOfMixes clockwise rotations of the container.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationNumberOfMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0,1],
      Description -> "For each member of SamplesIn, the number of times the cells are mixed in the destination container after they are deposited.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationMixVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume that is repeatedly aspirated and dispensed via pipetting from the destination sample in order to mix the destination sample immediately after the inoculation occurs. The same pipette and tips used in the inoculation are used to mix the destination sample.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    SamplesInStorageCondition -> {
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleStorageTypeP|Disposal,
      Description->"For each member of SamplesIn, the non-default condition under which the samples in should be stored after the protocol is completed.",
      Category->"Sample Storage",
      IndexMatching->SamplesIn
    },
    SamplesOutStorageCondition -> {
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleStorageTypeP|Disposal,
      Description->"For each member of SamplesIn, the non-default condition under which the samples out should be stored after the protocol is completed.",
      Category->"Sample Storage",
      IndexMatching->SamplesIn
    },
    TransferSubprotocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Protocol, ManualCellPreparation]],
      Description -> "The sub protocol to perform the inoculation.",
      Category -> "General"
    },

    (* Developer *)
    TransferUnitOperation -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "If InoculationSource is AgarStab, the Transfer Unit Operation that will populate the destination container. If InoculationSource is LiquidMedia, the Transfer that will populate the destination container and perform the inoculation.",
      Category -> "General",
      Developer -> True
    },
    (* NOTE: These are all resource picked at once so that we can minimize trips to the VLM. DO NOT COPY THIS. *)
    RequiredObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part],
      Description -> "Objects required for the protocol.",
      Category -> "General",
      Developer -> True
    },
    (* NOTE: These are resource picked on the fly, but we need this field so that ReadyCheck knows if we can start the protocol or not. *)
    RequiredInstruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument] | Object[Instrument],
      Description -> "Instruments required for the protocol.",
      Category -> "General",
      Developer -> True
    },
    SetUpTransferEnvironments -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the TransferEnvironment needs to be set up at the beginning of that iteration of the protocol loop.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    TearDownTransferEnvironments -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the TransferEnvironment needs to be torn down at the end of that iteration of the protocol loop.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    ReleaseInstruments -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each sample, whether the Pipette needs to be released at the end of this iteration of the protocol loop.",
      Category -> "General",
      Developer -> True
    },
    ReleaseTips -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each sample, whether the Tips needs to be released at the end of this iteration of the protocol loop.",
      Category -> "General",
      Developer -> True
    },
    CoverDestinationContainers -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the DestinationContainer should be covered after the inoculation.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    PlateSeal -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item, PlateSeal],
      Description -> "Indicates the plate seal model used to cover any DestinationMediaContainers that have footprint Plate after the inoculation.",
      Category -> "Deposit"
    },
    MovementObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Object[Item],
        Object[Sample],
        Object[Instrument]
      ],
      Description -> "The objects to move onto the TransferEnvironment's work surface after it is selected.",
      Category -> "General",
      Developer -> True
    },
    CollectionObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Object[Item],
        Object[Sample],
        Object[Instrument]
      ],
      Description -> "The objects to remove from the TransferEnvironment's work surface when before it is released.",
      Category -> "General",
      Developer -> True
    }
  }
}];