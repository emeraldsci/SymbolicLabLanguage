(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,ReferenceElectrode], {
	Description->"Object information for an electrode installed on the electrochemical detector and acts as a fixed potential reference or a pH monitor.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		StorageSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The recommended solution filled in the glass tube of the reference electrode when the reference electrode is stored in. For Ag/AgCl, this is 3M KCl.",
			Category -> "General"
		},
		StorageSolutionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {
				Null,
				Object[Sample],
				Object[User]|Object[Protocol]|Object[Qualification]|Object[Maintenance]
			},
			Headers -> {"Date", "Storage Solution", "Responsible Party"},
			Description -> "The historical recording of the solution this reference electrode has been stored in.",
			Category -> "Usage Information"
		},
		CalibrationLog -> {
			Format -> Multiple,
			Class -> {
				Date,
				Link,
				Link,
				Real,
				Real,
				Real,
				Link
			},
			Pattern :> {
				_?DateObjectQ,
				_Link,
				_Link,
				RangeP[0,14],
				RangeP[0,14],
				GreaterEqualP[0],
				_Link
			},
			Relation -> {
				Null,
				Object[Sample],
				Object[Sample],
				Null,
				Null,
				Null,
				Object[Protocol]|Object[Qualification]|Object[Maintenance]
			},
			Headers -> {
				"Date",
				"Neutral pH Calibration Buffer",
				"Secondary pH Calibration Buffer",
				"Secondary pH Calibration Buffer Target",
				"pH Electrode Offset",
				"pH Electrode Slope",
				"Protocol"
			},
			Description -> "The historical recording of the calibration data on this reference electrode.",
			Category -> "Usage Information"
		}
	}
}];
