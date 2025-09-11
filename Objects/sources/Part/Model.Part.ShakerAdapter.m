(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, ShakerAdapter], {
	Description->"Model information for an adapter that is used to connect vessels/plates to a shaker instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Positions -> {
			Format -> Multiple,
			Class -> {Name->String,Footprint->Expression,MaxWidth->Real,MaxDepth->Real,MaxHeight->Real},
			Pattern :> {Name->LocationPositionP,Footprint->(FootprintP|Open),MaxWidth->GreaterP[0 Centimeter],MaxDepth->GreaterP[0 Centimeter],MaxHeight->GreaterP[0 Centimeter]},
			Units -> {Name->None,Footprint->None,MaxWidth->Meter,MaxDepth->Meter,MaxHeight->Meter},
			Description -> "Spatial definitions of the positions that exist in this model of container.",
			Headers->{Name->"Name of Position",Footprint->"Footprint",MaxWidth->"Max Width",MaxDepth->"Max Depth",MaxHeight->"Max Height"},
			Category -> "Dimensions & Positions"
		},
		CompatibleMixers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Shaker][CompatibleAdapters],
			Description -> "Shakers that can use this shaker adapter.",
			Category -> "Model Information"
		}
	}
}];
