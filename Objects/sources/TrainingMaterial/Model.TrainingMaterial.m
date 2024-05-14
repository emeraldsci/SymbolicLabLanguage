(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

TrainingMaterialFormatP=Alternatives[Slides,TrainingVideo];

DefineObjectType[Model[TrainingMaterial], {
	Description->"A resource that is part of the curriculum for a training module.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		Site->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Site],
			Description->"The specific ECL location to which this training material refers.",
			Category->"General"
		},
		Title->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"A succinct but descriptive title for this training material that will be displayed as a link in the training dashboard.",
			Category->"General"
		},
		TrainingFormat->{
			Format->Single,
			Class->Expression,
			Pattern:>TrainingMaterialFormatP,
			Description->"Determines what format this training material is presented in.",
			Category->"General"
		},
		Hyperlink->{
			Format->Single,
			Class->String,
			Pattern:>URLP,
			Description->"The URL used to access this training material.",
			Category->"General"
		},
		TrainingModules->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[TrainingModule][TrainingMaterials],
			Description->"The training modules that use this material.",
			Category->"General"
		}
	}
}];
