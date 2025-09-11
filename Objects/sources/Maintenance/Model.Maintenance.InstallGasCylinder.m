(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, InstallGasCylinder], {
	Description -> "Definition of a set of parameters for a maintenance protocol that installs a new gas cylinder.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		ExchangeableCylinder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a cylinder placed during InstallGasCylinder.",
			Category -> "General",
			Developer -> True
		},
		GasLineConnection -> {
			Format -> Single,
			Class -> {Link, Expression},
			Pattern :> {_Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null},
			Description -> "The object and connector in the lab that this gas cylinder will be directly connected to.",
			Headers -> {"Lab Gas Line", "Lab Gas Line Connector"},
			Category -> "General"
		},
		CylinderConnector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorNameP,
			Description -> "The connector on the gas cylinder that will be used to connect it to the gas line in the lab.",
			Category -> "General"
		},
		CryogenicGloves -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Glove],
			Description -> "The type of cryo gloves worn to protect the hands from ultra low temperature surfaces/fluids.",
			Category -> "Health & Safety"
		},
		WrenchType -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Wrench],
			Description -> "The type of wrench required for adjusting connections or valves on the gas cylinder.",
			Category -> "General"
		}
	}
}];
