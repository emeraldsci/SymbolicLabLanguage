(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation, Grind], {
	Description -> "A detailed set of parameters that specifies a grinding step in a larger protocol.",
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
				Model[Container],
				Object[Container]
			],
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General",
			Migration -> SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[{Object[Container], Object[Sample]}]..} | {_String..},
			Relation -> Null,
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
				Model[Container],
				Object[Container]
			],
			Description -> "The Sample that is to be ground during this unit operation.",
			Category -> "General"
		},
		(* label for simulation *)
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			Migration -> SplitField,
			IndexMatching -> SampleLink
		},
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
			Description -> "For each member of SampleLink, the containers holding the samples to be filtered after any aliquoting, if applicable.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Developer -> True
		},
		(*Experiment Options*)
		(*General*)
		GrinderType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GrinderTypeP,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BalllMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, Grinder], Model[Instrument, Grinder]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the instrument that is used for reducing the size of the powder particles of the sample by mechanical actions.",
			Category -> "General"
		},
		AmountVariableUnit -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram],
			Description -> "For each member of SampleLink, the mass of the sample to be ground into a fine powder via a grinder.",
			Category -> "General",
			Migration->SplitField
		},
		AmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> All,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the mass of the sample to be ground into a fine powder via a grinder.",
			Category -> "General",
			Migration->SplitField
		},
		Fineness -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the approximate size of the largest particle of the sample.",
			Category -> "General"
		},
		BulkDensity -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Gram/Milliliter],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
			Category -> "General"
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
			(*TODO Table x.x*)
			Description -> "For each member of SampleLink, the container that the sample is transferred into during the grinding process. Refer to Table x.x for more information about the containers that are used for each model of grinders.",
			Category -> "General"
		},
		GrindingBead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Model[Item]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles as a result rapid mechanical movements of the grinding container.",
			Category -> "General"
		},
		NumberOfGrindingBeads -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the number of grinding beads or grinding balls that are used along with the sample inside the grinding container to beat and crush the sample into fine particles.",
			Category -> "General"
		},
		GrindingRate -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM]|GreaterEqualP[0 Hertz](*|GreaterEqualP[Quantity[0, IndependentUnit["StrokesPerMinute"]]]*),
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the speed of the circular motion of the grinding tool at which the sample is ground into a fine powder.",
			Category -> "General"
		},
(*		PestleRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the speed of the circular motion of the pestle at which the sample is ground into a fine powder in an automated mortar grinder.",
			Category -> "General"
		},
		MortarRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the speed of the circular motion of the mortar at which the sample is ground into a fine powder in an automated mortar grinder.",
			Category -> "General"
		},*)
		Time -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration for which the solid substance is ground into a fine powder in the grinder.",
			Category -> "General"
		},
		NumberOfGrindingSteps -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
			Category -> "General"
		},
		CoolingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the duration of time that the grinder is switched off between after each grinding step to cool down the sample and prevent overheating.",
			Category -> "General"
		},
		GrindingProfile -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{Alternatives[Grinding, Cooling], Alternatives[GreaterEqualP[0 RPM],GreaterEqualP[0 Hertz](*,GreaterEqualP[Quantity[0,IndependentUnit["StrokesPerMinute"]]]*)], GreaterEqualP[0 Minute]}..},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, determines the grinding activity (Grinding/GrindingRate or Cooling) over the course of time, in the form of {{Grinding, GrindingRate, Time}..}.",
			Category -> "General"
		},
		GrindingProfileForEngineDisplay -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{Alternatives[Grinding, Cooling], GreaterEqualP[0], GreaterEqualP[0 Minute]}..},
			Description -> "Similar to GrindingProfile, the only difference is that the rate is unitless and corrected depending on the instrument. Foe example, for BeadGenie, the operator should insert 200 for a grinding rate of 2000 RPM.",
			Category -> "General",
			Developer -> True
		},
		GrindingVideo -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LinkP[Object[EmeraldCloudFile]]..},
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, a link to a video file that displays the process of grinding the sample if Instrument is set to MortarGrinder.",
			Category -> "General"
		},
		GrinderTubeHolder -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, GrinderTubeHolder],
				Model[Container, GrinderTubeHolder]
			],
			Description -> "Tube holders that are needed for this experiment to hold sample tubes securely during grinding.",
			Category -> "General",
			Developer -> True
		},
		GrinderClampAssembly -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, GrinderClampAssembly],
				Model[Part, GrinderClampAssembly]
			],
			Description -> "Clamps that are needed for this experiment to hold sample tubes securely during grinding.",
			Category -> "General",
			Developer -> True
		},
		WeighingContainer->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, WeighBoat],
				Object[Item, WeighBoat],
				Model[Item, Consumable],
				Object[Item, Consumable]
			],
			Description -> "The container that is used as an intermediate to transfer a sample from one container to another.",
			Category -> "General",
			Developer -> True
		},
		(* output object *)
		ContainerOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the container that the ground sample is transferred into for storage after completing the protocol.",
			Category -> "General"
		},
		SamplesOutStorageConditionExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the non-default condition under which the ground sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration->SplitField
		},
		SamplesOutStorageConditionLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[StorageCondition]],
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the non-default condition under which the ground sample is stored after the protocol is completed.",
			Category -> "Storage Information",
			Migration->SplitField
		},
		
		(* output label *)
		SampleOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the label of the output sample, which is used for identification elsewhere in sample preparation.",
			Category -> "General"
		},
		ContainerOutLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			IndexMatching -> SampleLink,
			Description -> "For each member of SampleLink, the label of the ContainerOut container that contains the output sample, which is used for identification elsewhere in sample preparation.",
			Category -> "General"
		}
	}
}];