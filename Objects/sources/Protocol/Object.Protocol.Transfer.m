(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Transfer], {
	Description->"A protocol for moving liquid or solids between containers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Destinations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample]|Object[Container]|Model[Container]|Object[Item],
			Description -> "For each member of SamplesIn, the destinations samples or containers for each of our transfers.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		Amounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit],
			Description -> "For each member of SamplesIn, the amount of that sample that is transferred to the corresponding SamplesOut. An Amount of Null indicates that all of the source is transferred to the destination.",
			Category -> "General",
			Abstract -> True,
			IndexMatching -> SamplesIn
		},

		SourceWells->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, the position in the source container from which our sample is aspirated.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},

		TransferEnvironments->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, BiosafetyCabinet],
				Model[Instrument, FumeHood],
				Model[Instrument, GloveBox],
				Model[Container, Bench],
				Model[Container, Enclosure],
				Model[Instrument, HandlingStation],
				Object[Instrument, BiosafetyCabinet],
				Object[Instrument, FumeHood],
				Object[Instrument, GloveBox],
				Object[Container, Bench],
				Object[Container, Enclosure],
				Object[Instrument, HandlingStation]
			],
			Description -> "The environment in which the transfer will be performed (Biosafety Cabinet, Fume Hood, Glove Box, or Benchtop Handling Station). Containers involved in the transfer will first be moved into the TransferEnvironment (with covers on), uncovered inside of the TransferEnvironment, then covered after the Transfer has finished -- before they're moved back onto the operator cart. Consult the SterileTechnique/RNaseFreeTechnique option when using a BSC.",
			Category -> "General",
			Abstract -> True
		},
		Instruments->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Syringe],
				Model[Container,GraduatedCylinder],
				Model[Instrument,Pipette],
				Model[Instrument, Aspirator],
				Model[Item, Spatula],
				Model[Item, Tweezer],
				Model[Item, TransferTube],
				Model[Item, ChippingHammer],
				Model[Item, Scissors],

				Object[Container,Syringe],
				Object[Container,GraduatedCylinder],
				Object[Instrument,Pipette],
				Object[Instrument, Aspirator],
				Object[Item, Spatula],
				Object[Item, Tweezer],
				Object[Item, TransferTube],
				Object[Item, ChippingHammer],
				Object[Item, Scissors]
			],
			Description -> "The instruments used to transfer the sample from the source container (or from the intermediate container if IntermediateDecant->True) to the destination container.",
			Category -> "General",
			Abstract -> True
		},
		SterileTechnique->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if 70% ethanol is to be sprayed on all surfaces/containers used during the transfer. This also indicates if sterile instrument(s) and sterile transfer environment(s) are used for the transfer. Please consult the ExperimentTransfer documentation for a full diagram of SterileTechnique that is employed by operators.",
			Category -> "Transfer Technique"
		},
		RNaseFreeTechnique->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that RNase free technique was followed when performing the transfer (spraying RNase away on surfaces/containers, using RNaseFree tips, and using sterile instruments/transfer environments).",
			Category -> "Transfer Technique"
		},
		Balances->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Balance],
				Object[Instrument,Balance]
			],
			Description -> "The balance used to weigh the sample that is being transferred, if the transfer amount is specified by weight.",
			Category->"Instrument Specifications"
		},
		TabletCrushers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, TabletCrusher],
				Object[Item, TabletCrusher]
			],
			Description -> "The pill crushers to crush the tablets, if the transfer amount is a specific mass and the sample is a tablet.",
			Category->"Instrument Specifications"
		},
		TabletCrusherBags->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, TabletCrusherBag],
				Object[Item, TabletCrusherBag]
			],
			Description -> "The pill crusher bags that will contain the crushed itemized samples after it has been in the pill crusher.",
			Category->"Instrument Specifications"
		},
		IncludeSachetPouches -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicate if the pouches are also transferred to the destination along with the filler. If set to False, the pouches are directly discarded after emptied.",
			Category->"Instrument Specifications",
			IndexMatching -> SamplesIn
		},
		SachetIntermediateContainers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeighBoat],
				Object[Item, WeighBoat]
			],
			Description -> "For each member of SamplesIn, the container that the filler is emptied into after cutting open the source sachet in order to transfer to the destination, if not transferring gravimetrically.",
			Category->"Instrument Specifications",
			IndexMatching -> SamplesIn
		},
		Tips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips],
				Model[Item, Consumable],
				Object[Item, Consumable]
			],
			Description -> "The pipette tips used to aspirate and dispense the requested volume of the samples.",
			Category->"Instrument Specifications"
		},
		MultichannelTransfer->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sample is aspirated/dispensed along with multiple samples at the same time, using a multichannel pipette.",
			Category->"Instrument Specifications"
		},
		TipTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of Tips, the type of pipette tips used to aspirate and dispense the volume during the transfer.",
			Category->"Instrument Specifications",
			IndexMatching -> Tips
		},
		TipMaterials->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "For each member of Tips, the material of the pipette tips used to aspirate and dispense the volume during the transfer.",
			Category->"Instrument Specifications",
			IndexMatching -> Tips
		},
		ReversePipetting->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source sample is aspirated past the first stop of the pipette to reduce the chance of bubble formation when dispensing into the destination position.",
			Category->"Transfer Technique"
		},
		Supernatant->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates that only top most layer of the source sample is aspirated when performing the transfer.",
			Category->"Transfer Technique"
		},
		AspirationLayers->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The layer (counting from the top) of the source sample that is aspirated from when performing the transfer.",
			Category->"Transfer Technique"
		},
		DestinationLayers->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The layer (counting from the top) of the destination sample that is dispensed into when performing the transfer.",
			Category->"Transfer Technique"
		},

		Needles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needles used to aspirate and dispense the requested volume.",
			Category->"Instrument Specifications"
		},
		Funnels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "The funnels that is used to guide the source sample into the destination container when pouring or using a graduated cylinder.",
			Category->"Instrument Specifications"
		},
		WeighingContainers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container],
				Model[Item],
				Object[Item]
			],
			Description -> "The containers that will be placed on the Balance and used to weigh out the specified amount of the source that will be transferred to the destination.",
			Category->"Instrument Specifications"
		},
		Magnetization->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if each of the source samples is put in a magnetized rack to separate out any magnetic components before the transfer is performed.",
			Category->"Transfer Technique"
		},
		MagnetizationRack->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Rack],
				Object[Container,Rack]
			],
			Description -> "The magnetized rack that the source/intermediate container is placed in before the transfer is performed.",
			Category->"Transfer Technique"
		},
		MagnetizationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The time that the source sample was left on the magnetic rack until the magnetic components are settled at the side of the container.",
			Category->"Transfer Technique"
		},
		MaxMagnetizationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The maximum time that the source sample was left on the magnetic rack until the magnetic components are settled at the side of the container.",
			Category->"Transfer Technique"
		},
		Tolerances->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "The allowed tolerance of the weighed source sample from the specified amount requested to be transferred.",
			Category->"Instrument Specifications"
		},
		HandPumps->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, HandPump],
				Object[Part, HandPump]
			],
			Description -> "The hand pump used to get liquid out of the source container.",
			Category->"Instrument Specifications"
		},
		HandPumpAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,HandPumpAdapter],
				Object[Part,HandPumpAdapter]
			],
			Description -> "The part used to connect the handpump to the solvent container in order to transfer liquid out.",
			Category -> "General"
		},
		QuantitativeTransfer->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if additional QuantitativeTransferWashSolution is used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		QuantitativeTransferWashSolutions->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that is used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		QuantitativeTransferWashVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Milliliter,
			Description -> "The volume of the solution that is used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		QuantitativeTransferWashInstruments->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "The pipette that is used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		QuantitativeTransferWashTips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "The tips that is used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		NumberOfQuantitativeTransferWashes->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Indicates the number of washes of the weight boat with QuantitativeTransferWashSolution that will occur, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category->"Quantitative Transfers"
		},
		UnsealHermeticSources->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the source's hermetic container was unsealed before sample is transferred out of it.",
			Category->"Hermetic Transfers",
			IndexMatching -> SamplesIn
		},
		UnsealHermeticDestinations->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesOut, indicates if the destination's hermetic container was unsealed before sample is transferred out of it.",
			Category->"Hermetic Transfers",
			IndexMatching -> SamplesOut
		},
		BackfillNeedles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle used to backfill the source's hermetic container with BackfillGas.",
			Category->"Hermetic Transfers"
		},
		BackfillGas->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				Nitrogen,
				Argon
			],
			Description -> "The inert gas that is used equalize the pressure in the source's hermetic container while the transfer out of the source's container occurs.",
			Category->"Hermetic Transfers"
		},
		VentingNeedles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle that is used equalize the pressure in the destination's hermetic container while the transfer into the destination's container occurs.",
			Category->"Hermetic Transfers"
		},
		TipRinse->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the Tips are first be rinsed with a TipRinseSolution before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		TipRinseSolutions->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that the Tips was rinsed before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		TipRinseVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Milliliter,
			Description -> "The volume of the solution that the Tips was rinsed before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		NumberOfTipRinses->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of times that the Tips was rinsed before they are used to aspirate from the source sample.",
			Category->"Tip Rinsing"
		},
		SlurryTransfer->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source sample should be mixed via pipette until it becomes homogenous, up to MaxNumberOfAspirationMixes times.",
			Category->"Mixing"
		},
		AspirationMix->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing occurs during aspiration from the source sample.",
			Category->"Mixing"
		},
		AspirationMixTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Swirl|Pipette|Tilt,
			Description -> "For each member of AspirationMix, the type of mixing that occurs during aspiration.",
			Category->"Mixing",
			IndexMatching -> AspirationMix
		},
		AspirationMixVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
			Category->"Mixing"
		},
		NumberOfAspirationMixes->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of AspirationMix, the number of times that the source sample was mixed during aspiration.",
			Category->"Mixing",
			IndexMatching -> AspirationMix
		},
		MaxNumberOfAspirationMixes->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of AspirationMix, the maximum number of times that the source sample was mixed during aspiration in order to achieve a homogeneous solution before the transfer.",
			Category -> "General",
			IndexMatching -> AspirationMix
		},
		DispenseMix->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if mixing occurs after the sample is dispensed into the destination container.",
			Category->"Mixing"
		},
		DispenseMixTypes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Swirl|Pipette|Tilt,
			Description -> "For each member of DispenseMix, the type of mixing that occurs after the sample is dispensed into the destination container.",
			Category->"Mixing",
			IndexMatching -> DispenseMix
		},
		DispenseMixVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			Category->"Mixing"
		},
		NumberOfDispenseMixes->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of DispenseMix, the number of times that the source sample was mixed after the sample is dispensed into the destination container.",
			Category->"Mixing",
			IndexMatching -> DispenseMix
		},
		IntermediateDecant->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source will need to be decanted into an intermediate container in order for the precise amount requested to be transferred via pipette. Intermediate decants are necessary if the container geometry prevents the Instrument from reaching the liquid level of the sample in the container (plus the delta of volume that is to be transferred). The container geometry is automatically calculated from the inverse of the volume calibration function when the container is parameterized upon receiving.",
			Category->"Intermediate Decanting"
		},
		IntermediateContainers->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container that the source is decanted into in order to make the final transfer via pipette into the final destination.",
			Category->"Intermediate Decanting",
			Migration->SplitField
		},
		IntermediateFunnels->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "The funnel that is used to guide the source sample into the intermediate container when pouring.",
			Category->"Instrument Specifications"
		},

		SourceTemperatures->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature at which the source was at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
			Category -> "Temperature Equilibration",
			Migration->SplitField
		},
		SourceEquilibrationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The duration of time for which the samples is heated/cooled to the target SourceTemperature.",
			Category -> "Temperature Equilibration"
		},
		MaxSourceEquilibrationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The maximum duration of time for which the samples is heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime.",
			Category -> "Temperature Equilibration"
		},
		SourceEquilibrationCheck->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "The method by which to verify the temperature of the source before the transfer is performed.",
			Category -> "Temperature Equilibration"
		},
		DestinationTemperatures->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature at which the source was at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
			Category -> "Temperature Equilibration",
			Migration->SplitField
		},
		DestinationEquilibrationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The duration of time for which the samples is heated/cooled to the target SourceTemperature.",
			Category -> "Temperature Equilibration"
		},
		MaxDestinationEquilibrationTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "The maximum duration of time for which the samples is heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime.",
			Category -> "Temperature Equilibration"
		},
		DestinationEquilibrationCheck->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "The method by which to verify the temperature of the source before the transfer is performed.",
			Category -> "Temperature Equilibration"
		},
		SourceIncubationDevice ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "The portable heater/cooler used to maintain the Sources at the SourceTemperature in this Transfer.",
			Category -> "Temperature Equilibration"
		},
		DestinationIncubationDevice ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "The portable heater/cooler used to maintain the Destinations at the DestinationTemperatures in this Transfer.",
			Category -> "Temperature Equilibration"
		},
		CoolingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "Specifies the minimum length of time that should elapse after the transfer before the sample is removed from the TransferEnvironment.",
			Category -> "Temperature Equilibration",
			Developer -> True
		},
		SolidificationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
			Category -> "Temperature Equilibration",
			Developer -> True
		},
		SolidificationWaitTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Minute,
			Description -> "The duration of time to wait for all plate media to solidify before tearing down the transfer environment.",
			Category -> "Temperature Equilibration",
			Developer -> True
		},
		FlameDestination -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the destination should be briefly heated with a flame to remove any bubbles after transfer before it solidifies.",
			Category -> "Temperature Equilibration",
			Developer -> True
		},
		FlameSource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,Lighter],
			Description -> "Specifies the part used to heat destination with a flame to remove bubbles.",
			Category -> "Temperature Equilibration",
			Developer -> True
		},
		ParafilmDestination -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether Parafilm should be applied to the Destination after Transfer (and any applicable CoolingTime).",
			Category -> "Container Covering",
			Developer -> True
		},

		(* Additional Robotic-Only Transfer Fields *)
		DeviceChannel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DeviceChannelP,
			Description -> "The channel of the work cell that will be used to perform the transfer (MultiProbeHead | SingleProbe1 | SingleProbe2 | SingleProbe3 | SingleProbe4 | SingleProbe5 | SingleProbe6 | SingleProbe7 | SingleProbe8). This option can only be set if Preparation->Robotic.",
			Category -> "Pipetting Parameters"
		},
		Resuspension -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this transfer is resuspending a solid. If True, liquid is dispensed at the top of the destination's container.",
			Category -> "Pipetting Parameters"
		},
		AspirationRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The speed at which liquid was drawn up into the pipette tip.",
			Category -> "Pipetting Parameters"
		},
		OverAspirationVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
			Category -> "Pipetting Parameters"
		},
		AspirationWithdrawalRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter/Second],
			Units -> Millimeter/Second,
			Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
			Category -> "Pipetting Parameters"
		},
		AspirationEquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
			Category -> "Pipetting Parameters"
		},
		AspirationMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
			Category -> "Pipetting Parameters"
		},
		AspirationPositions -> {
			Format -> Multiple,
			Class -> Expression,
			(* Top | Bottom | LiquidLevel *)
			Pattern :> PipettingPositionP,
			Description -> "The location from which liquid should be aspirated. Top will aspirate AspirationPositionOffset below the Top of the container, Bottom will aspirate AspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate AspirationPositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified AspirationPositionOffset above the bottom of the container to start aspirate the sample.",
			Category -> "Pipetting Parameters"
		},
		AspirationPositionOffsets -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Millimeter]|Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
			Description -> "The distance from the center of the well that liquid will aspirated. When specifying a Z Offset, the Z Offset is calculated either as the height below the top of the well, the height above the bottom of the well, or the height below the detected liquid level, depending on value of the AspirationPosition option (Top|Bottom|LiquidLevel). When an AspirationAngle is specified, the AspirationPositionOffset is measured in the frame of reference of the tilted labware (so that wells that are further away from the pivot point of the tilt are in the same frame of reference as wells that are close to the pivot point of the tilt).",
			Category -> "Pipetting Parameters"
		},
		AspirationAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 AngularDegree],
			Units -> AngularDegree,
			Description -> "The angle that the source container will be tilted during the aspiration of liquid. The container is pivoted on its left edge when tilting occurs.",
			Category -> "Pipetting Parameters"
		},

		(* Dispense Parameters *)
		DispenseRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The speed at which liquid was expelled from the pipette tip.",
			Category -> "Pipetting Parameters"
		},
		OverDispenseVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of air drawn blown out at the end of the dispensing of a liquid.",
			Category -> "Pipetting Parameters"
		},
		DispenseWithdrawalRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter/Second],
			Units -> Millimeter/Second,
			Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
			Category -> "Pipetting Parameters"
		},
		DispenseEquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
			Category -> "Pipetting Parameters"
		},
		DispenseMixRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
			Category -> "Pipetting Parameters"
		},
		DispensePositions -> {
			Format -> Multiple,
			Class -> Expression,
			(* Top | Bottom | LiquidLevel *)
			Pattern :> PipettingPositionP,
			Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
			Category -> "Pipetting Parameters"
		},
		DispensePositionOffsets -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterEqualP[0 Millimeter]|Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
			Description -> "The distance from the center of the well that liquid will dispensed. When specifying a Z Offset, the Z Offset is calculated either as the height below the top of the well, the height above the bottom of the well, or the height below the detected liquid level, depending on value of the DispensePosition option (Top|Bottom|LiquidLevel). When an DispenseAngle is specified, the DispensePositionOffset is measured in the frame of reference of the tilted labware (so that wells that are further away from the pivot point of the tilt are in the same frame of reference as wells that are close to the pivot point of the tilt).",
			Category -> "Pipetting Parameters"
		},
		DispenseAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
			Units -> AngularDegree,
			Description -> "The angle that the destination container will be tilted during the dispensing of liquid. The container is pivoted on its left edge when tilting occurs.",
			Category -> "Pipetting Parameters"
		},

		CorrectionCurves -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|Null,
			Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. The correction curve is derived empirically from the relationship between the target and actual amount of volume transferred when on a specific robotic liquid handler instrument model. It is recommended when building one of these curves to measure the volume of sample transferred gravimetrically to get a more accurate CorrectionCurve. Use the function UploadPipettingMethod to create a new pipetting method for a sample model to have all robotic transfers of this sample model to use the derived CorrectionCurve automatically.",
			Category -> "Pipetting Parameters"
		},

		DynamicAspiration -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if droplet formation was prevented during liquid transfer. Only use this option for solvents that have high vapor pressure.",
			Category -> "Pipetting Parameters"
		},
		ContainersToCover -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The source and destination containers that are covered at the beginning of the protocol. These are usually empty containers that don't have a cover to begin with, covering them at the start of the protocol makes sure that we don't have to resource pick a cover in the middle of the transfer.",
			Category -> "Container Covering",
			Developer -> True
		},
		AllowSourceContainerReCover->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source container is allowed to re-cover once uncovered during this protocol. For example, the containers are not allowed to be re-covered if it is an ampoule or has CoverType->Crimped.",
			Category ->  "Container Covering",
			Developer -> True
		},
		KeepSourceCovered -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover on this container should be \"peaked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers in order to reduce chances of contamination or minimize light exposure. When performing robotic manipulations, this indicates that the container should be re-covered after any manipulation that uncovers it is completed.",
			Category -> "Container Covering"
		},
		ReplaceSourceCovers -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover on the source container was replaced at the end of the transfer with a new type of cover. If set to False, the previous cover (or a new instance of the previous cover if the previous cover is not reusable) is used to cover the container after the transfer occurs.",
			Category -> "Container Covering"
		},
		SourceCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Join[CoverObjectTypes, CoverModelTypes],
			Description -> "The new cover that was placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous cover was used.",
			Category -> "Container Covering"
		},
		SourceSeptums -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Septum], Object[Item, Septum]],
			Description -> "The new septum that was placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous septum was used (if there was previously a septum on the container).",
			Category -> "Container Covering"
		},
		SourceStoppers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Stopper], Object[Item, Stopper]],
			Description -> "The new stopper that was placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous stopper was used (if there was previously a stopper on the container).",
			Category -> "Container Covering"
		},
		KeepDestinationCovered -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover on the source container should be \"peaked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers in order to reduce chances of contamination or minimize light exposure. When performing robotic manipulations, this indicates that the container should be re-covered after the transfer is complete.",
			Category -> "Container Covering"
		},
		ReplaceDestinationCovers -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover on the destination container was replaced at the end of the transfer with a new type of cover. If set to False, the previous cover (or a new instance of the previous cover if the previous cover is not reusable) is used to cover the container after the transfer occurs.",
			Category -> "Container Covering"
		},
		DestinationCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Join[CoverObjectTypes, CoverModelTypes],
			Description -> "The new cover that was placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous cover was used.",
			Category -> "Container Covering"
		},
		DestinationSeptums -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Septum], Object[Item, Septum]],
			Description -> "The new septum that was placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous septum was used (if there was previously a septum on the container).",
			Category -> "Container Covering"
		},
		DestinationStoppers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Stopper], Object[Item, Stopper]],
			Description -> "The new stopper that was placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous stopper was used (if there was previously a stopper on the container).",
			Category -> "Container Covering"
		},

		RestrictSources -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the source was restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member).",
			Category -> "Sample Post-Processing"
		},
		RestrictDestinations -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the destination was restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member).",
			Category -> "Sample Post-Processing"
		},

		PercentTransferred -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The operator estimated percentage of mass/volume that was transferred from the source to the destination, in relation to the user specified Amount. The percent transferred will be less than 100% if there was not enough volume/mass in the source sample.",
			Category -> "Experimental Results"
		},
		HomogeneousSlurryTransfer -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source sample was able to become fully homogeneous via aspiration mixing (mixing up to MaxNumberOfAspirationMixes times) before the slurry transfer occurred. This data is recorded by the operator if the transfer is set as a SlurryTransfer.",
			Category -> "Experimental Results"
		},
		DestinationSampleHandling -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleHandlingP,
			Description -> "The resulting sample handling category of the destination sample after the transfer is performed.",
			Category -> "Experimental Results"
		},
		DefinedSourceLayers->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if there were defined layers in the source sample before the aspiration was performed.",
			Category -> "Experimental Results"
		},
		DefinedDestinationLayers->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if there were defined layers in the destination sample before the aspiration was performed.",
			Category -> "Experimental Results"
		},
		MagneticSeparation->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the operator observed that there was clear separation of any magnetic particles in the source sample after it was left on the magnetic rack for MagnetizationTime/MaxMagnetizationTime.",
			Category -> "Experimental Results"
		},
		MeasuredSourceTemperatures->{
			Format->Multiple,
			Class->Distribution,
			Pattern:>DistributionP[Celsius],
			Units->Celsius,
			Description->"The observed temperature of the source sample measured after the equilibration time if SourceEquilibrationCheck is set to True.",
			Category->"Experimental Results"
		},
		MeasuredSourceTemperatureData->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "For each member of MeasuredSourceTemperatures, the recorded temperature of the source sample after equilibration, as measured by the temperature probe.",
			IndexMatching->MeasuredSourceTemperatures,
			Category -> "Experimental Results"
		},
		MeasuredDestinationTemperatures->{
			Format -> Multiple,
			Class->Distribution,
			Pattern:>DistributionP[Celsius],
			Units->Celsius,
			Description->"The observed temperature of the destination sample measured after the equilibration time if DestinationEquilibrationCheck is set to True.",
			Category -> "Experimental Results"
		},
		MeasuredDestinationTemperatureData->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "For each member of MeasuredDestinationTemperatures, the recorded temperature of the destination sample after equilibration, as measured by the temperature probe.",
			Category -> "Experimental Results",
			IndexMatching->MeasuredDestinationTemperatures
		},

		(* NOTE: These are copied from the corresponding UOs. *)
		TareData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Weight] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the weight measurement data recorded with nothing on the balance and after zeroing the reading. This data should always be 0 Gram. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		TareWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the weight recorded with nothing on the balance and after zeroing the reading. This data should always be 0 Gram. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		TareWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Appearance] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the side on image of the weighing surface of the balance, captured immediately following the weight measurement of TareData by the integrated camera. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},

		EmptyContainerWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Weight] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the weight measurement data of the weigh container when empty and before any incoming sample transfer has commenced. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		EmptyContainerWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the weight of the weigh container when empty and before any incoming sample transfer has commenced. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		EmptyContainerWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Appearance] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of EmptyContainerWeightData by the integrated camera. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},

		MeasuredTransferWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Weight] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the weight measurement data of the weighing container when filled with the amount of sample needed to complete the transfer. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		MeasuredTransferWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the weight of the weighing container when filled with the amount of sample needed to complete the transfer. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		MeasuredTransferWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Appearance] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of MeasuredTransferWeightData by the integrated camera. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},

		MaterialLossWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Weight] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the weight measurement data recorded after the weighing container is removed from the balance. This measurement accounts for any material lost onto the balance pan during the transfer process. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		MaterialLossWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the weight recorded after the weighing container is removed from the balance. This weight accounts for any material lost onto the balance pan during the transfer process. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		MaterialLossWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Appearance] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the side on image of the weighing surface of the balance, captured immediately following the weight measurement of MaterialLossWeightData by the integrated camera. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		ResidueWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Weight] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the weight measurement data of the weighing container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		ResidueWeights -> {
			Format -> Multiple,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the weight of the weighing container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		ResidueWeightAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			(* This must be Object[Data,Appearance] but the pattern should be Object[Data] for backlink *)
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, the side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of ResidueWeightData by the integrated camera. This field is Null for non-weight-based transfers.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		AspirationDates->{
			Format->Multiple,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The date at which we aspirated our source solution.",
			Category->"Pipetting Parameters"
		},
		DispenseDates->{
			Format->Multiple,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"The date at which we dispensed our source solution.",
			Category->"Pipetting Parameters"
		},
		AspirationPressures->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Second,Pascal}..}],
			Description->"The pressure data measured by the liquid handler during aspiration of the source samples.",
			Category->"Pipetting Parameters"
		},
		DispensePressures->{
			Format->Multiple,
			Class->QuantityArray,
			Pattern:>QuantityArrayP[{{Second,Pascal}..}],
			Description->"The pressure data measured by the liquid handler during dispensing of the source samples.",
			Category->"Pipetting Parameters"
		},

		(* NOTE: These are all resource picked at once so that we can minimize trips to the VLM. DO NOT COPY THIS. *)
		RequiredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part],
			Description -> "Objects required for the protocol.",
			Category -> "General",
			Developer -> True
		},
		(* NOTE: These are resource picked on the fly, but we need this field so that ReadyCheck knows if we can start the protocol or not. *)
		(* DO NOT COPY THIS. *)
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Instruments required for the protocol.",
			Category -> "General",
			Developer -> True
		},
		KeepInstruments ->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description ->  "Indicates if instruments are released and moved back to the previous location after completing the ExperimentTransfer protocol.",
			Category -> "General",
			Developer -> True
		},
		OrdersFulfilled -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction, Order][Fulfillment],
			Description -> "Automatic inventory orders fulfilled by samples generated by this protocol.",
			Category -> "Inventory"
		},
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Resource, Sample][Preparation]
			],
			IndexMatching -> BatchedUnitOperations,
			Description -> "For each member of BatchedUnitOperations, the resource in the parent protocol that is fulfilled by performing the requested manipulation to generate a new sample.",
			Category -> "Resources",
			Developer -> True
		},

		LivingDestinations->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the typical rules for setting the Living field of the Destination will be followed, or if the Living field of the Destination will be set to False regardless of the state of the Living field of the source and destination initially. See the UploadSampleTransfer helpfile for more information on the 'typical rules' for setting the Living field.",
			IndexMatching -> SamplesIn,
			Category -> "General",
			Developer -> True
		},

		(* NOTE: These developer fields are here for speed -- previously there was a loop insertion to figure out how to individually *)
		(* queue or discard these samples in the procedure. We now figure this out in the parser and call one queue and one discard task *)
		(* at the end of the procedure. *)
		(* Discard any weighing container - consumable or vessel. Otherwise, they will be released as EMPTY containers in the user's notebook and will cause SEVERE contamination issues in the lab *)
		WeighingContainersToDiscard -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Consumable],
				Object[Container],
				Object[Item, WeighBoat]
			],
			Description -> "The weighing containers that will be discarded at the end of the protocol.",
			Category -> "General",
			Developer -> True
		},
		TransferPostProcessingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Object[Sample],
				Object[Container]
			],
			Description -> "The samples that will be queued for post processing at the end of the protocol.",
			Category -> "General",
			Developer -> True
		},
		MaterialLossLog -> {
			Format -> Multiple,
			Class -> {
				Date -> Date,
				OperatorMaterialLossAssessment -> Boolean,
				MeasuredTransferWeightAppearance -> Link,
				MaterialLossAutoDetected -> Boolean,
				MaterialLossWeight -> Real,
				MaterialLossWeightAppearance -> Link,
				Sample -> Link,
				UnitOperation -> Link,
				Operator -> Link
			},
			Pattern :> {
				Date -> _?DateObjectQ,
				OperatorMaterialLossAssessment -> BooleanP,
				MeasuredTransferWeightAppearance -> _Link,
				MaterialLossAutoDetected -> BooleanP,
				MaterialLossWeight -> _?QuantityQ,
				MaterialLossWeightAppearance -> _Link,
				Sample -> _Link,
				UnitOperation -> _Link,
				Operator -> _Link
			},
			Units -> {
				Date -> None,
				OperatorMaterialLossAssessment -> None,
				MeasuredTransferWeightAppearance -> None,
				MaterialLossAutoDetected -> None,
				MaterialLossWeight -> Milligram,
				MaterialLossWeightAppearance -> None,
				Sample -> None,
				UnitOperation -> None,
				Operator -> None
			},
			Relation -> {
				Date -> None,
				OperatorMaterialLossAssessment -> None,
				MeasuredTransferWeightAppearance -> Object[Data, Appearance],
				MaterialLossAutoDetected -> None,
				MaterialLossWeight -> Milligram,
				MaterialLossWeightAppearance -> Object[Data, Appearance],
				Sample -> Alternatives[
					Object[Sample],
					Object[Container]
				],
				UnitOperation -> Object[UnitOperation],
				Operator -> Object[User,Emerald,Operator]
			},
			Description -> "The information regarding stray material during a weighing instance. OperatorMaterialLossAssessment indicates the response of the operator as to whether stray material is after weighing. MeasuredTransferWeightAppearance is the image immediately taken after the weighing step. MaterialLossAutoDetected indicates whether a material loss is detected based on relevant weight data tracked. MaterialLossWeight is the weight that is not effectively transferred to the weighing container. MeasuredTransferWeightAppearance is the image immediately taken after material loss is autodetected. UnitOperation is the unit operation the log is associated with. Sample is the material ends up in the destination container. UnitOperation is the object pertaining to the transfer by weighing that is performed. Operator is the lab operator who performed the weighing.",
			Category -> "General"
		},
		BalancePreCleaningMethod ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Wet,Dry,None],
			Description ->  "Indicates the type of cleaning performed on the balance right before a weighing instance if the operator indicates presence of stray material. Dry indicates the balance pan surface and the balance floor outside of the balance pan is cleared of any stray material using soft and lint-free non-woven wipes. Wet indicates the balance pan surface and the balance floor outside of the balance pan is first cleaned with Dry method, followed by wiping with DI-water moistened wipes, IPA-moistened wipes, and a final dry wipe. None indicates no cleaning is performed prior to initial setup.",
			Category -> "Cleaning"
		},
		BalanceCleaningMethods ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Wet,Dry],
			Description ->  "Indicates the type of cleaning performed on the balance right before a weighing instance if the operator indicates presence of stray material. Dry indicates the balance pan surface and the balance floor outside of the balance pan is cleared of any stray material using soft and lint-free non-woven wipes. Wet indicates the balance pan surface and the balance floor outside of the balance pan is first cleaned with Dry method, followed by wiping with DI-water moistened wipes, IPA-moistened wipes, and a final dry wipe. None indicates no cleaning is performed prior to initial setup.",
			Category -> "Cleaning"
		}
	}
}];
