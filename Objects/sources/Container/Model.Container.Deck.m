
(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Deck], {
	Description->"Model information for a sample-holding platform on an automated instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		LiquidHandlerPositionIDs -> {
		    Format -> Multiple,
		    Class -> {String, String},
		    Pattern :> {LocationPositionP, _String},
		    Description -> "A table of SLL position names and their associated robotic liquid handler IDs.",
				Category -> "Dimensions & Positions",
		    Headers -> {"Position Name", "Liquid Handler ID"},
		    Developer -> True
		},
		LiquidHandlerPositionTracks -> {
			Format -> Multiple,
			Class -> {String, Integer, Integer},
			Pattern :> {LocationPositionP,_Integer, _Integer},
			Description -> "A table of SLL position names and their associated robotic liquid handler track numbers.",
			Category -> "Dimensions & Positions",
			Headers -> {"Position Name", "First Occupied Track", "Last Occupied Track"},
			Developer -> True
		},
		LiquidHandlerIntegrationPositionIDTypes -> {
			Format -> Multiple,
			Class -> {Expression, String},
			Pattern :> {HamiltonWorkCellPositionP, _String},
			Description -> "A table of integration types on this deck and their associated full (rack and position in rack) robotic liquid handler IDs.",
			Category -> "Dimensions & Positions",
			Headers -> {"Position Type", "Liquid Handler ID"},
			Developer -> True
		},
		LiquidHandlerMaxStackedPlateHeight -> {
			Format -> Single,
			Class -> Real,
			Units -> Millimeter,
			Pattern :> GreaterP[0 Millimeter],
			Description -> "The maximum allowed plate stack height of the most restrictive position (with the least clearance) on the robotic liquid handler deck.",
			Category -> "Dimensions & Positions",
			Developer -> True
		},
		(* DEPRECATED DO NOT USE. *)
		IncubatePositionIDs -> {
		    Format -> Multiple,
		    Class -> String,
		    Pattern :> _String,
		    Description -> "A list of robotic liquid handler position IDs where a device exists that can heat and shake.",
				Category -> "Dimensions & Positions",
		    Developer -> True
		}
	}
}];
