(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, DNASynthesizer], {
	Description->"A protocol that verifies the functionality of the DNA synthesizer target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
	QualityControlPreparationProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ManualSamplePreparation],
			Description -> "The sample manipulation protocol used to prepare synthesized strand for follow-up quality control experiments.",
			Category -> "Sample Preparation"
		},
		
	QualityControlSamplePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "The primitives used by sample manipulation to generate the quality control test samples.",
			Category -> "Sample Preparation"
		},
	
	AbsorbanceQualityControlProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectroscopy protocol used to interrogate crude concentration of synthesized strands.",
			Category -> "General"
		},
		
	MassSpecQualityControlProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MassSpectrometry],
			Description -> "The MALDI protocol used to interrogate molecular weight of crude synthesized strands.",
			Category -> "General"
		}
		
	}
}];
