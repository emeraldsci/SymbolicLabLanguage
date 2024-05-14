

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, Reactor, Microwave], {
  Description -> "A model of microwave reactor instrument which uses microwave heating to perform fixed or variable temperature reactions.",
  CreatePrivileges -> None,
  Cache -> Download,
  Fields -> {


    
    (* -- Operating Limits -- *)

    MaxPower -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Watt],
      Units -> Watt,
      Description -> "The highest achievable microwave radiation power output.",
      Category -> "Operating Limits"
    },

    (*TODO: objectify the enclosure even though it is part of the instrument. Also make sure there is a temp/RH sensor inside the box. Ask facilities.*)
    VentGas -> {
      Format -> Single,
      Class -> Expression,
      Pattern:>GasP (*Air, Nitrogen*),
      Description -> "The gas used to purge the microwave heating cavity during cooling, depressurization, and venting.",
      Category -> "Instrument Specifications"
    }
  }
}];
