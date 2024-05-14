(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[StorageCondition], {
	Description->"Parameters describing the specific environment in which a sample should be warehoused when not in use by an experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the storage condition.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		StorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP,
			Description -> "The shortcut symbol that refers to the genre of storage provided by this object.",
			Category -> "Storage Information"
		},
		CultureHandling -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureHandlingP,
			Description -> "Indicates the type of cell samples (Microbial or NonMicrobial) that can be stored under this condition (to prevent contamination). Refer to the patterns MicrobialCellTypeP and NonMicrobialCellTypeP for more information.",
			Category -> "Storage Information"
		},
		CellType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CellTypeP,
			Description -> "The primary types of cells that can be stored under this condition.",
			Category -> "Storage Information"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		Humidity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "The humidity at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		UVLightIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Watt)/Meter^2],
			Units -> Watt/Meter^2,
			Description -> "The UV light intensity at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		VisibleLightIntensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Lumen)/Meter^2],
			Units -> Lumen/Meter^2,
			Description -> "The visible light intensity at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		CarbonDioxide -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "The percent CO2 at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		ShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units -> RPM,
			Description -> "The shaking rate at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		PlateShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units -> RPM,
			Description -> "The shaking rate at which samples in plates with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		VesselShakingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units -> RPM,
			Description -> "The shaking rate at which samples in vessels (tubes and flasks) with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		ShakingRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Meter Milli,
			Description -> "The shaking radius at which samples with this storage condition are kept when not in use by any experiment.",
			Category -> "Storage Information"
		},
		Flammable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this storage condition is meant to contain samples that are easily set aflame under standard conditions.",
			Category -> "Health & Safety"
		},
		Acid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this storage condition is meant to contain acid samples requiring dedicated secondary containment.",
			Category -> "Health & Safety"
		},
		Base -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this storage condition is meant to contain base samples requiring dedicated secondary containment.",
			Category -> "Health & Safety"
		},
		Pyrophoric -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this storage condition is meant to contain samples that can ignite spontaneously upon exposure to air.",
			Category -> "Health & Safety"
		},
		Desiccated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this storage condition is meant to store moisture-sensitive items in a dry atmosphere requiring a sealable secondary enclosure.",
			Category -> "Storage Information"
		},
		AtmosphericCondition  -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AtmosphereP,
			Description -> "Indicates the atmospheric condition under which the samples are stored, for instance if the storage environment is held under vacuum or at ambient atmospheric pressure, or if the samples are kept in an inert atmosphere of argon or nitrogen gas.",
			Category -> "Storage Information"
		},
		PricingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD / (Month * Centimeter^3)],
			Units -> USD / (Month * Centimeter^3),
			Description -> "The pricing rate the ECL charges for storing items with this storage condition as a function of time and volume.",
			Category -> "Pricing Information",
			Developer->True
		},
		StockingPrices -> {
			Format -> Multiple,
			Class -> {
				UsageFrequency -> Expression,
				Price -> Real
			},
			Pattern :> {
				UsageFrequency -> UsageFrequencyP,
				Price -> GreaterEqualP[0*USD/(Meter^3)]
			},
			Units -> {
				UsageFrequency -> None,
				Price -> USD/(Meter^3)
			},
			Description -> "For each UsageFrequency category, the stocking cost associated with the purchase of a product stored in this storage condition as a function of their storage volume.",
			Category -> "Pricing Information",
			Developer->True
		}
	}
}];
