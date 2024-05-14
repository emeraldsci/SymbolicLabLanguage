(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, MeterModule], {
	Description->"Model information for a part designed to convert electrical signal from the sensor probe to the instrument readings.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, ConductivityMeter][MeterModule]|Model[Instrument, pHMeter][MeterModule],
			Description -> "The model of instrument where this module can be install to expand its capability.",
			Category -> "Instrument Specifications"
		},
		MeasurementParameters -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElectrochemicalParameterP,
			Description -> "The electrochemical parameter which can be read by this module.",
			Category -> "Instrument Specifications"
		}
	}
}];
