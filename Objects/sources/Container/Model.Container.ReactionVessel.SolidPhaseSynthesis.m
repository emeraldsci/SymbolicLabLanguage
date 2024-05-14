(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, ReactionVessel, SolidPhaseSynthesis], {
	Description->"A description of a type of vessel used to hold resin while reagents are passed through during solid phase synthesis.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Physical Properties --- *)
		InletFilterMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the inlet filter through which the reagent must travel before reaching the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		InletFilterThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The thickness of the inlet filter through which the reagent must travel before reaching the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		InletFilterPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The size of the pores in the inlet filter through which the reagent must travel before reaching the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		OutletFilterMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the outlet filter through which the reagent must travel before leaving the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		OutletFilterThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The thickness of the outlet filter through which the reagent must travel before leaving the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		OutletFilterPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The size of the pores in the outlet filter through which the reagent must travel before leaving the resin contained in the reaction vessel.",
			Category -> "Physical Properties"
		},
		(* --- Operating Limits --- *)
		NominalFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The nominal flow rate at which the reaction vessel performs.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the reaction vessel performs.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the reaction vessel performs.",
			Category -> "Operating Limits"
		},

		(* --- Compatibility --- *)
		InletConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionVesselConnectionTypeP,
			Description -> "The type of fitting needed to plumb the flow system into the reaction vessel.",
			Category -> "Compatibility"
		},
		OutletConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionVesselConnectionTypeP,
			Description -> "The type of fitting needed to plumb the reaction vessel back into the flow system.",
			Category -> "Compatibility"
		}
	}
}];
