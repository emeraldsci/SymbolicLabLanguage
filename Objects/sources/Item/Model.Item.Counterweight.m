(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Counterweight], {
	Description->"Model information for a precisely weighted container used to counterbalance a centrifuge.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The nominal net weight of this counterweight, including container, contents, and plate seal.",
			Category -> "Item Specifications"
		},
		Counterweights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel][Counterweights],
				Model[Container, Plate][Counterweights],
				Model[Container, Plate,Irregular][Counterweights]
			],
			Description -> "The container models for which this part can be used as a counterweight.",
			Category -> "Model Information"
		},
		LiquidHandlerPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique labware ID string prefix used to reference this model of container on a robotic liquid handler.",
			Category -> "General",
			Developer->True
		},
		BottomCavity3D -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli,Meter Milli},
			Description -> "A list of internal rectangular cross sections describing the empty space at the bottom of an item that can be placed on the liquid handler deck.",
			Headers -> {"X dimension","Y dimension","Z height"},
			Category -> "Dimensions & Positions"
		},
		GripHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance the liquid handler arms should grip below the top edge of the magnetization rack to move it across the liquid handler deck.",
			Category -> "Item Specifications",
			Developer -> True
		}
	}
}];
