(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, BioLayerInterferometer], {
  Description -> "A bio-layer interferometer instrument which is used to study binding of a solution phase species to a bio-functionalized fiber-optic sensor surface.",
  CreatePrivileges -> None,
  Cache -> Download,
  Fields -> {

    (* --- Instrument Specifications ---*)
    Lamp -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Part,Lamp],
      Description -> "The lamp used to generate the white-light input signal.",
      Category -> "Instrument Specifications"
    },
    ProbeCapacity -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ProbeCapacity]],
      Pattern :> GreaterP[0],
      Description -> "The number of bio-probes that can be stored within the instrument.",
      Category -> "Instrument Specifications"
    },


    (* --- Operating Limits --- *)


    MinTemperature -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
      Pattern :> GreaterP[0*Kelvin],
      Description -> "The minimum temperature to which the assay plate can be cooled.",
      Category -> "Operating Limits"
    },
    MaxTemperature -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
      Pattern :> GreaterP[0*Kelvin],
      Description -> "The maximum temperature to which the assay plate can be heated.",
      Category -> "Operating Limits"
    },
    MinShakeRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinShakeRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "The minimum rate that can be specified for the assay plate shaking.",
      Category -> "Operating Limits"
    },
    MaxShakeRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxShakeRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "The maximum rate that can be specified for assay plate shaking.",
      Category -> "Operating Limits"
    },
    MinWellVolume -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinWellVolume]],
      Pattern :> GreaterP[0*Microliter],
      Description -> "The maximum volume of solution in a well that can generate valid data.",
      Category -> "Operating Limits"
    },
    MaxWellVolume -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxWellVolume]],
      Pattern :> GreaterP[0*Microliter],
      Description -> "The minimum volume of solution in a well that can generate valid data.",
      Category -> "Operating Limits"
    },
    RecommendedWellVolume -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], RecommendedWellVolume]],
      Pattern :> GreaterP[0*Microliter],
      Description -> "The recommended volume of solution in a well recommended to generate valid data.",
      Category -> "Operating Limits"
    }
  }
}];