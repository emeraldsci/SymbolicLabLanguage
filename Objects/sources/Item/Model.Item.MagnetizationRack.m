(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,MagnetizationRack],{
	Description->"Model information for a magnetization rack used for magnetic bead separation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		LiquidHandlerPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique labware ID string prefix used to reference this model of magnetization rack on a robotic liquid handler.",
			Category->"General",
			Developer->True
		},
		MagnetFootprint->{
			Format->Single,
			Class->Expression,
			Pattern:>FootprintP,
			Description->"Form factor of the container that can be magnetized by this model of magnetization rack.",
			Category->"Dimensions & Positions"
		},
		Capacity->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			Units->None,
			Description->"Number of containers that can be magnetized by this model of magnetization rack simultaneously.",
			Category->"Dimensions & Positions"
		},
		GripHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance the liquid handler arms should grip below the top edge of the magnetization rack to move it across the liquid handler deck.",
			Category -> "Item Specifications",
			Developer -> True
		},
		BottomCavity3D -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli,Meter Milli},
			Description -> "A list of internal rectangular cross sections describing the empty space at the bottom of an item that can be placed on the liquid handler deck.",
			Headers -> {"X dimension","Y dimension","Z height"},
			Category -> "Dimensions & Positions"
		}
	}
}];
