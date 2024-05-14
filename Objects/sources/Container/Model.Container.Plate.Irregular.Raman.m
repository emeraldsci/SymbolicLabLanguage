(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Plate,Irregular,Raman], {
  Description->"Model information for a physical container used in Raman spectroscopy to hold tablets while they are characterized in an inverted configuration.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    WellWindowDimensions -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Milli*Meter],
      Units -> Meter Milli,
      Description -> "For each member of Positions, the diameter of the opening at the bottom of the well through which the sample may be observed.",
      IndexMatching -> Positions,
      Category -> "Container Specifications"
    }
  }
}];

