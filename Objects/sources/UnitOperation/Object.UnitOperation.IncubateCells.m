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
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the source sample that are used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the source container that are used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleLink
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
			IncubationStrategy -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Time, QuantificationTarget],
				Description -> "The manner in which the end of the incubation period is determined.",
				Category -> "General"
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
			RelativeHumidityExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Ambient,
				Description -> "For each member of SampleLink, percent humidity at which the input cells are incubated. Currently, 93% Relative Humidity is supported by default cell culture incubation conditions. Alternatively, a customized relative humidity can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			RelativeHumidityReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Percent],
				Units -> Percent,
				Description -> "For each member of SampleLink, percent humidity at which the input cells are incubated. Currently, 93% Relative Humidity is supported by default cell culture incubation conditions. Alternatively, a customized relative humidity can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			CarbonDioxideExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Ambient,
				Description -> "For each member of SampleLink, percent CO2 at which the input cells are incubated. Currently, 5% Carbon Dioxide is supported by default cell culture incubation conditions. Alternatively, a customized carbon dioxide percentage can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			CarbonDioxideReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Percent],
				Units -> Percent,
				Description -> "For each member of SampleLink, percent CO2 at which the input cells are incubated. Currently, 5% Carbon Dioxide is supported by default cell culture incubation conditions. Alternatively, a customized carbon dioxide percentage can be requested with a dedicated custom incubator until the protocol is completed.",
				Category -> "Incubation Condition",
				IndexMatching -> SampleLink,
				Migration -> SplitField
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
				Pattern :> CellIncubatorShakingRadiusP, (*3 Millimeter, 25 Millimeter, 25.4 Millimeter*)
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
				Headers -> {"Container to Place", "Destination Object", "Destination Position"},
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
			},
			(*===Quantification===*)
			QuantificationMethod -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Nephelometry, Absorbance, CoulterCount, ColonyCount],
				Description -> "The analytical method employed to assess the quantity or concentration of cells contained within the sample.",
				Category -> "Quantification"
			},
			QuantificationInstrument -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Instrument], Object[Instrument]],
				Description -> "The instrument used to assess the concentration of cells in the sample at every QuantificationInterval.",
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
			FailureResponse -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[Freeze, Incubate, Discard],
				Description -> "The manner in which the cell sample is to be processed in the event that the MinQuantificationTarget is not reached before the Time elapses from the beginning of cell incubation.",
				Category -> "Quantification"
			},
			MinQuantificationTargetVariableUnit -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> Alternatives[GreaterP[0 (Cell/Milliliter)], GreaterP[0 OD600], GreaterP[0 (CFU/Milliliter)], GreaterP[0 Colony]],
				Units -> None,
				Description -> "For each member of SampleLink, the minimum concentration of cells in the sample which must be detected by the QuantificationMethod before incubation is ceased and the protocol proceeds to the next step.",
				Category -> "Quantification",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			MinQuantificationTargetExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[None],
				Units -> None,
				Description -> "For each member of SampleLink, the minimum concentration of cells in the sample which must be detected by the QuantificationMethod before incubation is ceased and the protocol proceeds to the next step.",
				Category -> "Quantification",
				IndexMatching -> SampleLink,
				Migration -> SplitField
			},
			QuantificationTolerance -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> Alternatives[GreaterP[0 (Cell/Milliliter)], GreaterP[0 Percent], GreaterP[0 OD600], GreaterP[0 (CFU/Milliliter)], GreaterP[0 Colony]],
				Units -> None,
				Description -> "For each member of SampleLink, the margin of error applied to the MinQualificationTarget such that, if the detected cell concentration exceeds the MinQuantificationTarget minus this value, the quantified concentration is considered to have met the target.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationAliquot -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if an aliquot of cell sample is transferred to a new container prior to quantification rather than being analyzed in the cell sample's current container.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationAliquotVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of SampleLink, the volume of sample transferred to the QuantificationAliquotContainer to assess the concentration of cells using the QuantificationMethod.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationAliquotContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Container],
				Description -> "For each member of SampleLink, the container into which a portion of the cell sample is transferred in order to assess the concentration of cells in the sample.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationRecoupSample -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the aliquoted sample(s) should be recovered back into the corresponding source sample(s) after measurement using the QuantificationMethod.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationBlankMeasurement -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if a blank measurement is to be recorded and used to subtract background noise from the quantification measurement.",
				Category -> "Quantification"
			},
			QuantificationBlank -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Sample], Object[Sample]],
				Description -> "For each member of SampleLink, the sample on which the blank measurement is recorded in order to subtract background noise from the quantification measurement.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			BlanksLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample],
					Object[Sample]
				],
				Description -> "The object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SampleLink.",
				Category -> "Quantification",
				Migration -> SplitField
			},
			BlanksString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SampleLink.",
				Category -> "Quantification",
				Migration -> SplitField
			},
			BlankLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample],
					Object[Sample]
				],
				Description -> "The object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose light scattering is subtracted as background from the nephelometry readings of the SampleLink.",
				Category -> "Quantification",
				Migration -> SplitField
			},
			BlankString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose light scattering is subtracted as background from the nephelometry readings of the SampleLink.",
				Category -> "Quantification",
				Migration -> SplitField
			},
			QuantificationWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Nanometer],
				Units -> Nanometer,
				Description -> "For each member of SampleLink, the wavelength at which the quantification measurement is recorded.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationStandardCurve -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Analysis, StandardCurve],
				Description -> "For each member of SampleLink, an empirically derived function used to convert the results of quantification measurements to a cell concentration, which is then compared to the MinQuantificationTarget.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			}
		}
	}
];
