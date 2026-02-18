(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RestockLocalCache], {
	Description->"Definition of a set of parameters for a maintenance protocol that stocks Instrument local caches.",
	CreatePrivileges->None,
	Cache->Session,
  Fields -> {

    MaxResources -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0],
      Description -> "The maximum number of resources RestockLocalCache is able to request for an individual Maintenance.",
      Category -> "Qualifications & Maintenance",
      Abstract -> True
    }
  }

}];