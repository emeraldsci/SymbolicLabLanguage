(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Flush], {
	Description->"A protocol that flushes the flow path of a fluid chromatography instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		IdleFlush -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the flush continues after the instrument is released from the maintenance.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "A field used to enable calling of subprocedures from a protocol that dereferences through the Instrument field.",
			Category -> "General",
			Developer -> True
		},
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel A of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel B of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel C of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The solvent pumped through channel D of the flow path.",
			Category -> "General",
			Abstract -> True
		},
		FlushTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0*Second],
			Description -> "The estimated completion time for the flush.",
			Category -> "General",
			Developer -> True
		},
		SequenceDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The directory for the queue file.",
			Category -> "General",
			Developer -> True
		},
		InitialBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferA immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferB immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferC immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferD immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferA taken immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferB taken immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferC taken immediately before the experiment is started.",
			Category -> "General"
		},
		InitialBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferD taken immediately before the experiment is started.",
			Category -> "General"
		},
		FinalBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferA immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferB immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferC immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferD immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferA taken immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferB taken immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferC taken immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		FinalBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferD taken immediately after the experiment is completed.",
			Category -> "Gradient"
		},
		TubingRinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse buffers lines before and after and the maintenance.",
			Category -> "Cleaning"
		},
		PurgeWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Vessel],
				Model[Container, Vessel]
			],
			Description -> "The container used to hold waste from rinsing plumbing connections.",
			Category -> "Cleaning"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing buffers needed to run the maintenance onto the instrument buffer deck.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of solvents over time used to purge the instrument lines at the end.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushWorklistFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file describing the system flush imported onto the system.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushImportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that can be imported the protocol into the software for the system flush.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system flush raw data to the server.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushSequenceName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The software sequence name for the protocol's system flush.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Maintenance],
			Description -> "The chromatography traces generated for the system flush run.",
			Category -> "Experimental Results",
			Developer->True
		}
	}
}];
