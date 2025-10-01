(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, Deck], {
	Description->"A sample-holding platform on an automated instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][Decks],
				Object[Instrument, Dialyzer][ReservoirDeck],
				Object[Instrument, HPLC][AutosamplerDeck],
				Object[Instrument, HPLC][FractionCollectorDeck],
				Object[Instrument, HPLC][BufferDeck],
				Object[Instrument, HPLC][WashBufferDeck],
				Object[Instrument, HPLC][RearSealWashBufferDeck],
				Object[Instrument, FPLC][AutosamplerDeck],
				Object[Instrument, FPLC][BufferDeck],
				Object[Instrument, FPLC][FractionCollectorDeck],
				Object[Instrument, FPLC][WashFluidDeck],
				Object[Instrument, IonChromatography][AutosamplerDeck],
				Object[Instrument, IonChromatography][BufferDeck],
				Object[Instrument, IonChromatography][WashBufferDeck],
				Object[Instrument, FlashChromatography][BufferDeck],
				Object[Instrument, FlashChromatography][FractionCollectorDeck],
				Object[Instrument, GasChromatograph][AutosamplerDeck],
				Object[Instrument, DifferentialScanningCalorimeter][BufferDeck],
				Object[Instrument, DifferentialScanningCalorimeter][DetergentDeck],
				Object[Instrument, LiquidHandler][BufferDeck],
				Object[Instrument, LiquidHandler][ReservoirDeck],
				Object[Instrument, Incubator][ReservoirDeck],
				Object[Instrument, PeptideSynthesizer][SynthesisDeck],
				Object[Instrument, PeptideSynthesizer][BufferDeck],
				Object[Instrument, PlateWasher][BufferDeck],
				Object[Instrument, NMR][AutosamplerDeck],
				Object[Instrument, MassSpectrometer][ReservoirDeck],
				Object[Instrument, SupercriticalFluidChromatography][AutosamplerDeck],
				Object[Instrument, SupercriticalFluidChromatography][FractionCollectorDeck],
				Object[Instrument, SupercriticalFluidChromatography][CosolventDeck],
				Object[Instrument, SupercriticalFluidChromatography][WashBufferDeck],
				Object[Instrument, PlateWasher][BufferDeck],
				Object[Instrument, ColonyHandler][ColonyHandlerDeck],
				Object[Instrument, KarlFischerTitrator][AutosamplerDeck]
			],
			Description -> "Instruments that are using or associated with this deck.",
			Category -> "Instrument Specifications",
			Abstract -> True
		}
	}
}];
