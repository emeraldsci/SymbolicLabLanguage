(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentImageCells*)


(* ::Subsubsection:: *)
(* variable setup *)


(* store the instrument objects/models that are not high content imager to display in the option description *)
(* FIXME: update here whenever there's an additional inverted microscope object/model *)
$ImageCellsInvertedMicroscopes={
	Model[Instrument,Microscope,"Ti-E Inverted Microscope"],
	Object[Instrument,Microscope,"Epifluorescence inverted microscope"]
};


(* ::Subsubsection:: *)
(* AcquireImage shared options *)


DefineOptionSet[
	acquireImagePrimitiveOptions:>{
		(* --------------- *)
		(* Required Option *)
		(* --------------- *)
		{
			OptionName->Mode,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>MicroscopeModeP
			],
			Description->"The type of microscopy technique used to acquire an image of a sample. BrightField is the simplest type of microscopy technique that uses white light to illuminate the sample, resulting in an image in which the specimen is darker than the surrounding areas that are devoid of it. Bright-field microscopy is useful for imaging samples stained with dyes or samples with intrinsic colors. PhaseContrast microscopy increases the contrast between the sample and its background, allowing it to produce highly detailed images from living cells and transparent biological samples. The contrast is enhanced such that the boundaries of the sample and its structures appear much darker than the surrounding medium. Epifluorescence microscopy uses light at a specific wavelength range to excite a fluorophore of interest in the sample and capture the resulting emitted fluorescence to generate an image. ConfocalFluorescence microscopy employs a similar principle as Epifluorescence to illuminate the sample and capture the emitted fluorescence along with pinholes in the light path to block out-of-focus light in order to increase optical resolution. Confocal microscopy is often used to image thick samples or to clearly distinguish structures that vary in height along the z-axis.",
			ResolutionDescription->"Automatically set to Epifluorescence if any fluorophore is present in DetectionLabels Field of the sample's identity model. Otherwise, set to BrightField if DetectionLabels is an empty list.",
			Category->"General"
		},

		(* --------------- *)
		(* DetectionLabels *)
		(* --------------- *)
		{
			OptionName->DetectionLabels,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Molecule]]
				],
				Adder[
					Widget[
						Type->Object,
						Pattern:>ObjectP[Model[Molecule]]
					]
				]
			],
			Description->"Indicates the tags, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be imaged.",
			ResolutionDescription->"Automatically set to an object or a list of objects present in the DetectionLabels Field of the sample's identity model that does not exist in other AcquireImage primitives.",
			Category->"General"
		},

		(* ----------------------------------------------- *)
		(* General optics setup options for the microscope *)
		(* ----------------------------------------------- *)
		{
			(* Long Automatic: not resolved at experiment time. *)
			OptionName->FocalHeight,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Millimeter],
					Units->Alternatives[Micrometer,Millimeter]
				],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Autofocus,Manual]
				]
			],
			Description->"The distance between the top of the objective lens and the bottom of the sample when the imaging plane is in focus. If set to Autofocus, the microscope will obtain a small stack of images along the z-axis of the sample and determine the best focal plane based on the image in the stack that shows the highest contrast. FocalHeight is then calculated from the location of the best focal plane on the z-axis. If set to Manual, the FocalHeight will be adjutsted manually.",
			ResolutionDescription->"Automatically set to Autofocus if the selected instrument supports autofocusing. Otherwise, set to Manual.",
			Category->"Image Acquisition"
		},
		{
			(* Long Automatic: not resolved at experiment time. *)
			OptionName->ExposureTime,
			Default->AutoExpose,
			AllowNull->False,
			Widget->Alternatives[
				Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Millisecond],
					Units->Alternatives[Microsecond,Millisecond,Second]
				],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[AutoExpose]
				]
			],
			Description->"The length of time that the camera collects the signal from the sample. The longer the exposure time, the more photons the detector can collect, resulting in a brighter image. Selecting AutoExpose will prevent the pixels from becoming saturated by allowing the microscope software to determine the exposure time such that the brightest pixel is 75% of the maximum gray level that the camera can obtain.",
			Category->"Image Acquisition"
		},
		{
			OptionName->TargetMaxIntensity,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0,65535]
			],
			Description->"Specifies the intensity that the instrument should attempt to attain for the brightest pixel in the image to be acquired.",
			ResolutionDescription->"Automatically set to 33000 if ExposureTime is set to Automatic.",
			Category->"Image Acquisition"
		},

		(* ----------------- *)
		(* Timelapse options *)
		(* ----------------- *)
		{
			OptionName->TimelapseImageCollection,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				"At specific timepoints"->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[All,StartOnly,StartAndEnd]
				],
				"At every Nth timepoint"->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				]
			],
			Description->"Specifies the timepoint(s) at which the sample is imaged when acquiring timelapse images. All allows acquisition of an image at every timepoint defined in ExperimentImageCells option. StartOnly acquires an image at the first timepoint only. StartAndEnd acquires an image at the first and the last timepoints. When specified as an integer, an image will be acquired at every Nth timepoints, beginning with the first timepoint.",
			ResolutionDescription->"Automatically set to All if Timelapse option of ExperimentImageCells is set to True.",
			Category->"Time Lapse Imaging"
		},

		(* --------------- *)
		(* Z-Stack Options *)
		(* --------------- *)
		{
			OptionName->ZStackImageCollection,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if a series of images at multiple z-axis positions will be acquired for the sample.",
			ResolutionDescription->"Automatically set to True if ZStack option of ExperimentImageCells is set to True.",
			Category->"Z-Stack Imaging"
		},

		(* --------------------- *)
		(* Fluorescence Settings *)
		(* --------------------- *)
		{
			OptionName->ImagingChannel,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>MicroscopeImagingChannelP
			],
			Description->"Indicates the imaging channel pre-defined by the instrument that should be used to acquire images from the sample.",
			ResolutionDescription->"If none of the options in Fluorescence Imaging or BrightField and PhaseContrast Imaging is specified, automatically set to the instrument's imaging channel with ExcitationWavelength and EmissionWavelength capable if illuminating and detecting signal from DetectionLabels.",
			Category->"General"
		},
		{
			OptionName->ExcitationWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Nanometer],
				Units->Nanometer
			],
			Description->"The wavelength of excitation light used to illuminate the sample when imaging with ConfocalFluorescence or Epifluorescence Mode.",
			ResolutionDescription->"Automatically set to the wavelength capable of exciting the DetectionLabels.",
			Category->"Fluorescence Imaging"
		},
		{
			OptionName->EmissionWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Nanometer],
				Units->Nanometer
			],
			Description->"The wavelength at which the fluorescence emission of the DetectionLabels should be imaged.",
			ResolutionDescription->"Automatically set to the wavelength closest to the fluorescence emission wavelength of the DetectionLabels.",
			Category->"Fluorescence Imaging"
		},
		{
			OptionName->ExcitationPower,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent,100 Percent],
				Units->Percent
			],
			Description->"The percent of maximum intensity of the light source that should be used to illuminate the sample. Higher intensity will excite more fluorescent molecules in the sample, resulting in more signal being produced, but will also increase the chance of bleaching the fluorescent molecules.",
			ResolutionDescription->"Automatically set to 20% if a high content imager is selected as instrument. Otherwise, set to 100% if Mode is ConfocalFluorescence or Epifluorescence",
			Category->"Fluorescence Imaging"
		},
		{
			OptionName->DichroicFilterWavelength,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterP[0 Nanometer],
				Units->Nanometer
			],
			Description->"Specifies the wavelength that should be passed by the filter to illuminate the sample and excite the DetectionLabels.",
			ResolutionDescription->"Automatically set to wavelength closest to the fluorescence excitation wavelength of the DetectionLabels.",
			Category->"Fluorescence Imaging"
		},
		{
			OptionName->ImageCorrection,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>MicroscopeImageCorrectionP
			],
			Description->"The correction step(s) that will be automatically applied to the image. BackgroundCorrection removes stray light that is unrelated to light that reaches the sample. ShadingCorrection mitigates the uneven illumination of the sample that is visible around the edges of the image.",
			ResolutionDescription->"Automatically apply both BackgroundCorrection AND ShadingCorrection to the image if the high content imager is selected as Instrument and Mode is either ConfocalFluorescence or Epifluorescence. Otherwise, set to ShadingCorrection when Mode is BrightField.",
			Category->"Fluorescence Imaging"
		},
		{
			OptionName->ImageDeconvolution,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if a deconvolution algorithm should be used to enhance contrast, improve image resolution, and sharpen the image.",
			Category->"Fluorescence Imaging"
		},
		{
			OptionName->ImageDeconvolutionKFactor,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[0,2]
			],
			Description->"Specifies the factor used by the Wiener Filter in the deconvolution algorithm to determine image sharpness. Lower values increase sharpness and higher values reduce noise.",
			ResolutionDescription->"Automatically set to 1 if ImageDeconvolution is True.",
			Category->"Fluorescence Imaging"
		},

		(* -------------------------------------- *)
		(* Brightfield and PhaseContrast Settings *)
		(* -------------------------------------- *)
		{
			(* leave this out in the primitive *)
			OptionName->TransmittedLightPower,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Percent,100 Percent],
				Units->Percent
			],
			Description->"The percent of maximum intensity of the transmitted light that should be used to illuminate the sample. This option will set the percent maximum of the voltage applied to the light source, with higher percentages indicating higher intensities.",
			ResolutionDescription->"If Mode is BrightField or PhaseConstrast, automatically set to 20% for a high content inager, or 100% for "<>ToString[$ImageCellsInvertedMicroscopes]<>".",
			Category->"BrightField and PhaseContrast Imaging"
		},
		{
			(* leave this out in the primitive *)
			OptionName->TransmittedLightColorCorrection,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if a neutral color balance filter will be placed into the transmitted light path to correct the color temperature during BrightField and PhaseContrast imaging.",
			ResolutionDescription->"Automatically set to True if"<>ToString[$ImageCellsInvertedMicroscopes]<>"is selected as Instrument.",
			Category->"BrightField and PhaseContrast Imaging"
		}
	}
];


(* ::Subsubsection:: *)
(* AcquireImage Primitive Definition *)

(* NOTE: This primitive will not be hooked up to the primitive framework and is for internal use in ImageCells only. *)
(* Therefore, we set ExperimentFunction->None since the framework doesn't need to resolve it for us. *)
imageCellsAcquireImagePrimitive=DefinePrimitive[AcquireImage,
	SharedOptions:>{acquireImagePrimitiveOptions},
	ExperimentFunction->None,
	Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","AcquireImage.png"}]],
	Generative->False,
	Category->"Microscopy",
	Description->"A set of parameters for acquiring an image from a sample.",
	Author -> "melanie.reschke"
];


(* ::Subsubsection:: *)
(* Imaging Primitive Pattern *)


Clear[AcquireImagePrimitiveP];
DefinePrimitiveSet[
	AcquireImagePrimitiveP,
	{imageCellsAcquireImagePrimitive}
];


(* ::Subsubsection:: *)
(*ExperimentImageCells Options and Messages*)


DefineOptionSet[
	ImageCellsSharedOptions:>{
		{
			OptionName->Instrument,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,Microscope],Object[Instrument,Microscope]}]
			],
			Description->"The microscope or high content imager that is used to image the sample.",
			ResolutionDescription->"Automatically set to the high content imager instrument model if PhaseContrast is not included as Mode in AcquireImage primitives specified in the Images option.",
			Category->"General"
		},

		(* ---------------------- *)
		(* Environmental Controls *)
		(* ---------------------- *)
		{
			OptionName->Temperature,
			Default->Ambient,
			AllowNull->False,
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Ambient]
				],
				Widget[
					Type->Quantity,
					Pattern:>RangeP[25 Celsius,40 Celsius],
					Units->Alternatives[Celsius,Fahrenheit,Kelvin]
				]
			],
			Description->"The temperature of the stage where the sample container is placed during imaging.",
			Category->"Environmental Controls"
		},
		{
			OptionName->CarbonDioxide,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the sample will be incubated with CO2 during imaging.",
			Category->"Environmental Controls"
		},
		{
			OptionName->CarbonDioxidePercentage,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>GreaterEqualP[0 Percent],
				Units->Percent
			],
			Description->"Indicates percentage of CO2 in the gas mixture that will be provided to the sample during imaging.",
			ResolutionDescription->"Automatically set to 5% if CarbonDioxide is True.",
			Category->"Environmental Controls"
		},

		(* ----------------------------- *)
		(* Options index-matched to pool *)
		(* ----------------------------- *)
		IndexMatching[
			(* Note: make these options index-matched to input samples so that we can use the container overload *)
			IndexMatchingInput->"experiment samples",
			{
				OptionName->EquilibrationTime,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Hour,1 Hour],
					Units->Alternatives[Second,Minute,Hour,Day]
				],
				Description->"For each sample pool, specifies the amount of time for which the samples are placed on the stage of the microscope before the first image is acquired.",
				ResolutionDescription->"Automatically set to 5 minutes for sample's that contains Model[Cell] with CellType -> Suspension.",
				Category->"Image Acquisition"
			},

			(* -------------------- *)
			(* container properties *)
			(* -------------------- *)
			{
				OptionName->PlateBottomThickness,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Millimeter,5 Millimeter],
					Units->Millimeter
				],
				Description->"For each sample pool, the thickness of the well bottom of the sample's container, which is used to determine the position of the CorrectionCollar on high magnification objective lenses to correct for optical aberrations.",
				ResolutionDescription->"Automatically set to the well bottom thickness specified in the container model of the sample.",
				Category->"Image Acquisition"
			},

			(* ------------- *)
			(* Acquire Image *)
			(* ------------- *)
			{
				OptionName->ObjectiveMagnification,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				],
				Description->"For each sample pool, the magnification power defined by the ratio between the dimensions of the image and the sample. Low magnification power (4X and 10X) is recommended for acquiring an overview image of a sample. High magnification power (20X, 40X, 60X) is recommended for imaging detailed structure of a large tissue sample or intracellular structures.",
				ResolutionDescription->"Automatically set to 10 if available on the selected instrument. Otherwise, set to the lowest magnification supported by the selected instrument.",
				Category->"Optics"
			},
			{
				OptionName->PixelBinning,
				Default->1,
				AllowNull->False,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				],
				Description->"For each sample pool, the \"n x n\" grid of pixels whose intensity values should be combined into a single pixel. Higher binning values result in higher overall signal-to-noise ratios but lower pixel resolutions.",
				Category->"Image Acquisition"
			},
			{
				OptionName->Images,
				Default->Automatic,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Primitive,
						Pattern:>AcquireImagePrimitiveP
					],
					Adder[
						Widget[
							Type->Primitive,
							Pattern:>AcquireImagePrimitiveP
						]
					]
				],
				Description->"For each sample pool, a list of acquisition parameters used to image a sample. Each list of acquisition parameters corresponds to a single output image acquired from the input sample.",
				ResolutionDescription->"Automatically generates a unique image acquisition for each of the fluorophores present in the DetectionLabels Field of the sample's identity model. The value of acquisition parameters are determined from the Mode and the DetectionLabels of the sample's identity model.",
				Category->"Image Acquisition"
			},

			(* ------------------------- *)
			(* adjustment sample options *)
			(* ------------------------- *)
			{
				OptionName->AdjustmentSample,
				Default->All,
				AllowNull->False,
				Widget->Alternatives[
					"Use Selected Sample"->Widget[
						Type->Object,
						Pattern:>ObjectP[Object[Sample]]
					],
					"Use Each Sample"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				],
				Description->"For each sample pool, specifies the sample that will be used to adjust the ExposureTime and FocalHeight in each imaging session. In each sample pool, only one sample is allowed to be used as AdjustmentSample. If set to All, the ExposureTime and FocalHeight will be adjusted for each sample individually.",
				Category->"Image Acquisition"
			},

			(* ---------------- *)
			(* Sampling Options *)
			(* ---------------- *)
			{
				OptionName->SamplingPattern,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>MicroscopeSamplingMethodP
				],
				Description->"For each sample pool, the pattern of images that will be acquired from the samples. SinglePoint: acquires an image at the center of each well or sample. Grid: acquires multiple images along specified rows and columns. Coordinates: acquires image(s) at requested coordinates in each well or on a microscopic slide. Adaptive: uses an algorithm to calculate the number of cells in each field of view to increase the chances of acquiring valid data, until the indicated number of cells specified in AdaptiveNumberOfCells is obtained.",
				ResolutionDescription->"Automatically set to the default sampling method of the selected instrument.",
				Category->"Sampling"
			},
			(* Grid *)
			(* TODO: create a diagram to for grid sampling options and put in helpfile *)
			{
				(* TODO: explain here how the instrument determines number of images to fit in a well based on image size/field of view *)
				OptionName->SamplingNumberOfRows,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,35]
				],
				Description->"For each sample pool, the number of rows which will be acquired for each sample if the Grid SamplingPattern is selected. If Adaptive SamplingPattern is selected, SamplingNumberOfRows specifies maximum number of rows to be imaged if AdaptiveNumberOfCells cannot be reached.",
				ResolutionDescription->"Automatically set to maximum number of rows that can fit within the sample's container if Grid or Adaptive is selected as SamplingPattern.",
				Category->"Sampling Regions"
			},
			{
				(* TODO: explain here how the instrument determines number of images to fit in a well based on image size/field of view *)
				OptionName->SamplingNumberOfColumns,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[1,45]
				],
				Description->"For each sample pool, the number of columns which will be acquired for each sample if the Grid SamplingPattern is selected. If Adaptive SamplingPattern is selected, SamplingNumberOfColumns specifies maximum number of columns to be imaged if AdaptiveNumberOfCells cannot be reached.",
				ResolutionDescription->"Automatically set to maximum number of columns that can fit within the sample's container if Grid or Adaptive is selected as SamplingPattern.",
				Category->"Sampling Regions"
			},
			{
				OptionName->SamplingRowSpacing,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Spacing Distance"->Widget[
						Type->Quantity,
						Pattern:>RangeP[-85 Millimeter,85 Millimeter],(* range is based on Plate footprint *)
						Units->Alternatives[Micrometer,Millimeter,Centimeter]
					],
					"Percent Overlap"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Percent,100 Percent],
						Units->Percent
					]
				],
				Description->"For each sample pool, the distance between each row of images to be acquired. Negative distances indicate overlapping regions between adjacent rows. Overlapping regions between rows can also be specified as percentage if desired.",
				ResolutionDescription->"Automatically set to 0 Micrometer if Grid or Adaptive is selected as SamplingPattern.",
				Category->"Sampling Regions"
			},
			{
				OptionName->SamplingColumnSpacing,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Spacing Distance"->Widget[
						Type->Quantity,
						Pattern:>RangeP[-127 Millimeter,127 Millimeter],(* range is based on Plate footprint *)
						Units->Alternatives[Micrometer,Millimeter,Centimeter]
					],
					"Percent Overlap"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Percent,100 Percent],
						Units->Percent
					]
				],
				Description->"For each sample pool, the distance between each column of images to be acquired. Negative values indicate overlapping regions between adjacent columns. Overlapping regions between columns can also be specified as percentage if desired.",
				ResolutionDescription->"Automatically set to 0 Micrometer if Grid or Adaptive is selected as SamplingPattern.",
				Category->"Sampling Regions"
			},
			{
				OptionName->SamplingCoordinates,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					{
						"X Coordinate"->Widget[
							Type->Quantity,
							Pattern:>RangeP[-127 Millimeter,127 Millimeter],
							Units->Alternatives[Micrometer,Millimeter,Centimeter]
						],
						"Y Coordinate"->Widget[
							Type->Quantity,
							Pattern:>RangeP[-85 Millimeter,85 Millimeter],
							Units->Alternatives[Micrometer,Millimeter,Centimeter]
						]
					}
				],
				Description->"For each sample pool, specifies the positions at which images are acquired. The coordinates are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
				ResolutionDescription->"If the SamplingPattern is set to Coordinates, SamplingCoordinates will be set to randomly acquire images from 3 different sites in each well or on a microscopic slide.",
				Category->"Sampling Regions"
			},

			(* ------------------------- *)
			(* adaptive sampling options *)
			(* ------------------------- *)
			{
				OptionName->AdaptiveExcitationWaveLength,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[TransmittedLight]
					],
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Nanometer],
						Units->Nanometer
					]
				],
				Description->"For each sample pool, specifies the excitation wavelength of the light source that will be used to determine the number of cells in each field of view for the Adaptive SamplingPattern.",
				ResolutionDescription->"Automatically set to the ExcitationWavelength indicated in the first AcquireImage primitive if Adaptive is selected as SamplingPattern.",
				Category->"Adaptive Sampling"
			},
			{
				OptionName->AdaptiveNumberOfCells,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				],
				Description->"For each sample pool, specifies the minimum cell count per well that the instrument will work to satisfy by acquiring images from multiple regions before moving to the next sample.",
				ResolutionDescription->"Automatically set to 50 if Adaptive is selected as SamplingPattern.",
				Category->"Adaptive Sampling"
			},
			{
				OptionName->AdaptiveMinNumberOfImages,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[1] (* TODO: check max number of images *)
				],
				Description->"For each sample pool, the minimum number of regions that must be acquired when using the Adaptive SamplingPattern, even if the specified cell count (AdaptiveNumberOfCells) is already reached.",
				ResolutionDescription->"Automatically set to 1 imaging site if Adaptive is selected as SamplingPattern.",
				Category->"Adaptive Sampling"
			},
			{
				OptionName->AdaptiveCellWidth,
				Default->Automatic,
				AllowNull->True,
				Widget->Span[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Micrometer,100 Micrometer],
						Units->Micrometer
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Micrometer,100 Micrometer],
						Units->Micrometer
					]
				],
				Description->"For each sample pool, specifies the expected range of cell size in the sample. The instrument uses this range to determine which features in the image will be counted as cells.",
				(* TODO: can use the Diameter of the sample's identity Model[Cell] if any (+- 2 um?) *)
				ResolutionDescription->"Automatically set to 5-10 um if Adaptive is selected as SamplingPattern.",
				Category->"Adaptive Sampling"
			},
			{
				OptionName->AdaptiveIntensityThreshold,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,65535]
				],
				Description->"For each sample pool, the intensity above local background value that a putative cell needs to have in order to be counted. The intensity above local background value is calculated by subtracting the gray value of the surrounding background from the gray level value of a putative cell. Any feature in an image is considered to be a putative cell if its size falls within the specified cell width (AdaptiveCellWidth).",
				ResolutionDescription->"Automatically set to 100 if Adaptive is selected as SamplingPattern.",
				Category->"Adaptive Sampling"
			},

			(* --------------------- *)
			(* Timelapse acquisition *)
			(* --------------------- *)

			(* TODO: need an upperbound for time *)
			{
				OptionName->Timelapse,
				Default->False,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"For each sample pool, indicates if the sample will be imaged at multiple time points.",
				Category->"Time Lapse Imaging"
			},
			{
				(* TODO: check time resolution of the high content imager *)
				OptionName->TimelapseInterval,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Hour],
					Units->Alternatives[Second,Minute,Hour,Day]
				],
				Description->"For each sample pool, the amount of time between the start of an acquisition at one time point and the start of an acquisition at the next time point.",
				ResolutionDescription->"Automatically set to 1 Hour if Timelapse is True.",
				Category->"Time Lapse Imaging"
			},
			{
				(* TODO: double check how long we want to set if Automatic and no other options are specified *)
				OptionName->TimelapseDuration,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Hour],
					Units->Alternatives[Second,Minute,Hour,Day]
				],
				Description->"For each sample pool, the total amount of time that the Timelapse images will be acquired for the sample.",
				ResolutionDescription->"Automatically set to 8 Hour if Timelapse is True.",
				Category->"Time Lapse Imaging"
			},
			{
				OptionName->NumberOfTimepoints,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[1]
				],
				Description->"For each sample pool, the number of images that will be acquired from the sample in during the course of Timelapse imaging.",
				ResolutionDescription->"Automatically set to the maximum number of images that can be acquired in the course of TimelapseDuration with the amount of time between each image specified by TimelapseInterval.",
				Category->"Time Lapse Imaging"
			},
			(* TODO: add TimelapseMode option: continuous/discontinuous. add in description that discontinuous will take the sample out in between the timepoints. can resolve this option based on the interval and warn the user if it is set to continuous. *)
			(* and also warn that time point might not be exact because of the processing time *)
			{
				OptionName->ContinuousTimelapseImaging,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"For each sample pool, indicates if images from multiple time points should be acquired from the samples in a single imaging session.",
				ResolutionDescription->"Automatically set to True if Timelapse is True and TimelapseInterval is less than 1 Hour.",
				Category->"Time Lapse Imaging"
			},
			{
				OptionName->TimelapseAcquisitionOrder,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>ImageCellsTimelapseAcquitionOrderP
				],
				Description->"For each sample pool, determines the order in which the time-series images are acquired with respect to the sample's location in the plate. Parallel acquires images from every selected well in the plate at each time point before moving on to the next time point. Serial acquires images for all time points in one well before moving on to the next well. RowByRow acquires images at each time point in each row of wells before moving on to the next row. ColumnByColumn acquires images at each time point in each column of wells before moving on to the next column.",
				ResolutionDescription->"Automatically set to Parallel if Timelapse is True.",
				Category->"Time Lapse Imaging"
			},

			(* --------------- *)
			(* Z-Stack Options *)
			(* --------------- *)
			{
				OptionName->ZStack,
				Default->False,
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"For each sample pool, indicates if a series of images at multiple z-axis positions will be acquired for the sample.",
				Category->"Z-Stack Imaging"
			},
			{
				(* TODO: explain how an optimal step size is calculated according to the nyquist theorem in the help file and add reference literature *)
				OptionName->ZStepSize,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Micrometer],
					Units->Micrometer
				],
				Description->"For each sample pool, the distance between each image plane in the Z-Stack.",
				ResolutionDescription->"Automatically set to the Nyquist sampling distance of the objective by calculating from the following equation: ExcitationWavelength/2n(1-cos(\[Alpha])). ExcitationWavelength is set to default value of 550 nm. \[Alpha] = arcsin(NA/n) where n is refractive index of the objective's immersion medium. NA is numerical aperture of the objective.",
				Category->"Z-Stack Imaging"
			},
			{
				(* there's no need to supply this if ZStack span and step sizes are supplied *)
				OptionName->NumberOfZSteps,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterP[0]
				],
				Description->"For each sample pool, the total number of image planes that will be acquired in the Z-stack.",
				ResolutionDescription->"Automatically set to 10 if ZStack is True and no other Z-stack options are selected, or calculated from the ZStackSpan and ZStepSize options if specified.",
				Category->"Z-Stack Imaging"
			},
			{
				OptionName->ZStackSpan,
				Default->Automatic,
				AllowNull->True,
				Widget->Span[
					Widget[
						Type->Quantity,
						Pattern:>RangeP[-10000 Micrometer,0 Micrometer],
						Units->Micrometer
					],
					Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Micrometer,10000 Micrometer],
						Units->Micrometer
					]
				],
				Description->"For each sample pool, the range of Z-heights that the microscope will acquire images from in a Z-Stack. Negative values indicate planes that are below the sample's focal plane (as defined in FocalHeight) whereas positive values indicate planes that are above the sample's focal plane.",
				ResolutionDescription->"If ZStack is True, automatically calculated from the NumberOfZsteps and ZStepSize.",
				Category->"Z-Stack Imaging"
			},

			(* hidden options to propagate imaging site coordinates to resource packets *)
			{
				OptionName->AllImagingSiteCoordinates,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					{
						"X Coordinate"->Widget[
							Type->Number,
							Pattern:>RangeP[-127000,127000]
						],
						"Y Coordinate"->Widget[
							Type->Number,
							Pattern:>RangeP[-85000,85000]
						]
					}
				],
				Description->"For each sample pool, specifies all imaging positions in each well determined from SamplingNumberOfColumns and SamplingNumberOfRows. The coordinates are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0 Micrometer,0 Micrometer).",
				ResolutionDescription->"If the SamplingPattern is set to Grid or Adaptive, AllImagingSiteCoordinates will be determined from SamplingNumberOfColumns and SamplingNumberOfRows.",
				Category->"Hidden"
			},
			{
				OptionName->UsableImagingSiteCoordinates,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[
					{
						"X Coordinate"->Widget[
							Type->Number,
							Pattern:>RangeP[-127000,127000]
						],
						"Y Coordinate"->Widget[
							Type->Number,
							Pattern:>RangeP[-85000,85000]
						]
					}
				],
				Description->"For each sample pool, specifies all imaging positions in each well that can be imaged. The coordinates are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0 Micrometer,0 Micrometer).",
				ResolutionDescription->"If the SamplingPattern is set to Grid or Adaptive, UsableImagingSiteCoordinates will be determined from SamplingNumberOfColumns and SamplingNumberOfRows.",
				Category->"Hidden"
			}
		],

		(* shared option *)
		SamplesInStorageOptions
	}
];


DefineOptions[ExperimentImageCells,
	Options:>{
		(* only manual ImageCells options are listed outside of ImageCellsSharedOptions here *)
		(* instrument-related options *)
		{
			OptionName->MicroscopeOrientation,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>MicroscopeViewOrientationP
			],
			Description->"The location of the objective lens relative to the sample on the microscope stage. Inverted refers to having the objective lens below the sample. Only Inverted microscopes are currently available at ECL. This option can only be set if Preparation -> Manual.",
			ResolutionDescription->"Automatically set to Orientation of Instrument. Otherwise, set to Inverted if Preparation -> Robotic.",
			Category->"General"
		},
		{
			OptionName->ReCalibrateMicroscope,
			Default->False,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			],
			Description->"Indicates if the optical components of the microscope should be adjusted before imaging the sample. This option can only be set to True if Preparation -> Manual.",
			Category->"General"
		},
		(* TODO: ReCalibrateMicroscope \[Rule] True, will generate a maintenance protocol to calibrate in the procedure. If false, will use the most recent calibration object *)
		{
			OptionName->MicroscopeCalibration,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[Object[Maintenance,CalibrateMicroscope]]
			],
			Description->"A calibration object that specifies a set of parameters used to adjust optical components of the microscope. This option can only be set if Preparation -> Manual.",
			ResolutionDescription->"If CalibrateMicroscope is True, automatically set to the most recent Object[Maintenance,CalibrateMicroscope] performed on the selected instrument.",
			Category->"General"
		},

		(* index-matching options that only apply to manual ImageCells *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->ContainerOrientation,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>MicroscopeContainerOrientationP
				],
				Description->"For each sample pool, the orientation of the sample container when placed on the microscope stage for imaging. RightSideUp refers to placing the sample container on the stage such that the cover is on the top (plates: lids on top, microscope slides: coverslip facing up). UpsideDown refers to inverting the sample container on the stage such that the cover faces down (plates: lids facing down, microscope slides: coverslip facing down).",
				ResolutionDescription->"Automatically set RightSideUp if Preparation -> Robotic. Otherwise set to RightSideUp if sample's container is a plate or UpsideDown if sample's container is a slide.",
				Category->"Image Acquisition"
			},
			{
				OptionName->CoverslipThickness,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Millimeter,2 Millimeter],
					Units->Millimeter
				],
				Description->"For each sample pool, the thickness of the coverslip, which is used to determine the position of the CorrectionCollar on high magnification objective lenses to correct for optical aberrations. This option can only be set if Preparation -> Manual.",
				ResolutionDescription->"Automatically set to the thickness of the coverslip specified in the container model of the sample.",
				Category->"Image Acquisition"
			},
			(* label options for manual primitives *)
			{
				OptionName->SampleLabel,
				Default->Automatic,
				AllowNull->False,
				NestedIndexMatching->True,
				Widget->Widget[Type->String,Pattern:>_String,Size->Line],
				Description->"A user defined word or phrase used to identify the samples that will be imaged, for use in downstream unit operations.",
				Category->"General",
				UnitOperation->True
			},
			{
				OptionName->SampleContainerLabel,
				Default->Automatic,
				AllowNull->False,
				NestedIndexMatching->True,
				Widget->Widget[Type->String,Pattern:>_String,Size->Line],
				Description->"A user defined word or phrase used to identify the containers of the samples that will be imaged, for use in downstream unit operations.",
				Category->"General",
				UnitOperation->True
			}
		],

		(* options shared between manual and robotic ImageCells *)
		ImageCellsSharedOptions,
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True,
					ResolutionDescription -> "Automatically set to 200 Microliter."
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True,
					ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Plate, \"24-well Tissue Culture Plate\"]."
				}
			}
		],
		(* don't actually want this exposed to the customer, but do need it under the hood for ModelInputOptions to work *)
		ModifyOptions[
			PreparatoryUnitOperationsOption,
			Category -> "Hidden"
		],
		(* shared options *)
		PreparationOption,
		WorkCellOption,
		BiologyFuntopiaSharedOptionsPooled,
		SimulationOption,
		SubprotocolDescriptionOption
	}
];


(* ::Subsubsection:: *)
(*ExperimentImageCells Errors and Warnings*)

Error::ImageCellsInstrumentModelNotFound="`1`. Please specify Instrument directly or modify the input/option values.";
Error::ImageCellsCultureHandlingMismatch="The CultureHandling, `1`, of Instrument `2` does not match the culture handling of the input samples, `3`. Please choose a new instrument or leave the Instrument option to be set automatically.";
Error::ImageCellsContainerlessSamples="The following samples cannot be imaged because they are not in a container: `1`. Please make sure their containers are accurately uploaded.";
Error::MicroscopeOrientationMismatch="The Orientation, `1`, of Instrument `2` and specified MicroscopeOrientation, `3`, are not compatible. Please choose a new instrument or leave the MicroscopeOrientation option to be set automatically.";
Error::InvalidMicroscopeStatus="The specified Instrument `1` is retired or deprecated. Please choose a new instrument with a valid status.";
Error::MicroscopeCalibrationNotAllowed="The following Instrument does not allow calibration by running a maintenance: `1`. Please choose a new instrument with MicroscopeCalibration -> True. Otherwise, leave the Instrument option to be set automatically.";
Error::MicroscopeCalibrationMismatch="The following ReCalibrateMicroscope and MicroscopeCalibration options are conflicting: `1`. MicroscopeCalibration can only be specified when ReCalibrateMicroscope is True and Instrument allows calibration to be performed. Please correct these options or leave MicroscopeCalibration to be set automatically.";
Error::MicroscopeCalibrationNotFound="A maintenance object for calibrating the following instrument cannot be found: `1`. Please directly specify MicroscopeCalibration option with an Object[Maintenance,CalibrationMicroscope] if calibration is desired. Otherwise, leave the ReCalibrateMicroscope to be set automatically.";
Error::InvalidMicroscopeCalibration="The specified MicroscopeCalibration option `1` cannot be used to perform calibration because its Target is conflicting with the following instrument: `2`. Please specify a new Object[Maintenance,CalibrationMicroscope] that has the correct Target or leave MicroscopeCalibration to be set automatically.";
Error::InvalidMicroscopeTemperature="The specified Temperature option `1` is not supported by the following instrument: `2`. Please choose a new instrument or correct the Temperature option to be within the range supported by the instrument.";
Error::CO2IncompatibleMicroscope="The following instrument does not support carbon dioxide incubation: `1`. Please choose a new instrument with CarbonDioxideControl -> True.";
Error::CarbonDioxideOptionsMismatch="The following CarbonDioxide and CarbonDioxidePercentage options are conflicting: `1`. CarbonDioxidePercentage can only be specified when CarbonDioxide is True. Please correct these options or leave CarbonDioxidePercentage to be set automatically.";
Error::ImageCellsMismatchedContainers="The following samples in pool number `1` are not in the same container model: `2`. Samples to be imaged in the same pool must have the same container model. Please correct the input samples or separate the samples in question into multiple sample pools.";
Error::ImageCellsIncompatibleContainer="The following samples in pool number `1` are not in valid containers: `2`. Samples must be in a plate that can fit into 'Sample Slot' of the instrument or in a container with MicroscopeSlide footprint. Please correct the input samples in question.";
Error::ImageCellsInvalidWellBottom="The following samples in pool number `1` are not in containers with clear bottom and therefore cannot be imaged: `2`. Please correct the input samples in question or use sample preparation options to aliquot samples into a valid container.";
Error::ImageCellsInvalidContainerOrientation="The following samples in pool number `1` cannot be imaged with the specified ContainerOrientation: `2`. Samples in plates can only be imaged with RightSideUp while samples on microscope slide or hemocytometer can be imaged with either RightSideUp or UpsideDown. Please correct the option value or leave the ContainerOrientation option to be set automatically.";
Warning::MismatchedCoverslipThickness="The following specified CoverslipThickness options for samples in pool number `1` do not match the value in their container models: `2`. No action is needed if this is intentional.";
Error::ImageCellsInvalidCoverslipThickness="The specified CoverslipThickness options for pool number `1` must be Null because the following samples' containers are not microscope slides: `2`. Please correct the option value or leave CoverslipThickness option to be set automatically.";
Error::ImageCellsNegativePlateBottomThickness="For the following samples in pool number `1`, the calculated sample's plate bottom thickness is a negative value: `2`. Please check Dimensions, WellDepth, and DepthMargin of the container model for the samples in question. Plate bottom thickness is calulated by subtracting DepthMargin and WellDepth from the plate height.";
Warning::MismatchedPlateBottomThickness="The following specified PlateBottomThickness options for samples in pool number `1` do not match the value calculated from Dimensions, WellDepth, and DepthMargin of the container model: `2`. No action is needed if this is intentional.";
Error::ImageCellsInvalidPlateBottomThickness="The specified PlateBottomThickness options for pool number `1` must be Null because the following samples' containers are plates: `2`. Please correct the option value or leave PlateBottomThickness option to be set automatically.";
Error::ImageCellsInvalidObjectiveMagnification="The specified ObjectiveMagnification options for pool number `1` is not supported by the instrument: `2`. The instrument `3` supports the following objective magnifications: `4`. Please correct the option value or leave ObjectiveMagnification option to be set automatically.";
Error::ImageCellsInvalidPixelBinning="The specified PixelBinning options for pool number `1` is not supported by the instrument: `2`. The instrument `3` supports the following PixelBinning: `4`. Please correct the option value or leave PixelBinning option to be set automatically.";
Error::ImageCellsTimelapseIntervalNotAllowed="The TimelapseInterval options for pool number `1` must be Null when Timelapse option is False. Please correct the option value or leave TimelapseInterval option to be set automatically.";
Error::ImageCellsTimelapseDurationNotAllowed="The TimelapseDuration options for pool number `1` must be Null when Timelapse option is False. Please correct the option value or leave TimelapseDuration option to be set automatically.";
Error::ImageCellsNumberOfTimepointsNotAllowed="The NumberOfTimepoints options for pool number `1` must be Null when Timelapse option is False. Please correct the option value or leave NumberOfTimepoints option to be set automatically.";
Error::ImageCellsContinuousTimelapseImagingNotAllowed="The ContinuousTimelapseImaging options for pool number `1` cannot be set to True when Timelapse option is False. Please correct the option value or leave ContinuousTimelapseImaging option to be set automatically.";
Error::ImageCellsUnsupportedTimelapseImaging="Timelapse option for pool number `1` cannot be set to True because the following instrument does not support timelapse imaging: `2`. Please select a different instrument if timelapse imaging is desired. Otherwise, leave Timelapse option to be set automatically.";
Error::ImageCellsInvalidTimelapseDefinition="When Timelapse is set to True for pool number `1`, at least one of the following options must be left to be set automatically: `2`.";
Error::ImageCellsInvalidContinuousTimelapseImaging="ContinuousTimelapseImaging cannot be set to True for pool number `1` because TimelapseInterval is greater than 1 Hour. Please reduce TimelapseInterval if continuous imaging is desired or leave ContinuousTimelapseImaging option to be set automatically.";
Error::ImageCellsUnsupportedZStackImaging="ZStack option for pool number `1` cannot be set to True because the following instrument does not support z-stack imaging: `2`. Please select a different instrument if z-stack imaging is desired. Otherwise, leave ZStack option to be set automatically.";
Error::ImageCellsInvalidZStackDefinition="When ZStack is set to True for pool number `1`, at least one of the following options must be left to be set automatically: `2`.";
Error::ImageCellsZStepSizeNotAllowed="The ZStepSize options for pool number `1` must be Null when ZStack option is False. Please correct the option value or leave ZStepSize option to be set automatically.";
Error::ImageCellsNumberOfZStepsNotAllowed="The NumberOfZSteps options for pool number `1` must be Null when ZStack option is False. Please correct the option value or leave NumberOfZSteps option to be set automatically.";
Error::ImageCellsZStackSpanNotAllowed="The ZStackSpan options for pool number `1` must be Null when ZStack option is False. Please correct the option value or leave ZStackSpan option to be set automatically.";
Error::ImageCellsInvalidZStackSpan="The following ZStackSpan options for pool number `1` exceeds the maximum allowed distance on the z-axis: `2`. Please specify ZStackSpan withing the following ranges or leave the ZStackSpan option to be set automatically: `3`.";
Error::ImageCellsInvalidZStepSizeNumberOfZSteps="The product of the {ZStepSize,NumberOfZSteps} options `1` for pool number `2` exceeds the following maximum allowed distance on the z-axis: `3`. Please correct the invalid option values or leave the ZStepSize and NumberOfZSteps options to be set automatically.";
Error::ImageCellsInvalidZStepSize="For sample pool number `1`, the ZStepSize option `2` is larger than the following distance on the z-axis defined by the ZStackSpan option: `3`. Please correct the option value or leave the ZStepSize option to be set automatically.";
Error::ImageCellsInvalidAcquireImagePrimitive="The following AcquireImage primitives specified as Images option for sample pool number `1` are not valid: `2`. Please revise the options for AcquireImage primitive.";
Error::ImageCellsInvalidAdjustmentSample="The following AdjustmentSample option is not a part of the sample pool: `1`. Please specify the AdjustmentSample option as a sample object that is included the sameple pool for following pools: `2`.";
Error::ImageCellsUnsupportedSamplingPattern="The specified SamplingPattern option for pool number `1` is not supported by the instrument: `2`. The instrument `3` supports the following sampling patterns: `4`. Please correct the option value or leave SamplingPattern option to be set automatically.";
Error::ImageCellsSamplingCoordinatesNotAllowed="The SamplingCoordinates options for pool number `1` must be Null when SamplingPattern is set to Grid or Adaptive. Please correct the option value or leave SamplingCoordinates option to be set automatically.";
Error::ImageCellsSamplingRowSpacingMismatch="The SamplingRowSpacing options for pool number `1` must be Null when SamplingNumberOfRows is set to 1. Please correct the option value or leave SamplingRowSpacing option to be set automatically.";
Error::ImageCellsSamplingRowSpacingNotSpecified="The SamplingRowSpacing options for pool number `1` cannot be Null when SamplingNumberOfRows is higher than 1. Please correct the option value or leave SamplingRowSpacing option to be set automatically.";
Error::ImageCellsSamplingColumnSpacingMismatch="The SamplingColumnSpacing options for pool number `1` must be Null when SamplingNumberOfColumns is set to 1. Please correct the option value or leave SamplingColumnSpacing option to be set automatically.";
Error::ImageCellsSamplingColumnSpacingNotSpecified="The SamplingColumnSpacing options for pool number `1` cannot be Null when SamplingNumberOfColumns is higher than 1. Please correct the option value or leave SamplingColumnSpacing option to be set automatically.";
Error::ImageCellsGridDefinedAsSinglePoint="Both SamplingNumberOfColumns and SamplingNumberOfRows options for pool number `1` cannot be set to 1. When SamplingPattern is Grid or Adaptive, either SamplingNumberOfColumns and SamplingNumberOfRows option must be at least 2. Please correct the option value accordingly.";
Error::ImageCellsCannotDetermineImagingSites="When SamplingPattern is set to Grid or Adaptive for pool number `1`, all of the following options cannot be Null: `2`. Please correct the option values accordingly.";
Error::ImageCellsInvalidGridDefinition="The containers of the following samples from pool number `1` cannot accommodate all imaging sites calculated from the options `2`: `3`. Please decrease SamplingNumberOfColumns, SamplingNumberOfRows, SamplingColumnSpacing, or SamplingRowSpacing to ensure that all the imaging sites fit inside the sample's container.";
Error::ImageCellsInvalidAdaptiveExcitationWaveLength="The following AdaptiveExcitationWaveLength option for pool number `1` cannot be Null and must match the ExcitationWavelength specified in Images option: `2`. For pool number `1`, the following excitation wavelengths can be used: `3`.";
Warning::FirstWavelengthNotUsedForAdaptive="The following AdaptiveExcitationWaveLength option for pool number `1` does not match the first ExcitationWavelength which will be used to acquire images in each sample pool: `2`. For pool number `1`, choosing the following excitation wavelengths will provide the best results for adaptive sampling: `3`. ";
Error::ImageCellsAdaptiveNumberOfCellsNotSpecified="The AdaptiveNumberOfCells options for pool number `1` cannot be Null when SamplingPattern is Adaptive. Please correct the option value or leave AdaptiveNumberOfCells option to be set automatically.";
Error::ImageCellsAdaptiveMinNumberOfImagesNotSpecified="The AdaptiveMinNumberOfImages options for pool number `1` cannot be Null when SamplingPattern is Adaptive. Please correct the option value or leave AdaptiveMinNumberOfImages option to be set automatically.";
Error::ImageCellsTooManyAdaptiveImagingSites="The following specified AdaptiveMinNumberOfImages option for pool number `1` exceed the number of sites that can be imaged per sample: `2`. For pool number `1`, please specify AdaptiveMinNumberOfImages option equal to or less than the following values: `3`. Otherwise, leave the AdaptiveMinNumberOfImages option to be set automatically.";
Error::ImageCellsAdaptiveCellWidthNotSpecified="The AdaptiveCellWidth options for pool number `1` cannot be Null when SamplingPattern is Adaptive. Please correct the option value or leave AdaptiveCellWidth option to be set automatically.";
Error::ImageCellsAdaptiveIntensityThresholdNotSpecified="The AdaptiveIntensityThreshold options for pool number `1` cannot be Null when SamplingPattern is Adaptive. Please correct the option value or leave AdaptiveIntensityThreshold option to be set automatically.";
Error::ImageCellsInvalidAdaptiveIntensityThreshold="The following specified AdaptiveIntensityThreshold options for pool number `1` exceed the maximum gray level that the selected instrument supports: `2`. Please specify values equal to or less than `3`. Otherwise, leave the AdaptiveIntensityThreshold option to be set automatically.";
Error::ImageCellsAdaptiveExcitationWaveLengthNotAllowed="The AdaptiveExcitationWaveLength options for pool number `1` must be Null when SamplingPattern is not Adaptive. Please correct the option value or leave AdaptiveExcitationWaveLength option to be set automatically.";
Error::ImageCellsAdaptiveNumberOfCellsNotAllowed="The AdaptiveNumberOfCells options for pool number `1` must be Null when SamplingPattern is not Adaptive. Please correct the option value or leave AdaptiveNumberOfCells option to be set automatically.";
Error::ImageCellsAdaptiveMinNumberOfImagesNotAllowed="The AdaptiveMinNumberOfImages options for pool number `1` must be Null when SamplingPattern is not Adaptive. Please correct the option value or leave AdaptiveMinNumberOfImages option to be set automatically.";
Error::ImageCellsAdaptiveCellWidthNotAllowed="The AdaptiveCellWidth options for pool number `1` must be Null when SamplingPattern is not Adaptive. Please correct the option value or leave AdaptiveCellWidth option to be set automatically.";
Error::ImageCellsAdaptiveIntensityThresholdNotAllowed="The AdaptiveIntensityThreshold options for pool number `1` must be Null when SamplingPattern is not Adaptive. Please correct the option value or leave AdaptiveIntensityThreshold option to be set automatically.";
Error::ImageCellsSamplingNumberOfRowsNotAllowed="The SamplingNumberOfRows options for pool number `1` must be Null when SamplingPattern is not Grid or Adaptive. Please correct the option value or leave SamplingNumberOfRows option to be set automatically.";
Error::ImageCellsSamplingNumberOfColumnsNotAllowed="The SamplingNumberOfColumns options for pool number `1` must be Null when SamplingPattern is not Grid or Adaptive. Please correct the option value or leave SamplingNumberOfColumns option to be set automatically.";
Error::ImageCellsSamplingRowSpacingNotAllowed="The SamplingRowSpacing options for pool number `1` must be Null when SamplingPattern is not Grid or Adaptive. Please correct the option value or leave SamplingRowSpacing option to be set automatically.";
Error::ImageCellsSamplingColumnSpacingNotAllowed="The SamplingColumnSpacing options for pool number `1` must be Null when SamplingPattern is not Grid or Adaptive. Please correct the option value or leave SamplingColumnSpacing option to be set automatically.";
Error::ImageCellsInvalidSamplingCoordinates="The following specified SamplingCoordinates options for pool number `1` are invalid: `2`. If SamplingPattern is SinglePoint, SamplingCoordinates can only be set to {0 \[Mu]m, 0 \[Mu]m}. If SamplingPattern is Coordinates, SamplingCoordinates must be within each sample's well or position. Please correct the option values or leave the SamplingCoordinates option to be set automatically.";
Error::ImageCellsSamplingCoordinatesNotSpecified="The SamplingCoordinates options for pool number `1` cannot be Null when SamplingPattern is Coordinates or SinglePoint. Please correct the option value or leave SamplingCoordinates option to be set automatically.";
Error::ImageCellsMultipleContainersForAdjustmentSample="The AdjustmentSample option cannot be specified as a sample object for the sample pools `1` because they contain more than one sample containers: `2`. If the use of AdjustmentSample is desired, please separate the sample pools in question into individual pools with each pool containing only one sample container.";
Error::ImageCellsIncompatibleContainerThickness="The sample containers `1` from pool `2` have thickness `3` that are larger than the working distance `4` of the objectives with magnification `5`. Please specify samples in compatible containers or specify different ObjectiveMagnification option.";
Error::ImageCellsTimelapseAcquisitionOrderNotAllowed="TimelapseAcquisitionOrder TimelapseDuration options for pool number `1` must be Null when Timelapse option is False. Please correct the option value or leave TimelapseDuration option to be set automatically.";


(* ::Subsubsection:: *)
(*ExperimentImageCells*)


(*---Function overload accepting semi-pooled sample/container objects as inputs. Note: {s1,{s2,s3}}->{{s1},{s2,s3}}---*)
ExperimentImageCells[mySemiPooledInputs:ListableP[ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String]],myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples,listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,listedInputs,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySemiPooledInputs],ToList[myOptions]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentImageCells,
			listedSamples,
			listedOptions,
			DefaultPreparedModelAmount -> 200 Microliter,
			DefaultPreparedModelContainer -> Model[Container, Plate, "id:E8zoYveRlldX"](* 24-well clear bottom *)
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Wrap a list around any single sample inputs to convert flat input into a nested list *)
	listedInputs=Map[
		If[Not[MatchQ[#,ObjectP[Object[Container,Plate]]]],
			ToList[#],
			#
		]&,
		mySamplesWithPreparedSamples
	];

	(* for each group, mapping containerToSampleOptions over each group to get the samples out *)
	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests}=pooledContainerToSampleOptions[
			ExperimentImageCells,
			listedInputs,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=pooledContainerToSampleOptions[
				ExperimentImageCells,
				listedInputs,
				myOptionsWithPreparedSamples,
				Output->Result,
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(*If we were given an empty container, return early*)
	If[ContainsAny[ToList[containerToSampleResult],{$Failed}],
		(*containerToSampleOptions failed - return $Failed*)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Simulation[]
		},

		(*Split up our containerToSample result into samples and sampleOptions*)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		experimentImageCellsCore[samples,ReplaceRule[sampleOptions,Simulation->updatedSimulation]]
	]
];


(* This is the core function taking only clean pooled lists of samples in the form -> {{s1},{s2},{s3,s4},{s5,s6,s7}} *)
experimentImageCellsCore[myPooledSamples:ListableP[{ObjectP[{Object[Sample],Model[Sample]}]..}],myOptions:OptionsPattern[ExperimentImageCells]]:=Module[
	{
		listedSamples,listedOptions,outputSpecification,output,gatherTests,updatedSimulation,safeOptionsNamed,safeOps,validLengths,
		returnEarlyQ,performSimulationQ,templatedOptions,inheritedOptions,expandedSafeOps,cacheBall,samplesContainers,
		containerlessSamples,resolvedOptionsResult,simulatedProtocol,simulation,resolvedOptions,collapsedResolvedOptions,
		result,resourceResult,upload,confirm,canaryBranch,fastTrack,parentProtocol,cache,resolvedPreparation,runTime,optionsToReturn,
		validSamplePreparationResult,samplesWithPreparedSamplesNamed,optionsWithPreparedSamplesNamed,samplesWithPreparedSamples,
		optionsWithPreparedSamples,

		(* download variables *)
		flatListedSamples,specifiedInstrument,instrumentsToDownload,allSlideAdapterModels,detectionLabelsFromPrimitives,
		sampleFields,modelSampleFields,objectContainerFields,modelContainerFields,objectInstrumentFields,modelInstrumentFields,
		detectionLabelFields,identityCellModelFields,objectMaintenanceFields,modelMaintenanceFields,modelObjectiveFields,
		objectsToDownload,packetsToDownload,allPackets,allinstrumentFields,

		(* test variables *)
		safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest,containerlessSampleTests,resolvedOptionsTests,
		resourcePacketTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links. *)
	{listedSamples,listedOptions}=removeLinks[ToList[myPooledSamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed,optionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentImageCells,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentImageCells,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentImageCells,listedOptions,AutoCorrect->False],{}}
	];

	(* Replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples,safeOps,optionsWithPreparedSamples}=sanitizeInputs[samplesWithPreparedSamplesNamed,safeOptionsNamed,optionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentImageCells,{listedSamples},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentImageCells,{listedSamples},listedOptions],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentImageCells,{ToList[samplesWithPreparedSamples]},optionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentImageCells,{ToList[samplesWithPreparedSamples]},optionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(*get assorted hidden options*)
	{upload,confirm,canaryBranch,fastTrack,parentProtocol,cache,updatedSimulation}=Lookup[inheritedOptions,{Upload,Confirm,CanaryBranch,FastTrack,ParentProtocol,Cache,Simulation}];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentImageCells,{listedSamples},inheritedOptions]];

	(* -------------- *)
	(* ---DOWNLOAD--- *)
	(* -------------- *)

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* ---GATHER ALL OBJECTS TO DOWNLOAD--- *)

	(* flatten list of input samples *)
	flatListedSamples=Flatten[listedSamples];

	(* get the specified Instrument option *)
	specifiedInstrument=Lookup[expandedSafeOps,Instrument];

	(* get the instrument to download information from *)
	(* microscopeDevices ALWAYS returns user specified Instrument option and will return {} only when no instrument can be found based on the supplied experiment options *)
	instrumentsToDownload=microscopeDevices[
		specifiedInstrument,
		expandedSafeOps,
		Lookup[expandedSafeOps,Preparation],
		Lookup[expandedSafeOps,WorkCell]
	];

	(* get all possible slide adapter models that we may need *)
	allSlideAdapterModels=Search[Model[Container,Rack],Footprint==Plate&&Field[Positions[[Footprint]]]==MicroscopeSlide&&Deprecated==(False|Null)];

	(* throw an error if Instrument was not specified and no default model was found based on the supplied options *)
	If[MatchQ[instrumentsToDownload,{}]&&!gatherTests,
		Module[{errorString},
			errorString = "No microscope instrument was found based on the specified options";
			Message[Error::ImageCellsInstrumentModelNotFound,errorString]
		]
	];

	(* generate test for default instrument model *)
	instrumentNotFoundTest=If[gatherTests,
		Test["If Instrument is not specified, at least one instrument model that meets all the specified criteria must exist:",
			MatchQ[instrumentsToDownload,{}],
			False
		],
		{}
	];

	(* return early if Instrument was not specified and no default model was found *)
	If[MatchQ[instrumentsToDownload,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest}],
			Options->$Failed,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(*Pull out the options that may have models/objects whose information we need to download*)
	detectionLabelsFromPrimitives=Cases[Lookup[expandedSafeOps,Images],ObjectP[],Infinity];

	(* combine all objects to download *)
	objectsToDownload=Flatten[{
		flatListedSamples,
		instrumentsToDownload,
		allSlideAdapterModels,
		detectionLabelsFromPrimitives,
		Model[Instrument,LiquidHandler,"id:o1k9jAKOwLV8"],(* bioSTAR *)
		Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], (* Model[Instrument, LiquidHandler, "microbioSTAR"] *)
		Model[Instrument, Microscope, "id:XnlV5jN97nnM"] (* Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 40X, 60X Confocal, Microbial"] *)
	}];

	(* ---GATHER ALL FIELDS TO DOWNLOAD--- *)

	(* define Fields to download for each object type *)
	sampleFields=SamplePreparationCacheFields[Object[Sample],Format->Sequence];
	modelSampleFields=Sequence[SamplePreparationCacheFields[Model[Sample],Format->Sequence],AluminumFoil,Parafilm];
	objectContainerFields=Sequence[SamplePreparationCacheFields[Object[Container],Format->Sequence],AluminumFoil,Parafilm];
	modelContainerFields=Sequence[SamplePreparationCacheFields[Model[Container],Format->Sequence],RecommendedFillVolume,
		AllowedPositions,Columns,CrossSectionalShape,FlangeHeight,HorizontalMargin,HorizontalPitch,Rows,VerticalMargin,
		VerticalPitch,DepthMargin,GridDimensions,PlateFootprintAdapters,MetaXpressPrefix,Coverslipped,CoverslipThickness,PositionPlotting];
	objectInstrumentFields=Sequence[Name,Status,Model];
	modelInstrumentFields=Sequence[Name,Objects,Deprecated,Positions,ActiveHumidityControl,Autofocus,CameraModel,
		CarbonDioxideControl,CondenserMaxHeight,CondenserMinHeight,CustomizableImagingChannel,DefaultExcitationPowers,
		DefaultImageCorrections,DefaultSamplingMethod,DefaultTransmittedLightPower,DichroicFilters,DichroicFilterWavelengths,
		EmissionFilters,EyePieceMagnification,FluorescenceEmissionWavelengths,FluorescenceExcitationWavelengths,FluorescenceFilters,
		HighContentImaging,HumidityControl,IlluminationColorCorrectionFilter,IlluminationFilters,IlluminationTypes,ImageCorrectionMethods,
		ImageDeconvolution,ImagingChannels,LampTypes,MaxTemperatureControl,MinTemperatureControl,Modes,ObjectiveMagnifications,
		Objectives,OpticModules,Orientation,PixelBinning,SamplingMethods,TemperatureControlledEnvironment,TimelapseImaging,
		ZStackImaging,MicroscopeCalibration,MaintenanceFrequency,MaxImagingChannels,TransmittedLightColorCorrection,
		MinExposureTime,MaxExposureTime,DefaultTargetMaxIntensity,MaxGrayLevel,ImageSizeX,ImageSizeY,ImageScalesX,ImageScalesY,
		MaxFocalHeight,CultureHandling
	];
	detectionLabelFields=Sequence[Name,DetectionLabel,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums];
	identityCellModelFields=Sequence[Name,DefaultSampleModel,DetectionLabels,Diameter,PreferredMaxCellCount,
		CellType,Tissues];
	objectMaintenanceFields=Sequence[Name,Model,Target,Status,DateCompleted,CondenserHeight,CondenserXPosition,CondenserYPosition,
		PhaseRingXPosition,PhaseRingYPosition,ApertureDiaphragm,FieldDiaphragm];
	modelMaintenanceFields=Sequence[Name,Targets,Objects];
	modelObjectiveFields=Sequence[Name,Magnification,ImmersionMedium,NumericalAperture,MaxWorkingDistance];
	allinstrumentFields=DeleteDuplicates[Join[{modelInstrumentFields},{Modes,Name,WettedMaterials,Positions,MaxRotationRate,MinRotationRate,
		MinTemperature,MaxTemperature,CompatibleAdapters,Objects,
		InternalDimensions,AsepticHandling,MaxTime,SpeedResolution,CentrifugeType,
		RequestedResources,AluminumFoil,Parafilm,MaxForce,MinForce,IntegratedLiquidHandlers,
		ProgrammableTemperatureControl,ProgrammableMixControl,
		MaxOscillationAngle,MinOscillationAngle,GripperDiameter,MaxTemperatureRamp,MinTemperatureRamp}]];

	(* assemble packet to download according to the object type *)
	packetsToDownload=Map[
		Switch[#,
			Object[Sample],
			{
				Packet[sampleFields],
				Packet[Model[{modelSampleFields}]],
				Packet[Container[{objectContainerFields}]],
				Packet[Container[Model][{modelContainerFields}]],
				Packet[Field[Composition[[All,2]]][DetectionLabels][{detectionLabelFields}]],
				Packet[Field[Model[Composition][[All,2]]][{identityCellModelFields}]],
				Packet[Field[Model[Composition][[All,2]]][DetectionLabels][{detectionLabelFields}]]
			},
			Model[Molecule],
			{
				Packet[detectionLabelFields]
			},
			Object[Instrument],
			{
				Packet[objectInstrumentFields],
				Packet[Model[{modelInstrumentFields}]],
				Packet[Field[Model[MaintenanceFrequency][[All,1]]][{modelMaintenanceFields}]],
				Packet[Field[Model[MaintenanceFrequency][[All,1]][Objects]][{objectMaintenanceFields}]],
				Packet[Model[Objectives][{modelObjectiveFields}]]
			},
			Model[Instrument,LiquidHandler],
			{
				Packet[IntegratedInstruments[allinstrumentFields]]
			},
			Model[Instrument],
			{
				Packet[modelInstrumentFields],
				Packet[Field[MaintenanceFrequency[[All,1]]][{modelMaintenanceFields}]],
				Packet[Field[MaintenanceFrequency[[All,1]][Objects]][{objectMaintenanceFields}]],
				Packet[Objectives[{modelObjectiveFields}]]
			},
			Model[Container,Rack],
			{
				Packet[Dimensions,Positions,AvailableLayouts,TareWeight,Name,Footprint]
			},
			_,{}
		]&,
		Download[objectsToDownload,Type]
	];

	(* ---MAKE THE BIG DOWNLOAD CALL--- *)
	allPackets=Flatten[Quiet[
		Download[
			objectsToDownload,
			Evaluate[packetsToDownload],
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::Part}
	]];

	(* Combine our downloaded packets *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[allPackets];

	(* ---CONTAINER-LESS SAMPLE CHECK--- *)

	(* check for container-less samples before we go into resolver *)
	samplesContainers=Lookup[fetchPacketFromCache[#,cacheBall]&/@flatListedSamples,Container];

	(* check if there's any Null container *)
	containerlessSamples=PickList[flatListedSamples,samplesContainers,Null];

	(* if there are containerless samples and we are throwing messages, throw an error message *)
	If[Not[MatchQ[containerlessSamples,{}]]&&!gatherTests,
		Message[Error::ImageCellsContainerlessSamples,ObjectToString[containerlessSamples,Cache->cacheBall]];
		Message[Error::InvalidInput,ObjectToString[containerlessSamples,Cache->cacheBall]]
	];

	(* if we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerlessSampleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[containerlessSamples]==0,
				Nothing,
				Test["The provided source samples "<>ObjectToString[containerlessSamples,Cache->cacheBall]<>" are in a container:",True,False]
			];

			passingTest=If[Length[containerlessSamples]==Length[flatListedSamples],
				Nothing,
				Test["The provided source samples "<>ObjectToString[Complement[flatListedSamples,containerlessSamples],Cache->cacheBall]<>" are in a container:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* return early if there's a container-less sample *)
	If[!MatchQ[containerlessSamples,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest,containerlessSampleTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* ---RESOLVE OPTIONS--- *)

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentImageCellsOptions[samplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentImageCellsOptions[samplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentImageCells,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation=Lookup[collapsedResolvedOptions,Preparation];

	(* finalize options to return by removing sample prep options if Preparation -> Robotic since we don't allow them *)
	(* note: need to do this because primitive framework will expand our options to pooled pattern that do not match field.. *)
	(* ..patterns of shared sample prep fields in Object[UnitOperation] *)
	optionsToReturn=If[MatchQ[resolvedPreparation,Robotic],
		Last@splitPrepOptions[RemoveHiddenOptions[ExperimentImageCells,collapsedResolvedOptions]],
		RemoveHiddenOptions[ExperimentImageCells,collapsedResolvedOptions]
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest,resolvedOptionsTests,containerlessSampleTests}],
			Options->optionsToReturn,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ=Which[
		MatchQ[resolvedOptionsResult,$Failed],True,
		gatherTests,Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,Verbose->False,OutputFormat->SingleBoolean]],
		True,False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ=MatchQ[resolvedPreparation,Robotic]||MemberQ[output,Simulation]||MatchQ[$CurrentSimulation,SimulationP];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ&&!performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest,containerlessSampleTests,resolvedOptionsTests}],
			Options->optionsToReturn,
			Preview->Null,
			Simulation->Simulation[],
			RunTime->0 Minute
		}]
	];

	(* Build packets with resources *)
	(* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
	{resourceResult,resourcePacketTests}=Which[
		MatchQ[resolvedOptionsResult,$Failed],
			{$Failed,{}},
		TrueQ[gatherTests],
			experimentImageCellsResourcePackets[
				listedSamples,
				templatedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->{Result,Tests}
			],
		True,
			{
				experimentImageCellsResourcePackets[
					listedSamples,
					templatedOptions,
					resolvedOptions,
					Cache->cacheBall,
					Simulation->updatedSimulation
				],
				{}
			}
	];

	(* extract RunTime from resource result *)
	runTime=Which[
		(* if Preparation -> Manual, pull it out from the protocol packet *)
		MatchQ[resolvedPreparation,Manual],Lookup[resourceResult[[1]],RunTime],

		(* if Preparation -> Robotic, pull it out from the unit operation packet *)
		MatchQ[resolvedPreparation,Robotic],Total[ToList[Lookup[resourceResult[[2]],RunTime]]],

		(* return 0 min for all other cases *)
		True,0 Minute
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol,simulation}=If[performSimulationQ,
		simulateExperimentImageCells[
			If[MatchQ[resourceResult,$Failed],
				$Failed,
				resourceResult[[1]] (* protocolPacket *)
			],
			If[MatchQ[resourceResult,$Failed],
				$Failed,
				ToList[resourceResult[[2]]] (* unitOperationPackets *)
			],
			listedSamples,
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			ParentProtocol->Lookup[safeOps,ParentProtocol]
		],
		{Null,updatedSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest,containerlessSampleTests,resolvedOptionsTests,resourcePacketTests}],
			Options->optionsToReturn,
			Preview->Null,
			Simulation->simulation,
			RunTime->runTime
		}]
	];

	(* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure -> True or return a real protocol that's ready to be run. *)
	result=Which[
		(* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
		MatchQ[resourceResult,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
			$Failed,

		(* If we're in global script simulation mode and Preparation -> Manual, we want to upload our simulation to the global simulation. *)
		MatchQ[$CurrentSimulation,SimulationP]&&MatchQ[resolvedPreparation,Manual],
			Module[{},
				UpdateSimulation[$CurrentSimulation,simulation],

				If[MatchQ[Lookup[safeOps,Upload],False],
					Lookup[simulation[[1]],Packets],
					simulatedProtocol
				]
			],

		(* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
		(* Upload->False. *)
		MatchQ[resolvedPreparation,Robotic]&&MatchQ[Lookup[safeOps,Upload],False],
			resourceResult[[2]],(* unitOperationPackets *)

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
		MatchQ[resolvedPreparation,Robotic],
			Module[{primitive},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive=ImageCells@@Flatten[{
					Sample->myPooledSamples,
					RemoveHiddenPrimitiveOptions[ImageCells,ToList[myOptions]]
				}];

				(* Memoize the value of ExperimentImageCells so the framework doesn't spend time resolving it again. *)
				Block[{ExperimentImageCells},
					ExperimentImageCells[___,options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification=Lookup[ToList[options],Output];

						frameworkOutputSpecification/.{
							Result->resourceResult[[2]],
							Options->optionsToReturn,
							Preview->Null,
							Simulation->simulation,
							RunTime->runTime
						}
					];

					ExperimentRoboticCellPreparation[
						{primitive},
						Name->Lookup[safeOps,Name],
						Upload->Lookup[safeOps,Upload],
						Confirm->Lookup[safeOps,Confirm],
						CanaryBranch->Lookup[safeOps,CanaryBranch],
						ParentProtocol->Lookup[safeOps,ParentProtocol],
						Priority->Lookup[safeOps,Priority],
						StartDate->Lookup[safeOps,StartDate],
						HoldOrder->Lookup[safeOps,HoldOrder],
						QueuePosition->Lookup[safeOps,QueuePosition],
						Cache->cacheBall
					]
				]
			],

		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
			UploadProtocol[
				resourceResult[[1]],(* protocolPacket *)
				resourceResult[[2]],(* unitOperationPackets *)
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				Simulation->simulation
			]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->result,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,instrumentNotFoundTest,containerlessSampleTests,resolvedOptionsTests,resourcePacketTests}],
		Options->optionsToReturn,
		Preview->Null,
		Simulation->simulation,
		RunTime->runTime
	}
];


(* ::Subsubsection:: *)
(*resolveExperimentImageCellsOptions*)


DefineOptions[
	resolveExperimentImageCellsOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];


resolveExperimentImageCellsOptions[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentImageCellsOptions]]:=Module[
	{
		(* template variables *)
		outputSpecification,output,gatherTests,messages,notInEngine,cache,simulation,samplePrepOptions,imageCellsOptions,
		simulatedSamples,resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,imageCellsOptionsAssociation,
		invalidInputs,invalidOptions,targetContainers,resolveSamplePrepOptionsWithoutAliquot,resolvedAliquotOptions,
		aliquotTests,resolvedPostProcessingOptions,allTests,mapThreadFriendlyOptions,emailOption,parentProtocolOption,
		imageSampleOption,resolvedOptions,rawAliquotOption,preparationResult,allowedPreparation,objectToNewResolvedLabelLookup,
		samplePrepOptionsWithMasterSwitches,

		(* download variables *)
		flatSimulatedSamples,detectionLabelsFromPrimitives,specifiedInstrument,instrumentsToDownload,allSlideAdapterModels,
		instrumentObjectsToDownload,instrumentModelsToDownload,sampleFields,modelSampleFields,objectContainerFields,
		modelContainerFields,objectInstrumentFields,modelInstrumentFields,detectionLabelFields,identityCellModelFields,
		objectMaintenanceFields,modelMaintenanceFields,modelObjectiveFields,instrumentObjectDownloadPackets,
		instrumentModelDownloadPackets,instrumentObjectPackets,instrumentModelPackets,slideAdapterModelPackets,
		flatSimulatedSamplePackets,flatSampleModelPackets,flatSampleContainerPackets,flatSampleContainerModelPackets,
		flatSampleCompositionTypes,flatSampleDetectionLabelPackets,flatSampleIdentityModelPackets,flatSampleIdentityModelDetectionLabelPackets,
		primitiveDetectionLabelPackets,poolingLengths,pooledSimulatedSamplePackets,pooledSampleContainerPackets,
		pooledSampleContainerModelPackets,pooledSampleDetectionLabelPackets,pooledSampleIdentityModelPackets,
		pooledSampleIdentityModelDetectionLabelPackets,cleanedPrimitiveDetectionLabelPackets,cleanedInstrumentPackets,
		newCache,resolvedInstrumentModelPacket,resolvedInstrumentObjectPacket,objectiveModelPackets,resolvedObjectiveModelPackets,
		instrumentNotFoundTestOptions,instrumentNotFoundTest,resolvedInstrumentCultureHandling,instrumentCultureHandlingMismatchQ,
		cultureHandlingInvalidOptions,instrumentCultureHandlingMismatchTest,potentialWorkCells,resolvedWorkCell,

		(* input validation check variables *)
		optionsForRounding,valuesToRoundTo,avoidZeroBools,roundedImageCellsOptions,pooledSimulatedSamples,

		(* conflicting option variables *)
		validNameQ,resolvedInstrumentModel,resolvedInstrumentObject,instrumentOrientation,
		instrumentOrientationMismatchQ,validInstrumentStatusQ,calibrationOption,calibrationMismatchQ,
		instrumentAllowsCalibrationQ,calibrationNotAllowedError,calibrationMaintObjectExistQ,validCalibrationTargetQ,
		validTemperatureQ,validCarbonDioxideQ,specifiedCO2PercentOption,carbonDioxideMismatch,

		(* mapthread variables *)
		mismatchedContainersErrors,incompatibleContainerErrors,opaqueWellBottomErrors,
		invalidContainerOrientationErrors,coverslipThicknessMismatchWarnings,invalidCoverslipThicknessErrors,
		negativePlateBottomThicknessErrors,plateBottomThicknessMismatchWarnings,invalidPlateBottomThicknessErrors,
		unsupportedObjectiveMagnificationErrors,unsupportedPixelbinningErrors,notAllowedTimelapseIntervalErrors,
		notAllowedTimelapseDurationErrors,notAllowedNumberOfTimepointsErrors,notAllowedContinuousTimelapseImagingErrors,
		notAllowedTimelapseAcquisitionOrderErrors,unsupportedTimelapseImagingErrors,invalidTimelapseDefinitionErrors,
		invalidContinuousTimelapseImagingErrors,unsupportedZStackImagingErrors,invalidZStackDefinitionErrors,notAllowedZStepSizeErrors,
		notAllowedNumberOfZStepsErrors,notAllowedZStackSpanErrors,acquirePrimitiveResolverErrors,invalidAdjustmentSampleErrors,
		unsupportedSamplingPatternErrors,notAllowedSamplingCoordinatesErrors,rowSpacingNotAllowedErrors,samplingRowSpacingNotSpecifiedErrors,
		columnSpacingNotAllowedErrors,samplingColumnSpacingNotSpecifiedErrors,gridDefinedAsSinglePointErrors,
		cannotDetermineImagingSitesErrors,invalidGridDefinitionErrors,invalidAdaptiveExcitationWaveLengthErrors,
		adaptiveWavelengthOrderWarnings,unspecifiedAdaptiveNumberOfCellsErrors,unspecifiedAdaptiveMinNumberOfImagesErrors,
		tooManyAdaptiveImagingSitesErrors,unspecifiedAdaptiveCellWidthErrors,unspecifiedAdaptiveIntensityThresholdErrors,
		invalidAdaptiveIntensityThresholdErrors,notAllowedAdaptiveExcitationWaveLengthErrors,notAllowedAdaptiveNumberOfCellsErrors,
		notAllowedAdaptiveMinNumberOfImagesErrors,notAllowedAdaptiveCellWidthErrors,notAllowedAdaptiveIntensityThresholdErrors,
		notAllowedSamplingNumberOfRowsErrors,notAllowedSamplingNumberOfColumnsErrors,notAllowedSamplingRowSpacingErrors,
		notAllowedSamplingColumnSpacingErrors,invalidSamplingCoordinatesErrors,unspecifiedSamplingCoordinatesErrors,
		invalidZStackSpanErrors,invalidZStepSizeNumberOfZStepsErrors,invalidZStepSizeErrors,multipleContainersAdjustmentSampleErrors,
		incompatibleContainerThicknessErrors,

		(* resolved/defaulted options variables *)
		sampleCellTypes,requiredInstrumentCultureHandling,resolvedInstrument,noValidInstrumentError,nameOption,microscopeOrientationOption,resolvedMicroscopeOrientation,recalibrateBool,
		resolvedMicroscopeCalibrationOption,temperatureOption,carbonDioxideBool,resolvedCO2PercentOption,
		resolvedContainerOrientations,resolvedCoverslipThicknesses,resolvedPlateBottomThicknesses,resolvedObjectiveMagnifications,
		resolvedEquilibrationTimes,resolvedPixelBinnings,resolvedTimelapses,resolvedTimelapseIntervals,resolvedTimelapseDurations,
		resolvedNumberOfTimepoints,resolvedContinuousTimelapseImagings,resolvedTimelapseAcquisitionOrders,resolvedZStepSizes,
		resolvedNumberOfZSteps,resolvedZStackSpans,resolvedImagesOptions,resolvedAdjustmentSamples,resolvedSamplingPatterns,
		resolvedSamplingNumberOfRows,resolvedSamplingNumberOfColumns,resolvedSamplingRowSpacings,resolvedSamplingColumnSpacings,
		resolvedSamplingCoordinates,resolvedAdaptiveExcitationWaveLengths,resolvedAdaptiveNumberOfCells,resolvedAdaptiveMinNumberOfImages,
		resolvedAdaptiveCellWidths,resolvedAdaptiveIntensityThresholds,resolvedEmail,resolvedImageSample,resolvedPreparation,
		resolvedSampleLabels,resolvedSampleContainerLabels,

		(* invalid input variables *)
		discardedInvalidInputs,pooledSamplesWithIncompatibleContainers,pooledSamplesWithInvalidWellBottom,
		mismatchedContainersInvalidInputs,incompatibleContainerInvalidInputs,opaqueWellBottomInvalidInputs,
		negativePlateBottomThicknessInvalidInputs,objectivesToUse,maxAllowedZDistances,pooledTotalImagingSites,
		invalidSamplingCoordinates,incompatibleContainerThicknessInputs,

		(* coordinates variables *)
		allCoordinatesInWells,usableCoordinatesInWells,

		(* invalid option variables *)
		nameInvalidOptions,orientationInvalidOptions,invalidInstrumentStatusOption,calibrationNotAllowedOptions,
		mismatchedCalibrationOptions,microscopeCalibrationNotFoundOptions,invalidCalibrationTargetOptions,
		invalidTemperatureOptions,invalidCarbonDioxideOptions,carbonDioxideMismatchOptions,invalidContainerOrientationOptions,
		invalidCoverslipThicknessOptions,invalidPlateBottomThicknessOptions,invalidObjectiveMagnificationOptions,
		invalidPixelBinningOptions,timelapseIntervalNotAllowedOptions,numberOfTimepointsNotAllowedOptions,
		timelapseDurationNotAllowedOptions,continuousTimelapseImagingNotAllowedOptions,timelapseAcquisitionOrderNotAllowedOptions,
		unsupportedTimelapseOptions,invalidTimelapseDefinitionOptions,invalidContinuousTimelapseImagingOptions,
		unsupportedZStackOptions,invalidZStackDefinitionOptions,zStepSizeNotAllowedOptions,numberOfZStepsNotAllowedOptions,
		zStackSpanNotAllowedOptions,invalidZStackSpanOptions,invalidZStepSizeNumberOfZStepsOptions,invalidZStepSizeOptions,
		invalidImagesOptions,invalidAdjustmentSampleOptions,unsupportedSamplingPatternOptions,samplingCoordinatesNotAllowedOptions,
		samplingRowSpacingMismatchOptions,samplingRowSpacingNotSpecifiedOptions,samplingColumnSpacingMismatchOptions,
		samplingColumnSpacingNotSpecifiedOptions,gridDefinedAsSinglePointOptions,cannotDetermineImagingSitesOptions,
		invalidGridDefinitionOptions,invalidAdaptiveExcitationWaveLengthOptions,adaptiveNumberOfCellsNotSpecifiedOptions,
		adaptiveMinNumberOfImagesNotSpecifiedOptions,tooManyAdaptiveImagingSitesOptions,adaptiveCellWidthNotSpecifiedOptions,
		adaptiveIntensityThresholdNotSpecifiedOptions,invalidAdaptiveIntensityThresholdOptions,adaptiveExcitationWaveLengthNotAllowedOptions,
		adaptiveNumberOfCellsNotAllowedOptions,adaptiveMinNumberOfImagesNotAllowedOptions,adaptiveCellWidthNotAllowedOptions,
		adaptiveIntensityThresholdNotAllowedOptions,samplingNumberOfRowsNotAllowedOptions,samplingNumberOfColumnsNotAllowedOptions,
		samplingRowSpacingNotAllowedOptions,samplingColumnSpacingNotAllowedOptions,invalidSamplingCoordinatesOptions,
		samplingCoordinatesNotSpecifiedOptions,multipleContainersForAdjustmentSampleOptions,incompatibleContainerThicknessOptions,

		(* test variables *)
		discardedTest,precisionTests,validNameTest,instrumentOrientationMismatchTest,
		invalidInstrumentStatusTest,calibrationNotAllowedTest,mismatchedCalibrationOptionsTest,microscopeCalibrationNotFoundTest,
		invalidCalibrationTargetTest,invalidTemperatureTest,invalidCarbonDioxideTest,carbonDioxideMismatchTest,
		mismatchedContainersTest,incompatibleContainerTest,opaqueWellBottomTest,invalidContainerOrientationTest,
		mismatchedCoverslipThicknessTest,invalidCoverslipThicknessTest,negativePlateBottomThicknessTest,
		mismatchedPlateBottomThicknessTest,invalidPlateBottomThicknessTest,invalidObjectiveMagnificationTest,
		invalidPixelBinningTest,timelapseIntervalNotAllowedTest,numberOfTimepointsNotAllowedTest,timelapseDurationNotAllowedTest,
		continuousTimelapseImagingNotAllowedTest,timelapseAcquisitionOrderNotAllowedTest,unsupportedTimelapseTest,
		invalidTimelapseDefinitionTest,invalidContinuousTimelapseImagingTest,unsupportedZStackTest,
		invalidZStackDefinitionTest,zStepSizeNotAllowedTest,numberOfZStepsNotAllowedTest,zStackSpanNotAllowedTest,
		invalidZStackSpanTest,invalidZStepSizeNumberOfZStepsTest,invalidZStepSizeTest,invalidImagesTest,invalidAdjustmentSampleTest,
		unsupportedSamplingPatternTest,samplingCoordinatesNotAllowedTest,samplingRowSpacingMismatchTest,samplingRowSpacingNotSpecifiedTest,
		samplingColumnSpacingMismatchTest,samplingColumnSpacingNotSpecifiedTest,gridDefinedAsSinglePointTest,
		cannotDetermineImagingSitesTest,invalidGridDefinitionTest,invalidAdaptiveExcitationWaveLengthTest,adaptiveWavelengthOrderTest,
		adaptiveNumberOfCellsNotSpecifiedTest,adaptiveMinNumberOfImagesNotSpecifiedTest,tooManyAdaptiveImagingSitesTest,
		adaptiveCellWidthNotSpecifiedTest,adaptiveIntensityThresholdNotSpecifiedTest,invalidAdaptiveIntensityThresholdTest,
		adaptiveExcitationWaveLengthNotAllowedTest,adaptiveNumberOfCellsNotAllowedTest,adaptiveMinNumberOfImagesNotAllowedTest,
		adaptiveCellWidthNotAllowedTest,adaptiveIntensityThresholdNotAllowedTest,samplingNumberOfRowsNotAllowedTest,
		samplingNumberOfColumnsNotAllowedTest,samplingRowSpacingNotAllowedTest,samplingColumnSpacingNotAllowedTest,
		invalidSamplingCoordinatesTest,samplingCoordinatesNotSpecifiedTest,preparationTest,
		multipleContainersForAdjustmentSampleTest,incompatibleContainerThicknessTest
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine=!MatchQ[$ECLApplication,Engine];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our ImageCells options from our Sample Prep options. *)
	{samplePrepOptions,imageCellsOptions}=splitPrepOptions[myOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	imageCellsOptionsAssociation=Association[imageCellsOptions];

	(* ------------------------- *)
	(* ---RESOLVE PREPARATION--- *)
	(* ------------------------- *)

	(* Resolve our preparation option. *)
	(* we pass myOptions instead of imageCellsOptions here because we need to check for specified sample prep options *)
	preparationResult=Check[
		{allowedPreparation,preparationTest}=If[gatherTests,
			resolveImageCellsMethod[myPooledSamples,ReplaceRule[myOptions,{Cache->cache,Simulation->simulation,Output->{Result,Tests}}]],
			{
				resolveImageCellsMethod[myPooledSamples,ReplaceRule[myOptions,{Cache->cache,Simulation->simulation,Output->Result}]],
				{}
			}
		],
		$Failed
	];

	(* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
	(* options so that OptimizeUnitOperations can perform primitive grouping. *)
	resolvedPreparation=If[MatchQ[allowedPreparation,_List],
		First[allowedPreparation],
		allowedPreparation
	];

	(* --------------------------------- *)
	(* ---RESOLVE SAMPLE PREP OPTIONS--- *)
	(* --------------------------------- *)

	(* pre-resolve sample prep master switches based on Preparation option *)
	samplePrepOptionsWithMasterSwitches=If[MatchQ[resolvedPreparation,Robotic],
		(* if Preparation is Robotic, pre-resolve master switches to False since we don't allow sample prep *)
		ReplaceRule[
			samplePrepOptions,
			{
				Centrifuge->Lookup[samplePrepOptions,Centrifuge],
				Aliquot->Lookup[samplePrepOptions,Aliquot],
				Incubate->Lookup[samplePrepOptions,Incubate],
				Filtration->Lookup[samplePrepOptions,Filtration]
			}/.Automatic->False
		],
		(* else: Preparation is manual, return samplePrepOptions as is *)
		samplePrepOptions
	];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentImageCells,myPooledSamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentImageCells,myPooledSamples,samplePrepOptions,Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* -------------- *)
	(* ---DOWNLOAD--- *)
	(* ---------------*)

	(* ---GATHER ALL OBJECTS TO DOWNLOAD--- *)

	(* flatten list of input samples *)
	flatSimulatedSamples=Flatten[simulatedSamples];

	(*Pull out the options that may have models/objects whose information we need to download*)
	detectionLabelsFromPrimitives=Cases[Lookup[imageCellsOptionsAssociation,Images],ObjectReferenceP[],Infinity];

	(* get the specified Instrument option *)
	specifiedInstrument=Lookup[imageCellsOptionsAssociation,Instrument];

	(* get the instrument to download information from *)
	(* Note: we don't throw any error here because we already checked and returned early in the main function if search results came up as {} *)
	instrumentsToDownload=microscopeDevices[
		specifiedInstrument,
		imageCellsOptionsAssociation,
		Lookup[myOptions,Preparation],
		Lookup[myOptions,WorkCell]
	];

	(* get all possible slide adapter models that we may need *)
	allSlideAdapterModels=Search[Model[Container,Rack],Footprint==Plate&&Field[Positions[[Footprint]]]==MicroscopeSlide&&Deprecated==(False|Null)&&DeveloperObject!=True];

	(* separate instruments into models and objects to download *)
	instrumentObjectsToDownload=Cases[instrumentsToDownload,ObjectReferenceP[Object[Instrument]]];
	(* NOTE: Always include Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 40X, 60X Confocal, Microbial"] because it is our default instrument model if all else fails *)
	instrumentModelsToDownload=Join[Cases[instrumentsToDownload,ObjectReferenceP[Model[Instrument]]],{Model[Instrument, Microscope, "id:XnlV5jN97nnM"]}];

	(* ---GATHER ALL FIELDS TO DOWNLOAD--- *)

	(* define Fields to download for each object type *)
	sampleFields=SamplePreparationCacheFields[Object[Sample],Format->Sequence];
	modelSampleFields=SamplePreparationCacheFields[Model[Sample],Format->Sequence];
	objectContainerFields=SamplePreparationCacheFields[Object[Container],Format->Sequence];
	modelContainerFields=Sequence[SamplePreparationCacheFields[Model[Container],Format->Sequence],RecommendedFillVolume,
		AllowedPositions,Columns,CrossSectionalShape,FlangeHeight,HorizontalMargin,HorizontalPitch,Rows,VerticalMargin,
		VerticalPitch,DepthMargin,GridDimensions,PlateFootprintAdapters,MetaXpressPrefix,Coverslipped,CoverslipThickness,PositionPlotting];
	objectInstrumentFields=Sequence[Name,Status,Model];
	modelInstrumentFields=Sequence[Name,Objects,Deprecated,Positions,ActiveHumidityControl,Autofocus,CameraModel,
		CarbonDioxideControl,CondenserMaxHeight,CondenserMinHeight,CustomizableImagingChannel,DefaultExcitationPowers,
		DefaultImageCorrections,DefaultSamplingMethod,DefaultTransmittedLightPower,DichroicFilters,DichroicFilterWavelengths,
		EmissionFilters,EyePieceMagnification,FluorescenceEmissionWavelengths,FluorescenceExcitationWavelengths,FluorescenceFilters,
		HighContentImaging,HumidityControl,IlluminationColorCorrectionFilter,IlluminationFilters,IlluminationTypes,ImageCorrectionMethods,
		ImageDeconvolution,ImagingChannels,LampTypes,MaxTemperatureControl,MinTemperatureControl,Modes,ObjectiveMagnifications,
		Objectives,OpticModules,Orientation,PixelBinning,SamplingMethods,TemperatureControlledEnvironment,TimelapseImaging,
		ZStackImaging,MicroscopeCalibration,MaintenanceFrequency,MaxImagingChannels,TransmittedLightColorCorrection,
		MinExposureTime,MaxExposureTime,DefaultTargetMaxIntensity,MaxGrayLevel,ImageSizeX,ImageSizeY,ImageScalesX,ImageScalesY,
		MaxFocalHeight,CultureHandling
	];
	detectionLabelFields=Sequence[Name,DetectionLabel,Fluorescent,FluorescenceExcitationMaximums,FluorescenceEmissionMaximums];
	identityCellModelFields=Sequence[Name,DefaultSampleModel,DetectionLabels,Diameter,PreferredMaxCellCount,
		CellType,Tissues];
	objectMaintenanceFields=Sequence[Name,Model,Target,Status,DateCompleted,CondenserHeight,CondenserXPosition,CondenserYPosition,
		PhaseRingXPosition,PhaseRingYPosition,ApertureDiaphragm,FieldDiaphragm];
	modelMaintenanceFields=Sequence[Name,Targets,Objects];
	modelObjectiveFields=Sequence[Name,Magnification,ImmersionMedium,NumericalAperture,MaxWorkingDistance];

	(* get the instrument packets to download based on object type *)
	instrumentObjectDownloadPackets={
		Packet[objectInstrumentFields],
		Packet[Model[{modelInstrumentFields}]],
		Packet[Field[Model[MaintenanceFrequency][[All,1]]][{modelMaintenanceFields}]],
		Packet[Field[Model[MaintenanceFrequency][[All,1]][Objects]][{objectMaintenanceFields}]],
		Packet[Model[Objectives][{modelObjectiveFields}]]
	};
	instrumentModelDownloadPackets={
		Packet[modelInstrumentFields],
		Packet[Field[MaintenanceFrequency[[All,1]]][{modelMaintenanceFields}]],
		Packet[Field[MaintenanceFrequency[[All,1]][Objects]][{objectMaintenanceFields}]],
		Packet[Objectives[{modelObjectiveFields}]]
	};

	(* Extract the packets that we need from our downloaded cache. *)
	{
		(*1*)flatSimulatedSamplePackets,
		(*2*)flatSampleModelPackets,
		(*3*)flatSampleContainerPackets,
		(*4*)flatSampleContainerModelPackets,
		(*5*)flatSampleDetectionLabelPackets,
		(*6*)flatSampleIdentityModelPackets,
		(*7*)flatSampleIdentityModelDetectionLabelPackets,
		(*8*)primitiveDetectionLabelPackets,
		(*9*)instrumentObjectPackets,
		(*10*)instrumentModelPackets,
		(*11*)slideAdapterModelPackets,
		(*12*)flatSampleCompositionTypes
	}=Quiet[
		Download[
			{
				(*1*)flatSimulatedSamples,
				(*2*)flatSimulatedSamples,
				(*3*)flatSimulatedSamples,
				(*4*)flatSimulatedSamples,
				(*5*)flatSimulatedSamples,
				(*6*)flatSimulatedSamples,
				(*7*)flatSimulatedSamples,
				(*8*)detectionLabelsFromPrimitives,
				(*9*)instrumentObjectsToDownload,
				(*10*)instrumentModelsToDownload,
				(*11*)allSlideAdapterModels,
				(*12*)flatSimulatedSamples
			},
			Evaluate[{
				{
					Packet[sampleFields]
				},
				{
					Packet[Model[{modelSampleFields}]]
				},
				{
					Packet[Container[{objectContainerFields}]]
				},
				{
					Packet[Container[Model][{modelContainerFields}]]
				},
				{
					Packet[Field[Composition[[All,2]]][DetectionLabels][{detectionLabelFields}]]
				},
				{
					Packet[Field[Model[Composition][[All,2]]][{identityCellModelFields}]]
				},
				{
					Packet[Field[Model[Composition][[All,2]]][DetectionLabels][{detectionLabelFields}]]
				},
				{
					Packet[detectionLabelFields]
				},
				instrumentObjectDownloadPackets,
				instrumentModelDownloadPackets,
				{
					Packet[Dimensions,Footprint]
				},
				{
					Field[Composition[[All,2]]][Type]
				}
			}],
			Cache->cache,
			Simulation->updatedSimulation
		],
		{Download::FieldDoesntExist,Download::Part}
	];

	(* ---clean up and consolidate downloaded packets--- *)

	(* combine our downloaded packets into a new cache *)
	newCache=FlattenCachePackets[{flatSimulatedSamplePackets,flatSampleModelPackets,flatSampleContainerPackets,
		flatSampleContainerModelPackets,flatSampleDetectionLabelPackets,flatSampleIdentityModelPackets,
		flatSampleIdentityModelDetectionLabelPackets,primitiveDetectionLabelPackets,instrumentObjectPackets,
		instrumentModelPackets,slideAdapterModelPackets}];

	(* get the number of samples in each pool for bringing back the nested form of simulatedSamples *)
	poolingLengths=Length/@simulatedSamples;

	(* bring back the nested form of packets downloaded from simulated samples *)
	pooledSimulatedSamplePackets=TakeList[Flatten@flatSimulatedSamplePackets,poolingLengths];
	pooledSampleContainerPackets=TakeList[Flatten@flatSampleContainerPackets,poolingLengths];
	pooledSampleContainerModelPackets=TakeList[Flatten@flatSampleContainerModelPackets,poolingLengths];
	pooledSampleDetectionLabelPackets=TakeList[Flatten/@flatSampleDetectionLabelPackets,poolingLengths];
	pooledSampleIdentityModelPackets=TakeList[Flatten/@flatSampleIdentityModelPackets,poolingLengths];
	pooledSampleIdentityModelDetectionLabelPackets=TakeList[Flatten/@flatSampleIdentityModelDetectionLabelPackets,poolingLengths];

	(* clean up downloaded packets that are not index-matched to pools *)
	cleanedPrimitiveDetectionLabelPackets=FlattenCachePackets[primitiveDetectionLabelPackets];
	cleanedInstrumentPackets=FlattenCachePackets[{instrumentObjectPackets,instrumentModelPackets}];

	(* get all objective model packets we downloaded *)
	objectiveModelPackets=Cases[cleanedInstrumentPackets,PacketP[Model[Part,Objective]]];

	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(* ----------------------------- *)
	(* ---INPUT VALIDATION CHECKS--- *)
	(* ----------------------------- *)

	(* ---DISCARDED INPUT CHECK--- *)

	(* get the samples from flatSimulatedSamples that are discarded *)
	discardedInvalidInputs=Cases[Flatten@flatSimulatedSamplePackets,KeyValuePattern[{Object->x_,Status->Discarded}]:>x];

	(* if there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->newCache]]
	];

	(*If we are gathering tests, create a passing and/or failing test with the appropriate result*)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->newCache]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[flatSimulatedSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[flatSimulatedSamples,discardedInvalidInputs],Cache->newCache]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* ----------------------------- *)
	(* ---OPTION PRECISION CHECKS--- *)
	(* ----------------------------- *)

	(* make a list of options to round *)
	optionsForRounding={
		(*01*)Temperature,
		(*02*)CarbonDioxidePercentage,
		(*03*)EquilibrationTime,
		(*04*)CoverslipThickness,
		(*05*)PlateBottomThickness,
		(*06*)ObjectiveMagnification,
		(*07*)PixelBinning,
		(*08*)SamplingNumberOfRows,
		(*09*)SamplingNumberOfColumns,
		(*10*)SamplingRowSpacing,
		(*11*)SamplingColumnSpacing,
		(*12*)SamplingCoordinates,
		(*13*)AdaptiveExcitationWaveLength,
		(*14*)AdaptiveNumberOfCells,
		(*15*)AdaptiveMinNumberOfImages,
		(*16*)AdaptiveCellWidth,
		(*17*)AdaptiveIntensityThreshold,
		(*18*)TimelapseInterval,
		(*19*)TimelapseDuration,
		(*20*)NumberOfTimepoints,
		(*21*)ZStepSize,
		(*22*)NumberOfZSteps,
		(*23*)ZStackSpan
	};

	(* make list of values to round to, index matched to option list *)
	valuesToRoundTo={
		(*01*)10^-1 Celsius,
		(*02*)10^-1 Percent,
		(*03*)1 Second,
		(*04*)10^-2 Millimeter,
		(*05*)10^-2 Millimeter,
		(*06*)1,
		(*07*)1,
		(*08*)1,
		(*09*)1,
		(*10*)1 Micrometer,
		(*11*)1 Micrometer,
		(*12*)1 Micrometer,
		(*13*)1 Nanometer,
		(*14*)1,
		(*15*)1,
		(*16*)1 Micrometer,
		(*17*)1,
		(*18*)1 Millisecond,
		(*19*)1 Millisecond,
		(*20*)1,
		(*21*)10^-1 Micrometer,
		(*22*)1,
		(*23*)10^-1 Micrometer
	};

	(* make a list of booleans to avoid rounding to zero, index matched to option list *)
	avoidZeroBools={False,False,False,False,False,True,True,True,True,False,False,False,False,True,True,False,True,False,False,True,True,True,True};

	(* round the options that have precision *)
	{roundedImageCellsOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[imageCellsOptionsAssociation,optionsForRounding,valuesToRoundTo,AvoidZero->avoidZeroBools,Output->{Result,Tests}],
		{RoundOptionPrecision[imageCellsOptionsAssociation,optionsForRounding,valuesToRoundTo,AvoidZero->avoidZeroBools],{}}
	];

	(* -------------------------------- *)
	(* ---CONFLICTING OPTIONS CHECKS--- *)
	(* -------------------------------- *)

	(* ---1. protocol name check--- *)
	(* get the specified Name *)
	nameOption=Lookup[roundedImageCellsOptions,Name];

	(* If the specified Name is not in the database, it is valid *)
	validNameQ=If[MatchQ[nameOption,_String],
		!DatabaseMemberQ[Object[Protocol,AcousticLiquidHandling,nameOption]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions=If[!validNameQ&&!gatherTests,
		(
			Message[Error::DuplicateName,"ImageCells protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[nameOption,_String],
		Test["If specified, Name is not already a ImageCells protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* ---2. resolve Instrument --- *)

	(* Get the culture handling that is required by our input *)
	(* Get desired culture handling based on the input samples *)
	sampleCellTypes=MapThread[
		Function[{samplesCellType,compositionTypes},
			Which[
				(* check if sample's CellType and Composition for yeast and bacteria *)
				MatchQ[samplesCellType,MicrobialCellTypeP]||MemberQ[compositionTypes,Model[Cell,Yeast]|Model[Cell,Bacteria]],
				Microbial,

				(* Next check for mammalian cells *)
				MatchQ[samplesCellType,NonMicrobialCellTypeP]||MemberQ[compositionTypes,Model[Cell,Mammalian]],
				NonMicrobial,

				(* If no cells we can use anything *)
				True,
				Automatic
			]
		],
		{Lookup[Flatten@flatSimulatedSamplePackets,CellType],flatSampleCompositionTypes}
	];

	(* Determine the instrument cell types from the input samples *)
	(* 1. If we have any Microbial cells, need to use microbial microscopes *)
	(* 2. If no microbial present, but have nonmicrobial, use nonmicrobial microscope *)
	(* 3. If no cells, can use anything *)
	requiredInstrumentCultureHandling = Which[
		MemberQ[sampleCellTypes,Microbial], Microbial,
		MemberQ[sampleCellTypes, NonMicrobial], NonMicrobial,
		True, Automatic
	];

	(* resolve instrument option *)
	{resolvedInstrument,noValidInstrumentError}=If[MatchQ[specifiedInstrument,Automatic],
		Module[{microscopeModelPackets,potentialInstrumentsCultureHandling,finalPotentialInstrumentPackets},

			(* Get our microscope model packets *)
			microscopeModelPackets = Cases[cleanedInstrumentPackets,ObjectP[instrumentsToDownload]];

			(* We need to do a final filter of our instrument packets to check their CultureHandling vs the CellType of the input samples *)
			potentialInstrumentsCultureHandling = Map[Function[{modelMicroscopePacket},
				Lookup[modelMicroscopePacket,CultureHandling,Null]
			],
				microscopeModelPackets
			];

			(* Filter out instruments if they have invalid culture handlings compared to our input samples *)
			finalPotentialInstrumentPackets = Switch[requiredInstrumentCultureHandling,
				Microbial,PickList[microscopeModelPackets,potentialInstrumentsCultureHandling,Except[NonMicrobial]],
				NonMicrobial,PickList[microscopeModelPackets,potentialInstrumentsCultureHandling,Except[Microbial]],
				Automatic,microscopeModelPackets
			];

			Switch[Length[finalPotentialInstrumentPackets],
				(* If we have no valid instruments, mark an error and choose the microbial high content imager by default *)
				0,
					{
						Model[Instrument, Microscope, "id:XnlV5jN97nnM"], (* Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 40X, 60X Confocal, Microbial"] *)
						True
					},
				(* If we have one valid instrument, choose it *)
				1,
					{
						Lookup[First@finalPotentialInstrumentPackets,Object],
						False
					},
				_,
					Module[{highContentImager},
						(* if so, check if any of them is a high content imager *)
						highContentImager=FirstCase[finalPotentialInstrumentPackets,(KeyValuePattern[{Object->x_,HighContentImaging->True}]:>x)];

						If[MissingQ[highContentImager],
							(* if none of the instruments are high content imager, return the first instrument in the list *)
							{Lookup[First@finalPotentialInstrumentPackets,Object],False},
							(* otherwise, return the first high content imager found in the list *)
							{highContentImager,False}
						]
					]
			]
		],
		{specifiedInstrument,False}
	];

	(* assign separate variables since resolvedInstrument can be either model or object type *)
	{resolvedInstrumentModel,resolvedInstrumentObject}=If[MatchQ[resolvedInstrument,ObjectReferenceP[Model[Instrument]]],
		{resolvedInstrument,Null},
		(* lookup instrument model from downloaded packets if Instrument is specified as an object *)
		{
			Download[Lookup[fetchPacketFromCache[resolvedInstrument,cleanedInstrumentPackets],Model],Object],
			resolvedInstrument
		}
	];

	(* get the instrument model and object packets from cache *)
	resolvedInstrumentModelPacket=fetchPacketFromCache[resolvedInstrumentModel,cleanedInstrumentPackets];
	resolvedInstrumentObjectPacket=fetchPacketFromCache[resolvedInstrumentObject,cleanedInstrumentPackets];

	(* get the packets of objectives installed on the resolved instrument *)
	resolvedObjectiveModelPackets=fetchPacketFromCache[#,objectiveModelPackets]&/@Lookup[resolvedInstrumentModelPacket,Objectives];

	(* throw an error if Instrument was not specified and no default model was found based on the supplied options *)
	instrumentNotFoundTestOptions = If[noValidInstrumentError&&!gatherTests,
		Module[{specifiedOptions,errorString},
			(* Get the options *)
			specifiedOptions = Select[
				{
					MicroscopeOrientation,
					Images,
					ReCalibrateMicroscope,
					Temperature,
					CarbonDioxide,
					ObjectiveMagnification
				},
				(!MatchQ[Lookup[roundedImageCellsOptions,#],ListableP[Alternatives[Automatic,False,Ambient]]])&
			];

			(* Define the error string *)
			errorString = StringJoin[
				"No microscope instrument was found based on the combination of specified options, ",
				ToString[specifiedOptions],
				" and the detected celltype of the input samples, ",
				ToString[requiredInstrumentCultureHandling /. {Automatic -> "No Cells"}]
			];

			Message[Error::ImageCellsInstrumentModelNotFound,errorString];
			specifiedOptions
		],
		{}
	];

	(* generate test for default instrument model *)
	instrumentNotFoundTest=If[gatherTests,
		Test["If Instrument is not specified, at least one instrument model that meets all the specified criteria must exist:",
			noValidInstrumentError,
			False
		],
		{}
	];

	(* Check if CultureHandling and resolved instrument are compatible *)
	(* First, get the culture handling of the resolved instrument *)
	resolvedInstrumentCultureHandling = Lookup[resolvedInstrumentModelPacket,CultureHandling,Null];
	instrumentCultureHandlingMismatchQ = Which[
		(* If the samples, have no found cells, no error *)
		MatchQ[requiredInstrumentCultureHandling,Automatic], False,

		(* If the Instrument has Null CultureHandling - were also always ok *)
		MatchQ[resolvedInstrumentCultureHandling,Null], False,

		(* If the samples have non microbial, but the instrument is microbial, we are ok *)
		MatchQ[requiredInstrumentCultureHandling,NonMicrobial], False,

		(* If the samples have Microbial, instrument must have microbial *)
		MatchQ[requiredInstrumentCultureHandling,Microbial] && !MatchQ[resolvedInstrumentCultureHandling,Microbial], True,

		(* Catch all *)
		True, False
	];

	(* if instrumentCultureHandlingMismatchQ is True and we are throwing message, throw an error message *)
	cultureHandlingInvalidOptions = If[instrumentCultureHandlingMismatchQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::ImageCellsCultureHandlingMismatch,resolvedInstrumentCultureHandling,ObjectToString[resolvedInstrument,Cache->newCache],requiredInstrumentCultureHandling /. {Automatic -> "No Cells"}];
			{Instrument}
		),
		{}
	];

	(* If we are gathering tests, generate a test for Instrument-CultureHandling mismatch *)
	instrumentCultureHandlingMismatchTest = If[gatherTests,
		Test["The culture handling of the input samples matches the culture handling of the Instrument:",
			If[noValidInstrumentError,
				False,
				instrumentCultureHandlingMismatchQ
			],
			False
		],
		Nothing
	];

	(* 2.5 Resolve the workcell, now that we have our instrument  *)
	potentialWorkCells = resolveImageCellsWorkCell[myPooledSamples,myOptions];

	(* resolve workcells based on instrument and preparation *)
	resolvedWorkCell = Which[
		(* No Workcell for manual preparation *)
		MatchQ[resolvedPreparation,Manual],
			Null,
		(* If only one potential workcell, go with it *)
		Length[potentialWorkCells] == 1,
			First[potentialWorkCells],
		True,
			(* If we have multiple potential workcells, decide based on the resolved instrument *)
			Switch[resolvedInstrumentModel,
				(* Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 20X, 60X Confocal, Mammalian"] *)
				(* Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 40X, 60X Confocal, Mammalian"] *)
				ObjectP[{Model[Instrument, Microscope, "id:n0k9mG8pj9BW"],Model[Instrument, Microscope, "id:L8kPEjObWWOE"]}], bioSTAR,
				(* Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 40X, 60X Confocal, Microbial"] *)
				(* Model[Instrument, Microscope, "Molecular Devices ImageXpress, 4X, 10X, 20X, 60X Confocal, Microbial"] *)
				ObjectP[{Model[Instrument, Microscope, "id:XnlV5jN97nnM"],Model[Instrument, Microscope, "id:pZx9joObekxM"]}], microbioSTAR,
				(* Catch All *)
				_,
				Null
			]
	];

	(* ---3. resolve MicroscopeOrientation / check if Instrument and MicroscopeOrientation are copacetic --- *)

	(* get the instrument's orientation from its model *)
	instrumentOrientation=Lookup[resolvedInstrumentModelPacket,Orientation];

	(* lookup specified MicroscopeOrientation option *)
	microscopeOrientationOption=Lookup[roundedImageCellsOptions,MicroscopeOrientation];

	(* resolve MicroscopeOrientation *)
	{resolvedMicroscopeOrientation,instrumentOrientationMismatchQ}=If[MatchQ[microscopeOrientationOption,Automatic],
		(* set to our resolved instrument's orientation *)
		{instrumentOrientation,False},
		(* else: return the specified value and check if compatible with our resolved instrument's orientation *)
		{microscopeOrientationOption,!MatchQ[instrumentOrientation,microscopeOrientationOption]}
	];

	(* if instrumentOrientationMismatchQ is False and we are throwing message, throw an error message *)
	orientationInvalidOptions=If[instrumentOrientationMismatchQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::MicroscopeOrientationMismatch,instrumentOrientation,ObjectToString[resolvedInstrument,Cache->newCache],microscopeOrientationOption];
			{Instrument,MicroscopeOrientation}
		),
		{}
	];

	(* if we are gathering tests generate a test for Instrument-MicroscopeOrientation mismatch *)
	instrumentOrientationMismatchTest=If[gatherTests,
		Test["If both are specified, Instrument's Orientation and MicroscopeOrientation option must be compatible:",
			If[noValidInstrumentError,
				False,
				instrumentOrientationMismatchQ
			],
			False
		],
		Nothing
	];

	(* ---4. instrument status check--- *)

	(* check the status of the Instrument if specified by the user *)
	validInstrumentStatusQ=If[MatchQ[specifiedInstrument,Automatic],
		(* always return True if Instrument is not directly specified by the user *)
		True,
		(
			If[MatchQ[specifiedInstrument,ObjectReferenceP[Model[Instrument]]],
				(* if specified Instrument is a model, check if it is deprecated *)
				!TrueQ[Lookup[resolvedInstrumentModelPacket,Deprecated]],
				(* if it is an object, check its status *)
				!MatchQ[Lookup[resolvedInstrumentObjectPacket,Status],Retired]
			]
		)
	];

	(* if we are throwing messages, throw an error message if Instrument is retired or deprecated *)
	invalidInstrumentStatusOption=If[!validInstrumentStatusQ&&!gatherTests,
		(
			Message[Error::InvalidMicroscopeStatus,ObjectToString[specifiedInstrument,Cache->newCache]];
			{Instrument}
		),
		{}
	];

	(* if we are gathering tests generate a test for invalid instrument status *)
	invalidInstrumentStatusTest=If[gatherTests,
		Test["Specified Instrument must not be retied or have a deprecated model:",
			validInstrumentStatusQ,
			True
		],
		Nothing
	];

	(* ---5. ReCalibrateMicroscope and Instrument check--- *)

	(* get ReCalibrateMicroscope and MicroscopeCalibration option *)
	{recalibrateBool,calibrationOption}=Lookup[roundedImageCellsOptions,{ReCalibrateMicroscope,MicroscopeCalibration}];

	(* does the instrument allow performing calibration by running a maintenance? *)
	instrumentAllowsCalibrationQ=TrueQ[Lookup[resolvedInstrumentModelPacket,MicroscopeCalibration]];

	(* if ReCalibrateMicroscope is True, check if the Instrument allows recalibration *)
	calibrationNotAllowedError=If[recalibrateBool,
		!instrumentAllowsCalibrationQ,
		False
	];

	(* if we are throwing messages, throw an error message if ReCalibrateMicroscope is True when calibration is not allowed by the Instrument *)
	calibrationNotAllowedOptions=If[calibrationNotAllowedError&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::MicroscopeCalibrationNotAllowed,ObjectToString[resolvedInstrument,Cache->newCache]];
			{Instrument,ReCalibrateMicroscope}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	calibrationNotAllowedTest=If[gatherTests,
		Test["If ReCalibrateMicroscope is True, "<>ObjectToString[resolvedInstrument,Cache->newCache]<>" must allow calibration by running a maintenance:",
			If[noValidInstrumentError,
				False,
				calibrationNotAllowedError
			],
			False
		],
		Nothing
	];

	(* ---6. ReCalibrateMicroscope and MicroscopeCalibration check--- *)

	(* check if the MicroscopeCalibration agrees with ReCalibrateMicroscope *)
	calibrationMismatchQ=If[MatchQ[calibrationOption,Automatic],
		(* no need to check if MicroscopeCalibration is not specified *)
		False,
		(
			If[recalibrateBool&&instrumentAllowsCalibrationQ,
				(* if ReCalibrateMicroscope is True and Instrument allows calibration, MicroscopeCalibration option cannot be Null *)
				NullQ[calibrationOption],
				(* if ReCalibrateMicroscope or instrumentAllowsCalibrationQ is False, MicroscopeCalibration option cannot be specified *)
				!NullQ[calibrationOption]
			]
		)
	];

	(* if we are throwing messages, throw an error message if MicroscopeCalibration and ReCalibrateMicroscope mismatch *)
	mismatchedCalibrationOptions=If[calibrationMismatchQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::MicroscopeCalibrationMismatch,{recalibrateBool,calibrationOption}];
			{ReCalibrateMicroscope,MicroscopeCalibration}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	mismatchedCalibrationOptionsTest=If[gatherTests,
		Test["MicroscopeCalibration option can only be specified when ReCalibrateMicroscope is True and Instrument allows calibration:",
			If[noValidInstrumentError,
				False,
				calibrationMismatchQ
			],
			False
		],
		Nothing
	];

	(* ---7. MicroscopeCalibration validation check--- *)

	(* resolve MicroscopeCalibration to an Object[Maintenance,CalibrateMicroscope] *)
	resolvedMicroscopeCalibrationOption=If[MatchQ[calibrationOption,Automatic],
		(* check if ReCalibrateMicroscope is True and the resolved Instrument allows calibration to be performed *)
		If[recalibrateBool&&instrumentAllowsCalibrationQ,

			(* if specified as or resolved to a Model, look for Object[Maintenance,CalibrateMicroscope] under its maintenance model *)
			Module[{possibleMaintenanceModels,possibleMaintenanceObjects,possibleMaintenancePackets,maintCalibDateTuples,mostRecentCalibrationTuple},
				(* get all possible maintenance models that have type Model[Maintenance,CalibrateMicroscope] *)
				possibleMaintenanceModels=Cases[Lookup[resolvedInstrumentModelPacket,MaintenanceFrequency][[All,1]],ObjectP[Model[Maintenance,CalibrateMicroscope]]];

				(* get all possible maintenance models objects *)
				possibleMaintenanceObjects=Flatten[Lookup[fetchPacketFromCache[#,cleanedInstrumentPackets],Objects]&/@possibleMaintenanceModels];

				(* check if we can find any possible maintenance objects *)
				If[MatchQ[possibleMaintenanceObjects,{}],
					(* return Null if we have an empty list *)
					Null,
					(
						(* get the packets for possible maintenance objects *)
						possibleMaintenancePackets=fetchPacketFromCache[#,cleanedInstrumentPackets]&/@possibleMaintenanceObjects;

						(* get the object reference and DateCompleted for all maintenance objects *)
						maintCalibDateTuples=Lookup[possibleMaintenancePackets,{Object,DateCompleted}];

						(* check if maintCalibDateTuples is an empty list *)
						If[!MatchQ[maintCalibDateTuples,{}],
							(* get the most recently performed calibration tuple *)
							mostRecentCalibrationTuple=Last@SortBy[maintCalibDateTuples,#[[2]]&];

							(* return the most recently performed calibration object *)
							First@mostRecentCalibrationTuple
						]
					)
				]
			],
			(* otherwise, return Null *)
			Null
		],
		(* if MicroscopeCalibration is specified, return as is *)
		calibrationOption
	];

	(* check if we can find a maintenance object if ReCalibrateMicroscope is True, Instruments allows calibration, and resolvedMicroscopeCalibrationOption is Null *)
	calibrationMaintObjectExistQ=If[recalibrateBool&&instrumentAllowsCalibrationQ&&MatchQ[calibrationOption,Automatic],
		!NullQ[resolvedMicroscopeCalibrationOption],
		True
	];

	(* if we are throwing messages, throw an error message *)
	microscopeCalibrationNotFoundOptions=If[!calibrationMaintObjectExistQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::MicroscopeCalibrationNotFound,resolvedInstrument];
			{Instrument,ReCalibrateMicroscope,MicroscopeCalibration}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	microscopeCalibrationNotFoundTest=If[gatherTests,
		Test["If ReCalibrateMicroscope is True and Instrument allows calibration, MicroscopeCalibration option must be specified with or successfully resolved to Object[Maintenance,CalibrationMicroscope]:",
			If[noValidInstrumentError,
				True,
				calibrationMaintObjectExistQ
			],
			True
		],
		Nothing
	];

	(* if MicroscopeCalibration is specified, check if the maintenance object has a valid target *)
	validCalibrationTargetQ=If[!NullQ[resolvedMicroscopeCalibrationOption]&&instrumentAllowsCalibrationQ,
		(* check if Target matches any Objects under resolved Instrument's model *)
		(
			Module[{calibrationTarget,possibleInstrumentObjects},
				(* get the Target instrument object from maintenance object's packet *)
				calibrationTarget=Download[Lookup[fetchPacketFromCache[resolvedMicroscopeCalibrationOption,cleanedInstrumentPackets],Target],Object];

				(* get all objects under the resolved instrument model *)
				possibleInstrumentObjects=Download[Lookup[resolvedInstrumentModelPacket,Objects],Object];

				(* check if calibration Target is a member of objects sharing our instrument model *)
				MemberQ[possibleInstrumentObjects,calibrationTarget]
			]
		),
		True
	];

	(* if we are throwing messages, throw an error message *)
	invalidCalibrationTargetOptions=If[!validCalibrationTargetQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::InvalidMicroscopeCalibration,resolvedMicroscopeCalibrationOption,resolvedInstrument];
			{MicroscopeCalibration,Instrument}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	invalidCalibrationTargetTest=If[gatherTests,
		Test["If ReCalibrateMicroscope is True and Instrument allows calibration, the Target of MicroscopeCalibration option must not conflict with the Instrument option:",
			If[noValidInstrumentError,
				True,
				validCalibrationTargetQ
			],
			True
		],
		Nothing
	];

	(* ---8. Temperature and Instrument--- *)

	(* get the Temperature option value *)
	temperatureOption=Lookup[roundedImageCellsOptions,Temperature];

	(* check if our Instrument supports the specified temperature *)
	validTemperatureQ=If[MatchQ[temperatureOption,Ambient],
		(* if Ambient, return True as we don't need instrument's environmental control *)
		True,
		(* if specified, check if the instrument supports temperature control *)
		If[TrueQ[Lookup[resolvedInstrumentModelPacket,TemperatureControlledEnvironment]],
			(* check if it's within the instrument's temperature range *)
			Module[{instrumentMinTemperature,instrumentMaxTemperature},
				(* get min and max temperature from our intruemtn model packet *)
				{instrumentMinTemperature,instrumentMaxTemperature}=Lookup[resolvedInstrumentModelPacket,{MinTemperatureControl,MaxTemperatureControl}];

				(* check if specified temperature falls within range *)
				MatchQ[temperatureOption,GreaterEqualP[instrumentMinTemperature]]&&MatchQ[temperatureOption,LessEqualP[instrumentMaxTemperature]]
			],
			False
		]
	];

	(* if we are throwing messages, throw an error message *)
	invalidTemperatureOptions=If[!validTemperatureQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::InvalidMicroscopeTemperature,temperatureOption,resolvedInstrument];
			{Temperature,Instrument}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	invalidTemperatureTest=If[gatherTests,
		Test["Temperature must be within range supported by the Instrument:",
			If[noValidInstrumentError,
				True,
				validTemperatureQ
			],
			True
		],
		Nothing
	];

	(* ---9. CarbonDioxide and Instrument--- *)

	(* get the CarbonDioxide option value *)
	carbonDioxideBool=Lookup[roundedImageCellsOptions,CarbonDioxide];

	(* check if our Instrument supports CO2 incubation *)
	validCarbonDioxideQ=If[carbonDioxideBool,
		TrueQ[Lookup[resolvedInstrumentModelPacket,CarbonDioxideControl]],
		True
	];

	(* if we are throwing messages, throw an error message *)
	invalidCarbonDioxideOptions=If[!validCarbonDioxideQ&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::CO2IncompatibleMicroscope,resolvedInstrument];
			{Temperature,Instrument}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	invalidCarbonDioxideTest=If[gatherTests,
		Test["If CarbonDioxide is True, the Instrument must support carbon dioxide incubation:",
			If[noValidInstrumentError,
				True,
				validCarbonDioxideQ
			],
			True
		],
		Nothing
	];

	(* ---10. CarbonDioxide and CarbonDioxidePercentage--- *)

	(* get the CarbonDioxidePercentage option value *)
	specifiedCO2PercentOption=Lookup[roundedImageCellsOptions,CarbonDioxidePercentage];

	resolvedCO2PercentOption = Which[
		(* respect user input *)
		MatchQ[specifiedCO2PercentOption, Except[Automatic]], specifiedCO2PercentOption,
		(* if CarbonDioxide is True, set to 5% *)
		TrueQ[carbonDioxideBool], 5 * Percent,
		(* otherwise set to Null *)
		True, Null
	];

	(* we have a conflict if either of the following is True *)
	carbonDioxideMismatch = Or[
		(* CarbonDioxide is True but CO2 percent is Null *)
		TrueQ[carbonDioxideBool] && NullQ[resolvedCO2PercentOption],
		(* CarbonDioxide is False but CO2 percent is a number *)
		!TrueQ[carbonDioxideBool] && MatchQ[resolvedCO2PercentOption, PercentP]
	];

	(* if we are throwing messages, throw an error message *)
	carbonDioxideMismatchOptions=If[carbonDioxideMismatch&&!gatherTests&&!noValidInstrumentError,
		(
			Message[Error::CarbonDioxideOptionsMismatch,{carbonDioxideBool,specifiedCO2PercentOption}];
			{CarbonDioxide,CarbonDioxidePercentage}
		),
		{}
	];

	(* If we are gathering tests, create a test with the appropriate result. *)
	carbonDioxideMismatchTest=If[gatherTests,
		Test["If CarbonDioxide is False, CarbonDioxidePercentage cannot be specified:",
			If[noValidInstrumentError,
				False,
				carbonDioxideMismatch
			],
			False
		],
		Nothing
	];

	(* ------------------------------ *)
	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	(* ------------------------------ *)

	(* make a lookup of any new labels that we create for samples/containers since we may re-use them *)
	objectToNewResolvedLabelLookup={};

	(* convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentImageCells,roundedImageCellsOptions];

	(*MapThread over each of our samples*)
	{
		pooledSamplesWithIncompatibleContainers,
		pooledSamplesWithInvalidWellBottom,
		allCoordinatesInWells,
		usableCoordinatesInWells,
		objectivesToUse,
		maxAllowedZDistances,
		pooledTotalImagingSites,
		invalidSamplingCoordinates,

		(*Error-tracking variables*)
		mismatchedContainersErrors,
		incompatibleContainerErrors,
		opaqueWellBottomErrors,
		invalidContainerOrientationErrors,
		coverslipThicknessMismatchWarnings,
		invalidCoverslipThicknessErrors,
		negativePlateBottomThicknessErrors,
		plateBottomThicknessMismatchWarnings,
		invalidPlateBottomThicknessErrors,
		unsupportedObjectiveMagnificationErrors,
		unsupportedPixelbinningErrors,
		notAllowedTimelapseIntervalErrors,
		notAllowedTimelapseDurationErrors,
		notAllowedNumberOfTimepointsErrors,
		notAllowedContinuousTimelapseImagingErrors,
		notAllowedTimelapseAcquisitionOrderErrors,
		unsupportedTimelapseImagingErrors,
		invalidTimelapseDefinitionErrors,
		invalidContinuousTimelapseImagingErrors,
		unsupportedZStackImagingErrors,
		invalidZStackDefinitionErrors,
		notAllowedZStepSizeErrors,
		notAllowedNumberOfZStepsErrors,
		notAllowedZStackSpanErrors,
		invalidZStackSpanErrors,
		invalidZStepSizeNumberOfZStepsErrors,
		invalidZStepSizeErrors,
		acquirePrimitiveResolverErrors,
		invalidAdjustmentSampleErrors,
		unsupportedSamplingPatternErrors,
		notAllowedSamplingCoordinatesErrors,
		rowSpacingNotAllowedErrors,
		samplingRowSpacingNotSpecifiedErrors,
		columnSpacingNotAllowedErrors,
		samplingColumnSpacingNotSpecifiedErrors,
		gridDefinedAsSinglePointErrors,
		cannotDetermineImagingSitesErrors,
		invalidGridDefinitionErrors,
		invalidAdaptiveExcitationWaveLengthErrors,
		adaptiveWavelengthOrderWarnings,
		unspecifiedAdaptiveNumberOfCellsErrors,
		unspecifiedAdaptiveMinNumberOfImagesErrors,
		tooManyAdaptiveImagingSitesErrors,
		unspecifiedAdaptiveCellWidthErrors,
		unspecifiedAdaptiveIntensityThresholdErrors,
		invalidAdaptiveIntensityThresholdErrors,
		notAllowedAdaptiveExcitationWaveLengthErrors,
		notAllowedAdaptiveNumberOfCellsErrors,
		notAllowedAdaptiveMinNumberOfImagesErrors,
		notAllowedAdaptiveCellWidthErrors,
		notAllowedAdaptiveIntensityThresholdErrors,
		notAllowedSamplingNumberOfRowsErrors,
		notAllowedSamplingNumberOfColumnsErrors,
		notAllowedSamplingRowSpacingErrors,
		notAllowedSamplingColumnSpacingErrors,
		invalidSamplingCoordinatesErrors,
		unspecifiedSamplingCoordinatesErrors,
		multipleContainersAdjustmentSampleErrors,
		incompatibleContainerThicknessErrors,

		(*Resolved option values*)
		resolvedContainerOrientations,
		resolvedCoverslipThicknesses,
		resolvedPlateBottomThicknesses,
		resolvedEquilibrationTimes,
		resolvedObjectiveMagnifications,
		resolvedPixelBinnings,
		resolvedTimelapses,
		resolvedTimelapseIntervals,
		resolvedTimelapseDurations,
		resolvedNumberOfTimepoints,
		resolvedContinuousTimelapseImagings,
		resolvedTimelapseAcquisitionOrders,
		resolvedZStepSizes,
		resolvedNumberOfZSteps,
		resolvedZStackSpans,
		resolvedImagesOptions,
		resolvedAdjustmentSamples,
		resolvedSamplingPatterns,
		resolvedSamplingNumberOfRows,
		resolvedSamplingNumberOfColumns,
		resolvedSamplingRowSpacings,
		resolvedSamplingColumnSpacings,
		resolvedSamplingCoordinates,
		resolvedAdaptiveExcitationWaveLengths,
		resolvedAdaptiveNumberOfCells,
		resolvedAdaptiveMinNumberOfImages,
		resolvedAdaptiveCellWidths,
		resolvedAdaptiveIntensityThresholds,
		resolvedSampleLabels,
		resolvedSampleContainerLabels
	}=Transpose[MapThread[
		Function[{simulatedSamplePackets,sampleContainerPackets,sampleContainerModelPackets,sampleDetectionLabelPackets,
			sampleIdentityModelDetectionLabelPackets,sampleIdentityModelPackets,myMapThreadOptions},
			Module[
				{
					sampleObjectRefs,uniqueContainerModels,instrumentPositions,containerFootprints,validContainerQs,slideAdapterExistQ,
					samplesWithIncompatibleContainer,containerWellColors,samplesWithInvalidWellBottom,canUseObjectiveMagnification,
					firstContainerFootprint,firstContainerCoverslipThickness,firstContainerDimensions,firstContainerWellDepth,
					firstContainerDepthMargin,calculatedWellThickness,instrumentObjectiveMagnifications,instrumentPixelBinnings,
					preResolvedImagesOption,allDetectionlabelPackets,resolvedImagesOptionsTests,objectiveModelPacketToUse,
					totalImagingSites,allCoordinatesInWell,usableCoordinatesInWell,hemocytometerQ,maxAllowedZ,resolvedImagesOptionsResult,
					invalidCoordinates,workingDistance,

					(* Error-tracking variables *)
					mismatchedContainersError,incompatibleContainerError,opaqueWellBottomError,invalidContainerOrientationError,
					coverslipThicknessMismatchWarning,invalidCoverslipThicknessError,negativePlateBottomThicknessError,
					plateBottomThicknessMismatchWarning,invalidPlateBottomThicknessError,unsupportedObjectiveMagnificationError,
					unsupportedPixelbinningError,notAllowedTimelapseIntervalError,notAllowedTimelapseDurationError,
					notAllowedNumberOfTimepointsError,notAllowedContinuousTimelapseImagingError,notAllowedTimelapseAcquisitionOrderError,
					unsupportedTimelapseImagingError,invalidTimelapseDefinitionError,invalidContinuousTimelapseImagingError,
					unsupportedZStackImagingError,invalidZStackDefinitionError,notAllowedZStepSizeError,notAllowedNumberOfZStepsError,
					notAllowedZStackSpanError,acquirePrimitiveResolverError,invalidAdjustmentSampleError,
					unsupportedSamplingPatternError,notAllowedSamplingCoordinatesError,rowSpacingNotAllowedError,
					samplingRowSpacingNotSpecifiedError,columnSpacingNotAllowedError,samplingColumnSpacingNotSpecifiedError,
					gridDefinedAsSinglePointError,cannotDetermineImagingSitesError,invalidGridDefinitionError,
					invalidAdaptiveExcitationWaveLengthError,adaptiveWavelengthOrderWarning,unspecifiedAdaptiveNumberOfCellsError,
					unspecifiedAdaptiveMinNumberOfImagesError,tooManyAdaptiveImagingSitesError,unspecifiedAdaptiveCellWidthError,
					unspecifiedAdaptiveIntensityThresholdError,invalidAdaptiveIntensityThresholdError,notAllowedAdaptiveExcitationWaveLengthError,
					notAllowedAdaptiveNumberOfCellsError,notAllowedAdaptiveMinNumberOfImagesError,notAllowedAdaptiveCellWidthError,
					notAllowedAdaptiveIntensityThresholdError,notAllowedSamplingNumberOfRowsError,notAllowedSamplingNumberOfColumnsError,
					notAllowedSamplingRowSpacingError,notAllowedSamplingColumnSpacingError,invalidSamplingCoordinatesError,
					unspecifiedSamplingCoordinatesError,invalidZStackSpanError,invalidZStepSizeNumberOfZStepsError,invalidZStepSizeError,
					multipleContainersAdjustmentSampleError,incompatibleContainerThicknessError,

					(* Specified option values *)
					equilibrationTime,containerOrientation,coverslipThickness,plateBottomThickness,objectiveMagnification,
					pixelBinning,images,adjustmentSample,samplingPattern,samplingNumberOfRows,samplingNumberOfColumns,
					samplingRowSpacing,samplingColumnSpacing,samplingCoordinates,adaptiveExcitationWaveLength,
					adaptiveNumberOfCells,adaptiveMinNumberOfImages,adaptiveCellWidth,adaptiveIntensityThreshold,
					timelapse,timelapseInterval,timelapseDuration,numberOfTimepoints,continuousTimelapseImaging,
					timelapseAcquisitionOrder,zStack,zStepSize,numberOfZSteps,zStackSpan,sampleLabels,sampleContainerLabels,

					(* Resolved option values *)
					resolvedContainerOrientation,resolvedCoverslipThickness,resolvedPlateBottomThickness,resolvedEquilibrationTime,
					resolvedObjectiveMagnification,resolvedTimelapseInterval,resolvedTimelapseDuration,resolvedNumberOfTimepoint,
					resolvedContinuousTimelapseImaging,resolvedTimelapseAcquisitionOrder,resolvedZStepSize,resolvedNumberOfZStep,
					resolvedZStackSpan,resolvedImagesOption,resolvedSamplingPattern,resolvedSamplingNumberOfRow,
					resolvedSamplingNumberOfColumn,resolvedSamplingRowSpacing,resolvedSamplingColumnSpacing,resolvedSamplingCoordinate,
					resolvedAdaptiveExcitationWaveLength,resolvedAdaptiveNumberOfCell,resolvedAdaptiveMinNumberOfImage,
					resolvedAdaptiveCellWidth,resolvedAdaptiveIntensityThreshold,resolvedSampleLabel,resolvedSampleContainerLabel
				},

				(*Initialize the error-tracking variables*)
				{
					mismatchedContainersError,
					incompatibleContainerError,
					opaqueWellBottomError,
					invalidContainerOrientationError,
					coverslipThicknessMismatchWarning,
					invalidCoverslipThicknessError,
					negativePlateBottomThicknessError,
					plateBottomThicknessMismatchWarning,
					invalidPlateBottomThicknessError,
					unsupportedObjectiveMagnificationError,
					unsupportedPixelbinningError,
					notAllowedTimelapseIntervalError,
					notAllowedTimelapseDurationError,
					notAllowedNumberOfTimepointsError,
					notAllowedContinuousTimelapseImagingError,
					notAllowedTimelapseAcquisitionOrderError,
					unsupportedTimelapseImagingError,
					invalidTimelapseDefinitionError,
					invalidContinuousTimelapseImagingError,
					unsupportedZStackImagingError,
					invalidZStackDefinitionError,
					notAllowedZStepSizeError,
					notAllowedNumberOfZStepsError,
					notAllowedZStackSpanError,
					acquirePrimitiveResolverError,
					invalidAdjustmentSampleError,
					unsupportedSamplingPatternError,
					notAllowedSamplingCoordinatesError,
					rowSpacingNotAllowedError,
					samplingRowSpacingNotSpecifiedError,
					columnSpacingNotAllowedError,
					samplingColumnSpacingNotSpecifiedError,
					gridDefinedAsSinglePointError,
					cannotDetermineImagingSitesError,
					invalidGridDefinitionError,
					invalidAdaptiveExcitationWaveLengthError,
					adaptiveWavelengthOrderWarning,
					unspecifiedAdaptiveNumberOfCellsError,
					unspecifiedAdaptiveMinNumberOfImagesError,
					tooManyAdaptiveImagingSitesError,
					unspecifiedAdaptiveCellWidthError,
					unspecifiedAdaptiveIntensityThresholdError,
					invalidAdaptiveIntensityThresholdError,
					notAllowedAdaptiveExcitationWaveLengthError,
					notAllowedAdaptiveNumberOfCellsError,
					notAllowedAdaptiveMinNumberOfImagesError,
					notAllowedAdaptiveCellWidthError,
					notAllowedAdaptiveIntensityThresholdError,
					notAllowedSamplingNumberOfRowsError,
					notAllowedSamplingNumberOfColumnsError,
					notAllowedSamplingRowSpacingError,
					notAllowedSamplingColumnSpacingError,
					invalidSamplingCoordinatesError,
					unspecifiedSamplingCoordinatesError,
					invalidZStackSpanError,
					invalidZStepSizeNumberOfZStepsError,
					invalidZStepSizeError,
					multipleContainersAdjustmentSampleError,
					incompatibleContainerThicknessError
				}=ConstantArray[False,59];

				(*Look up the option values*)
				{
					equilibrationTime,containerOrientation,coverslipThickness,plateBottomThickness,objectiveMagnification,
					pixelBinning,images,adjustmentSample,samplingPattern,samplingNumberOfRows,samplingNumberOfColumns,
					samplingRowSpacing,samplingColumnSpacing,samplingCoordinates,adaptiveExcitationWaveLength,
					adaptiveNumberOfCells,adaptiveMinNumberOfImages,adaptiveCellWidth,adaptiveIntensityThreshold,timelapse,
					timelapseInterval,timelapseDuration,numberOfTimepoints,continuousTimelapseImaging,
					timelapseAcquisitionOrder,zStack,zStepSize,numberOfZSteps,zStackSpan,sampleLabels,sampleContainerLabels
				}=Lookup[
					myMapThreadOptions,
					{
						EquilibrationTime,ContainerOrientation,CoverslipThickness,PlateBottomThickness,ObjectiveMagnification,
						PixelBinning,Images,AdjustmentSample,SamplingPattern,SamplingNumberOfRows,SamplingNumberOfColumns,
						SamplingRowSpacing,SamplingColumnSpacing,SamplingCoordinates,AdaptiveExcitationWaveLength,
						AdaptiveNumberOfCells,AdaptiveMinNumberOfImages,AdaptiveCellWidth,AdaptiveIntensityThreshold,
						Timelapse,TimelapseInterval,TimelapseDuration,NumberOfTimepoints,ContinuousTimelapseImaging,
						TimelapseAcquisitionOrder,ZStack,ZStepSize,NumberOfZSteps,ZStackSpan,SampleLabel,SampleContainerLabel
					}
				];

				(* ---setup--- *)

				(* get the sample object reference from our packets *)
				sampleObjectRefs=Lookup[simulatedSamplePackets,Object];

				(* initialize a list to keep track of invalid SamplingCoordinates *)
				invalidCoordinates={};

				(* ---1. check if all containers in this pool share the same model--- *)

				(* get the unique containers from our packets *)
				uniqueContainerModels=If[NullQ[sampleContainerModelPackets]||NullQ[First@sampleContainerModelPackets],
					(* return an empty list when we have container-less sample *)
					{},
					(* else: return only unique containers *)
					DeleteDuplicates@Lookup[sampleContainerModelPackets,Object]
				];

				(* if there are more than one unique container model, flip the error switch *)
				mismatchedContainersError=Length[uniqueContainerModels]>1;

				(* ---2. container compatibility check--- *)

				(* 1. if slide/hemocytometer lookup PlateFootprintAdapter field (multiple) *)
				(* 2. is any of them compatible with our instrument? (call CompatibleFootprintQ with rack as input and Sample Slot as instrument's position) *)
				(* 3. if not populated or none of populated ones are compatible with our instrument, search for compatible one that accepts our slide/hemocytometer if any *)
				(* 4. if nothing is found, flip the error switch *)
				(* 5. if everything checks out we will need to do this again in resource packets to get the correct adapter MODELS. make sure to generate resource with all possible adapter models and make correct Placement fields with proper instrument position *)

				(* get all positions from our resolved instrument model *)
				instrumentPositions=Lookup[resolvedInstrumentModelPacket,Positions];

				(* get our containers' footrpints *)
				containerFootprints=Lookup[sampleContainerModelPackets,Footprint];

				(* if any sample's container footprint is MicroscopeSlide, we will check if any available adapters fit on our instrument *)
				slideAdapterExistQ=If[MemberQ[containerFootprints,MicroscopeSlide],
					Module[{flatSlideAdapterModelPackets,expandedInstruments,cfqResult},
						(* flatten our slideAdapterModelPackets *)
						flatSlideAdapterModelPackets=Flatten[slideAdapterModelPackets];

						(* expand instrument model to pass to CompatibleFootprintQ *)
						expandedInstruments=ConstantArray[{resolvedInstrumentModel},Length[flatSlideAdapterModelPackets]];

						(* call CompatibleFootprintQ with all available slide adapters *)
						cfqResult=CompatibleFootprintQ[expandedInstruments,Lookup[flatSlideAdapterModelPackets,Object],Position->"Sample Slot",Cache->newCache,Output->Boolean,ExactMatch->False];

						(* return our result as a single boolean *)
						If[MatchQ[cfqResult,_List],
							(* return True if any of the adapter can fit on our instrument *)
							Or@@Flatten[cfqResult],
							cfqResult
						]
					]
				];

				(* get the positions each sample container can be placed *)
				validContainerQs=MapThread[
					(* for each sample in this pool, check if there's any compatible position on the instrument *)
					Function[{sample,containerModelPacket},
						Switch[Lookup[containerModelPacket,Footprint],
							(* container is a plate, check each sample container against sample slot in our instrument *)
							Plate,CompatibleFootprintQ[resolvedInstrumentModel,sample,Position->"Sample Slot",Cache->newCache,Output->Boolean,ExactMatch->False],

							(* container has slide footprint. return our boolean that we got when checking all available slide adapters *)
							MicroscopeSlide,slideAdapterExistQ,

							(* we don't support any other footprints *)
							_,False
						]
					],
					{sampleObjectRefs,sampleContainerModelPackets}
				];

				(* get the sample whose container is incompatible with the instrument *)
				samplesWithIncompatibleContainer=PickList[sampleObjectRefs,validContainerQs,False];

				(* if there's any sample with incompatible container, flip the error switch *)
				If[!MatchQ[samplesWithIncompatibleContainer,{}],
					incompatibleContainerError=True;
				];

				(* ---3. container well bottom check--- *)
				(* inverted microscopes only allow imaging from the plate bottom, so WellColor must be Clear *)

				(* lookup well bottom color for each sample *)
				containerWellColors=If[NullQ[#],
					(* if container is Null return Null *)
					Null,
					Switch[Lookup[#,Footprint],
						(* if it is a slide, return Clear *)
						(* TODO: should we store slide color in model like plate and check here? *)
						MicroscopeSlide,Clear,
						(* otherwise, get value from WellColor field if exists *)
						_,Lookup[#,WellColor,Null]
					]
				]&/@sampleContainerModelPackets;

				(* get the sample whose container well bottom is not clear *)
				(* note: skip this check if we already triggered incompatible container error *)
				samplesWithInvalidWellBottom=If[TrueQ[incompatibleContainerError],
					{},
					PickList[sampleObjectRefs,containerWellColors,Except[Clear]]
				];

				(* if there's any sample with non-clear well bottom, flip the error switch *)
				opaqueWellBottomError=!MatchQ[samplesWithInvalidWellBottom,{}];

				(* 4. ---container orientation check--- *)

				(* get the footprint of our first container *)
				(* Note: only lookup the first container model, in case multiple models are specified which is not allowed *)
				firstContainerFootprint=First@containerFootprints;

				(* is our first container a hemocytometer? *)
				hemocytometerQ=MatchQ[First@sampleContainerModelPackets,PacketP[Model[Container,Hemocytometer]]];

				(* resolve ContainerOrientation *)
				resolvedContainerOrientation=If[MatchQ[containerOrientation,Automatic],
					(* if Automatic, resolve it *)
					If[MatchQ[firstContainerFootprint,MicroscopeSlide],
						(* if our container is a slide, resolve based on microscope orientation *)
						(* but always resolve to RightSideUp for hemocytometer or slide without a coverslip *)
						If[MatchQ[instrumentOrientation,Upright]||hemocytometerQ||!TrueQ[Lookup[First@sampleContainerModelPackets,Coverslipped]],
							RightSideUp,
							(* FIXME: also set to RightSideUp for now until we support UpsideDown *)
							RightSideUp (*UpsideDown*)
						],
						(* resolve to RightSideUp for all other footprint *)
						RightSideUp
					],
					(
						(* if specified and container is a hemocytometer or a plate, must always be RightSideUp *)
						(* FIXME: throw error for now if imaging slide and containerOrientation is set to UpsideDown until we fully support UpsideDown *)
						(*If[(MatchQ[firstContainerFootprint,Plate]||hemocytometerQ)&&!MatchQ[containerOrientation,RightSideUp],*)
						If[(MatchQ[firstContainerFootprint,Plate|MicroscopeSlide]||hemocytometerQ)&&!MatchQ[containerOrientation,RightSideUp],
							(* flip the error switch *)
							invalidContainerOrientationError=True;
						];
						(* accept the specified value *)
						containerOrientation
					)
				];

				(* 5. ---resolve CoverslipThickness--- *)

				(* get the CoverslipThickness of our first container *)
				(* Note: only lookup the first container model, in case multiple models are specified which is not allowed *)
				(* default to 0.16 mm if field does not exist *)
				firstContainerCoverslipThickness=If[MatchQ[resolvedContainerOrientation,UpsideDown],
					(* coverslip thickness also depends on imaging direction. if UpsideDown, we use CoverslipThickness from the container model *)
					Lookup[First@sampleContainerModelPackets,CoverslipThickness]/.($Failed->0.16 Millimeter),

					(* if RightSideUp, we use z-dimension of the container model *)
					Lookup[First@sampleContainerModelPackets,Dimensions][[3]]/.($Failed->1 Millimeter)
				];

				(* is CoverslipThickness specified? *)
				resolvedCoverslipThickness=If[MatchQ[coverslipThickness,Automatic],
					(* is our container a slide? *)
					If[MatchQ[firstContainerFootprint,MicroscopeSlide],
						(* get thickness from container model *)
						firstContainerCoverslipThickness,
						(* otherwise, return Null *)
						Null
					],
					(* ELSE: is our container a slide? *)
					(
						If[MatchQ[firstContainerFootprint,MicroscopeSlide],
							(* are the specified value and model's value conflicting? *)
							If[!NullQ[Lookup[First@sampleContainerModelPackets,CoverslipThickness]]&&!MatchQ[coverslipThickness,EqualP[firstContainerCoverslipThickness]],
								(* flip the warning switch if specified value and model's value are conflicting *)
								coverslipThicknessMismatchWarning=True;
							],
							(* ELSE: flip the error switch if not Null *)
							If[!NullQ[coverslipThickness],
								invalidCoverslipThicknessError=True;
							]
						];
						(* accept the specified value *)
						coverslipThickness
					)
				];

				(* 6. ---resolve PlateBottomThickness--- *)

				(* get Dimensions, WellDepth, DepthMargin of our first container *)
				(* Note: only lookup the first container model, in case multiple models are specified which is not allowed *)
				{firstContainerDimensions,firstContainerWellDepth,firstContainerDepthMargin}=Lookup[First@sampleContainerModelPackets,{Dimensions,WellDepth,DepthMargin},Null];

				(* calculate well bottom thickness *)
				calculatedWellThickness=If[MatchQ[firstContainerFootprint,Plate],
					(* if our container is a plate, calculate from plate height - well depth - depth margin *)
					SafeRound[(firstContainerDimensions[[3]]-firstContainerWellDepth-firstContainerDepthMargin), 10^-2 Millimeter],
					(* otherwise, return Null *)
					Null
				];

				(* check if calculated value > 0 *)
				If[MatchQ[calculatedWellThickness,LessEqualP[0 Millimeter]],
					(* if so, flip the error switch *)
					negativePlateBottomThicknessError=True;
				];

				(* is PlateBottomThickness specified? *)
				resolvedPlateBottomThickness=If[MatchQ[plateBottomThickness,Automatic],
					(* is our container a plate? *)
					If[MatchQ[firstContainerFootprint,Plate],
						(* return well bottom thickness calculated from container model *)
						calculatedWellThickness,
						(* otherwise, return Null *)
						Null
					],
					(* ELSE: is our container a plate? *)
					(
						If[MatchQ[firstContainerFootprint,Plate],
							(* are the specified value and model's value conflicting? *)
							If[!MatchQ[plateBottomThickness,EqualP[calculatedWellThickness]],
								(* flip the warning switch if specified value and model's value are conflicting *)
								plateBottomThicknessMismatchWarning=True;
							],
							(* ELSE: flip the error switch if not Null *)
							If[!NullQ[plateBottomThickness],
								invalidPlateBottomThicknessError=True;
							]
						];
						(* accept the specified value *)
						plateBottomThickness
					)
				];

				(* 7. ---resolve EquilibrationTime--- *)

				(* is EquilibrationTime specified? *)
				resolvedEquilibrationTime=If[MatchQ[equilibrationTime,Automatic],
					(* are we dealing with suspension cells? *)
					If[MemberQ[Lookup[simulatedSamplePackets,CultureAdhesion],Suspension],
						(* set to 5 Minute for the cells to settle before imaging  *)
						5 Minute,
						(* otherwise, set to 0 *)
						0 Minute
					],
					(* if specified, accept it *)
					equilibrationTime
				];

				(* 8. ---resolve ObjectiveMagnification--- *)

				(* lookup magnifications of objectives installed in our instrument *)
				instrumentObjectiveMagnifications=N[Lookup[resolvedInstrumentModelPacket,ObjectiveMagnifications]];

				(* is ObjectiveMagnification specified? *)
				resolvedObjectiveMagnification=If[MatchQ[objectiveMagnification,Automatic],
					If[MemberQ[instrumentObjectiveMagnifications,10.],
						(* set to 10 if the instrument allows *)
						10.,
						(* otherwise, set to the lowest magnification the instrument allows *)
						Min[instrumentObjectiveMagnifications]
					],
					(
						(* ELSE: is the specified magnification available on our instrument? *)
						(* NOTE: If we have an invalid instrument error, we should already be throwing an error, no need to throw this one also *)
						If[!MemberQ[instrumentObjectiveMagnifications,N[objectiveMagnification]]&&!noValidInstrumentError,
							(* if not, flip the error switch *)
							unsupportedObjectiveMagnificationError=True;
						];
						(* If we couldn't find an instrument before, we know we are defaulting to 10 *)
						If[noValidInstrumentError,
							10,
							(* accept the specified value *)
							objectiveMagnification
						]
					)
				];

				(* get objective magnification we can actually use to resolve related options *)
				(* note :if unsupportedObjectiveMagnificationError is True we will need to select a supported magnification *)
				(* which is closest to specified one to use for resolving other related options downstream *)
				canUseObjectiveMagnification=If[unsupportedObjectiveMagnificationError,
					(* find an objective magnification nearest to the specified one *)
					First@Nearest[instrumentObjectiveMagnifications,resolvedObjectiveMagnification,1],
					(* else: ok to use resolved value *)
					resolvedObjectiveMagnification
				];

				(* ---container and objective compatibility check--- *)
				(* now that we know which objective we're using, check if our container is compatible with the working distance *)

				(* get the objective model packet based on our resolvedObjectiveMagnification option *)
				objectiveModelPacketToUse=FirstCase[resolvedObjectiveModelPackets,KeyValuePattern[Magnification->N@canUseObjectiveMagnification]];

				(* lookup max working distance of the objective *)
				workingDistance=Lookup[objectiveModelPacketToUse,MaxWorkingDistance];

				(* check if our container thickness is compatible with the objective working distance *)
				Which[
					(* if container is a plate and well bottom thickness is more than working distance, flip the error switch *)
					MatchQ[firstContainerFootprint,Plate]&&MatchQ[resolvedPlateBottomThickness,GreaterP[workingDistance]],
						incompatibleContainerThicknessError=True;,

					(* if container is a plate and coverslip thickness is more than working distance, flip the error switch *)
					MatchQ[firstContainerFootprint,MicroscopeSlide]&&MatchQ[resolvedCoverslipThickness,GreaterP[workingDistance]],
						incompatibleContainerThicknessError=True;,

					(* else: do nothing *)
					True,
						Null
				];

				(* 9. ---PixelBinning check--- *)

				(* lookup allowed PixelBinning from our instrument *)
				instrumentPixelBinnings=N[Lookup[resolvedInstrumentModelPacket,PixelBinning]];

				(* is the specified PixelBinning supported by our instrument? *)
				If[!MemberQ[instrumentPixelBinnings,N[pixelBinning]],
					(* if not, flip the error switch *)
					unsupportedPixelbinningError=True;
				];

				(* 10. ---resolve timelapse imaging options--- *)

				(* is Timelapse option set to True? *)
				(* Note: Timelapse option is a master switch that turns on/off all timelapse-related options *)
				If[TrueQ[timelapse],
					(
						(* does our instrument support timelapse imaging? *)
						If[!TrueQ[Lookup[resolvedInstrumentModelPacket,TimelapseImaging]],
							unsupportedTimelapseImagingError=True;
						];

						(* resolve TimelapseInterval, TimelapseDuration, NumberOfTimepoints *)
						{resolvedTimelapseInterval,resolvedTimelapseDuration,resolvedNumberOfTimepoint}=Switch[{timelapseInterval,timelapseDuration,numberOfTimepoints},

							(* none of the options are specified. set all options to default values *)
							{Automatic,Automatic,Automatic},
							{1 Hour,8 Hour,8},

							(* only TimelapseInterval is specified. set duration to 8 hours and calculate timepoints *)
							{_,Automatic,Automatic},
							{timelapseInterval,8 Hour,SafeRound[(8 Hour)/timelapseInterval,1]},

							(* only TimelapseDuration is specified. default timepoints to 2 and calculate interval *)
							{Automatic,_,Automatic},
							{SafeRound[timelapseDuration/2,1 Millisecond],timelapseDuration,2},

							(* only NumberOfTimepoints is specified. set interval to 1 Hour and calculate duration *)
							{Automatic,Automatic,_},
							{1 Hour,SafeRound[(1 Hour)*numberOfTimepoints,1 Millisecond],numberOfTimepoints},

							(* TimelapseInterval and TimelapseDuration are specified. calculate timepoints *)
							{_,_,Automatic},
							{timelapseInterval,timelapseDuration,SafeRound[timelapseDuration/timelapseInterval,1]},

							(* TimelapseInterval and NumberOfTimepoints are specified. calculate duration *)
							{_,Automatic,_},
							{timelapseInterval,SafeRound[timelapseInterval*numberOfTimepoints,1 Millisecond],numberOfTimepoints},

							(* TimelapseDuration, NumberOfTimepoints are specified. calculate interval *)
							{Automatic,_,_},
							{SafeRound[timelapseDuration/numberOfTimepoints,1 Millisecond],timelapseDuration,numberOfTimepoints},

							(* all 3 options are specified. flip the error switch as we don't allow specifying all 3 options *)
							_,
							invalidTimelapseDefinitionError=True;{timelapseInterval,timelapseDuration,numberOfTimepoints}
						];

						(* is ContinuousTimelapseImaging specified? *)
						resolvedContinuousTimelapseImaging=If[MatchQ[continuousTimelapseImaging,Automatic],

							(* if resolvedTimelapseInterval is <= 1 Hour, resolve to True *)
							MatchQ[resolvedTimelapseInterval,LessEqualP[1 Hour]],

							(* ELSE: is ContinuousTimelapseImaging set to True? *)
							(
								If[TrueQ[continuousTimelapseImaging],
									(
										(* is resolvedTimelapseInterval > 1 Hour? *)
										If[MatchQ[resolvedTimelapseInterval,GreaterP[1 Hour]],
											(* flip the error switch as we don't allow continuous imaging if interval is more than 1 hour *)
											invalidContinuousTimelapseImagingError=True;
										];
										(* accept the specified value *)
										continuousTimelapseImaging
									),
									(* if not True, accpet the specified value *)
									continuousTimelapseImaging
								]
							)
						];

						(* is TimelapseAcquisitionOrder specified? *)
						resolvedTimelapseAcquisitionOrder=If[MatchQ[timelapseAcquisitionOrder,Automatic],
							(* default to parallel *)
							Parallel,
							(* otherwise, accept the specified value *)
							timelapseAcquisitionOrder
						]
					),

					(* ELSE: all timelapse-related options cannot be specified *)
					(
						(* is TimelapseInterval specified? *)
						resolvedTimelapseInterval=If[MatchQ[timelapseInterval,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* othwerwise, flip the error switch and accept the specified value *)
							(
								notAllowedTimelapseIntervalError=True;
								timelapseInterval
							)
						];

						(* is TimelapseDuration specified? *)
						resolvedTimelapseDuration=If[MatchQ[timelapseDuration,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedTimelapseDurationError=True;
								timelapseDuration
							)
						];

						(* is NumberOfTimepoints specified? *)
						resolvedNumberOfTimepoint=If[MatchQ[numberOfTimepoints,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedNumberOfTimepointsError=True;
								numberOfTimepoints
							)
						];

						(* is ContinuousTimelapseImaging specified? *)
						resolvedContinuousTimelapseImaging=If[MatchQ[continuousTimelapseImaging,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedContinuousTimelapseImagingError=True;
								continuousTimelapseImaging
							)
						];

						(* is TimelapseAcquisitionOrder specified? *)
						resolvedTimelapseAcquisitionOrder=If[MatchQ[timelapseAcquisitionOrder,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							(
								notAllowedTimelapseAcquisitionOrderError=True;
								timelapseAcquisitionOrder
							)
						];
					)
				];

				(* 11. ---resolve ZStepSize, NumberOfZSteps, ZStackSpan--- *)

				(* get the instrument's MaxFocalHeight for error check *)
				maxAllowedZ=Lookup[resolvedInstrumentModelPacket,MaxFocalHeight];

				(* is ZStack option set to True? *)
				(* Note: ZStack option is a master switch that turns on/off all ZStack-related options *)
				{resolvedZStepSize,resolvedNumberOfZStep,resolvedZStackSpan}=If[TrueQ[zStack],
					Module[{refractiveIndex,objectiveNA,alphaAngle,zSamplingDistance,roundedZSamplingDistance},

						(* ---calculate z sampling distance--- *)
						(* we use this as default zStepSize value *)
						(* note: based on Nyquist sampling: https://svi.nl/NyquistRate *)

						(* lookup refractive index of objective's immersion medium *)
						refractiveIndex=Switch[Lookup[objectiveModelPacketToUse],
							Oil,1.515,
							Glycerol,1.4695,
							Silicone,1.404,
							Water,1.333,
							Air,1.0003,
							_,1.
						];

						(* get the objective's numerical aperture *)
						objectiveNA=Lookup[objectiveModelPacketToUse,NumericalAperture];

						(* calculate half-aperture angle of the objective *)
						alphaAngle=ArcSin[objectiveNA/refractiveIndex];

						(* calculate the optimal sampling distance in the z axis *)
						(* note: calculate using 550 Nanometer as excitation wavelength as this is around the mean of wavelength range we support *)
						zSamplingDistance=(0.550 Micrometer)/(8*refractiveIndex*(1-Cos[alphaAngle]));

						(* round sampling distance to 0.1 Micrometer *)
						roundedZSamplingDistance=SafeRound[zSamplingDistance,10^-1 Micrometer];

						(* ---resolve z-stack options--- *)
						(* does our instrument support z-stack imaging? *)
						If[!TrueQ[Lookup[resolvedInstrumentModelPacket,ZStackImaging]],
							(* flip the error switch and set any Automatic to Null *)
							unsupportedZStackImagingError=True;{zStepSize,numberOfZSteps,zStackSpan}/.Automatic->Null,

							(* ELSE: resolve ZStepSize, NumberOfZSteps, ZStackSpan *)
							Switch[{zStepSize,numberOfZSteps,zStackSpan},
								(* none of the options are specified. set all options to default values *)
								{Automatic,Automatic,Automatic},
								Module[{steps,halfDistance},
									(* check if default 10 steps exceed max allowed z distance *)
									steps=If[MatchQ[zSamplingDistance*10,GreaterP[maxAllowedZ]],
										(* yes: calculate number of z steps from max distance *)
										Floor[maxAllowedZ/zSamplingDistance],
										(* no: use 10 *)
										10
									];
									(* calculate and round half of z-stack distance *)
									halfDistance=SafeRound[zSamplingDistance*steps/2,10^-1 Micrometer,AvoidZero->True];
									(* return the results *)
									{roundedZSamplingDistance,steps,Span[-halfDistance,halfDistance]}
								],
								(* only ZStepSize is specified. default NumberOfZSteps to 10 and calculate ZStackSpan *)
								{_,Automatic,Automatic},
								Module[{steps,halfDistance},
									(* check if default 10 steps exceed max allowed z distance *)
									steps=If[MatchQ[zStepSize*10,GreaterP[maxAllowedZ]],
										(* yes: calculate number of z steps from max distance *)
										Floor[maxAllowedZ/zStepSize],
										(* no: use 10 *)
										10
									];
									(* calculate and round half of z-stack distance *)
									halfDistance=SafeRound[zStepSize*steps/2,10^-1 Micrometer,AvoidZero->True];
									(* return the results *)
									{zStepSize,steps,Span[-halfDistance,halfDistance]}
								],
								(* only NumberOfZSteps is specified. resolve ZStepSize to zSamplingDistance and calculate zStackSpan *)
								{Automatic,_,Automatic},
								Module[{stepSize,halfDistance},
									(* get z step size *)
									stepSize=If[MatchQ[zSamplingDistance*numberOfZSteps,GreaterP[maxAllowedZ]],
										SafeRound[maxAllowedZ/numberOfZSteps,10^-1 Micrometer,AvoidZero->True],
										zSamplingDistance
									];
									(* calculate and round half of z-stack distance *)
									halfDistance=SafeRound[stepSize*numberOfZSteps/2,10^-1 Micrometer,AvoidZero->True];
									(* return the results *)
									{stepSize,numberOfZSteps,Span[-halfDistance,halfDistance]}
								],
								(* only ZStackSpan is specified. resolve ZStepSize to half of objective's MaxWorkingDistance and calculate NumberOfZSteps *)
								{Automatic,Automatic,_},
								Module[{zBottom,zTop,distance},
									(* get absolute top and bottom positions *)
									{zBottom,zTop}=MinMax[List@@zStackSpan];
									(* calculate spanning distance *)
									distance=zTop-zBottom;
									(* flip the error switch if distance exceeds max allowed distance *)
									If[MatchQ[distance,GreaterP[maxAllowedZ]],
										invalidZStackSpanError=True;
									];
									(* return the results *)
									{roundedZSamplingDistance,Floor[distance/zSamplingDistance],zStackSpan}
								],
								(* ZStepSize and NumberOfZSteps are specified. calculate ZStackSpan *)
								{_,_,Automatic},
								Module[{halfDistance},
									(* flip the error switch calculated z distance exceeds max allowed distance *)
									If[MatchQ[zStepSize*numberOfZSteps,GreaterP[maxAllowedZ]],
										invalidZStepSizeNumberOfZStepsError=True;
									];
									(* calculate and round half of z-stack distance *)
									halfDistance=SafeRound[zStepSize*numberOfZSteps/2,10^-1 Micrometer,AvoidZero->True];
									(* return the results *)
									{zStepSize,numberOfZSteps,Span[-halfDistance,halfDistance]}
								],
								(* ZStepSize and ZStackSpan are specified. calculate NumberOfZSteps *)
								{_,Automatic,_},
								Module[{zBottom,zTop,distance},
									(* get absolute top and bottom positions *)
									{zBottom,zTop}=MinMax[List@@zStackSpan];
									(* calculate spanning distance *)
									distance=zTop-zBottom;
									(* flip the error switch if distance exceeds max allowed distance *)
									If[MatchQ[distance,GreaterP[maxAllowedZ]],
										invalidZStackSpanError=True;
									];
									(* flip the error switch if ZStepSize is higher than distance *)
									If[MatchQ[zStepSize,GreaterP[distance]],
										invalidZStepSizeError=True;
									];
									(* return the results *)
									{zStepSize,Floor[distance/zStepSize],zStackSpan}
								],
								(* ZStackSpan and NumberOfZSteps are specified. calculate ZStepSize *)
								{Automatic,_,_},
								Module[{zBottom,zTop,distance},
									(* get absolute top and bottom positions *)
									{zBottom,zTop}=MinMax[List@@zStackSpan];
									(* calculate spanning distance *)
									distance=zTop-zBottom;
									(* flip the error switch if distance exceeds max allowed distance *)
									If[MatchQ[distance,GreaterP[maxAllowedZ]],
										invalidZStackSpanError=True;
									];
									(* return the results *)
									{SafeRound[distance/numberOfZSteps,10^-1 Micrometer,AvoidZero->True],numberOfZSteps,zStackSpan}
								],
								(* all 3 options are specified. flip the error switch as we don't allow specifying all 3 options *)
								_,
								invalidZStackDefinitionError=True;{zStepSize,numberOfZSteps,zStackSpan}
							]
						]
					],

					(* ELSE: all zstack-related options cannot be specified *)
					{
						(* is ZStepSize specified? *)
						If[MatchQ[zStepSize,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* othwerwise, flip the error switch and accept the specified value *)
							notAllowedZStepSizeError=True;zStepSize
						],

						(* is NumberOfZSteps specified? *)
						If[MatchQ[numberOfZSteps,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							notAllowedNumberOfZStepsError=True;numberOfZSteps
						],

						(* is ZStackSpan specified? *)
						If[MatchQ[zStackSpan,(Automatic|Null)],
							(* resolve to Null *)
							Null,
							(* otherwise, flip the error switch and accept the specified value *)
							notAllowedZStackSpanError=True;zStackSpan
						]
					}
				];

				(* 12. ---resolve Images option--- *)
				(* call our helper function to resolve AcquireImage primitive *)

				(* pre-resolve our Images option to non-Automatic value *)
				preResolvedImagesOption=If[MatchQ[images,Automatic],
					(* return an empty list so that our primitive resolver knows we don't pass any primitives to resolve *)
					{},
					(* else: return user-specified value *)
					images
				];

				(* combine detection label packets we downloaded from 1. sample's model and 2. sample's identity model *)
				allDetectionlabelPackets=Flatten[{sampleDetectionLabelPackets,sampleIdentityModelDetectionLabelPackets}];

				(* 2. primitive resolver returns failed test, this means that our primitives are partially resolved with some errors. *)
				(* flip a different error switch. this error message will tell the user to call resolveAcquireImagePrimitive to look at the messages *)
				If[Not[RunUnitTest[<|"Tests"->resolvedImagesOptionsTests|>,Verbose->False,OutputFormat->SingleBoolean]],
					acquirePrimitiveResolverError=True;
				];

				(* resolve AcquireImage primitives *)
				resolvedImagesOptionsResult=If[gatherTests,
					(* We are gathering tests. This silences any messages being thrown. *)
					{resolvedImagesOption,resolvedImagesOptionsTests}=resolveAcquireImagePrimitive[
						sampleObjectRefs,
						Instrument->resolvedInstrumentModel,
						Timelapse->timelapse,
						NumberOfTimepoints->resolvedNumberOfTimepoint,
						ZStack->zStack,
						ObjectiveMagnification->canUseObjectiveMagnification,
						Primitive->preResolvedImagesOption,
						Cache->newCache,
						Simulation->updatedSimulation,
						Output->{Result,Tests}
					];

					(* Therefore, we have to run the tests to see if we encountered a failure. *)
					If[RunUnitTest[<|"Tests"->resolvedImagesOptionsTests|>,Verbose->False,OutputFormat->SingleBoolean],
						{resolvedImagesOption,resolvedImagesOptionsTests},
						$Failed
					],

					(* We are not gathering tests. Simply check for Error::InvalidOption. *)
					Check[
						{resolvedImagesOption,resolvedImagesOptionsTests}={
							resolveAcquireImagePrimitive[
								sampleObjectRefs,
								Instrument->resolvedInstrumentModel,
								Timelapse->timelapse,
								NumberOfTimepoints->resolvedNumberOfTimepoint,
								ZStack->zStack,
								ObjectiveMagnification->canUseObjectiveMagnification,
								Primitive->preResolvedImagesOption,
								Cache->newCache,
								Simulation->updatedSimulation,
								Output->Result
							],
							{}
						},
						$Failed,
						{Error::InvalidOption}
					]
				];

				(* flip the error switch if the primitive resolver returned $Failed *)
				If[MatchQ[resolvedImagesOptionsResult,$Failed],
					acquirePrimitiveResolverError=True;
				];

				(* 13. ---AdjustmentSample check --- *)

				(* if specified as a sample object, that sample must be included in this current sample pool *)
				If[MatchQ[adjustmentSample,Except[All]],
					Module[{uniqueContainers},
						(* do we have more than one unique container in this pool? *)
						uniqueContainers=DeleteDuplicates[Lookup[sampleContainerPackets,Object]];
						If[Length[uniqueContainers]>1,
							(* AdjustmentSample is specified as a sample and we have more than one container *)
							(* flip the error switch since this is not allowed. each unique container will be split into different batches *)
							(* each batch needs its own AdjustmentSample *)
							multipleContainersAdjustmentSampleError=True;,

							(* else: check if specified AdjustmentSample is in this sample pool *)
							If[!MemberQ[Lookup[simulatedSamplePackets,Object],Download[adjustmentSample,Object]],
								invalidAdjustmentSampleError=True;
							]
						]
					]
				];

				(* 14. ---resolve SamplingPattern--- *)

				(* is SamplingPattern specified? *)
				resolvedSamplingPattern=If[MatchQ[samplingPattern,Automatic],
					(* are we imaging a hemocytometer? *)
					If[hemocytometerQ,
						(* check if grid area is larger than our field of view (FOV) *)
						Module[{gridSizeX,gridSizeY,imageSizeX,imageSizeY,imageScaleTuples,imageScaleX,imageScaleY,imageFOVx,imageFOVy},
							(* get counting grid dimensions from the first container model *)
							{gridSizeX,gridSizeY}=Lookup[First@sampleContainerModelPackets,GridDimensions];

							(* get image size in pixel in X and Y directions from the instrument *)
							{imageSizeX,imageSizeY}=Lookup[resolvedInstrumentModelPacket,{ImageSizeX,ImageSizeY}];

							(* create a list of tuples in the form {objectiveMagnification,imageScaleX,imageScaleY} *)
							imageScaleTuples=Transpose@Lookup[resolvedInstrumentModelPacket,{ObjectiveMagnifications,ImageScalesX,ImageScalesY}];

							(* get image scale from the tuple that matches our resolved ObjectiveMagnification option *)
							{imageScaleX,imageScaleY}=Rest@FirstCase[imageScaleTuples,{N[canUseObjectiveMagnification],__}];

							(* calculate image FOV in distance in X and Y direction *)
							{imageFOVx,imageFOVy}={imageScaleX*imageSizeX,imageScaleY*imageSizeY};

							(* is our FOV larger than the counting grid? *)
							If[MatchQ[imageFOVx,GreaterP[gridSizeX]]&&MatchQ[imageFOVy,GreaterP[gridSizeY]],
								(* set to SinglePoint *)
								SinglePoint,
								(* else: set to Grid *)
								Grid
							]
						],
						(* else: set to DefaultSamplingMethods of our instrument *)
						Lookup[resolvedInstrumentModelPacket,DefaultSamplingMethod]
					],
					(* else: does our instrument support specified SamplingPattern? *)
					If[MemberQ[Lookup[resolvedInstrumentModelPacket,SamplingMethods],samplingPattern],
						(* yes: accept it *)
						samplingPattern,
						(* no: flip the error switch and return the specified value *)
						unsupportedSamplingPatternError=True;samplingPattern
					]
				];

				(* ===resolve SamplingPattern dependent options=== *)

				(* did we flip unsupportedSamplingPatternError? *)
				If[unsupportedSamplingPatternError,
					(* yes: our instrument doesn't support specified SamplingPattern, set all related options with Automatic to Null *)
					{resolvedSamplingNumberOfRow,resolvedSamplingNumberOfColumn,resolvedSamplingRowSpacing,
						resolvedSamplingColumnSpacing,resolvedSamplingCoordinate,resolvedAdaptiveExcitationWaveLength,
						resolvedAdaptiveNumberOfCell,resolvedAdaptiveMinNumberOfImage,resolvedAdaptiveCellWidth,
						resolvedAdaptiveIntensityThreshold}={samplingNumberOfRows,samplingNumberOfColumns,samplingRowSpacing,
						samplingColumnSpacing,samplingCoordinates,adaptiveExcitationWaveLength,adaptiveNumberOfCells,
						adaptiveMinNumberOfImages,adaptiveCellWidth,adaptiveIntensityThreshold}/.Automatic->Null;,

					(* Switch based off of our resolved SamplingPattern to resolve related options *)
					Switch[resolvedSamplingPattern,

						(* SamplingPattern is Grid or Adaptive *)
						Alternatives[Grid,Adaptive],
						Module[{imageSizeX,imageSizeY,imageScaleTuples,imageScaleX,imageScaleY,imageDistanceX,imageDistanceY},
							(* get image size in pixel in X and Y directions from the instrument *)
							{imageSizeX,imageSizeY}=Lookup[resolvedInstrumentModelPacket,{ImageSizeX,ImageSizeY}];

							(* create a list of tuples in the form {objectiveMagnification,imageScaleX,imageScaleY} *)
							imageScaleTuples=Transpose@Lookup[resolvedInstrumentModelPacket,{ObjectiveMagnifications,ImageScalesX,ImageScalesY}];

							(* get image scale from the tuple that matches our resolved ObjectiveMagnification option *)
							{imageScaleX,imageScaleY}=Rest@FirstCase[imageScaleTuples,{N[canUseObjectiveMagnification],__}];

							(* calculate image size in distance in X and Y direction *)
							{imageDistanceX,imageDistanceY}={imageScaleX*imageSizeX,imageScaleY*imageSizeY};

							(* 1. ---resolve SamplingCoordinates--- *)

							(* is SamplingCoordinates specified? *)
							resolvedSamplingCoordinate=If[MatchQ[samplingCoordinates,Automatic|Null],
								(* set to Null *)
								Null,
								(* else: flip the error switch and return the specified value *)
								notAllowedSamplingCoordinatesError=True;samplingCoordinates
							];

							(* 2. ---resolve SamplingRowSpacing--- *)

							(* is SamplingRowSpacing specified? *)
							resolvedSamplingRowSpacing=If[MatchQ[samplingRowSpacing,Automatic],
								(* are we imaging a hemocytometer? *)
								If[hemocytometerQ,
									(* set to 10% overlap so that we can stitched seamlessly *)
									-0.1*imageDistanceY,
									(* else: set to tile: 0% overlap *)
									0 Micrometer
								],
								(* else: is SamplingNumberOfRows = 1? *)
								If[MatchQ[samplingNumberOfRows,EqualP[1]]&&!NullQ[samplingRowSpacing],
									(* flip the error switch. we don't allow setting spacing if there's only 1 row *)
									rowSpacingNotAllowedError=True;samplingRowSpacing,
									(* else: is SamplingRowSpacing Null? *)
									If[NullQ[samplingRowSpacing],
										(* flip the error switch since SamplingRowSpacing cannot be Null *)
										samplingRowSpacingNotSpecifiedError=True;samplingRowSpacing,
										(* else: is SamplingRowSpacing specified in percent overlap ? *)
										If[MatchQ[samplingRowSpacing,PercentP],
											(* convert it to distance *)
											-Normal[samplingRowSpacing]*imageDistanceY,
											(* return as is. we will check if entire scan area exceeds container size later *)
											samplingRowSpacing
										]
									]
								]
							];

							(* 3. ---resolve SamplingColumnSpacing--- *)

							(* is SamplingColumnSpacing specified? *)
							resolvedSamplingColumnSpacing=If[MatchQ[samplingColumnSpacing,Automatic],
								(* are we imaging a hemocytometer? *)
								If[hemocytometerQ,
									(* set to 10% overlap so that we can stitched seamlessly *)
									-0.1*imageDistanceY,
									(* else: set to tile: 0% overlap *)
									0 Micrometer
								],
								(* else: is SamplingNumberOfColumns = 1? *)
								If[MatchQ[samplingNumberOfColumns,EqualP[1]]&&!NullQ[samplingColumnSpacing],
									(* flip the error switch. we don't allow setting spacing if there's only 1 column *)
									columnSpacingNotAllowedError=True;samplingColumnSpacing,
									(* else: is SamplingColumnSpacing Null? *)
									If[NullQ[samplingColumnSpacing],
										(* flip the error switch since SamplingColumnSpacing cannot be Null *)
										samplingColumnSpacingNotSpecifiedError=True;samplingColumnSpacing,
										(* else: is SamplingColumnSpacing specified in percent overlap ? *)
										If[MatchQ[samplingColumnSpacing,PercentP],
											(* convert it to distance *)
											-Normal[samplingColumnSpacing]*imageDistanceX,
											(* return as is. we will check if entire scan area exceeds container size later *)
											samplingColumnSpacing
										]
									]
								]
							];

							(* 4. ---resolve SamplingNumberOfRows--- *)
							(* 5. ---resolve SamplingNumberOfColumns--- *)

							(* revise for slide (but not hemocytometer) handling *)
							(* TODO: how do we handle slides here if both options are Automatic? may need to set upper limit of number of sites to image with higher mag *)
							(* should we enforce defining sample location on the slide so that we can treat it as a pseudo-well?. *)
							(* actually a good idea. add VOQ for slide sample or slide container object to enforce sample area/location definition according to (0,0) at bottom left *)
							(* we should also support multiple samples per slide. talk to thomas about this *)
							(* TODO: also need to handle edge case where Footprint is not either Plate or MicroscopeSlide. error would have been thrown already.
							should resolve to Null without going into calculations to save time *)
							(* TODO: if our container is a hemocytometer, SamplingPattern must always be Grid (HCI) or Coordinates (Nikon; if we decide to support with nikon) *)
							(* TODO: download fields SamplePositions and SamplePositionPlotting from container OBJECT and use the info to generate grid rows/columns *)

							(* check if {row,column} is {1,1}. we don't allow that because it's a single point *)
							{
								resolvedSamplingNumberOfRow,
								resolvedSamplingNumberOfColumn,
								totalImagingSites,
								allCoordinatesInWell,
								usableCoordinatesInWell
							}=If[ContainsExactly[{samplingNumberOfRows,samplingNumberOfColumns},{1}],
								(* flip the error switch and return the specified values *)
								gridDefinedAsSinglePointError=True;{samplingNumberOfRows,samplingNumberOfColumns,0,{},{}},

								(* else: is any of SamplingNumberOfRows, SamplingNumberOfColumns, resolvedSamplingRowSpacing, resolvedSamplingColumnSpacing Null? *)
								If[MemberQ[{samplingNumberOfRows,samplingNumberOfColumns,resolvedSamplingRowSpacing,resolvedSamplingColumnSpacing},Null],

									(* flip the error switch as we can't determine imaging sites when any of these options is Null *)
									cannotDetermineImagingSitesError=True;{samplingNumberOfRows,samplingNumberOfColumns,0,{},{}}/.Automatic->Null,

									(* else: call our helper function to calculate and/or check specified row/column numbers against our container dimensions *)
									(* result is in the form {#row,#column,#sites,allCoordinates,usableCoordinates} *)
									Module[{rowColumnResult},
										rowColumnResult=imagingSiteCalculator[
											First@sampleContainerModelPackets,
											resolvedInstrumentModelPacket,
											N@canUseObjectiveMagnification,
											samplingNumberOfRows,
											samplingNumberOfColumns,
											resolvedSamplingRowSpacing,
											resolvedSamplingColumnSpacing
										];

										(* check if imagingSiteCalculator returned $Failed *)
										(* TODO: if error is thrown, also surface well dimensions for the user to check or tell user to lookup container's model (probably the latter) *)
										If[MatchQ[rowColumnResult,$Failed],
											(* flip the error switch as the specified number rows and/or columns are invalid *)
											invalidGridDefinitionError=True;{samplingNumberOfRows,samplingNumberOfColumns,0,{},{}}/.Automatic->Null,
											(* else: return our valid result *)
											rowColumnResult
										]
									]
								]
							];

							(* resolve adaptive sampling options *)
							{
								resolvedAdaptiveExcitationWaveLength,
								resolvedAdaptiveNumberOfCell,
								resolvedAdaptiveMinNumberOfImage,
								resolvedAdaptiveCellWidth,
								resolvedAdaptiveIntensityThreshold
							}=If[MatchQ[resolvedSamplingPattern,Adaptive],
								(* SamplingPattern is Adaptive *)
								Module[{resAdaptiveExcitationWaveLength,resAdaptiveNumberOfCells,resAdaptiveMinNumberOfImages,
									resAdaptiveCellWidth,resAdaptiveIntensityThreshold,excitationList,cellDiameters},

									(* resolve AdaptiveExcitationWaveLength *)

									(* is AdaptiveExcitationWaveLength specified? *)
									resAdaptiveExcitationWaveLength=If[MatchQ[adaptiveExcitationWaveLength,Automatic],
										(* did we successfully resolve Images options? *)
										If[MatchQ[resolvedImagesOption,$Failed],
											(* no: set to Null *)
											Null,
											(* yes: set to the first wavelength in the list of AcquireImage primitives from resolved Images option *)
											(* note: if first wavelength is Null, set to TransmittedLight *)
											First[resolvedImagesOption][ExcitationWavelength]/.Null->TransmittedLight
										],
										(* else: is it Null? *)
										If[NullQ[adaptiveExcitationWaveLength],
											(* yes: flip the error switch since it needs to be specified *)
											invalidAdaptiveExcitationWaveLengthError=True;adaptiveExcitationWaveLength,
											(* no: check further *)
											(
												(*  get the resolved ExcitationWavelength from AcquireImage primitives in our resolved Images option *)
												excitationList=#[ExcitationWavelength]&/@resolvedImagesOption;

												(* if not specified as TransmittedLight, does it match any excitation wavelength..*)
												(*..specified in AcquireImage primitive from resolved Images options *)
												If[Or[
													MatchQ[adaptiveExcitationWaveLength,TransmittedLight]&&NullQ[First@excitationList],
													!MatchQ[excitationList,$Failed]&&MemberQ[N@excitationList,N@adaptiveExcitationWaveLength]
												],
													(* does it match the first wavelength in AcquireImage primitives? *)
													If[Or[
														MatchQ[adaptiveExcitationWaveLength,TransmittedLight]&&NullQ[First@excitationList],
														MatchQ[adaptiveExcitationWaveLength,EqualP[First@excitationList]]
													],
														(* yes: return the specified value *)
														adaptiveExcitationWaveLength,
														(* no: flip the warning switch *)
														adaptiveWavelengthOrderWarning=True;adaptiveExcitationWaveLength
													],
													(* else: flip the error switch and return the value *)
													invalidAdaptiveExcitationWaveLengthError=True;adaptiveExcitationWaveLength
												]
											)
										]
									];

									(* resolve AdaptiveNumberOfCells *)

									(* is AdaptiveNumberOfCells specified? *)
									resAdaptiveNumberOfCells=If[MatchQ[adaptiveNumberOfCells,Automatic],
										(* set to 50 cells *)
										50,
										(* else: is it Null? *)
										If[NullQ[adaptiveNumberOfCells],
											(* flip the error switch *)
											unspecifiedAdaptiveNumberOfCellsError=True;adaptiveNumberOfCells,
											(* else: return the specified value *)
											adaptiveNumberOfCells
										]
									];

									(* resolve AdaptiveMinNumberOfImages *)

									(* is AdaptiveMinNumberOfImages specified? *)
									resAdaptiveMinNumberOfImages=If[MatchQ[adaptiveMinNumberOfImages,Automatic],
										(* set to 1 imaging site *)
										1,
										(* else: is it Null? *)
										If[NullQ[adaptiveMinNumberOfImages],
											(* flip the error switch *)
											unspecifiedAdaptiveMinNumberOfImagesError=True;adaptiveMinNumberOfImages,
											(* else: does it exceed total number of imaging sites? *)
											If[MatchQ[adaptiveMinNumberOfImages,GreaterP[totalImagingSites]],
												(* yes: flip the error switch *)
												tooManyAdaptiveImagingSitesError=True;adaptiveMinNumberOfImages,
												(* else: accept the specified value *)
												adaptiveMinNumberOfImages
											]
										]
									];

									(* resolve AdaptiveCellWidth *)

									(* is AdaptiveCellWidth specified? *)
									resAdaptiveCellWidth=If[MatchQ[adaptiveCellWidth,Automatic],
										(* resolve cell size based on sample's identity cell model *)
										(
											(* get all the sample cell identity model's diameter *)
											cellDiameters=Flatten@Lookup[Cases[Flatten@sampleIdentityModelPackets,PacketP[Model[Cell]]],Diameter,{}];

											(* did we find any diameter from samples' identity models? *)
											If[MatchQ[cellDiameters,{}],
												(* no: default to 5 to 10 Micrometer *)
												Span[5 Micromteter,10 Micrometer],
												(* yes: span Min and Max of the diameters we found *)
												(* TODO: should add buffer if min and max are the same *)
												Span[Sequence@@SafeRound[MinMax[cellDiameters],1 Micrometer]]
											]
										),
										(* else: is it Null *)
										If[NullQ[adaptiveCellWidth],
											(* flip the error switch *)
											unspecifiedAdaptiveCellWidthError=True;adaptiveCellWidth,
											(* no: return the specified value *)
											adaptiveCellWidth
										]
									];

									(* resolve AdaptiveIntensityThreshold *)

									(* is AdaptiveIntensityThreshold specified? *)
									resAdaptiveIntensityThreshold=If[MatchQ[adaptiveIntensityThreshold,Automatic],
										(* TODO: set to 100. this is relatively low, so may need to find a way to resolve better *)
										100,
										(* else: is it Null? *)
										If[NullQ[adaptiveIntensityThreshold],
											(* flip the error switch *)
											unspecifiedAdaptiveIntensityThresholdError=True;adaptiveIntensityThreshold,
											(* no: does it exceed MaxGrayLevel of our resolved instrument model *)
											If[MatchQ[adaptiveIntensityThreshold,GreaterP[Lookup[resolvedInstrumentModelPacket,MaxGrayLevel]]],
												(* flip the error switch *)
												invalidAdaptiveIntensityThresholdError=True;adaptiveIntensityThreshold,
												(* else: return the specified value *)
												adaptiveIntensityThreshold
											]
										]
									];

									(* return our resolved options *)
									{
										resAdaptiveExcitationWaveLength,
										resAdaptiveNumberOfCells,
										resAdaptiveMinNumberOfImages,
										resAdaptiveCellWidth,
										resAdaptiveIntensityThreshold
									}
								],
								(* else: our sampling pattern is Grid. we don't allow any adaptive options to be specified *)
								Module[{resAdaptiveExcitationWaveLength,resAdaptiveNumberOfCells,resAdaptiveMinNumberOfImages,
									resAdaptiveCellWidth,resAdaptiveIntensityThreshold},

									(* resolve AdaptiveExcitationWaveLength *)
									resAdaptiveExcitationWaveLength=If[MatchQ[adaptiveExcitationWaveLength,(Automatic|Null)],
										(* resolve to Null *)
										Null,
										(* else: flip the error switch and accept the specified value *)
										notAllowedAdaptiveExcitationWaveLengthError=True;adaptiveExcitationWaveLength
									];

									(* resolve AdaptiveNumberOfCells *)
									resAdaptiveNumberOfCells=If[MatchQ[adaptiveNumberOfCells,(Automatic|Null)],
										(* resolve to Null *)
										Null,
										(* else: flip the error switch and accept the specified value *)
										notAllowedAdaptiveNumberOfCellsError=True;adaptiveNumberOfCells
									];

									(* resolve AdaptiveMinNumberOfImages *)
									resAdaptiveMinNumberOfImages=If[MatchQ[adaptiveMinNumberOfImages,(Automatic|Null)],
										(* resolve to Null *)
										Null,
										(* else: flip the error switch and accept the specified value *)
										notAllowedAdaptiveMinNumberOfImagesError=True;adaptiveMinNumberOfImages
									];

									(* resolve AdaptiveCellWidth *)
									resAdaptiveCellWidth=If[MatchQ[adaptiveCellWidth,(Automatic|Null)],
										(* resolve to Null *)
										Null,
										(* else: flip the error switch and accept the specified value *)
										notAllowedAdaptiveCellWidthError=True;adaptiveCellWidth
									];

									(* resolve AdaptiveIntensityThreshold *)
									resAdaptiveIntensityThreshold=If[MatchQ[adaptiveIntensityThreshold,(Automatic|Null)],
										(* resolve to Null *)
										Null,
										(* else: flip the error switch and accept the specified value *)
										notAllowedAdaptiveIntensityThresholdError=True;adaptiveIntensityThreshold
									];

									(* return our resolved options *)
									{
										resAdaptiveExcitationWaveLength,
										resAdaptiveNumberOfCells,
										resAdaptiveMinNumberOfImages,
										resAdaptiveCellWidth,
										resAdaptiveIntensityThreshold
									}
								]
							]
						],

						(* SamplingPattern is SinglePoint or Coordinates *)
						Alternatives[SinglePoint,Coordinates],
						(
							(* first, check options that are not allowed to be specified *)

							(* resolve SamplingNumberOfRows *)
							resolvedSamplingNumberOfRow=If[MatchQ[samplingNumberOfRows,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedSamplingNumberOfRowsError=True;samplingNumberOfRows
							];

							(* resolve SamplingNumberOfColumns *)
							resolvedSamplingNumberOfColumn=If[MatchQ[samplingNumberOfColumns,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedSamplingNumberOfColumnsError=True;samplingNumberOfColumns
							];

							(* resolve SamplingRowSpacing *)
							resolvedSamplingRowSpacing=If[MatchQ[samplingRowSpacing,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedSamplingRowSpacingError=True;samplingRowSpacing
							];

							(* resolve SamplingColumnSpacing *)
							resolvedSamplingColumnSpacing=If[MatchQ[samplingColumnSpacing,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedSamplingColumnSpacingError=True;samplingColumnSpacing
							];

							(* resolve AdaptiveExcitationWaveLength *)
							resolvedAdaptiveExcitationWaveLength=If[MatchQ[adaptiveExcitationWaveLength,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedAdaptiveExcitationWaveLengthError=True;adaptiveExcitationWaveLength
							];

							(* resolve AdaptiveNumberOfCells *)
							resolvedAdaptiveNumberOfCell=If[MatchQ[adaptiveNumberOfCells,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedAdaptiveNumberOfCellsError=True;adaptiveNumberOfCells
							];

							(* resolve AdaptiveMinNumberOfImages *)
							resolvedAdaptiveMinNumberOfImage=If[MatchQ[adaptiveMinNumberOfImages,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedAdaptiveMinNumberOfImagesError=True;adaptiveMinNumberOfImages
							];

							(* resolve AdaptiveCellWidth *)
							resolvedAdaptiveCellWidth=If[MatchQ[adaptiveCellWidth,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedAdaptiveCellWidthError=True;adaptiveCellWidth
							];

							(* resolve AdaptiveIntensityThreshold *)
							resolvedAdaptiveIntensityThreshold=If[MatchQ[adaptiveIntensityThreshold,(Automatic|Null)],
								(* resolve to Null *)
								Null,
								(* else: flip the error switch and accept the specified value *)
								notAllowedAdaptiveIntensityThresholdError=True;adaptiveIntensityThreshold
							];

							(* resolve SamplingCoordinates *)

							(* is SamplingCoordinates Null? *)
							resolvedSamplingCoordinate=If[NullQ[samplingCoordinates],
								(* flip the error switch *)
								unspecifiedSamplingCoordinatesError=True;samplingCoordinates,

								(* else: is SamplingPattern SinglePoint? *)
								If[MatchQ[resolvedSamplingPattern,SinglePoint],
									(* is SamplingCoordinates specified? *)
									If[MatchQ[samplingCoordinates,Automatic],
										(* set to {0,0} *)
										{{0. Micrometer,0. Micrometer}},
										(* else: is it {0,0}? *)
										If[MatchQ[samplingCoordinates,{{EqualP[0. Micrometer],EqualP[0. Micrometer]}}],
											(* return the specified value *)
											samplingCoordinates,
											(* else: flip the error switch *)
											invalidSamplingCoordinatesError=True;samplingCoordinates
										]
									],

									(* else: SamplingPattern is Coordinates *)
									Module[{containerFootprint,wellSizeX,wellSizeY,wellDiameter,wellDimensions,
										resCoordinates,unitlessSamplingCoordinates,validCoordinatesQs},

										(* get the footprint of our first container model in this pool *)
										containerFootprint=Lookup[First@sampleContainerModelPackets,Footprint];

										(* get the well size of our container *)
										{wellSizeX,wellSizeY}=Switch[Lookup[First@sampleContainerPackets,Type],
											(* container is a plate *)
											Object[Container,Plate],
											(
												(* get well diameter and dimensions *)
												{wellDiameter,wellDimensions}=Lookup[First@sampleContainerModelPackets,{WellDiameter,WellDimensions}];
												(* convert well diameter or dimensions to micrometer and strip off unit *)
												If[NullQ[wellDiameter],
													(* our well is rectangular *)
													Rationalize@Unitless[wellDimensions,Micrometer],
													(* else: our well is circular *)
													Rationalize@Unitless[{wellDiameter,wellDiameter},Micrometer]
												]
											),

											(* container is a hemocytometer. lookup counting grid dimensions *)
											Object[Container,Hemocytometer],
											(* convert grid dimensions to micrometer and strip off unit *)
											Rationalize@Unitless[Lookup[First@sampleContainerModelPackets,GridDimensions],Micrometer],

											(* TODO: container is a slide. will need to revise once slide is online *)
											(* TODO: download fields SamplePositions and SamplePositionPlotting from container OBJECT to resolve coordinates or perform check *)
											Object[Container,MicroscopeSlide],
											(* is sample region specified in the first container OBJECT ? *)
											If[NullQ[Lookup[First@sampleContainerPackets,SampleRegionDimensions]],
												(* if sample region is not populated, use the slide dimensions from the model *)
												(* TODO: this should be changed to slide's center square (or possible sample area excluding the frosted zone) dimensions instead so it's not too large and won't get too close to edges. we need to define default dimensions for this and store in slide model *)
												Most@Lookup[First@sampleContainerModelPackets,Dimensions],
												(* else: use the sample region. should be in {x,y} format already *)
												Lookup[First@sampleContainerPackets,SampleRegionDimensions]
											],

											(* type other than above, set each to Null. error would have been thrown already *)
											_,{Null,Null}
										];

										(* TODO: may need to update if imaging hemocytometer in Coordinates *)
										(* check if our container is either plate or slide *)
										If[MatchQ[containerFootprint,Plate|MicroscopeSlide],
											(* is SamplingCoordinates specified? *)
											If[MatchQ[samplingCoordinates,Automatic],
												(* generate 3 random sites *)
												(
													(* what is the footprint of our first container? plate or slide? *)
													resCoordinates=If[MatchQ[containerFootprint,Plate]&&!NullQ[wellDiameter],
														(* plate: find 3 random coordinates within well dimensions. well shape matters here *)
														(* else: our well is circular *)
														QuantityArray[RandomPoint[Disk[{0,0},wellSizeX/2],3],Micrometer],
														(* else: our container has rectangular or is a slide *)
														QuantityArray[RandomPoint[Rectangle[-{wellSizeX,wellSizeY}/2,{wellSizeX,wellSizeY}/2],3],Micrometer]
													];
													(* safe round and return *)
													(* TODO: shouldn't SafeRound be listable? *)
													(*SafeRound[resCoordinates,1 Micrometer]*)
													resCoordinates
												),
												(
													unitlessSamplingCoordinates=Unitless[samplingCoordinates,Micrometer];
													(* else: check if the specified coordinates fit within our well/slide dimensions *)

													validCoordinatesQs=If[MatchQ[containerFootprint,Plate]&&!NullQ[wellDiameter],
														(* our well is circular *)
														RegionMember[Disk[{0,0},wellSizeX/2],unitlessSamplingCoordinates],
														(* else: our container has rectangular or is a slide *)
														RegionMember[Rectangle[-{wellSizeX,wellSizeY}/2,{wellSizeX,wellSizeY}/2],unitlessSamplingCoordinates]
													];

													(* are all our coordinates valid? *)
													If[And@@validCoordinatesQs,
														(* accept the specified value *)
														samplingCoordinates,
														(* else: flip the error switch, collect invalid coordinates, and return specified values *)
														(
															invalidSamplingCoordinatesError=True;
															invalidCoordinates=PickList[samplingCoordinates,validCoordinatesQs,False];
															samplingCoordinates
														)
													]
												)
											],
											(* else: invalid container. resolve to {0,0} if needed. error would have been thrown already *)
											samplingCoordinates/.Automatic->{0. Micrometer,0. Micrometer}
										]
									]
								]
							]
						)
					];
				];

				(* resolve label relate options *)

				(* We don't need to give these options labels automatically, unless we're in the work cell resolver. *)
				(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
				(* labels if we have duplicates. *)

				(* resolve sample labels *)
				resolvedSampleLabel=MapThread[
					Function[{sample,specifiedSampleLabel},
						Which[
							(* if specified, return it *)
							MatchQ[specifiedSampleLabel,Except[Automatic]],
								specifiedSampleLabel,
							(* if simulation exists, lookup label from it *)
							MatchQ[simulation,SimulationP]&&MatchQ[LookupObjectLabel[simulation,sample],_String],
								LookupObjectLabel[simulation,sample],
							(* if label exists in the current lookup, return it *)
							KeyExistsQ[objectToNewResolvedLabelLookup,sample],
								Lookup[objectToNewResolvedLabelLookup,sample],
							(* if we got to this point, create a new label *)
							True,
								Module[{newLabel},
									newLabel=CreateUniqueLabel["ImageCells sample"];

									AppendTo[objectToNewResolvedLabelLookup,sample->newLabel];

									newLabel
								]
						]
					],
					{sampleObjectRefs,sampleLabels}
				];

				(* resolve sample container labels *)
				resolvedSampleContainerLabel=MapThread[
					Function[{sampleContainer,specifiedSampleContainerLabel},
						Which[
							(* if specified, return it *)
							MatchQ[specifiedSampleContainerLabel,Except[Automatic]],
								specifiedSampleContainerLabel,
							(* if simulation exists, lookup label from it *)
							MatchQ[simulation,SimulationP]&&MatchQ[LookupObjectLabel[simulation,sampleContainer],_String],
								LookupObjectLabel[simulation,sampleContainer],
							(* if label exists in the current lookup, return it *)
							KeyExistsQ[objectToNewResolvedLabelLookup,sampleContainer],
								Lookup[objectToNewResolvedLabelLookup,sampleContainer],
							(* if we got to this point, create a new label *)
							True,
								Module[{newLabel},
									newLabel=CreateUniqueLabel["ImageCells container"];

									AppendTo[objectToNewResolvedLabelLookup,sampleContainer->newLabel];

									newLabel
								]
						]
					],
					{Lookup[sampleContainerPackets,Object],sampleContainerLabels}
				];

				(*Return the error-tracking variables and resolved option values*)
				{
					samplesWithIncompatibleContainer,
					samplesWithInvalidWellBottom,
					allCoordinatesInWell,
					usableCoordinatesInWell,
					Lookup[objectiveModelPacketToUse,Object],
					maxAllowedZ,
					totalImagingSites,
					invalidCoordinates,

					(*Error-tracking variables*)
					(*1*)mismatchedContainersError,
					(*2*)incompatibleContainerError,
					(*3*)opaqueWellBottomError,
					(*4*)invalidContainerOrientationError,
					(*5*)coverslipThicknessMismatchWarning,
					(*6*)invalidCoverslipThicknessError,
					(*7*)negativePlateBottomThicknessError,
					(*8*)plateBottomThicknessMismatchWarning,
					(*9*)invalidPlateBottomThicknessError,
					(*10*)unsupportedObjectiveMagnificationError,
					(*11*)unsupportedPixelbinningError,
					(*12*)notAllowedTimelapseIntervalError,
					(*13*)notAllowedTimelapseDurationError,
					(*14*)notAllowedNumberOfTimepointsError,
					(*15*)notAllowedContinuousTimelapseImagingError,
					(*16*)notAllowedTimelapseAcquisitionOrderError,
					(*17*)unsupportedTimelapseImagingError,
					(*18*)invalidTimelapseDefinitionError,
					(*19*)invalidContinuousTimelapseImagingError,
					(*20*)unsupportedZStackImagingError,
					(*21*)invalidZStackDefinitionError,
					(*22*)notAllowedZStepSizeError,
					(*23*)notAllowedNumberOfZStepsError,
					(*24*)notAllowedZStackSpanError,
					(*25*)invalidZStackSpanError,
					(*26*)invalidZStepSizeNumberOfZStepsError,
					(*27*)invalidZStepSizeError,
					(*28*)acquirePrimitiveResolverError,
					(*29*)invalidAdjustmentSampleError,
					(*30*)unsupportedSamplingPatternError,
					(*31*)notAllowedSamplingCoordinatesError,
					(*32*)rowSpacingNotAllowedError,
					(*33*)samplingRowSpacingNotSpecifiedError,
					(*34*)columnSpacingNotAllowedError,
					(*35*)samplingColumnSpacingNotSpecifiedError,
					(*36*)gridDefinedAsSinglePointError,
					(*37*)cannotDetermineImagingSitesError,
					(*38*)invalidGridDefinitionError,
					(*39*)invalidAdaptiveExcitationWaveLengthError,
					(*40*)adaptiveWavelengthOrderWarning,
					(*41*)unspecifiedAdaptiveNumberOfCellsError,
					(*42*)unspecifiedAdaptiveMinNumberOfImagesError,
					(*43*)tooManyAdaptiveImagingSitesError,
					(*44*)unspecifiedAdaptiveCellWidthError,
					(*45*)unspecifiedAdaptiveIntensityThresholdError,
					(*46*)invalidAdaptiveIntensityThresholdError,
					(*47*)notAllowedAdaptiveExcitationWaveLengthError,
					(*48*)notAllowedAdaptiveNumberOfCellsError,
					(*49*)notAllowedAdaptiveMinNumberOfImagesError,
					(*50*)notAllowedAdaptiveCellWidthError,
					(*51*)notAllowedAdaptiveIntensityThresholdError,
					(*52*)notAllowedSamplingNumberOfRowsError,
					(*53*)notAllowedSamplingNumberOfColumnsError,
					(*54*)notAllowedSamplingRowSpacingError,
					(*55*)notAllowedSamplingColumnSpacingError,
					(*56*)invalidSamplingCoordinatesError,
					(*57*)unspecifiedSamplingCoordinatesError,
					(*58*)multipleContainersAdjustmentSampleError,
					(*59*)incompatibleContainerThicknessError,

					(*Resolved option values*)
					resolvedContainerOrientation,
					resolvedCoverslipThickness,
					resolvedPlateBottomThickness,
					resolvedEquilibrationTime,
					resolvedObjectiveMagnification,
					pixelBinning,
					timelapse,
					resolvedTimelapseInterval,
					resolvedTimelapseDuration,
					resolvedNumberOfTimepoint,
					resolvedContinuousTimelapseImaging,
					resolvedTimelapseAcquisitionOrder,
					resolvedZStepSize,
					resolvedNumberOfZStep,
					resolvedZStackSpan,
					resolvedImagesOption,
					adjustmentSample,
					resolvedSamplingPattern,
					resolvedSamplingNumberOfRow,
					resolvedSamplingNumberOfColumn,
					resolvedSamplingRowSpacing,
					resolvedSamplingColumnSpacing,
					resolvedSamplingCoordinate,
					resolvedAdaptiveExcitationWaveLength,
					resolvedAdaptiveNumberOfCell,
					resolvedAdaptiveMinNumberOfImage,
					resolvedAdaptiveCellWidth,
					resolvedAdaptiveIntensityThreshold,
					resolvedSampleLabel,
					resolvedSampleContainerLabel
				}
			]
		],
		(* lists we are mapping over *)
		{pooledSimulatedSamplePackets,pooledSampleContainerPackets,pooledSampleContainerModelPackets,pooledSampleDetectionLabelPackets,
			pooledSampleIdentityModelDetectionLabelPackets,pooledSampleIdentityModelPackets,mapThreadFriendlyOptions}
	]];

	(* -------------------------------- *)
	(* ---UNRESOLVABLE OPTION CHECKS--- *)
	(* -------------------------------- *)

	(* get the pooled simulated samples *)
	pooledSimulatedSamples=TakeList[Lookup[Flatten@flatSimulatedSamplePackets,Object],poolingLengths];

	(* 1. Error::MismatchedContainers *)

	(* if there are mismatchedContainersErrors and we are throwing messages, throw an error message*)
	mismatchedContainersInvalidInputs=If[Or@@mismatchedContainersErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[mismatchedContainersErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSimulatedSamples,mismatchedContainersErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsMismatchedContainers,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid input objects *)
			invalidSamples
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	mismatchedContainersTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[mismatchedContainersErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[mismatchedContainersErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,mismatchedContainersErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,mismatchedContainersErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", are in the same container model:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", are in the same container model:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 2. Error::ImageCellsIncompatibleContainer *)

	(* if there are incompatibleContainerErrors and we are throwing messages, throw an error message*)
	incompatibleContainerInvalidInputs=If[Or@@incompatibleContainerErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[incompatibleContainerErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSamplesWithIncompatibleContainers,incompatibleContainerErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsIncompatibleContainer,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid input objects *)
			invalidSamples
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	incompatibleContainerTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[incompatibleContainerErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[incompatibleContainerErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSamplesWithIncompatibleContainers,incompatibleContainerErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,incompatibleContainerErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", are in valid containers:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", are in valid containers:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 3. Error::ImageCellsInvalidWellBottom *)

	(* if there are opaqueWellBottomErrors and we are throwing messages, throw an error message*)
	opaqueWellBottomInvalidInputs=If[Or@@opaqueWellBottomErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[opaqueWellBottomErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSamplesWithInvalidWellBottom,opaqueWellBottomErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidWellBottom,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid input objects *)
			invalidSamples
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	opaqueWellBottomTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[opaqueWellBottomErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[opaqueWellBottomErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSamplesWithInvalidWellBottom,opaqueWellBottomErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,opaqueWellBottomErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", are in containers with clear bottom:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", are in containers with clear bottom:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 4. Error::ImageCellsInvalidContainerOrientation *)

	(* if there are invalidContainerOrientationErrors and we are throwing messages, throw an error message*)
	invalidContainerOrientationOptions=If[Or@@invalidContainerOrientationErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidContainerOrientationErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSimulatedSamples,invalidContainerOrientationErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidContainerOrientation,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid options *)
			{ContainerOrientation}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidContainerOrientationTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidContainerOrientationErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidContainerOrientationErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidContainerOrientationErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidContainerOrientationErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", can be imaged with the specified ContainerOrientation option:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", can be imaged with the specified ContainerOrientation option:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 5. Warning::MismatchedCoverslipThickness *)

	(* if there are coverslipThicknessMismatchWarnings and we are throwing messages, throw a warning message*)
	If[Or@@coverslipThicknessMismatchWarnings&&messages&&notInEngine,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[coverslipThicknessMismatchWarnings,True];

			(* get the invalid samples *)
			invalidValues=PickList[resolvedCoverslipThicknesses,coverslipThicknessMismatchWarnings];

			(* throw the corresponding error *)
			Message[Warning::MismatchedCoverslipThickness,invalidIndices,invalidValues]
		]
	];

	(* if we are gathering tests, create a corresponding test *)
	mismatchedCoverslipThicknessTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[coverslipThicknessMismatchWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[coverslipThicknessMismatchWarnings,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,coverslipThicknessMismatchWarnings];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,coverslipThicknessMismatchWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The CoverslipThickness option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", matches the value in the container model:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The CoverslipThickness option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", matches the value in the container model:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 6. Error::ImageCellsInvalidCoverslipThickness *)

	(* if there are invalidCoverslipThicknessErrors and we are throwing messages, throw an error message*)
	invalidCoverslipThicknessOptions=If[Or@@invalidCoverslipThicknessErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidCoverslipThicknessErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSimulatedSamples,invalidCoverslipThicknessErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidCoverslipThickness,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid options *)
			{CoverslipThickness}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidCoverslipThicknessTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidCoverslipThicknessErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidCoverslipThicknessErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidCoverslipThicknessErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidCoverslipThicknessErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The CoverslipThickness option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when the samples are not on microscope slides:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The CoverslipThickness option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when the samples are not on microscope slides:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 7. Error::ImageCellsnegativePlateBottomThickness *)

	(* if there are negativePlateBottomThicknessErrors and we are throwing messages, throw an error message*)
	negativePlateBottomThicknessInvalidInputs=If[Or@@negativePlateBottomThicknessErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[negativePlateBottomThicknessErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSimulatedSamples,negativePlateBottomThicknessErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsNegativePlateBottomThickness,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid input objects *)
			invalidSamples
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	negativePlateBottomThicknessTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[negativePlateBottomThicknessErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[negativePlateBottomThicknessErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,negativePlateBottomThicknessErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,negativePlateBottomThicknessErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", are in containers positive calculated well bottom thickness:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", are in containers positive calculated well bottom thickness:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 8. Warning::MismatchedPlateBottomThickness *)

	(* if there are plateBottomThicknessMismatchWarnings and we are throwing messages, throw a warning message*)
	If[Or@@plateBottomThicknessMismatchWarnings&&messages&&notInEngine,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[plateBottomThicknessMismatchWarnings,True];

			(* get the invalid samples *)
			invalidValues=PickList[resolvedPlateBottomThicknesses,plateBottomThicknessMismatchWarnings];

			(* throw the corresponding error *)
			Message[Warning::MismatchedPlateBottomThickness,invalidIndices,invalidValues]
		]
	];

	(* if we are gathering tests, create a corresponding test *)
	mismatchedPlateBottomThicknessTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[plateBottomThicknessMismatchWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[plateBottomThicknessMismatchWarnings,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,plateBottomThicknessMismatchWarnings];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,plateBottomThicknessMismatchWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["The PlateBottomThickness option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", matches the value calculated from the container model:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["The PlateBottomThickness option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", matches the value calculated from the container model:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 9. Error::ImageCellsInvalidPlateBottomThickness *)

	(* if there are invalidPlateBottomThicknessErrors and we are throwing messages, throw an error message*)
	invalidPlateBottomThicknessOptions=If[Or@@invalidPlateBottomThicknessErrors&&messages,
		Module[{invalidIndices,invalidSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidPlateBottomThicknessErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSimulatedSamples,invalidPlateBottomThicknessErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidPlateBottomThickness,invalidIndices,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid options *)
			{PlateBottomThickness}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidPlateBottomThicknessTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidPlateBottomThicknessErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidPlateBottomThicknessErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidPlateBottomThicknessErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidPlateBottomThicknessErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The PlateBottomThickness option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when the samples are not in a plate:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The PlateBottomThickness option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when the samples are not in a plate:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 10. Error::ImageCellsInvalidObjectiveMagnification *)

	(* if there are unsupportedObjectiveMagnificationErrors and we are throwing messages, throw an error message*)
	invalidObjectiveMagnificationOptions=If[Or@@unsupportedObjectiveMagnificationErrors&&messages&&!noValidInstrumentError,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedObjectiveMagnificationErrors,True];

			(* get the invalid samples *)
			invalidValues=PickList[resolvedObjectiveMagnifications,unsupportedObjectiveMagnificationErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidObjectiveMagnification,
				invalidIndices,
				invalidValues,
				ObjectToString[resolvedInstrument,Cache->newCache],
				Lookup[resolvedInstrumentModelPacket,ObjectiveMagnifications]
			];

			(* return our invalid options *)
			{ObjectiveMagnification,Instrument}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidObjectiveMagnificationTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=If[noValidInstrumentError,
				{},
				Flatten@Position[unsupportedObjectiveMagnificationErrors,True]
			];

			(* get the inputs that pass this test *)
			passingIndices=If[noValidInstrumentError,
				Range[Length[pooledSimulatedSamples]],
				Flatten@Position[unsupportedObjectiveMagnificationErrors,False]
			];

			(*Get the inputs that fail this test*)
			failingSamples=If[noValidInstrumentError,
				{},
				PickList[pooledSimulatedSamples,unsupportedObjectiveMagnificationErrors]
			];

			(*Get the inputs that pass this test*)
			passingSamples=If[noValidInstrumentError,
				pooledSimulatedSamples,
				PickList[pooledSimulatedSamples,unsupportedObjectiveMagnificationErrors,False]
			];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ObjectiveMagnification option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ObjectiveMagnification option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 11. Error::ImageCellsInvalidPixelBinning *)

	(* if there are unsupportedPixelbinningErrors and we are throwing messages, throw an error message*)
	invalidPixelBinningOptions=If[Or@@unsupportedPixelbinningErrors&&messages&&!noValidInstrumentError,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedPixelbinningErrors,True];

			(* get the invalid samples *)
			invalidValues=PickList[resolvedPixelBinnings,unsupportedPixelbinningErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidPixelBinning,
				invalidIndices,
				invalidValues,
				ObjectToString[resolvedInstrument,Cache->newCache],
				Lookup[resolvedInstrumentModelPacket,PixelBinning]
			];

			(* return our invalid options *)
			{PixelBinning,Instrument}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidPixelBinningTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=If[noValidInstrumentError,
				{},
				Flatten@Position[unsupportedPixelbinningErrors,True]
			];

			(* get the inputs that pass this test *)
			passingIndices=If[noValidInstrumentError,
				Range[Length[pooledSimulatedSamples]],
				Flatten@Position[unsupportedPixelbinningErrors,False]
			];

			(*Get the inputs that fail this test*)
			failingSamples=If[noValidInstrumentError,
				{},
				PickList[pooledSimulatedSamples,unsupportedPixelbinningErrors]
			];

			(*Get the inputs that pass this test*)
			passingSamples=If[noValidInstrumentError,
				pooledSimulatedSamples,
				PickList[pooledSimulatedSamples,unsupportedPixelbinningErrors,False]
			];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The PixelBinning option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The PixelBinning option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 12. Error::ImageCellsTimelapseIntervalNotAllowed *)

	(* if there are notAllowedTimelapseIntervalErrors and we are throwing messages, throw an error message*)
	timelapseIntervalNotAllowedOptions=If[Or@@notAllowedTimelapseIntervalErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTimelapseIntervalErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsTimelapseIntervalNotAllowed,invalidIndices];

			(* return our invalid options *)
			{TimelapseInterval}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	timelapseIntervalNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTimelapseIntervalErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTimelapseIntervalErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedTimelapseIntervalErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedTimelapseIntervalErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TimelapseInterval option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when Timelapse is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TimelapseInterval option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when Timelapse is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 13. Error::ImageCellsTimelapseDurationNotAllowed *)

	(* if there are notAllowedTimelapseDurationErrors and we are throwing messages, throw an error message*)
	timelapseDurationNotAllowedOptions=If[Or@@notAllowedTimelapseDurationErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTimelapseDurationErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsTimelapseDurationNotAllowed,invalidIndices];

			(* return our invalid options *)
			{TimelapseDuration}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	timelapseDurationNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTimelapseDurationErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTimelapseDurationErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedTimelapseDurationErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedTimelapseDurationErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TimelapseDuration option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when Timelapse is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TimelapseDuration option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when Timelapse is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 14. Error::ImageCellsNumberOfTimepointsNotAllowed *)

	(* if there are notAllowedNumberOfTimepointsErrors and we are throwing messages, throw an error message*)
	numberOfTimepointsNotAllowedOptions=If[Or@@notAllowedNumberOfTimepointsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedNumberOfTimepointsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsNumberOfTimepointsNotAllowed,invalidIndices];

			(* return our invalid options *)
			{NumberOfTimepoints}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	numberOfTimepointsNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedNumberOfTimepointsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedNumberOfTimepointsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedNumberOfTimepointsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedNumberOfTimepointsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The NumberOfTimepoints option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when Timelapse is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The NumberOfTimepoints option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when Timelapse is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 15. Error::ImageCellsContinuousTimelapseImagingNotAllowed *)

	(* if there are notAllowedContinuousTimelapseImagingErrors and we are throwing messages, throw an error message*)
	continuousTimelapseImagingNotAllowedOptions=If[Or@@notAllowedContinuousTimelapseImagingErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedContinuousTimelapseImagingErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsContinuousTimelapseImagingNotAllowed,invalidIndices];

			(* return our invalid options *)
			{ContinuousTimelapseImaging}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	continuousTimelapseImagingNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedContinuousTimelapseImagingErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedContinuousTimelapseImagingErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedContinuousTimelapseImagingErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedContinuousTimelapseImagingErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ContinuousTimelapseImaging option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is not True when Timelapse is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ContinuousTimelapseImaging option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is not True when Timelapse is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 16. Error::ImageCellsTimelapseAcquisitionOrderNotAllowed *)

	(* if there are notAllowedTimelapseAcquisitionOrderErrors and we are throwing messages, throw an error message*)
	timelapseAcquisitionOrderNotAllowedOptions=If[Or@@notAllowedTimelapseAcquisitionOrderErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedTimelapseAcquisitionOrderErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsTimelapseAcquisitionOrderNotAllowed,invalidIndices];

			(* return our invalid options *)
			{TimelapseAcquisitionOrder}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	timelapseAcquisitionOrderNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedTimelapseAcquisitionOrderErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedTimelapseAcquisitionOrderErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedTimelapseAcquisitionOrderErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedTimelapseAcquisitionOrderErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The TimelapseAcquisitionOrder option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when Timelapse is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The TimelapseAcquisitionOrder option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when Timelapse is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 17. Error::ImageCellsUnsupportedTimelapseImaging *)

	(* if there are unsupportedTimelapseImagingErrors and we are throwing messages, throw an error message*)
	unsupportedTimelapseOptions=If[Or@@unsupportedTimelapseImagingErrors&&messages&&!noValidInstrumentError,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedTimelapseImagingErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsUnsupportedTimelapseImaging,invalidIndices,ObjectToString[resolvedInstrument,Cache->newCache]];

			(* return our invalid options *)
			{Timelapse,Instrument}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	unsupportedTimelapseTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=If[noValidInstrumentError,
				{},
				Flatten@Position[unsupportedTimelapseImagingErrors,True]
			];

			(* get the inputs that pass this test *)
			passingIndices=If[noValidInstrumentError,
				Range[Length[pooledSimulatedSamples]]
			];

			(*Get the inputs that fail this test*)
			failingSamples=If[noValidInstrumentError,
				{},
				PickList[pooledSimulatedSamples,unsupportedTimelapseImagingErrors]
			];

			(*Get the inputs that pass this test*)
			passingSamples=If[noValidInstrumentError,
				pooledSimulatedSamples,
				PickList[pooledSimulatedSamples,unsupportedTimelapseImagingErrors,False]
			];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If Timelapse is True for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", the instrument can perform timelapse imaging:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If Timelapse is True for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", the instrument can perform timelapse imaging:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 18. Error::ImageCellsInvalidTimelapseDefinition *)

	(* if there are invalidTimelapseDefinitionErrors and we are throwing messages, throw an error message*)
	invalidTimelapseDefinitionOptions=If[Or@@invalidTimelapseDefinitionErrors&&messages,
		Module[{invalidIndices,timelapseOptions},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidTimelapseDefinitionErrors,True];

			(* put the options affected in a list to return with message *)
			timelapseOptions={TimelapseInterval,NumberOfTimepoints,TimelapseDuration};

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidTimelapseDefinition,invalidIndices,timelapseOptions];

			(* return our invalid options *)
			timelapseOptions
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidTimelapseDefinitionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidTimelapseDefinitionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidTimelapseDefinitionErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidTimelapseDefinitionErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidTimelapseDefinitionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If Timelapse is True for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", at least one of the following options is left to be set automatically: TimelapseInterval, NumberOfTimepoints, TimelapseDuration:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If Timelapse is True for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", at least one of the following options is left to be set automatically: TimelapseInterval, NumberOfTimepoints, TimelapseDuration:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 19. Error::ImageCellsInvalidTimelapseDefinition *)

	(* if there are invalidContinuousTimelapseImagingErrors and we are throwing messages, throw an error message*)
	invalidContinuousTimelapseImagingOptions=If[Or@@invalidContinuousTimelapseImagingErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidContinuousTimelapseImagingErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidContinuousTimelapseImaging,invalidIndices];

			(* return our invalid options *)
			{ContinuousTimelapseImaging,TimelapseInterval}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidContinuousTimelapseImagingTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidContinuousTimelapseImagingErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidContinuousTimelapseImagingErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidContinuousTimelapseImagingErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidContinuousTimelapseImagingErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If ContinuousTimelapseImaging is True for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", TimelapseInterval is less than 1 Hour:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If ContinuousTimelapseImaging is True for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", TimelapseInterval is less than 1 Hour:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 20. Error::ImageCellsUnsupportedZStackImaging *)

	(* if there are unsupportedZStackImagingErrors and we are throwing messages, throw an error message*)
	unsupportedZStackOptions=If[Or@@unsupportedZStackImagingErrors&&messages&&!noValidInstrumentError,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedZStackImagingErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsUnsupportedZStackImaging,invalidIndices,ObjectToString[resolvedInstrument,Cache->newCache]];

			(* return our invalid options *)
			{ZStack,Instrument}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	unsupportedZStackTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=If[noValidInstrumentError,
				{},
				Flatten@Position[unsupportedZStackImagingErrors,True]
			];

			(* get the inputs that pass this test *)
			passingIndices=If[noValidInstrumentError,
				Range[Length[pooledSimulatedSamples]],
				Flatten@Position[unsupportedZStackImagingErrors,False]
			];

			(*Get the inputs that fail this test*)
			failingSamples=If[noValidInstrumentError,
				{},
				PickList[pooledSimulatedSamples,unsupportedZStackImagingErrors]
			];

			(*Get the inputs that pass this test*)
			passingSamples=If[noValidInstrumentError,
				pooledSimulatedSamples,
				PickList[pooledSimulatedSamples,unsupportedZStackImagingErrors,False]
			];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If ZStack is True for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", the instrument can perform z-stack imaging:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If ZStack is True for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", the instrument can perform z-stack imaging:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 21. Error::ImageCellsInvalidZStackDefinition *)

	(* if there are invalidZStackDefinitionErrors and we are throwing messages, throw an error message*)
	invalidZStackDefinitionOptions=If[Or@@invalidZStackDefinitionErrors&&messages,
		Module[{invalidIndices,zStackOptions},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidZStackDefinitionErrors,True];

			(* put the options affected in a list to return with message *)
			zStackOptions={ZStepSize,NumberOfZSteps,ZStackSpan};

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidZStackDefinition,invalidIndices,zStackOptions];

			(* return our invalid options *)
			zStackOptions
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidZStackDefinitionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidZStackDefinitionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidZStackDefinitionErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidZStackDefinitionErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidZStackDefinitionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["If ZStack is True for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", at least one of the following options is left to be set automatically: ZStepSize, NumberOfZSteps, ZStackSpan:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["If ZStack is True for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", at least one of the following options is left to be set automatically: ZStepSize, NumberOfZSteps, ZStackSpan:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 22. Error::ImageCellsZStepSizeNotAllowed *)

	(* if there are notAllowedZStepSizeErrors and we are throwing messages, throw an error message*)
	zStepSizeNotAllowedOptions=If[Or@@notAllowedZStepSizeErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedZStepSizeErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsZStepSizeNotAllowed,invalidIndices];

			(* return our invalid options *)
			{ZStack,ZStepSize}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	zStepSizeNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedZStepSizeErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedZStepSizeErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedZStepSizeErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedZStepSizeErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ZStepSize option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when ZStack is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ZStepSize option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when ZStack is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 23. Error::ImageCellsNumberOfZStepsNotAllowed *)

	(* if there are notAllowedNumberOfZStepsErrors and we are throwing messages, throw an error message*)
	numberOfZStepsNotAllowedOptions=If[Or@@notAllowedNumberOfZStepsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedNumberOfZStepsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsNumberOfZStepsNotAllowed,invalidIndices];

			(* return our invalid options *)
			{ZStack,NumberOfZSteps}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	numberOfZStepsNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedNumberOfZStepsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedNumberOfZStepsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedNumberOfZStepsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedNumberOfZStepsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The NumberOfZSteps option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when ZStack is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The NumberOfZSteps option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when ZStack is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 24. Error::ImageCellsZStackSpanNotAllowed *)

	(* if there are notAllowedZStackSpanErrors and we are throwing messages, throw an error message*)
	zStackSpanNotAllowedOptions=If[Or@@notAllowedZStackSpanErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedZStackSpanErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsZStackSpanNotAllowed,invalidIndices];

			(* return our invalid options *)
			{ZStack,ZStackSpan}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	zStackSpanNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedZStackSpanErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedZStackSpanErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedZStackSpanErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedZStackSpanErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ZStackSpan option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when ZStack is False:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ZStackSpan option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when ZStack is False:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 25. Error::ImageCellsInvalidZStackSpan *)

	(* if there are invalidZStackSpanErrors and we are throwing messages, throw an error message*)
	invalidZStackSpanOptions=If[Or@@invalidZStackSpanErrors&&messages,
		Module[{invalidIndices,invalidValues,allowedValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidZStackSpanErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedZStackSpans,invalidZStackSpanErrors];

			(* get the allowed values *)
			allowedValues=Span[-#/2,#/2]&/@PickList[maxAllowedZDistances,invalidZStackSpanErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidZStackSpan,invalidIndices,invalidValues,allowedValues];

			(* return our invalid options *)
			{ZStackSpan}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidZStackSpanTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidZStackSpanErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidZStackSpanErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidZStackSpanErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidZStackSpanErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ZStackSpan option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is within instrument's max allowed distance on the z-axis:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ZStackSpan option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is within instrument's max allowed distance on the z-axis:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 26. Error::ImageCellsInvalidZStepSizeNumberOfZSteps *)

	(* if there are invalidZStepSizeNumberOfZStepsErrors and we are throwing messages, throw an error message*)
	invalidZStepSizeNumberOfZStepsOptions=If[Or@@invalidZStepSizeNumberOfZStepsErrors&&messages,
		Module[{invalidIndices,invalidValues,allowedValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidZStepSizeNumberOfZStepsErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[Transpose[{resolvedZStepSizes,resolvedNumberOfZSteps}],invalidZStepSizeNumberOfZStepsErrors];

			(* get the allowed values *)
			allowedValues=PickList[maxAllowedZDistances,invalidZStepSizeNumberOfZStepsErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidZStepSizeNumberOfZSteps,invalidValues,invalidIndices,allowedValues];

			(* return our invalid options *)
			{ZStepSize,NumberOfZSteps}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidZStepSizeNumberOfZStepsTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidZStepSizeNumberOfZStepsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidZStepSizeNumberOfZStepsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidZStepSizeNumberOfZStepsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidZStepSizeNumberOfZStepsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The product of ZStepSize and NumberOfZSteps options specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is within instrument's max allowed distance on the z-axis:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The product of ZStepSize and NumberOfZSteps options specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is within instrument's max allowed distance on the z-axis:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 27. Error::ImageCellsInvalidZStepSize *)

	(* if there are invalidZStepSizeErrors and we are throwing messages, throw an error message*)
	invalidZStepSizeOptions=If[Or@@invalidZStepSizeErrors&&messages,
		Module[{invalidIndices,invalidValues,allowedValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidZStepSizeErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedZStepSizes,invalidZStepSizeErrors];

			(* get the allowed values *)
			allowedValues=(Last[#]-First[#])&/@PickList[resolvedZStackSpans,invalidZStepSizeErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidZStepSize,invalidIndices,invalidValues,allowedValues];

			(* return our invalid options *)
			{ZStepSize}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidZStepSizeTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidZStepSizeErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidZStepSizeErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidZStepSizeErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidZStepSizeErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The ZStepSize option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is within distance on the z-axis defined by the ZStackSpan option:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The ZStepSize option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is within distance on the z-axis defined by the ZStackSpan option:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 28. Error::ImageCellsInvalidAcquireImagePrimitive *)

	(* if there are acquirePrimitiveResolverErrors and we are throwing messages, throw an error message*)
	invalidImagesOptions=If[Or@@acquirePrimitiveResolverErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[acquirePrimitiveResolverErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedImagesOptions,acquirePrimitiveResolverErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidAcquireImagePrimitive,invalidIndices,invalidValues];

			(* return our invalid options *)
			{Images}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidImagesTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[acquirePrimitiveResolverErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[acquirePrimitiveResolverErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,acquirePrimitiveResolverErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,acquirePrimitiveResolverErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The Images option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", can be used to generate valid AcquireImage primitives:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The Images option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", can be used to generate valid AcquireImage primitives:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 29. Error::ImageCellsInvalidAdjustmentSample *)

	(* if there are multipleAdjustmentSamplesErrors and we are throwing messages, throw an error message*)
	invalidAdjustmentSampleOptions=If[Or@@invalidAdjustmentSampleErrors&&messages,
		Module[{invalidIndices,invalidAdjustmentSamples},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidAdjustmentSampleErrors,True];

			(* get the invalid adjustment sample *)
			invalidAdjustmentSamples=PickList[resolvedAdjustmentSamples,invalidAdjustmentSampleErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidAdjustmentSample,ObjectToString[invalidAdjustmentSamples,Cache->cache],invalidIndices];

			(* return our invalid options *)
			{AdjustmentSample}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidAdjustmentSampleTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidAdjustmentSampleErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidAdjustmentSampleErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidAdjustmentSampleErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidAdjustmentSampleErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The AdjustmentSample option for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is valid:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The AdjustmentSample option for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is valid:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 30. Error::ImageCellsUnsupportedSamplingPattern *)

	(* if there are unsupportedSamplingPatternErrors and we are throwing messages, throw an error message*)
	unsupportedSamplingPatternOptions=If[Or@@unsupportedSamplingPatternErrors&&messages&&!noValidInstrumentError,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unsupportedSamplingPatternErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedSamplingPatterns,unsupportedSamplingPatternErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsUnsupportedSamplingPattern,
				invalidIndices,
				invalidValues,
				ObjectToString[resolvedInstrument,Cache->newCache],
				Lookup[resolvedInstrumentModelPacket,SamplingMethods]
			];

			(* return our invalid options *)
			{SamplingPattern,Instrument}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	unsupportedSamplingPatternTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=If[noValidInstrumentError,
				{},
				Flatten@Position[unsupportedSamplingPatternErrors,True]
			];

			(* get the inputs that pass this test *)
			passingIndices=If[noValidInstrumentError,
				Range[Length[pooledSimulatedSamples]],
				Flatten@Position[unsupportedSamplingPatternErrors,False]
			];

			(*Get the inputs that fail this test*)
			failingSamples=If[noValidInstrumentError,
				{},
				PickList[pooledSimulatedSamples,unsupportedSamplingPatternErrors]
			];

			(*Get the inputs that pass this test*)
			passingSamples=If[noValidInstrumentError,
				pooledSimulatedSamples,
				PickList[pooledSimulatedSamples,unsupportedSamplingPatternErrors,False]
			];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The specified SamplingPattern option for the following "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is supported by the instrument:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The specified SamplingPattern option for the following "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is supported by the instrument:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 31. Error::ImageCellsSamplingCoordinatesNotAllowed *)

	(* if there are notAllowedSamplingCoordinatesErrors and we are throwing messages, throw an error message*)
	samplingCoordinatesNotAllowedOptions=If[Or@@notAllowedSamplingCoordinatesErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedSamplingCoordinatesErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingCoordinatesNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingCoordinates}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingCoordinatesNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedSamplingCoordinatesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedSamplingCoordinatesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingCoordinatesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingCoordinatesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The SamplingCoordinates option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when SamplingPattern is Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The SamplingCoordinates option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when SamplingPattern is Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 32. Error::ImageCellsSamplingRowSpacingMismatch *)

	(* if there are rowSpacingNotAllowedErrors and we are throwing messages, throw an error message*)
	samplingRowSpacingMismatchOptions=If[Or@@rowSpacingNotAllowedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[rowSpacingNotAllowedErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingRowSpacingMismatch,invalidIndices];

			(* return our invalid options *)
			{SamplingRowSpacing}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingRowSpacingMismatchTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[rowSpacingNotAllowedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[rowSpacingNotAllowedErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,rowSpacingNotAllowedErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,rowSpacingNotAllowedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The SamplingRowSpacing option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when SamplingNumberOfRows is 1:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The SamplingRowSpacing option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when SamplingNumberOfRows is 1:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 33. Error::ImageCellsSamplingRowSpacingNotSpecified *)

	(* if there are samplingRowSpacingNotSpecifiedErrors and we are throwing messages, throw an error message*)
	samplingRowSpacingNotSpecifiedOptions=If[Or@@samplingRowSpacingNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[samplingRowSpacingNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingRowSpacingNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingRowSpacing}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingRowSpacingNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[samplingRowSpacingNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[samplingRowSpacingNotSpecifiedErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,samplingRowSpacingNotSpecifiedErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,samplingRowSpacingNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The SamplingRowSpacing option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is not Null when SamplingNumberOfRows > 1:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The SamplingRowSpacing option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is not Null when SamplingNumberOfRows > 1:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 34. Error::ImageCellsSamplingColumnSpacingMismatch *)

	(* if there are columnSpacingNotAllowedErrors and we are throwing messages, throw an error message*)
	samplingColumnSpacingMismatchOptions=If[Or@@columnSpacingNotAllowedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[columnSpacingNotAllowedErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingColumnSpacingMismatch,invalidIndices];

			(* return our invalid options *)
			{SamplingColumnSpacing}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingColumnSpacingMismatchTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[columnSpacingNotAllowedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[columnSpacingNotAllowedErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,columnSpacingNotAllowedErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,columnSpacingNotAllowedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The SamplingColumnSpacing option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is Null when SamplingNumberOfColumns is 1:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The SamplingColumnSpacing option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is Null when SamplingNumberOfColumns is 1:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 35. Error::ImageCellsSamplingColumnSpacingNotSpecified *)

	(* if there are samplingColumnSpacingNotSpecifiedErrors and we are throwing messages, throw an error message*)
	samplingColumnSpacingNotSpecifiedOptions=If[Or@@samplingColumnSpacingNotSpecifiedErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[samplingColumnSpacingNotSpecifiedErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingColumnSpacingNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingColumnSpacing}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingColumnSpacingNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[samplingColumnSpacingNotSpecifiedErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[samplingColumnSpacingNotSpecifiedErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,samplingColumnSpacingNotSpecifiedErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,samplingColumnSpacingNotSpecifiedErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The SamplingColumnSpacing option specified for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", is not Null when SamplingNumberOfColumns > 1:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The SamplingColumnSpacing option specified for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", is not Null when SamplingNumberOfColumns > 1:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 36. Error::ImageCellsGridDefinedAsSinglePoint *)

	(* if there are gridDefinedAsSinglePointErrors and we are throwing messages, throw an error message*)
	gridDefinedAsSinglePointOptions=If[Or@@gridDefinedAsSinglePointErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[gridDefinedAsSinglePointErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsGridDefinedAsSinglePoint,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,SamplingNumberOfColumns,SamplingNumberOfRows}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	gridDefinedAsSinglePointTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[gridDefinedAsSinglePointErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[gridDefinedAsSinglePointErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,gridDefinedAsSinglePointErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,gridDefinedAsSinglePointErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["SamplingNumberOfColumns and SamplingNumberOfRows for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", are not 1 when SamplingPattern is Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["SamplingNumberOfColumns and SamplingNumberOfRows for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", are not 1 when SamplingPattern is Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 37. Error::ImageCellsCannotDetermineImagingSites *)

	(* if there are cannotDetermineImagingSitesErrors and we are throwing messages, throw an error message*)
	cannotDetermineImagingSitesOptions=If[Or@@cannotDetermineImagingSitesErrors&&messages,
		Module[{invalidIndices,imagingSiteOptions},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[cannotDetermineImagingSitesErrors,True];

			(* put all invalid option names in a list to throw the message *)
			imagingSiteOptions={SamplingPattern,SamplingNumberOfColumns,SamplingNumberOfRows,SamplingColumnSpacing,SamplingRowSpacing};

			(* throw the corresponding error *)
			Message[Error::ImageCellsCannotDetermineImagingSites,invalidIndices,imagingSiteOptions];

			(* return our invalid options *)
			imagingSiteOptions
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	cannotDetermineImagingSitesTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[cannotDetermineImagingSitesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[cannotDetermineImagingSitesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,cannotDetermineImagingSitesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,cannotDetermineImagingSitesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingPattern, SamplingNumberOfColumns, SamplingNumberOfRows, SamplingColumnSpacing, SamplingRowSpacingare options are not Null when SamplingPattern is Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingPattern, SamplingNumberOfColumns, SamplingNumberOfRows, SamplingColumnSpacing, SamplingRowSpacingare options are not Null when SamplingPattern is Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 38. Error::ImageCellsInvalidGridDefinition *)

	(* if there are invalidGridDefinitionErrors and we are throwing messages, throw an error message*)
	invalidGridDefinitionOptions=If[Or@@invalidGridDefinitionErrors&&messages,
		Module[{invalidIndices,invalidSamples,imagingSiteOptions},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidGridDefinitionErrors,True];

			(* get the invalid samples *)
			invalidSamples=PickList[pooledSimulatedSamples,invalidGridDefinitionErrors];

			(* put all invalid option names in a list to throw the message *)
			imagingSiteOptions={SamplingNumberOfColumns,SamplingNumberOfRows,SamplingColumnSpacing,SamplingRowSpacing};

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidGridDefinition,invalidIndices,imagingSiteOptions,ObjectToString[invalidSamples,Cache->newCache]];

			(* return our invalid options *)
			imagingSiteOptions
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidGridDefinitionTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidGridDefinitionErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidGridDefinitionErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidGridDefinitionErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidGridDefinitionErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", all calculated imaging sites fit inside each sample's container:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", all calculated imaging sites fit inside each sample's container:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 39. Error::ImageCellsGridDefinedAsSinglePoint *)

	(* if there are invalidAdaptiveExcitationWaveLengthErrors and we are throwing messages, throw an error message*)
	invalidAdaptiveExcitationWaveLengthOptions=If[Or@@invalidAdaptiveExcitationWaveLengthErrors&&messages,
		Module[{invalidIndices,invalidValues,validValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidAdaptiveExcitationWaveLengthErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedAdaptiveExcitationWaveLengths,invalidAdaptiveExcitationWaveLengthErrors];

			(* get the valid excitation wavelength we can use *)
			validValues=Function[primitiveList,
				Cases[#[ExcitationWavelength]&/@primitiveList,_Quantity]
			]/@PickList[resolvedImagesOptions,invalidAdaptiveExcitationWaveLengthErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidAdaptiveExcitationWaveLength,invalidIndices,invalidValues,validValues];

			(* return our invalid options *)
			{AdaptiveExcitationWaveLength}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidAdaptiveExcitationWaveLengthTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidAdaptiveExcitationWaveLengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidAdaptiveExcitationWaveLengthErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidAdaptiveExcitationWaveLengthErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidAdaptiveExcitationWaveLengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveExcitationWaveLength is not Null and matches one of the ExcitationWavelengths specified in Images option:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveExcitationWaveLength is not Null and matches one of the ExcitationWavelengths specified in Images option:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 40. Warning::FirstWavelengthNotUsedForAdaptive *)

	(* if there are adaptiveWavelengthOrderWarnings and we are throwing messages, throw a warning message*)
	If[Or@@adaptiveWavelengthOrderWarnings&&messages&&notInEngine,
		Module[{invalidIndices,invalidValues,validValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[adaptiveWavelengthOrderWarnings,True];

			(* get the invalid samples *)
			invalidValues=PickList[resolvedAdaptiveExcitationWaveLengths,adaptiveWavelengthOrderWarnings];

			(* get the valid excitation wavelength we can use *)
			validValues=Function[primitiveList,
				FirstCase[#[ExcitationWavelength]&/@primitiveList,_Quantity]
			]/@PickList[resolvedImagesOptions,adaptiveWavelengthOrderWarnings];

			(* throw the coerresponding error *)
			Message[Warning::FirstWavelengthNotUsedForAdaptive,invalidIndices,invalidValues,validValues]
		]
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveWavelengthOrderTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[adaptiveWavelengthOrderWarnings,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[adaptiveWavelengthOrderWarnings,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,adaptiveWavelengthOrderWarnings];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,adaptiveWavelengthOrderWarnings,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Warning["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveExcitationWaveLength matches the ExcitationWavelength of the first AcquireImage primitive in Images option:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Warning["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveExcitationWaveLength matches the ExcitationWavelength of the first AcquireImage primitive in Images option:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 41. Error::ImageCellsAdaptiveNumberOfCellsNotSpecified *)

	(* if there are unspecifiedAdaptiveNumberOfCellsErrors and we are throwing messages, throw an error message*)
	adaptiveNumberOfCellsNotSpecifiedOptions=If[Or@@unspecifiedAdaptiveNumberOfCellsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unspecifiedAdaptiveNumberOfCellsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveNumberOfCellsNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveNumberOfCells}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveNumberOfCellsNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unspecifiedAdaptiveNumberOfCellsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unspecifiedAdaptiveNumberOfCellsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveNumberOfCellsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveNumberOfCellsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveNumberOfCells is not Null when SamplingPattern is Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveNumberOfCells is not Null when SamplingPattern is Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 42. Error::ImageCellsAdaptiveMinNumberOfImagesNotSpecified *)

	(* if there are unspecifiedAdaptiveMinNumberOfImagesErrors and we are throwing messages, throw an error message*)
	adaptiveMinNumberOfImagesNotSpecifiedOptions=If[Or@@unspecifiedAdaptiveMinNumberOfImagesErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unspecifiedAdaptiveMinNumberOfImagesErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveMinNumberOfImagesNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveMinNumberOfImages}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveMinNumberOfImagesNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unspecifiedAdaptiveMinNumberOfImagesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unspecifiedAdaptiveMinNumberOfImagesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveMinNumberOfImagesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveMinNumberOfImagesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveMinNumberOfImages is not Null when SamplingPattern is Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveMinNumberOfImages is not Null when SamplingPattern is Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 43. Error::ImageCellsTooManyAdaptiveImagingSites *)

	(* if there are tooManyAdaptiveImagingSitesErrors and we are throwing messages, throw an error message*)
	tooManyAdaptiveImagingSitesOptions=If[Or@@tooManyAdaptiveImagingSitesErrors&&messages,
		Module[{invalidIndices,invalidValues,validValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[tooManyAdaptiveImagingSitesErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedAdaptiveMinNumberOfImages,tooManyAdaptiveImagingSitesErrors];

			(* get the valid values *)
			validValues=PickList[pooledTotalImagingSites,tooManyAdaptiveImagingSitesErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsTooManyAdaptiveImagingSites,invalidIndices,invalidValues,validValues];

			(* return our invalid options *)
			{AdaptiveMinNumberOfImages}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	tooManyAdaptiveImagingSitesTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[tooManyAdaptiveImagingSitesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[tooManyAdaptiveImagingSitesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,tooManyAdaptiveImagingSitesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,tooManyAdaptiveImagingSitesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveMinNumberOfImages does not exceed total imageable sites of each sample:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveMinNumberOfImages does not exceed total imageable sites of each sample:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 44. Error::ImageCellsAdaptiveCellWidthNotSpecified *)

	(* if there are unspecifiedAdaptiveCellWidthErrors and we are throwing messages, throw an error message*)
	adaptiveCellWidthNotSpecifiedOptions=If[Or@@unspecifiedAdaptiveCellWidthErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unspecifiedAdaptiveCellWidthErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveCellWidthNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveCellWidth}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveCellWidthNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unspecifiedAdaptiveCellWidthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unspecifiedAdaptiveCellWidthErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveCellWidthErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveCellWidthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveCellWidth is not Null when SamplingPattern is Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveCellWidth is not Null when SamplingPattern is Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 45. Error::ImageCellsAdaptiveIntensityThresholdNotSpecified *)

	(* if there are unspecifiedAdaptiveIntensityThresholdErrors and we are throwing messages, throw an error message*)
	adaptiveIntensityThresholdNotSpecifiedOptions=If[Or@@unspecifiedAdaptiveIntensityThresholdErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unspecifiedAdaptiveIntensityThresholdErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveIntensityThresholdNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveIntensityThreshold}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveIntensityThresholdNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unspecifiedAdaptiveIntensityThresholdErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unspecifiedAdaptiveIntensityThresholdErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveIntensityThresholdErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,unspecifiedAdaptiveIntensityThresholdErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveIntensityThreshold is not Null when SamplingPattern is Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveIntensityThreshold is not Null when SamplingPattern is Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 46. Error::ImageCellsInvalidAdaptiveIntensityThreshold *)

	(* if there are invalidAdaptiveIntensityThresholdErrors and we are throwing messages, throw an error message*)
	invalidAdaptiveIntensityThresholdOptions=If[Or@@invalidAdaptiveIntensityThresholdErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidAdaptiveIntensityThresholdErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[resolvedAdaptiveIntensityThresholds,invalidAdaptiveIntensityThresholdErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidAdaptiveIntensityThreshold,invalidIndices,invalidValues,Lookup[resolvedInstrumentModelPacket,MaxGrayLevel]];

			(* return our invalid options *)
			{AdaptiveIntensityThreshold}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidAdaptiveIntensityThresholdTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidAdaptiveIntensityThresholdErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidAdaptiveIntensityThresholdErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidAdaptiveIntensityThresholdErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidAdaptiveIntensityThresholdErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveIntensityThreshold does not exceed the instrument's MaxGrayLevel:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveIntensityThreshold does not exceed the instrument's MaxGrayLevel:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 47. Error::ImageCellsAdaptiveExcitationWaveLengthNotAllowed *)

	(* if there are notAllowedAdaptiveExcitationWaveLengthErrors and we are throwing messages, throw an error message*)
	adaptiveExcitationWaveLengthNotAllowedOptions=If[Or@@notAllowedAdaptiveExcitationWaveLengthErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedAdaptiveExcitationWaveLengthErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveExcitationWaveLengthNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveExcitationWaveLength}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveExcitationWaveLengthNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedAdaptiveExcitationWaveLengthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedAdaptiveExcitationWaveLengthErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveExcitationWaveLengthErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveExcitationWaveLengthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveExcitationWaveLength is Null when SamplingPattern is not Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveExcitationWaveLength is Null when SamplingPattern is not Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 48. Error::ImageCellsAdaptiveNumberOfCellsNotAllowed *)

	(* if there are notAllowedAdaptiveNumberOfCellsErrors and we are throwing messages, throw an error message*)
	adaptiveNumberOfCellsNotAllowedOptions=If[Or@@notAllowedAdaptiveNumberOfCellsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedAdaptiveNumberOfCellsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveNumberOfCellsNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveNumberOfCells}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveNumberOfCellsNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedAdaptiveNumberOfCellsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedAdaptiveNumberOfCellsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveNumberOfCellsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveNumberOfCellsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveNumberOfCells is Null when SamplingPattern is not Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveNumberOfCells is Null when SamplingPattern is not Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 49. Error::ImageCellsAdaptiveMinNumberOfImagesNotAllowed *)

	(* if there are notAllowedAdaptiveMinNumberOfImagesErrors and we are throwing messages, throw an error message*)
	adaptiveMinNumberOfImagesNotAllowedOptions=If[Or@@notAllowedAdaptiveMinNumberOfImagesErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedAdaptiveMinNumberOfImagesErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveMinNumberOfImagesNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveMinNumberOfImages}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveMinNumberOfImagesNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedAdaptiveMinNumberOfImagesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedAdaptiveMinNumberOfImagesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveMinNumberOfImagesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveMinNumberOfImagesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveMinNumberOfImages is Null when SamplingPattern is not Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveMinNumberOfImages is Null when SamplingPattern is not Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 50. Error::ImageCellsAdaptiveCellWidthNotAllowed *)

	(* if there are notAllowedAdaptiveCellWidthErrors and we are throwing messages, throw an error message*)
	adaptiveCellWidthNotAllowedOptions=If[Or@@notAllowedAdaptiveCellWidthErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedAdaptiveCellWidthErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveCellWidthNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveCellWidth}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveCellWidthNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedAdaptiveCellWidthErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedAdaptiveCellWidthErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveCellWidthErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveCellWidthErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveCellWidth is Null when SamplingPattern is not Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveCellWidth is Null when SamplingPattern is not Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 51. Error::ImageCellsAdaptiveIntensityThresholdNotAllowed *)

	(* if there are notAllowedAdaptiveIntensityThresholdErrors and we are throwing messages, throw an error message*)
	adaptiveIntensityThresholdNotAllowedOptions=If[Or@@notAllowedAdaptiveIntensityThresholdErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedAdaptiveIntensityThresholdErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsAdaptiveIntensityThresholdNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,AdaptiveIntensityThreshold}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	adaptiveIntensityThresholdNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedAdaptiveIntensityThresholdErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedAdaptiveIntensityThresholdErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveIntensityThresholdErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedAdaptiveIntensityThresholdErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", AdaptiveIntensityThreshold is Null when SamplingPattern is not Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", AdaptiveIntensityThreshold is Null when SamplingPattern is not Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 52. Error::ImageCellsSamplingNumberOfRowsNotAllowed *)

	(* if there are notAllowedSamplingNumberOfRowsErrors and we are throwing messages, throw an error message*)
	samplingNumberOfRowsNotAllowedOptions=If[Or@@notAllowedSamplingNumberOfRowsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedSamplingNumberOfRowsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingNumberOfRowsNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,SamplingNumberOfRows}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingNumberOfRowsNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedSamplingNumberOfRowsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedSamplingNumberOfRowsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingNumberOfRowsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingNumberOfRowsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingNumberOfRows is Null when SamplingPattern is not Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingNumberOfRows is Null when SamplingPattern is not Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 53. Error::ImageCellsSamplingNumberOfColumnsNotAllowed *)

	(* if there are notAllowedSamplingNumberOfColumnsErrors and we are throwing messages, throw an error message*)
	samplingNumberOfColumnsNotAllowedOptions=If[Or@@notAllowedSamplingNumberOfColumnsErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedSamplingNumberOfColumnsErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingNumberOfColumnsNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,SamplingNumberOfColumns}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingNumberOfColumnsNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedSamplingNumberOfColumnsErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedSamplingNumberOfColumnsErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingNumberOfColumnsErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingNumberOfColumnsErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingNumberOfColumns is Null when SamplingPattern is not Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingNumberOfColumns is Null when SamplingPattern is not Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 54. Error::ImageCellsSamplingRowSpacingNotAllowed *)

	(* if there are notAllowedSamplingRowSpacingErrors and we are throwing messages, throw an error message*)
	samplingRowSpacingNotAllowedOptions=If[Or@@notAllowedSamplingRowSpacingErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedSamplingRowSpacingErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingRowSpacingNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,SamplingRowSpacing}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingRowSpacingNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedSamplingRowSpacingErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedSamplingRowSpacingErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingRowSpacingErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingRowSpacingErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingRowSpacing is Null when SamplingPattern is not Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingRowSpacing is Null when SamplingPattern is not Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 55. Error::ImageCellsSamplingColumnSpacingNotAllowed *)

	(* if there are notAllowedSamplingColumnSpacingErrors and we are throwing messages, throw an error message*)
	samplingColumnSpacingNotAllowedOptions=If[Or@@notAllowedSamplingColumnSpacingErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[notAllowedSamplingColumnSpacingErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingColumnSpacingNotAllowed,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,SamplingColumnSpacing}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingColumnSpacingNotAllowedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[notAllowedSamplingColumnSpacingErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[notAllowedSamplingColumnSpacingErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingColumnSpacingErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,notAllowedSamplingColumnSpacingErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingColumnSpacing is Null when SamplingPattern is not Grid or Adaptive:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingColumnSpacing is Null when SamplingPattern is not Grid or Adaptive:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 56. Error::ImageCellsInvalidSamplingCoordinates *)

	(* if there are invalidSamplingCoordinatesErrors and we are throwing messages, throw an error message*)
	invalidSamplingCoordinatesOptions=If[Or@@invalidSamplingCoordinatesErrors&&messages,
		Module[{invalidIndices,invalidValues},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[invalidSamplingCoordinatesErrors,True];

			(* get the invalid values *)
			invalidValues=PickList[invalidSamplingCoordinates,invalidSamplingCoordinatesErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsInvalidSamplingCoordinates,invalidIndices,invalidValues];

			(* return our invalid options *)
			{SamplingCoordinates}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	invalidSamplingCoordinatesTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[invalidSamplingCoordinatesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[invalidSamplingCoordinatesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,invalidSamplingCoordinatesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,invalidSamplingCoordinatesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingCoordinates are within each sample's container when SamplingPattern is Coordinates or {0 \[Mu]m,0 \[Mu]m} when SamplingPatten is SinglePoint:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingCoordinates are within each sample's container when SamplingPattern is Coordinates or {0 \[Mu]m,0 \[Mu]m} when SamplingPatten is SinglePoint:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 57. Error::ImageCellsSamplingCoordinatesNotSpecified *)

	(* if there are unspecifiedSamplingCoordinatesErrors and we are throwing messages, throw an error message*)
	samplingCoordinatesNotSpecifiedOptions=If[Or@@unspecifiedSamplingCoordinatesErrors&&messages,
		Module[{invalidIndices},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[unspecifiedSamplingCoordinatesErrors,True];

			(* throw the corresponding error *)
			Message[Error::ImageCellsSamplingCoordinatesNotSpecified,invalidIndices];

			(* return our invalid options *)
			{SamplingPattern,SamplingCoordinates}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	samplingCoordinatesNotSpecifiedTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[unspecifiedSamplingCoordinatesErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[unspecifiedSamplingCoordinatesErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,unspecifiedSamplingCoordinatesErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,unspecifiedSamplingCoordinatesErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["For the following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", SamplingCoordinates is not Null when SamplingPattern is Coordinates or SinglePoint:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["For the following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", SamplingCoordinates is not Null when SamplingPattern is Coordinates or SinglePoint:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 58. Error::ImageCellsMultipleContainersForAdjustmentSample *)

	(* if there are multipleAdjustmentSamplesErrors and we are throwing messages, throw an error message*)
	multipleContainersForAdjustmentSampleOptions=If[Or@@multipleContainersAdjustmentSampleErrors&&messages,
		Module[{invalidIndices,invalidContainerPools},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[multipleContainersAdjustmentSampleErrors,True];

			(* get the containers from each sample pool *)
			invalidContainerPools=DeleteDuplicates[Lookup[#,Object]]&/@PickList[pooledSampleContainerPackets,multipleContainersAdjustmentSampleErrors];

			(* throw the corresponding error *)
			Message[Error::ImageCellsMultipleContainersForAdjustmentSample,invalidIndices,ObjectToString[invalidContainerPools,Cache->newCache]];

			(* return our invalid options *)
			{AdjustmentSample}
		],
		{}
	];

	(* if we are gathering tests, create a corresponding test *)
	multipleContainersForAdjustmentSampleTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[multipleContainersAdjustmentSampleErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[multipleContainersAdjustmentSampleErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,multipleContainersAdjustmentSampleErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,multipleContainersAdjustmentSampleErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The AdjustmentSample option for following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", can be specified as sample because each pool contains a single sample container:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The AdjustmentSample option for following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", can be specified as sample because each pool contains a single sample container:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* 59. Error::ImageCellsIncompatibleContainerThickness *)

	(* if there are incompatibleContainerThicknessErrors and we are throwing messages, throw an error message*)
	{incompatibleContainerThicknessInputs,incompatibleContainerThicknessOptions}=If[Or@@incompatibleContainerThicknessErrors&&messages,
		Module[{invalidIndices,invalidObjectiveMagnifications,invalidWorkingDistances,invalidContainers,invalidThicknesses},
			(* get the invalid index *)
			invalidIndices=Flatten@Position[incompatibleContainerThicknessErrors,True];

			(* get the invalid objective magnifications *)
			invalidObjectiveMagnifications=PickList[resolvedObjectiveMagnifications,incompatibleContainerThicknessErrors];

			(* get the invalid working distance *)
			invalidWorkingDistances=Map[
				FirstCase[resolvedObjectiveModelPackets,KeyValuePattern[{Magnification->N[#],MaxWorkingDistance->workingDistance_}]:>workingDistance]&,
				invalidObjectiveMagnifications
			];

			(* get the containers from each sample pool *)
			invalidContainers=First@Lookup[#,Object]&/@PickList[pooledSampleContainerPackets,incompatibleContainerThicknessErrors];

			(* get the invalid container thicknesses *)
			invalidThicknesses=MapThread[
				Function[{wellThickness,coverslipThickness,errorBool},
					If[errorBool,
						(* if well thickness is Null, return coverslip thickness *)
						If[NullQ[wellThickness],coverslipThickness,wellThickness],
						Nothing
					]
				],
				{resolvedPlateBottomThicknesses,resolvedCoverslipThicknesses,incompatibleContainerThicknessErrors}
			];

			(* throw the corresponding error *)
			Message[Error::ImageCellsIncompatibleContainerThickness,
				ObjectToString[invalidContainers,Cache->newCache],
				invalidIndices,
				UnitConvert[invalidThicknesses,Millimeter],
				UnitConvert[invalidWorkingDistances,Millimeter],
				invalidObjectiveMagnifications
			];

			(* return our invalid inputs/options *)
			{invalidContainers,{ObjectiveMagnification}}
		],
		{{},{}}
	];

	(* if we are gathering tests, create a corresponding test *)
	incompatibleContainerThicknessTest=If[gatherTests,
		(* we're gathering tests. Create the appropriate tests *)
		Module[{failingIndices,passingIndices,failingSamples,passingSamples,passingTest,failingTest},
			(* get the inputs that fail this test *)
			failingIndices=Flatten@Position[incompatibleContainerThicknessErrors,True];

			(* get the inputs that pass this test *)
			passingIndices=Flatten@Position[incompatibleContainerThicknessErrors,False];

			(*Get the inputs that fail this test*)
			failingSamples=PickList[pooledSimulatedSamples,incompatibleContainerThicknessErrors];

			(*Get the inputs that pass this test*)
			passingSamples=PickList[pooledSimulatedSamples,incompatibleContainerThicknessErrors,False];

			(* create a test for the non-passing inputs *)
			failingTest=If[Length[failingIndices]>0,
				Test["The following samples "<>ObjectToString[failingSamples,Cache->newCache]<>" in pool number "<>ToString[failingIndices]<>", are in containers with thickness compatible with the objective working distance:",True,False],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingTest=If[Length[passingIndices]>0,
				Test["The following samples "<>ObjectToString[passingSamples,Cache->newCache]<>" in pool number "<>ToString[passingIndices]<>", are in containers with thickness compatible with the objective working distance:",True,True],
				Nothing
			];

			(* return our created tests *)
			{passingTest,failingTest}
		],
		(* else: we aren't gathering tests. no tests to create *)
		{}
	];

	(* ---Resolve aliquot options--- *)
	(* TODO: may need to revise. right now we don't want to flip Aliquot to True every time we have pooled inputs unless we really need to *)
	(* potential issue: when Aliquot is actually required, pooled samples input will be aliquotted into the same destination well *)
	(* may need to define aliquot options with NestedIndexMatching->True for all options to get around this *)
	(* work around: pre-resolve AliquotDestinationWell here such that each source sample goes to different destination well *)

	(*Resolve RequiredAliquotContainers*)
	targetContainers=Null;

	(* Importantly: Remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver. *)
	resolveSamplePrepOptionsWithoutAliquot=First[splitPrepOptions[resolvedSamplePrepOptions,PrepOptionSets->{IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew}]];

	(* Separate out our raw aliquot options *)
	rawAliquotOption=First@splitPrepOptions[myOptions,PrepOptionSets->AliquotOptions];

	(* Resolve aliquot options and make tests if needed *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		(* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
		resolveAliquotOptions[
			ExperimentImageCells,
			myPooledSamples,
			simulatedSamples,
			ReplaceRule[myOptions,Flatten[{resolveSamplePrepOptionsWithoutAliquot,rawAliquotOption}]],
			Cache->newCache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->Null,
			AllowPoolsWithoutAliquot->True,
			Output->{Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentImageCells,
				myPooledSamples,
				simulatedSamples,
				ReplaceRule[myOptions,Flatten[{resolveSamplePrepOptionsWithoutAliquot,rawAliquotOption}]],
				Cache->newCache,
				Simulation->updatedSimulation,
				RequiredAliquotContainers->targetContainers,
				RequiredAliquotAmounts->Null,
				AllowPoolsWithoutAliquot->True,
				Output->Result],
			{}
		}
	];

	(* ---resolve Post Processing Options--- *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions,Living->True];

	(* ---resolve Email--- *)
	(* True if it's a parent protocol, and False if it's a subprotocol*)
	{emailOption,parentProtocolOption}=Lookup[roundedImageCellsOptions,{Email,ParentProtocol}];
	resolvedEmail=Which[
		MatchQ[emailOption,Automatic]&&NullQ[parentProtocolOption],True,
		MatchQ[emailOption,Automatic]&&MatchQ[parentProtocolOption,ObjectP[ProtocolTypes[]]],False,
		True,emailOption
	];

	(* ---resolve ImageSample option--- *)
	(* resolve ImageSample option; for this experiment, the default is False *)
	imageSampleOption=Lookup[roundedImageCellsOptions,ImageSample];
	resolvedImageSample=If[MatchQ[imageSampleOption,Automatic],
		False,
		imageSampleOption
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		discardedInvalidInputs,mismatchedContainersInvalidInputs,incompatibleContainerInvalidInputs,
		opaqueWellBottomInvalidInputs,negativePlateBottomThicknessInvalidInputs,
		incompatibleContainerThicknessInputs
	}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		nameInvalidOptions,instrumentNotFoundTestOptions,orientationInvalidOptions,cultureHandlingInvalidOptions,invalidInstrumentStatusOption,
		calibrationNotAllowedOptions, mismatchedCalibrationOptions,microscopeCalibrationNotFoundOptions,invalidCalibrationTargetOptions,
		invalidTemperatureOptions,invalidCarbonDioxideOptions,carbonDioxideMismatchOptions,invalidContainerOrientationOptions,
		invalidCoverslipThicknessOptions,invalidPlateBottomThicknessOptions,invalidObjectiveMagnificationOptions,
		invalidPixelBinningOptions,timelapseIntervalNotAllowedOptions,timelapseDurationNotAllowedOptions,
		numberOfTimepointsNotAllowedOptions,continuousTimelapseImagingNotAllowedOptions,timelapseAcquisitionOrderNotAllowedOptions,
		unsupportedTimelapseOptions,invalidTimelapseDefinitionOptions,invalidContinuousTimelapseImagingOptions,unsupportedZStackOptions,
		invalidZStackDefinitionOptions,zStepSizeNotAllowedOptions,numberOfZStepsNotAllowedOptions,zStackSpanNotAllowedOptions,
		invalidZStackSpanOptions,invalidZStepSizeNumberOfZStepsOptions,invalidZStepSizeOptions,invalidImagesOptions,
		invalidAdjustmentSampleOptions,unsupportedSamplingPatternOptions,samplingCoordinatesNotAllowedOptions,
		samplingRowSpacingMismatchOptions,samplingRowSpacingNotSpecifiedOptions,samplingColumnSpacingMismatchOptions,
		samplingColumnSpacingNotSpecifiedOptions,gridDefinedAsSinglePointOptions,cannotDetermineImagingSitesOptions,
		invalidGridDefinitionOptions,invalidAdaptiveExcitationWaveLengthOptions,adaptiveNumberOfCellsNotSpecifiedOptions,
		adaptiveMinNumberOfImagesNotSpecifiedOptions,tooManyAdaptiveImagingSitesOptions,adaptiveCellWidthNotSpecifiedOptions,
		adaptiveIntensityThresholdNotSpecifiedOptions,invalidAdaptiveIntensityThresholdOptions,adaptiveExcitationWaveLengthNotAllowedOptions,
		adaptiveNumberOfCellsNotAllowedOptions,adaptiveMinNumberOfImagesNotAllowedOptions,adaptiveCellWidthNotAllowedOptions,
		adaptiveIntensityThresholdNotAllowedOptions,samplingNumberOfRowsNotAllowedOptions,samplingNumberOfColumnsNotAllowedOptions,
		samplingRowSpacingNotAllowedOptions,samplingColumnSpacingNotAllowedOptions,invalidSamplingCoordinatesOptions,
		samplingCoordinatesNotSpecifiedOptions,multipleContainersForAdjustmentSampleOptions,incompatibleContainerThicknessOptions,
		If[MatchQ[preparationResult,$Failed],{Preparation},{}],
		(* For experiments that teh developer marks the post processing samples as Living -> True, we need to add potential failing options to invalidOptions list in order to properly fail the resolver *)
		If[MemberQ[Values[resolvedPostProcessingOptions],$Failed],
			PickList[Keys[resolvedPostProcessingOptions],Values[resolvedPostProcessingOptions],$Failed],
			Nothing]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->newCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* ---------------------- *)
	(* ---GATHER ALL TESTS--- *)
	(* ---------------------- *)

	(* gather all the tests together *)
	allTests=Cases[Flatten[{
		discardedTest,precisionTests,validNameTest,instrumentNotFoundTest,instrumentOrientationMismatchTest,instrumentCultureHandlingMismatchTest,
		invalidInstrumentStatusTest, calibrationNotAllowedTest,mismatchedCalibrationOptionsTest,microscopeCalibrationNotFoundTest,invalidCalibrationTargetTest,
		invalidTemperatureTest,invalidCarbonDioxideTest,carbonDioxideMismatchTest,mismatchedContainersTest,
		incompatibleContainerTest,opaqueWellBottomTest,invalidContainerOrientationTest,mismatchedCoverslipThicknessTest,
		invalidCoverslipThicknessTest,negativePlateBottomThicknessTest,mismatchedPlateBottomThicknessTest,invalidPlateBottomThicknessTest,
		invalidObjectiveMagnificationTest,invalidPixelBinningTest,timelapseIntervalNotAllowedTest,timelapseDurationNotAllowedTest,
		numberOfTimepointsNotAllowedTest,continuousTimelapseImagingNotAllowedTest,timelapseAcquisitionOrderNotAllowedTest,
		unsupportedTimelapseTest,invalidTimelapseDefinitionTest,invalidContinuousTimelapseImagingTest,unsupportedZStackTest,
		invalidZStackDefinitionTest,zStepSizeNotAllowedTest,numberOfZStepsNotAllowedTest,zStackSpanNotAllowedTest,
		invalidZStackSpanTest,invalidZStepSizeNumberOfZStepsTest,invalidZStepSizeTest,invalidImagesTest,invalidAdjustmentSampleTest,
		unsupportedSamplingPatternTest,samplingCoordinatesNotAllowedTest,samplingRowSpacingMismatchTest,
		samplingRowSpacingNotSpecifiedTest,samplingColumnSpacingMismatchTest,samplingColumnSpacingNotSpecifiedTest,
		gridDefinedAsSinglePointTest,cannotDetermineImagingSitesTest,invalidGridDefinitionTest,invalidAdaptiveExcitationWaveLengthTest,
		adaptiveWavelengthOrderTest,adaptiveNumberOfCellsNotSpecifiedTest,adaptiveMinNumberOfImagesNotSpecifiedTest,
		tooManyAdaptiveImagingSitesTest,adaptiveCellWidthNotSpecifiedTest,adaptiveIntensityThresholdNotSpecifiedTest,
		invalidAdaptiveIntensityThresholdTest,adaptiveExcitationWaveLengthNotAllowedTest,adaptiveNumberOfCellsNotAllowedTest,
		adaptiveMinNumberOfImagesNotAllowedTest,adaptiveCellWidthNotAllowedTest,adaptiveIntensityThresholdNotAllowedTest,
		samplingNumberOfRowsNotAllowedTest,samplingNumberOfColumnsNotAllowedTest,samplingRowSpacingNotAllowedTest,
		samplingColumnSpacingNotAllowedTest,invalidSamplingCoordinatesTest,samplingCoordinatesNotSpecifiedTest,
		preparationTest,multipleContainersForAdjustmentSampleTest,incompatibleContainerThicknessTest,
		If[gatherTests,
			postProcessingTests[resolvedPostProcessingOptions],
			Nothing
		]
	}],_EmeraldTest];

	(* ------------------------ *)
	(* ---GATHER ALL OPTIONS--- *)
	(* ------------------------ *)

	(*Gather the resolved options (pre-collapsed; that is happening outside the function)*)
	resolvedOptions=ReplaceRule[Normal[roundedImageCellsOptions],
		Flatten[{
			Preparation->resolvedPreparation,
			WorkCell->resolvedWorkCell,
			SampleLabel->resolvedSampleLabels,
			SampleContainerLabel->resolvedSampleContainerLabels,
			Instrument->resolvedInstrument,
			Name->nameOption,
			MicroscopeOrientation->resolvedMicroscopeOrientation,
			ReCalibrateMicroscope->recalibrateBool,
			MicroscopeCalibration->resolvedMicroscopeCalibrationOption,
			Temperature->temperatureOption,
			CarbonDioxide->carbonDioxideBool,
			CarbonDioxidePercentage->resolvedCO2PercentOption,
			ContainerOrientation->resolvedContainerOrientations,
			CoverslipThickness->resolvedCoverslipThicknesses,
			PlateBottomThickness->resolvedPlateBottomThicknesses,
			ObjectiveMagnification->resolvedObjectiveMagnifications,
			EquilibrationTime->resolvedEquilibrationTimes,
			PixelBinning->resolvedPixelBinnings,
			Timelapse->resolvedTimelapses,
			TimelapseInterval->resolvedTimelapseIntervals,
			TimelapseDuration->resolvedTimelapseDurations,
			NumberOfTimepoints->resolvedNumberOfTimepoints,
			ContinuousTimelapseImaging->resolvedContinuousTimelapseImagings,
			TimelapseAcquisitionOrder->resolvedTimelapseAcquisitionOrders,
			ZStepSize->resolvedZStepSizes,
			NumberOfZSteps->resolvedNumberOfZSteps,
			ZStackSpan->resolvedZStackSpans,
			Images->resolvedImagesOptions,
			AdjustmentSample->resolvedAdjustmentSamples,
			SamplingPattern->resolvedSamplingPatterns,
			SamplingNumberOfRows->resolvedSamplingNumberOfRows,
			SamplingNumberOfColumns->resolvedSamplingNumberOfColumns,
			SamplingRowSpacing->resolvedSamplingRowSpacings,
			SamplingColumnSpacing->resolvedSamplingColumnSpacings,
			SamplingCoordinates->resolvedSamplingCoordinates,
			AdaptiveExcitationWaveLength->resolvedAdaptiveExcitationWaveLengths,
			AdaptiveNumberOfCells->resolvedAdaptiveNumberOfCells,
			AdaptiveMinNumberOfImages->resolvedAdaptiveMinNumberOfImages,
			AdaptiveCellWidth->resolvedAdaptiveCellWidths,
			AdaptiveIntensityThreshold->resolvedAdaptiveIntensityThresholds,
			Email->resolvedEmail,
			ImageSample->resolvedImageSample,

			(* hidden options to pass to resource packets *)
			AllImagingSiteCoordinates->Replace[allCoordinatesInWells,Except[_List]->Null,1],
			UsableImagingSiteCoordinates->Replace[usableCoordinatesInWells,Except[_List]->Null,1],

			(*Shared options*)
			resolveSamplePrepOptionsWithoutAliquot,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		}]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->resolvedOptions,
		Tests->allTests
	}
];


(* ::Subsubsection:: *)
(*imageCellsResourcePackets*)


DefineOptions[experimentImageCellsResourcePackets,
	Options:>{
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];


experimentImageCellsResourcePackets[
	myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[]
]:=Module[
	{
		expandedResolvedOptions,unresolvedOptionsNoHidden,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,
		messages,cache,simulation,expandedAliquotVolume,sampleResourceReplaceRules,samplesInResources,instrument,instrumentTime,
		tempEqulibrateTime,instrumentResource,protocolPacket,allResourceBlobs,rawResourceBlobs,resourcesWithoutName,
		simulatedSamples,updatedSimulation,flatSimulatedSamples,allSlideAdapterModels,containerPackets,containerModelPackets,
		adapterPackets,instrumentModelPacket,newCache,poolingLengths,pooledSimulatedContainers,samplesRequiredVolumes,
		samplesInVolumeRules,uniqueSamplesInAndVolumesAssoc,uniqueContainersIn,slideImagingQ,slideAdapterResource,instrumentDownloadPacket,
		orderedPooledContainers,nestedPooledSamples,nestedAdjustmentSampleOption,mapFriendlyPooledOptions,nestedBatchedImagingParameters,
		batchedImagingParameters,containerModelsWithoutPrefix,calibrationPrimitives,originalSamplePackets,originalContainers,
		flatOriginalSamples,pooledSampleIndexes,nestedPooledSampleIndexes,batchedContainerIndexes,simulatedSamplePackets,
		resolvedPreparation,unitOperationPackets,resourcesOk,resourceTests,resourceToNameReplaceRules,containersInResourceLookup,
		batchedImageCellsPrimitives
	},

	(* expand the resolved options if they weren't expanded already *)
	(* ImageCells does not support NumberOfReplicates and ExpandIndexMatchedInputs does not work for some options.. *)
	(* .. so we use expandNumberOfReplicates with NumberOfReplicates -> Null *)
	expandedResolvedOptions=Last@expandNumberOfReplicates[ExperimentImageCells,myPooledSamples,ReplaceRule[myResolvedOptions,NumberOfReplicates->Null]];

	(*Get the collapsed unresolved index-matching options that don't include hidden options*)
	unresolvedOptionsNoHidden=RemoveHiddenOptions[ExperimentImageCells,myUnresolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentImageCells,
		RemoveHiddenOptions[ExperimentImageCells,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myOptions],Cache];
	simulation=Lookup[ToList[myOptions],Simulation];

	(* Lookup the Preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions,Preparation];

	(* Get our simulated samples (we have to figure out slide adapter from simulated sample) *)
	{simulatedSamples,updatedSimulation}=simulateSamplesResourcePacketsNew[ExperimentImageCells,myPooledSamples,myResolvedOptions,Cache->cache,Simulation->simulation];

	(* flatten list of input samples *)
	flatSimulatedSamples=Flatten[simulatedSamples];

	(* get all possible slide adapter models that we may need *)
	allSlideAdapterModels=Search[Model[Container,Rack],Footprint==Plate&&Field[Positions[[Footprint]]]==MicroscopeSlide&&Deprecated==(False|Null)&&DeveloperObject!=True];

	(* get our instrument option *)
	instrument=Lookup[myResolvedOptions,Instrument];

	(* get fields to download from our instrument based on its type *)
	instrumentDownloadPacket=If[MatchQ[instrument,ObjectReferenceP[Object[Instrument]]],
		Packet[Model[{Positions,HighContentImaging}]],
		Packet[Positions,HighContentImaging]
	];

	(* get a list of flattened pooled samples *)
	flatOriginalSamples=Flatten[Download[myPooledSamples,Object]];

	(* -------------------------------------- *)
	(* --- Make our one big Download call --- *)
	(* -------------------------------------- *)

	(* note: we download container object and model fields from our SIMULATED samples to determine adapters and batching *)
	{
		originalSamplePackets,
		originalContainers,
		simulatedSamplePackets,
		containerPackets,
		containerModelPackets,
		adapterPackets,
		{instrumentModelPacket}
	}=Flatten/@Quiet[Download[
		{
			flatOriginalSamples,
			flatOriginalSamples,
			flatSimulatedSamples,
			flatSimulatedSamples,
			flatSimulatedSamples,
			allSlideAdapterModels,
			{instrument}
		},
		{
			{Packet[Container]},
			{Container[Object]},
			{Packet[Container]},
			{Packet[Container[Model]]},
			{Packet[Container[Model[{Dimensions,Footprint,PlateFootprintAdapters,MetaXpressPrefix,AllowedPositions,RecommendedFillVolume,MinVolume,NumberOfWells,AspectRatio}]]]},
			{Packet[Dimensions,Footprint]},
			{instrumentDownloadPacket}
		},
		Cache->cache,
		Simulation->updatedSimulation
	],Download::FieldDoesntExist];

	(* Flatten our simulated information so that we can fetch it from cache. *)
	newCache=FlattenCachePackets[{cache,originalSamplePackets,containerPackets,containerModelPackets,adapterPackets}];

	(* get the number of samples in each pool for bringing back the nested form of simulatedSamples *)
	poolingLengths=Length/@simulatedSamples;

	(* ------------------------------------------------------- *)
	(* --- Make all the resources needed in the experiment --- *)
	(* ------------------------------------------------------- *)

	(* -- Generate resources for SamplesIn -- *)

	(* pull out the AliquotAmount option *)
	expandedAliquotVolume=Lookup[myResolvedOptions,AliquotAmount];

	(* get the amount required of each sample *)
	samplesRequiredVolumes=Map[
		If[VolumeQ[#],#,Null]&,
		Flatten[expandedAliquotVolume]
	];

	(* generate sample volume rules by pairing the samples with their volumes determined above*)
	samplesInVolumeRules=Rule@@@Transpose[{Flatten[myPooledSamples],samplesRequiredVolumes}];

	(* merge any entries with duplicate keys, totaling the values *)
	uniqueSamplesInAndVolumesAssoc=Merge[samplesInVolumeRules,If[NullQ[#],Null,Total[DeleteCases[#,Null]]]&];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules=KeyValueMap[
		Function[{sample,volume},
			If[VolumeQ[volume],
				sample->Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume],
				sample->Resource[Sample->sample,Name->ToString[Unique[]]]
			]
		],
		uniqueSamplesInAndVolumesAssoc
	];

	(* replace our input samples with resource blob *)
	samplesInResources=Flatten[myPooledSamples]/.sampleResourceReplaceRules;

	(* -- Generate resources for slide adapters -- *)

	(* create a list of unique sample containers *)
	uniqueContainersIn=DeleteDuplicates@Flatten[originalContainers];

	(*create resource lookup for our sample containers*)
	containersInResourceLookup=Map[
		(#->Resource[Sample->#,Name->ToString[Unique[]]])&,
		uniqueContainersIn
	];

	(* create a list of pooled containersIn *)
	pooledSimulatedContainers=TakeList[Lookup[containerPackets,Object],poolingLengths];

	(* check if we need to make a resource for slide adapter *)
	slideImagingQ=MemberQ[Lookup[containerModelPackets,Footprint],MicroscopeSlide];

	(* if slideImagingQ is True make a resource for adapter *)
	slideAdapterResource=If[slideImagingQ,
		Module[{adapterModels,expandedInstruments,cfqResult,canUseAdapterModels},

			(* get the adapter rack models *)
			adapterModels=Lookup[adapterPackets,Object];

			(* expand instrument model to pass to CompatibleFootprintQ *)
			expandedInstruments=ConstantArray[{Lookup[instrumentModelPacket,Object]},Length[adapterModels]];

			(* call CompatibleFootprintQ with all available slide adapters *)
			cfqResult=CompatibleFootprintQ[expandedInstruments,adapterModels,Position->"Sample Slot",Cache->newCache,Output->Boolean,ExactMatch->False];

			(* pick on the adapter model that we can use with our instrument *)
			(* CFQ gives some weird format results. may need to revise this part *)
			canUseAdapterModels=PickList[adapterModels,Flatten[ToList[cfqResult]]];

			(* make resource *)
			(* note: we cannot specify >1 models under Sample key so just pick the first one *)
			Resource[Sample->First@canUseAdapterModels,Name->ToString[Unique[]]]
		]
	];

	(* -------------------------------------- *)
	(* --- Build BatchedImagingParameters --- *)
	(* -------------------------------------- *)

	(* build a list of original pooled sample indexes *)
	pooledSampleIndexes=TakeList[Range[Length[flatOriginalSamples]],poolingLengths];

	(* map over our pooled samples and their container OBJECT and reorder samples within each pool based on their container *)
	{orderedPooledContainers,nestedPooledSamples,nestedPooledSampleIndexes,nestedAdjustmentSampleOption}=Transpose@MapThread[
		Function[{myContainerPool,mySamplePool,mySampleIndexes,adjustmentSampleOption},
			Module[{sampleContainerTuples,containerSamplesIndexTuples,optionContainerTuples,groupedSamplesAssoc,groupedIndexesAssoc,groupedOptionAssoc},
				(* create a list of tuples in the form {container,sample} *)
				sampleContainerTuples=Transpose[{myContainerPool,mySamplePool}];
				(* create a list of tuples in the form {container,index} *)
				containerSamplesIndexTuples=Transpose[{myContainerPool,mySampleIndexes}];
				(* create a list of tuples in the form {container,option} *)
				optionContainerTuples=Table[{myContainer,adjustmentSampleOption},{myContainer,myContainerPool}];
				(* group the samples by their containers *)
				groupedSamplesAssoc=GroupBy[sampleContainerTuples,First->Last];
				(* group the samples' indexes by samples' containers *)
				groupedIndexesAssoc=GroupBy[containerSamplesIndexTuples,First->Last];
				(* group the option by the sample's containers *)
				groupedOptionAssoc=GroupBy[optionContainerTuples,First->Last];
				(* return list of re-ordered samples and containers *)
				{Keys[groupedSamplesAssoc],Values[groupedSamplesAssoc],Values[groupedIndexesAssoc],Values[groupedOptionAssoc]}
			]
		],
		{pooledSimulatedContainers,myPooledSamples,pooledSampleIndexes,Lookup[expandedResolvedOptions,AdjustmentSample]}
	];

	(* convert all options index-matched to pooled samples to a map-friendly version *)
	mapFriendlyPooledOptions=OptionsHandling`Private`mapThreadOptions[ExperimentImageCells,expandedResolvedOptions];

	(* construct BatchedImagingParameters by mapping over orderedPooledContainers *)
	nestedBatchedImagingParameters=MapThread[
		Function[{containerPool,nestedSamplePool,nestedAdjustmentSample,myPooledOptions,myPoolIndex},
			(* map over all containers in the pool *)
			MapThread[
				Module[{containerPacket,containerModelPacket,adapterResource,adjSample,primAssociations,totalExposureTime,
					numberOfSamplesInBatch,numberOfSites,timelapseDuration,numberOfZSteps,batchRunTime},

					(* get our container packet's from cache *)
					containerPacket=fetchPacketFromCache[#1,newCache];

					(* get our container model's packet from cache *)
					containerModelPacket=fetchPacketFromCache[Lookup[containerPacket,Model],newCache];

					(* check if we need a slide adapter for this batch *)
					adapterResource=If[MatchQ[Lookup[containerModelPacket,Footprint],MicroscopeSlide],
						slideAdapterResource
					];

					(* check if any sample in this pool is an AdjustmentSample *)
					adjSample=FirstCase[#3,ObjectReferenceP[],Null];

					(* ---estimate imaging time per batch--- *)

					(* convert primitive to associations *)
					primAssociations=Association@@#&/@Flatten[Lookup[myPooledOptions,Images]];

					(* calculate exposure time from the primitive. if still AutoExpose at this point use 1 Second which is quite generous already *)
					totalExposureTime=Total[Lookup[primAssociations,ExposureTime]/.AutoExpose->1 Second];

					(* get number of samples to scan in this batch *)
					numberOfSamplesInBatch=Length[#2];

					(* calculate number of imaging sites *)
					numberOfSites=Times[
						Lookup[myPooledOptions,SamplingNumberOfColumns]/.(Null->1),
						Lookup[myPooledOptions,SamplingNumberOfRows]/.(Null->1)
					];

					(* get timelapse duration *)
					timelapseDuration=Lookup[myPooledOptions,TimelapseDuration]/.(Null->0 Minute);

					(* get number of z-steps *)
					numberOfZSteps=Lookup[myPooledOptions,NumberOfZSteps]/.(Null->1);

					(* calculate total imaging time *)
					batchRunTime=Total[{
						totalExposureTime*numberOfSites*numberOfZSteps*numberOfSamplesInBatch,
						timelapseDuration
					}];

					(* Build the BatchedImagingParameters entry *)
					<|
						Container->Lookup[containersInResourceLookup,#1],(* will be replaced will actual WorkingContainers in the compiler *)
						AdjustmentSample->adjSample,(* will be replaced will actual WorkingSamples in the compiler *)
						SlideAdapter->adapterResource,
						DestinationPosition->"Sample Slot",(* Model[Instrument,Microscope] VOQ enforces that all models have 'Sample Slot' *)
						EquilibrationTime->Lookup[myPooledOptions,EquilibrationTime],
						ContainerOrientation->Lookup[myPooledOptions,ContainerOrientation],
						ObjectiveMagnification->Lookup[myPooledOptions,ObjectiveMagnification],
						PixelBinning->Lookup[myPooledOptions,PixelBinning],
						ContinuousTimelapseImaging->Lookup[myPooledOptions,ContinuousTimelapseImaging],
						MetaXpressPrefix->Lookup[containerModelPacket,MetaXpressPrefix,Null],
						PoolNumber->myPoolIndex,(* indicating the original sample pool that each batch association belongs to*)
						RunTime->batchRunTime,
						AllImagingSiteCoordinates->Lookup[myPooledOptions,AllImagingSiteCoordinates],
						UsableImagingSiteCoordinates->Lookup[myPooledOptions,UsableImagingSiteCoordinates]
					|>
				]&,
				{containerPool,nestedSamplePool,nestedAdjustmentSample}
			]
		],
		{orderedPooledContainers,nestedPooledSamples,nestedAdjustmentSampleOption,mapFriendlyPooledOptions,Range[Length[orderedPooledContainers]]}
	];

	(* append BatchNumber with value indicating the batch number to each batch association *)
	batchedImagingParameters=MapIndexed[
		Append[#1,BatchNumber->First[#2]]&,
		Flatten@nestedBatchedImagingParameters
	];

	(* grab a list of the index of the container in WorkingSamples. This will be used by the compiler to fill out BatchedContainers *)
	(* note: Container subfield now has Link[Resource[]], need to grab container object inside *)
	batchedContainerIndexes=Flatten@Map[
		FirstPosition[uniqueContainersIn,First[#][Sample]]&,
		Lookup[batchedImagingParameters,Container]
	];

	(* -- Generate instrument resources -- *)

	(* get the estimate equilibration time *)
	tempEqulibrateTime=Switch[Lookup[expandedResolvedOptions,Temperature],
		(* no need to equilibrate *)
		Ambient|EqualP[25 Celsius],0 Hour,
		(* give it 30 min if not much higher than 25C *)
		RangeP[25 Celsius,27 Celsius],30 Minute,
		(* if much higher, return 2 hours *)
		_,2 Hour
	];

	(* calculate total imaging time for the instrument *)
	instrumentTime=Total[Flatten[{
		(* get all EquilibrationTime and RunTime from every batches *)
		Lookup[batchedImagingParameters,{EquilibrationTime, RunTime}],

		(* add buffer time for loading/unloading sample and method file loading per batch *)
		Length[batchedImagingParameters]*2 Minute
	}]];

	(* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
		this will probably look like set-up time + time/sample + tear-down time *)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->(tempEqulibrateTime+instrumentTime),
		Name->ToString[Unique[]]
	];

	(* -----------------------------------------*)
	(* --- containers to labware definition --- *)
	(* -----------------------------------------*)

	(* ---build resources for container models that need labware definition generated--- *)
	(* note: this is only required when our instrument is a high content imager *)
	(* make resources for container models that need labware definition generated for MetaXpress software *)

	containerModelsWithoutPrefix=If[TrueQ[Lookup[instrumentModelPacket,HighContentImaging]],
		(* check ContainersIn models if their labware definitions exist *)
		Module[{uniqueContainerModelPackets,noPrefixModels},
			(* fetch the unique container model packets *)
			uniqueContainerModelPackets=FlattenCachePackets[containerModelPackets];
			(* pick the PLATE models without MetaXpressPrefix populated *)
			noPrefixModels=Cases[uniqueContainerModelPackets,KeyValuePattern[{Object->obj_,Type->Model[Container,Plate],MetaXpressPrefix->Null}]:>obj];
			(* if we found any, wrap with link and return *)
			If[!MatchQ[noPrefixModels,{}],
				noPrefixModels
			]
		],
		Null
	];

	(* create Transfer SP primitives to fill containers for calibration *)
	(* do this only when we have plates to calibrate *)
	calibrationPrimitives=If[!MatchQ[containerModelsWithoutPrefix,Null|{}],
		MapIndexed[
			Function[{plateModel,index},
				Module[{packet,recommendedVol,minVol,fillVolume,wellsToFill},
					(* get our plate model's packet *)
					packet=fetchPacketFromCache[plateModel,containerModelPackets];
					(* get the liquid volume to use as Amount in the primitive *)
					{recommendedVol,minVol}=Lookup[packet,{RecommendedFillVolume,MinVolume}];
					fillVolume=If[NullQ[recommendedVol],
						(* if RecommendedFillVolume is Null, use MinVolume *)
						minVol,
						(* else: return it *)
						recommendedVol
					];

					(* get the wells we need to fill with water for calibration *)
					wellsToFill=List@@Lookup[packet,AllowedPositions];

					(* create a primitive to aliquot water into all wells with fillVolume as Amount *)
					Transfer[
						Source->Model[Sample,"id:8qZ1VWNmdLBD"], (* Milli-Q water *)
						Amount->fillVolume,
						Destination->{First@index,plateModel},
						DestinationWell->wellsToFill
					]
				]
			],
			containerModelsWithoutPrefix
		]
	];

	(* ------------------------------------ *)
	(* --- Generate the protocol packet --- *)
	(* ------------------------------------ *)

	(* generate batched ImageCells primitives *)
	(* note: we do this for both Manual and Robotic but store them in ImageCells protocol or RCP protocol, respectively *)
	batchedImageCellsPrimitives=MapThread[
		Function[{batchParameter,batchSamples,batchSampleIndex,batchContainerIndex},
			(* assemble ImageCells primitive *)
			ImageCells[<|
				Sample->{batchSamples},(* note that we need to double list since all samples are in the sample pool *)
				BatchedSamplesIn->batchSamples/.sampleResourceReplaceRules,
				BatchedSampleIndexes->batchSampleIndex,
				BatchContainer->Lookup[batchParameter,Container],
				BatchedContainerIndex->batchContainerIndex,
				AdjustmentSample->ToList[Lookup[batchParameter,AdjustmentSample]/.sampleResourceReplaceRules],
				SlideAdapter->ToList[slideAdapterResource],
				DestinationPosition->Lookup[batchParameter,DestinationPosition],
				EquilibrationTime->Lookup[batchParameter,EquilibrationTime],
				ContainerOrientation->Lookup[batchParameter,ContainerOrientation],
				ObjectiveMagnification->Lookup[batchParameter,ObjectiveMagnification],
				PixelBinning->Lookup[batchParameter,PixelBinning],
				ContinuousTimelapseImaging->Lookup[batchParameter,ContinuousTimelapseImaging],
				MetaXpressPrefix->Lookup[batchParameter,MetaXpressPrefix],
				PoolNumber->Lookup[batchParameter,PoolNumber],
				BatchNumber->Lookup[batchParameter,BatchNumber],
				RunTime->Lookup[batchParameter,RunTime],
				AllImagingSiteCoordinates->List@Lookup[batchParameter,AllImagingSiteCoordinates],
				UsableImagingSiteCoordinates->List@Lookup[batchParameter,UsableImagingSiteCoordinates],
				Instrument -> instrumentResource
			|>]
		],
		{batchedImagingParameters,Flatten[nestedPooledSamples,1],Flatten[nestedPooledSampleIndexes,1],batchedContainerIndexes}
	];

	{protocolPacket,unitOperationPackets}=If[MatchQ[resolvedPreparation,Manual],
		(* if Preparation -> Manual, generate batched unit operations and ImageCells protocol *)
		Module[
			{imageCellsManualUnitOperationPackets,imageCellsUnitOperationIDs,manualProtocolPacket,sharedFieldPacket,
				protocolPacketWithSamplePrepFields,simulatedSampleLabelRules},

			(* call UploadUnitOperation to generate our upload packets *)
			imageCellsManualUnitOperationPackets=UploadUnitOperation[
				batchedImageCellsPrimitives,
				Preparation->Manual,
				UnitOperationType->Batched,
				FastTrack->True,
				Upload->False
			];

			(* get the unit operation object reference from the packets *)
			imageCellsUnitOperationIDs=Cases[
				imageCellsManualUnitOperationPackets,
				KeyValuePattern[{Object->obj_,Type->Object[UnitOperation,ImageCells]}]:>obj
			];

			(*
			   we want to stash the simulated <> labels in a field so we can update all fields
			   (like NestedIndexMatchingSamplesIn) once the samples are prepared,
			*)
			simulatedSampleLabelRules = Reverse/@Lookup[updatedSimulation[[1]],Labels];


			(* generate our protocol packet *)
			manualProtocolPacket=<|
				(* ---Organizational Information--- *)
				Object->CreateID[Object[Protocol,ImageCells]],
				Type->Object[Protocol,ImageCells],
				Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
				Replace[NestedIndexMatchingSamplesIn]->ReplaceAll[Download[myPooledSamples,Object],simulatedSampleLabelRules],
				Replace[ContainersIn]->Map[Link[#,Protocols]&,(uniqueContainersIn/.containersInResourceLookup)],

				(* ---Options Handling--- *)
				UnresolvedOptions->unresolvedOptionsNoHidden,
				ResolvedOptions->resolvedOptionsNoHidden,

				(* ---Method Information--- *)

				(* ---non-index matching--- *)
				Instrument->instrumentResource,
				ReCalibrateMicroscope->Lookup[expandedResolvedOptions,ReCalibrateMicroscope],
				MicroscopeCalibration->Lookup[expandedResolvedOptions,MicroscopeCalibration],
				Temperature->Lookup[expandedResolvedOptions,Temperature]/.Ambient->25 Celsius,(* replace Ambient with 25C *)
				CarbonDioxide->Lookup[expandedResolvedOptions,CarbonDioxide],
				CarbonDioxidePercentage->Lookup[expandedResolvedOptions,CarbonDioxidePercentage],

				(* ---index-matched to NestedIndexMatchingSamplesIn--- *)

				(* instrument-related *)
				Replace[EquilibrationTimes]->Lookup[expandedResolvedOptions,EquilibrationTime],
				Replace[ContainerOrientations]->Lookup[expandedResolvedOptions,ContainerOrientation],
				Replace[CoverslipThicknesses]->Lookup[expandedResolvedOptions,CoverslipThickness],
				Replace[PlateBottomThicknesses]->Lookup[expandedResolvedOptions,PlateBottomThickness],
				Replace[ObjectiveMagnifications]->Lookup[expandedResolvedOptions,ObjectiveMagnification],
				Replace[PixelBinnings]->Lookup[expandedResolvedOptions,PixelBinning],
				Replace[AcquireImagePrimitives]->Lookup[expandedResolvedOptions,Images],

				(* ---sampling methods--- *)
				Replace[SamplingPatterns]->Lookup[expandedResolvedOptions,SamplingPattern],
				Replace[SamplingNumberOfRows]->Lookup[expandedResolvedOptions,SamplingNumberOfRows],
				Replace[SamplingNumberOfColumns]->Lookup[expandedResolvedOptions,SamplingNumberOfColumns],
				Replace[SamplingRowSpacings]->Lookup[expandedResolvedOptions,SamplingRowSpacing],
				Replace[SamplingColumnSpacings]->Lookup[expandedResolvedOptions,SamplingColumnSpacing],
				Replace[SamplingCoordinates]->Map[If[MatchQ[#,{DistanceP,DistanceP}],{#},#]&,Lookup[expandedResolvedOptions,SamplingCoordinates]],(* make sure to upload in nested form *)
				Replace[AdaptiveExcitationWaveLengths]->Lookup[expandedResolvedOptions,AdaptiveExcitationWaveLength]/.TransmittedLight->Null,
				Replace[AdaptiveNumberOfCells]->Lookup[expandedResolvedOptions,AdaptiveNumberOfCells],
				Replace[AdaptiveMinNumberOfImages]->Lookup[expandedResolvedOptions,AdaptiveMinNumberOfImages],
				Replace[AdaptiveCellWidths]->Map[If[NullQ[#],{Null,Null},List@@#]&,Lookup[expandedResolvedOptions,AdaptiveCellWidth]],(* convert Span to {_,_} *)
				Replace[AdaptiveIntensityThresholds]->Lookup[expandedResolvedOptions,AdaptiveIntensityThreshold],
				(* developer fields storing coordinates to use in compiler/exporter *)
				Replace[AllImagingSiteCoordinates]->Lookup[expandedResolvedOptions,AllImagingSiteCoordinates],
				Replace[UsableImagingSiteCoordinates]->Lookup[expandedResolvedOptions,UsableImagingSiteCoordinates],

				(* ---timelaspse imaging--- *)
				Replace[TimelapseImaging]->Lookup[expandedResolvedOptions,Timelapse],
				Replace[TimelapseIntervals]->Lookup[expandedResolvedOptions,TimelapseInterval],
				Replace[TimelapseDurations]->Lookup[expandedResolvedOptions,TimelapseDuration],
				Replace[NumberOfTimepoints]->Lookup[expandedResolvedOptions,NumberOfTimepoints],
				Replace[ContinuousTimelapseImagings]->Lookup[expandedResolvedOptions,ContinuousTimelapseImaging],
				Replace[TimelapseAcquisitionOrders]->Lookup[expandedResolvedOptions,TimelapseAcquisitionOrder],

				(* ---Z-stack imaging--- *)
				Replace[ZStackImaging]->Lookup[expandedResolvedOptions,ZStack],
				Replace[ZStepSizes]->Lookup[expandedResolvedOptions,ZStepSize],
				Replace[NumberOfZSteps]->Lookup[expandedResolvedOptions,NumberOfZSteps],
				Replace[ZStackSpans]->Map[If[NullQ[#],{Null,Null},List@@#]&,Lookup[expandedResolvedOptions,ZStackSpan]],(* convert Span to {_,_} *)

				(* ---index-matched to individual samples--- *)
				Replace[AdjustmentSamples]->Link/@(Lookup[expandedResolvedOptions,AdjustmentSample]/.Flatten[{sampleResourceReplaceRules,All->Null}]),
				Replace[RequireAdapter]->Map[If[MatchQ[#,MicroscopeSlide],True,False]&,Lookup[containerModelPackets,Footprint]],

				(* ---slide adapter single field--- *)
				SlideAdapter->Link[slideAdapterResource],

				(* ---batching fields--- *)
				Replace[BatchedUnitOperations]->(Link[#,Protocol]&)/@imageCellsUnitOperationIDs,

				(* container calibration fields *)
				(* CalibrationContainersWet will be resource picked by SM subprotocol and replaced with actual object in an execute task *)
				Replace[CalibrationContainers]->Map[Link[Resource[Sample->#,Name->ToString[Unique[]]]]&,containerModelsWithoutPrefix],
				Replace[CalibrationContainersWet]->Link/@containerModelsWithoutPrefix,
				Replace[ContainerCalibrationPrimitives]->calibrationPrimitives,

				Replace[Checkpoints]->{
					{"Preparing Instrumentation",tempEqulibrateTime,"The microscope is equilibrated to the desired temperature.",Link[Resource[Operator->$BaselineOperator,Time->tempEqulibrateTime]]},
					{"Preparing Samples",10 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
					{"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]},
					{"Acquiring Images",instrumentTime,"The images are acquired for the samples.",Link[Resource[Operator->$BaselineOperator,Time->instrumentTime]]},
					{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->$BaselineOperator,Time->1 Hour]]},
					{"Returning Materials",15 Minute,"Samples are returned to storage.",Link[Resource[Operator->$BaselineOperator,Time->10 Minute]]}
				},
				RunTime->instrumentTime,

				(* ---shared options/fields--- *)
				ImageSample->Lookup[expandedResolvedOptions,ImageSample],
				MeasureWeight->Lookup[expandedResolvedOptions,MeasureWeight],
				MeasureVolume->Lookup[expandedResolvedOptions,MeasureVolume],
				Replace[SamplesInStorage]->Lookup[expandedResolvedOptions,SamplesInStorageCondition]
			|>;

			(* generate a packet with the shared fields *)
			sharedFieldPacket=populateSamplePrepFields[myPooledSamples,myResolvedOptions,Cache->cache,Simulation->simulation];

			(* Merge the shared fields with the specific fields *)
			protocolPacketWithSamplePrepFields=Join[sharedFieldPacket,manualProtocolPacket];

			(* Return our protocol packet and unit operation packets. *)
			{protocolPacketWithSamplePrepFields,imageCellsManualUnitOperationPackets}
		],

		(* robotic *)
		Module[{imageCellsRoboticBatchedUnitOperationPackets,imageCellsBatchedUnitOperationIDs,imageCellsUnitOperationPacket,samplesContainerResources,imageCellsUnitOperationPacketWithLabeledObjects},

			(* generate batched unit operation packets to use in robotic exporter *)
			imageCellsRoboticBatchedUnitOperationPackets=UploadUnitOperation[
				batchedImageCellsPrimitives,
				Preparation->Robotic,
				UnitOperationType->Batched,
				FastTrack->True,
				Upload->False
			];

			(* get the unit operation object reference from the packets *)
			imageCellsBatchedUnitOperationIDs=Cases[
				imageCellsRoboticBatchedUnitOperationPackets,
				KeyValuePattern[{Object->obj_,Type->Object[UnitOperation,ImageCells]}]:>obj
			];


			(* Upload our main UnitOperation with resources. *)
			imageCellsUnitOperationPacket=Module[{
				nonHiddenImageCellsOptions,samplePrepOptionNames,imageCellsUnitOperationOptions
			},
				(* Only include non-hidden options from Transfer. *)
				nonHiddenImageCellsOptions=Lookup[
					Cases[OptionDefinition[ExperimentImageCells],KeyValuePattern["Category"->Except["Hidden"]]],
					"OptionSymbol"
				];

				(* gather sample prep option names to remove since we don't allow that in robotic primitive *)
				samplePrepOptionNames=ToExpression[Flatten[Options/@(List@@Experiment`Private`prepOptionSetP),1][[All,1]]];

				(* combine non-hidden options with required hidden options and remove sample prep options *)
				imageCellsUnitOperationOptions=Complement[Flatten[{nonHiddenImageCellsOptions,AllImagingSiteCoordinates,UsableImagingSiteCoordinates}],samplePrepOptionNames];

				(* call UploadUnitOperation to create ONE ImageCells unit operation packet *)
				UploadUnitOperation[
					ImageCells@@Flatten[{
						Sample->myPooledSamples,
						BatchedSamplesIn->samplesInResources,
						BatchedContainersIn->uniqueContainersIn/.containersInResourceLookup,
						ReplaceRule[
							Cases[myResolvedOptions,Verbatim[Rule][Alternatives@@imageCellsUnitOperationOptions,_]],
							{
								(* TODO this almost definitely does not work but it makes sure the tests pass and this will need a big second pass anyway *)
								RoboticUnitOperations->imageCellsBatchedUnitOperationIDs,
								Instrument->instrumentResource,
								RunTime->instrumentTime,
								Name->Null, (*don't want name to be passed down *)
								PreparatoryUnitOperations->Null (* make sure we don't upload PreparatoryUnitOperations option *)
							}
						]
					}],
					Preparation->Robotic,
					UnitOperationType->Output,
					FastTrack->True,
					Upload->False
				]
			];

			(* get the index-matching sample container resources *)
			samplesContainerResources=originalContainers/.containersInResourceLookup;

			(* Add the LabeledObjects field to the Robotic unit operation packet. *)
			(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
			imageCellsUnitOperationPacketWithLabeledObjects=Append[
				imageCellsUnitOperationPacket,
				Replace[LabeledObjects]->DeleteDuplicates@Join[
					Cases[
						Transpose[{Flatten@Lookup[expandedResolvedOptions,SampleLabel],samplesInResources}],
						{_String,Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample],Model[Sample]}]]]}
					],
					Cases[
						Transpose[{Flatten@Lookup[expandedResolvedOptions,SampleContainerLabel],samplesContainerResources}],
						{_String,Resource[KeyValuePattern[Sample->ObjectP[{Object[Container],Model[Container]}]]]}
					]
				]
			];

			(* Return Null as our protocol packet (since we don't have one) and our unit operation packet. *)
			{Null,Flatten[{imageCellsUnitOperationPacketWithLabeledObjects,imageCellsRoboticBatchedUnitOperationPackets}]}
		]
	];

	(* make list of all the resources we need to check in FRQ *)
	rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket],Normal[unitOperationPackets]}],_Resource,Infinity]];

	(* Get all resources without a name. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs,Resource[_?(MatchQ[KeyExistsQ[#,Name],False]&)]]];
	resourceToNameReplaceRules=MapThread[#1->#2&,{resourcesWithoutName,(Resource[Append[#[[1]],Name->CreateUUID[]]]&)/@resourcesWithoutName}];
	allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		(* don't call frq if we're in Engine *)
		MatchQ[$ECLApplication,Engine],
			{True,{}},

		(* When Preparation->Robotic, the framework will call FRQ for us. *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},

		(* if we gathering tests, call frq and also return tests *)
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->cache],

		(* otherwise, just get result from frq *)
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->cache],Null}
	];

	(* Return requested output *)
	(* if not returning Result, or the resources are not fulfillable, Result is $Failed *)
	outputSpecification/.{
		Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
			{protocolPacket,unitOperationPackets}/.resourceToNameReplaceRules,
			$Failed
		],
		Tests->If[gatherTests,resourceTests,{}]
	}
];


(* ::Subsubsection::Closed:: *)
(*simulateExperimentImageCells*)

DefineOptions[
	simulateExperimentImageCells,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentImageCells[
	myProtocolPacket:(PacketP[Object[Protocol,ImageCells],{Object,ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]..}|$Failed),
	myPooledSamples:{{ObjectP[Object[Sample]]...}...},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentImageCells]
]:=Module[{cache,simulation,flatSamples,samplePackets,protocolObject,fulfillmentSimulation,simulationWithLabels,resolvedPreparation},

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

	(* flatten our pooled samples input *)
	flatSamples=Flatten[myPooledSamples];

	(* Download containers from our sample packets. *)
	samplePackets=Download[
		flatSamples,
		Packet[Container],
		Cache->Lookup[ToList[myResolutionOptions],Cache,{}],
		Simulation->Lookup[ToList[myResolutionOptions],Simulation,Null]
	];

	(* Lookup our resolved preparation option. *)
	resolvedPreparation=Lookup[myResolvedOptions,Preparation];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[resolvedPreparation,Robotic],
			SimulateCreateID[Object[Protocol,RoboticCellPreparation]],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket,$Failed],
			SimulateCreateID[Object[Protocol,ImageCells]],
		True,
			Lookup[myProtocolPacket,Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	fulfillmentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticCellPreparation] so that we can call SimulateResources. *)
		MatchQ[myProtocolPacket,Null]&&MatchQ[myUnitOperationPackets,{PacketP[]..}],
			Module[{protocolPacket},
				(* generate a shell protocol packet with resources pulled out from the unit operation packets *)
				protocolPacket=<|
					Object->protocolObject,
					(* put unit operation objects in OutputUnitOperations field *)
					Replace[OutputUnitOperations]->(Link[#,Protocol]&)/@Lookup[myUnitOperationPackets,Object],
					(* pull out sample resources from unit operation and put in SamplesIn field *)
					Replace[SamplesIn]->DeleteDuplicates[
						Cases[myUnitOperationPackets,Resource[KeyValuePattern[Sample->ObjectP[Object[Sample]]]],Infinity]
					],
					(* pull out instrument resource from unit operation and put in RequiredInstruments field *)
					Replace[RequiredInstruments]->DeleteDuplicates[
						Cases[myUnitOperationPackets,Resource[KeyValuePattern[Type->Object[Resource,Instrument]]],Infinity]
					],
					ResolvedOptions->{}
				|>;

				(* simulate our resources. also pass parenet protocol if any *)
				SimulateResources[
					protocolPacket,
					myUnitOperationPackets,
					ParentProtocol->Lookup[ToList[myResolutionOptions],ParentProtocol,Null],
					Simulation->simulation
				]
			],

		(* if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket,$Failed],
			SimulateResources[
				<|
					Object->protocolObject,
					Replace[SamplesIn]->(Resource[Sample->#]&)/@flatSamples,
					ResolvedOptions->myResolvedOptions
				|>,
				Cache->cache,
				Simulation->simulation,
				PooledSamplesIn->myPooledSamples
			],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol,ImageCells]. *)
		True,
			SimulateResources[
				myProtocolPacket,
				Cache->cache,
				Simulation->simulation,
				PooledSamplesIn->myPooledSamples
			]
	];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Flatten@Lookup[myResolvedOptions,SampleLabel],flatSamples}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Flatten@Lookup[myResolvedOptions,SampleContainerLabel],Download[Lookup[samplePackets,Container],Object]}],
				{_String,ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Flatten@Lookup[myResolvedOptions,SampleLabel],(Field[SampleLink[[#]]]&)/@Range[Length[flatSamples]]}],
				{_String,_}
			],
			Rule@@@Cases[
				Transpose[{Flatten@Lookup[myResolvedOptions,SampleContainerLabel],(Field[SampleLink[[#]][Container]]&)/@Range[Length[flatSamples]]}],
				{_String,_}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[fulfillmentSimulation,simulationWithLabels]
	}
];


(* resolveImageCellsMethod options *)
DefineOptions[resolveImageCellsMethod,
	SharedOptions:>{
		ExperimentImageCells,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

Error::ConflictingImageCellsMethodRequirements="The following option(s)/input(s) were specified that require a Manual Preparation method, `1`. However, the following option(s)/input(s) were specified that require a Robotic Preparation method, `2`. Please resolve this conflict in order to submit a valid ImageCells protocol.";

(* NOTE: You should NOT throw messages in this function. Just return the methods by which you can perform your primitive with the given options. *)
resolveImageCellsMethod[
	mySemiPooledInputs:Automatic|ListableP[ListableP[ObjectP[{Object[Sample],Object[Container]}]]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,containerPackets,samplePackets,integratedInstrumentPackets,
		allModelContainerPackets,allModelContainerPlatePackets,liquidHandlerIncompatibleContainers,imagesOption,microscopeOrientation,reCalibrateMicroscope,
		microscopeCalibration,containerOrientation,coverslipThickness,safeOps,instrumentOption,integratedMicroscopePackets,
		integratedInstrumentQ,result,tests,allModelContainerMetaXpressPrefixes,manualRequirementStrings,roboticRequirementStrings,
		unsupportedImagingMode,samplePrepOptions,specifiedSamplePrepOptions,nonAutomaticImagesOption
	},

	(* make sure options are in listed form *)
	listedOptions=ToList[myOptions];

	(* get the safe options *)
	safeOps=SafeOptions[resolveImageCellsMethod,listedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Download information that we need from our inputs and/or options. *)
	{containerPackets,samplePackets,integratedInstrumentPackets}=Quiet[Download[
		{
			Cases[mySemiPooledInputs,ObjectP[Object[Container]],Infinity],
			Cases[mySemiPooledInputs,ObjectP[Object[Sample]],Infinity],
			{Model[Instrument,LiquidHandler,"id:o1k9jAKOwLV8"]}(* bioSTAR *)
		},
		{
			{Packet[Model[{Footprint,LiquidHandlerAdapter,LiquidHandlerPrefix}]]},
			{Packet[Container],Packet[Container[Model[{Footprint,MetaXpressPrefix,LiquidHandlerAdapter,LiquidHandlerPrefix}]]]},
			{Packet[IntegratedInstruments[{Modes,Name}]]}
		},
		Cache->Lookup[listedOptions,Cache,{}],
		Simulation->Lookup[listedOptions,Simulation,Null]
	],Download::FieldDoesntExist];

	(* Get all of our Model[Container]s and look at their footprints. *)
	allModelContainerPackets=Cases[Flatten[{containerPackets,samplePackets}],PacketP[Model[Container]]];
	allModelContainerPlatePackets=Cases[allModelContainerPackets,PacketP[Model[Container,Plate]]];
	allModelContainerMetaXpressPrefixes=Lookup[allModelContainerPackets,MetaXpressPrefix];

	(* determine if all the container model packets in question can fit on the liquid handler (MetaXpress can only accept plate) *)
	liquidHandlerIncompatibleContainers=DeleteDuplicates[
		Join[
			Lookup[Cases[allModelContainerPackets,KeyValuePattern[Footprint->Except[Plate]]],Object,{}],
			Lookup[Cases[allModelContainerPlatePackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
		]
	];

	(* get the options that can force to manual if they are specified *)
	{
		instrumentOption,imagesOption,microscopeOrientation,reCalibrateMicroscope,microscopeCalibration,containerOrientation,coverslipThickness
	}=Lookup[safeOps,{Instrument,Images,MicroscopeOrientation,ReCalibrateMicroscope,MicroscopeCalibration,ContainerOrientation,CoverslipThickness}];

	(* get the integrated microscope packet *)
	integratedMicroscopePackets=Cases[Flatten@integratedInstrumentPackets,PacketP[Model[Instrument,Microscope]]];

	(* if Instrument option is specified, check if it is integrated to the bioSTAR workcell *)
	integratedInstrumentQ=If[MatchQ[instrumentOption,Automatic],
		(* return True if Automatic *)
		True,
		(* else: check if it is integrated *)
		MatchQ[Download[instrumentOption,Object],ObjectReferenceP[Lookup[integratedMicroscopePackets,Object]]]
	];

	(* if Images is not Automatic, check if all imaging Modes specified in AcquireImage primitives are supported by the bioSTAR workcell *)
	nonAutomaticImagesOption=Cases[ToList[imagesOption],AcquireImagePrimitiveP,Infinity];
	unsupportedImagingMode=If[MatchQ[nonAutomaticImagesOption,{}],
		(* if non of Images value is specified as AcquireImage primitives *)
		{},

		(* else: check if all specified Modes are supported by the workcell integrated microscope *)
		Module[{imagingModes,workcellImagingModes},
			(* get the imaging Mode specified in AcquireImage primitives *)
			imagingModes=#[Mode]&/@Flatten[ToList[nonAutomaticImagesOption]];

			(* get the robotic supported imaging Modes from the workcell integrated microscope *)
			workcellImagingModes=Flatten@Lookup[integratedMicroscopePackets,Modes];

			(* return specified imaging Modes not supported by the workcell integrate microscope *)
			If[ContainsAll[workcellImagingModes,imagingModes],
				{},
				Complement[imagingModes,workcellImagingModes]
			]
		]
	];

	(* get the specified sample prep options and return option name if any of its value is non-Automatic *)
	samplePrepOptions=First@splitPrepOptions[safeOps];
	specifiedSamplePrepOptions=KeyValueMap[
		If[MemberQ[Flatten[ToList[#2]],Except[Automatic]],
			#1,
			Nothing
		]&,
		Association@@samplePrepOptions
	];

	(* Create a list of reasons why we need Preparation->Manual. *)
	manualRequirementStrings={
		(* 1.) if we are dealing with something besides a Plate, must be Manual *)
		If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
			"the sample containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible plate",
			Nothing
		],
		(* 2.) if any of the specified Mode is not supported by the workcell integrated microscope, must be Manual *)
		If[MatchQ[unsupportedImagingMode,{}],
			Nothing,
			"the imaging Mode "<>ToString[unsupportedImagingMode]<>" are not supported by any of the liquid handler integrated microscope: "<>ObjectToString[Lookup[integratedMicroscopePackets,Object],Cache->integratedMicroscopePackets]
		],
		(* 3.) if MicroscopeOrientation is Upright, must be Manual *)
		If[MatchQ[microscopeOrientation,Upright],
			"upright microscopes can only be used to image the samples manually",
			Nothing
		],
		(* 4.) if ReCalibrateMicroscope is True, must be Manual as this only applies to the Nikon *)
		If[TrueQ[reCalibrateMicroscope],
			"ReCalibrateMicroscope is set to True by the user",
			Nothing
		],
		(* 5.) if MicroscopeCalibration is not Automatic or Null, must be Manual *)
		If[MatchQ[microscopeCalibration,Except[Automatic|Null]],
			"MicroscopeCalibration is not Automatic or Null",
			Nothing
		],
		(* 6.) if any of the ContainerOrientation options is UpsideDown, must be Manual *)
		If[MemberQ[ToList[containerOrientation],UpsideDown],
			"ContainerOrientation is set to UpsideDown by the user",
			Nothing
		],
		(* 7.) if any of the liquid handling-required options are Automatic or Null, must be Manual *)
		If[MemberQ[ToList[coverslipThickness],_Quantity],
			"CoverslipThickness is set by the user",
			Nothing
		],
		(* 8.) if specified instrument is not a workcell integrated microscope, must be Manual *)
		If[Not[integratedInstrumentQ],
			"specified instrument is not a workcell integrated microscope",
			Nothing
		],
		(* 9.) if any container model is not calibrated for the high content imager (MetaXpressPrefix is Null or is an empty string ("")), must be manual *)
		If[MemberQ[allModelContainerMetaXpressPrefixes,(Null | "")],
			"container model is not calibrated for the high content imager",
			Nothing
		],
		(* 10.) if any of the sample prep options is specified as non-Automatic, must be manual *)
		If[Length[specifiedSamplePrepOptions]>0,
			"the following sample preparation options are specified and the values are not Automatic: "<>ToString[specifiedSamplePrepOptions],
			Nothing
		],
		(* 11.) Preparation option is set to Manual by the user *)
		If[MatchQ[Lookup[safeOps,Preparation],Manual],
			"the Preparation option is set to Manual by the user",
			Nothing
		]
	};

	(* Create a list of reasons why we need Preparation->Robotic. *)
	roboticRequirementStrings={
		If[MatchQ[Lookup[safeOps,Preparation],Robotic],
			"the Preparation option is set to Robotic by the user",
			Nothing
		],
		If[MatchQ[Lookup[safeOps,WorkCell],Except[Automatic]],
			"the WorkCell option is set to a specific workcell by the user",
			Nothing
		]
	};

	(* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
	If[Length[manualRequirementStrings]>0&&Length[roboticRequirementStrings]>0&&!gatherTests,
		Message[
			Error::ConflictingImageCellsMethodRequirements,
			StringRiffle[manualRequirementStrings,{"{",", ","}"}],
			StringRiffle[roboticRequirementStrings,{"{",", ","}"}]
		]
	];

	(* Return our result and tests. *)
	result=Which[
		MatchQ[Lookup[safeOps,Preparation],Except[Automatic]],
		Lookup[safeOps,Preparation],
		Length[manualRequirementStrings]>0,
		Manual,
		Length[roboticRequirementStrings]>0,
		Robotic,
		True,
		{Manual,Robotic}
	];

	(* gather all tests *)
	tests=If[gatherTests,
		{
			Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Transfer primitive",
				Length[manualRequirementStrings]>0&&Length[roboticRequirementStrings]>0,
				False
			]
		},
		{}
	];

	(* return our result and/or tests *)
	outputSpecification/.{Result->result,Tests->tests}
];

(* resolveImageCellsWorkCell *)
resolveImageCellsWorkCell[
	mySemiPooledInputs:ListableP[ListableP[ObjectP[{Object[Sample],Object[Container],Model[Sample]}]|_String]],
	myOptions:OptionsPattern[]
]:= Module[
	{workCell},

	workCell=Lookup[myOptions,WorkCell, Automatic];

	(* Determine the WorkCell that can be used: *)
	If[
		MatchQ[workCell,Except[Automatic]],
		{workCell},
		{bioSTAR,microbioSTAR}
	]
];


(* ::Subsection:: *)
(*ImageCells Helpers*)


(* search of instrument models based on specified options *)
microscopeDevices[instrumentOption_,experimentOptions_,preparationOption_,workCellOption_]:=Module[{},
	(* first check if the Instrument is specified *)
	If[MatchQ[instrumentOption,Automatic],
		Module[{
			microscopeOrientation,orientationSearchCondition,microscopeObjectiveMagnifications,objectiveMagnificationSearchCondition,
			specifiedImagingModes,modeSearchCondition,recalibrateOption,
			calibrationSearchOption,temperatureOption,temperatureSearchCondition,carbonDioxideOption,carbonDioxideSearchOption,
			highContentImagingSearchCondition,workCellSearchCondition,modelSearchConditions
		},
			(* get the microscope orientation option *)
			microscopeOrientation=Lookup[experimentOptions,MicroscopeOrientation];

			(* create search condition for microscope viewing orientation *)
			orientationSearchCondition=If[MatchQ[microscopeOrientation,Automatic],
				Orientation==MicroscopeViewOrientationP,
				Orientation==microscopeOrientation
			];

			(* Get the ObjectiveMagnification option *)
			microscopeObjectiveMagnifications = Cases[ToList[Lookup[experimentOptions,ObjectiveMagnification]],NumberP];

			(* create the Search condition for objective magnifications - must allow all specified *)
			objectiveMagnificationSearchCondition = If[!MatchQ[microscopeObjectiveMagnifications,{}],
				ObjectiveMagnifications==#&/@microscopeObjectiveMagnifications,
				{}
			];

			(* get all specified imaging modes from the AcquireImage primitives *)
			specifiedImagingModes=DeleteDuplicates@Cases[Lookup[experimentOptions,Images],MicroscopeModeP,Infinity];

			(* create search condition for imaging modes *)
			modeSearchCondition=Modes==#&/@specifiedImagingModes;

			(* get ReCalibrateMicroscope option *)
			recalibrateOption=Lookup[experimentOptions,ReCalibrateMicroscope];

			(* create search condition for microscope calibration *)
			calibrationSearchOption=If[TrueQ[recalibrateOption],
				MicroscopeCalibration==True,
				{}
			];

			(* get Temperature option *)
			temperatureOption=Lookup[experimentOptions,Temperature];

			(* create search condition for temperature control *)
			temperatureSearchCondition=If[!MatchQ[temperatureOption,Ambient],
				{
					TemperatureControlledEnvironment==True,
					MinTemperatureControl<=temperatureOption,
					MaxTemperatureControl>=temperatureOption
				},
				{}
			];

			(* get the CarbonDioxide option value *)
			carbonDioxideOption=Lookup[experimentOptions,CarbonDioxide];

			(* create search condition for microscope calibration *)
			carbonDioxideSearchOption=If[TrueQ[carbonDioxideOption],
				CarbonDioxideControl==True,
				{}
			];

			(* If we have Preparation->Robotic, we know we have a high content imager *)
			highContentImagingSearchCondition = If[MatchQ[preparationOption,Robotic],
				HighContentImaging == True,
				{}
			];

			(* Workcell search condition *)
			(* If we have a specified workcell, only allow instrument models on that workcell *)
			workCellSearchCondition = Switch[workCellOption,
				Automatic, {},
				bioSTAR, IntegratedLiquidHandlers==Model[Instrument, LiquidHandler, "id:o1k9jAKOwLV8"], (* Model[Instrument, LiquidHandler, "bioSTAR"] *)
				microbioSTAR, IntegratedLiquidHandlers==Model[Instrument, LiquidHandler, "id:aXRlGnZmOd9m"], (*Model[Instrument, LiquidHandler, "microbioSTAR"]*)
				_, {}
			];

			(* combine all search conditions *)
			modelSearchConditions=And@@Flatten[{
				Deprecated==(False|Null),
				orientationSearchCondition,
				objectiveMagnificationSearchCondition,
				calibrationSearchOption,
				modeSearchCondition,
				temperatureSearchCondition,
				carbonDioxideSearchOption,
				workCellSearchCondition,
				highContentImagingSearchCondition
			}];

			(* search for all microscope models that meet our criteria *)
			Search[Model[Instrument,Microscope],Evaluate@modelSearchConditions]
		],

		(* if Instrument is specified return as is *)
		{instrumentOption}
	]
];


(* calculate imaging sites and/or check specified row/column numbers if they fit in each well *)
(* return output in the format {#row,#column,#ofSites(excluding ones that are outside of well) *)
(* TODO: needs a new overload to handle slide with variable sample area sizes *)
imagingSiteCalculator[
	containerModelPacket:PacketP[{Model[Container,Plate],Model[Container,Hemocytometer],Model[Container,MicroscopeSlide]}],
	microscopeModelPacket:PacketP[Model[Instrument,Microscope]],
	objectiveMagnification:Alternatives[_Real,_Integer],
	numberOfRows:Alternatives[Automatic,_Integer],
	numberOfColumns:Alternatives[Automatic,_Integer],
	rowSpacing:DistanceP,
	columnSpacing:DistanceP
]:=Module[
	{
		wellDiameter,wellDimensions,wellSizeX,wellSizeY,unitlessRowSpacing,unitlessColumnSpacing,imageSizeX,imageSizeY,
		imageScaleTuples,imageScaleX,imageScaleY,imageDistanceX,imageDistanceY,maxPossibleRows,maxPossibleColumns,maxRow,
		maxCol,returnEarlyQ,allCombinations,maxRowToUse,maxColumnToUse,goodCoordinatesResults,allCoordinatesList,
		usableCoordinatesList,rowColResult,allCoordinatesResult,usableCoordinatesResult
	},

	(* get well diameter and dimensions based on our container type *)
	{wellDiameter,wellDimensions}=Switch[containerModelPacket,
		(* if container is a plate, simply lookup well diameter and dimensions *)
		PacketP[Model[Container,Plate]],Lookup[containerModelPacket,{WellDiameter,WellDimensions}],
		(* container is a hemocytometer, lookup grid dimensions *)
		PacketP[Model[Container,Hemocytometer]],{Null,Lookup[containerModelPacket,GridDimensions]},
		(* container is a microscope slide: lookup dimensions from first position *)
		_,If[MatchQ[Lookup[First@Lookup[containerModelPacket,PositionPlotting],CrossSectionalShape],Circle],
			{Lookup[First@Lookup[containerModelPacket,Positions],MaxWidth],Null},
			Lookup[First@Lookup[containerModelPacket,Positions],{MaxWidth,MaxDepth}]
		]
	];

	(* convert well diameter or dimensions to micrometer and strip off unit *)
	{wellSizeX,wellSizeY}=If[NullQ[wellDiameter],
		(* our well is rectangular *)
		Rationalize@Unitless[wellDimensions,Micrometer],
		(* else: our well is circular *)
		Rationalize@Unitless[{wellDiameter,wellDiameter},Micrometer]
	];

	(* get image size in pixel in X and Y directions from the instrument *)
	{imageSizeX,imageSizeY}=Lookup[microscopeModelPacket,{ImageSizeX,ImageSizeY}];

	(* create a list of tuples in the form {objectiveMagnification,imageScaleX,imageScaleY} *)
	imageScaleTuples=Transpose@Lookup[microscopeModelPacket,{ObjectiveMagnifications,ImageScalesX,ImageScalesY}];

	(* get image scale from the tuple that matches our resolved ObjectiveMagnification option *)
	{imageScaleX,imageScaleY}=Rest@FirstCase[imageScaleTuples,{N[objectiveMagnification],__}];

	(* calculate image size in distance in X and Y direction *)
	(* note: this is the size of each imaging site *)
	{imageDistanceX,imageDistanceY}=Rationalize@Unitless[{imageScaleX*imageSizeX,imageScaleY*imageSizeY},Micrometer];

	(* convert spacing values to micrometer and strip off unit *)
	{unitlessRowSpacing,unitlessColumnSpacing}=Rationalize@Unitless[{rowSpacing,columnSpacing},Micrometer];

	(* solve for max possible number of rows *)
	maxPossibleRows=Ceiling[maxRow]/.First@Solve[((maxRow*imageDistanceY)+((maxRow-1)*unitlessRowSpacing))==wellSizeY];

	(* initialize return early variable *)
	returnEarlyQ=False;

	(* check if specified # or rows exceeds maxPossibleRows *)
	maxRowToUse=If[!MatchQ[numberOfRows,Automatic],
		(* check if specified # or rows exceeds maxPossibleRows *)
		If[numberOfRows>maxPossibleRows,
			(* yes, flip returnEarlyQ *)
			returnEarlyQ=True;,
			(* no return the specified value *)
			numberOfRows
		],
		(* else: numberOfColumns is not specified, return our calculated value *)
		maxPossibleRows
	];

	(* return early if specified numberOfRows exceeds maxPossibleRows *)
	If[returnEarlyQ,
		Return[$Failed]
	];

	(* solve for max possible number of columns *)
	maxPossibleColumns=Ceiling[maxCol]/.First@Solve[((maxCol*imageDistanceX)+((maxCol-1)*unitlessColumnSpacing))==wellSizeX];

	(* check if specified # or columns exceeds maxPossibleColumns *)
	maxColumnToUse=If[!MatchQ[numberOfColumns,Automatic],
		(* check if specified # or columns exceeds maxPossibleColumns *)
		If[numberOfColumns>maxPossibleColumns,
			(* yes, flip returnEarlyQ *)
			returnEarlyQ=True;,
			(* no return the specified value *)
			numberOfColumns
		],
		(* else: numberOfColumns is not specified, return our calculated value *)
		maxPossibleColumns
	];

	(* return early if specified numberOfColumns exceeds maxPossibleColumns *)
	If[returnEarlyQ,
		Return[$Failed]
	];

	(* generate all possible combinations of {#row,#column} to use to find best imaging sites coverage for our well *)
	allCombinations=Switch[{numberOfRows,numberOfColumns},
		(* if both numberOfRows and numberOfColumns are not specified, generate all combinations starting from row=1 and column=1 *)
		{Automatic,Automatic},Flatten[Table[{x,y},{x,1,maxRowToUse},{y,1,maxColumnToUse}],1],
		(* only numberOfRows is specified *)
		{_,Automatic},Table[{numberOfRows,y},{y,1,maxColumnToUse}],
		(* only numberOfColumns is specified *)
		{Automatic,_},Table[{x,numberOfColumns},{x,1,maxRowToUse}],
		(* if both are specified, we only need to test that combination *)
		_,{{numberOfRows,numberOfColumns}}
	];

	(* test all possible combinations of {#row,#column} and get the number of total imaging sites that fit in our well *)
	(* criteria: usable imaging sites are the ones that has theirs center coordinate inside the well *)
	{goodCoordinatesResults,allCoordinatesList,usableCoordinatesList}=Transpose[Function[rowColTuple,
		Module[{rowNum,colNum,totalXDistance,totalYDistance,startCoord,xCoordSpacing,yCoordSpacing,allSiteCoordinates,
			regionMemberQ,coordinatesPickList,goodCoordCount,goodCoordinates},

			(* get the # of row and # of column *)
			{rowNum,colNum}=rowColTuple;

			(* calculate total distance in x direction *)
			totalXDistance=(colNum*imageDistanceX)+((colNum-1)*unitlessColumnSpacing);

			(* calculate total distance in y direction *)
			totalYDistance=(rowNum*imageDistanceY)+((rowNum-1)*unitlessRowSpacing);

			(* get the coordinates of the bottom left imaging site *)
			startCoord={-(totalXDistance/2-imageDistanceX/2),-(totalYDistance/2-imageDistanceY/2)};

			(* calculate the distance between each center of the imaging site in x direction *)
			xCoordSpacing=imageDistanceX+unitlessColumnSpacing;

			(* calculate the distance between each center of the imaging site in Y direction *)
			yCoordSpacing=imageDistanceY+unitlessRowSpacing;

			(* generate all coordinates from the given #row, #col and spacings *)
			allSiteCoordinates=Flatten[Table[{x,y},
				{x,First@startCoord,-First@startCoord,xCoordSpacing},
				{y,Last@startCoord,-Last@startCoord,yCoordSpacing}
			],1];

			(* create a region member function to apply to our coordinates *)
			regionMemberQ=If[NullQ[wellDiameter],
				(* our well is rectangular *)
				RegionMember[Rectangle[-{wellSizeX,wellSizeY}/2,{wellSizeX,wellSizeY}/2]],
				(* else: our well is circular *)
				RegionMember[Disk[{0,0},wellSizeX/2]]
			];

			(* create a pick list for coordinates can be imaged *)
			coordinatesPickList=regionMemberQ[allSiteCoordinates];

			(* count total number of coordinates we can use *)
			(* these are the ones that fall within our well boundary *)
			goodCoordCount=Count[coordinatesPickList,True];

			(* get the good coordinates that can be iamged *)
			goodCoordinates=PickList[allSiteCoordinates,coordinatesPickList];

			(* return our results *)
			{goodCoordCount,allSiteCoordinates,goodCoordinates}
		]
	]/@allCombinations];

	(* get the #row and #column combination that gives us the best well coverage *)
	rowColResult=First@PickList[allCombinations,goodCoordinatesResults,Max[goodCoordinatesResults]];

	(* get all possible coordinates from the best combination *)
	allCoordinatesResult=First@PickList[allCoordinatesList,goodCoordinatesResults,Max[goodCoordinatesResults]];

	(* get the usable coordinates from the best combination *)
	usableCoordinatesResult=First@PickList[usableCoordinatesList,goodCoordinatesResults,Max[goodCoordinatesResults]];

	(* return our results n the form {#row,#column,total#sites,allCoordinates,usableCoordinates} *)
	{Sequence@@rowColResult,Max[goodCoordinatesResults],allCoordinatesResult,usableCoordinatesResult}
];