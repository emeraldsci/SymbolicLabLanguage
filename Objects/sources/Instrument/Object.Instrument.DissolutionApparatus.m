(* ::Text:: *)

(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, DissolutionApparatus], {
	Description->"Used for dissolving solid samples in a liquid in controlled conditions",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[(0*Revolution)/Second],
			Description -> "Maximum speed at which the vortex can spin samples.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterP[(0*Revolution)/Second],
			Description -> "Minimum speed at which the vortex can spin samples.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression -> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0 Kelvin],
			Description -> "Indicates the highest temperature that this instrument can heat the media.",
			Category -> "Instrument Specifications"
		},
		WastePump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, PeristalticPump][DissolutionApparatus],
			Description -> "Peristaltic pump that is used to drain waste liquid into the carboy after the experiment is completed.",
			Category -> "Instrument Specifications"
		},

		AutosamplerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform that contains the vials where the samples taken during the experiment are deposited.",
			Category -> "Dimensions & Positions"
		},

		(*gas information*)
		GasCylinder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder],
			Description -> "The Helium gas cylinder used to degas the dissolution medium before the experiment.",
			Category -> "Instrument Specifications"
		},
		HeliumDeliveryPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The digital gauge measuring the pressure on the instrument side of the regulator for the Helium gas tank.",
			Category -> "Sensor Information"
		},

		DissolutionVesselCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item,Cap],
			Description -> "The caps for the dissolution vessels.",
			Category -> "Instrument Specifications",
			Developer -> True
		}
	}
}];
