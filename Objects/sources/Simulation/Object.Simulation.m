(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Simulation], {
	Description->"A computerized approximation of a physical process intended to predict the outcome of that process.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		(* --- Organizational Information --- *)
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ProtocolStatusP,
			Description -> "The current status of the simulation.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User][SimulationsAuthored],
			Description -> "The person who requested this simulation.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateConfirmed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the simulation first entered processing or a backlog.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateEnqueued -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the simulation first entered processing or a backlog.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateStarted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date when this simulation was started.",
			Category -> "Organizational Information"
		},
		DateCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date when this simulation was completed.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DateCanceled -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date when this simulation was canceled.",
			Category -> "Organizational Information"
		},
		TimeElapsed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[DateCompleted], Field[DateStarted]}, Computables`Private`timeElapsed[Field[DateCompleted], Field[DateStarted]]],
			Pattern :> GreaterEqualP[0*Day],
			Description -> "The time that was required to complete the simulation.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		
		(* --- Option Handling --- *)
		UnresolvedOptions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_Rule...},
			Units -> None,
			Description -> "The unresolved options entered into the simulation function that generated this object.",
			Category -> "Option Handling"
		},
		ResolvedOptions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {_Rule...},
			Units -> None,
			Description -> "The options resolved automatically by this simulation or entered by the requestor.",
			Category -> "Option Handling"
		},
		
		(* --- Migration Support --- *)
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
