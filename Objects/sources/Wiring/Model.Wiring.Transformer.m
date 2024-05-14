(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Wiring, Transformer], {
	Description -> "Model information regarding an electrical component that directs electricity between circuits and has the ability to control the output voltage.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		ElectricalPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ElectricalPhaseP,
			Description -> "The type of alternating current this model of transformer distributes.",
			Category -> "Wiring Information"
		},
		
		TransformerType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TransformerTypeP,
			Description -> "The function of this model of transformer in controlling the output voltage.",
			Category -> "Wiring Information"
		},

		MaxVoltAmperes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0 Volt*Ampere],
			Units -> Volt*Ampere,
			Description -> "The volt-ampere rating for this model of transformer, which will cause damage if exceeded.",
			Category -> "Wiring Information"
		},

		InputVoltage -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Voltages that can be accepted by this model of transformer.",
			Category -> "Wiring Information"
		},

		OutputVoltage -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Voltages that this model of transformer can output from the input voltage.",
			Category -> "Wiring Information"
		}

	}
}];
