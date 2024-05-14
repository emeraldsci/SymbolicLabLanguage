(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, SwagingTool], {
	Description->"A model for a tool used to pre-swage a ferrule to a piece of tubing",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Gender -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorGenderP,
			Description -> "Indicates whether the swaging tool contains outward facing (male) or inward facing (female) threading.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "The mechanism by which this swaging tool connects to its mating part.",
			Category -> "Plumbing Information",
			Abstract -> True
		},
		ThreadType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ThreadP,
			Description -> "The measurement of the helical grooves on this swaging tool that fit into the helical grooves of a mating part and draw the two parts together or apart when their relative rotation is changed.",
			Category -> "Plumbing Information",
			Abstract -> True
		}
	}
}];
