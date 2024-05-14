(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, BioLayerInterferometer], {
  Description -> "The model for a bio-layer interferometer instrument, which is used to study binding of a solution phase species to a bio-functionalized fiber-optic sensor surface.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* --- Instrument Specifications --- *)
    Lamp -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Part,Lamp],
      Description -> "The lamp used to generate the white-light input signal.",
      Category -> "Instrument Specifications"
    },
    ProbeCapacity -> {
      Format -> Single,
      Class -> Integer,
      Pattern :>GreaterP[0],
      Description -> "The number of bio-probes that can be stored within the instrument.",
      Category -> "Instrument Specifications"
    },
    (*Assay plate cover is taken care of as a part which occupies the platecover position, also listed in associatedaccessories*)

    (*Assay plate compatibility is handled using the footprint system, in the assay plate position.*)

    (*BLIProbe connections are taken care of using the plumbing system.*)


    (* --- Operating Limits --- *)


    MinTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "The minimum temperature to which the assay plate can be cooled.",
      Category -> "Operating Limits"
    },
    MaxTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "The maximum temperature to which the assay plate can be heated.",
      Category -> "Operating Limits"
    },
    MinShakeRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "The minimum rate that can be specified for the assay plate shaking.",
      Category -> "Operating Limits"
    },
    MaxShakeRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "The maximum rate that can be specified for assay plate shaking.",
      Category -> "Operating Limits"
    },
    MinWellVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Micro*Liter],
      Units -> Microliter,
      Description -> "The maximum volume of solution in a well that can generate valid data.",
      Category -> "Operating Limits"
    },
    MaxWellVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Micro*Liter],
      Units -> Microliter,
      Description -> "The minimum volume of solution in a well that can generate valid data.",
      Category -> "Operating Limits"
    },
    RecommendedWellVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Micro*Liter],
      Units -> Microliter,
      Description -> "The recommended volume of solution in a well recommended to generate valid data.",
      Category -> "Operating Limits"
    }
  }
}];