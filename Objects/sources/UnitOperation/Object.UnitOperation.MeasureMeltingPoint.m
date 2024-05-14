(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, MeasureMeltingPoint], {
	Description -> "A detailed set of parameters that specifies measuring melting point of solid substances in a larger protocol.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* input *)
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[{Object[Container], Object[Sample]}]..} | {_String..},
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleResource -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Container],
				Model[Container]
			],
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General"
		},
		(* label for simulation *)
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the source sample that are being used in the experiment, which is used for identification in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the SampleContainer that contains the sample during desiccation, which is used for identification in downstream unit operations.",
			Category -> "General"
		},
		PreparedSampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a word or phrase defined by the user to identify the the prepared sample (by desiccation and/or grinding) for use in downstream unit operations.",
			Category -> "General"
		},
		PreparedSampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the label of the container of the prepared sample (by grinding and/or desiccation) used for identification in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		(* This is either Sample or the corresponding WorkingSamples after aliquoting etc. *)
		WorkingSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of SampleLink, the samples to be ground after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Developer -> True
		},
		WorkingContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of Capillaries, the containers holding the samples to be filtered after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> Capillaries,
			Developer -> True
		},
		WorkingCapillary -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Capillary],
				Model[Container, Capillary]
			],
			Description -> "A capillary or capillaries that are packed or going to be packed with sample(s).",
			Category -> "General",
			Developer -> True
		},
		PreparedSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples that are prepared by desiccation or grinding before being packed into melting point capillary tubes.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "Grind and/or desiccate unit operations used for preparing samples before packing them into melting point capillaries.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		(*Experiment Options*)
		(*General*)
		MeasurementMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Pharmacopeia, Thermodynamic],
			Description -> "Determines the method used to adjust the measured temperatures obtained from the apparatus's temperature sensor. When set to \"Pharmacopeia\", the temperatures are adjusted using Pharmacopeia melting point standards; when set to \"Thermodynamic\", thermodynamic melting point standards are utilized for temperature adjustments. In \"Pharmacopeia\" mode, adjustments are based on experimental measurements following pharmacopeial guidelines. This method neglects the furnace temperature being slightly higher than the sample temperature during heating, leading to dependency on heating rate for comparability. In contrast, \"Thermodynamic\" mode provides a physically accurate melting point that represents the theoretical temperature at which a substance transitions from solid to liquid phase under standard conditions.",
			Category -> "General"
		},
		OrderOfOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[{Desiccate, Grind}, {Grind, Desiccate}],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates which preparatory step (Grind or Desiccate) is performed first if both are set to True.",
			Category -> "General"
		},
		NumbersOfReplicates -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[2, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of melting point capillaries to be packed with the same sample and read.",
			Category -> "General"
		},
		ExpectedMeltingPointReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the approximate melting point of the sample, if known.",
			Category -> "General",
			Migration -> SplitField
		},
		ExpectedMeltingPointExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[Unknown | Null],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the approximate melting point of the sample, if known.",
			Category -> "General",
			Migration -> SplitField
		},
		AmountVariableUnit -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 * Milliliter] | GreaterEqualP[0 * Milligram],
			Description -> "For each member of SampleLink, the mass of the sample to be ground and/or desiccated before packing into  into a melting point capillary and measuring melting point.",
			Category -> "General",
			Migration -> SplitField
		},
		AmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> All,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the mass of the sample to be ground and/or desiccated before packing into  into a melting point capillary and measuring melting point.",
			Category -> "General",
			Migration -> SplitField
		},
		(*Grind*)
		Grind -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if the sample is ground into smaller particles via a grinder before packing into a melting point capillary and measuring melting point.",
			Category -> "Grinding"
		},
		GrinderType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GrinderTypeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
			Category -> "Grinding"
		},
		Grinder -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Grinder], Model[Instrument, Grinder]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the instrument that is used for reducing the size of the powder particles of the sample by mechanical actions.",
			Category -> "Grinding"
		},
		Fineness -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Millimeter],
			Units -> Millimeter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the approximate length of the largest particle of the sample.",
			Category -> "Grinding"
		},
		BulkDensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Gram / Milliliter],
			Units -> Gram / Milliliter,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
			Category -> "Grinding"
		},
		GrindingContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that the sample is transferred into during the grinding process if Grind is set to True. Refer to the table in the instrumentation section of the help files for more information about the containers that are used for each model of grinders.",
			Category -> "Grinding"
		},
		GrindingBead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item], Model[Item]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result rapid mechanical movements of the grinding container.",
			Category -> "Grinding"
		},
		NumberOfGrindingBeads -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
			Category -> "Grinding"
		},
		GrindingRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the speed of the circular motion of the grinding tool at which the sample is ground into a fine powder.",
			Category -> "Grinding"
		},
		GrindingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration for which the solid substance is ground into a fine powder in the grinder.",
			Category -> "Grinding"
		},
		NumberOfGrindingSteps -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
			Category -> "Grinding"
		},
		CoolingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration of time that the grinder is switched off between after each grinding step to cool down the sample and prevent overheating.",
			Category -> "Grinding"
		},
		GrindingProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{Alternatives[Grinding, Cooling], Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 Hertz]], GreaterEqualP[0 Minute]}..},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the grinding activity (Grinding/GrindingRate or Cooling) over the course of time, in the form of {{Grinding, GrindingRate, Time}..}.",
			Category -> "Grinding"
		},
		GrindingVideo -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[EmeraldCloudFile]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a link to a video file that displays the process of grinding the sample if Instrument is set to MortarGrinder.",
			Category -> "Grinding"
		},

		(*Desiccation*)
		Desiccate -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if the sample is desiccated (dried in a desiccator) before packing into a melting point capillary and measuring melting point.",
			Category -> "Desiccation"
		},
		DesiccationMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesiccationMethodP,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, DesiccantUnderVacuum, and Vacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			Category -> "Desiccation"
		},
		ValvePosition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Open, Closed],
			Description -> "The state of the of vacuum valve of the desiccator if Desiccate is set to True. Open or Closed respectively indicate if the valve is open or closed to the vacuum pump.",
			Category -> "Desiccation"
		},
		Desiccator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Desiccator], Model[Instrument, Desiccator]],
			Description -> "The instrument that is used to dry the sample by exposing the sample with its container lid open in a bell jar which includes a chemical desiccant either at atmosphere or vacuum.",
			Category -> "Desiccation"
		},
		DesiccantPhase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Solid, Liquid],
			Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		Desiccant -> { (*TODO change desiccant to Object/Model[Sample] (from consumable), then correct pattern here*)
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample], Model[Sample], Object[Item, Consumable], Model[Item, Consumable]],
			Description -> "A hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		DesiccantContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "The container that holds the desiccant in the desiccator during desiccation to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		DesiccantAmount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 Gram], GreaterEqualP[0 Milliliter]],
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
			Category -> "Desiccation"
		},
		SampleContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that the sample Amount is transferred into prior to desiccating in a bell jar. The container's lid is off during desiccation.",
			Category -> "Desiccation"
		},
		DesiccationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "Duration of time that the sample is dried with the lid off via desiccation inside a desiccator.",
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
			Relation -> Alternatives[Object[Sensor]],
			Description -> "The pressure sensor this data was obtained using if Desiccate is set to True and DesiccationMethod is set to Vacuum or DesiccantUnderVacuum.",
			Category -> "Sensor Information"
		},
		Pressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Data]],
			Description -> "The pressure data during desiccation process. Pressure data is recorded if the Method is Vacuum or DesiccantUnderVacuum.",
			Category -> "Sensor Information"
		},

		(*Packing*)
		Prepacked -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesLink, indicates if the sample is already packed into a melting point capillary.",
			Category -> "Packing",
			Developer -> True
		},
		Capillaries -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Capillary], Model[Container, Capillary]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a group of melting point capillary tube(s) that the sample is packed into before measuring the melting point of the sample. If the initial input sample is already contained within a capillary tube, it is included here without curly brackets. Otherwise, they are presented within curly brackets.",
			Category -> "Packing"
		},
		NumberOfCapillaries -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of capillaries that are used to pack the same sample, based on NumberOfReplicates, before measuring the melting point.",
			Category -> "Packing",
			Developer -> True
		},
		SealCapillary -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines whether to close the top end of the capillary after packing it with the sample.",
			Category -> "Packing"
		},
		Seals -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Consumable], Model[Item, Consumable]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the sealant that is used to seal the top end of the capillary if SealCapillary is set to True.",
			Category -> "Packing"
		},
		PackingFailure -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> Capillaries,
			Description -> "For each member of Capillaries, set to True if the sample was not successfully tapped down to the bottom of capillary after an hour of taping by the loading device.",
			Category -> "Packing"
		},
		SampleImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance],
			IndexMatching -> Capillaries,
			Description -> "For each member of Capillaries, images of capillaries after packing the Sample into the capillaries. The capillaries are imaged inside a height check tool which shows if the height of the sample in the capillaries is about 3 mm.",
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
		MethodName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Refers to the task name within the instrument software, where sample runs are executed.",
			Category -> "Measurement",
			Developer -> True
		},
		StartTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the initial temperature of the chamber that holds the capillaries before sweeping the temperature to EndTemperature.",
			Category -> "Measurement"
		},
		EquilibrationTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the amount of time that the sample is equilibrated at StartTemperature before starting temperature ramp.",
			Category -> "Measurement"
		},
		EndTemperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kelvin],
			Units -> Celsius,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the final temperature to conclude the temperature sweep of the chamber that holds sample capillary.",
			Category -> "Measurement"
		},
		TemperatureRampRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0.1 Celsius / Minute],
			Units -> Celsius / Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the speed of temperature at which it is swept from StartTemperature to EndTemperature.",
			Category -> "Measurement"
		},
		RampTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, duration of temperature sweep between the StartTemperature and EndTemperature.",
			Category -> "Measurement"
		},

		(*Storage Information*)
		RecoupSample -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, indicates if the PreparedSample from Desiccation and/or grinding is retained after it is used to pack the melting point capillary.",
			Category -> "Storage Information"
		},
		PreparedSampleContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the container that the PreparedSample from Desiccation and/or grinding is transferred into for storage after the experiment.",
			Category -> "Storage Information"
		},
		PreparedSampleStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the condition under which the PreparedSample from Desiccation and/or grinding is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration -> SplitField
		},
		PreparedSampleStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the condition under which the PreparedSample from Desiccation and/or grinding is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration -> SplitField
		},
		CapillaryStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the condition under which the capillary containing the sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration -> SplitField
		},
		CapillaryStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleStorageTypeP, Desiccated, VacuumDesiccated, RefrigeratorDesiccated, Disposal],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the condition under which the capillary containing the sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration -> SplitField
		}
	}
}]







