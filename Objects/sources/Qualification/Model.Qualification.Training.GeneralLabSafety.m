(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: jihan.kim *)

DefineObjectType[Model[Qualification,Training,GeneralLabSafety], {
    Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to locate the general lab safety equipment.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        GeneralLabSafetyEquipment -> {
            Units -> None,
            Relation -> Alternatives[Model[Item],Model[Part],Model[Container],Model[Instrument]],
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Description -> "The general lab safety equipment model, which includes a chemical shower station, eyewash station, and solid and liquid waste drums, will be utilized for searching objects based on the ECL site.",
            Category -> "General"
        },
        GeneralLabSafetyEquipmentInstructions -> {
            Units -> None,
            Relation -> Null,
            Format -> Multiple,
            Class -> String,
            Pattern :> _String,
            Description -> "For each member of GeneralLabSafetyEquipment, the instruction to convey to the operator regarding how the equipment should be found and scanned.",
            Category -> "General",
            IndexMatching -> GeneralLabSafetyEquipment
        }
    }
}
]