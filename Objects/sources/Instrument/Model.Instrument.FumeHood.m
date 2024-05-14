(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, FumeHood], {
	Description->"The model for a ventaliation device for working with potentially harmful chemical fumes and vapors.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FumeHoodTypeP,
			Description -> "Type of fume hood it is.  Options include Benchtop for a standard hood, WalkIn for a large walk-in style hood, or Recirculating for a small unvented hood.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Plumbing -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlumbingP,
			Description -> "List of items that could be plumbed into the cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FlowMeter -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether or not a flow meter is connected to the hood.",
			Category -> "Instrument Specifications"
		},
		FlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Second],
			Units -> Liter/Second,
			Description -> "The recommended face velocity at the sash opening to ensure vapors do not escape.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the fume hood.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
