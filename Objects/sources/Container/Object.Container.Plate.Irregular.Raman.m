(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container,Plate,Irregular,Raman], {
  Description->"A physical container used in Raman spectroscopy to hold tablets while they are characterized in an inverted configuration.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    WellWindowDimensions -> {
      Format -> Computable,
      Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model], WellWindowDimensions]],
      Pattern :> GreaterP[0*Milli*Meter],
      Description -> "For each member of Positions, the diameter of the opening at the bottom of the well through which the sample may be observed.",
      Category -> "Container Specifications"
    }
  }
}];