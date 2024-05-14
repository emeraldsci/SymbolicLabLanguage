(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-01-26 *)

DefineUsageWithCompanions[SimulatePeptideFragmentationSpectra, {
  BasicDefinitions -> {
    {
      Definition -> {"SimulatePeptideFragmentationSpectra[Samples]", "Simulations"},
      Description -> "finds the set of ions created after fragmenting the proteins and peptides in the composition field of the 'Samples', and also estimates the likelihood of fragmentation for each generated ion.",
      Inputs :> {
        {
          InputName -> "Samples",
          Description -> "A constellation object reference that represents a Sample that physically exists in the lab.",
          Widget -> Adder[
            Widget[Type -> Object, Pattern :> ObjectP[Object[Sample]], PatternTooltip -> "The constellation object reference for a sample."]
          ]
        }
      },
      Outputs :> {
        {
          OutputName -> "Simulations",
          Pattern :> ListableP[{ObjectP[Object[Simulation,FragmentationSpectra]], {ObjectP[Object[MassFragmentationSpectrum]]..}}],
          Description -> "The Simulation object containing details regarding the set of ions generated during the fragmentation, the likelihood of the generation of the ion, and the parent sequence of the ion."
        }
      }
    },
    {
      Definition -> {"SimulatePeptideFragmentationSpectra[Strands]", "Simulations"},
      Description -> "finds the set of ions created after fragmenting the peptide or protein defined by the 'Strand', and also estimates the likelihood of fragmentation for each generated ions.",
      Inputs :> {
        {
          InputName -> "Strands",
          Description -> "A 'Strand' that represents a protein or peptide.",
          Widget -> Adder[
            Widget[Type -> Expression, Pattern :> StrandP, PatternTooltip -> "A peptide and protein strands.", Size->Paragraph]
          ]
        }
      },
      Outputs :> {
        {
          OutputName -> "Simulations",
          Pattern :> ListableP[{ObjectP[Object[Simulation,FragmentationSpectra]], {ObjectP[Object[MassFragmentationSpectrum]] ..}}],
          Description -> "The Simulation object containing details regarding the set of ions generated during the fragmentation, the likelihood of the generation of the ion, and the parent sequence of the ion."
        }
      }
    },
    {
      Definition -> {"SimulatePeptideFragmentationSpectra[States]", "Simulations"},
      Description -> "finds the set of ions created after fragmenting the proteins and peptides in the species field of the 'States', and also estimates the likelihood of fragmentation for each generated ion.",
      Inputs :> {
        {
          InputName -> "States",
          Description -> "A State that represents a sample containing proteins or peptides.",
          Widget -> Adder[
            Widget[Type -> Expression, Pattern :> StateP, PatternTooltip -> "A state representing a sample containing proteins or peptides.", Size->Paragraph]
          ]
        }
      },
      Outputs :> {
        {
          OutputName -> "Simulations",
          Pattern :> ListableP[{ObjectP[Object[Simulation,FragmentationSpectra]], {ObjectP[Object[MassFragmentationSpectrum]] ..}}],
          Description -> "The Simulation object containing details regarding the set of ions generated during the fragmentation, the likelihood of the generation of the ion, and the parent sequence of the ion."
        }
      }
    }

  },
  MoreInformation -> {
    "SimulatePeptideFragmentationSpectra is designed to replicate high-energy, high-resolution MALDI mass spectrometry (MS) experiments and tandem MS (MS2) experiments. Notably, this simulation function does not replicate ESI or QQQ-based instruments doing single MS (MS1), which are weakly ionizing and generate only the various precursor ions, not the fragment ions, but can replicate them if they are doing tandem MS. The options for this function reflect high-energy fragmentation, and provide control over which fragment types (a,b,c,x,y,z, precursors, and losses) are included, the charge of the fragments, an how many isotope peaks will be included. Commonly, peptide fragmentation will be preceded by a digest step, which can be added by setting the Protease option. Otherwise, Protease will default to Null, such that no digest occurs."
  },
  SeeAlso -> {
    "SimulateDigest", "SimulateFolding"
  },
  Author -> {
    "scicomp",
    "tommy.harrelson",
    "brian.day"
  }
}];
