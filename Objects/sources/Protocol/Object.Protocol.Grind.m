(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Grind], {
  Description -> "A protocol for reducing the size of powder particles by grinding solid substances into fine powders via a grinder (mill).",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (*General*)
    GrinderTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> GrinderTypeP,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
      Category -> "General"
    },
    Instruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument, Grinder], Model[Instrument, Grinder]],
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the instrument that is used for reducing the size of the powder particles of the sample by mechanical actions.",
      Category -> "General"
    },
    Amounts -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Gram],
      Units -> Gram,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the mass of the sample to be ground into a fine powder via a grinder.",
      Category -> "General"
    },
    Finenesses -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0Milliliter],
      Units -> Milliliter,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the approximate length of the largest particle of the sample.",
      Category -> "General"
    },
    BulkDensities -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Gram/Milliliter],
      Units -> Gram/Milliliter,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
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
      (*TODO Table x.x*)
      Description -> "For each member of SamplesIn, the container that the sample is transferred into during the grinding process. Refer to Table x.x for more information about the containers that are used for each model of grinders.",
      Category -> "General"
    },
    GrindingBeads -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,GrindingBead],
        Model[Item,GrindingBead]
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
      Class -> Real,(*VariableUnit does not work!*)
      Pattern :> GreaterEqualP[0 RPM]|GreaterEqualP[0 Hertz],
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the speed of the circular motion of the grinding tool at which the sample is ground into a fine powder in a BallMill or KnifeMill.",
      Category -> "General"
    },
(*    PestleRates -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the speed of the circular motion of the pestle at which the sample is ground into a fine powder in an automated mortar grinder.",
      Category -> "General"
    },
    MortarRates -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the speed of the circular motion of the mortar at which the sample is ground into a fine powder in an automated mortar grinder.",
      Category -> "General"
    },*)
    Times -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the duration for which the solid substance is ground into a fine powder in the grinder.",
      Category -> "General"
    },
    NumbersOfGrindingSteps -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[2, 1],
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, how many times the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating of the sample. Between each grinding step there is a cooling time that the grinder is switched off to cool down the sample and prevent excessive rise in sample's temperature.",
      Category -> "General"
    },
    CoolingTimes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the duration of time that the grinder is switched off between after each grinding step to cool down the sample and prevent overheating.",
      Category -> "General"
    },
    GrindingProfiles -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{Alternatives[Grinding, Cooling], Alternatives[GreaterEqualP[0 RPM],{GreaterEqualP[0 Hertz]}], GreaterEqualP[0 Minute]}..},
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, determines the grinding activity (Grinding/GrindingRate or Cooling) over the course of time, in the form of {{Grinding, GrindingRate, Time}..}.",
      Category -> "General"
    },
    GrindingVideos -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {LinkP[Object[EmeraldCloudFile]]..},
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, a link to a video file that displays the process of grinding the sample if Instrument is set to MortarGrinder.",
      Category -> "General"
    },
    SampleLabels -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the sample that is ground for use in downstream unit operations.",
      Category -> "General"
    },
    SampleOutLabels -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the output sample (the ground sample) for use in downstream unit operations.",
      Category -> "General"
    },
    Tweezer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item, Tweezer],
        Object[Item, Tweezer]
      ],
      Description -> "The metal tweezers used to transfer grinding beads.",
      Category -> "General",
      Developer -> True
    },
    WeighingContainers->{
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
    (*Storage Information*)
    ContainerOutLabels -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, a word or phrase defined by the user to identify the ContainerOut that the sample is transferred into after the grinding step, for use in downstream unit operations.",
      Category -> "General"
    },
    SamplesOutStorageConditions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[LinkP[Model[StorageCondition]],SampleStorageTypeP,Desiccated,VacuumDesiccated,RefrigeratorDesiccated,Disposal],
      IndexMatching -> SamplesIn,
      Description -> "For each member of SamplesIn, the non-default condition under which the ground sample is stored after the protocol is completed.",
      Category -> "Storage Information"
    }
  }
}];