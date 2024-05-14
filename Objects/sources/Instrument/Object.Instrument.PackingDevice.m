(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PackingDevice], {
  Description -> "An instrument for packing finely-ground powders inside a melting point capillary tube before measuring melting point by a melting point apparatus",
  CreatePrivileges -> None,
  Cache -> Download,
  Fields -> {
    NumberOfCapillaries -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NumberOfCapillaries]],
      Pattern :> GreaterEqualP[0,1],
      Description -> "Number of capillary slots that the device has for simultaneous packing of melting point capillaries.",
      Category -> "Instrument Specifications"
    },
    HeightCheckTool -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container, Rack],
      Description -> "A tool to measure the approximate height of the sample inside a melting point capillary tube after packing the sample into the capillary by this packing device.",
      Category -> "Part Specifications"
    }
  }
}]