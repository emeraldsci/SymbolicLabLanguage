

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report], {
	Description->"A record of an event, transaction, or piece of information.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
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
