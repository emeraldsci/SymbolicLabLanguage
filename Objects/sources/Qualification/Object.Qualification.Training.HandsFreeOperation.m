(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,HandsFreeOperation], {
  Description -> "A protocol that verifies an operator's ability to work in HandsFreeOperation mode with foot pedals.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    BiosafetyCabinet -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
       Model[Instrument, BiosafetyCabinet],
        Object[Instrument, BiosafetyCabinet]
      ],
      Description -> "The biosafety cabinet where the hands free operation occurs.",
      Category -> "General"
    },
    Container -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Object[Container]
      ],
      Description -> "The container used to practice scanning and moving in HandsFreeOperation.",
      Category -> "General"
    },
    BiosafetyCabinetPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container],
          Model[Container],
          Object[Sample],
          Model[Sample],
          Object[Instrument],
          Model[Instrument],
          Object[Item],
          Model[Item]
        ],
        Alternatives[
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, BiosafetyCabinet],
          Object[Container,WasteBin],
          Model[Container,WasteBin]
        ],
        Null
      },
      Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which objects are moved into the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    BiosafetyCabinetMovements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container],
          Model[Container],
          Object[Sample],
          Model[Sample]
        ],
        Alternatives[
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, BiosafetyCabinet]
        ],
        Null
      },
      Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which objects are moved within the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    BiosafetyCabinetBackMovements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container],
          Model[Container],
          Object[Sample],
          Model[Sample]
        ],
        Alternatives[
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, BiosafetyCabinet]
        ],
        Null
      },
      Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which objects are moved back to within the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    (* Developer *)
    (* Upload fields during qualification run *)
    MultipleChoiceAnswer -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "The value selected in the multiple choice tasks.",
      Category -> "User Input Tests"
    }
  }
}];