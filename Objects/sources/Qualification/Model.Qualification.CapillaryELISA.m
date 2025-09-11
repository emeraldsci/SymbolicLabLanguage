(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,CapillaryELISA],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a capillary-based ELISA instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Cartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Plate, Irregular, CapillaryELISA],
			Description -> "The model of the capillary ELISA cartridge plate that is used in the instrument qualification to perform ELISA experiments and quantify the analytes (such as peptides, proteins, antibodies and hormones) in the samples by ELISA.",
			Category -> "General"
		}
	}
}];