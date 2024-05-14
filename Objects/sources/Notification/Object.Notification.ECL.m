(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notification, ECL], {
	Description -> "A broadly distributed notification containing information regarding general operation of the ECL.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* --- Team and Recipient Information *)
		Team -> {
			Format -> Single, 
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team],
			Description -> "The team to which this notification applies.",
			Abstract -> True,
			Category -> "Organizational Information"
		},

		(* --- Notification Information *)
		ECLEvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ECLEventP,
			Description -> "The type of ECL-wide event announced by this notification, such as the addition of a new experiment or a software update.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		Application -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ECLApplicationP,
			Description -> "The ECL application that has been updated.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		VersionNumber -> {
			Format -> Single, 
			Class -> String,
			Pattern :> VersionNumberP,
			Description -> "The new version number of the application.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		URL -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "A URL containing further information regarding this notification.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		FeatureDescription -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "One or more sentences describing the new feature(s) added to the ECL platform.",
			Abstract -> True,
			Category -> "Notification Information"
		}
		
	}
}]
