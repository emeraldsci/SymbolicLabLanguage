(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)
DefineObjectType[Object[UnitOperation,PickColonies],
  {
    Description -> "A detailed set of parameters for picking microbial colonies growing on solid media and depositing them in a liquid media or on a solid media.",
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
        Description -> "The samples that we are picking microbial colonies from.",
        Category -> "General",
        Migration->SplitField
      },
      SampleString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The samples that we are picking microbial colonies from.",
        Category -> "General",
        Migration->SplitField
      },
      SampleExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
        Relation -> Null,
        Description -> "The samples that we are picking microbial colonies from.",
        Category -> "General",
        Migration->SplitField
      },

      Instrument -> {
        Format -> Single,
        Class -> Link,
        Relation -> Alternatives[Model[Instrument,ColonyHandler],Object[Instrument,ColonyHandler]],
        Pattern :> _Link,
        Description -> "The robotic instrument that is used to transfer colonies incubating on solid media to fresh liquid or solid media.",
        Category -> "General"
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

      (* ---------------- Selection --------------- *)
      Populations -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[
          Alternatives[
            CustomCoordinates,
            ColonySelectionPrimitiveP,
            ColonySelectionFeatureP,
            All,
            Null
          ]
        ],
        Description -> "For each member of SampleLink, the criteria used to group colonies together into a population. Criteria are based on the ordering of colonies by the desired feature(s): Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen, or all colonies and colonies at custom coordinates are grouped.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinDiameter -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the smallest diameter value from which colonies will be considered for picking. The diameter is defined as the diameter of a circle with the same area as the colony.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MaxDiameter -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the largest diameter value from which colonies will be considered for picking. The diameter is defined as the diameter of a circle with the same area as the colony.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinColonySeparation -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the closest distance included colonies can be from each other from which colonies will be considered for picking. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinRegularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the smallest regularity ratio from which colonies will be considered for picking. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MaxRegularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the largest regularity ratio from which colonies will be considered for picking. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinCircularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the smallest circularity ratio from which colonies will be considered for picking. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MaxCircularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the largest circularity ratio from which colonies will be considered for picking. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },

      (* ---------- Picking ------------ *)
      ColonyPickingTool -> {
        Format -> Multiple,
        Class -> Link,
        Relation -> Alternatives[Model[Part,ColonyHandlerHeadCassette],Object[Part,ColonyHandlerHeadCassette]],
        Pattern :> _Link,
        Description -> "For each member of SampleLink, the tool used to stab the source colonies plates from SampleLink and either deposit any material stuck to the picking head onto the destination plate or into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      HeadDiameter -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the width of the metal probe used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      HeadLength -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the length of the metal probe used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      NumberOfHeads -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the number of metal probes on the ColonyHandlerHeadCassette used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      ColonyHandlerHeadCassetteApplication -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ColonyHandlerHeadCassetteTypeP,
        Description -> "For each member of SampleLink, the designed use of the ColonyPickingTool used to stab the source colonies and deposit any material stuck to the probe onto the destination plate or into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      ColonyPickingDepth -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[GreaterP[0 Millimeter]],
        Description -> "For each member of SampleLink, the distance the picking head penetrates into the agar when picking a colony.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      PickCoordinates -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :>  {{DistanceP,DistanceP}..}|Null,
        Description -> "For each member of SampleLink, the coordinates, in Millimeters, from which colonies will be picked from the source plate where {0 Millimeter, 0 Millimeter} is the center of the source well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },

      (* -------- Placing --------- *)
      DestinationMediaType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[DestinationMediaTypeP],
        Description -> "For each member of SampleLink, the type of media (liquid or solid) the picked colonies will be transferred in to.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
      DestinationMediaLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample],Model[Sample]],
        Description -> "For each member of SampleLink, the media in which the picked colonies should be placed.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationMediaString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the media in which the picked colonies should be placed.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationMediaExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _String]..},
        Description -> "For each member of SampleLink, the media in which the picked colonies should be placed.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationMediaContainerLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container],Model[Container]],
        Description -> "For each member of SampleLink, the desired container to have picked colonies deposited in.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationMediaContainerExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {(ObjectP[{Object[Container],Model[Container]}] | {ObjectP[Object[Container]]..})..},
        Description -> "For each member of SampleLink, the desired container to have picked colonies deposited in.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationFillDirection -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> DestinationFillDirectionP,
        Description -> "For each member of SampleLink, indicates if the DestinationMediaContainer is filled with picked colonies in row order, column order, or by custom coordinates. Row/Column completely fills spots in available row/column before moving to the next. If set to CustomCoordinates, ignores MaxDestinationNumberOfColumns and MaxDestinationNumberOfRows to fill at locations specfied by DestinationCoordinates.",
        Category -> "Placing"
      },
      MaxDestinationNumberOfColumns -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the maximum number of columns of colonies deposited in the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
      MaxDestinationNumberOfRows -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the maximum number of rows of colonies deposited in the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
      DestinationCoordinates -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :>  ListableP[ListableP[{DistanceP,DistanceP}|{Null,Null}|Null]],
        Description -> "For each member of SampleLink, the xy coordinates, in Millimeters, where the picked colonies are deposited on solid media where {0 Millimeter, 0 Millimeter} is the center of the destination well.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
      MediaVolumeReal -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Microliter],
        Units -> Microliter,
        Description -> "For each member of SampleLink, the starting amount of liquid media in which the picked colonies are deposited prior to the colonies being added.", (* If doing Nulls and volumes doesn't work just do 0 Microliter for solid and explain in description *)
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      MediaVolumeExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[GreaterP[0 Microliter],Null] ..},
        Description -> "For each member of SampleLink, the starting amount of liquid media in which the picked colonies are deposited prior to the colonies being added.", (* If doing Nulls and volumes doesn't work just do 0 Microliter for solid and explain in description *)
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationMix -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[BooleanP],
        Description -> "For each member of SampleLink, indicates if the picking head is swirled in the destination plate while inoculating the liquid media. DestinationMix is only applicable when Destination -> LiquidMedia.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
      DestinationNumberOfMixesInteger -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> RangeP[0,50,1],
        Description -> "For each member of SampleLink, the number of times the picking pin is swirled in the liquid media during inoculation.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },
      DestinationNumberOfMixesExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[RangeP[0, 50, 1],Null]..},
        Description -> "For each member of SampleLink, the number of times the picking pin is swirled in the liquid media during inoculation.",
        IndexMatching -> SampleLink,
        Category -> "Placing",
        Migration -> SplitField
      },

      (* --------- Sanitization ---------- *)
      PrimaryWash -> {
        Format -> Multiple,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "For each member of SampleLink, indicates if the PrimaryWash stage should be turned on during the sanitization process.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      PrimaryWashSolutionLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample],Model[Sample]],
        Description -> "For each member of SampleLink, the first wash solution that is used during the sanitization process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      PrimaryWashSolutionString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the first wash solution that is used during the sanitization process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      NumberOfPrimaryWashes -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the PrimaryWashSolution to clean any material off the head.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      PrimaryDryTime -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Second],
        Units -> Second,
        Description -> "For each member of SampleLink, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in PrimaryWashSolution.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      SecondaryWash -> {
        Format -> Multiple,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "For each member of SampleLink, indicates if the SecondaryWash stage should be turned on during the sanitization process.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      SecondaryWashSolutionLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample],Model[Sample]],
        Description -> "For each member of SampleLink, the second wash solution that can be used during the sanitization process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      SecondaryWashSolutionString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the second wash solution that can be used during the sanitization process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      NumberOfSecondaryWashes -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the SecondaryWashSolution to clean any material off the head.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      SecondaryDryTime -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Second],
        Units -> Second,
        Description -> "For each member of SampleLink, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in SecondaryWashSolution.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      TertiaryWash -> {
        Format -> Multiple,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "For each member of SampleLink, indicates if the TertiaryWash stage should be turned on during the sanitization process.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      TertiaryWashSolutionLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample],Model[Sample]],
        Description -> "For each member of SampleLink, the third wash solution that can be used during the sanitization process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      TertiaryWashSolutionString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the third wash solution that can be used during the sanitization process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      NumberOfTertiaryWashes -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the TertiaryWashSolution to clean any material off the head.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      TertiaryDryTime -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Second],
        Units -> Second,
        Description -> "For each member of SampleLink, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in TertiaryWashSolution.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      QuaternaryWash -> {
        Format -> Multiple,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "For each member of SampleLink, indicates if the QuaternaryWash stage should be turned on during the sanitization process.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      QuaternaryWashSolutionLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample],Model[Sample]],
        Description -> "For each member of SampleLink, the fourth wash solution that can be used during the process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      QuaternaryWashSolutionString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the fourth wash solution that can be used during the process prior to each round of picking.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      NumberOfQuaternaryWashes -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the number of times the ColonyHandlerHeadCassette moves in a circular motion in the QuaternaryWashSolution to clean any material off the head.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      QuaternaryDryTime -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Second],
        Units -> Second,
        Description -> "For each member of SampleLink, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in QuaternaryWashSolution.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },

      SampleOutLabel->{
        Format->Multiple,
        Class->Expression,
        Pattern:>ListableP[ListableP[ListableP[{(_String|Null)..}|_String|Null]]],
        Description->"For each member of SampleLink, the labels of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        IndexMatching->SampleLink,
        Migration->NMultiple
      },
      ContainerOutLabel->{
        Format->Multiple,
        Class->Expression,
        Pattern:>ListableP[ListableP[{Alternatives[_String,Null]..}|_String|Null]],
        Description->"For each member of SampleLink, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category->"General",
        IndexMatching->SampleLink,
        Migration->NMultiple
      },

      (* Data and Analysis *)
      (* These are the flat fields *)
      AllImageExposureAnalyses -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Analysis,ImageExposure]],
        Description -> "A list of the exposure analyses performed on the source plate images taken by the QPix.",
        Category -> "Analysis & Reports"
      },
      AllColonyAnalyses -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Analysis,Colonies]],
        Description -> "A list of the colony analyses performed on the source plate images taken by the QPix.",
        Category -> "Analysis & Reports"
      },
      AllColonyAppearanceData -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Data,Appearance,Colonies]],
        Description -> "A list of the data objects containing the images of the source plates taken by the QPix.",
        Category -> "Analysis & Reports"
      },
      (* These are the batched fields *)
      ImageExposureAnalyses -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Analysis,ImageExposure]]...},
        Description -> "For each member of SampleLink, a list of the exposure analyses performed on the images of the sample taken by the QPix.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      ColonyAnalyses -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Analysis,Colonies]]...},
        Description -> "For each member of SampleLink, a list of the colony analyses performed on the images of the sample taken by the QPix.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      ColonyAppearanceData -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Data,Appearance,Colonies]]...},
        Description -> "For each member of SampleLink, a list of the data objects containing the images of the sample taken by the QPix.",
        IndexMatching -> SampleLink,
        Category -> "Analysis & Reports"
      },
      (* -------------- Developer -------------- *)
      (* OutputUnitOperation *)
      PopulateDestContainerUnitOps -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> {SamplePreparationP...},
        Description -> "A LabelContainer unit operation to label model containers and a Transfer unit operation to fill any destination media containers with media before picking.",
        Category -> "General",
        Developer -> True
      },
      DestinationMediaContainers -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container], Model[Container]],
        Description -> "A flat list of all of the destination containers required for this experiment.",
        Category -> "General",
        Developer ->True
      },
      WellReservations -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> _List,
        Description -> "A list of tuples where each tuple contains a list of the wells of a specific plate a particular population has reserved.",
        Category -> "General",
        Developer -> True
      },
      ModelContainerReservations -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> _Association,
        Description -> "An association where they keys are model container's and the value is a list of {Sample, Population, numberOfModels} tuples that represent how many {n,model container} each model container corresponds to for a population.",
        Category -> "General",
        Developer -> True
      },
      ModelContainerPositionLabelMap -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> _List,
        Description -> "A list of rules that map a model container position to corresponding labels.",
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
      MediaPreparationProtocol -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Protocol]],
        Description -> "The Subprotocol which populates the destination media containers with media prior to the picking routine.",
        Category -> "General",
        Developer -> True
      },
      CassetteHolderResources -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Container, ColonyHandlerHeadCassetteHolder],Object[Container, ColonyHandlerHeadCassetteHolder]],
        Description -> "The list of ColonyHandlerHeadCassetteHolder used as the container for the ColonyHandlerHeadCassette.",
        Category -> "General",
        Developer -> True
      },
      CarrierAndRiserInitialResources -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container,Rack],Model[Container,Rack]],
        Description -> "The list of carrier and riser objects to pick during the first physical batch of an output unit operation.",
        Category -> "General",
        Developer -> True
      },
      FinalRiserReturns -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container]],
        Description -> "The risers that need to be returned at the end of the unit operation loop.",
        Category -> "General",
        Developer -> True
      },
      FinalCarrierReturns -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container]],
        Description -> "The qpix carriers that need to be returned at the end of the unit operation loop.",
        Category -> "General",
        Developer -> True
      },
      FinalColonyHandlerHeadCassetteReturn -> {
        Format -> Single,
        Class -> {Link, Link, String},
        Pattern :> {_Link, _Link, LocationPositionP},
        Relation -> {Alternatives[Object[Part,ColonyHandlerHeadCassette],Model[Part,ColonyHandlerHeadCassette]], Alternatives[Object[Container],Model[Container]], Null},
        Description -> "The placement for removing the final colony handler head cassette at the end of the output unit operation loop.",
        Category -> "General",
        Developer -> True,
        Headers->{"Object to Place", "Destination Object","Destination Position"}
      },
      AbsorbanceFilter -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Model[Part,OpticalFilter],Object[Part,OpticalFilter]],
        Description -> "The Absorbance filter used for any absorbance imaging in this unit operation.",
        Category -> "General",
        Developer -> True
      },

      (* BatchedUnitOperation *)
      BatchedUnitOperations -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[UnitOperation,PickColonies]],
        Description -> "The physical batches split by destination containers that can fit on the deck at once.",
        Category -> "General",
        Developer -> True
      },
      (* NOTE: The fields below will only be filled out for unit operations that are in the BatchedUnitOperations field of another Object[UnitOperation,PickColonies] *)
      FlatBatchedSourceContainers -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container,Plate], Object[Sample]],
        Description -> "A flat list of the source containers that once batched with the lengths in BatchedSourceContainerLengths, represents which pairs of source containers should be placed on deck at the same time.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedSourceContainerPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Sample]],Null},
        Headers -> {"Object","Position"},
        Description -> "A flat list of the source container placements that once batched with the lengths in BatchedSourceContainerLengths, represents which pairs of source containers should be placed on the deck at the same time.",
        Category -> "General",
        Developer -> True
      },
      BatchedSourceContainerLengths -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
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
        Pattern :> GreaterP[0,1],
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
        Pattern :> GreaterEqualP[0,1],
        Description -> "The length of the batches of any jsons stored in FlatBatchedAbsorbanceRoutineJSONPaths.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedPickCoordinates -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {{DistanceP,DistanceP}..}|Null,
        Description -> "The lists of predetermined pick coordinates corresponding to the flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedImagingChannels -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[QPixFluorescenceWavelengthsP,QPixAbsorbanceWavelengthsP,BrightField]..}|Null,
        Description -> "The lists of imaging channels corresponding to the flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedExposureTimes -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[GreaterP[0 Millisecond],AutoExpose]..}|Null,
        Description -> "The lists of exposure times corresponding to the flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedPopulations -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[Alternatives[
          CustomCoordinates,
          ColonySelectionPrimitiveP
        ]],
        Description -> "The lists of populations corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedSamplePopulationRoutineGroups -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[{ObjectP[Object[Sample]],Alternatives[
          CustomCoordinates,
          FluorescencePrimitiveP,
          AbsorbancePrimitiveP,
          DiameterPrimitiveP,
          CircularityPrimitiveP,
          RegularityPrimitiveP,
          IsolationPrimitiveP,
          AllColoniesPrimitiveP,
          MultiFeaturedPrimitiveP
        ]}],
        Description -> "The flat lists of sample population pairs corresponding to flat the generated pick routine files.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMinDiameters -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The list of minimum diameters corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMaxDiameters -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The list of maximum diameters corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMinColonySeparations -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The list of minimum colony separations corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMinRegularityRatios -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "The list of min regularity ratios corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMaxRegularityRatios -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "The list of max regularity ratios corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMinCircularityRatios -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "The list of min circularity ratios corresponding to flat batched source samples.",
        Category -> "General",
        Developer -> True
      },
      FlatBatchedMaxCircularityRatios -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "The list of max circularity ratios corresponding to flat batched source samples.",
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
      RiserDeckPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Container],Model[Container]], Null},
        Headers -> {"Riser","Placement Location"},
        Description -> "A list of deck placements used to place any needed risers on the qpix deck at the beginning of the physical batch.",
        Category -> "General",
        Developer -> True
      },
      CarrierDeckPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Container],Model[Container]], Null},
        Headers -> {"Carrier", "Placement Location"},
        Description -> "A list of deck placements used to place any needed carriers on the qpix deck at the beginning of the physical batch.",
        Category -> "General",
        Developer -> True
      },
      RiserReturns -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container],Model[Container]],
        Description -> "A list of qpix risers to remove from the deck at the beginning of the batch.",
        Category -> "General",
        Developer -> True
      },
      CarrierReturns -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container],Model[Container]],
        Description -> "A list of qpix carriers to remove from the deck at the beginning of the batch.",
        Category -> "General",
        Developer -> True
      },
      ColonyHandlerHeadCassette -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Part,ColonyHandlerHeadCassette], Model[Part,ColonyHandlerHeadCassette]],
        Description -> "The colony handler head cassette that is used for the physical batch.",
        Category -> "General",
        Developer -> True
      },
      ColonyHandlerHeadCassetteHolder -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container, ColonyHandlerHeadCassetteHolder]],
        Description -> "The colony handler head cassette holder that is used to store the ColonyHandlerHeadCassette for the physical batch.",
        Category -> "General",
        Developer -> True
      },
      ColonyHandlerHeadCassettePlacement -> {
        Format -> Single,
        Class -> {Link, Link, String},
        Pattern :> {_Link, _Link, LocationPositionP},
        Relation -> {Alternatives[Object[Part,ColonyHandlerHeadCassette],Model[Part,ColonyHandlerHeadCassette]], Alternatives[Object[Instrument],Model[Instrument]], Null},
        Description -> "The placement used to place the colony picking tool for the current batch.",
        Category -> "General",
        Developer -> True,
        Headers->{"Object to Place", "Destination Object","Destination Position"}
      },
      ColonyHandlerHeadCassetteReturn -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Part,ColonyHandlerHeadCassette],Model[Part,ColonyHandlerHeadCassette]],
        Description -> "The colony handler head cassette to return to the cart before the new one is placed in the instrument.",
        Category -> "General",
        Developer -> True
      },
      ColonyHandlerHeadCassetteReturnHolder -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container, ColonyHandlerHeadCassetteHolder]],
        Description -> "The colony handler head cassette holder that is used to store the ColonyHandlerHeadCassetteReturn for the physical batch.",
        Category -> "General",
        Developer -> True
      },
      ColonyHandlerHeadCassetteReturnPlacement -> {
        Format -> Single,
        Class -> {Link, Link, String},
        Pattern :> {_Link, _Link, LocationPositionP},
        Relation -> {Alternatives[Object[Part,ColonyHandlerHeadCassette],Model[Part,ColonyHandlerHeadCassette]], Alternatives[Object[Container],Model[Container]], Null},
        Description -> "The placement used to remove the colony picking tool from the colony handler and move it back to its holder once this batch is complete.",
        Category -> "General",
        Developer -> True,
        Headers->{"Object to Place", "Destination Object","Destination Position"}
      },
      DestinationContainerDeckPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Container]],Null},
        Headers -> {"Object","Position"},
        Description -> "The placement of destination containers on the carriers of the qpix for this physical batch.",
        Category -> "General",
        Developer -> True
      },
      IntermediateDestinationContainerDeckPlacements -> {
        Format -> Multiple,
        Class -> {Expression, Expression},
        Pattern :> {ObjectP[Object[Container]] | _String, {LocationPositionP..}},
        Headers -> {"Object or label","Position"},
        Description -> "The placement of destination containers on the carriers of the qpix for this physical batch.",
        Category -> "General",
        Developer -> True
      },
      AllDestinationContainers -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container]],
        Description -> "A list of all of the destination containers that go on the deck for this physical batch.",
        Category -> "General",
        Developer -> True
      },
      AllDestinationContainerStorageConditions -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> Alternatives[SampleStorageTypeP, Disposal, Null],
        Description -> "For each container in AllDestinationContainers, the storage condition of the container after the protocol is completed.",
        Category -> "General",
        Developer -> True
      },
      PickListAssociations -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {_Association,_List},
        Description -> "A list of all of the pick lists and the corresponding source samples that were completed for this physical batch.",
        Category -> "General",
        Developer -> True
      },
      ImageExposureAnalysisObjects -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {ObjectP[Object[Analysis,ImageExposure]]...},
        Description -> "For each plate in the batched unit operation, a list of the image exposure analysis objects that were taken for that plate.",
        Category -> "General",
        Developer -> True
      },
      AppearanceDataObjects -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Data,Appearance,Colonies]],
        Description -> "For each plate in the batched unit operation, the data object containing the final images used for colony analysis.",
        Category -> "General",
        Developer -> True
      },
      AnalyzeColoniesObjects -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Analysis,Colonies]],
        Description -> "For each plate in the batched unit operation, the colony analysis object that determined the pick locations.",
        Category -> "General",
        Developer -> True
      }
    }
  }
];