(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2022-11-26 *)

DefineObjectType[Model[Instrument,GravityRack], {
    Description -> "A specialized two-tier rack used for gravity flow extractions, which may be liquid-liquid, solid-liquid or solid phase extractions. The top tier of a gravity rack consists of a platform with rows of connectors for extraction cartridge outlets, possibly connected underneath to tubular delivery chips to channel outgoing fluids. The bottom tier of a gravity rack consists of a rack with suitable positions for some type of collection container for fluids from an extraction cartridge. Some styles of gravity racks comprise a top (cartridge) tier that connects to any of several interchangeable bottom (collection) tiers. Finally, a gravity rack may have one or more platforms that are movable along the Z dimension, so the standard configuration is defined such that the highest possible Position MaxHeight is achieved.",
    CreatePrivileges->None,
    Cache -> Session,
    Fields -> {

        (* --- Operating Limits --- *)
        (*Min Collection Volume*)
        MinCollectionVolume -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Milliliter],
            Units -> Milliliter,
            Description -> "Indicates the minimum volume of collection container that can theoretically fit in the collection rack Positions (based on their Dimensions) of this gravity rack during experiments. For example, if the smallest container that can be supported by the collection rack of this gravity rack is sized 1 mL, then this field is set to 1 Milliliter.",
            Category -> "Operating Limits"
        },

        (*Max Collection Volume*)
        MaxCollectionVolume -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Milliliter],
            Units -> Milliliter,
            Description -> "Indicates the maximum volume of collection container that can theoretically fit in the collection rack Positions (based on their Dimensions) of this gravity rack during experiments. For example, if the largest container that can be supported by the collection rack of this gravity rack is sized 15 mL, then this field is set to 15 Milliliter.",
            Category -> "Operating Limits"
        },

        (* --- Instrument Specifications --- *)

        (*Collection Rack Attached*)
        CollectionRackAttached -> {
            Format -> Single,
            Class -> Boolean,
            Pattern :> BooleanP,
            Description -> "Indicates whether this Gravity Rack has its associated collection rack permanently attached, or is always maintained with the same collection rack attached. For a Gravity Rack with interchangeable collection racks, this value will be False.",
            Category -> "Instrument Specifications"
        },

        (*Platforms*)
        Platforms -> {
            Format -> Multiple,
            Class -> {Expression,Link},
            Pattern :> {GravityRackPlatformTypeP,
                LinkP[Model[Part,GravityRackPlatform]]|Null},
            Relation -> {Null,Model[Part,GravityRackPlatform]},
            Headers -> {"Platform Type","Part Model"},
            Description -> "A list of the types of the platforms (horizontal board shaped pieces sitting parallel to the floor, stacked on top of one of each other), according to their standard arrangement in space from bottom to top, in the form of {{Platform Type, Model (if relevant)}..}. For Platform Type, options include BasePlatform (the base of the gravity rack itself), CollectionVesselBasePlatform (the platform the bottoms of the collection containers rest on during the experiment, if separate from the CollectionVesselRack), CollectionVesselRack (any platform with openings or slots for different collection containers), CartridgePlatform (the platform with connectors or ports to attach extraction cartridges, usually positioned on the top).",
            Category -> "Instrument Specifications"
        }
    }
}
];