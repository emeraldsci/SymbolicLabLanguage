(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotPeptideFragmentationSpectra*)


DefineUsage[PlotPeptideFragmentationSpectra, {
  BasicDefinitions -> {
    {
      Definition -> {"PlotPeptideFragmentationSpectra[Simulation]", "Plot"},
      Description -> "generates an interactive 'Plot' representing a mass spectrum 'Simulation' for the sample linked in the simulation object.",
      Inputs :> {
        {
          InputName -> "Simulation",
          Description -> "An Object[Simulation, FragmentationSpectra] that contains the results of a simulated mass spectroscopy experiment for one or more peptides.",
          Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Simulation, FragmentationSpectra]], PatternTooltip -> "The constellation object reference for a tandem mass spectrometry simulation."]
        }
      },
      Outputs :> {
        {
          OutputName->"Plot",
          Pattern:> _Grid|_SlideView,
          Description->"The interactive plot that contains simulated intensities that can be clicked on to reveal the fragment that the peak represents."
        }
      }
    },
    {
      Definition -> {"PlotPeptideFragmentationSpectra[Spectrum]", "Plot"},
      Description -> "generates an interactive 'Plot' representing a mass 'Spectrum'.",
      Inputs :> {
        {
          InputName -> "Spectrum",
          Description -> "An Object[MassFragmentationSpectrum] that contains the results of a simulated mass spectrometry experiment for a single peptide.",
          Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[MassFragmentationSpectrum]], PatternTooltip -> "The constellation object reference for a mass fragmentation spectrum."]
        }
      },
      Outputs :> {
        {
          OutputName->"Plot",
          Pattern:> _Grid|_SlideView,
          Description->"The interactive plot that contains simulated intensities that can be clicked on to reveal the fragment that the peak represents."
        }
      }
    }
  },
  SeeAlso -> {
    "SimulatePeptideFragmentationSpectra",
    "SimulateDigest"
  },
  Author -> {
    "scicomp",
    "brian.day",
    "tommy.harrelson"
  }
}];
