(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance,CalibrateNMRShim],{
	Description->"A protocol that calibrates the 3D shim of an NMR spectrometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ManufacturerCalibration -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ManufacturerCalibration]],
			Pattern :> BooleanP,
			Description -> "Indicates that the calibration function for this sensor is provided by sensor's manufacturer or a calibration service company.",
			Category -> "General",
			Abstract -> True
		},
		ShimmingStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The standard sample used to perform 3D shimming.",
			Category -> "General",
			Abstract -> True
		},
		ShimmingStandardSpinner -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, NMRSpinner] | Object[Container, NMRSpinner],
			Description -> "The container that holds the ShimmingStandard NMR tube.",
			Category -> "General",
			Developer -> True
		},
		DepthGauge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, NMRDepthGauge] | Object[Part, NMRDepthGauge],
			Description -> "The part used to set the depth of an NMR tube that does not go into the NMRTubeRack so as to center the sample in the coil.",
			Category -> "General",
			Developer -> True
		},
		NMRTubeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The rack that holds the NMR tubes that will be put onto the instrument for data collection.",
			Category -> "General",
			Developer -> True
		},
		StickerSheet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Consumable] | Model[Item, Consumable],
			Description -> "A book of laminated sheets that is used to collect the object stickers for NMR tubes going into the instrument. The stickers of NMR tubes are taken off temporarily and collected in this book, and restickered after the measurement is done, because loading NMR tubes with stickers into the NMR instrument can lead to bad shimming, compromised data quality, and even broken tubes inside NMR historically.",
			Developer -> True,
			Category -> "General"
		},
		UnrackedNMRTubeStickerPositions -> {
			Format -> Multiple,
			Class -> {Integer, String},
			Pattern :> {GreaterP[0], _String},
			Headers -> {"Page", "Slot Name"},
			Description -> "For each member of UnrackedNMRTubeLoadingPlacements, indicates the page number and the slot on the StickerSheet book where the sticker of the unracked NMR tube is collected temporarily.",
			Developer -> True,
			IndexMatching -> UnrackedNMRTubeLoadingPlacements,
			Category -> "General"
		},
		UnrackedNMRTubePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "For each member of UnrackedNMRTubeLoadingPlacements, the placement used to move the NMR tubes into the spinners.",
			Headers -> {"Spinner", "NMR Tube To Move", "Placement Position"},
			Category -> "Placements",
			IndexMatching -> UnrackedNMRTubeLoadingPlacements,
			Developer -> True
		},
		UnrackedNMRTubeLoadingPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the unracked NMR tubes onto the NMR autosampler.",
			Headers -> {"NMR Tube Rack to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		Qualification -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification,NMR],
			Description -> "The qualification protocol run after calibration to verify it.",
			Category -> "Experimental Results"
		},
		TopSpinVersion -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The current version of TopSpin used by the NMR instrument.",
			Category -> "General",
			Developer -> True
		}
	}
}];