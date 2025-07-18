(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Deionizer], {
	Description -> "A model of machine that works to minimize static-potential build-up on ungrounded items.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		DeionizationTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DeionizationTechniqueP,
       		Description -> "The spatial configuration of the deionizer relative to the sample. Options include HandHeld, PassThrough, and BenchTop. The HandHeld technique involves waving the deionizer past a sample. The PassThrough technique involves passing the sample through the active region of the deionizer; the active region is normally 'U' or 'L' shaped. The BenchTop technique involves passively deionizing a sample handling zone on a bench top.",
			Category -> "Part Specifications"
		},
		MaxElectrodeVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "Indicates the maximum magnitude of voltage the instrument can provide across its electrodes.",
			Category -> "Part Specifications"
		},
		DischargePeriod -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "Indicates the switching time between positive and negative voltage at the electrode(s).",
			Category -> "Part Specifications"
		},
		PreferredCleaningSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The solvent used to clean the deionizer electrodes as recommended by the part manufacturer.",
			Category -> "Part Specifications"
		},
		MaxIonizationDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "Indicates the maximum distance from the electrode to the sample that will result effective deionization.",
			Category -> "Operating Limits"
		}
	}
}];
