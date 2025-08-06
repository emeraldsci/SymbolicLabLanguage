

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, WaterPurifier], {
	Description->"Model information for an instrument that filters and purifies tap water for use in sensitive laboratory applications.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		WaterGenerated -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The type of water that this instrument dispenses.",
			Category -> "Instrument Specifications"
		},
		ParticulateFilter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "Minimum size of particles filtered out from the pure water.",
			Category -> "Instrument Specifications"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum rate at which the purifier can deliver pure water from storage.",
			Category -> "Operating Limits"
		},
		MaxPurificationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum rate at which the purifier can purify water from the tap to fill pure storage.",
			Category -> "Operating Limits"
		},
		StorageCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "Volume of pure water the purifier can store.",
			Category -> "Operating Limits"
		},
		MinResistivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Mega*Ohm)*(Centi*Meter)],
			Units -> Centi Mega Meter Ohm,
			Description -> "Minimum acceptable resistivity of the purified water.",
			Category -> "Operating Limits"
		},
		MaxResistivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Mega*Ohm)*(Centi*Meter)],
			Units -> Centi Mega Meter Ohm,
			Description -> "Maximum resistivity the purified water can reach.",
			Category -> "Operating Limits"
		},
		MinTotalOrganicContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPB],
			Units -> PPB,
			Description -> "Minimum total organic content the purified water can reach.",
			Category -> "Operating Limits"
		},
		MaxTotalOrganicContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PPB],
			Units -> PPB,
			Description -> "Maximum acceptable total organic content of the purified water.",
			Category -> "Operating Limits"
		},
		MaxDNase -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Gram*Nano))/(Liter*Milli)],
			Units -> (Gram Nano)/(Liter Milli),
			Description -> "Maximum concentration of DNase the pure water should contain.",
			Category -> "Operating Limits"
		},
		MaxRNase -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Gram*Nano))/(Liter*Milli)],
			Units -> (Gram Nano)/(Liter Milli),
			Description -> "Maximum concentration of RNase the pure water should contain.",
			Category -> "Operating Limits"
		},
		QRCode -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether this model of instrument can display a scannable quick response code summary of the quality report it generates while dispensing water.",
			Category -> "Instrument Specifications"
		}
	}
}];
