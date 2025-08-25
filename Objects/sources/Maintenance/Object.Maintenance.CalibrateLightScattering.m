(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateLightScattering], {
  Description->"A protocol that generates a calibration converting a light scattering instrument's raw output to intensity based on measurement of a standard sample.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    CalibrationStandard -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[Sample]|Model[Sample],
      Description -> "The standard sample which is used to calibrate the scattered light intensity of a MultimodeSpectrophotometer.",
      Category -> "General",
      Abstract -> True
    },

    AssayContainers->{
      Format->Multiple,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Container,Plate],Model[Container,Plate]],
      Description -> "The capillary strips that the samples are assayed in.",
      Category->"Sample Loading"
    },
    CapillaryClips->{
      Format->Multiple,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Container],Model[Container]],
      Description -> "The capillary clips used to seal the assay containers.",
      Category->"Sample Loading",
      Developer->True
    },
    CapillaryGaskets->{
      Format->Single,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Item,Consumable],Model[Item,Consumable]],
      Description -> "The gaskets inserted into the capillary clips prior to sealing the assay containers.",
      Category->"Sample Loading",
      Developer->True
    },
    CapillaryStripLoadingRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Container,Plate],Model[Container,Plate]],
      Description -> "The capillary strip plate adaptor rack for loading samples using a liquid handler.",
      Category->"Sample Loading",
      Developer->True
    },
    SampleStageLid->{
      Format->Single,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Part],Model[Part]],
      Description -> "The lid enclosing the Uncle sample stage.",
      Category->"Sample Loading",
      Developer->True
    },
    AssayPlateUnitOperations->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A set of instructions specifying the loading of the AssayContainers with the input samples diluted input samples, and BlankBuffers.",
      Category -> "Sample Loading"
    },
    AssayPlatePreparation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
        Object[Protocol,ManualSamplePreparation],
        Object[Protocol,RoboticSamplePreparation],
        Object[Notebook, Script]
      ],
      Description->"A sample manipulation protocol used to load the AssayContainers.",
      Category->"Sample Loading"
    },
    ContainerPlacements -> {
      Format -> Multiple,
      Class -> {Link, Expression},
      Pattern :> {_Link, {LocationPositionP}},
      Relation -> {Object[Container] | Model[Container] | Object[Part] | Model[Part], Null},
      Description -> "A list of placements used to place the capillary strips to be analyzed into the sample stage of the multimode spectrophotometer.",
      Category -> "Sample Loading",
      Developer -> True,
      Headers -> {"Object to Place", "Placement Tree"}
    },

    (* uni clip loading fields *)
    CapillaryLoading->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Robotic, Manual],
      Description->"The loading method for capillaries.",
      Category -> "General"
    },
    ManualLoadingPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],
      Description->"The plate from which samples are loaded onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
      Category -> "Sample Loading"
    },
    ManualLoadingPipette->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Instrument,Pipette]|Object[Instrument,Pipette],
      Description->"The multichannel pipette that is used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
      Category -> "Sample Loading"
    },
    ManualLoadingTips->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Item,Tips]|Object[Item,Tips],
      Description->"The pipette tips that are used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
      Category -> "Sample Loading"
    },
    ManualLoadingTuples->{
      Format->Multiple,
      Class->{Sources->Link, SourceRow->Expression ,Targets->Link, TargetRow->Expression, FirstWell->Expression, NumberOfWells->Expression, TargetPositions -> Expression},
      Pattern:>{Sources->_Link, SourceRow->_String, Targets->_Link, TargetRow->_String, FirstWell->_String, NumberOfWells->_String, TargetPositions -> _String},
      Relation->{Sources->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],SourceRow->Null, Targets->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel], TargetRow->Null, FirstWell->Null, NumberOfWells->Null, TargetPositions -> Null},
      Description->"The pipetting instructions used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
      Category -> "Sample Loading"
    },

    (* File stuff *)
    MethodFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The full file path of the file containing instructions used by the instrument software to run this maintenance.",
      Category -> "General",
      Developer->True
    },
    SampleFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The full file path of the file containing the sample information for this maintenance.",
      Category -> "General",
      Developer->True
    },
    InstrumentDataFilePath->{
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path on the instrument computer in which the data generated by the experiment is stored locally.",
      Category -> "Data Processing",
      Developer -> True
    },
    DataTransferFilePath->{
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path and name of the .bat file which transfers data to the public drive at the conclusion of the experiment.",
      Category -> "Data Processing",
      Developer -> True
    },
    DataFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The name of the directory where the data files are stored at the conclusion of the experiment.",
      Category -> "Data Processing",
      Developer -> True
    },
    DataFileName -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The name of the .bat file which transfers the contents of the InstrumentDataFilePath to the DataFilePath.",
      Category -> "Data Processing",
      Developer -> True
    },
    DataFile -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      Description -> "The file containing the method information and the data generated by the instrument.",
      Category -> "Data Processing"
    },





    CalibrationStandardIntensity->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0],
      Units->None,
      Description->"The average measured scattered light intensity of the CalibrationStandard in counts per second.",
      Category->"Experimental Results"
    }
  }
}]
