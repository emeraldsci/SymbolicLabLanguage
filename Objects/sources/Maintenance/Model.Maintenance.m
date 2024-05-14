(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance], {
	Description->"Definition of a set of parameters for a maintenance protocol that maintains the functionality of a target and keeps it operating to specification.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the model of maintenance, describing its purpose and intent.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who created this model of maintenance.",
			Category -> "Organizational Information"
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this type of maintenance is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Suspended -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model Maintenance is temporarily excluded from automatic enqueuing because it requires changes.",
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
				Model[Instrument][MaintenanceFrequency, 1],
				Model[Container][MaintenanceFrequency, 1],
				Model[Sample][MaintenanceFrequency, 1],
				Model[Sensor][MaintenanceFrequency, 1],
				Model[Part][MaintenanceFrequency, 1],
				Model[Item][MaintenanceFrequency, 1]
			],
			Description -> "The target model of object for which this model of Maintenance is designed to maintain.",
			Category -> "Qualifications & Maintenance"
		},
		MaintenanceFrequencies -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Targets], Field[Object]}, Computables`Private`maintenanceFrequenciesComputable[Field[Targets], Field[Object]]],
			Pattern :> {{ObjectReferenceP[{Model[Instrument], Model[Container], Model[Sample], Model[Sensor], Model[Part], Model[Item]}], GreaterP[0*Day] | Null}...},
			Description -> "A list of the targets and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Target","Time Interval"},
			Abstract -> True
		},
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		},
		ScheduleOverride -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Always,Never],
			Description -> "Indicates if this Maintenance should Always, or Never be enqueued by the automatic maintenance scheduling function, overriding normal scheduling behavior based on frequency and NextMaintenanceDate.",
			Category-> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}];
