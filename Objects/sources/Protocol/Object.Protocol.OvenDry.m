(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, OvenDry], {
  Description -> "A protocol that dries glassware or samples in an oven in order to remove water or pyrogens, and then cools the glassware or samples in a desiccator.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
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
    RemainingDesiccatorTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Minute],
      Units -> Minute,
      Description -> "The length of time required for the samples to be cooled in the desiccator for DesiccatorTime after being removed from the oven.",
      Category -> "Desiccator Cooling",
      Developer -> True
    },
    DesiccatorCompletionTime -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The earliest time at which the samples may be removed from the desiccator after being removed from the oven.",
      Category -> "Desiccator Cooling",
      Developer -> True
    },
    Gloves -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item, Glove], Object[Item, Glove]],
      Description -> "Gloves used to protect operators' hands from the high temperature of the oven and hot objects.",
      Category -> "General",
      Developer -> True
    },
    GloveSize -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> GloveSizeP,
      Description -> "The sizes of gloves worn by the operator.",
      Category -> "General",
      Developer -> True
    },
    Desiccant -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "A hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
      Category -> "Desiccator Cooling",
      Developer -> True
    },
    DesiccantReplaced -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the desiccant was replaced with a new sample because the original sample was exhausted.",
      Category -> "Desiccator Cooling",
      Developer -> True
    },
    DesiccantAmount -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 Gram], GreaterEqualP[0 Milliliter]],
      Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
      Category -> "Desiccator Cooling",
      Developer -> True
    },
    DesiccantContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "The container that holds the desiccant in the desiccator to dry the exposed sample by absorbing water molecules from the sample through the shared atmosphere around the sample.",
      Category -> "Desiccator Cooling",
      Developer -> True
    },
    DesiccantTransferUnitOperation -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "Transfer unit operation that contains the instructions for transferring Desiccant to DesiccantContainer.",
      Category -> "Desiccator Cooling",
      Developer -> True
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
    SampleTransferUnitOperations -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "Transfer unit operation or operations that contain the instructions for transferring SamplesIn to compatible containers.",
      Category -> "General",
      Developer -> True
    },
    SampleTransfers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol, ManualSamplePreparation],
        Object[Protocol, RoboticSamplePreparation],
        Object[Notebook, Script]
      ],
      Description -> "A sample preparation protocol or protocols used to transfer SamplesIn to compatible containers.",
      Category -> "General"
    },
    OvenActualTemperature -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Data][Protocol],
      Description -> "A field used to record the actual temperature of the heat block while the instrument is incubating the sample.",
      Category -> "Oven Drying",
      Developer -> True
    }
  }
}];