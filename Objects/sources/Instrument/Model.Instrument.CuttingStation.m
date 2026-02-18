(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, CuttingStation], {
	Description -> "The model of a bench-mounted workstation equipped with an integrated spool dispenser, fixed rulers, and cutting implements for preparing sheet materials to specified dimensions.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		WorkSurfaceDimensions -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0 Centimeter], GreaterP[0 Centimeter]},
			Units -> {Centimeter, Centimeter},
			Description -> "The width and depth of the flat work surface on which materials are laid out for measuring and cutting.",
			Category -> "Dimensions & Positions",
			Headers -> {"Width", "Depth"}
		},
		ParallelRulerLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The length of the fixed ruler that runs parallel to the direction of material unrolling from the spool dispenser.",
			Category -> "Instrument Specifications"
		},
		PerpendicularRulerLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The length of the fixed ruler that runs perpendicular to the direction of material unrolling from the spool dispenser.",
			Category -> "Instrument Specifications"
		},
		MaxSpoolWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The maximum width of material roll that can be mounted on the integrated spool dispenser.",
			Category -> "Instrument Specifications"
		},
		MaxSpoolDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The maximum diameter of material roll that can be mounted on the integrated spool dispenser.",
			Category -> "Instrument Specifications"
		},
		DefaultWasteBinModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, WasteBin],
			Description -> "The standard waste bin model provided with this station for collecting material scraps and offcuts.",
			Category -> "Instrument Specifications"
		},
		CuttingWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The maximum width of material that can be positioned and cut by the integrated bench-top cutter.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxCuttingThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The maximum thickness of material that can be cut by the integrated bench-top cutter.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ReplaceableBlade -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cutting blade on the integrated bench-top cutter can be removed and swapped with a new blade.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		ReplacementBladeModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Blade],
			Description -> "The model of consumable blade used to replace the cutting edge of the integrated bench-top cutter.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		LinerHolderAssembly -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Model[Item]
			],
			Description -> "The list of parts that comprise the liner holder assembly used to support and position sheet materials during cutting operations.",
			Category -> "Instrument Specifications"
		}
	}
}];
