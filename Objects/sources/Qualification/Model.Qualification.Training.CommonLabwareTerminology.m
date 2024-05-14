(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,CommonLabwareTerminology], {
  Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to identify common labware.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    MixLabwareBin -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The bin that holds all the objects that the operator is asked to verify during the procedure.",
      Category -> "General"
    },
    LargeTube -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The tube that the operator is asked to identify as 2mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    MediumTube -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The tube that the operator is asked to identify as 1.5mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    SmallTube -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The tube that the operator is asked to identify as 0.5mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    Plate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The plate that the operator is asked to identify as 2mL Deep Well Plate from the MixLabware Bin.",
      Category -> "General"
    },
    HPLCHighRecoveryVial -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The HPLC high recovery vial that look similiar to the other HPLC vials that help user identify the correct object in the MixLabwareBin.",
      Category -> "General"
    },
    HPLCTotalRecoveryVial -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The HPLC total recovery vial that look similiar to the other HPLC vials that help user identify the correct object in the MixLabwareBin.",
      Category -> "General"
    },
    LargeConicalTube -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The tube that the operator is asked to identify as 50mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    MidConicalTube -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The tube that the operator is asked to identify as 15mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    PCRPlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The plate that the operator is asked to identify as PCR Plate from the MixLabware Bin.",
      Category -> "General"
    },
    ReusableNeedle -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as 6 in x 18G stainless steel Needle from the MixLabware Bin.",
      Category -> "General"
    },
    BluntLuerLockNeedle -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as 6 Gauge2 in Reusable Blunt Probe Luer Lock Needle from the MixLabware Bin.",
      Category -> "General"
    },
    WieghPaper -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as Weighing Paper from the MixLabware Bin.",
      Category -> "General"
    },
    Funnel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Part]|Object[Part],
      Description -> "The Part that the operator is asked to identify Funnel from the MixLabware Bin.",
      Category -> "General"
    },
    SingleUseNeedle -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as 21g x 1 Inch Single-Use Needle from the MixLabware Bin.",
      Category -> "General"
    },
    MicroTips -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as 1000 uL reach tips, non-sterile from the MixLabware Bin.",
      Category -> "General"
    },
    ErlenmeyerFlask -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The container that the operator is asked to identify as 125mL Erlenmeyer Flask from the MixLabware Bin.",
      Category -> "General"
    },
    PlateSealRoller -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as seal roller from the MixLabware Bin.",
      Category -> "General"
    },
    SerologicalPipette -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument]|Object[Instrument],
      Description -> "The Item that the operator is asked to identify as Serological Pipette from the MixLabware Bin.",
      Category -> "General"
    },
    MicroPipette -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument]|Object[Instrument],
      Description -> "The Instrument that the operator is asked to identify as Eppendorf Research Plus P1000 Pipette from the MixLabware Bin.",
      Category -> "General"
    },
    VolumetricFlask -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The container that the operator is asked to identify as 100 mL Glass Volumetric Flask from the MixLabware Bin.",
      Category -> "General"
    },
    LabSpatula -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The item that the operator is asked to identify as Flat/Round Spatula from the MixLabware Bin.",
      Category -> "General"
    },
    SerologicalTip -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The Item that the operator is asked to identify as 10 mL glass barrier serological Tip, sterile from the MixLabware Bin.",
      Category -> "General"
    },
    DisposableSyringe -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The container that the operator is asked to identify as 5mL Sterile Disposable Syringe from the MixLabware Bin.",
      Category -> "General"
    },
    PlateLid -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The plate seal that the operator is asked to identify as Plate Seal, 96-Well Square from the MixLabware Bin.",
      Category -> "General"
    },
    ZoneFreePlateSeal -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item]|Object[Item],
      Description -> "The plate seal that the operator is asked to identify as 96-Well Plate Seal, EZ-Pierce Zone-Free from the MixLabware Bin.",
      Category -> "General"
    },
    AmberBottle -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The container that the operator is asked to identify as 4L Bottle from the MixLabware Bin.",
      Category -> "General"
    },
    Carboy -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Object[Container],
      Description -> "The container that the operator is asked to identify as Carboy from the MixLabware Bin.",
      Category -> "General"
    }
  }
}]