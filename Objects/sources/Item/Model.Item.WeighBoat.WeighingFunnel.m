(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,WeighBoat,WeighingFunnel], {
	Description->"A model of a light, disk-like container that has an attached tube extending from the one end and is used to hold solid samples during weighing followed by transferring samples into containers with small apertures.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FunnelStemDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[Milli Meter],
			Units -> Milli Meter,
			Description -> "The outer diameter of the tube extending from the weighing area portion of the weigh boat.",
			Category -> "Physical Properties"
		},
		FunnelStemLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[Milli Meter],
			Units -> Milli Meter,
			Description -> "The length of the tube extending from the weighing area portion of the weigh boat.",
			Category -> "Physical Properties"
		}
	}
}];
