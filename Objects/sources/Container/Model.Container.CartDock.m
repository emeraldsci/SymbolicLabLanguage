

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, CartDock], {
    Description->"A model of a cart docking station capable of charging and smartly indicating protocol status using a micro controller.",
    CreatePrivileges->None,
    Cache->Session,
        Fields -> {
            PlugRequirements -> {
                Format -> Multiple,
                Class -> {
                    PlugNumber->Integer,
                    Phases->Integer,
                    Voltage->Integer,
                    Current->Real,
                    PlugType->String
                },
                Pattern :> {
                    PlugNumber->GreaterP[0, 1],
                    Phases->GreaterP[0],
                    Voltage->RangeP[100*Volt, 480*Volt],
                    Current->GreaterP[0*Ampere],
                    PlugType->NEMADesignationP
                },
                Units -> {
                    PlugNumber -> None,
                    Phases -> None,
                    Voltage -> Volt,
                    Current -> Ampere,
                    PlugType -> None
                },
                Headers -> {
                    PlugNumber->"Number of Plugs",
                    Phases->"Phases",
                    Voltage->"Voltage",
                    Current->"Current",
                    PlugType->"Plug Type"
                },
                Description -> "All electrical requirements for plug-in parts of this model.",
                Category -> "Compatibility"
            }
        }
  }
];