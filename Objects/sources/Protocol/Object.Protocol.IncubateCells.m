

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

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
		}
	}
}];
