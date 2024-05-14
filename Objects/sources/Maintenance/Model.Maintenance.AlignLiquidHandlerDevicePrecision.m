(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance,AlignLiquidHandlerDevicePrecision],{
	Description->"Definition of a set of parameters for a maintenance protocol that tests and adjusts the alignment of a liquid handler's dispensing channels.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ChannelCalibrationTool->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,AlignmentTool],
			Description->"The tool used to check that the positioning and tilt of the pipetting channels are within allowed limits.",
			Category->"General"
		},
		ChannelPositioningTool->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,AlignmentTool],
			Description->"The tool used to adjust the x-position and tilt of the pipetting channels to bring them into allowed limits.",
			Category->"General"
		},
		ManualAlignmentFilePath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The location of the macro program that is used to perform manual alignment of the pipetting channels.",
			Category->"General",
			Developer->True
		},
		AlignmentFilePath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The location of the macro program that is used to perform automated alignment of the pipetting channels.",
			Category->"General",
			Developer->True
		},
		AlignmentCheckFilePath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The location of the macro program that is used to perform a final check on pipetting channel alignment.",
			Category->"General",
			Developer->True
		},
		LeftTrack->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The track position near the left edge of the instrument deck where the channel calibration tool will be placed.",
			Category->"General"
		},
		RightTrack->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The track position near the right edge of the instrument deck where the channel calibration tool will be placed.",
			Category->"General"
		},
		AdjustmentScrewdriver->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Screwdriver],
			Description->"The screwdriver used to make fine adjustments to channel offset and tilt.",
			Category->"General"
		},
		FasteningScrewdriver->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Screwdriver],
			Description->"The screwdriver used to tightly fasten the channel positioning tool to the channels.",
			Category->"General"
		},
		Wrenches->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Wrench],
			Description->"The wrenches used to loosen and tighten the channel and to make fine adjustments to offset and tilt.",
			Category->"General"
		},
		DeckWrenches->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Wrench],
			Description->"The wrenches used to loosen and tighten immovable carriers.",
			Category->"General"
		},
		CoverTool->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Wrench],
			Description->"The tool required to remove and reattach the liquid handler's face plate.",
			Category->"General"
		}
	}
}];
