(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, ConductivityMeter], {
	Description->"A device for high precision measurement of electrical conductivity of solutions.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		(* --- Instrument Specifications ---*)
		Modules -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part],
			Description -> "The modules installed that transform signal from the probe to the electrochemical parameters readings.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		InUseProbeHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The probe holder for holding the one probe that is actively being used in the current experiment.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		PermanentProbeHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The probe holder for storing all the probe(s) that are connected to this Conductivity Meter when they are not in use.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		Probes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,ConductivityProbe],
			Description -> "The conductivity probes installed used to measure conductivity.",
			Category -> "Instrument Specifications",
			Abstract -> True
		}
	}
}];
