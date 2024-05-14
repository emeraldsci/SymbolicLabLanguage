(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2023-01-07 *)

DefineObjectType[Object[Part, FlaskRing], {
    Description -> "A thick metal sheet with a large aperture in the center, which circumscribes the neck of a piece of glassware that is collecting fluid during an experiment on a GravityRack Instrument. Functionally, the flask ring is necessary when the collection glassware piece has a round bottom, as the round bottom flasks and eggplant shaped flasks often used for organic reactions do. Each flask ring also has small round slots in the corners for grasping the Support Rods that are used for positioning on the Collection Tray.",
    CreatePrivileges->None,
    Cache->Download,
    Fields -> {
        Aperture -> {
            Format -> Computable,
            Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Aperture]],
            Pattern :> GreaterP[0 Millimeter],
            Description -> "The width of the center aperture of this flask ring, through which the necks of glassware pieces are threaded during experiments.",
            Category -> "Part Specifications"
        },

        Dimensions -> {
            Format -> Computable,
            Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Dimensions]],
            Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
            Description -> "The external dimensions of this model of part.",
            Category -> "Dimensions & Positions"
        }
    }
}];