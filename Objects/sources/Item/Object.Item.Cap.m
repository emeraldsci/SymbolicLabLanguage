(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, Cap], {
	Description->"Information for cap used to cover vessel.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Fittings -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ObjectP[Object[Plumbing, Fitting]],
			Relation -> Object[Plumbing, Fitting],
			Description -> "Tubing connectors that are attached to this cap.",
			Category -> "Item Specifications"
		},
		CappedContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :>  _Link,
			Relation -> Object[Container][Cap],
			Description -> "The container on which this cap is currently apposed.",
			Category -> "Item Specifications"
		},
		NumberOfPiercings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The number of times this cap has been pierced with a needle.",
			Category -> "Item Specifications"
		},
		CoveredContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :>  _Link,
			Relation -> Object[Container][Cover],
			Description -> "The container on which this cap is currently apposed.",
			Category -> "Item Specifications"
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this cover can be taken off and replaced multiple times without issue.",
			Category -> "Item Specifications"
		},

		(* Fields that linked to different Instrument, this is unique for aspiration cap *)

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
		FlashChromatography -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, FlashChromatography][BufferA1Cap],
				Object[Instrument, FlashChromatography][BufferA2Cap],
				Object[Instrument, FlashChromatography][BufferB1Cap],
				Object[Instrument, FlashChromatography][BufferB2Cap]
			],
			Description -> "The Flash Chromatography instrument that is connected to this cap.",
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
			Description -> "The Supercritical Fluid Chromatography instrument that is connected to this cap.",
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
		ConnectedLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][ConnectedPlumbing],
				Object[Container][ConnectedPlumbing]
			],
			Description -> "The nearest object of known location to which this plumbing component is connected, either directly or indirectly.",
			Category -> "Plumbing Information"
		}

	}
}];
