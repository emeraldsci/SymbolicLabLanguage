(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,AsepticTechnique], {
  Description -> "A protocol that verifies an operator's ability to use AsepticTechnique mode for BSC.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    BiosafetyCabinet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument, BiosafetyCabinet],
        Object[Instrument, BiosafetyCabinet],
        Model[Instrument, HandlingStation, BiosafetyCabinet],
        Object[Instrument, HandlingStation, BiosafetyCabinet]
      ],
      Description -> "The biosafety cabinet instrument that is selected for the training qualification of AsepticTechnique.",
      Category -> "General"
    },
    Indicator -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "Fluorescent indicator that is spread to the biosafety cabinet surface, container, etc. and is not detected at the end of the training if there is proper decontamination.",
      Category -> "General"
    },
    CulturePlates-> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "The culture plates that are placed open in the biosafety cabinet surface throughout the HandsFreeOperation process, and incubated afterwards to check the aseptic technique performance.",
      Category -> "General"
    },
    NegativeControlCulturePlates-> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "The culture plates that are placed covered in the biosafety cabinet surface throughout the HandsFreeOperation process as negative controls, and incubated afterwards to verify that the culture plates are not contaminated by other means.",
      Category -> "General"
    },
    TransferSample -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "The sample to transfer to the Container in the biosafety cabinet.",
      Category -> "General"
    },
    Container -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Object[Container]
      ],
      Description -> "The container into which to transfer the sample in the biosafety cabinet.",
      Category -> "General"
    },
    TransferAmount -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "The amount of TransferSample to transfer into Container in the biosafety cabinet.",
      Category -> "General"
    },
    Pipette -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument, Pipette],
        Model[Instrument, Pipette]
      ],
      Description -> "The pipette instrument used for transfer inside the BSC.",
      Category -> "General"
    },
    Tips-> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item],
        Object[Item]
      ],
      Description -> "The pipette tips used in this qualification with the Pipette.",
      Category -> "General"
    },
    BiosafetyWasteBin -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Container,WasteBin],Object[Container,WasteBin]],
      Description -> "The waste bin brought into the bio safety cabinet to hold the BiosafetyWasteBag that collect biohazardous waste generated while working in the bsc.",
      Category -> "General"
    },
    BiosafetyWasteBag -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
      Description -> "The waste bag brought into the biosafety cabinet and placed in the BiosafetyWasteBin to collect biohazardous waste generated while working in the bsc.",
      Category -> "General"
    },
    BiosafetyWasteBinPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container,WasteBin],
          Model[Container,WasteBin],
          Object[Item,Consumable],
          Model[Item,Consumable]
        ],
        Alternatives[
          Object[Instrument,BiosafetyCabinet],
          Model[Instrument,BiosafetyCabinet],
          Object[Instrument,HandlingStation,BiosafetyCabinet],
          Model[Instrument,HandlingStation,BiosafetyCabinet],
          Object[Container,WasteBin],
          Model[Container,WasteBin]
        ],
        Null
      },
      Headers -> {"Objects to move", "Object to move to", "Position to move to"},
      Description -> "The specific positions into which waste bin objects are moved into the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    TransferSamplePlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container],
          Model[Container],
          Object[Sample],
          Model[Sample]
        ],
        Alternatives[
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, BiosafetyCabinet],
          Model[Instrument, HandlingStation, BiosafetyCabinet],
          Object[Instrument, HandlingStation, BiosafetyCabinet]
        ],
        Null
      },
      Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which the TransferSample are moved into the biosafety cabinet for imaging under UV after rubbing the Indicator on.",
      Category -> "General",
      Developer -> True
    },
    BiosafetyCabinetPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container],
          Model[Container],
          Object[Sample],
          Model[Sample],
          Object[Instrument],
          Model[Instrument],
          Object[Item],
          Model[Item]
        ],
        Alternatives[
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, BiosafetyCabinet],
          Model[Instrument, HandlingStation, BiosafetyCabinet],
          Object[Instrument, HandlingStation, BiosafetyCabinet],
          Object[Container,WasteBin],
          Model[Container,WasteBin]
        ],
        Null
      },
      Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which objects are moved into the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    (* Developer *)
    (* Upload fields during qualification run *)
    IncubateCellsProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,IncubateCells],
      Description -> "The experimental protocol that generated for incubating the culture plates and negative control plates.",
      Category -> "General"
    },
    CollectionObjects->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Object[Item],
        Object[Sample],
        Object[Instrument],
        Object[Part]
      ],
      Description -> "The objects to be moved from the biosafety cabinet's work surface back onto the cart after working in the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    FluorescentImagesBeforeDecontamination -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The images taken under UV after spreading the Indicator.",
      Category -> "Decontaminating"
    },
    FluorescentImagesAfterDecontamination -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The images taken under UV after decontamination of the surfaces and containers.",
      Category -> "Decontaminating"
    },
    Images -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The images of the biosafety cabinet surface taken without turning on UV.",
      Category -> "Decontaminating"
    }
  }
}];