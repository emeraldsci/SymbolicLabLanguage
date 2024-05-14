

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, VacuumManifold], {
	Description->"A device that removes liquid from attached cartriges by creating a partial vacuum.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		ConnectionType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ConnectionType]],
			Pattern :> ConnectorP,
			Description -> "Indicates the way that cartridges are connected to this instrument.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Instrument Specifications"
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][VacuumManifold],
			Description -> "The vacuum pump that provides the pressure differential to create a vacuum in the manifold.",
			Category -> "Integrations"
		}
	}
}];
