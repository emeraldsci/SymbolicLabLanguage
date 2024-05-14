(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineUsageWithCompanions[AnalyzeMassSpectrumDeconvolution,
  {
    BasicDefinitions->{

      (* Data Object Definition *)
      {
        Definition -> {"AnalyzeMassSpectrumDeconvolution[Data]", "Object"},
        Description -> "denoises and centroids spectral data, and then combines peaks corresponding to analytes of the same elemental composition, but different isotopic compositions, into monoisotopic peaks. Optionally, peaks with known charge states can be shifted to the corresponding single-charged position.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Data",
              Description -> "A data object containing mass spectrometry or Liquid Chromatography Mass Spectrometry (LCMS) data.",
              Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[Data, ChromatographyMassSpectra], Object[Data, MassSpectrometry]}]]
            },
            IndexName -> "Input Data"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Object",
            Description -> "The object containing the analysis results of the deconvolution of the mass spectrometry data.",
            Pattern :> ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
          }
        }
      },

      (* Protocol Object Definition *)
      {
        Definition -> {"AnalyzeMassSpectrumDeconvolution[Protocol]", "Object"},
        Description -> "denoises and centroids spectral data in the linked objects of the Data field of the 'Protocol', and then combines peaks corresponding to analytes of the same elemental composition, but different isotopic compositions, into monoisotopic peaks. Optionally, peaks with known charge states can be shifted to the corresponding single-charged position.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "Protocol",
              Description -> "A protocol object with linked data objects containing mass spectrometry or Liquid Chromatography Mass Spectrometry (LCMS) data.",
              Widget -> Widget[Type->Object, Pattern:>ObjectP[{Object[Protocol, MassSpectrometry], Object[Protocol, LCMS]}]]
            },
            IndexName -> "Input Data"
          ]
        },
        Outputs :> {
          {
            OutputName -> "Object",
            Description -> "The object containing the analysis results of the deconvolution of the mass spectrometry data in the protocol object.",
            Pattern :> ObjectP[Object[Analysis, MassSpectrumDeconvolution]]
          }
        }
      }

    },

    MoreInformation -> {
      "The purpose of this function is to detect and combine the peaks of isotopic clusters in mass spectrum data, and generate a spectrum with reduced complexity for use in additional analyses, such as spectral annotation, with increased effectiveness. Isotopic clusters, which are set of peaks corresponding to analytes of the same elemental composition, but different isotopic compositions, are identified via an algorithm with requires no prior knowledge of the analytes. First, the algorithm removes noise and creates a list of centroided peaks. Then, starting from the lowest m/z value, the algorithm scans each peak in the spectrum, and for each peak, checks if the position is within some distance of the previous peak. If the option UseDecreasingModel is set to True, the algorithm also checks that the intensity of the peak is less than the intensity of the previous peak. If a peak satisfies both the position and intensity criteria relative to the previous peak, the peak is added to the isotopic cluster. This process continues until some peak does not satisfy the criteria, at which point, the algorithm will begin assigning peaks to a new isotopic cluster. Once the algorithm has successfully identified all the peaks of an isotopic cluster, it creates a monoisotopic peak in the deconvoluted spectrum corresponding to that cluster. More detail can be found in the following paper: https://pubs.acs.org/doi/full/10.1021/acs.jproteome.0c00544."
    },
    SeeAlso -> {
      "AnalyzePeaks",
      "SimulateDigest",
      "SimulatePeptideFragmentationSpectra"
    },
    Author -> {"brian.day", "scicomp"},
    Preview->False

  }
]
