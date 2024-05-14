(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance,CalibrateNMRShim],{
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates the shim of an NMR spectrometer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ManufacturerCalibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the calibration function for this sensor is provided by sensor's manufacturer or a calibration service company.",
			Category -> "General",
			Abstract -> True
		},
		ShimmingStandard -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Model[Sample]|Object[Sample],
			Description -> "The standard sample which is used shimming calibration of the NMR spectrometer.",
			Category -> "General",
			Abstract -> True
		}
	}
}];