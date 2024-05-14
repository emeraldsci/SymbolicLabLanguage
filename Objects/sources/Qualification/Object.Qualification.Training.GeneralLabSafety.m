(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim*)

DefineObjectType[Object[Qualification,Training,GeneralLabSafety], {
    Description -> "A protocol that verifies an operator's ability to locate the general lab safety equipment.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        GeneralLabSafetyEquipment -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Item],Object[Part],Object[Container],Object[Instrument]],
            Description -> "The general lab safety equipment, which include a chemical shower station, eyewash station, and solid and liquid waste drums, that operators will be asked to find on their ECL site.",
            Category -> "General"
        },
        GeneralLabSafetyEquipmentInstructions -> {
            Format -> Multiple,
            Class -> String,
            Pattern :> _String,
            Description -> "For each member of GeneralLabSafetyEquipment, the special information conveyed to the operator regarding how the equipment should be found and scanned.",
            Category -> "General",
            IndexMatching -> GeneralLabSafetyEquipment
        },
        ObjectsFound -> {
            Format -> Multiple,
            Class -> String,
            Pattern :> _String,
            Relation -> Null,
            Description -> "The list of safety equipment that the user found during the training.",
            Category -> "General"
        }
    }
}
]