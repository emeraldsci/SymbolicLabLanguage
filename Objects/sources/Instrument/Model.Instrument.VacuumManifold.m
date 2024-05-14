

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, VacuumManifold], {
	Description->"The model of a device that removes liquid from attached cartriges by creating a partial vacuum.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "Indicates the way that cartridges are connected to this instrument.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Instrument Specifications"
		}
	}
}];
