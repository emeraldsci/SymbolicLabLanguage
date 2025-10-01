
(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Data, KarlFischerTitration], {
	Description->"Analytical data captured for determining water content of substances by titrating them with Karl Fischer reagent.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Technique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerTechniqueP,
			Description -> "Indicates how the Karl Fischer reagent was introduced to the sample for this data.  If Volumetric, the Karl Fischer reagent mixture is introduced via buret in small increments. If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current on a sample of iodide ions.",
			Category -> "General"
		},
		StandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, KarlFischerTitration][SampleData],
			Description -> "Data containing the standards run to determine the titer of the the KarlFischerReagent prior to this titration.",
			Category -> "Analysis & Reports"
		},
		SampleData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, KarlFischerTitration][StandardData],
				Object[Data, KarlFischerTitration][BlankData]
			],
			Description -> "Data containing the samples whose water content were determined using this standard or blank data.",
			Category -> "Analysis & Reports"
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, KarlFischerTitration][SampleData],
			Description -> "Data containing the blanks run to determine the background water content of the headspace gas prior to this titration.",
			Category -> "Analysis & Reports"
		},
		Titer -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Milligram / Milliliter],
			Units -> Milligram / Milliliter,
			Description -> "The amount of water that can be titrated per unit volume by the KarlFischerReagent used in this titration.  For Standard measurements, this is the calculated value based on the known quantity of water in Standard.  For Sample measurements, this is the value calculated from all Standard runs and used in the calculation of the WaterContent.",
			Category -> "Experimental Results"
		},
		WaterContent -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[MassPercent],
			Units -> MassPercent,
			Description -> "The amount of water measured in the titrated sample. If DataType is Standard, WaterContent refers to the known value used to calculate the Titer.",
			Category -> "Experimental Results"
		},
		KarlFischerReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The Karl Fischer reagent used to titrate the sample and calculate WaterContent.",
			Category -> "Reagents"
		},
		Medium -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The reaction medium that used in this reaction mixture during the titration.",
			Category -> "Reagents"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> KarlFischerTitrationDataTypeP,
			Description -> "Indciates if this data represents a standard, a blank, or an analyte sample.",
			Category -> "Analysis & Reports"
		},
		TitrationVolumeOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Milliliter},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Milliliter]},
			Description -> "Indicates how much volume of KarlFischerReagent was added to the reaction mixture as a function of time until the titration end point.",
			Headers -> {"Time", "Volume"},
			Category -> "Experimental Results"
		},
		TitrationPotentialOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Millivolt},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of time until the titration end point.  This potential is dictated by the presence of iodine, and will typically decrease as all water is consumed and iodine begins to accumulate.",
			Headers -> {"Time", "Potential"},
			Category -> "Experimental Results"
		},
		TitrationDriftOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Microliter / Minute},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Microliter / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of time until the titration end point. This indicates how much water may be reaching the reaction vessel from the surroundings and not from the sample itself.",
			Headers -> {"Time", "Drift"},
			Category -> "Experimental Results"
		},
		TitrationTemperatureOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Celsius},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Kelvin]},
			Description -> "Indicates the temperature of the reaction vessel as a function of time until the titration end point if temperature control is specified in the experiment.",
			Headers -> {"Time", "Temperature"},
			Category -> "Experimental Results"
		},
		TitrationPotentialPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Millivolt},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of the amount of KarlFischerReagent added to the reaction vessel until the titration end point.  This potential is dictated by the presence of iodine, and will typically decrease as all water is consumed and iodine begins to accumulate.",
			Headers -> {"Volume", "Potential"},
			Category -> "Experimental Results"
		},
		TitrationDriftPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Microliter / Minute},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Microliter / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of the amount of KarlFischerReagent added to the reaction vessel until the titration end point. This indicates how much water may be reaching the reaction vessel from the surroundings and not from the sample itself.",
			Headers -> {"Volume", "Drift"},
			Category -> "Experimental Results"
		},
		TitrationTemperaturePerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Celsius},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Kelvin]},
			Description -> "Indicates the temperature of the reaction vessel as a function of the amount of KarlFischerReagent added to the reaction vessel until the titration end point if temperature control is specified in the experiment.",
			Headers -> {"Volume", "Temperature"},
			Category -> "Experimental Results"
		},

		ConditioningVolumeOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Milliliter},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Milliliter]},
			Description -> "Indicates how much volume of KarlFischerReagent was added to the reaction mixture as a function of time during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Volume"},
			Category -> "Experimental Results"
		},
		ConditioningPotentialOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Millivolt},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of time during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Potential"},
			Category -> "Experimental Results"
		},
		ConditioningDriftOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Microliter / Minute},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Microliter / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of time during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Drift"},
			Category -> "Experimental Results"
		},
		ConditioningTemperatureOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Celsius},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Kelvin]},
			Description -> "Indicates the temperature of the reaction vessel as a function of time during conditioning to remove all water from the vessel prior to titration if temperature control is specified in the experiment.",
			Headers -> {"Time", "Temperature"},
			Category -> "Experimental Results"
		},
		ConditioningPotentialPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Millivolt},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of the amount of KarlFischerReagent added to the reaction vessel during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Volume", "Potential"},
			Category -> "Experimental Results"
		},
		ConditioningDriftPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Microliter / Minute},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Microliter / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of the amount of KarlFischerReagent added to the reaction vessel during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Volume", "Drift"},
			Category -> "Experimental Results"
		},
		ConditioningTemperaturePerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Celsius},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Kelvin]},
			Description -> "Indicates the temperature of the reaction vessel as a function of the amount of KarlFischerReagent added to the reaction vessel during conditioning to remove all water from the vessel prior to titration if temperature control is specified in the experiment.",
			Headers -> {"Volume", "Temperature"},
			Category -> "Experimental Results"
		}

	}
}];