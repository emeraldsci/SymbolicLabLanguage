

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, PAGE], {
	Description->"Data from separation of nucleic acids or proteins as determined by electrochemical motility, obtained by running Polyacrylamide Gel Electrophoresis (PAGE).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		GelModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Gel],
			Description -> "The model of gel that this separation is performed on.",
			Category -> "General",
			Abstract -> False
		},
		GelMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GelMaterialP,
			Description -> "The polymer material that the hydrogel network of the gel is composed of.",
			Category -> "General",
			Abstract -> True
		},
		GelPercentage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The polymer weight percentage of the gel.",
			Category -> "General",
			Abstract -> True
		},
		CrosslinkerRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The weight ratio of acrylamide monomer to bis-acrylamide crosslinker used to prepare the gel.",
			Category -> "General",
			Abstract -> True
		},
		DenaturingGel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the gel contains additives that disrupt the secondary structure of macromolecules.",
			Category -> "General",
			Abstract -> True
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The number of minutes the current is applied across the gel.",
			Category -> "General",
			Abstract -> True
		},
		Voltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage of the current applied across the gel.",
			Category -> "General"
		},
		DutyCycle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0*Percent, 100*Percent, 1*Percent, Inclusive -> Right],
			Units -> Percent,
			Description -> "The percentage of each power cycle that voltage is applied to the gel.",
			Category -> "General"
		},
		CycleDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Second],
			Units -> Micro Second,
			Description -> "The time duration of each power cycle applied to the gel. If duty cycle is less than 100%, this is the period over which the voltage switches on and off once.",
			Category -> "General"
		},
		Stain -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The Object or Model of buffer used to stain the gel.",
			Category -> "General"
		},
		StainingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The length of time the post-electrophoresis stain is incubated with the gel.",
			Category -> "General"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the gel for a fluorescence image.",
			Category -> "General"
		},
		ExcitationBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the excitation wavelength that the excitation filter will allow to pass through at 50% of the maximum transmission.",
			Category -> "General"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The wavelength at which fluorescence emitted from the gel is captured for a fluorescence image.",
			Category -> "General"
		},
		EmissionBandwidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Nano],
			Units -> Meter Nano,
			Description -> "The range in wavelengths centered around the emission wavelength that the emission filter will allow to pass through at 50% of the maximum transmission.",
			Category -> "General"
		},
		LowExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Milli * Second],
			Units -> Milli Second,
			Description -> "The shortest amount of time for which a camera shutter stayed open for each gel image.",
			Category -> "General"
		},
		MediumLowExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Milli * Second],
			Units -> Milli Second,
			Description -> "The second shortest amount of time for which a camera shutter stayed open for each gel image.",
			Category -> "General"
		},
		MediumHighExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Milli * Second],
			Units -> Milli Second,
			Description -> "The second longest amount of time for which a camera shutter stayed open while taking this image.",
			Category -> "General"
		},
		HighExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Milli * Second],
			Units -> Milli Second,
			Description -> "The longest amount of time for which a camera shutter stayed open while taking this image.",
			Category -> "General"
		},
		OptimalExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time for which a camera shutter stayed open while taking this image.",
			Category -> "General"
		},
		LowExposureLaneIntensity -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Units -> {Meter Milli, ArbitraryUnit},
			Description -> "The distance down the lane vs. pixel intensity for the given lane image of the shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumLowExposureLaneIntensity -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Units -> {Meter Milli, ArbitraryUnit},
			Description -> "The distance down the lane vs. pixel intensity for the given lane image of the second shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumHighExposureLaneIntensity -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Units -> {Meter Milli, ArbitraryUnit},
			Description -> "The distance down the lane vs. pixel intensity for the given lane image of the second longest exposure time.",
			Category -> "Experimental Results"
		},
		HighExposureLaneIntensity -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Units -> {Meter Milli, ArbitraryUnit},
			Description -> "The distance down the lane vs. pixel intensity for the given lane image of the longest exposure time.",
			Category -> "Experimental Results"
		},
		OptimalLaneIntensity -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityArrayP[{{Milli*Meter, ArbitraryUnit}..}],
			Units -> {Meter Milli, ArbitraryUnit},
			Description -> "The distance down the lane vs. pixel intensity for the given lane image.",
			Category -> "Experimental Results"
		},
		LowExposureLadderIntensity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], LowExposureLaneIntensity]],
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Description -> "The distance down the lane vs. pixel intensity for this analyte's corresponding ladder lane of the shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumLowExposureLadderIntensity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], MediumLowExposureLaneIntensity]],
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Description -> "The distance down the lane vs. pixel intensity for this analyte's corresponding ladder lane of the second shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumHighExposureLadderIntensity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], MediumHighExposureLaneIntensity]],
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Description -> "The distance down the lane vs. pixel intensity for this analyte's corresponding ladder lane of the second longest exposure time.",
			Category -> "Experimental Results"
		},
		HighExposureLadderIntensity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], HighExposureLaneIntensity]],
			Pattern :> QuantityArrayP[{{Milli * Meter, ArbitraryUnit}..}],
			Description -> "The distance down the lane vs. pixel intensity for this analyte's corresponding ladder lane of the longest exposure time.",
			Category -> "Experimental Results"
		},
		OptimalLadderIntensity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], OptimalLaneIntensity]],
			Pattern :> QuantityArrayP[{{Milli*Meter, ArbitraryUnit}..}],
			Description -> "The distance down the lane vs. pixel intensity for this analyte's corresponding ladder lane.",
			Category -> "Experimental Results"
		},
		LowExposureLaneImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LowExposureLaneImageFile]}, ImportCloudFile[Field[LowExposureLaneImageFile]]],
			Pattern :> _Image,
			Description -> "Photographic image of the lane in the gel for the shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumLowExposureLaneImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[MediumLowExposureLaneImageFile]}, ImportCloudFile[Field[MediumLowExposureLaneImageFile]]],
			Pattern :> _Image,
			Description -> "Photographic image of the lane in the gel for the second shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumHighExposureLaneImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[MediumHighExposureLaneImageFile]}, ImportCloudFile[Field[MediumHighExposureLaneImageFile]]],
			Pattern :> _Image,
			Description -> "Photographic image of the lane in the gel for the second longest exposure time.",
			Category -> "Experimental Results"
		},
		HighExposureLaneImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[HighExposureLaneImageFile]}, ImportCloudFile[Field[HighExposureLaneImageFile]]],
			Pattern :> _Image,
			Description -> "Photographic image of the lane in the gel for the longest exposure time.",
			Category -> "Experimental Results"
		},
		OptimalLaneImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[OptimalLaneImageFile]}, ImportCloudFile[Field[OptimalLaneImageFile]]],
			Pattern :> _Image,
			Description -> "Photographic image of the lane in the gel.",
			Category -> "Experimental Results"
		},
		LowExposureLadderImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], LowExposureLaneImage]],
			Pattern :> _Image,
			Description -> "Photographic image of this analyte's corresponding ladder lane for the shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumLowExposureLadderImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], MediumLowExposureLaneImage]],
			Pattern :> _Image,
			Description -> "Photographic image of this analyte's corresponding ladder lane for the second shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumHighExposureLadderImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], MediumHighExposureLaneImage]],
			Pattern :> _Image,
			Description -> "Photographic image of this analyte's corresponding ladder lane for the second longest exposure time.",
			Category -> "Experimental Results"
		},
		HighExposureLadderImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], HighExposureLaneImage]],
			Pattern :> _Image,
			Description -> "Photographic image of this analyte's corresponding ladder lane for the longest exposure time.",
			Category -> "Experimental Results"
		},
		OptimalLadderImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], OptimalLaneImage]],
			Pattern :> _Image,
			Description -> "Photographic image of this analyte's corresponding ladder lane.",
			Category -> "Experimental Results"
		},
		LowExposureLaneImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Experimental Results"
		},
		MediumLowExposureLaneImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Experimental Results"
		},
		MediumHighExposureLaneImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Experimental Results"
		},
		HighExposureLaneImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Experimental Results"
		},
		OptimalLaneImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Experimental Results"
		},
		LowExposureLadderImageFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], LowExposureLaneImageFile]],
			Pattern :> ImageFileP,
			Description -> "File containing a photographic image of this analyte's coresponding ladder lane for the shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumLowExposureLadderImageFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], MediumLowExposureLaneImageFile]],
			Pattern :> ImageFileP,
			Description -> "File containing a photographic image of this analyte's coresponding ladder lane for the second shortest exposure time.",
			Category -> "Experimental Results"
		},
		MediumHighExposureLadderImageFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], MediumHighExposureLaneImageFile]],
			Pattern :> ImageFileP,
			Description -> "File containing a photographic image of this analyte's coresponding ladder lane for the second longest exposure time.",
			Category -> "Experimental Results"
		},
		HighExposureLadderImageFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], HighExposureLaneImageFile]],
			Pattern :> ImageFileP,
			Description -> "File containing a photographic image of this analyte's coresponding ladder lane for the longest exposure time.",
			Category -> "Experimental Results"
		},
		OptimalLadderImageFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderData]}, Download[Field[LadderData], OptimalLaneImageFile]],
			Pattern :> ImageFileP,
			Description -> "File containing a photographic image of this analyte's coresponding ladder lane.",
			Category -> "Experimental Results"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PAGEDataTypeP,
			Description -> "Indciates if this data represents a standard or an analyte sample.",
			Category -> "Analysis & Reports"
		},
		LadderData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, PAGE][Analytes],
			Description -> "Data containing the ladder run alongside with this analyte.",
			Category -> "Analysis & Reports"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, PAGE][LadderData],
			Description -> "The samples, or analytes, that were run on a polyacrylamide gel in this PAGE experiment alongside with this ladder.",
			Category -> "Analysis & Reports"
		},
		LadderSizes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderAnalyses]}, Download[Field[LadderAnalyses], Sizes]],
			Pattern :> {GreaterEqualP[0, 1]..},
			Description -> "List of sizes of the fragments in the provided ladder.",
			Category -> "Analysis & Reports"
		},
		LadderAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A link to the ladder analysis object for this data.",
			Category -> "Analysis & Reports"
		},
		LadderPeaks -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderAnalyses]}, Computables`Private`ladderPeaks[Field[LadderAnalyses]]],
			Pattern :> {(GreaterEqualP[0, 1] -> GreaterP[0])..},
			Description -> "List of the position of the ladder peaks.",
			Category -> "Analysis & Reports"
		},
		SizeFunction -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderAnalyses]}, Computables`Private`sizeFunction[Field[LadderAnalyses]]],
			Pattern :> _Function,
			Description -> "Pure function which takes a retention time as input and returns an expected size as output (as interpolated by the ladder fit).",
			Category -> "Analysis & Reports"
		},
		RetentionFunction -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderAnalyses]}, Computables`Private`retentionFunction[Field[LadderAnalyses]]],
			Pattern :> _Function,
			Description -> "Pure function which takes a fragment size as input and returns an expected retention time as output (as interpolated by the ladder fit).",
			Category -> "Analysis & Reports"
		},
		LowExposureGelImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LowExposureGelImageFile]}, ImportCloudFile[Field[LowExposureGelImageFile]]],
			Pattern :> _Image,
			Description -> "Full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		MediumLowExposureGelImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[MediumLowExposureGelImageFile]}, ImportCloudFile[Field[MediumLowExposureGelImageFile]]],
			Pattern :> _Image,
			Description -> "Full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		MediumHighExposureGelImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[MediumHighExposureGelImageFile]}, ImportCloudFile[Field[MediumHighExposureGelImageFile]]],
			Pattern :> _Image,
			Description -> "Full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		HighExposureGelImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[HighExposureGelImageFile]}, ImportCloudFile[Field[HighExposureGelImageFile]]],
			Pattern :> _Image,
			Description -> "Full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		OptimalGelImage -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[OptimalGelImageFile]}, ImportCloudFile[Field[OptimalGelImageFile]]],
			Pattern :> _Image,
			Description -> "Full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		LowExposureGelImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		MediumLowExposureGelImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		MediumHighExposureGelImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		HighExposureGelImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		OptimalGelImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "File containing the full sized uncropped image of the entire gel, including all lanes.",
			Category -> "Data Processing"
		},
		InvertIntensity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicate if the gel image has been inverted for intensity calculations.",
			Category -> "Data Processing"
		},
		LaneNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The lane index starting from the left most lane of the gel.",
			Category -> "Data Processing",
			Abstract -> True
		},
		NeighboringLanes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, PAGE][NeighboringLanes],
			Description -> "Data from analytes or ladders that were run on the same gel.",
			Category -> "Data Processing"
		},
		Scale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Pixel)/(Centi*Meter)],
			Units -> Pixel/(Centi Meter),
			Description -> "The scale in pixels/distance relating pixels of the darkroom image to real world distance.",
			Category -> "Data Processing",
			Abstract -> True
		},
		ImageExposureAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Exposure analyses performed on images in this data.",
			Category -> "Analysis & Reports"
		},
		LanePeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak-picking analyses conducted on this lane image.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		},
		RedAnimationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Files containing the time lapsed red-light GIF images of the entire gel during polyacrylamide gel electrophoresis.",
			Category -> "Experimental Results"
	  },
	  BlueAnimationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Files containing the time lapsed blue-light GIF images of the entire gel during polyacrylamide gel electrophoresis.",
			Category -> "Experimental Results"
	 },
	 CombinedAnimationFiles -> {
		 Format -> Multiple,
		 Class -> Link,
		 Pattern :> _Link,
		 Relation -> Object[EmeraldCloudFile],
		 Description -> "Files containing the time lapsed combined red- and blue-light GIF images of the entire gel during polyacrylamide gel electrophoresis.",
		 Category -> "Experimental Results"
	 }
	}
}];

