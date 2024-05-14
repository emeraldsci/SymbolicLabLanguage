(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Reactor, Microwave], {
  Description -> "A model of microwave reactor instrument which uses microwave heating to perform fixed or variable temperature reactions.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {

    MaxPower -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxPower]],
      Pattern :> GreaterP[0 Watt],
      Description -> "The highest achievable microwave radiation power output.",
      Category -> "Operating Limits"
    },
    VentGas -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VentGas]],
      Pattern:>GasP,
      Description -> "The gas used to purge the microwave heating cavity during cooling, depressurization, and venting.",
      Category -> "Instrument Specifications"
    },
    TemplateDatabaseFile -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The database file template which is modified with new methods and batches.",
      Category -> "General",
      Developer -> True
    }
  }
}];
