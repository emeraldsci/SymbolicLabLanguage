(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Object[Method, CrystallizationScreening], {
  Description -> "A method containing parameters specifying screening conditions utilized by a crystallization experiment.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    ReservoirBuffers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The screening solutions composed of precipitants, salts, and pH buffers. In the presence of multiple ReservoirBuffers, they are combined with the input sample in a multiplexed fashion. These combined solutions are added to drop wells to discover crystallization conditions for the input sample. If the CrystallizationTechnique is SittingDropVaporDiffusion, ReservoirBuffers are also included in the reservoir wells. In such a plate configuration, the drops sharing headspace with each reservoir well have the same precipitant composition.",
      Category -> "Sample Preparation"
    },
    Additives -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The screening solutions composed of either organic solvents, salts, amino acids,or polymers to manipulate sample-sample and sample-solvent interactions. These solutions are introduced to the drop well of CrystallizationPlate in the attempt to improve crystal quality. In the presence of multiple PrimaryAdditives, they are combined with the input sample in a multiplexed fashion, thus each drop has a distinct additive composition.",
      Category -> "Sample Preparation"
    },
    CoCrystallizationReagents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The screening solutions composed of either small molecule drugs, metal salts, antibodies or other ligands to solidify together with the input sample. In the presence of multiple CoCrystallizationReagents, they are combined with the input sample in a multiplexed fashion in attempt to form crystals in the drop wells. Each crystal constitutes a multicomponent system of the same input sample and one of the CoCrystallizationReagents.",
      Category -> "Sample Preparation"
    }
  }
}];
