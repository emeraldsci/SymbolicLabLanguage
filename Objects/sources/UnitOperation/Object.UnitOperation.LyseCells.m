(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,LyseCells],{
	Description -> "A detailed set of parameters that specifies a cell lysis step within a larger protocol.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* --- SAMPLES AND SAMPLE LABELS --- *)

		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "The cell samples whose membranes are to be ruptured.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The cell samples whose membranes are to be ruptured.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},

		(* --- GENERAL OPTIONS --- *)

		MethodLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Method, LyseCells], Object[Method, Extraction]],
			Description -> "For each member of SampleLink, the set of reagents and recommended operating conditions which are used to lyse the cell sample and to perform subsequent extraction unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		MethodExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Custom],
			Description -> "For each member of SampleLink, the set of reagents and recommended operating conditions which are used to lyse the cell sample and to perform subsequent extraction unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		RoboticInstrument->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument],Model[Instrument]],
			Description -> "The robotic liquid handler used (along with integrated instrumentation for heating, mixing, and other functions) to manipulate the cell sample in order to extract and purify targeted cellular components.",
			Category -> "General"
		},
		CellType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "For each member of SampleLink, the taxon of the organism or cell line from which the cell samples originate.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},
		TargetCellularComponent -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (CellularComponentP|Unspecified),
			Description -> "For each member of SampleLink, the class of biomolecule whose purification is desired following lysis of the cell samples and subsequent extraction operations.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},
		CultureAdhesion -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CultureAdhesionP,
			Description -> "For each member of SampleLink, the manner in which the cell samples physically interact with their containers prior to lysis.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},

		(* --- DISSOCIATE --- *)

		Dissociate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if adherent cells in the input cell sample are dissociated from their container prior to cell lysis.",
			IndexMatching -> SampleLink,
			Category -> "Dissociation"
		},

		(* --- NUMBER OF LYSIS STEPS AND REPLICATES --- *)

		NumberOfLysisSteps -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of SampleLink, the number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},

		(* --- CELL TARGETS AND ALIQUOTING --- *)

		TargetCellCount -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 EmeraldCell],
			Units -> EmeraldCell,
			Description -> "For each member of SampleLink, the number of cells in the experiment prior to the addition of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Aliquoting"
		},
		TargetCellConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 EmeraldCell/Milliliter],
			Units -> (EmeraldCell/Milliliter),
			Description -> "For each member of SampleLink, the targeted concentration of cells present in the experiment following combination of cell samples and LysisSolution. This value assumes that the most recent measurement of the concentration of the source sample is accurate when calculated following dilution.",
			IndexMatching -> SampleLink,
			Category -> "Aliquoting"
		},
		AliquotContainerWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the well of the container into which the AliquotAmount is transferred prior to cell lysis.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},
		AliquotContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container into which the cell sample is aliquoted prior to cell lysis, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "General"
		},

		(* --- PRELYSIS PELLETING --- *)

		PreLysisPellet -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the cell sample is centrifuged to remove unwanted solution prior to addition of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PreLysisPelletingCentrifuge -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the centrifuge used to apply centrifugal force to the cell samples at PreLysisPelletingIntensity for PreLysisPelletingTime in order to remove unwanted solution prior to addition of LysisSolution.",
			Category -> "Pelleting"
		},
		PreLysisPelletingIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 GravitationalAcceleration]],
			Description -> "For each member of SampleLink, the rotational speed or force applied to the cell sample to facilitate separation of the cells from the solution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PreLysisPelletingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration for which the cell sample is centrifuged at PreLysisPelletingIntensity to facilitate separation of the cells from the solution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PreLysisSupernatantVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of the supernatant that is transferred to a new container after the cell sample is pelleted prior to optional dilution and addition of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of the supernatant that is transferred to a new container after the cell sample is pelleted prior to optional dilution and addition of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant isolated from the cell sample is stored upon completion of this protocol.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleStorageTypeP, Disposal],
			Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant isolated from the cell sample is stored upon completion of this protocol.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{_Integer, ObjectP[Model[Container]]},
				{_String, ObjectP[{Object[Container], Model[Container]}]},
				{_String, {_Integer, ObjectP[{Object[Container], Model[Container]}]}},
				Null
			],
			Description -> "For each member of SampleLink, the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SampleLink, the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PreLysisSupernatantContainerWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the well of the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PreLysisSupernatantLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the supernatant which is transferred to a new container following pelleting of the cell sample by centrifugation, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PreLysisSupernatantContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the new container into which the supernatant is transferred to a new container following pelleting of the cell sample by centrifugation, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},

		(* --- PRELYSIS DILUTION --- *)

		PreLysisDilute -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the cell sample is diluted prior to cell lysis.",
			IndexMatching -> SampleLink,
			Category -> "Aliquoting"
		},
		PreLysisDiluent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleLink, the solution with which the cell sample is diluted prior to cell lysis.",
			IndexMatching -> SampleLink,
			Category -> "Aliquoting"
		},
		PreLysisDilutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of PreLysisDiluent added to the cell sample (or AliqoutAmount, if a portion of the cell sample has been aliquoted to an AliquotContainer) prior to addition of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Aliquoting"
		},

		(* --- CONDITIONS FOR PRIMARY LYSIS STEP --- *)

		LysisSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleLink, the solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},
		LysisSolutionVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of LysisSolution to be added to the cell sample.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		LysisSolutionVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of LysisSolution to be added to the cell sample.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		MixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "For each member of SampleLink, the rate at which the sample is mixed by the selected MixType during the MixTime.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		MixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration for which the sample is mixed by the selected MixType following combination of the cell sample and the LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		NumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of SampleLink, the number of times that the sample is mixed by pipetting the MixVolume up and down following combination of the cell sample and the LysisSolution.",
			IndexMatching -> SampleLink,
			Category ->"Mixing"
		},
		MixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of the cell sample and LysisSolution displaced during each mix-by-pipette mix cycle.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		MixTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the MixTime, which occurs immediately before the LysisTime.",
			IndexMatching -> SampleLink,
			Category -> "Mixing",
			Migration -> SplitField
		},
		MixTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the MixTime, which occurs immediately before the LysisTime.",
			IndexMatching -> SampleLink,
			Category -> "Mixing",
			Migration -> SplitField
		},
		MixInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the device used to mix the cell sample by shaking.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		LysisTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the minimum duration for which the IncubationInstrument is maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},
		LysisTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the IncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		LysisTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleLink, the temperature at which the IncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},

		(* --- CONDITIONS FOR SECONDARY LYSIS STEP --- *)

		SecondaryLysisSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleLink, the solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},
		SecondaryLysisSolutionVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of SecondaryLysisSolution to be added to the cell sample in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		SecondaryLysisSolutionVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of SecondaryLysisSolution to be added to the cell sample in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		SecondaryMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[MixTypeP,None],
			Description -> "For each member of SampleLink, the manner in which the sample is mixed following combination of cell sample and SecondaryLysisSolution in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		SecondaryMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "For each member of SampleLink, the rate at which the sample is mixed by the selected SecondaryMixType during the SecondaryMixTime in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		SecondaryMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration for which the sample is mixed by the selected SecondaryMixType following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		SecondaryNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of SampleLink, the number of times that the sample is mixed by pipetting the SecondaryMixVolume up and down following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category ->"Mixing"
		},
		SecondaryMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of the cell sample and SecondaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		SecondaryMixTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing",
			Migration -> SplitField
		},
		SecondaryMixTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing",
			Migration -> SplitField
		},
		SecondaryMixInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the device used to mix the cell sample by shaking in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		SecondaryLysisTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the minimum duration for which the SecondaryIncubationInstrument is maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},
		SecondaryLysisTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the SecondaryIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		SecondaryLysisTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleLink, the temperature at which the SecondaryIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		SecondaryIncubationInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the device used to cool or heat the cell sample to the SecondaryLysisTemperature for the duration of the SecondaryLysisTime in an optional second lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},

		(* --- CONDITIONS FOR TERTIARY LYSIS STEP --- *)

		TertiaryLysisSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of SampleLink, the solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},
		TertiaryLysisSolutionVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of TertiaryLysisSolution to be added to the cell sample in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		TertiaryLysisSolutionVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of TertiaryLysisSolution to be added to the cell sample in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		TertiaryMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[MixTypeP,None],
			Description -> "For each member of SampleLink, the manner in which the sample is mixed following combination of cell sample and TertiaryLysisSolution in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		TertiaryMixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "For each member of SampleLink, the rate at which the sample is mixed by the selected TertiaryMixType during the TertiaryMixTime in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		TertiaryMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration for which the sample is mixed by the selected TertiaryMixType following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		TertiaryNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of SampleLink, the number of times that the sample is mixed by pipetting the TertiaryMixVolume up and down following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category ->"Mixing"
		},
		TertiaryMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Milliliter,
			Description -> "For each member of SampleLink, the volume of the cell sample and TertiaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		TertiaryMixTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing",
			Migration -> SplitField
		},
		TertiaryMixTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing",
			Migration -> SplitField
		},
		TertiaryMixInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the device used to mix the cell sample by shaking in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Mixing"
		},
		TertiaryLysisTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the minimum duration for which the TertiaryIncubationInstrument is maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},
		TertiaryLysisTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature at which the TertiaryIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		TertiaryLysisTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Ambient],
			Description -> "For each member of SampleLink, the temperature at which the TertiaryIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
		TertiaryIncubationInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the device used to cool or heat the cell sample to the TertiaryLysisTemperature for the duration of the TertiaryLysisTime in an optional third lysis step.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis"
		},

		(* --- LYSATE CLARIFICATION --- *)

		ClarifyLysate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		ClarifyLysateCentrifuge -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]],
			Description -> "For each member of SampleLink, the centrifuge used to apply centrifugal force to the cell samples at ClarifyLysateIntensity for ClarifyLysateTime in order to facilitate separation of suspended, insoluble cellular debris into a solid phase at the bottom of the container.",
			Category -> "Pelleting"
		},
		ClarifyLysateIntensity -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 GravitationalAcceleration]],
			Description -> "For each member of SampleLink, the rotational speed or force applied to the lysate to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		ClarifyLysateTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of SampleLink, the duration for which the lysate is centrifuged at ClarifyLysateIntensity to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		ClarifiedLysateVolumeReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of lysate transferred to a new container following clarification by centrifugation.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		ClarifiedLysateVolumeExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of lysate transferred to a new container following clarification by centrifugation.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PostClarificationPelletStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the pelleted sample resulting from the centrifugation of lysate to remove cellular debris is stored upon completion of this protocol.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PostClarificationPelletStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleStorageTypeP, Disposal],
			Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the pelleted sample resulting from the centrifugation of lysate to remove cellular debris is stored upon completion of this protocol.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PostClarificationPelletContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the container in which the lysate resulting from cell lysis is located.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PostClarificationPelletContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{_Integer, ObjectP[Model[Container]]},
				{_String, ObjectP[{Object[Container], Model[Container]}]},
				{_String, {_Integer, ObjectP[{Object[Container], Model[Container]}]}},
				Null
			],
			Description -> "For each member of SampleLink, the container in which the lysate resulting from cell lysis is located.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PostClarificationPelletContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SampleLink, the container in which the lysate resulting from cell lysis is located.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		PostClarificationPelletContainerWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the well of ContainerOut in which the lysate resulting from cell lysis is located.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PostClarificationPelletLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container in which the lysate sample resulting from the disruption of cell membranes is located, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		PostClarificationPelletContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container in which the lysate sample resulting from the disruption of cell membranes is located, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		ClarifiedLysateContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		ClarifiedLysateContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				{_Integer, ObjectP[Model[Container]]},
				{_String, ObjectP[{Object[Container], Model[Container]}]},
				{_String, {_Integer, ObjectP[{Object[Container], Model[Container]}]}},
				Null
			],
			Description -> "For each member of SampleLink, the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		ClarifiedLysateContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SampleLink, the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting",
			Migration -> SplitField
		},
		ClarifiedLysateContainerWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the well of the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},
		ClarifiedLysateContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
			IndexMatching -> SampleLink,
			Category -> "Pelleting"
		},

		(* --- LYSATE STORAGE AND HANDLING --- *)

		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the lysate sample resulting from the disruption of cell membranes, for use in downstream unit operations.",
			IndexMatching -> SampleLink,
			Category -> "Sample Storage"
		},
		SamplesOutStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the lysate generated from the cell lysis experiment is stored upon completion of this protocol.",
			IndexMatching -> SampleLink,
			Category -> "Sample Storage",
			Migration -> SplitField
		},
		SamplesOutStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleStorageTypeP, Disposal],
			Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the lysate generated from the cell lysis experiment is stored upon completion of this protocol.",
			IndexMatching -> SampleLink,
			Category -> "Sample Storage",
			Migration -> SplitField
		}

	}
}];
