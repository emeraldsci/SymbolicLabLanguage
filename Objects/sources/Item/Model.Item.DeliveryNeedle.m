(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2023-01-12 *)

DefineObjectType[Model[Item, DeliveryNeedle], {
    Description -> "A specialized plumbing fixture for a GravityRack. A DeliveryNeedle channels liquid from the Phase Separator or similar extraction cartridge, through a blunt-needle-shaped delivery tip, and out into the collection glassware. Each DeliveryNeedle has an inlet (usually LuerSlip type) that connects to the outlet of the extraction cartridge, a threaded outlet that screws into the GravityRack's CartridgePlatform, and a long, tubular delivery tip. Models of DeliveryNeedles can differ in the materials they are composed of, and whether they are designed to be a permanent fixture or a consumable.",
    CreatePrivileges -> None,
    Cache -> Session,
    Fields -> {
        DeliveryTipDimensions -> {
            Format -> Single,
            Class -> {Real, Real},
            Pattern :> {DistanceP, DistanceP},
            Units -> {Millimeter, Millimeter},
            Headers -> {"X Direction (Diameter)", "Z Direction (Length)"},
            Description -> "The diameter and length of the long, tubular tip of the delivery needle, the channel through which fluids flow before reaching the collection vessel.",
            Category -> "Dimensions & Positions"
        }
    }
}];