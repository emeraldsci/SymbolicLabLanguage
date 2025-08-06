(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-04-03 *)

DefineObjectType[Object[Instrument, pHTitrator], {
  Description->"Device for automatically titrating in pH adjustment.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    AcidContainerCap -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,Cap][pHTitrator],
        Object[Plumbing,AspirationCap][pHTitrator]
      ],
      Description -> "The aspiration cap used to uptake acid solution from the acid container to the instrument pump.",
      Category -> "Instrument Specifications"
    },
    BaseContainerCap -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,Cap][pHTitrator],
        Object[Plumbing,AspirationCap][pHTitrator]
      ],
      Description -> "The aspiration cap used to uptake base solution from the base container to the instrument pump.",
      Category -> "Instrument Specifications"
    },
    AcidContainerInlet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Plumbing, Tubing][pHTitrator]|Object[Plumbing, Tubing],
      Description -> "The tubing used by this pHTitrator to uptake acid solution from the acid container into the syringe of the instrument.",
      Category -> "Instrument Specifications"
    },
    BaseContainerInlet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Plumbing, Tubing][pHTitrator]|Object[Plumbing, Tubing],
      Description -> "The tubing used by this pHTitrator to uptake base solution from the base container into the syringe of the instrument.",
      Category -> "Instrument Specifications"
    },
    AcidContainerOutlet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Plumbing, Tubing][pHTitrator]|Object[Plumbing, Tubing],
      Description -> "The tubing used by this pHTitrator to add acid solution to sample container from the syringe of the instrument.",
      Category -> "Instrument Specifications"
    },
    BaseContainerOutlet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Plumbing, Tubing][pHTitrator]|Object[Plumbing, Tubing],
      Description -> "The tubing used by this pHTitrator to add base solution to sample container from the syringe of the instrument.",
      Category -> "Instrument Specifications"
    },
    AcidInletCleaningSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The cleaning solution used by this pHTitrator to clean the acid inlet tubing after experiment when titration method is robotic.",
      Category -> "Instrument Specifications",
      Developer -> True
    },
    BaseInletCleaningSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The cleaning solution used by this pHTitrator to clean the base inlet tubing after experiment when titration method is robotic.",
      Category -> "Instrument Specifications",
      Developer -> True
    },
    MixInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Instrument, OverheadStirrer],
      Description -> "The OverheadStirrer assigned to this pHTitrator for mixing samples in AdjustpH when titration method is robotic.",
      Category -> "Instrument Specifications",
      Developer -> True
    },
    pHMeter -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Instrument, pHMeter],
      Description -> "The pHMeter assigned to this pHTitrator for mixing samples in AdjustpH when titration method is robotic.",
      Category -> "Instrument Specifications",
      Developer -> True
    }
  }
}];