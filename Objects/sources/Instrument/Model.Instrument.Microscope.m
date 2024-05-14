(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Microscope], {
	Description->"Model of an optical magnification imaging device for obtaining images under bright field or fluorescent illumination.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Modes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MicroscopeModeP,
			Description -> "The types of images the microscope is capable of generating.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		HighContentImaging->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the instrument is capable of performing high-throughput phenotypic screening of live cells.",
			Category->"Instrument Specifications"
		},
		Orientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MicroscopeViewOrientationP,
			Description -> "Indicates if the sample is viewed from above (upright) or underneath (inverted).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IlluminationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MicroscopeIlluminationTypeP,
			Description -> "For each member of Modes, the source of illumination available to image samples on the microscope.",
			IndexMatching -> Modes,
			Category -> "Instrument Specifications"
		},
		LampTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "Indicates the sources of illumination available to the microscope.",
			Category -> "Instrument Specifications"
		},
		CameraModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part],
			Description -> "The model of the digital camera connected to the microscope.",
			Category -> "Instrument Specifications"
		},
		Objectives -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Objective],
			Description -> "For each member of ObjectiveMagnifications, a viewing objective available for this model of microscope.",
			IndexMatching->ObjectiveMagnifications,
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		OpticModules -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,OpticModule],
			Description -> "A list of the optic modules, used in fluorescence imaging, available for this model of microscope.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		EyePieceMagnification -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The magnification provided by the eyepiece.",
			Category -> "Instrument Specifications"
		},
		ObjectiveMagnifications -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The objective magnifications available for this model of microscope.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FluorescenceFilters -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Nano*Meter, 1*Nano*Meter], GreaterP[0*Nano*Meter, 1*Nano*Meter]},
			Units -> {Meter Nano, Meter Nano},
			Description -> "The fluorescence filters available, based on the compatible optic modules for this instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers -> {"Excitation Wavelength","Emission Wavelength"}
		},

		(* New Fluorescence Imaging Fields *)
		CustomizableImagingChannel->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if a custom imaging channel can be created from a new combination of available FluorescenceExcitationWavelengths and FluorescenceEmissionWavelengths.",
			Category->"Instrument Specifications"
		},
		ImagingChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeImagingChannelP,
			Description->"Indicates the fluorescence imaging channels available for this model of microscope.",
			Category->"Instrument Specifications"
		},
		MaxImagingChannels->{
		    Format->Single,
		    Class->Integer,
		    Pattern:>GreaterP[0],
		    Description->"Maximum number of imaging channels allowed per each imaging run.",
		    Category->"Operating Limits"
		},
		FluorescenceExcitationWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of ImagingChannels, the wavelength that should be used to illuminate the sample.",
			IndexMatching->ImagingChannels,
			Category->"Instrument Specifications"
		},
		LumencorWavelengthNames->{
		    Format->Multiple,
		    Class->Expression,
		    Pattern:>LumencorWavelengthNameP,
		    Description->"For each member of FluorescenceExcitationWavelengths, the name used by Lumencor laser light source to refer to a given exciation wavelength.",
			Category->"Instrument Specifications",
			IndexMatching->FluorescenceExcitationWavelengths,
			Developer->True
		},
		FluorescenceEmissionWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of ImagingChannels, the wavelength at which the fluorescence emission of the sample should be imaged.",
			IndexMatching->ImagingChannels,
			Category->"Instrument Specifications"
		},
		EmissionFilters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,OpticalFilter],
			Description->"For each member of ImagingChannels, the emission filter available on this instrument model to filter fluorescence emission in a specified wavelength range.",
			IndexMatching->ImagingChannels,
			Category->"Instrument Specifications"
		},
		EmissionFilterPositions->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"For each member of FluorescenceEmissionWavelengths, the position index of each emission filter on the instrument.",
			IndexMatching->FluorescenceEmissionWavelengths,
			Category->"Instrument Specifications",
			Developer->True
		},
		DichroicFilterWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of ImagingChannels, the cutoff wavelength of the dichroic filter that allows longer wavelengths to be transmitted and reflects shorter wavelengths.",
			IndexMatching->ImagingChannels,
			Category->"Instrument Specifications"
		},
		DichroicFilters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,OpticalFilter],
			Description->"For each member of ImagingChannels, the dichroic filter available on this instrument model that allows wavelengths above cutoff to be transmitted and reflects shorter wavelengths below cutoff.",
			IndexMatching->ImagingChannels,
			Category->"Instrument Specifications"
		},
		DichroicFilterPositions->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"For each member of DichroicFilterWavelengths, the position index of each dichroic filter on the instrument.",
			IndexMatching->DichroicFilterWavelengths,
			Category->"Instrument Specifications",
			Developer->True
		},
		DefaultExcitationPowers->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"For each member of ImagingChannels, the default percent of maximum intensity of the light source that should be used to illuminate the sample. Higher percentages indicating higher intensities.",
			IndexMatching->ImagingChannels,
			Category->"Instrument Specifications"
		},
		DefaultTransmittedLightPower->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"The default percent of maximum intensity of the white light source that should be used to illuminate the sample. Higher percentages indicating higher intensities.",
			Category->"Instrument Specifications"
		},

		(* Image Acquisition settings *)
		Autofocus->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the microscope is fitted with an Autofocus feature to automatically find the focal plane of a sample.",
			Category->"Instrument Specifications"
		},
		PixelBinning->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Indicates the combining of \"n x n\" grid of pixels into a single pixel that is supported by this instrument model. Higher binning values result in higher overall signal-to-noise ratios but lower pixel resolutions.",
			Category->"Instrument Specifications"
		},
		ImageSizeX->{
		    Format->Single,
		    Class->Real,
		    Pattern:>GreaterP[0 Pixel],
			Units->Pixel,
		    Description->"Indicates the size of field of view in X direction (Width) of an unbinned image acquired by this instrument.",
			Category->"Instrument Specifications"
		},
		ImageSizeY->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Pixel],
			Units->Pixel,
			Description->"Indicates the size of field of view in Y direction (Length) of an unbinned image acquired by this instrument.",
			Category->"Instrument Specifications"
		},
		ImageScalesX->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer/Pixel],
			Units->Micrometer/Pixel,
			Description->"For each member of ObjectiveMagnifications, indicates the size of each pixel in X direction (Width) of an unbinned image acquired by this instrument.",
			IndexMatching->ObjectiveMagnifications,
			Category->"Instrument Specifications"
		},
		ImageScalesY->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer/Pixel],
			Units->Micrometer/Pixel,
			Description->"For each member of ObjectiveMagnifications, indicates the size of each pixel in Y direction (Length) of an unbinned image acquired by this instrument.",
			IndexMatching->ObjectiveMagnifications,
			Category->"Instrument Specifications"
		},
		TimelapseImaging->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this instrument model can image a sample at multiple time points.",
			Category->"Instrument Specifications"
		},
		ZStackImaging->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this instrument model can acquire a series of images at multiple z-axis positions from a sample.",
			Category->"Instrument Specifications"
		},
		DefaultZStepSizes->{
		    Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
		    Description->"For each member of ObjectiveMagnifications, indicates the recommended distance between images in z-series imaging.",
			IndexMatching->ObjectiveMagnifications,
			Category->"Instrument Specifications"
		},
		MinZStepSize->{
		    Format->Single,
		    Class->Real,
		    Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
		    Description->"Indicates the minimum distance between images in z-series imaging.",
			Category->"Operating Limits"
		},
		MaxZStepSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"Indicates the maximum distance between images in z-series imaging.",
			Category->"Operating Limits"
		},
		MinNumberOfZSteps->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->Micrometer,
			Description->"Indicates the minimum distance between images in z-series imaging.",
			Category->"Operating Limits"
		},
		(* TODO: Z = 0 is at the bottom for HCI. check if reference point is the same for Nikon. if not may need another field to indicate reference origin *)
		MaxFocalHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"Indicates the maximum distance that the imaging stage can move vertically to bring sample into focus.",
			Category->"Operating Limits"
		},
		ImageCorrectionMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeImageCorrectionP,
			Description->"Indicates the correction methods that can be applied to the acquired images by this instrument model. BackgroundCorrection removes stray light that is unrelated to light that reaches the sample. ShadingCorrection mitigates the uneven illumination of the sample that is visible around the edges of the image.",
			Category->"Instrument Specifications"
		},
		DefaultImageCorrections->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeImageCorrectionP,
			Description->"For each member of Modes, indicates the default image correction method that should be applied to the acquire image.",
			IndexMatching->Modes,
			Category->"Instrument Specifications"
		},
		ImageDeconvolution->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if this instrument model is fitted with a deconvolution algorithm that can be used to enhance contrast, improve image resolution, and sharpen the image.",
			Category->"Instrument Specifications"
		},
		SamplingMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeSamplingMethodP,
			Description->"The sampling pattern of images that can be acquired from the samples by this instrument model. SinglePoint: acquires an image at the center of each well or sample. Grid: acquires multiple images along specified rows and columns. Coordinates: acquires image(s) at requested coordinates in each well or on a microscopic slide. Adaptive: uses an algorithm to calculate the number of cells in each field of view to increase the chances of acquiring valid data, until the indicated number of cells specified in AdaptiveNumberOfCells is obtained.",
			Category->"Instrument Specifications"
		},
		DefaultSamplingMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>MicroscopeSamplingMethodP,
			Description->"Indicates the default sampling pattern that this instrument model uses to acquire image from a sample.",
			Category->"Instrument Specifications"
		},
		TransmittedLightColorCorrection->{
		    Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
		    Description->"Indicates if the instrument has a neutral color balance filter that can be placed into the transmitted light path to correct the color temperature during BrightField and PhaseContrast imaging.",
			Category->"Instrument Specifications"
		},

		(* Environmental Control *)
		TemperatureControlledEnvironment->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the microscope is fitted with a temperature-controlled sample chamber to maintain a specific temperature during imaging.",
			Category->"Instrument Specifications"
		},
		MinTemperatureControl->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units->Celsius,
			Description->"Minimum temperature at which this instrument model can perform thermal incubation while imaging.",
			Category->"Operating Limits"
		},
		MaxTemperatureControl->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units->Celsius,
			Description->"Maximum temperature at which this instrument model can perform thermal incubation while imaging.",
			Category->"Operating Limits"
		},
		CarbonDioxideControl->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the microscope is fitted with a carbon dioxide-controlled sample chamber to maintain a specified carbon dioxide percentage while imaging.",
			Category->"Operating Limits"
		},
		HumidityControl->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the microscope is fitted with a chamber that maintains humidity to prevent evaporation while imaging.",
			Category->"Operating Limits"
		},
		ActiveHumidityControl->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the microscope is fitted with a chamber that can maintain humidity at a specified percentage (or alternatively if the humidity is dependent on the temperature) while imaging.",
			Category->"Operating Limits"
		},

		(* BrightField and PhaseContrast Parts *)
		CondenserMinHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The minimum height, measured from the stage to the condenser bottom, that the condenser mount can be adjusted to.",
			Category->"Operating Limits"
		},
		CondenserMaxHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"The maximum height, measured from the stage to the condenser bottom, that the condenser mount can be adjusted to.",
			Category->"Operating Limits"
		},
		IlluminationFilters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,OpticalFilter],
			Description->"The neutral density filter(s) available on the microscope to used to reduced the intensity of the white illumination light used in bright-field and phase phase-contrast imaging.",
			Category->"Instrument Specifications"
		},
		IlluminationColorCorrectionFilter->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,OpticalFilter],
			Description->"The neutral color balance Filter(s) available on the microscope used to adjust the color temperature of the image during bright-field and phase-contrast imaging.",
			Category->"Instrument Specifications"
		},

		(* labware definition *)
		DefaultLabwareDefinitionFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the labware definition file which contains the plate's parameters.",
			Category->"Instrument Specifications",
			Developer->True
		},

		(* qualification image *)
		DefaultQualificationImageFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the images acquired during qualification.",
			Category->"Qualifications & Maintenance",
			Developer->True
		},

		(* microscope calibration *)
		MicroscopeCalibration->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the microscope can be calibrated by running a maintenance protocol.",
			Category->"Qualifications & Maintenance"
		},

		MinExposureTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millisecond],
			Units->Millisecond,
			Description->"The minimum amount of time for which a camera shutter can stay open when acquiring an image.",
			Category->"Operating Limits"
		},
		MaxExposureTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Millisecond],
			Units->Millisecond,
			Description->"The maximum amount of time for which a camera shutter can stay open when acquiring an image.",
			Category->"Operating Limits"
		},
		DefaultTargetMaxIntensity->{
		    Format->Single,
		    Class->Integer,
		    Pattern:>GreaterP[0],
		    Description->"Indicates the intensity that auto exposure should attempt to attain for the brightest pixel in the image.",
			Category->"Instrument Specifications"
		},
		MaxGrayLevel->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Indicates the intensity that auto exposure should attempt to attain for the brightest pixel in the image.",
			Category->"Instrument Specifications"
		}
	}
}];
