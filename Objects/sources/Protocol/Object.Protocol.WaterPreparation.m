(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, WaterPreparation], {
	Description->"A protocol for generating water samples to fulfill water resources.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Amounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter],
			Description -> "For each member of SamplesIn, the amount of the water sample that is prepared.",
			Category -> "General",
			Abstract -> True,
			IndexMatching -> SamplesIn
		},
		DisplayedAmountAsVolume -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The Amount, converted to a Volume, as a string, as it will be displayed to the operator in the procedure.",
			Category -> "General",
			Developer -> True
		},
		WaterSourceInstruments->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Sink],
				Model[Instrument, WaterPurifier],
				Object[Instrument, Sink],
				Object[Instrument, WaterPurifier]
			],
			Description -> "For each member of SamplesIn, the water  purifier or sink that supplies the water sample generated.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		WaterSourceInstrumentFlushes->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the water runs through the lines of the WaterSourceInstruments, at WaterSourceInstrumentFlushFlowRates for a duration of WaterSourceInstrumentFlushTimes, in order to rid the lines stagnant water prior to use. Flushing is only done once right before the washing and dispensing of the first water generation for a batch of water resources utilizing the same WaterSourceInstrument.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		WaterSourceInstrumentFlushFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "For each member of SamplesIn, the volume of water per time released during the flush of the water line in order to rid the lines stagnant water prior to use.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		WaterSourceInstrumentFlushTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration that water is ran from the dispenser of WaterSourceInstruments, at a rate of WaterSourceInstrumentFlushFlowRates, in order to rid the lines stagnant water prior to use.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		RinseContainers->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the water is ran along the inner surface of the container, at RinseContainerFlowRates for a duration of RinseContainerTimes, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		RinseContainerFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "For each member of SamplesIn, the volume of water per time that run along the inner surface of the container, for a duration of RinseContainerTimes, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		RinseContainerTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration that water run along the inner surface of the container, at RinseContainerFlowRates, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		NumberOfContainerRinses-> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "For each member of SamplesIn, the number of times water is ran along the inner surface of the container, at RinseContainerFlowRates for a duration of RinseContainerTimes, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		NumberOfContainerRinsesPerformed-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "The number that tracks the number of container rinses that have been performed at a given time for the current container.",
			Category -> "General",
			Developer -> True
		},
		RinseCaps->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the water is ran along the inner surface of the cap, at RinseCapFlowRates for a duration of RinseCapTimes, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		RinseCapFlowRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "For each member of SamplesIn, the volume of water per time that run along the inner surface of the cap, for a duration of RinseCapTimes, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		RinseCapTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration that water run along the inner surface of the cap, at RinseCapFlowRates, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		NumberOfCapRinses-> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "For each member of SamplesIn, the number of times water is ran along the inner surface of the cap, at RinseCapFlowRates for a duration of RinseCapTimes, in order to remove contaminants.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		NumberOfCapRinsesPerformed-> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "The number that tracks the number of cap rinses that have been performed at a given time for the current container.",
			Category -> "General",
			Developer -> True
		},
		(* --- Resources --- *)
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Resource, Sample][Preparation]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the resource in the parent protocol that is fulfilled by performing the requested manipulation to generate a new sample.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];
