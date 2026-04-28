
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
			Description -> "The amount of water measured in the titrated sample. If DataType is Standard and Technique is Volumetric, WaterContent refers to the known value used to calculate the Titer.",
			Category -> "Experimental Results"
		},
		ExpectedWaterContent -> {
			Format -> Single,
			Class -> Real,
			Pattern :> MassPercentP,
			Units -> MassPercent,
			Description -> "The expected amount of water in sample based on the sample's Certificate of Analysis.",
			Category -> "Experimental Results"
		},
		BlankWaterMass -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Microgram],
			Units -> Microgram,
			Description -> "The amount of water measured in the headspace vials in the BlankData of this sample.  If DataType is Blank, then this value is the water content of the container itself, minus the water introduced to the reaction vessel from the surroundings.",
			Category -> "Experimental Results"
		},
		DriftCorrectionValue -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microgram / Minute],
			Units -> Microgram / Minute,
			Description -> "The rate at which water is introduced to the reaction vessel from its surroundings over the course of this titration if Technique is Coulometric.  This value is always the drift recorded in the last data point in the ConditioningDriftOverTime field.",
			Category -> "Experimental Results"
		},
		DriftCorrectionDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The length of time from the end of the conditioning step to the end of the titration step.  The water content found by multiplying DriftCorrectionDuration by DriftCorrectionValue is subtracted from the TitrationEndPointMass to obtain ContainerWaterMass.",
			Category -> "Experimental Results"
		},
		SampleTitratedWaterMass -> {
			Format -> Single,
			Class -> Distribution,
			Pattern :> DistributionP[Microgram],
			Units -> Microgram,
			Description -> "The amount of water consumed during the course of this Karl Fischer titration that came from the sample itself.  This value is obtained by taking the TitrationEndPointMass and subtracting the BlankWaterMass and the product of DriftCorrectionValue and DriftCorrectionDuration.",
			Category -> "Experimental Results"
		},
		TitrationEndPointVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The amount of KarlFischerReagent added to this sample or standard during the course of its titration.",
			Category -> "Experimental Results"
		},
		TitrationEndPointMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microgram],
			Units -> Microgram,
			Description -> "The amount of water that was consumed during the course of this titration.  This includes water in the sample, water from the headspace vial, and water introduced from the surroundings.",
			Category -> "Experimental Results"
		},
		SampleWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "The amount of sample or standard added to the reaction vessel to be titrated with KarlFischerReagent.",
			Category -> "Experimental Results"
		},
		HeadspaceVial -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The headspace vial in which the sample was sealed and heated when performing the coulometric Karl Fischer titration.",
			Category -> "Reagents"
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
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature to which the headspace vial was heated to release water into the headspace during the titration.",
			Category -> "Operations Information"
		},
		TitrationVolumeOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Milliliter},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Milliliter]},
			Description -> "Indicates how much volume of KarlFischerReagent was added to the reaction mixture as a function of time until the titration end point.",
			Headers -> {"Time", "Titrant Volume"},
			Category -> "Experimental Results"
		},
		TitrationMassOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Microgram},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Microgram]},
			Description -> "Indicates how much water was consumed by the coulometric Karl Fischer titration as a function of time until the titration end point.",
			Headers -> {"Time", "Water Mass"},
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
			Class -> {Real, VariableUnit},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Microliter / Minute] | GreaterEqualP[0 Microgram / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of time until the titration end point. This indicates how much water may be reaching the reaction vessel from the surroundings and not from the sample itself.",
			Headers -> {"Time", "Drift"},
			Category -> "Experimental Results"
		},
		TitrationChargeOverTime -> {
			Format -> Multiple,
			Class -> {Real, VariableUnit},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Micro Coulomb]},
			Description -> "Indicates the he amount of charge expended to convert iodide anions into molecular iodine as a function of time until the titration end point.",
			Headers -> {"Time", "Charge"},
			Category -> "Experimental Results"
		},
		TitrationPotentialPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Millivolt},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of the amount of KarlFischerReagent added to the reaction vessel until the titration end point.  This potential is dictated by the presence of iodine, and will typically decrease as all water is consumed and iodine begins to accumulate.",
			Headers -> {"Titrant Volume", "Potential"},
			Category -> "Experimental Results"
		},
		TitrationDriftPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Microliter / Minute},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Microliter / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of the amount of KarlFischerReagent added to the reaction vessel until the titration end point. This indicates how much water may be reaching the reaction vessel from the surroundings and not from the sample itself.",
			Headers -> {"Titrant Volume", "Drift"},
			Category -> "Experimental Results"
		},
		TitrationPotentialPerMass -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Microgram, Millivolt},
			Pattern :> {GreaterEqualP[0 Microgram], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of the amount of water consumed during the coulometric Karl Fischer reaction until the titration end point.  This potential is dictated by the presence of iodine, and will typically decrease as all water is consumed and iodine begins to accumulate.",
			Headers -> {"Water Mass", "Potential"},
			Category -> "Experimental Results"
		},
		TitrationDriftPerMass -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Microgram, Microgram / Minute},
			Pattern :> {GreaterEqualP[0 Microgram], GreaterEqualP[0 Microgram / Minute]},
			Description -> "Indicates amount of water per unit time that is consumed to keep the titration cell dry as a function of the amount of water consumed during the coulometric Karl Fischer reaction until the titration end point. This indicates how much water may be reaching the reaction vessel from the surroundings and not from the sample itself.",
			Headers -> {"Water Mass", "Drift"},
			Category -> "Experimental Results"
		},
		TitrationChargePerMass -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Microgram, Milli Coulomb},
			Pattern :> {GreaterEqualP[0 Microgram], GreaterEqualP[0 Milli Coulomb]},
			Description -> "Indicates the amount of charge expended to convert iodide anions into molecular iodine as a function of the amount of water consumed as part of the coulometric Karl Fischer reaction until the titration end point. Note that the water consumed is calculated directly from this raw charge data, and thus this relationship will always be perfectly linear.",
			Headers -> {"Water Mass", "Charge"},
			Category -> "Experimental Results"
		},
		ConditioningVolumeOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Milliliter},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Milliliter]},
			Description -> "Indicates how much volume of KarlFischerReagent was added to the reaction mixture as a function of time during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Titrant Volume"},
			Category -> "Experimental Results"
		},
		ConditioningMassOverTime -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Second, Microgram},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Microgram]},
			Description -> "Indicates how much water was consumed during the coulometric Karl Fischer reaction as a function of time during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Water Mass"},
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
			Class -> {Real, VariableUnit},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Microliter / Minute] | GreaterEqualP[0 Microgram / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of time during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Drift"},
			Category -> "Experimental Results"
		},
		ConditioningChargeOverTime -> {
			Format -> Multiple,
			Class -> {Real, VariableUnit},
			Pattern :> {GreaterEqualP[0 Second], GreaterEqualP[0 Micro Coulomb]},
			Description -> "Indicates the he amount of charge expended to convert iodide anions into molecular iodine as a function of time until during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Time", "Charge"},
			Category -> "Experimental Results"
		},
		ConditioningPotentialPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Millivolt},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of the amount of KarlFischerReagent added to the reaction vessel during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Titrant Volume", "Potential"},
			Category -> "Experimental Results"
		},
		ConditioningDriftPerVolume -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Milliliter, Microliter / Minute},
			Pattern :> {GreaterEqualP[0 Milliliter], GreaterEqualP[0 Microliter / Minute]},
			Description -> "Indicates the amount of KarlFischerReagent per unit time that is consumed to keep the titration cell dry as a function of the amount of KarlFischerReagent added to the reaction vessel during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Titrant Volume", "Drift"},
			Category -> "Experimental Results"
		},
		ConditioningPotentialPerMass -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Microgram, Millivolt},
			Pattern :> {GreaterEqualP[0 Microgram], GreaterEqualP[0 Millivolt]},
			Description -> "Indicates the electric potential between the reference and measurement electrodes in the reaction mixture as a function of the amount of water consumed as part of the coulometric Karl Fischer reaction during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Water Mass", "Potential"},
			Category -> "Experimental Results"
		},
		ConditioningDriftPerMass -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Microgram, Microgram / Minute},
			Pattern :> {GreaterEqualP[0 Microgram], GreaterEqualP[0 Microgram / Minute]},
			Description -> "Indicates the amount of water per unit time that is consumed to keep the titration cell dry as a function of the amount of water consumed as part of the coulometric Karl Fischer reaction during conditioning to remove all water from the vessel prior to titration.",
			Headers -> {"Water Mass", "Drift"},
			Category -> "Experimental Results"
		},
		ConditioningChargePerMass -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Units -> {Microgram, Milli Coulomb},
			Pattern :> {GreaterEqualP[0 Microgram], GreaterEqualP[0 Milli Coulomb]},
			Description -> "Indicates the amount of charge expended to convert iodide anions into molecular iodine as a function of the amount of water consumed as part of the coulometric Karl Fischer reaction during conditioning to remove all water from the vessel prior to titration. Note that the water consumed is calculated directly from this raw charge data, and thus this relationship will always be perfectly linear.",
			Headers -> {"Water Mass", "Charge"},
			Category -> "Experimental Results"
		},
		EmptyBalanceWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "Indicates the weight data used to measure the value on the empty balance prior to measuring the weight of the empty syringe or weighing funnel.",
			Category -> "Weighing"
		},
		TareWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight data of the sample transfer device prior to measuring the weight of the samples. If using weighing funnels, this is the weight of the empty weighing funnel prior to measurement of solid weight.  If using syringes, this is the weight of the empty syringe and needle on the syringe rack.",
			Category -> "Weighing"
		},
		SampleWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the full sample syringe or weighing container when it is filled prior to addition to the reaction vessel. This value refers to the weight of the syringe and needle or the weighing funnel plus the weight of their contents.",
			Category -> "Weighing"
		},
		EmptyContainerWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Weight],
			Description -> "The weight deta of the empty sample syringe and needle or weighing container after its contents have been addded to the reaction vessel.",
			Category -> "Weighing"
		},
		SampleAdditionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The length of time from when the SampleWeightData and the EmptyContainerWeightData are collected, between which the titration actually happens.",
			Category -> "Weighing"
		},
		DateSampleAdded -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date and time the input sample was added to the reaction vessel for Volumetric titration.",
			Category -> "General"
		}
	}
}];