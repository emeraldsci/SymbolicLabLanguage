(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification,Training,WasteNeutralization],{
    Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to neutralize chemical waste.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        WasteSample -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Sample],
            Description -> "The sample model used to create the waste sample in this training qualfication.",
            Category -> "General"
        },
        WasteVolume -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0*Liter],
            Units -> Milliliter,
            Description -> "The volume of waste sample used in the waste neutralization training.",
            Category -> "General"
        },
        WasteNeutralizationSolution -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Sample],
            Description -> "The sample model used to neutralize the waste sample in this training qualification.",
            Category -> "General"
        },
        WasteNeutralizationContainer -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Container],
            Description -> "The container model used to dilute and neutralize the waste sample in this training qualification.",
            Category -> "General"
        },
        WasteNeutralizationEnvironment -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Instrument,FumeHood],
            Description -> "The fume hood instrument model in which the neutralization occurs.",
            Category -> "General"
        },
        WasteNeutralizationInstrument -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Instrument,pHMeter],
            Description -> "The pH meter model to measure ph of the waste sample before and after neutralization.",
            Category -> "General"
        },
        WasteNeutralizationProbe -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Part,pHProbe],
            Description -> "The pH probe model to use to measure ph of the waste sample before and after neutralization.",
            Category -> "General"
        },
        WasteNeutralizationSpatula -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Item,Spatula],
            Description -> "The spatula model to use during the waste neutralization.",
            Category -> "General"
        }
    }
}];
