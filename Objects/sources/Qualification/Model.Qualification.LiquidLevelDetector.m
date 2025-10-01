(* ::Package:: *)

DefineObjectType[Model[Qualification,LiquidLevelDetector], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a liquid level detector.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		(* Macro LLD *)
		SensorArmHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"The height at which the sensor of the target should be set, as indicated on the built in scale.",
			Category->"Qualification Parameters"
		},
		GageBlockDistances->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"The length of the longest dimension of the blocks of standard length used to qualify the target.",
			Category->"Qualification Parameters"
		},
		SensorArmHeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The list of sensor heights utilized for ultrasonic distance measurement.",
			Category -> "Qualification Parameters"
		},
		TareDistanceTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"The amount above or below the sensor arm height that the tare reading may deviate by to be considered a pass.",
			Category->"Passing Criteria"
		},
		GageBlockDistanceTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"The amount above or below the expected height that the gage block readings may deviate by to be considered a pass.",
			Category->"Passing Criteria"
		},
		SensorArmDistanceTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The amount above or below the expected height by which the readings may deviate is considered a pass.",
			Category->"Passing Criteria"
		},
		(* Plate reader LLD *)
		PlateModel->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Container],
			Description->"The model of the plate used to test a plate reading liquid level detector.",
			Category->"Qualification Parameters"
		},
		PlateSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Milliliter],
			Units->Milliliter,
			Description->"The volumes of liquid to fill alternate columns of the plate with.",
			Category->"Qualification Parameters"
		},
		PlatePreparation->{
			Format->Single,
			Class->Expression,
			Pattern:>PreparationMethodP,
			Description->"Specifies if the test plate is to be prepared manually or robotically.",
			Category->"Qualification Parameters"
		},
		BufferModel->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The model of the buffer that will be used in this Qualification.",
			Category->"Qualification Parameters"
		},
		PlateVolumeTolerances->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"For each member of PlateSampleVolumes, the amount above or below the expected volume that the measured volume may deviate by to be considered a pass.",
			Category->"Passing Criteria",
			IndexMatching->PlateSampleVolumes
		},
		EmptyWellDistanceTolerance->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimeter],
			Units->Millimeter,
			Description->"The amount above or below the expected empty distance that the readings may deviate by to be considered a pass.",
			Category->"Passing Criteria"
		}
	}
}];
