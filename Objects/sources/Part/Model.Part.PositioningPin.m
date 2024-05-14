(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2023-01-10 *)

DefineObjectType[Model[Part, PositioningPin], {
    Description -> "A specialized cylindrical metal pin used to hold collection trays in place on the GL Sciences GravityRack. Each PositioningPin has a threaded outlet on the bottom for connecting to the GravityRack frame, and a cylindrical body, the top of which threads through a circular opening in the bottom of the collection tray.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        Dimensions -> {
            Format -> Single,
            Class -> {Real, Real, Real},
            Pattern :> {GreaterEqualP[0 * Meter], GreaterEqualP[0 * Meter], GreaterEqualP[0 * Meter]},
            Units -> {Meter, Meter, Meter},
            Headers -> {"X Direction (Width)", "Y Direction (Depth)", "Z Direction (Height)"},
            Description -> "The external dimensions of this model of part.",
            Category -> "Dimensions & Positions"
        },
        PinBodyLength -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Millimeter],
            Units -> Millimeter,
            Description -> "The length of the cylindrical body of the PositioningPin.",
            Category -> "Dimensions & Positions"
        }
    }
}];