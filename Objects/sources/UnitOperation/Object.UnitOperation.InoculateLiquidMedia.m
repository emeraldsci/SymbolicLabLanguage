(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, InoculateLiquidMedia],
  {
    Description -> "A protocol for transferring cells (e.g., cell suspension or inoculum) into fresh liquid media to initiate culture growth.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
      (* --------- General ----------- *)
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
        Description -> "The samples that we are transferring source cells from.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The samples that we are transferring source cells from.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
        Relation -> Null,
        Description -> "The samples that we are transferring source cells from.",
        Category -> "General",
        Migration -> SplitField
      },
      SampleLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The label of the Sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General"
      },
      SampleContainerLabel -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Relation -> Null,
        Description -> "The label of the Sample container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General"
      },
      InoculationSource -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> InoculationSourceP,
        Description -> "The type of the media (Solid, Liquid, AgarStab, FreezeDried, or FrozenGlycerol) where the source cells are stored before the experiment.",
        Category -> "General"
      },
      Instrument -> {
        Format -> Multiple,
        Class -> Link,
        Relation -> Alternatives[Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler], Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler], Object[Instrument, Pipette], Model[Instrument, Pipette]],
        Pattern :> _Link,
        Description -> "For each member of SampleLink, the instrument that is used to transfer cells (e.g., cell suspension or inoculum) into fresh liquid media to initiate culture growth.",
        IndexMatching -> SampleLink,
        Category -> "General"
      },
      TransferEnvironment -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Model[Instrument, BiosafetyCabinet],
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, HandlingStation, BiosafetyCabinet],
          Object[Instrument, HandlingStation, BiosafetyCabinet]
        ],
        Description -> "For each member of SampleLink, the environment in which the inoculation is performed for the input sample (e.g., cell suspension or inoculum).",
        Category -> "General"
      },
      DestinationMediaContainerLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container], Model[Container]],
        Description -> "For each member of SampleLink, the container containing liquid media into which the cells are deposited.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMediaContainerExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {(ObjectP[{Object[Container], Model[Container]}] | {ObjectP[Object[Container]]..} | (_String))..},
        Description -> "For each member of SampleLink, the container containing liquid media into which the cells are deposited.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMediaContainerString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the container containing liquid media into which the cells are deposited.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMix -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[BooleanP],
        Description -> "For each member of SampleLink, indicates if mixing is performed immediately after the input sample (e.g., cell suspension or inoculum) is dispensed into the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Deposit"
      },
      DestinationMixType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[InoculationMixTypeP|Null],
        Description -> "For each member of SampleLink, the type of mixing that is performed immediately after the input sample (e.g., cell suspension or inoculum) is dispensed into the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Deposit"
      },
      DestinationNumberOfMixesInteger -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> RangeP[0,50,1],
        Description -> "For each member of SampleLink, the number of times the cells are mixed in the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationNumberOfMixesExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[RangeP[0, 50, 1], Null]..},
        Description -> "For each member of SampleLink, the number of times the cells are mixed in the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMixVolumeReal -> {
        Format -> Multiple,
        Class -> Real,
        Units -> Microliter,
        Pattern :> GreaterP[0 Microliter],
        Description -> "For each member of SampleLink, the volume that is repeatedly aspirated and dispensed via pipetting from the destination sample in order to mix the destination sample immediately after the inoculation occurs.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMixVolumeExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[GreaterP[0 Microliter], Null]..},
        Description -> "For each member of SampleLink, the volume that is repeatedly aspirated and dispensed via pipetting from the destination sample in order to mix the destination sample immediately after the inoculation occurs.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      MediaVolumeReal -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Microliter],
        Units -> Microliter,
        Description -> "For each member of SampleLink, the amount of suspended source cells to transfer to the destination container. Applicable only when the input sample is in liquid form or resuspended from freeze-dried powder.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      MediaVolumeExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[GreaterP[0 Microliter], Null]..},
        Description -> "For each member of SampleLink, the amount of suspended source cells to transfer to the destination container. Applicable only when the input sample is in liquid form or resuspended from freeze-dried powder.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMediaLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample], Model[Sample]],
        Description -> "For each member of SampleLink, the liquid, nutrient-rich solution added to the destination container to provide the necessary conditions for cell growth following inoculation.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMediaString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the liquid, nutrient-rich solution added to the destination container to provide the necessary conditions for cell growth following inoculation.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      DestinationMediaExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], ListableP[Null], _String]..},
        Description -> "For each member of SampleLink, the liquid, nutrient-rich solution added to the destination container to provide the necessary conditions for cell growth following inoculation.",
        IndexMatching -> SampleLink,
        Category -> "Deposit",
        Migration -> SplitField
      },
      ResuspensionMix -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> BooleanP,
        Description -> "For each member of SampleLink, indicates if the cells in resuspension is mixed after adding ResuspensionMedia to the source sample.",
        IndexMatching -> SampleLink,
        Category -> "Resuspension"
      },
      NumberOfResuspensionMixes -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0],
        Units -> None,
        Description -> "For each member of SampleLink, the number of times that the cells in resuspension is mixed after adding ResuspensionMedia to the source sample.",
        Category -> "Aspirate",
        IndexMatching -> SampleLink
      },
      ResuspensionMixVolume -> {
        Format -> Multiple,
        Class -> Real,
        Units -> Microliter,
        Pattern :> GreaterP[0 Microliter],
        Description -> "For each member of SampleLink, the volume that will be repeatedly aspirated and dispensed via pipette from the cells in resuspension in order to mix after adding ResuspensionMedia to the source sample. The same pipette and tips used to add the ResuspensionMedia will be used to mix the cell resuspension.",
        IndexMatching -> SampleLink,
        Category -> "Resuspension"
      },
      ResuspensionMediaLink -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Sample], Model[Sample]],
        Description -> "For each member of SampleLink, the media to add to the source samples in order to resuspend the cells.",
        IndexMatching -> SampleLink,
        Category -> "Resuspension",
        Migration -> SplitField
      },
      ResuspensionMediaString -> {
        Format -> Multiple,
        Class -> String,
        Pattern :> _String,
        Description -> "For each member of SampleLink, the media to add to the source samples in order to resuspend the cells.",
        IndexMatching -> SampleLink,
        Category -> "Resuspension",
        Migration -> SplitField
      },
      ResuspensionMediaVolume -> {
        Format -> Multiple,
        Class -> Real,
        Units -> Microliter,
        Pattern :> GreaterP[0 Microliter],
        Description -> "For each member of SampleLink, the amount of liquid media added to the source samples in order to resuspend the cells.",
        IndexMatching -> SampleLink,
        Category -> "Resuspension"
      },
      NumberOfSourceScrapes->{
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0],
        Units -> None,
        Description -> "For each member of SampleLink, the number of times that the sample is scraped with the tip before it is dipped into the liquid media and swirled.",
        Category -> "Aspirate",
        IndexMatching -> SampleLink
      },
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
        Description -> "For each member of SampleLink, the smallest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MaxDiameter -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the largest diameter value from which colonies will be included. The diameter is defined as the diameter of a circle with the same area as the colony.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinColonySeparation -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "For each member of SampleLink, the closest distance included colonies can be from each other from which colonies will be included. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinRegularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the smallest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MaxRegularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the largest regularity ratio from which colonies will be included. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MinCircularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the smallest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
      },
      MaxCircularityRatio -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> RangeP[0,1],
        Description -> "For each member of SampleLink, the largest circularity ratio from which colonies will be included. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
        IndexMatching -> SampleLink,
        Category -> "Selection"
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
      ColonyPickingTool -> {
        Format -> Multiple,
        Class -> Link,
        Relation -> Alternatives[Model[Part, ColonyHandlerHeadCassette], Object[Part, ColonyHandlerHeadCassette]],
        Pattern :> _Link,
        Description -> "For each member of SampleLink, the part used to collect the source colonies and deposit them into a destination well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      NumberOfHeads -> {
        Format -> Multiple,
        Class -> Integer,
        Pattern :> GreaterP[0,1],
        Description -> "For each member of SampleLink, the number of metal probes on the ColonyHandlerHeadCassette that will pick the colonies.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      ColonyPickingDepth -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[GreaterP[0 Millimeter] | Null],
        Description -> "For each member of SampleLink, the deepness to reach into the agar when collecting a colony.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      PickCoordinates -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :>  {{DistanceP, DistanceP}..}|Null,
        Description -> "For each member of SampleLink, the coordinates, in Millimeters, from which colonies will be collected from the source plate where {0 Millimeter, 0 Millimeter} is the center of the source well.",
        IndexMatching -> SampleLink,
        Category -> "Picking"
      },
      DestinationFillDirection -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> DestinationFillDirectionP,
        Description -> "Indicates if the destination will be filled with picked colonies in row order or column order.",
        Category -> "Placing"
      },
      MaxDestinationNumberOfColumns -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[GreaterP[0,1]|Null],
        Description -> "For each member of SampleLink, the number of columns of colonies to deposit in the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
      MaxDestinationNumberOfRows -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[GreaterP[0,1]|Null],
        Description -> "For each member of SampleLink, the number of rows of colonies to deposit in the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Placing"
      },
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
        Relation -> Alternatives[Object[Sample], Model[Sample]],
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
        Relation -> Alternatives[Object[Sample], Model[Sample]],
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
        Relation -> Alternatives[Object[Sample], Model[Sample]],
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
        Relation -> Alternatives[Object[Sample], Model[Sample]],
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
        Pattern :> GreaterP[0,Second],
        Units -> Second,
        Description -> "For each member of SampleLink, the length of time the ColonyHandlerHeadCassette is dried over the halogen fan after the cassette is washed in QuaternaryWashSolution.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization"
      },
      VolumeReal -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Microliter],
        Units -> Milliliter,
        Description -> "For each member of SampleLink, if the source cells are in liquid media, the amount of source cells to transfer to the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      VolumeExpression -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> Alternatives[All],
        Description -> "For each member of SampleLink, if the source cells are in liquid media, the amount of source cells to transfer to the destination container.",
        IndexMatching -> SampleLink,
        Category -> "Sanitization",
        Migration -> SplitField
      },
      InoculationTips -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Model[Item, Tips],
          Object[Item, Tips]
        ],
        Description -> "For each member of SampleLink, the pipette tip attached to a manual pipette instrument or robotic hamilton workcell during inoculation to aspirate and dispense the cells.",
        IndexMatching -> SampleLink,
        Category -> "Inoculation"
      },
      InoculationTipType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> TipTypeP,
        Description -> "For each member of SampleLink, the type of pipette tips used to aspirate and dispense the cells during the inoculation.",
        Category -> "Inoculation",
        IndexMatching -> SampleLink
      },
      InoculationTipMaterial -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> MaterialP,
        Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the cells during the inoculation.",
        Category -> "General",
        IndexMatching -> SampleLink
      },
      SourceMix -> {
        Format -> Multiple,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "For each member of SampleLink, indicates if mixing of the cells in liquid media will occur during aspiration from the source sample.",
        Category -> "Inoculation",
        IndexMatching -> SampleLink
      },
      SourceMixType -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> Pipette|Swirl,
        Description -> "For each member of SampleLink, the type of mixing that is performed in the container of the input sample before the inoculation. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform DestinationNumberOfMixes clockwise rotations of the container.",
        Category -> "Inoculation",
        IndexMatching -> SampleLink
      },
      NumberOfSourceMixes -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0],
        Units -> None,
        Description -> "For each member of SampleLink, the number of times that the source cells will be mixed during aspiration.",
        Category -> "Inoculation",
        IndexMatching -> SampleLink
      },
      SourceMixVolume -> {
        Format -> Multiple,
        Class -> Real,
        Pattern :> GreaterP[0 Microliter],
        Units -> Microliter,
        Description -> "For each member of SampleLink, the volume that will be repeatedly aspirated and dispensed via pipette from the source cells in order to mix the source cells immediately before the inoculation occurs. The same pipette and tips used in the inoculation will be used to mix the source cells.",
        Category -> "Inoculation",
        IndexMatching -> SampleLink
      },
      SampleOutLabel -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[ListableP[ListableP[{(_String|Null)..}|_String|Null]]],
        Description -> "For each member of SampleLink, the labels of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        IndexMatching -> SampleLink,
        Migration -> NMultiple
      },
      ContainerOutLabel->{
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[ListableP[{Alternatives[_String, Null]..}|_String|Null]],
        Description -> "For each member of SampleLink, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
        Category -> "General",
        IndexMatching -> SampleLink,
        Migration -> NMultiple
      },
      SamplesOut -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[ListableP[ObjectP[Object[Sample]]]],
        Description -> "For each member of SampleLink, the samples that were be created in this experiment.",
        Category -> "General",
        IndexMatching -> SampleLink,
        Migration -> NMultiple
      },
      ContainersOut -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> ListableP[ListableP[ObjectP[Object[Container]]]],
        Description -> "For each member of SampleLink, the containers of the samples that were be created in this experiment.",
        Category -> "General",
        IndexMatching -> SampleLink,
        Migration -> NMultiple
      },
      (* Developer *)
      DestinationMediaContainerResources -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
          Object[Container],
          Model[Container],
          Model[Sample],
          Object[Sample]
        ],
        Description -> "The desired container to have stabbed cells deposited in.",
        Category -> "General",
        Developer -> True
      },
      (* Data and Analysis *)
      (* These are the flat fields *)
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
      (* These are the batched fields *)
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
        Relation -> Alternatives[Model[Container, ColonyHandlerHeadCassetteHolder], Object[Container, ColonyHandlerHeadCassetteHolder]],
        Description -> "The list of ColonyHandlerHeadCassetteHolder used as the container for the ColonyHandlerHeadCassette.",
        Category -> "General",
        Developer -> True
      },
      CarrierAndRiserInitialResources -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container, Rack], Model[Container, Rack]],
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
        Relation -> {Alternatives[Object[Part, ColonyHandlerHeadCassette], Model[Part, ColonyHandlerHeadCassette]], Alternatives[Object[Container], Model[Container]], Null},
        Description -> "The placement for removing the final colony handler head cassette at the end of the output unit operation loop.",
        Category -> "General",
        Developer -> True,
        Headers -> {"Object to Place", "Destination Object","Destination Position"}
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
      (* BatchedUnitOperation *)
      BatchedUnitOperations -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[UnitOperation, InoculateLiquidMedia]],
        Description -> "The physical batches split by destination containers that can fit on the deck at once.",
        Category -> "General",
        Developer -> True
      },
      (* NOTE: The fields below will only be filled out for unit operations that are in the BatchedUnitOperations field of another Object[UnitOperation,InoculateLiquidMedia] *)
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
        Headers -> {"Object", "Position"},
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
      FlatBatchedPickCoordinates -> {
        Format -> Multiple,
        Class -> Expression,
        Pattern :> {{DistanceP, DistanceP}..}|Null,
        Description -> "The lists of predetermined pick coordinates corresponding to the flat batched source samples.",
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
        Pattern :> ListableP[{ObjectP[Object[Sample]], Alternatives[
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
        Relation -> {Alternatives[Object[Container], Model[Container]], Null},
        Headers -> {"Riser","Placement Location"},
        Description -> "A list of deck placements used to place any needed risers on the qpix deck at the beginning of the physical batch.",
        Category -> "General",
        Developer -> True
      },
      CarrierDeckPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Container], Model[Container]], Null},
        Headers -> {"Carrier", "Placement Location"},
        Description -> "A list of deck placements used to place any needed carriers on the qpix deck at the beginning of the physical batch.",
        Category -> "General",
        Developer -> True
      },
      RiserReturns -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container]],
        Description -> "A list of qpix risers to remove from the deck at the beginning of the batch.",
        Category -> "General",
        Developer -> True
      },
      CarrierReturns -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Container]],
        Description -> "A list of qpix carriers to remove from the deck at the beginning of the batch.",
        Category -> "General",
        Developer -> True
      },
      ColonyHandlerHeadCassette -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Part, ColonyHandlerHeadCassette], Model[Part, ColonyHandlerHeadCassette]],
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
        Relation -> {Alternatives[Object[Part, ColonyHandlerHeadCassette],Model[Part, ColonyHandlerHeadCassette]], Alternatives[Object[Instrument], Model[Instrument]], Null},
        Description -> "The placement used to place the colony picking tool for the current batch.",
        Category -> "General",
        Developer -> True,
        Headers->{"Object to Place", "Destination Object","Destination Position"}
      },
      ColonyHandlerHeadCassetteReturn -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Part, ColonyHandlerHeadCassette], Model[Part, ColonyHandlerHeadCassette]],
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
        Relation -> {Alternatives[Object[Part, ColonyHandlerHeadCassette], Model[Part, ColonyHandlerHeadCassette]], Alternatives[Object[Container], Model[Container]], Null},
        Description -> "The placement used to remove the colony picking tool from the colony handler and move it back to its holder once this batch is complete.",
        Category -> "General",
        Developer -> True,
        Headers->{"Object to Place", "Destination Object","Destination Position"}
      },
      DestinationContainerDeckPlacements -> {
        Format -> Multiple,
        Class -> {Link, Expression},
        Pattern :> {_Link, {LocationPositionP..}},
        Relation -> {Alternatives[Object[Container]], Null},
        Headers -> {"Object", "Position"},
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
        Pattern :> {_Association, _List},
        Description -> "A list of all of the pick lists and the corresponding source samples that were completed for this physical batch.",
        Category -> "General",
        Developer -> True
      },
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
      },
      AnalyzeColoniesObjects -> {
        Format -> Multiple,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[Object[Analysis, Colonies]],
        Description -> "For each plate in the batched unit operation, the colony analysis object that determined the pick locations.",
        Category -> "General",
        Developer -> True
      }
    }
  }
]