(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,PlateWasher],{
    Description->"A device to automatically wash microplates.",
    CreatePrivileges->None,
    Cache->Download,
    Fields->{

        NumberOfChannels->{
            Format->Single,
            Class->Integer,
            Pattern:>_Integer,
            Description->"Indicates how many wells the washer can dispense liquid into or aspirate from at the same time.",
            Category->"Instrument Specifications"
        },
        MixModes->{
            Format->Multiple,
            Class->Expression,
            Pattern:>MechanicalShakingP,
            Description->"The pattern that the shaking is capable of following.",
            Category->"Instrument Specifications"
        },
        MinRotationRate->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterEqualP[0 RPM],
            Units->RPM,
            Description->"Minimum speed by which the plate washer can shake the plate.",
            Category->"Operating Limits"
        },
        MaxRotationRate->{
            Format->Single,
            Class->Real,
            Pattern:>GreaterP[0 RPM],
            Units->RPM,
            Description->"Maximum speed by which the plate washer can shake the plate.",
            Category->"Operating Limits"
        },
        BufferDeckModel->{
            Format->Single,
            Class->Link,
            Pattern:>_Link,
            Relation->Model[Container,Deck],
            Description->"The model of container used to house buffers.",
            Category->"Instrument Specifications",
            Developer->True
        }
    }
}
];
