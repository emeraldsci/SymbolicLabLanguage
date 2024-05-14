(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2023-01-13 *)

DefineObjectType[Model[Item,Washer],{
    Description -> "A flat thin ring or a perforated plate used in joints or assemblies to ensure tightness, prevent leakage, or relieve friction (Merriam-Webster).",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        InnerDiameter -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Millimeter],
            Units -> Millimeter,
            Description -> "The distance across the washer's opening, passing through the center; in other words, the diameter of the open space in the middle of the washer, through which a bolt or similar part can be threaded.",
            Category -> "Part Specifications"
        }
    }
}];