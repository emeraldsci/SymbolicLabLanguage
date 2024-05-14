(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, NMR], {
	Description->"A nuclear magentic resonance instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MinimumHeliumLevel->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The minimum fill level of liquid Helium, as a percentage, allowed in the NMR reservoir before damage to the coil can occur.",
			Category -> "Operating Limits"
		},
		HeliumRefillLevel->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "The fill level of liquid Helium, as a percentage, that triggers the helium reservoir to be refilled to 100%.",
			Category -> "Operating Limits"
		},
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, NMRProbe][Instrument],
			Description -> "The part inserted into this instrument that excites nuclear spins, detects the signal, and collects data.",
			Category -> "Instrument Specifications"
		},
		SystemDefaultProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, NMRProbe],
			Description -> "The probe inserted into this instrument by default at the beginning and end of every experiment.",
			Category -> "Instrument Specifications"
		},
		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform from which samples are robotically loaded into the NMR.",
			Category -> "Dimensions & Positions"
		}
	}
}];
