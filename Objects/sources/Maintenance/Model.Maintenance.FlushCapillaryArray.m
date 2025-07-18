(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-02-27 *)

DefineObjectType[Model[Maintenance, FlushCapillaryArray], {
  Description->"Definition of a set of parameters for a maintenance protocol that flushes the capillary array of fragment analyzer.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    PrimaryCapillaryFlushSolutionModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The model of solution that is used in the container attached to the COND line of the instrument and runs through the capillaries and into the Waste Plate during flushing.",
      Category -> "General",
      Abstract -> True
    },
    PrimaryCapillaryFlushSolutionVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Milliliter],
      Units->Milliliter,
      Description->"The volume of PrimaryCapillaryFlushSolution that runs through the capillaries and into the Waste Plate during flushing.",
      Category -> "General"
    },
    SecondaryCapillaryFlushSolutionModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The model of solution that is used in the container attached to the GEL1 line of the instrument and runs through the capillaries and into the Waste Plate during flushing.",
      Category -> "General",
      Abstract -> True
    },
    SecondaryCapillaryFlushSolutionVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Milliliter],
      Units->Milliliter,
      Description->"The volume of SecondaryCapillaryFlushSolution that runs through the capillaries and into the Waste Plate during flushing.",
      Category -> "General"
    },
    TertiaryCapillaryFlushSolutionModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "The model of solution that is used in the container attached to the GEL2 line of the instrument and runs through the capillaries and into the Waste Plate during flushing.",
      Category -> "General",
      Abstract -> True
    },
    TertiaryCapillaryFlushSolutionVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Milliliter],
      Units->Milliliter,
      Description->"The volume of TertiaryCapillaryFlushSolution that runs through the capillaries and into the Waste Plate during flushing.",
      Category -> "General"
    },
    SamplePreparationUnitOperations->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A set of instructions specifying the loading of the sample container with the desired solution for use in Maintenance.",
      Category -> "General"
    },
    SoakSolutionPlatePreparationUnitOperations->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A set of instructions specifying the loading of the SoakSolutionPlate container with the desired solution for use in Maintenance.",
      Category -> "General"
    },
    CapillaryFlushFileNames->{
      Format->Multiple,
      Class->String,
      Pattern:>_String,
      Description->"The name(s) of the method file(s) containing the parameters for running the conditioning solution or specified alternative(s) through the capillaries.",
      Category->"General",
      Developer->True
    },
    SoakSolutionPlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container,Plate],
      Description -> "The plate that is used to contain the solution the capillary array is soaked in to facilitate clog removal.",
      Category -> "General"
    },
    PrimaryWastePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container,Plate],
      Description -> "The model of the plate that is used to contain the waste from the first method of the capillary flush run.",
      Category -> "General"
    },
    SecondaryWastePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container,Plate],
      Description -> "The model of the plate that is used to contain the waste from the second method of thecapillary flush run.",
      Category -> "General"
    },
    TertiaryWastePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container,Plate],
      Description -> "The model of the plate that is used to contain the waste from the third method of thecapillary flush run.",
      Category -> "General"
    },
    UnclogChannels -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates whether or not maintenance to unclog is to be enqueued when there are clogged channels.",
      Category -> "General",
      Developer -> True
    }
  }
}];
