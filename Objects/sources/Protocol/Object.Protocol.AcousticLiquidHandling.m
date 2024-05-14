(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,AcousticLiquidHandling],{
	Description->"A protocol for moving liquid samples in the form of transfers, consolidations, and aliquots by using an acoustic liquid handler.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		(* ---------- Primitives Fields ---------- *)
		Manipulations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"A list of transfers, consolidations, and, aliquots in the order they are to be performed.",
			Category->"General",
			Abstract->True
		},
		ResolvedManipulations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"A list of manipulations in the order they are performed with all models resolved to samples.",
			Category->"General"
		},

		(* ---------- Objects Fields ---------- *)
		LiquidHandler->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description->"The acoustic liquid handler used to transfer liquid between the samples.",
			Category->"General",
			Abstract->True
		},
		RequiredObjects->{
			Format->Multiple,
			Class->{Expression,Link},
			Pattern:>{_String|_Symbol|ObjectReferenceP[]|_List|(_Symbol[_Integer,_Symbol]),_Link},
			Relation->{Null,Object[Container]|Model[Container]|Object[Sample]|Model[Sample]},
			Headers->{"Unique Identifier","Required Object"},
			Description->"Objects required for the protocol. The first element corresponds to an identifier for the object. The second element is fulfilled to the object used.",
			Category->"General",
			Developer->True
		},

		(* ---------- Looping Plate Placement Fields ---------- *)

		PlatePlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container,Plate],Null},
			Description->"A list of placement sequence used to place the source and destination plates into the correct position of an acoustic liquid handler.",
			Category->"General",
			Developer->True,
			Headers->{"Plate Object","Destination Position"}
		},
		PlateRemovals->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Plate],
			Description->"A list of plates to be removed from an acoustic liquid handling in the correct sequence.",
			Category->"General",
			Developer->True
		},
		InitialSourcePlacement->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container,Plate],Null},
			Description->"First placement to place the source plate into the correct position of an acoustic liquid handler.",
			Category->"General",
			Developer->True,
			Headers->{"Plate Object","Destination Position"}
		},
		InitialDestinationPlacement->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container,Plate],Null},
			Description->"First placement to place the destination plate into the correct position of an acoustic liquid handler.",
			Category->"General",
			Developer->True,
			Headers->{"Plate Object","Destination Position"}
		},
		FinalSource->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Plate],
			Description->"Final source plate to be removed from an acoustic liquid handler.",
			Category->"General",
			Developer->True
		},
		FinalDestination->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Plate],
			Description->"Final destination plate to be removed from an acoustic liquid handler.",
			Category->"General",
			Developer->True
		},


		(* ---------- General ---------- *)
		RunTime->{
			Format->Single,
			Class->Expression,
			Pattern:>_?TimeQ,
			Description->"The estimated time for completion of the liquid handling portion of the protocol.",
			Category->"General",
			Developer->True
		},
		PreMeasureVolume->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the well volume of the samples are measured by the acoustic liquid handling prior to dispensing.",
			Category->"General",
			Developer->True
		},
		FluidTypeCalibration->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AcousticLiquidHandlerCalibrationTypeP,
			Description->"Indicates the fluid type calibration for each input primitive to be used by the acoustic liquid handler.",
			Category->"General"
		},
		InWellSeparation->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates how the droplets of different samples are transferred into the same destination well. If True, the droplets are targeted to be spatially separated to avoid mixing with each other until additional volume is added to the well.",
			Category->"General"
		},
		PercentDMSOMeasurement->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the DMSO concentration of the samples are measured by the acoustic liquid handler prior to dispensing.",
			Category->"General",
			Developer->True
		},
		PercentGlycerolMeasurement->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the glycerol concentration of the samples are measured by the acoustic liquid handler prior to dispensing.",
			Category->"General",
			Developer->True
		},

		(* ----------File Handling ---------- *)
		MethodFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the protocol file which contains the experiment parameters.",
			Category->"General",
			Developer->True
		},
		MethodFileName->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The name of the protocol file containing the experiment parameters.",
			Category->"General",
			Developer->True
		},
		DataFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category->"General",
			Developer->True
		},
		DataFileName->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the data file generated at the conclusion of the experiment.",
			Category->"General",
			Developer->True
		},
		LabwareDefinitionFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the folder containing the labware definition file which contains the plate's parameters.",
			Category->"General",
			Developer->True
		},
		LabwareDefinitionFileName->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"The file path of the labware definition file(s) which contains the plate's parameters.",
			Category->"General",
			Developer->True
		},
		DestinationPlateTypes->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The destination plate types to be inputted to the Echo Plate Reformat software when generating a run protocol.",
			Category->"General",
			Developer->True
		},
		SourcePlateFormats->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The source plate formats to be inputted to the Echo Plate Reformat software when generating a run protocol.",
			Category->"General",
			Developer->True
		},
		EchoDataFileReferenceID->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The reference ID used to create a name for a raw data file generated by an Echo Acoustic Liquid Handler.",
			Category->"General",
			Developer->True
		}
	}
}
];