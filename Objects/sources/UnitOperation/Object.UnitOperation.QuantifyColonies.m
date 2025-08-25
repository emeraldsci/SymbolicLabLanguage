(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)
DefineObjectType[Object[UnitOperation, QuantifyColonies],
  {
    Description -> "A detailed set of parameters for counting microbial colonies growing on solid media using a colony handler.",
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
        Description -> "The samples that we are imaging microbial colonies from.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The samples that we are imaging microbial colonies from.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
        Relation -> Null,
        Description -> "The samples that we are imaging microbial colonies from.",
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
      SampleOutLabel -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[_String],
        Description -> "For each member of SampleLink, the label of the sample that becomes the SamplesOut.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      ContainerOutLabel -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[_String],
        Description -> "For each member of SampleLink, the label of the container that holds the sample that becomes the SamplesOut.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      ImagingInstrument -> {
        Format -> Single,
        Class -> Link,
        Relation -> Alternatives[Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]],
        Pattern :> _Link,
        Description -> "The colony handler that is used to image colonies on solid media.",
        Category -> "General",
        Abstract -> True
      },
      SpreaderInstrument -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]],
        Description -> "The colony handler instrument that is used to spread the provided samples on solid media to prepare colony samples.",
        Category -> "General"
      },
      Incubator -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Instrument, Incubator], Object[Instrument, Incubator]],
        Description -> "The cell incubator that is used to grow colonies in the desired environment before colonies are imaged.",
        Category -> "General"
      },
      PreparedSample -> {
        Format -> Single,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "Indicates if the provided samples containing microbial cells that are counted have been previously transferred onto a solid media plate and cultivated to grow colonies.",
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
      (* ----------- Analysis -------------- *)
      MinReliableColonyCount -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterEqualP[0, 1],
        Units -> None,
        Description -> "The smallest number of colonies that can be counted on a solid media plate to provide a statistically reliable estimate of the concentration of microorganisms in a sample.",
        Category -> "Analysis & Reports"
      },
      MaxReliableColonyCount -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterEqualP[0, 1],
        Units -> None,
        Description -> "The largest number of colonies that can be counted on a solid media plate beyond which accurate counting becomes impractical and unreliable.",
        Category -> "Analysis & Reports"
      },
      MinDiameter -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The smallest diameter value from which colonies will be included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
        Category -> "Analysis & Reports"
      },
      MaxDiameter -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The largest diameter value from which colonies will be included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
        Category -> "Analysis & Reports"
      },
      MinColonySeparation -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The closest distance included colonies can be from each other from which colonies will be included in in TotalColonyCounts the data and analysis. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
        Category -> "Analysis & Reports"
      },
      MinRegularityRatio -> {
        Format -> Single,
        Class -> Real,
        Pattern :> RangeP[0, 1],
        Description -> "The smallest regularity ratio from which colonies will be included in TotalColonyCounts in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        Category -> "Analysis & Reports"
      },
      MaxRegularityRatio -> {
        Format -> Single,
        Class -> Real,
        Pattern :> RangeP[0, 1],
        Description -> "The largest regularity ratio from which colonies will be included in TotalColonyCounts in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        Category -> "Analysis & Reports"
      },
      MinCircularityRatio -> {
        Format -> Single,
        Class -> Real,
        Pattern :> RangeP[0, 1],
        Description -> "The smallest circularity ratio from which colonies will be included in TotalColonyCounts in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        Category -> "Analysis & Reports"
      },
      MaxCircularityRatio -> {
        Format -> Single,
        Class -> Real,
        Pattern :> RangeP[0, 1],
        Description -> "The largest circularity ratio from which colonies will be included in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        Category -> "Analysis & Reports"
      },
      Populations -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[
          Alternatives[
            ColonySelectionPrimitiveP,
            ColonySelectionFeatureP,
            All
          ]
        ],
        Description -> "For each member of SampleLink, the criteria used to group colonies together into a population. Criteria are based on the ordering of colonies by the desired feature(s): Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen, or all colonies are grouped.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      PopulationCellTypes -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[Alternatives[Bacterial, Yeast]],
        Description -> "For each member of SampleLink, the cell types that are thought to be represent the physiological characteristics defined in Populations.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      PopulationIdentities -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[Alternatives[_String, ObjectP[]]],
        Description -> "For each member of SampleLink, the molecular constituents are thought to be represent the physiological characteristics defined in Populations.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      (* ----------- Spreading -------------- *)
      DilutionType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> DilutionTypeP,
        Description -> "For each member of SampleLink, indicates the type of dilution performed on the sample. Linear dilution represents a single stage dilution of the Analyte in the sample to a specified concentration or by a specified dilution factor. Serial dilution represents a stepwise dilution of the Analyte in the sample resulting in multiple samples and a geometric progression of the concentration.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      DilutionStrategy -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> DilutionStrategyP,
        Description -> "For each member of SampleLink, indicates if only the final sample (Endpoint) or all diluted samples (Series) produced by serial dilution are used for spreading on solid media plate.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      NumberOfDilutions -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterEqualP[1],
        Description -> "For each member of SampleLink, the number of diluted samples to prepare.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      CumulativeDilutionFactor -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[RangeP[1, 10^23] | Null],
        Description -> "For each member of SampleLink, the factor by which the concentration of the TargetAnalyte in the original sample is reduced during the dilution.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      SerialDilutionFactor -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[RangeP[1, 10^23] | Null],
        Description -> "For each member of SampleLink, the factor by which the concentration of the TargetAnalyte in the resulting sample of the previous dilution step is reduced.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      ColonySpreadingTool -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Part, ColonyHandlerHeadCassette], Object[Part, ColonyHandlerHeadCassette]],
        Description -> "For each member of SampleLink, the tool used to spread the suspended cells from the input sample onto the destination plate or into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      SpreadVolume -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Microliter],
        Units -> Microliter,
        Description -> "For each member of SampleLink, the volume of suspended cells transferred to and spread on the agar gel.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      DispenseCoordinates -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {{DistanceP, DistanceP}..},
        Description -> "For each member of SampleLink, the location(s) the suspended cells are dispensed on the destination plate before spreading.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      SpreadPatternType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> SpreadPatternP,
        Description -> "For each member of SampleLink, the pattern the spreading colony handler head will move when spreading the colony on the plate.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      CustomSpreadPattern -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[Spread[ListableP[CoordinatesP]]],
        Description -> "For each member of SampleLink, the user defined pattern used to spread the suspended cells across the plate.",
        IndexMatching -> SampleLink,
        Category -> "Spreading"
      },
      DestinationContainerLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container], Model[Container]],
        Description -> "For each member of SampleLink, the desired type of container to have suspended cells spread in, with indices indicating grouping of samples in the same plate, if desired.",
        IndexMatching -> SampleLink,
        Category -> "Spreading",
        Migration -> SplitField
      },
      DestinationContainerExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {_Integer, ObjectP[{Model[Container], Object[Container]}]|_String},
        Description -> "For each member of SampleLink, the desired type of container to have suspended cells spread in, with indices indicating grouping of samples in the same plate, if desired.",
        IndexMatching -> SampleLink,
        Category -> "Spreading",
        Migration -> SplitField
      },
      DestinationContainerString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the desired type of container to have suspended cells spread in, with indices indicating grouping of samples in the same plate, if desired.",
        IndexMatching -> SampleLink,
        Category -> "Spreading",
        Migration -> SplitField
      },
      DestinationMediaLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample], Model[Sample]],
        Description -> "For each member of SampleLink, the media on which the cells are spread.",
        IndexMatching -> SampleLink,
        Category -> "Spreading",
        Migration -> SplitField
      },
      DestinationMediaString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the media on which the cells are spread.",
        IndexMatching -> SampleLink,
        Category -> "Spreading",
        Migration -> SplitField
      },
      (* ----------- Incubation -------------- *)
      IncubationConditionLink -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Model[StorageCondition],
        Description -> "The default incubation condition with desired Temperature, CarbonDioxide, RelativeHumidity, ShakingRate etc under which the colony samples will be stored inside of the incubator.",
        Category -> "Incubation",
        Migration -> SplitField
      },
      IncubationConditionExpression -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> Alternatives[SampleStorageTypeP, Custom],
        Description -> "The default incubation condition with desired Temperature, CarbonDioxide, RelativeHumidity, ShakingRate etc under which the colony samples will be stored inside of the incubator.",
        Category -> "Incubation",
        Migration -> SplitField
      },
      Temperature -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Kelvin],
        Units -> Celsius,
        Description -> "Temperature at which the colony samples are incubated.",
        Category -> "Incubation"
      },
      ColonyIncubationTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterEqualP[0 Hour],
        Units -> Hour,
        Description -> "The duration during which the colony samples are incubated inside of cell incubators before imaging.",
        Category -> "Incubation"
      },
      IncubationInterval -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Hour],
        Units -> Hour,
        Description -> "The duration during which colony samples are placed inside a cell incubator as part of repeated cycles of incubation, imaging, and analysis.",
        Category -> "Incubation"
      },
      MaxColonyIncubationTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterEqualP[0 Hour],
        Units -> Hour,
        Description -> "The maximum duration during which the colony samples are allowed to be incubated inside of cell incubator.",
        Category -> "Incubation"
      },
      IncubateUntilCountable -> {
        Format -> Single,
        Class -> Boolean,
        Pattern :> BooleanP,
        Relation -> Null,
        Description -> "Indicates whether colony samples should undergo repeated cycles of incubation, imaging, and analysis.",
        Category -> "Incubation"
      },
      NumberOfStableIntervals -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> RangeP[1, 5],
        Relation -> Null,
        Description -> "The number of additional intervals used to determine if the TotalColonyCounts remain stable (do not increase) before stopping the experiment.",
        Category -> "Incubation"
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
      AllColonyAnalyses -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Analysis, Colonies]],
        Description -> "A list of the colony analyses performed on the source plate images taken by the QPix.",
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
        Relation -> Alternatives[Object[UnitOperation, QuantifyColonies]],
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
      ColonyAnalyses -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Analysis, Colonies]]...},
        Description -> "For each member of SampleLink, a list of the colony analyses performed on the images of the sample taken by the QPix.",
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