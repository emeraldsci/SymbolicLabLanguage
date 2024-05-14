(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, MassSpectrumDeconvolution],
  {
    Description -> "Analysis of tandem mass spectrometry data to identify and combine isotopic peaks of the same molecules, which result primarily from the natural abundance of carbon-13 in large organic molecules, and charge peaks, which result from the various charge states generated during ionization. The process of isotope and charge deconvolution helps to reduce the complexity of the data and improve the effectiveness of spectral annotation methods.",
    CreatePrivileges -> None,
    Cache -> Session,

    Fields -> {
      DeconvolutedMassSpectrum -> {
        Format -> Single,
        Class -> QuantityArray,
        Pattern :> QuantityArrayP[{{Dalton, ArbitraryUnit}..}],
        Units -> {Gram / Mole, ArbitraryUnit},
        Description -> "Deconvoluted spectrum of observed mass-to-charge (m/z) ratio vs peak intensity for this analyte, calibrant, or matrix sample detected by the instrument.",
        Category -> "Analysis & Reports"
      },
      DeconvolutedIonAbundance3D -> {
        Format -> Single,
        Class -> QuantityArray,
        Pattern :> QuantityArrayP[{{Minute, Dalton, ArbitraryUnit}..}],
        Units -> {Minute, Gram / Mole, ArbitraryUnit},
        Description -> "The deconvoluted measured counts of intact ions at each m/z for each retention time point during the course of the experiment for the MassSpectrometry detector. Each entry is {Time, MS1 m/z, IonAbundance}.",
        Category -> "Analysis & Reports"
      },
      IsotopicClusterCharge -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> {NumericP...},
        Units -> None,
        Description -> "The calculated charge states of the peaks in the deconvoluted spectrum as determined by the spacing of the peaks in the isotopic cluster. Peaks not belonging to an isotopic cluster, and thus having an indeterminate charge state, are assigned a value of 0. Note that the charges reported here are not impacted by the ChargeDeconvolution option of the analysis function.",
        Category -> "Analysis & Reports"
      },
      IsotopicClusterPeaksCount -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> {GreaterEqualP[0]...},
        Units -> None,
        Description -> "The number of peaks in the isotopic cluster resulting in the peak in the deconvoluted spectrum.",
        Category -> "Analysis & Reports"
      },
      MassCentroidMzMLFile -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Object[EmeraldCloudFile],
        Description -> "The data from the MassSpectrum field of the data object after smoothing, filtering, and centroiding, but before deconvolution, in mzML format. This data is centroided with respect to m/z, where each peak is represented by a single data point.",
        Category -> "Analysis & Reports"
      },
      DeconvolutionMzMLFile -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Object[EmeraldCloudFile],
        Description -> "The deconvoluted mass spectrum data in mzML format.",
        Category -> "Analysis & Reports"
      },

      (* Options as Individual Fields for Searching. *)
      (* Pre-processing Options *)
      SmoothingWidth -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0 Dalton],
        Description -> "The standard deviation of the one-dimensional Gaussian filter used for noise reduction of the data.",
        Category -> "Option Handling"
      },
      IntensityThreshold -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0 ArbitraryUnit],
        Description -> "The intensity value below which points in the spectrum were removed before centroiding.",
        Category -> "Option Handling"
      },
      (* Peak Clustering Options *)
      IsotopicPeakTolerance -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0 Dalton],
        Description -> "The maximum allowed deviation from the expected position for the peaks of an isotopic cluster.",
        Category -> "Option Handling"
      },
      MinCharge -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0],
        Description -> "The minimum expected charge state of the analyte peaks to be deconvoluted.",
        Category -> "Option Handling"
      },
      MaxCharge -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0],
        Description -> "The maximum expected charge state of the analyte peaks to be deconvoluted.",
        Category -> "Option Handling"
      },
      MinIsotopicPeaks -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0],
        Description -> "The minimum number of peaks required for set of peaks to be considered an isotopic cluster.",
        Category -> "Option Handling"
      },
      MaxIsotopicPeaks -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0],
        Description -> "The maximum number of peaks which can be included in a single isotopic cluster.",
        Category -> "Option Handling"
      },
      AveragineClustering -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> BooleanP,
        Description -> "Indicates if the isotopic peak clustering algorithm employed an intensity check using a decreasing Averagine model, which expects that the isotopic peaks of an analyte containing heavy isotopes will be less intense.",
        Category -> "Option Handling"
      },
      StartIntensityCheck -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> GreaterEqualP[0],
        Description -> "The peak at which the intensity check started being be applied when grouping peaks into isotopic clusters. If AveragineClustering was set to False, this option had no effect on the results.",
        Category -> "Option Handling"
      },
      (* Post-processing Options *)
      KeepOnlyDeisotoped -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> BooleanP,
        Units -> None,
        Description -> "Indicates if peaks which were not part of isotopic clusters were included in the deisotoped data.",
        Category -> "Option Handling"
      },
      SumIntensity -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> BooleanP,
        Description -> "Indicates if the reported intensity of a monoisotopic peak is the sum of all peak intensities in the isotopic peaks cluster. If False, the reported intensity is equal to the intensity of the largest peak in the cluster.",
        Category -> "Option Handling"
      },
      ChargeDeconvolution -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> BooleanP,
        Description -> "Indicates if deisotoped peaks with known charge states were shifted to the single charged m/z value. Note, the listed charges are not impacted by this option.",
        Category -> "Option Handling"
      }

    }
  }
];
