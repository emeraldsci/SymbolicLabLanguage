(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2021-05-17 *)

DefineObjectType[Object[Part,FanFilterUnit],{
  Description->"Object information for a part that supplies clean air to an enclosure or room.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    PDU -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
      Description -> "The PDU that controls power flow to this fan filter unit.",
      Category -> "Part Specifications"
    },
    PDUIP -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[PDU]},Download[Field[PDU],IP]],
      Pattern :> IpP,
      Description -> "The IP address of the PDU that controls power flow to this fan filter unit.",
      Category -> "Part Specifications"
    },
    PDUPort -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUPart]],
      Pattern :> PDUPortP,
      Description -> "The specific PDU port to which this fan filter unit is connected.",
      Category -> "Part Specifications"
    },
    IntegratedLiquidHandler -> {
      Format-> Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Object[Instrument,LiquidHandler][IntegratedHEPAFilters],
      Description-> "The liquid handler that is connected to this fan filter unit.",
      Category-> "Integrations"
    }
  }
}];