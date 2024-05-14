(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: xu.yi *)
(* :Date: 2024-02-27 *)

DefineObjectType[Object[Maintenance, FlushCapillaryArray], {
  Description->"A protocol that flushes the capillary array of fragment analyzer.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    PrimaryCapillaryFlushSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The solution that is used to flush the primary capillary.",
      Category -> "General",
      Abstract -> True
    },

    SecondaryCapillaryFlushSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The solution that is used to flush the secondary capillary.",
      Category -> "General",
      Abstract -> True
    },

    TertiaryCapillaryFlushSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample],Object[Sample]],
      Description -> "The solution that is used to flush the tertiary capillary.",
      Category -> "General",
      Abstract -> True
    },

    ConditioningLinePlaceholderRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
      Description->"The rack that holds the ConditioningLinePlaceholderContainer temporarily when not inside the Target.",
      Category->"Storage & Handling",
      Developer->True
    },

    SecondaryGelLinePlaceholderRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
      Description->"The rack that holds the SecondaryGelLinePlaceholderContainer temporarily when not inside the Target.",
      Category->"Storage & Handling",
      Developer->True
    },

    PrimaryCapillaryFlushSolutionContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Object[Container]
      ],
      Description -> "The container that holds the PrimaryCapillaryFlushSolution when flushing the capillary array.",
      Category -> "General"
    },
    PrimaryCapillaryFlushSolutionContainerRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
      Description->"The rack that holds the PrimaryCapillaryFlushSolutionContainer throughout the experiment when not inside the Target.",
      Category->"Storage & Handling",
      Developer->True
    },

    SecondaryCapillaryFlushSolutionContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Object[Container]
      ],
      Description -> "The container that holds the SecondaryCapillaryFlushSolution when flushing the capillary array.",
      Category -> "General"
    },
    SecondaryCapillaryFlushSolutionContainerRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
      Description->"The rack that holds the SecondaryCapillaryFlushSolutionContainer throughout the experiment when not inside the Target.",
      Category->"Storage & Handling",
      Developer->True
    },

    TertiaryCapillaryFlushSolutionContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Object[Container]
      ],
      Description -> "The container that holds the TertiaryCapillaryFlushSolution when flushing the capillary array.",
      Category -> "General"
    },
    TertiaryCapillaryFlushSolutionContainerRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
      Description->"The rack that holds the TertiaryCapillaryFlushSolutionContainer throughout the experiment when not inside the Target.",
      Category->"Storage & Handling",
      Developer->True
    },

    PrimaryCapillaryFlushSolutionPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the PrimaryCapillaryFlushSolutionContainer in the dedicated position inside the Target.",
      Headers -> {"PrimaryCapillaryFlushSolution", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    SecondaryCapillaryFlushSolutionPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the SecondaryCapillaryFlushSolutionContainer in the dedicated position inside the Target.",
      Headers -> {"SecondaryCapillaryFlushSolution", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    TertiaryCapillaryFlushSolutionPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the TertiaryCapillaryFlushSolutionContainer in the dedicated position inside the Target.",
      Headers -> {"TertiaryCapillaryFlushSolution", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    WasteContainerPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the WasteContainer in the dedicated position inside the Target.",
      Headers -> {"WasteContainer", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    WastePlatePlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the WastePlate in the dedicated position inside the Target.",
      Headers -> {"WastePlate", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },

    CapillaryFlushFileName->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The name of the method file containing the parameters for running the conditioning solution or specified alternative(s) through the capillaries.",
      Category->"General",
      Developer->True
    },

    WastePlatePrep -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,ManualSamplePreparation]|Object[Protocol,RoboticSamplePreparation],
      Description -> "The sample manipulation protocol executed to prepare the waste plate for flushing capillary array.",
      Category -> "General"
    }
  }
}];