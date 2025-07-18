(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the functionality of a target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Purpose -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The purpose or intent of this model Qualification.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person(s) who created this Qualification model.",
			Category -> "Organizational Information"
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model Qualification is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Suspended -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model Qualification is temporarily excluded from automatic enqueuing because it requires changes.",
			Category -> "Organizational Information",
			Abstract -> True,
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Targets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument][QualificationFrequency, 1],
				Model[Container][QualificationFrequency, 1],
				Model[Sample][QualificationFrequency, 1],
				Model[Sensor][QualificationFrequency, 1],
				Model[Part][QualificationFrequency, 1],
				Model[Item][QualificationFrequency, 1],
				Model[User][QualificationFrequency, 1]
			],
			Description -> "The object that this model of Qualification is designed to assess.",
			Category -> "Qualifications & Maintenance"
		},
		QualificationFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Targets], Field[Object]}, Computables`Private`qualificationFrequenciesComputable[Field[Targets], Field[Object]]],
			Pattern :> {{ObjectReferenceP[{Model[Instrument], Model[Container], Model[Sample], Model[Sensor], Model[Part], Model[Item]}], GreaterP[0*Day] | Null}..},
			Description -> "A list of the targets and their required frequencies in the form: {target Object, time interval}.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		PassLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Qualification]},
			Units -> {None, None},
			Description -> "A historical record of the Qualifications that passed.",
			Category -> "Experimental Results",
			Headers -> {"Date","Qualification"}
		},
		FailLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Object[SupportTicket]},
			Units -> {None, None, None},
			Description -> "A historical record of the Qualifications that failed.",
			Category -> "Experimental Results",
			Headers -> {"Date","Qualification","Troubleshooting"}
		},
		PreparatoryUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers, consolidations, aliquiots, mixes and diutions that will be performed in the order listed to prepare samples for the qualification.",
			Category -> "Sample Preparation"
		},
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		},
		AutomaticExecution -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this qualification model executes automatically without requiring operator input.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		AutomaticExecutionFunction -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The full name of the function to be called in order to execute the automatic qualification.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		AutomaticEvaluation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this qualification model evaluates automatically without requiring a developer to review the Qualification Notebook.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		ScheduleOverride -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Always,Never],
			Description -> "Indicates if this Qualification should Always, or Never be enqueued by the automatic qualification scheduling function, overriding normal scheduling behavior based on frequency and NextQualificationDate.",
			Category-> "Qualifications & Maintenance",
			Developer -> True
		},
		LiteratureReferences -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Object[Report, Literature][References]},
			Description -> "A list of primary literature sources that were referenced to design this qualification model.",
			Category -> "Qualifications & Maintenance",
			Headers->{"Label","Report"}
		}
	}
}];
