

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,SpargingApparatus],{
	Description->"A model for a sparging degassing instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DegasType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DegasTypeP,
			Description ->"The category of degassing type.",
			Category -> "Instrument Specifications"
		},
		GasType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DegasGasP,
			Description ->"The type of gas used in the degasser.",
			Category -> "Instrument Specifications"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Minimum flow rate the flow regulator can manage that controls the amount of gas flowing through the SchlenkLine, which in turn controls the pressure of gas that can be used for sparging.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum flow rate the flow regulator can manage that controls the amount of gas flowing through the SchlenkLine, which in turn controls the pressure of gas that can be used for sparging.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		(*-Manifold-*)
		SchlenkLine -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,SchlenkLine],
			Description -> "The Schlenk line used as the vacuum and inert gas source during degassing.",
			Category -> "Instrument Specifications"
		},
		NumberOfChannels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of channels that the Schlenk line can be configured to connect with to comply with the instrument requirements for the Sparging Apparatus. This indicates how many samples can be run with sparging degassing simultaneously.",
			Category -> "Instrument Specifications"
		},

		Mixer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Model[Instrument, OverheadStirrer],
			Description -> "The mixer used to stir the solution as it is being degassed via the sparging method.",
			Category -> "General"
		},

		(*-Tubing and cap compatibility-*)
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "Indicates the way that containers are connected to this instrument to be used for sparging.",
			Category -> "Instrument Specifications"
		}
	}
}];