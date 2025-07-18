(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Column], {
	Description->"Model information for a separatory column used for chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(*--- Model Information---*)
		ChromatographyType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyTypeP, (* Add: GC, GCMS *)
			Description -> "The type of chromatography technique for which this column is suitable.",
			Category -> "Model Information",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (SeparationModeP|GasChromatography),
			Description -> "The type of chromatography for which this column is suitable.",
			Category -> "Model Information",
			Abstract -> True
		},
		AnalysisChannel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AnalysisChannelP,
			Description -> "The flow path in the instrument for which this column is suitable for IonChrmatography experiments, e.g. either cation channel or anion channel.",
			Category -> "Model Information",
			Abstract -> True
		},
		ColumnType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnTypeP,
			Description -> "The scale of the chromatography to be performed on the column. Analytical columns are used for smaller volumes and mainly for identification purposes. Preparative columns are used for larger volumes and mainly for separation purposes. Guard columns are mounted between the injector and main column to protect the main column from impurities.",
			Category -> "Model Information",
			Abstract -> True
		},
		EmptyColumnModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Column],
			Description -> "The model that represents the empty object column.",
			Category -> "Model Information"
		},

		(* --- Physical Properties --- *)
		PackingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnPackingTypeP|NoPacking,
			Description -> "The method used to fill the column with the resin, be that by hand packing with loose solid resin, by inserting a disposable cartridge, or with a column which has been prepacked during manufacturing.",
			Category -> "Physical Properties"
		},
		USPDesignation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> USPDesignationP,
			Description -> "The equivalent of the stationary phase in this column, as outlined by the United States Pharmacopeial Convention.",
			Category -> "Physical Properties"
		},
		PackingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnPackingMaterialP,
			Description -> "Chemical composition of the packing material in the column.",
			Category -> "Physical Properties"
		},
		BedWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "The dry weight of the packing material (stationary phase media) in the column.",
			Category -> "Physical Properties"
		},
		CapillaryFilmMaterial -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the capillary film phase provided by the manufacturer (e.g., HP-5).",
			Category -> "Physical Properties"
		},
		FunctionalGroup -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ColumnFunctionalGroupP,
			Description -> "The functional group displayed on the column's stationary phase.",
			Category -> "Physical Properties"
		},
		ParticleSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter*Micro],
			Units -> Meter Micro,
			Description -> "The size of the particles that make up the column packing material.",
			Category -> "Physical Properties"
		},
		PoreSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Angstrom],
			Units -> Angstrom,
			Description -> "The average size of the pores within the column packing material.",
			Category -> "Physical Properties"
		},
		ResinCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The weight of the resin that the column can be packed with.",
			Category -> "Physical Properties"
		},
		CasingMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material that the exterior of the column which houses the packing material is composed of.",
			Category -> "Physical Properties"
		},
		CapillaryMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Silica|FusedSilica|StainlessSteel),
			Description -> "The material that the capillary tube is composed of.",
			Category -> "Physical Properties"
		},
		InletFilterMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FilterMembraneMaterialP,
			Description -> "The material of the inlet filter through which the sample must travel before reaching the stationary phase.",
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
		InletFilterThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The thickness of the inlet filter through which the sample must travel before reaching the stationary phase.",
			Category -> "Physical Properties"
		},

		(* --- Resin Properties --- *)
    Resin -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample]|Model[Sample],
      Description -> "The model of the resin used to pack the column.",
      Category ->  "Model Information",
      Abstract -> True
    },
    ResinLoadingAmount -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 * Milligram],
      Units -> Milligram,
      Description -> "The amount of resin that will be used to fill up the empty column. When specifying the mass it is the amount of dry resin, when specifying the volume it is the volume of the resin in its storage state.",
			Category ->  "Model Information",
      Abstract -> True
    },
		BedVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 * Milliliter],
      Units -> Milliliter,
      Description -> "The total volume of material, both solid and liquid, in the compacted column; i.e. the volume of the support particles (compacted resin) plus the void volume.",
			Category ->  "Model Information",
      Abstract -> True
    },
    PackingBuffer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample]|Object[Sample],
      Description -> "The buffer required for packing an empty column when the resin is dry.",
      Category ->  "Model Information"
    },
    StorageBuffer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Sample]|Object[Sample],
      Description -> "The buffer used to keep the resin wet while the column is stored.",
      Category ->   "Model Information"
    },
		StorageCaps -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this column requires special storage locking caps when not installed on the instrument.",
			Category ->   "Model Information"
		},

		(* --- Operating Limits ---*)
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The minimum pressure the column can handle during chromatography experiments.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The maximum pressure the column can handle during chromatography experiments.",
			Category -> "Operating Limits"
		},
		NominalFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The nominal flow rate at which the column performs.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate at which the column performs.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Liter*Milli))/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate at which the column performs.",
			Category -> "Operating Limits"
		},
		MinSampleMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Milligram,
			Description -> "The minimum mass of analyte that can be loaded into the column.",
			Category -> "Operating Limits"
		},
		MaxSampleMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Milligram,
			Description -> "The maximum mass of analyte that can be loaded into the column.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which this column can function.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which this column can function.",
			Category -> "Operating Limits"
		},
		MaxShortExposureTemperature -> { (* GC QA *)
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature to which this column can exposed for a brief period of time.",
			Category -> "Operating Limits"
		},
		MaxAcceleration->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Milliliter/Minute^2],
			Units->Milliliter/Minute^2,
			Description->"The maximum flow rate acceleration at which to ramp the speed of pumping solvent for this column.",
			Category->"Operating Limits"
		},

		(* --- Dimensions & Positions --- *)

		Diameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The outside diameter of the column.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "If this is a housing column where PackingType is Cartridge, then this value is the diameter of cartridge that can be accommodated.",
			Category -> "Dimensions & Positions"
		},
		ColumnLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The outside length of the column.",
			Category -> "Dimensions & Positions"
		},
		InternalLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "If this is a housing column where PackingType is Cartridge, then this value is the length of cartridge that can be accommodated.",
			Category -> "Dimensions & Positions"
		},
		ColumnVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "Total volume of the column. This is the sum of the packing volume and the void volume.",
			Category -> "Dimensions & Positions"
		},
		VoidVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "The volume of mobile (liquid) phase media that the column can hold. This is the column's total volume minus the volume of the stationary (solid) phase media.",
			Category -> "Dimensions & Positions"
		},
		FilmThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Meter],
			Units -> Micro*Meter,
			Description -> "The thickness of the liquid stationary phase film in a capillary GC column.",
			Category -> "Dimensions & Positions"
		},
		ColumnFormat -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The diameter of the capillary GC column cage.",
			Category -> "Dimensions & Positions"
		},

		(* --- Compatibility ---*)
		PreferredGuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Column][ProtectedColumns],
			Description -> "The preferred guard column for use with this column.",
			Category -> "Compatibility",
			Abstract -> True
		},
		ProtectedColumns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Column][PreferredGuardColumn],
			Description -> "The analytical or preparative columns for which this column is preferred as a guard.",
			Category -> "Compatibility",
			Abstract -> True
		},
		PreferredGuardCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Cartridge, Column][GuardColumns]|Model[Item, Cartridge, Column],
			Description -> "The guard column cartridge which is preferred to be inserted into this column.",
			Category -> "Compatibility",
			Abstract -> True
		},
		PreferredColumnJoin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Plumbing, ColumnJoin][GuardColumns],
			Description -> "The column join that best connects a column to this guard column.",
			Category -> "Compatibility",
			Abstract -> True
		},
		IncompatibleSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample, StockSolution]
			],
			Description -> "Chemicals that are incompatible for use with this column.",
			Category -> "Compatibility"
		},
		CompatibleFlushSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Chemicals that may be used to flush a GC column during cleaning.",
			Category -> "Compatibility",
			Abstract -> True
		},
		MinpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The minimum pH the column can handle.",
			Category -> "Compatibility"
		},
		MaxpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 14],
			Units -> None,
			Description -> "The maximum pH the column can handle.",
			Category -> "Compatibility"
		},
		Polarity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GCColumnPolarityP,
			Units -> None,
			Description -> "The polarity of the column stationary phase.",
			Category -> "Compatibility"
		},
		StationaryPhaseBonded -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GCColumnBondedP,
			Units -> None,
			Description -> "Indicates if a GC column stationary phase is has been chemical bound to its support or crosslinked to improve thermal stability and/or solvent rinseability.",
			Category -> "Compatibility"
		},

		(* Qualifications & Maintenance *)
		PreferredStandards -> {
			Format -> Multiple,
			Class -> {
				Standard -> Link,
				Gradient -> Link,
				BufferA -> Link,
				BufferB -> Link,
				BufferC -> Link,
				BufferD -> Link,
				Amount -> VariableUnit,
				Data -> Link
			},
			Pattern :> {
				Standard -> _Link,
				Gradient -> _Link,
				BufferA -> _Link,
				BufferB -> _Link,
				BufferC -> _Link,
				BufferD -> _Link,
				Amount -> GreaterP[0*Milliliter] | GreaterP[0*Milligram] | GreaterP[0*Unit, 1*Unit],
				Data -> _Link
			},
			Relation -> {
				Standard -> (Model[Sample]|Model[Sample,StockSolution,Standard]),
				Gradient -> Object[Method,Gradient],
				BufferA -> Model[Sample],
				BufferB -> Model[Sample],
				BufferC -> Model[Sample],
				BufferD -> Model[Sample],
				Amount -> Null,
				Data -> Object[Data,Chromatography]
			},
			Headers -> {
				Standard -> "Standard",
				Gradient -> "Gradient Method",
				BufferA -> "Buffer A",
				BufferB -> "Buffer B",
				BufferC -> "Buffer C",
				BufferD -> "Buffer D",
				Amount -> "Injection Amount",
				Data -> "Standard Data"
			},
			Description -> "Sample, gradient, and buffer conditions for running standards on this model of column with corresponding reference data.",
			Category -> "Qualifications & Maintenance"
		}
	}
}];
