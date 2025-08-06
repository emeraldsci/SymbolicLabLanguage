(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, StockSolution], {
	Description->"A protocol describing a set of preparations of component mixtures, specified by formulas, that will be used in other experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Method Information --- *)
		MaxNumberOfOverfillingRepreparations -> {
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The maximum number of times the StockSolution protocol can be repeated in the event of target volume overfilling in the FillToVolume step of the stock solution preparation. When a repreparation is triggered, the same inputs and options are used.",
			Category->"General"
		},
		OverfillingRepreparations -> {
			Format->Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,StockSolution]],
			Description->"The repeat StockSolution protocol that is automatically enqueued when target volume overfilling occurs during the FillToVolume step of the stock solution preparation. The new protocol uses the same inputs and options as the original.",
			Category->"General"
		},
		StockSolutionModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The models of the stock solutions for which this protocol specifies preparation instructions.",
			Category -> "General",
			Abstract -> True
		},
		VolumeMeasurementSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stock solutions that are prepared for the first time and have their volume measured after component combination and mixing to calculate the actual volume of the mixture while taking into account density changes and/or solid dissolution.",
			Category -> "General"
		},
		FixedAmountsComponents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Any stock solution components that come in pre-measured amounts.",
			Category -> "General",
			Developer -> True
		},
		SpecifiedSamples -> {
			Format -> Multiple,
			Class -> {
				StockSolutionModel -> Link,
				ModelIndex -> Integer,
				Amount -> VariableUnit,
				Sample -> Link
			},
			Pattern :> {
				StockSolutionModel -> _Link,
				ModelIndex -> GreaterP[0, 1],
				Amount -> GreaterP[0 Unit, 1 Unit] | GreaterP[0 Gram] | GreaterP[0 Milliliter],
				Sample -> _Link
			},
			Relation -> {
				StockSolutionModel -> Model[Sample],
				ModelIndex -> Null,
				Amount -> Null,
				Sample -> Object[Sample]
			},
			Description -> "This field is only populated if a sample was specified rather than a model in a stock solution's formula.  The model stock solution for which a specific sample was specified for its creation, the index of the model in the StockSolutionModels field, the amount of the specified sample in the model, and the sample itself.",
			Category -> "General",
			Developer -> True
		},
		PreparatoryImaging -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stock solutions that should have their images recorded after component combination and mixing.",
			Category -> "General"
		},
		FinalImaging -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description ->  "The stock solutions that should have their images recorded after the fully prepared stock solution has been transferred into its final container.",
			Category -> "General"
		},
		(* --- Sample Preparation --- *)
		RequestedVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			IndexMatching -> StockSolutionModels,
			Description -> "For each member of StockSolutionModels, the requested target volume of stock solution prepared by this protocol, not including any excess volume that may be prepared to ensure that component tranfers are in a workable range for accurate dosing.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		PreparatorySamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			IndexMatching -> StockSolutionModels,
			Description -> "For each member of StockSolutionModels, the sample initially prepared according to the model's formula prior to any mixing, pH titration, and/or filtration steps.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		PreparatoryVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Milli,
			IndexMatching -> PreparatorySamples,
			Description -> "For each member of PreparatorySamples, the total volume of stock solution prepared, including the requested volume plus any excess volume required to ensure that the component transfers are in a workable range for accurate dosing.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		PreparatoryContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> PreparatorySamples,
			Description -> "For each member of PreparatorySamples, the container in which the stock solution components are initially combined to make the preparatory volume.",
			Category -> "Sample Preparation"
		},
		Primitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "The sample preparation primitives that should be used to create the stock solution.",
			Category -> "Sample Preparation"
		},
		PreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, ManualSamplePreparation],
			Description -> "The sample preparation protocol that was used to create the stock solution.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		UnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ManualSamplePreparationP,
			Description -> "The sample preparation UnitOperations that should be used to create the stock solution.",
			Category -> "Sample Preparation"
		},
		FillToVolumePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|ManualSamplePreparationP,
			Description -> "For each member of StockSolutionModels, fill to volume primitives that will be performed to bring each stock solution up to a specified volume.",
			IndexMatching -> StockSolutionModels,
			Category -> "Sample Preparation"
		},
		FillToVolumeDefinePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|ManualSamplePreparationP,
			Description -> "For each member of FillToVolumePrimitives, the define primitive that specifies what the destination actually is.",
			IndexMatching -> FillToVolumePrimitives,
			Developer -> True,
			Category -> "Sample Preparation"
		},
		ContainerPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|ManualSamplePreparationP,
			Description -> "The set of instructions specifying the transfers of the final volumes of the stock solutions into their final containers.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		ContainerTransferSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The stock solution samples that are transfered into their final containers.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		GellingAgents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The types and amounts of substances added to solidify the prepared media.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		HeatSensitiveReagents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Components of this stock solution that are heat sensitive and should be added after autoclave.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		HeatSensitiveReagentAdditionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|ManualSamplePreparationP,
			Description -> "For each member of StockSolutionModels, transfer primitives for heat sensitive reagents (that must be added after autoclave).",
			IndexMatching -> StockSolutionModels,
			Category -> "Sample Preparation"
		},
		MediaPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MediaPhaseP,
			Description -> "The physical state of the prepared media at ambient temperature and pressure.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		MediaToPlate -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The media samples which will be plated after their preparation.",
			Category -> "General"
		},

		(* --- Fill To Volume --- *)
		FillToVolumeSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The stock solutions which are prepared by using a series of successively smaller solvent transfers until the target volume is reached.",
			Category -> "Fill to Volume"
		},
		FillToVolumeSolvents->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample],Object[Sample]],
			IndexMatching -> FillToVolumeSamples,
			Description -> "For each member of FillToVolumeSamples, the solvent used to dilute the components up to the requested total volume.",
			Category -> "Fill to Volume"
		},
		FillToVolumeMethods->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FillToVolumeMethodP,
			IndexMatching -> FillToVolumeSamples,
			Description -> "For each member of FillToVolumeSamples, the method by which to add the Solvent to the bring the stock solution up to the TotalVolume.",
			Category -> "Fill to Volume"
		},
		FillToVolumeProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The protocols containing method information to add the Solvent to bring the stock solution up to the TotalVolume.",
			Category -> "Filtration",
			Developer -> True
		},
		DensityScouts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The stock solution models of which a small volume will be prepared in a volumetric flask and then have their densities measured.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		DensityScoutProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The protocol object used to prepare a small volume of a stock solution to have its density measured.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		TargetVolumeToleranceAchieved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> FillToVolumeSamples,
			Description -> "For each member of FillToVolumeSamples, indicates if the final measured volume of the sample after FillToVolume exceeds the specified TotalVolume + Tolerance in the FillToVolume protocol.",
			Category -> "Fill to Volume"
		},

		(* --- Mixing --- *)
		MixedSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stock solution samples for which mixing is performed following component combination and filling to volume with solvent.",
			Category -> "Mixing"
		},
		PostAutoclaveMixedSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stock solution samples for which mixing is performed following autoclave and addition of heat sensitive reagents.",
			Category -> "Mixing"
		},
		MixProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, Incubate],
				Object[Protocol, ManualSamplePreparation]
			],
			Description -> "The subprotocol which mixing is performed.",
			Category -> "Mixing"
		},
		MixParameters -> {
			Format -> Multiple,
			Class -> {
				Type -> Expression,
				MixUntilDissolved -> Boolean,
				Mixer -> Link,
				Time -> Real,
				MaxTime -> Real,
				Rate -> Real,
				NumberOfMixes -> Integer,
				MaxNumberOfMixes -> Integer,
				PipettingVolume -> Real,
				Temperature -> Real,
				AnnealingTime -> Real,
				ThawInstrument -> Link,
				ThawTemperature -> Real,
				ThawTime -> Real
			},
			Pattern :> {
				Type -> MixTypeP,
				MixUntilDissolved -> BooleanP,
				Mixer -> _Link,
				Time -> GreaterP[0*Minute],
				MaxTime -> GreaterP[0*Minute],
				Rate -> GreaterP[0*RPM],
				NumberOfMixes -> GreaterEqualP[0],
				MaxNumberOfMixes -> GreaterEqualP[0],
				PipettingVolume -> GreaterP[0 Milliliter],
				Temperature -> GreaterP[0 Kelvin],
				AnnealingTime -> GreaterEqualP[0 Second],
				ThawInstrument -> _Link,
				ThawTemperature -> GreaterP[0 Kelvin],
				ThawTime -> GreaterP[0 Second]
			},
			Units -> {
				Type -> None,
				MixUntilDissolved -> None,
				Mixer -> None,
				Time -> Minute,
				MaxTime -> Minute,
				Rate -> RPM,
				NumberOfMixes -> None,
				MaxNumberOfMixes ->None,
				PipettingVolume -> Milliliter,
				Temperature -> Celsius,
				AnnealingTime -> Minute,
				ThawInstrument -> None,
				ThawTemperature -> Celsius,
				ThawTime -> Minute
			},
			Relation -> {
				Type -> Null,
				MixUntilDissolved -> Null,
				Mixer -> Alternatives[Object[Instrument], Model[Instrument]],
				Time -> Null,
				MaxTime -> Null,
				Rate -> Null,
				NumberOfMixes ->Null,
				MaxNumberOfMixes ->Null,
				PipettingVolume -> Null,
				Temperature -> Null,
				AnnealingTime -> Null,
				ThawInstrument -> Alternatives[Object[Instrument], Model[Instrument]],
				ThawTemperature -> Null,
				ThawTime -> Null
			},
			IndexMatching -> MixedSolutions,
			Description -> "For each member of MixedSolutions, parameters describing how the stock solution should be mixed following component combination and filling to volume with solvent.",
			Category -> "Mixing"
		},
		PostAutoclaveMixParameters -> {
			Format -> Multiple,
			Class -> {
				Type -> Expression,
				MixUntilDissolved -> Boolean,
				Mixer -> Link,
				Time -> Real,
				MaxTime -> Real,
				Rate -> Real,
				NumberOfMixes -> Integer,
				MaxNumberOfMixes -> Integer,
				PipettingVolume -> Real,
				Temperature -> Real,
				AnnealingTime -> Real,
				ThawInstrument -> Link,
				ThawTemperature -> Real,
				ThawTime -> Real
			},
			Pattern :> {
				Type -> MixTypeP,
				MixUntilDissolved -> BooleanP,
				Mixer -> _Link,
				Time -> GreaterP[0*Minute],
				MaxTime -> GreaterP[0*Minute],
				Rate -> GreaterP[0*RPM],
				NumberOfMixes -> GreaterEqualP[0],
				MaxNumberOfMixes -> GreaterEqualP[0],
				PipettingVolume -> GreaterP[0 Milliliter],
				Temperature -> GreaterP[0 Kelvin],
				AnnealingTime -> GreaterEqualP[0 Second],
				ThawInstrument -> _Link,
				ThawTemperature -> GreaterP[0 Kelvin],
				ThawTime -> GreaterP[0 Second]
			},
			Units -> {
				Type -> None,
				MixUntilDissolved -> None,
				Mixer -> None,
				Time -> Minute,
				MaxTime -> Minute,
				Rate -> RPM,
				NumberOfMixes -> None,
				MaxNumberOfMixes ->None,
				PipettingVolume -> Milliliter,
				Temperature -> Celsius,
				AnnealingTime -> Minute,
				ThawInstrument -> None,
				ThawTemperature -> Celsius,
				ThawTime -> Minute
			},
			Relation -> {
				Type -> Null,
				MixUntilDissolved -> Null,
				Mixer -> Alternatives[Object[Instrument], Model[Instrument]],
				Time -> Null,
				MaxTime -> Null,
				Rate -> Null,
				NumberOfMixes ->Null,
				MaxNumberOfMixes ->Null,
				PipettingVolume -> Null,
				Temperature -> Null,
				AnnealingTime -> Null,
				ThawInstrument -> Alternatives[Object[Instrument], Model[Instrument]],
				ThawTemperature -> Null,
				ThawTime -> Null
			},
			IndexMatching -> PostAutoclaveMixedSolutions,
			Description -> "For each member of PostAutoclaveMixedSolutions, parameters describing how the stock solution should be mixed following autoclave and addition of heat-sensitive reagents.",
			Category -> "Mixing"
		},

		(* --- pH Titration --- *)
		pHingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The stock solution samples that are titrated to a specified pH following component combination, filling to volume with solvent, and mixing.",
			Category -> "pH Titration"
		},
		pHingSampleModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample]
			],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the target StockSolutionModel which is applied to this sample if pH adjustment is succseeful.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHingSampleContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the container in which the stock solution components are initially combined to make the preparatory volume, and if aliquoted, transferred back to after pHing.",
			Category -> "pH Titration"
		},
		NominalpHs->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the pH the stock solution is intended to have following component combination, filling to volume with solvent, and mixing.",
			Category -> "pH Titration"
		},
		MinpHs->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the minimum pH the stock solution has following component combination, filling to volume with solvent, and mixing.",
			Category -> "pH Titration"
		},
		MaxpHs->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the maximum pH the stock solution has following component combination, filling to volume with solvent, and mixing.",
			Category -> "pH Titration"
		},
		pHTolerances -> { (*Legacy*)
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the acceptable tolerance range for a measurement of the NominalpH.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHingAcids -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the acid used to adjust the pH of the sample downwards following component combination, filling to volume with solvent, and mixing.",
			Category -> "pH Titration"
		},
		pHingBases -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the base used to adjust the pH of the sample upwards following component combination, filling to volume with solvent, and mixing.",
			Category -> "pH Titration"
		},
		pHIncrements -> {(*Legacy*)
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the volume added by each successive attempt to adjust the pH until it is in the range of the minimum and maximum pHs.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHMeters -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[
				Model[Instrument,pHMeter],
				Object[Instrument,pHMeter]
			],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the pHMeter used to measure the sample's pH during adjustment.",
			Category -> "pH Titration"
		},
		pHMeasurements -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasurepH],
			Description -> "The protocols containing method information for measuring the pH of the stock solutions whose pHs are being adjusted.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHingPipettes -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette], Object[Instrument, Pipette]],
			Description -> "The pipettes used to transfer acid/base into the samples that are being pH-titrated.",
			Category -> "pH Titration",
			Developer -> True
		},
		AcidPipetteTips -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the serological pipette used to transfer acid into the sample being pH-titrated.",
			Category -> "pH Titration",
			Developer -> True
		},
		BasePipetteTips -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the serological pipette used to transfer base into the sample being pH-titrated.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHingMixer -> {(*Legacy*)
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, OverheadStirrer],Object[Instrument, OverheadStirrer]],
			Description -> "The mixer used to stir the solution whose pH is being adjusted.",
			Category -> "pH Titration"
		},
		pHingMixerImpellers -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, the impeller used in the mixer responsible for stirring the solution in between acid/base additions.",
			Category -> "pH Titration",
			Developer -> True
		},
		AllpHingPipettes -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette], Object[Instrument, Pipette]],
			Description -> "All the pipettes used to transfer acid/base into the samples that are being pH-titrated.",
			Category -> "pH Titration",
			Developer -> True
		},
		AllpHingTips -> {(*Legacy*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Tips],
				Object[Item,Tips]
			],
			Description -> "All the pipette tips used to transfer acid and/or base into the sample being pH-titrated.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHAdjustment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AdjustpH],
			Description -> "The protocol containing method information for adjusting the pH of the stock solutions.",
			Category -> "pH Titration",
			Developer -> True
		},
		pHsAchieved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> pHingSamples,
			Description -> "For each member of pHingSamples, indicates if the desired pHs were achieved without exceeding the volume or iteration limits.",
			Category -> "pH Titration",
			Developer -> True
		},
		(* --- Filtration --- *)
		FiltrationSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stock solution samples for which filtration is performed following component combination, filling to volume with solvent, mixing, and pH titration.",
			Category -> "Filtration"
		},
		FiltrationParameters -> {
			Format -> Multiple,
			Class -> {
				Type -> Expression,
				Instrument -> Link,
				Filter -> Link,
				MembraneMaterial -> Expression,
				PoreSize -> Real,
				Syringe -> Link,
				FilterHousing -> Link
			},
			Pattern :> {
				Type -> FiltrationTypeP,
				Instrument -> _Link,
				Filter -> _Link,
				MembraneMaterial -> FilterMembraneMaterialP,
				PoreSize -> FilterSizeP,
				Syringe -> _Link,
				FilterHousing -> _Link
			},
			Units -> {
				Type -> None,
				Instrument -> None,
				Filter -> None,
				MembraneMaterial -> None,
				PoreSize -> Micrometer,
				Syringe -> None,
				FilterHousing -> None
			},
			Relation -> {
				Type -> Null,
				Instrument -> Alternatives[Object[Instrument],Model[Instrument],Object[Container,Syringe]],
				Filter -> Alternatives[Object[Container], Model[Container],Object[Sample], Model[Sample], Object[Item], Model[Item]], (* TODO: Remove Object[Sample] here after item migration *)
				MembraneMaterial -> Null,
				PoreSize -> Null,
				Syringe -> Alternatives[Object[Container],Model[Container]],
				FilterHousing -> Alternatives[Object[Instrument,FilterHousing],Model[Instrument,FilterHousing]]
			},
			IndexMatching -> FiltrationSamples,
			Description -> "For each member of FiltrationSamples, parameters describing how the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and pH titration.",
			Category -> "Filtration"
		},
		FilterContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			IndexMatching -> FiltrationSamples,
			Description -> "For each member of FiltrationSamples, the container into which the filtered solution is filtered following component combination, filling to volume with solvent, mixing, and pH titration.",
			Category -> "Filtration",
			Developer -> True
		},
		FilterProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The protocols containing method information for removal of particulates of a certain size from the FiltrationSamples.",
			Category -> "Filtration",
			Developer -> True
		},
		PreFiltrationImage -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the stock solutions being prepared are imaged before filtration.",
			Category -> "Sample Preparation",
			Developer -> True
		},

		(* --- Autoclaving --- *)
		AutoclaveSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The stock solution samples that are autoclaved at the end of the stock solution protocol.",
			Category -> "Autoclaving"
		},
		AutoclavePrograms -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AutoclaveProgramP,
			Units -> None,
			Relation -> Null,
			IndexMatching -> AutoclaveSamples,
			Description -> "For each member of AutoclaveSamples, the type of autoclave cycle to run.",
			Category -> "Autoclaving"
		},
		(* Note: We only need this because ExperimentAutoclave will not batch for us. *)
		AutoclaveBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Relation -> Null,
			Description -> "The length of each of our autoclave batches.",
			Category -> "Autoclaving",
			Developer->True
		},
		AutoclaveBooleans -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Units -> None,
			Relation -> Null,
			Description -> "The length of each of our autoclave batches.",
			Category -> "Autoclaving",
			Developer->True
		},
		AutoclaveProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,Autoclave],
			Description -> "The protocols containing method information for sterilizing samples throught heat.",
			Category -> "Autoclaving",
			Developer -> True
		},
		StirBar -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,StirBar],
				Object[Part,StirBar]
			],
			Description -> "For each member of AutoclaveSamples, indicates the stir bar inserted into the container to mix the sample after autoclaving.",
			IndexMatching -> AutoclaveSamples,
			Category -> "Autoclaving",
			Developer -> True
		},

		(* --- Experimental Results --- *)
		FullyDissolved ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MultipleChoiceAnswerP,
			IndexMatching -> SamplesOut,
			Description -> "For each member of SamplesOut, indicates if all components in the solution appear fully dissolved by visual inspection following component combination, filling to volume with solvent, mixing, pH titration, and filtration.",
			Category -> "Experimental Results",
			Abstract->True
		},

		(* --- Resources --- *)
		OrdersFulfilled -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction, Order][Fulfillment],
			IndexMatching -> StockSolutionModels,
			Description -> "For each member of StockSolutionModels, the automatic inventory order fulfilled by preparation of a sample of this model.",
			Category -> "Resources"
		},
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][Preparation],
			IndexMatching -> StockSolutionModels,
			Description -> "For each member of StockSolutionModels, the resource in the parent protocol that is fulfilled by preparing a sample of the stock solution model.",
			Category -> "Resources",
			Developer -> True
		},
		MeniscusImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			IndexMatching -> PreparatorySamples,
			Description -> "For each member of PreparatorySamples, the cloud file that stores the images of the filled volumetric flasks, if the sample is not fulfilled by Volumetric FillToVolume method, the corresponding value will be Null.",
			Category -> "Sample Post-Processing"
		}
	}
}];
