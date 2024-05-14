(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,Pellet],
	{
		Description->"A detailed set of parameters to precipitate solids that are present in a solution, aspirate off the supernatant, and optionally resuspend the pellet in a resuspension solution..",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
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
				Description -> "The sample that is to be pelleted during this unit operation.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that is to be pelleted during this unit operation.",
				Category -> "General",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The sample that is to be pelleted during this unit operation.",
				Category -> "General",
				Migration->SplitField
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the sample container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the SamplesOut that are in the SupernatantDestinations, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			ContainerOutLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the SupernatantDestinations container that contains SamplesOut, which is used for identification elsewhere in sample preparation.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			Instrument -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, Centrifuge],
					Object[Instrument, Centrifuge]
				],
				Description -> "For each member of SampleLink, the centrifuge that will be used to spin the provided samples.",
				Category->"Centrifugation",
				IndexMatching -> SampleLink
			},
			Intensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0*RPM]|GreaterP[0*GravitationalAcceleration],
				Description -> "For each member of SampleLink, the rotational speed or the force that will be applied to the samples by centrifugation.",
				Category -> "Centrifugation",
				IndexMatching -> SampleLink
			},
			Time -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Minute],
				Units -> Minute,
				Description -> "For each member of SampleLink, the amount of time for which samples are spun in this centrifugation.",
				Category -> "Centrifugation",
				IndexMatching -> SampleLink
			},
			TemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Kelvin],
				Units -> Celsius,
				Description -> "For each member of SampleLink, the temperature in real value at which the centrifuge chamber is held during centrifugation.",
				Category -> "Centrifugation",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			TemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Ambient],
				Description -> "For each member of SampleLink, the temperature (if it's ambient) at which the centrifuge chamber is held during centrifugation.",
				Category -> "Centrifugation",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			SupernatantVolumeReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Description -> "For each member of SampleLink, the volume of supernatant that will be aspirated from the source sample.",
				Category->"Supernatant Aspiration",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			SupernatantVolumeExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> All|Null,
				Description -> "For each member of SampleLink, the volume of supernatant that will be aspirated from the source sample.",
				Category->"Supernatant Aspiration",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			SupernatantDestinationLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "For each member of SampleLink, the destination that the supernatant should be dispensed into, after aspirated from the source sample.",
				Category->"Supernatant Aspiration",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			SupernatantDestinationString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the destination that the supernatant should be dispensed into, after aspirated from the source sample.",
				Category->"Supernatant Aspiration",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			SupernatantDestinationExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Waste|Null,
				Relation -> Null,
				Description -> "For each member of SampleLink, the destination that the supernatant should be dispensed into, after aspirated from the source sample.",
				Category->"Supernatant Aspiration",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			SupernatantTransferInstrument ->{
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
				Description -> "For each member of SampleLink, the instrument that will be used to transfer the supernatant from the source sample into the supernatant destination.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferTips->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Tips],
					Object[Item, Tips]
				],
				Description -> "The pipette tips used to aspirate and dispense the requested volume.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferTipType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> TipTypeP,
				Description -> "For each member of SupernatantTransferTips, the type of pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category -> "Supernatant Aspiration",
				IndexMatching -> SupernatantTransferTips
			},
			SupernatantTransferTipMaterial->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MaterialP,
				Description -> "For each member of SupernatantTransferTips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category -> "Supernatant Aspiration",
				IndexMatching -> SupernatantTransferTips
			},
			SupernatantTransferReversePipetting->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination position.",
				Category -> "Supernatant Aspiration"
			},
			SupernatantTransferSlurryTransfer->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source sample should be mixed via pipette until it becomes homogenous, up to MaxNumberOfAspirationMixes times.",
				Category -> "General"
			},
			SupernatantTransferAspirationMix->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should occur during aspiration from the source sample.",
				Category -> "Supernatant Aspiration"
			},
			SupernatantTransferNumberOfAspirationMixes->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of SupernatantTransferAspirationMix, the number of times that the source sample should be mixed during aspiration.",
				Category -> "Supernatant Aspiration",
				IndexMatching -> SupernatantTransferAspirationMix
			},
			SupernatantTransferMaxNumberOfAspirationMixes->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of SupernatantTransferAspirationMix, the maximum number of times that the source sample was mixed during aspiration in order to achieve a homogeneous solution before the transfer.",
				Category -> "Supernatant Aspiration",
				IndexMatching -> SupernatantTransferAspirationMix
			},
			SupernatantTransferDispenseMix->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should occur after the sample is dispensed into the destination container.",
				Category -> "Supernatant Aspiration"
			},
			SupernatantTransferNumberOfDispenseMixes->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of SupernatantTransferDispenseMix, the number of times that the source sample should be mixed after the sample is dispensed into the destination container.",
				Category -> "Supernatant Aspiration",
				IndexMatching -> SupernatantTransferDispenseMix
			},
			SupernatantTransferDeviceChannel -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> DeviceChannelP,
				Description -> "The channel of the work cell that should be used to perform the transfer.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid should be drawn up into the pipette tip.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferOverAspirationVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationWithdrawalRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be aspirated.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]},
				Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferAspirationAngle->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the source container will be tilted during the aspiration of liquid. The container is pivoted on its left edge when tilting occurs.",
				Category -> "Supernatant Aspiration"
			},

			(* Dispense Parameters *)
			SupernatantTransferDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid should be expelled from the pipette tip.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferOverDispenseVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn blown out at the end of the dispensing of a liquid.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispenseWithdrawalRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispenseEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispenseMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispenseMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispensePosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be dispensed.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispensePositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]},
				Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferDispenseAngle->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the destination container will be tilted during the dispensing of liquid. The container is pivoted on its left edge when tilting occurs.",
				Category -> "Supernatant Aspiration"
			},

			SupernatantTransferCorrectionCurve -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|Null,
				Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume in the form: {target volume, actual volume}.",
				Category->"Supernatant Aspiration"
			},
			SupernatantTransferPipettingMethod -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Method,Pipetting],
				Description -> "The pipetting parameters used to manipulate the supernatant sample in each transfer.",
				Category -> "Pipetting Parameters"
			},
			SupernatantTransferDynamicAspiration -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
				Category->"Supernatant Aspiration"
			},

			Resuspension -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if the pellet should be resuspended after the supernatant is aspirated.",
				Category->"Resuspension",
				IndexMatching->SampleLink
			},
			ResuspensionSourceLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "For each member of SampleLink, the sample that should be used to resuspend the pellet from the source sample.",
				Category->"Resuspension",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			ResuspensionSourceString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the sample that should be used to resuspend the pellet from the source sample.",
				Category->"Resuspension",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			ResuspensionSourceLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, the label of the samples that should be used to resuspend the pellet from the source sample, which is used for identification elsewhere in sample preparation.",
				Category->"Resuspension",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			ResuspensionVolumeReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Description -> "For each member of SampleLink, the volume of ResuspensionSource that should be used to resuspend the pellet from the source sample.",
				Category->"Resuspension",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			ResuspensionVolumeExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> All|Null,
				Description -> "For each member of SampleLink, the volume of ResuspensionSource that should be used to resuspend the pellet from the source sample.",
				Category->"Resuspension",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			ResuspensionInstrument ->{
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
				Description -> "For each member of SampleLink, the instrument that will be used to resuspend the pellet from the source sample.",
				Category->"Resuspension"
			},
			ResuspensionTips->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Tips],
					Object[Item, Tips]
				],
				Description -> "The pipette tips used to aspirate and dispense the requested volume.",
				Category->"Resuspension"
			},
			ResuspensionTipType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> TipTypeP,
				Description -> "For each member of ResuspensionTips, the type of pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category->"Resuspension",
				IndexMatching -> ResuspensionTips
			},
			ResuspensionTipMaterial->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MaterialP,
				Description -> "For each member of ResuspensionTips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category->"Resuspension",
				IndexMatching -> ResuspensionTips
			},
			ResuspensionReversePipetting->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination position.",
				Category->"Resuspension"
			},
			ResuspensionSlurryTransfer->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source sample should be mixed via pipette until it becomes homogenous, up to MaxNumberOfAspirationMixes times.",
				Category->"Resuspension"
			},
			ResuspensionAspirationMix->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should occur during aspiration from the source sample.",
				Category->"Resuspension"
			},
			ResuspensionNumberOfAspirationMixes->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of ResuspensionAspirationMix, the number of times that the source sample should be mixed during aspiration.",
				Category->"Resuspension",
				IndexMatching -> ResuspensionAspirationMix
			},
			ResuspensionMaxNumberOfAspirationMixes->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of ResuspensionAspirationMix, the maximum number of times that the source sample was mixed during aspiration in order to achieve a homogeneous solution before the transfer.",
				Category->"Resuspension",
				IndexMatching -> ResuspensionAspirationMix
			},
			ResuspensionDispenseMix->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should occur after the sample is dispensed into the destination container.",
				Category->"Resuspension"
			},
			ResuspensionNumberOfDispenseMixes->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of ResuspensionDispenseMix, the number of times that the source sample should be mixed after the sample is dispensed into the destination container.",
				Category->"Resuspension",
				IndexMatching -> ResuspensionDispenseMix
			},
			ResuspensionDeviceChannel -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> DeviceChannelP,
				Description -> "The channel of the work cell that should be used to perform the transfer.",
				Category->"Resuspension"
			},
			ResuspensionAspirationRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid should be drawn up into the pipette tip.",
				Category->"Resuspension"
			},
			ResuspensionOverAspirationVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
				Category->"Resuspension"
			},
			ResuspensionAspirationWithdrawalRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
				Category->"Resuspension"
			},
			ResuspensionAspirationEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
				Category->"Resuspension"
			},
			ResuspensionAspirationMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
				Category->"Resuspension"
			},
			ResuspensionAspirationMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
				Category->"Resuspension"
			},
			ResuspensionAspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be aspirated.",
				Category->"Resuspension"
			},
			ResuspensionAspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]},
				Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
				Category->"Resuspension"
			},
			ResuspensionAspirationAngle->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the resuspension solution's container will be tilted during the dispensing of liquid. The container is pivoted on its left edge when tilting occurs.",
				Category->"Resuspension"
			},

			(* Dispense Parameters *)
			ResuspensionDispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid should be expelled from the pipette tip.",
				Category->"Resuspension"
			},
			ResuspensionOverDispenseVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn blown out at the end of the dispensing of a liquid.",
				Category->"Resuspension"
			},
			ResuspensionDispenseWithdrawalRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
				Category->"Resuspension"
			},
			ResuspensionDispenseEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
				Category->"Resuspension"
			},
			ResuspensionDispenseMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
				Category->"Resuspension"
			},
			ResuspensionDispenseMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
				Category->"Resuspension"
			},
			ResuspensionDispensePosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be dispensed.",
				Category->"Resuspension"
			},
			ResuspensionDispensePositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]},
				Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
				Category->"Resuspension"
			},
			ResuspensionDispenseAngle->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the sample's container will be tilted during the dispensing of liquid during resuspension. The container is pivoted on its left edge when tilting occurs.",
				Category->"Resuspension"
			},

			ResuspensionCorrectionCurve -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|Null,
				Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume in the form: {target volume, actual volume}.",
				Category->"Resuspension"
			},
			ResuspensionPipettingMethod -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Method,Pipetting],
				Description -> "The pipetting parameters used to manipulate the resuspension sample in each transfer.",
				Category -> "Pipetting Parameters"
			},
			ResuspensionDynamicAspiration -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
				Category->"Resuspension"
			},

			ResuspensionMix -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this sample should be mixed while incubated, prior to starting the experiment.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixType -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MixTypeP,
				Description -> "Indicates the style of motion used to mix the sample, prior to starting the experiment.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixUntilDissolved -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixInstrument->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Sequence@@Join[MixInstrumentModels,MixInstrumentObjects]
				],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the instrument used to perform the Mix and/or Incubation.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixStirBar->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Part,StirBar],
					Object[Part,StirBar]
				],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the stir bar that should be used to stir the sample.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixTime->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the duration of time for which the samples will be mixed.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixMaxTime->{
				Format->Multiple,
				Class->Real,
				Units->Minute,
				Pattern:>GreaterEqualP[0 Minute],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the maximum duration of time for which the samples will be mixed, in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. Note this option only applies for mix type: Shake, Roll, Vortex or Sonicate.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixDutyCycle->{
				Format->Multiple,
				Class->Expression,
				Pattern:>Null|{GreaterP[0 Minute], GreaterP[0 Minute]},
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, specifies how the homogenizer should mix the given sample via pulsation of the sonication horn. This duty cycle is repeated indefinitely until the specified Time/MaxTime has elapsed. This option can only be set when mixing via homogenization.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixRate->{
				Format->Multiple,
				Class->Real,
				Units->RPM,
				Pattern:>GreaterEqualP[0 RPM],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the frequency of rotation the mixing instrument should use to mix the samples.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixRateProfile->{
				Format->Multiple,
				Class->Expression,
				Pattern:>_List,
				Description->"For each member of SampleLink, the frequency of rotation the mixing instrument should use to mix the samples, over the course of time.",
				IndexMatching->SampleLink,
				Category->"Resuspension Mix"
			},
			ResuspensionNumberOfMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Description->"For each member of SampleLink, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
				IndexMatching->SampleLink,
				Category->"Resuspension Mix"
			},
			ResuspensionMaxNumberOfMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterEqualP[0],
				Description->"For each member of SampleLink, the number of times the samples should be mixed if mix Type: Pipette or Invert, is chosen.",
				IndexMatching->SampleLink,
				Category->"Resuspension Mix"
			},
			ResuspensionMixVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Milliliter,
				Description->"For each member of SampleLink, the volume of the sample that should be pipetted up and down to mix if mix Type: Pipette, is chosen.",
				IndexMatching->SampleLink,
				Category->"Resuspension Mix"
			},
			ResuspensionMixTemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Units->Celsius,
				Pattern :> GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
				Category->"Resuspension Mix",
				Migration -> SplitField
			},
			ResuspensionMixTemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Ambient,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature of the device that should be used to mix/incubate the sample. If mixing via homogenization, the pulse duty cycle of the sonication horn will automatically adjust if the measured temperature of the sample exceeds this set temperature.",
				Category->"Resuspension Mix",
				Migration -> SplitField
			},
			ResuspensionMixTemperatureProfile->{
				Format->Multiple,
				Class->Expression,
				Pattern:>_List,
				Description->"For each member of SampleLink, the temperature of the device, over the course of time, that should be used to mix/incubate the sample.",
				IndexMatching->SampleLink,
				Category->"Resuspension Mix"
			},
			ResuspensionMixMaxTemperature->{
				Format->Multiple,
				Class->Real,
				Units->Celsius,
				Pattern:>GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the maximum temperature that the sample should reach during mixing via homogenization or sonication. If the measured temperature is above this MaxTemperature, the homogenizer/sonicator will turn off until the measured temperature is 2C below the MaxTemperature, then it will automatically resume.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixOscillationAngle->{
				Format->Multiple,
				Class->Real,
				Units->AngularDegree,
				Pattern:>GreaterEqualP[0 AngularDegree],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the angle of oscillation of the mixing motion when a wrist action shaker is used.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixAmplitude->{
				Format->Multiple,
				Class->Real,
				Units->Percent,
				Pattern:>PercentP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the amplitude of the sonication horn when mixing via homogenization. When using a microtip horn (ex. for 2mL and 15mL tubes), the maximum amplitude is 70 Percent, as specified by the manufacturer, in order not to damage the instrument.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixFlowRate->{
				Format->Multiple,
				Class->Real,
				Units->Microliter/Second,
				Pattern:>GreaterEqualP[0 Microliter/Second],
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, indicates the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixPosition->{
				Format->Multiple,
				Class->Expression,
				Pattern:>PipettingPositionP,
				Description -> "For each member of SampleLink, the location from which liquid should be mixed by pipetting. This option can only be set if Preparation->Robotic.",
				IndexMatching->SampleLink,
				Category->"Resuspension Mix"
			},
			ResuspensionMixPositionOffset->{
				Format->Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, indicates the distance below the top of the container, above the bottom of the container, or below the liquid level, depending on MixPosition, from which liquid should be mixed. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixCorrectionCurve->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|Null,
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixTips->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Tips],
					Object[Item, Tips]
				],
				Description -> "The pipette tips used to aspirate and dispense the requested volume.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixTipType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> TipTypeP,
				Description -> "For each member of ResuspensionMixTips, the tip type to use to mix liquid in the manipulation. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix",
				IndexMatching -> ResuspensionMixTips
			},
			ResuspensionMixTipMaterial->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MaterialP,
				Description->"For each member of ResuspensionMixTips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix",
				IndexMatching -> ResuspensionMixTips
			},
			ResuspensionMixMultichannelMix->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description -> "For each member of SampleLink, indicates if multiple device channels should be used when performing pipette mixing. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixDeviceChannel -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> DeviceChannelP,
				Description -> "For each member of SampleLink, the channel of the work cell that should be used to perform the pipetting mixing. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix",
				IndexMatching->SampleLink
			},

			ResuspensionMixResidualIncubation->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates if the incubation and/or mixing should continue after Time/MaxTime has finished while waiting to progress to the next step in the protocol.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixResidualTemperature->{
				Format->Multiple,
				Class->Real,
				Units->Celsius,
				Pattern:>GreaterEqualP[0 Kelvin],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, the temperature at which the sample(s) should remain incubating after Time has elapsed. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixResidualMix->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates that the sample(s) should remain shaking at the ResidualMixRate after Time has elapsed. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixResidualMixRate->{
				Format->Multiple,
				Class->Real,
				Units->RPM,
				Pattern:>GreaterEqualP[0 RPM],
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates the rate at which the sample(s) should remain shaking after Time has elapsed, when mixing by shaking. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			ResuspensionMixPreheat->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				IndexMatching->SampleLink,
				Description->"For each member of SampleLink, indicates if the incubation position should be brought to Temperature before exposing the Sample to it. This option can only be set if Preparation->Robotic.",
				Category->"Resuspension Mix"
			},
			DefinedPellet -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SampleLink, indicates if a pellet is visible after centrifugation.",
				Category -> "Experimental Results",
				IndexMatching -> SampleLink
			},
			SterileTechnique->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if 70% ethanol is to be sprayed on all surfaces/containers used during the transfer. This also indicates if sterile instrument(s) and sterile transfer environment(s) are used for the transfer. Please consult the ExperimentTransfer documentation for a full diagram of SterileTechnique that is employed by operators.",
				Category -> "Transfer Technique"
			}
		}
	}
];
