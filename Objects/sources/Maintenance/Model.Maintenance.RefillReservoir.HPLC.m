(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RefillReservoir, HPLC], {
	Description->"Definition of a set of parameters for a maintenance protocol that refills a liquid chromatography system's reservoir.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		ReservoirFieldName -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FieldP[Output->Short],
			Description -> "The field name in the instrument where the reservoir container is stored.",
			Category -> "General"
		}

	}
}];
