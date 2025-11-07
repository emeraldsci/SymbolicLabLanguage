

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, ExtractionCartridge], {
	Description->"Model information for a disposable cartridge used in solid phase extraction or flash chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of solid phase extraction (SPE) for which this cartridge model is suitable.",
			Category -> "Model Information",
			Abstract -> True
		},
		PackingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnPackingMaterialP,
			Description -> "Chemical composition of the packing material in the cartridge.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		FunctionalGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SolidPhaseExtractionFunctionalGroupP,
			Description -> "The functional group displayed on the cartridge's stationary phase.",
			Category -> "Physical Properties"
		},
		ParticleSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Micro],
			Units -> Meter Micro,
			Description -> "The average size of the particles that make up the packing material.",
			Category -> "Physical Properties"
		},
		PoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Angstrom],
			Units -> Angstrom,
			Description -> "The average size of the pores within the cartridge's packing material.",
			Category -> "Physical Properties"
		},
		BedWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The dry weight of the packing material in the cartridge.",
			Category -> "Physical Properties"
		},
		MaxBedWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The maximum dry weight of the packing material that can be loaded into this size of cartridge.",
			Category -> "Physical Properties"
		},
		PackingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CartridgePackingTypeP,
			Description -> "The method by which the cartridge is filled with packing material. Can be prepacked by the manufacturer or empty to be hand packed by the user.",
			Category -> "Physical Properties"
		},
		CasingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlasticP,
			Description -> "The material that the exterior of the cartridge which houses the packing material is composed of.",
			Category -> "Physical Properties",
			Abstract -> True
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
		OutletFilterMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the outlet filter through which the sample must travel before exiting the cartridge.",
			Category -> "Physical Properties"
		},
		OutletFilterThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The thickness of the outlet filter through which the sample must travel before exiting the cartridge.",
			Category -> "Physical Properties"
		},
		OutletFilterPoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The size of the pores in the outlet filter through which the sample must travel before exiting the cartridge.",
			Category -> "Physical Properties"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure to which the cartridge can be exposed without becoming damaged.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure to which the cartridge can be exposed without becoming damaged.",
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
		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The internal diameter of the cartridge body.",
			Category -> "Dimensions & Positions"
		},
		CartridgeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The internal length of the cartridge body.",
			Category -> "Dimensions & Positions"
		},
		InletConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionVesselConnectionTypeP,
			Description -> "The type of fitting needed to plumb the flow system into the cartridge.",
			Category -> "Compatibility"
		},
		OutletConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReactionVesselConnectionTypeP,
			Description -> "The type of fitting needed to plumb the cartridge back into the flow system.",
			Category -> "Compatibility"
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
			Description -> "The minimum pH to which the cartridge can be exposed without becoming damaged.",
			Category -> "Compatibility"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH to which the cartridge can be exposed without becoming damaged.",
			Category -> "Compatibility"
		},
		HoldUpVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of retained liquid that cannot be recovered from the cartridge.",
			Category -> "Operating Limits"
		},
		ChromatographyType->{
			Format->Single,
			Class->Expression,
			Pattern:>ChromatographyTypeP,
			Description->"The type of chromatography instrument with which this cartridge can be used.",
			Category->"Compatibility",
			Abstract->True
		}
	}
}];
