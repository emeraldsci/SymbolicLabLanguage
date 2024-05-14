(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,ImageCells],
	{
		Description->"A detailed set of parameters that specifies a single imaging step of a microscope in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Sample->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(ObjectReferenceP[{Object[Sample],Object[Container],Model[Sample],Model[Container]}]|_String)..},
				Description->"The sample that should be imaged by a microscope.",
				Category->"General",
				Migration->NMultiple
			},
			SampleLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(_String|Null)..},
				Description->"For each member of Sample, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},
			SampleContainerLabel->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{(_String|Null)..},
				Description->"For each member of Sample, the label of the sample's container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category->"General",
				IndexMatching->Sample,
				Migration->NMultiple
			},

			(* non-index matching options *)
			Instrument->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Instrument,Microscope],
					Object[Instrument,Microscope]
				],
				Description->"For each member of SampleLink, the microscope that will be used to image the provided samples.",
				Category->"General"
			},
			MicroscopeOrientation->{
				Format->Single,
				Class->Expression,
				Pattern:>MicroscopeViewOrientationP,
				Description->"The location of the objective lens relative to the sample on the microscope stage. Inverted refers to having the objective lens below the sample. Only Inverted microscopes are currently available at ECL.",
				Category->"Calibration"
			},
			ReCalibrateMicroscope->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the optical components of the microscope should be adjusted before imaging the sample.",
				Category->"Calibration"
			},
			MicroscopeCalibration->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Maintenance,CalibrateMicroscope]],
				Description->"A calibration object that specifies a set of parameters used to adjust optical components of the microscope.",
				Category->"Calibration"
			},
			TemperatureReal->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"For each member of SampleLink, the temperature in real value of the stage where the sample container is placed during imaging.",
				Category->"Environmental Controls",
				Migration->SplitField
			},
			TemperatureExpression->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[Ambient],
				Description->"For each member of SampleLink, the temperature (if it's ambient) of the stage where the sample container is placed during imaging.",
				Category->"Environmental Controls",
				Migration->SplitField
			},
			CarbonDioxide->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the sample will be incubated with CO2 during imaging.",
				Category->"Environmental Controls"
			},
			CarbonDioxidePercentage->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0*Percent],
				Units->Percent,
				Description->"Indicates percentage of CO2 in the gas mixture that will be provided to the sample during imaging.",
				Category->"Environmental Controls"
			},

			(* pool index matching options *)
			ContainerOrientation->{
				Format->Multiple,
				Class->Expression,
				Pattern:>MicroscopeContainerOrientationP,
				Description->"The orientation of the sample container when placed on the microscope stage for imaging.",
				Category->"Image Acquisition"
			},
			EquilibrationTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Hour],
				Units->Minute,
				Description->"The amount of time for which the samples are placed on the stage of the microscope before the first image is acquired.",
				Category->"Image Acquisition"
			},
			PlateBottomThickness->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Meter],
				Units->Millimeter,
				Description->"The thickness of the well bottom of the sample's container, which is used to determine the position of the CorrectionCollar on high magnification objective lenses to correct for optical aberrations.",
				Category->"Image Acquisition"
			},
			CoverslipThickness->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Meter],
				Units->Millimeter,
				Description->"The thickness of the coverslip, which is used to determine the position of the CorrectionCollar on high magnification objective lenses to correct for optical aberrations.",
				Category->"Image Acquisition"
			},
			ObjectiveMagnification->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The magnification power defined by the ratio between the dimensions of the image and the sample. Low magnification power (4X and 10X) is recommended for acquiring an overview image of a sample. High magnification power (20X, 40X, 60X) is recommended for imaging detailed structure of a large tissue sample or intracellular structures.",
				Category->"Image Acquisition"
			},
			PixelBinning->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The \"n x n\" grid of pixels whose intensity values should be combined into a single pixel. Higher binning values result in higher overall signal-to-noise ratios but lower pixel resolutions.",
				Category->"Image Acquisition"
			},
			Images->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{AcquireImagePrimitiveP..},
				Description->"A list of acquisition parameters used to image a sample. Each list of acquisition parameters corresponds to a single output image acquired from the input sample.",
				Category->"Image Acquisition",
				Migration->NMultiple
			},
			AdjustmentSampleLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Sample],Model[Sample]],
				Description->"The sample that should be used to adjust the ExposureTime and FocalHeight in each imaging session. In each sample pool, only one sample is allowed to be used as AdjustmentSample. If set to All, the ExposureTime and FocalHeight will be adjusted for each sample individually.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			AdjustmentSampleString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"The sample that should be used to adjust the ExposureTime and FocalHeight in each imaging session. In each sample pool, only one sample is allowed to be used as AdjustmentSample. If set to All, the ExposureTime and FocalHeight will be adjusted for each sample individually.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			AdjustmentSampleExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[All],
				Description->"The sample that should be used to adjust the ExposureTime and FocalHeight in each imaging session. In each sample pool, only one sample is allowed to be used as AdjustmentSample. If set to All, the ExposureTime and FocalHeight will be adjusted for each sample individually.",
				Category->"Image Acquisition",
				Migration->SplitField
			},
			SamplingPattern->{
				Format->Multiple,
				Class->Expression,
				Pattern:>MicroscopeSamplingMethodP,
				Description->"The pattern of images that will be acquired from the samples. SinglePoint: acquires an image at the center of each well or sample. Grid: acquires multiple images along specified rows and columns. Coordinates: acquires image(s) at requested coordinates in each well or on a microscopic slide. Adaptive: uses an algorithm to calculate the number of cells in each field of view to increase the chances of acquiring valid data, until the indicated number of cells specified in AdaptiveNumberOfCells is obtained.",
				Category->"Sampling"
			},
			SamplingNumberOfRows->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The number of rows which will be acquired for each sample if the Grid SamplingPattern is selected. If Adaptive SamplingPattern is selected, SamplingNumberOfRows specifies maximum number of rows to be imaged if AdaptiveNumberOfCells cannot be reached.",
				Category->"Sampling Regions"
			},
			SamplingNumberOfColumns->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The number of columns which will be acquired for each sample if the Grid SamplingPattern is selected. If Adaptive SamplingPattern is selected, SamplingNumberOfColumns specifies maximum number of columns to be imaged if AdaptiveNumberOfCells cannot be reached.",
				Category->"Sampling Regions"
			},
			SamplingRowSpacing->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>Alternatives[GreaterP[-100*Millimeter],RangeP[0*Percent,100*Percent]],
				Description->"The distance between each row of images to be acquired. Negative distances indicate overlapping regions between adjacent rows. Overlapping regions between rows can also be specified as percentage if desired.",
				Category->"Sampling Regions"
			},
			SamplingColumnSpacing->{
				Format->Multiple,
				Class->VariableUnit,
				Pattern:>Alternatives[GreaterP[-100*Millimeter],RangeP[0*Percent,100*Percent]],
				Description->"The distance between each column of images to be acquired. Negative values indicate overlapping regions between adjacent columns. Overlapping regions between columns can also be specified as percentage if desired.",
				Category->"Sampling Regions"
			},
			SamplingCoordinates->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{RangeP[-127 Millimeter,127 Millimeter],RangeP[-85 Millimeter,85 Millimeter]}..},
				Description->"Specifies the positions at which images are acquired. The coordinates in the form (X,Y) are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
				Category->"Sampling Regions"
			},
			AdaptiveExcitationWaveLengthReal->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Nanometer],
				Units->Nanometer,
				Description->"Specifies the excitation wavelength of the light source that will be used to determine the number of cells in each field of view for the Adaptive SamplingPattern.",
				Category->"Adaptive Sampling",
				Migration->SplitField
			},
			AdaptiveExcitationWaveLengthExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Alternatives[TransmittedLight],
				Description->"Specifies the excitation wavelength of the light source that will be used to determine the number of cells in each field of view for the Adaptive SamplingPattern.",
				Category->"Adaptive Sampling",
				Migration->SplitField
			},
			AdaptiveNumberOfCells->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"Specifies the minimum cell count per well that the instrument will work to satisfy by acquiring images from multiple regions before moving to the next sample.",
				Category->"Adaptive Sampling"
			},
			AdaptiveMinNumberOfImages->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The minimum number of regions that must be acquired when using the Adaptive SamplingPattern, even if the specified cell count (AdaptiveNumberOfCells) is already reached.",
				Category->"Adaptive Sampling"
			},
			AdaptiveCellWidth->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Span[DistanceP,DistanceP],
				Description->"Specifies the expected range of cell size in the sample. The instrument uses this range to determine which features in the image will be counted as cells.",
				Category->"Adaptive Sampling"
			},
			AdaptiveIntensityThreshold->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The intensity above local background value that a putative cell needs to have in order to be counted. The intensity above local background value is calculated by subtracting the gray value of the surrounding background from the gray level value of a putative cell. Any feature in an image is considered to be a putative cell if its size falls within the specified cell width (AdaptiveCellWidth).",
				Category->"Adaptive Sampling"
			},
			Timelapse->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the sample will be imaged at multiple time points.",
				Category->"Time Lapse Imaging"
			},
			TimelapseInterval->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Hour],
				Units->Hour,
				Description->"The amount of time between the start of an acquisition at one time point and the start of an acquisition at the next time point.",
				Category->"Time Lapse Imaging"
			},
			TimelapseDuration->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Hour],
				Units->Hour,
				Description->"The total amount of time that the Timelapse images will be acquired for the sample.",
				Category->"Time Lapse Imaging"
			},
			NumberOfTimepoints->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The number of images that will be acquired from the sample in during the course of Timelapse imaging.",
				Category->"Time Lapse Imaging"
			},
			ContinuousTimelapseImaging->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if images from multiple time points should be acquired from the samples in a single imaging session.",
				Category->"Time Lapse Imaging"
			},
			TimelapseAcquisitionOrder->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ImageCellsTimelapseAcquitionOrderP,
				Description->"Determines the order in which the time-series images are acquired with respect to the sample's location in the plate.",
				Category->"Time Lapse Imaging"
			},
			ZStack->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if a series of images at multiple z-axis positions will be acquired for the sample.",
				Category->"Z-Stack Imaging"
			},
			ZStepSize->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Micrometer],
				Units->Micrometer,
				Description->"The distance between each image plane in the Z-Stack.",
				Category->"Z-Stack Imaging"
			},
			NumberOfZSteps->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"The total number of image planes that will be acquired in the Z-stack.",
				Category->"Z-Stack Imaging"
			},
			ZStackSpan->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Span[DistanceP,DistanceP],
				Description->"The range of Z-heights that the microscope will acquire images from in a Z-Stack. Negative values indicate planes that are below the sample's imaging plane.",
				Category->"Z-Stack Imaging"
			},

			(* develop fields storing site coordinates to use in compiler/exporter *)
			AllImagingSiteCoordinates->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{RangeP[-127000,127000],RangeP[-85000,85000]}..},
				Description->"Specifies all imaging positions in each well determined from SamplingNumberOfColumns and SamplingNumberOfRows. The coordinates in the form (X Micrometer,Y Micrometer) are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
				Category->"Scan Area",
				Developer->True
			},
			UsableImagingSiteCoordinates->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{{RangeP[-127000,127000],RangeP[-85000,85000]}..},
				Description->"Specifies all imaging positions in each well that can be imaged. The coordinates in the form (X Micrometer,Y Micrometer) are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
				Category->"Scan Area",
				Developer->True
			},

			(* ---developer fields for batch handling--- *)
			BatchedSamplesIn->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Sample],Model[Sample]],
				Units->None,
				Description->"The list of samples that will be imaged, sorted by container groupings that will be imaged simultaneously as part of the same 'batch'.",
				Category->"Batching",
				Developer->True
			},
			BatchedContainersIn->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Container],Model[Container]],
				Description->"The list of containers that will be imaged simultaneously as part of the same 'batch'.",
				Category->"Batching",
				Developer->True
			},
			BatchedSampleIndexes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Description->"For each member of BatchedSamplesIn, the index in the protocol's WorkingSamples field of each sample in BatchedSamplesIn.",
				Category->"Batching",
				Developer->True,
				IndexMatching->BatchedSamplesIn
			},
			BatchContainer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Container],Model[Container]],
				Units->None,
				Description->"The container that will be imaged in the 'batch'.",
				Category->"Batching",
				Developer->True
			},
			BatchedContainerIndex->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterP[0],
				Description->"The index in the protocol's WorkingContainers of the BatchContainer.",
				Category->"Batching",
				Developer->True
			},

			(* fields ported from BatchedImagingParameters in Object[Protocol,ImageCells] *)
			BatchedUnitOperations->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[UnitOperation],
				Description->"The individual batches of the protocol, as they will be executed in the lab.",
				Category->"Batching",
				Developer->True
			},
			SlideAdapter->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
				Description->"Rack model with Plate footprint that is used to hold microscope slide while imaging.",
				Category->"Batching",
				Developer->True
			},
			DestinationPosition->{
				Format->Multiple,
				Class->String,
				Pattern:>LocationPositionP,
				Description->"The position on the microscope instrument that the slide adapter should be placed.",
				Category->"Batching",
				Developer->True
			},
			MetaXpressPrefix->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"The unique labware ID string prefix used to identify the plate model being imaged in the MetaXpress software.",
				Category->"Batching",
				Developer->True
			},
			MethodFileName->{
				Format->Multiple,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file path of file container methods that the instrument uses to run protocols.",
				Category->"Batching",
				Developer->True
			},
			PoolNumber->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"Indicates the input sample pool index that this unit operation belongs to.",
				Category->"Batching",
				Developer->True
			},
			BatchNumber->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0],
				Units->None,
				Description->"Indicates the index of the batch this unit operation belongs to.",
				Category->"Batching",
				Developer->True
			},
			LoadContainer->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the BatchContainer should be loaded into the microscope instrument for this batch.",
				Category->"Batching",
				Developer->True
			},
			EjectContainer->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the BatchContainer should be ejected and unloaded from the microscope instrument for this batch.",
				Category->"Batching",
				Developer->True
			},
			DryContainer->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates if the bottom of the BatchContainer should be dried after unloading from the microscope instrument for this batch.",
				Category->"Batching",
				Developer->True
			},
			RunTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Minute],
				Units->Minute,
				Description->"The estimated time for completion of the imaging portion of the protocol.",
				Category->"Batching",
				Developer->True
			},
			ImagingChannels->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"The list of imaging channel names used to acquire images of the input sample.",
				Category->"Batching",
				Developer->True
			},
			BatchedMethodFiles->{
				Format->Multiple,
				Class->String,
				Pattern:>FilePathP,
				Description->"The file paths of all files containing methods that the instrument uses to run protocols.",
				Category->"Batching",
				Developer->True
			},
			ContainerPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Object[Container],Null},
				Description->"Deck placement instructions for container being imaged.",
				Category->"Batching",
				Headers->{"Object to Place","Destination Position"},
				Developer->True
			}
		}
	}
];