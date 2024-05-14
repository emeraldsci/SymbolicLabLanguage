(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, SerialDilute], {
	Description -> "A detailed set of parameters that specifies the information of how to perform a serial dilution.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Todo: N-Multiples *)
		Source -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> (_String | ObjectP[{Object[Sample], Object[Container]}]) | {(_String | ObjectP[{Object[Sample], Object[Container]}])..},
			Description -> "Source sample to be used in the serial dilution.",
			Category -> "Organizational Information"
		},
		(* these are fields that match the option patterns exactly *)

		SourceLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _String | {_String..},
			Description -> "For each member of Source, the label of the sample that is being aliquoted in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},

		SourceContainerLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _String | {_String..},
			Description -> "For each member of Source, the label of the container of the sample that is being aliquoted in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
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
		
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_String..},(*{(ObjectP[] | {_Integer, ObjectP[]})..},*) (*{{_String,_String}..}*)
			Relation -> Null,
			Description -> "For each member of Source, the label of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},

		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_String..},
			Relation -> Null,
			Description -> "For each member of Source, the label of the container of the sample that will be created in this experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> Source
		},

		DiluentLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the diluent added to the diluted sample.",
			Category -> "General",
			IndexMatching -> Source
		},

		ConcentratedBufferLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the concentrated buffer that is diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent).",
			Category -> "General",
			IndexMatching -> Source
		},

		BufferDiluentLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the label of the buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution.",
			Category -> "General",
			IndexMatching -> Source
		},

		SerialDilutionFactors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of Source, the factors by which you wish to reduce the concentrations starting with SamplesIn, followed by each previous dilution in the series of dilutions.",
			Category -> "Sample Preparation"
		},

		NumberOfSerialDilutions -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "For each member of Source, the number of times the sample is repeatedly diluted, starting with SamplesIn, followed by each previous diltuion.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		TargetConcentrations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 * Micromolar]|GreaterP[0 (Milligram/Milliliter)])..},
			Description -> "For each member of SerialDilutionFactors, the desired concentrations of Analyte in the final diluted samples after serial dilutions.",
			Category -> "Sample Preparation",
			IndexMatching -> SerialDilutionFactors
		},

		Analyte -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypes,
			Description -> "For each member of Source, the substance whose final concentrations are attained through a series of dilutions.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		FinalVolume -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 * Milliliter]..},
			Description -> "For each member of SerialDilutionFactors, The final volume in each well after the series of dilutions.",
			Category -> "Sample Preparation",
			IndexMatching -> SerialDilutionFactors
		},

		BufferDilutionStrategy -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BufferDilutionStrategyP,
			Description -> "For each member of Source, bufferDilutionStrategy describes the manner in which to generate to buffer samples for each serial dilution. FromConcentrate provides ConcentratedBuffer to each well, which is then diluted with BufferDiluent to reach a final buffer concentraion of 1X, whereas Direct uses pre-diluted buffer which is already at 1X to perform the subsequent dilutions (see figure 1.x).",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		TransferAmounts -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 * Microliter]..},
			Description -> "For each member of Source, the series of volume transferred starting from SamplesIn, and going into each subsequent dilution.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		DiluentLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "For each member of Source, the solution used to reduce the concentration of the SamplesIn and each subsequent dilution.",
			Category -> "Sample Preparation",
			Migration -> SplitField,
			IndexMatching -> Source
		},

		DiluentString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of Source, the solution used to reduce the concentration of the SamplesIn and each subsequent dilution.",
			Category -> "Sample Preparation",
			Migration -> SplitField,
			IndexMatching -> Source
		},

		(* Todo: N-Multiples*)
		DiluentAmount -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 * Microliter]..},
			Description -> "For each member of Source, the amount of solution used to reduce the concentration of the SamplesIn and each subsequent dilution.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		(* Todo: N-Multiples*)
		BufferDiluentAmount -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 * Microliter]..},
			Description -> "For each member of Source, the amount of buffer diluent to be added to reduce the concentration of ConcentratedBuffer in each dilution.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		(* Todo: N-Multiples*)
		ConcentratedBufferAmount -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0 * Microliter]..},
			Description -> "For each member of Source, the amount of ConcentratedBuffer used in the first dilution from SamplesIn and each subsequent diltuion.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		DiscardFinalTransfer -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Source, indicates if the final wells contain the same volume as the previously diluted wells by removing TransferAmount from the final dilution.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		(* Todo: N-Multiples*)
		DestinationWells -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {WellP..},
			Description -> "For each member of SerialDilutionFactors, the wells in which the dilutions will occur in ContainerOut if the dilutions occur in well plates.",
			Category -> "Sample Preparation",
			IndexMatching -> SerialDilutionFactors
		},

		(* Todo: N-Multiples*)
		ContainerOut -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[] | {_Integer, ObjectP[]|_String} | _String )..},
			Description -> "For each member of Source, specifies the containers that have the final serial dilutions.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		TransferMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Source, Indicates if mixing of the samples is needed after each dilution in the series.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		TransferMixType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:> Pipette|Swirl,
			Description->"For each member of Source, determines which type of mixing should be performed on the diluted samples after each dispense.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		TransferNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "For each member of Source, the number of times the sample is repeatedly diluted, starting with SamplesIn, followed by each previous diltuion.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		},

		(*DilutionSeriesDirection->{
			Format->Single,
			Class->Expression,
			Pattern:>BufferDilutionStrategyP,
			Description->"BufferDilutionStrategy describes the manner in which to generate to buffer samples for each serial dilution. FromConcentrate provides ConcentratedBuffer to each well, which is then diluted with BufferDiluent to reach a final buffer concentraion of 1X, whereas Direct uses pre-diluted buffer which is already at 1X to perform the subsequent dilutions (see figure 1.x).",
			Category->"Sample Preparation"
		},*)

		WasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "Waste containers for discarding final transfer volumes from final samples.",
			Category -> "Sample Preparation",
			Developer -> True
		},

		WasteContainerLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Waste container labels for discarding final transfer volumes from final samples.",
			Category -> "Sample Preparation"
		}

		(*PostDiluteMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Source, indicates if Mixing will occur after each dilution.",
			Category -> "Sample Preparation",
			IndexMatching -> Source
		}*)

	}}];
