(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,InversionAndSwirling], {
  Description -> "A protocol that verifies an operator's ability to mix by inversion and swirling.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    InversionSwirlingProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,ManualSamplePreparation],
      Description -> "The ManualSamplePreparation subprotocol that asks the operator to prepare a sample in flask by inversion and a sample in tube by swirling operations. In post processing the samples out gets imaged. Once they have gone through the mixing operations such that they can be verified as the part of the qualification to ensure they are completely mixed.",
      Category -> "Sample Preparation"
    },
    SampleImagingProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,ImageSample],
      Description -> "The ImageSample subprotocol that asks the operator to image the sample containers that went through inversion and mixing.",
      Category -> "General"
    }
  }
}]