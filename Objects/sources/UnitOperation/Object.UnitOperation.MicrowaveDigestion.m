(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, MicrowaveDigestion], {
	Description -> "A detailed set of parameters that specifies a microwave digestion procedure inside a MicrowaveDigestion protocol.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Sample-related fields *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The sample that is being heated and digested through microwave reactor during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The sample that is being heated and digested through microwave reactor during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}] | _String},
			Relation -> Null,
			Description -> "The sample that is being heated and digested through microwave reactor during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Reactor, Microwave], Model[Instrument, Reactor, Microwave]],
			Description -> "The reactor used to perform the microwave digestion.",
			Category -> "General"
		},
		SampleType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Organic, Inorganic, Tablet, Biological],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Specifies if the sample is primarily composed of organic material, inorganic material, or is a tablet formulation. If the sample in tablet form, select Tablet regardless of the composition.",
			Category -> "General"
		},
		SampleAmount -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 Milligram], GreaterP[0 Microliter]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of sample used for digestion.",
			Category -> "General"
		},
		CrushSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the tablet is crushed to a powder prior to digestion.",
			Category -> "Sample Preparation"
		},
		PreDigestionMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating. Pre-mixing can ensure that a sample is fully dissolved or suspended prior to heating.",
			Category -> "Sample Preparation"
		},
		PreDigestionMixTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of time for which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
			Category -> "Sample Preparation"
		},
		PreDigestionMixRate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[None, Low, Medium, High],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The rate at which the reaction mixture is stirred at ambient temperature directly prior to being subjected to microwave heating.",
			Category -> "Sample Preparation"
		},
		PreparedSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the member of SampleIn is already mixed with an appropriate digestion agent. Setting PreparedSample -> True will change the upper limit on the SampleAmount to 20 mL.",
			Category -> "Sample Preparation"
		},
		DigestionAgents -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ObjectP[Model[Sample]], VolumeP}...},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The volume and identity of the digestion agents used to digest and dissolve the SamplesIn.",
			Category -> "Digestion"
		},
		DigestionAgentsResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The volume and identity of the digestion agents used to digest and dissolve the SamplesIn.",
			Category -> "Digestion"
		},
		DigestionTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The temperature to which the sample is heated for the duration of the DigestionDuration.",
			Category -> "Sample Preparation"
		},
		DigestionDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of time for which the sample is incubated at the set DigestionTemperature during digestion.",
			Category -> "Digestion"
		},
		DigestionRampDuration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The amount of time taken for the sample chamber temperature from ambient temperature to reach the DigestionTemperature.",
			Category -> "Digestion"
		},
		DigestionTemperatureProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{TimeP, TemperatureP}...},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The heating profile for the reaction mixture in the form {{Time, Target Temperature}..}. Consecutive entries with different temperatures result in a linear ramp between the temperatures, while consecutive entries with the same temperature indicate an isothermal region at the specified temperature.",
			Category -> "Digestion"
		},
		DigestionMixRateProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{TimeP, Alternatives[Low, Medium, High]}...} | Low | Medium | High,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The relative rate of the magnetic stir bar rotation that will be used to mix the sample, either for the duration of the digestion (fixed), or from the designated time point to the next time point (variable). For safety reasons, the sample must be mixed during microwave heating.",
			Category -> "Digestion"
		},
		DigestionMaxPower -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Watt],
			Units -> Watt,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The maximum power of the microwave radiation output that will be used during heating.",
			Category -> "Digestion"
		},
		DigestionMaxPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The pressure at which the magnetron will cease to heat the reaction vessel. If the vessel internal pressure exceeds 500 PSI, the instrument will cease heating regardless of this option.",
			Category -> "Digestion"
		},
		PressureVenting -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The pressure at which the magnetron will cease to heat the reaction vessel. If the vessel internal pressure exceeds 500 PSI, the instrument will cease heating regardless of this option.",
			Category -> "Digestion"
		},
		PressureVentingTriggers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{PressureP, _Integer}...},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The set point pressures at which venting will begin, and the number of times that the system will vent the vessel in an attempt to reduce the pressure by the value of TargetPressureReduction. If the pressure set points are not reached, no venting will occur. Be aware that excessive venting may result in sample evaporation, leading to dry out of sample, loss of sample and damage of reaction vessel.",
			Category -> "Digestion"
		},
		TargetPressureReduction -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[1 PSI],
			Units -> PSI,
			Description -> "For each member of SampleLink, For each member of SamplesIn, the desired reduction in pressure during sample venting.",
			Category -> "Digestion",
			IndexMatching -> SampleLink
		},
		OutputAliquotReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			Category -> "Digestion",
			Migration -> SplitField
		},
		OutputAliquotExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			Category -> "Digestion",
			Migration -> SplitField
		},
		DiluteOutputAliquot -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, Indicates if the OutputAliquot is added to a specified volume (DiluentVolume) of Diluent prior to storage or use in subsequent experiments. Dilution reduces the risk and cost associated with storage of caustic/oxidizing reagents commonly employed in digestion protocols.",
			Category -> "Digestion"
		},
		Diluent -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The solution used to dilute the OutputAliquot of the digested sample.",
			Category -> "Digestion"
		},
		DiluentVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The volume of diluent into which the OutputAliquot will be added.",
			Category -> "Digestion"
		},
		DilutionFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The desired dilution factor for this mixture.",
			Category -> "Digestion"
		},
		TargetDilutionVolume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> VolumeP,
			Units -> Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The volume of output sample after DigestionOutputAliquot has been removed, and subsequently been diluted by the DiluentVolume of the provided Diluent sample.",
			Category -> "Digestion"
		},
		ContainerOutLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, The container model into which the OutputAliquotVolume or dilutions thereof is placed as the output of digestion.",
			Category -> "Digestion",
			Migration -> SplitField
		},
		ContainerOutString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			IndexMatching -> SampleLink,
			Migration -> SplitField,
			Description -> "For each member of SampleLink, The container into which the OutputAliquotVolume or dilutions thereof is placed as the output of digestion. If StandardType is set to Internal, the sample will be subjected to internal standard addition before injecting into ICPMS instrument, otherwise the sample will be directly injected to ICPMS instrument.",
			Category -> "Digestion"
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the Sample for use in downstream unit operations.",
			Category -> "Digestion"
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the containers of sample for use in downstream unit operations.",
			Category -> "General"
		},
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the Sample as the result of current unit operations.",
			Category -> "Digestion"
		}
	}
}];