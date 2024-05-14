(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, Thermodynamics], {
  Description -> "Thermodynamic parameters for an oligomer set. Denotes the nearest neighbor parameter sets for various stacking, loop, and mismatch oligomer configurations.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    (* --- Model Information --- *)
    OligomerPhysics -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Physics,Oligomer][Thermodynamics],
      Description -> "The physical model containing parameters for the oligomer that this thermodynamics information is associated with.",
      Category -> "Model Information"
    },
    (* --- Physical Properties --- *)
    StackingEnergy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Sense Dimer","Antisense Dimer","Energy"},
      Description -> "The nearest neighbor parameters for the Gibbs free energy of the stabilizing interaction between flat surfaces of adjacent bases at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    StackingEnthalpy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Sense Dimer","Antisense Dimer","Enthalpy"},
      Description -> "The nearest neighbor parameters for the enthalpy of the stabilizing interaction between flat surfaces of adjacent bases.",
      Category -> "Physical Properties"
    },
    StackingEntropy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,None,CaloriePerMoleKelvin},
      Headers -> {"Sense Dimer","Antisense Dimer","Entropy"},
      Description -> "The nearest neighbor parameters for the entropy of the stabilizing interaction between flat surfaces of adjacent bases.",
      Category -> "Physical Properties"
    },
    InitialEnergyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Sense Strand Type","Antisense Strand Type","Energy Correction"},
      Description -> "The initial energy adjustment when calculating the Gibbs free energy of binding between two oligomer strands by the nearest neighbor method at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    InitialEnthalpyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Enthalpy Correction"},
      Description -> "The initial enthalpy adjustment when calculating the enthalpy of binding between two oligomer strands by the nearest neighbor method.",
      Category -> "Physical Properties"
    },
    InitialEntropyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,None,CaloriePerMoleKelvin},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Entropy Correction"},
      Description -> "The initial entropy adjustment when calculating the entropy of binding between two oligomer strands by the nearest neighbor method.",
      Category -> "Physical Properties"
    },
    TerminalEnergyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Energy Correction"},
      Description -> "The terminal energy adjustment when calculating the Gibbs free energy of binding between two oligomer strands by the nearest neighbor method at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    TerminalEnthalpyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Enthalpy Correction"},
      Description -> "The terminal enthalpy adjustment when calculating the enthalpy of binding between two oligomer strands by the nearest neighbor method.",
      Category -> "Physical Properties"
    },
    TerminalEntropyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,None,CaloriePerMoleKelvin},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Entropy Correction"},
      Description -> "The terminal entropy adjustment when calculating the entropy of binding between two oligomer strands by the nearest neighbor method.",
      Category -> "Physical Properties"
    },
    SymmetryEnergyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Energy Correction"},
      Description -> "The symmetry energy adjustment when calculating the Gibbs free energy of a palindromic oligomer strand binding to itself at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    SymmetryEnthalpyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Enthalpy Correction"},
      Description -> "The symmetry enthalpy adjustment when calculating the enthalpy of a palindromic oligomer strand binding to itself at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    SymmetryEntropyCorrection -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {PolymerP,PolymerP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,None,CaloriePerMoleKelvin},
      Headers ->{"Sense Strand Type","Antisense Strand Type","Entropy Correction"},
      Description -> "The symmetry entropy adjustment when calculating the entropy of a palindromic oligomer strand binding to itself.",
      Category -> "Physical Properties"
    },
    MismatchEnergy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Sense Dimer","Antisense Dimer","Energy"},
      Description -> "The nearest neighbor parameters for the Gibbs free energy of the destabilizing interaction between flat surfaces of unmatched adjacent bases at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    MismatchEnthalpy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Sense Dimer","Antisense Dimer","Enthalpy"},
      Description -> "The nearest neighbor parameters for the enthalpy of the destabilizing interaction between flat surfaces of unmatched adjacent bases.",
      Category -> "Physical Properties"
    },
    MismatchEntropy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,None,CaloriePerMoleKelvin},
      Headers -> {"Sense Dimer","Antisense Dimer","Entropy"},
      Description -> "The nearest neighbor parameters for the entropy of the destabilizing interaction between flat surfaces of unmatched adjacent bases.",
      Category -> "Physical Properties"
    },
    TriLoopEnergy -> {
      Format -> Multiple,
      Class -> {Expression,Real},
      Pattern :> {SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Dimer","Energy"},
      Description -> "The nearest neighbor Gibbs free energy contribution by a special type of three-base hairpin loop in the secondary structure of a nucleic acid at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    TriLoopEnthalpy -> {
      Format -> Multiple,
      Class -> {Expression,Real},
      Pattern :> {SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Dimer","Enthalpy"},
      Description -> "The nearest neighbor enthalpy contribution by a special type of three-base hairpin loop in the secondary structure of a nucleic acid.",
      Category -> "Physical Properties"
    },
    TriLoopEntropy -> {
      Format -> Multiple,
      Class -> {Expression,Real},
      Pattern :> {SequenceP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,CaloriePerMoleKelvin},
      Headers -> {"Dimer","Entropy"},
      Description -> "The nearest neighbor entropy contribution by a special type of three-base hairpin loop in the secondary structure of a nucleic acid.",
      Category -> "Physical Properties"
    },
    TetraLoopEnergy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Dimer","4-mer","Energy"},
      Description -> "The nearest neighbor Gibbs free energy contribution by a special type of four-base hairpin loop in the secondary structure of a nucleic acid at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    TetraLoopEnthalpy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[KilocaloriePerMole]},
      Units -> {None,None,KilocaloriePerMole},
      Headers -> {"Dimer","4-mer","Enthalpy"},
      Description -> "The nearest neighbor enthalpy contribution by a special type of four-base hairpin loop in the secondary structure of a nucleic acid.",
      Category -> "Physical Properties"
    },
    TetraLoopEntropy -> {
      Format -> Multiple,
      Class -> {Expression,Expression,Real},
      Pattern :> {SequenceP,SequenceP,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,None,CaloriePerMoleKelvin},
      Headers -> {"Dimer","4-mer","Entropy"},
      Description -> "The nearest neighbor entropy contribution by a special type of four-base hairpin loop in the secondary structure of a nucleic acid.",
      Category -> "Physical Properties"
    },
    InternalLoopEnergy -> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Loop Size","Energy"},
      Description -> "The Gibbs free energy contribution due to nucleotide separation of a particular size in the middle of a double-stranded oligomer at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    InternalLoopEnthalpy-> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Loop Size","Enthalpy"},
      Description -> "The enthalpy contribution due to nucleotide separation of a particular size in the middle of a double-stranded oligomer.",
      Category -> "Physical Properties"
    },
    InternalLoopEntropy-> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,CaloriePerMoleKelvin},
      Headers -> {"Loop Size","Entropy"},
      Description -> "The entropy contribution due to nucleotide separation of a particular size in the middle of a double-stranded oligomer.",
      Category -> "Physical Properties"
    },
    InternalLoopEnergyFunction -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in InternalLoopEnergy, a function that takes in as input the loop size and returns the Gibbs free energy contribution due to nucleotide separation of a particular size in the middle of a double-stranded oligomer at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    InternalLoopEnthalpyFunction-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in InternalLoopEnthalpy, a function that takes in as input the loop size and returns the enthalpy contribution due to nucleotide separation of a particular size in the middle of a double-stranded oligomer.",
      Category -> "Physical Properties"
    },
    InternalLoopEntropyFunction-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in InternalLoopEntropy, a function that takes in as input the loop size and returns the entropy contribution due to nucleotide separation of a particular size in the middle of a double-stranded oligomer.",
      Category -> "Physical Properties"
    },
    BulgeLoopEnergy -> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Loop Size","Energy"},
      Description -> "The Gibbs free energy contribution due to an asymmetric internal loop of a particular size at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    BulgeLoopEnthalpy -> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Loop Size","Enthalpy"},
      Description -> "The enthalpy contribution due to an asymmetric internal loop of a particular size.",
      Category -> "Physical Properties"
    },
    BulgeLoopEntropy -> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,CaloriePerMoleKelvin},
      Headers -> {"Loop Size","Entropy"},
      Description -> "The entropy contribution due to an asymmetric internal loop of a particular size.",
      Category -> "Physical Properties"
    },
    BulgeLoopEnergyFunction -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in BulgeLoopEnergy, a function that takes in as input the loop size and returns the Gibbs free energy contribution due to an asymmetric internal loop of a particular size at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    BulgeLoopEnthalpyFunction-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in BulgeLoopEnthalpy, a function that takes in as input the loop size and returns the enthalpy contribution due to an asymmetric internal loop of a particular size.",
      Category -> "Physical Properties"
    },
    BulgeLoopEntropyFunction-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in BulgeLoopEntropy, a function that takes in as input the loop size and returns the entropy contribution due to an asymmetric internal loop of a particular size.",
      Category -> "Physical Properties"
    },
    HairpinLoopEnergy-> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Loop Size","Energy"},
      Description -> "The Gibbs free energy contribution due to nucleotide separation resulting in a loop of a particular size in a single-stranded oligomer at STP (37C,1ATM)}.",
      Category -> "Physical Properties"
    },
    HairpinLoopEnthalpy-> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"Loop Size","Enthalpy"},
      Description -> "The enthalpy contribution due to nucleotide separation resulting in a loop of a particular size in a single-stranded oligomer.",
      Category -> "Physical Properties"
    },
    HairpinLoopEntropy-> {
      Format -> Multiple,
      Class -> {Integer,Real},
      Pattern :> {_Integer,UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,CaloriePerMoleKelvin},
      Headers -> {"Loop Size","Entropy"},
      Description -> "The entropy contribution due to nucleotide separation resulting in a loop of a particular size in a single-stranded oligomer.",
      Category -> "Physical Properties"
    },
    HairpinLoopEnergyFunction -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in HairpinLoopEnergy, a function that takes in as input the loop size and returns the Gibbs free energy contribution due to nucleotide separation resulting in a loop of a particular size in a single-stranded oligomer at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    HairpinLoopEnthalpyFunction-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in HairpinLoopEnthalpy, a function that takes in as input the loop size and returns the enthalpy contribution due to nucleotide separation resulting in a loop of a particular size in a single-stranded oligomer.",
      Category -> "Physical Properties"
    },
    HairpinLoopEntropyFunction-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "For loop sizes not in HairpinLoopEntropy, a function that takes in as input the loop size and returns the entropy contribution due to nucleotide separation resulting in a loop of a particular size in a single-stranded oligomer.",
      Category -> "Physical Properties"
    },
    MultipleLoopEnergy -> {
      Format -> Multiple,
      Class -> {Expression,Real},
      Pattern :> {{_Integer,_Integer},UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"{First Loop Size, Second Loop Size}","Energy"},
      Description -> "The Gibbs free energy contribution due to adjacent nucleotide separations of specific sizes at STP (37C,1ATM).",
      Category -> "Physical Properties"
    },
    MultipleLoopEnthalpy -> {
      Format -> Multiple,
      Class -> {Expression,Real},
      Pattern :> {{_Integer,_Integer},UnitsP[KilocaloriePerMole]},
      Units -> {None,KilocaloriePerMole},
      Headers -> {"{First Loop Size, Second Loop Size}","Enthalpy"},
      Description -> "The enthalpy contribution due to adjacent nucleotide separations of specific sizes.",
      Category -> "Physical Properties"
    },
    MultipleLoopEntropy -> {
      Format -> Multiple,
      Class -> {Expression,Real},
      Pattern :> {{_Integer,_Integer},UnitsP[CaloriePerMoleKelvin]},
      Units -> {None,CaloriePerMoleKelvin},
      Headers -> {"{First Loop Size, Second Loop Size}","Entropy"},
      Description -> "The entropy contribution due to adjacent nucleotide separations of specific sizes.",
      Category -> "Physical Properties"
    }
  }
}];
