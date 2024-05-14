(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Program], {
	Description->"A set of parameters specifying the handling of a group of samples on automated instrumentation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* --- Organizational Information --- *)
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		
		(* --- Method Information --- *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instrument on which the program was run.",
			Category -> "General",
			Abstract -> True
		},
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, AbsorbanceQuantification][AbsorbanceQuantificationProgram],
				Object[Protocol, cDNAPrep][cDNAPrepProgram],
				Object[Protocol, CellMediaChange][CellMediaChangeProgram],
				Object[Protocol, CellSplit][CellSplitProgram],
				Object[Protocol, ProteinPrep][ProteinPrepProgram],
				Object[Protocol, SampleManipulation][MacroTransfers],
				Object[Protocol, SampleManipulation][SolventTransfers],
				Object[Protocol, SampleManipulation][CompletedSolventTransfers],
				Object[Protocol, SampleManipulation][InSituSolventTransfer],
				Object[Protocol, SampleManipulation][DispensingPrograms],
				Object[Protocol, SampleManipulation][InSituSolventTransfer],
				Object[Protocol, FluorescenceThermodynamics][LiquidHandlerProgram],
				Object[Protocol, Transfection][TransfectionProgram],
				Object[Protocol, MitochondrialIntegrityAssay][MitochondrialIntegrityAssayProgram],
				Object[Protocol, FPLC][Programs],
				Object[Protocol, FPLC][SystemPrimeProgram],
				Object[Protocol, FPLC][SystemFlushProgram],
				Object[Protocol][ProcedureLog],
				Object[Qualification][ProcedureLog],
				Object[Maintenance][ProcedureLog],
				Object[Protocol, MeasureWeight][MeasureWeightPrograms],
				Object[Protocol, IncubateOld][IncubatePrograms],
				Object[Protocol, Centrifuge][CentrifugePrograms],
				Object[Protocol, MeasureVolume][VolumeMeasurements]
			],
			Description -> "The protocol that generated this program for use in an experiment.",
			Category -> "General"
		},
		Maintenance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Maintenance, CellBleach][CellBleachProgram],
				Object[Maintenance, ReceiveInventory][ReceiveInventoryPrograms]
			],
			Description -> "The maintenance protocol that generated this program.",
			Category -> "General"
		},
		Qualification -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Qualification, PipettingLinearity][DilutionProgram],
				Object[Qualification, EngineBenchmark][QualificationPrograms]
			],
			Description -> "The Qualification protocol that generated this program.",
			Category -> "General"
		},
		RequiredResources -> {
			Format -> Multiple,
			Class -> {Link, Expression, Integer, Expression},
			Pattern :> {_Link, _Symbol, _Integer, _Integer|_Symbol},
			Relation -> {Object[Resource][Requestor], Null, Null, Null},
			Units -> {None, None, None, None},
			Headers->{"Resource","Field Name","Field Position", "Field Index"},
			Description -> "All resources which will be used by this program and the field, ordinal, and index in this program to which they refer.",
			Category -> "Resources"
		},
		Distro-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Software,Distro],
			Description -> "The pre-built set of packages for a specific commit of SLL used to generate this program.",
			Category -> "Organizational Information",
			Developer -> True
		},
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
