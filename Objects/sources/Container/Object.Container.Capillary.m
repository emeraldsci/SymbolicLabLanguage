

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Capillary], {
	Description->"An instance of a very narrow cylindrical tube that is used to perform experiments on small amounts of samples.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		CapillaryLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CapillaryLength]],
			Pattern :> GreaterP[0*Centimeter],
			Description -> "The distance from one end to the other end of the capillary tube.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		InnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InnerDiameter]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The largest distance between the inner side of walls of a capillary tube.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		OuterDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], OuterDiameter]],
			Pattern :> GreaterP[0*Millimeter],
			Description -> "The largest distance between the outer side of walls of a capillary tube.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		CapillaryType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CapillaryType]],
			Pattern :> Open|Closed,
			Description -> "Indicates if the capillary is Open capillary is both ends or just one end.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		Barcode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Barcode]],
			Pattern :> BooleanP,
			Description -> "Indicates if this capillary should have a barcode sticker placed on it. If a capillary is not barcoded (which is often the case), it is placed in a case for carriage purposes or in instrument positions. If set to Null, indicates that the capillary is not barcoded.",
			Category -> "Physical Properties"
		}
	}
}];
