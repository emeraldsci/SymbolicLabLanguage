(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Mention confluency all other things we are outputing in the description *)
DefineObjectType[Object[Analysis, CellCount], {
	Description->"Image analysis of microscope data to count the number of cells in a given image, calculate the confluency, i.e., the total area that is covered by cells, and find different morphological properties of segmented cells.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(*-------------*)
		(* Input Image *)
		(*-------------*)
		(* naming convention same as varoth's - like objective_ - DisplayName field in the cloudfile *)
		ReferenceImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> EmeraldCloudFileP,
			Relation->Object[EmeraldCloudFile],
			Description -> "The links to the images from the microscope before performing any image processing steps.",
			Category -> "General"
		},

		(*--------------*)
		(* Output Image *)
		(*--------------*)
		AdjustedImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> EmeraldCloudFileP,
			Relation->Object[EmeraldCloudFile],
			Description -> "For each member of ReferenceImage, the image after performing all the adjustment steps.",
			Category -> "Output Image",
			IndexMatching->ReferenceImage
		},
		HighlightedCells -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> EmeraldCloudFileP,
			Relation->Object[EmeraldCloudFile],
			Description -> "For each member of ReferenceImage, the final image that contains the original image and epilogs that highlight all of the segmented components.",
			Category -> "Output Image",
			IndexMatching->ReferenceImage
		},

		(*------------------*)
		(* Image Properties *)
		(*------------------*)
		ImageComponents -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> _?(And[MatrixQ[#, IntegerQ], Max[Flatten[#]] >= 0] &),
			Units -> None,
			Description -> "For each member of ReferenceImage, an array in which the image's pixels have been replaced by integer indices indicating connected components.",
			Category -> "Counting Properties",
			IndexMatching->ReferenceImage
		},
		Confluency -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "For each member of ReferenceImage, the calculated percentange of the image covered by cells. If the image is fluoresent an a threshold is specified, the confluency of fluoresent cells will be returned.",
			Category -> "Counting Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		SampleCellDensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> 1/Milliliter,
			Description -> "For each member of ReferenceImage, the calculated number of cells in the sample well per ml.",
			Category -> "Analysis & Reports",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		NumberOfCells -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ,
			Units -> None,
			Description -> "For each member of ReferenceImage, the estimated number of cells in the image based on the NumberOfComponents, MinCellRadius, and MaxCellRadius.",
			Category -> "Counting Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		NumberOfComponents -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of ReferenceImage, the calculated number of connected components in the image. If the image is fluoresent an a threshold is specified, the number of fluoresent components will be returned.",
			Category -> "Counting Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		AverageSingleCellArea -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Pixel^2],
			Units -> Pixel^2,
			Description -> "For each member of ReferenceImage, the average size of a single cell in square pixels that is obtained from the values of MinCellRadius and MaxCellRadius options.",
			Category -> "Counting Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		CellViability -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent],
			Units -> Percent,
			Description -> "For each member of ReferenceImage, the percentage of the live components in the image, i.e. the number of live cells divided by the total number of components times 100.",
			Category -> "Counting Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},

		(*-----------------------------------*)
		(* Selected Morphological Properties *)
		(*-----------------------------------*)
		ComponentAreaDistribution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ,
			Description -> "For each member of ReferenceImage, the distribution of the area of each connected component in the image (in pixels squared or micrometer squared).",
			Category -> "Morphological Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		ComponentArea -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {(GreaterEqualP[0 Pixel^2]|GreaterEqualP[0 Micrometer^2])..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the areas of each connected component in the image (in pixels squared or micrometer squared).",
			Category -> "Morphological Properties",
			IndexMatching->ReferenceImage
		},
		ComponentCircularityDistribution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ,
			Description -> "For each member of ReferenceImage, the distribution of the circularity of the connected component in the image. A measure of how circular the cell is, with 1 being an ideal circle and 0 a line.",
			Category -> "Morphological Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		ComponentCircularity -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {GreaterEqualP[0]..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the circularity of each connected component in the image. A measure of how circular the cell is, with 1 being an ideal circle and 0 a line.",
			Category -> "Morphological Properties",
			IndexMatching->ReferenceImage
		},
		ComponentDiameterDistribution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _?DistributionParameterQ,
			Description -> "For each member of ReferenceImage, the distribution of the diameter of the connected component in the image (in pixelsor micrometer).",
			Category -> "Morphological Properties",
			Abstract -> True,
			IndexMatching->ReferenceImage
		},
		ComponentDiameter -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {(GreaterEqualP[0 Pixel]|GreaterEqualP[0 Micrometer])..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the diameter for each connected component in the image (in pixels or micrometer).",
			Category -> "Morphological Properties",
			IndexMatching->ReferenceImage
		},
		ComponentCentroid -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {({GreaterEqualP[0],GreaterEqualP[0]})..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the centroid for each connected component in the image (in pixels).",
			Category -> "Morphological Properties",
			IndexMatching->ReferenceImage
		},

		(*-----------------*)
		(* Cell Properties *)
		(*-----------------*)
		AreaProperties -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{AreaMeasurementAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the area measurement properties for all counted components, which includes PixelCount, Area, FilledPixelCount, EquivalentDiskRadius, and AreaRadiusCoverage.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		PerimeterProperties ->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{PerimeterPropertiesAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the perimeter properties for all counted components, which includes AuthalicRadius, MaxPerimeterDistance, OuterPerimeterCount, PerimeterCount, PerimeterLength, PerimeterPositions, and PolygonalLength.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		CentroidProperties -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{CentroidPropertiesAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the centroid properties for all counted components, which includes Centroid, Medoid, MeanCentroidDistance, MaxCentroidDistance, and MinCentroidDistance.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		BestfitEllipse->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{BestfitEllipseAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the best-fit ellipse properties for all counted components, which includes Length, Width, SemiAxes, Orientation, Elongation, and Eccentricity.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		ShapeMeasurements->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ShapeMeasurementsAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the shape measurements properties for all counted components, which includes Circularity, FilledCircularity, and Rectangularity.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		BoundingboxProperties->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{BoundingboxPropertiesAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the bounding-box properties for all counted components, which includes Length, Width, SemiAxes, Orientation, Elongation, and Eccentricity.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		TopologicalProperties->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{TopologicalPropertiesAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the topological properties for all counted components, which includes Fragmentation, Holes, Complexity, EulerNumber, EmbeddedComponents, EmbeddedComponentCount, EnclosingComponents, and EnclosingComponentCount.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},
		ImageIntensity -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{ImageIntensityAssociationP..}, (* Todo: N-Multiples *)
			Description -> "For each member of ReferenceImage, the image intensity properties for all counted components, which includes MinIntensity, MaxIntensity, MeanIntensity, MedianIntensity, StandardDeviationIntensity, TotalIntensity, Skew, and IntensityCentroid.",
			Category -> "Component Properties",
			IndexMatching->ReferenceImage
		},

		(*-----------------------------*)
		(*  Image comprehensive packet *)
		(*-----------------------------*)
		ImageDataLookup->{
			Format->Multiple,
			Class->{
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
				WellCenterOffsetY->Real,

				(** Analysis Results **)

				(* Output Image *)
				AdjustedImage->Link,
				HighlightedCells->Link,
				ImageComponents->Compressed,
				Confluency->Real,
				NumberOfComponents->Real,

				(* Image properties *)
				ComponentAreaDistribution->Expression,
				ComponentArea->Compressed,
				ComponentDiameterDistribution->Expression,
				ComponentDiameter->Compressed,
				ComponentCircularityDistribution->Expression,
				ComponentCircularity->Compressed,

				(* Component properties *)
				AreaProperties->Expression,
				PerimeterProperties->Expression,
				CentroidProperties->Expression,
				BestfitEllipse->Expression,
				ShapeMeasurements->Expression,
				BoundingboxProperties->Expression,
				TopologicalProperties->Expression,
				ImageIntensity->Expression
			},
			Pattern:>{
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
				WellCenterOffsetY->GreaterEqualP[-500 Millimeter],
				(* Analysis *)
				AdjustedImage->_Link,
				HighlightedCells->_Link,
				ImageComponents->_?(And[MatrixQ[#, IntegerQ], Max[Flatten[#]] >= 0] &),
				Confluency->RangeP[0*Percent, 100*Percent],
				NumberOfComponents->GreaterEqualP[0],
				ComponentAreaDistribution->_?DistributionParameterQ,
				ComponentArea->{(GreaterEqualP[0 Pixel^2]|GreaterEqualP[0 Micrometer^2])..},
				ComponentDiameterDistribution->_?DistributionParameterQ,
				ComponentDiameter->{(GreaterEqualP[0 Pixel]|GreaterEqualP[0 Micrometer])..},
				ComponentCircularityDistribution->_?DistributionParameterQ,
				ComponentCircularity->{GreaterEqualP[0]..},
				AreaProperties->{AreaMeasurementAssociationP..},
				PerimeterProperties->{PerimeterPropertiesAssociationP..},
				CentroidProperties->{CentroidPropertiesAssociationP..},
				BestfitEllipse->{BestfitEllipseAssociationP..},
				ShapeMeasurements->{ShapeMeasurementsAssociationP..},
				BoundingboxProperties->{BoundingboxPropertiesAssociationP..},
				TopologicalProperties->{TopologicalPropertiesAssociationP..},
				ImageIntensity->{ImageIntensityAssociationP..}
			},
			Relation->{
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
				WellCenterOffsetY->Null,
				(* Analysis *)
				AdjustedImage->Object[EmeraldCloudFile],
				HighlightedCells->Object[EmeraldCloudFile],
				ImageComponents->Null,
				Confluency->Null,
				NumberOfComponents->Null,
				ComponentAreaDistribution->Null,
				ComponentArea->Null,
				ComponentDiameterDistribution->Null,
				ComponentDiameter->Null,
				ComponentCircularityDistribution->Null,
				ComponentCircularity->Null,
				AreaProperties->Null,
				PerimeterProperties->Null,
				CentroidProperties->Null,
				BestfitEllipse->Null,
				ShapeMeasurements->Null,
				BoundingboxProperties->Null,
				TopologicalProperties->Null,
				ImageIntensity->Null
			},
			Units->{
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
				WellCenterOffsetY->Micrometer,
				(* Analysis *)
				AdjustedImage->None,
				HighlightedCells->None,
				ImageComponents->None,
				Confluency->None,
				NumberOfComponents->None,
				ComponentAreaDistribution->None,
				ComponentArea->None,
				ComponentDiameterDistribution->None,
				ComponentDiameter->None,
				ComponentCircularityDistribution->None,
				ComponentCircularity->None,
				AreaProperties->None,
				PerimeterProperties->None,
				CentroidProperties->None,
				BestfitEllipse->None,
				ShapeMeasurements->None,
				BoundingboxProperties->None,
				TopologicalProperties->None,
				ImageIntensity->None
			},
			Headers->{
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
				WellCenterOffsetY->"Well Center OffsetY",
				(* Analysis *)
				AdjustedImage->"Adjusted Image",
				HighlightedCells->"Highlighted Cells Image",
				ImageComponents->"Components",
				Confluency->"Confluency",
				NumberOfComponents->"Number of Components",
				ComponentAreaDistribution->"Area Distribution",
				ComponentArea->"Area",
				ComponentDiameterDistribution->"Diameter Distribution",
				ComponentDiameter->"Diameter",
				ComponentCircularityDistribution->"Circularity Distribution",
				ComponentCircularity->"Circularity",
				AreaProperties->"Area Properties",
				PerimeterProperties->"Perimeter Properties",
				CentroidProperties->"Centroid Properties",
				BestfitEllipse->"Best-fit Ellipse",
				ShapeMeasurements->"Shape Measurements",
				BoundingboxProperties->"Bounding-box Properties",
				TopologicalProperties->"Topological Properties",
				ImageIntensity->"Image Intensity"
			},
			Description->"For each member of ReferenceImage, a comprehensive lookup that contains microscope detailed specifications and also analysis results.",
			Category->"Analysis & Reports",
			IndexMatching->ReferenceImage
		}

	}
}];
