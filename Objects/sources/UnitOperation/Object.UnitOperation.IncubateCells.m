(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, IncubateCells],
	{
		Description -> "A detailed set of parameters that specifies how to grow or maintain samples containing cells.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
			(*===General Information===*)
			SampleLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "The samples containing target cells which will be held at desired incubation condition in order to expand the number of target cells.",
				Category -> "General",
				Migration -> SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The samples containing target cells which will be held at desired incubation condition in order to expand the number of target cells.",
				Category -> "General",
				Migration -> SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The samples containing target cells which will be held at desired incubation condition in order to expand the number of target cells.",
				Category -> "General",
				Migration -> SplitField
			},
			Time -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Hour],
				Units -> Hour,
				Description -> "The duration during which the input cells are incubated inside of cell incubators.",
				Category -> "General"
			},
			Incubator -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, Incubator],
					Object[Instrument, Incubator]
				],
				Description -> "For each member of SampleLink, the instrument used to cultivate cell cultures under specified conditions, including, Temperature, CarbonDioxide, RelativeHumidity, ShakingRate, and ShakingRadius.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			(*===Incubation Condition Information===*)
			IncubationConditionLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[StorageCondition],
				Description -> "For each member of SampleLink, the default incubation condition with desired Temperature, CarbonDioxide, RelativeHumidity, ShakingRate etc under which the SamplesIn will be stored inside of the incubator.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			IncubationConditionExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[SampleStorageTypeP, Custom],
				Description -> "For each member of SampleLink, the default incubation condition with desired Temperature, CarbonDioxide, RelativeHumidity, ShakingRate etc under which the SamplesIn will be stored inside of the incubator.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			Temperature -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "For each member of SampleLink, temperature at which the input cells are incubated. Currently, 30 Degrees Celsius and 37 Degrees Celsius are supported by default cell culture incubation conditions. Alternatively, a customized temperature can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			RelativeHumidity -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Percent],
				Units -> Percent,
				Description -> "For each member of SampleLink, percent humidity at which the input cells are incubated. Currently, 93% Relative Humidity is supported by default cell culture incubation conditions. Alternatively, a customized relative humidity can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			CarbonDioxide -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Percent],
				Units -> Percent,
				Description -> "For each member of SampleLink, percent CO2 at which the input cells are incubated. Currently, 5% Carbon Dioxide is supported by default cell culture incubation conditions. Alternatively, a customized carbon dioxide percentage can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			Shake -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the input sample should be shaken during incubation.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			ShakingRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 RPM],
				Units -> RPM,
				Description -> "For each member of SampleLink, the frequency at which the sample is agitated by movement in a circular motion. Currently, 200 RPM, 250 RPM and 400 RPM are supported by preset cell culture incubation conditions with shaking. Alternatively, a customized shaking rate can be requested with a dedicated custom incubator until the protocol is completed. See the IncubationCondition option for more information.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			ShakingRadius -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> CellIncubatorShakingRadiusP,(*3 Millimeter, 25 Millimeter, 25.4 Millimeter*)
				Description -> "For each member of SampleLink, the radius of the circle of orbital motion applied to the sample during incubation. The MultitronPro Incubators for plates has a 25 mm shaking radius, and the Innova Incubators have a 25.4 Millimeter shaking radius.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			CellType -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> CellTypeP,
				Description -> "For each member of SampleLink, the type of the most abundant cells that are thought to be present in this sample.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			CultureAdhesion -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> CultureAdhesionP,
				Description -> "For each member of SampleLink, the manner of cell growth the cells in the sample are thought to employ (i.e., SolidMedia, Suspension, and Adherent). SolidMedia cells grow in colonies on a nutrient rich substrate, suspended cells grow free floating in liquid media, and adherent cells grow as a monolayer attached to a substrate.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink
			},
			CustomIncubationPlacements -> {
				Format -> Multiple,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {Object[Container], Object[Container], Null},
				Description -> "For each member of SampleLink, a list of container placements used to place containers containing cells in a Custom incubator.",
				Headers ->  {"Container to Place", "Destination Object","Destination Position"},
				Category -> "Incubation",
				IndexMatching -> SampleLink,
				Developer -> True
			},
			PostCustomIncubationAvailabilities -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[StorageAvailability],
				Description -> "For each member of SampleLink, the storage availability object that corresponds to the reserved position in a default incubator (Incubator with a provided storage condition) that the container will be moved to after custom incubation is complete.",
				Category -> "Incubation",
				IndexMatching -> SampleLink,
				Developer -> True
			}
		}
	}
];
