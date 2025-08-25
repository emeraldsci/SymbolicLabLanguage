

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, QuantifyColonies], {
	Description -> "A protocol to count microbial colonies growing on solid media using a colony handler.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*==General==*)
		ImagingInstrument -> {
			Format -> Single,
			Class -> Link,
			Relation -> Alternatives[Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]],
			Pattern :> _Link,
			Description -> "The colony handler that is used to image colonies.",
			Category -> "General",
			Abstract -> True
		},
		SpreaderInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]],
			Description -> "The colony handler that is used to spread the provided samples on solid media to prepare colony samples.",
			Category -> "General"
		},
		Incubator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Incubator], Object[Instrument, Incubator]],
			Description -> "The cell incubator that is used to grow colonies in the desired environment before colonies are imaged.",
			Category -> "General"
		},
		QuantificationColonySamples -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[Sample]]..},
			Description -> "For each member of SamplesIn, the list of samples containing microbial colonies spread on solid media plates to be imaged and analyzed.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		QuantificationColonyDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[1]..},
			Description -> "For each member of SamplesIn, the factors by which the cells in SamplesIn are diluted when preparing QuantificationColonySamples. If no dilution, this number is {1}.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results"
		},
		ColonyIncubations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Description -> "For each member of SamplesIn, the incubation protocols of the plates containing microbial colonies plated from the SamplesIn.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results"
		},
		ColonyQuantifications -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Description -> "For each member of SamplesIn, the quantification protocols of the plates containing microbial colonies plated from the SamplesIn.",
			IndexMatching -> SamplesIn,
			Category -> "Experimental Results"
		},
		SpreadingProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, RoboticCellPreparation],
			Description -> "The SpreadCells protocol that prepares solid media agar plates.",
			Category -> "General",
			Developer -> True
		},
		IncubationProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, IncubateCells]|Object[Protocol, RoboticCellPreparation],
			Description -> "The IncubateCells protocols that grow colonies at desired incubation conditions.",
			Category -> "General",
			Developer -> True
		},
		QuantificationProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, RoboticCellPreparation],
			Description -> "The QuantifyColonies protocols that measure counts of colonies.",
			Category -> "General",
			Developer -> True
		},
		QuantificationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellPreparationP,
			Description -> "A set of instructions specifying the measurement of cell concentration of the plates containing microbial colonies on solid media prepared from the input samples.",
			Category -> "General",
			Developer -> True
		},
		(*==Subprotocols related below==*)
		(*==IncubationCondition==*)
		IncubationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			Description -> "All the samples in omnitrays containing microbial colonies on solid media that will be incubated in Incubator.",
			Category -> "Incubation",
			Developer -> True
		},
		CurrentIncubationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples containing microbial colonies on solid media that that are going to be incubated during this round of repeated incubation/quantification cycle.",
			Category -> "Incubation",
			Developer -> True
		},
		IncubationCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Custom,
			Description -> "A description of the conditions under which the IncubationSamples are incubated. Examples include BacterialIncubation, incubation at 37C, BacterialShakingIncubation, incubation at 37C with shaking, YeastIncubation, incubation at 30C, YeastShakingIncubation, incubation at 30C with shaking, and Mammalian Incubation, incubation at 37C, 5% CO2, and 93% Relative Humidity. If set to Custom, requires the active use of an incubator as opposed to the other predefined conditions which can share incubators with other protocols and do not occupy a thread when in use.",
			Category -> "Incubation Condition",
			Abstract -> True
		},
		IncubationConditionObject -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "The storage condition object which describes the conditions under which the IncubationSamples are incubated. When under custom incubation conditions, this is Null.",
			Category -> "Incubation Condition"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The target temperature at which the IncubationSamples are incubated.",
			Category -> "Incubation Condition"
		},
		RelativeHumidity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Percent]|Ambient,
			Description -> "If the RelativeHumidity is being regulated by the incubator, the target percent relative humidity at which the IncubationSamples are incubated.",
			Category -> "Incubation Condition",
			Developer -> True
		},
		CarbonDioxide -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Percent]|Ambient,
			Description -> "If the CarbonDioxide percentage is being regulated by the incubator, the target percent CO2 at which the IncubationSamples are incubated.",
			Category -> "Incubation Condition",
			Developer -> True
		},
		Shake -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the IncubationSamples should be shaken during incubation.",
			Category -> "Incubation Condition",
			Developer -> True
		},
		ShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency at which the IncubationSamples is agitated by movement in a circular motion.",
			Category -> "Incubation Condition",
			Developer -> True
		},
		ShakingRadius -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellIncubatorShakingRadiusP,
			Description -> "The radius of the circle of orbital motion applied to the IncubationSamples during incubation.",
			Category -> "Incubation Condition",
			Developer -> True
		},
		ColonyIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration during which the IncubationSamples are incubated inside of cell incubators before imaging.",
			Category -> "Incubation"
		},
		IncubateUntilCountable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether IncubationSamples should undergo repeated cycles of incubation, imaging, and analysis.",
			Category -> "Incubation"
		},
		IncubationInterval -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Hour],
			Units -> Hour,
			Description -> "The duration during which colony samples are placed inside a cell incubator as part of repeated cycles of incubation, imaging, and analysis.",
			Category -> "Incubation"
		},
		NumberOfStableIntervals -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 5],
			Units -> None,
			Description -> "The number of additional intervals used to determine if the PopulationTotalColonyCounts for all SamplesIn remain stable (do not increase) before stopping the experiment.",
			Category -> "Incubation"
		},
		MaxColonyIncubationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The maximum duration during which the IncubationSamples are allowed to be incubated inside of cell incubator.",
			Category -> "Incubation"
		},
		IncubationStartTimeLog -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time at which the processing stage begins and the time which we begin recording environmental data inside the incubator.",
			Category -> "Incubation",
			Developer -> True
		},
		(* ----------- Spreading -------------- *)
		DilutionTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DilutionTypeP,
			Description -> "For each member of SamplesIn, indicates the type of dilution performed on the sample. Linear dilution represents a single stage dilution of the Analyte in the sample to a specified concentration or by a specified dilution factor. Serial dilution represents a stepwise dilution of the Analyte in the sample resulting in multiple samples and a geometric progression of the concentration.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		DilutionStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DilutionStrategyP,
			Description -> "For each member of SamplesIn, indicates if only the final sample (Endpoint) or all diluted samples (Series) produced by serial dilution are used for spreading on solid media plate.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		NumberOfDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1],
			Description -> "For each member of SamplesIn, the number of diluted samples to prepare.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		CumulativeDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[RangeP[1, 10^23] | Null],
			Description -> "For each member of SamplesIn, the factor by which the concentration of the TargetAnalyte in the original sample is reduced during the dilution.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		SerialDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[RangeP[1, 10^23] | Null],
			Description -> "For each member of SamplesIn, the factor by which the concentration of the TargetAnalyte in the resulting sample of the previous dilution step is reduced.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		ColonySpreadingTools -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part, ColonyHandlerHeadCassette], Object[Part, ColonyHandlerHeadCassette]],
			Description -> "For each member of SamplesIn, the tool used to spread the suspended cells from the input sample onto the destination plate or into a destination well.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		SpreadVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the volume of suspended cells transferred to and spread on the agar gel.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		DispenseCoordinates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{DistanceP, DistanceP}..},
			Description -> "For each member of SamplesIn, the location(s) the suspended cells are dispensed on the destination plate before spreading.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		SpreadPatternTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SpreadPatternP,
			Description -> "For each member of SamplesIn, the pattern the spreading colony handler head will move when spreading the colony on the plate.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		CustomSpreadPatterns -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Spread[ListableP[CoordinatesP]]],
			Description -> "For each member of SamplesIn, the user defined pattern used to spread the suspended cells across the plate.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		DestinationContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SamplesIn, the desired type of container to have suspended cells spread in.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		DestinationMedia -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SamplesIn, the media on which the cells are spread.",
			IndexMatching -> SamplesIn,
			Category -> "Spreading"
		},
		(*==QuantifyColonies==*)
		MinReliableColonyCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The smallest number of colonies that can be counted on a solid media plate to provide a statistically reliable estimate of the concentration of microorganisms in a sample.",
			Category -> "Analysis & Reports"
		},
		MaxReliableColonyCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The largest number of colonies that can be counted on a solid media plate beyond which accurate counting becomes impractical and unreliable.",
			Category -> "Analysis & Reports"
		},
		MinDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The smallest diameter value from which colonies will be included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
			Category -> "Analysis & Reports"
		},
		MaxDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The largest diameter value from which colonies will be included in TotalColonyCounts in the data and analysis. The diameter is defined as the diameter of a circle with the same area as the colony.",
			Category -> "Analysis & Reports"
		},
		MinColonySeparation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The closest distance included colonies can be from each other from which colonies will be included in in TotalColonyCounts the data and analysis. The separation of a colony is the shortest path between the perimeter of the colony and the perimeter of any other colony.",
			Category -> "Analysis & Reports"
		},
		MinRegularityRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "The smallest regularity ratio from which colonies will be included in TotalColonyCounts in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
			Category -> "Analysis & Reports"
		},
		MaxRegularityRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "The largest regularity ratio from which colonies will be included in TotalColonyCounts in the data and analysis. The regularity ratio is the ratio of the area of the colony to the area of a circle with the colony's perimeter. For example, jagged edged shapes will have a longer perimeter than smoother ones and therefore a smaller regularity ratio.",
			Category -> "Analysis & Reports"
		},
		MinCircularityRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "The smallest circularity ratio from which colonies will be included in TotalColonyCounts in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
			Category -> "Analysis & Reports"
		},
		MaxCircularityRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Description -> "The largest circularity ratio from which colonies will be included in the data and analysis. The circularity ratio is defined as the ratio of the minor axis to the major axis of the best fit ellipse. For example, a very oblong colony will have a much larger major axis compared to its minor axis and therefore a low circularity ratio.",
			Category -> "Analysis & Reports"
		},
		Populations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[
				Alternatives[
					ColonySelectionPrimitiveP,
					ColonySelectionFeatureP,
					All
				]
			],
			Description -> "For each member of SamplesIn, the criteria used to group colonies together into a population. Criteria are based on the ordering of colonies by the desired feature(s): Diameter, Regularity, Circularity, Isolation, Fluorescence, and BlueWhiteScreen, or all colonies are grouped.",
			IndexMatching -> SamplesIn,
			Category -> "Analysis & Reports"
		},
		PopulationCellTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[Bacterial, Yeast]],
			Description -> "For each member of SamplesIn, the cell types that are thought to be represent the physiological characteristics defined in Populations.",
			IndexMatching -> SamplesIn,
			Category -> "Analysis & Reports"
		},
		PopulationIdentities -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[_String, ObjectP[Model[Cell]]]],
			Description -> "For each member of SamplesIn, the molecular constituents are thought to are thought to be represent the physiological characteristics defined in Populations.",
			IndexMatching -> SamplesIn,
			Category -> "Analysis & Reports"
		},
		ImagingStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[QPixImagingStrategiesP],
			Description -> "For each member of SamplesIn, the end goals for capturing images of the colonies. The available options include BrightField imaging, BlueWhite Screening, and Fluorescence imaging.",
			IndexMatching -> SamplesIn,
			Category -> "Imaging"
		},
		ExposureTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[GreaterP[0 Millisecond]|Automatic],
			Description -> "For each member of SamplesIn, and for each ImagingStrategy, the length of time to allow the camera to capture an image. When auto exposure is specified, optimal exposure time is automatically determined during experiment.",
			IndexMatching -> SamplesIn,
			Category -> "Imaging"
		}
	}
}];
