(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,AcquireImage],
	{
		Description->"A detailed set of parameters that specifies the acquisition of a sample image.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Mode -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MicroscopeModeP,
				Description -> "The type of microscopy technique used to acquire an image of a sample. BrightField is the simplest type of microscopy technique that uses white light to illuminate the sample, resulting in an image in which the specimen is darker than the surrounding areas that are devoid of it. Bright-field microscopy is useful for imaging samples stained with dyes or samples with intrinsic colors. PhaseContrast microscopy increases the contrast between the sample and its background, allowing it to produce highly detailed images from living cells and transparent biological samples. The contrast is enhanced such that the boundaries of the sample and its structures appear much darker than the surrounding medium. Epifluorescence microscopy uses light at a specific wavelength range to excite a fluorophore of interest in the sample and capture the resulting emitted fluorescence to generate an image. ConfocalFluorescence microscopy employs a similar principle as Epifluorescence to illuminate the sample and capture the emitted fluorescence along with pinholes in the light path to block out-of-focus light in order to increase optical resolution. Confocal microscopy is often used to image thick samples or to clearly distinguish structures that vary in height along the z-axis.",
				Category -> "General"
			},
			DetectionLabelsLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Molecule]
				],
				Description -> "Indicates the tags, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be imaged.",
				Category -> "General",
				Migration->SplitField
			},
			DetectionLabelsExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {ObjectP[Model[Molecule]]..},
				Relation -> Null,
				Description -> "Indicates the tags, including fluorescent or non-fluorescent chemical compounds or proteins, attached to the sample that will be imaged.",
				Category -> "General",
				Migration->SplitField
			},
			FocalHeightReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter],
				Units -> Millimeter,
				Description -> "The distance between the top of the objective lens and the bottom of the sample when the imaging plane is in focus. If set to Autofocus, the microscope will obtain a small stack of images along the z-axis of the sample and determine the best focal plane based on the image in the stack that shows the highest contrast. FocalHeight is then calculated from the location of the best focal plane on the z-axis. If set to Manual, the FocalHeight will be adjutsted manually.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			FocalHeightExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Automatic|Autofocus|Manual,
				Description -> "The distance between the top of the objective lens and the bottom of the sample when the imaging plane is in focus. If set to Autofocus, the microscope will obtain a small stack of images along the z-axis of the sample and determine the best focal plane based on the image in the stack that shows the highest contrast. FocalHeight is then calculated from the location of the best focal plane on the z-axis. If set to Manual, the FocalHeight will be adjutsted manually.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			ExposureTimeReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millisecond],
				Units -> Millisecond,
				Description -> "The length of time that the camera collects the signal from the sample. The longer the exposure time, the more photons the detector can collect, resulting in a brighter image. Selecting AutoExpose will prevent the pixels from becoming saturated by allowing the microscope software to determine the exposure time such that the brightest pixel is 75% of the maximum gray level that the camera can obtain.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			ExposureTimeExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> AutoExpose,
				Description -> "The length of time that the camera collects the signal from the sample. The longer the exposure time, the more photons the detector can collect, resulting in a brighter image. Selecting AutoExpose will prevent the pixels from becoming saturated by allowing the microscope software to determine the exposure time such that the brightest pixel is 75% of the maximum gray level that the camera can obtain.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			TargetMaxIntensity -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,65535],
				Description -> "Specifies the intensity that the instrument should attempt to attain for the brightest pixel in the image to be acquired.",
				Category->"Image Acquisition"
			},
			TimelapseImageCollectionExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[All,StartOnly,StartAndEnd],
				Description -> "Specifies the timepoint(s) at which the sample is imaged when acquiring timelapse images. All allows acquisition of an image at every timepoint defined in ExperimentImageCells option. StartOnly acquires an image at the first timepoint only. StartAndEnd acquires an image at the first and the last timepoints. When specified as an integer, an image will be acquired at every Nth timepoints, beginning with the first timepoint.",
				Category->"Time Lapse Imaging",
				Migration->SplitField
			},
			TimelapseImageCollectionInteger -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[1],
				Description -> "Specifies the timepoint(s) at which the sample is imaged when acquiring timelapse images. All allows acquisition of an image at every timepoint defined in ExperimentImageCells option. StartOnly acquires an image at the first timepoint only. StartAndEnd acquires an image at the first and the last timepoints. When specified as an integer, an image will be acquired at every Nth timepoints, beginning with the first timepoint.",
				Category->"Time Lapse Imaging",
				Migration->SplitField
			},
			ZStackImageCollection -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a series of images at multiple z-axis positions will be acquired for the sample.",
				Category->"Z-Stack Imaging"
			},
			ImagingChannel -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MicroscopeImagingChannelP,
				Description -> "Indicates the imaging channel pre-defined by the instrument that should be used to acquire images from the sample.",
				Category->"Image Acquisition"
			},
			ExcitationWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Nanometer],
				Units -> Nanometer,
				Description -> "The wavelength of excitation light used to illuminate the sample when imaging with ConfocalFluorescence or Epifluorescence Mode.",
				Category->"Fluorescence Imaging"
			},
			EmissionWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Nanometer],
				Units -> Nanometer,
				Description -> "The wavelength at which the fluorescence emission of the DetectionLabels should be imaged.",
				Category->"Fluorescence Imaging"
			},
			ExcitationPower -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 Percent,100 Percent],
				Units -> Percent,
				Description -> "The percent of maximum intensity of the light source that should be used to illuminate the sample. Higher intensity will excite more fluorescent molecules in the sample, resulting in more signal being produced, but will also increase the chance of bleaching the fluorescent molecules.",
				Category->"Fluorescence Imaging"
			},
			DichroicFilterWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Nanometer],
				Units -> Nanometer,
				Description -> "Specifies the wavelength that should be passed by the filter to illuminate the sample and excite the DetectionLabels.",
				Category->"Fluorescence Imaging"
			},
			ImageCorrection -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MicroscopeImageCorrectionP,
				Description -> "The correction step(s) that will be automatically applied to the image. BackgroundCorrection removes stray light that is unrelated to light that reaches the sample. ShadingCorrection mitigates the uneven illumination of the sample that is visible around the edges of the image.",
				Category->"Fluorescence Imaging"
			},
			ImageDeconvolution -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a deconvolution algorithm should be used to enhance contrast, improve image resolution, and sharpen the image.",
				Category->"Fluorescence Imaging"
			},
			ImageDeconvolutionKFactor -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0,2],
				Description -> "Specifies the factor used by the Wiener Filter in the deconvolution algorithm to determine image sharpness. Lower values increase sharpness and higher values reduce noise.",
				Category->"Fluorescence Imaging"
			},
			TransmittedLightPower -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 Percent,100 Percent],
				Units -> Percent,
				Description -> "The percent of maximum intensity of the transmitted light that should be used to illuminate the sample. This option will set the percent maximum of the voltage applied to the light source, with higher percentages indicating higher intensities.",
				Category->"BrightField and PhaseContrast Imaging"
			},
			TransmittedLightColorCorrection -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a neutral color balance filter will be placed into the transmitted light path to correct the color temperature during BrightField and PhaseContrast imaging.",
				Category->"BrightField and PhaseContrast Imaging"
			}
		}
	}
];
