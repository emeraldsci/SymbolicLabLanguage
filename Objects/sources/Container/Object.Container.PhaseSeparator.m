

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[
	Object[Container, PhaseSeparator], {
	Description->"A Biotage Phase Separator cartridge, which is used in liquid-liquid extractions.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		CasingMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CasingMaterial]],
			Pattern :> PlasticP,
			Description -> "The material that composes the exterior of the cartridge which houses the frit.",
			Category -> "Physical Properties"
		},
		FritThickness -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FritThickness]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The thickness of the frit through which the organic phase must travel before exiting the cartridge.",
			Category -> "Physical Properties"
		},
		CartridgeWorkingVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CartridgeWorkingVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "The volume of extraction for which this cartridge is specified by the manufacturer.",
			Category -> "Dimensions & Positions"
		},
		Diameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Diameter]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The internal diameter of the cartridge body, where the sample resides.",
			Category -> "Dimensions & Positions"
		},
		ExternalDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ExternalDiameter]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The external diameter of the cartridge body, where the sample resides.",
			Category ->"Dimensions & Positions"
		},
		CartridgeLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CartridgeLength]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The total length of the cartridge body, excluding the connector at the bottom.",
			Category -> "Dimensions & Positions"
		},
		ConnectorLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ConnectorLength]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The distance from the bottom of the cartridge body to the bottom of the connector.",
			Category -> "Dimensions & Positions"
		},
		Tabbed -> {(*Description needs to be updated if we axe the pressure manifold from this experiment.*)
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Tabbed]],
			Pattern :> BooleanP,
			Description -> "Indicates whether there are tabs (which look like a collar) protruding perpendicularly from the top (opening) rim of the cartridge. Cartridges lacking this feature are called TABLESS by Biotage (the manufacturer); such TABLESS cartridges are compatible with the Biotage PRESSURE+ pressure manifold, which is accessed with the Option PhaseSeparatorMethod in ExperimentLiquidLiquidExtraction.",
			Category -> "Container Specifications"
		},
		TabWidth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], TabWidth]],
			Pattern :> GreaterEqualP[0 Millimeter],
			Description -> "The distance from the wall of the cartridge to the exterior edge of the tab protruding from the cartridge rim.",
			Category -> "Container Specifications"
		},
		MinpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinpH]],
			Pattern :> RangeP[0, 14],
			Description -> "The minimum pH to which the cartridge/frit can be exposed without becoming damaged.",
			Category -> "Compatibility"
		},
		MaxpH -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxpH]],
			Pattern :> RangeP[0, 14],
			Description -> "The maximum pH to which the cartridge/frit can be exposed without becoming damaged.",
			Category -> "Compatibility"
		},
		ConnectionType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ConnectionType]],
			Pattern :> ConnectorP,
			Description -> "Indicates the manner in which the cartridge can be fitted to its receptacle.",
			Category -> "Compatibility"
		},
		MaxRetentionTime -> { (*Ask: is MaxNumberOfHours gonna be different?*)
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxRetentateTime]],
			Pattern :> GreaterEqualP[0*Hour],
			Description -> "The maximum amount of time the impermeable phase can remain in the cartridge, as set by the manufacturer.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure to which the cartridge/frit can be exposed without becoming damaged.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxFlowRate]],
			Pattern :> GreaterP[0*(Milliliter/Minute)],
			Description -> "The maximum flow rate at which the cartridge performs.",
			Category -> "Operating Limits"
		},
		DeadVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DeadVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "The maximum flow rate at which the cartridge performs.",
			Category -> "Operating Limits"
		}
	}
}
];
