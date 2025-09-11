(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2023-01-06 *)

DefineObjectType[Model[Part,FlaskRing], {
    Description -> "A thick metal sheet with a large aperture in the center, which circumscribes the neck of a piece of glassware that is collecting fluid during an experiment on a GravityRack Instrument or while mixing with a Sonicator Instrument. Functionally, the flask ring provides stability when the glassware is too light to stand securely in a sonicator, or collection glassware piece has a round bottom, as the round bottom flasks and eggplant shaped flasks often used for organic reactions do. On the GravityRack Instrument, each flask ring also has small round slots in the corners for grasping the Support Rods that are used for positioning on the Collection Tray.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        Aperture -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Millimeter],
            Units -> Millimeter,
            Description -> "The width of the center aperture of this flask ring, through which the necks of glassware pieces are threaded during experiments.",
            Category -> "Part Specifications"
        },
        Weight-> {
            Format -> Single,
            Class -> Real,
            Pattern :> _?MassQ,
            Units-> Gram,
            Description -> "The weight of the flask ring.",
            Category -> "Part Specifications"
        },
        CompatibleMixers -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Model[Instrument, Sonicator][CompatibleSonicationAdapters],
            Description -> "Sonicators that can use this flask ring during mixing experiments.",
            Category -> "Model Information"
        }
    }
}];