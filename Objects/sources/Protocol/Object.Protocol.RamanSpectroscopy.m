(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, RamanSpectroscopy], {
  Description -> "A protocol for performing Raman spectroscopy.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* ------------------------- *)
    (* -------- General -------- *)
    (* ------------------------- *)

    Instrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument],
        Object[Instrument]
      ],
      Description -> "The spectrometer used for the RamanSpectroscopy protocol.",
      Category -> "General"
    },
    SamplePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description -> "The container used to hold samples during the Raman measurement.",
      Category -> "General"
    },
    TabletCutter -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,TabletCutter],
        Model[Item, TabletCutter]
      ],
      Description -> "The enclosed blade tablet cutter used to perform tablet processing.",
      Category -> "General"
    },
    TabletCrusher -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,TabletCrusher],
        Model[Item, TabletCrusher]
      ],
      Description -> "The lever based tablet crusher used to perform tablet processing.",
      Category -> "General"
    },
    TabletCrusherBag -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,TabletCrusherBag],
        Model[Item, TabletCrusherBag]
      ],
      Description -> "The bags used to collect and contain tablets crushed using the TabletCrusher.",
      Category -> "General"
    },
    Tweezers ->{
      Format ->Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item, Tweezer],
        Object[Item, Tweezer]
      ],
      Description -> "The tweezers used to perform tablet manipulations.",
      Category -> "General",
      Developer ->True
    },
    SampleAmount -> {
      Format -> Multiple,
      Class -> {Real, Real, Expression},
      Pattern :> {GreaterEqualP[1 Microliter],GreaterEqualP[1 Milligram], BooleanP},
      Units -> {Microliter, Milligram, None},
      Headers -> {"Volume", "Mass", "Tablet"},
      Description -> "For each member of SamplesIn, the amount of sample loaded onto the sample plate for measurement.",
      Category -> "General",
      IndexMatching -> SamplesIn
    },
    SampleType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Tablet, Liquid, Powder],
      Description -> "For each member of SamplesIn, the form factor of sample being measured.",
      Category -> "General",
      IndexMatching ->SamplesIn
    },
    CalibrationCheck -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if a calibration check is performed on a PMMA internal standard.",
      Category -> "General"
    },


    (* ----------------- *)
    (* -- SAMPLE PREP -- *)
    (* ----------------- *)

    TabletProcessing -> {
      Format -> Multiple,
      Class -> {Expression, Expression},
      Pattern :> {Alternatives[LargestCrossSection, SmallestCrossSection, None, Whole], BooleanP},
      Headers -> {"Type of cut", "Ground"},
      Description -> "For each member of SamplesIn, indicates if tablets are characterized whole, cut, or crushed.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SamplePlatePrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (Null|SampleManipulationP),
      Description -> "Instructions specifying the transfer of the SamplesIn into the SamplePlate.",
      Category -> "Sample Preparation"
    },
    SamplePlateManipulations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "The specific sub-protocols performed to transfer samples into the SamplePlate.",
      Category -> "Sample Preparation"
    },


    (* ----------------- *)
    (* -- ACQUISITION -- *)
    (* ----------------- *)


    ObjectiveMagnification -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :>Alternatives[0,2,4,10,20],
      Description -> "For each member of SamplesIn, the objective lens magnification used for the sample measurement.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    FloodLight -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :>BooleanP,
      Description -> "For each member of SamplesIn, indicates if an objective which creates a ~ 1 Millimeter spot size is used.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    LaserPower -> {
      Format -> Multiple,
      Class -> {Real, Expression},
      Pattern :> {RangeP[1 Percent, 100 Percent], BooleanP},
      Units -> {Percent, None},
      Headers -> {"Set Power", "Optimized"},
      Description -> "For each member of SamplesIn, \"Set Power\" is the laser power used to measure the sample and \"Optimized\" indicates if the power is set by the user or optimized during the experiment.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    ExposureTime -> {
      Format -> Multiple,
      Class -> {Real, Expression},
      Pattern :> {GreaterEqualP[1 Millisecond], BooleanP},
      Units -> {Millisecond, None},
      Headers -> {"Exposure Time", "Optimized"},
      Description ->  "For each member of SamplesIn, \"Exposure Time\" is the exposure time used to measure the sample and \"Optimized\" indicates if the exposure time is optimized during the experiment.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    AdjustmentMethod -> {
      Format -> Multiple,
      Class -> {Link, String,Real, Real},
      Pattern :> {
        _Link,
        WellP,
        _?QuantityQ,
        RangeP[1 Percent, 100 Percent]
      },
      Units -> {None, None, 1/Centimeter, Percent},
      Relation -> {Alternatives[Object[Sample], Model[Sample]], None, None, None},
      Headers -> {"Adjustment Sample", "Well", "Wavelength", "Target Percentage"},
      Description ->  "For each member of SamplesIn, the adjustment sample used to optimize the LaserPower and ExposureTime based on the wavelength and target percentage.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    Blanks -> {
      Format -> Multiple,
      Class -> {Link, String, Expression},
      Pattern :> {
        (_Link|Null),
        (WellP|Null),
        BooleanP
      },
      Relation -> {Alternatives[Object[Sample], Model[Sample]], None, None},
      Headers -> {"Blank Sample", "Well Position", "Window Only"},
      Description ->  "For each member of SamplesIn, the sample used to generate a background spectrum and an indication of if the background spectrum is generated from the plate surface rather than a sample.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    BackgroundRemove -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, indicates if a dark background (collected with the shutter closed) is subtracted from each spectrum.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    CosmicRadiationFilter -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, indicates if CosmicRadiation corrections are applied to each spectrum.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },

    (* --------------------- *)
    (* -- OPTICAL IMAGING -- *)
    (* --------------------- *)


    OpticalImagingParameters -> {
      Format -> Multiple,
      Class -> {Real, Real, Expression},
      Pattern :> {(GreaterEqualP[1 Millisecond]|Null), (RangeP[0 Percent, 100 Percent]|Null), BooleanP},
      Headers ->{"Set Exposure Time","Set Light Intensity", "Optimized"},
      Units -> {Millisecond, Percent, None},
      Description -> "For each member of SamplesIn, \"ExposureTime\" and \"Light Intensity\" specify the exposure and light intensity for optical imaging of the sample well and \"Optimized\" indicates if the settings are optimized during the experiment, in which case the Intensity and Exposure are starting values before optimization.",
      Category -> "Imaging",
      IndexMatching -> SamplesIn
    },

    (* ------------ *)
    (* -- METHOD -- *)
    (* ------------ *)

    ReadOrder -> {
      Format -> Multiple,
      Class -> String,
      Pattern :>WellP,
      Description -> "The sequence in which the wells of the SamplePlate are characterized.",
      Category -> "Scattering Measurement"
    },
    ReadParameters -> {
      Format -> Multiple,
      Class -> {Integer, Real},
      Pattern :> {GreaterP[0], GreaterP[0 Millisecond]},
      Units -> {None, Millisecond},
      Headers -> {"Number of Reads", "Rest Time"},
      Description -> "For each member of SamplesIn, the number of times the sampling pattern is performed, and the delay time between each measurement.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    SamplingPattern -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :>  Alternatives[SinglePoint, Spiral, FilledSpiral, FilledSquare, Grid, Rings, Coordinates],
      Description -> "For each member of SamplesIn, the sampling pattern used to measure the sample.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    SamplingTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :>  GreaterP[1 Second],
      Units -> Second,
      Description -> "For each member of SamplesIn, the duration of the sampling measurement if applicable to the SamplingPattern.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },

    (* -- SPIRAL PARAMETERS -- *)
    SpiralSamplingParameters ->{
      Format -> Multiple,
      Class -> {Real, Real, Real, Real},
      Pattern :> {
        GreaterEqualP[1 Micrometer],
        GreaterEqualP[1 Micrometer],
        GreaterEqualP[1 Micrometer],
        GreaterEqualP[1 Percent]
      },
      Units -> {
        Micrometer,
        Micrometer,
        Micrometer,
        Percent
      },
      Headers -> {
        "Inner Diameter",
        "Outer Diameter",
        "Resolution",
        "Fill Area"
      },
      Description -> "For each member of SamplesIn, the parameters for the FilledSpiral or Spiral patterns.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    SamplingDimensions -> {
      Format -> Multiple,
      Class ->{Real, Real, Real},
      Pattern :> {
        (GreaterEqualP[0 Micrometer]|Null),
        (GreaterEqualP[0 Micrometer]|Null),
        (GreaterEqualP[0 Micrometer]|Null)
      },
      Units -> {Micrometer, Micrometer, Micrometer},
      Headers -> {"X Dimension", "Y Dimension", "Z Dimension"},
      Description -> "For each member of SamplesIn, the total distance covered by the sampling pattern in the X, Y, and Z dimensions for Grid or Square pattern.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    SamplingStepSize -> {
      Format -> Multiple,
      Class ->{Real, Real, Real},
      Pattern :> {
        (GreaterEqualP[0 Micrometer]|Null),
        (GreaterEqualP[0 Micrometer]|Null),
        (GreaterEqualP[0 Micrometer]|Null)
      },
      Units -> {Micrometer, Micrometer, Micrometer},
      Headers -> {"X Step Size", "Y Step Size", "Z Step Size"},
      Description -> "For each member of SamplesIn, the spacing between adjacent measurement points in the X, Y, and Z direction for Grid or Square pattern.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    RingSamplingParameters -> {
      Format -> Multiple,
      Class -> {Integer, Real, Integer},
      Pattern :> {GreaterP[0], GreaterEqualP[1 Micrometer], GreaterP[1]},
      Units -> {None, Micrometer, None},
      Headers -> {"Number of Rings", "Ring Spacing", "Number of Points"},
      Description -> "For each member of SamplesIn, the parameters for the Ring pattern.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    NumberOfShots ->{
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "For each member of SamplesIn, the number of times that each point in the sampling pattern is measured.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    FilledSquareNumberOfTurns ->{
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "For each member of SamplesIn, the number of connected parallel lines along which spectra are collected when using the FilledSquare SamplingPattern.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },
    SamplingCoordinates -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern:>QuantityArrayP[],
      (*Pattern :> QuantityCoordinatesP[{Micrometer, Micrometer, Micrometer}],*)
      Units -> {Micrometer, Micrometer, Micrometer},
      Description -> "For each member of SamplesIn, the specified coordinates at which the sample is measured.",
      Category -> "Scattering Measurement",
      IndexMatching -> SamplesIn
    },

    (* ----------------------- *)
    (* -- METHOD/DATA FILES -- *)
    (* ----------------------- *)

    DataFilePaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "For each member of SamplesIn, the file paths where the raw scattering data files are located.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    MethodFilePaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "For each member of SamplesIn, the file paths where the method information are located.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    ScriptsFilePaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "For each batch of method files, the file paths where the scripts to load and modify insturment parameters are located.",
      Category -> "General",
      Developer -> True
    },
    BatchRunTime ->{
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      Description -> "For each member of ScriptsFilePaths, an estimate of how long the script will run without requiring operator intervention.",
      Category -> "General",
      IndexMatching -> ScriptsFilePaths,
      Developer ->True
    },
    SamplingRunTime ->{
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      Description -> "For each member of SamplesIn, an estimate of the sampling pattern will take to execute.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer ->True
    },
    BlankMethodFilePaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file paths where the method information are located for the blank samples.",
      Category -> "General",
      Developer -> True
    },
    BlankScriptFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path where the script to load and modify instrument parameters for the blank samples is located.",
      Category -> "General",
      Developer -> True
    },
    BatchedAdjustmentParameters -> {
      Format -> Multiple,
      Class -> {Real, Real, Expression, Expression},
      Pattern :> {
        _?QuantityQ,
        GreaterEqualP[0],
        BooleanP,
        BooleanP
      },
      Units -> {1/Centimeter, None, None, None},
      Headers -> {"Wavelength", "Target Intensity", "Adjust LaserPower", "Adjust ExposureTime"},
      Description ->  "For each member of ScriptsFilePaths, the adjustment parameters used to optimize the LaserPower and ExposureTime based on the wavelength and target percentage. The LaserPower or ExposureTime booleans indicate if the parameter is set (False) or requires optimization (True).",
      Category -> "General",
      IndexMatching -> ScriptsFilePaths,
      Developer -> True
    },
    BatchedTargetIntensity ->{
      Format->Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description ->"For each member of ScriptsFilePaths, the target intensity.",
      IndexMatching -> ScriptsFilePaths,
      Category -> "General",
      Developer ->True
    },
    BatchedTargetWavelength ->{
      Format-> Multiple,
      Class -> Real,
      Pattern :> _?QuantityQ,
      Units -> None,
      Description ->"For each member of ScriptsFilePaths, the wavelength that is being adjusted.",
      IndexMatching -> ScriptsFilePaths,
      Category -> "General",
      Developer ->True
    },
    RemainingTabletTransfers ->{
      Format ->Single,
      Class ->Integer,
      Pattern :> GreaterEqualP[0],
      Description -> "The number of tablet samples that have not yet been moved to the SamplePlate.",
      Category -> "General",
      Developer ->True
    },
    Tablets->{
      Format ->Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Sample],
        Object[Container]
      ],
      Description -> "A list of all of SamplesIn which are in tablet form when they are resource picked.",
      Category -> "General",
      Developer -> True
    },

    (* ------------------- *)
    (* -- RECOUP SAMPLE -- *)
    (* ------------------- *)

    RecoupSample->{
      Format->Multiple,
      Class->Boolean,
      Pattern:>BooleanP,
      Description->"For each member of SamplesIn, indicates whether the sample should be recovered back into the container after measurement.",
      Category->"Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    RecoupSamplePrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (Null|SampleManipulationP),
      Description -> "For each member of SamplesIn, instructions specifying the transfer of the sample back into the origin container after measurement.",
      Category -> "Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    RecoupSampleManipulations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "For each member of SamplesIn, the specific subprotocol performed to transfer the sample back into the origin container after measurement.",
      Category -> "Sample Post-Processing",
      IndexMatching -> SamplesIn
    }
  }
}];

