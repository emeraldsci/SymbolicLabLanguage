(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,SamplingProbe],{
	Description->"Model information for the sampling probe that direct connects to a sensor in a HIAC 9703 plus liquid particle counter.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ProbeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the connection to the sensor to the tip of the probe.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];