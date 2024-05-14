(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*RamanSpectroscopy*)


(* ::Subsubsection::Closed:: *)
(*ExperimentRamanSpectroscopy Options*)

DefineOptions[ExperimentRamanSpectroscopy,
  Options :> {

    (* ----------------- *)
    (* -- SAMPLE TYPE -- *)
    (* ----------------- *)

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> SampleType,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Powder, Liquid, Tablet]],
        Description -> "For each member of SamplesIn, specifies the form factor of the sample as liquid or solid (powder or tablet) which will occupy a well in the sample plate.",
        ResolutionDescription -> "The sample type is determined from the State and Tablet fields of the Object[Sample], and by Aliquot options specifying dilution and the TabletProcessing option. For example, a solid sample with TargetConcentration specified will have SampleType -> Liquid, and a tablet sample with TabletProcessing -> Grind will have SampletType -> Solid.",
        Category -> "General"
      },
      {
        OptionName->Blank,
        Default->Automatic,
        AllowNull->False,
        Widget->Alternatives[
          "Sample" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
          "Window" -> Widget[Type -> Enumeration, Pattern:>Alternatives[Window, None]]
        ],
        Description->"For each member of SamplesIn, the source used to generate a blank sample whose Raman scattering response is subtracted as background from every Raman spectrum collected for that sample. Window indicates that a stored spectrum of the window material wil be subtracted, while None indicates that there will be no blank subtraction.",
        ResolutionDescription->"Automatically set to Window for samples with SampleType ->  Liquid or Powder, and None when SampleType -> Tablet.",
        Category->"Data Processing"
      }
    ],
    {
      OptionName -> Instrument,
      Default -> Model[Instrument, RamanSpectrometer, "THz Raman WPS"],
      Description -> "The THz-Raman Spectrometer used to characterize Raman scattering.",
      AllowNull -> False,
      Category -> "General",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, RamanSpectrometer], Object[Instrument, RamanSpectrometer]}]
      ]
    },

    (* ----------------------- *)
    (* -- TABLET PROCESSING -- *)
    (* ----------------------- *)

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> TabletProcessing,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Whole, LargestCrossSection, SmallestCrossSection, Grind]],
        Description -> "For each member of SamplesIn, specifies if a tablet should be ground or cut prior to analysis. LargestCrossSection and SmallestCrossSection specify that the tablet is to be cut in half along an axis to expose either the largest or smallest amount of the tablet interior. The largest cross section is obtained by cleaving the tablet parallel to the longest axis, while the smallest cross section will be obtained by cleaving the tablet perpendicular to the longest axis. For scored round tablets, the direction of the score is considered the long axis, and for unscored round tablets LargestCrossSection and SmallestCrossSection are equivalent. The cut face of the tablet is placed facing downward and is subjected to Raman analysis.",
        ResolutionDescription -> "If SampleType -> Solid for a Tablet input, TabletProcessing is set to Grind. For Tablet samples with SampleType  -> Automatic or Tablet, TabletProcessing is set to Whole and for all other samples it is set to Null.",
        Category -> "General"
      },

      (* ------------ *)
      (* -- OPTICS -- *)
      (* ------------ *)
      (*TODO: floodlight is used for the spectroscopy only, so in cases where optical images are taken we would need to default those to 2x. There is no point in a higher objective since the spot size is 1 mm *)
      {
        OptionName -> FloodLight,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "For each member of SamplesIn, indicates if spectroscopic measurements are performed with an objective that creates a broad spot size of approximately 1 Millimeter. FloodLight is best used to obtain a rapid average over the entire sample in cases where spatial resolution of the Raman scattering is not the primary goal.",
        ResolutionDescription -> "If the ObjectiveMagnification is set to Null, FloodLight will be used.",
        Category -> "Optics"
      },
      {
        OptionName -> ObjectiveMagnification,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[2,4,10,20]],
        Description -> "For each member of SamplesIn, specifies the magnification factor objective to be used for the excitation beam, optical imaging, and Raman backscattering.",
        ResolutionDescription -> "If FloodLight is True, the ObjectiveMagnification will be set to Null if no optical image is requested, and 2X if optical images are to be taken along with spectroscopic measurements. Otherwise ObjectiveMagnification is set to 10.",
        Category -> "Optics"
      },
      {
        OptionName -> LaserPower,
        Default -> 20 Percent,
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> Alternatives[Optimize]],
          Widget[Type -> Quantity, Pattern :> RangeP[1 Percent, 100 Percent], Units -> Percent]
        ],
        Description -> "For each member of SamplesIn, specifies the percent of the maximum laser output (400 mW) at the objective. Insufficient LaserPower may result in low signal-to-noise ratio, while excessively LaserPower can result in detector saturation (and loss or spectral resolution) and sample damage. If you are unsure of an appropriate LaserPower, select Optimize.",
        Category -> "Optics"
      },
      {
        OptionName -> ExposureTime,
        Default -> 100 Millisecond,
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> Alternatives[Optimize]],
          Widget[Type -> Quantity, Pattern :> GreaterEqualP[1 Millisecond], Units -> Millisecond]
        ],
        Description -> "For each member of SamplesIn, specifies the amount of time over which the Raman scattering signal is summed by the CCD detector for each measurement. Insufficient ExposureTime results in weak signal, while excessive ExposureTime may lead to detector saturation and loss of spectral resolution. If you are unsure of an appropriate ExposureTime, select Optimize.",
        Category -> "Optics"
      },
      {
        OptionName -> AdjustmentSample,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Use Each Sample" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]],
          "Use Selected Sample" -> Widget[Type -> Object, Pattern:>ObjectP[{Object[Sample], Model[Sample]}]]
        ],
        Description -> "For each member of SamplesIn, specifies the sample that should be used to adjust the LaserPower and ExposureTime. If All is selected, the LaserPower and ExposureTime will be adjusted for each sample individually.",
        ResolutionDescription -> "If LaserPower or ExposureTime are set to Optimize, the first measured sample will be used as the adjustment sample.",
        Category -> "Optics"
      },
      {
        OptionName -> AdjustmentEmissionWavelength,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Use Maximum" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Max]],
          "Single Wavelength" -> Widget[
            Type -> Quantity,
            Pattern:>Alternatives[RangeP[-600*1/Centimeter, -10*1/Centimeter], RangeP[10*1/Centimeter, 3800*1/Centimeter]],
            Units -> 1/Centimeter
          ]
        ],
        Description -> "For each member of SamplesIn, specifies the Raman shift wavelength to be used for optimizing signal intensity. \"Max\" indicates that the most intense scattering peak will be used.",
        ResolutionDescription -> "If AdjustmentSample is specified or All, AdjustmentEmissionWavelength will be set to use the most intense scattering peak. Otherwise, this option will be set to Null.",
        Category -> "Optics"
      },
      {
        OptionName -> AdjustmentTarget,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Percent, 100 Percent], Units -> Percent],
        Description -> "For each member of SamplesIn, specifies the target intensity for an optimized signal as a percentage of the saturation threshold of the detector.",
        ResolutionDescription -> "If AdjustmentSample is specified or All, or Optimize is indicated in ExposureTime or LaserPower, AdjustmentTarget is set to 50 Percent, otherwise this option is set to Null.",
        Category -> "Optics"
      },
      {
        OptionName -> BackgroundRemove,
        Default -> True,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "For each member of SamplesIn, indicates if a dark background is subtracted from the sample spectrum. The background is collected with the beam shutter closed and accounts for noise in the CCD detector.",
        Category -> "Optics"
      },
      {
        OptionName -> CosmicRadiationFilter,
        Default -> True,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "For each member of SamplesIn, indicates if spectra are processed to remove features arising from cosmic rays. Cosmic rays are random and intense bursts of radiation that overwhelm the Raman scattering signal. It is highly recommended that this option is used to eradicate cosmic radiation features which can obfuscate the sample scatting. Note that NumberOfShots should be set to more than 1 (if applicable) in order for this feature to function optimally.",
        Category -> "Optics"
      }
    ],
    {
      OptionName -> CalibrationCheck,
      Default -> True,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
      Description -> "Indicates if the instrument collects a spectrum using a PMMA internal standard prior to measuring the samples. The calibration check reports a value from 0 to 1 representing the similarity between the collected spectrum and the manufacturer collected spectrum (1 is a perfect match). Note that this assessment will not adjust the instrument in any way.",
      Category -> "Optics"
    },

    (* -------------------- *)
    (* -- CAMERA OPTIONS -- *)
    (* -------------------- *)

    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> InvertedMicroscopeImage,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "For each member of SamplesIn, indicates if an optical image of the sample is taken using an inverted microscope configuration. The optical camera will utilize ObjectiveMagnification.",
        ResolutionDescription ->"If MicroscopeImageExposureTime or MicroscopeImageLightIntensity are informed, InvertedMicroscopeImage is set to True.",
        Category -> "Optical Imaging"
      },
      {
        OptionName -> MicroscopeImageExposureTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Set Time" -> Widget[Type -> Quantity, Pattern :> RangeP[1 Millisecond, 9999 Millisecond], Units -> Millisecond],
          "Optimize" -> Widget[Type -> Enumeration, Pattern :>Alternatives[Optimize]]
        ],
        Description -> "For each member of SamplesIn, specifies the exposure time for optical microscope images. Optimize will automatically adjust the exposure for best image quality.",
        ResolutionDescription -> "If InvertedMicroscopeImage is True, the default value is Optimize.",
        Category -> "Optical Imaging"
      },
      {
        OptionName -> MicroscopeImageLightIntensity,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Alternatives[
          "Set Percent" -> Widget[Type -> Quantity, Pattern :> RangeP[0 Percent, 100 Percent], Units -> Percent]
        ],
        Description -> "For each member of SamplesIn, specifies the power of the blue LED light that illuminates the sample stage for optical imaging.",
        ResolutionDescription -> "If InvertedMicroscopeImage is True, the default value is 10 Percent.",
        Category -> "Optical Imaging"
      }
    ],

    (* ---------------------- *)
    (* -- READING OPTIONS -- *)
    (* ---------------------- *)
    {
      OptionName -> ReadPattern,
      Default -> Row,
      AllowNull -> False,
      Widget -> Alternatives[
        "Predefined" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Row, Column, Serpentine, TransposedSerpentine]],
        "Custom" -> Adder[Widget[Type -> Enumeration, Pattern:>WellP]]
      ],
      Description -> "Specifies the sequence in which the sample plate is measured.",
      Category -> "Reading"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> NumberOfReads,
        Default -> 1,
        AllowNull -> False,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1,9999,1]],
        Description -> "For each member of SamplesIn, specifies the number of times that the SamplingPattern is repeated on the sample.",
        Category -> "Reading"
      },
      {
        OptionName -> ReadRestTime,
        Default -> 1 Second,
        AllowNull -> False,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Second, 9999 Second], Units -> Second],
        Description -> "For each member of SamplesIn, specifies the delay between executing the SamplingPattern in a given well.",
        Category -> "Reading"
      },

      (* ---------------------- *)
      (* -- SAMPLING OPTIONS -- *)
      (* ---------------------- *)

      {
        OptionName -> SamplingPattern,
        Default -> SinglePoint,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[SinglePoint, Spiral, FilledSpiral, FilledSquare, Grid, Rings, Coordinates]],
        Description -> "For each member of SamplesIn, specifies pattern or set of points that are samples within each well. SinglePoint: Collects spectra at a single point of the well. Spiral: Collects spectra at each point along a spiral pattern. FilledSpiral: Collects spectra at each point along a spiral pattern with the specified area coverage. FilledSquare: Collects spectra in a designated square area by sampling along an S-pattern. Grid: Collects spectra along specified grid lines. Rings: Collects spectra at sparse points on nested rings. Custom: Collects spectra at the requested coordinates.",
        Category -> "Sampling"
      },
      {
        OptionName -> SamplingTime,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Second, 9999 Second], Units -> Second],
        Description -> "For each member of SamplesIn, specifies the amount of time to complete the requested Spiral or Grid SamplingPattern.",
        ResolutionDescription -> "The value of SamplingTime is based on the SamplingPattern. For SamplingPattern -> (Spiral or FilledSquare) this will be set to 600 Second.",
        Category -> "Sampling"
      },

      (* spiral pattern options *)
      {
        OptionName -> SpiralInnerDiameter,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[10 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the inner diameter of the Spiral or FilledSpiral SamplingPattern.",
        ResolutionDescription -> "If the SamplingPattern is set Spiral or Filled Spiral, SpiralInnerDiameter will be set to 50 Micrometer if SpiralOuterDiameter is Automatic or greater than 100 Micrometer, and 1 Micrometer is SpiralOuterDiameter is less than 100 Micrometer.",
        Category -> "Sampling"
      },
      {
        OptionName -> SpiralOuterDiameter,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[10 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the outer diameter of the Spiral or FilledSpiral SamplingPattern.",
        ResolutionDescription -> "If the SamplingPattern is set Spiral or FilledSpiral, SpiralOuterDiameter will be set to 200 Micrometer if SpiralInnerDiameter is Automatic or less than 100 Micrometer, and SpiralInnerDiameter + 200 Micrometer otherwise.",
        Category -> "Sampling"
      },
      {
        OptionName -> SpiralFillArea,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Percent, 999 Percent], Units -> Percent],
        Description -> "For each member of SamplesIn, specifies the percentage of the total area inside the FilledSpiral pattern from which spectra are collected. Note that when percentages greater than 100 Percent are specified, the pattern will include overlapping measurements.",
        ResolutionDescription -> "If the SamplingPattern is set to FilledSpiral, SpiralFillArea will be set to 50 Percent.",
        Category -> "Sampling"
      },
      {
        OptionName -> SpiralResolution,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[1 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the distance between adjacent sampling points in the FilledSpiral or Spiral pattern.",
        ResolutionDescription -> "If the SamplingPattern is set to Spiral or FilledSpiral, SpiralResolution will be set to 10 Micrometer.",
        Category -> "Sampling"
      },

      (* options pertaining to Grid, FilledSquare *)
      {
        OptionName -> SamplingXDimension,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the size of the Grid or FilledSquare SamplingPattern in the X direction.",
        ResolutionDescription -> "If the SamplingPattern is set to Grid or FilledSquare, SamplingXDimension will be set to 200 Micrometer.",
        Category -> "Sampling"
      },
      {
        OptionName -> SamplingYDimension,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the size of the Grid or FilledSquare SamplingPattern in the Y direction.",
        ResolutionDescription -> "If the SamplingPattern is set to Grid or FilledSquare, SamplingYDimension will be set to 200 Micrometer.",
        Category -> "Sampling"
      },
      {
        OptionName -> SamplingZDimension,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[1 Micrometer, 2500 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the size of the Grid SamplingPattern in the Z direction.",
        ResolutionDescription -> "When SamplingPattern -> Grid, this will be set to 0 Micrometer, indicating that no z steps will be taken.",
        Category -> "Sampling"
      },
      {
        OptionName -> SamplingXStepSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[1 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the spacing between adjacent points of the Grid SamplingPattern in the X direction.",
        ResolutionDescription -> "If the SamplingPattern is set to Grid, SamplingXStepSize will be set to 20 Micrometer.",
        Category -> "Sampling"
      },
      (*TODO: the FilledSquare pattern only has Y steps.*)
      {
        OptionName -> SamplingYStepSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[1 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the spacing between adjacent points of the Grid SamplingPattern in the Y direction.",
        ResolutionDescription -> "If the SamplingPattern is set to Grid, SamplingYStepSize will be set to 20 Micrometer.",
        Category -> "Sampling"
      },
      {
        OptionName -> SamplingZStepSize,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[1 Micrometer, 2500 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the spacing between adjacent points of the Grid SamplingPattern in the Z direction.",
        ResolutionDescription -> "When SamplingPattern -> Grid, this will be set to 0 Micrometer, indicating that no step will be taken.",
        Category -> "Sampling"
      },
      {
        OptionName -> FilledSquareNumberOfTurns,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1,999,1]],
        Description -> "For each member of SamplesIn, specifies the number of parallel lines within the FilledSquare pattern along which spectra are recorded.",
        ResolutionDescription -> "If the SamplingPattern is set to FilledSquare, FilledSquareNumberOfTurns is set to 10.",
        Category -> "Sampling"
      },


      (* rings option *)
      {
        OptionName -> RingSpacing,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Quantity, Pattern :>  RangeP[1 Micrometer, 250000 Micrometer], Units -> Micrometer],
        Description -> "For each member of SamplesIn, specifies the difference in radius of consecutive nested rings for the Rings SamplingPattern. This value also designates the radius of the innermost ring.",
        ResolutionDescription -> "If the SamplingPattern is set to Rings, RingSpacing will be set to 100 Micrometer.",
        Category -> "Sampling"
      },
      {
        OptionName -> NumberOfRings,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 99, 1]],
        Description -> "For each member of SamplesIn, specifies the number of evenly spaced rings in the Rings SamplingPattern.",
        ResolutionDescription -> "If the SamplingPattern is set to Rings, NumberOfRings will be set to 5.",
        Category -> "Sampling"
      },
      {
        OptionName -> NumberOfSamplingPoints,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 999, 1]],
        Description -> "For each member of SamplesIn, specifies the total number of distinct measurement points generated along the circumference of the rings specified by NumberOfRings and RingSpacing.",
        ResolutionDescription -> "If the SamplingPattern is set to Rings, NumberOfPoints will be set to 30.",
        Category -> "Sampling"
      },

      (* custom coordinates *)
      {
        OptionName -> NumberOfShots,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :>RangeP[1, 9999, 1]],
        Description -> "For each member of SamplesIn, specifies the number of redundant times the sample is illuminated with the excitation laser at each point in the SinglePoint, Grid, Rings, or Coordinates SamplingPattern.",
        ResolutionDescription -> "If SamplingPattern -> (SinglePoint, Grid, Rings, or Coordinates), NumberOfShots will be set to 5.",
        Category -> "Sampling"
      },
      {
        OptionName -> SamplingCoordinates,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Adder[
          {
            "X Dimension" -> Widget[Type -> Quantity, Pattern :> RangeP[-125 Millimeter, 125 Millimeter], Units -> Micrometer],
            "Y Dimension" -> Widget[Type -> Quantity, Pattern :> RangeP[-85 Millimeter, 85 Millimeter], Units -> Micrometer],
            "Z Dimension" -> Widget[Type -> Quantity, Pattern :> RangeP[-10 Millimeter, 10 Millimeter], Units -> Micrometer]
          }
        ],
        Description -> "For each member of SamplesIn, specifies positions at which to record spectra. The coordinates are referenced to the center of the well, which has coordinates of (0,0,0).",
        ResolutionDescription -> "If the SamplingPattern is set to Custom, SamplingCoordinates will be set to randomly sample 20 points in the well with the Z-dimension of 0.",
        Category -> "Sampling"
      }
    ],
    {
      OptionName -> SamplePlate,
      Default -> Automatic,
      Description -> "The plate used to hold samples during the Raman spectroscopy characterization.",
      ResolutionDescription -> "This will resolve based on the identity of the samples, particularly if they are tablets or liquid/powder. The default settings are Model[Container, Plate, Irregular, Raman, \"Tablet holder for inverted microscopy\"] for tablets and Model[Container, Plate, \"96-well glass bottom plate\"] for liquids/powders.",
      AllowNull -> False,
      Category -> "Hidden",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Container, Plate], Model[Container, Plate, Irregular, Raman]}]
      ]
    },
    {
      OptionName -> NumberOfReplicates,
      Default -> Null,
      Description -> "The number of times to repeat spectroscopy reading on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
      AllowNull -> True,
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterEqualP[2,1]
      ],
      Category->"Protocol"
    },
    (* Shared options *)
    FuntopiaSharedOptions,
    SamplesInStorageOptions
  }
];

(* ::Subsubsection::Closed:: *)
(*ExperimentRamanSpectroscopy: Errors and Warnings*)


(* ======================== *)
(* == ERROR AND WARNINGS == *)
(* ======================== *)

Error::RamanNotEnoughSample = "The following samples do not have sufficient quantity to perform this experiment: `1`";
Error::IncompatibleRamanSampleTypes = "All SampleTypes must be (Powder or Liquid) or (Tablet). Please change the TabletProcessing or split these samples into different experiments as they cannot be measured on the same plate.";
Error::TooManyRamanSampleInputs = "The number of samples and blanks (`1`) exceeds the capacity of the plate that can hold this SampleType (`2`).";

(* microscope image errors *)
Error::MissingRamanMicroscopeImageLightIntensity = "MicroscopeImageLightIntensity must be specified or Automatic when InvertedMicroscopeImage is True. Please change the value of this option for `1`.";
Error::MissingRamanMicroscopeImageExposureTime = "MicroscopeImageExposureTime must be specified or Automatic when InvertedMicroscopeImage is True. Please change the value of this option for `1`.";
Error::UnusedRamanMicroscopeImageLightIntensity = "MicroscopeImageLightIntensity is only used when InvertedMicroscopeImage -> True. Change the value of InvertedMicroscopeImage to True or set this option to Null or Automatic for `1`.";
Error::UnusedRamanMicroscopeImageExposureTime = "MicroscopeImageExposureTime is only used when InvertedMicroscopeImage -> True. Change the value of InvertedMicroscopeImage to True or set this option to Null or Automatic for `1`.";

(* objective/optics errors *)
Error::RamanObjectiveMisMatch = "The value of ObjectiveMagnification and FloodLight are conflicting. Change one of these values to specify an available objective or FloodLight for `1`.";
Error::NoRamanObjective = "No ObjectiveMagnification was specified and FloodLight is False. Set FloodLight -> True or select an ObjectiveMagnification for `1`.";
Error::MissingRamanAdjustmentTarget = "LaserPower and/or ExposureTime are set to Optimize, but cannot be executed without the AdjustmentTarget. Please specify a value for this option or set it to Automatic for `1`.";
Error::NoRamanAdjustmentTargetRequired = "AdjustmentTarget is only required if LaserPower and/or ExposureTime are set to Optimize for `1`.";
Error::MissingRamanAdjustmentSample = "LaserPower and/or ExposureTime are set to Optimize, but cannot be executed without the AdjustmentSample. Please specify a value for this option or set it to Automatic for `1`.";
Error::NoRamanAdjustmentSampleRequired = "AdjustmentSample is only required if LaserPower and/or ExposureTime are set to Optimize for `1`.";
Error::MissingRamanAdjustmentEmissionWavelength = "LaserPower and/or ExposureTime are set to Optimize, but cannot be executed without the AdjustmentEmissionWavelength. Please specify a value for this option or set it to Automatic for `1`.";
Error::NoRamanAdjustmentEmissionWavelengthRequired = "AdjustmentEmissionWavelength is only required if LaserPower and/or ExposureTime are set to Optimize for `1`.";
Error::RamanAdjustmentSamplesNotPresent = "The AdjustmentSamples `1` are not included in SamplesIn or Blank and cannot be used to adjust LaserPower or Exposure. Please select a sample that is included in the sample plate.";

(* sample type errors *)

Error::MissingRamanTabletProcessing = "TabletProcessing must be informed when the input sample is a Tablet. Set this option to Automatic or specify a tablet processing value for `1`.";
Error::UnusedRamanTabletProcessing = "TabletProcessing must be set to Automatic or Null when the input sample is not a tablet. Change the value of this option for `1`.";
Error::IncorrectRamanSampleType = "The specified SampleType is not consistent with the sample state or preparation. Verify the physical state of `1`.";
Error::RamanTabletProcessingInconsistancy = "The specified SampleType is in conflict with TabletProcessing for `1`. Please update one of these options.";
Error::InvalidRamanTabletProcessingRequested = "TabletProcessing can only occur on samples which are Tablets. Please set this value to Null or Automatic for `1`.";
Error::RamanSampleTypeRequiresDissolution = "The sample is a solid but SampleType -> Liquid. If you wish to dissolve the sample, prepare a solution outside of this experiment or utilize the PreparatoryUnitOperations option.";

(*sampling pattern errors*)
Error::RamanSwappedXDimensionStepSize = "The SamplingXDimension must be greater than or equal to the SamplingXStepSize for `1`. Please change the value of one of these options.";
Error::RamanSwappedYDimensionStepSize = "The SamplingYDimension must be greater than or equal to the SamplingYStepSize for `1`. Please change the value of one of these options.";
Error::RamanSwappedZDimensionStepSize = "The SamplingZDimension must be greater than or equal to the SamplingZStepSize for `1`. Please change the value of one of these options.";
Error::RamanSwappedInnerOuterDiameter = "The SpiralInnerDiameter is equal to or larger than the SpiralOuterDiameter for `1`. Please change the value of one of these options.";
Error::MissingRamanSamplingCoordinates = "Coordinates must be specified or Automatic when SamplingType -> Coordinates. Please provide specify Coordinates or set it to Automatic for `1`.";
Error::RamanMissingNumberOfSamplingPoints = "NumberOfSamplingPoints must be specified or Automatic when SamplingType -> Rings. Please provide specify NumberOfSamplingPoints or set it to Automatic for `1`.";
Error::RamanMissingNumberOfRings = "NumberOfRings must be specified or Automatic when SamplingType -> Rings. Please provide specify NumberOfRings or set it to Automatic for `1`.";
Error::MissingNumberOfShots = "NumberOfShots must be specified or Automatic when SamplingType -> Rings,Grid, Coordinates or SinglePoint. Please provide specify NumberOfShots or set it to Automatic for `1`.";
Error::MissingRamanSamplingTime = "SamplingTime must be specified or Automatic when SamplingType -> FilledSquare or Spiral. Please provide specify SamplingTime or set it to Automatic for `1`.";
Error::RamanMissingSpiralInnerDiameter = "SpiralInnerDiameter must be specified or Automatic when SamplingType -> Spiral or FilledSpiral. Please provide specify SpiralInnerDiameter or set it to Automatic for `1`.";
Error::RamanMissingSpiralOuterDiameter = "SpiralOuterDiameter must be specified or Automatic when SamplingType -> Spiral or FilledSpiral. Please provide specify SpiralOuterDiameter or set it to Automatic for `1`.";
Error::RamanMissingSpiralResolution = "SpiralResolution must be specified or Automatic when SamplingType -> FilledSpiral. Please provide specify SpiralResolution or set it to Automatic for `1`.";
Error::RamanMissingSpiralFillArea = "SpiralFillArea must be specified or Automatic when SamplingType -> FilledSpiral. Please provide specify SpiralFillArea or set it to Automatic for `1`.";
Error::RamanMissingFilledSquareNumberOfTurns = "FilledSquareNumberOfTurns must be specified or Automatic when SamplingType -> FilledSquare. Please provide specify FilledSquareNumberOfTurns or set it to Automatic for `1`.";
Error::ExcessiveRamanSamplingTime = "The measurement time for samples `1` exceed 2 Hours. Please adjust the parameters `2` to reduce the resolution, duration, overlap or size of the sampling pattern.";
Warning::LongRamanSamplingTime = "The measurement time for samples `1` exceed 20 Minutes. Consider adjusting the parameters  `2` to reduce the resolution, duration, overlap, or size of the sampling pattern.";
Error::RamanSamplingPatternOutOfBounds = "The samples `1` have SamplingPattern parameters `2` which result in a pattern with points outside of the sample well.";
Error::RamanMaxSpeedExceeded = "The samples `1` have SamplingPattern parameters `2` which require the sample stage to move at a speed beyond what it is capable of. Reduce the size of the pattern, increase the time, or decrease the resolution.";
Warning::RamanSamplingCoordinatesPrecision = "The provided SamplingCoordinates have higher precision than the instrument specifications. They have been rounded to the nearest Micrometer.";

Error::MissingRamanSamplingDimension = "The following dimensions are required for the Grid or FilledSquare but not informed for samples `1`: `2`.";
Error::MissingRamanSamplingStepSize = "The following step sizes are required for the Grid or FilledSquare but not informed for samples `1`: `2`.";
Error::UnusedRamanSamplingPatternParameterOption = "The following options are not relevant to the selected SamplingPattern for samples `1`: `2`. Please set these options to Null or Automatic or change the SamplingPattern.";

(* blanks errors *)
Error::TabletWithRamanBlankSample = "The following samples have SampleType->Tablet, for which the Blank option is not supported: `1`. Set Blank to None for these samples.";
Warning::RamanSampleWithoutBlank = "Samples `1` do not have specified Blank. If you wish to subtract out background signal arising from the plate or any solvent or solid matrix, specify an appropriate Object or Window for the Blank option.";
Error::InvalidRamanBlankFormFactor = "The following samples request blanks with the Tablet form factor: `1`. This is not currently supported, please use a liquid or powder blank sample or set Blank to Window or None.";



(* ::Subsubsection::Closed:: *)
(*ExperimentRamanSpectroscopy: Experiment Function*)


ExperimentRamanSpectroscopy[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[ExperimentRamanSpectroscopy]]:=Module[
  {listedOptions,listedSamples,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
    samplePreparationCache,safeOps,safeOpsNamed,safeOpsTests,validLengths,validLengthTests,
    templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,allDownloadValues,
    (* fake object tracking *)
    optionsWithObjects, userSpecifiedObjects, simulatedSampleQ, objectsExistQs, objectsExistTests,
    (* variables from safeOps and download *)
    upload, confirm, fastTrack, parentProt, inheritedCache, samplePreparationPackets, sampleModelPreparationPackets, messages,
    allModelSamplesFromOptions, allObjectSamplesFromOptions, allInstrumentObjectsFromOptions, allObjectsFromOptions, allInstrumentModelsFromOptions,
    containerPreparationPackets, modelPreparationPackets, liquidHandlerContainers, modelContainerPacketFields
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];
  messages = !gatherTests;

  (* Remove temporal links and named objects. *)
  {listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationCache}=simulateSamplePreparationPackets[
      ExperimentRamanSpectroscopy,
      listedSamples,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentRamanSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentRamanSpectroscopy,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  {mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentRamanSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentRamanSpectroscopy,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* get assorted hidden options *)
  {upload, confirm, fastTrack, parentProt, inheritedCache} = Lookup[safeOps, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];


  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentRamanSpectroscopy,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentRamanSpectroscopy,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentRamanSpectroscopy,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];


  (* ---------------------------------------------------- *)
  (* -- Check for Objects that are not in the database -- *)
  (* ---------------------------------------------------- *)

  (* Any options whose values _could_ be an object *)
  optionsWithObjects = Cases[Values[ToList[myOptions]], ObjectP[]];

  (* Extract any objects that the user has explicitly specified *)
  userSpecifiedObjects = DeleteDuplicates@Cases[
    Flatten[{ToList[mySamplesWithPreparedSamples],optionsWithObjects}],
    ObjectP[]
  ];

  (* Check that the specified objects exist or are visible to the current user *)
  simulatedSampleQ = Lookup[fetchPacketFromCache[#,samplePreparationCache],Simulated,False]&/@userSpecifiedObjects;
  objectsExistQs = DatabaseMemberQ[PickList[userSpecifiedObjects,simulatedSampleQ,False]];

  (* Build tests for object existence *)
  objectsExistTests = If[gatherTests,
    MapThread[
      Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
      {PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs}
    ],
    {}
  ];

  (* If objects do not exist, return failure *)
  If[!(And@@objectsExistQs),
    If[!gatherTests,
      Message[Error::ObjectDoesNotExist,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]];
      Message[Error::InvalidInput,PickList[PickList[userSpecifiedObjects,simulatedSampleQ,False],objectsExistQs,False]]
    ];

    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests,objectsExistTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];


  (* ----------------------------------------------------------------------------------- *)
  (* -- DOWNLOAD THE INFORMATION FOR THE OPTION RESOLVER AND RESOURCE PACKET FUNCTION -- *)
  (* ----------------------------------------------------------------------------------- *)
  (*TODO: somethign in here is givign a null packet that used to not do that*)
  (*TODO: need to download the normal sample/container/model fields, along with the insturment. Thats about it. *)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  samplePreparationPackets = Packet[SamplePreparationCacheFields[Object[Sample], Format->Sequence], Volume, IncompatibleMaterials, LiquidHandlerIncompatible, Well, Composition, Tablet];
  sampleModelPreparationPackets = Packet[Model[Flatten[{Products, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials, SamplePreparationCacheFields[Model[Sample]]}]]];
  containerPreparationPackets = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];
  modelPreparationPackets = Packet[SamplePreparationCacheFields[Model[Sample], Format->Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, IncompatibleMaterials];

  (* look up the values of the options and select ones that are objects/models *)
  allObjectsFromOptions = DeleteDuplicates[Cases[Values[KeyDrop[expandedSafeOps, Cache]], ObjectP[], Infinity]];

  (* break into their types *)
  allInstrumentObjectsFromOptions = Cases[allObjectsFromOptions, ObjectP[Object[Instrument,RamanSpectrometer]]];
  allInstrumentModelsFromOptions = Cases[allObjectsFromOptions, ObjectP[Model[Instrument,RamanSpectrometer]]];

  (* download the object here since there will be a packet also from simulation *)
  (* note that we want to avoid duplicates that arise from the SamplesIn potentially being the AdjustmentSample *)
  allObjectSamplesFromOptions = DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Object[Sample]]], Object], Alternatives@@ToList[mySamplesWithPreparedSamples[Object]]];
  allModelSamplesFromOptions = DeleteCases[Download[Cases[allObjectsFromOptions, ObjectP[Model[Sample]]], Object], Alternatives@@ToList[Download[mySamplesWithPreparedSamples, Model[Object], Cache -> samplePreparationCache]]];

  (* get liquid handler compatible containers *)
  ramanLiquidHandlerContainers[]:=(ramanLiquidHandlerContainers[]=hamiltonAliquotContainers["Memoization"]);
  liquidHandlerContainers=ramanLiquidHandlerContainers[];

  (* download fields for liquid handler compatible containers *)
  modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];

  (* make the big download call *)
  allDownloadValues = Quiet[
    Flatten[
      Download[
        {
          ToList[mySamplesWithPreparedSamples],
          allInstrumentObjectsFromOptions,
          allInstrumentModelsFromOptions,
          allObjectSamplesFromOptions,
          allModelSamplesFromOptions
        },
        {
          {
            samplePreparationPackets,
            sampleModelPreparationPackets,
            containerPreparationPackets
          },
          {
            Packet[Object,Name,Status,Model],
            Packet[Model[{Object,Name, WettedMaterials}]]
          },
          {
            Packet[Object, Name, WettedMaterials]
          },
          {
            samplePreparationPackets,
            sampleModelPreparationPackets
          },
          {
            modelPreparationPackets
          }
        },
        Cache -> Flatten[{samplePreparationCache, inheritedCache}]
      ]
    ],
    Download::FieldDoesntExist];

  cacheBall=Cases[FlattenCachePackets[{samplePreparationCache, inheritedCache, allDownloadValues}], PacketP[]];

  (* -------------------------- *)
  (* --- RESOLVE THE OPTIONS ---*)
  (* -------------------------- *)

  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,

    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentRamanSpectroscopyOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentRamanSpectroscopyOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  
  (* ---------------------------- *)
  (* -- PREPARE OPTIONS OUTPUT -- *)
  (* ---------------------------- *)

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentRamanSpectroscopy,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentRamanSpectroscopy,collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* ---------------------------- *)
  (* Build packets with resources *)
  (* ---------------------------- *)

  {resourcePackets,resourcePacketTests} = If[gatherTests,
    ramanSpectroscopyResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
    {ramanSpectroscopyResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions, collapsedResolvedOptions, Cache->cacheBall],{}}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentRamanSpectroscopy,collapsedResolvedOptions],
      Preview -> Null
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
    UploadProtocol[
      resourcePackets,
      Upload->Lookup[safeOps,Upload],
      Confirm->Lookup[safeOps,Confirm],
      ParentProtocol->Lookup[safeOps,ParentProtocol],
      Priority->Lookup[safeOps,Priority],
      StartDate->Lookup[safeOps,StartDate],
      HoldOrder->Lookup[safeOps,HoldOrder],
      QueuePosition->Lookup[safeOps,QueuePosition],
      ConstellationMessage->Object[Protocol,RamanSpectroscopy],
      Cache -> samplePreparationCache
    ],
    $Failed
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentRamanSpectroscopy,collapsedResolvedOptions],
    Preview -> Null
  }
];



(* -------------------------- *)
(* --- CONTAINER OVERLOAD --- *)
(* -------------------------- *)

ExperimentRamanSpectroscopy[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,sampleCache,
    samplePreparationCache,containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests},

  (* Make sure we're working with a list of options *)
  listedOptions=ToList[myOptions];

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache}=simulateSamplePreparationPackets[
      ExperimentRamanSpectroscopy,
      ToList[myContainers],
      ToList[myOptions]
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests}=containerToSampleOptions[
      ExperimentRamanSpectroscopy,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
      Output->{Result,Tests},
      Cache->samplePreparationCache
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      containerToSampleOutput=containerToSampleOptions[
        ExperimentRamanSpectroscopy,
        mySamplesWithPreparedSamples,
        myOptionsWithPreparedSamples,
        Output->Result,
        Cache->samplePreparationCache
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },

    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions, sampleCache}=containerToSampleOutput;

    (* Update our cache with our new simulated values. *)
    (* It is important the sample preparation cache appears first in the cache ball. *)
    updatedCache=Flatten[{
      samplePreparationCache,
      Lookup[sampleOptions,Cache,{}]
    }];

    (* Call our main function with our samples and converted options. *)
    ExperimentRamanSpectroscopy[samples,ReplaceRule[sampleOptions,Cache->updatedCache]]
  ]
];








(* ::Subsection::Closed:: *)
(* resolveExperimentRamanSpectroscopyOptions *)


(* ---------------------- *)
(* -- OPTIONS RESOLVER -- *)
(* ---------------------- *)


DefineOptions[
  resolveExperimentRamanSpectroscopyOptions,
  Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentRamanSpectroscopyOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentBioLayerInterferometryOptions]]:=Module[
  {outputSpecification,output,gatherTests,samplePrepOptions,ramanOptions,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,samplePrepTests, ramanOptionsAssociation,
    ramanTests, invalidInputs,invalidOptions,resolvedAliquotOptions,aliquotTests, resolvedOptions, mapThreadFriendlyOptions, resolvedPostProcessingOptions,
    fastAssoc,sampleModels,
    (* -- download related variables -- *)
    inheritedCache, sampleObjectPrepFields, sampleModelPrepFields, samplePackets, sampleModelPackets, newCache,
    allObjectPackets, allModelPackets, allModelOptions, allObjectOptions,
    liquidHandlerContainers, liquidHandlerContainerPackets,simulatedSamplesContainers,
    (* -- invalid input tests and variables -- *)
    discardedSamplePackets, discardedInvalidInputs,discardedTest, messages,
    modelPacketsToCheckIfDeprecated, deprecatedTest, deprecatedInvalidInputs, deprecatedModelPackets,
    compatibleMaterialsBool, compatibleMaterialsTests, compatibleMaterialsInvalidInputs, lowSampleVolumeTest,
    lowSampleAmountPackets, lowSampleAmountBool, lowSampleMassBool, lowSampleVolumeBool, globalMinMass, globalMinVolume,
    lowSampleAmountInputs, tooManyInputsList,

    (* -- unresolved options -- *)
    instrument, readPattern, calibrationCheck,


    (* -- samples in storage condition -- *)
    samplesInStorageCondition, validSamplesInStorageBool, validSamplesInStorageConditionBools,

    (* -- automatic hidden options -- *)
    resolvedSamplePlate,

    (* -- option rounding -- *)
    roundedGeneralOptions, roundedOptions, precisionTests, roundedSamplingCoordinates, samplingCoordinatesInMicrometers,
    optionPrecisions,

    (* -- experiment specific helper variables -- *)

    (* -- map thread error tracking variables -- *)
    resolvedMapThreadOptionsAssociations, mapThreadErrorCheckingAssociations, resolvedOptionsAssociation, mapThreadErrorCheckingAssociation,
    longTimeRelatedOptionSets, excessiveTimeRelatedOptionSets, maxSpeedExceededOptionSets,

    (* -- bad sample packets from map thread error check -- *)
    samplePacketsWithSwappedInnerOuterDiameter, samplePacketsWithMissingSamplingCoordinates, samplePacketsWithMissingNumberOfSamplingPoints,
    samplePacketsWithMissingNumberOfRings, samplePacketsWithMissingNumberOfShots, samplePacketsWithMissingSamplingTime, samplePacketsWithMissingSpiralInnerDiameter, samplePacketsWithMissingSpiralOuterDiameter,
    samplePacketsWithMissingSpiralResolution, samplePacketsWithMissingSpiralFillArea, samplePacketsWithMissingSamplingXDimension, samplePacketsWithMissingSamplingYDimension,
    samplePacketsWithMissingSamplingZDimension, samplePacketsWithMissingSamplingXStepSize, samplePacketsWithMissingSamplingYStepSize, samplePacketsWithMissingSamplingZStepSize,
    samplePacketsWithMissingFilledSquareNumberOfTurns, samplePacketsWithExcessiveSamplingTime, samplePacketsWithLongSamplingTime,
    samplePacketsWithUnusedRamanSamplingPatternOptions, samplePacketsWithMaxSpeedExceeded, samplePacketsWithPatternsOutOfBounds,
    outOfBoundsOptionSets, samplePacketsWithSwappedXDimension, samplePacketsWithSwappedYDimension, samplePacketsWithSwappedZDimension,

    samplePacketsWithObjectiveMisMatchBool, samplePacketsWithNoObjectiveBool, samplePacketsWithMissingAdjustmentTarget, samplePacketsWithNoAdjustmentTargetRequired,
    samplePacketsWithMissingAdjustmentSample, samplePacketsWithNoAdjustmentSampleRequired, samplePacketsWithMissingAdjustmentEmissionWavelength, samplePacketsWithNoAdjustmentEmissionWavelengthRequired,
    adjustmentSamplesNotOnPlate,

    samplePacketsWithSampleTypeRequiresDissolution, samplePacketsWithInvalidTabletProcessingRequested, samplePacketsWithTabletProcessingInconsistancy,
    samplePacketsWithIncorrectSampleType, samplePacketsWithUnusedTabletProcessing, samplePacketsWithMissingTableProcessing,

    samplePacketsWithMissingMicroscopeImageLightIntensity, samplePacketsWithMissingMicroscopeImageExposureTime, samplePacketsWithUnusedMicroscopeImageLightIntensity, samplePacketsWithUnusedMicroscopeImageExposureTime,

    samplePacketsWithBlankForTablet, samplePacketsWithMissingBlank, samplePacketsWithBlankIsTablet,

    (* -- invalid option tests -- *)
    missingMicroscopeImageLightIntensityTests, unusedMicroscopeImageExposureTimeTests, unusedMicroscopeImageLightIntensityTests, missingRamanMicroscopeImageExposureTimeTests,

    objectiveMisMatchTests, noObjectiveTests, missingAdjustmentTargetTests, noAdjustmentTargetRequiredTests,
    missingAdjustmentSampleTests, noAdjustmentSampleTests, missingAdjustmentEmissionWavelengthTests, noAdjustmentEmissionWavelengthTests,
    adjustmentSampleNotOnPlateTest,

    missingTabletProcessingTests, unusedTabletProcessingTests, incorrectSampleTypeTests, tabletProcessingInconsistancyTests,
    invalidTabletProcessingRequestedTests, sampleTypeRequiresDissolutionTests,

    samplingPatternGroupedTests, unusedSamplingPatternTests,
    tooManySamplesTest, incompatibleSampleTypeTest, numberOfReplicatesNumber,

    blanksAreTabletsTests, blanksForTabletsTests, validSamplesInStorageConditionTests, roundedSamplingCoordinatesTest,
    longSamplingTimeTests, noBlankTests,

    (* -- invalid option tracking -- *)
    invalidMicroscopeImageOptions, invalidOpticsOptions, invalidTabletProcessingOptions, invalidSampleTypeOptions,
    swappedInnerOuterDiameterOptions, missingSamplingCoordinatesOptions, missingNumberOfSamplingPointsOptions, missingNumberOfRingsOptions,
    missingNumberOfShotsOptions, missingSamplingTimeOptions, missingSpiralInnerDiameterOptions, missingSpiralOuterDiameterOptions,
    missingSpiralResolutionOptions, missingSpiralFillAreaOptions, invalidSamplingDimensionOptions, invalidSamplingStepSizeOptions,
    invalidFilledSquareNumberOfTurnsOptions, invalidExcessiveSamplingTimeOptions, unusedSamplingPatternOptions, incompatibleSampleTypesOption,
    maxSpeedExceededOptions, samplingPatternOutOfBoundsOptions, optionsCausingPatternOutOfBounds, invalidBlankOption,
    adjustmentSampleNotOnPlateOptions, invalidSamplesInStorageConditionOption,
    swappedSamplingZDimensionStepSizeOptions, swappedSamplingYDimensionStepSizeOptions, swappedSamplingXDimensionStepSizeOptions,

    (* -- non map thread variables -- *)
    maxNumberOfSamples,

    (* -- aliquot resolution variables -- *)
    sampleContainerPackets, sampleContainerFields,
    sampleVolumes,sampleMasses,tabletBools, bestAliquotAmount, liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,
    potentialAliquotContainers, simulatedSamplesContainerModels, requiredAliquotContainers
  },

  (* ---------------------------------------------- *)
  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
  (* ---------------------------------------------- *)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = !gatherTests;

  (* Fetch our cache from the parent function. *)
  inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

  (* Separate out our BLI options from our Sample Prep options. *)
  {samplePrepOptions, ramanOptions}=splitPrepOptions[myOptions];

  (* Resolve our sample prep options *)
  {{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},samplePrepTests}=If[gatherTests,
    resolveSamplePrepOptions[ExperimentRamanSpectroscopy,mySamples,samplePrepOptions,Cache->inheritedCache,Output->{Result,Tests}],
    {resolveSamplePrepOptions[ExperimentRamanSpectroscopy,mySamples,samplePrepOptions,Cache->inheritedCache,Output->Result],{}}
  ];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  ramanOptionsAssociation = Association[ramanOptions];

  (* Extract the packets that we need from our downloaded cache. *)
  (* we dont know what solutions will be needed yet, is there any way to prevent two download calls here? The solutions in the options will also need a volume check *)

  (* Remember to download from simulatedSamples, using our simulatedCache *)
  sampleObjectPrepFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, State, Volume, Tablet];
  sampleModelPrepFields = Packet[Model[Flatten[{SamplePreparationCacheFields[Model[Sample], Format -> Sequence], State,Products, IncompatibleMaterials, UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock, Deprecated, Tablet}]]];
  sampleContainerFields = Packet[Container[Flatten[{SamplePreparationCacheFields[Object[Container]], Model}]]];
  (*
  (* grab all of the instances of objects in the options and make packets for them - make sure to exclude the cache and also any models/objects found in the input *)
  allObjectOptions = DeleteCases[DeleteDuplicates[Download[Cases[KeyDrop[ramanOptionsAssociation, Cache], ObjectP[Object[Sample]], Infinity], Object]],Alternatives@@ToList[simulatedSamples]];
  allModelOptions =  DeleteDuplicates[Download[Cases[KeyDrop[ramanOptionsAssociation, Cache], ObjectP[Model[Sample]], Infinity],Object]];

  (* also grab the fields that we will need to check *)
  allObjectFields = Packet[Object, Name, State, Container, Composition, IncompatibleMaterials];
  allModelFields = Packet[Object, Name, State, IncompatibleMaterials];
  modelContainerPacketFields=Packet@@Flatten[{Object,SamplePreparationCacheFields[Model[Container]]}];
*)
  (* gatehr a list of potential aliquot containers *)
  liquidHandlerContainers = ramanLiquidHandlerContainers[];
  (*
  {allDownloadValues, allObjectPackets, allModelPackets, liquidHandlerContainerPackets} = Quiet[Download[
    {
      simulatedSamples,
      allObjectOptions,
      allModelOptions,
      liquidHandlerContainers
    },
    {
      {
        sampleObjectPrepFields,
        sampleModelPrepFields,
        sampleContainerFields
      },
      {
        allObjectFields
      },
      {
        allModelFields
      },
      {
        modelContainerPacketFields
      }
    },
    Cache -> simulatedCache
  ], Download::FieldDoesntExist];

  (* split out the sample and model packets *)
  samplePackets = allDownloadValues[[All, 1]];
  sampleModelPackets = allDownloadValues[[All, 2]];
  sampleContainerPackets = allDownloadValues[[All, 3]];
*)


  (*do the download without downloading - make a fast cache for looking up from*)
  fastAssoc = makeFastAssocFromCache[simulatedCache];

  (*no need to download object since all options and inputs are sanitized at the beginning to prevent any issues from named objects popping up*)
  allObjectPackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@allObjectOptions;
  allModelPackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@allModelOptions;
  (*liquidHandlerContainerPackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@liquidHandlerContainers;*)


  (* Find the ContainerModel for each input sample *)
  simulatedSamplesContainerModels = Download[fastAssocLookup[fastAssoc, #, {Container, Model}]&/@simulatedSamples, Object];
  simulatedSamplesContainers = Download[fastAssocLookup[fastAssoc, #, {Container}]&/@simulatedSamples, Object];
  sampleContainerPackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@simulatedSamplesContainers;
  samplePackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@simulatedSamples;
  sampleModels = Download[Lookup[samplePackets, Model], Object];
  sampleModelPackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@sampleModels;

  (*make the new cache, excluding things we dont need in the resolver*)
  newCache = simulatedCache;

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

  (* -------------- *)
  (* -- ROUNDING -- *)
  (* -------------- *)
  (*TODO: something in here is not working properly. Look at DLS as an example for the roundign setup, it may just be that there is some typo in the option names that is freakign it out*)

  (* gather options and their precisions *)
  optionPrecisions={
    {LaserPower,10^0*Percent},
    {MicroscopeImageLightIntensity,10^0*Percent},
    {AdjustmentTarget,10^0*Percent},
    {SpiralFillArea,10^0*Percent},
    {ExposureTime,10^0 Millisecond},
    {MicroscopeImageExposureTime,10^0 Millisecond},
    {SamplingTime,10^0 Second},
    {ReadRestTime,10^0 Second},
    {SpiralInnerDiameter,10^0 Micrometer},
    {SpiralOuterDiameter,10^0 Micrometer},
    {SpiralResolution,10^0 Micrometer},
    {SamplingXDimension, 10^0 Micrometer},
    {SamplingYDimension, 10^0 Micrometer},
    {SamplingZDimension, 10^0 Micrometer},
    {SamplingXStepSize, 10^0 Micrometer},
    {SamplingYStepSize, 10^0 Micrometer},
    {SamplingZStepSize, 10^0 Micrometer},
    {RingSpacing, 10^0 Micrometer},
    {AdjustmentEmissionWavelength, 10^1*1/Centimeter}
  };

  (*expand index matched options then merge them again?*)

  (* big round call on the joined lists of all roundable options *)
  {
    roundedGeneralOptions,
    precisionTests
  } = If[gatherTests,
    RoundOptionPrecision[ramanOptionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All,2]], Output -> {Result, Tests}],
    {
      RoundOptionPrecision[ramanOptionsAssociation,  optionPrecisions[[All,1]], optionPrecisions[[All,2]]],
      {}
    }
  ];

  (* round sampling coordinates since they are too nested for RoundOptionPrecision *)
  samplingCoordinatesInMicrometers = Lookup[ramanOptions, SamplingCoordinates]/.{x_?QuantityQ:>UnitConvert[x,Micrometer]};
  roundedSamplingCoordinates = samplingCoordinatesInMicrometers/.{x_?QuantityQ:>SafeRound[x, 1 Micrometer]};

  (* warn the user if the sampling coordinates are rounded *)
  If[messages&&Not[MatchQ[$ECLApplication, Engine]]&&!MatchQ[roundedSamplingCoordinates, samplingCoordinatesInMicrometers],
    Message[Warning::RamanSamplingCoordinatesPrecision],
    Nothing
  ];

  (* Define the tests the user will see for the above message *)
  roundedSamplingCoordinatesTest=If[gatherTests&&MatchQ[Lookup[ramanOptions, SamplingCoordinates], Except[Null]],
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[roundedSamplingCoordinates, samplingCoordinatesInMicrometers],
        Nothing,
        Warning["SamplingCoordinates have been specified at a higher precision than can be executed by the instrument:",True,False]
      ];
      passingTest=If[MatchQ[roundedSamplingCoordinates, samplingCoordinatesInMicrometers],
        Warning["SamplingCoordinates have been specified at a precision appropriate for the instrument :",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* gather the rounded options association that we will use for the rest of the resolver *)
  roundedOptions = Join[KeyDrop[roundedGeneralOptions, SamplingCoordinates], <|SamplingCoordinates -> roundedSamplingCoordinates|>];

  (* ------------------------------- *)
  (* -- LOOK UP THE OPTION VALUES -- *)
  (* ------------------------------- *)

  (* look up the non index matched options *)
  {
    instrument,
    readPattern,
    calibrationCheck,
    samplesInStorageCondition
  } = Lookup[roundedOptions,
    {
      Instrument,
      ReadPattern,
      CalibrationCheck,
      SamplesInStorageCondition
    }
  ];


  (* --------------------------- *)
  (*-- INPUT VALIDATION CHECKS --*)
  (* --------------------------- *)


  (* -- Compatible Materials Check -- *)

  (* get the boolean for any incompatible materials *)
  {compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[instrument, simulatedSamples, Cache -> newCache, Output -> {Result, Tests}],
    {CompatibleMaterialsQ[instrument, simulatedSamples, Cache -> newCache, Messages -> messages], {}}
  ];

  (* If the materials are incompatible, then the Instrument is invalid *)
  compatibleMaterialsInvalidInputs = If[Not[compatibleMaterialsBool] && messages,
    Download[mySamples, Object],
    {}
  ];


  (* -- Discarded Samples check -- *)

  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
    {},
    Lookup[discardedSamplePackets,Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&!gatherTests,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Cache->newCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[Length[discardedInvalidInputs],0],
        Nothing,
        Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->newCache]<>" are not discarded:",True,False]
      ];

      passingTest=If[MatchQ[Length[discardedInvalidInputs], Length[mySamples]],
        Nothing,
        Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->newCache]<>" are not discarded:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* --- Check if the input samples have Deprecated inputs --- *)

  (* get all the model packets together that are going to be checked for whether they are deprecated *)
  (* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
  modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

  (* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
  deprecatedModelPackets = Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&];

  (* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
  deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
    (
      Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
      Lookup[deprecatedModelPackets, Object, {}]
    ),
    Lookup[deprecatedModelPackets, Object, {}]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> newCache] <> " that are not deprecated:", True, False]
      ];

      passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
        Nothing,
        Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Cache -> newCache] <> " that are not deprecated:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* -- Sample amount check -- *)

  (*get the global minimum volume for sample*)
  globalMinVolume= 100 Microliter;
  globalMinMass = 150 Milligram;
  
  (*check in the sample packets where the volume or mass is too small*)
  (* note that for Tablets we aren't really going to worry since there will always be at least one tablet *)
  lowSampleVolumeBool=Map[MatchQ[Lookup[#,Volume],LessP[globalMinVolume*1.25]]&,samplePackets];
  lowSampleMassBool=Map[MatchQ[Lookup[#,Mass],LessP[globalMinMass*1.25]]&,samplePackets];

  (*find the positions that are true for either*)
  lowSampleAmountBool=MapThread[Or,{lowSampleVolumeBool,lowSampleMassBool}];

  (*get the sample objects that are low volume*)
  lowSampleAmountPackets=PickList[samplePackets,lowSampleAmountBool,True];

  lowSampleAmountInputs=If[Length[lowSampleAmountPackets]>0,
    Lookup[Flatten[lowSampleAmountPackets],Object],
    (* if there are no low quantity inputs, the list is empty *)
    {}
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message *)
  If[Length[lowSampleAmountInputs]>0&&!gatherTests,
    Message[Error::RamanNotEnoughSample,ObjectToString[lowSampleAmountInputs,Cache->newCache]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  lowSampleVolumeTest=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[lowSampleAmountInputs]==0,
        (* when not a single sample is low volume, we know we don't need to throw any failing test *)
        Nothing,
        (* otherwise, we throw one failing test for all low volume quantity *)
        Test["The input sample(s) "<>ObjectToString[lowSampleAmountInputs,Cache->newCache]<>" have enough quantity for measurement:",True,False]
      ];
      passingTest=If[Length[lowSampleAmountInputs]==Length[simulatedSamples],
        (* when ALL samples are low volume, we know we don't need to throw any passing test *)
        Nothing,
        (* otherwise, we throw one passing test for all non-low volume samples *)
        Test["The input sample(s) "<>ObjectToString[Complement[simulatedSamples,lowSampleAmountInputs],Cache->newCache]<>" have enough quantity for measurement:",True,True]
      ];
      {failingTest,passingTest}
    ],
    (* if we're not gathering tests, do Nothing *)
    Nothing
  ];



  (* -- SAMPLES IN STORAGE CONDITION -- *)

  (* determine if incompatible storage conditions have been specified for samples in the same container *)
  (* this will throw warnings if needed *)
  {validSamplesInStorageConditionBools, validSamplesInStorageConditionTests} = Quiet[
    If[gatherTests,
      ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> {Result, Tests}, Cache ->newCache],
      {ValidContainerStorageConditionQ[simulatedSamples, samplesInStorageCondition, Output -> Result, Cache ->newCache], {}}
    ],
    Download::MissingCacheField
  ];

  (* convert to a single boolean *)
  validSamplesInStorageBool = And@@ToList[validSamplesInStorageConditionBools];

  (* collect the bad option to add to invalid options later *)
  invalidSamplesInStorageConditionOption = If[MatchQ[validSamplesInStorageBool, False],
    {SamplesInStorageCondition},
    {}
  ];


  (* =============== *)
  (* == MAPTHREAD == *)
  (* =============== *)

  (*MapThreadFriendlyOptions have the Key value pairs expanded to index match, such that if you call Lookup[options, OptionName], it gives the Option value at the index we are interested in*)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentRamanSpectroscopy, roundedOptions];

  (* since this si a fairly heavy map thread, the output will be an association of the form <| OptionName -> resolvedOptionValue |> so that it is easy to look up aht teh end *)
  (* the error trackers will come out the same way as <| |> *)

  {
    resolvedMapThreadOptionsAssociations,
    mapThreadErrorCheckingAssociations
  } = Transpose[
    MapThread[
      Function[{options, sample},
        Module[
          {
            (* unresolved options - grouped as they were looked up *)
            sampleType, samplingPattern, samplingTime, spiralInnerDiameter, spiralOuterDiameter, spiralResolution,
            spiralFillArea, samplingXDimension, samplingYDimension, samplingZDimension, samplingXStepSize, samplingYStepSize,
            samplingZStepSize, filledSquareNumberOfTurns, ringSpacing, numberOfRings, numberOfSamplingPoints, numberOfShots,
            samplingCoordinates,

            invertedMicroscopeImage, microscopeImageExposure, microscopeImageLightIntensity,

            floodLight, objectiveMagnification, laserPower, exposureTime, adjustmentSample,
            adjustmentTarget, adjustmentEmissionWavelength, backgroundRemove, cosmicRadiationFilter, blank,

            aliquot, targetConcentration, tabletProcessing, numberOfReads, readRestTime,

            (* resolved sampling pattern options *)
            resolvedSamplingTime, resolvedSpiralInnerDiameter, resolvedSpiralOuterDiameter, resolvedSpiralResolution,
            resolvedSpiralFillArea, resolvedSamplingXDimension, resolvedSamplingYDimension, resolvedSamplingZDimension,
            resolvedSamplingXStepSize, resolvedSamplingYStepSize, resolvedSamplingZStepSize, resolvedFilledSquareNumberOfTurns,
            resolvedRingSpacing, resolvedNumberOfRings, resolvedNumberOfSamplingPoints, resolvedSamplingCoordinates, resolvedNumberOfShots,
            (* resolved optics options *)
            resolvedFloodLight, resolvedObjectiveMagnification, resolvedLaserPower, resolvedExposureTime,preResolvedAdjustmentSample,
            resolvedAdjustmentSample, resolvedAdjustmentTarget, resolvedAdjustmentEmissionWavelength,
            (* resolved microscope options *)
            resolvedInvertedMicroscopeImage, resolvedMicroscopeImageExposureTime, resolvedMicroscopeImageLightIntensity,
            (* resolved sample processing options *)
            resolvedTabletProcessing, resolvedSampleType,

            (*resolved blanks*)
            resolvedBlank,

            (*intermediate storage variables*)
            allPatternsResolvedOptions,allPatternsErrorTrackers, unusedPatternOption,

            (* groups of options to gather *)
            resolvedSamplingParameterAssociation, resolvedMicroscopeOptionsAssociation, resolvedOpticsOptionsAssociation,
            resolvedGeneralOptionsAssociation, resolvedBlankOptionsAssociation,

            (* groups of error trackers to gather *)
            samplingPatternErrorTrackerAssociation, microscopeParametersErrorTrackerAssociation, opticsParametersErrorTrackerAssociation,
            generalParametersErrorTrackerAssociation, unusedPatternOptionErrorTrackerAssociation,
            blanksErrorTrackerAssociation,

            (* hidden options *)
            totalSamplingTime,

            (* map thread output *)
            resolvedOptionsAssociation, errorTrackersAssociation
          },

          (* ------------------------------- *)
          (* -- LOOKUP UNRESOLVED OPTIONS -- *)
          (* ------------------------------- *)

          (* -- sample type -- *)
          sampleType = Lookup[options, SampleType];

          (* -- sampling options -- *)
          {
            samplingPattern,
            samplingTime,
            spiralInnerDiameter,
            spiralOuterDiameter,
            spiralResolution,
            spiralFillArea,
            samplingXDimension,
            samplingYDimension,
            samplingZDimension,
            samplingXStepSize,
            samplingYStepSize,
            samplingZStepSize,
            filledSquareNumberOfTurns,
            ringSpacing,
            numberOfRings,
            numberOfSamplingPoints,
            numberOfShots,
            samplingCoordinates
          } = Lookup[options,
            {
              SamplingPattern,
              SamplingTime,
              SpiralInnerDiameter,
              SpiralOuterDiameter,
              SpiralResolution,
              SpiralFillArea,
              SamplingXDimension,
              SamplingYDimension,
              SamplingZDimension,
              SamplingXStepSize,
              SamplingYStepSize,
              SamplingZStepSize,
              FilledSquareNumberOfTurns,
              RingSpacing,
              NumberOfRings,
              NumberOfSamplingPoints,
              NumberOfShots,
              SamplingCoordinates
            }
          ];

          (* -- optical imaging options -- *)
          {
            invertedMicroscopeImage,
            microscopeImageExposure,
            microscopeImageLightIntensity
          } = Lookup[options,
            {
              InvertedMicroscopeImage,
              MicroscopeImageExposureTime,
              MicroscopeImageLightIntensity
            }
          ];

          (* -- objective/adjustment options -- *)
          {
            floodLight,
            objectiveMagnification,
            laserPower,
            exposureTime,
            adjustmentSample,
            adjustmentTarget,
            adjustmentEmissionWavelength,
            backgroundRemove,
            cosmicRadiationFilter,
            blank
          } = Lookup[options,
            {
              FloodLight,
              ObjectiveMagnification,
              LaserPower,
              ExposureTime,
              AdjustmentSample,
              AdjustmentTarget,
              AdjustmentEmissionWavelength,
              BackgroundRemove,
              CosmicRadiationFilter,
              Blank
            }
          ];


          (* -- processing and other options -- *)
          {
            tabletProcessing,
            numberOfReads,
            readRestTime,
            aliquot,
            targetConcentration
          } = Lookup[options,
            {
              TabletProcessing,
              NumberOfReads,
              ReadRestTime,
              Aliquot,
              TargetConcentration
            }
          ];








          (* ------------------------------------ *)
          (* -- Resolve the Microscope Options -- *)
          (* ------------------------------------ *)

          (* Options to resolve: InvertedMicroscopeImage, MicroscopeImageExposureTime, MicroscopeImageLightIntensity *)
          {resolvedMicroscopeOptionsAssociation, microscopeParametersErrorTrackerAssociation} = Module[
            {
              microscopeOptions, microscopeErrorTrackers,
              (* error trackers *)
              missingMicroscopeImageLightIntensity, missingMicroscopeImageExposureTime, unusedMicroscopeImageLightIntensity, unusedMicroscopeImageExposureTime
            },

            (* -- Microscope Image Option Resolution -- *)

            (* resolve the boolean for the optical image based on if any of the relevant parameters are specified *)
            resolvedInvertedMicroscopeImage = If[MemberQ[{microscopeImageExposure, microscopeImageLightIntensity}, Except[Null|Automatic]],
              invertedMicroscopeImage/.Automatic -> True,
              invertedMicroscopeImage/.Automatic -> False
            ];

            (* resolve the exposure time to Optimize if the is going to be optical imaging *)
            resolvedMicroscopeImageExposureTime = If[MatchQ[resolvedInvertedMicroscopeImage, True],
              microscopeImageExposure/.Automatic -> Optimize,
              microscopeImageExposure/.Automatic -> Null
            ];

            (* resolve the light intensity to 10 Percent default if there is optical imaging *)
            resolvedMicroscopeImageLightIntensity = If[MatchQ[resolvedInvertedMicroscopeImage, True],
              microscopeImageLightIntensity/.Automatic -> 10 Percent,
              microscopeImageLightIntensity/.Automatic -> Null
            ];

            (* -- Microscope Image Error Trackers -- *)

            (* check if the intensity is set properly for the value of InvertedMicroscopeImage *)
            {missingMicroscopeImageExposureTime, unusedMicroscopeImageExposureTime} = Which[

              (* imaging is true the exposure time is needed but set to Null by the user *)
              MatchQ[resolvedInvertedMicroscopeImage, True]&&MatchQ[resolvedMicroscopeImageExposureTime, Null],
              {True, False},

              (* imaging is false and this parameter is set but not used *)
              MatchQ[resolvedInvertedMicroscopeImage, False]&&MatchQ[resolvedMicroscopeImageExposureTime, Except[Null]],
              {False, True},

              (*any other scenerio is ok*)
              True,
              {False, False}
            ];

            (* check if the exposure is set properly for the value of InvertedMicroscopeImage *)
            {missingMicroscopeImageLightIntensity, unusedMicroscopeImageLightIntensity} = Which[

              (* imaging is true the light intensity is needed but set to Null by the user *)
              MatchQ[resolvedInvertedMicroscopeImage, True]&&MatchQ[resolvedMicroscopeImageLightIntensity, Null],
              {True, False},

              (* imaging is false and this parameter is set but not used *)
              MatchQ[resolvedInvertedMicroscopeImage, False]&&MatchQ[resolvedMicroscopeImageLightIntensity, Except[Null]],
              {False, True},

              (*any other scenerio is ok*)
              True,
              {False, False}
            ];


            (* -- Microscope Image Wrap Up -- *)

            (* collect the resolved options relevant to the optical microscope images *)
            microscopeOptions = Association[
              InvertedMicroscopeImage -> resolvedInvertedMicroscopeImage,
              MicroscopeImageExposureTime -> resolvedMicroscopeImageExposureTime,
              MicroscopeImageLightIntensity -> resolvedMicroscopeImageLightIntensity
            ];

            (* collect the error tracking variables for the optical microscope images *)
            microscopeErrorTrackers = Association[
              MissingMicroscopeImageLightIntensity -> missingMicroscopeImageLightIntensity,
              MissingMicroscopeImageExposureTime -> missingMicroscopeImageExposureTime,
              UnusedMicroscopeImageLightIntensity -> unusedMicroscopeImageLightIntensity,
              UnusedMicroscopeImageExposureTime -> unusedMicroscopeImageExposureTime
            ];

            (* return the options and errors *)
            {microscopeOptions, microscopeErrorTrackers}
          ];




          (* -------------------------------- *)
          (* -- Resolve the Optics Options -- *)
          (* -------------------------------- *)

          (*
          Options to resolve:FloodLight,ObjectiveMagnification,LaserPower,ExposureTime,AdjustmentSample,AdjustmentTarget,AdjustmentEmissionWavelength,
          Defaults:BackgroundRemove, CosmicRadiationFilter
          *)

          {resolvedOpticsOptionsAssociation, opticsParametersErrorTrackerAssociation} = Module[
            {
              opticsOptions, opticsErrorTrackers,
              (* error trackers *)
              objectiveMisMatchBool, noObjectiveBool, missingAdjustmentTarget, noAdjustmentTargetRequired, missingAdjustmentSample, noAdjustmentSampleRequired,
              missingAdjustmentEmissionWavelength, noAdjustmentEmissionWavelengthRequired, missingAdjustmentParameters, unusedAdjustmentParameters
            },

            (* -- Resolve Optics Options -- *)

            (* resolve the objective based on the value of floodlight and the  *)
            resolvedObjectiveMagnification = If[MatchQ[floodLight, True],
              If[MatchQ[Lookup[resolvedMicroscopeOptionsAssociation, InvertedMicroscopeImage], True],
                objectiveMagnification/.Automatic -> 2,
                objectiveMagnification /.Automatic -> Null
              ],
              objectiveMagnification/.Automatic -> 10
            ];

            (* resolve the floodLight option based on the value of objectiveMagnification  - note, do not worry about if they are doing optical imaging. This shoudl only ever be set to true if they request it or specifically null the objective *)
            resolvedFloodLight = If[MatchQ[resolvedObjectiveMagnification, Null],
              floodLight /.Automatic -> True,
              floodLight /.Automatic -> False
            ];

            (* turn on adjustment parameters based on if they are needed to adjust laser power or exposure time *)

            (* resolve the laser power based on the presence or absence of the adjustmentSample *)
            resolvedLaserPower = If[MemberQ[{adjustmentSample, adjustmentTarget, adjustmentEmissionWavelength}, Except[Null]],
              laserPower/.Automatic -> Optimize,
              laserPower/.Automatic -> 30 Percent
            ];

            (* resolve the exposure time based on the presence or absence of the adjustmentSample *)
            resolvedExposureTime = If[MemberQ[{adjustmentSample, adjustmentTarget, adjustmentEmissionWavelength}, Except[Null]],
              exposureTime/.Automatic -> Optimize,
              exposureTime/.Automatic -> 10 Millisecond
            ];

            (* resolve AdjustmentSample based on if LaserPower or ExposureTime are set to Optimize parameters *)
            preResolvedAdjustmentSample = If[MemberQ[{resolvedLaserPower, resolvedExposureTime}, Optimize],
              adjustmentSample/.Automatic ->sample,
              adjustmentSample/.Automatic -> Null
            ];

            (* we may also need to swap out the All symbol for the object that it represents. This does not constitute changing the user option as the meaning of the option does not change *)
            resolvedAdjustmentSample = preResolvedAdjustmentSample/.(All->sample);

            (* resolve the adjustment target based on if other adjustment parameters are set *)
            resolvedAdjustmentTarget = If[MemberQ[{resolvedLaserPower, resolvedExposureTime}, Optimize],
              adjustmentTarget/.Automatic -> 50 Percent,
              adjustmentTarget/.Automatic -> Null
            ];

            (* resolve the adjustment wavelength based on if other adjustment parameters are set *)
            resolvedAdjustmentEmissionWavelength = If[MemberQ[{resolvedLaserPower, resolvedExposureTime}, Optimize],
              adjustmentEmissionWavelength/.Automatic -> Max,
              adjustmentEmissionWavelength/.Automatic -> Null
            ];


            (* -- Optics Error Tracking Variables -- *)

            (* check if there are any mismatches between the flood light and objective settings. It really does not make sense to have floodlight and anything more than the 2X *)
            objectiveMisMatchBool = If[MatchQ[resolvedObjectiveMagnification, Except[Null|2]]&&MatchQ[resolvedFloodLight, True],
              True,
              False
            ];

            (* check that there is an objective, either defined by the objective mag or the flood light boolean *)
            noObjectiveBool = If[MatchQ[resolvedObjectiveMagnification, Null]&&MatchQ[resolvedFloodLight, False],
              True,
              False
            ];

            (* check that the adjustment parameters are specified if they are needed *)
            missingAdjustmentParameters = If[MemberQ[{resolvedLaserPower, resolvedExposureTime}, Optimize],
              PickList[
                {AdjustmentTarget, AdjustmentSample, AdjustmentExcitationWavelength},
                {resolvedAdjustmentTarget, resolvedAdjustmentSample, resolvedAdjustmentEmissionWavelength},
                Null
              ],
              {}
            ];

            (* check if the adjustment parameters are specified but not needed/not used *)
            unusedAdjustmentParameters = If[MatchQ[{resolvedLaserPower, resolvedExposureTime}, {Except[Optimize], Except[Optimize]}],
              PickList[
                {AdjustmentTarget, AdjustmentSample, AdjustmentExcitationWavelength},
                {resolvedAdjustmentTarget, resolvedAdjustmentSample, resolvedAdjustmentEmissionWavelength},
                Except[Null]
              ],
              {}
            ];

            (* get the more specific booleans for each parameter to throw more helpful errors about missing adjustment parameters *)
            {
              missingAdjustmentTarget,
              missingAdjustmentSample,
              missingAdjustmentEmissionWavelength
            } = Map[
              If[MemberQ[missingAdjustmentParameters, #],
                True,
                False
              ]&,
              {AdjustmentTarget, AdjustmentSample, AdjustmentExcitationWavelength}
            ];

            (* get more specific booleans to throw errors about unused adjustment parameters *)
            {
              noAdjustmentTargetRequired,
              noAdjustmentSampleRequired,
              noAdjustmentEmissionWavelengthRequired
            } = Map[
              If[MemberQ[unusedAdjustmentParameters, #],
                True,
                False
              ]&,
              {AdjustmentTarget, AdjustmentSample, AdjustmentExcitationWavelength}
            ];

            (* TODO: could increase error checking for laser power and exposure options to prevnet super weird values (warning high power, warning high/low exposure) *)
            (*TODO: check for valid adjustment samples maybe to this outside of the map thread so we can also warn if you are calibrating with sample of a different state*)

            (* collect the resolved options *)
            opticsOptions = Association[
              FloodLight -> resolvedFloodLight,
              ObjectiveMagnification -> resolvedObjectiveMagnification,
              LaserPower -> resolvedLaserPower,
              ExposureTime -> resolvedExposureTime,
              AdjustmentSample -> resolvedAdjustmentSample,
              AdjustmentTarget -> resolvedAdjustmentTarget,
              AdjustmentEmissionWavelength -> resolvedAdjustmentEmissionWavelength
            ];

            (* collect the error tracking variables for the optics options *)
            opticsErrorTrackers = Association[
              ObjectiveMisMatchBool -> objectiveMisMatchBool,
              NoObjectiveBool -> noObjectiveBool,
              MissingAdjustmentTarget -> missingAdjustmentTarget,
              NoAdjustmentTargetRequired -> noAdjustmentTargetRequired,
              MissingAdjustmentSample -> missingAdjustmentSample,
              NoAdjustmentSampleRequired -> noAdjustmentSampleRequired,
              MissingAdjustmentEmissionWavelength -> missingAdjustmentEmissionWavelength,
              NoAdjustmentEmissionWavelengthRequired -> noAdjustmentEmissionWavelengthRequired
            ];

            (* return the options and errors *)
            {opticsOptions, opticsErrorTrackers}
          ];



          (* ---------------------------------- *)
          (* -- Resolve the Sample Processing --*)
          (* ---------------------------------- *)

          (* Options to resolve: tabletProcessing,sampleType *)
          {resolvedGeneralOptionsAssociation, generalParametersErrorTrackerAssociation} = Module[
            {generalOptions, generalErrorTrackers,
              (* error tracking variables *)
              sampleTypeRequiresDissolution, invalidTabletProcessingRequested, tabletProcessingInconsistancy, incorrectSampleType, unusedTabletProcessing, missingTableProcessing,
              (*  other variables*)
              sampleState, sampleTabletBool, safeSampleTabletBool, computedSampleState
            },

            (* -- setup -- *)


            (* get the stat from teh simulated sample packets *)
            sampleState = fastAssocLookup[fastAssoc, sample, State];
            sampleTabletBool = fastAssocLookup[fastAssoc, sample, Tablet];

            safeSampleTabletBool = sampleTabletBool/.Null->False;
            (* -- Resolve the other options -- *)

            (* resolve tablet processing based on A) if it is a tablet and B) if the sample type is Solid *)
            resolvedTabletProcessing = If[MatchQ[safeSampleTabletBool, True],
              If[MatchQ[sampleType, Powder],
                tabletProcessing/.Automatic -> Grind,
                tabletProcessing/.Automatic -> Whole
              ],
              tabletProcessing/.Automatic -> Null
            ];

            (* determine teh state of the sample as it will be in the plate. This is to determine which type of plate to use since Tablet coudl result ina powder that needs a 96 well rather than the tablet holder *)
            computedSampleState = Which[

              (* make sure to put this first since tablets are also State -> Solid *)
              MatchQ[safeSampleTabletBool, True],
              If[MatchQ[resolvedTabletProcessing, Grind],
                Powder,
                Tablet
              ],

              MatchQ[sampleState, Solid],
              Powder,

              MatchQ[sampleState, Liquid],
              Liquid,

              (* if the sample uses prep primitives, it is not going to have anything informed so we will guess that its a liquid *)
              True,
              Liquid
            ];

            (* resolve the SampleType *)
            resolvedSampleType = sampleType/.Automatic -> computedSampleState;


            (* -- Error tracking variables for random options -- *)

            (* check if the sampleType is given as liquid for a solid sample *)
            sampleTypeRequiresDissolution = If[MatchQ[{resolvedSampleType, computedSampleState}, {Liquid,Powder}],
              True,
              False
            ];

            (* check if the sample is a tablet but they are requesting a liquid - we cant do that right now *)
            invalidTabletProcessingRequested = If[MatchQ[{resolvedSampleType, computedSampleState}, {Liquid,Tablet}],
              True,
              False
            ];

            (* check if the sampleType is Tablet but they had groudn it up this is a pretty reasonable mistake but needs a hard error since tablet and solid are two different procedure branches *)
            tabletProcessingInconsistancy = If[MatchQ[{resolvedSampleType, computedSampleState}, {Powder,Tablet}],
              True,
              False
            ];

            (* if it is a Liquid and set to Powder or Tablet, throw a different error since it cant be corrected *)
            incorrectSampleType = If[MatchQ[{resolvedSampleType, computedSampleState}, {(Tablet|Powder), Liquid}],
              True,
              False
            ];

            (* if there are processing parameters set but the input is not a tablet, set teh error tracker to True *)
            unusedTabletProcessing = If[MatchQ[resolvedTabletProcessing, Except[Null]]&&MatchQ[safeSampleTabletBool, False],
              True,
              False
            ];

            (* if there are table inputs but the processing is Null, also need to throw an error *)
            missingTableProcessing = If[MatchQ[resolvedTabletProcessing, Null]&&MatchQ[safeSampleTabletBool, True],
              True,
              False
            ];


            (* gather the general resolved options *)
            generalOptions = Association[
              TabletProcessing -> resolvedTabletProcessing,
              SampleType -> resolvedSampleType
            ];

            (*gather the general error trackers*)
            generalErrorTrackers = Association[
              SampleTypeRequiresDissolution -> sampleTypeRequiresDissolution,
              InvalidTabletProcessingRequested -> invalidTabletProcessingRequested,
              TabletProcessingInconsistancy -> tabletProcessingInconsistancy,
              IncorrectSampleType -> incorrectSampleType,
              UnusedTabletProcessing -> unusedTabletProcessing,
              MissingTableProcessing -> missingTableProcessing
            ];

            (* return the options and errors *)
            {generalOptions, generalErrorTrackers}
          ];




          (* ------------------------------- *)
          (* -- Resolve the Blank Option -- *)
          (* ------------------------------- *)



          (* Options to resolve: InvertedMicroscopeImage, MicroscopeImageExposureTime, MicroscopeImageLightIntensity *)
          {resolvedBlankOptionsAssociation, blanksErrorTrackerAssociation} = Module[
            {
              blankOption, blankErrorTrackers,
              (* error trackers *)
              missingBlankBool, blankForTabletBool, blankIsTabletBool
            },

            (* -- Blank Option Resolution -- *)

            (* resolve the blank based on if there is a glass window or not (tablets are measured directly) *)
            resolvedBlank = If[MatchQ[resolvedSampleType, Tablet],
              blank/.Automatic -> None,
              blank/.Automatic -> Window
            ];




            (* -- Blank Error Trackers -- *)

            (* if there is no blank and the samples are liquids/solids warn the user*)
            missingBlankBool = If[MatchQ[resolvedBlank, None]&&MatchQ[resolvedSampleType, Except[Tablet]],
              True,
              False
            ];

            (* do not blanks for tablets *)
            blankForTabletBool = If[MatchQ[resolvedBlank, Except[None]]&&MatchQ[resolvedSampleType, Tablet],
              True,
              False
            ];

            (* do not allow blanks that are tablets *)
            blankIsTabletBool = If[MatchQ[fastAssocLookup[fastAssoc, resolvedBlank, Tablet], True],
              True,
              False
            ];


            (* -- Blank Wrap Up -- *)

            (* collect the resolved options relevant to the optical microscope images *)
            blankOption = Association[
              Blank -> resolvedBlank
            ];

            (* collect the error tracking variables for the optical microscope images *)
            blankErrorTrackers = Association[
              BlankIsTablet -> blankIsTabletBool,
              BlankForTablet -> blankForTabletBool,
              MissingBlank -> missingBlankBool
            ];

            (* return the options and errors *)
            {blankOption, blankErrorTrackers}
          ];






          (* ----------------------------------------- *)
          (* -- Resolve Sampling Pattern Parameters -- *)
          (* ----------------------------------------- *)
          (*
          Options to resolve are:
              SamplingTime,
              SpiralInnerDiameter,
              SpiralOuterDiameter,
              SpiralResolution,
              SpiralFillArea,
              SamplingXDimension,
              SamplingYDimension,
              SamplingZDimension,
              SamplingXStepSize,
              SamplingYStepSize,
              SamplingZStepSize,
              FilledSquareNumberOfTurns,
              RingSpacing,
              NumberOfRings,
              NumberOfSamplingPoints,
              NumberOfShots,
              SamplingCoordinates
          *)

          (* set the parameters based on the samplingPattern - note that the resolved Variables are in the MapThread Module *)
          {resolvedSamplingParameterAssociation, unusedPatternOptionErrorTrackerAssociation} = Module[{},
            Switch[
            samplingPattern,

            (* ----------- 1 --------------- *)
            (* -- Resolve for SinglePoint -- *)

            SinglePoint,
            Module[{},

              (*Resolve all the Automatic Nulls*)
              {
                resolvedSamplingTime,
                resolvedSpiralInnerDiameter,
                resolvedSpiralOuterDiameter,
                resolvedSpiralResolution,
                resolvedSpiralFillArea,
                resolvedSamplingXDimension,
                resolvedSamplingYDimension,
                resolvedSamplingZDimension,
                resolvedSamplingXStepSize,
                resolvedSamplingYStepSize,
                resolvedSamplingZStepSize,
                resolvedFilledSquareNumberOfTurns,
                resolvedRingSpacing,
                resolvedNumberOfRings,
                resolvedNumberOfSamplingPoints,
                resolvedSamplingCoordinates
              } = {
                samplingTime,
                spiralInnerDiameter,
                spiralOuterDiameter,
                spiralResolution,
                spiralFillArea,
                samplingXDimension,
                samplingYDimension,
                samplingZDimension,
                samplingXStepSize,
                samplingYStepSize,
                samplingZStepSize,
                filledSquareNumberOfTurns,
                ringSpacing,
                numberOfRings,
                numberOfSamplingPoints,
                samplingCoordinates
              }/.Automatic ->Null;

              (* resolve the number of shots *)
              resolvedNumberOfShots = numberOfShots/.Automatic -> 5;

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SamplingTime,
                SpiralInnerDiameter,
                SpiralOuterDiameter,
                SpiralResolution,
                SpiralFillArea,
                SamplingXDimension,
                SamplingYDimension,
                SamplingZDimension,
                SamplingXStepSize,
                SamplingYStepSize,
                SamplingZStepSize,
                FilledSquareNumberOfTurns,
                RingSpacing,
                NumberOfRings,
                NumberOfSamplingPoints,
                SamplingCoordinates
              },
                {
                  resolvedSamplingTime,
                  resolvedSpiralInnerDiameter,
                  resolvedSpiralOuterDiameter,
                  resolvedSpiralResolution,
                  resolvedSpiralFillArea,
                  resolvedSamplingXDimension,
                  resolvedSamplingYDimension,
                  resolvedSamplingZDimension,
                  resolvedSamplingXStepSize,
                  resolvedSamplingYStepSize,
                  resolvedSamplingZStepSize,
                  resolvedFilledSquareNumberOfTurns,
                  resolvedRingSpacing,
                  resolvedNumberOfRings,
                  resolvedNumberOfSamplingPoints,
                  resolvedSamplingCoordinates
                },
                Except[Null]
              ]
            ],


            (* ----------- 2 ---------- *)
            (* -- Resolve for Spiral -- *)

            Spiral,
            Module[{},

              (*Resolve all the Automatic Nulls*)
              {
                resolvedSpiralResolution,
                resolvedSpiralFillArea,
                resolvedSamplingXDimension,
                resolvedSamplingYDimension,
                resolvedSamplingZDimension,
                resolvedSamplingXStepSize,
                resolvedSamplingYStepSize,
                resolvedSamplingZStepSize,
                resolvedFilledSquareNumberOfTurns,
                resolvedRingSpacing,
                resolvedNumberOfRings,
                resolvedNumberOfSamplingPoints,
                resolvedSamplingCoordinates,
                resolvedNumberOfShots
              } = {
                spiralResolution,
                spiralFillArea,
                samplingXDimension,
                samplingYDimension,
                samplingZDimension,
                samplingXStepSize,
                samplingYStepSize,
                samplingZStepSize,
                filledSquareNumberOfTurns,
                ringSpacing,
                numberOfRings,
                numberOfSamplingPoints,
                samplingCoordinates,
                numberOfShots
              }/.Automatic ->Null;

              (* resolve the sampling time *)
              resolvedSamplingTime = samplingTime/.Automatic->600 Second;

              (* resolve the inner diameter *)
              resolvedSpiralInnerDiameter = Which[
                MatchQ[spiralOuterDiameter, Automatic],
                spiralInnerDiameter/.Automatic -> 50 Micrometer,

                MatchQ[spiralOuterDiameter, LessP[100 Micrometer]],
                spiralInnerDiameter/.Automatic -> 1 Micrometer,

                (* if it is larger than 100 Micrometer, set to 50 Micrometer *)
                True,
                spiralInnerDiameter/.Automatic -> 50 Micrometer
              ];

              (* resolve the outer diameter *)
              resolvedSpiralOuterDiameter = Which[

                MatchQ[spiralInnerDiameter, Automatic],
                spiralOuterDiameter/.Automatic->200 Micrometer,

                MatchQ[spiralInnerDiameter, LessP[100 Micrometer]],
                spiralOuterDiameter/.Automatic -> 200 Micrometer,

                MatchQ[spiralInnerDiameter, GreaterEqualP[100 Micrometer]],
                spiralOuterDiameter/.Automatic -> (resolvedSpiralInnerDiameter + 200 Micrometer),

                True,
                spiralOuterDiameter/.Automatic -> 200 Micrometer
              ];

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SpiralResolution,
                SpiralFillArea,
                SamplingXDimension,
                SamplingYDimension,
                SamplingZDimension,
                SamplingXStepSize,
                SamplingYStepSize,
                SamplingZStepSize,
                FilledSquareNumberOfTurns,
                RingSpacing,
                NumberOfRings,
                NumberOfSamplingPoints,
                NumberOfShots,
                SamplingCoordinates
              },
                {
                  resolvedSpiralResolution,
                  resolvedSpiralFillArea,
                  resolvedSamplingXDimension,
                  resolvedSamplingYDimension,
                  resolvedSamplingZDimension,
                  resolvedSamplingXStepSize,
                  resolvedSamplingYStepSize,
                  resolvedSamplingZStepSize,
                  resolvedFilledSquareNumberOfTurns,
                  resolvedRingSpacing,
                  resolvedNumberOfRings,
                  resolvedNumberOfSamplingPoints,
                  resolvedNumberOfShots,
                  resolvedSamplingCoordinates
                },
                Except[Null]
              ]
            ],


            (* ----------- 3 ---------------- *)
            (* -- Resolve for FilledSpiral -- *)

            FilledSpiral,
            Module[{},

              (*Resolve all the Automatic Nulls*)
              {
                resolvedSamplingTime,
                resolvedSamplingXDimension,
                resolvedSamplingYDimension,
                resolvedSamplingZDimension,
                resolvedSamplingXStepSize,
                resolvedSamplingYStepSize,
                resolvedSamplingZStepSize,
                resolvedFilledSquareNumberOfTurns,
                resolvedRingSpacing,
                resolvedNumberOfRings,
                resolvedNumberOfSamplingPoints,
                resolvedSamplingCoordinates,
                resolvedNumberOfShots
              } = {
                samplingTime,
                samplingXDimension,
                samplingYDimension,
                samplingZDimension,
                samplingXStepSize,
                samplingYStepSize,
                samplingZStepSize,
                filledSquareNumberOfTurns,
                ringSpacing,
                numberOfRings,
                numberOfSamplingPoints,
                samplingCoordinates,
                numberOfShots
              }/.Automatic ->Null;

              (* resolve the inner diameter *)
              resolvedSpiralInnerDiameter = Which[
                MatchQ[spiralOuterDiameter, Automatic],
                spiralInnerDiameter/.Automatic -> 50 Micrometer,

                MatchQ[spiralOuterDiameter, LessP[100 Micrometer]],
                spiralInnerDiameter/.Automatic -> 1 Micrometer,

                (* if it is larger than 100 Micrometer, set to 50 Micrometer *)
                True,
                spiralInnerDiameter/.Automatic -> 50 Micrometer
              ];

              (* resolve the outer diameter *)
              resolvedSpiralOuterDiameter = Which[

                MatchQ[spiralInnerDiameter, Automatic],
                spiralOuterDiameter/.Automatic->200 Micrometer,

                MatchQ[spiralInnerDiameter, LessP[100 Micrometer]],
                spiralOuterDiameter/.Automatic -> 200 Micrometer,

                MatchQ[spiralInnerDiameter, GreaterEqualP[100 Micrometer]],
                spiralOuterDiameter/.Automatic -> (resolvedSpiralInnerDiameter + 200 Micrometer),

                True,
                spiralOuterDiameter/.Automatic -> 200 Micrometer
              ];

              (* resolve the resolution *)
              (*TODO: may want to be time sensetive with this? Smarter resolution?*)
              resolvedSpiralResolution = spiralResolution/.Automatic -> 50 Micrometer;

              (* resolve the fill area, again it could be possible to fill this based on the objective etc. but woudl require re-ordering this section  *)
              resolvedSpiralFillArea = spiralFillArea/.Automatic -> 60 Percent;

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SamplingTime,
                SamplingXDimension,
                SamplingYDimension,
                SamplingZDimension,
                SamplingXStepSize,
                SamplingYStepSize,
                SamplingZStepSize,
                FilledSquareNumberOfTurns,
                RingSpacing,
                NumberOfRings,
                NumberOfSamplingPoints,
                NumberOfShots,
                SamplingCoordinates
              },
                {
                  resolvedSamplingTime,
                  resolvedSamplingXDimension,
                  resolvedSamplingYDimension,
                  resolvedSamplingZDimension,
                  resolvedSamplingXStepSize,
                  resolvedSamplingYStepSize,
                  resolvedSamplingZStepSize,
                  resolvedFilledSquareNumberOfTurns,
                  resolvedRingSpacing,
                  resolvedNumberOfRings,
                  resolvedNumberOfSamplingPoints,
                  resolvedNumberOfShots,
                  resolvedSamplingCoordinates
                },
                Except[Null]
              ]
            ],


            (* ------------ 4 --------------- *)
            (* -- Resolve for FilledSquare -- *)

            FilledSquare,
            Module[{},

              (*Resolve all the Automatic Nulls*)
              {
                resolvedSpiralInnerDiameter,
                resolvedSpiralOuterDiameter,
                resolvedSpiralResolution,
                resolvedSpiralFillArea,
                resolvedSamplingZDimension,
                resolvedSamplingXStepSize,
                resolvedSamplingYStepSize,
                resolvedSamplingZStepSize,
                resolvedRingSpacing,
                resolvedNumberOfRings,
                resolvedNumberOfSamplingPoints,
                resolvedSamplingCoordinates,
                resolvedNumberOfShots
              } = {
                spiralInnerDiameter,
                spiralOuterDiameter,
                spiralResolution,
                spiralFillArea,
                samplingZDimension,
                samplingXStepSize,
                samplingYStepSize,
                samplingZStepSize,
                ringSpacing,
                numberOfRings,
                numberOfSamplingPoints,
                samplingCoordinates,
                numberOfShots
              }/.Automatic ->Null;

              (* resolve the amount of time that sampling happens for *)
              resolvedSamplingTime = samplingTime/.Automatic->600 Second;

              (* resolve the x and y dimensions of the area that is sampled *)
              resolvedSamplingXDimension = samplingXDimension/.Automatic->100 Micrometer;
              resolvedSamplingYDimension = samplingYDimension/.Automatic->100 Micrometer;

              (* generate  fill pattern with 5 turns. Note that the number of turns is not dependnt on the size of the apttern inan y way *)
              resolvedFilledSquareNumberOfTurns = filledSquareNumberOfTurns/.Automatic -> 5;

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SpiralInnerDiameter,
                SpiralOuterDiameter,
                SpiralResolution,
                SpiralFillArea,
                SamplingZDimension,
                SamplingXStepSize,
                SamplingYStepSize,
                SamplingZStepSize,
                RingSpacing,
                NumberOfRings,
                NumberOfSamplingPoints,
                NumberOfShots,
                SamplingCoordinates
              },
                {
                  resolvedSpiralInnerDiameter,
                  resolvedSpiralOuterDiameter,
                  resolvedSpiralResolution,
                  resolvedSpiralFillArea,
                  resolvedSamplingZDimension,
                  resolvedSamplingXStepSize,
                  resolvedSamplingYStepSize,
                  resolvedSamplingZStepSize,
                  resolvedRingSpacing,
                  resolvedNumberOfRings,
                  resolvedNumberOfSamplingPoints,
                  resolvedNumberOfShots,
                  resolvedSamplingCoordinates
                },
                Except[Null]
              ]
            ],


            (* --------- 5 ---------- *)
            (* -- Resolve for Grid -- *)

            Grid,
            Module[{},

              (*Resolve all the Automatic Nulls*)
              {
                resolvedSamplingTime,
                resolvedSpiralInnerDiameter,
                resolvedSpiralOuterDiameter,
                resolvedSpiralResolution,
                resolvedSpiralFillArea,
                resolvedFilledSquareNumberOfTurns,
                resolvedRingSpacing,
                resolvedNumberOfRings,
                resolvedNumberOfSamplingPoints,
                resolvedSamplingCoordinates
              } = {
                samplingTime,
                spiralInnerDiameter,
                spiralOuterDiameter,
                spiralResolution,
                spiralFillArea,
                filledSquareNumberOfTurns,
                ringSpacing,
                numberOfRings,
                numberOfSamplingPoints,
                samplingCoordinates
              }/.Automatic ->Null;

              (* resolve the grid dimensions, default to a 2-D grid and if the step size has been specified, set this to make there be 10 steps*)
              resolvedSamplingXDimension = If[
                MatchQ[samplingXStepSize, _?QuantityQ],
                samplingXDimension/.Automatic :> Round[samplingXStepSize*10, 1 Micrometer],
                samplingXDimension/.Automatic -> 200 Micrometer
              ];
              resolvedSamplingYDimension = If[
                MatchQ[samplingYStepSize, _?QuantityQ],
                samplingYDimension/.Automatic :> Round[samplingYStepSize*10, 1 Micrometer],
                samplingYDimension/.Automatic -> 200 Micrometer
              ];
              resolvedSamplingZDimension = If[MatchQ[samplingZStepSize, _?QuantityQ],
                samplingZDimension/.Automatic :> Round[samplingZStepSize*5, 1 Micrometer],
                samplingZDimension/.Automatic -> 0 Micrometer
              ];

              (* resolve the step sizes based on the dimensions. Do this for the Z dimension to avoid having a 0 step size for a non zero dimension. Plan on 10 steps. *)
              resolvedSamplingXStepSize = If[MatchQ[resolvedSamplingXDimension, _?QuantityQ],
                samplingXStepSize/.Automatic :>SafeRound[resolvedSamplingXDimension/10, 1 Micrometer, AvoidZero -> True],
                samplingXStepSize/.Automatic -> 10 Micrometer
              ];
              resolvedSamplingYStepSize = If[MatchQ[resolvedSamplingYDimension, _?QuantityQ],
                samplingYStepSize/.Automatic :>SafeRound[resolvedSamplingYDimension/10, 1 Micrometer, AvoidZero ->True],
                samplingYStepSize/.Automatic -> 10 Micrometer
              ];
              resolvedSamplingZStepSize = If[MatchQ[resolvedSamplingZDimension, _?QuantityQ],
                samplingZStepSize/.Automatic :>SafeRound[resolvedSamplingZDimension/10, 1 Micrometer, AvoidZero ->True],
                samplingZStepSize/.Automatic -> 10 Micrometer
              ];

              (* resolve the number of times each point is sampled *)
              resolvedNumberOfShots = numberOfShots/.Automatic->5;

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SamplingTime,
                SpiralInnerDiameter,
                SpiralOuterDiameter,
                SpiralResolution,
                SpiralFillArea,
                FilledSquareNumberOfTurns,
                RingSpacing,
                NumberOfRings,
                NumberOfSamplingPoints,
                SamplingCoordinates
              },
                {
                  resolvedSamplingTime,
                  resolvedSpiralInnerDiameter,
                  resolvedSpiralOuterDiameter,
                  resolvedSpiralResolution,
                  resolvedSpiralFillArea,
                  resolvedFilledSquareNumberOfTurns,
                  resolvedRingSpacing,
                  resolvedNumberOfRings,
                  resolvedNumberOfSamplingPoints,
                  resolvedSamplingCoordinates
                },
                Except[Null]
              ]
            ],


            (* ---------- 6 ---------- *)
            (* -- Resolve for Rings -- *)

            Rings,
            Module[{},

              (*Resolve all the Automatic Nulls*)
              {
                resolvedSamplingTime,
                resolvedSpiralInnerDiameter,
                resolvedSpiralOuterDiameter,
                resolvedSpiralResolution,
                resolvedSpiralFillArea,
                resolvedSamplingXDimension,
                resolvedSamplingYDimension,
                resolvedSamplingZDimension,
                resolvedSamplingXStepSize,
                resolvedSamplingYStepSize,
                resolvedSamplingZStepSize,
                resolvedFilledSquareNumberOfTurns,
                resolvedSamplingCoordinates
              } = {
                samplingTime,
                spiralInnerDiameter,
                spiralOuterDiameter,
                spiralResolution,
                spiralFillArea,
                samplingXDimension,
                samplingYDimension,
                samplingZDimension,
                samplingXStepSize,
                samplingYStepSize,
                samplingZStepSize,
                filledSquareNumberOfTurns,
                samplingCoordinates
              }/.Automatic ->Null;

              (* resolve the ring parameters, again this could be made smarter *)
              resolvedRingSpacing = ringSpacing/.Automatic -> 100 Micrometer;
              resolvedNumberOfRings = numberOfRings/.Automatic -> 5;
              resolvedNumberOfSamplingPoints = numberOfSamplingPoints/.Automatic -> 30;
              resolvedNumberOfShots = numberOfShots/.Automatic -> 5;

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SamplingTime,
                SpiralInnerDiameter,
                SpiralOuterDiameter,
                SpiralResolution,
                SpiralFillArea,
                SamplingXDimension,
                SamplingYDimension,
                SamplingZDimension,
                SamplingXStepSize,
                SamplingYStepSize,
                SamplingZStepSize,
                FilledSquareNumberOfTurns,
                SamplingCoordinates
              },
                {
                  resolvedSamplingTime,
                  resolvedSpiralInnerDiameter,
                  resolvedSpiralOuterDiameter,
                  resolvedSpiralResolution,
                  resolvedSpiralFillArea,
                  resolvedSamplingXDimension,
                  resolvedSamplingYDimension,
                  resolvedSamplingZDimension,
                  resolvedSamplingXStepSize,
                  resolvedSamplingYStepSize,
                  resolvedSamplingZStepSize,
                  resolvedFilledSquareNumberOfTurns,
                  resolvedSamplingCoordinates
                },
                Except[Null]
              ]
            ],


            (* ------------- 7 ------------- *)
            (* -- Resolve for Coordinates -- *)

            Coordinates,
            Module[{},
              (*Resolve all the Automatic Nulls*)
              {
                resolvedSamplingTime,
                resolvedSpiralInnerDiameter,
                resolvedSpiralOuterDiameter,
                resolvedSpiralResolution,
                resolvedSpiralFillArea,
                resolvedSamplingXDimension,
                resolvedSamplingYDimension,
                resolvedSamplingZDimension,
                resolvedSamplingXStepSize,
                resolvedSamplingYStepSize,
                resolvedSamplingZStepSize,
                resolvedFilledSquareNumberOfTurns,
                resolvedRingSpacing,
                resolvedNumberOfRings,
                resolvedNumberOfSamplingPoints
              } = {
                samplingTime,
                spiralInnerDiameter,
                spiralOuterDiameter,
                spiralResolution,
                spiralFillArea,
                samplingXDimension,
                samplingYDimension,
                samplingZDimension,
                samplingXStepSize,
                samplingYStepSize,
                samplingZStepSize,
                filledSquareNumberOfTurns,
                ringSpacing,
                numberOfRings,
                numberOfSamplingPoints
              }/.Automatic ->Null;


              resolvedSamplingCoordinates = If[!MatchQ[samplingCoordinates,Automatic],
                samplingCoordinates,
                Module[{containerSize, xMax, yMax, zMax, coordinates},
                  (* introduce some logic to get the well boundries - for now I'm hard coding some place holders *)
                  (* TODO: the well size will be needed everywhere to do error checking anyway *)
                  xMax = Unitless[1000 Micrometer];
                  yMax = Unitless[1000 Micrometer];
                  zMax = Unitless[10 Micrometer];

                  (* generate random sampling points *)
                  coordinates = Transpose[{
                    RandomInteger[{-xMax, xMax}, 10],
                    RandomInteger[{-yMax, yMax}, 10],
                    RandomInteger[{-zMax, zMax}, 10]
                  }]*Micrometer
                ]
              ];

              (* resolve the number of shots based on how many points there are to manage the experiment time *)
              resolvedNumberOfShots = If[MatchQ[Length[ToList[resolvedSamplingCoordinates]], GreaterP[20]],
                numberOfShots/.Automatic -> 3,
                numberOfShots/.Automatic -> 5
              ];

              (* track errors for unused options *)
              unusedPatternOption = PickList[{
                SamplingTime,
                SpiralInnerDiameter,
                SpiralOuterDiameter,
                SpiralResolution,
                SpiralFillArea,
                SamplingXDimension,
                SamplingYDimension,
                SamplingZDimension,
                SamplingXStepSize,
                SamplingYStepSize,
                SamplingZStepSize,
                FilledSquareNumberOfTurns,
                RingSpacing,
                NumberOfRings,
                NumberOfSamplingPoints
              },
                {
                  resolvedSamplingTime,
                  resolvedSpiralInnerDiameter,
                  resolvedSpiralOuterDiameter,
                  resolvedSpiralResolution,
                  resolvedSpiralFillArea,
                  resolvedSamplingXDimension,
                  resolvedSamplingYDimension,
                  resolvedSamplingZDimension,
                  resolvedSamplingXStepSize,
                  resolvedSamplingYStepSize,
                  resolvedSamplingZStepSize,
                  resolvedFilledSquareNumberOfTurns,
                  resolvedRingSpacing,
                  resolvedNumberOfRings,
                  resolvedNumberOfSamplingPoints
                },
                Except[Null]
              ]
            ]
          ];

          (*  gather the resolved sampling options *)
          allPatternsResolvedOptions = Association[
            SamplingTime -> resolvedSamplingTime,
            SpiralInnerDiameter -> resolvedSpiralInnerDiameter,
            SpiralOuterDiameter -> resolvedSpiralOuterDiameter,
            SpiralResolution -> resolvedSpiralResolution,
            SpiralFillArea -> resolvedSpiralFillArea,
            SamplingXDimension -> resolvedSamplingXDimension,
            SamplingYDimension -> resolvedSamplingYDimension,
            SamplingZDimension -> resolvedSamplingZDimension,
            SamplingXStepSize -> resolvedSamplingXStepSize,
            SamplingYStepSize -> resolvedSamplingYStepSize,
            SamplingZStepSize -> resolvedSamplingZStepSize,
            FilledSquareNumberOfTurns -> resolvedFilledSquareNumberOfTurns,
            RingSpacing -> resolvedRingSpacing,
            NumberOfRings -> resolvedNumberOfRings,
            NumberOfSamplingPoints -> resolvedNumberOfSamplingPoints,
            NumberOfShots -> resolvedNumberOfShots,
            SamplingCoordinates -> resolvedSamplingCoordinates
          ];

          (* gather the error trackers for unused options *)
          allPatternsErrorTrackers = Association[
            UnusedRamanSamplingPatternOptions -> unusedPatternOption
          ];

          (* return the result *)
          {allPatternsResolvedOptions, allPatternsErrorTrackers}
          ];


          (* ------------------------------------------- *)
          (* -- Error Check SamplingPattern Variables -- *)
          (* ------------------------------------------- *)

          samplingPatternErrorTrackerAssociation = Module[{
            patternSpecificErrorTrackerAssociation,

            (* missing options error trackers *)
            missingNumberOfShots, missingSamplingTime, missingSpiralInnerDiameter, missingSpiralOuterDiameter, missingSpiralResolution,
            missingSpiralFillArea, missingSamplingXDimension, missingSamplingYDimension, missingSamplingZDimension, missingSamplingXStepSize,
            missingSamplingYStepSize, missingSamplingZStepSize, missingFilledSquareNumberOfTurns, missingNumberOfRings, missingNumberOfSamplingPoints, missingSamplingCoordinates,
            swappedXDimension, swappedYDimension, swappedZDimension,

            (* other error trackers *)
           patternOutOfBounds, excessiveSamplingTime, longSamplingTime, swappedInnerOuterDiameter, maxSpeedExceeded, samplingSpeed, timeRelatedOptions, speedRelatedOptions
          },


            (* == MISSING PARAMETERS == *)
            (* -- Missing NumberOfShots -- *)
            missingNumberOfShots = If[
              And[
                MatchQ[resolvedNumberOfShots, Null],
                MatchQ[samplingPattern, (SinglePoint|Grid|Coordinates|Rings)]
              ],
              True,
              False
            ];

            (* -- Missing SamplingTime -- *)
            missingSamplingTime = If[
              And[
                MatchQ[resolvedSamplingTime, Null],
                MatchQ[samplingPattern, (Spiral|FilledSquare)]
              ],
              True,
              False
            ];

            (* -- Missing SpiralInnerDiameter -- *)
            missingSpiralInnerDiameter = If[
              And[
                MatchQ[resolvedSpiralInnerDiameter, Null],
                MatchQ[samplingPattern, (Spiral|FilledSpiral)]
              ],
              True,
              False
            ];

            (* -- Missing SpiralOuterDiameter -- *)
            missingSpiralOuterDiameter= If[
              And[
                MatchQ[resolvedSpiralOuterDiameter, Null],
                MatchQ[samplingPattern, (Spiral|FilledSpiral)]
              ],
              True,
              False
            ];

            (* -- Missing SpiralResolution -- *)
            missingSpiralResolution= If[
              And[
                MatchQ[resolvedSpiralResolution, Null],
                MatchQ[samplingPattern, FilledSpiral]
              ],
              True,
              False
            ];

            (* -- Missing SpiralFillArea -- *)
            missingSpiralFillArea= If[
              And[
                MatchQ[resolvedSpiralFillArea, Null],
                MatchQ[samplingPattern, FilledSpiral]
              ],
              True,
              False
            ];

            (* -- Missing SamplingXDimension -- *)
            missingSamplingXDimension= If[
              And[
                MatchQ[resolvedSamplingXDimension, Null],
                MatchQ[samplingPattern, (Grid|FilledSquare)]
              ],
              True,
              False
            ];

            (* -- Missing SamplingYDimension -- *)
            missingSamplingYDimension= If[
              And[
                MatchQ[resolvedSamplingYDimension, Null],
                MatchQ[samplingPattern, (Grid|FilledSquare)]
              ],
              True,
              False
            ];

            (* -- Missing SamplingZDimension -- *)
            missingSamplingZDimension= If[
              And[
                MatchQ[resolvedSamplingZDimension, Null],
                MatchQ[samplingPattern, Grid]
              ],
              True,
              False
            ];

            (* -- Missing SamplingXStepSize -- *)
            missingSamplingXStepSize= If[
              And[
                MatchQ[resolvedSamplingXStepSize, Null],
                MatchQ[samplingPattern, Grid]
              ],
              True,
              False
            ];

            (* -- Missing SamplingYStepSize -- *)
            missingSamplingYStepSize= If[
              And[
                MatchQ[resolvedSamplingYStepSize, Null],
                MatchQ[samplingPattern, Grid]
              ],
              True,
              False
            ];

            (* -- Missing SamplingZStepSize -- *)
            missingSamplingZStepSize= If[
              And[
                MatchQ[resolvedSamplingZStepSize, Null],
                MatchQ[samplingPattern, Grid]
              ],
              True,
              False
            ];

            (* -- Swapped Dimension and step size -- *)
            swappedXDimension = If[MatchQ[resolvedSamplingXStepSize, GreaterP[resolvedSamplingXDimension]],
              True,
              False
            ];
            swappedYDimension = If[MatchQ[resolvedSamplingYStepSize, GreaterP[resolvedSamplingYDimension]],
              True,
              False
            ];
            swappedZDimension = If[MatchQ[resolvedSamplingZStepSize, GreaterP[resolvedSamplingZDimension]],
              True,
              False
            ];

            (* -- Missing FilledSquareNumberOfTurns -- *)
            missingFilledSquareNumberOfTurns= If[
              And[
                MatchQ[resolvedFilledSquareNumberOfTurns, Null],
                MatchQ[samplingPattern, FilledSquare]
              ],
              True,
              False
            ];

            (* -- Missing NumberOfRings -- *)
            missingNumberOfRings= If[
              And[
                MatchQ[resolvedNumberOfRings, Null],
                MatchQ[samplingPattern, Rings]
              ],
              True,
              False
            ];

            (* -- Missing NumberOfSamplingPoints -- *)
            missingNumberOfSamplingPoints= If[
              And[
                MatchQ[resolvedNumberOfSamplingPoints, Null],
                MatchQ[samplingPattern, Rings]
              ],
              True,
              False
            ];

            (* -- Missing SamplingCoordinates -- *)
            missingSamplingCoordinates= If[
              And[
                MatchQ[resolvedSamplingCoordinates, Null],
                MatchQ[samplingPattern, Coordinates]
              ],
              True,
              False
            ];


            (* -- Spiral specific error tracking -- *)

            (* if the inner and outer diameter are both numbers then check that one is larger than the other *)
            swappedInnerOuterDiameter = If[!MemberQ[{resolvedSpiralInnerDiameter, resolvedSpiralOuterDiameter}, Null],
              If[MatchQ[resolvedSpiralInnerDiameter, GreaterEqualP[resolvedSpiralOuterDiameter]],
                True,
                False
              ],
              False
            ];


            (* -- general errors for sample time and region -- *)

            (* The max appers to be 6000 um/s *)
            (* we will assume that the sample plate is valid for this test, so use the well size that woudl be used for the SampleType *)
            (* Tablet -> 24 Well with 8 mm diameter, Liquid/Powder -> Glass plate with 6.21 mm diameter*)
            (*teh software limits diameter to 6 mm diameter, so the plate doesnt really matter*)
            (* the allowable Z height for both is 10 mm, although this is sort of crazy *)
            (*the coordinates are relative to well center*)
            (*see www.cellvis.com/_96-well-glass-bottom-plate-with-high-performance-number-1.5-cover-glass_/product_detail.php?product_id=50#dimension-diagram*)

            (* the software will accept up to 8000 Micrometer diameter, but we will restrict to 6000 since 8000 goes outside of the well *)
            {patternOutOfBounds, optionsCausingPatternOutOfBounds} = If[
              MemberQ[
                {
                  swappedInnerOuterDiameter, missingSamplingCoordinates, missingNumberOfSamplingPoints, missingNumberOfRings,
                  missingNumberOfShots, missingSamplingTime, missingSpiralInnerDiameter, missingSpiralOuterDiameter, missingSpiralResolution,
                  missingSpiralFillArea, missingSamplingXDimension, missingSamplingYDimension, missingSamplingZDimension, missingSamplingXStepSize,
                  missingSamplingYStepSize, missingSamplingZStepSize, missingFilledSquareNumberOfTurns},
                True
              ],

              (* if there are missing or bad parameters, dont do this calculation since it wont make sense *)
              {False, {}},

              (* otherwise check the relevant sampling pattern parameters *)
              Switch[samplingPattern,

                SinglePoint,
                {False,{}},

                Spiral,
                Which[
                  MatchQ[spiralOuterDiameter, Automatic]&&MatchQ[resolvedSpiralInnerDiameter, GreaterP[5800 Micrometer]],
                  {True, {SpiralInnerDiameter}},
                  MatchQ[spiralOuterDiameter, GreaterP[6000 Micrometer]]&&MatchQ[spiralInnerDiameter, GreaterP[5800 Micrometer]],
                  {True, {SpiralOuterDiameter, SpiralInnerDiameter}},
                  MatchQ[resolvedSpiralOuterDiameter, GreaterP[6000 Micrometer]],
                  {True, {SpiralOuterDiameter}},
                  True,
                  {False,{}}
                ],

                FilledSpiral,
                Which[
                  MatchQ[spiralOuterDiameter, Automatic]&&MatchQ[resolvedSpiralInnerDiameter, GreaterP[5800 Micrometer]],
                  {True, {SpiralInnerDiameter}},
                  MatchQ[spiralOuterDiameter, GreaterP[6000 Micrometer]]&&MatchQ[spiralInnerDiameter, GreaterP[5800 Micrometer]],
                  {True, {SpiralOuterDiameter, SpiralInnerDiameter}},
                  MatchQ[resolvedSpiralOuterDiameter, GreaterP[6000 Micrometer]],
                  {True, {SpiralOuterDiameter}},
                  True,
                  {False,{}}
                ],

                FilledSquare,
                If[MatchQ[(resolvedSamplingXDimension/2)^2+(resolvedSamplingYDimension/2)^2, GreaterP[6000^2*Micrometer]],
                  {True, {SamplingXDimension, SamplingYDimension}},
                  {False,{}}
                ],

                Grid,
                Which[
                  MatchQ[(resolvedSamplingXDimension/2)^2+(resolvedSamplingYDimension/2)^2, GreaterP[6000^2*Micrometer]]&&MatchQ[resolvedSamplingZDimension, GreaterP[1000 Micrometer]],
                  {True, {SamplingXDimension, SamplingYDimension, SamplingZDimension}},
                  MatchQ[(resolvedSamplingXDimension/2)^2+(resolvedSamplingYDimension/2)^2, GreaterP[6000^2*Micrometer]],
                  {True, {SamplingXDimension, SamplingYDimension}},
                  MatchQ[resolvedSamplingZDimension, GreaterP[1000 Micrometer]],
                  {True, {SamplingZDimension}},
                  True,
                  {False,{}}
                ],

                Rings,
                If[MatchQ[resolvedRingSpacing*resolvedNumberOfRings, GreaterP[6000 Micrometer]],
                  {True, {RingSpacing, NumberOfRings}},
                  {False,{}}
                ],

                Coordinates,
                Module[{badPoints},

                  (* determien if any points lie outside of the well area or are unreasonably deep into the sample *)
                  badPoints = Select[
                    resolvedSamplingCoordinates,
                    Or[
                      MatchQ[(#[[1]]/2)^2+(#[[2]]/2)^2GreaterP[6000^2*Micrometer]],
                      MatchQ[#[[3]], GreaterP[1000 Micrometer]]
                    ]&
                  ];

                  (* if there were point that are out or range, return True *)
                  If[MatchQ[badPoints, Except[{}]],
                    {True, SamplingCoordinates},
                    {False,{}}
                  ]
                ]
              ]
            ];

            (* determine the total sampling time, assuming that the optimized exposure time will be ~100 Millisecond *)
            {totalSamplingTime, samplingSpeed, timeRelatedOptions, speedRelatedOptions} = If[
              MemberQ[
                {
                  swappedInnerOuterDiameter, missingSamplingCoordinates, missingNumberOfSamplingPoints, missingNumberOfRings,
                  missingNumberOfShots, missingSamplingTime, missingSpiralInnerDiameter, missingSpiralOuterDiameter, missingSpiralResolution,
                  missingSpiralFillArea, missingSamplingXDimension, missingSamplingYDimension, missingSamplingZDimension, missingSamplingXStepSize,
                  missingSamplingYStepSize, missingSamplingZStepSize, missingFilledSquareNumberOfTurns},
                True
              ],

              (* if there are missing or bad parameters, dont do this calculation since it wont make sense *)
              {0*Second, 0*Micrometer/Second, {}, {}},

              (* if there are no errors, then check the time that it will take to do the sampling and the required speed *)
              Switch[samplingPattern,

                (* single point time check *)
                SinglePoint,
                {
                  (resolvedExposureTime/.Optimize -> 100 Millisecond)*resolvedNumberOfShots,
                  0*Micrometer/Second,
                  {ExposureTime, NumberOfShots},
                  {}
                },

                Spiral,
                (* I dont know how this calculation is done but this appears to be the rule *)
                {
                  resolvedSamplingTime,
                  resolvedSpiralInnerDiameter*3.8*1/Second,
                  {SamplingTime},
                  {SpiralInnerDiameter}
                },

                FilledSquare,
                (* this one at least makes sense *)
                {
                  resolvedSamplingTime,
                  resolvedFilledSquareNumberOfTurns*resolvedSamplingXDimension/resolvedSamplingTime,
                  {SamplingTime},
                  {SamplingTime, FilledSquareNumberOfTurns, SamplingXDimension}
                },

                FilledSpiral,
                (* the amount of area times the percent coverage divided by the beam size?  *)
                Module[{numberOfConcentricCircles, concentricCirclesCircumferences, objectiveToSpotSizeLookup, totalPathLength, speed},
                  (* need to know the speed and how long the path is that it will travel. Speed is resolution/exposure time
                  the path length is dictated by the spot size and the *)

                  (* TODO: this lookup could move out to the general section if it is useful elsewhere. may even want this to live in teh instrument object *)
                  objectiveToSpotSizeLookup = {
                    20 -> 35 Micrometer,
                    10 -> 50 Micrometer,
                    4 -> 150 Micrometer,
                    2 -> 330 Micrometer,
                    Null -> 1750 Micrometer
                  };

                  (* determine the number of circles the pattern will need to have to obtain the desired coverage *)
                  numberOfConcentricCircles = Unitless[
                    Round[
                      0.5*Normal[resolvedSpiralFillArea]*(resolvedSpiralOuterDiameter-resolvedSpiralInnerDiameter)/(resolvedObjectiveMagnification/.objectiveToSpotSizeLookup),
                      1
                    ]
                  ];

                  (* calculate the radii or the circular paths as Pi*d *)
                  concentricCirclesCircumferences = Table[(3.14*(resolvedSpiralInnerDiameter+(resolvedSpiralOuterDiameter-resolvedSpiralInnerDiameter)/ringNumber)), {ringNumber, 1, numberOfConcentricCircles}];

                  (* sum all the quasi-circular paths in the spiral *)
                  totalPathLength = Total[concentricCirclesCircumferences];

                  (* calculate the speed based on the exposure and resolution - this is how it is done in the software *)
                  speed = resolvedSpiralResolution/(resolvedExposureTime/.Optimize -> 100 Millisecond);

                  (* use the speed and distance to compute time *)
                  {
                    totalPathLength/speed,
                    speed,
                    {SpiralOuterDiameter, SpiralInnerDiameter, ObjectiveMagnification, ExposureTime, SpiralResolution},
                    {ExposureTime, SpiralResolution}
                  }
                ],

                Grid,
                {
                  Module[{numberOfSteps},
                    numberOfSteps = {
                      (resolvedSamplingXDimension/.{Null -> 0 Micrometer})/(resolvedSamplingXStepSize/.{0->1}),
                      (resolvedSamplingYDimension/.{Null -> 0 Micrometer})/(resolvedSamplingYStepSize/.{0->1}),
                      (resolvedSamplingZDimension/.{Null -> 0 Micrometer})/(resolvedSamplingZStepSize/.{0->1})
                    };

                    Times[Sequence@@Join[numberOfSteps, resolvedNumberOfShots]]
                  ],
                  0*Micrometer/Second,
                  {SamplingZStepSize, SamplingYStepSize, SamplingXStepSize},
                  {}
                },

                Rings,
                {
                  (resolvedNumberOfSamplingPoints*resolvedExposureTime*resolvedNumberOfShots),
                  0*Micrometer/Second,
                  {ExposureTime, NumberOfSamplingPoints,NumberOfShots},
                  {}
                },

                Coordinates,
                {
                  (Length[resolvedSamplingCoordinates] * resolvedExposureTime * resolvedNumberOfShots),
                  0*Micrometer/Second,
                  {SamplingCoordinates, ExposureTime, NumberOfShots},
                  {}
                }
              ]
            ];

            (* return the booleans for excessive (error) or long (warning) measurment times *)
            {excessiveSamplingTime, longSamplingTime} = Which[
              (* 2 Hour samplign time may lead to problems *)
              MatchQ[totalSamplingTime, GreaterEqualP[2 Hour]],
              {True, False},

              (* long sampling times will be annoying and probably unneeded *)
              MatchQ[totalSamplingTime, RangeP[20 Minute, 2 Hour]],
              {False, True},

              (* anything else is ok *)
              True,
              {False, False}
            ];

            (* determine if the pattern will require the stage to move faster than it is programmed to do *)
            maxSpeedExceeded = If[MatchQ[samplingSpeed, GreaterP[5000 Micrometer/Second]],
              True,
              False
            ];

            (* -- collect all the error trackers specific to a particular sampling pattern -  *)
            patternSpecificErrorTrackerAssociation = Association[
              MissingSamplingTime ->missingSamplingTime,
              MissingNumberOfShots -> missingNumberOfShots,
              MissingSpiralInnerDiameter -> missingSpiralInnerDiameter,
              MissingSpiralOuterDiameter -> missingSpiralOuterDiameter,
              MissingSpiralResolution -> missingSpiralResolution,
              MissingSpiralFillArea -> missingSpiralFillArea,
              MissingSamplingXDimension -> missingSamplingXDimension,
              MissingSamplingYDimension -> missingSamplingYDimension,
              MissingSamplingZDimension -> missingSamplingZDimension,
              MissingSamplingXStepSize -> missingSamplingXStepSize,
              MissingSamplingYStepSize -> missingSamplingYStepSize,
              MissingSamplingZStepSize -> missingSamplingZStepSize,
              MissingFilledSquareNumberOfTurns -> missingFilledSquareNumberOfTurns,
              MissingNumberOfRings -> missingNumberOfRings,
              MissingNumberOfSamplingPoints -> missingNumberOfSamplingPoints,
              MissingSamplingCoordinates -> missingSamplingCoordinates,

              PatternOutOfBounds -> patternOutOfBounds,
              OptionsCausingPatternOutOfBounds -> optionsCausingPatternOutOfBounds,
              MaxSpeedExceeded -> maxSpeedExceeded,
              ExcessiveSamplingTime -> excessiveSamplingTime,
              TimeRelatedOptions -> timeRelatedOptions,
              SpeedRelatedOptions -> speedRelatedOptions,
              LongSamplingTime -> longSamplingTime,
              SwappedInnerOuterDiameter -> swappedInnerOuterDiameter,
              SwappedXDimension -> swappedXDimension,
              SwappedYDimension -> swappedYDimension,
              SwappedZDimension -> swappedZDimension
            ];

            (* gather the output *)
            Join[
              patternSpecificErrorTrackerAssociation,
              unusedPatternOptionErrorTrackerAssociation
            ]
          ];



          (* ------------------------------------------------- *)
          (* -- COMBINE RESOLVED OPTIONS AND ERROR TRACKING -- *)
          (* ------------------------------------------------- *)


          (* compose the resolved options in the form of <|OptionName -> resolvedOptionValue..|> *)
          resolvedOptionsAssociation = Join[
            resolvedSamplingParameterAssociation,
            resolvedMicroscopeOptionsAssociation,
            resolvedOpticsOptionsAssociation,
            resolvedGeneralOptionsAssociation,
            resolvedBlankOptionsAssociation
          ];

          (* compose the error trackers in the form of <|ErrorName -> errorTrackervalue .. |> *)
          errorTrackersAssociation = Join[
            samplingPatternErrorTrackerAssociation,
            microscopeParametersErrorTrackerAssociation,
            opticsParametersErrorTrackerAssociation,
            generalParametersErrorTrackerAssociation,
            blanksErrorTrackerAssociation
          ];

          (* return the options and the error tracking booleans - note that becasue this is an association dont worry about order *)
          {resolvedOptionsAssociation, errorTrackersAssociation}
        ]
      ],
      {mapThreadFriendlyOptions, simulatedSamples}
    ]
  ];


  (* -- MAPTHREAD CLEANUP -- *)

  resolvedOptionsAssociation = Merge[resolvedMapThreadOptionsAssociations, Join];
  mapThreadErrorCheckingAssociation = Merge[mapThreadErrorCheckingAssociations, Join];


  (* -- Extract samplePackets that had a problem in the MapThread -- *)
  (*samplingPattern*)
  {
    samplePacketsWithSwappedXDimension,
    samplePacketsWithSwappedYDimension,
    samplePacketsWithSwappedZDimension,
    samplePacketsWithSwappedInnerOuterDiameter,
    samplePacketsWithMissingSamplingCoordinates,
    samplePacketsWithMissingNumberOfSamplingPoints,
    samplePacketsWithMissingNumberOfRings,
    samplePacketsWithMissingNumberOfShots,
    samplePacketsWithMissingSamplingTime,
    samplePacketsWithMissingSpiralInnerDiameter,
    samplePacketsWithMissingSpiralOuterDiameter,
    samplePacketsWithMissingSpiralResolution,
    samplePacketsWithMissingSpiralFillArea,
    samplePacketsWithMissingSamplingXDimension,
    samplePacketsWithMissingSamplingYDimension,
    samplePacketsWithMissingSamplingZDimension,
    samplePacketsWithMissingSamplingXStepSize,
    samplePacketsWithMissingSamplingYStepSize,
    samplePacketsWithMissingSamplingZStepSize,
    samplePacketsWithMissingFilledSquareNumberOfTurns,
    samplePacketsWithExcessiveSamplingTime,
    samplePacketsWithLongSamplingTime,
    samplePacketsWithMaxSpeedExceeded,
    samplePacketsWithPatternsOutOfBounds
  } = Map[PickList[samplePackets, #]&,
    Lookup[mapThreadErrorCheckingAssociation,
      {
        SwappedXDimension,
        SwappedYDimension,
        SwappedZDimension,
        SwappedInnerOuterDiameter,
        MissingSamplingCoordinates,
        MissingNumberOfSamplingPoints,
        MissingNumberOfRings,
        MissingNumberOfShots,
        MissingSamplingTime,
        MissingSpiralInnerDiameter,
        MissingSpiralOuterDiameter,
        MissingSpiralResolution,
        MissingSpiralFillArea,
        MissingSamplingXDimension,
        MissingSamplingYDimension,
        MissingSamplingZDimension,
        MissingSamplingXStepSize,
        MissingSamplingYStepSize,
        MissingSamplingZStepSize,
        MissingFilledSquareNumberOfTurns,
        ExcessiveSamplingTime,
        LongSamplingTime,
        MaxSpeedExceeded,
        PatternOutOfBounds
      }
    ]
  ];

    (* the unused sampling pattern parameters are a list of options not booleans so the picklist needs to check for non-empty lists *)
    samplePacketsWithUnusedRamanSamplingPatternOptions = PickList[samplePackets, Lookup[mapThreadErrorCheckingAssociation, UnusedRamanSamplingPatternOptions], Except[{}]];


  (*optics*)
  {
    samplePacketsWithObjectiveMisMatchBool,
    samplePacketsWithNoObjectiveBool,
    samplePacketsWithMissingAdjustmentTarget,
    samplePacketsWithNoAdjustmentTargetRequired,
    samplePacketsWithMissingAdjustmentSample,
    samplePacketsWithNoAdjustmentSampleRequired,
    samplePacketsWithMissingAdjustmentEmissionWavelength,
    samplePacketsWithNoAdjustmentEmissionWavelengthRequired
  } = Map[PickList[samplePackets, #]&,
    Lookup[mapThreadErrorCheckingAssociation,
      {
        ObjectiveMisMatchBool,
        NoObjectiveBool,
        MissingAdjustmentTarget,
        NoAdjustmentTargetRequired,
        MissingAdjustmentSample,
        NoAdjustmentSampleRequired,
        MissingAdjustmentEmissionWavelength,
        NoAdjustmentEmissionWavelengthRequired
      }
    ]
  ];

  (* blanks *)

  {
    samplePacketsWithBlankIsTablet,
    samplePacketsWithBlankForTablet,
    samplePacketsWithMissingBlank
  } = Map[PickList[samplePackets, #]&,
    Lookup[mapThreadErrorCheckingAssociation,
      {
        BlankIsTablet,
        BlankForTablet,
        MissingBlank
      }
    ]
  ];


    (* sample processing/sampletype *)
  {
    samplePacketsWithSampleTypeRequiresDissolution,
    samplePacketsWithInvalidTabletProcessingRequested,
    samplePacketsWithTabletProcessingInconsistancy,
    samplePacketsWithIncorrectSampleType,
    samplePacketsWithUnusedTabletProcessing,
    samplePacketsWithMissingTableProcessing
  }  = Map[PickList[samplePackets, #]&,
      Lookup[mapThreadErrorCheckingAssociation,
        {
          SampleTypeRequiresDissolution,
          InvalidTabletProcessingRequested,
          TabletProcessingInconsistancy,
          IncorrectSampleType,
          UnusedTabletProcessing,
          MissingTableProcessing
        }
      ]
    ];

  (* microscope imaging *)
  {
    samplePacketsWithMissingMicroscopeImageLightIntensity,
    samplePacketsWithMissingMicroscopeImageExposureTime,
    samplePacketsWithUnusedMicroscopeImageLightIntensity,
    samplePacketsWithUnusedMicroscopeImageExposureTime
  }  = Map[PickList[samplePackets, #]&,
    Lookup[mapThreadErrorCheckingAssociation,
      {
        MissingMicroscopeImageLightIntensity,
        MissingMicroscopeImageExposureTime, UnusedMicroscopeImageLightIntensity,
        UnusedMicroscopeImageExposureTime
      }
    ]
  ];







  (* ------------------------------ *)
  (*-- CONFLICTING OPTIONS CHECKS --*)
  (* ------------------------------ *)


  (* --------------- 1 ------------- *)
  (* -- Optical Microscope Errors -- *)
  (* --------------- 1 ------------- *)


  (* -- MissingMicroscopeImageLightIntensity: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingMicroscopeImageLightIntensity,{}]&&!gatherTests,
    Message[Error::MissingRamanMicroscopeImageLightIntensity,ObjectToString[samplePacketsWithMissingMicroscopeImageLightIntensity,Cache->newCache]]
  ];
  (* make the test *)
  missingMicroscopeImageLightIntensityTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingMicroscopeImageLightIntensity,
    "If required, MicroscopeImageLightIntensity is specified for the input sample `1`:",
    newCache];



  (* -- MissingMicroscopeImageExposureTime: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingMicroscopeImageExposureTime,{}]&&!gatherTests,
    Message[Error::MissingRamanMicroscopeImageExposureTime,ObjectToString[samplePacketsWithMissingMicroscopeImageExposureTime,Cache->newCache]]
  ];
  (* make the test *)
  missingRamanMicroscopeImageExposureTimeTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingMicroscopeImageExposureTime,
    "If required, MicroscopeImageExposureTime is specified for the input sample `1`:",
    newCache];



  (* -- UnusedMicroscopeImageLightIntensity: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithUnusedMicroscopeImageLightIntensity,{}]&&!gatherTests,
    Message[Error::UnusedRamanMicroscopeImageLightIntensity,ObjectToString[samplePacketsWithUnusedMicroscopeImageLightIntensity,Cache->newCache]]
  ];
  (* make the test *)
  unusedMicroscopeImageLightIntensityTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithUnusedMicroscopeImageLightIntensity,
    "If not required, MicroscopeImageLightIntensity is not specified for the input sample `1`:",
    newCache];


  (* -- UnusedMicroscopeImageExposureTime: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithUnusedMicroscopeImageExposureTime,{}]&&!gatherTests,
    Message[Error::UnusedRamanMicroscopeImageExposureTime,ObjectToString[samplePacketsWithUnusedMicroscopeImageExposureTime,Cache->newCache]]
  ];
  (* make the test *)
  unusedMicroscopeImageExposureTimeTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithUnusedMicroscopeImageExposureTime,
    "If not required, MicroscopeImageExposureTime is not specified for the input sample `1`:",
    newCache];



  (* -- collect the invalid options for optical imaging -- *)
  invalidMicroscopeImageOptions = PickList[
    {
      MicroscopeImageLightIntensity,
      MicroscopeImageExposureTime,
      MicroscopeImageLightIntensity,
      MicroscopeImageExposureTime
    },
    {
      samplePacketsWithMissingMicroscopeImageLightIntensity,
      samplePacketsWithMissingMicroscopeImageExposureTime,
      samplePacketsWithUnusedMicroscopeImageLightIntensity,
      samplePacketsWithUnusedMicroscopeImageExposureTime
    },
    Except[{}]
  ];


  (* ------- 2 --------- *)
  (* -- Optics Errors -- *)
  (* ------- 2 --------- *)


  (* -- ObjectiveMisMatch: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithObjectiveMisMatchBool,{}]&&!gatherTests,
    Message[Error::RamanObjectiveMisMatch,ObjectToString[samplePacketsWithObjectiveMisMatchBool,Cache->newCache]]
  ];
  (* make the test *)
  objectiveMisMatchTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithObjectiveMisMatchBool,
    "The FloodLight and ObjectiveMagnification option do not conflict for the input sample `1`:",
    newCache];



  (* -- NoObjective: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithNoObjectiveBool,{}]&&!gatherTests,
    Message[Error::NoRamanObjective,ObjectToString[samplePacketsWithNoObjectiveBool,Cache->newCache]]
  ];
  (* make the test *)
  noObjectiveTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithNoObjectiveBool,
    "A valid objective or FloodLight is specified for the input sample `1`:",
    newCache];



  (* -- NissingAdjustmentTarget: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingAdjustmentTarget,{}]&&!gatherTests,
    Message[Error::MissingRamanAdjustmentTarget,ObjectToString[samplePacketsWithMissingAdjustmentTarget,Cache->newCache]]
  ];
  (* make the test *)
  missingAdjustmentTargetTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingAdjustmentTarget,
    "If power/exposure optimization is performed, AdjustmentTarget is specified for the input sample `1`:",
    newCache];



  (* -- NoAdjustmentTargetRequired: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithNoAdjustmentTargetRequired,{}]&&!gatherTests,
    Message[Error::NoRamanAdjustmentTargetRequired,ObjectToString[samplePacketsWithNoAdjustmentTargetRequired,Cache->newCache]]
  ];
  (* make the test *)
  noAdjustmentTargetRequiredTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithNoAdjustmentTargetRequired,
    "If power/exposure optimization is not performed, AdjustmentTarget is not specified for the input sample `1`:",
    newCache];



  (* -- MissingAdjustmentSample: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingAdjustmentSample,{}]&&!gatherTests,
    Message[Error::MissingRamanAdjustmentSample,ObjectToString[samplePacketsWithMissingAdjustmentSample,Cache->newCache]]
  ];
  (* make the test *)
  missingAdjustmentSampleTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingAdjustmentSample,
    "If power/exposure optimization is performed, AdjustmentSample is specified for the input sample `1`:",
    newCache];



  (* -- noAdjustmentSample: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithNoAdjustmentSampleRequired,{}]&&!gatherTests,
    Message[Error::NoRamanAdjustmentSampleRequired,ObjectToString[samplePacketsWithNoAdjustmentSampleRequired,Cache->newCache]]
  ];
  (* make the test *)
  noAdjustmentSampleTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithNoAdjustmentSampleRequired,
    "If power/exposure optimization is not performed, AdjustmentSample is not specified for the input sample `1`:",
    newCache];



  (* -- MissingRamanAdjustmentEmissionWavelength: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingAdjustmentEmissionWavelength,{}]&&!gatherTests,
    Message[Error::MissingRamanAdjustmentEmissionWavelength,ObjectToString[samplePacketsWithMissingAdjustmentEmissionWavelength,Cache->newCache]]
  ];
  (* make the test *)
  missingAdjustmentEmissionWavelengthTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingAdjustmentEmissionWavelength,
    "If power/exposure optimization is performed, AdjustmentEmissionWavelength is specified for the input sample `1`:",
    newCache];




  (* -- NoAdjustmentEmissionWavelength: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithNoAdjustmentEmissionWavelengthRequired,{}]&&!gatherTests,
    Message[Error::NoRamanAdjustmentEmissionWavelengthRequired,ObjectToString[samplePacketsWithNoAdjustmentEmissionWavelengthRequired,Cache->newCache]]
  ];
  (* make the test *)
  noAdjustmentEmissionWavelengthTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithNoAdjustmentEmissionWavelengthRequired,
    "If power/exposure optimization is not performed, AdjustmentEmissionWavelength is not specified for the input sample `1`:",
    newCache];


  (* -- AdjustmentSampleNotFound -- *)
  (* we will only allow adjustment samples that are on the plate, either as backgrounds or as samples - if there is an adjustment sample that is not a memeber of
   either the Blank or the SamplesIn, we need to throw an error*)
  adjustmentSamplesNotOnPlate = Map[
    If[MatchQ[#, ObjectP[]],
      (* if we have an object, make sure it is a member of the samplesIn *)
      If[
        MemberQ[
          Download[Join[mySamples, Cases[Lookup[resolvedOptionsAssociation, Blank], ObjectP[]]], Object],
          Download[#, Object]
        ],
        Nothing,
        #
      ],
      Nothing
    ]&,
    Lookup[resolvedOptionsAssociation, AdjustmentSample]
  ];

  (* generate the invalid option *)
  adjustmentSampleNotOnPlateOptions = If[MatchQ[adjustmentSamplesNotOnPlate, {}],
    {},
    AdjustmentSample
  ];

  (* generate the error message *)
  If[MatchQ[adjustmentSamplesNotOnPlate, Except[{}]],
    Message[Error::RamanAdjustmentSamplesNotPresent, adjustmentSamplesNotOnPlate]
  ];

  (* generate the tests *)
  adjustmentSampleNotOnPlateTest = Test[
    "The adjustment samples are included in either SamplesIn or Blank:",
    MatchQ[adjustmentSamplesNotOnPlate,{}],
    True
  ];

  (* collect the invalid optics options *)
  invalidOpticsOptions = PickList[
    {
      ObjectiveMagnification,
      ObjectiveMagnification,
      AdjustmentTarget,
      AdjustmentTarget,
      AdjustmentSample,
      AdjustmentSample,
      AdjustmentEmissionWavelength,
      AdjustmentEmissionWavelength
    },
    {
      samplePacketsWithObjectiveMisMatchBool,
      samplePacketsWithNoObjectiveBool,
      samplePacketsWithMissingAdjustmentTarget,
      samplePacketsWithNoAdjustmentTargetRequired,
      samplePacketsWithMissingAdjustmentSample,
      samplePacketsWithNoAdjustmentSampleRequired,
      samplePacketsWithMissingAdjustmentEmissionWavelength,
      samplePacketsWithNoAdjustmentEmissionWavelengthRequired
    },
    Except[{}]
  ];


  (* ----------- 3 --------- *)
  (* -- SampleType Errors -- *)
  (* ----------- 3 --------- *)


  (* -- SampleTypeRequiresDissolutionTests: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithSampleTypeRequiresDissolution,{}]&&!gatherTests,
    Message[Error::RamanSampleTypeRequiresDissolution,ObjectToString[samplePacketsWithSampleTypeRequiresDissolution,Cache->newCache]]
  ];
  (* make the test *)
  sampleTypeRequiresDissolutionTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithSampleTypeRequiresDissolution,
    "When the SampleType is Liquid, the sample in is also a liquid for the input sample `1`:",
    newCache];


  (* -- InvalidTabletProcessingRequested: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithInvalidTabletProcessingRequested,{}]&&!gatherTests,
    Message[Error::InvalidRamanTabletProcessingRequested,ObjectToString[samplePacketsWithInvalidTabletProcessingRequested,Cache->newCache]]
  ];
  (* make the test *)
  invalidTabletProcessingRequestedTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithInvalidTabletProcessingRequested,
    "The TabletProcessing option is valid for the input sample `1`:",
    newCache];


  (* -- TabletProcessingInconsistancy: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithTabletProcessingInconsistancy,{}]&&!gatherTests,
    Message[Error::RamanTabletProcessingInconsistancy,ObjectToString[samplePacketsWithTabletProcessingInconsistancy,Cache->newCache]]
  ];
  (* make the test *)
  tabletProcessingInconsistancyTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithTabletProcessingInconsistancy,
    "The TabletProcessing option is consistant with the state of the sample in and the SampleType for the input sample `1`:",
    newCache];



  (* -- IncorectSampelType: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithIncorrectSampleType,{}]&&!gatherTests,
    Message[Error::IncorrectRamanSampleType,ObjectToString[samplePacketsWithIncorrectSampleType,Cache->newCache]]
  ];
  (* make the test *)
  incorrectSampleTypeTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithIncorrectSampleType,
    "The SampleType matches the physical state of the sample after the requested processing/preparation is done for the input sample `1`:",
    newCache];


  (* -- UnusedTabletProcessing: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithUnusedTabletProcessing,{}]&&!gatherTests,
    Message[Error::UnusedRamanTabletProcessing,ObjectToString[samplePacketsWithUnusedTabletProcessing,Cache->newCache]]
  ];
  (* make the test *)
  unusedTabletProcessingTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithUnusedTabletProcessing,
    "If TabletProcessing is specified, the input is a Tablet for the input sample `1`:",
    newCache];



  (* -- MissingTabletProcessing: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingTableProcessing,{}]&&!gatherTests,
    Message[Error::MissingRamanTabletProcessing,ObjectToString[samplePacketsWithMissingTableProcessing,Cache->newCache]]
  ];
  (* make the test *)
  missingTabletProcessingTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithMissingTableProcessing,
    "If the input is a Tablet, TabletProcessing is not Null for the input sample `1`:",
    newCache];


  (* collect the invalid option names for the sample type *)
  invalidSampleTypeOptions = If[
    Or[
      MatchQ[samplePacketsWithSampleTypeRequiresDissolution, Except[{}]],
      MatchQ[samplePacketsWithIncorrectSampleType, Except[{}]]
    ],
    {SampleType},
    {}
  ];

  (* collect the invalid option name for tablet processing/sample type *)
  invalidTabletProcessingOptions = If[
    Or[
      MatchQ[samplePacketsWithInvalidTabletProcessingRequested, Except[{}]],
      MatchQ[samplePacketsWithTabletProcessingInconsistancy, Except[{}]],
      MatchQ[samplePacketsWithUnusedTabletProcessing, Except[{}]],
      MatchQ[samplePacketsWithMissingTableProcessing, Except[{}]]
    ],
    {TabletProcessing, SampleType},
    {}
  ];



  (* -------------- 4 ------------ *)
  (* -- Sampling Pattern Errors -- *)
  (* -------------- 4 ------------ *)

  (* make the tests for all of the sampling pattern error checkers*)
  samplingPatternGroupedTests=MapThread[
    ramanSampleTests[gatherTests,
      Test,
      samplePackets,
      #1,
      #2,
      newCache]&,
    {
      {
        samplePacketsWithSwappedXDimension,
        samplePacketsWithSwappedYDimension,
        samplePacketsWithSwappedZDimension,
        samplePacketsWithSwappedInnerOuterDiameter,
        samplePacketsWithMissingSamplingCoordinates,
        samplePacketsWithMissingNumberOfSamplingPoints,
        samplePacketsWithMissingNumberOfRings,
        samplePacketsWithMissingNumberOfShots,
        samplePacketsWithMissingSamplingTime,
        samplePacketsWithMissingSpiralInnerDiameter,
        samplePacketsWithMissingSpiralOuterDiameter,
        samplePacketsWithMissingSpiralResolution,
        samplePacketsWithMissingSpiralFillArea,
        samplePacketsWithMissingSamplingXDimension,
        samplePacketsWithMissingSamplingYDimension,
        samplePacketsWithMissingSamplingZDimension,
        samplePacketsWithMissingSamplingXStepSize,
        samplePacketsWithMissingSamplingYStepSize,
        samplePacketsWithMissingSamplingZStepSize,
        samplePacketsWithMissingFilledSquareNumberOfTurns,
        samplePacketsWithExcessiveSamplingTime,
        samplePacketsWithLongSamplingTime,
        samplePacketsWithMaxSpeedExceeded,
        samplePacketsWithPatternsOutOfBounds
      },
      {
        "When the SamplingXDimension and SamplingXStepSize are specified, the dimension is greater than or equal to the step size for the input sample `1`:",
        "When the SamplingYDimension and SamplingYStepSize are specified, the dimension is greater than or equal to the step size for the input sample `1`:",
        "When the SamplingZDimension and SamplingZStepSize are specified, the dimension is greater than or equal to the step size for the input sample `1`:",
        "When the SpiralInnerDiameter and SpiralOuterDiameter are specified, the outer diameter is larger for the input sample `1`:",
        "When SamplingPattern -> Coordinates, Coordinates are specified for the input sample `1`:",
        "When NumberOfSamplingPoints is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When NumberOfRings is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When NumberOfShots is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingTime is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SpiralInnerDiameter is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SpiralOuterDiameter is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SpiralResolution is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SpiralFillArea is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingXDimension is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingYDimension is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingZDimension is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingXStepSize is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingYStepSize is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When SamplingZStepSize is required by the SamplingPattern, it is specified for the input sample `1`:",
        "When FilledSquareNumberOfTurns is required by the SamplingPattern, it is specified for the input sample `1`:",
        "The specified SamplingPattern parameters do not result in an excessively long measurement time for the input sample `1`:",
        "The specified SamplingPattern parameters do not result in an unusually long measurement time for the input sample `1`:",
        "The specified SamplingPattern parameters do not result in movement of the sample stage that exceeds its capabilities for input sample `1`:",
        "The specified SamplingPattern parameters do not result in measurement points outside of the well for input sample `1`:"
      }
    }
  ];


  (* -- MaxSpeedExceeded: Message, Test and Invalid Option -- *)

  (* identify the options responsible for exceeding the max speed *)
  maxSpeedExceededOptionSets = PickList[Lookup[mapThreadErrorCheckingAssociation, SpeedRelatedOptions],samplePackets, Alternatives@@samplePacketsWithMaxSpeedExceeded];

  (* throw the message *)
  If[!MatchQ[samplePacketsWithMaxSpeedExceeded,{}]&&!gatherTests,
    Message[Error::RamanMaxSpeedExceeded,ObjectToString[samplePacketsWithMaxSpeedExceeded,Cache->newCache], maxSpeedExceededOptionSets]
  ];

  (* collect the invalid option name *)
  maxSpeedExceededOptions = If[MatchQ[samplePacketsWithMaxSpeedExceeded, Except[{}]],
    DeleteDuplicates[Flatten[maxSpeedExceededOptionSets]],
    {}
  ];

  (* -- PatternOutOfBounds: Message, Test and Invalid Option -- *)

  (* identify the options responsible for the out of bounds pattern *)
  outOfBoundsOptionSets = Cases[Lookup[mapThreadErrorCheckingAssociation, OptionsCausingPatternOutOfBounds], Except[{}]];

  (* throw the message *)
  If[!MatchQ[samplePacketsWithPatternsOutOfBounds,{}]&&!gatherTests,
    Message[Error::RamanSamplingPatternOutOfBounds, ObjectToString[samplePacketsWithPatternsOutOfBounds,Cache->newCache], outOfBoundsOptionSets]
  ];

  (* collect the invalid option name *)
  samplingPatternOutOfBoundsOptions = If[MatchQ[samplePacketsWithPatternsOutOfBounds, Except[{}]],
    DeleteDuplicates[Flatten[outOfBoundsOptionSets]],
    {}
  ];


  (* -- SwappedInnerOuterDiameter: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithSwappedInnerOuterDiameter,{}]&&!gatherTests,
    Message[Error::RamanSwappedInnerOuterDiameter,ObjectToString[samplePacketsWithSwappedInnerOuterDiameter,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  swappedInnerOuterDiameterOptions = If[MatchQ[samplePacketsWithSwappedInnerOuterDiameter, Except[{}]],
    {SpiralInnerDiameter, SpiralOuterDiameter},
    {}
  ];

  (* -- SwappedXDimensionStepSize: Message, InvalidOption -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithSwappedXDimension,{}]&&!gatherTests,
    Message[Error::RamanSwappedXDimensionStepSize,ObjectToString[samplePacketsWithSwappedXDimension,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  swappedSamplingXDimensionStepSizeOptions = If[MatchQ[samplePacketsWithSwappedXDimension, Except[{}]],
    {SamplingXDimension, SamplingXStepSize},
    {}
  ];

  (* -- SwappedYDimensionStepSize: Message, InvalidOption -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithSwappedYDimension,{}]&&!gatherTests,
    Message[Error::RamanSwappedYDimensionStepSize,ObjectToString[samplePacketsWithSwappedYDimension,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  swappedSamplingYDimensionStepSizeOptions = If[MatchQ[samplePacketsWithSwappedYDimension, Except[{}]],
    {SamplingYDimension, SamplingYStepSize},
    {}
  ];

  (* -- SwappedZDimensionStepSize: Message, InvalidOption -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithSwappedZDimension,{}]&&!gatherTests,
    Message[Error::RamanSwappedZDimensionStepSize,ObjectToString[samplePacketsWithSwappedZDimension,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  swappedSamplingZDimensionStepSizeOptions = If[MatchQ[samplePacketsWithSwappedZDimension, Except[{}]],
    {SamplingZDimension, SamplingZStepSize},
    {}
  ];


  (* -- MissingSamplingCoordinates: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingSamplingCoordinates,{}]&&!gatherTests,
    Message[Error::MissingRamanSamplingCoordinates,ObjectToString[samplePacketsWithMissingSamplingCoordinates,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingSamplingCoordinatesOptions = If[MatchQ[samplePacketsWithMissingSamplingCoordinates, Except[{}]],
    {Coordinates},
    {}
  ];


  (* -- MissingNumberOfSamplingPoints: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingNumberOfSamplingPoints,{}]&&!gatherTests,
    Message[Error::RamanMissingNumberOfSamplingPoints,ObjectToString[samplePacketsWithMissingNumberOfSamplingPoints,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingNumberOfSamplingPointsOptions = If[MatchQ[samplePacketsWithMissingNumberOfSamplingPoints, Except[{}]],
    {NumberOfSamplingPoints},
    {}
  ];


  (* -- MissingNumberOfRings: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingNumberOfRings,{}]&&!gatherTests,
    Message[Error::RamanMissingNumberOfRings,ObjectToString[samplePacketsWithMissingNumberOfRings,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingNumberOfRingsOptions = If[MatchQ[samplePacketsWithMissingNumberOfRings, Except[{}]],
    {NumberOfRings},
    {}
  ];


  (* -- MissingNumberOfShots: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingNumberOfShots,{}]&&!gatherTests,
    Message[Error::MissingNumberOfShots,ObjectToString[samplePacketsWithMissingNumberOfShots,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingNumberOfShotsOptions = If[MatchQ[samplePacketsWithMissingNumberOfShots, Except[{}]],
    {NumberOfShots},
    {}
  ];


  (* -- MissingSamplingTime: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingSamplingTime,{}]&&!gatherTests,
    Message[Error::MissingRamanSamplingTime,ObjectToString[samplePacketsWithMissingSamplingTime,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingSamplingTimeOptions = If[MatchQ[samplePacketsWithMissingSamplingTime, Except[{}]],
    {SamplingTime},
    {}
  ];


  (* -- MissingSpiralInnerDiameter: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingSpiralInnerDiameter,{}]&&!gatherTests,
    Message[Error::RamanMissingSpiralInnerDiameter,ObjectToString[samplePacketsWithMissingSpiralInnerDiameter,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingSpiralInnerDiameterOptions = If[MatchQ[samplePacketsWithMissingSpiralInnerDiameter, Except[{}]],
    {SpiralInnerDiameter},
    {}
  ];


  (* -- MissingSpiralOuterDiameter: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingSpiralOuterDiameter,{}]&&!gatherTests,
    Message[Error::RamanMissingSpiralOuterDiameter,ObjectToString[samplePacketsWithMissingSpiralOuterDiameter,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingSpiralOuterDiameterOptions = If[MatchQ[samplePacketsWithMissingSpiralOuterDiameter, Except[{}]],
    {SpiralOuterDiameter},
    {}
  ];


  (* -- MissingSpiralResolution: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingSpiralResolution,{}]&&!gatherTests,
    Message[Error::RamanMissingSpiralResolution,ObjectToString[samplePacketsWithMissingSpiralResolution,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingSpiralResolutionOptions = If[MatchQ[samplePacketsWithMissingSpiralResolution, Except[{}]],
    {SpiralResolution},
    {}
  ];


  (* -- MissingSpiralFillArea: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingSpiralFillArea,{}]&&!gatherTests,
    Message[Error::RamanMissingSpiralFillArea,ObjectToString[samplePacketsWithMissingSpiralFillArea,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  missingSpiralFillAreaOptions = If[MatchQ[samplePacketsWithMissingSpiralFillArea, Except[{}]],
    {SpiralFillArea},
    {}
  ];


  (* -- MissingSampling(X,Y,Z)StepSize: Message, Test and Invalid Option -- *)
  (* throw the message *)
  MapThread[
    If[!MatchQ[#1,{}]&&!gatherTests,
    Message[Error::MissingRamanSamplingDimension,ObjectToString[#,Cache->newCache], #2]
  ]&,
    {
      {
        samplePacketsWithMissingSamplingXDimension,
        samplePacketsWithMissingSamplingYDimension,
        samplePacketsWithMissingSamplingZDimension
      },
      {SamplingXDimension,SamplingYDimension, SamplingZDimension}
    }
  ];

  (* collect the invalid option name *)
  invalidSamplingDimensionOptions = PickList[
    {SamplingXDimension,SamplingYDimension, SamplingZDimension},
    {samplePacketsWithMissingSamplingXDimension, samplePacketsWithMissingSamplingYDimension, samplePacketsWithMissingSamplingZDimension},
    Except[{}]
  ];


  (* -- MissingSampling(X,Y,Z)StepSize: Message, Test and Invalid Option -- *)
  (* throw the message *)
  MapThread[
    If[!MatchQ[#1,{}]&&!gatherTests,
      Message[Error::MissingRamanSamplingStepSize,ObjectToString[#,Cache->newCache], #2]
    ]&,
    {
      {
        samplePacketsWithMissingSamplingXStepSize,
        samplePacketsWithMissingSamplingYStepSize,
        samplePacketsWithMissingSamplingZStepSize
      },
      {SamplingXStepSize,SamplingYStepSize, SamplingZStepSize}
    }
  ];

  (* collect the invalid option name *)
  invalidSamplingStepSizeOptions = PickList[
    {SamplingXStepSize,SamplingYStepSize, SamplingZStepSize},
    {
      samplePacketsWithMissingSamplingXStepSize,
      samplePacketsWithMissingSamplingYStepSize,
      samplePacketsWithMissingSamplingZStepSize
    },
    Except[{}]
  ];


  (* -- ERRORNAME: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingFilledSquareNumberOfTurns,{}]&&!gatherTests,
    Message[Error::RamanMissingFilledSquareNumberOfTurns,ObjectToString[samplePacketsWithMissingFilledSquareNumberOfTurns,Cache->newCache]]
  ];

  (* collect the invalid option name *)
  invalidFilledSquareNumberOfTurnsOptions = If[MatchQ[samplePacketsWithMissingFilledSquareNumberOfTurns, Except[{}]],
    {FilledSquareNumberOfTurns},
    {}
  ];


  (* -- ExcessiveSamplingTime: Message, Test and Invalid Option -- *)

  (* identify the options responsible for exceeding the time limit *)
  excessiveTimeRelatedOptionSets = PickList[Lookup[mapThreadErrorCheckingAssociation, TimeRelatedOptions],samplePackets, Alternatives@@samplePacketsWithExcessiveSamplingTime];

  (* throw the message *)
  If[!MatchQ[samplePacketsWithExcessiveSamplingTime,{}]&&!gatherTests,
    Message[Error::ExcessiveRamanSamplingTime,ObjectToString[samplePacketsWithExcessiveSamplingTime,Cache->newCache], excessiveTimeRelatedOptionSets]
  ];

  (* collect the invalid option name *)
  invalidExcessiveSamplingTimeOptions = If[MatchQ[samplePacketsWithExcessiveSamplingTime, Except[{}]],
    DeleteDuplicates[Flatten[excessiveTimeRelatedOptionSets]],
    {}
  ];

  (* -- LongSamplingTime: Message, Test and Invalid Option -- *)

  (* identify the options responsible for approaching the time limit *)
  longTimeRelatedOptionSets = PickList[Lookup[mapThreadErrorCheckingAssociation, TimeRelatedOptions],samplePackets, Alternatives@@samplePacketsWithLongSamplingTime];

  (* throw the message *)
  If[!MatchQ[samplePacketsWithLongSamplingTime,{}]&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
    Message[Warning::LongRamanSamplingTime,ObjectToString[samplePacketsWithLongSamplingTime,Cache->newCache], longTimeRelatedOptionSets]
  ];

  (* Define the tests the user will see for the above message *)
  longSamplingTimeTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[samplePacketsWithLongSamplingTime,{}],
        Nothing,
        Warning["The sampling time for samples "<>ObjectToString[samplePacketsWithLongSamplingTime,Cache->simulatedCache]<>" is less than 2 hours:",True,False]
      ];
      passingTest=If[MatchQ[samplePacketsWithLongSamplingTime,{}],
        Warning["The sampling time for every sample is less than 2 hours:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* -- UnusedSamplingPatternParameterOption: Message, Test and Invalid Options -- *)
  (*collect the unused options from the wrong sampling pattern types*)
  unusedSamplingPatternOptions = If[MatchQ[samplePacketsWithUnusedRamanSamplingPatternOptions, Except[{}]],
    Flatten[Lookup[mapThreadErrorCheckingAssociation, UnusedRamanSamplingPatternOptions]]
  ];

  (* throw the message *)
  If[!MatchQ[samplePacketsWithUnusedRamanSamplingPatternOptions,{}]&&!gatherTests,
    Message[
      Error::UnusedRamanSamplingPatternParameterOption,
      ObjectToString[samplePacketsWithUnusedRamanSamplingPatternOptions,Cache->newCache],
      PickList[
        Lookup[mapThreadErrorCheckingAssociation, UnusedRamanSamplingPatternOptions],
        samplePackets,
        Alternatives@@samplePacketsWithUnusedRamanSamplingPatternOptions
      ]
    ]
  ];

  (* make the test *)
  unusedSamplingPatternTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithUnusedRamanSamplingPatternOptions,
    "No irrelevant SamplingPattern options are specified for `1`:",
    newCache];




  (* ------- 6 --------- *)
  (* -- Blank Errors -- *)
  (* ------- 6 --------- *)

  {samplePacketsWithBlankForTablet,
    samplePacketsWithMissingBlank,
    samplePacketsWithBlankIsTablet};


  (* -- TabletWithRamanBlankSample: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithBlankForTablet,{}]&&!gatherTests,
    Message[Error::TabletWithRamanBlankSample,ObjectToString[samplePacketsWithBlankForTablet,Cache->newCache]]
  ];
  (* make the test *)
  blanksForTabletsTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithBlankForTablet,
    "No blanks are specified when the samples with a tablet form factor for `1`:",
    newCache];

  (* -- TabletWithRamanBlankSample: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithMissingBlank,{}]&&!gatherTests&&Not[MatchQ[$ECLApplication,Engine]],
    Message[Warning::RamanSampleWithoutBlank,ObjectToString[samplePacketsWithMissingBlank,Cache->newCache]]
  ];

  (* Define the tests the user will see for the above message *)
  noBlankTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[MatchQ[samplePacketsWithMissingBlank,{}],
        Nothing,
        Warning["The samples "<>ObjectToString[samplePacketsWithMissingBlank,Cache->simulatedCache]<>" have Blank specified:",True,False]
      ];
      passingTest=If[MatchQ[samplePacketsWithMissingBlank,{}],
        Warning["All samples have Blank specified:",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];


  (* -- TabletWithRamanBlankSample: Message, Test and Invalid Option -- *)
  (* throw the message *)
  If[!MatchQ[samplePacketsWithBlankIsTablet,{}]&&!gatherTests,
    Message[Error::InvalidRamanBlankFormFactor,ObjectToString[samplePacketsWithBlankIsTablet,Cache->newCache]]
  ];
  (* make the test *)
  blanksAreTabletsTests=ramanSampleTests[gatherTests,
    Test,
    samplePackets,
    samplePacketsWithBlankIsTablet,
    "Blank are not tablets for samples `1`:",
    newCache];


  (* -- collect the invalid options for blanks -- *)
  invalidBlankOption = If[
    MatchQ[
      Flatten[
        {
          samplePacketsWithBlankForTablet,
          samplePacketsWithBlankIsTablet
        }
      ], Except[{}]],
    Blank,
    {}
  ];




  (* ---------------------------------- *)
  (* -- Non-MapThread error checking -- *)
  (* ---------------------------------- *)

  (* -- incompatible sample types -- *)
  (* if the sampleType is not all (Powder|Liquid) or all Tablet, they cant go in the same plate *)
  incompatibleSampleTypesOption = If[
    Or[
      MatchQ[Lookup[resolvedOptionsAssociation, SampleType], {(Liquid|Powder)..}],
      MatchQ[Lookup[resolvedOptionsAssociation, SampleType], {Tablet..}]
    ],
    {},
    {SampleType}
  ];
  (* make the test *)
  incompatibleSampleTypeTest = testOrNull[
    gatherTests,
    "All samples can be measured in the same plate:",
    MatchQ[incompatibleSampleTypesOption, {}]
  ];

  (* throw the error *)
  If[MatchQ[incompatibleSampleTypesOption, Except[{}]]&&messages,
    Message[Error::IncompatibleRamanSampleTypes]
  ];

  (* -- Too Many Samples -- *)
  (* we need to wait until this poitn to throw this becasue it depends on the sampleType *)
  maxNumberOfSamples = Which[
    MatchQ[Lookup[resolvedOptionsAssociation, SampleType], {(Liquid|Powder)..}],
    96,

    MatchQ[Lookup[resolvedOptionsAssociation, SampleType], {Tablet..}],
    18,

    (* just be on the safe side and dont throw the error until we are sure that it is appropriate *)
    True,
    96
  ];

  (*get the number of replicates and convert a Null to 1*)
  numberOfReplicatesNumber=Lookup[myOptions,NumberOfReplicates]/.Null:>1;

  (* make the test *)
  tooManySamplesTest = testOrNull[
    gatherTests,
    "The number of samples and blanks can be measured in a single plate:",
    MatchQ[maxNumberOfSamples, GreaterEqualP[Length[mySamples]*numberOfReplicatesNumber+Length[Cases[Lookup[resolvedOptionsAssociation, Blank], ObjectP[]]]]]
  ];

  (* throw the error *)
  If[MatchQ[maxNumberOfSamples, LessP[Length[mySamples]*numberOfReplicatesNumber+Length[Cases[Lookup[resolvedOptionsAssociation, Blank], ObjectP[]]]]]&&messages,
    Message[Error::TooManyRamanSampleInputs, Length[mySamples]*numberOfReplicatesNumber+Length[Cases[Lookup[resolvedOptionsAssociation, Blank], ObjectP[]]], maxNumberOfSamples]
  ];

  (* gather the invalid inputs, which in this case is all of them *)
  tooManyInputsList = If[MatchQ[maxNumberOfSamples, LessP[(Length[mySamples]*numberOfReplicatesNumber+Length[Cases[Lookup[resolvedOptionsAssociation, Blank], ObjectP[]]])]],
    Lookup[Flatten[samplePackets],Object],
    (* if there are no low quantity inputs, the list is empty *)
    {}
  ];




  (* ---------------------- *)
  (* -- PLATE RESOLUTION -- *)

  resolvedSamplePlate = Switch[Lookup[resolvedOptionsAssociation, SampleType],

    (* if we have tablets, use the tablet holder *)
    {Tablet..},
    Model[Container, Plate, Irregular, Raman, "18-well multi-size tablet holder"],

    (* if we have only solids and liquids, use the preferred glass bottom plate *)
    {(Liquid|Powder)..},
    Model[Container, Plate, "96-well glass bottom plate"],

    (* if there are mixed tablets and powder/liquids there will be a different error, jst resolve the plate to 96 well so no unneeded errors are diplayed *)
    True,
    Model[Container, Plate, "96-well glass bottom plate"]
  ];

  (* ------------------------ *)
  (* -- ALIQUOT RESOLUTION -- *)
  (* ------------------------ *)

  (*-- CONTAINER GROUPING RESOLUTION --*)
  (* Resolve RequiredAliquotContainers *)
  (*targetContainers=targetAliquotContainerList;*)
  (* targetContainers is in the form {(Null|ObjectP[Model[Container]])..} and is index-matched to simulatedSamples. *)
  (* When you do not want an aliquot to happen for the corresopnding simulated sample, make the corresponding index of targetContainers Null. *)
  (* Otherwise, make it the Model[Container] that you want to transfer the sample into. *)

  (*figure out the required aliquot amounts*)
  (*first get the volume and mass of our original samples (not simulated)*)
  {sampleVolumes,sampleMasses,tabletBools}=Transpose[Lookup[fetchPacketFromFastAssoc[#,fastAssoc],{Volume,Mass, Tablet}]&/@mySamples];


  (*get the best aliquot amount based on the available amount*)
  bestAliquotAmount=MapThread[Which[
    MatchQ[#3,True], 1,
    MatchQ[#1,GreaterP[0*Liter]],globalMinVolume*1.25,
    MatchQ[#2,GreaterP[0*Gram]],globalMinMass*1.25,

    (*this is utterly nonsensical*)
    True,globalMinVolume

  ]&,{sampleVolumes,sampleMasses, tabletBools}];


  (* ------------------------------------ *)


  (* - Make a list of the smallest liquid handler compatible container that can potentially hold the needed volume for each sample - *)
  (* First, find the Models and the MaxVolumes of the liquid handler compatible containers *)
  {liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes}=Transpose[Download[liquidHandlerContainers, {Object, MaxVolume}]];

  (* Define the container we would transfer into for each sample, if Aliquotting needed to happen *)
  potentialAliquotContainers=
    If[VolumeQ[#],
      First[
        PickList[
        liquidHandlerContainerModels,
        liquidHandlerContainerMaxVolumes,
        GreaterEqualP[#]
      ]
      ],
      Null
  ]&/@bestAliquotAmount;

  (*add state to the mapthread, treat Nulls as Solids*)
  (* Define the RequiredAliquotContainers - we have to aliquot if the samples are not in a liquid handler compatible container *)
  requiredAliquotContainers=MapThread[
    If[(MatchQ[#1, Alternatives@@liquidHandlerContainerModels]||MatchQ[#2, Null]),
      Automatic,
      #2
    ]&,
    {simulatedSamplesContainerModels,potentialAliquotContainers}
  ];


  (* ------------------------------------ *)



  (* Resolve Aliquot Options *)
  {resolvedAliquotOptions,aliquotTests}=If[gatherTests,
    resolveAliquotOptions[
      ExperimentRamanSpectroscopy,
      mySamples,
      simulatedSamples,
      ReplaceRule[myOptions,resolvedSamplePrepOptions],
      Cache -> newCache,
      RequiredAliquotContainers->requiredAliquotContainers,
      RequiredAliquotAmounts->bestAliquotAmount,
      AllowSolids -> True,
      AliquotWarningMessage->Null,
      Output->{Result,Tests}
    ],
    {
      resolveAliquotOptions[
        ExperimentRamanSpectroscopy,
        mySamples,
        simulatedSamples,
        ReplaceRule[myOptions,resolvedSamplePrepOptions],
        Cache -> newCache,
        RequiredAliquotContainers->requiredAliquotContainers,
        RequiredAliquotAmounts->bestAliquotAmount,
        AliquotWarningMessage->Null,
        AllowSolids -> True,
        Output->Result
      ],
      {}
    }
  ];


  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  (* gather the invalid inputs *)
  invalidInputs=DeleteDuplicates[Flatten[{
    compatibleMaterialsInvalidInputs,
    deprecatedInvalidInputs,
    discardedInvalidInputs,
    lowSampleAmountInputs,
    tooManyInputsList
  }]];


  (*add the invalid options here*)
  (* gather the invalid options *)
  invalidOptions=DeleteCases[
    DeleteDuplicates[
      Flatten[
        {
          invalidMicroscopeImageOptions,
          invalidOpticsOptions,
          invalidTabletProcessingOptions,
          invalidSampleTypeOptions,

          (* sampling pattern options *)
          swappedSamplingZDimensionStepSizeOptions,
          swappedSamplingYDimensionStepSizeOptions,
          swappedSamplingXDimensionStepSizeOptions,
          swappedInnerOuterDiameterOptions,
          missingSamplingCoordinatesOptions,
          missingNumberOfSamplingPointsOptions,
          missingNumberOfRingsOptions,
          missingNumberOfShotsOptions,
          missingSamplingTimeOptions,
          missingSpiralInnerDiameterOptions,
          missingSpiralOuterDiameterOptions,
          missingSpiralResolutionOptions,
          missingSpiralFillAreaOptions,
          invalidSamplingDimensionOptions,
          invalidSamplingStepSizeOptions,
          invalidFilledSquareNumberOfTurnsOptions,
          invalidExcessiveSamplingTimeOptions,
          unusedSamplingPatternOptions,
          samplingPatternOutOfBoundsOptions,
          maxSpeedExceededOptions,

          incompatibleSampleTypesOption,
          invalidBlankOption,
          adjustmentSampleNotOnPlateOptions,
          invalidSamplesInStorageConditionOption
        }
      ]
    ],
    Null
  ];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->newCache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  ramanTests = Cases[Flatten[
    {
      lowSampleVolumeTest,
      deprecatedTest,
      discardedTest,
      compatibleMaterialsTests,
      tooManySamplesTest,
      incompatibleSampleTypeTest,

      (* microscope tests *)
      missingMicroscopeImageLightIntensityTests,
      unusedMicroscopeImageExposureTimeTests,
      unusedMicroscopeImageLightIntensityTests,
      missingRamanMicroscopeImageExposureTimeTests,

      (* optics tests *)
      objectiveMisMatchTests,
      noObjectiveTests,
      missingAdjustmentTargetTests,
      noAdjustmentTargetRequiredTests,
      missingAdjustmentSampleTests,
      noAdjustmentSampleTests,
      missingAdjustmentEmissionWavelengthTests,
      noAdjustmentEmissionWavelengthTests,
      adjustmentSampleNotOnPlateTest,

      (* sample type tests *)
      missingTabletProcessingTests,
      unusedTabletProcessingTests,
      incorrectSampleTypeTests,
      tabletProcessingInconsistancyTests,
      invalidTabletProcessingRequestedTests,
      sampleTypeRequiresDissolutionTests,

      (* samplingpattern tests *)
      samplingPatternGroupedTests,
      unusedSamplingPatternTests,

      (*blanks tests*)
      blanksAreTabletsTests,
      blanksForTabletsTests,

      (*storage condition tests*)
      validSamplesInStorageConditionTests,

      (* warnings *)
      roundedSamplingCoordinatesTest,
      longSamplingTimeTests,
      noBlankTests
    }
  ], _EmeraldTest];

  (* ------------------------ *)
  (* --- RESOLVED OPTIONS --- *)
  (* ------------------------ *)


  resolvedOptions = ReplaceRule[Normal[roundedOptions],
    Flatten[
      {
        (* -- map thread resolved options -- *)
        Normal[resolvedOptionsAssociation],
        SamplePlate -> resolvedSamplePlate,

        (* --- pass through and other resolved options ---- *)
        resolvedSamplePrepOptions,
        resolvedAliquotOptions,
        resolvedPostProcessingOptions
      }
    ]
  ]/.x:ObjectP[]:>Download[x,Object];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> ramanTests
  }
];









(* ::Subsection::Closed:: *)
(* ramanSpectroscopyResourcePackets *)



(* ====================== *)
(* == RESOURCE PACKETS == *)
(* ====================== *)

DefineOptions[ramanSpectroscopyResourcePackets,
  Options:>{
    CacheOption,
    HelperOutputOption
  }
];

ramanSpectroscopyResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
  {
    (* general variables *)
    expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden, outputSpecification,output,
    gatherTests,messages, cache,fastAssoc,

    (* resolved option values *)
    sampleType, instrument, tabletProcessing, floodLight, objectiveMagnification, laserPower, exposureTime, adjustmentSample,
    adjustmentEmissionWavelength, adjustmentTarget, backgroundRemove, cosmicRadiationFilter, calibrationCheck, invertedMicroscopeImage,
    microscopeImageExposure, microscopeImageLightIntensity, readPattern, numberOfReads, readRestTime, samplingPattern, samplingTime,
    spiralInnerDiameter, spiralOuterDiameter, spiralFillArea, spiralResolution, samplingXDimension, samplingYDimension,
    samplingZDimension, samplingXStepSize, samplingYStepSize, samplingZStepSize, filledSquareNumberOfTurns, ringSpacing,
    numberOfRings, numberOfSamplingPoints, numberOfShots, samplingCoordinates, samplePlate, blanks, samplesInStorage,

    (*download*)
    objectSamplePacketFields, listedSamplePackets,liquidHandlerContainerDownload, samplePackets,
    sampleCompositionPackets, listedSampleContainers, sampleContainersIn, liquidHandlerContainerMaxVolumes,
    liquidHandlerContainers,

    (* variables for condensed option fields in protocol *)
    safeObjectiveMagnification, composedAdjustmentMethod, composedSpiralSamplingParameters, composedSamplingDimensions,
    composedSamplingStepSizes, composedReadParameters, composedOpticalImagingParameters, composedRingSamplingParameters,
    safeLaserPower, safeReadOrder, safeExposureTime, composedSamplingCoordinates, composedTabletProcessing, composedBlank,
    remainingTabletTransfers,

    blankWellRules, blankWellsWithNulls, blankObjects, blankWells, safeBlank, sampleToWellRules, adjustmentWells,

    (* samples in resources *)
    expandedAliquotAmount, sampleAmount, minimumVolume, minimumMass, pairedSamplesInAndAmounts,
    sampleAmountRules, sampleResourceReplaceRules, samplesInResources,

    (* other resources *)
    tabletCutterResource, tabletCrusherResource, instrumentResource, samplePlateResource, tabletCrusherBagResource,
    blankAmounts, blankResourcesReplaceRules, updatedComposedBlank, tweezerResource,

    (* time estimates *)
    totalSamplingTime, samplingTimes, safeSamplingTimes, samplePrepTime, adjustmentTime, numberOfAdjustments,batchRunTime,
    
    samplesWithoutLinks,tablets, numberOfReplicates,samplesWithReplicates,optionsWithReplicates,
    recoupSample,
    protocolPacket,allResourceBlobs,fulfillable,frqTests,resultRule,testsRule,
    gatherResourcesTime
  },

  (* --------------------------- *)
  (*-- SETUP OPTIONS AND CACHE --*)
  (* --------------------------- *)


  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentRamanSpectroscopy, {mySamples}, myResolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
    ExperimentRamanSpectroscopy,
    RemoveHiddenOptions[ExperimentRamanSpectroscopy,myResolvedOptions],
    Ignore->myUnresolvedOptions,
    Messages->False
  ];

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests=MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cache=Cases[Lookup[ToList[myOptions],Cache], PacketP[]];

  (* Get rid of the links in mySamples. *)
  samplesWithoutLinks=mySamples/.x:ObjectP[]:>Download[x, Object];

  (* Get our number of replicates. *)
  numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates]/.{Null->1};

  (*Get our instrument*)
  instrument=Lookup[myResolvedOptions,Instrument];

  (* Expand our samples and options according to NumberOfReplicates. *)
  {samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentRamanSpectroscopy,samplesWithoutLinks,myResolvedOptions];

  (* Lookup some of our options that were expanded.*)
  (*{recoupSample} =Lookup[optionsWithReplicates,{RecoupSample}];*)

  (* ------------------- *)
  (* -- OPTION LOOKUP -- *)
  (* ------------------- *)

  (* split the lookup by category for readability *)

  (* GENERAL OPTIONS *)
  {
    sampleType, tabletProcessing, samplePlate, blanks, samplesInStorage
  } = Lookup[optionsWithReplicates,
    {
      SampleType, TabletProcessing, SamplePlate, Blank, SamplesInStorageCondition
    }
  ];

  (* OPTICS AND IMAGING *)
  {
    floodLight, objectiveMagnification, laserPower, exposureTime, adjustmentSample,
    adjustmentEmissionWavelength, adjustmentTarget, backgroundRemove, cosmicRadiationFilter, calibrationCheck, invertedMicroscopeImage,
    microscopeImageExposure, microscopeImageLightIntensity, readPattern, numberOfReads, readRestTime
  } = Lookup[optionsWithReplicates,
    {
      FloodLight, ObjectiveMagnification, LaserPower, ExposureTime, AdjustmentSample,
      AdjustmentEmissionWavelength, AdjustmentTarget, BackgroundRemove, CosmicRadiationFilter, CalibrationCheck, InvertedMicroscopeImage,
      MicroscopeImageExposureTime, MicroscopeImageLightIntensity, ReadPattern, NumberOfReads, ReadRestTime
    }
  ];

  (* SAMPLING PARAMETERS *)
  {
    samplingPattern, samplingTime,
    spiralInnerDiameter, spiralOuterDiameter, spiralFillArea, spiralResolution, samplingXDimension, samplingYDimension,
    samplingZDimension, samplingXStepSize, samplingYStepSize, samplingZStepSize, filledSquareNumberOfTurns, ringSpacing,
    numberOfRings, numberOfSamplingPoints, numberOfShots, samplingCoordinates
  } = Lookup[optionsWithReplicates,
    {
      SamplingPattern, SamplingTime,
      SpiralInnerDiameter, SpiralOuterDiameter, SpiralFillArea, SpiralResolution, SamplingXDimension, SamplingYDimension,
      SamplingZDimension, SamplingXStepSize, SamplingYStepSize, SamplingZStepSize, FilledSquareNumberOfTurns, RingSpacing,
      NumberOfRings, NumberOfSamplingPoints, NumberOfShots, SamplingCoordinates}
  ];

  (* ---------------- *)
  (* -- "DOWNLOAD" -- *)
  (* ---------------- *)

  (* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
  (* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
  liquidHandlerContainers=ramanLiquidHandlerContainers[];
  Clear[ramanLiquidHandlerContainers];

  (* get the packets without using download *)
  fastAssoc = makeFastAssocFromCache[cache];
  listedSamplePackets = fetchPacketFromFastAssoc[#,fastAssoc]&/@mySamples;

  (* Make a list of all the maximum volumes *)
  liquidHandlerContainerMaxVolumes=Download[liquidHandlerContainers, MaxVolume];

  (* ----------------- *)
  (* -- Pate Layout -- *)
  (* ----------------- *)

  (* -- safe readOrder -- *)
  (* now that we have reslved the plate, we can determine the well order *)
  (* the read order is a list of wells. We will determine the pattern then take the appropriate number of wells based on the plate *)

  safeReadOrder = Switch[readPattern,

    Row,
    ConvertWell[Range[Length[samplesWithReplicates]], InputFormat -> Index, OutputFormat -> Position],

    Column,
    ConvertWell[Range[Length[samplesWithReplicates]], InputFormat -> TransposedIndex, OutputFormat -> Position],

    Serpentine,
    ConvertWell[Range[Length[samplesWithReplicates]], InputFormat -> SerpentineIndex, OutputFormat -> Position],

    TransposedSerpentine,
    ConvertWell[Range[Length[samplesWithReplicates]], InputFormat -> TransposedSerpentineIndex, OutputFormat -> Position],

    {WellP..},
    readPattern
  ];




  (* -------------------- *)
  (* -- PREPARE FIELDS -- *)
  (* -------------------- *)

  (* some options are gathered together for better readablity in the protocol object  *)

  (* -- tablet processing -- *)
  composedTabletProcessing = Map[
    Which[
      MatchQ[#, Grind],
      {None, True},

      MatchQ[#, (LargestCrossSection|SmallestCrossSection)],
      {#,False},

      MatchQ[#, Whole],
      {Whole,False},

      (*anything else*)
      True,
      {None, False}
    ]&,
    tabletProcessing
  ];

  (* -- tablet transfers -- *)
  remainingTabletTransfers = Length[Cases[composedTabletProcessing, {(Whole|LargestCrossSection|SmallestCrossSection),_}|{_,True}]];


  (* -- laser power -- *)
  safeLaserPower = Map[
    If[MatchQ[#, Optimize],
      {Null, True},
      {#, False}
    ]&,
    laserPower
  ];

  (* -- exposure time -- *)
  safeExposureTime = Map[
    If[MatchQ[#, Optimize],
      {Null, True},
      {#, False}
    ]&,
    exposureTime
  ];

  (* -- Safe Objective Magnification -- *)
  safeObjectiveMagnification = objectiveMagnification/.(Null->0);

  (* -- compose blanks -- *)
  (* this has the form of (sample, position, window boolean) *)

  (* determine the blank objects *)
  (* TODO: need to make a call on if samples in are eligible for use as blanks, right now they are but will create an unused duplicate resource  *)
  blankObjects =DeleteDuplicates[Download[Cases[blanks, ObjectP[]], Object]];

  (* first we need to determine which wells we are looking at *)
  (* this will be all wells in the plate except for those used up by the samples  *)
  blankWells = Switch[readPattern,

    Row,
    ConvertWell[Range[Length[Join[samplesWithReplicates, blankObjects]]][[Length[samplesWithReplicates]+1;;]], InputFormat -> Index, OutputFormat -> Position],

    Column,
    ConvertWell[Range[Length[Join[samplesWithReplicates, blankObjects]]][[Length[samplesWithReplicates]+1;;]], InputFormat -> TransposedIndex, OutputFormat -> Position],

    Serpentine,
    ConvertWell[Range[Length[Join[samplesWithReplicates, blankObjects]]][[Length[samplesWithReplicates]+1;;]], InputFormat -> SerpentineIndex, OutputFormat -> Position],

    TransposedSerpentine,
    ConvertWell[Range[Length[Join[samplesWithReplicates, blankObjects]]][[Length[samplesWithReplicates]+1;;]], InputFormat -> TransposedSerpentineIndex, OutputFormat -> Position],

    {WellP..},
    DeleteCases[ConvertWell[Range[Length[Join[samplesWithReplicates, blankObjects]]], InputFormat -> Index, OutputFormat -> Position], Alternatives@@readPattern]
  ];

  blankWellRules = If[MatchQ[blankObjects, Except[{}]],
    Join[
      MapThread[(#1 -> #2)&, {blankObjects, blankWells}],
      {None->Null, Window -> Null}
    ],
    {None->Null, Window -> Null}
  ];

  (* safe blanks *)
  safeBlank = blanks/.x:ObjectP[]:>Download[x, Object];

  (* substitute out teh objects for the wells *)
  blankWellsWithNulls = safeBlank/.blankWellRules;

  (* compose the blanks field for the protocol object *)
  composedBlank = MapThread[
    Which[
      MatchQ[#1, Window],
      {Null, Null, True},

      MatchQ[#1, ObjectP[]],
      {Link[#1], #2, False},

      MatchQ[#1, None],
      {Null, Null, False}
    ]&,
    {safeBlank, blankWellsWithNulls}
  ];



  (* -- compose the Adjustment Method -- *)
  (* this has the form of: {Sample, Well, Target, Wavelength} *)

  (* make rules relating the samples to their wells *)
  (*TODO: this map may no longer work corrently*)
  sampleToWellRules = MapThread[(#1 -> #2)&, {Download[samplesWithReplicates, Object, Cache -> cache], safeReadOrder}];

  (* figure out which well we are using - use the rules. Note that with replicates there may be multiple Object1 -> Well1, Object2 -> Well2 etc but since they are the same, it is ok to use any well with a given sample as the adjustment sample.  *)
  adjustmentWells = (Download[adjustmentSample, Object])/.Join[blankWellRules, sampleToWellRules];

  (* compose the method file *)
  composedAdjustmentMethod = MapThread[
    {#1/.(x:ObjectP[]:>Link[x]), #2, #3/.{Max -> Null}, #4}&,
    {adjustmentSample, adjustmentWells, adjustmentEmissionWavelength, adjustmentTarget}
  ];


  (* -- compose the spiral parameters -- *)
  (* this has the form of: {Inner diamter, outer diameter, resolution, fill} *)
  composedSpiralSamplingParameters = Transpose[
    {
      spiralInnerDiameter,
      spiralOuterDiameter,
      spiralResolution,
      spiralFillArea
    }
  ];

  (* -- compose the sampling dimensions -- *)
  (* this has the form of: {x,y,z} *)
  composedSamplingDimensions = Transpose[
    {
      samplingXDimension,
      samplingYDimension,
      samplingZDimension
    }
  ];

  (* -- compose the sampling step sizes -- *)
  (* this has the form of: {x,y,z} *)
  composedSamplingStepSizes = Transpose[
    {
      samplingXStepSize,
      samplingYStepSize,
      samplingZStepSize
    }
  ];

  (* -- compose the Read parameters -- *)
  (* this has the form of: {number of reads, read rest time} *)
  composedReadParameters = Transpose[
    {
      numberOfReads,
      readRestTime
    }
  ];

  (* -- compose the Ring parameters -- *)
  (*the form is: {spacing, number, samplingpoints}*)
  composedRingSamplingParameters = Transpose[
    {
      numberOfRings,
      ringSpacing,
      numberOfSamplingPoints
    }
  ];

  (* -- compose the Optical Image parameters -- *)
  composedOpticalImagingParameters = Transpose[
    {
      microscopeImageExposure/.Optimize -> 1 Millisecond,
      microscopeImageLightIntensity/.Optimize -> 10 Percent,
      MapThread[
        If[MemberQ[{#1, #2}, Optimize], True, False]&,
        {microscopeImageExposure, microscopeImageLightIntensity}
      ]
    }
  ];

  (* -- prepare the sampling coordinates -- *)
  composedSamplingCoordinates  = Map[
    If[MatchQ[#, Null],
      Null,
      QuantityArray[Unitless[UnitConvert[#, Micrometer]], {Micrometer, Micrometer, Micrometer}]
    ]&,
    samplingCoordinates
  ];


  (* -------------------------- *)
  (* -- SAMPLES IN RESOURCES -- *)
  (* -------------------------- *)

  (* -- Generate resources for the SamplesIn -- *)
  (* pull out the AliquotAmount option *)
  expandedAliquotAmount = Lookup[optionsWithReplicates, AliquotAmount];

  (* Get the sample amount; if we're aliquoting, use that amount; otherwise use the minimum amount the experiment will require *)
  (* set the minimum volume and mass for this experiment *)
  minimumVolume = 100 Microliter;
  minimumMass = 100 Milligram;

  (* check what type of sample we are dealing with in order to grab the correct resource *)
  sampleAmount = MapThread[
    Which[
      MatchQ[#2, (Liquid|Null)],
      If[VolumeQ[#1],
        #1,
        minimumVolume
      ],

      MatchQ[#3, True],
      If[IntegerQ[#1],
        #1,
        1
      ],

      MatchQ[#2, Solid],
      If[MassQ[#1],
        #1,
        minimumMass
      ]
    ]&,
    {
      expandedAliquotAmount,
      fastAssocLookup[fastAssoc, #, State]&/@Download[samplesWithReplicates, Object, Cache -> cache],
      fastAssocLookup[fastAssoc, #, State]&/@Download[samplesWithReplicates, Object, Cache -> cache]
    }
  ];




  (* Pair the SamplesIn and their Amounts *)
  pairedSamplesInAndAmounts = MapThread[
    (#1 -> #2)&,
    {samplesWithReplicates, sampleAmount}
  ];

  (* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
  sampleAmountRules = Merge[pairedSamplesInAndAmounts, Total];

  (* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
  sampleResourceReplaceRules = KeyValueMap[
    Function[{sample, amount},
      If[VolumeQ[amount],
        (*sample -> Resource[Sample -> Lookup[sample, Object], Name -> ToString[Unique[]], Amount -> amount * numReplicates],*)
        (sample -> Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount]),
        (sample -> Resource[Sample -> Download[sample, Object], Name -> ToString[Unique[]], Amount -> amount])
      ]
    ],
    sampleAmountRules
  ];

  (* Use the replace rules to get the sample resources *)
  (*samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];*)
  samplesInResources = Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];


  (* --------------------- *)
  (* -- BLANK RESOURCES -- *)
  (* --------------------- *)

  (* TODO: make a distinction between liquid and solid samples so that liquid samples can do microSM *)

  (* we already deleted duplciates, so each memeber of the blankObjects list will need a unique resource - also removed any instances of samplesIn*)
  (* decide the resoruce amount based on the State *)
  blankAmounts = (fastAssocLookup[fastAssoc, #, State]&/@Download[blankObjects, Object, Cache -> cache])/.{Solid ->100 Milligram, Liquid -> 100 Microliter};

  (* make replace rules to swap the blank objects for the resources *)
  blankResourcesReplaceRules = MapThread[
    If[VolumeQ[#2],
      (#1 -> Resource[Sample -> Download[#1, Object], Container -> PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[#2]], Name -> ToString[Unique[]], Amount -> #2]),
      (#1 -> Resource[Sample -> Download[#1, Object], Name -> ToString[Unique[]], Amount -> #2])
    ]&,
    {blankObjects, blankAmounts}
  ];

  (*swap the resources into the blanks field - note that they come prewrapped in Link*)
  updatedComposedBlank = composedBlank/.blankResourcesReplaceRules;

  (* -------------------- *)
  (* -- TIME ESTIMATES -- *)
  (* -------------------- *)

  (* map thread over the sample parameters to determine the amount of time each sampling pattern is going to take, multiply by the number of reads and add the number of reads x read rest time.  *)
  (* then multiply everything by number of replicates *)

  (* -- instrument time estimate -- *)

  (* determine the total sampling time, assuming that the optimized exposure time will be ~100 Millisecond *)
  samplingTimes = Map[
    Module[{timePerSample, samplingTimeWithReads},

    (* if there are no errors, then check the time that it will take to do the sampling and the required speed *)
    timePerSample = Switch[samplingPattern[[#]],

      (* single point time check *)
      SinglePoint,
      (exposureTime[[#]]/.(Optimize -> 100 Millisecond))*numberOfShots[[#]],

      Spiral,
      (* I dont know how this calculation is done but this appears to be the rule *)
      samplingTime[[#]],

      FilledSquare,
      (* this one at least makes sense *)
      samplingTime[[#]],

      FilledSpiral,
      (* the amount of area times the percent coverage divided by the beam size?  *)
      Module[{numberOfConcentricCircles, concentricCirclesCircumferences, objectiveToSpotSizeLookup, totalPathLength, speed},
        (* need to know the speed and how long the path is that it will travel. Speed is resolution/exposure time
        the path length is dictated by the spot size and the *)

        (* TODO: this lookup could move out to the general section if it is useful elsewhere. may even want this to live in teh instrument object *)
        objectiveToSpotSizeLookup = {
          20 -> 35 Micrometer,
          10 -> 50 Micrometer,
          4 -> 150 Micrometer,
          2 -> 330 Micrometer,
          Null -> 1750 Micrometer
        };

        (* determine the number of circles the pattern will need to have to obtain the desired coverage *)
        numberOfConcentricCircles = Unitless[
          SafeRound[
            0.5*Normal[spiralFillArea[[#]]]*(spiralOuterDiameter[[#]]-spiralInnerDiameter[[#]])/(objectiveMagnification[[#]]/.objectiveToSpotSizeLookup),
            1,
            AvoidZero->True
          ]
        ];

        (* calculate the radii or the circular paths as Pi*d *)
        concentricCirclesCircumferences = Table[(3.14*(spiralInnerDiameter[[#]]+(spiralOuterDiameter[[#]]-spiralInnerDiameter[[#]])/ringNumber)), {ringNumber, 1, numberOfConcentricCircles}];

        (* sum all the quasi-circular paths in the spiral *)
        totalPathLength = Total[concentricCirclesCircumferences];

        (* calculate the speed based on the exposure and resolution - this is how it is done in the software *)
        speed = spiralResolution[[#]]/(exposureTime[[#]]/.(Optimize -> 100 Millisecond));

        (* use the speed and distance to compute time *)
        totalPathLength/speed
      ],

      Grid,
      Module[{numberOfSteps},
        numberOfSteps = {
          (samplingXDimension[[#]]/.{0->1})/(samplingXStepSize[[#]]/.{0->1}),
          (samplingYDimension[[#]]/.{0->1})/(samplingYStepSize[[#]]/.{0->1}),
          (samplingZDimension[[#]]/.{0->1})/(samplingZStepSize[[#]]/.{0->1})
        };

        Times[Sequence@@Join[numberOfSteps, {numberOfShots[[#]],(exposureTime[[#]]/.(Optimize -> 100 Millisecond))}]]
      ],

      Rings,
      (numberOfSamplingPoints[[#]]*(exposureTime[[#]]/.(Optimize -> 100 Millisecond))*numberOfShots[[#]]),

      Coordinates,
      (Length[samplingCoordinates[[#]]] * (exposureTime[[#]]/.(Optimize -> 100 Millisecond)) * numberOfShots[[#]])
    ];

    samplingTimeWithReads = (timePerSample+readRestTime[[#]])*numberOfReads[[#]]
    ]&,

    (* we can just map over the index since I dont want to gather all of these variables *)
    Range[Length[mySamples]]
  ];

  (* add the sampling times *)
  totalSamplingTime = Round[UnitConvert[Total[samplingTimes], Minute], 1 Minute];

  (* make a safe sampling time for the protocol *)
  safeSamplingTimes = Map[
    If[MatchQ[#, _?QuantityQ],
      Round[#, 0.1 Minute],
      0.1 Minute
    ]&,
    samplingTimes
  ];

  (* -- adjustment estimate -- *)

  (* if the power and exposure are going to be optimized, it will take ~3 minutes each *)
  numberOfAdjustments = Length[Cases[adjustmentSample, ObjectP[]]];
  adjustmentTime = numberOfAdjustments*3 Minute;

  (* -- sample prep estimate -- *)
  
  (* this includes tablet processing and the potential SMs to load the plate with *)
  (* since I dont really know how long this takes, I'm just going to say 2 min per sample and 10 minutes for setup/teardown *)
  samplePrepTime = (10 Minute)*Length[samplesWithReplicates];
  
  
  (* -- resource picking estimate -- *)
  
  (*roughly calculate the time required to gather resources*)
  gatherResourcesTime=(10 Minute)*Length[samplesWithReplicates];


  (* ------------------------------- *)
  (* -- INSTRUMENT/ITEM RESOURCES -- *)
  (* ------------------------------- *)

  (* -- spectrometer -- *)
  (*get the instrument resources. we will assume 30 minutes per sample for the instrument*)
  instrumentResource=Resource[Instrument->instrument,Time->(10 Minute)+totalSamplingTime+adjustmentTime];


  (* -- tablet cutter and crusher -- *)
  (* if there is tablet processing, gather the relevant resources *)
  (*TODO: remove hard coding here*)
  tabletCutterResource = If[MemberQ[tabletProcessing, (LargestCrossSection|SmallestCrossSection)],
    Resource[Sample -> Model[Item, TabletCutter, "Single blade tablet cutter"]],
    Null
  ];

  tabletCrusherResource = If[MemberQ[tabletProcessing, (Grind)],
    Resource[Sample -> Model[Item, TabletCrusher, "Silent Knight tablet crusher"]],
    Null
  ];

  tabletCrusherBagResource = If[MemberQ[tabletProcessing, (Grind)],
    Resource[Sample -> Model[Item, TabletCrusherBag, "Silent Knight tablet crusher bag"], Amount -> Length[Cases[tabletProcessing, Grind]], UpdateCount -> True],
    Null
  ];

  tweezerResource = If[MemberQ[tabletProcessing, Except[Null]],
    Resource[Sample -> Model[Item, Tweezer, "Straight flat tip tweezer"]],
    Null
  ];
  (* -------------------- *)
  (* -- PLATE RESOURCE -- *)
  (* -------------------- *)

  (* generate a resource for the plate used for this experiment *)
  samplePlateResource = Resource[Sample -> samplePlate];


  (* -- determine which samples are tablets -- *)
  (* if the tablet processing is anything except Null, it is a tablet that is going to be processed *)
  tablets = PickList[samplesWithReplicates, tabletProcessing, Except[Null]];

  (* --------------------- *)
  (* -- PROTOCOL PACKET -- *)
  (* --------------------- *)

  (* Create our protocol packet. *)
  protocolPacket=Join[<|
    Type->Object[Protocol,RamanSpectroscopy],
    Object->CreateID[Object[Protocol,RamanSpectroscopy]],
    Replace[SamplesIn]->samplesInResources,
    Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@DeleteDuplicates[Lookup[fetchPacketFromCache[#,cache],Container]&/@samplesWithReplicates],
    (*Replace[RecoupSample]->recoupSample,*)

    (* tool and instrument resources *)
    TabletCutter -> Link[tabletCutterResource],
    TabletCrusher -> Link[tabletCrusherResource],
    TabletCrusherBag -> Link[tabletCrusherBagResource],
    Tweezers -> Link[tweezerResource],
    SamplePlate -> Link[samplePlateResource],
    Instrument -> Link[instrumentResource],

    (* general parameters *)
    CalibrationCheck -> calibrationCheck,
    Replace[SampleType] -> sampleType,
    Replace[TabletProcessing] -> composedTabletProcessing,
    RemainingTabletTransfers -> remainingTabletTransfers,
    Replace[Tablets]->(Link/@tablets)/.{{}->Null},

    (* optics and adjustment *)
    Replace[ObjectiveMagnification] -> safeObjectiveMagnification,
    Replace[FloodLight] -> floodLight,
    Replace[LaserPower] -> safeLaserPower,
    Replace[ExposureTime] -> safeExposureTime,
    Replace[AdjustmentMethod] -> composedAdjustmentMethod,
    Replace[BackgroundRemove] -> backgroundRemove,
    Replace[CosmicRadiationFilter] -> cosmicRadiationFilter,
    Replace[Blanks] -> updatedComposedBlank,

    (* reading *)
    Replace[ReadParameters]->composedReadParameters,
    Replace[ReadOrder] -> safeReadOrder,

    (* sampling pattern *)
    Replace[SamplingPattern]->samplingPattern,
    Replace[SamplingTime]->samplingTime,
    Replace[SpiralSamplingParameters]-> composedSpiralSamplingParameters,
    Replace[SamplingDimensions]->composedSamplingDimensions,
    Replace[SamplingStepSize]->composedSamplingStepSizes,
    Replace[NumberOfShots]->numberOfShots/.{Null->1},
    Replace[SamplingCoordinates]->composedSamplingCoordinates,
    Replace[RingSamplingParameters] -> composedRingSamplingParameters,
    Replace[FilledSquareNumberOfTurns] -> filledSquareNumberOfTurns/.{Null -> 0},
    Replace[SamplingRunTime] -> safeSamplingTimes,

    (* microscope image *)
    Replace[OpticalImagingParameters] -> composedOpticalImagingParameters,

    (* checkpoints *)
    Replace[Checkpoints]->{
      {"Preparing Samples",0 Minute,"Preprocessing, such as thermal incubation/mixing, centrifugation, filteration, and aliquoting, is performed.", Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->0 Minute]},
      {"Picking Resources",gatherResourcesTime,"Samples required to execute this protocol are gathered from storage.",Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->gatherResourcesTime]},
      {"Preparing Plate", samplePrepTime, "Tablets are prepared for measurement, and samples are loaded into the measurement plate.", Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> samplePrepTime]},
      {"Measure Raman Spectra",(10 Minute)+totalSamplingTime,"The Raman spectra of the requested samples is measured.",Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->(10 Minute)+totalSamplingTime]},
      {"Sample Postprocessing",0 Minute,"The samples are imaged and volumes are measured.",Resource[Operator->Model[User,Emerald,Operator,"Trainee"],Time->0 Minute]}
    },
    ResolvedOptions->myCollapsedResolvedOptions,
    UnresolvedOptions->myUnresolvedOptions,
    Replace[SamplesInStorage]->samplesInStorage
  |>,
    populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache]
  ];

  (* ---------------------- *)
  (* -- CLEAN UP AND FRQ -- *)
  (* ---------------------- *)


  (* get all the resource "symbolic representations" *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

  (* call fulfillableResourceQ on all resources we created *)
  {fulfillable,frqTests}=Which[
    MatchQ[$ECLApplication,Engine],
    {True,{}},
    gatherTests,
    Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache -> cache],
    True,
    {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache -> cache],Null}
  ];

  (* generate the tests rule *)
  testsRule=Tests->If[gatherTests,
    frqTests,
    Null
  ];

  (* generate the Result output rule *)
  (* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
    protocolPacket,
    $Failed
  ];

  (* Return our result. *)
  outputSpecification/.{resultRule,testsRule}
];







(* ::Subsubsection::Closed:: *)
(*ExperimentRamanSpectroscopy: Sister Functions*)


(* ------------- *)
(* -- OPTIONS -- *)
(* ------------- *)

DefineOptions[ExperimentRamanSpectroscopyOptions,
  Options:>{
    {
      OptionName->OutputFormat,
      Default->Table,
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Table,List]],
      Description->"Indicates whether the function returns a table or a list of the options."
    }
  },
  SharedOptions :> {ExperimentRamanSpectroscopy}
];

ExperimentRamanSpectroscopyOptions[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ExperimentRamanSpectroscopyOptions]]:=Module[
  {listedOptions,preparedOptions,resolvedOptions},

  listedOptions=ToList[myOptions];

  (* Send in the correct Output option and remove OutputFormat option *)
  preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

  resolvedOptions=ExperimentRamanSpectroscopy[myInput,preparedOptions];

  (* Return the option as a list or table *)
  If[MatchQ[OptionDefault[OptionValue[OutputFormat]],Table]&&MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
    LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentRamanSpectroscopy],
    resolvedOptions
  ]
];



(* ------------- *)
(* -- PREVIEW -- *)
(* ------------- *)


DefineOptions[ExperimentRamanSpectroscopyPreview,
  SharedOptions :> {ExperimentRamanSpectroscopy}
];

ExperimentRamanSpectroscopyPreview[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ExperimentRamanSpectroscopyPreview]]:=Module[
  {listedOptions},

  listedOptions=ToList[myOptions];

  ExperimentRamanSpectroscopy[myInput,ReplaceRule[listedOptions,Output->Preview]]
];

(* ------------- *)
(* -- VALIDQ -- *)
(* ------------- *)


DefineOptions[ValidExperimentRamanSpectroscopyQ,
  Options:>{
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentRamanSpectroscopy}
];

ValidExperimentRamanSpectroscopyQ[myInput:ListableP[ObjectP[{Object[Sample],Object[Container]}]|_String],myOptions:OptionsPattern[ValidExperimentRamanSpectroscopyQ]]:=Module[
  {listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOps,verbose,outputFormat,result},

  listedInput=ToList[myInput];
  listedOptions=ToList[myOptions];

  (* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
  preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

  (* Call the function to get a list of tests *)
  functionTests=ExperimentRamanSpectroscopy[myInput,preparedOptions];

  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  allTests=If[MatchQ[functionTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
      voqWarnings=MapThread[
        Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
          #2,
          True
        ]&,
        {DeleteCases[listedInput,_String],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Join[{initialTest},functionTests,voqWarnings]
    ]
  ];

  (* Lookup test running options *)
  safeOps=SafeOptions[ValidExperimentRamanSpectroscopyQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
  {verbose,outputFormat}=Lookup[safeOps,{Verbose,OutputFormat}];

  (* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
  Lookup[
    RunUnitTest[
      <|"ExperimentRamanSpectroscopy"->allTests|>,
      Verbose->verbose,
      OutputFormat->outputFormat
    ],
    "ExperimentRamanSpectroscopy"
  ]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRamanSpectroscopy: Helper Functions*)

(* ------------------- *)
(* -- CHECK OPTIONS -- *)
(* ------------------- *)


(* ======================== *)
(* == ramanSampleTests HELPER == *)
(* ======================== *)

(* Conditionally returns appropriate tests based on the number of failing samples and the gather tests boolean
	Inputs:
		testFlag - Indicates if we should actually make tests
		allSamples - The input samples
		badSamples - Samples which are invalid in some way
		testDescription - A description of the sample invalidity check
			- must be formatted as a template with an `1` which can be replaced by a list of samples or "all input samples"
	Outputs:
		out: {(_Test|_Warning)...} - Tests for the good and bad samples - if all samples fall in one category, only one test is returned *)

ramanSampleTests[testFlag:False,testHead:(Test|Warning),allSamples_,badSamples_,testDescription_,cache_]:={};

ramanSampleTests[testFlag:True,testHead:(Test|Warning),allSamples:{PacketP[]..},badSamples:{PacketP[]...},testDescription_String,cache_]:=Module[{
  numberOfSamples,numberOfBadSamples,allSampleObjects,badObjects,goodObjects},

  (* Convert packets to objects *)
  allSampleObjects=Lookup[allSamples,Object];
  badObjects=Lookup[badSamples,Object,{}];

  (* Determine how many of each sample we have - delete duplicates in case one of sample sets was sent to us with duplicates removed *)
  numberOfSamples=Length[DeleteDuplicates[allSampleObjects]];
  numberOfBadSamples=Length[DeleteDuplicates[badObjects]];

  (* Get a list of objects which are okay *)
  goodObjects=Complement[allSampleObjects,badObjects];

  Which[
    (* All samples are okay *)
    MatchQ[numberOfBadSamples,0],{testHead[StringTemplate[testDescription]["all input samples"],True,True]},

    (* All samples are bad *)
    MatchQ[numberOfBadSamples,numberOfSamples],{testHead[StringTemplate[testDescription]["all input samples"],False,True]},

    (* Mixed samples *)
    True,
    {
      (* Passing Test *)
      testHead[StringTemplate[testDescription][ObjectToString[goodObjects,Cache->cache]],True,True],
      (* Failing Test *)
      testHead[StringTemplate[testDescription][ObjectToString[badObjects,Cache->cache]],False,True]
    }
  ]
];