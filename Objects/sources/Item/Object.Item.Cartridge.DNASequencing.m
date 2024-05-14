(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item,Cartridge,DNASequencing], {
	Description->"A cartridge that fits in the genetic analyzer instrument that houses the polymer and capillary array.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Polymer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Polymer]],
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The polymer that fills the capillary array to separate DNA fragments.",
			Category -> "Physical Properties"
		},
		AnodeBuffer -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],AnodeBuffer]],
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The buffer run at the positive end of the capillary in the sequencing cartridge.",
			Category -> "Physical Properties"
		},
		VersionNumber -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VersionNumber]],
			Pattern :> 1|2,
			Description -> "The version number of the sequencing cartridge, which determines the NumberOfInjections and UnsealedShelfLife of the cartridge.",
			Category -> "Item Specifications"
		},
		NumberOfCapillaries -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],NumberOfCapillaries]],
			Pattern :> GreaterP[0,1],
			Description -> "The number of capillaries in the capillary array of the sequencing cartridge.",
			Category -> "Physical Properties"
		},
		CapillaryLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CapillaryLength]],
			Pattern :> GreaterP[0*Centimeter],
			Description -> "The length of the capillaries in the capillary array of the sequencing cartridge.",
			Category -> "Physical Properties"
		},
		CapillaryDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],CapillaryDiameter]],
			Pattern :> GreaterP[0*Micrometer],
			Description -> "The diameter of the capillaries in the capillary array of the sequencing cartridge.",
			Category -> "Physical Properties"
		}
	}
}
];
