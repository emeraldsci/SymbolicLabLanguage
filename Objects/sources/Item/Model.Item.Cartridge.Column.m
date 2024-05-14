DefineObjectType[Model[Item, Cartridge, Column], {
	Description-> "Model information for a guard cartridge used for chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatography for which this cartridge is suitable.",
			Category -> "Model Information",
			Abstract -> True
		},
		PackingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnPackingMaterialP,
			Description -> "Chemical composition of the packing material in the cartridge.",
			Category -> "Physical Properties"
		},
		FunctionalGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnFunctionalGroupP,
			Description -> "The functional group displayed on the cartridge's stationary phase.",
			Category -> "Physical Properties"
		},
		ParticleSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Micro],
			Units -> Meter Micro,
			Description -> "The size of the particles that make up the cartridge packing material.",
			Category -> "Physical Properties"
		},
		PoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Angstrom],
			Units -> Angstrom,
			Description -> "The average size of the pores within the cartridge packing material.",
			Category -> "Physical Properties"
		},
		CasingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the exterior of the cartridge which houses the packing material is composed of.",
			Category -> "Physical Properties"
		},
		InletFilterMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the inlet filter through which the sample must travel before reaching the stationary phase.",
			Category -> "Physical Properties"
		},
		InletFilterThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The thickness of the inlet filter through which the sample must travel before reaching the stationary phase.",
			Category -> "Physical Properties"
		},
		InletFilterPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The size of the pores in the inlet filter through which the sample must travel before reaching the stationary phase.",
			Category -> "Physical Properties"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure the cartridge can handle during chromatography experiments.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the cartridge can handle during chromatography experiments.",
			Category -> "Operating Limits"
		},
		NominalFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The nominal flow rate at which the cartridge performs.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the cartridge performs.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the cartridge performs.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this cartridge can function.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this cartridge can function.",
			Category -> "Operating Limits"
		},
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The diameter of the cartridge.",
			Category -> "Dimensions & Positions"
		},
		CartridgeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The length of the cartridge.",
			Category -> "Dimensions & Positions"
		},
		CartridgeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "Total volume of the cartridge. This is the sum of the packing volume and the void volume.",
			Category -> "Dimensions & Positions"
		},
		PreferredGuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Column],
			Description -> "The default guard column housings into which this cartridge can be inserted.",
			Category -> "Compatibility",
			Abstract -> True
		},
		GuardColumns -> { (*Deprecated field that can probably be safely removed*)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Column][PreferredGuardCartridge],
			Description -> "The guard column housings into which this cartridge can be inserted.",
			Category -> "Compatibility",
			Developer -> True
		},
		IncompatibleSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample, StockSolution][IncompatibleCartridges]
			],
			Description -> "Chemicals that are incompatible for use with this cartridge.",
			Category -> "Compatibility",
			Abstract -> True
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH the cartridge can handle.",
			Category -> "Compatibility"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH the cartridge can handle.",
			Category -> "Compatibility"
		}
	}
}];
