(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, CuttingStation], {
	Description -> "A bench-mounted workstation equipped with an integrated spool dispenser, fixed rulers, and cutting implements for preparing sheet materials to specified dimensions.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		InstalledBlade -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Part, Blade] | Object[Part, Blade]),
			Description -> "The rotary cutter currently used in the integrated bench-top cutter of this station.",
			Category -> "Instrument Specifications"
		},
		InstalledRoll -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Liner],
			Description -> "The material roll currently loaded on the integrated spool dispenser.",
			Category -> "Instrument Specifications"
		},
		WasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, WasteBin][CuttingStation],
			Description -> "The waste bin positioned at this station for collecting material scraps and offcuts.",
			Category -> "Instrument Specifications"
		},
		LinerHolderAssembly -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Model[Item],
				Object[Part],
				Object[Item]
			],
			Description -> "The list of parts that comprise the liner holder assembly used to support and position sheet materials during cutting operations.",
			Category -> "Instrument Specifications"
		}
	}
}];
