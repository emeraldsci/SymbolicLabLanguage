

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Object[Instrument, RamanSpectrometer], {
  Description->"A Raman spectrometer instrument that measures Raman response of a sample to determine chemical or structural characteristics from a spectroscopic fingerprint.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    MaxPower -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxPower]],
      Pattern :> GreaterP[0 Milli*Watt],
      Description -> "The highest achievable power of the excitation laser input at the point where it encounters the objective lens.",
      Category -> "Operating Limits"
    },
    MinStokesScatteringFrequency -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinStokesScatteringFrequency]],
      Pattern :> GreaterP[0 1/Centimeter],
      Description -> "The lowest energy Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    MaxStokesScatteringFrequency -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxStokesScatteringFrequency]],
      Pattern :> GreaterP[0 1/Centimeter],
      Description -> "The highest energy Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    MinAntiStokesScatteringFrequency -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinAntiStokesScatteringFrequency]],
      Pattern :> LessP[0 1/Centimeter],
      Description -> "The lowest energy anti-Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    MaxAntiStokesScatteringFrequency -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAntiStokesScatteringFrequency]],
      Pattern :> LessP[0 1/Centimeter],
      Description -> "The highest energy anti-Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    SpectralResolution -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],SpectralResolution]],
      Pattern :> GreaterP[0 1/Centimeter],
      Description -> "The smallest spectral feature size that can be reliably detected by the CCD detector under normal operating conditions.",
      Category -> "Operating Limits"
    },
    MaxDetectionSignal -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxDetectionSignal]],
      Pattern :> GreaterP[0],
      Description -> "The scattering intensity at which signal will saturate the CCD detector.",
      Category -> "Operating Limits"
    },

    (* -- CONFIGURATION -- *)

    LaserWavelength -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],LaserWavelength]],
      Pattern :> GreaterP[0],
      Description -> "The fixed wavelength of the excitation beam, which is equivilant to the Rayleigh back-scattering.",
      Category -> "Instrument Specifications"
    },
    OpticsOrientation -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],OpticsOrientation]],
      Pattern :> MicroscopeViewOrientationP,
      Description -> "The positioning of the objectives, cameras, and detectors with respect to the sample stage. In the inverted configuration all three are situated below the stage.",
      Category -> "Instrument Specifications"
    },
    WellSampling -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],WellSampling]],
      Pattern :> BooleanP,
      Description -> "Indicates if this instrument can measure multiple areas of a given well using a designated two or three dimensional motion pattern to spatially resolve the Raman response within a sample.",
      Category -> "Instrument Specifications"
    },
    OpticalImaging -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],OpticalImaging]],
      Pattern :> BooleanP,
      Description -> "Indicates if the spectrometer is also equipped with a optical imaging camera.",
      Category -> "Instrument Specifications"
    },

    (* -- OBJECTIVES -- *)

    Objectives -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Objectives]],
      Pattern :> GreaterP[0],
      Description -> "The available objective lenses which set the factor by which the image is magnified. The objectives are used for focusing the excitation beam, Raman back-scattering, and optical images.",
      Category -> "Instrument Specifications"
    }
  }
}];