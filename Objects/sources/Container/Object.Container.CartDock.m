

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, CartDock], {
  Description->"A object of a cart docking station capable of charging and smartly indicating protocol status.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    MicroControllerIP -> {
      Format -> Single,
      Class -> String,
      Pattern :> IpP,
      Description -> "The IP/Web address for the Arduino that controls the status indication lights.",
      Category -> "Part Specifications",
      Abstract -> True
    },
    CartDockStatus -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> CartDockStatusP,
      Description -> "Current usage state of the Cart Docking station. Meanings are as follows: Ready (The cart has no ties to a current protocol); Danger Zone (The cart is running a protocol that is currently in Danger Zone and needs to be picked up immediately); Running (The cart is in a protocol that is running a protocol that needs be picked up); .",
      Category -> "Organizational Information",
      Abstract -> True
    },
    Occupied -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the docking station is empty or occupied.",
      Category -> "Container Specifications"
    }
  }
}];