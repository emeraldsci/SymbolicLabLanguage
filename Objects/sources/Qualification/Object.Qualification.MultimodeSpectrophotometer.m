(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,MultimodeSpectrophotometer], {
  Description->"A protocol that verifies the functionality of the multimode spectrophotometer target.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    SamplePreparationProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
      Description -> "The sample manipulation protocol used to generate the test samples.",
      Category -> "Sample Preparation"
    },
    (*ExperimentThermalShift qualification protocol*)
    ThermalShiftProtocol-> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,ThermalShift],
      Description -> "The thermal shift protocol used to interrogate multimode spectrophotometer performance.",
      Category -> "General"
    }
    (* TODO will add DLS protocol here when ExperimentDLS is added *)
  }
}];