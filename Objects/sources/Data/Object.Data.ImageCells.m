(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,ImageCells],{
	Description->"Image data captured by a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Organizational Information *)
		ParentDataObject->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,ImageCells],
			Description->"The parent data object the image belongs to.",
			Category->"Organizational Information",
			Developer->True
		},
		ProtocolBatchNumber->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Indicates the batch number of the protocol in which the image was acquired.",
			Category->"Organizational Information",
			Developer->True
		},
		Software->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The acquisition software on the instrument used to acquire the images.",
			Category->"Organizational Information"
		},
		SoftwareVersion->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"Indicates the version of the acquisition software on the instrument used to acquire the images.",
			Category->"Organizational Information"
		},
		DateAcquired->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The date on which the image was acquired.",
			Category->"Organizational Information"
		},

		(* image information *)
		Mode->{
			Format->Single,
			Class->Expression,
			Pattern:>MicroscopeModeP,
			Description->"The type of microscopy technique used to acquire an image of a sample.",
			Category -> "General"
		},
		ImageSizeX->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Pixel],
			Units->Pixel,
			Description->"Indicates the size of the image in X direction (Width) measure in pixel.",
			Category -> "General"
		},
		ImageSizeY->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Pixel],
			Units->Pixel,
			Description->"Indicates the size of the image in Y direction (Length) measured in pixel.",
			Category -> "General"
		},
		ImageScaleX->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer/Pixel],
			Units->Micrometer/Pixel,
			Description->"Indicates the size of each pixel in X direction (Width) of the image.",
			Category -> "General"
		},
		ImageScaleY->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer/Pixel],
			Units->Micrometer/Pixel,
			Description->"Indicates the size of each pixel in Y direction (Length) of the image.",
			Category -> "General"
		},
		ImageBitDepth->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Indicates the binary range of possible grayscale values stored in each pixel of the image.",
			Category -> "General"
		},
		PixelBinning->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Indicates the combining of \"n x n\" grid of pixels into a single pixel that is supported by this instrument model. Higher binning values result in higher overall signal-to-noise ratios but lower pixel resolutions.",
			Category -> "General"
		},

		(* image physical location *)
		StagePositionX->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Micrometer],
			Units->Micrometer,
			Description->"Indicates the X value of the stage at the time the image was acquired.",
			Category -> "General"
		},
		StagePositionY->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Micrometer],
			Units->Micrometer,
			Description->"Indicates the Y value of the stage at the time the image was acquired.",
			Category -> "General"
		},
		FocalHeight->{
			Format->Single,
			Class->Real,
			Pattern:>DistanceP,
			Units->Micrometer,
			Description->"Indicates the vertical position of the objective at the time the image was acquired relative to the lowest objective position.",
			Category -> "General"
		},
		ImagingSiteRow->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Indicates the row of the grid representing all the imaging sites that the image was acquired from. Row 1 is the top row of the grid.",
			Category -> "General"
		},
		ImagingSiteColumn->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Indicates the column of the grid representing all the imaging sites that the image was acquired from. Column 1 is the left most column of the grid.",
			Category -> "General"
		},
		WellCenterOffsetX->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[-100 Millimeter],
			Units->Micrometer,
			Description->"Indicates the position at which the image was acquired in the X direction relative to the center of the well which has coordinates of (0,0).",
			Category -> "General"
		},
		WellCenterOffsetY->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[-100 Millimeter],
			Units->Micrometer,
			Description->"Indicates the position at which the image was acquired in the Y direction relative to the center of the well which has coordinates of (0,0).",
			Category -> "General"
		},


		(* instrument's environmental data *)
		Temperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"Indicates the temperature of the stage at the time the image was acquired.",
			Category -> "General"
		},
		CarbonDioxidePercentage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Percent],
			Units->Percent,
			Description->"Indicates percentage of CO2 in the imaging chamber at the time the image was acquired.",
			Category -> "General"
		},


		(* fields for organizing multi-dimensional data *)

		Timelapse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the image acquired is a time-series image.",
			Category -> "General"
		},
		TimelapseInterval->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"The amount of time between the start of an acquisition at one time point and the start of an acquisition at the next time point.",
			Category -> "General"
		},
		Timepoints->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"The list of time points when the images were acquired during the course of imaging session.",
			Category -> "General"
		},
		TimeSeriesData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,ImageCells],
			Description->"For each member of Timepoints, the data object containing images acquired from the sample.",
			Category->"Experimental Results",
			IndexMatching->Timepoints
		},
		ZStack->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the image acquired is a z-stack image.",
			Category -> "General"
		},
		ZStepSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"The distance between each image plane in the Z-Stack.",
			Category -> "General"
		},
		ZPlanes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[-1000 Micrometer],
			Units->Micrometer,
			Description->"The list of positions along the sample's z-axis where the images were acquired. Negative values indicate planes that are below the sample's focal plane (as defined in FocalHeight).",
			Category -> "General"
		},
		ZSeriesData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,ImageCells],
			Description->"For each member of ZPlanes, the data object containing images acquired from the sample at a specific plane along the z-axis.",
			Category->"Experimental Results",
			IndexMatching->ZPlanes
		},

		(* TODO: imaging site level organization *)
		ImagingSiteData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data,ImageCells],
			Description->"The list of data objects containing images acquired from the sample at a specific imaging site in the XY plane.",
			Category->"Experimental Results"
		},


		(* --Imaging Information-- *)

		(* optics *)
		Objective->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Objective],
			Description->"The objective lens used to acquire the image from SamplesIn.",
			Category->"Imaging"
		},
		ObjectiveMagnification->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[1],
			Units->None,
			Description->"The magnification power used to acquire the image which is defined by the ratio between the dimensions of the image and the sample.",
			Category->"Imaging"
		},
		ObjectiveNumericalAperture->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The numerical aperture of the objective used to acquire the image.",
			Category->"Imaging"
		},

		(* illumination and detection *)
		ImagingChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeImagingChannelP,
			Description->"Indicates the fluorescence imaging channels used to acquire the images. Each imaging channel has a unique combination of excitation and emission wavelengths.",
			Category->"Imaging"
		},
		ExposureTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millisecond],
			Units->Millisecond,
			Description->"For each member of ImagingChannels, the length of time that the camera collects the signal from the sample.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},
		ExcitationWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of ImagingChannels, the wavelength of excitation light used to illuminate the sample when imaging with ConfocalFluorescence or Epifluorescence Mode.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},
		ExcitationPowers->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Percent],
			Units->Percent,
			Description->"For each member of ImagingChannels, the percent of maximum intensity of the light source used to illuminate the sample.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},
		TransmittedLightPowers->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Percent],
			Units->Percent,
			Description->"For each member of ImagingChannels, the percent of maximum intensity of the transmitted light used to illuminate the sample.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},
		DichroicFilters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,OpticalFilter],
			Description->"For each member of ImagingChannels, the dichroic filter used in the light path at the time the image was acquired to selectively pass fluorescence emitted from the sample and reflect excitation light.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},
		EmissionFilters->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,OpticalFilter],
			Description->"For each member of ImagingChannels, the optical filter used in the light path at the time the image was acquired to selectively pass fluorescence emitted from the sample.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},

		(* image correction method *)
		ImageCorrections->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeImageCorrectionP,
			Description->"For each member of ImagingChannels, the correction method applied to the image after acquisition to remove stray light or mitigate the uneven illumination.",
			Category->"Imaging",
			IndexMatching->ImagingChannels
		},

		(* raw image data *)
		ImageFiles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"For each member of ImagingChannels, the raw image acquired from the sample.",
			Category->"Experimental Results",
			IndexMatching->ImagingChannels
		},

		(* Analysis and Reports *)
		MicroscopeOverlay -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Microscope image analyses that used this data in overlaying multiple images while varying transparency, color, contrast and brightness.",
			Category -> "Analysis & Reports"
		},
		CellCountAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of the cell counting analyses that were performed on this microscope data.",
			Category -> "Analysis & Reports"
		}
	}
}];
