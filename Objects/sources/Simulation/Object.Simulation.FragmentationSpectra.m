(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-01-09 *)

DefineObjectType[Object[Simulation, FragmentationSpectra],{
  Description -> "A predicted spectrum that takes molecules from an Object[Sample], Strand, or State, and relates mass-to-charge ratios to intensities of the fragments. For an Object[Sample] input, the prediction relies on the identity models in the Composition field.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    Reference -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The sample object that represents the proteins/peptides in this mass spectrum simulation. Each molecule is digested and fragmented into ions, and their masses are calculated and relative abundances are simulated.",
      Category -> "General",
      Abstract -> True
    },
    InputState -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> StateP,
      Description -> "The state that represents the proteins/peptides and their concentrations used in this mass spectrum simulation. Each molecule is digested and fragmented into ions, and their masses are calculated and relative abundances are simulated.",
      Category -> "General",
      Abstract -> True
    },
    PrecursorMolecules -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> StrandP,
      Description -> "The strands representing the proteins/peptides used in the mass spectrum simulations. The molecules in the InputState are digested by the Protease (no digest if not specified), generating the PrecursorMolecules.",
      Category -> "Simulation Results",
      Abstract -> True
    },
    MassFragmentationSpectra -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> {_Link..},
      Relation -> Object[MassFragmentationSpectrum][Reference],
      Description -> "For each member of PrecursorMolecules, the object containing the results of the simulated mass fragmentation spectrum, which includes information regarding the ions, ion labels, mass-to-charge ratios, and peak intensities.",
      Category -> "Simulation Results",
      IndexMatching -> PrecursorMolecules,
      Abstract -> True
    }
  }
}];
