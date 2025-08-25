(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HandlingStation, GloveBox], {
	Description->"A sealed container that is designed to manipulate samples under a separate atmosphere while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AntechamberSensors -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {Alternatives[Left, Right, Small, Large], _Link},
			Relation -> {None, Object[Sensor][DevicesMonitored]},
			Description -> "The sensor for respective GloveBox antichamber(s) in the form: {Antechamber, Sensor}. The antechamber is designated by the symbol Small, Large, Left or Right.",
			Headers -> {"Antechamber","Sensor"},
			Category -> "Sensor Information"
		}
	}
}];
