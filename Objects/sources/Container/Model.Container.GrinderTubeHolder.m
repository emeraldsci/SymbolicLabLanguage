(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, GrinderTubeHolder], {
    Description -> "The model of a container used in some models of grinders to securely position the sample tubes during the grinding process.",
    CreatePrivileges->None,
    Cache -> Session,
    Fields -> {
        SupportedInstruments -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Instrument][AssociatedAccessories,1],
            Description -> "A list of instruments for which this model is an accompanying accessory.",
            Category -> "Qualifications & Maintenance"
        }
    }
}];