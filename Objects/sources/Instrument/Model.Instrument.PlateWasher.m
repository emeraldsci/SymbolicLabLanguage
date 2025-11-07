(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, PlateWasher], {
	Description -> "A device to automatically wash microplates.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		NumberOfChannels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "Indicates how many wells the washer can dispense liquid into or aspirate from at the same time.",
			Category -> "Instrument Specifications"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Deck],
			Description -> "The model of deck container used to house buffers, buffer caps and sensors.",
			Category -> "Instrument Specifications"
		},
		MixModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The shaking pattern that this plate washer model is capable of performing during mixing.",
			Category -> "Instrument Specifications"
		},
		MinDispenseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Microliter,
			Description -> "The minimum volume that this plate washer model can dispense into each well per wash cycle.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxDispenseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Microliter,
			Description -> "The maximum volume that this plate washer model can dispense into each well per wash cycle.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MinRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "Minimum speed by which the plate washer can shake the plate.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "Maximum speed by which the plate washer can shake the plate.",
			Category -> "Operating Limits"
		},
		RotationRateConversion -> {
			Format -> Multiple,
			Class -> {Relative -> Expression, Scientific -> Real},
			Pattern :> {Relative -> Alternatives[Slow, Medium, Fast], Scientific -> GreaterEqualP[0 RPM]},
			Units -> {Relative -> None, Scientific -> RPM},
			Description -> "The correlation between relative RotationRate of the plate washer to absolute scientific unit. It is common to specify RotationRate as relative rate (Slow, Medium, Fast) for Agilent plate washer.",
			Headers -> {Relative -> "Relative Rate", Scientific -> "Scientific unit"},
			Category -> "Aspiration"
		},
		MinAspirateTravelRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter/Second],
			Units -> Millimeter/Second,
			Description -> "The minimum speed at which the plate washer manifold moves downward into the wells.",
			Category -> "Aspiration"
		},
		MaxAspirateTravelRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter/Second],
			Units -> Millimeter/Second,
			Description -> "The maximum speed at which the plate washer manifold moves downward into the wells.",
			Category -> "Aspiration"
		},
		AspirateTravelRateConversion -> {
			Format -> Multiple,
			Class -> {Relative -> Integer, Scientific -> Real},
			Pattern :> {Relative -> _Integer, Scientific -> GreaterEqualP[0 Millimeter/Second]},
			Units -> {Relative -> None, Scientific -> Millimeter/Second},
			Description -> "The correlation between relative AspirationTravelRate of the plate washer to absolute scientific unit. It is common to specify AspirateTravelRate as relative rate (1 to 5) for Agilent plate washer.",
			Headers -> {Relative -> "Relative Rate", Scientific -> "Scientific unit"},
			Category -> "Aspiration"
		},
		MinDispenseFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The lowest speed at which fluid can be dispensed from the manifold tubes of this plate washer model.",
			Category -> "Operating Limits"
		},
		MaxDispenseFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter/Second],
			Units -> Microliter/Second,
			Description -> "The fastest speed at which fluid can be dispensed from the manifold tubes of this plate washer model.",
			Category -> "Operating Limits"
		},
		DispenseFlowRateConversion -> {
			Format -> Multiple,
			Class -> {Relative -> Integer, Scientific -> Real},
			Pattern :> {Relative -> _Integer, Scientific -> GreaterEqualP[0 Microliter/Second]},
			Units -> {Relative -> None, Scientific -> Microliter/Second},
			Description -> "The correlation between relative DispenseFlowRate of the plate washer to absolute scientific unit. It is common to specify DispenseFlowRate as relative rate (3 to 11) for Agilent plate washer.",
			Headers -> {Relative -> "Relative Rate", Scientific -> "Scientific unit"},
			Category -> "Aspiration"
		},
		MinDispenseVacuumDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Microliter,
			Description -> "The minimum dispensed volume per well after which the vacuum pump is triggered to start normal aspiration when dispense vacuum delay is on.",
			Category -> "Dispensing"
		},
		MaxDispenseVacuumDelay -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Microliter,
			Description -> "The maximum dispensed volume per well after which the vacuum pump is triggered to start normal aspiration when dispense vacuum delay is on.",
			Category -> "Dispensing"
		}
	}
}];
