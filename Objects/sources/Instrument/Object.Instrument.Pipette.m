

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Pipette], {
	Description->"Handheld device for small volume liquid transfer.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		PipetteType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],PipetteType]],
			Pattern :> PipetTypeP,
			Description -> "Type and scale of pipette used.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Controller -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Controller]],
			Pattern :> Analog | Digital,
			Description -> "Describes how the required volume is set on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Capabilities -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Capabilities]],
			Pattern :> PipetCapabilitiesP,
			Description -> "Advanced capabilities of the pipette beyond just aspiration and dispensing.",
			Category -> "Instrument Specifications"
		},
		Channels -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Channels]],
			Pattern :> GreaterP[0, 1],
			Description -> "Number of redundant channels the pipette has.",
			Category -> "Instrument Specifications"
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinVolume]],
			Pattern :> GreaterEqualP[0*Liter*Milli],
			Description -> "Minimum amount of volume the pipette can transfer.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxVolume]],
			Pattern :> GreaterEqualP[0*Liter*Milli],
			Description -> "Maximum amount of volume the pipette can transfer.",
			Category -> "Operating Limits"
		},
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0*Liter],
			Description -> "The smallest interval which can be measured by this pipette.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TipTypes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TipTypes]],
			Pattern :> {ObjectP[Model[Item,Tips]]..},
			Description -> "The models of tips compatible with this pipette.",
			Category -> "Operating Limits"
		}
	}
}];
