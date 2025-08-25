(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Rebuild, Pump], {
	Description->"A protocol that makes extensive repairs to an HPLC pump.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ToolBox->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->(Model[Container, Box]|Object[Container, Box]),
			Description->"The tool box which stores pump maintenance tools.",
			Category -> "General"
		},
		PrimeBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The buffer used to rinse the pump to remove toxic solutions.",
			Category -> "General"
		},
		FlushBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Sample]|Object[Sample]),
			Description -> "The buffer used to run in new piston seals.",
			Category -> "General"
		},
		FlowRestrictor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Part,FlowRestrictor]|Object[Part,FlowRestrictor]),
			Description -> "The capillary that can generate high back pressure used to run in new piston seals.",
			Category -> "General"
		},
		CheckValves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Part,CheckValve]|Object[Part,CheckValve]),
			Description -> "The new check valves for the replacement during this maintenance.",
			Category -> "General"
		},
		PistonSeals -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Part,Seal]|Object[Part,Seal]),
			Description -> "The new piston seals for the replacement during this maintenance.",
			Category -> "General"
		},
		Pistons -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Part,Piston]|Object[Part,Piston]),
			Description -> "The new pistons for the replacement during this maintenance. They will be replaced only if the old ones are damaged.",
			Category -> "General"
		},
		RemovedParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Object[Sample],
				Object[Container],
				Object[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Replaced parts.",
			Category -> "General"
		},
		ConnectedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instrument to which the target instrument connected.",
			Category -> "General"
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
		WasteBeaker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Container, Vessel]|Object[Container, Vessel]),
			Description -> "A beaker used to drain liquid waste from the pump.",
			Category -> "Cleaning"
		}
	}
}];
