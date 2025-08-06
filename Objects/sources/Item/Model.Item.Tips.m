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
			Description -> "The maximum volume that each pipette tip can transfer. For serological pipettes with descending graduations, the volume contained when filled to the 0 volume graduation.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "Resolution of the pipette's volume-indicating markings, the volume between gradation subdivisions.",
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
		},
		AscendingGraduations->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For serological pipette tips, the markings on this model used to indicate the fluid's fill level.",
			Abstract->True,
			Category -> "General"
		},
		AscendingGraduationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Labeled, Short, Long],
			Description -> "For each member of AscendingGraduations, indicates if the graduation is labeled with a number, a long unlabeled line, or a short unlabeled line.",
			Category -> "General",
			IndexMatching -> AscendingGraduations
		},
		AscendingGraduationLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of AscendingGraduations, if GraduationTypes is Labeled, exactly matches the labeling text. Otherwise, Null.",
			Category -> "General",
			IndexMatching -> AscendingGraduations,
			Developer -> True
		},
		DescendingGraduations->{
			Format->Multiple,
			Class->Real,
			Pattern :> UnitsP[Milliliter],
			Units -> Milliliter,
			Description -> "For serological pipette tips, the markings on this tip model used to indicate tips MaxVolume minus the fill level of a fluid.",
			Abstract->True,
			Category -> "General"
		},
		DescendingGraduationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Labeled, Short, Long],
			Description -> "For each member of DescendingGraduations, indicates if the descending graduation is labeled with a number, a long unlabeled line, or a short unlabeled line.",
			Category -> "General",
			IndexMatching -> DescendingGraduations
		},
		DescendingGraduationLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of DescendingGraduations, if GraduationTypes is Labeled, exactly matches the labeling text. Otherwise, Null.",
			Category -> "General",
			IndexMatching -> DescendingGraduations,
			Developer -> True
		}(*,
		GraduationCalibration -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Deliver, Contain, Both],
			Description -> "Indicates if the manufacture calibrated the graduations for dispensing an accurate volume to a destination (i.e. 'To Deliver') or for taking an accurate volume from a source (i.e. 'To Contain').",
			Category -> "Container Specifications",
			Abstract -> True
		}*)
	}
}];
