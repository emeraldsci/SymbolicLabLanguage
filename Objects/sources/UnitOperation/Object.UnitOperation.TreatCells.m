(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, TreatCells],{
	Description->"The information that specifies the information of how to perform a treatment of cell samples from treatment samples",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		TransferProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, Transfer],
				Object[Protocol, ManualSamplePreparation]
			],
			Description -> "The Transfer protocols that transferred the amount going into the Destination.",
			Category -> "Method Information"
		},
		TransferUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation, Transfer],
			Description -> "For each member of TransferProtocols, the Transfer unit operation that contained the instructions for transferring sample into the Destination.",
			Category -> "Method Information",
			IndexMatching -> TransferProtocols
		},
		TransferAndMixUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[UnitOperation, Transfer],Object[UnitOperation, Mix]],
			Description -> "The Transfer and Mix unit operations that contained the instructions for transferring sample into the Destination and Mixing.",
			Category -> "Method Information"
		},
		TransferAndMixProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, Transfer],
				Object[Protocol, Incubate],
				Object[Protocol, ManualSamplePreparation],
				Object[Protocol, ManualCellPreparation]
			],
			Description -> "The Transfer and Mix protocols that transferred the amount going into the Destination and used to mixed the CellSample after TreatmentSample is added.",
			Category -> "Method Information"
		},
		MixProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, Incubate],
				Object[Protocol, ManualSamplePreparation]
			],
			Description -> "The Mix protocols that are used to mix CellSample after TreatmentSample is added.",
			Category -> "Method Information"
		},
		MixUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation, Mix],
			Description -> "For each member of MixProtocols, the Mix unit operation that contained the instructions for mixing the CellSample after the TreatmentSample is added.",
			Category -> "Method Information",
			IndexMatching -> MixProtocols
		},

		(*Transfers*)
		TreatmentSampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of CellSampleLink, the source sample for this transfer that we transfer out of.",
			Category -> "General",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},
		TreatmentSampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the source sample for this transfer that we transfer out of.",
			Category -> "General",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},
		TreatmentSampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the source sample for this transfer that we transfer out of.",
			Category -> "General",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},

		CellSampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The destination samples for this transfer that we transfer into.",
			Category -> "General",
			Migration->SplitField
		},
		CellSampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the destination samples for this transfer that we transfer into.",
			Category -> "General",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},
		CellSampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the destination samples for this transfer that we transfer into.",
			Category -> "General",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},

		AmountVariableUnit -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit],
			Description -> "For each member of CellSampleLink, the amount of that sample that will be transferred to the corresponding CellSample. An Amount of All indicates that all of the source will be transferred to the destination.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},

		AmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> All,
			Description -> "For each member of CellSampleLink, the amount of that sample that will be transferred to the corresponding CellSample. An Amount of All indicates that all of the source will be transferred to the destination.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},

		TransferEnvironment->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, BiosafetyCabinet],
				Model[Instrument, FumeHood],
				Model[Instrument, GloveBox],
				Model[Container, Bench],
				Model[Container, Enclosure],
				Object[Instrument, BiosafetyCabinet],
				Object[Instrument, FumeHood],
				Object[Instrument, GloveBox],
				Object[Container, Bench],
				Object[Container, Enclosure]
			],
			Description -> "The instrument that will be used to contain all of the materials during the transfer.",
			Category -> "Method Information"
		},
		TransferInstrument->{
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
			Description -> "The instrument used to move the sample from the source container (or from the intermediate container if IntermediateDecant->True) to the destination container.",
			Category -> "Method Information"
		},

		Balance->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Balance],
				Object[Instrument,Balance]
			],
			Description -> "For each member of CellSampleLink, the balance used to weigh the transfer amount, if the transfer is occurring gravimetrically (MassP).",
			Category -> "Method Information"
		},
		TabletCrusher->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, TabletCrusher],
				Object[Item, TabletCrusher]
			],
			Description -> "For each member of CellSampleLink, the pill crusher to crush the itemized samples (if necessary), if the transfer amount is a specific mass.",
			Category -> "Method Information"
		},
		TabletCrusherBag->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, TabletCrusherBag],
				Object[Item, TabletCrusherBag]
			],
			Description -> "For each member of CellSampleLink, the pill crusher bag that will contain the crushed Itemized sample after it has been in the pill crusher.",
			Category -> "Method Information"
		},
		TransferTips->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "For each member of CellSampleLink, the pipette tips used to aspirate and dispense the requested volume.",
			Category -> "Method Information"
		},
		MultichannelTransfer->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if this transfer will aspirate/dispense multiple samples at the same time, using a multichannel pipette.",
			Category -> "Method Information"
		},

		Needle->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of CellSampleLink, the needle used to aspirate and dispense the requested volume.",
			Category -> "Method Information"
		},
		Funnel->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "For each member of CellSampleLink, the funnel that is used to guide the source sample into the destination container when pouring or using a graduated cylinder.",
			Category -> "Method Information"
		},
		WeighingContainer->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of CellSampleLink, the container that will be used to weigh out the specified amount of the source that will be transferred to the destination.",
			Category -> "Method Information"
		},
		Magnetization->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if the source container should be put in a magnetized rack to separate out any magnetic components before the transfer is performed.",
			Category -> "Method Information"
		},
		MagnetizationRack->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Rack],
				Object[Container,Rack]
			],
			Description -> "For each member of CellSampleLink, the magnetized rack that the source/intermediate container will be placed in before the transfer is performed.",
			Category -> "Method Information"
		},
		MagnetizationTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the time that the source sample should be left on the magnetic rack until the magnetic components are settled at the side of the container.",
			Category -> "Method Information"
		},
		MaxMagnetizationTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the maximum time that the source sample should be left on the magnetic rack until the magnetic components are settled at the side of the container.",
			Category -> "Method Information"
		},

		CellSampleRack->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Rack],
				Object[Container,Rack]
			],
			Description -> "For each member of CellSampleLink, the rack that is used to hold the CellSample container upright when it is being weighed, if necessary (ex. 50mL Tube stand).",
			Category -> "Method Information"
		},
		Tolerance->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "For each member of CellSampleLink, the allowed tolerance of the weighed source sample from the specified amount requested to be transferred.",
			Category -> "Method Information"
		},

		QuantitativeTransfer->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if additional QuantitativeTransferWashSolution will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		QuantitativeTransferWashSolution->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of CellSampleLink, the solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		QuantitativeTransferWashVolume->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Milliliter,
			Description -> "For each member of CellSampleLink, the volume of the solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		QuantitativeTransferWashInstrument->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "For each member of CellSampleLink, the pipette that will be used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		QuantitativeTransferWashTips->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "For each member of CellSampleLink, the tips that will be used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		NumbersOfQuantitativeTransferWashes->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of CellSampleLink, indicates the number of washes of the weight boat with QuantitativeTransferWashSolution that will occur, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		UnsealHermeticTreatmentSamples->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if the source's hermetic container should be unsealed before sample is transferred out of it.",
			Category -> "Method Information"
		},
		UnsealHermeticSource->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if the source's hermetic container should be unsealed before sample is transferred out of it.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink
		},
		BackfillNeedle->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of CellSampleLink, the needle used to backfill the source's hermetic container with BackfillGas.",
			Category -> "Method Information"
		},
		BackfillGas->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Expression,
			Pattern :> Alternatives[
				Nitrogen,
				Argon
			],
			Description -> "For each member of CellSampleLink, the inert gas that is used equalize the pressure in the source's hermetic container while the transfer out of the source's container occurs.",
			Category -> "Method Information"
		},

		AspirationMix->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if mixing should occur during aspiration from the source sample.",
			Category -> "Method Information"
		},
		AspirationMixType->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "For each member of CellSampleLink, the type of mixing that should occur during aspiration.",
			Category -> "Method Information"
		},
		NumbersOfAspirationMixes->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of CellSampleLink, the number of times that the source sample should be mixed during aspiration.",
			Category -> "Method Information"
		},
		DispenseMix->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if mixing should occur after the sample is dispensed into the destination container.",
			Category -> "Method Information"
		},
		DispenseMixType->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Expression,
			Pattern :> Swirl|Pipette,
			Description -> "For each member of CellSampleLink, the type of mixing that should occur after the sample is dispensed into the destination container.",
			Category -> "Method Information"
		},
		NumbersOfDispenseMixes->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of CellSampleLink, the number of times that the source sample should be mixed after the sample is dispensed into the destination container.",
			Category -> "Method Information"
		},
		IntermediateDecant->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if the source will need to be decanted into an intermediate container in order for the precise amount requested to be transferred via pipette.",
			Category -> "Method Information"
		},
		IntermediateContainer->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of CellSampleLink, the container that the source will be decanted into in order to make the final transfer via pipette into the final destination.",
			Category -> "Method Information"
		},
		IntermediateFunnel->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "For each member of CellSampleLink, the funnel that is used to guide the source sample into the intermediate container when pouring.",
			Category -> "Method Information"
		},
		TreatmentSampleTemperatureReal->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of CellSampleLink, the temperature at which the source should be at during the transfer.",
			Category -> "Method Information",
			Migration -> SplitField
		},
		TreatmentSampleTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient,
			IndexMatching->CellSampleLink,
			Description->"For each member of CellSampleLink, the temperature at which the source should be at during the transfer.",
			Category->"Method Information",
			Migration -> SplitField
		},
		TreatmentSampleEquilibrationTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the duration of time for which the samples will be heated/cooled to the target TreatmentSampleTemperature.",
			Category -> "Method Information"
		},
		MaxTreatmentSampleEquilibrationTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the maximum duration of time for which the samples will be heated/cooled to the target TreatmentSampleTemperature, if they do not reach the TreatmentSampleTemperature after TreatmentSampleEquilibrationTime.",
			Category -> "Method Information"
		},
		TreatmentSampleEquilibrationCheck->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "For each member of CellSampleLink, the method by which to verify the temperature of the source before the transfer is performed.",
			Category -> "Method Information"
		},
		CellSampleTemperatureReal->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of CellSampleLink, the temperature at which the source should be at during the transfer.",
			Category -> "Method Information",
			Migration -> SplitField
		},
		CellSampleTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient,
			IndexMatching->CellSampleLink,
			Description->"For each member of CellSampleLink, the temperature at which the source should be at during the transfer.",
			Category->"Method Information",
			Migration -> SplitField
		},
		CellSampleEquilibrationTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the duration of time for which the samples will be heated/cooled to the target TreatmentSampleTemperature.",
			Category -> "Method Information"
		},
		MaxCellSampleEquilibrationTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the maximum duration of time for which the samples will be heated/cooled to the target TreatmentSampleTemperature, if they do not reach the TreatmentSampleTemperature after TreatmentSampleEquilibrationTime.",
			Category -> "Method Information"
		},
		CellSampleEquilibrationCheck->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "For each member of CellSampleLink, the method by which to verify the temperature of the source before the transfer is performed.",
			Category -> "Method Information"
		},

		(*To feed mix sub*)

		MixSampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of CellSampleLink, the samples that are being mixed.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},
		MixSampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the samples that are being mixed.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},
		MixSampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the samples that are being mixed.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink,
			Migration->SplitField
		},
		(* Note: These fields are now included in the shared fields in Object[UnitOperation], and are no longer needed here
		MixType->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Expression,
			Pattern :> CellMixTypeP,
			Description -> "For each member of CellSampleLink, the type of mix.",
			Category -> "Method Information"
		},
		MixUntilDissolved->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if all solid must be dissolved at the end of mixing.",
			Category -> "Method Information"
		},*)
		MixInstrument->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Join[MixInstrumentModels,MixInstrumentObjects],
			Description -> "For each member of CellSampleLink, the instrument used to mix CellSampleLink.",
			Category -> "Method Information"
		},
		MixTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the time that the MixSample is mixed.",
			Category -> "Method Information"
		},
		MaxMixTime->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of CellSampleLink, the time that the MixSample is mixed.",
			Category -> "Method Information"
		},
		MixRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units ->RPM,
			Description -> "For each member of CellSampleLink, the speed at which sample is mixed.",
			IndexMatching -> CellSampleLink,
			Category -> "Method Information"
		},
		NumbersOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "For each member of CellSampleLink, the number of mixing motions to be performed.",
			IndexMatching -> CellSampleLink,
			Category ->  "Method Information"
		},
		MaxNumbersOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "For each member of CellSampleLink, the max number of mixing motions to be performed in order for solids to be dissolved.",
			IndexMatching -> CellSampleLink,
			Category -> "Method Information"
		},
		MixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of CellSampleLink, the volume that is pipetted up and down to mix the sample.",
			IndexMatching -> CellSampleLink,
			Category ->  "Method Information"
		},
		MixTemperatureReal->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of CellSampleLink, the temperature at which the sample should be at during mixing.",
			Category -> "Method Information",
			Migration -> SplitField
		},
		MixTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient,
			IndexMatching->CellSampleLink,
			Description-> "For each member of CellSampleLink, the temperature at which the sample should be at during mixing.",
			Category->"Method Information",
			Migration -> SplitField
		},
		OscillationAngle->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Real,
			Pattern :> GreaterEqualP[0 AngularDegree],
			Units -> AngularDegree,
			Description -> "For each member of CellSampleLink, the angle at which the sample should be mixed at.",
			Category -> "Method Information"
		},
		ResidualIncubation->{
			Format -> Multiple,
			IndexMatching -> CellSampleLink,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CellSampleLink, indicates if the mixing should continue after Time/MaxTime has finished while waiting to progress to the next step in the protocol.",
			Category -> "Method Information"
		},
		TipRinse->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the Tips should first be rinsed with a TipRinseSolution before they are used to aspirate from the source sample.",
			Category -> "Method Information"
		},
		TipRinseSolutionLink->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "Method Information",
			Migration->SplitField
		},
		TipRinseSolutionString->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The solution that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "Method Information",
			Migration->SplitField
		},
		TipRinseVolume->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Milliliter,
			Description -> "The volume of the solution that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "Method Information"
		},
		NumberOfTipRinses->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of times that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "Method Information"
		},
		NumberOfAspirationMixes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of CellSampleLink, the number of times that the source sample should be mixed during aspiration.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink
		},
		NumberOfDispenseMixes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of CellSampleLink, the number of times that the source sample should be mixed after the sample is dispensed into the destination container.",
			Category -> "Method Information",
			IndexMatching -> CellSampleLink
		},
		NumberOfQuantitativeTransferWashes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Indicates the number of washes of the weight boat with QuantitativeTransferWashSolution that will occur, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
			Category -> "Method Information"
		},
		NumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"For each member of CellSampleLink, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			IndexMatching->CellSampleLink,
			Category->"Method Information"
		},
		MaxNumberOfMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"For each member of CellSampleLink, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
			IndexMatching->CellSampleLink,
			Category->"Method Information"
		},
		TreatmentSampleLabel->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of TreatmentSampleLink, the label of the source treatment sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category ->  "General",
			IndexMatching->TreatmentSampleLink
		},
		TreatmentSampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of TreatmentSampleLink, the label of the source treatment container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> TreatmentSampleLink
		},
		CellSampleLabel->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the label of the source cell sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category ->  "General",
			IndexMatching->CellSampleLink
		},
		CellSampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of CellSampleLink, the label of the source cell container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> CellSampleLink
		}
	}
}];