(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-07-30 *)

DefineObjectType[Object[Qualification,pHTitrator], {
  Description->"A protocol that verifies the functionality of the pHTitrator target.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    TitrationContainerCap->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item, Cap],
        Object[Item, Cap]
      ],
      Description -> "The cap that is used to assemble pH probe, overhead stir rod and tube of pHTitrator during qualification using the water sample.",
      Category->"General"
    },
    pHMeter -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument, pHMeter],Model[Instrument, pHMeter]],
      Description -> "The instrument used to measure the pH of the water sample in qualification.",
      Category -> "pH Measurement"
    },
    Probe -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Part, pHProbe],Model[Part, pHProbe]],
      Description -> "The probe used to measure the pH of the water sample in qualification.",
      Category -> "pH Measurement"
    },
    WashSolution->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample]|Model[Sample],
      Description->"The sample that are used to wash the probe(s) by submerging it.",
      Category->"Cleaning"
    },
    WasteBeaker->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample]|Model[Sample],
      Description->"A vessel that contains water to dilute base and acid and will be used to catch any residual water that comes off the pH instrument as it is washed in qualification.",
      Developer->True,
      Category->"Cleaning"
    },
    TitratingAcid -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "The acid used to change the pH of the qualification water sample.",
      Category -> "General"
    },
    TitratingBase -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "The base used to change the pH of the qualification water sample.",
      Category -> "General"
    },
    TitratingSolutionPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {Object[Container], Object[Instrument], Null},
      Description -> "A list of placements used to move Titrating solution to acid and base container slot of the pHTitrator in qualification.",
      Headers -> {"Object to Place", "Destination Object","Destination Position"},
      Category -> "Injector Cleaning",
      Developer -> True
    },
    CleaningSolutionPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {Object[Container], Object[Instrument], Null},
      Description -> "A list of placements used to move cleaning solution to acid and base container slot of the pHTitrator in qualification.",
      Headers -> {"Object to Place", "Destination Object","Destination Position"},
      Category -> "Injector Cleaning",
      Developer -> True
    },
    pHMixInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Instrument]|Model[Instrument],
      Description -> "The instrument used to mix the water sample after addition of acid/base.",
      Category -> "Mixing"
    },
    pHMixImpeller -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Part,StirrerShaft],Object[Part,StirrerShaft]],
      Description -> "The impeller used in the mixer responsible for stirring the water sample in between acid/base additions.",
      Category -> "Mixing",
      Developer -> True
    },
    DataFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path of the SentData.txt and ReceivedData.txt to communicate with SevenExcellence in qualification of water sample.",
      Category -> "General",
      Developer -> True
    },
    MethodFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The folder name of ML600ToSLL.txt and SLLToML600.txt to communicate with pH Titrator in qualification of water sample.",
      Category -> "General",
      Developer -> True
    },
    CurrentpHMeterResponseTime -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The most recently response timestamp from SevenExcellence in pHTitrator qualification. The most recently response timestamp is in the format of yyyy-mm-ddThh:mm:ss.",
      Category -> "General",
      Developer ->True
    },
    CurrentpHTitratorResponseTime -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The most recently response timestamp from pH titrator when TitrationMethod is Robotic. The most recently response timestamp is in the format of yyyy-mm-dd hh:mm:ss.",
      Category -> "pH Titration",
      Developer ->True
    }
  }
}];