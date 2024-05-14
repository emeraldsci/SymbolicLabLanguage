(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, SamplingProbe], {
	Description->"An emergency station that is used to wash hazardous contaminants from the body.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ProbeLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ProbeLength]],
			Pattern :> GreaterEqualP[0*Millimeter],
			Description -> "The distance from the connection to the sensor to the tip of the probe.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ConnectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument,LiquidParticleCounter][SamplingProbe]],
			Description -> "The instrument for which this probe is installed.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];