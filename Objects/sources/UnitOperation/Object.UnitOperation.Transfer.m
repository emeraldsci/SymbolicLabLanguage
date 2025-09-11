(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,Transfer],
	{
		Description->"A detailed set of parameters that specifies a single transfer step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			SourceLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "The sample that we aspirate out of during this transfer.",
				Category -> "General",
				Migration->SplitField
			},
			SourceString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that we aspirate out of during this transfer.",
				Category -> "General",
				Migration->SplitField
			},
			SourceExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {_Integer|_String, _String|ObjectP[{Model[Container], Object[Container]}]},
				Relation -> Null,
				Description -> "The sample that we aspirate out of during this transfer.",
				Category -> "General",
				Migration->SplitField
			},
			SourceLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			SourceContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the source container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},

			SourceSample -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "The sample that is located in our Source, if Source is a Container.",
				Category -> "General",
				Developer -> True
			},
			SourceContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "The container that holds our source, if Source is a Sample.",
				Category -> "General",
				Developer -> True
			},
			(* This is either Source or this is IntermediateContainer. *)
			WorkingSource -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],

					(* NOTE: This is only going to be a Model[Sample] if we're going to use a water purifier. *)
					Model[Sample]
				],
				Description -> "The current container in which our source sample is in, after any intermediate transfers.",
				Category -> "General",
				Developer -> True
			},

			MagnetizationSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],
					Model[Sample],
					Model[Container]
				],
				Description -> "The sample(s)/container(s) that we should place into the magnetic rack at the same time, during this manipulation.",
				Category -> "General",
				Developer -> True
			},

			DestinationLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample],
					Object[Sample],
					Object[Container],
					Model[Container],
					Object[Item]
				],
				Description -> "The sample that we should dispense into, after aspirating from Source.",
				Category -> "General",
				Migration->SplitField
			},
			DestinationString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that we aspirate out of during this transfer.",
				Category -> "General",
				Migration->SplitField
			},
			DestinationExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {_Integer|_String, ObjectP[{Model[Container], Object[Container]}]|_String}|Waste,
				Relation -> Null,
				Description -> "The sample that we aspirate out of during this transfer.",
				Category -> "General",
				Migration->SplitField
			},
			DestinationLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the destination sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},
			DestinationContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The label of the destination container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
				Category -> "General"
			},

			DestinationSample -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Object[Item]
				],
				Description -> "The sample that holds our destination, if Destination is a Container.",
				Category -> "General",
				Developer -> True
			},
			DestinationContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The container that holds our destination, if Destination is a Sample.",
				Category -> "General",
				Developer -> True
			},
			(* This is either Destination or WeighingContainer *)
			WorkingDestination -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Object[Container],
					Object[Item]
				],
				Description -> "The current container to transfer our sample from WorkingSample into.",
				Category -> "General",
				Developer -> True
			},

			AmountVariableUnit -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram],
				Description -> "The amount of that sample that will be transferred from the Source to the corresponding Destination.",
				Category -> "General",
				Migration->SplitField
			},
			AmountInteger -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0, 1],
				Description -> "The amount of that sample that will be transferred from the Source to the corresponding Destination.",
				Category -> "General",
				Migration->SplitField
			},
			AmountExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> All,
				Description -> "The amount of that sample that will be transferred from the Source to the corresponding Destination.",
				Category -> "General",
				Migration->SplitField
			},

			TargetAmount -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Milligram],
				Units -> Milligram,
				Description -> "The total weight of the sample and the weighing container container that should be achieved on the balance during a weight-based transfer. This target is calculated as the sum of the EmptyContainerWeight and the Amount.",
				Category -> "General",
				Developer -> True
			},

			DisplayedAmount -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The Amount as a string, as it will be displayed to the operator in the procedure.",
				Category -> "General",
				Developer -> True
			},
			DisplayedAmountAsVolume -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The Amount, converted to a Volume, as a string, as it will be displayed to the operator in the procedure.",
				Category -> "General",
				Developer -> True
			},

			DisplayedAspirationMixVolume -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The AspirationMixVolume as a string, as it will be displayed to the operator in the procedure.",
				Category -> "General",
				Developer -> True
			},
			DisplayedDispenseMixVolume -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The DispenseMixVolume as a string, as it will be displayed to the operator in the procedure.",
				Category -> "General",
				Developer -> True
			},
			PipetteDialImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "An image that imitates what the dial of the transfer pipette should be set to.",
				Category -> "General",
				Developer -> True
			},
			AspirationMixPipetteDialImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "An image that imitates what the dial of the transfer pipette should be set to during aspiration mix.",
				Category -> "General",
				Developer -> True
			},
			DispenseMixPipetteDialImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "An image that imitates what the dial of the transfer pipette should be set to during dispense mix.",
				Category -> "General",
				Developer -> True
			},
			GraduatedCylinderImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "An image that imitates what the graduated cylinder should look like when filled to the target volume.",
				Category -> "General",
				Developer -> True
			},
			SerologicalPipetteImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "An image that imitates what the serological pipette should look like when filled to the target volume.",
				Category -> "General",
				Developer -> True
			},
			SourceWell->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SourceLink, the desired position in the source container from which our sample will be aspirated.",
				Category -> "General",
				IndexMatching -> SourceLink
			},

			WorkingSourceWell->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The position(s) in the working source container from which our sample will be aspirated.",
				Category -> "General",
				Developer -> True
			},
			WorkingDestinationWell->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The position(s) in the working destination container in which the transferred samples will be placed.",
				Category -> "General",
				Developer -> True
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

			HandlingCondition -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> ObjectP[Model[HandlingCondition]] | {ObjectP[Model[HandlingCondition]]...},
				Description -> "The abstract condition that describes the environment in which the transfer will be performed (Biosafety Cabinet, Fume Hood, Glove Box, or Benchtop Handling Station). This option cannot be set when Preparation->Robotic.",
				Category -> "General",
				Developer -> True
			},

			BiosafetyWasteBin -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Container,WasteBin],Object[Container,WasteBin]],
				Description -> "The waste bin brought into the bio safety cabinet to hold the BiosafetyWasteBag that collect biohazardous waste generated while working in the BSC.",
				Category -> "General"
			},
			BiosafetyWasteBag -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
				Description -> "The waste bag brought into the biosafety cabinet and placed in the BiosafetyWasteBin to collect biohazardous waste generated while working in the BSC.",
				Category -> "General"
			},
			InstrumentLink->{
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
				Category -> "General",
				Migration->SplitField
			},
			InstrumentString->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The instrument used to move the sample from the source container (or from the intermediate container if IntermediateDecant->True) to the destination container.",
				Category -> "General",
				Migration->SplitField
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
				Description -> "Indicates that RNase free technique was followed when performing the transfer (spraying RNase away on surfaces, using RNaseFree tips, etc).",
				Category -> "General"
			},
			Balance->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument,Balance],
					Object[Instrument,Balance]
				],
				Description -> "The balance used to weigh the transfer amount, if the transfer is occurring gravimetrically.",
				Category -> "General",
				Abstract -> True
			},
			TabletCrusher->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, TabletCrusher],
					Object[Item, TabletCrusher]
				],
				Description -> "The pill crusher to crush the itemized samples (if necessary), if the transfer amount is a specific mass.",
				Category -> "General"
			},
			TabletCrusherBag->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, TabletCrusherBag],
					Object[Item, TabletCrusherBag]
				],
				Description -> "The pill crusher bag that will contain the crushed itemized sample after it has been in the pill crusher.",
				Category -> "General"
			},
			(* Sachet handling *)
			IncludeSachetPouch -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicate if the pouch is also transferred to the destination along with the filler. If IncludeSachetPouch -> False, the pouch is directly discarded after emptied.",
				Category -> "General"
			},
			SachetIntermediateContainer -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, WeighBoat],
					Object[Item, WeighBoat]
				],
				Description -> "The container that the filler is emptied into after cutting open the source sachet in order to transfer to the destination, if not transferring gravimetrically.",
				Category->"General"
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
				Description -> "The pipette tips used to aspirate and dispense the requested volume.",
				Category -> "General"
			},
			MultichannelTransfer->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if this transfer will aspirate/dispense multiple samples at the same time, using a multichannel pipette.",
				Category -> "General"
			},
			MultichannelTransferName->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The unique identitifer for the multichannel transfer.",
				Category -> "General",
				Developer->True
			},
			NumberOfMultichannelTips->{
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The number of multichannel pipette tips to attach to the pipette.",
				Category -> "General",
				Developer->True
			},
			TipType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> TipTypeP,
				Description -> "For each member of Tips, the type of pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category -> "General",
				IndexMatching -> Tips
			},
			TipMaterial->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> MaterialP,
				Description -> "For each member of Tips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
				Category -> "General",
				IndexMatching -> Tips
			},
			ReversePipetting->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if additional source sample was aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination position.",
				Category -> "General"
			},
			Supernatant->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Units -> None,
				Description -> "Indicates that only top most layer of the source sample was aspirated when performing the transfer.",
				Category -> "General"
			},
			AspirationLayer->{
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "The layer (counting from the top) of the source sample that was aspirated from when performing the transfer.",
				Category -> "General"
			},
			DisplayedAspirationLayer->{
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The displayed instruction to the operator on how to aspirate from the given aspiration layer.",
				Category -> "General",
				Developer->True
			},
			DestinationLayer->{
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "The layer (counting from the top) of the destination sample that was dispensed into when performing the transfer.",
				Category -> "General"
			},
			DisplayedDestinationLayer->{
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The displayed instruction to the operator on how to dispense from the given destination layer.",
				Category -> "General",
				Developer->True
			},

			Needle->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Needle],
					Object[Item, Needle]
				],
				Description -> "The needle used to aspirate and dispense the requested volume.",
				Category -> "General"
			},
			Funnel->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Part, Funnel],
					Object[Part, Funnel]
				],
				Description -> "The funnel that is used to guide the source sample into the destination container when pouring or using a graduated cylinder.",
				Category -> "General"
			},
			WeighingContainerLink->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container],
					Model[Item],
					Object[Item]
				],
				Description -> "The container that will be placed on the Balance and used to weigh out the specified amount of the source that will be transferred to the destination.",
				Category -> "General",
				Migration->SplitField
			},
			WeighingContainerString->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The container that will be placed on the Balance and used to weigh out the specified amount of the source that will be transferred to the destination.",
				Category -> "General",
				Migration->SplitField
			},
			ReplacedWeighingContainers->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container],
					Model[Item],
					Object[Item]
				],
				Description -> "The container that are originally used to weigh out the specified amount of the source that are to be transferred to the destination but replaced with new ones in event of spillage on balance.",
				Category -> "General"
			},
			Magnetization->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source container was put in a magnetized rack to separate out any magnetic components before the transfer is performed.",
				Category -> "General"
			},
			MagnetizationRack->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Rack],
					Object[Container,Rack],
					Model[Item,MagnetizationRack],
					Object[Item,MagnetizationRack]
				],
				Description -> "The magnetized rack that the source/intermediate container will be placed in before the transfer is performed.",
				Category -> "General"
			},
			UnresolvedMagnetizationRackFromParentProtocol->{
				Format -> Multiple,
				Class -> Expression,
				Relation->Null,
				Pattern :>Automatic|ObjectP[{Model[Item,MagnetizationRack],
				Object[Item,MagnetizationRack]}]|Null,
				Description -> "The user input of the magnetized rack. This info is passed from parent experiment function eventually to the framework, in order to decide if an error should be thrown if Preparation->Robotic, and MagnetizationRack is set to the heavy one \"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\" while also having a Filter unit operation.",
				Developer -> True,
				Category -> "General"
			},
			MagnetizationTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The time that the source sample was left on the magnetic rack until the magnetic components are settled at the side of the container.",
				Category -> "General"
			},
			MaxMagnetizationTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The maximum time that the source sample was left on the magnetic rack until the magnetic components are settled at the side of the container.",
				Category -> "General"
			},
			CollectionContainerString->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "Specifies the container that is stacked on the bottom of the destination container, before the source sample is transferred into the destination container, in order to collect the sample that flows through from the bottom of the destination container and into the CollectionContainer. This option is only available when Preparation->Robotic.",
				Category -> "General",
				Migration->SplitField
			},
			CollectionContainerLink->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "Specifies the container that is stacked on the bottom of the destination container, before the source sample is transferred into the destination container, in order to collect the sample that flows through from the bottom of the destination container and into the CollectionContainer. This option is only available when Preparation->Robotic.",
				Category -> "General",
				Migration->SplitField
			},
			CollectionContainerExpression->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {_Integer, ObjectP[Model[Container]]},
				Description -> "Specifies the container that is stacked on the bottom of the destination container, before the source sample is transferred into the destination container, in order to collect the sample that flows through from the bottom of the destination container and into the CollectionContainer. This option is only available when Preparation->Robotic.",
				Category -> "General",
				Migration->SplitField
			},
			CollectionTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The amount of time that the sample that is transferred into the destination container is allowed to flow through the bottom of the destination plate and into the CollectionContainer (that is stacked on the bottom of the destination container). This option is only available when Preparation->Robotic.",
				Category -> "General"
			},
			WeighingContainerRack->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Rack],
					Object[Container,Rack]
				],
				Description -> "The rack that is used to hold the WeighingContainer upright when it is being weighed, if necessary (ex. 50mL Tube stand).",
				Category -> "General"
			},
			DestinationRack->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,Rack],
					Object[Container,Rack]
				],
				Description -> "The rack that is used to hold the Destination container upright when it is being weighed, if necessary (ex. 50mL Tube stand).",
				Category -> "General"
			},
			Tolerance->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Gram],
				Units -> Gram,
				Description -> "The allowed tolerance of the weighed source sample from the specified amount requested to be transferred.",
				Category -> "General"
			},
			HandPump->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Part, HandPump],
					Object[Part, HandPump]
				],
				Description -> "The hand pump used to get liquid out of the source container.",
				Category -> "General"
			},
			HandPumpAdapter->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Part, HandPumpAdapter],
					Object[Part, HandPumpAdapter]
				],
				Description -> "The part used to connect the handpump to the solvent container in order to transfer liquid out.",
				Category -> "General"
			},
			HandPumpWasteContainer->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that will be used to collect any excess liquid that is still in the hand pump when it is removed from the source container.",
				Category -> "General"
			},
			QuantitativeTransfer->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if additional QuantitativeTransferWashSolution will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General"
			},
			QuantitativeTransferWashSolutionLink->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample],
					Object[Sample]
				],
				Description -> "The solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General",
				Migration->SplitField
			},
			QuantitativeTransferWashSolutionString->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General",
				Migration->SplitField
			},
			QuantitativeTransferWashVolume->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Liter],
				Units -> Milliliter,
				Description -> "The volume of the solution that will be used to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General"
			},
			QuantitativeTransferWashInstrument->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument,Pipette],
					Object[Instrument,Pipette]
				],
				Description -> "The pipette that will be used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General"
			},
			QuantitativeTransferWashTips->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Tips],
					Object[Item, Tips]
				],
				Description -> "The tips that will be used to transfer the wash solution to wash the weigh boat, NumberOfQuantitativeTransferWashes times, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General"
			},
			NumberOfQuantitativeTransferWashes->{
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0],
				Units -> None,
				Description -> "Indicates the number of washes of the weight boat with QuantitativeTransferWashSolution that will occur, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General"
			},
			NumberOfQuantitativeTransferWashesPerformed->{
				Format -> Single,
				Class -> Integer,
				Pattern :> GreaterEqualP[0],
				Units -> None,
				Description -> "Indicates the number of washes of the weight boat with QuantitativeTransferWashSolution that have been performed, to maximize the amount of solid that is transferred from the weigh boat (after measurement) to the destination.",
				Category -> "General",
				Developer -> True
			},
			UnsealHermeticSource->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SourceLink, indicates if the source's hermetic container was unsealed before sample is transferred out of it.",
				Category -> "General",
				IndexMatching -> SourceLink
			},
			UnsealHermeticDestination->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of DestinationLink, indicates if the destination's hermetic container was unsealed before sample is transferred out of it.",
				Category -> "General",
				IndexMatching -> DestinationLink
			},
			BackfillNeedle->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Needle],
					Object[Item, Needle]
				],
				Description -> "The needle used to backfill the source's hermetic container with BackfillGas.",
				Category -> "General"
			},
			BackfillGas->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[
					Nitrogen,
					Argon
				],
				Description -> "The inert gas that is used equalize the pressure in the source's hermetic container while the transfer out of the source's container occurs.",
				Category -> "General"
			},
			VentingNeedle->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Item, Needle],
					Object[Item, Needle]
				],
				Description -> "The needle that is used equalize the pressure in the destination's hermetic container while the transfer into the destination's container occurs.",
				Category -> "General"
			},
			TipRinse->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the Tips should first be rinsed with a TipRinseSolution before they are used to aspirate from the source sample.",
				Category -> "General"
			},
			TipRinseSolutionLink->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Sample],
					Object[Sample]
				],
				Description -> "The solution that the Tips was rinsed before they are used to aspirate from the source sample.",
				Category -> "General",
				Migration->SplitField
			},
			TipRinseSolutionString->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The solution that the Tips was rinsed before they are used to aspirate from the source sample.",
				Category -> "General",
				Migration->SplitField
			},
			TipRinseVolume->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Liter],
				Units -> Milliliter,
				Description -> "The volume of the solution that the Tips was rinsed before they are used to aspirate from the source sample.",
				Category -> "General"
			},
			NumberOfTipRinses->{
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0],
				Units -> None,
				Description -> "The number of times that the Tips was rinsed before they are used to aspirate from the source sample.",
				Category -> "General"
			},
			SlurryTransfer->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source sample should be mixed via pipette until it becomes homogenous, up to MaxNumberOfAspirationMixes times.",
				Category -> "General"
			},
			AspirationMix->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should occur during aspiration from the source sample.",
				Category -> "General"
			},
			AspirationMixType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Swirl|Pipette|Tilt,
				Description -> "For each member of AspirationMix, the type of mixing that should occur during aspiration.",
				Category -> "General",
				IndexMatching -> AspirationMix
			},
			NumberOfAspirationMixes->{
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterEqualP[0],
				Units -> None,
				Description -> "For each member of AspirationMix, the number of times that the source sample was mixed during aspiration.",
				Category -> "General",
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
			AspirationMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of AspirationMix, the volume quickly aspirated and dispensed to mix the source sample before it is aspirated.",
				Category -> "General",
				IndexMatching -> AspirationMix
			},
			DispenseMix->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if mixing should occur after the sample is dispensed into the destination container.",
				Category -> "General"
			},
			DispenseMixType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Swirl|Pipette|Tilt,
				Description -> "For each member of DispenseMix, the type of mixing that should occur after the sample is dispensed into the destination container.",
				Category -> "General",
				IndexMatching -> DispenseMix
			},
			NumberOfDispenseMixes->{
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "For each member of DispenseMix, the number of times that the destination sample was mixed after the source sample is dispensed into the destination container.",
				Category -> "General",
				IndexMatching -> DispenseMix
			},
			DispenseMixVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter],
				Units -> Microliter,
				Description -> "For each member of DispenseMix, the volume quickly aspirated and dispensed to mix the destination sample after the source sample is dispensed into the destination container.",
				Category -> "General",
				IndexMatching -> DispenseMix
			},

			IntermediateDecant->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source will need to be decanted into an intermediate container in order for the precise amount requested to be transferred via pipette. Intermediate decants are necessary if the container geometry prevents the Instrument from reaching the liquid level of the sample in the container (plus the delta of volume that is to be transferred). The container geometry is automatically calculated from the inverse of the volume calibration function when the container is parameterized upon receiving.",
				Category -> "General"
			},
			IntermediateContainerLink->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container],
					Object[Container]
				],
				Description -> "The container that the source will be decanted into in order to make the final transfer via pipette into the final destination.",
				Category -> "General",
				Migration->SplitField
			},
			IntermediateContainerString->{
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The container that the source will be decanted into in order to make the final transfer via pipette into the final destination.",
				Category -> "General",
				Migration->SplitField
			},
			IntermediateFunnel->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Part, Funnel],
					Object[Part, Funnel]
				],
				Description -> "The funnel that is used to guide the source sample into the intermediate container when pouring.",
				Category -> "General"
			},
			IntermediateDecantRecoup -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if any residual sample transferred into the intermediate container is transferred back to the source sample.",
				Category -> "General"
			},
			DisplayedDecantAmountAsVolume -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The amount to transfer into intermediate container, converted to a Volume, as a string, as it will be displayed to the operator in the procedure.",
				Category -> "General",
				Developer -> True
			},
			IntermediateContainerImage -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[EmeraldCloudFile],
				Description -> "An image that imitates what the intermediate container should look like when filled to the target decant volume.",
				Category -> "General",
				Developer -> True
			},

			SourceTemperatureReal->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "Indicates the temperature at which the source was at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
				Category -> "Temperature Equilibration",
				Migration->SplitField
			},
			SourceTemperatureExpression->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, Cold],
				Description -> "Indicates the temperature at which the source was at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
				Category -> "Temperature Equilibration",
				Migration->SplitField
			},
			SourceTemperatureStartDate->{
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The start date at which we started to equilibrate our source solution. (Used to determine when the timeout is hit).",
				Category -> "Temperature Equilibration",
				Developer -> True
			},
			SourceEquilibrationTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The duration of time for which the samples will be heated/cooled to the target SourceTemperature.",
				Category -> "Temperature Equilibration"
			},
			MaxSourceEquilibrationTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The maximum duration of time for which the samples will be heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime.",
				Category -> "Temperature Equilibration"
			},
			SourceEquilibrationCheck->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> EquilibrationCheckP,
				Description -> "The method by which to verify the temperature of the source before the transfer is performed.",
				Category -> "Temperature Equilibration"
			},
			DestinationTemperatureReal->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Kelvin],
				Units -> Celsius,
				Description -> "Indicates the temperature at which the source was at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
				Category -> "Temperature Equilibration",
				Migration->SplitField
			},
			DestinationTemperatureExpression->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Ambient, Cold],
				Description -> "Indicates the temperature at which the source was at during the transfer. When samples are transferred off of the operator cart and into the TransferEnvironment, they are placed in a portable heater/cooler to get the sample to temperature right before the transfer occurs. Note that this is different than the TransportCondition of the sample.",
				Category -> "Temperature Equilibration",
				Migration->SplitField
			},
			DestinationTemperatureStartDate->{
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "The start date at which we started to equilibrate our source solution. (Used to determine when the timeout is hit).",
				Category -> "Temperature Equilibration",
				Developer -> True
			},
			DestinationEquilibrationTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The duration of time for which the samples will be heated/cooled to the target SourceTemperature.",
				Category -> "Temperature Equilibration"
			},
			IntermediateEquilibrationTime->{
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The duration of time, equal to the absolute difference between the SourceEquilibrationTime and DestinationEquilibrationTime, for which the source or destination sample will be heated/cooled the SourceTemperature/DestinationTemperature before also heating/cooling the destination or source to the DestinationTemperature/SourceTemperature.",
				Category -> "Temperature Equilibration",
				Developer->True
			},
			MaxDestinationEquilibrationTime->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Second],
				Units -> Minute,
				Description -> "The maximum duration of time for which the samples will be heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime.",
				Category -> "Temperature Equilibration"
			},
			DestinationEquilibrationCheck->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> EquilibrationCheckP,
				Description -> "The method by which to verify the temperature of the source before the transfer is performed.",
				Category -> "Temperature Equilibration"
			},
			DestinationIncubationDevice ->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Instrument] | Object[Instrument],
				Description -> "The portable heater/cooler used to maintain the Destinations at the DestinationTemperatures in this Transfer.",
				Category -> "Temperature Equilibration",
				Developer -> True
			},
			SourceIncubationDevice ->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Instrument] | Object[Instrument],
				Description -> "The portable heater/cooler used to maintain the Sources at the SourceTemperature in this Transfer.",
				Category -> "Temperature Equilibration",
				Developer -> True
			},
			CoolingTime ->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Second],
				Units -> Minute,
				Description -> "Specifies the length of time that should elapse after the transfer before the sample is removed from the TransferEnvironment.",
				Category -> "Temperature Equilibration",
				Developer -> True
			},
			SolidificationTime ->{
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0*Second],
				Units -> Minute,
				Description -> "The duration of time after transferring the liquid media into incubation plates that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments.",
				Category -> "Temperature Equilibration",
				Developer -> True
			},
			FlameDestination ->{
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
				Relation -> Model[Part,Lighter]|Object[Part,Lighter],
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
				Description -> "Indicates if this transfer is resuspending a solid. If True, liquid will be dispensed at the top of the destination's container.",
				Category -> "Pipetting Parameters"
			},
			AspirationRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid was drawn up into the pipette tip.",
				Category -> "Pipetting Parameters"
			},
			OverAspirationVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
				Category -> "Pipetting Parameters"
			},
			AspirationWithdrawalRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
				Category -> "Pipetting Parameters"
			},
			AspirationEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
				Category -> "Pipetting Parameters"
			},
			AspirationMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
				Category -> "Pipetting Parameters"
			},
			AspirationPosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be aspirated. Top will aspirate AspirationPositionOffset below the Top of the container, Bottom will aspirate AspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate AspirationPositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified AspirationPositionOffset above the bottom of the container to start aspirate the sample.",
				Category -> "Pipetting Parameters"
			},
			AspirationPositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				Description -> "The distance from the center of the well that liquid will aspirated. When specifying a Z Offset, the Z Offset is calculated either as the height below the top of the well, the height above the bottom of the well, or the height below the detected liquid level, depending on value of the AspirationPosition option (Top|Bottom|LiquidLevel). When an AspirationAngle is specified, the AspirationPositionOffset is measured in the frame of reference of the tilted labware (so that wells that are further away from the pivot point of the tilt are in the same frame of reference as wells that are close to the pivot point of the tilt).",
				Category -> "Pipetting Parameters"
			},
			AspirationAngle -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the source container will be tilted during the aspiration of liquid. The container is pivoted on its left edge when tilting occurs.",
				Category -> "Pipetting Parameters"
			},

			(* Dispense Parameters *)
			DispenseRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid was expelled from the pipette tip.",
				Category -> "Pipetting Parameters"
			},
			OverDispenseVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description -> "The volume of air drawn blown out at the end of the dispensing of a liquid.",
				Category -> "Pipetting Parameters"
			},
			DispenseWithdrawalRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Millimeter/Second],
				Units -> Millimeter/Second,
				Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
				Category -> "Pipetting Parameters"
			},
			DispenseEquilibrationTime -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
				Category -> "Pipetting Parameters"
			},
			DispenseMixRate -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Microliter/Second],
				Units -> Microliter/Second,
				Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
				Category -> "Pipetting Parameters"
			},
			DispensePosition -> {
				Format -> Multiple,
				Class -> Expression,
				(* Top | Bottom | LiquidLevel *)
				Pattern :> PipettingPositionP,
				Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
				Category -> "Pipetting Parameters"
			},
			DispensePositionOffset -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> GreaterEqualP[0 Millimeter]|Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				Description -> "The distance from the center of the well that liquid will dispensed. When specifying a Z Offset, the Z Offset is calculated either as the height below the top of the well, the height above the bottom of the well, or the height below the detected liquid level, depending on value of the DispensePosition option (Top|Bottom|LiquidLevel). When an DispenseAngle is specified, the DispensePositionOffset is measured in the frame of reference of the tilted labware (so that wells that are further away from the pivot point of the tilt are in the same frame of reference as wells that are close to the pivot point of the tilt).",
				Category -> "Pipetting Parameters"
			},
			DispenseAngle -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 AngularDegree, 10 AngularDegree, 1 AngularDegree],
				Units -> AngularDegree,
				Description -> "The angle that the destination container will be tilted during the dispensing of liquid. The container is pivoted on its left edge when tilting occurs.",
				Category -> "Pipetting Parameters"
			},

			CorrectionCurve -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}..}|Null,
				Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. The correction curve is derived empirically from the relationship between the target and actual amount of volume transferred when on a specific robotic liquid handler instrument model. It is recommended when building one of these curves to measure the volume of sample transferred gravimetrically to get a more accurate CorrectionCurve. Use the function UploadPipettingMethod to create a new pipetting method for a sample model to have all robotic transfers of this sample model to use the derived CorrectionCurve automatically.",
				Category -> "Pipetting Parameters"
			},
			PipettingMethod -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Method,Pipetting],
				Description -> "The pipetting parameters used to manipulate the sample in each transfer.",
				Category -> "Pipetting Parameters"
			},
			DynamicAspiration -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if droplet formation was prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
				Category -> "Pipetting Parameters"
			},


			(* Multiprobe head-specific keys required for MxN transfers *)
			MultiProbeHeadNumberOfRows->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[0,8,1],
				Description->"The number of rows used for this manipulation with the multiprobe head.",
				Category->"Pipetting Parameters",
				Developer->True
			},
			MultiProbeHeadNumberOfColumns->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[0,12,1],
				Description->"The number of columns used for this manipulation with the multiprobe head.",
				Category->"Pipetting Parameters",
				Developer->True
			},
			MultiProbeAspirationOffsetRows->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[-16,1,1],
				Description->"The row offset used for the aspiration with the multiprobe head (0 means that A1 of the multiprobe head will aspirate from A1 of the plate, 1 means that A1 of the multiprobe head will aspirate from B1, -1 means that B1 of the multiprobe head will aspirate from the A1 of the plate).",
				Category->"Pipetting Parameters",
				Developer->True
			},
			MultiProbeAspirationOffsetColumns->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[-24,1,1],
				Description->"The column offset used for the aspiration with the multiprobe head (0 means that A1 of the multiprobe head will aspirate from A1 of the plate, 1 means that A1 of the multiprobe head will aspirate from A2, -1 means that A2 of the multiprobe head will aspirate from the A1 of the plate).",
				Category->"Pipetting Parameters",
				Developer->True
			},
			MultiProbeDispenseOffsetRows->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[-16,1,1],
				Description->"The row offset used for dispensing with the multiprobe head (0 means that A1 of the multiprobe head will dispense into A1 of the plate, 1 means that A1 of the multiprobe head will dispense into B1 of the plate, -1 means that B1 of the multiprobe head will dispense into A1 of the plate).",
				Category->"Pipetting Parameters",
				Developer->True
			},
			MultiProbeDispenseOffsetColumns->{
				Format->Multiple,
				Class->Real,
				Pattern:>RangeP[-24,1,1],
				Description->"The column offset used for dispensing with the multiprobe head (0 means that A1 of the multiprobe head will dispense into A1 of the plate, 1 means that A1 of the multiprobe head will dispense into A2 of the plate, -1 means that A2 of the multiprobe head will dispense into A1 of the plate).",
				Category->"Pipetting Parameters",
				Developer->True
			},
			TipAdapter->{
				Format-> Single,
				Class-> Link,
				Pattern:> _Link,
				Relation->Alternatives[
					Model[Item],
					Object[Item]
				],
				Description->"Tips adapter used in this manipulation for offset tip pickup by the multiprobe head.",
				Category->"Placements",
				Developer->True
			},

			KeepSourceCovered -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the cover on the source container should be \"peaked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers in order to reduce chances of contamination or minimize light exposure. When performing robotic manipulations, this indicates that the container should be re-covered after the transfer is complete.",
				Category -> "Container Covering"
			},
			ReplaceSourceCover -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the cover on the source container was replaced at the end of the transfer with a new type of cover. If set to False, the previous cover (or a new instance of the previous cover if the previous cover is not reusable) will be used to cover the container after the transfer occurs.",
				Category -> "Container Covering"
			},
			AllowSourceContainerReCover -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source container was not re-coverable once uncovered and therefore will not be in ContainersToCover at the end of a BatchedUnitOperations group.",
				Category -> "Container Covering"
			},
			DiscardSourceContainerAndCover->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source container and its cover are discarded after transferring the sample out during ths unit operation.",
				Category -> "Container Covering"
			},
			SourceCover -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives@@Join[CoverObjectTypes, CoverModelTypes],
				Description -> "The new cover that was placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous cover was used.",
				Category -> "Container Covering"
			},
			SourceSeptum -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Item, Septum], Object[Item, Septum]],
				Description -> "The new septum that was placed on the source container after the transfer occurs. By default, this option is set to Null which indicates that the previous septum was used (if there was previously a septum on the container).",
				Category -> "Container Covering"
			},
			SourceStopper -> {
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
			ReplaceDestinationCover -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the cover on the destination container was replaced at the end of the transfer with a new type of cover. If set to False, the previous cover (or a new instance of the previous cover if the previous cover is not reusable) will be used to cover the container after the transfer occurs.",
				Category -> "Container Covering"
			},
			DestinationCover -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives@@Join[CoverObjectTypes, CoverModelTypes],
				Description -> "The new cover that was placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous cover was used.",
				Category -> "Container Covering"
			},
			DestinationSeptum -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Item, Septum], Object[Item, Septum]],
				Description -> "The new septum that was placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous septum was used (if there was previously a septum on the container).",
				Category -> "Container Covering"
			},
			DestinationStopper -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Item, Stopper], Object[Item, Stopper]],
				Description -> "The new stopper that was placed on the destination container after the transfer occurs. By default, this option is set to Null which indicates that the previous stopper was used (if there was previously a stopper on the container).",
				Category -> "Container Covering"
			},

			RestrictSource -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether the source was restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member).",
				Category -> "Sample Post-Processing"
			},
			RestrictDestination -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether the destination was restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member).",
				Category -> "Sample Post-Processing"
			},

			(* This field is only populated for volumetric flask transfers *)
			(* This is a single field because when called by FillToVolume, we only have one transfer in the UnitOperation (no multi-channel transfer) *)
			TargetVolumeToleranceAchieved -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For Volumetric FillToVolume transfer, indicates whether the final sample volume reaches the graduation line of the volumetric flask without exceeding it. If the volume is below the line, additional solvent is added. A TargetVolumeToleranceAchieved value of False indicates that the liquid level has gone above the graduation line.",
				Category -> "Fill to Volume"
			},
			LiquidLevelDetector -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, LiquidLevelDetector],
					Object[Instrument, LiquidLevelDetector]
				],
				Description -> "The instrument that will be used to measure the volume of the source sample after transferring into a volumetric flask if Instrument is a pipette.",
				Category -> "Fill to Volume"
			},
			PostVolumetricFlaskMeasureVolume -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Protocol, MeasureVolume],
				Description -> "The MeasureVolume protocol used to measure the volume of the source sample after transferring into a volumetric flask if Instrument is a pipette.",
				Category -> "Fill to Volume"
			},

			(* NOTE: These three fields are used to minimize the amount of movements that we do to/from the TransferEnvironment. *)
			CapRacks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container, Rack],
					Object[Container, Rack]
				],
				Description -> "The cap racks that should be moved into the biosafety cabinet at the beginning of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			MovementObjects->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Object[Item],
					Object[Sample],
					Object[Instrument],
					Object[Part]
				],
				Description -> "The objects that was moved onto the TransferEnvironment's work surface at the beginning of this primitive. Note that this excludes everything that is going into a biosafety cabinet; those are handled separately since those need to use the placement task, not the movement task.",
				Category -> "General",
				Developer -> True
			},
			BiosafetyCabinetPlacements -> {
				Format -> Multiple,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {
					Alternatives[
						Object[Container],
						Object[Item],
						Object[Sample],
						Object[Instrument],
						Object[Part]
					],
					Alternatives[Object[Instrument, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]],
					Null
				},
				Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
				Description -> "The specific positions into which objects should be moved into the transfer environment's biosafety cabinet at the beginning of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			BiosafetyWasteBinPlacements -> {
				Format -> Multiple,
				Class -> {Link, Link, String},
				Pattern :> {_Link, _Link, LocationPositionP},
				Relation -> {
					Alternatives[
						Object[Container,WasteBin],
						Model[Container,WasteBin],
						Object[Item,Consumable],
						Model[Item,Consumable]
					],
					Alternatives[
						Object[Instrument,BiosafetyCabinet],
						Model[Instrument,BiosafetyCabinet],
						Object[Instrument,HandlingStation,BiosafetyCabinet],
						Model[Instrument,HandlingStation,BiosafetyCabinet],
						Object[Container,WasteBin],
						Model[Container,WasteBin]
					],
					Null
				},
				Headers -> {"Objects to move", "Object to move to", "Position to move to"},
				Description -> "The specific positions into which waste bin objects should be moved into the biosafety cabinet at the beginning of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			BiosafetyWasteBinTeardowns -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Object[Container],
					Model[Container],
					Object[Item,Consumable],
					Model[Item,Consumable]
				],
				Description -> "The specific items that should be removed from the biosafety cabinet at the end of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			CollectionObjects->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Object[Item],
					Object[Sample],
					Object[Instrument],
					Object[Part]
				],
				Description -> "The objects that was moved from the TransferEnvironment's work surface back onto the cart at the end of this primitive.",
				Category -> "General",
				Developer -> True
			},
			CollectionItems->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Object[Item],
					Object[Sample],
					Object[Part]
				],
				Description -> "The non-instrument objects that was moved from the TransferEnvironment's work surface back onto the cart at the end of this primitive.",
				Category -> "General",
				Developer -> True
			},
			CollectionInstruments->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument],
				Description -> "The instrument objects that was moved from the TransferEnvironment's work surface back onto the cart at the end of this primitive.",
				Category -> "General",
				Developer -> True
			},
			StoredObjects->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Object[Item],
					Object[Sample],
					Object[Part]
				],
				Description -> "Devices used to complete transfers in the current transfer environment that are stored at the end of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			DiscardedObjects->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Object[Item],
					Object[Sample],
					Object[Part]
				],
				Description -> "Devices used to complete transfers in the current transfer environment that are discarded at the end of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			ReleasedInstruments->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument],
				Description ->"Instruments used to complete transfers in the current transfer environment that are released at the end of this unit operation.",
				Category -> "General",
				Developer -> True
			},
			PlateTilter -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, PlateTilter],
					Object[Instrument, PlateTilter]
				],
				Description -> "The robotically integrated plate tilter that will tilt the plates during the course of the transfer, if plate tilting is requested.",
				Category -> "General",
				Developer -> True
			},

			PercentTransferred -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Percent],
				Units -> Percent,
				Description -> "The operator estimated percentage of mass/volume that was transferred from the source to the destination, in relation to the user specified Amount. The percent transferred will be less than 100% if there was not enough volume/mass in the source sample.",
				Category -> "Experimental Results"
			},
			PercentTransferredString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The operator estimated percentage of mass/volume that was transferred from the source to the destination, in relation to the user specified Amount. The percent transferred will be less than 100% if there was not enough volume/mass in the source sample. This is string input due to operators inputting the value in a multiple choice task. The value is later converted to PercentTransferred which is a Real.",
				Category -> "Experimental Results",
				Developer -> True
			},
			HomogeneousSlurryTransfer -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if the source sample was able to become fully homogeneous via aspiration mixing (mixing up to MaxNumberOfAspirationMixes times) before the slurry transfer occurred. This data is recorded by the operator if the transfer is set as a SlurryTransfer.",
				Category -> "Experimental Results"
			},

			(* NOTE: These need to be Multiple for UnitOperationType->Output which can be executed via multiple Batched UOs. *)
			TareData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Weight],
				Description -> "The weight measurement data recorded with nothing on the balance and after zeroing the reading. This data should always be 0 Gram.",
				Category -> "Experimental Results"
			},
			TareWeights -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Milligram],
				Units -> Milligram,
				Description -> "The weight recorded with nothing on the balance and after zeroing the reading. This data should always be 0 Gram.",
				Category -> "Experimental Results"
			},
			TareWeightAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Appearance],
				Description -> "The side on image of the weighing surface of the balance, captured immediately following the weight measurement of TareData by the integrated camera.",
				Category -> "Experimental Results"
			},

			EmptyContainerWeightData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Weight],
				Description -> "The weight measurement data of the weigh container when empty and before any incoming sample transfer has commenced.",
				Category -> "Experimental Results"
			},
			EmptyContainerWeights -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Milligram],
				Units -> Milligram,
				Description -> "The weight of the weigh container when empty and before any incoming sample transfer has commenced.",
				Category -> "Experimental Results"
			},
			EmptyContainerWeightAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Appearance],
				Description -> "The side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of EmptyContainerWeightData by the integrated camera.",
				Category -> "Experimental Results"
			},

			MeasuredTransferWeightData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Weight],
				Description -> "The weight measurement data of the weighing container when filled with the amount of sample needed to complete the transfer.",
				Category -> "Experimental Results"
			},
			MeasuredTransferWeights -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Milligram],
				Units -> Milligram,
				Description -> "The weight of the weighing container when filled with the amount of sample needed to complete the transfer.",
				Category -> "Experimental Results"
			},
			MeasuredTransferWeightAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Appearance],
				Description -> "The side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of MeasuredTransferWeightData by the integrated camera.",
				Category -> "Experimental Results"
			},

			MaterialLossWeightData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Weight],
				Description -> "The weight measurement data recorded after the weighing container is removed from the balance. This measurement accounts for any material lost onto the balance pan during the transfer process.",
				Category -> "Experimental Results"
			},
			MaterialLossWeights -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Milligram],
				Units -> Milligram,
				Description -> "The weight recorded after the weighing container is removed from the balance. This weight accounts for any material lost onto the balance pan during the transfer process.",
				Category -> "Experimental Results"
			},
			MaterialLossWeightAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Appearance],
				Description -> "The side on image of the weighing surface of the balance, captured immediately following the weight measurement of MaterialLossWeightData by the integrated camera.",
				Category -> "Experimental Results"
			},

			ResidueWeightData -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Weight],
				Description -> "The weight measurement data of the weighing container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container.",
				Category -> "Experimental Results"
			},
			ResidueWeights -> {
				Format -> Multiple,
				Class -> Distribution,
				Pattern :> DistributionP[Milligram],
				Units -> Milligram,
				Description -> "The weight of the weighing container after weighing is complete and the sample has been transferred out, leaving behind possible residue in the container.",
				Category -> "Experimental Results"
			},
			ResidueWeightAppearances -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data, Appearance],
				Description -> "The side on image of the weighing surface of the balance and its contents, captured immediately following the weight measurement of ResidueWeightData by the integrated camera.",
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
			AspirationDate->{
				Format->Multiple,
				Class->Date,
				Pattern:>_?DateObjectQ,
				Description->"The date at which we aspirated our source solution.",
				Category->"Pipetting Parameters"
			},
			AspirationPressure->{
				Format->Multiple,
				Class->QuantityArray,
				Pattern:>QuantityArrayP[{{Second,Pascal}..}],
				Description->"The pressure data measured by the liquid handler during aspiration of the source samples.",
				Category->"Pipetting Parameters"
			},
			AspirationLiquidLevelDetected -> {
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates whether the liquid level of the source sample was successfully detected before aspiration was performed. If the liquid level was not successfully detected, the aspiration occurred 2mm from the bottom of the source container.",
				Category->"Pipetting Parameters"
			},
			AspirationErrorMessage -> {
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"The error message that the Hamilton firmware threw during aspiration from the source sample. If error messages are thrown during aspiration, the aspiration is retried from 2mm above the bottom of the source container.",
				Category->"Pipetting Parameters"
			},
			AspirationDetectedLiquidLevel -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units -> Microliter,
				Description->"The estimated amount of liquid before the aspiration occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if AspirationPosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
				Category->"Pipetting Parameters"
			},
			DispenseDate->{
				Format->Multiple,
				Class->Date,
				Pattern:>_?DateObjectQ,
				Description->"The date at which we dispensed our source solution.",
				Category->"Pipetting Parameters"
			},
			DispensePressure->{
				Format->Multiple,
				Class->QuantityArray,
				Pattern:>QuantityArrayP[{{Second,Pascal}..}],
				Description->"The pressure data measured by the liquid handler during dispensing of the source samples.",
				Category->"Pipetting Parameters"
			},
			DispenseLiquidLevelDetected -> {
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"Indicates whether the liquid level of the destination sample was successfully detected before dispense was performed. If the liquid level was not successfully detected, the dispense occurred 2mm from the bottom of the destination container.",
				Category->"Pipetting Parameters"
			},
			DispenseErrorMessage -> {
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Description->"The error message that the Hamilton firmware threw during dispense from the destination sample. If error messages are thrown during dispense, the dispense is retried from 2mm above the bottom of the destination container.",
				Category->"Pipetting Parameters"
			},
			DispenseDetectedLiquidLevel -> {
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0 Microliter],
				Units -> Microliter,
				Description->"The estimated amount of liquid before the dispense occurred, as calculated from the detected liquid level height and container geometry. This can only be estimated if DispensePosition is set to LiquidLevel and is a very coarse estimate that should only be used qualitatively.",
				Category->"Pipetting Parameters"
			},
			RentDestinationContainer->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SourceLink, Indicates if the container model resource requested for this transfer should be rented when this experiment is performed.",
				IndexMatching -> SourceLink,
				Category -> "General",
				Developer -> True
			},

			LivingDestination->{
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "For each member of SourceLink, indicates if the typical rules for setting the Living field of the Destination will be followed, or if the Living field of the Destination will be set to False regardless of the state of the Living field of the source and destination initially. See the UploadSampleTransfer helpfile for more information on the 'typical rules' for setting the Living field.",
				IndexMatching -> SourceLink,
				Category -> "General",
				Developer -> True
			},

			(* NOTE: These fields are filled out via populateContainersToUncover and is used to batch uncover several containers at once. *)
			(* This function will look 10 transfers ahead within the same transfer environment and get all the containers to be used to *)
			(* uncover them at once (which is more efficient for the operator). *)
			ContainersToCover->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The containers that will be uncovered during this unit operation.",
				Category -> "General",
				Developer -> True
			},
			ContainersToUncover->{
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The containers that will be uncovered during this unit operation.",
				Category -> "General",
				Developer -> True
			},
			AspirationClassifications -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> (Success | Failure),
				Description -> "For each member of AspirationPressure, the resulting classifications of a machine learning model that categorized the success or failure of the aspiration step of the transfer from the pressure data of the aspiration.",
				Category -> "Simulation Results",
				IndexMatching -> AspirationPressure
			},
			AspirationClassificationConfidences -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent,
				Description -> "For each member of AspirationPressure, the confidence (on a scale of 0-100%) of the machine learning model result that classified the success or failure of the aspiration step of the transfer. A higher confidence value means that the corresponding categorization in AspirationClassifications is more likely to be correct.",
				Category -> "Simulation Results",
				IndexMatching -> AspirationPressure
			},
			PipetteDialPicture -> {
 				Format -> Single,
 				Class -> Link,
 				Pattern :> _Link,
 				Relation -> Object[Data, Appearance],
 				Description -> "The image of the dial of the transfer pipette that was set to.",
 				Category -> "General"
 			},
 			AspirationMixPipetteDialPicture -> {
 				Format -> Single,
 				Class -> Link,
 				Pattern :> _Link,
 				Relation -> Object[Data, Appearance],
 				Description -> "The image of the dial of the transfer pipette that was set to during aspiration mix.",
 				Category -> "General"
 			},
 			DispenseMixPipetteDialPicture -> {
 				Format -> Single,
 				Class -> Link,
 				Pattern :> _Link,
 				Relation -> Object[Data, Appearance],
 				Description -> "The image of the dial of the transfer pipette that was set to during dispense mix.",
 				Category -> "General"
			},
			BalanceCleaningMethod ->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Wet,Dry],
				Description ->  "Indicates the type of cleaning performed on the balance right before a weighing instance if the operator indicates presence of stray material. Dry indicates the balance pan surface and the balance floor outside of the balance pan is cleared of any stray material using soft and lint-free non-woven wipes. Wet indicates the balance pan surface and the balance floor outside of the balance pan is first cleaned with Dry method, followed by wiping with DI-water moistened wipes, IPA-moistened wipes, and a final dry wipe. None indicates no cleaning is performed prior to initial setup.",
				Category -> "General"
			},
			BalancePreCleaningMethod ->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Wet,Dry,None],
				Description ->  "Indicates the type of cleaning performed on the balance right before a weighing instance if the operator indicates presence of stray material. Dry indicates the balance pan surface and the balance floor outside of the balance pan is cleared of any stray material using soft and lint-free non-woven wipes. Wet indicates the balance pan surface and the balance floor outside of the balance pan is first cleaned with Dry method, followed by wiping with DI-water moistened wipes, IPA-moistened wipes, and a final dry wipe. None indicates no cleaning is performed prior to initial setup.",
				Category -> "General"
			},
			OverdrawVolume -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Milliliter],
				Units -> Milliliter,
				Description -> "When performing a syringe transfer, the amount with which to fill the syringe with to allow for the removal of air from the syringe body, determined by adding the specified Amount and a calculated extra volume based on the needle and syringe used.",
				Category -> "General"
			},
			OverdrawVolumeWasteContainer -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container, Vessel],
					Model[Container, Vessel]
				],
				Description -> "The vessel to hold any extraneous discarded sample when expelling air or bringing the sample volume to the target amount after overdrawing.",
				Category -> "General"
			}
		}
	}
];
