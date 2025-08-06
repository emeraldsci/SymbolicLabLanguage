(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Plate,PhaseSeparator], {
	Description->"Model information for a physical container used in LiquidLiquidExtraction to separate the aqueous layer (which is retained in the phase separator) and organic layer (which flows through the hydrophobic frit into a collection container) through hydrophobic/hydrophilic interactions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NozzleHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the top of the separator plate to the bottom of the separator nozzles.",
			Category -> "Physical Properties",
			Developer -> True
		},
		NozzleOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[Millimeter],
			Units -> Millimeter,
			Description -> "The distance the nozzles of this separator protrude into the wells of the collection plate when seated on top, as measure from the bottom of the nozzle to the top of the collection plate. Negative values indicate the nozzles extend into the collection plate, while positive values indicate the nozzles are above the plate.",
			Category -> "Physical Properties",
			Developer -> True
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure that can be applied to this separator plate before it is prone to burst during the experiment.",
			Category -> "Operating Limits"
		}
	}
}];
