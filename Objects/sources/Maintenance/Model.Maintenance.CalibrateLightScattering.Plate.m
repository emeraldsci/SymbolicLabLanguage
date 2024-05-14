(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance, CalibrateLightScattering, Plate], {
  Description->"A set of parameters describing regularly performed maintenance to calibrate the scattered light intensity of a plate used in a DLSPlateReader.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    AssayContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation->Model[Container,Plate],
      Description -> "The plate used in a DLSPlateReader whose scattered light intensity is calibrated.",
      Category -> "General",
      Abstract -> True
    }

  }
}];