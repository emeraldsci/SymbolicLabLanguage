(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, HandlingStation], {
	Description -> "The model of station that provides a specific handling environment while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		BalanceType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "The scale of balance (Micro, Analytical, Macro, etc) that is contained within this Model of Handling Station for determining the mass of samples transferred.",
			Category -> "Instrument Specifications"
		},
		NumberOfVideoCameras -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Indicates how many cameras are present within the HandlingStation for streaming the actions of an operator.",
			Category -> "Instrument Specifications"
		},
		Ventilated -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is connected to a negative pressure source. This field does not guarantee a high flow rate, for instance, the ventilation flow rate may vary from 20-50 CFM inside of an enclosure to 100-400 CFM inside of a fumehood.",
			Category -> "Instrument Specifications"
		},
		Deionizing -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is equipped with a deionizer that intends to mitigate accumulated electrostatic charge from handled samples and containers before weighing.",
			Category -> "Instrument Specifications"
		},
		HermeticTransferCompatible -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is equipped with the nitrogen and argon gases, regulators, and valves needed to backfill containers during hermetic transfers.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the handling station in {X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions where sample handling and transfer occur.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		ProvidedHandlingConditions -> {
			Relation -> Model[HandlingCondition],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The physical environments such as integration with ventilation, balance, UV-C light, and etc inside this instrument, which the samples are handled inside of. Handling in this case involves opening the container the sample resides in and adding to, removing, or measuring some of the sample.",
			Category -> "General"
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
		LaminarFlowDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Horizontal | Vertical),
			Description -> "Indicates if smooth, non-turbid flow is present and which way it is oriented. Horizontal refers to uniform flow into or away from the handling environment through the door. Vertical refers to uniform flow up or down within the handling environment. As examples, some BiosafetyCabinets supply Vertical laminar flow down to the work surface while CleanBenches supply Horizontal laminar flow across the work surface towards the operator.",
			Category -> "Instrument Specifications"
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
		MinVolumetricFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Second],
			Units -> Liter/Second,
			Description -> "The minimum amount of air, per unit time, pulled through the instrument when the sash is at its working position. This rate generally determines how quickly vapors are removed from the instrument and is often a function of the building's HVAC configuration.",
			Category-> "Instrument Specifications"
		}
	}
}];
