(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,FlashChromatography],{
	Description->"A protocol describing the separation of samples using flash chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* --- Instrument Information ---*)
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
		BufferContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container],Null},
			Description->"A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category->"General",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		BufferCapPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Item,Cap],Null},
			Description->"A list of deck placements used for placing buffer caps back on the buffer deck at the end of the procedure.",
			Category->"General",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		Column->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item],
				Model[Item]
			],
			Description->"For each member of SamplesIn, the stationary phase device through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, and column material.",
			IndexMatching->SamplesIn,
			Category->"General",
			Abstract->True
		},
		PreSampleEquilibration->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the length of time that of buffer is pumped through the column at the specified FlowRate prior to sample loading. The buffer used will be the initial composition of the Gradient.",
			IndexMatching->SamplesIn,
			Category->"Priming"
		},
		LoadingType->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FlashChromatographyLoadingTypeP,
			Description->"For each member of SamplesIn, the method by which sample is introduced to the instrument: liquid injection, solid load cartridge, or preloaded directly on the column.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		LoadingAmount->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the volume of sample loaded into the flow path of the flash chromatography instrument that will be separated by differential adsorption.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		Syringe->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Syringe],Model[Container,Syringe]],
			Description->"For each member of SamplesIn, the syringe that will be used to load the sample's LoadingAmount onto the instrument.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		Needle->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Needle],Model[Item,Needle]],
			Description->"For each member of SamplesIn, the needle that will be attached to the syringe that will be used to load the sample's LoadingAmount onto the instrument.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		MaxLoadingPercent->{
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units->Percent,
			Description->"For each member of SamplesIn, the maximum amount of liquid sample to be loaded on the flash chromatography instrument. Expressed as a percent of the Column's VoidVolume.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		Cartridge->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]],
			Description->"For each member of SamplesIn, the item attached upstream of the column into which sample will be introduced if the LoadingType is Solid.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgePackingMaterial->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ColumnPackingMaterialP,
			Description->"For each member of SamplesIn, the material with which the solid load cartridge is filled. The sample will be loaded onto this material inside the cartridge.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgeFunctionalGroup->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ColumnFunctionalGroupP,
			Description->"For each member of SamplesIn, the functional group displayed on the material with which the solid load cartridge is filled.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgePackingMass->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Gram],
			Units->Gram,
			Description->"For each member of SamplesIn, the mass of the material with which the solid load cartridge is filled.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgeDryingTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the duration of time for which the solid sample cartridge is dried with pressurized air after the sample is loaded.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgeCap->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part,CartridgeCap],Object[Part,CartridgeCap]],
			Description->"For each member of SamplesIn, the item that holds a solid load cartridge in the flow path upstream of the column.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgeCapTubing->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Plumbing],Object[Plumbing]],
			Description->"For each member of SamplesIn, the length of tubing that connects the instrument's injection valve to the cartridge cap if a solid load cartridge is being used to load sample.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		Frits->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
			Description->"For each member of SamplesIn, the package of frits from which a frit is taken to place at the top of a hand-packed cartridge prevent back flow of solid media into the cartridge cap.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		Plunger->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Plunger],Object[Item,Plunger]],
			Description->"For each member of SamplesIn, the item used to pack down solid media covered by a frit into a hand-packed cartridge.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		CartridgeMedia->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of SamplesIn, the solid phase media that will be used to fill a hand-packed cartridge.",
			IndexMatching->SamplesIn,
			Category->"Sample Loading"
		},
		Beaker->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
			Description->"For each member of SamplesIn, the beaker in which a cartridge will be placed while it is dried with pressurized air after sample is loaded into the cartridge and before the cartridge is loaded on the instrument.",
			IndexMatching->SamplesIn,
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
			Description->"For each member of SamplesIn, the composition of BufferA within the flow over time, in the form {Time, % BufferA}.",
			IndexMatching->SamplesIn,
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
			Description->"For each member of SamplesIn, the composition of BufferB within the flow over time, in the form {Time, % BufferB}.",
			IndexMatching->SamplesIn,
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
			Description->"For each member of SamplesIn, the composition of BufferA and BufferB within the flow over time, in the form {Time, % BufferA, % BufferB}.",
			IndexMatching->SamplesIn,
			Category->"Separation"
		},
		FlowRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter/Minute],
			Units->Milliliter/Minute,
			Description->"For each member of SamplesIn, the total rate of mobile phase pumped through the instrument.",
			IndexMatching->SamplesIn,
			Category->"Separation"
		},
		CollectFractions->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SamplesIn, indicates if effluents from the column (fractions) should be captured and stored.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		FractionCollectionStartTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the time at which to start column effluent capture. Time is measured from the start of the Gradient.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		FractionCollectionEndTime->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the time at which to end column effluent capture. Time is measured from the start of the Gradient. Fraction collection will end at this time regardless of peak collection status.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		FractionContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Vessel],Model[Container,Vessel]],
			Description->"For each member of SamplesIn, the type of containers in which fractions of the separated sample are collected after flowing out of the column and past the detector.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		FractionContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Vessel],Model[Container,Vessel]],
			Description->"The containers loaded into racks on the instrument to collect fractions from the samples separated by flash chromatography.",
			Category->"Fraction Collection"
		},
		MaxFractionVolume->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"For each member of SamplesIn, the maximum volume of effluent collected in a single fraction container before moving on to the next fraction container.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		FractionCollectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[All,Peaks],
			Description->"For each member of SamplesIn, indicates if All effluent from the column should be collected as fractions with MaxFractionVolume, or only effluent corresponding to Peaks detected by PeakDetectors.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		Rack->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description->"For each member of SamplesIn, the fraction collection container rack that will sit in the instrument's primary (left) rack slot.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		SecondaryRack->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container,Rack],Model[Container,Rack]],
			Description->"For each member of SamplesIn, the fraction collection container rack that will sit in the instrument's secondary (right) rack slot.",
			IndexMatching->SamplesIn,
			Category->"Fraction Collection"
		},
		Detectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV],
			Description->"For each member of SamplesIn, the set or sets of wavelengths of light used to measure absorbance through the separated sample. Independent measurements are collected using up to three of a single primary wavelength, a single secondary wavelength, and the average of a wide range of wavelengths.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		PrimaryWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of SamplesIn, the wavelength of light passed through the flow cell whose absorbance is measured by the PrimaryWavelength Detector.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		SecondaryWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"For each member of SamplesIn, the wavelength of light passed through the flow cell whose absorbance is measured by the SecondaryWavelength Detector.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		WideRangeUV->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Span[
				GreaterP[0 Nanometer],
				GreaterP[0 Nanometer]
			],
			Description->"For each member of SamplesIn, the span of wavelengths of UV light passed through the flow cell from which a single absorbance value is measured by the WideRangeUV Detector. The total absorbance from wavelengths in the specified range is measured.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		PeakDetectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV],
			Description->"For each member of SamplesIn, the set of detectors (PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV) used to identify peaks in absorbance through the sample. A peak is called if there is a peak in called by any of the detectors.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		PrimaryWavelengthPeakDetectionMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[Slope|Threshold],
			Description->"For each member of SamplesIn, the method(s) by which the sample's absorbance measurements from the PrimaryWavelength Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (PrimaryWavelengthPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (PrimaryWavelengthPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		PrimaryWavelengthPeakWidth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the PrimaryWavelength Detector. When PrimaryWavelengthPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the PrimaryWavelength Detector with widths between 20% and 200% of this value.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		PrimaryWavelengthPeakThreshold->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 MilliAbsorbanceUnit],
			Units->MilliAbsorbanceUnit,
			Description->"For each member of SamplesIn, the signal value from the PrimaryWavelength absorbance Detector above which fractions will always be collected when PrimaryWavelengthPeakDetectionMethod includes Threshold.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		SecondaryWavelengthPeakDetectionMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[Slope|Threshold],
			Description->"For each member of SamplesIn, the method(s) by which the sample's absorbance measurements from the SecondaryWavelength Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (SecondaryWavelengthPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (SecondaryWavelengthPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		SecondaryWavelengthPeakWidth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the SecondaryWavelength Detector. When SecondaryWavelengthPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the SecondaryWavelength Detector with widths between 20% and 200% of this value.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		SecondaryWavelengthPeakThreshold->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 MilliAbsorbanceUnit],
			Units->MilliAbsorbanceUnit,
			Description->"For each member of SamplesIn, the signal value from the SecondaryWavelength absorbance Detector above which fractions will always be collected when SecondaryWavelengthPeakDetectionMethod includes Threshold.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},

		WideRangeUVPeakDetectionMethod->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[Slope|Threshold],
			Description->"For each member of SamplesIn, the method(s) by which the sample's absorbance measurements from the WideRangeUV Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (WideRangeUVPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (WideRangeUVPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		WideRangeUVPeakWidth->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the WideRangeUV Detector. When WideRangeUVPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the WideRangeUV Detector with widths between 20% and 200% of this value.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		WideRangeUVPeakThreshold->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 MilliAbsorbanceUnit],
			Units->MilliAbsorbanceUnit,
			Description->"For each member of SamplesIn, the signal value from the WideRangeUV absorbance Detector above which fractions will always be collected when WideRangeUVPeakDetectionMethod includes Threshold.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		ColumnStorageCondition->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"For each member of SamplesIn, indicates whether the column should be disposed of or stored after the sample run is completed and, if stored, under what condition it should be stored.",
			IndexMatching->SamplesIn,
			Category->"Cleaning"
		},
		AirPurgeDuration->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"For each member of SamplesIn, the amount of time to force pressurized air through the column to remove mobile phase liquid from the column.",(* TODO: indicate the pressure (instrument default, can't change) *)
			IndexMatching->SamplesIn,
			Category->"Cleaning"
		},
		MethodFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the method files which contains the instructions needed by the instrument for each sample run.",
			Category->"General",
			Developer->True
		},
		DataFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the data files generated by the instrument after each sample run.",
			Category->"General",
			Developer->True
		},
		MethodFiles->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SamplesIn, a path to the method file specifying the gradient, measurement, and fraction collection settings for the sample's run on the instrument.",
			Category->"Separation",
			IndexMatching->SamplesIn,
			Developer->True
		},
		DataFiles->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SamplesIn, a path to the data file from the instrument containing chromatography traces (absorbance over time) and fraction collection information generated for the sample.",
			Category->"Experimental Results",
			IndexMatching->SamplesIn,
			Developer->True
		},
		MethodFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SamplesIn, the name of the method file specifying the gradient, measurement, and fraction collection settings for the sample's run on the instrument.",
			Category->"Separation",
			IndexMatching->SamplesIn,
			Developer->True
		},
		DataFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"For each member of SamplesIn, the name of the data file from the instrument containing chromatography traces (absorbance over time) and fraction collection information generated for the sample.",
			Category->"Experimental Results",
			IndexMatching->SamplesIn,
			Developer->True
		},
		RequiredObjects->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container],
				Object[Sample],
				Model[Sample],
				Model[Item],
				Object[Item],
				Model[Part],
				Object[Part],
				Model[Plumbing],
				Object[Plumbing]
			],
			Description->"Objects required for the protocol.",
			Category->"General",
			Developer->True
		},
		RequiredInstruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Instrument]|Object[Instrument],
			Description->"Instruments required for the protocol.",
			Category->"General",
			Developer->True
		}
	}
}];
