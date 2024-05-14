(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data,DissolvedOxygen],{
	Description->"DissolvedOxygen of a solution as determined by an dissolved oxygen meter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*Method Information*)
		SampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"The volume of sample solution that was used for the measurement of dissolved oxygen.",
			Category -> "General"
		},
		(*Calibration*)
		Calibrants->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The solutions used by the instrument to determine the conversion from raw measurement to dissolved oxygen.",
			Category->"Calibration"
		},
		CalibrationDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the raw unprocessed calibration data generated meter.",
			Category -> "Calibration"
		},
		CalibrationTemperatures->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description->"The temperatures when the calibration was performed as measured by the selected dissolved oxygen meter.",
			Category->"Experimental Results"
		},
		CalibrationPressures->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*MillimeterMercury],
			Units ->MillimeterMercury,
			Description->"The atmospheric pressures when the calibration was performed as measured by the selected dissolved oxygen meter.",
			Category->"Experimental Results"
		},
		(*Experimental Results*)
		DissolvedOxygen->{
			Format -> Single,
			Class -> Expression,
			Pattern :> (DistributionP[Percent]|DistributionP[Milligram/Liter]),
			Description->"The empirical distribution of DissolvedOxygen measurements of the sample solution, as measured by the selected DissolvedOxygen measurement method, under the stated conditions.",
			Category->"Experimental Results"
		},
		Temperature->{
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Celsius],
			Description->"The empirical distribution of temperature measurements of the sample solution, as measured by the selected dissolved oxygen meter.",
			Category->"Experimental Results"
		},
		Pressure->{
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[MillimeterMercury],
			Description->"The empirical distribution of barometric pressures during the measurements, as measured by the selected dissolved oxygen meter.",
			Category->"Experimental Results"
		}
	}
}]
