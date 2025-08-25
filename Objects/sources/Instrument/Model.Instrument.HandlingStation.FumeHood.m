(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, HandlingStation, FumeHood], {
	Description->"The model of a ventilation device for working with potentially harmful chemical fumes and vapors while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FumeHoodTypeP,
			Description -> "The configuration of the fume hood based on its size and ventilation design. Options include, Benchtop (a standard hood mounted on a work surface), WalkIn (a larger hood designed to accommodate people or large equipment), or Recirculating (a compact, unvented hood that filters and returns air to the room).",
			Category -> "Instrument Specifications",
			Abstract -> True
		}
	}
}];
