

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, IncubateCells], {
	Description -> "A protocol to grow or maintain samples containing mammalian, yeast, or bacterial cells at desired incubation conditions.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(*==General==*)
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The duration during which the input cells are incubated inside of cell incubators.",
			Category -> "General",
			Abstract -> True
		},
		Incubators -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "For each member of SamplesIn, the instrument which provides the specified Temperature, CarbonDioxide, RelativeHumidity, ShakingRate, and ShakingRadius in order to grow cell cultures.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		IncubationStrategies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Time, QuantificationTarget],
			Description -> "For each member of SamplesIn, the manner in which the end of the incubation period is determined.",
			Category -> "General",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		(*==IncubationCondition==*)
		IncubationConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Custom,
			Description -> "For each member of SamplesIn, a description of the conditions under which the input cells are incubated. Examples include BacterialIncubation, incubation at 37C, BacterialShakingIncubation, incubation at 37C with shaking, YeastIncubation, incubation at 30C, YeastShakingIncubation, incubation at 30C with shaking, and Mammalian Incubation, incubation at 37C, 5% CO2, and 93% Relative Humidity. If set to Custom, requires the active use of an incubator as opposed to the other predefined conditions which can share incubators with other protocols and do not occupy a thread when in use.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn,
			Abstract -> True
		},
		IncubationConditionObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "For each member of SamplesIn, the storage condition object which describes the conditions under which the cells are incubated. When under custom incubation conditions, this is Null.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the target temperature at which the cells are incubated.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		RelativeHumidities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, if the RelativeHumidity is being regulated by the incubator, the target percent relative humidity at which the cells are incubated.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		CarbonDioxide -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, if the CarbonDioxide percentage is being regulated by the incubator, the target percent CO2 at which the cells are incubated.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		CellTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "For each member of SamplesIn, the type of the most abundant cells that are thought to be present in this sample.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		CultureAdhesions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "For each member of SamplesIn, the manner of cell growth the cells in the sample are thought to employ (i.e., SolidMedia, Suspension, and Adherent). SolidMedia cells grow in colonies on a nutrient rich substrate, suspended cells growing free floating in liquid media, and adherent cells grow as a monolayer attached to a substrate.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		ShakingRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "For each member of SamplesIn, the frequency at which the sample is agitated by movement in a circular motion.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		ShakingRadii -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellIncubatorShakingRadiusP,
			Description -> "For each member of SamplesIn, the radius of the circle of orbital motion applied to the sample during incubation.",
			Category -> "Incubation Condition",
			IndexMatching -> SamplesIn
		},
		(*==EnvironmentalData==*)
		TemperatureData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "For each member of SamplesIn, a recording of the actual temperature inside in the incubator from the point which the samples were loaded until the incubation Time has passed.",
			Category -> "Environmental Data",
			IndexMatching -> SamplesIn
		},
		RelativeHumidityData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, RelativeHumidity],
			Description -> "For each member of SamplesIn, a recording of the actual relative humidity percentage inside in the incubator from the point which the samples were loaded until the incubation Time has passed.",
			Category -> "Environmental Data",
			IndexMatching -> SamplesIn
		},
		CarbonDioxideData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, CarbonDioxide],
			Description -> "For each member of SamplesIn, a recording of the actual carbon dioxide percentage inside in the incubator from the point which the samples were loaded until the incubation Time has passed.",
			Category -> "Environmental Data",
			IndexMatching -> SamplesIn
		},
		DefaultIncubationContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that will be incubated in Default Incubators (Incubators that have a ProvidedStorageCondition).",
			Category -> "Incubation",
			Developer -> True
		},
		PostDefaultIncubationContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that will be incubated in Default Incubators (Incubators that have a ProvidedStorageCondition) that have a different IncubationCondition and SamplesOutStorageCondition.",
			Category -> "Incubation",
			Developer -> True
		},
		DefaultIncubatorAvailabilities -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[StorageAvailability],
			Description -> "For each member of DefaultIncubationContainers, the storage availability object that corresponds to a reserved position in an incubator.",
			Category -> "Incubation",
			IndexMatching -> DefaultIncubationContainers,
			Developer -> True
		},
		PostDefaultIncubationAvailabilities -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[StorageAvailability],
			Description -> "For each member of PostDefaultIncubationContainers, the storage availability object that corresponds to a reserved position in an incubator.",
			Category -> "Incubation",
			IndexMatching -> PostDefaultIncubationContainers,
			Developer -> True
		},
		NonIncubationStorageContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that have a SamplesOutStorageCondition that does not correspond to an incubator.",
			Category -> "Incubation",
			Developer -> True
		},
		NonIncubationStorageContainerConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			Description -> "For each member of NonIncubationStorageContainers, the storage condition the sample be moved to at the end of the experiment.",
			Category -> "Incubation",
			IndexMatching -> NonIncubationStorageContainers,
			Developer -> True
		},
		IncubationStartTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time at which the processing stage begins and the time which we begin recording environmental data inside the incubator.",
			Category -> "Incubation",
			Developer -> True
		},
		IncubatorSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sensor, Temperature], Object[Sensor, CarbonDioxide], Object[Sensor, RelativeHumidity]],
			Description -> "The sensor objects inside Incubators whose data need to be recorded during the processing stage of the experiment.",
			Category -> "Incubation",
			Developer -> True
		},
		IncubatorEnvironmentalData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data, Temperature], Object[Data, CarbonDioxide], Object[Data, RelativeHumidity]],
			Description -> "For each member of IncubatorSensors, the data recorded from the sensor during the incubation.",
			Category -> "Incubation",
			IndexMatching -> IncubatorSensors,
			Developer -> True
		},
		(*===Quantification===*)
		QuantificationInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "The instrument used to assess the concentration of cells in the sample at every QuantificationInterval.",
			Category -> "Quantification"
		},
		QuantificationMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Nephelometry, Absorbance, CoulterCount, ColonyCount],
			Description -> "The analytical method employed to assess the quantity or concentration of cells contained within the sample.",
			Category -> "Quantification"
		},
		QuantificationInterval -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Hour],
			Units -> Hour,
			Description -> "The duration of time that elapses between each quantification of the cells in the sample.",
			Category -> "Quantification"
		},
		MinQuantificationTargets -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 (Cell/Milliliter)], GreaterP[0 OD600], GreaterP[0 (CFU/Milliliter)], GreaterP[0 Colony]],
			Units -> None,
			Description -> "For each member of SamplesIn, the minimum concentration of cells in the sample which must be detected by the QuantificationMethod before incubation is ceased and the protocol proceeds to the next step.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		QuantificationTolerances -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 (Cell/Milliliter)], GreaterP[0 Percent], GreaterP[0 OD600], GreaterP[0 (CFU/Milliliter)], GreaterP[0 Colony]],
			Units -> None,
			Description -> "For each member of SamplesIn, the margin of error applied to the MinQualificationTarget such that, if the detected cell concentration exceeds the MinQuantificationTarget minus this value, the quantified concentration is considered to have met the target.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		QuantificationAliquotVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SamplesIn, the volume of sample transferred to the QuantificationAliquotContainer to assess the concentration of cells using the QuantificationMethod.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		QuantificationAliquotContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of SamplesIn, the container into which a portion of the cell sample is transferred in order to assess the concentration of cells in the sample.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		QuantificationRecoupSample -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the aliquoted sample(s) should be recovered back into the corresponding source sample(s) after measurement using the QuantificationMethod.",
			Category -> "Quantification"
		},
		CurrentRecoupSampleUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the manner in which the aliquoted cell sample(s) are transferred back into their original container(s) following the current quantification subprotocol in this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		RecoupSampleUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the manner in which the aliquoted cell sample(s) are transferred back into their original container(s) following each quantification subprotocol in this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		MostRecentRecoupSampleProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The most recent subprotocol used to transfer the cells in this protocol to their original container following quantification.",
			Category -> "Quantification",
			Developer -> True
		},
		RecoupSampleProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The subprotocols used to transfer the cells in this protocol to their original container following quantification.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationBlanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, the sample on which the blank measurement is recorded in order to subtract background noise from the quantification measurement.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		QuantificationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the wavelength at which the quantification measurement is recorded.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		QuantificationStandardCurves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, StandardCurve],
			Description -> "For each member of SamplesIn, an empirically derived function used to convert the results of quantification measurements to a cell concentration, which is then compared to the MinQuantificationTarget.",
			Category -> "Quantification",
			IndexMatching -> SamplesIn
		},
		FailureResponse -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Freeze, Incubate, Discard],
			Description -> "The manner in which the cell sample is to be processed in the event that the MinQuantificationTarget is not reached before the Time elapses from the beginning of cell incubation.",
			Category -> "Failure Response"
		},
		FailureResponseUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FreezeCellsP,
			Description -> "A set of instructions specifying the intended treatment of the cell sample(s) in the event that one or more samples in the protocol fail to meet their MinQuantificationTarget before the Time elapses.",
			Category -> "Failure Response",
			Developer -> True
		},
		FailureResponseProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The protocol used to process the cell sample(s) in the event that one or more samples in the protocol fail to meet their MinQuantificationTarget before the Time elapses.",
			Category -> "Failure Response",
			Developer -> True
		},
		QuantificationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> QuantifyCellsP | QuantifyColoniesP,
			Description -> "A set of instructions specifying the manner in which the cell sample(s) are quantified at each QuantificationInterval during this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		CurrentQuantificationUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> QuantifyCellsP | QuantifyColoniesP,
			Description -> "A set of instructions specifying the manner in which the cell sample(s) are to be quantified at the conclusion of the current QuantificationInterval during this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationPreparation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PreparationMethodP,
			Description -> "Indicates if the cell quantification should occur manually or on a robotic liquid handler.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationSubprotocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "A list of the subprotocols used in cell quantification during this protocol.",
			Category -> "Quantification"
		},
		QuantificationAliquotUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the manner in which the cell sample(s) are transferred to a new container prior to quantification at each QuantificationInterval during this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationAliquotProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "A list of the subprotocols used to transfer cell samples to new container(s) prior to quantification during this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		MostRecentQuantificationAliquotProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The most recent subprotocol used to transfer the cells in this protocol to a new container prior to quantification.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationProcessingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The input duration of the instrument processing stages of protocols which involve cell quantification.",
			Category -> "Quantification",
			Developer -> True
		},
		IncubationDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The amount of time the cell sample(s) spend in incubators during processing stages of protocols which involve cell quantification.",
			Category -> "Quantification",
			Developer -> True
		},
		CellGrowthLog -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_?DateObjectQ, {_?QuantityQ..}},
			Description -> "The time(s) at which the cell concentration was quantified and list(s) of the associated concentrations, index-matched to the cell samples.",
			Category -> "Quantification"
		},
		QuantificationTargetsMet -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates whether or not the sample has reached its MinQuantificationTarget (within the QuantificationTolerance).",
			Category -> "Quantification",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		MaxNumberOfQuantifications -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "The greatest possible number of times that the cell sample(s) can be quantified during this experiment, obtained by dividing the Time by the QuantificationInterval and rounding down to an integer.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationsRemaining -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The remaining number of times the cell sample(s) are expected to be quantified during this experiment.",
			Category -> "Quantification",
			Developer -> True
		},
		QuantificationCounter -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "The number of times that the cell sample(s) have been quantified to this point in the experiment.",
			Category -> "Quantification",
			Developer -> True
		},
		MostRecentQuantification -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]],
			Description -> "The most recent subprotocol used to quantify the cells or colonies in this protocol.",
			Category -> "Quantification",
			Developer -> True
		},
		ObjectsToStore -> {
			Format -> Multiple,
			Class -> Link,
			Pattern:> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Plumbing],
				Object[Item],
				Object[Wiring]
			],
			Description -> "A list of objects to be stored during instrument processing because they are no longer needed for this protocol.",
			Category -> "Cleaning",
			Developer -> True
		}
	}
}];
