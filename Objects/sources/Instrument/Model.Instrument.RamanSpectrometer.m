

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, RamanSpectrometer], {
  Description->"A model of Raman spectrometer instrument that measures Raman scattering of a sample to determine chemical or structural characteristics from a spectroscopic fingerprint.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {

    (* -- OPTICS/LASER -- *)

    MaxPower -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Milli*Watt],
      Units -> Milli*Watt,
      Description -> "The highest achievable power of the excitation laser input at the point where it encounters the objective lens.",
      Category -> "Operating Limits"
    },
    MaxDetectionSignal -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0],
      Units ->None,
      Description -> "The scattering intensity at which signal will saturate the CCD detector.",
      Category -> "Operating Limits"
    },
    MinStokesScatteringFrequency -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "The lowest energy Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    MaxStokesScatteringFrequency -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "The highest energy Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    MinAntiStokesScatteringFrequency -> {
      Format -> Single,
      Class -> Real,
      Pattern :> LessP[0 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "The lowest energy anti-Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    MaxAntiStokesScatteringFrequency -> {
      Format -> Single,
      Class -> Real,
      Pattern :> LessP[0 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "The highest energy anti-Stokes scattering that the detector is capable of recording, reported as the Raman shift.",
      Category -> "Operating Limits"
    },
    SpectralResolution -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "The smallest spectral feature size that can be reliably detected by the CCD detector under normal operating conditions.",
      Category -> "Operating Limits"
    },

    (* -- CONFIGURATION -- *)
    LaserWavelength -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units-> Nanometer,
      Description -> "The fixed wavelength of the excitation beam, which is equivilant to the Rayleigh back-scattering.",
      Category -> "Instrument Specifications"
    },
    OpticsOrientation -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> MicroscopeViewOrientationP,
      Description -> "The positioning of the objectives, cameras, and detectors with respect to the sample stage. In the inverted configuration all three are situated below the stage.",
      Category -> "Instrument Specifications"
    },
    WellSampling -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this instrument can measure multiple areas of a given well using a designated two or three dimensional motion pattern to spatially resolve the Raman response within a sample.",
      Category -> "Instrument Specifications"
    },
    OpticalImaging -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if the spectrometer is also equipped with a optical imaging camera.",
      Category -> "Instrument Specifications"
    },
    ReferenceSpectra -> {
      Format -> Multiple,
      Class ->{Expression, Link},
      Pattern :> {MaterialP, _Link},
      Relation -> {None, Object[EmeraldCloudFile]},
      Headers -> {"Material", "Reference Spectrum Data"},
      Description -> "Reference spectra for a given well window material collected using this model spectrometer.",
      Category -> "Instrument Specifications"
    },

    (* -- OBJECTIVES -- *)

    Objectives -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "The available objective lenses which set the factor by which the image is magnified. The objectives are used for focusing the excitation beam, Raman back-scattering, and optical images.",
      Category -> "Instrument Specifications"
    }
  }
}];
