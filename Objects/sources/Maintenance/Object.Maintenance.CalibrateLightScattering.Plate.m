(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, CalibrateLightScattering, Plate], {
  Description->"A maintenance protocol to generate a calibration for SLS measurements on a target plate.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{

    AssayContainer->{
      Format->Single,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Container,Plate],Model[Container,Plate]],
      Description -> "The plate that the samples are assayed in and is calibrated.",
      Category->"Sample Loading",
      Abstract->True
    },
    WellCover -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[Sample]|Model[Sample]|Object[Item,PlateSeal]|Model[Item,PlateSeal],
      Description -> "The cover used for the plate to be calibrated in a DLSPlateReader.",
      Category -> "Sample Loading"
    }

  }

}];