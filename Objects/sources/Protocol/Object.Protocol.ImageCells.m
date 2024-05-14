(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,ImageCells],{
	Description->"A protocol that uses a microscope to take magnified images of the samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* instrument *)
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument,Microscope],Model[Instrument,Microscope]],
			Description->"The microscope or high content imager that is used to image the sample.",
			Category -> "General"
		},

		(* calibration *)
		ReCalibrateMicroscope->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the optical components of the microscope should be adjusted before imaging the sample.",
			Category->"Calibration"
		},
		MicroscopeCalibration->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Maintenance,CalibrateMicroscope],
			Description->"A calibration object that specifies a set of parameters used to adjust optical components of the microscope.",
			Category->"Calibration"
		},

		(* environmental controls *)
		Temperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The temperature of the stage where the sample container is placed during imaging.",
			Category->"Instrument Setup"
		},
		CarbonDioxide->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the sample will be incubated with CO2 during imaging.",
			Category->"Instrument Setup"
		},
		CarbonDioxidePercentage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Percent],
			Units->Percent,
			Description->"Indicates percentage of CO2 in the gas mixture that will be provided to the sample during imaging.",
			Category->"Instrument Setup"
		},

		(* ---index-matched to NestedIndexMatchingSamplesIn--- *)

		EquilibrationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies the amount of time for which the samples are placed on the stage of the microscope before the first image is acquired.",
			Category->"Equilibration",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		(* imaging parameters *)
		ContainerOrientations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeContainerOrientationP,
			Description->"For each member of NestedIndexMatchingSamplesIn, the orientation of the sample container when placed on the microscope stage for imaging.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		CoverslipThicknesses->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the thickness of the coverslip, which is used to determine the position of the CorrectionCollar on high magnification objective lenses to correct for optical aberrations.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		PlateBottomThicknesses->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Millimeter],
			Units->Millimeter,
			Description->"For each member of NestedIndexMatchingSamplesIn, the thickness of the well bottom of the sample's container, which is used to determine the position of the CorrectionCollar on high magnification objective lenses to correct for optical aberrations.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		ObjectiveMagnifications->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the magnification power defined by the ratio between the dimensions of the image and the sample. Low magnification power (4X and 10X) is recommended for acquiring an overview image of a sample. High magnification power (20X, 40X, 60X) is recommended for imaging detailed structure of a large tissue sample or intracellular structures.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		PixelBinnings->{
			Format->Multiple,
			Class->Integer,
			Pattern:>RangeP[1,8],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the \"n x n\" grid of pixels whose intensity values should be combined into a single pixel. Higher binning values result in higher overall signal-to-noise ratios but lower pixel resolutions.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		(* TODO: update to support Object[UnitOperation,AcquireImage] *)
		AcquireImagePrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{AcquireImagePrimitiveP..},
			Description->"For each member of NestedIndexMatchingSamplesIn, a list of acquisition parameters used to acquire images of the input sample.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		(* sampling method *)
		SamplingPatterns->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MicroscopeSamplingMethodP,
			Description->"For each member of NestedIndexMatchingSamplesIn, the pattern of images that will be acquired from the samples.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SamplingNumberOfRows->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the number of rows which will be acquired for each sample if the Grid SamplingPattern is selected.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SamplingNumberOfColumns->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the number of columns which will be acquired for each sample if the Grid SamplingPattern is selected.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SamplingRowSpacings->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[-85 Millimeter,85 Millimeter],
			Units->Micrometer,
			Description->"For each member of NestedIndexMatchingSamplesIn, the distance between each row of images to be acquired. Negative distances indicate overlapping regions between adjacent rows.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SamplingColumnSpacings->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[-127 Millimeter,127 Millimeter],
			Units->Micrometer,
			Description->"For each member of NestedIndexMatchingSamplesIn, the distance between each column of images to be acquired. Negative values indicate overlapping regions between adjacent columns.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		SamplingCoordinates->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{RangeP[-127 Millimeter,127 Millimeter],RangeP[-85 Millimeter,85 Millimeter]}..},
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies the positions at which images are acquired. The coordinates in the form (X,Y) are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},

		(* develop fields storing site coordinates to use in compiler/exporter *)
		AllImagingSiteCoordinates->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{RangeP[-127000,127000],RangeP[-85000,85000]}..},
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies all imaging positions in each well determined from SamplingNumberOfColumns and SamplingNumberOfRows. The coordinates in the form (X Micrometer,Y Micrometer) are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn,
			Developer->True
		},
		UsableImagingSiteCoordinates->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{RangeP[-127000,127000],RangeP[-85000,85000]}..},
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies all imaging positions in each well that can be imaged. The coordinates in the form (X Micrometer,Y Micrometer) are referenced to the center of each well if the sample's container is a plate or center of a microscopic slide, which has coordinates of (0,0).",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn,
			Developer->True
		},

		AdaptiveExcitationWaveLengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies the excitation wavelength of the light source that will be used to determine the number of cells in each field of view for the Adaptive SamplingPattern.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		AdaptiveNumberOfCells->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies the minimum cell count per well that the instrument will work to satisfy by acquiring images from multiple regions before moving to the next sample.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		AdaptiveMinNumberOfImages->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the minimum number of regions that must be acquired when using the Adaptive SamplingPattern, even if the specified cell count (AdaptiveNumberOfCells) is already reached.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		AdaptiveCellWidths->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterP[0 Micrometer],GreaterP[0 Micrometer]},
			Units->{Micrometer,Micrometer},
			Headers->{"Min Cell Width","Max Cell Width"},
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies the expected range of cell size in the sample. The instrument uses this range to determine which features in the image will be counted as cells.",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		AdaptiveIntensityThresholds->{
			Format->Multiple,
			Class->Integer,
			Pattern:>RangeP[0,65535],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the intensity above local background value that a putative cell needs to have in order to be counted. The intensity above local background value is calculated by subtracting the gray value of the surrounding background from the gray level value of a putative cell. Any feature in an image is considered to be a putative cell if its size falls within the specified cell width (AdaptiveCellWidth).",
			Category->"Scan Area",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		(* timelapse *)
		TimelapseImaging->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of NestedIndexMatchingSamplesIn, indicates if the sample will be imaged at multiple time points.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		TimelapseIntervals->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Hour],
			Units->Hour,
			Description->"For each member of NestedIndexMatchingSamplesIn, the amount of time between the start of an acquisition at one time point and the start of an acquisition at the next time point.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		TimelapseDurations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Hour],
			Units->Hour,
			Description->"For each member of NestedIndexMatchingSamplesIn, the total amount of time that the Timelapse images will be acquired for the sample.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		NumberOfTimepoints->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the number of images that will be acquired from the sample in during the course of Timelapse imaging.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		ContinuousTimelapseImagings->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of NestedIndexMatchingSamplesIn, indicates if images from multiple time points should be acquired from the samples in a single imaging session.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		TimelapseAcquisitionOrders->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ImageCellsTimelapseAcquitionOrderP,
			Description->"For each member of NestedIndexMatchingSamplesIn, determines the order in which the time-series images are acquired with respect to the sample's location in the plate.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		(* z-stack *)
		ZStackImaging->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of NestedIndexMatchingSamplesIn, indicates if a series of images at multiple z-axis positions will be acquired for the sample.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		ZStepSizes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Micrometer],
			Units->Micrometer,
			Description->"For each member of NestedIndexMatchingSamplesIn, the distance between each image plane in the Z-Stack.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		NumberOfZSteps->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Units->None,
			Description->"For each member of NestedIndexMatchingSamplesIn, the total number of image planes that will be acquired in the Z-stack.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		ZStackSpans->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{RangeP[-100 Micrometer,100 Micrometer],RangeP[0 Micrometer,100 Micrometer]},
			Units->{Micrometer,Micrometer},
			Headers->{"Z Bottom","Z Top"},
			Description->"For each member of NestedIndexMatchingSamplesIn, the range of Z-heights that the microscope will acquire images from in a Z-Stack. Negative values indicate planes that are below the sample's imaging plane.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},

		(* index-matched to SamplesIn *)
		AdjustmentSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of NestedIndexMatchingSamplesIn, specifies if this sample is used to adjust the ExposureTime and FocalHeight in each imaging session.",
			Category->"Imaging",
			IndexMatching->NestedIndexMatchingSamplesIn
		},
		RequireAdapter->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if the sample requires to be held in an adapter while being imaged.",
			Category->"Imaging",
			IndexMatching->SamplesIn
		},

		(* single/non-index matching *)
		SlideAdapter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description->"Rack model with Plate footprint that is used to hold the sample while imaging.",
			Category->"Imaging"
		},

		(* batching information *)
		BatchedSamplesIn->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Units->None,
			Description->"The list of samples that will be imaged, sorted by container groupings that will be imaged simultaneously as part of the same 'batch'.",
			Category->"Batching",
			Developer->True
		},
		BatchedSampleIndexes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The index in WorkingSamples field of each sample in BatchedSamplesIn.",
			Category->"Batching",
			Developer->True
		},
		BatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The list of batch sizes corresponding to number of samples per batch.",
			Category->"Batching",
			Developer->True
		},
		BatchedContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Units->None,
			Description->"The list of containers that will be imaged, sorted by container groupings that will be imaged simultaneously as part of the same 'batch'.",
			Category->"Batching",
			Developer->True
		},
		BatchedContainerIndexes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The index in WorkingContainers of each container in BatchedContainers.",
			Category->"Batching",
			Developer->True
		},

		BatchedImagingParameters->{
			Format->Multiple,
			Class->{
				Container->Link,
				StorageCondition->Link,
				AdjustmentSample->Link,
				SlideAdapter->Link,
				DestinationPosition->String,
				EquilibrationTime->Real,
				ContainerOrientation->Expression,
				ObjectiveMagnification->Real,
				PixelBinning->Integer,
				ContinuousTimelapseImaging->Expression,
				MetaXpressPrefix->String,
				MethodFileName->String,
				DataFilePath->String,
				PoolNumber->Integer,
				BatchNumber->Integer,
				RunTime->Real,
				LoadContainer->Expression,
				EjectContainer->Expression,
				DryContainer->Expression
			},
			Pattern:>{
				Container->_Link,
				StorageCondition->_Link,
				AdjustmentSample->_Link,
				SlideAdapter->_Link,
				DestinationPosition->LocationPositionP,
				EquilibrationTime->GreaterEqualP[0 Minute],
				ContainerOrientation->Alternatives[UpsideDown,RightSideUp],
				ObjectiveMagnification->GreaterP[0],
				PixelBinning->GreaterP[0],
				ContinuousTimelapseImaging->BooleanP,
				MetaXpressPrefix->_String,
				MethodFileName->FilePathP,
				DataFilePath->FilePathP,
				PoolNumber->GreaterP[0],
				BatchNumber->GreaterP[0],
				RunTime->TimeP,
				LoadContainer->BooleanP,
				EjectContainer->BooleanP,
				DryContainer->BooleanP
			},
			Relation->{
				Container->Alternatives[Object[Container],Model[Container]],
				StorageCondition->Model[StorageCondition],
				AdjustmentSample->Alternatives[Object[Sample],Model[Sample]],
				SlideAdapter->Alternatives[Object[Container],Model[Container]],
				DestinationPosition->Null,
				EquilibrationTime->Null,
				ContainerOrientation->Null,
				ObjectiveMagnification->Null,
				PixelBinning->Null,
				ContinuousTimelapseImaging->Null,
				MetaXpressPrefix->Null,
				MethodFileName->Null,
				DataFilePath->Null,
				PoolNumber->Null,
				BatchNumber->Null,
				RunTime->Null,
				LoadContainer->Null,
				EjectContainer->Null,
				DryContainer->Null
			},
			Units->{
				Container->None,
				StorageCondition->None,
				AdjustmentSample->None,
				SlideAdapter->None,
				DestinationPosition->None,
				EquilibrationTime->Minute,
				ContainerOrientation->None,
				ObjectiveMagnification->None,
				PixelBinning->None,
				ContinuousTimelapseImaging->None,
				MetaXpressPrefix->None,
				MethodFileName->None,
				DataFilePath->None,
				PoolNumber->None,
				BatchNumber->None,
				RunTime->Minute,
				LoadContainer->None,
				EjectContainer->None,
				DryContainer->None
			},
			Headers->{
				Container->"Container",
				StorageCondition->"Storage Condition",
				AdjustmentSample->"Adjustment Sample",
				SlideAdapter->"Slide Adapter",
				DestinationPosition->"Destination Position",
				EquilibrationTime->"Equilibration Time",
				ContainerOrientation->"Container Orientation",
				ObjectiveMagnification->"Objective Magnification",
				PixelBinning->"Pixel Binning",
				ContinuousTimelapseImaging->"Continuous Timelapse Imaging",
				MetaXpressPrefix->"MetaXpress Labware Prefix",
				MethodFileName->"Method File Name",
				DataFilePath->"Data File Path",
				PoolNumber->"Pool Number",
				BatchNumber->"Batch Number",
				RunTime->"Run Time",
				LoadContainer->"Load Container",
				EjectContainer->"Eject Container",
				DryContainer->"Dry Container"
			},
			IndexMatching->BatchLengths,
			Description->"For each member of BatchLengths, the imaging parameters shared by all samples in the batch.",
			Category->"Batching",
			Developer->True
		},
		ImagingChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_String..},
			Description->"For each member of BatchLengths, a list of imaging channel names used to acquire images of the input sample.",
			Category->"Imaging",
			IndexMatching->BatchLengths,
			Developer->True
		},

		BatchedMethodFiles->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{FilePathP..},
			Description->"For each member of BatchLengths, the file paths of all files containing methods that the instrument uses to run protocols.",
			Category -> "General",
			IndexMatching->BatchLengths,
			Developer->True
		},
		ContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container],Null},
			Description->"For each member of BatchedUnitOperations, deck placement instructions for container being imaged.",
			Category->"Method Information",
			Headers->{"Object to Place","Destination Position"},
			IndexMatching->BatchedUnitOperations,
			Developer->True
		},

		(* field for high content imager plate calibration *)
		CalibrationContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"The empty containers that need their labware definition created for imaging with a high content imager.",
			Category -> "General",
			Developer->True
		},
		CalibrationContainersWet->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container],Object[Container]],
			Description->"For each member of CalibrationContainers, the liquid-filled containers that need their labware definition created for imaging with a high content imager.",
			Category -> "General",
			IndexMatching->CalibrationContainers,
			Developer->True
		},
		(* TODO: update to unit operation *)
		ContainerCalibrationPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleManipulationP,SamplePreparationP],
			Description->"For each member of CalibrationContainers, the set of instructions to prepare containers for calibration on a high content imager.",
			Category -> "General",
			IndexMatching->CalibrationContainers,
			Developer->True
		},
		ContainerCalibrationManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol,SampleManipulation],Object[Protocol,RoboticSamplePreparation],Object[Protocol,ManualSamplePreparation]],
			Description->"The sample manipulation/preparation protocol generated as a result of the execution of ContainerCalibrationPrimitives.",
			Category -> "General",
			Developer->True
		},
		CalibrationContainerFilePaths->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of CalibrationContainers, the full file path of the file used to load the labware definition in the instrument's software.",
			Category -> "General",
			IndexMatching->CalibrationContainers,
			Developer->True
		},
		CalibrationContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container],Null},
			Description->"For each member of CalibrationContainers, deck placement instructions for container being calibrated.",
			Category -> "General",
			Headers->{"Object to Place","Destination Position"},
			IndexMatching->CalibrationContainers,
			Developer->True
		},
		CalibrationContainerWetPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container],Null},
			Description->"For each member of CalibrationContainersWet, deck placement instructions for liquid-filled container that is being calibrated.",
			Category -> "General",
			Headers->{"Object to Place","Destination Position"},
			IndexMatching->CalibrationContainersWet,
			Developer->True
		},
		ObjectiveMetaXpressPrefixes->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The unique string prefixes used by the MetaXpress software to reference the objectives used for calibrating the containers in this protocol.",
			Category -> "General",
			Developer->True
		},
		ContainersWithAmbientStorage->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The list of sample containers that are not temperature sensitive. These containers are resource picked at the beginning of ImageCells protocol.",
			Category -> "General",
			Developer->True
		},
		ContainersToSeal->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"The list of sample containers that need to be sealed before storage.",
			Category -> "General",
			Developer->True
		},
		RunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"The estimated time for completion of the imaging portion of the protocol.",
			Category -> "General",
			Developer->True
		},
		LabwareDefinitionFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The full file path of the file used to copy the labware definition files onto the instrument computer.",
			Category -> "General",
			Developer->True
		}
	}
}];
