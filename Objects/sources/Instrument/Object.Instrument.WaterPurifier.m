(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, WaterPurifier], {
	Description->"Ultra-pure water purification system for removing contaminants and salts from tap water.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		WaterGenerated -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],WaterGenerated]],
			Pattern :> ObjectReferenceP[Object[Model]],
			Description -> "The type of water that this instrument dispenses.",
			Category -> "Instrument Specifications"
		},
		AdditionalFiltering -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WaterFilterP,
			Description -> "Type of final purification filter attached to dispense head.",
			Category -> "Instrument Specifications"
		},
		ParticulateFilter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ParticulateFilter]],
			Pattern :> GreaterP[0*Micro*Meter],
			Description -> "Minimum size of particles filtered out from the pure water.",
			Category -> "Instrument Specifications"
		},
		IntegratedDispenser-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is connected to an on demand dispensing unit.",
			Category -> "Instrument Specifications"
		},
		MaxFlowRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlowRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "Maximum rate at which the purifier can deliver pure water from storage.",
			Category -> "Operating Limits"
		},
		MaxPurificationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxPurificationRate]],
			Pattern :> GreaterP[(0*Liter)/Minute],
			Description -> "Maximum rate at which the purifier can purify water from the tap to fill pure storage.",
			Category -> "Operating Limits"
		},
		StorageCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],StorageCapacity]],
			Pattern :> GreaterEqualP[0*Liter],
			Description -> "Volume of pure water the purifier can store.",
			Category -> "Operating Limits"
		},
		MinResistivity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinResistivity]],
			Pattern :> GreaterP[0*(Mega*Ohm)*(Centi*Meter)],
			Description -> "Minimum acceptable resistivity of the purified water.",
			Category -> "Operating Limits"
		},
		MaxResistivity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxResistivity]],
			Pattern :> GreaterP[0*(Mega*Ohm)*(Centi*Meter)],
			Description -> "Maximum resistivity the purified water can reach.",
			Category -> "Operating Limits"
		},
		MinTotalOrganicContent -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTotalOrganicContent]],
			Pattern :> GreaterEqualP[0*Percent],
			Description -> "Minimum total organic content the purified water can reach.",
			Category -> "Operating Limits"
		},
		MaxTotalOrganicContent -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTotalOrganicContent]],
			Pattern :> GreaterEqualP[0*Percent],
			Description -> "Maximum acceptable total organic content of the purified water.",
			Category -> "Operating Limits"
		},
		MaxDNase -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDNase]],
			Pattern :> GreaterP[(0*(Gram*Nano))/(Liter*Milli)],
			Description -> "Maximum concentration of DNase the pure water should contain.",
			Category -> "Operating Limits"
		},
		MaxRNase -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRNase]],
			Pattern :> GreaterP[(0*(Gram*Nano))/(Liter*Milli)],
			Description -> "Maximum concentration of RNase the pure water should contain.",
			Category -> "Operating Limits"
		}
	}
}];
