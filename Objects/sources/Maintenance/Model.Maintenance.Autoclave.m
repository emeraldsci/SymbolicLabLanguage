(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Autoclave], {
	Description->"Definition of a set of parameters for a maintenance protocol that uses an autoclave on containers awaiting sterilization.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Autoclaves->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument],
			Description->"The autoclave(s) that labware can be sterilized in that this maintenance can target.",
			Category -> "General"
		},
		AutoclaveBins->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,WashBin],
			Description->"The bins that will be checked to see if there is labware awaiting sterilization.",
			Category -> "General"
		},
		MinThreshold->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Units->None,
			Description->"The minimum number of containers required before the autoclave maintenance can be enqueued.",
			Category -> "General"
		},
		AutoclavePrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "The price the ECL charges for autoclaving a labware item owned by the user.",
			Category -> "Pricing Information"
		}
	}
}];
