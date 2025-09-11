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
		MinVolumetricFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Second],
			Units -> Liter/Second,
			Description -> "The minimum amount of air, per unit time, pulled through the instrument when the sash is at its working position. This rate generally determines how quickly vapors are removed from the instrument and is often a function of the building's HVAC configuration.",
			Category-> "Instrument Specifications"
		},
		MinFlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Meter)/Second],
			Units -> Meter/Second,
			Description -> "The minimum distance per unit time traveled by air that is pulled through the open face of the sample handling environment when the sash is at its working position. This value determines how quickly vapors at the entrance of the instrument are sucked into the work area. This speed is usually determined by the MinVolumetricFlowRate divided by the area of the open entrance door.",
			Category-> "Instrument Specifications"
		},
		MinLaminarFlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Meter)/Second],
			Units -> Meter/Second,
			Description -> "The minimum distance per unit time traveled by non-turbid air that is smoothly blown in the LaminarFlowDirection.",
			Category-> "Instrument Specifications"
		},
		LaminarFlowDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Horizontal | Vertical),
			Description -> "Indicates if smooth, non-turbid flow is present and which way it is oriented. Horizontal refers to uniform flow into or away from the handling environment through the door. Vertical refers to uniform flow up or down within the handling environment. As examples, some BiosafetyCabinets supply Vertical laminar flow down to the work surface while CleanBenches supply Horizontal laminar flow across the work surface towards the operator.",
			Category -> "Model Information"
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
