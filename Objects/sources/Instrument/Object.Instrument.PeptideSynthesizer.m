(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PeptideSynthesizer], {
	Description->"A Peptide Synthesizer that generates protein/PNA and performs cleaved and resin download.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		SynthesisDeck->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The deck which holds the reaction, preactivation and collection vessels and monomers solutions during a synthesis.",
			Category -> "Dimensions & Positions"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The deck which holds all the solvents used during a synthesis.",
			Category -> "Dimensions & Positions"
		},
		WashSolutionTank -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The main wash solution tank connected to this instrument.",
			Category -> "Instrument Specifications"
		},
		SecondaryWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container connected to the instrument used to collect any liquid waste produced by the instrument during operation.",
			Category -> "Instrument Specifications"
		},
		DeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],DeadVolume]],
			Pattern :> GreaterEqualP[0*Milliliter],
			Description -> "Dead volume needed to fill the instrument lines.",
			Category -> "Instrument Specifications"
		},
		PurgePressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to measure the purge pressure.",
			Category -> "Sensor Information"
		},
		SecondaryWasteScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet weight sensors used by this peptide synthesizer to determine the amount of waste in the secondary waste container.",
			Category -> "Sensor Information",
			Abstract -> True
		}
	}
}];
