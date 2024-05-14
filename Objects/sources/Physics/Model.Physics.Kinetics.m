(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, Kinetics], {
  Description->"Kinetic parameters for an oligomer set. Contains hybridization and strand exchange parameters. Some parameters are constants, while others are functions of strand properties, such as strand length.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    (* --- Model Information --- *)
    OligomerPhysics -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Physics,Oligomer][Kinetics],
      Description -> "The physical model containing parameters for the oligomer that this kinetics information is associated with.",
      Category -> "Model Information"
    },
    (* --- Physical Properties --- *)
    ForwardHybridization -> {
      Format -> Single,
      Class -> Real,
      Pattern :> UnitsP[Second/Molar],
      Units -> Second/Molar,
      Description -> "The constant rate at which the pairing of two oligomer strands occurs.",
      Category -> "Physical Properties"
    },
    StrandExchange -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "The rate at which a single-stranded oligomer pairs with a sequence-matched double-stranded oligomer as a function of toehold length.",
      Category -> "Physical Properties"
    },
    DuplexExchange -> {
      Format -> Single,
      Class -> Real,
      Pattern :> UnitsP[PerSecond],
      Units -> PerSecond,
      Description -> "The average product-formation rate for the two-step strand exchange reaction between two sequence-matched double-stranded oligomers involving the formation of an intermediate.",
      Category -> "Physical Properties"
    },
    DualToeHoldStrandExchange -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> _Function,
      Description -> "The rate at which an invading oligomer strand with a toehold binds to the toehold of a paired oligomer (one strand with a toehold and the other without) and displaces the oligomer strand without a toehold as a function of toehold length.",
      Category -> "Physical Properties"
    }
  }
}];
