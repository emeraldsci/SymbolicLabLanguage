(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,GCInletLiner], {
	Description->"A model of an inlet liner used to protect analytes injected into the inlet of a gas chromatograph from active surface inside the inlet.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The outside diameter of the inlet liner tube.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The inside diameter of the inlet liner tube.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		LinerLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The length of the inlet liner tube.",
			Units -> Milli*Meter,
			Category -> "Physical Properties"
		},
		Volume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Liter],
			Description -> "The void space inside the inlet liner into which the vaporized solvent and analytes can expand.",
			Units -> Micro*Liter,
			Category -> "Physical Properties"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature that this liner can withstand.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature that this liner can withstand.",
			Units->Celsius,
			Category -> "Physical Properties"
		},
		SplitMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Split|Splitless,
			Description -> "The inlet mode for which the inlet was designed to be used.",
			Category -> "Physical Properties"
		},
		LinerGeometry -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (SingleTaper|DualTaper|Baffled|StraightTube),
			Description -> "Indicates the internal shape of the inlet liner, which may be tapered at one or both ends, or contain baffling to aid static mixing during injection.",
			Category -> "Physical Properties"
		},
		GlassWool -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the liner is packed with glass wool for trapping non-volatiles injected into the liner.",
			Category -> "Physical Properties"
		},
		CupLiner -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the inlet liner contains a cup liner for trapping non-volatiles injected into the liner.",
			Category -> "Physical Properties"
		},
		Deactivated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the inlet liner has been deactivated to prevent reaction with the injected analytes.",
			Category -> "Physical Properties"
		}
	}
}];
