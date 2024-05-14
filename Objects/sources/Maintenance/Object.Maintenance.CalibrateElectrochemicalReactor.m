(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, CalibrateElectrochemicalReactor], {
	Description->"A protocol that calibrates an electrochemical reactor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CalibrationCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Cap, ElectrodeCap, CalibrationCap],
				Object[Item, Cap, ElectrodeCap, CalibrationCap]
			],
			Description -> "Indicates the cap used to calibrate the target electrochemical reactor.",
			Category -> "General",
			Abstract -> True
		},
		ReactionVesselHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "Indicates the reaction vessel holder to hold the calibration cap during the CalibrateElectrochemicalReactor maintenance protocol.",
			Category -> "General"
		}
	}
}];
