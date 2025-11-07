(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, OvenDry], {
  Description -> "A detailed set of parameters that specifies the information of how to dry glassware or samples in an oven in order to remove water or pyrogens, and then cool the glassware or samples in a desiccator.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    SampleLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Sample],
        Model[Sample],
        Model[Container],
        Object[Container]
      ],
      Description -> "The samples that will be dried and then cooled.",
      Category -> "General",
      Migration -> SplitField
    },
    SampleString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The samples that will be dried and then cooled.",
      Category -> "General",
      Migration -> SplitField
    },
    SampleExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
      Relation -> Null,
      Description -> "The samples that will be dried and then cooled.",
      Category -> "General",
      Migration -> SplitField
    },
    SampleLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the label of the sample that is analyzed.",
      Category -> "General",
      Developer -> True,
      IndexMatching -> SampleLink
    },
    SampleContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the label of the sample's container.",
      Category -> "General",
      Developer -> True,
      IndexMatching -> SampleLink
    },
    Oven -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Instrument, Oven], Object[Instrument, Oven]],
      Description -> "The oven in which the samples are dried.",
      Category -> "Oven Drying"
    },
    OvenTemperature -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "The temperature to which the oven is set before the samples are dried.",
      Category -> "Oven Drying"
    },
    OvenTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Minute],
      Units -> Minute,
      Description -> "The minimum length of time for which the samples are kept in the oven before being moved to the desiccator.",
      Category -> "Oven Drying"
    },
    RemainingOvenTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Minute],
      Units -> Minute,
      Description -> "The length of time required for the samples to be heated in the oven for OvenTime.",
      Category -> "Oven Drying",
      Developer -> True
    },
    OvenCompletionTime -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The earliest time at which the samples may be removed from the oven after being heated.",
      Category -> "Oven Drying",
      Developer -> True
    },
    Desiccator -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Instrument, Desiccator], Object[Instrument, Desiccator]],
      Description -> "The desiccator in which the samples are cooled after being removed from the oven.",
      Category -> "Desiccator Cooling"
    },
    DesiccatorTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0*Minute],
      Units -> Minute,
      Description -> "The minimum length of time for which the samples are cooled in the desiccator after being removed from the oven.",
      Category -> "Desiccator Cooling"
    },
    OvenRampTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Minute],
      Units -> Minute,
      Description -> "The minimum length of time required for the oven to reach the desired temperature.",
      Category -> "Oven Drying"
    },
    VentingCaps -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item, Cap], Object[Item, Cap]],
      Description -> "Caps used to cover containers while samples are dried in the oven.",
      Category -> "Oven Drying",
      Developer -> True
    },
    ContainersToVent -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container]
      ],
      Description -> "The containers that will be fitted with venting caps before oven drying.",
      Category -> "Oven Drying",
      Developer -> True
    }
  }
}];