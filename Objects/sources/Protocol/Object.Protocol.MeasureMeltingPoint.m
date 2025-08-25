(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MeasureMeltingPoint], {
	Description -> "A protocol for measuring melting point, the temperature of a solid substance at which the physical state of the substance changes from solid to liquid, by capillary method via a melting point apparatus.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(*General*)
		MeasurementMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Pharmacopeia, Thermodynamic],
			Description -> "Determines the method used to adjust the measured temperatures obtained from the apparatus's temperature sensor. When set to \"Pharmacopeia\", the temperatures are adjusted using Pharmacopeia melting point standards; when set to \"Thermodynamic\", thermodynamic melting point standards are utilized for temperature adjustments. In \"Pharmacopeia\" mode, adjustments are based on experimental measurements following pharmacopeial guidelines. This method neglects the furnace temperature being slightly higher than the sample temperature during heating, leading to dependency on heating rate for comparability. In contrast, \"Thermodynamic\" mode provides a physically accurate melting point that represents the theoretical temperature at which a substance transitions from solid to liquid phase under standard conditions.",
			Category -> "General"
		},
		OrdersOfOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[{Desiccate, Grind}, {Grind, Desiccate}],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates which preparatory step (Grind or Desiccate) is performed first if both are set to True.",
			Category -> "General"
		},
		NumbersOfReplicates -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[2, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of melting point capillaries to be packed with the same sample and read.",
			Category -> "General"
		},
		ExpectedMeltingPoints -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Unknown, GreaterP[0Kelvin]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the approximate melting point of the sample, if known.",
			Category -> "General"
		},
		Amounts -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GreaterP[0 Gram],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines how much sample to use for this experiment. If Grind is True, Amount determines how much sample to grind into a fine powder via a grinder before packing into a melting point capillary and measuring the melting point. If Desiccate is True, Amount determines how much sample to dry via a desiccator before packing into a melting point capillary and measuring the melting point. If both Grind and Desiccate are True, Amount determines how much sample to grind and desiccate, in the order determined by OrderOfOperations, before packing into a melting point capillary and measuring the melting point. If both Grind and Desiccate are set to False, Amount determines how much sample to transfer into a desired container for packing into a melting point capillary and measuring the melting point. If Amount is set to Null sample is directly packed into a melting point capillary from its original container if feasible, without grinding and desiccation. The Amount of the sample should be equal or more than the minimum required amount of the specified grinder if Grind is set to True.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "Grind and/or desiccate unit operations used for preparing samples before packing them into melting point capillaries.",
			Category -> "Sample Preparation"
		},
		PreparedSamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples that are prepared by desiccation or grinding before being packed into melting point capillary tubes.",
			Category -> "Sample Preparation"
		},
		Rod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Rod], Model[Item, Rod]],
			Description -> "A slender tool capable of being inserted into a melting point capillary tube in order to compress the sample within the capillary.",
			Category -> "Sample Preparation",
			Developer -> True
		},

		(*Labels*)
		SampleLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the prepared sample for use in downstream unit operations.",
			Category -> "General"
		},
		SampleContainerLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify sample containers that are used during the desiccation step if Desiccate is set to True, for use in downstream unit operations.",
			Category -> "General"
		},
		PreparedSampleLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the the prepared sample (by desiccation and/or grinding) for use in downstream unit operations.",
			Category -> "General"
		},

		(*Grinding*)
		Grind -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the sample is ground into smaller particles via a grinder before packing into a melting point capillary and measuring melting point.",
			Category -> "Grinding"
		},
		GrinderTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GrinderTypeP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BalllMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
			Category -> "Grinding"
		},
		Grinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Grinder], Model[Instrument, Grinder]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the instrument that is used for reducing the size of the powder particles of the sample.",
			Category -> "Grinding"
		},
		Finenesses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Millimeter],
			Units -> Millimeter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the approximate length of the largest particle of the sample.",
			Category -> "General"
		},
		BulkDensities -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Gram / Milliliter],
			Units -> Gram / Milliliter,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces.",
			Category -> "General"
		},
		GrindingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the container that the sample is transferred into during the grinding process if Grind is set to True. Refer to the table in the instrumentation section of the help files for more information about the containers that are used for each model of grinders.",
			Category -> "General"
		},
		GrindingBeads -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, GrindingBead],
				Model[Item, GrindingBead]
			],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result rapid mechanical movements of the grinding container.",
			Category -> "General"
		},
		NumbersOfGrindingBeads -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
			Category -> "General"
		},
		GrindingRates -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the speed of the circular motion of the grinding tool at which the sample is ground into a fine powder via a BallMill or KnifeMill.",
			Category -> "Grinding"
		},
		GrindingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the duration of grinding the sample in a grinder to reduce the size of the powder particles.",
			Category -> "Grinding"
		},
		NumbersOfGrindingSteps -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
			Category -> "Grinding"
		},
		CoolingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the duration of time that the grinder is switched off after each grinding step to cool down the sample and prevent overheating.",
			Category -> "Grinding"
		},
		GrindingProfiles -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{Alternatives[Grinding, Cooling], Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 Hertz]], GreaterEqualP[0 Minute]}..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the grinding activity (Grinding/GrindingRate or Colling) over the course of time.",
			Category -> "Grinding"
		},

		(*Desiccation*)
		Desiccate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the sample is dried by removing water molecules from the sample via a desiccator before packing it into a melting point capillary and measuring its melting point.",
			Category -> "Desiccation"
		},
		DesiccationMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesiccationMethodP,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, Vacuum, and DesiccantUnderVacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			Category -> "Desiccation"
		},
		ValvePosition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Open | Closed,
			Description -> "The state of the of vacuum valve of the desiccator if Desiccate is set to True. Open or Closed respectively indicate if the valve is open or closed to the vacuum pump.",
			Category -> "Desiccation"
		},
		Desiccator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Desiccator], Model[Instrument, Desiccator]],
			Description -> "The instrument in which the sample is exposed to a chemical desiccant to absorb water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		Desiccant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample]],
			Description -> "The hygroscopic chemical that is used in the desiccator to absorb water molecules from the exposed sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		CheckDesiccant -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the desiccant color is examined prior to beginning the experiment. If the color indicates the desiccant is exhausted it is replaced.",
			Category -> "Desiccant"
		},
		DesiccantReplaced -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the desiccant was replaced with a new sample because the original sample was exhausted.",
			Category -> "Experimental Results"
		},
		DesiccantPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Solid, Liquid],
			Description -> "The physical state of the desiccant in the desiccator that dries the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		DesiccantContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
			Description -> "The container that holds the desiccant in the desiccator during desiccation to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		DesiccantAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 Gram], GreaterP[0 Milliliter]],
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		SampleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the container that the sample Amount is transferred into prior to desiccating. The sample is desiccated in the specified container before loading into a capillary and measuring the melting point.",
			Category -> "Desiccation"
		},
		DesiccationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Hour],
			Units -> Hour,
			Description -> "The amount of time that the samples are left in the desiccator.",
			Category -> "Desiccation"
		},
		DesiccationImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[EmeraldCloudFile]],
			Description -> "A link to image files from the desiccant and samples in the desiccator before and after desiccation if Desiccate is set to True.",
			Category -> "Desiccation"
		},
		Sensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor],
			Description -> "The pressure sensor this data was obtained using if Desiccate is set to True and DesiccationMethod is set to Vacuum or DesiccantUnderVacuum.",
			Category -> "Sensor Information"
		},
		Pressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data during desiccation process. Pressure data is recorded if the Method is Vacuum or DesiccantUnderVacuum.",
			Category -> "Sensor Information"
		},

		(*Packing*)
		Prepacked -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the sample is already packed into a melting point capillary.",
			Category -> "Packing",
			Developer -> True
		},
		Capillaries -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{LinkP[Object[Container, Capillary]]..}..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, a group of melting point capillary tube(s) that the sample is packed into before measuring the melting point of the sample.",
			Category -> "Packing"
		},
		Capillary -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Capillary],
			Description -> "A flat list of prepacked or new empty capillaries used in this experiment. This field is the flattened form of Capillaries field.",
			Category -> "Packing",
			Developer -> True
		},
		AssaySamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples (aliquots of SamplesIn) that are packed inside a melting point capillary tube and their melting temperatures are measured.",
			Category -> "Packing"
		},
		CapillaryResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Capillary], Model[Container, Capillary]],
			Description -> "A flat list of capillary tubes that are to be resource picked.",
			Category -> "Packing",
			Developer -> True
		},
		NumberOfCapillaries -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the number of capillaries that are used to pack the same sample, based on NumberOfReplicates, before measuring the melting point.",
			Category -> "Packing",
			Developer -> True
		},
		PackingDevice -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, PackingDevice], Model[Instrument, PackingDevice]],
			Description -> "The instrument that is used to pack powder into capillaries.",
			Category -> "Packing"
		},
		SealCapillary -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines whether to close the top end of the capillary after packing it with the sample.",
			Category -> "Packing"
		},
		Seals -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the sealant that is used to seal the top end of the capillary if SealCapillary is set to True.",
			Category -> "Packing"
		},
		PackingFailures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(BooleanP | Null | {(BooleanP | Null)...})...},
			IndexMatching -> Capillaries,
			Description -> "For each member of Capillaries, set to True if the sample was not successfully tapped down to the bottom of capillary after 3 attempts of packing by the loading device. False indicates the packing is successful and Null indicates the input sample is already packed into a melting point capillary tube.",
			Category -> "Packing"
		},
		SampleImages -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(ObjectP[Object[Data, Appearance]] | Null | {(ObjectP[Object[Data, Appearance]] | Null)...})...},
			IndexMatching -> Capillaries,
			Description -> "For each member of Capillaries, an image of the capillary after packing the Sample into the capillary. The capillaries are imaged inside a height check tool which shows if the height of the sample in the capillaries is about 3 mm.",
			Category -> "Packing"
		},

		(*Measurement*)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, MeltingPointApparatus], Model[Instrument, MeltingPointApparatus]],
			Description -> "The instrument that is used for measuring the melting point of the solid samples.",
			Category -> "Measurement"
		},
		StartTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the initial temperature of the chamber that holds the capillaries before sweeping the temperature to EndTemperature.",
			Category -> "Measurement"
		},
		EquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the amount of time that the sample is equilibrated at StartTemperature before starting temperature ramp.",
			Category -> "Measurement"
		},
		EndTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the final temperature to conclude the temperature sweep of the chamber that holds sample capillary.",
			Category -> "Measurement"
		},
		TemperatureRampRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0.1 Celsius / Minute],
			Units -> Celsius / Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the speed of temperature at which it is swept from StartTemperature to EndTemperature.",
			Category -> "Measurement"
		},
		RampTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, duration of temperature sweep between the StartTemperature and EndTemperature.",
			Category -> "Measurement"
		},

		(* Method and Data *)
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the protocol file which contains the run parameters.",
			Category -> "General",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		},

		(*Storage Information*)
		PreparedSampleStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[LinkP[Model[StorageCondition]], SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the condition under which the PreparedSample from Desiccation and/or grinding is stored after the protocol is completed.",
			Category -> "Storage Information"
		},
		CapillaryStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[LinkP[Model[StorageCondition]], SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, determines the conditions under which the capillary containing the sample is stored after the protocol is completed.",
			Category -> "Storage Information"
		},
		CapillaryStorageCondition -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[LinkP[Model[StorageCondition]], SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			IndexMatching -> Capillary,
			Description -> "For each member of Capillary, determines the condition under which the capillary containing the sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Developer -> True
		},
		DesiccantStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[LinkP[Model[StorageCondition]], SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			Description -> "Indicates the condition that the desiccant will be stored in when it is put away after desiccation.",
			Category -> "Storage Information"
		},
		DesiccantStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "The container that the desiccant is transferred into after desiccation for storage.",
			Category -> "Storage Information"
		}
	}
}];
