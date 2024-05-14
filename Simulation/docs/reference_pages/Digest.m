(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-01-25 *)

DefineUsageWithCompanions[SimulateDigest, {
  BasicDefinitions -> {
    {
      Definition -> {"SimulateDigest[Sample, Protease]", "DigestedState"},
      Description -> "determines the cut sites for all components in a 'Sample' given a 'Protease', and returns a 'DigestedState' expression that describes the digested peptides and their concentrations.",
      Inputs :> {
        {
          InputName -> "Sample",
          Description -> "A Constellation object reference that represents a sample that physically exists in the lab.",
          Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Sample]], PatternTooltip -> "The Constellation object reference for a sample."]]
        },
        {
          InputName -> "Protease",
          Description -> "A symbol that represents the enzyme that cuts proteins/peptides at specific sites.",
          Widget -> Adder[Alternatives[
            Widget[Type -> Enumeration, Pattern :> ProteaseP, PatternTooltip -> "A symbol representing a protease."]
          ]]
        }
      },
      Outputs :> {
        {
          OutputName->"DigestedState",
          Pattern:> StateP,
          Description->"A local Mathematica construct that defines the concentrations of components in a solution after digestion."
        }
      }
    },
    {
      Definition -> {"SimulateDigest[State, Protease]", "DigestedState"},
      Description -> "determines the cut sites of a 'State' expression, and returns a 'DigestedState' as another State expression in which the Species contain the digested peptides.",
      Inputs :> {
        {
          InputName -> "State",
          Description -> "A local Mathematica construct that defines the concentrations of components in a solution before digestion. The construct is useful for modeling reaction kinetics.",
          Widget -> Adder[Widget[Type -> Expression, Pattern :> StateP, PatternTooltip -> "An expression representing a solution of biomolecule sequences.", Size -> Line]]
        },
        {
          InputName -> "Protease",
          Description -> "A symbol that represents the enzyme that cuts proteins/peptides at specific sites.",
          Widget -> Adder[Alternatives[
            Widget[Type -> Enumeration, Pattern :> ProteaseP, PatternTooltip -> "A symbol representing a protease."]
          ]]
        }
      },
      Outputs :> {
        {
          OutputName->"DigestedState",
          Pattern:> StateP,
          Description->"A local Mathematica construct that defines the concentrations of components in a solution after digestion."
        }
      }
    },
    {
      Definition -> {"SimulateDigest[IdentityModel, Protease]", "DigestedStrands"},
      Description -> "determines the cut sites of a specified 'Protease' for a given 'IdentityModel', and returns a list of strands, 'DigestedStrands'.",
      Inputs :> {
        {
          InputName -> "IdentityModel",
          Description -> "A Constellation object that represents a protein or a peptide.",
          Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Model[Molecule, Protein], Model[Molecule, Oligomer]}], PatternTooltip -> "The Constellation object reference for either a protein or peptide IdentityModel."]]
        },
        {
          InputName -> "Protease",
          Description -> "A symbol that represents the enzyme that cuts proteins/peptides at specific sites.",
          Widget -> Adder[Alternatives[
            Widget[Type -> Enumeration, Pattern :> ProteaseP, PatternTooltip -> "A symbol representing a protease."]
          ]]
        }
      },
      Outputs :> {
        {
          OutputName->"DigestedStrands",
          Pattern:> {StrandP..},
          Description->"The resulting list of sequences that come from the digest."
        }
      }
    },
    {
      Definition -> {"SimulateDigest[Structure, Protease]", "DigestedStrands"},
      Description -> "determines the cut sites of a specified 'Protease' for a given 'Structure', and returns a list of strands, 'DigestedStrands'.",
      Inputs :> {
        {
          InputName -> "Structure",
          Description -> "A Mathematica expression that defines a complex of bound biomolecules, which can include molecules like DNA, RNA, and Peptides.",
          Widget -> Adder[Widget[Type -> Expression, Pattern :> StrandP, PatternTooltip -> "An expression that represents a complex of bound peptides.", Size -> Line]]
        },
        {
          InputName -> "Protease",
          Description -> "A symbol that represents the enzyme that cuts proteins/peptides at specific sites.",
          Widget -> Adder[Alternatives[
            Widget[Type -> Enumeration, Pattern :> ProteaseP, PatternTooltip -> "A symbol representing a protease."]
          ]]
        }
      },
      Outputs :> {
        {
          OutputName->"DigestedStrands",
          Pattern:> {StrandP..},
          Description->"The resulting list of sequences that come from the digest."
        }
      }
    },
    {
      Definition -> {"SimulateDigest[PeptideStrand, Protease]", "DigestedStrands"},
      Description -> "determines the cut sites of a specified 'Protease' for a given 'PeptideStrand', and returns a list of strands, 'DigestedStrands'.",
      Inputs :> {
        {
          InputName -> "PeptideStrand",
          Description -> "A Mathematica expression that defines the covalently bound subunits of a peptide. Strands can also represent other biomolecules, but they are not allowed as inputs to SimulateDigest.",
          Widget -> Adder[Widget[Type -> Expression, Pattern :> _?PeptideQ, PatternTooltip -> "An expression that represents the peptide sequence.", Size -> Line]]
        },
        {
          InputName -> "Protease",
          Description -> "A symbol that represents the enzyme that cuts proteins/peptides at specific sites.",
          Widget -> Adder[Alternatives[
            Widget[Type -> Enumeration, Pattern :> ProteaseP, PatternTooltip -> "A symbol representing a protease."]
          ]]
        }
      },
      Outputs :> {
        {
          OutputName->"DigestedStrands",
          Pattern:> {StrandP..},
          Description->"The resulting list of sequences that come from the digest."
        }
      }
    }
  },
  SeeAlso -> {
    (* TODO: change this to include the plot and the new name of the mass spectrum simulator *)
    "State",
    "PlotState",
    "Strand",
    "Structure",
    "ExperimentMassSpectrometry",
    "ExperimentLCMS",
    "SimulateDigestOptions",
    "SimulateDigestPreview",
    "ValidSimulationDigestQ"
  },
  Author -> {
    "scicomp",
    "tommy.harrelson"
  }
}];
