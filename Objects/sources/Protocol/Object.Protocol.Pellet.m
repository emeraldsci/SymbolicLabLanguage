(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Pellet], {
	Description -> "A protocol to precipitate solids that are present in a solution, aspirate off the supernatant, and optionally resuspend the pellet in a resuspension solution.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Centrifugation -> {
			Format -> Multiple,
			Class -> {
				Instrument -> Link,
				Intensity -> VariableUnit,
				Time -> Real,
				Temperature -> Real
			},
			Pattern :> {
				Instrument -> ObjectP[{Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]}],
				Intensity -> GreaterEqualP[0 RPM] | GreaterEqualP[0 GravitationalAcceleration],
				Time -> GreaterEqualP[0 Second],
				Temperature -> GreaterEqualP[0 Kelvin]
			},
			Relation -> {
				Instrument -> Alternatives[Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]],
				Intensity -> Null,
				Time -> Null,
				Temperature -> Null
			},
			Units -> {
				Instrument -> None,
				Intensity -> None,
				Time -> Minute,
				Temperature -> Celsius
			},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, parameters describing how the input samples should be spun down in order to form a pellet.",
			Category -> "Centrifugation"
		},

		SupernatantVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volume of the supernatant that should be aspirated from the source sample.",
			Category -> "Supernatant Aspiration",
			IndexMatching -> SamplesIn
		},
		SupernatantDestinations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of SamplesIn, the destination that the supernatant should be dispensed into, after aspirated from the source sample.",
			Category -> "Supernatant Aspiration",
			IndexMatching -> SamplesIn
		},
		SupernatantTransferInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument],
				Model[Container],
				Object[Container],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SamplesIn, the pipette that will be used to transfer off the supernatant from the source sample.",
			Category -> "Supernatant Aspiration",
			IndexMatching -> SamplesIn
		},

		Resuspension -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the pellet should be resuspended after the supernatant is aspirated..",
			Category -> "Resuspension",
			IndexMatching -> SamplesIn
		},
		ResuspensionSources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SamplesIn, the sample that should be used to resuspend the pellet from the source sample.",
			Category -> "Resuspension",
			IndexMatching -> SamplesIn
		},
		ResuspensionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volume of ResuspensionSource that should be used to resuspend the pellet from the source sample.",
			Category -> "Resuspension",
			IndexMatching -> SamplesIn
		},
		ResuspensionInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Pipette],
				Object[Instrument, Pipette]
			],
			Description -> "For each member of SamplesIn, the pipette that will be used to resuspend the pellet from the source sample..",
			Category -> "Resuspension",
			IndexMatching -> SamplesIn
		},

		ResuspensionMix -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixType -> Expression,
				MixUntilDissolved -> Boolean,
				Instrument -> Link,
				StirBar -> Link,
				Time -> Real,
				MaxTime -> Real,
				DutyCycle-> Expression,
				MixRate->Real,
				MixRateProfile -> Expression,
				NumberOfMixes->Integer,
				MaxNumberOfMixes->Integer,
				MixVolume->Real,
				Temperature->Real,
				TemperatureProfile->Expression,
				MaxTemperature->Real,
				OscillationAngle->Real,
				Amplitude->Real,
				MixFlowRate->Real,
				MixPosition->Expression,
				MixPositionOffset->Real,
				CorrectionCurve->Expression,
				Tips->Link,
				TipType->Expression,
				TipMaterial->Expression,
				MultichannelMix->Boolean,
				DeviceChannel->Expression,
				ResidualIncubation->Boolean,
				ResidualTemperature->Real,
				ResidualMix->Boolean,
				ResidualMixRate->Real,
				Preheat->Boolean
			},
			Pattern :> {
				Mix -> BooleanP,
				MixType -> MixTypeP,
				MixUntilDissolved -> BooleanP,
				Instrument -> _Link,
				StirBar -> _Link,
				Time->TimeP,
				MaxTime->TimeP,
				DutyCycle->_List,
				MixRate->RPMP,
				MixRateProfile -> _List,
				NumberOfMixes->GreaterEqualP[0],
				MaxNumberOfMixes->GreaterEqualP[0],
				MixVolume->VolumeP,
				Temperature->TemperatureP,
				TemperatureProfile->_List,
				MaxTemperature->TemperatureP,
				OscillationAngle->GreaterEqualP[0 AngularDegree],
				Amplitude->PercentP,
				MixFlowRate->GreaterP[0 Microliter/Second],
				MixPosition->PipettingPositionP,
				MixPositionOffset->GreaterEqualP[0 Millimeter],
				CorrectionCurve->_List,
				Tips->_Link,
				TipType->TipTypeP,
				TipMaterial->MaterialP,
				MultichannelMix->BooleanP,
				DeviceChannel->DeviceChannelP,
				ResidualIncubation->BooleanP,
				ResidualTemperature->GreaterEqualP[0 Kelvin],
				ResidualMix->BooleanP,
				ResidualMixRate->GreaterEqualP[0 RPM],
				Preheat->BooleanP
			},
			Units -> {
				Mix -> None,
				MixType -> None,
				MixUntilDissolved -> None,
				Instrument -> None,
				StirBar -> None,
				Time->Minute,
				MaxTime->Minute,
				DutyCycle->None,
				MixRate->RPM,
				MixRateProfile -> None,
				NumberOfMixes->None,
				MaxNumberOfMixes->None,
				MixVolume->Milliliter,
				Temperature->Celsius,
				TemperatureProfile->None,
				MaxTemperature->Celsius,
				OscillationAngle->AngularDegree,
				Amplitude->Percent,
				MixFlowRate->Microliter/Second,
				MixPosition->None,
				MixPositionOffset->Millimeter,
				CorrectionCurve->None,
				Tips->None,
				TipType->None,
				TipMaterial->None,
				MultichannelMix->None,
				DeviceChannel->None,
				ResidualIncubation->None,
				ResidualTemperature->Celsius,
				ResidualMix->None,
				ResidualMixRate->RPM,
				Preheat->None
			},
			Relation -> {
				Mix -> Null,
				MixType -> Null,
				MixUntilDissolved -> Null,
				Instrument -> Alternatives[Model[Instrument],Object[Instrument]],
				StirBar -> Alternatives[Model[Part,StirBar], Object[Part,StirBar]],
				Time->Null,
				MaxTime->Null,
				DutyCycle->Null,
				MixRate->Null,
				MixRateProfile -> Null,
				NumberOfMixes->Null,
				MaxNumberOfMixes->Null,
				MixVolume->Null,
				Temperature->Null,
				TemperatureProfile->Null,
				MaxTemperature->Null,
				OscillationAngle->Null,
				Amplitude->Null,
				MixFlowRate->Null,
				MixPosition->Null,
				MixPositionOffset->Null,
				CorrectionCurve->Null,
				Tips->Alternatives[Model[Item, Tips], Object[Item, Tips]],
				TipType->Null,
				TipMaterial->Null,
				MultichannelMix->Null,
				DeviceChannel->Null,
				ResidualIncubation->Null,
				ResidualTemperature->Null,
				ResidualMix->Null,
				ResidualMixRate->Null,
				Preheat->Null
			},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, parameters describing how the input samples should be mixed upon resuspension.",
			Category -> "Sample Preparation"
		},

		UnitOperations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[UnitOperation],
			Description -> "The unit operations that container the specifications for how the samples should be centrifuged, aspirated, and optionally resuspended.",
			Category -> "Experimental Results"
		},
		DefinedPellet -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if a pellet is visible after centrifugation.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		SterileTechnique->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if 70% ethanol is to be sprayed on all surfaces/containers used during the transfer. This also indicates if sterile instrument(s) and sterile transfer environment(s) are used for the transfer. Please consult the ExperimentTransfer documentation for a full diagram of SterileTechnique that is employed by operators.",
			Category -> "Transfer Technique"
		}
	}
}];
