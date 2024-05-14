(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,WasteNeutralization], {
    Description -> "A qualification to test user's ability to neutralize chemical waste.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        SamplePreparationUnitOperations -> {
            Format -> Multiple,
            Class -> Expression,
            Pattern :> SamplePreparationP,
            Description -> "The unit operations used to generate the test samples.",
            Category -> "Sample Preparation"
        },
        SamplePreparationProtocol -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation],
            Description -> "The sample preparation protocol used to generate the test samples.",
            Category -> "Sample Preparation"
        },
        WasteSample -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Sample], Model[Sample]],
            Description -> "The waste sample used to be neutralized in this training qualification.",
            Category -> "General"
        },
        WasteNeutralizationSolution -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Sample], Model[Sample]],
            Description -> "The solution used to neutralize the waste sample in this training qualification.",
            Category -> "General"
        },
        WasteNeutralizationContainer -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Container], Model[Container]],
            Description -> "The container used to dilute and neutralize the waste sample in this training qualification.",
            Category -> "General"
        },
        MeasurepHProtocol -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Protocol],
            Description -> "The MeasurepH protocol for the waste sample after neutralization.",
            Category -> "General"
        },
        WasteNeutralizationEnvironment -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Instrument,FumeHood],Model[Instrument,FumeHood]],
            Description -> "The fume hood instrument object in which the neutralization occurs.",
            Category -> "General"
        },
        WasteNeutralizationInstrument -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Instrument,pHMeter],
            Description -> "The pH meter model to use to select ph meter in ExperimentMeasurepH.",
            Category -> "General"
        },
        WasteNeutralizationProbe -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Part,pHProbe],
            Description -> "The pH probe model to use to select ph probe in ExperimentMeasurepH.",
            Category -> "General"
        },
        WasteNeutralizationSpatula -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Model[Item,Spatula],Object[Item,Spatula]],
            Description -> "The spatula object to use during the waste neutralization.",
            Category -> "General"
        },
        TransferCounter -> {
            Format -> Single,
            Class -> Integer,
            Pattern :> _Integer,
            Units -> None,
            Description -> "The number of the transfer uploads executed by uploadWasteNeutralizationTransfer in the Engine.",
            Category -> "General"
        }
    }
}];
