(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, Oligomer], {
  Description->"Physical parameters for an oligomer set, including the alphabet representing the monomers, the relationship between the monomers, and their physical properties such as mass, extinction coefficient, thermodynamics and kinetics.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    (* --- Model Information --- *)
    Alphabet -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "The possible monomers for this oligomer set.",
      Category -> "Model Information",
      Abstract -> True
    },
    DegenerateAlphabet -> {
      Format -> Multiple,
      Class -> {String, String},
      Pattern :> {_String, _String},
      Headers -> {"Symbol","Monomer"},
      Description -> "Symbols representing zero or more possible monomers that could exist in a given position in the sequence.",
      Category -> "Model Information",
      Abstract -> True
    },
    WildcardMonomer -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The symbol which represents that any possible monomer can exist at its specified position in a sequence.",
      Category -> "Model Information"
    },
    NullMonomer -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The symbol which represents an empty placeholder site (backbone only, no monomer) at its specified position in a sequence.",
      Category -> "Model Information"
    },
    Complements -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of Alphabet, the pairing relationships between monomers that will spontaneously form an intermolecular hybrid of two strands of complementary sequence.",
      Category -> "Model Information",
      IndexMatching -> Alphabet,
      Abstract -> True
    },
    Pairing -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_String...},
      Description -> "For each member of Alphabet, the pairing relationships between monomers that will spontaneously form an intermolecular hybrid of two strands.",
      Category -> "Model Information",
      IndexMatching -> Alphabet,
      Abstract -> True
    },
    AlternativeEncodings -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {Rule[_String,_String]..},
      Description -> "Additional symbolic representations for the alphabet, each of which can be used in place of the standard alphabet and will be treated as equivalent, in the form: {Alternative Alphabet Monomer -> Alphabet Monomer..}.",
      Category -> "Model Information"
    },
    AlternativeDegenerateEncodings -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {Rule[_String,_String]..},
      Description -> "Additional symbolic representations for the degenerate alphabet, each of which can be used in place of the standard degenerate alphabet and will be treated as equivalent, in the form: {Alternative Degenerate Symbol -> Degenerate Alphabet Symbol..}.",
      Category -> "Model Information"
    },
    Modifications -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Physics,Modification][Oligomers],
      Description -> "Contains parameters concerning custom monomers not included in the standard Alphabet of the given Oligomer type, such as fluorescent labels, terminal functional groups, etc.",
      Category -> "Model Information"
    },

    (* Synthesis Information *)
    SyntheticMonomers -> {
      Format -> Multiple,
      Class -> {Monomer -> String, Strategy -> Expression, StockSolutionModel -> Link},
      Pattern :> {Monomer -> _String, Strategy -> None|Boc|Fmoc|Phosphoramidite|_String, StockSolutionModel -> Null|_Link},
      Units -> {Monomer -> None, Strategy -> None, StockSolutionModel -> None},
      Relation -> {Monomer -> Null, Strategy -> Null, StockSolutionModel -> Model[Sample,StockSolution]},
      Headers->{Monomer->"Monomer",Strategy->"Strategy",StockSolutionModel->"StockSolution"},
      Description -> "StockSolutions used as defaults by the synthesis experiment function for this type of Polymer to grow the polymeric chain. For cases where different synthetic strategies are possible (Boc and Fmoc for example), different StockSolutions might be specified.",
      Category -> "Model Information"
    },
    DownloadMonomers -> {
      Format -> Multiple,
      Class -> {Monomer -> String, Strategy -> Expression, StockSolutionModel -> Link},
      Pattern :> {Monomer -> _String, Strategy -> None|Boc|Fmoc|Phosphoramidite|_String, StockSolutionModel -> Null|_Link},
      Units -> {Monomer -> None, Strategy -> None, StockSolutionModel -> None},
      Relation -> {Monomer -> Null, Strategy -> Null, StockSolutionModel -> Model[Sample,StockSolution]},
      Headers->{Monomer->"Monomer",Strategy->"Strategy",StockSolutionModel->"StockSolutionModel"},
      Description -> "StockSolutions used by the synthesis experiment function for this type of Polymer to moderate the number of reactive sites on the unmodified solid support. Different defaults can be used for different synthetic strategies (Boc and Fmoc for example).",
      Category -> "Model Information"
    },

    (* --- Physical Properties --- *)
    MonomerMolecule -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MoleculeP,
      Description -> "For each member of Alphabet, the monomer molecule within the context of a larger oligomer chain.",
      Category -> "Physical Properties",
      IndexMatching -> Alphabet
    },
    MonomerMass -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Gram/Mole],
      Units -> Gram/Mole,
      Description -> "For each member of Alphabet, the mass of each monomer subunit within the context of a larger oligomer chain.",
      Category -> "Physical Properties",
      IndexMatching -> Alphabet
    },
    InitialMolecule -> {
      Format -> Single,
      Class -> {Expression, Expression},
      Pattern :> {MoleculeP|None,MoleculeP|None},
      Headers -> {"Addition","Removal"},
      Description -> "The molecule attached at the start (N terminus for peptides and 3'-end for DNA/RNA/PNA) of the strand after accounting for all of the internal subunits.",
      Category -> "Physical Properties"
    },
    InitialMass -> {
      Format -> Single,
      Class -> Real,
      Pattern :> UnitsP[Gram/Mole],
      Units -> Gram/Mole,
      Description -> "The mass adjustment given to the oligomer to correct the differences in the atoms attached at the start (N terminus for peptides and 3'-end for DNA/RNA/PNA) of the strand after accounting for all of the internal subunits.",
      Category -> "Physical Properties"
    },
    TerminalMolecule -> {
      Format -> Single,
      Class -> {Expression, Expression},
      Pattern :> {MoleculeP|None,MoleculeP|None},
      Headers -> {"Addition","Removal"},
      Description -> "The molecule attached at the end (C terminus for peptides and 5'-end for DNA/RNA/PNA) of the strand after accounting for all of the internal subunits.",
      Category -> "Physical Properties"
    },
    TerminalMass -> {
      Format -> Single,
      Class -> Real,
      Pattern :> UnitsP[Gram/Mole],
      Units -> Gram/Mole,
      Description -> "The mass adjustment given to the oligomer to correct the differences in the atoms attached at the end (C terminus for peptides and 5'-end for DNA/RNA/PNA) of the strand after accounting for all of the internal subunits.",
      Category -> "Physical Properties"
    },
    ExtinctionCoefficients -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Physics,ExtinctionCoefficients][OligomerPhysics],
      Description -> "Denotes how strongly each monomer or a pair of monomers absorbs a particular wavelength of light per sample path length.",
      Category -> "Physical Properties"
    },
    Thermodynamics -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation ->  Model[Physics,Thermodynamics][OligomerPhysics],
      Description -> "Denotes the nearest neighbor parameter sets for various stacking, loop, and mismatch configurations of the oligomer.",
      Category -> "Physical Properties"
    },
    Kinetics -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Physics,Kinetics][OligomerPhysics],
      Description -> "Contains the various hybridization and strand exchange parameters. Some parameters are given as constants while others are expressed as functions of properties of the strand such as its length.",
      Category -> "Physical Properties"
    },
    AlternativeParameterization -> {
      Format -> Multiple,
      Class -> {
        Model -> Expression,
        ReferenceOligomer -> Link,
        SubstitutionRules -> Expression
      },
      Pattern :> {
        Model -> All|ExtinctionCoefficients|Thermodynamics|Kinetics,
        ReferenceOligomer-> _Link,
        SubstitutionRules -> {(Rule[_String,_String]|_Rule|_RuleDelayed)..}
      },
      Relation -> {
        Model -> Null,
        ReferenceOligomer -> Model[Physics,Oligomer],
        SubstitutionRules -> Null
      },
      Headers->{
        Model->"Model",
        ReferenceOligomer->"Reference Oligomer",
        SubstitutionRules -> "Substitution Rules"
      },
      Description -> "If any of the ExtinctionCoefficient, Thermodynamics, or Kinetics models are not available, use the parameters available in a substitute oligomer given the substitution rules.",
      Category -> "Physical Properties"
    }
  }
}];
