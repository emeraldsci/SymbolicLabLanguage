(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,FlashChromatography],{
	Description->"The information that specifies how to perform a flash chromatography operation using the same instrument on one or multiple samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,FlashChromatography],
				Object[Instrument,FlashChromatography]
			],
			Description->"The device containing a pump, column holder, detector, and fraction collector that executes this flash chromatography experiment.",
			Category->"General",
			Abstract->True
		},
		SeparationMode->{
			Format->Single,
			Class->Expression,
			Pattern:>FlashChromatographySeparationModeP,
			Description->"The type of chromatographic separation that categorizes the mobile and stationary phase used.",
			Category->"General",
			Abstract->True
		},
		Detector->{
			Format->Single,
			Class->Expression,
			Pattern:>FlashChromatographyDetectorTypeP,
			Description->"The type of device on the instrument that is used to perform measurements on the sample.",
			Category->"General",
			Abstract->True
		},
		BufferA->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solvent pumped through channel A of the flow path. Typically, Buffer A is the weaker solvent (less polar for normal phase chromatography or more polar for reverse phase).",
			Category->"Priming",
			Abstract->True
		},
		BufferB->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solvent pumped through channel B of the flow path. Typically, Buffer B is the stronger solvent (more polar for normal phase chromatography or less polar for reverse phase).",
			Category->"Priming",
			Abstract->True
		},

		(* Sample-related fields *)
		SampleLink->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description->"Sample to be separated by flash chromatography in this experiment.",
			Category->"General",
			Migration->SplitField
		},
		SampleString->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"Sample to be separated by flash chromatography in this experiment.",
			Category->"General",
			Migration->SplitField
		},
		SampleExpression->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{LocationPositionP,ObjectP[{Model[Container],Object[Container]}]|_String},
			Relation->Null,
			Description->"Sample to be separated by flash chromatography in this experiment.",
			Category->"General",
			Migration->SplitField (* TODO: get this everywhere it needs to be *)
		},
		SampleLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SampleLink, the label of the sample to be separated by flash chromatography.",
			Category->"General",
			IndexMatching->SampleLink
		},
		SampleContainerLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of SampleLink, the label of the container of the sample to be separated by flash chromatography.",
			Category->"General",
			IndexMatching->SampleLink
		},
		(* This is either Sample or the corresponding WorkingSamples after aliquoting etc. *)
		WorkingSample->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"For each member of SampleLink, the samples to be separated by flash chromatography after any aliquoting, if applicable.",
			Category->"General",
			IndexMatching->SampleLink,
			Developer->True
		},
		WorkingContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SampleLink, the containers holding the samples to be separated by flash chromatography after any aliquoting, if applicable.",
			Category->"General",
			IndexMatching->SampleLink,
			Developer->True
		},
		ColumnLink->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Column],
				Model[Item,Column]
			],
			Description->"For each member of SampleLink, the stationary phase device through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, and column material.",
			IndexMatching->SampleLink,
			Category->"General",
			Migration->SplitField
		},
		ColumnString->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"For each member of ColumnLink, the stationary phase device through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, and column material.",
			IndexMatching->ColumnLink,
			Category->"General",
			Migration->SplitField
		},
		ColumnLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of ColumnLink, the label of the column through which the sample is forced.",
			Category->"General",
			IndexMatching->ColumnLink
		},
		ColumnVoidVolume->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of ColumnLink, the volume of mobile (liquid) phase media that the column can hold. This is the column's total volume minus the volume of the stationary (solid) phase media.",
			Category->"General",
			IndexMatching->ColumnLink
		},
		PreSampleEquilibration->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, the length of time that of buffer is pumped through the column at the specified FlowRate prior to sample loading. The buffer used will be the initial composition of the Gradient.",
			IndexMatching->SampleLink,
			Category->"Priming"
		},
		LoadingType->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyLoadingTypeP,
			Description->"For each member of SampleLink, the method by which sample is introduced to the instrument: liquid injection, solid load cartridge, or preloaded directly on the column.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		LoadingAmountVariableUnit->{
			Format->Multiple,
			Class->VariableUnit,
			Pattern:>GreaterEqualP[0 Milliliter],
			Description->"For each member of SampleLink, the volume of sample loaded into the flow path of the flash chromatography instrument that will be separated by differential adsorption.",
			IndexMatching->SampleLink,
			Category->"Sample Loading",
			Migration->SplitField
		},
		LoadingAmountExpression->{
			Format->Multiple,
			Class->Expression,
			Pattern:>All,
			Description->"For each member of SampleLink, the volume of sample loaded into the flow path of the flash chromatography instrument that will be separated by differential adsorption.",
			IndexMatching->SampleLink,
			Category->"Sample Loading",
			Migration->SplitField
		},
		MaxLoadingPercent->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"For each member of SampleLink, the maximum amount of liquid sample to be loaded on the flash chromatography instrument. Expressed as a percent of the Column's VoidVolume. If LoadingAmount is not specified, then LoadingAmount will be MaxLoadingPercent times the VoidVolume of the Column. If LoadingAmount is specified but Column is not, then a Column will be chosen such that its VoidVolume times MaxLoadingPercent is greater than or equal to the LoadingAmount. If both LoadingAmount and Column are specified, then MaxLoadingPercent must be greater than or equal to LoadingAmount divided by the Column's VoidVolume.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgeLink->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]],
			Description->"For each member of SampleLink, the item attached upstream of the column into which sample will be introduced if the LoadingType is Solid.",
			IndexMatching->SampleLink,
			Category->"Sample Loading",
			Migration->SplitField
		},
		CartridgeString->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Relation->Null,
			Description->"For each member of CartridgeLink, the item attached upstream of the column into which sample will be introduced if the LoadingType is Solid.",
			IndexMatching->CartridgeLink,
			Category->"Sample Loading",
			Migration->SplitField
		},
		CartridgeLabel->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of CartridgeLink, the label of the cartridge into which the sample is loaded.",
			Category->"General",
			IndexMatching->CartridgeLink
		},
		CartridgePackingMaterial->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyCartridgePackingMaterialP,
			Description->"For each member of SampleLink, the material with which the solid load cartridge is filled. The sample will be loaded onto this material inside the cartridge.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgeFunctionalGroup->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyCartridgeFunctionalGroupP,
			Description->"For each member of SampleLink, the functional group displayed on the material with which the solid load cartridge is filled.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgePackingMass->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Gram],
			Units->Gram,
			Description->"For each member of SampleLink, the mass of the material with which the solid load cartridge is filled.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgeDryingTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, the duration of time for which the solid sample cartridge is dried with pressurized air after the sample is loaded.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		GradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{
				{
					GreaterEqualP[0 Minute],
					RangeP[0 Percent,100 Percent]
				}..
			},
			Description->"For each member of SampleLink, the composition of BufferA within the flow over time, in the form {Time, % Buffer A}.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		GradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{
				{
					GreaterEqualP[0 Minute],
					RangeP[0 Percent,100 Percent]
				}..
			},
			Description->"For each member of SampleLink, the composition of BufferB within the flow over time, in the form {Time, % Buffer B}.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		FlowRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[5 Milliliter/Minute,200 Milliliter/Minute],
			Units->Milliliter/Minute,
			Description->"For each member of SampleLink, the total rate of mobile phase pumped through the instrument.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		GradientStart->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"For each member of SampleLink, a shorthand to specify the starting BufferB composition in the fluid flow. This must be specified with GradientEnd and GradientDuration.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		GradientEnd->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"For each member of SampleLink, a shorthand to specify the final BufferB composition in the fluid flow. This must be specified with GradientStart and GradientDuration.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		GradientDuration->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, a shorthand to specify the total length of time during which the buffer composition changes. This option must be specified with GradientStart and GradientEnd.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		EquilibrationTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, a shorthand to specify the duration of equilibration at the starting buffer composition before the start of gradient change. The buffer composition is the same as that of GradientStart. This option must be specified with GradientStart.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		FlushTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, a shorthand to specify the duration of constant buffer composition flushing at the end of the gradient change. The buffer composition is the same as that of GradientEnd. This option must be specified with GradientEnd.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		Gradient->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{
				{
					GreaterEqualP[0 Minute],
					RangeP[0 Percent,100 Percent],
					RangeP[0 Percent,100 Percent]
				}..
			},
			Description->"For each member of SampleLink, composition of BufferA and BufferB within the flow over time, in the form {Time, % Buffer A, % Buffer B}.",
			IndexMatching->SampleLink,
			Category->"Separation"
		},
		CollectFractions->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SampleLink, indicates if effluents from the column (fractions) should be captured and stored.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		FractionCollectionStartTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, the time at which to start column effluent capture. Time is measured from the start of the Gradient.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		FractionCollectionEndTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, the time at which to end column effluent capture. Time is measured from the start of the Gradient. Fraction collection will end at this time regardless of peak collection status.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		(* This is only Links, but the option is ObjectP[Model[Container,Vessel]] do I need to split to FractionContainerLink and FractionContainerExpression?  *)
		FractionContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Vessel],
			Description->"For each member of SampleLink, the type of containers in which fractions of the separated sample are collected after flowing out of the column and past the detector.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		FractionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Vessel],Model[Container,Vessel]],
			Description->"For this BatchedUnitOperation, the containers loaded into racks on the instrument to collect fractions from the sample separated by flash chromatography.",
			Category->"Fraction Collection"
		},
		FractionContainerPlacements->{
			Format->Multiple,
			Class->{Link,Link,Expression},
			Pattern:>{_Link,_Link,LocationPositionP},
			Relation->{(Object[Container,Vessel]|Model[Container,Vessel]),(Object[Container,Rack]|Model[Container,Rack]),Null},
			Description->"For this BatchedUnitOperation, the list of placements for putting fraction collection containers into fraction collection container racks.",
			Category->"Fraction Collection",
			Developer->True,
			Headers->{"Container to Place","Destination Rack","Destination Position"}
		},
		FractionRackPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container,Rack]|Model[Container,Rack],Null},
			Description->"For this BatchedUnitOperation, the list of deck placements for putting fraction collection container racks into slots on the instrument's fraction collection deck.",
			Category->"Fraction Collection",
			Headers->{"Rack to Place","Placement Tree"},
			Developer->True
		},
		SamplesOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"For this BatchedUnitOperation, the fractions collected from the separated sample.",
			Category->"General"
		},
		ContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"For this BatchedUnitOperation, the collection tubes that the SamplesOut fractions were collected in.",
			Category->"General"
		},
		MaxFractionVolume->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of SampleLink, the maximum volume of effluent collected in a single fraction container before moving on to the next fraction container.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		FractionCollectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[All,Peaks],
			Description->"For each member of SampleLink, indicates if All effluent from the column should be collected as fractions with MaxFractionVolume, or only effluent corresponding to Peaks detected by PeakDetectors.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		Detectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[
				ListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV],
				All
			],
			Description->"For each member of SampleLink, the set or sets of wavelengths of light used to measure absorbance through the separated sample. Independent measurements are collected using up to three of a single primary wavelength, a single secondary wavelength, and the average of a wide range of wavelengths.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		PrimaryWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of SampleLink, the wavelength of light passed through the flow cell whose absorbance is measured by the PrimaryWavelength Detector.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		SecondaryWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of SampleLink, the wavelength of light passed through the flow cell whose absorbance is measured by the SecondaryWavelength Detector.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		WideRangeUV->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[
				All,
				Span[
					GreaterP[0 Nanometer],
					GreaterP[0 Nanometer]
				]
			],
			Description->"For each member of SampleLink, the span of wavelengths of UV light passed through the flow cell from which a single absorbance value is measured by the WideRangeUV Detector. The total absorbance from wavelengths in the specified range is measured.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		PeakDetectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV],
			Description->"For each member of SampleLink, the set of detectors (PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV) used to identify peaks in absorbance through the sample. A peak is called if there is a peak in called by any of the detectors.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		PrimaryWavelengthPeakDetectionMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[Slope|Threshold],
			Description->"For each member of SampleLink, the method(s) by which the sample's absorbance measurements from the PrimaryWavelength Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (PrimaryWavelengthPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (PrimaryWavelengthPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		PrimaryWavelengthPeakWidth->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyPeakWidthP,(* Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute] *)
			Description->"For each member of SampleLink, the peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the PrimaryWavelength Detector. When PrimaryWavelengthPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the PrimaryWavelength Detector with widths between 20% and 200% of this value.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		PrimaryWavelengthPeakThreshold->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 MilliAbsorbanceUnit],
			Units->MilliAbsorbanceUnit,
			Description->"For each member of SampleLink, the signal value from the PrimaryWavelength absorbance Detector above which fractions will always be collected when PrimaryWavelengthPeakDetectionMethod includes Threshold.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		SecondaryWavelengthPeakDetectionMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[Slope|Threshold],
			Description->"For each member of SampleLink, the method(s) by which the sample's absorbance measurements from the SecondaryWavelength Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (SecondaryWavelengthPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (SecondaryWavelengthPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		SecondaryWavelengthPeakWidth->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyPeakWidthP,(* Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute] *)
			Description->"For each member of SampleLink, the peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the SecondaryWavelength Detector. When SecondaryWavelengthPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the SecondaryWavelength Detector with widths between 20% and 200% of this value.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		SecondaryWavelengthPeakThreshold->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 MilliAbsorbanceUnit],
			Units->MilliAbsorbanceUnit,
			Description->"For each member of SampleLink, the signal value from the SecondaryWavelength absorbance Detector above which fractions will always be collected when SecondaryWavelengthPeakDetectionMethod includes Threshold.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},

		WideRangeUVPeakDetectionMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[Slope|Threshold],
			Description->"For each member of SampleLink, the method(s) by which the sample's absorbance measurements from the WideRangeUV Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (WideRangeUVPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (WideRangeUVPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		WideRangeUVPeakWidth->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyPeakWidthP,(* Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute] *)
			Description->"For each member of SampleLink, the peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the WideRangeUV Detector. When WideRangeUVPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the WideRangeUV Detector with widths between 20% and 200% of this value.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		WideRangeUVPeakThreshold->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 MilliAbsorbanceUnit],
			Units->MilliAbsorbanceUnit,
			Description->"For each member of SampleLink, the signal value from the WideRangeUV absorbance Detector above which fractions will always be collected when WideRangeUVPeakDetectionMethod includes Threshold.",
			IndexMatching->SampleLink,
			Category->"Detection"
		},
		ColumnStorageCondition->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of SampleLink, indicates whether the column should be disposed of or stored after the sample run is completed and, if stored, under what condition it should be stored.",
			IndexMatching->SampleLink,
			Category->"Cleaning"
		},
		AirPurgeDuration->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, the amount of time to force pressurized air through the column to remove mobile phase liquid from the column.",
			IndexMatching->SampleLink,
			Category->"Cleaning"
		},
		(* Fields for resources that aren't options *)
		Rack->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description->"For each member of SampleLink, the fraction collection container rack that will sit in the instrument's primary (left) rack slot.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		SecondaryRack->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description->"For each member of SampleLink, the fraction collection container rack that will sit in the instrument's secondary (right) rack slot.",
			IndexMatching->SampleLink,
			Category->"Fraction Collection"
		},
		Syringe->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Syringe],Model[Container,Syringe]],
			Description->"For each member of SampleLink, the syringe that will be used to load the sample's LoadingAmount onto the instrument.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		Needle->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Needle],Model[Item,Needle]],
			Description->"For each member of SampleLink, the needle that will be attached to the syringe that will be used to load the sample's LoadingAmount onto the instrument.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		Frits->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
			Description->"For each member of SampleLink, the package of frits from which a frit is taken to place at the top of a hand-packed cartridge prevent back flow of solid media into the cartridge cap.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		Plunger->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Plunger],Object[Item,Plunger]],
			Description->"For each member of SampleLink, the item used to pack down solid media covered by a frit into a hand-packed cartridge.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgeMedia->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SampleLink, the solid phase media that will be used to fill a hand-packed cartridge.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgeCap->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part,CartridgeCap],Object[Part,CartridgeCap]],
			Description->"For each member of SampleLink, the item that holds a solid load cartridge in the flow path upstream of the column.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		CartridgeCapTubing->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Plumbing],Object[Plumbing]],
			Description->"For each member of SampleLink, the length of tubing that connects the instrument's injection valve to the cartridge cap if a solid load cartridge is being used to load sample.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		Beaker->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
			Description->"For each member of SampleLink, the beaker in which a cartridge will be placed while it is dried with pressurized air after sample is loaded into the cartridge and before the cartridge is loaded on the instrument.",
			IndexMatching->SampleLink,
			Category->"Sample Loading"
		},
		MethodFile->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SampleLink, a path to the method file specifying the gradient, measurement, and fraction collection settings for the sample's run on the instrument.",
			Category->"Separation",
			IndexMatching->SampleLink,
			Developer->True
		},
		DataFile->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SampleLink, a path to the data file from the instrument containing chromatography traces (absorbance over time) and fraction collection information generated for the sample.",
			Category->"Experimental Results",
			IndexMatching->SampleLink,
			Developer->True
		},
		MethodFileName->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SampleLink, the name of the method file specifying the gradient, measurement, and fraction collection settings for the sample's run on the instrument.",
			Category->"Separation",
			IndexMatching->SampleLink,
			Developer->True
		},
		DataFileName->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SampleLink, the name of the data file from the instrument containing chromatography traces (absorbance over time) and fraction collection information generated for the sample.",
			Category->"Experimental Results",
			IndexMatching->SampleLink,
			Developer->True
		},
		ObjectsToStore->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Plumbing],
				Object[Item],
				Object[Wiring]
			],
			Description->"A list of objects that are not needed for the next BatchedUnitOperation that should be stored at the end of this BatchedUnitOperation.",
			Category->"Cleaning",
			Developer->True
		},
		RunTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SampleLink, an estimate of the length of time that the sample run will take.",
			Category->"Batching",
			Developer->True
		}
	}
}];
