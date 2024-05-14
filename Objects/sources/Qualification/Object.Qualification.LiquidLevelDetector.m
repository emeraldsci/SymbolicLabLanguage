(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,LiquidLevelDetector],{
	Description->"A protocol that verifies the functionality of the liquid level detector target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* Macro LLD *)
		SensorArmHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0Millimeter],
			Units->Millimeter,
			Description->"The height to raise or lower the ultrasonic sensor to prior to taking any measurements.",
			Category->"Qualification Parameters"
		},
		GageBlocks->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0Millimeter],
			Units->Millimeter,
			Description->"The gage block sizes that will be read under the ultrasonic sensors.",
			Category->"Qualification Parameters"
		},
		HeightGauge->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->(Model[Part,HeightGauge]|Object[Part,HeightGauge]),
			Description->"The digital height gauge used to set known distances from the sensor.",
			Category->"General"
		},
		StorageContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container,Box]|Object[Container,Box],
			Description->"The containers used to store the gage blocks used in this qualification.",
			Category->"General"
		},
		TareDistance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data],
			Description->"The data containing the ultrasonic distance measurement with no gage blocks underneath the sensor.",
			Category->"Experimental Results"
		},
		GageBlockDistances->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data],
			Description->"For each member of GageBlocks, the measured distance between the sensor and the block.",
			IndexMatching->GageBlocks,
			Category->"Experimental Results"
		},

		(* Plate reader LLD *)
		SamplePreparationUnitOperations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SamplePreparationP,
			Description->"The primitives used by Sample Manipulation to generate the test samples.",
			Category->"Sample Preparation"
		},
		SamplePreparationProtocol->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
			Description->"The sample manipulation protocol used to generate the test samples.",
			Category->"Sample Preparation"
		},
		LayoutFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name of the file used to specify the layout settings for the liquid level detector's distance measurements of the target containers.",
			Category->"Qualification Parameters",
			Developer->True
		},
		DataFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The filename to save raw volume data to.",
			Category->"General",
			Developer->True
		},
		RackGripperTestPassing->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Whether or not the instrument passes the rack gripper test.",
			Category->"Experimental Results"
		}
	}
}];
