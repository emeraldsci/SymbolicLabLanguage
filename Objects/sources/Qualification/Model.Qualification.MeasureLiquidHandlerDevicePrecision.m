(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,MeasureLiquidHandlerDevicePrecision],{
	Description->"Definition of a set of parameters for a qualification protocol that verifies the alignments of a liquid handler's dispensing channels.",
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
		ManualAlignmentFilePath->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The location of the macro program that is used to perform measurement of the pipetting channels.",
			Category->"General",
			Developer->True
		},
		LeftTrack->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The track position near the left edge of the instrument deck where the channel calibration tool will be placed.",
			Category->"General"
		}
	}
}];
