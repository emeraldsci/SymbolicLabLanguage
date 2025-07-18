

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, FluorescencePolarization], {
  Description->"Measurements of intensity of a fluorescence emission at a fixed wavelength.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    ExcitationWavelengths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      Description -> "Wavelength of light used to excite the sample.",
      Category -> "General",
      Abstract -> True
    },
    EmissionWavelengths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      Description -> "The wavelengths at which fluorescence emitted from the samples is measured.",
      Category -> "General",
      Abstract -> True
    },
    DualEmissionWavelengths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Meter*Nano],
      Units -> Meter Nano,
      Description -> "The wavelengths at which fluorescence emitted from the samples is measured.",
      Category -> "General",
      Abstract -> True
    },
    FocalHeight -> {
      Format -> Single,
      Class -> Real,
      Pattern :> DistanceP,
      Units -> Meter Milli,
      Description -> "Focal height of the objective lens when the sample is measured.",
      Category -> "General"
    },
    ReadLocation -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> ReadLocationP,
      Description -> "The side of the microplate from which the readings were taken.",
      Category -> "Fluorescence Measurement"
    },
    PositioningDelay -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Second],
      Units -> Second,
      Description -> "The amount of time the system waited before taking measurements in order to allow for the sample in the well to settle after any shaking.",
      Category -> "General"
    },
    NumberOfReadings -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "The number of readings taken and averaged to form a single data point.",
      Category -> "General"
    },
    Gains -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Volt],
      Units -> Volt,
      Description -> "For each member of EmissionWavelengths, gain setting of the detector, for measurement at the emission wavelengths.",
      IndexMatching -> EmissionWavelengths,
      Category -> "General"
    },
    DualEmissionGains -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Volt],
      Units -> Volt,
      Description -> "For each member of DualEmissionWavelengths, the gain setting of the detector.",
      Category -> "General",
      IndexMatching -> DualEmissionWavelengths
    },
    NominalTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Kelvin],
      Units -> Celsius,
      Description -> "Target temperature setting for the experiment.",
      Category -> "General"
    },
    Well -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> WellP,
      Description -> "The plate well of the sample at the time of measurement.",
      Category -> "General",
      Abstract -> True
    },
    ParallelIntensities -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> UnitsP[RFU],
      Units -> RFU,
      Description -> "For each member of DualEmissionWavelengths, the measurements of fluorescence intensity oriented parallel to the horizontally polarized excitation light.",
      Category -> "Experimental Results",
      IndexMatching -> DualEmissionWavelengths,
      Abstract -> True
    },
    PerpendicularIntensities -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> UnitsP[RFU],
      Units -> RFU,
      Description -> "For each member of DualEmissionWavelengths, the measurements of fluorescence intensity oriented perpendicular to the horizontally polarized excitation light.",
      Category -> "Experimental Results",
      IndexMatching -> DualEmissionWavelengths,
      Abstract -> True
    },
    Anisotropy -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> UnitsP[AnisotropyUnit],
      Units -> AnisotropyUnit Milli,
      Description -> "For each member of DualEmissionWavelengths, the fluorescence anisotropy calculated as the difference between parallel and perpendicular emission intensities normalized by the total fluorescence intensity of the emission light (in three dimensions).",
      Category -> "Experimental Results",
      IndexMatching -> DualEmissionWavelengths,
      Abstract -> True
    },
    Polarization -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> UnitsP[PolarizationUnit],
      Units -> PolarizationUnit Milli,
      Description -> "For each member of DualEmissionWavelengths, the fluorescence polarization calculated as the difference between parallel and perpendicular emission intensities normalized by the total fluorescence intensity of the emission light (in two dimensions).",
      Category -> "Experimental Results",
      IndexMatching -> DualEmissionWavelengths,
      Abstract -> True
    },
    Temperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "Temperature inside the sample chamber at the time of acquisition.",
      Category -> "Experimental Results"
    },
    DetectorRangeExceeded -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if any of the recorded intensities maxed out the instrument's detector.",
      Category -> "Experimental Results"
    },
    InvalidValuesExcluded -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if any of the recorded intensities are below 0 RFU and have been deleted from the final result.",
      Category -> "Experimental Results"
    },
    InjectionSamples -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample][Data],
      Description -> "The samples that were injected into the well.",
      Category -> "General"
    },
    InjectionVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Liter*Micro],
      Units -> Liter Micro,
      Description -> "For each member of InjectionSamples, the volume of the samples injected into the well.",
      IndexMatching -> InjectionSamples,
      Category -> "General"
    },
    InjectionFlowRates -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*(Liter*Micro))/Second],
      Units -> (Liter Micro)/Second,
      Description ->"For each member of InjectionSamples, the flow rate at which the sample was added to the well.",
      IndexMatching -> InjectionSamples,
      Category -> "General"
    }
  }
}];
