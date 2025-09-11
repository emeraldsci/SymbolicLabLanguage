(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Plumbing,AspirationCap], {	(* Note that this field has been deprecated and migrated to Object[Item,Cap] *)
	
	Description->"A multiport aspiration cap that can be used to interface instruments with source vessels.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		HPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, HPLC][BufferACap],
				Object[Instrument, HPLC][BufferBCap],
				Object[Instrument, HPLC][BufferCCap],
				Object[Instrument, HPLC][BufferDCap],
				Object[Instrument, HPLC][NeedleWashCap]
			],
			Description -> "The HPLC instrument that is connected to this cap.",
			Category -> "Instrument Specifications"
		},
		FPLC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, FPLC][BufferACap],
				Object[Instrument, FPLC][BufferBCap]
			],
			Description -> "The FPLC instrument that is connected to this cap.",
			Category -> "Instrument Specifications"
		},
		IonChromatographySystem -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, IonChromatography][EluentGeneratorInletSolutionCap],
				Object[Instrument, IonChromatography][BufferACap],
				Object[Instrument, IonChromatography][BufferBCap],
				Object[Instrument, IonChromatography][BufferCCap],
				Object[Instrument, IonChromatography][BufferDCap],
				Object[Instrument, IonChromatography][NeedleWashSolutionCap]
			],
			Description -> "The Ion Chromatography instrument that is connected to this cap.",
			Category -> "Instrument Specifications"
		},
		SupercriticalFluidChromatography -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, SupercriticalFluidChromatography][NeedleWashCap],
				Object[Instrument, SupercriticalFluidChromatography][ExternalNeedleWashCap],
				Object[Instrument, SupercriticalFluidChromatography][CosolventACap],
				Object[Instrument, SupercriticalFluidChromatography][CosolventBCap],
				Object[Instrument, SupercriticalFluidChromatography][CosolventCCap],
				Object[Instrument, SupercriticalFluidChromatography][CosolventDCap],
				Object[Instrument, SupercriticalFluidChromatography][MakeupSolventCap]
			],
			Description -> "The HPLC instrument that is connected to this cap.",
			Category -> "Instrument Specifications"
		},
		PlateWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, PlateWasher][BufferACap],
				Object[Instrument, PlateWasher][BufferBCap],
				Object[Instrument, PlateWasher][BufferCCap],
				Object[Instrument, PlateWasher][BufferDCap]
			],
			Description -> "The plate washer instrument that is connected to this cap.",
			Category -> "Instrument Specifications"
		},
		MassSpectrometer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, MassSpectrometer][WashBufferCap],
				Object[Instrument, MassSpectrometer][LockMassCap]
			],
			Description -> "The MassSpectrometer that is connected to this cap.",
			Category -> "Instrument Specifications"
		},
		pHTitrator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, pHTitrator][AcidContainerCap],
				Object[Instrument, pHTitrator][BaseContainerCap]
			],
			Description -> "The pHTitrator instrument that is connected to this cap.",
			Category -> "Instrument Specifications"
		}
	}
}];
