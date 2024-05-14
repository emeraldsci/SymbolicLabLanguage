(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, FillToVolume], {
	Description -> "The information that specifies the information of how to perform a single fill to volume operation adding a solvent to a destination",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Transfers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, Transfer],
				Object[Protocol, ManualSamplePreparation]
			],
			Description -> "The Transfer protocols that transferred the amount going into the Destination.",
			Category -> "Fill to Volume"
		},
		TransferUnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation, Transfer],
			Description -> "For each member of Transfers, the Transfer unit operation that contained the instructions for transferring sample into the Destination.",
			Category -> "Fill to Volume",
			IndexMatching -> Transfers
		},
		(* these are fields that match the option patterns exactly *)
		Method -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FillToVolumeMethodP,
			Description -> "For each member of SolventLink, the method by which to add the Solvent to the bring the input sample up to the TotalVolume.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		SolventLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container, Vessel]
			],
			Description -> "Source solvent to be transferred into the destination for this experiment.",
			Category -> "General",
			Migration -> SplitField
		},
		SolventString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, source solvent to be transferred into the destination for this experiment.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SolventContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "For each member of SolventLink, solvent container for this fill to volume.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SolventContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SolventLink, solvent container for this fill to volume.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SolventLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, the label of the solvent sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		SolventContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, the label of the solvent container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
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
			Description -> "For each member of SolventLink, input samples for this analytical or preparative experiment.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SolventLink, input samples for this analytical or preparative experiment.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "For each member of SolventLink, input samples for this analytical or preparative experiment.",
			Category -> "General",
			Migration->SplitField,
			IndexMatching -> SolventLink
		},
		SampleContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "For each member of SolventLink, the container in which the fill to volume will occur.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SampleContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SolventLink, the container in which the fill to volume will occur.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, the label of the sample to which solvent will be added in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, the label of the container to which solvent will be added in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		TotalVolume -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * Milliliter],
			Description -> "For each member of SolventLink, the total amount of the sample after all solvent is added to the Destination.",
			Category -> "Fill to Volume",
			Abstract -> True,
			IndexMatching -> SolventLink
		},
		GraduationFillings -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the Solvent specified in the stock solution model is added to bring the stock solution model up to the TotalVolume based on the horizontal markings on the container indicating discrete volume levels, not necessarily in a volumetric flask."
		},
		Tolerance -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> UnitsP[Milliliter] | UnitsP[Percent],
			Description -> "For each member of SolventLink, the allowed tolerance of the final volume.  If the sample's volume reaches the specified volume +/- this value then no more Solvent will be added.  If the sample's volume is below the specified volume +/- this value then more Solvent will be added.",
			Category -> "Instrument Specifications",
			IndexMatching -> SolventLink
		},
		SolventStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Disposal,
			IndexMatching -> Solvents,
			Description -> "For each member of SolventLink, the storage conditions under which each solvent used by this experiment should be stored after the protocol is completed.",
			Category -> "Sample Storage",
			IndexMatching -> SolventLink
		},
		LiquidLevelDetector -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, LiquidLevelDetector],
				Object[Instrument, LiquidLevelDetector]
			],
			Description -> "For each member of SolventLink, the instrument that will be used to measure the volume of the solution ultrasonically if Method -> Ultrasonic.",
			Category -> "Fill to Volume",
			IndexMatching -> SolventLink
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Model[Container, GraduatedCylinder],
				Model[Instrument, Pipette],
				Model[Instrument, Aspirator],
				Model[Item, Spatula],
				Model[Item, Tweezer],
				Model[Item, TransferTube],
				Model[Item, ChippingHammer],
				Model[Item, Scissors],

				Object[Container, Syringe],
				Object[Container, GraduatedCylinder],
				Object[Instrument, Pipette],
				Object[Instrument, Aspirator],
				Object[Item, Spatula],
				Object[Item, Tweezer],
				Object[Item, TransferTube],
				Object[Item, ChippingHammer],
				Object[Item, Scissors]
			],
			Description -> "For each member of SolventLink, the instrument used to move the sample from the source container (or from the intermediate container if IntermediateDecant->True) to the destination container.",
			Category -> "General",
			Abstract -> True,
			IndexMatching -> SolventLink
		},
		TransferEnvironment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, BiosafetyCabinet],
				Model[Instrument, FumeHood],
				Model[Instrument, GloveBox],
				Model[Container, Bench],

				Object[Instrument, BiosafetyCabinet],
				Object[Instrument, FumeHood],
				Object[Instrument, GloveBox],
				Object[Container, Bench]
			],
			Description -> "For each member of SolventLink, the instrument in which the transfer will occur.",
			Category -> "General",
			Abstract -> True,
			IndexMatching -> SolventLink
		},
		Tips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tips],
				Object[Item, Tips]
			],
			Description -> "For each member of SolventLink, the pipette tips used to aspirate and dispense the requested volume.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		TipType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TipTypeP,
			Description -> "For each member of Tips, the type of pipette tips used to aspirate and dispense the requested volume during the transfer.",
			Category -> "General",
			IndexMatching -> Tips
		},
		TipMaterial -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "For each member of Tips, the material of the pipette tips used to aspirate and dispense the requested volume during the transfer.",
			Category -> "General",
			IndexMatching -> Tips
		},
		ReversePipetting -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of TotalVolume, indicates if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination position.",
			Category -> "General",
			IndexMatching -> TotalVolume
		},
		SlurryTransfer->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the source sample should be mixed via pipette until it becomes homogenous, up to MaxNumberOfAspirationMixes times.",
			Category -> "General"
		},
		AspirationMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of TotalVolume, tndicates if mixing should occur during aspiration from the source sample.",
			Category -> "General",
			IndexMatching -> TotalVolume
		},
		AspirationMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Swirl | Pipette,
			Description -> "For each member of AspirationMix, the type of mixing that should occur during aspiration.",
			Category -> "General",
			IndexMatching -> AspirationMix
		},
		NumberOfAspirationMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "For each member of TotalVolume, the number of times that the source sample should be mixed during aspiration.",
			Category -> "General",
			IndexMatching -> TotalVolume
		},
		MaxNumberOfAspirationMixes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
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
		DispenseMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of TotalVolume, indicates if mixing should occur after the sample is dispensed into the destination container.",
			Category -> "General",
			IndexMatching -> TotalVolume
		},
		DispenseMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Swirl | Pipette,
			Description -> "For each member of DispenseMix, the type of mixing that should occur after the sample is dispensed into the destination container.",
			Category -> "General",
			IndexMatching -> DispenseMix
		},
		NumberOfDispenseMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "For each member of TotalVolume, the number of times that the source sample should be mixed after the sample is dispensed into the destination container.",
			Category -> "General",
			IndexMatching -> TotalVolume
		},
		DispenseMixVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of DispenseMix, the volume quickly aspirated and dispensed to mix the destination sample after the source is dispensed.",
			Category -> "General",
			IndexMatching -> DispenseMix
		},
		Needle -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of SolventLink, the needle used to aspirate and dispense the requested volume.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		Funnel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "For each member of SolventLink, the funnel that is used to guide the source sample into the destination container when pouring or using a graduated cylinder.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		WaterPurifier -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, WaterPurifier],
				Object[Instrument, WaterPurifier]
			],
			Description -> "For each member of SolventLink, the water purifier used to gather the Milli-Q water required for the transfer.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		HandPump -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, HandPump],
				Object[Part, HandPump]
			],
			Description -> "For each member of SolventLink, the hand pump used to get liquid out of the source container.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		HandPumpWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SolventLink, the container that will be used to collect any excess liquid that is still in the hand pump when it is removed from the source container.",
			Category -> "General"
		},
		UnsealHermeticSource -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SolventLink, indicates if the source's hermetic container should be unsealed before sample is transferred out of it.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		BackfillNeedle -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of SolventLink, the needle used to backfill the source's hermetic container with BackfillGas.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		BackfillGas -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[
				Nitrogen,
				Argon
			],
			Description -> "For each member of SolventLink, the inert gas that is used equalize the pressure in the source's hermetic container while the transfer out of the source's container occurs.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		VentingNeedle -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of SolventLink, the needle that is used equalize the pressure in the destination's hermetic container while the transfer into the destination's container occurs.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		TipRinse -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SolventLink, indicates if the Tips should first be rinsed with a TipRinseSolution before they are used to aspirate from the source sample.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		TipRinseSolutionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SolventLink, the solution that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		TipRinseSolutionString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, the solution that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		TipRinseVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Milliliter,
			Description -> "For each member of SolventLink, the volume of the solution that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		NumberOfTipRinses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of SolventLink, the number of times that the Tips should be rinsed before they are used to aspirate from the source sample.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		IntermediateDecant -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SolventLink, indicates if the source will need to be decanted into an intermediate container in order for the precise amount requested to be transferred via pipette.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		IntermediateContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SolventLink, the container that the source will be decanted into in order to make the final transfer via pipette into the final destination.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		IntermediateContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SolventLink, the container that the source will be decanted into in order to make the final transfer via pipette into the final destination.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		IntermediateFunnel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "For each member of SolventLink, the funnel that is used to guide the source sample into the intermediate container when pouring.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		SourceTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SolventLink, indicates the temperature at which the source should be at during the transfer.",
			Category -> "Temperature Equilibration",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SourceTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient,
			Description -> "For each member of SolventLink, indicates the temperature at which the source should be at during the transfer.",
			Category -> "Temperature Equilibration",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		SourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of SolventLink, the duration of time for which the samples will be heated/cooled to the target SourceTemperature.",
			Category -> "Temperature Equilibration",
			IndexMatching -> SolventLink
		},
		MaxSourceEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of SolventLink, the maximum duration of time for which the samples will be heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime.",
			Category -> "Temperature Equilibration",
			IndexMatching -> SolventLink
		},
		SourceEquilibrationCheck -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "For each member of SolventLink, the method by which to verify the temperature of the source before the transfer is performed.",
			Category -> "Temperature Equilibration",
			IndexMatching -> SolventLink
		},
		DestinationTemperatureReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SolventLink, indicates the temperature at which the source should be at during the transfer.",
			Category -> "Temperature Equilibration",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		DestinationTemperatureExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Ambient,
			Description -> "For each member of SolventLink, indicates the temperature at which the source should be at during the transfer.",
			Category -> "Temperature Equilibration",
			Migration -> SplitField,
			IndexMatching -> SolventLink
		},
		DestinationEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of SolventLink, the duration of time for which the samples will be heated/cooled to the target SourceTemperature.",
			Category -> "Temperature Equilibration",
			IndexMatching -> SolventLink
		},
		MaxDestinationEquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Minute,
			Description -> "For each member of SolventLink, the maximum duration of time for which the samples will be heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime.",
			Category -> "Temperature Equilibration",
			IndexMatching -> SolventLink
		},
		DestinationEquilibrationCheck -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EquilibrationCheckP,
			Description -> "For each member of SolventLink, the method by which to verify the temperature of the source before the transfer is performed.",
			Category -> "Temperature Equilibration",
			IndexMatching -> SolventLink
		},
		SterileTechnique -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SolventLink, indicates if sterile instruments and a sterile transfer environment should be used for the transfer.",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		RNaseFreeTechnique -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SolventLink, indicates that RNase free technique should be followed when performing the transfer (spraying RNase away on surfaces, using RNaseFree tips, etc).",
			Category -> "General",
			IndexMatching -> SolventLink
		},
		(* these fields below are actually used during the running of the protocol (or the old version at least; TODO update them once we get to writing stuff) *)
		(* This is either Source or this is IntermediateContainer. *)
		WorkingSource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description -> "The current container in which our source sample is in, after any intermediate transfers.",
			Category -> "General",
			Developer -> True
		},
		SolventSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Solvent sample for this fill to volume.",
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
				Object[Container]
			],
			Description -> "The current container to transfer our sample from WorkingSample into.",
			Category -> "General",
			Developer -> True
		},
		DestinationSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Destination sample for this fill to volume.",
			Category -> "General",
			Developer -> True
		},

		SourceWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The desired position in the source container from which our sample will be aspirated.",
			Category -> "Fill to Volume",
			Developer -> True
		},

		WorkingSourceWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The position(s) in the working source container from which our sample will be aspirated.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		WorkingDestinationWell -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The position(s) in the working destination container in which the transferred samples will be placed.",
			Category -> "Fill to Volume",
			Developer -> True
		},
		TargetVolumeToleranceAchieved -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the final volume measured falls within the TotalVolume \[PlusMinus] the Tolerance fields in the parent protocol object.",
			Category -> "Fill to Volume"
		}
	}
}];