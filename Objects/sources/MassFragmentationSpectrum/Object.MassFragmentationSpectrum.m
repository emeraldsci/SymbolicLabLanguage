(* Mathematica Source File *)
(* :Author: brianday *)
(* :Date: 2023-04-13 *)

DefineObjectType[Object[MassFragmentationSpectrum],{
  Description -> "A predicted spectrum that relates mass-to-charge ratios to intensities. The prediction comes solely from an input sample object, and relies on the identity models in the Composition field.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    },
    Reference -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Simulation, FragmentationSpectra][MassFragmentationSpectra],
      Description -> "The fragmentation spectra simulation which generated this mass spectrum.",
      Category -> "General",
      Abstract -> True
    },
    Ions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {StrandP..},
      Description -> "The molecular structure of each fragmented ion, not accounting for any side chain losses.",
      Category -> "General",
      Abstract -> True
    },
    IonLabels -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_String..},
      Description -> "For each member of Ions, the list of ion labels associated with each ion created in the sequence. These ion labels are four component codes describing the type of ion (usually y or b), the size (in number of amino acids), the charge, and the loss/addition of a neutral molecule. An example is \"y12-H2O++\", which is a y-type ion with 12 residues, a charge of +2, and a neutral loss of a water molecule.",
      Category -> "General",
      IndexMatching -> Ions,
      Abstract -> True
    },
    Losses -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_String..|Null},
      Description -> "For each member of Ions, the molecules lost from the side chains during fragmentation (which are not reflected in the Strand representation of the ion), or Null if there are no losses from the molecule.",
      Category -> "General",
      IndexMatching -> Ions,
      Abstract -> True
    },
    Masses -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {GreaterP[0 Dalton]..},
      Description -> "For each member of Ions, the mass of the fragment.",
      Category -> "General",
      IndexMatching -> Ions,
      Abstract -> True
    },
    Charges -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer..},
      Description -> "For each member of Ions, the charge of the fragment.",
      Category -> "General",
      IndexMatching -> Ions,
      Abstract -> True
    },
    MassToChargeRatios -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {GreaterP[0 Dalton]..},
      Description -> "For each member of Ions, the mass of the fragment divided by its charge.",
      Category -> "General",
      IndexMatching -> Ions,
      Abstract -> True
    },
    RelativeIntensities -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {GreaterP[0.]..},
      Description -> "For each member of Ions, the calculated frequency with which a fragment is generated. The absolute scale is relative because the set of intensities for each fragment sums to unity.",
      Category -> "General",
      IndexMatching -> Ions,
      Abstract -> True
    }
  }
}];
