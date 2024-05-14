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
		NMRTubePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to move the NMR tubes onto the NMR tube rack or into the spinners.",
			Headers -> {"NMR Tube to Place", "NMR Tube Destination", "Placement Position"},
			Category -> "Placements",
			Developer -> True
		},
		NMRTubeRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move the NMR tube racks onto the NMR autosampler.",
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
		}
	}
}];