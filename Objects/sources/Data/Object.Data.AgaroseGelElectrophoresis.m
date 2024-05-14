

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, AgaroseGelElectrophoresis], {
  Description->"Data from separation of nucleic acids as determined by electrochemical motility, obtained by running Agarose Gel Electrophoresis.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    Scale -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> PurificationScaleP,
      Description -> "Indicates whether the data is obtained from an Analytical or Preparative Size-Selection gel.",
      Category -> "General",
      Abstract -> True
    },
    GelModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item,Gel],
      Description -> "The model of gel that this separation is performed on.",
      Category -> "General",
      Abstract -> False
    },
    GelMaterial -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> GelMaterialP,
      Description -> "The polymer material that the hydrogel network of the gel is composed of.",
      Category -> "General",
      Abstract -> True
    },
    GelPercentage -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Percent],
      Units -> Percent,
      Description -> "The polymer weight percentage of the gel.",
      Category -> "General",
      Abstract -> True
    },
    LoadingDyes-> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Sample],
        Model[Sample]
      ],
      Description -> "The samples containing fluorescently-labeled oligonucleotides of known length used as size markers to generate these data.",
      Category -> "General"
    },
    SeparationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Minute],
      Units -> Minute,
      Description -> "If Scale is Analytical, the amount of time that Voltage is applied across the Gel. If Scale is Preparative, the maximum amount of time that Voltage is applied across the Gel before the run is stopped. The actual separation time may be shorter if all bands are extracted before the SeparationTime has been reached.",
      Category -> "General",
      Abstract -> True
    },
    Voltage -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Volt],
      Units -> Volt,
      Description -> "The voltage of the current applied across the gel to generate these data.",
      Category -> "General"
    },
    DutyCycle -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0*Percent, 100*Percent, 1*Percent, Inclusive -> Right],
      Units -> Percent,
      Description -> "If Scale is Analytical, the percentage of each power cycle that Voltage is applied across the gel. If Scale is Preparative, the maximum percentage of each power cycle that Voltage is applied across the gel. In Preparative runs, the DutyCycle is modulated in each lane individually so that sample extraction can take simultaneously across multiple lanes when possible.",
      Category -> "General"
    },
    CycleDuration -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Micro*Second],
      Units -> Micro Second,
      Description -> "The time duration of each power cycle applied to the gel. If DutyCycle is less than 100%, this is the period over which the voltage switches on and off once.",
      Category -> "General"
    },
    AutomaticPeakDetection->{
      Format->Single,
      Class->Expression,
      Pattern :> BooleanP,
      Description->"Indicates if the instrument software automatically detects and collects the largest peak present between the MinPeakDetectionSize and MaxPeakDetectionSize.",
      Category -> "General"
    },
    MinPeakDetectionSize->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*BasePair],
      Units->BasePair,
      Description->"The lower bound, in base pairs, of the range the instrument software searches for a peak to collect.",
      Category -> "General"
    },
    MaxPeakDetectionSize->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*BasePair],
      Units->BasePair,
      Description->"The upper bound, in base pairs, of the range the instrument software searches for a peak to collect.",
      Category -> "General"
    },
    CollectionSize->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*BasePair],
      Units->BasePair,
      Description->"The target size of the sample, in base paris, that is extracted in the ExtractionVolume.",
      Category -> "General"
    },
    MinCollectionRangeSize->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*BasePair],
      Units->BasePair,
      Description->"The lower bound, in base pairs, of the range of Oligomers that are extracted in the ExtractionVolume.",
      Category -> "General"
    },
    MaxCollectionRangeSize->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*BasePair],
      Units->BasePair,
      Description->"The upper bound, in base pairs, of the range of Oligomers that are extracted in the ExtractionVolume.",
      Category -> "General"
    },
    ExtractionVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Microliter],
      Units->Microliter,
      Description->"The total volume of sample-containing buffer that is removed from the gel for each input sample. The ExtractionVolume is either centered around the largest peak between the MinPeakDetectionSize and MaxPeakDetectionSize, centered around the CollectionSize, or spans the MinCollectionRangeSize and MaxCollectionRangeSize, depending on the method of peak selection chosen.",
      Category -> "General"
    },
    ExposureTimes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Milli*Second],
      Units -> Milli Second,
      Description -> "The amounts of time for which a camera shutter stays open for each set of gel images.",
      Category -> "Imaging"
    },
    ExcitationWavelengths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      Description -> "The wavelengths of light that are used to excite the gel for fluorescence images.",
      Category -> "Imaging"
    },
    ExcitationBandwidths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      IndexMatching -> ExcitationWavelengths,
      Description -> "For each member of ExcitationWavelengths, the range in wavelengths centered around the ExcitationWavelength that the excitation filter allows through at 50% of the maximum transmission.",
      Category -> "Imaging"
    },
    EmissionWavelengths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      Description -> "The wavelengths at which fluorescence emitted from the gels is detected for fluorescence images.",
      Category -> "Imaging"
    },
    EmissionBandwidths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      IndexMatching -> EmissionWavelengths,
      Description -> "For each member of EmissionWavelengths, the range in wavelengths centered around the EmissionWavelength that the emission filter allows to pass through at 50% of the maximum transmission.",
      Category -> "Imaging"
    },
    SampleElectropherogram -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{BasePair,RFU}],
      Units -> {BasePair, RFU},
      Description -> "Trace of Oligomer lengths versus fluorescence intensity that is calculated by the Instrument software from the blue gel images and the known lengths of the LoadingDye markers. This trace is created when the LoadingDye of shorter length has migrated 75% of the way across the gel (as seen in the red gel images).",
      Category -> "Experimental Results"
    },
    MarkerElectropherogram -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{BasePair,RFU}],
      Units -> {BasePair, RFU},
      Description -> "Trace of LoadingDye marker lengths versus fluorescence intensity that is calculated by the Instrument software from the red-light gel images. This trace is created when the LoadingDye of shorter length has migrated 75% of the way across the gel.",
      Category -> "Experimental Results"
    },
    PostSelectionElectropherogram -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{BasePair,RFU}],
      Units -> {BasePair, RFU},
      Description -> "Estimated trace of the Oligomer lengths versus fluorescence intensity of the SampleOut, calculated by the Instrument software.",
      Category -> "Experimental Results"
    },
    BlueFluorescenceImageFiles->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      IndexMatching -> ExposureTimes,
      Description -> "For each member of ExposureTimes, files containing the full-sized uncropped blue-light images of the entire gel after electrophoresis. The SamplesIn and Ladder are visible in these images. In Preparative runs, the BlueFluorescenceImageFiles only contain the Oligomer bands still present on the gels after sample extraction. The SampleElectropherogram has a more complete set of Oligomers present in the input sample.",
      Category -> "Experimental Results"
    },
    RedFluorescenceImageFiles->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      IndexMatching -> ExposureTimes,
      Description -> "For each member of ExposureTimes, files containing the full-sized uncropped red-light images of the entire gel after electrophoresis. The marker LoadingDyes are visible in these gel images. In Preparative runs, the RedFluorescenceImageFiles only contain the LoadingDye bands still present on the gels after sample extraction. The MarkerElectropherogram has the complete set of LoadingDyes and lengths.",
      Category -> "Experimental Results"
    },
    BlueFluorescenceGelImages->{
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[BlueFluorescenceImageFiles]}, ImportCloudFile[Field[BlueFluorescenceImageFiles]]],
      Pattern :> _Image,
      Description -> "For each member of ExposureTimes, the full-sized uncropped blue-light images of the entire gel after electrophoresis. The SamplesIn and Ladder are visible in these images. In Preparative runs, the BlueFluorescenceGelImages only contain the Oligomer bands still present on the gels after sample extraction. The SampleElectropherogram has a more complete set of Oligomers present in the input sample.",
      Category -> "Experimental Results"
    },
    RedFluorescenceGelImages->{
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[RedFluorescenceImageFiles]}, ImportCloudFile[Field[RedFluorescenceImageFiles]]],
      Pattern :> _Image,
      Description -> "For each member of ExposureTimes, the full-sized uncropped red-light images of the entire gel after electrophoresis. The marker LoadingDyes are visible in these gel images. In Preparative runs, the RedFluorescenceGelImages only contain the LoadingDye bands still present on the gels after sample extraction. The MarkerElectropherogram has the complete set of LoadingDyes and lengths.",
      Category -> "Experimental Results"
    },
    LadderData -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Data, AgaroseGelElectrophoresis][Analytes],
      Description -> "The data generated from the Ladder present in the same gel as this analyte.",
      Category -> "Analysis & Reports"
    },
    Analytes -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Data, AgaroseGelElectrophoresis][LadderData],
      Description -> "The samples that are run on an agarose gel in this AgaroseGelElectrophoresis experiment alongside this ladder.",
      Category -> "Analysis & Reports"
    },
    DataType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> PAGEDataTypeP,
      Description -> "Indicates if this data represents a Ladder or an Analyte sample.",
      Category -> "Experimental Results"
    },
    LaneNumber -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Units -> None,
      Description -> "The lane index starting from the left most lane of the gel.",
      Category -> "Experimental Results",
      Abstract -> True
    },
    NeighboringLanes -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Data, AgaroseGelElectrophoresis][NeighboringLanes],
      Description -> "Data from any Analytes and Ladder that are run on the same gel.",
      Category -> "Experimental Results"
    },
    SampleElectropherogramPeaksAnalyses -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "Peak-picking analysis conducted on these data.",
      Category -> "Analysis & Reports"
    },
    MarkerElectropherogramPeaksAnalyses -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "Peak-picking analysis conducted on these data.",
      Category -> "Analysis & Reports"
    },
    PostSelectionPeaksAnalyses -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "Peak-picking analysis conducted on these data.",
      Category -> "Analysis & Reports"
    },
    SmoothingAnalyses -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "Smoothing analysis performed on this data.",
      Category -> "Analysis & Reports"
    },
    RedAnimationFiles->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      Description -> "Files containing the time lapsed red-light GIF images of the entire gel during electrophoresis.",
      Category -> "Experimental Results"
    },
    BlueAnimationFiles->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      Description -> "Files containing the time lapsed blue-light GIF images of the entire gel during electrophoresis.",
      Category -> "Experimental Results"
    },
    CombinedAnimationFiles->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      Description -> "Files containing the time lapsed combined red- and blue-light GIF images of the entire gel during electrophoresis.",
      Category -> "Experimental Results"
    }
  }
}];

