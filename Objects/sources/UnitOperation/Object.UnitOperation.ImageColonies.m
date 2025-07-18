(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)
DefineObjectType[Object[UnitOperation, ImageColonies],
  {
    Description -> "A detailed set of parameters for imaging microbial colonies growing on solid media using a colony handler.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
      (* General *)
      SampleLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Object[Sample],
          Model[Sample],
          Model[Container],
          Object[Container]
        ],
        Description -> "The sample(s) to be imaged.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The sample(s) to be imaged.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
        Relation -> Null,
        Description -> "The sample(s) to be imaged.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the label of the source sample that are used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        IndexMatching -> SampleLink
      },
      SampleContainerLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "For each member of SampleLink, the label of the source container that are used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        IndexMatching -> SampleLink
      },
      Instrument -> {
        Format -> Single,
        Class -> Link,
        Relation -> Alternatives[Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler]],
        Pattern :> _Link,
        Description -> "The robotic instrument that is used to image colonies on solid media.",
        Category -> "General"
      },
      AbsorbanceFilter -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Part, OpticalFilter], Object[Part, OpticalFilter]],
        Description -> "The Absorbance filter used for any absorbance imaging in this unit operation.",
        Category -> "General",
        Developer -> True
      },
      (* ----------- Imaging -------------- *)
      ImagingChannels -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[QPixFluorescenceWavelengthsP | QPixAbsorbanceWavelengthsP | BrightField],
        Description -> "For each member of SampleLink, and for each ImagingStrategy, the preset which describes the light source, blue-white filter, and filter pairs for selecting fluorescence excitation and emission wavelengths when capturing images.",
        IndexMatching -> SampleLink,
        Developer -> True,
        Category -> "Imaging"
      },
      ImagingStrategies -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[QPixImagingStrategiesP],
        Description -> "For each member of SampleLink, the end goals for capturing images of the colonies. The available options include BrightField imaging, BlueWhite Screening, and Fluorescence imaging.",
        IndexMatching -> SampleLink,
        Category -> "Imaging"
      },
      ExposureTimes -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[GreaterP[0 Millisecond]|Null|AutoExpose],
        Description -> "For each member of SampleLink, and for each ImagingStrategy, the length of time to allow the camera to capture an image. When auto exposure is desired, exposure time is marked as Null before the optimal exposure time is determined during experiment and multiple images are taken to calculate the optimal exposure time.",
        IndexMatching -> SampleLink,
        Category -> "Imaging"
      },
      (* Data and Analysis *)
      AllImageExposureAnalyses -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Analysis, ImageExposure]],
        Description -> "A list of the exposure analyses performed on the source plate images taken by the QPix.",
        Category -> "Analysis & Reports"
      },
      AllColonyAppearanceData -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Data, Appearance, Colonies]],
        Description -> "A list of the data objects containing the images of the source plates taken by the QPix.",
        Category -> "Analysis & Reports"
      },
      (* ---developer fields for batch handling--- *)
      BatchedUnitOperations -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[UnitOperation, ImageColonies]],
        Description -> "The physical batches split by destination containers that can fit on the deck at once.",
        Category -> "General",
        Developer -> True
      },
      PhysicalBatchingGroups -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> _List,
        Description -> "A Nested list of associations storing how the sample packets are physically batched. For example, in {{{a,b},{c}},{{d,e}}}, abc are from the same physical batch, de are from the same physical batch, ab and c are from different source group.",
        Category -> "General",
        Developer -> True
      },
      ImageExposureAnalyses -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Analysis, ImageExposure]]...},
        Description -> "For each member of SampleLink, a list of the exposure analyses performed on the images of the sample taken by the QPix.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      ColonyAppearanceData -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Data, Appearance, Colonies]]...},
        Description -> "For each member of SampleLink, a list of the data objects containing the images of the sample taken by the QPix.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      (* NOTE: The fields below will only be filled out for unit operations that are in the BatchedUnitOperations field of another Object[UnitOperation,ImageColonies] *)
      FlatBatchedSourceContainers -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container, Plate], Object[Sample]],
        Description -> "A flat list of the source containers that once batched with the lengths in BatchedSourceContainerLengths, represents which pairs of source containers should be placed on deck at the same time.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedSourceContainerPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Sample]], Null},
        Headers -> {"Object","Position"},
        Description -> "A flat list of the source container placements that once batched with the lengths in BatchedSourceContainerLengths, represents which pairs of source containers should be placed on the deck at the same time.",
        Category -> "General",
        Developer -> True
      },
      BatchedSourceContainerLengths -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The batching lengths corresponding to FlatBatchedSourceContainers that are used to partition FlatBatchedSourceContainers.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedRoutineJSONPaths -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> FilePathP,
        Description -> "The file paths pointing to the location of any JSON files to pass to the qpix for this physical batch. This list is unflattened by FlatBatchedRoutineJSONLengths.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedRoutineJSONLengths -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The length of the batches of any jsons stored in FlatBatchedRoutineJSONPaths.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedAbsorbanceRoutineJSONPaths -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> FilePathP,
        Description -> "The file paths pointing to the JSON files to pass to the qpix to run the exposure finding routines for absorbance images for this physical batch. This list is unflattened by FlatBatchedAbsorbanceRoutineJSONLengths.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedAbsorbanceRoutineJSONLengths -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterEqualP[0, 1],
        Description -> "The length of the batches of any jsons stored in FlatBatchedAbsorbanceRoutineJSONPaths.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedImagingChannels -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[QPixFluorescenceWavelengthsP, QPixAbsorbanceWavelengthsP, BrightField]..}|Null,
        Description -> "The lists of imaging channels corresponding to the flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedExposureTimes -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[GreaterP[0 Millisecond], AutoExpose]..}|Null,
        Description -> "The lists of exposure times corresponding to the flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedSamplesInStorageConditions -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> Alternatives[SampleStorageTypeP, Disposal, Null],
        Description -> "The list of samples in storage condition values corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      (* ----------- Experimental Data  -------------- *)
      ImageExposureAnalysisObjects -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Analysis, ImageExposure]]...},
        Description -> "For each plate in the batched unit operation, a list of the image exposure analysis objects that were taken for that plate.",
        Category -> "General",
        Developer -> True
      },
      AppearanceDataObjects -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Data, Appearance, Colonies]],
        Description -> "For each plate in the batched unit operation, the data object containing the final images used for colony analysis.",
        Category -> "General",
        Developer -> True
      }
    }
  }
];