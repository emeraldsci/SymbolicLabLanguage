(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Tips], {
	Description->"Model information for disposable pipette tips used for liquid transfers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PipetteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PipetteTypeP,
			Description -> "Indicates the pipette type that this tip is compatible with.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		TipConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TipConnectionTypeP,
			Description -> "The mechanism by which tip connects to the pipette.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Filtered -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the pipette tips have built-in filters to prevent aerosol contamination.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		WideBore -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the pipette tips have a large aperture.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		GelLoading -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the pipette tips have capillaries that are ideal for gel loading.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Aspirator-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the pipette tips are for use by an aspirator pipette.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Conductive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the pipette tips are conductive, allowing for liquid level detection for more precise transfers.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Racked -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether the pipette tips are pre-loaded into racks with defined tip positions.",
			Category -> "Physical Properties"
		},
		NumberOfTips -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "The number of individual pipette tips included in tip samples of this model.",
			Category -> "Physical Properties"
		},
		Material -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the pipette tips are made out of.",
			Category -> "Physical Properties"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The minimum volume that each pipette tip is recommended to transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The maximum volume that each pipette tip can transfer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "Resolution of the cylinder's volume-indicating markings, the volume between gradation subdivisions.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxStackSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The maximum number of tip racks that fit in a stack of racks.",
			Category -> "Operating Limits"
		},
		AspirationDepth -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Meter], GreaterEqualP[0*Meter]},
			Units -> {Meter Milli, Meter Milli},
			Description -> "The maximum depth from which these pipette tips can aspirate at a given source container aperture.",
			Category -> "Operating Limits",
			Headers->{"Aperture Diameter", "Aspiration Depth"}
		},
		Diameter3D -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli},
			Description -> "A list of the external diameter of the tips over the entire height of the tips.",
			Headers -> {"Z Direction Offset (Height)","External Diameter"},
			Category -> "Dimensions & Positions"
		},
		LiquidHandlerPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique labware ID string prefix used to reference this model of tips on a robotic liquid handler.",
			Category -> "General",
			Developer->True
		},
		HamiltonTipEncoding->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Description->"The encoding integer used for Hamilton to denote the current type of the tip.",
			Category -> "General",
			Developer->True
		}
	}
}];
