(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, NMRProbe], {
	Description->"Model information for a part inserted into an NMR that excites nuclear spins, detects the signal, and collects data.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TubeDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of NMR tubes that this probe can read.",
			Category -> "Dimensions & Positions"
		},
		Nuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nuclei whose NMR spectra can be obtained with this probe.",
			Category -> "Part Specifications"
		},
		InnerCoilNuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nuclei that the inner coil of this probe can be tuned to observe.",
			Category -> "Part Specifications"
		},
		OuterCoilNuclei -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nuclei that the outer coil of this probe can be tuned to observe.",
			Category -> "Part Specifications"
		},
		LockNucleus -> {
			Format -> Single,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nucleus this probe uses to lock onto the desired NMR frequency.",
			Category -> "Part Specifications"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature that this probe can be cooled to when collecting NMR data.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature that this probe can be heated to when collecting NMR data.",
			Category -> "Operating Limits"
		}
	}
}];
