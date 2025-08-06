(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,Microscope],{
	Description->"Image data captured by a microscope.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* sample info *)
		CellModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Cell],
			Description->"The identity models of cell lines that the sample contains.",
			Category -> "General"
		},

		(* organizational info *)
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

		(* time-series info *)
		Timelapse->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the image acquired is contain time-series images.",
			Category -> "General"
		},
		TimelapseInterval->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"The amount of time between the start of an acquisition at one time point and the start of an acquisition at the next time point.",
			Category -> "General"
		},
		NumberOfTimepoints->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Number of time points that images were acquired from the sample during the course of imaging session.",
			Category -> "General"
		},

		(* z-series info *)
		ZStack->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the image acquired contain z-series images.",
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
		NumberOfZSteps->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"Number of positions along the sample's z-axis where the images were acquired.",
			Category -> "General"
		},

		(* site info *)
		SamplingNumberOfRows->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The number of rows that the images were acquired from the sample.",
			Category -> "General"
		},
		SamplingNumberOfColumns->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"The number of columns that the images were acquired from the sample.",
			Category -> "General"
		},
		SamplingRowSpacing->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[-85 Millimeter,85 Millimeter],
			Units->Micrometer,
			Description->"The distance between each row of images acquired from the sample.",
			Category -> "General"
		},
		SamplingColumnSpacing->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[-127 Millimeter,127 Millimeter],
			Units->Micrometer,
			Description->"The distance between each column of images acquired from the sample.",
			Category -> "General"
		},

		Images->{
			Format->Multiple,
			Class->{
				ImageFile->Link,
				ProtocolBatchNumber->Integer,
				DateAcquired->Date,
				Mode->Expression,

				(* optics *)
				ObjectiveMagnification->Real,
				ObjectiveNumericalAperture->Real,
				Objective->Link,

				(* data dimensions *)
				ImageTimepoint->Integer,
				ImageZStep->Integer,
				ImagingSite->Integer,

				(* imaging channel *)
				ExcitationWavelength->Real,
				EmissionWavelength->Real,
				DichroicFilterWavelength->Real,
				EmissionFilter->Link,
				DichroicFilter->Link,
				ExcitationPower->Real,
				TransmittedLightPower->Real,

				(* image info *)
				ExposureTime->Real,
				FocalHeight->Real,
				ImageSizeX->Real,
				ImageSizeY->Real,
				ImageScaleX->Real,
				ImageScaleY->Real,
				ImageBitDepth->Integer,
				PixelBinning->Integer,
				ImageCorrection->Expression,

				(* image physical location *)
				StagePositionX->Real,
				StagePositionY->Real,
				ImagingSiteRow->Integer,
				ImagingSiteColumn->Integer,
				ImagingSiteRowSpacing->Real,
				ImagingSiteColumnSpacing->Real,
				WellCenterOffsetX->Real,
				WellCenterOffsetY->Real
			},
			Pattern:>{
				ImageFile->_Link,
				ProtocolBatchNumber->GreaterP[0],
				DateAcquired->_?DateObjectQ,
				Mode->MicroscopeModeP,
				ObjectiveMagnification->GreaterP[0],
				ObjectiveNumericalAperture->GreaterP[0],
				Objective->_Link,
				ImageTimepoint->GreaterP[0],
				ImageZStep->GreaterP[0],
				ImagingSite->GreaterP[0],
				ExcitationWavelength->GreaterP[0 Nanometer],
				EmissionWavelength->GreaterP[0 Nanometer],
				DichroicFilterWavelength->GreaterP[0 Nanometer],
				EmissionFilter->_Link,
				DichroicFilter->_Link,
				ExcitationPower->GreaterEqualP[0 Percent],
				TransmittedLightPower->GreaterEqualP[0 Percent],
				ExposureTime->GreaterP[0 Millisecond],
				FocalHeight->GreaterEqualP[0 Micrometer],
				ImageSizeX->GreaterP[0 Pixel],
				ImageSizeY->GreaterP[0 Pixel],
				ImageScaleX->GreaterP[0 Micrometer/Pixel],
				ImageScaleY->GreaterP[0 Micrometer/Pixel],
				ImageBitDepth->GreaterP[0],
				PixelBinning->GreaterP[0],
				ImageCorrection->MicroscopeImageCorrectionP,
				StagePositionX->GreaterEqualP[0 Micrometer],
				StagePositionY->GreaterEqualP[0 Micrometer],
				ImagingSiteRow->GreaterP[0],
				ImagingSiteColumn->GreaterP[0],
				ImagingSiteRowSpacing->RangeP[-85 Millimeter,85 Millimeter],
				ImagingSiteColumnSpacing->RangeP[-127 Millimeter,127 Millimeter],
				WellCenterOffsetX->GreaterEqualP[-500 Millimeter],
				WellCenterOffsetY->GreaterEqualP[-500 Millimeter]
			},
			Relation->{
				ImageFile->Object[EmeraldCloudFile],
				ProtocolBatchNumber->Null,
				DateAcquired->Null,
				Mode->Null,
				ObjectiveMagnification->Null,
				ObjectiveNumericalAperture->Null,
				Objective->Object[Part,Objective]|Model[Part,Objective],
				ImageTimepoint->Null,
				ImageZStep->Null,
				ImagingSite->Null,
				ExcitationWavelength->Null,
				EmissionWavelength->Null,
				DichroicFilterWavelength->Null,
				EmissionFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				DichroicFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				ExcitationPower->Null,
				TransmittedLightPower->Null,
				ExposureTime->Null,
				FocalHeight->Null,
				ImageSizeX->Null,
				ImageSizeY->Null,
				ImageScaleX->Null,
				ImageScaleY->Null,
				ImageBitDepth->Null,
				PixelBinning->Null,
				ImageCorrection->Null,
				StagePositionX->Null,
				StagePositionY->Null,
				ImagingSiteRow->Null,
				ImagingSiteColumn->Null,
				ImagingSiteRowSpacing->Null,
				ImagingSiteColumnSpacing->Null,
				WellCenterOffsetX->Null,
				WellCenterOffsetY->Null
			},
			Units->{
				ImageFile->None,
				ProtocolBatchNumber->None,
				DateAcquired->None,
				Mode->None,
				ObjectiveMagnification->None,
				ObjectiveNumericalAperture->None,
				Objective->None,
				ImageTimepoint->None,
				ImageZStep->None,
				ImagingSite->None,
				ExcitationWavelength->Nanometer,
				EmissionWavelength->Nanometer,
				DichroicFilterWavelength->Nanometer,
				EmissionFilter->None,
				DichroicFilter->None,
				ExcitationPower->Percent,
				TransmittedLightPower->Percent,
				ExposureTime->Millisecond,
				FocalHeight->Micrometer,
				ImageSizeX->Pixel,
				ImageSizeY->Pixel,
				ImageScaleX->Micrometer/Pixel,
				ImageScaleY->Micrometer/Pixel,
				ImageBitDepth->None,
				PixelBinning->None,
				ImageCorrection->None,
				StagePositionX->Micrometer,
				StagePositionY->Micrometer,
				ImagingSiteRow->None,
				ImagingSiteColumn->None,
				ImagingSiteRowSpacing->Micrometer,
				ImagingSiteColumnSpacing->Micrometer,
				WellCenterOffsetX->Micrometer,
				WellCenterOffsetY->Micrometer
			},
			Headers->{
				ImageFile->"Image File",
				ProtocolBatchNumber->"Protocol Batch Number",
				DateAcquired->"Date Acquired",
				Mode->"Mode",
				ObjectiveMagnification->"Objective Magnification",
				ObjectiveNumericalAperture->"Numerical Aperture",
				Objective->"Objective",
				ImageTimepoint->"Time Point",
				ImageZStep->"Z Step",
				ImagingSite->"Imaging Site",
				ExcitationWavelength->"Excitation Wavelength",
				EmissionWavelength->"Emission Wavelength",
				DichroicFilterWavelength->"Dichroic Filter Wavelength",
				EmissionFilter->"Emission Filter",
				DichroicFilter->"Dichroic Filter",
				ExcitationPower->"Excitation Power",
				TransmittedLightPower->"Transmitted LightPower",
				ExposureTime->"Exposure Time",
				FocalHeight->"Focal Height",
				ImageSizeX->"Image Size X",
				ImageSizeY->"Image Size Y",
				ImageScaleX->"Image Scale X",
				ImageScaleY->"Image Scale Y",
				ImageBitDepth->"Bit Depth",
				PixelBinning->"Pixel Binning",
				ImageCorrection->"Image Correction",
				StagePositionX->"Stage Position X",
				StagePositionY->"Stage Position Y",
				ImagingSiteRow->"Imaging Site Row",
				ImagingSiteColumn->"Imaging Site Column",
				ImagingSiteRowSpacing->"Row Spacing",
				ImagingSiteColumnSpacing->"Column Spacing",
				WellCenterOffsetX->"Well Center Offset X",
				WellCenterOffsetY->"Well Center OffsetY"
			},
			Description->"The images acquired from the sample by a microscope.",
			Category->"Experimental Results"
		},
		
		(* Three fields for tiled images - Low, Medium, and High *)
		HighResolutionTiledImages->{
			Format->Multiple,
			Class->{
				
				ImageFile->Link,
				MeanDateAcquired->Date,
				Mode->Expression,
				
				(* optics *)
				ObjectiveMagnification->Real,
				ObjectiveNumericalAperture->Real,
				Objective->Link,
				
				(* data dimensions *)
				ImageTimepoint->Integer,
				ImageZStep->Integer,
				
				(* imaging channel *)
				ExcitationWavelength->Real,
				EmissionWavelength->Real,
				DichroicFilterWavelength->Real,
				EmissionFilter->Link,
				DichroicFilter->Link,
				ExcitationPower->Real,
				TransmittedLightPower->Real,
				ExposureTime->Real,
				FocalHeight->Real,
				
				(* image info *)
				ImageSizeX->Real,
				ImageSizeY->Real,
				ImageScaleX->Real,
				ImageScaleY->Real,
				ImageBitDepth->Integer,
				PixelBinning->Integer,
				ImageCorrection->Expression,
				WellCenterOffsetX->Real,
				WellCenterOffsetY->Real
			},
			Pattern:>{
				ImageFile->_Link,
				MeanDateAcquired->_?DateObjectQ,
				Mode->MicroscopeModeP,
				
				ObjectiveMagnification->GreaterP[0],
				ObjectiveNumericalAperture->GreaterP[0],
				Objective->_Link,
				
				ImageTimepoint->GreaterP[0],
				ImageZStep->GreaterP[0],
				
				ExcitationWavelength->GreaterP[0 Nanometer],
				EmissionWavelength->GreaterP[0 Nanometer],
				DichroicFilterWavelength->GreaterP[0 Nanometer],
				EmissionFilter->_Link,
				DichroicFilter->_Link,
				ExcitationPower->GreaterEqualP[0 Percent],
				TransmittedLightPower->GreaterEqualP[0 Percent],
				ExposureTime->GreaterP[0 Millisecond],
				FocalHeight->GreaterEqualP[0 Micrometer],
				
				ImageSizeX->GreaterP[0 Pixel],
				ImageSizeY->GreaterP[0 Pixel],
				ImageScaleX->GreaterP[0 Micrometer/Pixel],
				ImageScaleY->GreaterP[0 Micrometer/Pixel],
				ImageBitDepth->GreaterP[0],
				PixelBinning->GreaterP[0],
				ImageCorrection->MicroscopeImageCorrectionP,
				WellCenterOffsetX->GreaterEqualP[-500 Millimeter],
				WellCenterOffsetY->GreaterEqualP[-500 Millimeter]
			},
			Relation->{
				ImageFile->Object[EmeraldCloudFile],
				MeanDateAcquired->Null,
				Mode->Null,
				
				ObjectiveMagnification->Null,
				ObjectiveNumericalAperture->Null,
				Objective->Object[Part,Objective]|Model[Part,Objective],
				
				ImageTimepoint->Null,
				ImageZStep->Null,
				
				ExcitationWavelength->Null,
				EmissionWavelength->Null,
				DichroicFilterWavelength->Null,
				EmissionFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				DichroicFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				ExcitationPower->Null,
				TransmittedLightPower->Null,
				ExposureTime->Null,
				FocalHeight->Null,
				
				ImageSizeX->Null,
				ImageSizeY->Null,
				ImageScaleX->Null,
				ImageScaleY->Null,
				ImageBitDepth->Null,
				PixelBinning->Null,
				ImageCorrection->Null,
				WellCenterOffsetX->Null,
				WellCenterOffsetY->Null
			},
			Units->{
				ImageFile->None,
				MeanDateAcquired->None,
				Mode->None,
				
				ObjectiveMagnification->None,
				ObjectiveNumericalAperture->None,
				Objective->None,
				
				ImageTimepoint->None,
				ImageZStep->None,
				
				ExcitationWavelength->Nanometer,
				EmissionWavelength->Nanometer,
				DichroicFilterWavelength->Nanometer,
				EmissionFilter->None,
				DichroicFilter->None,
				ExcitationPower->Percent,
				TransmittedLightPower->Percent,
				ExposureTime->Millisecond,
				FocalHeight->Micrometer,
				
				ImageSizeX->Pixel,
				ImageSizeY->Pixel,
				ImageScaleX->Micrometer/Pixel,
				ImageScaleY->Micrometer/Pixel,
				ImageBitDepth->None,
				PixelBinning->None,
				ImageCorrection->None,
				WellCenterOffsetX->Micrometer,
				WellCenterOffsetY->Micrometer
			},
			Headers->{
				ImageFile->"Image File",
				MeanDateAcquired->"Date Acquired",
				Mode->"Mode",
				
				ObjectiveMagnification->"Objective Magnification",
				ObjectiveNumericalAperture->"Numerical Aperture",
				Objective->"Objective",
				
				ImageTimepoint->"Time Point",
				ImageZStep->"Z Step",
				
				ExcitationWavelength->"Excitation Wavelength",
				EmissionWavelength->"Emission Wavelength",
				DichroicFilterWavelength->"Dichroic Filter Wavelength",
				EmissionFilter->"Emission Filter",
				DichroicFilter->"Dichroic Filter",
				ExcitationPower->"Excitation Power",
				TransmittedLightPower->"Transmitted LightPower",
				ExposureTime->"Exposure Time",
				FocalHeight->"Focal Height",
				
				ImageSizeX->"Image Size X",
				ImageSizeY->"Image Size Y",
				ImageScaleX->"Image Scale X",
				ImageScaleY->"Image Scale Y",
				ImageBitDepth->"Bit Depth",
				PixelBinning->"Pixel Binning",
				ImageCorrection->"Image Correction",
				WellCenterOffsetX->"Well Center Offset X",
				WellCenterOffsetY->"Well Center Offset Y"
			},
			Description->"The high resolution tiled images created from the individual images of the sample by a microscope. All individual images taken on the same channel, at the same z-level, time point, and magnification are placed into a single image based on their physical x and y coordinates.",
			Category->"Experimental Results"
		},
		
		MediumResolutionTiledImages->{
			Format->Multiple,
			Class->{
				
				ImageFile->Link,
				MeanDateAcquired->Date,
				Mode->Expression,
				
				(* optics *)
				ObjectiveMagnification->Real,
				ObjectiveNumericalAperture->Real,
				Objective->Link,
				
				(* data dimensions *)
				ImageTimepoint->Integer,
				ImageZStep->Integer,
				
				(* imaging channel *)
				ExcitationWavelength->Real,
				EmissionWavelength->Real,
				DichroicFilterWavelength->Real,
				EmissionFilter->Link,
				DichroicFilter->Link,
				ExcitationPower->Real,
				TransmittedLightPower->Real,
				ExposureTime->Real,
				FocalHeight->Real,
				
				(* image info *)
				ImageSizeX->Real,
				ImageSizeY->Real,
				ImageScaleX->Real,
				ImageScaleY->Real,
				ImageBitDepth->Integer,
				PixelBinning->Integer,
				ImageCorrection->Expression,
				WellCenterOffsetX->Real,
				WellCenterOffsetY->Real,
				
				(* New Fields *)
				DownsamplingRate->Real
				
			},
			Pattern:>{
				ImageFile->_Link,
				MeanDateAcquired->_?DateObjectQ,
				Mode->MicroscopeModeP,
				
				ObjectiveMagnification->GreaterP[0],
				ObjectiveNumericalAperture->GreaterP[0],
				Objective->_Link,
				
				ImageTimepoint->GreaterP[0],
				ImageZStep->GreaterP[0],
				
				ExcitationWavelength->GreaterP[0 Nanometer],
				EmissionWavelength->GreaterP[0 Nanometer],
				DichroicFilterWavelength->GreaterP[0 Nanometer],
				EmissionFilter->_Link,
				DichroicFilter->_Link,
				ExcitationPower->GreaterEqualP[0 Percent],
				TransmittedLightPower->GreaterEqualP[0 Percent],
				ExposureTime->GreaterP[0 Millisecond],
				FocalHeight->GreaterEqualP[0 Micrometer],
				
				ImageSizeX->GreaterP[0 Pixel],
				ImageSizeY->GreaterP[0 Pixel],
				ImageScaleX->GreaterP[0 Micrometer/Pixel],
				ImageScaleY->GreaterP[0 Micrometer/Pixel],
				ImageBitDepth->GreaterP[0],
				PixelBinning->GreaterP[0],
				ImageCorrection->MicroscopeImageCorrectionP,
				WellCenterOffsetX->GreaterEqualP[-500 Millimeter],
				WellCenterOffsetY->GreaterEqualP[-500 Millimeter],
				
				DownsamplingRate->GreaterP[0]
				
			},
			Relation->{
				ImageFile->Object[EmeraldCloudFile],
				MeanDateAcquired->Null,
				Mode->Null,
				
				ObjectiveMagnification->Null,
				ObjectiveNumericalAperture->Null,
				Objective->Object[Part,Objective]|Model[Part,Objective],
				
				ImageTimepoint->Null,
				ImageZStep->Null,
				
				ExcitationWavelength->Null,
				EmissionWavelength->Null,
				DichroicFilterWavelength->Null,
				EmissionFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				DichroicFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				ExcitationPower->Null,
				TransmittedLightPower->Null,
				ExposureTime->Null,
				FocalHeight->Null,
				
				ImageSizeX->Null,
				ImageSizeY->Null,
				ImageScaleX->Null,
				ImageScaleY->Null,
				ImageBitDepth->Null,
				PixelBinning->Null,
				ImageCorrection->Null,
				WellCenterOffsetX->Null,
				WellCenterOffsetY->Null,
				
				DownsamplingRate->Null
			},
			Units->{
				ImageFile->None,
				MeanDateAcquired->None,
				Mode->None,
				
				ObjectiveMagnification->None,
				ObjectiveNumericalAperture->None,
				Objective->None,
				
				ImageTimepoint->None,
				ImageZStep->None,
				
				ExcitationWavelength->Nanometer,
				EmissionWavelength->Nanometer,
				DichroicFilterWavelength->Nanometer,
				EmissionFilter->None,
				DichroicFilter->None,
				ExcitationPower->Percent,
				TransmittedLightPower->Percent,
				ExposureTime->Millisecond,
				FocalHeight->Micrometer,
				
				ImageSizeX->Pixel,
				ImageSizeY->Pixel,
				ImageScaleX->Micrometer/Pixel,
				ImageScaleY->Micrometer/Pixel,
				ImageBitDepth->None,
				PixelBinning->None,
				ImageCorrection->None,
				WellCenterOffsetX->Micrometer,
				WellCenterOffsetY->Micrometer,
				
				DownsamplingRate-> None
			},
			Headers->{
				ImageFile->"Image File",
				MeanDateAcquired->"Date Acquired",
				Mode->"Mode",
				
				ObjectiveMagnification->"Objective Magnification",
				ObjectiveNumericalAperture->"Numerical Aperture",
				Objective->"Objective",
				
				ImageTimepoint->"Time Point",
				ImageZStep->"Z Step",
				
				ExcitationWavelength->"Excitation Wavelength",
				EmissionWavelength->"Emission Wavelength",
				DichroicFilterWavelength->"Dichroic Filter Wavelength",
				EmissionFilter->"Emission Filter",
				DichroicFilter->"Dichroic Filter",
				ExcitationPower->"Excitation Power",
				TransmittedLightPower->"Transmitted LightPower",
				ExposureTime->"Exposure Time",
				FocalHeight->"Focal Height",
				
				ImageSizeX->"Image Size X",
				ImageSizeY->"Image Size Y",
				ImageScaleX->"Image Scale X",
				ImageScaleY->"Image Scale Y",
				ImageBitDepth->"Bit Depth",
				PixelBinning->"Pixel Binning",
				ImageCorrection->"Image Correction",
				WellCenterOffsetX->"Well Center Offset X",
				WellCenterOffsetY->"Well Center Offset Y",
				
				DownsamplingRate-> "Downsampling Rate"
			},
			Description->"The medium resolution tiled images created from downsampling the full resolution tiled images. The downsampling rate is selected so that the total memory of the medium resolution images is at most 1 gigabyte.",
			Category->"Experimental Results"
		},
		
		LowResolutionTiledImages->{
			Format->Multiple,
			Class->{
				
				ImageFile->Link,
				MeanDateAcquired->Date,
				Mode->Expression,
				
				(* optics *)
				ObjectiveMagnification->Real,
				ObjectiveNumericalAperture->Real,
				Objective->Link,
				
				(* data dimensions *)
				ImageTimepoint->Integer,
				ImageZStep->Integer,
				
				(* imaging channel *)
				ExcitationWavelength->Real,
				EmissionWavelength->Real,
				DichroicFilterWavelength->Real,
				EmissionFilter->Link,
				DichroicFilter->Link,
				ExcitationPower->Real,
				TransmittedLightPower->Real,
				ExposureTime->Real,
				FocalHeight->Real,
				
				(* image info *)
				ImageSizeX->Real,
				ImageSizeY->Real,
				ImageScaleX->Real,
				ImageScaleY->Real,
				ImageBitDepth->Integer,
				PixelBinning->Integer,
				ImageCorrection->Expression,
				WellCenterOffsetX->Real,
				WellCenterOffsetY->Real,
				
				(* New Fields *)
				DownsamplingRate->Real
				
			},
			Pattern:>{
				ImageFile->_Link,
				MeanDateAcquired->_?DateObjectQ,
				Mode->MicroscopeModeP,
				
				ObjectiveMagnification->GreaterP[0],
				ObjectiveNumericalAperture->GreaterP[0],
				Objective->_Link,
				
				ImageTimepoint->GreaterP[0],
				ImageZStep->GreaterP[0],
				
				ExcitationWavelength->GreaterP[0 Nanometer],
				EmissionWavelength->GreaterP[0 Nanometer],
				DichroicFilterWavelength->GreaterP[0 Nanometer],
				EmissionFilter->_Link,
				DichroicFilter->_Link,
				ExcitationPower->GreaterEqualP[0 Percent],
				TransmittedLightPower->GreaterEqualP[0 Percent],
				ExposureTime->GreaterP[0 Millisecond],
				FocalHeight->GreaterEqualP[0 Micrometer],
				
				ImageSizeX->GreaterP[0 Pixel],
				ImageSizeY->GreaterP[0 Pixel],
				ImageScaleX->GreaterP[0 Micrometer/Pixel],
				ImageScaleY->GreaterP[0 Micrometer/Pixel],
				ImageBitDepth->GreaterP[0],
				PixelBinning->GreaterP[0],
				ImageCorrection->MicroscopeImageCorrectionP,
				WellCenterOffsetX->GreaterEqualP[-500 Millimeter],
				WellCenterOffsetY->GreaterEqualP[-500 Millimeter],
				
				DownsamplingRate->GreaterP[0]
				
			},
			Relation->{
				ImageFile->Object[EmeraldCloudFile],
				MeanDateAcquired->Null,
				Mode->Null,
				
				ObjectiveMagnification->Null,
				ObjectiveNumericalAperture->Null,
				Objective->Object[Part,Objective]|Model[Part,Objective],
				
				ImageTimepoint->Null,
				ImageZStep->Null,
				
				ExcitationWavelength->Null,
				EmissionWavelength->Null,
				DichroicFilterWavelength->Null,
				EmissionFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				DichroicFilter->Object[Part,OpticalFilter]|Model[Part,OpticalFilter],
				ExcitationPower->Null,
				TransmittedLightPower->Null,
				ExposureTime->Null,
				FocalHeight->Null,
				
				ImageSizeX->Null,
				ImageSizeY->Null,
				ImageScaleX->Null,
				ImageScaleY->Null,
				ImageBitDepth->Null,
				PixelBinning->Null,
				ImageCorrection->Null,
				WellCenterOffsetX->Null,
				WellCenterOffsetY->Null,
				
				DownsamplingRate->Null
			},
			Units->{
				ImageFile->None,
				MeanDateAcquired->None,
				Mode->None,
				
				ObjectiveMagnification->None,
				ObjectiveNumericalAperture->None,
				Objective->None,
				
				ImageTimepoint->None,
				ImageZStep->None,
				
				ExcitationWavelength->Nanometer,
				EmissionWavelength->Nanometer,
				DichroicFilterWavelength->Nanometer,
				EmissionFilter->None,
				DichroicFilter->None,
				ExcitationPower->Percent,
				TransmittedLightPower->Percent,
				ExposureTime->Millisecond,
				FocalHeight->Micrometer,
				
				ImageSizeX->Pixel,
				ImageSizeY->Pixel,
				ImageScaleX->Micrometer/Pixel,
				ImageScaleY->Micrometer/Pixel,
				ImageBitDepth->None,
				PixelBinning->None,
				ImageCorrection->None,
				WellCenterOffsetX->Micrometer,
				WellCenterOffsetY->Micrometer,
				
				DownsamplingRate-> None
			},
			Headers->{
				ImageFile->"Image File",
				MeanDateAcquired->"Date Acquired",
				Mode->"Mode",
				
				ObjectiveMagnification->"Objective Magnification",
				ObjectiveNumericalAperture->"Numerical Aperture",
				Objective->"Objective",
				
				ImageTimepoint->"Time Point",
				ImageZStep->"Z Step",
				
				ExcitationWavelength->"Excitation Wavelength",
				EmissionWavelength->"Emission Wavelength",
				DichroicFilterWavelength->"Dichroic Filter Wavelength",
				EmissionFilter->"Emission Filter",
				DichroicFilter->"Dichroic Filter",
				ExcitationPower->"Excitation Power",
				TransmittedLightPower->"Transmitted LightPower",
				ExposureTime->"Exposure Time",
				FocalHeight->"Focal Height",
				
				ImageSizeX->"Image Size X",
				ImageSizeY->"Image Size Y",
				ImageScaleX->"Image Scale X",
				ImageScaleY->"Image Scale Y",
				ImageBitDepth->"Bit Depth",
				PixelBinning->"Pixel Binning",
				ImageCorrection->"Image Correction",
				WellCenterOffsetX->"Well Center Offset X",
				WellCenterOffsetY->"Well Center Offset Y",
				
				DownsamplingRate-> "Downsampling Rate"
			},
			Description->"The low resolution tiled images created from downsampling the full resolution tiled images. The downsampling rate is selected so that the total memory of the low resolution images enable smooth interactivity.",
			Category->"Experimental Results"
		},
		
		HighResolutionPartitionedImages -> {
			Format -> Multiple,
			Class -> {
				Integer,
				Integer,
				Integer,
				Integer,
				Expression,
				Expression,
				Link
			},
			Pattern :> {
				_?IntegerQ,
				_?IntegerQ,
				_?IntegerQ,
				_?IntegerQ,
				{_?NumericQ, _?NumericQ},
				{_?NumericQ, _?NumericQ},
				_Link
			},
			Relation -> {
				Null,
				Null,
				Null,
				Null,
				Null,
				Null,
				Object[EmeraldCloudFile]
			},
			Headers -> {
				"Magnification",
				"Time",
				"Z-step",
				"Channel",
				"X-range",
				"Y-range",
				"Image Cloud File"
			},
			Description -> "Subsections of the high resolution tiled images with their image context and pixel ranges. The subsections are used to control the memory use of displaying high resolution images in PlotMicroscope.",
			Category -> "Experimental Results",
			Developer -> True
		},
		

		(* ---old fields. will be deprecated--- *)
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the sample for the primary fluorescence image.",
			Category -> "General",
			Abstract -> True
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which fluorescence emitted from the sample is measured at for the primary fluorescence image.",
			Category -> "General",
			Abstract -> True
		},
		SecondaryExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the sample for the secondary fluorescence image.",
			Category -> "General",
			Abstract -> True
		},
		SecondaryEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which fluorescence emitted from the sample is measured at for the secondary fluorescence image.",
			Category -> "General",
			Abstract -> True
		},
		TertiaryExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the sample for the third fluorescence image.",
			Category -> "General",
			Abstract -> True
		},
		TertiaryEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which fluorescence emitted from the sample is measured at for the third fluorescence image.",
			Category -> "General",
			Abstract -> True
		},
		PhaseContrastExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light for the phase contrast image.",
			Category -> "General",
			Abstract -> True
		},
		FluorescenceExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light at the primary emission wavelength during imaging.",
			Category -> "General",
			Abstract -> True
		},
		SecondaryFluorescenceExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light at the primary emission wavelength during imaging.",
			Category -> "General",
			Abstract -> True
		},
		TertiaryFluorescenceExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light at the primary emission wavelength during imaging.",
			Category -> "General",
			Abstract -> True
		},
		Scale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Pixel/(Meter*Micro))],
			Units -> Pixel/(Meter Micro),
			Description -> "Relationship between number of pixels in the image and actual distance.",
			Category -> "General"
		},
		CameraTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature of the microscope camera when the images were taken.",
			Category -> "General"
		},
		StageX -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "The x-coordinate of the microscope stage (relative to the origin at the bottom left corner) at which the images were taken.",
			Category -> "General"
		},
		StageY -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "The y-coordinate of the microscope stage (relative to the origin at the bottom left corner) at which the images were taken.",
			Category -> "General"
		},
		Stain -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample]
			],
			Description -> "The model of chemical used to stain the specimen being imaged.",
			Category -> "General"
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate],
			Description -> "The model of the plate containing the samples used in the experiment.",
			Category -> "General"
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution],
				Model[Sample],
				Model[Sample, Media]
			],
			Description -> "The model of buffer used in the experiment.",
			Category -> "General"
		},
		Well -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellP,
			Description -> "Well in the plate that the data is taken from.",
			Category -> "General"
		},
		PhaseContrastImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PhaseContrastImageFile]}, ImportCloudFile[Field[PhaseContrastImageFile]]],
			Pattern :> _Image,
			Description -> "Returns the image taken under phase contrast conditions.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		FluorescenceImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[FluorescenceImageFile]}, ImportCloudFile[Field[FluorescenceImageFile]]],
			Pattern :> _Image,
			Description -> "Returns the primary fluorescence image.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SecondaryFluorescenceImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[SecondaryFluorescenceImageFile]}, ImportCloudFile[Field[SecondaryFluorescenceImageFile]]],
			Pattern :> _Image,
			Description -> "Returns the secondary fluorescence image.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		TertiaryFluorescenceImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[TertiaryFluorescenceImageFile]}, ImportCloudFile[Field[TertiaryFluorescenceImageFile]]],
			Pattern :> _Image,
			Description -> "Returns the tertiary fluorescence image.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		PhaseContrastImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The raw image taken under phase contrast conditions.",
			Category -> "Experimental Results"
		},
		FluorescenceImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The raw fluorescence image captured at the primary emission wavelength.",
			Category -> "Experimental Results"
		},
		SecondaryFluorescenceImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The raw fluorescence image captured at the secondary emission wavelength.",
			Category -> "Experimental Results"
		},
		TertiaryFluorescenceImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The raw fluorescence image captured at the tertiary emission wavelength.",
			Category -> "Experimental Results"
		},
		MicroscopeOverlay -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Microscope image analyses that used this data in overlaying multiple images while varying transparency, color, contrast and brightness.",
			Category -> "Analysis & Reports"
		},
		AdjustmentAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Microscope image analyses that used this data in adjusting contrast and brightness of image channels.",
			Category -> "Analysis & Reports"
		},
		CellCountAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A list of the cell counting analyses that were performed on this microscope data.",
			Category -> "Analysis & Reports"
		},
		PhaseContrastCellCount -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CellCountAnalyses],Field[PhaseContrastImage]}, Computables`Private`cellCountComputable[Field[CellCountAnalyses], Field[PhaseContrastImage]]],
			Pattern :> GreaterEqualP[0],
			Description -> "The most recent cell count of the phase contrast image analysis.",
			Category -> "Analysis & Reports"
		},
		FluorescenceCellCount -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CellCountAnalyses],Field[FluorescenceImage]}, Computables`Private`cellCountComputable[Field[CellCountAnalyses], Field[FluorescenceImage]]],
			Pattern :> GreaterEqualP[0],
			Description -> "The most recent cell count of the image analysis on the primary fluorescence image.",
			Category -> "Analysis & Reports"
		},
		SecondaryFluorescenceCellCount -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CellCountAnalyses],Field[SecondaryFluorescenceImage]}, Computables`Private`cellCountComputable[Field[CellCountAnalyses], Field[SecondaryFluorescenceImage]]],
			Pattern :> GreaterEqualP[0],
			Description -> "The most recent cell count of the image analysis on the secondary fluorescence image.",
			Category -> "Analysis & Reports"
		},
		TertiaryFluorescenceCellCount -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CellCountAnalyses],Field[TertiaryFluorescenceImage]}, Computables`Private`cellCountComputable[Field[CellCountAnalyses], Field[TertiaryFluorescenceImage]]],
			Pattern :> GreaterEqualP[0],
			Description -> "The most recent cell count of the image analysis on the tertiary fluorescence image.",
			Category -> "Analysis & Reports"
		}
	}
}];
