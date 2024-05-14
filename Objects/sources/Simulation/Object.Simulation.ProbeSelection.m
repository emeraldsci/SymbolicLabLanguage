(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation, ProbeSelection], {
	Description->"A simulation to generate ideal sets of nucleic acid probes for use in detecting the presence of a given particular target gene sequence or transcript sequence.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TargetSequence -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MotifP,
			Description -> "The sequence to which the probe will bind to.",
			Category -> "General",
			Abstract -> True
		},
		TargetConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Molar*Micro],
			Units -> Femtomolar,
			Description -> "The concentration of the target sequence to be used in the simulation.",
			Category -> "General"
		},
		ProbeConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Molar*Micro],
			Units -> Femtomolar,
			Description -> "The concentration of the probe which will bind to the target in the simulation.",
			Category -> "General"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "Length of time for each kinetic simulation in which a probe is binding to a specific site on the target.",
			Category -> "General",
			Abstract -> False
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Temperature at which each kinetic simulation is running while a probe is binding to a specific site on the target.",
			Category -> "General",
			Abstract -> False
		},
		ProbeLength -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[1, 1] | {GreaterP[1, 1]..} | GreaterP[1, 1] ;; GreaterP[1, 1],
			Description -> "Length of the probes to consider.  Can be single length, span of lengths, or list of lengths.",
			Category -> "General",
			Abstract -> True
		},
		BeaconStemLength -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "If Beacon length is specified as n>0, then the reverse complement of the first n bases of the probe sequence are added to the end of the probe, resulting in a probe that can fold into a hairpin loop with stem length of n.",
			Category -> "General",
			Abstract -> False
		},
		(* Simulation Results *)
		TargetPosition -> {
			Format -> Multiple,
			Class -> {Integer, Integer},
			Pattern :> {GreaterEqualP[1, 1], GreaterEqualP[1, 1]},
			Units -> {None, None},
			Description -> "The corresponding indices on the target sequence for each probe, each pair contains a starting position and an ending position.",
			Category -> "Simulation Results",
			Headers -> {"Start", "End"},
			Abstract -> True
		},
		ProbeStrands -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> StrandP,
			Description -> "A list of probe candidates (one for each site tested) as determined by the kinetic simulation, sorted by their correctly bound concentration.",
			Category -> "Simulation Results",
			Abstract -> True
		},
		BoundProbeConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Molar*Micro],
			Units -> Micromolar,
			Description -> "For each member of ProbeStrands, concentration of probe correctly bound to its target site.",
			Category -> "Simulation Results",
			IndexMatching -> ProbeStrands
		},
		FreeProbeConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Molar*Micro],
			Units -> Micromolar,
			Description -> "For each member of ProbeStrands, concentration of probe not bound to anything.",
			Category -> "Simulation Results",
			IndexMatching -> ProbeStrands
		},
		FalseAmpliconConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Molar*Micro],
			Units -> Micromolar,
			Description -> "For each member of ProbeStrands, concentration of probe bound offsite to target at either their beginning or end.",
			Category -> "Simulation Results",
			IndexMatching -> ProbeStrands
		},
		FoldedBeaconConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Molar*Micro],
			Units -> Micromolar,
			Description -> "For each member of ProbeStrands, concentration of probe maximally folded onto itself, in the case where Beacon is used.",
			Category -> "Simulation Results",
			IndexMatching -> ProbeStrands
		}
	}
}];
