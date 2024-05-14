(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,CommonLabwareTerminology], {
  Description -> "A protocol that verifies an operator's ability to identify common labware.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    MixLabwareBin -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The bin that holds all the objects that the user is asked to verify during the procedure.",
      Category -> "General"
    },
    LargeTube -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The tube that the operator scans as 2mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    MediumTube -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The tube that the operator scans as 1.5mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    SmallTube -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The tube that the operator scans as 0.5mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    Plate -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Relation -> Model[Container]|Object[Container],
      Description -> "The plate that the operator scans as 2mL Deep Well Plate from the MixLabware Bin.",
      Category -> "General"
    },
    HPLCHighRecoveryVial -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The HPLC high recovery vial that look similiar to the other HPLC vials that help user identify the correct object in the MixLabwareBin.",
      Category -> "General"
    },
    HPLCTotalRecoveryVial -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The HPLC total recovery vial that look similiar to the other HPLC vials that help user identify the correct object in the MixLabwareBin.",
      Category -> "General"
    },
    LargeConicalTube -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The tube that the operator scans as 50mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    MidConicalTube -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The tube that the operator scans as 15mL Tube from the MixLabware Bin.",
      Category -> "General"
    },
    PCRPlate -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The plate that the operator scans as PCR Plate from the MixLabware Bin.",
      Category -> "General"
    },
    ReusableNeedle -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as 6 in x 18G stainless steel Needle from the MixLabware Bin.",
      Category -> "General"
    },
    BluntLuerLockNeedle -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as 6 Gauge2 in Reusable Blunt Probe Luer Lock Needle from the MixLabware Bin.",
      Category -> "General"
    },
    WieghPaper -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as Weighing Paper from the MixLabware Bin.",
      Category -> "General"
    },
    Funnel -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Part that the operator scans Funnel from the MixLabware Bin.",
      Category -> "General"
    },
    SingleUseNeedle -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as 21g x 1 Inch Single-Use Needle from the MixLabware Bin.",
      Category -> "General"
    },
    MicroTips -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as 1000 uL reach tips, non-sterile from the MixLabware Bin.",
      Category -> "General"
    },
    ErlenmeyerFlask -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The container that the operator scans as 125mL Erlenmeyer Flask from the MixLabware Bin.",
      Category -> "General"
    },
    PlateSealRoller -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as seal roller from the MixLabware Bin.",
      Category -> "General"
    },
    SerologicalPipette -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as Serological Pipette from the MixLabware Bin.",
      Category -> "General"
    },
    MicroPipette -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Instrument that the operator scans as Eppendorf Research Plus P1000 Pipette from the MixLabware Bin.",
      Category -> "General"
    },
    VolumetricFlask -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The container that the operator scans as 100 mL Glass Volumetric Flask from the MixLabware Bin.",
      Category -> "General"
    },
    LabSpatula -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The item that the operator scans as Flat/Round Spatula from the MixLabware Bin.",
      Category -> "General"
    },
    SerologicalTip -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The Item that the operator scans as 10 mL glass barrier serological Tip, sterile from the MixLabware Bin.",
      Category -> "General"
    },
    DisposableSyringe -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The container that the operator scans as 5mL Sterile Disposable Syringe from the MixLabware Bin.",
      Category -> "General"
    },
    PlateLid -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The plate seal that the operator scans as Plate Seal, 96-Well Square from the MixLabware Bin.",
      Category -> "General"
    },
    ZoneFreePlateSeal -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The plate seal that the operator scans as 96-Well Plate Seal, EZ-Pierce Zone-Free from the MixLabware Bin.",
      Category -> "General"
    },
    AmberBottle -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The container that the operator scans as 4L Bottle from the MixLabware Bin.",
      Category -> "General"
    },
    Carboy -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The container that the operator scans as Carboy from the MixLabware Bin.",
      Category -> "General"
    }
  }
}]