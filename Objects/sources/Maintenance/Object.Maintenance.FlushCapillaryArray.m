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
    DisplayedPrimaryCapillaryFlushSolutionVolume->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The PrimaryCapillaryFlushSolutionVolume, as a string, as displayed to the operator in the procedure.",
      Category -> "General",
      Developer->True
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
    DisplayedSecondaryCapillaryFlushSolutionVolume->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The SecondaryCapillaryFlushSolutionVolume, as a string, as displayed to the operator in the procedure.",
      Category -> "General",
      Developer->True
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
    DisplayedTertiaryCapillaryFlushSolutionVolume->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The TertiaryCapillaryFlushSolutionVolume, as a string, as displayed to the operator in the procedure.",
      Category -> "General",
      Developer->True
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
    PrimaryGelLinePlaceholderRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
      Description->"The rack that holds the PrimaryGelLinePlaceholderContainer temporarily when not inside the Target.",
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
    ConditioningLinePlaceholderPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the ConditioningLinePlaceholderContainer in the dedicated position inside the Instrument.",
      Headers -> {"ConditioningLinerPlaceholderContainer", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    PrimaryGelLinePlaceholderPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the PrimaryGelLinePlaceholderContainer in the dedicated position inside the Instrument.",
      Headers -> {"PrimaryGelLinePlaceholderContainer", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    SecondaryGelLinePlaceholderPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the SecondaryGelLinePlaceholderContainer in the dedicated position inside the Instrument.",
      Headers -> {"SecondaryGelLinePlaceholderContainer", "Instrument", "Instrument Position"},
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
    PrimaryWastePlatePlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the PrimaryWastePlate in the dedicated position inside the Target.",
      Headers -> {"WastePlate", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    SecondaryWastePlatePlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the SecondaryWastePlate in the dedicated position inside the Target.",
      Headers -> {"WastePlate", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    TertiaryWastePlatePlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the TertiaryWastePlate in the dedicated position inside the Target.",
      Headers -> {"WastePlate", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    SoakSolutionPlatePlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the SoakSolutionPlate in the dedicated position inside the Target.",
      Headers -> {"SoakSolutionPlate", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },
    RunningBufferPlatePlaceholderPlacement -> {
      Format -> Single,
      Class -> {Link, Link, String},
      Pattern :> {_Link,_Link, _String},
      Relation -> {Object[Container],Object[Instrument], Null},
      Description -> "The placement used to place the RunningBufferPlatePlaceholder in the dedicated position inside the Target.",
      Headers -> {"RunningBufferPlatePlaceholder", "Instrument", "Instrument Position"},
      Category -> "Placements",
      Developer -> True
    },

    CapillaryFlushFileNames->{
      Format->Multiple,
      Class->String,
      Pattern:>_String,
      Description->"The name of the method file containing the parameters for running the conditioning solution or specified alternative(s) through the capillaries.",
      Category->"General",
      Developer->True
    },
    CapillaryFlushIndex ->{
      Format->Multiple,
      Class->Integer,
      Pattern:>RangeP[1,3],
      Description->"For each member of CapillaryFlushFileNames, indicates the order of the flush to be performed.",
      Category->"General",
      Developer->True
    },
    SoakSolutionPlatePrep -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol,ManualSamplePreparation],
        Object[Protocol,RoboticSamplePreparation],
        Object[Notebook, Script]
      ],
      Description -> "The sample manipulation protocol executed to prepare the soak solution plate for flushing capillary array.",
      Category -> "General"
    },
    SoakSolutionPlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Plate]|Model[Container,Plate],
      Description -> "The plate that is used to contain the solution the capillaries are soaked in prior to flushing.",
      Category -> "General"
    },
    WastePlatePrep -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol,ManualSamplePreparation],
        Object[Protocol,RoboticSamplePreparation],
        Object[Notebook, Script]
      ],
      Description -> "The sample manipulation protocol executed to prepare the waste plate for flushing capillary array.",
      Category -> "General"
    },
    PrimaryWastePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Plate]|Model[Container,Plate],
      Description -> "The plate that is used to contain the waste from the first method of the capillary flush run.",
      Category -> "General"
    },
    SecondaryWastePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Plate]|Model[Container,Plate],
      Description -> "The plate that is used to contain the waste from the second method of the capillary flush run.",
      Category -> "General"
    },
    TertiaryWastePlate -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Plate]|Model[Container,Plate],
      Description -> "The plate that is used to contain the waste from the third method of the capillary flush run.",
      Category -> "General"
    },
    
    CloggedChannels ->{
      Format->Multiple,
      Class->String,
      Pattern:>WellP,
      Description->"The list of channels that are clogged based on the inspection of the contents of the WastePlate after the maintenance is performed.",
      Category->"General",
      Developer->True
    }
  }
}];