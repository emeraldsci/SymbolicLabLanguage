(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, ReactionVessel, SolidPhaseSynthesis], {
	Description->"A disposable vessel used to hold resin while reagents are passed through during solid phase synthesis.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		InletFilterMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InletFilterMaterial]],
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the inlet filter through which the reagent must travel before reaching the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		InletFilterThickness -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InletFilterThickness]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The thickness of the inlet filter through which the reagent must travel before reaching the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		InletFilterPoreSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InletFilterPoreSize]],
			Pattern :> GreaterP[0*Micro*Meter],
			Description -> "The size of the pores in the inlet filter through which the reagent must travel before reaching the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		OutletFilterMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], OutletFilterMaterial]],
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the outlet filter through which the reagent must travel before leaving the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		OutletFilterThickness -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], OutletFilterThickness]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The thickness of the outlet filter through which the reagent must travel before leaving the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		OutletFilterPoreSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], OutletFilterPoreSize]],
			Pattern :> GreaterP[0*Micro*Meter],
			Description -> "The size of the pores in the outlet filter through which the reagent must travel before leaving the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		NominalFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NominalFlowRate]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "The nominal flow rate at which the reaction vessel performs.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinFlowRate]],
			Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
			Description -> "The minimum flow rate at which the reaction vessel performs.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxFlowRate]],
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Description -> "The maximum flow rate at which the reaction vessel performs.",
			Category -> "Operating Limits"
		},
		InletConnectionType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InletConnectionType]],
			Pattern :> ReactionVesselConnectionTypeP,
			Description -> "The type of fitting needed to plumb the flow system into the reaction vessel.",
			Category -> "Compatibility"
		},
		OutletConnectionType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], OutletConnectionType]],
			Pattern :> ReactionVesselConnectionTypeP,
			Description -> "The type of fitting needed to plumb the reaction vessel back into the flow system.",
			Category -> "Compatibility"
		}
	}
}];
