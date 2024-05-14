(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, CalibrateElectrochemicalReactor], {
	Description->"Definition of a set of parameters for a maintenance protocol that calibrates an electrochemical reactor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CalibrationCapModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Cap, ElectrodeCap, CalibrationCap],
			Description -> "Indicates the cap model used to calibrate the target electrochemical reactor.",
			Category -> "General",
			Abstract -> True
		},
		ReactionVesselHolderModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "Indicates the reaction vessel holder model used to hold the calibration cap during an electrochemical reactor calibration maintenance protocol.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
