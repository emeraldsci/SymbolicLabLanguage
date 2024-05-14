(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, Extraction], {
	Description -> "A method specifying conditions and reagents for the extraction and isolation of desired cellular components from a cell-containing sample.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* Lysis Shared Options *)

		Lyse -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the input sample is lysed, breaking the cells' plasma membranes chemically and releasing the cell components into the chosen solution, creating a lysate to extract the plasmid DNA from. An input of live cells must be lysed before neutralization and purification. An input of lysate will not be lysed again before neutralization and purification.",
			Category -> "Cell Lysis"
		},
		
		(* - GENERAL INFORMATION - *)

		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "The taxon of the organism or cell line from which the cell sample originates.",
			Category -> "Cell Lysis"
		},
		TargetCellularComponent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[CellularComponentP, Unspecified],
			Description -> "The class of biomolecule whose purification is desired following lysis of the cell sample and any subsequent extraction operations.",
			Category -> "Cell Lysis"
		},
		NumberOfLysisSteps -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes.",
			Category -> "Cell Lysis"
		},

		(* The method object does not specify fields for aliquoting and dilution options since these should instead resolve based on experiment scale *)

		(* - PRELYSIS PELLETING - *)

		PreLysisPellet -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if adherent cells in the input cell sample are dissociated from their container prior to cell lysis.",
			Category -> "Cell Lysis"
		},
		PreLysisPelletingIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or force applied to the cell sample to facilitate separation of the cells from the solution.",
			Category -> "Cell Lysis"
		},
		PreLysisPelletingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The duration for which the cell sample is centrifuged at PreLysisPelletingIntensity to facilitate separation of the cells from the solution.",
			Category -> "Cell Lysis"
		},

		(* - CONDITIONS FOR FIRST LYSIS STEP - *)

		LysisSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The amount that is transferred from the input cell sample to a new container in order to lyse a portion of the cell sample.",
			Category -> "Cell Lysis"
		},
		LysisMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixTypeP | None | Null,
			Description -> "The manner in which the solutions are mixed following combination of the cell samples and LysisSolutions.",
			Category -> "Cell Lysis"
		},
		LysisMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The rate at which the samples are mixed by the LysisMixType during the LysisMixTime.",
			Category -> "Cell Lysis"
		},
		LysisMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The duration for which the samples are mixed by the MixType following combination of the cell samples and the LysisSolution.",
			Category -> "Cell Lysis"
		},
		NumberOfLysisMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the samples are mixed by pipetting the LysisMixVolume up and down.",
			Category -> "Cell Lysis"
		},
		LysisMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples is maintained during the LysisMixTime.",
			Category -> "Cell Lysis"
		},
		LysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The minimum duration for which the LysisInstrument heating or cooling the cell samples are maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents.",
			Category -> "Cell Lysis"
		},
		LysisTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples is maintained during the LysisTime, following addition of the LysisSolution and mixing.",
			Category -> "Cell Lysis"
		},

		(* - CONDITIONS FOR SECOND LYSIS STEP - *)

		SecondaryLysisSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution intended to effect the disruption of cell membranes (including enzymes, detergents, and chaotropics) in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryLysisMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixTypeP,
			Description -> "The manner in which the solutions are mixed following combination of the cell samples and SecondaryLysisSolution in the protocol's second lysis step. Null implies that no mixing occurs during the second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryLysisMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The rate at which the samples are mixed by the SecondaryLysisMixType during the SecondaryLysisMixTime in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryLysisMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The duration for which the samples are mixed by the SecondaryLysisMixType following combination of the cell samples and the SecondaryLysisSolution in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryNumberOfLysisMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the samples are mixed by pipetting the SecondaryLysisMixVolume up and down in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryLysisMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and SecondaryLysisSolution is maintained during the SecondaryLysisMixTime in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryLysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The minimum duration for which the LysisInstrument heating or cooling the cell samples are maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},
		SecondaryLysisTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and SecondaryLysisSolution is maintained during the SecondaryLysisTime, following addition of the SecondaryLysisSolution and mixing in the protocol's second lysis step.",
			Category -> "Cell Lysis"
		},

		(* - CONDITIONS FOR THIRD LYSIS STEP - *)

		TertiaryLysisSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution intended to effect the disruption of cell membranes (including enzymes, detergents, and chaotropics) in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryLysisMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixTypeP,
			Description -> "The manner in which the solutions are mixed following combination of the cell samples and TertiaryLysisSolution in the protocol's third lysis step. Null implies that no mixing occurs during the third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryLysisMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The rate at which the samples are mixed by the TertiaryLysisMixType during the TertiaryLysisMixTime in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryLysisMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The duration for which the samples are mixed by the TertiaryLysisMixType following combination of the cell samples and the TertiaryLysisSolution in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryNumberOfLysisMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the samples are mixed by pipetting the TertiaryLysisMixVolume up and down in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryLysisMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and TertiaryLysisSolution is maintained during the TertiaryLysisMixTime in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryLysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The minimum duration for which the LysisInstrument heating or cooling the cell samples are maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		TertiaryLysisTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and TertiaryLysisSolution is maintained during the TertiaryLysisTime, following addition of the TertiaryLysisSolution and mixing in the protocol's third lysis step.",
			Category -> "Cell Lysis"
		},
		ClarifyLysate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
			Category -> "Cell Lysis"
		},
		ClarifyLysateIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or force applied to the lysate to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
			Category -> "Cell Lysis"
		},
		ClarifyLysateTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The duration for which the lysate is centrifuged at ClarifyLysateIntensity to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
			Category -> "Cell Lysis"
		},

		(* Purification Shared Option *)

		Purification -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ( None | (LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation) | {(LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation)..} ),
			Description -> "Indicates the number of rudimentary purification steps, which techniques each step will use, and in what order the techniques will be carried out to isolate the target cell component. There are four rudimentary purification techniques: liquid-liquid extraction, precipitation, solid phase extraction (also known as using \"spin columns\"), and magnetic bead separation. Each technique can be run up to three times each and can be run in any order (as specified by the order of the list). Additional purification steps such as these or more advanced purification steps such as HPLC, FPLC, gels, etc. can be performed on the final product using scripts which call the corresponding functions (ExperimentLiquidLiquidExtraction, ExperimentPrecipitate, ExperimentSolidPhaseExtraction, ExperimentMagneticBeadSeparation, ExperimentHPLC, ExperimentFPLC, ExperimentAgaroseGelElectrophoresis, etc.).",
			Category -> "Purification"
		},

		(* Liquid-liquid Extraction Shared Options *)

		LiquidLiquidExtractionTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Pipette | PhaseSeparator,
			Description -> "The physical separation technique that is used to separate the aqueous and organic phase of a sample after solvent addition, mixing, and settling. Pipette uses a pipette to aspirate off either the aqueous or organic layer. PhaseSeparator uses a column with a hydrophobic frit, which allows the organic phase to pass freely through the frit, but physically blocks the aqueous phase from passing through.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionDevice -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Plate, PhaseSeparator], Model[Container, Plate, PhaseSeparator]],
			Description -> "The device which is used to physically separate the aqueous and organic phases.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionSelectionStrategy -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Positive | Negative,
			Description -> "Indicates if additional rounds of extraction are performed on the impurity phase (Positive) or the target phase (Negative). Positive selection is used when the goal is to extract the maximum amount of target analyte from the impurity phase (maximizing yield). Negative selection is used when the goal is to remove impurities that may still exist in the target phase (maximizing purity).",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionTargetPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Aqueous | Organic,
			Description -> "Indicates the phase (Organic or Aqueous) that is collected during the extraction and carried forward to further purification steps or other experiments, which is the liquid layer that contains more of the dissolved target analyte after the liquid-liquid extraction settling time has elapsed and the phases are separated.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionTargetLayer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {(Top | Bottom)..},
			Description -> "Indicates if the target phase (containing more of the target analyte) is the top layer or the bottom layer of the separated solution.",
			Category -> "Liquid-liquid Extraction"
		},
		AqueousSolvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[ObjectP[{Object[Sample],Model[Sample]}], None],
			Description -> "The aqueous solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase for a liquid-liquid extraction.",
			Category -> "Liquid-liquid Extraction"
		},
		AqueousSolventRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The ratio of the sample volume to the volume of aqueous solvent that is added to the sample in a liquid-liquid extraction.",
			Category -> "Liquid-liquid Extraction"
		},
		OrganicSolvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[ObjectP[{Object[Sample],Model[Sample]}], None],
			Description -> "The organic solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase for a liquid-liquid extraction.",
			Category -> "Liquid-liquid Extraction"
		},
		OrganicSolventRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The ratio of the sample volume to the volume of organic solvent that is added to the sample in a liquid-liquid extraction.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionSolventAdditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[ObjectP[{Object[Sample],Model[Sample]}],ListableP[ObjectP[{Object[Sample],Model[Sample]}]], None]],
			Description -> "For each extraction round of a liquid-liquid extraction, the solvent(s) that are added to the sample in order to create a biphasic solution.",
			Category -> "Liquid-liquid Extraction"
		},
		Demulsifier -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[ObjectP[{Object[Sample],Model[Sample]}], None],
			Description -> "The organic solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase.",
			Category -> "Liquid-liquid Extraction"
		},
		DemulsifierAdditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Alternatives[ObjectP[{Object[Sample],Model[Sample]}], None]],
			Description -> "For each extraction round, the Demulsifier that is added to the sample mixture to help promote complete phase separation and avoid emulsions.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The set temperature of the incubation device that holds the extraction container during solvent/demulsifier addition, mixing, and settling in a liquid-liquid extraction.",
			Category -> "Liquid-liquid Extraction"
		},
		NumberOfLiquidLiquidExtractions -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of times that the liquid-liquid extraction is performed using the specified extraction parameters first on the input sample, and then using the previous extraction round's target layer or impurity layer (based on the LiquidLiquidSelectionStrategy and LiquidLiquidExtractionTargetPhase).",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the sample mixture following the addition of the AqueousSolvent/OrganicSolvent and Demulsifier (if specified).",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the sample, AqueousSolvent/OrganicSolvent, and Demulsifier (if specified) are mixed.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The frequency of rotation the mixing instrument uses to mechanically incorporate the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified).",
			Category -> "Liquid-liquid Extraction"
		},
		NumberOfLiquidLiquidExtractionMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[1],
			Units -> None,
			Description -> "The number of times the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) are mixed when LiquidLiquidExtractionMixType is set to Pipette.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionSettlingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the sample is allowed to settle and thus allow the organic and aqueous phases to separate after the AqueousSolvent/OrganicSolvent and Demulsifier (if specified) are added and optionally mixed. If LiquidLiquidExtractionTechnique is set to PhaseSeparator, the settling time starts once the sample is loaded into the phase separator (the amount of time for the organic phase to drain through the phase separator's hydrophobic frit).",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionCentrifuge -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is centrifuged to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
			Category -> "Cell Lysis"
		},
		LiquidLiquidExtractionCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0*GravitationalAcceleration], GreaterEqualP[0*RPM]],
			Units -> None,
			Description -> "The rotational speed or the force that is applied to the samples via centrifugation to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
			Category -> "Liquid-liquid Extraction"
		},
		LiquidLiquidExtractionCentrifugeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The amount of time that the samples are centrifuged to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
			Category -> "Liquid-liquid Extraction"
		},

		(* Precipitation *)

		PrecipitationTargetPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Solid | Liquid,
			Description -> "Indicates if the target molecules in this sample are expected to be located in the solid precipitate or liquid supernatant after separating the two phases by pelleting or filtration.",
			Category -> "Precipitation"
		},
		PrecipitationSeparationTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Pellet | Filter,
			Description -> "Indicates if the the solid precipitate and liquid supernatant are to be separated by centrifugation followed by pipetting of the supernatant (Pellet), or separated by passing the solution through a filter with a pore size large enough to allow the liquid phase to pass through, but not the solid precipitate (Filter).",
			Category -> "Precipitation"
		},
		PrecipitationReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "A reagent which, when added to the sample, will help form the precipitate and encourage it to crash out of solution so that it can be collected if it will contain the target molecules, or discarded if the target molecules will only remain in the liquid phase.",
			Category -> "Precipitation"
		},
		PrecipitationReagentTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature that the PrecipitationReagent is incubated at for the PrecipitationReagentEquilibrationTime before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
			Category -> "Precipitation"
		},
		PrecipitationReagentEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The minimum duration for which the PrecipitationReagent will be kept at PrecipitationReagentTemperature before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
			Category -> "Precipitation"
		},
		PrecipitationMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette | None,
			Description -> "The manner in which the sample is agitated following the addition of PrecipitationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample will be placed on a shaker at PrecipitationMixRate for PrecipitationMixTime, while Pipette indicates that PrecipitationMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationMixes. None indicates that no mixing occurs after adding PrecipitationReagent before incubation.",
			Category -> "Precipitation"
		},
		PrecipitationMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute that the sample and PrecipitationReagent will be shaken at in order to prepare a uniform mixture prior to incubation.",
			Category -> "Precipitation"
		},
		PrecipitationMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the mixing device's heating/cooling block is maintained during the PrecipitationMixTime in order to prepare a uniform mixture prior to incubation.",
			Category -> "Precipitation"
		},
		PrecipitationMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time that the sample and PrecipitationReagent will be shaken for, at the specified PrecipitationMixRate, in order to prepare a uniform mixture prior to incubation.",
			Category -> "Precipitation"
		},
		NumberOfPrecipitationMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times the sample and PrecipitationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to incubation.",
			Category -> "Liquid-liquid Extraction"
		},
		PrecipitationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the combined sample and PrecipitationReagent are left to settle, at the specified PrecipitationTemperature, in order to encourage crashing of precipitant following any mixing.",
			Category -> "Precipitation"
		},
		PrecipitationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the incubation device's heating/cooling block is maintained during the PrecipitationTime in order to encourage crashing out of precipitant.",
			Category -> "Precipitation"
		},
		PrecipitationFiltrationTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Centrifuge | AirPressure,
			Description -> "The type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This will be done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
			Category -> "Precipitation"
		},
		PrecipitationFilter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Plate, Filter], Model[Container, Plate, Filter]],
			Description -> "The consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample, after incubation with PrecipitationReagent.",
			Category -> "Precipitation"
		},
		PrecipitationPrefilterPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> FilterSizeP,
			Units -> Micron,
			Description -> "The pore size of the prefilter membrane, which is placed above PrecipitationFilter, and is designed so that molecules larger than the specified prefilter pore size should not pass through this filter.",
			Category -> "Precipitation"
		},
		PrecipitationPrefilterMembraneMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material from which the prefilter filtration membrane, which is placed above PrecipitationFilter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
			Category -> "Precipitation"
		},
		PrecipitationPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> FilterSizeP,
			Units -> Micron,
			Description -> "The pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
			Category -> "Precipitation"
		},
		PrecipitationMembraneMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
			Category -> "Precipitation"
		},
		PrecipitationFilterCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
			Category -> "Precipitation"
		},
		PrecipitationFiltrationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
			Category -> "Precipitation"
		},
		PrecipitationFiltrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the samples will be exposed to either PrecipitationFiltrationPressure or PrecipitationFilterCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
			Category -> "Precipitation"
		},
		PrecipitationPelletCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or force that will be applied to the sample to facilitate precipitation of insoluble molecules out of solution.",
			Category -> "Precipitation"
		},
		PrecipitationPelletCentrifugeTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the samples will be centrifuged at PrecipitationPelletCentrifugeIntensity in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
			Category -> "Precipitation"
		},
		PrecipitationNumberOfWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[0, 50, 1],
			Units -> None,
			Description -> "The number of times PrecipitationWashSolution is added to the solid, mixed, and then separated again by either pelleting and aspiration if PrecipitationSeparationTechnique is set to Pellet, or by filtration if PrecipitationSeparationTechnique is set to Filter. The wash steps are performed in order to help further wash impurities from the solid.",
			Category -> "Liquid-liquid Extraction"
		},
		PrecipitationWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample, after incubation with PrecipitationReagent.",
			Category -> "Precipitation"
		},
		PrecipitationWashSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which PrecipitationWashSolution is incubated at during the PrecipitationWashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
			Category -> "Precipitation"
		},
		PrecipitationWashSolutionEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The minimum duration for which the PrecipitationWashSolution will be kept at PrecipitationWashSolutionTemperature before being used to help further wash impurities from the solid after the liquid phase has been separated from it.",
			Category -> "Precipitation"
		},
		PrecipitationWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette | None,
			Description -> "The manner in which the sample is agitated following addition of PrecipitationWashSolution, in order to help further wash impurities from the solid. Shake indicates that the sample will be placed on a shaker at the specified PrecipitationWashMixRate for PrecipitationWashMixTime, while Pipette indicates that PrecipitationWashMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationWashMixes. None indicates that no mixing occurs before incubation.",
			Category -> "Precipitation"
		},
		PrecipitationWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The rate at which the solid and PrecipitationWashSolution are mixed, for the duration of PrecipitationWashMixTime, in order to help further wash impurities from the solid.",
			Category -> "Precipitation"
		},
		PrecipitationWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the mixing device's heating/cooling block is maintained for the duration of PrecipitationWashMixTime in order to help further wash impurities from the solid.",
			Category -> "Precipitation"
		},
		PrecipitationWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the solid and PrecipitationWashSolution are mixed at PrecipitationWashMixRate in order to help further wash impurities from the solid.",
			Category -> "Precipitation"
		},
		PrecipitationNumberOfWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times PrecipitationWashMixVolume of the PrecipitationWashSolution is mixed by pipetting up and down in order to help further wash impurities from the solid.",
			Category -> "Liquid-liquid Extraction"
		},
		PrecipitationWashPrecipitationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the samples remain in PrecipitationWashSolution after any mixing has occurred, held at PrecipitationWashPrecipitationTemperature, in order to allow the solid to precipitate back out of solution before separation of WashSolution from the solid.",
			Category -> "Precipitation"
		},
		PrecipitationWashPrecipitationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature which the samples in PrecipitationWashSolution are held at for the duration of PrecipitationWashPrecipitationTime in order to help further wash impurities from the solid.",
			Category -> "Precipitation"
		},
		PrecipitationWashCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or the force that will be applied to the sample in order to separate the PrecipitationWashSolution from the solid after any mixing and incubation steps have been performed. If PrecipitationSeparationTechnique is set to Filter, then the force is applied to the filter containing the retentate and PrecipitationWashSolution in order to facilitate the solution's passage through the filter and further wash impurities from the solid. If PrecipitationSeparationTechnique is set to Pellet, then the force is applied to the container containing the pellet and PrecipitationWashSolution in order to encourage the repelleting of the solid.",
			Category -> "Precipitation"
		},
		PrecipitationWashPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The target pressure applied to the filter containing the retentate and PrecipitationWashSolution in order to facilitate the solution's passage through the filter and help further wash impurities from the retentate.",
			Category -> "Precipitation"
		},
		PrecipitationWashSeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the samples are exposed to PrecipitationWashPressure or PrecipitationWashCentrifugeIntensity in order to separate the PrecipitationWashSolution from the solid. If PrecipitationSeparationTechnique is set to Filter, then this separation is performed by passing the PrecipitationWashSolution through PrecipitationFilter by applying force of either PrecipitationWashPressure (if PrecipitationFiltrationTechnique is set to AirPressure) or PrecipitationWashCentrifugeIntensity (if PrecipitationFiltrationTechnique is set to Centrifuge). If PrecipitationSeparationTechnique is set to Pellet, then centrifugal force of PrecipitationWashCentrifugeIntensity is applied to encourage the solid to remain as, or return to, a pellet at the bottom of the container.",
			Category -> "Precipitation"
		},
		PrecipitationDryingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the incubation device's heating/cooling block is maintained for the duration of PrecipitationDryingTime after removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
			Category -> "Precipitation"
		},
		PrecipitationDryingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The amount of time for which the solid will be exposed to open air at PrecipitationDryingTemperature following final removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution into which the target molecules of the solid will be resuspended or redissolved. Setting PrecipitationResuspensionBuffer to None indicates that the sample will not be resuspended and that it will be stored as a solid, after any wash steps have been performed.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionBufferTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature that the PrecipitationResuspensionBuffer is incubated at during the PrecipitationResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionBufferEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The minimum duration for which the PrecipitationResuspensionBuffer will be kept at PrecipitationResuspensionBufferTemperature before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette | None,
			Description -> "The manner in which the sample is agitated following addition of PrecipitationResuspensionBuffer in order to encourage the solid phase to resuspend or redissolve into the buffer. Shake indicates that the sample will be placed on a shaker at the specified PrecipitationResuspensionMixRate for PrecipitationResuspensionMixTime at PrecipitationResuspensionMixTemperature, while Pipette indicates that PrecipitationResuspensionMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationResuspensionMixes. None indicates that no mixing occurs after adding PrecipitationResuspensionBuffer.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The rate at which the solid and PrecipitationResuspensionBuffer are shaken, for the duration of PrecipitationResuspensionMixTime at PrecipitationResuspensionMixTemperature, in order to encourage the solid to redissolve or resuspend into the buffer.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the sample and PrecipitationResuspensionBuffer are held at for the duration of PrecipitationResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the buffer.",
			Category -> "Precipitation"
		},
		PrecipitationResuspensionMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time that the solid and PrecipitationResuspensionBuffer is shaken for, at the specified PrecipitationResuspensionMixRate, in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
			Category -> "Precipitation"
		},
		PrecipitationNumberOfResuspensionMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the PrecipitationResuspensionMixVolume of the PrecipitationResuspensionBuffer and solid are mixed pipetting up and down in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
			Category -> "Liquid-liquid Extraction"
		},

		(* Solid Phase Extraction *)

		SolidPhaseExtractionStrategy -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Positive | Negative,
			Description -> "Indicates if the target analyte or the impurities are adsorbed on the solid phase extraction column sorbent material while the other material passes through. Positive indicates that analytes of interest are adsorbed onto the extraction column sorbent and impurities pass through. Negative indicates that impurities adsorb onto the extraction column sorbent and target analytes pass through unretained.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionSeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The mechanism by which the mobile phase and solid support separate impurities from target analytes. IonExchange separates compounds based on charge where the sorbent material retains oppositely charged molecules on its surface. Affinity separates compounds based on \"Lock-and-Key\" model between molecules and sorbent materials, where the sorbent material selectively retains molecules of interest. SizeExclusion separates compounds based on hydrodynamic radius, which is proportional to molecular weight, where sorbent material allows smaller molecules to flow into pores while larger molecules bypass the pores and travel around the outside of the resin material. As a result, smaller molecules process though the column more slowly. Compounds elute in order of decreasing molecular weight.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionSorbent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SolidPhaseExtractionFunctionalGroupP,
			Description -> "The chemistry of the solid phase material which interacts with the molecular components of the sample in order to retain either the target analyte(s) or the impurities on the extraction column. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionSorbent adsorbs the target analyte while impurities pass through. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionSorbent adsorbs impurities while the target analyte passes through unretained.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			(*TODO::Relation needs to be updated if SPE widget is updated.*)
			Relation -> Alternatives[
				(* Cartridges *)
				Model[Container, ExtractionCartridge], Object[Container, ExtractionCartridge],
				(* Spin column *)
				Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
				(* Filter Plate *)
				Model[Container, Plate, Filter], Object[Container, Plate, Filter]
			],
			Description -> "The container that is packed with SolidPhaseExtractionSorbent, which forms the stationary phase for extraction of the target analyte.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Centrifuge | AirPressure,
			Description -> "The type of force that is used to flush fluid through the SolidPhaseExtractionSorbent during Loading, Washing, and Eluting steps.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionLoadingTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the sample is maintained during the SolidPhaseExtractionLoadingTemperatureEquilibrationTime, which occurs before loading the sample into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the sample is held at the SolidPhaseExtractionLoadingTemperature before loading the sample into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionLoadingCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush the loading sample through the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionLoadingPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush the loading sample through the SolidPhaseExtractionSorbent in order to bind the target analyte(s) or impurities to the extraction column.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionLoadingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush the loading sample through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to load the sample onto the column.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionWashTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionWashTemperatureEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionWashCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionWashPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SecondarySolidPhaseExtractionWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SecondarySolidPhaseExtractionWashTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SecondarySolidPhaseExtractionWashCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SecondarySolidPhaseExtractionWashPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SecondarySolidPhaseExtractionWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		TertiarySolidPhaseExtractionWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		TertiarySolidPhaseExtractionWashTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		TertiarySolidPhaseExtractionWashCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		TertiarySolidPhaseExtractionWashPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		TertiarySolidPhaseExtractionWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionDigestionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the sample is maintained during the SolidPhaseExtractionDigestionTime, which occurs after adding the SolidPhaseExtractionDigestionEnzyme into the SolidPhaseExtractionCartridge and before adding the SolidPhaseExtractionDigestionWashSolution.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionDigestionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of time for which the sample is held at the SolidPhaseExtractionDigestionTemperature after adding the SolidPhaseExtractionDigestionEnzyme into the SolidPhaseExtractionCartridge and before adding the SolidPhaseExtractionDigestionWashSolution.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionElutionSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionElutionSolutionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the SolidPhaseExtractionElutionSolution is incubated for SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime before being flushed through the SolidPhaseExtractionSorbent to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent. The final temperature of the SolidPhaseExtractionElutionSolution is assumed to equilibrate with the SolidPhaseExtractionElutionSolutionTemperature.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which SolidPhaseExtractionElutionSolution is held at the SolidPhaseExtractionElutionSolutionTemperature before adding the SolidPhaseExtractionElutionSolution into the SolidPhaseExtractionCartridge.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionElutionCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
			Units -> None,
			Description -> "The rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush the SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionElutionPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},
		SolidPhaseExtractionElutionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration for which the SolidPhaseExtractionInstrument applies force to the SolidPhaseExtractionCartridge to flush the SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
			Category -> "Solid Phase Extraction"
		},

		(* Magnetic Bead Separation *)

		MagneticBeadSeparationSelectionStrategy -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MagneticBeadSeparationSelectionStrategyP,
			Description -> "Specified if the target analyte (Positive) or contaminants (Negative) binds to the magnetic beads in order to isolate the target analyte. When the target analyte is bound to the magnetic beads (Positive), they are collected as SamplesOut during the elution step. When contaminants are bound to the magnetic beads (Negative), the target analyte remains in the supernatant and is collected as SamplesOut during the loading step.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Affinity,IonExchange,NormalPhase,ReversePhase],
			Description -> "The mechanism used to selectively isolate or remove targeted components from the samples by magnetic beads. Options include NormalPhase, ReversePhase, IonExchange, Affinity. In NormalPhase mode, magnetic beads are coated with polar molecules (mainly pure silica) and the mobile phase less polar causing the adsorption of polar targeted components. In ReversePhase mode, magnetic beads are coated with hydrophobic groups on the surface to bind targeted components. In IonExchange mode, magnetic beads coated with ion-exchange groups ionically bind charged targeted components. In Affinity mode, magnetic beads are coated with functional groups that can covalently conjugate ligands on targeted components.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationAnalyteAffinityLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "The target molecule in the sample that binds the immobilized ligand on the magnetic beads for affinity separation, applicable if MagneticBeadSeparationMode is set to Affinity. MagneticBeadSeparationAnalyteAffinityLabel is used to help set automatic options such as MagneticBeadAffinityLabel.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadAffinityLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "The molecule immobilized on the magnetic beads that specifically binds the target analyte for affinity separation, applicable if MagneticBeadSeparationMode is set to Affinity. MagneticBeadAffinityLabel is used to help set automatic options such as MagneticBeads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeads -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The superparamagnetic particles with surface coatings to bind target analyte or contaminants. They exhibit magnetic behavior only in the presence of an external magnetic field. The magnetic beads are pulled to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the supernatant.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "Indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each sample, indicates if the magnetic beads should be mixed during the wash prior to equilibration.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationPreWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationPreWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationPreWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationPreWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationPreWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationPreWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationPreWashMixVolume up and down following the addition of MagneticBeadSeparationPreWashSolution to the magnetic beads during each prewash in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationPreWashSolution and magnetic beads is maintained during the MagneticBeadSeparationPreWashMix, which occurs after adding MagneticBeadSeparationPreWashSolution to the magnetic beads and before the MagneticBeadSeparationPreWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		PreWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationPreWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationPreWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationPreWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationPreWashSolution, mixing, magnetization, and aspirating solution prior to equilibration.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationPreWashSolution following the final prewash prior to equilibration.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationPreWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationPreWashSolution following the final prewash prior to equilibration.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are equilibrated to a condition for optimal bead-target binding prior to adding the samples to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution that is added to the magnetic beads in order to equilibrate them to a condition for optimal bead-target binding prior to sample loading.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationEquilibrationSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationEquilibrationSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads are mixed by the selected MagneticBeadSeparationEquilibrationMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationEquilibrationMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationEquilibrationMixVolume up and down following the addition of MagneticBeadSeparationEquilibrationSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is maintained during the MagneticBeadSeparationEquilibrationMix, which occurs after adding MagneticBeadSeparationEquilibrationSolution to the magnetic beads and before the EquilibrationMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		EquilibrationMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationEquilibrationMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationEquilibrationSolution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationEquilibrationSolution and prior to sample loading.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationEquilibrationAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationEquilibrationSolution after aspiration of the used MagneticBeadSeparationEquilibrationSolution and prior to sample loading.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of the sample and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the sample to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined sample and magnetic beads are mixed by the selected MagneticBeadSeparationLoadingMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined sample and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationLoadingMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined sample and magnetic beads is mixed by pipetting the MagneticBeadSeparationLoadingMixVolume up and down following the addition of sample to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined sample and magnetic beads is maintained during the MagneticBeadSeparationLoadingMix, which occurs after adding sample to the magnetic beads and before the LoadingMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		LoadingMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationLoadingMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the sample solution containing components that are not bound to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining sample solution after aspiration of sample solution containing components that are not bound to the magnetic beads and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationLoadingAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining sample after aspiration of sample solution containing components that are not bound to the magnetic beads and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},

		MagneticBeadSeparationWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationWashMixVolume up and down following the addition of MagneticBeadSeparationWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationWashSolution and magnetic beads is maintained during the MagneticBeadSeparationWashMix, which occurs after adding MagneticBeadSeparationWashSolution to the magnetic beads and before the WashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		WashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationWashSolution and prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationWashSolution after aspiration of the used MagneticBeadSeparationWashSolution and prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during secondary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationSecondaryWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSecondaryWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationSecondaryWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationSecondaryWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSecondaryWashMixVolume up and down following the addition of MagneticBeadSeparationSecondaryWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSecondaryWashMix, which occurs after adding MagneticBeadSeparationSecondaryWashSolution to the magnetic beads and before the SecondaryWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		SecondaryWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationSecondaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSecondaryWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationSecondaryWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationSecondaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSecondaryWashSolution and prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSecondaryWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSecondaryWashSolution after aspiration of the used MagneticBeadSeparationSecondaryWashSolution and prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during tertiary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationTertiaryWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationTertiaryWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationTertiaryWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationTertiaryWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationTertiaryWashMixVolume up and down following the addition of MagneticBeadSeparationTertiaryWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationTertiaryWashMix, which occurs after adding MagneticBeadSeparationTertiaryWashSolution to the magnetic beads and before the TertiaryWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		TertiaryWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationTertiaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationTertiaryWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationTertiaryWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationTertiaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationTertiaryWashSolution and prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationTertiaryWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationTertiaryWashSolution after aspiration of the used MagneticBeadSeparationTertiaryWashSolution and prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during quaternary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationQuaternaryWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationQuaternaryWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationQuaternaryWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationQuaternaryWashMixVolume up and down following the addition of MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationQuaternaryWashMix, which occurs after adding MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads and before the QuaternaryWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		QuaternaryWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationQuaternaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationQuaternaryWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationQuaternaryWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationQuaternaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationQuaternaryWashSolution and prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuaternaryWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationQuaternaryWashSolution after aspiration of the used MagneticBeadSeparationQuaternaryWashSolution and prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during quinary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationQuinaryWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationQuinaryWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationQuinaryWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationQuinaryWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationQuinaryWashMixVolume up and down following the addition of MagneticBeadSeparationQuinaryWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the sample is maintained during the MagneticBeadSeparationQuinaryWashMix, which occurs after adding MagneticBeadSeparationQuinaryWashSolution to the magnetic beads and before the QuinaryWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		QuinaryWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationQuinaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationQuinaryWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationQuinaryWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationQuinaryWashSolution, mixing, magnetization, and aspirating solution prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationQuinaryWashSolution and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationQuinaryWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationQuinaryWashSolution after aspiration of the used MagneticBeadSeparationQuinaryWashSolution and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during Senary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationSenaryWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSenaryWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationSenaryWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationSenaryWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSenaryWashMixVolume up and down following the addition of MagneticBeadSeparationSenaryWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the sample is maintained during the MagneticBeadSeparationSenaryWashMix, which occurs after adding MagneticBeadSeparationSenaryWashSolution to the magnetic beads and before the SenaryWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		SenaryWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationSenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSenaryWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationSenaryWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationSenaryWashSolution, mixing, magnetization, and aspirating solution prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSenaryWashSolution and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSenaryWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSenaryWashSolution after aspiration of the used MagneticBeadSeparationSenaryWashSolution and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWash -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads during Septenary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationSeptenaryWashSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationSeptenaryWashMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationSeptenaryWashMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSeptenaryWashMixVolume up and down following the addition of MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the sample is maintained during the MagneticBeadSeparationSeptenaryWashMix, which occurs after adding MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads and before the SeptenaryWashMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		SeptenaryWashMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationSeptenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSeptenaryWashSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationSeptenaryWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationSeptenaryWashSolution, mixing, magnetization, and aspirating solution prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashAirDry -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSeptenaryWashSolution and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationSeptenaryWashAirDryTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSeptenaryWashSolution after aspiration of the used MagneticBeadSeparationSeptenaryWashSolution and prior to elution.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElution -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the magnetic beads are rinsed in a different buffer condition in order to release the components bound to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElutionSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solution used to rinse the magnetic beads, providing a buffer condition in order to release the components bound to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElutionMix -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationElutionSolution and the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElutionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette,
			Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationElutionSolution to the magnetic beads.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElutionMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration during which the combined MagneticBeadSeparationElutionSolution and magnetic beads is mixed by the selected MagneticBeadSeparationElutionMixType.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElutionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationElutionSolution and magnetic beads is shaken in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationElutionMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> RangeP[1, 50, 1],
			Units -> None,
			Description -> "The number of times that the combined MagneticBeadSeparationElutionSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationElutionMixVolume up and down following the addition of MagneticBeadSeparationElutionSolution to the magnetic beads in order to fully mix.",
			Category -> "Magnetic Bead Separation"
		},
		MagneticBeadSeparationElutionMixTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationElutionSolution and magnetic beads is maintained during the MagneticBeadSeparationElutionMix, which occurs after adding MagneticBeadSeparationElutionSolution to the magnetic beads and before the ElutionMagnetizationTime.",
			Category -> "Magnetic Bead Separation"
		},
		ElutionMagnetizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Second, 72 Hour],
			Units -> Second,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationElutionMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationElutionSolution.",
			Category -> "Magnetic Bead Separation"
		},
		NumberOfMagneticBeadSeparationElutions -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Units -> None,
			Description -> "The number of times the bound components on the magnetic beads are eluted by adding MagneticBeadSeparationElutionSolution, mixing, magnetization, and aspiration.",
			Category -> "Magnetic Bead Separation"
		}
	}
}];