(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item,Cartridge,DNASequencing], {
	Description->"A model of the cartridge that houses the polymer, anode buffer, and capillary array that fits in the genetic analyzer instrument for Sanger DNA sequencing experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VersionNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> 1|2,
			Description -> "The version number of the sequencing cartridge as described and purchased from the vendor, which determines the MaxNumberOfUses and UnsealedShelfLife of the cartridge.",
			Category -> "Organizational Information"
		},
		Polymer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Model[Sample],
			Description -> "The macromolecular material that fills the capillary array in order to separate DNA fragments in the samples.",
			Category -> "Physical Properties"
		},
		AnodeBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Model[Sample],
			Description -> "The buffer solution that is run at the positive end of the capillary in the sequencing cartridge.",
			Category -> "Physical Properties"
		},
		NumberOfCapillaries -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of polymer-filled tubes in the capillary array of the sequencing cartridge that inject simultaneously in a single run.",
			Category -> "Physical Properties"
		},
		CapillaryLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Centimeter,
			Description -> "The linear distance of the capillary from the inlet to the outlet in the capillary array of the sequencing cartridge.",
			Category -> "Physical Properties"
		},
		CapillaryDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micrometer],
			Units -> Micrometer,
			Description -> "The internal distance from wall to wall of the capillaries in the capillary array of the sequencing cartridge.",
			Category -> "Physical Properties"
		},
		CapillaryMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The substance that the capillary tube is composed of in the capillary array of the sequencing cartridge.",
			Category -> "Physical Properties"
		}
	}
}
];