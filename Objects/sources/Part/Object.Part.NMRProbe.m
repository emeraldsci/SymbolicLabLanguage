(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, NMRProbe], {
	Description->"Information for a part inserted into an NMR that excites nuclear spins, detects the signal, and collects data.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, NMR][Probe],
			Description -> "The nuclear magnetic resonance instrument that is currently using this probe.",
			Category -> "Instrument Specifications"
		},
		DefaultPulseParameters -> {
			Format -> Multiple,
			Class -> {String, Real, Real},
			Pattern :> {Nucleus1DP, GreaterP[0 Microsecond], GreaterP[0 Watt]},
			Units -> {None, Microsecond, Watt},
			Headers -> {"Nucleus", "Default 90 degree pulse width", "Default hard pulse power"},
			Description -> "The default 90 degree pulse power and width that is currently configured fot this probe.",
			Category -> "Instrument Specifications"
		}
	}
}];
