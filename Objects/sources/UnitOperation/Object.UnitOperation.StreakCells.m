(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

DefineObjectType[Object[UnitOperation,StreakCells], {
  Description -> "A protocol for spreading microbial cells in a liquid media on an agar gel in order to clonally isolate and quantify the cells in the source sample.",
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
      Description -> "The samples that we are spreading on an agar gel.",
      Category -> "General",
      Migration->SplitField
    },
    SampleString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The samples that we are spreading on an agar gel.",
      Category -> "General",
      Migration->SplitField
    },
    SampleExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
      Relation -> Null,
      Description -> "The samples that we are spreading on an agar gel.",
      Category -> "General",
      Migration->SplitField
    },

    SampleLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the label of the Sample that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
      IndexMatching -> SampleLink,
      Category -> "General"
    },
    SampleContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the label of the Sample container that is being used in the experiment, which is used for identification elsewhere in sample preparation.",
      IndexMatching -> SampleLink,
      Category -> "General"
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
    InoculationSource -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> StreakSpreadInoculationSourceP, (* LiquidMedia | FreezeDried | FrozenGlycerol *)
      Description -> "The type of the media (LiquidMedia, FreezeDried, or FrozenGlycerol) where the source cells are stored before the experiment. For the source type of FreezeDried, the samples are resuspended first by adding a liquid media. For the source type of FrozenGlycerol, the samples are scraped from top and resuspended into liquid media by pipette, while the source tube is chilled to remain frozen.",
      Category -> "General"
    },

    Instrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]],
      Description -> "The instrument that is used to transfer cells in suspension to a solid agar gel and then streak the suspension across the plate.",
      Category -> "General"
    },
    (* Preparatory Resuspension *)
    NumberOfSourceScrapes->{
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the frozen glycerol sample is scraped with the tip before it is dipped into the resuspension media and swirled.",
      Category -> "Resuspension",
      IndexMatching -> SampleLink
    },
    ResuspensionMediaLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample],Model[Sample]],
      Description -> "For each member of SampleLink, the liquid media to add to the ResuspensionContainer or source container in order to resuspend the sample. For a source of frozen glycerol, the ResuspensionMedia is added to the ResuspensionContainer before dipping the scraped sample. For a freeze-dried source sample, the ResuspensionMedia is added to the source container directly followed by ResuspensionMix.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension",
      Migration -> SplitField
    },
    ResuspensionMediaString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the liquid media to add to the ResuspensionContainer or source container in order to resuspend the sample. For a source of frozen glycerol, the ResuspensionMedia is added to the ResuspensionContainer before dipping the scraped sample. For a freeze-dried source sample, the ResuspensionMedia is added to the source container directly followed by ResuspensionMix.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension",
      Migration -> SplitField
    },
    ResuspensionMediaVolume -> {
      Format -> Multiple,
      Class -> Real,
      Units -> Microliter,
      Pattern :> GreaterP[0 Microliter],
      Description -> "For each member of SampleLink, the amount of the liquid media added to the ResuspensionMediaContainer in order to resuspend the scraped frozen glycerol sample or the amount of the liquid media added to the freeze-dried sample.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension"
    },
    ResuspensionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container],Model[Container]],
      Description -> "For each member of SampleLink, the desired container to have cells transferred to.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension",
      Migration -> SplitField
    },
    ResuspensionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(ObjectP[{Object[Container],Model[Container]}] | {ObjectP[Object[Container]]..})..},
      Description -> "For each member of SampleLink, the desired container to have cells transferred to.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension",
      Migration -> SplitField
    },
    ResuspensionContainerWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> WellP,
      Description -> "For each member of SampleLink, the well of the ResuspensionMediaContainer to contain the cell resuspension.",
      Category -> "Resuspension",
      IndexMatching -> SampleLink
    },
    ResuspensionMix -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the cells in resuspension is mixed after combining the ResuspensionMedia and the source sample.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension"
    },
    ResuspensionMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Pipette],
      Description -> "For each member of SampleLink, the type of mixing of the cells in resuspension after combining ResuspensionMedia and the source sample. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension"
    },
    NumberOfResuspensionMixes->{
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the cells in resuspension is mixed after combining the ResuspensionMedia and the source sample.",
      Category -> "Aspirate",
      IndexMatching -> SampleLink
    },
    ResuspensionMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Units -> Microliter,
      Pattern :> GreaterP[0 Microliter],
      Description -> "For each member of SampleLink, the volume that will be repeatedly aspirated and dispensed via pipette from the cells in resuspension in order to mix after combining the ResuspensionMedia and the source sample. For freeze-dried source sample, the same pipette and tips used to add the ResuspensionMedia will be used to mix the cell resuspension. For frozen glycerol source sample, the same pipette and tips used to mix the cell resuspension will be used to deposit it onto the solid media.",
      IndexMatching -> SampleLink,
      Category -> "Resuspension"
    },

    (* Preparatory Dilution *)
    DilutionType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> DilutionTypeP,
      Description -> "For each member of SampleLink, indicates the type of dilution performed on the sample. Linear dilution represents a single stage dilution of the Analyte in the sample to a specified concentration or by a specified dilution factor. Serial dilution represents a stepwise dilution of the Analyte in the sample resulting in multiple samples and a geometric progression of the concentration.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionStrategy -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> DilutionStrategyP,
      Description -> "For each member of SampleLink, indicates if only the final sample (Endpoint) or all diluted samples (Series) produced by serial dilution are spread on the DestinationMedia.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    NumberOfDilutions -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1,500,1],
      Description -> "For each member of SampleLink,, the number of diluted samples to prepare.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionTargetAnalyte -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives@@IdentityModelTypes,
      Description -> "For each member of SampleLink, the component in the Composition of the input sample whose concentration is being reduced to TargetAnalyteConcentration.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    CumulativeDilutionFactor -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[RangeP[1,10^23] | Null],
      Description -> "For each member of SampleLink,, the factor by which the concentration of the TargetAnalyte in the original sample is reduced during the dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    SerialDilutionFactor -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[RangeP[1,10^23] | Null],
      Description -> "For each member of SampleLink, the factor by which the concentration of the TargetAnalyte in the resulting sample of the previous dilution step is reduced.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionTargetAnalyteConcentration -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[Alternatives[
        GreaterEqualP[0 Molar],
        GreaterEqualP[0 Gram/Liter],
        GreaterEqualP[0 EmeraldCell/Milliliter],
        GreaterEqualP[0 OD600],
        GreaterEqualP[0 CFU/Milliliter],
        GreaterEqualP[0 RelativeNephelometricUnit],
        GreaterEqualP[0 NephelometricTurbidityUnit],
        GreaterEqualP[0 FormazinTurbidityUnit],
        Null
      ]],
      Description -> "For each member of SampleLink, the desired concentration of TargetAnalyte in the final diluted sample.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionTransferVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Milliliter] | Null],
      Description -> "For each member of SampleLink, if DilutionType is set to LinearDilution, the amount of sample that is diluted with Diluent. If DilutionType is set to Serial, the amount of sample transferred from the resulting sample of one round of the dilution series to the next sample in the series. The first transfer source is the original sample provided.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    TotalDilutionVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Milliliter] | Null],
      Description -> "For each member of SampleLink, the total volume of sample, diluent, concentrated buffer, and concentrated buffer diluent. If DilutionType is set to Serial, this is also the volume of the resulting sample before TransferVolume has been removed for use in the next dilution in the series.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionFinalVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Milliliter] | Null],
      Description -> "For each member of SampleLink, if DilutionType is set to Serial, the volume of the resulting diluted sample after TransferVolume has been removed for use in the next dilution in the series.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionDiscardFinalTransfer -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, if DilutionType is Serial, indicates if, after the final dilution is complete, TransferVolume should be removed from the final dilution container.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DiluentLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample] | Model[Sample],
      Description -> "For each member of SampleLink, the solution used to reduce the concentration of the sample.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    DiluentString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the solution used to reduce the concentration of the sample.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    DiluentVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Milliliter] | Null],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the amount of diluent added to dilute the sample. If DilutionType is set to Serial, the amount of diluent added to dilute the sample at each stage of the dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionConcentratedBufferLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample] | Model[Sample],
      Description -> "For each member of SampleLink, the concentrated buffer which should be diluted by the ConcentratedBufferDilutionFactor in the final solution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    DilutionConcentratedBufferString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the concentrated buffer which should be diluted by the ConcentratedBufferDilutionFactor in the final solution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    ConcentratedBufferVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Milliliter] | Null],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the amount of concentrated buffer added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer added to dilute the sample at each stage of the dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    ConcentratedBufferDiluentLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample] | Model[Sample],
      Description -> "For each member of SampleLink, the solution used to reduce the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor. The ConcentratedBuffer and ConcentratedBufferDiluent are combined and then mixed with the sample.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    ConcentratedBufferDiluentString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the solution used to reduce the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor. The ConcentratedBuffer and ConcentratedBufferDiluent are combined and then mixed with the sample.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    ConcentratedBufferDilutionFactor -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterP[0] | Null],
      Description -> "For each member of SampleLink, the factor by which to reduce ConcentratedBuffer before it is combined with the sample.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    ConcentratedBufferDiluentVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Milliliter] | Null],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the amount of concentrated buffer diluent added to dilute the sample. If DilutionType is set to Serial, the amount of concentrated buffer diluent added to dilute the sample at each stage of the dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionIncubate -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink,For each member of SampleLink, if DilutionType is set to Linear, indicates if the sample is incubated following the dilution. If DilutionType is set to Serial, indicates if the resulting sample after a round of dilution is incubated before moving to the next stage in the dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionIncubationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the duration of time for which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the duration of time for which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionIncubationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives@@Join[MixInstrumentModels,MixInstrumentObjects],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the instrument used to mix/incubate the sample following the dilution. If DilutionType is set to Serial, the instrument used to mix/incubate the resulting sample after a round of dilution before the next stage of dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionIncubationTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the temperature at which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the temperature at which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    DilutionIncubationTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the temperature at which the sample is mixed/incubated following the dilution. If DilutionType is set to Serial, the temperature at which the resulting sample after a round of dilution is mixed/incubated before the next stage of dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution",
      Migration -> SplitField
    },
    DilutionMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MixTypeP,
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the style of motion used to mix the sample following the dilution. If DilutionType is set to Serial, the style of motion used to mix the resulting sample after a round of dilution before the next stage of dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionNumberOfMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[1],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the number of times the sample is mixed following the dilution. If DilutionType is set to Serial, the number of times the resulting sample after a round of dilution is mixed before the next stage of dilution. In both cases, this option applies to discrete mixing processes such as Pipette or Invert.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionMixRate -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 GravitationalAcceleration],
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the frequency of rotation the mixing instrument should use to mix the sample following the dilution. If DilutionType is set to Serial, the frequency of rotation the mixing instrument should use to mix the resulting sample after a round of dilution before the next stage of dilution. In both cases, this option applies to discrete mixing processes such as Pipette or Invert.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },
    DilutionMixOscillationAngle -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 AngularDegree],
      Units -> AngularDegree,
      Description -> "For each member of SampleLink, if DilutionType is set to Linear, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the sample following the dilution. If DilutionType is set to Serial, the angle of oscillation of the mixing motion when a wrist action shaker or orbital shaker is used to mix the resulting sample after a round of dilution before the next stage of dilution.",
      IndexMatching -> SampleLink,
      Category -> "Preparatory Dilution"
    },

    (* Mixing *)
    SourceMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description->"For each member of SampleLink, indicates whether the source should be mixed by pipette before being transferred to the agar gel to be streaked.",
      IndexMatching -> SampleLink,
      Category -> "Mixing"
    },
    SourceMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description->"For each member of SampleLink, the amount of liquid to aspirate and dispense when mixing by pipette before being transferred to the agar gel to be streaked.",
      IndexMatching -> SampleLink,
      Category -> "Mixing"
    },
    NumberOfSourceMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description->"For each member of SampleLink, the number of times the source should be mixed by pipette before being transferred to the agar gel to be streaked.",
      IndexMatching -> SampleLink,
      Category -> "Mixing"
    },

    (* Streaking *)
    StreakVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of suspended cells transferred to and spread on the agar gel.",
      IndexMatching -> SampleLink,
      Category -> "Streaking"
    },
    ColonyStreakingTool -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Part, ColonyHandlerHeadCassette], Object[Part, ColonyHandlerHeadCassette]],
      Description -> "For each member of SampleLink, the tool used to spread the suspended cells from the input sample onto the destination plate or into a destination well.",
      Category -> "Streaking"
    },
    HeadDiameter -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "For each member of SampleLink, the width of the metal probe that will streak the cells.",
      Category -> "Streaking"
    },
    HeadLength -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "For each member of SampleLink, the length of the metal probe that will streak the cells.",
      Category -> "Streaking"
    },
    NumberOfHeads -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "For each member of SampleLink, the number of metal probes on the ColonyHandlerHeadCassette that will streak the cells.",
      Category -> "Streaking"
    },
    ColonyHandlerHeadCassetteApplication -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ColonyHandlerHeadCassetteTypeP,
      Description -> "For each member of SampleLink, the designed use of the ColonyStreakingTool.",
      Category -> "Streaking"
    },
    DispenseCoordinates -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{DistanceP, DistanceP}..},
      Description -> "For each member of SampleLink, the location(s) the suspended cells are dispensed on the destination plate before streaking.",
      IndexMatching -> SampleLink,
      Category -> "Streaking"
    },
    StreakPatternType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> StreakPatternP,
      Description->"For each member of SampleLink, the pattern the streaking colony handler head will move when streaking the colony on the plate.",
      IndexMatching -> SampleLink,
      Category -> "Streaking"
    },
    CustomStreakPattern -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[Streak[ListableP[CoordinatesP]]],
      Description -> "For each member of SampleLink, the user defined pattern used to streak the suspended cells across the plate.",
      IndexMatching -> SampleLink,
      Category -> "Streaking"
    },
    NumberOfSegments -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Description-> "For each member of SampleLink, if StreakPatternType->RotatedHatches, the number of times the plate is rotated during the streak. If StreakPatternType->LinearHatches, the amount of sections that have sets of hatches.",
      IndexMatching -> SampleLink,
      Category -> "Streaking"
    },
    HatchesPerSegment -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Description->"For each member of SampleLink, the number of zig-zags per segment.",
      IndexMatching -> SampleLink,
      Category -> "Streaking"
    },
    DestinationContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container],Model[Container]],
      Description->"For each member of SampleLink, the desired type of container to have suspended cells streaked in, with indices indicating grouping of samples in the same plate, if desired.",
      IndexMatching -> SampleLink,
      Category -> "Spreading",
      Migration -> SplitField
    },
    DestinationContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer, ObjectP[{Model[Container], Object[Container]}]|_String},
      Description->"For each member of SampleLink, the desired type of container to have suspended cells streaked in, with indices indicating grouping of samples in the same plate, if desired.",
      IndexMatching -> SampleLink,
      Category -> "Spreading",
      Migration -> SplitField
    },
    DestinationContainerString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description->"For each member of SampleLink, the desired type of container to have suspended cells streaked in, with indices indicating grouping of samples in the same plate, if desired.",
      IndexMatching -> SampleLink,
      Category -> "Spreading",
      Migration -> SplitField
    },
    DestinationMediaLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample],Model[Sample]],
      Description->"For each member of SampleLink, the media on which the cells are streaked.",
      IndexMatching -> SampleLink,
      Category -> "Spreading",
      Migration -> SplitField
    },
    DestinationMediaString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description->"For each member of SampleLink, the media on which the cells are streaked.",
      IndexMatching -> SampleLink,
      Category -> "Spreading",
      Migration -> SplitField
    },

    (* Sanitization *)
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
      Description -> "For each member of SampleLink, the first wash solution that is used during the sanitization process prior to each round of streaking.",
      IndexMatching -> SampleLink,
      Category -> "Sanitization",
      Migration -> SplitField
    },
    PrimaryWashSolutionString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the first wash solution that is used during the sanitization process prior to each round of streaking.",
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
      Description -> "For each member of SampleLink, the second wash solution that can be used during the sanitization process prior to each round of streaking.",
      IndexMatching -> SampleLink,
      Category -> "Sanitization",
      Migration -> SplitField
    },
    SecondaryWashSolutionString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the second wash solution that can be used during the sanitization process prior to each round of streaking.",
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
      Description -> "For each member of SampleLink, the third wash solution that can be used during the sanitization process prior to each round of streaking.",
      IndexMatching -> SampleLink,
      Category -> "Sanitization",
      Migration -> SplitField
    },
    TertiaryWashSolutionString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the third wash solution that can be used during the sanitization process prior to each round of streaking.",
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
      Description -> "For each member of SampleLink, the quaternary wash solution that can be used during the process prior to each round of streaking.",
      IndexMatching -> SampleLink,
      Category -> "Sanitization",
      Migration -> SplitField
    },
    QuaternaryWashSolutionString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the quaternary wash solution that can be used during the process prior to each round of streaking.",
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

    (* Developer *)
    (* NOTE: The fields below will be populated in unit operation objects that function as OutputUnitOperations *)
    ResuspensionUnitOperations -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> CellPreparationP,
      Description -> "A mix of sample preparation primitives to resuspend the input samples if they are FreezeDried or FrozenGlycerol.",
      Category -> "General",
      Developer -> True
    },
    AssayContainerUnitOperations -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A mix of sample preparation primitives to prepare the assay container if needed. These primitives also contain the Transfer/Mix primitives for any dilutions.",
      Category -> "General",
      Developer -> True
    },
    AssayContainerResources -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container],
        Model[Sample],
        Object[Sample]
      ],
      Description -> "The desired container to perform any sample dilutions prior to streaking the suspended cells.",
      Category -> "General",
      Developer -> True
    },
    DestinationContainerResources -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container],
        Model[Sample],
        Object[Sample]
      ],
      Description -> "The desired container to Streak any suspended cells. This is a flattened list that is used to store sample resources.",
      Category -> "General",
      Developer -> True
    },
    DestinationContainerResourceLengths -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0,1],
      Description -> "Stored batching lengths of the destination container resources.",
      Category -> "General",
      Developer -> True
    },
    SampleToSourceWellMapping -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Association,
      Description -> "An Association mapping input samples to a list of the source wells in the assay container that need to be Streak for that sample.",
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
    ResuspensionProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,ManualCellPreparation],
      Description -> "The protocol of the resuspension of the input samples before any assay container preparation.",
      Category -> "General",
      Developer -> True
    },
    AssayContainerPreparationProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Protocol,RoboticCellPreparation], Object[Protocol,ManualCellPreparation]],
      Description -> "The protocol of the preparation of the assay container. Including any dilutions.",
      Category -> "General",
      Developer -> True
    },
    CassetteHolderResources -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Container, ColonyHandlerHeadCassetteHolder],Object[Container, ColonyHandlerHeadCassetteHolder]],
      Description -> "The list of ColonyHandlerHeadCassetteHolder used as the container for the ColonyHandlerHeadCassette during the physical batch.",
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
    FinalTipRackReturns -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Item,Tips]],
      Description -> "The Tip Racks that need to be returned at the end of the unit operation loop.",
      Category -> "General",
      Developer -> True
    },

    (* BatchedUnitOperation fields *)
    BatchedUnitOperations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[UnitOperation,StreakCells]],
      Description -> "The physical batches split by source and assay containers that can fit on the deck at once.",
      Category -> "General",
      Developer -> True
    },

    (* NOTE: The fields below will only be populated in unit operations that are themselves a BatchedUnitOperation of another StreakCells unit op *)
    IntermediateSourceContainerDeckPlacements -> {
      Format -> Multiple,
      Class -> {Expression, Expression},
      Pattern :> {ObjectP[Object[Container]] | _String, {LocationPositionP..}},
      Headers -> {"Object or label","Position"},
      Description -> "The placement of source containers on the carriers of the qpix for this physical batch.",
      Category -> "General",
      Developer -> True
    },
    SourceContainerDeckPlacements -> {
      Format -> Multiple,
      Class->{Link,Expression},
      Pattern:>{_Link,{LocationPositionP..}},
      Relation->{Object[Container],Null},
      Headers -> {"Source Container Object To Place","Placement Tree"},
      Description -> "The placement of source containers on the carriers of the qpix for this physical batch.",
      Category -> "General",
      Developer -> True
    },
    AllSourceContainers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container]],
      Description -> "A list of all of the source containers that go on the deck for this physical batch.",
      Category -> "General",
      Developer -> True
    },
    FlatBatchedDestinationContainers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container,Plate], Object[Sample], Model[Sample], Model[Container,Plate]],
      Description -> "A flat list of the destination containers that once batched with the lengths in BatchedDestinationContainerLengths, represents which destination containers go with which routine file.",
      Category -> "General",
      Developer -> True
    },
    FlatBatchedDestinationContainerPlacements -> {
      Format -> Multiple,
      Class -> {Link, Expression},
      Pattern :> {_Link, {LocationPositionP..}},
      Relation -> {Alternatives[Object[Container,Plate], Object[Sample], Model[Sample], Model[Container,Plate]],Null},
      Headers -> {"Object","Position"},
      Description -> "A flat list of the destination container placements that once batched with the lengths in BatchedDestinationContainerLengths, represents which pairs of destination containers should be placed on the deck at the same time.",
      Category -> "General",
      Developer -> True
    },
    FlatBatchedStreakVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "The list of Streak volumes corresponding to flat batched destination samples.",
      Category -> "General",
      Developer -> True
    },
    FlatBatchedDispenseCoordinates -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{DistanceP, DistanceP}..},
      Description -> "The list of dispense coordinates corresponding to flat batched destination samples.",
      Category -> "General",
      Developer -> True
    },
    FlatBatchedTransfers -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[{_String,_String},{ObjectP[Object[Container]],_String},{}],
      Description -> "The list of transfer pairs (sample, well) corresponding to flat batched destination samples.",
      Category -> "General",
      Developer -> True
    },
    BatchedDestinationContainerLengths -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0,1],
      Description -> "The batching lengths corresponding to FlatBatchedDestinationContainers that are used to partition FlatBatchedDestinationContainers.",
      Category -> "General",
      Developer -> True
    },
    FlatBatchedRoutineJSONPaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The filepaths to the routine jsons for this batch.",
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
      Relation -> Alternatives[Object[Part,ColonyHandlerHeadCassette],Model[Part,ColonyHandlerHeadCassette]],
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
      Description -> "The placement used to place the colony streaking tool for the current batch.",
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
      Description -> "The placement used to remove the colony streaking tool from the colony handler and move it back to its holder once this batch is complete.",
      Category -> "General",
      Developer -> True,
      Headers->{"Object to Place", "Destination Object","Destination Position"}
    },
    FlatBatchedSamplesOutStorageConditions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal, Null],
      Description -> "The list of samples out storage condition values corresponding to flat batched source samples.",
      Category -> "General",
      Developer -> True
    },
    AllSourceContainerStorageConditions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal, Null],
      Description -> "For each container in AllSourceContainers, the storage condition of the container after the protocol is completed.",
      Category -> "General",
      Developer -> True
    },
    TipRackDeckPlacements -> {
      Format -> Multiple,(*We need an extra list here because deckPlacementAssociation does not deal well with traveling through links to a single field and will break with wall of errors*)
      Class -> {Link, Expression},
      Pattern :> {_Link, {LocationPositionP..}},
      Relation -> {Alternatives[Object[Item, Tips],Model[Item, Tips]], Null},
      Headers -> {"Tip Rack", "Placement Location"},
      Description -> "The deck placement to place the tip rack on the qpix deck at the beginning of the physical batch.",
      Category -> "General",
      Developer -> True
    },
    TipRackReturn -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Item,Tips],Model[Item,Tips]],
      Description -> "The tip rack to return to the cart before the new one is placed in the instrument for this physical batch.",
      Category -> "General",
      Developer -> True
    },
    NumberOfTipsRequired -> {
      Format -> Multiple,
      Class -> {Link, Integer},
      Pattern :> {_Link,GreaterP[0]},
      Relation -> {Alternatives[Object[Item, Tips],Model[Item, Tips]], Null},
      Headers -> {"Tips Object","Number Required"},
      Description -> "The tips and the corresponding number of tips used for this physical batch. This information is used to update the tip counts in parser.",
      Category -> "General",
      Developer -> True
    }
  }
}];