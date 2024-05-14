(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, ConductivityProbe], {
	Description->"A probe used for the electrical conductivity measurements in a solution.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ProbeCertificate->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs for the quality certificate of this probe coming from the manufacturer.",
			Category -> "Model Information"
		},
		NominalCellConstant ->{
			Format -> Single,
			Class ->Real,
			Pattern :> DistributionP[1/Centimeter],
			Description -> "Nominal cell constant provided from the manufacturer.",
			Category -> "Model Information"
		},
		ResponseTime->{
			Format -> Single,
			Class ->Real,
			Pattern :> GreterP[0],
			Units -> Second,
			Description -> "Response time provided from the manufacturer.", (* TODO: fine out what is it*)
			Category -> "Model Information"
		},
		TolerenceOfTemperatureMeasurement->{
			Format -> Single,
			Class ->Real,
			Pattern :> GreterP[0],
			Units -> Celsius,
			Description -> "Tolerance of temperature measurement provided from the manufacturer.",(*TODO: fine out what is it*)
			Category -> "Model Information"
		},
		CurrenCalibration ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, Conductivity],
			Description -> "The current cell constant calibration fit into calibrations standard conductivity used to calculate the samples conductivity.",
			Category -> "Qualifications & Maintenance"
		},
		CalibrationLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation ->{Null, Object[Calibration, Conductivity]},
			Description -> "A list of all the calibrations that were performed on this probe.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Date", "Calibration Object"}
		}
	}
}];
