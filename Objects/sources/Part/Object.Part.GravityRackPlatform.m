(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: madmarchhare *)
(* :Date: 2023-01-05 *)

DefineObjectType[Object[Part, GravityRackPlatform], {
    Description -> "A single platform that serves as a Part for a GravityRack Instrument. Such instruments normally comprise a stacked assembly of platforms, with a cartridge platform on the top which holds the extraction cartridges, collection vessel base and rack platforms in the middle (in some models; for holding glassware), and a base platform at the bottom. Some GravityRack Instruments' platforms can be detached and rearranged into different configurations to accommodate different kinds of glassware.",
    CreatePrivileges->None,
    Cache->Download,
    Fields -> {
        GravityRackPlatformType -> {
            Format -> Computable,
            Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],GravityRackPlatformType]],
            Pattern :> GravityRackPlatformTypeP,
            Description -> "Platform Type is a category for this gravity rack platform based on its function. Options include BasePlatform (the base of the gravity rack itself), CollectionVesselBasePlatform (the platform the bottoms of the collection containers rest on during the experiment, if separate from the CollectionVesselRack), CollectionVesselRack (any platform with openings or slots for different collection containers), CartridgePlatform (the platform with connectors or ports to attach extraction cartridges, usually positioned on the top). For more information about how gravity racks are arranged, see the help file for ExperimentLiquidLiquidExtraction.",
            Category -> "Part Specifications"
        }
    }
}
];