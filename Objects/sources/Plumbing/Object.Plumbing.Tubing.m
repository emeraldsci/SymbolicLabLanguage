(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Plumbing,Tubing], {
	Description->"A hollow, cylindrical length of material for channeling liquids.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		HPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, HPLC][BufferAInlet],
				Object[Instrument, HPLC][BufferBInlet],
				Object[Instrument, HPLC][BufferCInlet],
				Object[Instrument, HPLC][BufferDInlet],
				Object[Instrument, HPLC][NeedleWashSolutionInlet]
			],
			Description -> "The HPLC instrument that is connected to this buffer inlet tubing.",
			Category -> "Instrument Specifications"
		},
		FPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, FPLC][SampleInlet1],
				Object[Instrument, FPLC][SampleInlet2],
				Object[Instrument, FPLC][SampleInlet3],
				Object[Instrument, FPLC][SampleInlet4],
				Object[Instrument, FPLC][SampleInlet5],
				Object[Instrument, FPLC][BufferInletA1],
				Object[Instrument, FPLC][BufferInletA2],
				Object[Instrument, FPLC][BufferInletA3],
				Object[Instrument, FPLC][BufferInletA4],
				Object[Instrument, FPLC][BufferInletB1],
				Object[Instrument, FPLC][BufferInletB2],
				Object[Instrument, FPLC][BufferInletB3],
				Object[Instrument, FPLC][BufferInletB4]
			],
			Description -> "The FPLC instrument that is connected to this buffer inlet tubing.",
			Category -> "Instrument Specifications"
		},
		IonChromatographySystem -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, IonChromatography][EluentGeneratorInletSolutionInlet],
				Object[Instrument, IonChromatography][BufferAInlet],
				Object[Instrument, IonChromatography][BufferBInlet],
				Object[Instrument, IonChromatography][BufferCInlet],
				Object[Instrument, IonChromatography][BufferDInlet],
				Object[Instrument, IonChromatography][NeedleWashSolutionInlet]
			],
			Description -> "The Ion Chromatography instrument that is connected to this buffer inlet tubing.",
			Category -> "Instrument Specifications"
		},
		SupercriticalFluidChromatography -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, SupercriticalFluidChromatography][CosolventAInlet],
				Object[Instrument, SupercriticalFluidChromatography][CosolventBInlet],
				Object[Instrument, SupercriticalFluidChromatography][CosolventCInlet],
				Object[Instrument, SupercriticalFluidChromatography][CosolventDInlet],
				Object[Instrument, SupercriticalFluidChromatography][MakeupSolventInlet],
				Object[Instrument, SupercriticalFluidChromatography][NeedleWashSolutionInlet],
				Object[Instrument, SupercriticalFluidChromatography][ExternalNeedleWashSolutionInlet]
			],
			Description -> "The SupercriticalFluidChromatography instrument that is connected to this buffer inlet tubing.",
			Category -> "Instrument Specifications"
		},
		PlateWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, PlateWasher][BufferAInlet],
				Object[Instrument, PlateWasher][BufferBInlet],
				Object[Instrument, PlateWasher][BufferCInlet],
				Object[Instrument, PlateWasher][BufferDInlet]
			],
			Description -> "The plate washer instrument that is connected to this buffer inlet tubing.",
			Category -> "Instrument Specifications"
		}
	}
}];
