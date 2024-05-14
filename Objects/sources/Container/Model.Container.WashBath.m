(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
DefineObjectType[Model[Container,WashBath],
  {
    Description->"A model of a container which stores a sheet of bristles and a sample.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
      MaxSampleVolume -> {
        Format -> Single,
        Class -> Real,
        Pattern :> VolumeP,
        Units -> Milliliter,
        Description -> "The maximum volume of sample that can fit inside the wash bath when the bristle plate is also inside.",
        Category -> "Operating Limits"
      }
    }
  }
];