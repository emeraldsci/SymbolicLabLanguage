(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, ElectrochemicalReactionVesselHolder], {
	Description->"Model information about a part that physically holds and electrically connects one or more electrochemical reaction vessels and also electrically connects to the electrochemical reactor instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NumberOfReactionVessels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "Indicates the number of electrochemical reaction vessels this part can hold and electrically connect.",
			Category -> "General"
		}
	}
}];
