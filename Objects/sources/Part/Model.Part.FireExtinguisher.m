(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ECLAdmin *)
(* :Date: 2022-10-04 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part,FireExtinguisher],{
  Description->"Model information for a part that is used to put out fires by smothering in inert gas or liquid.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    FireExtinguisherClass -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> FireExtinguisherClassP,
      Description -> "Classification letter of the type of material this extinguishing agent can be applied to in a fire.",
      Category -> "Part Specifications"
    },
    FireExtinguisherPurpose -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FireExtinguisherPurposeP,
      IndexMatching -> FireExtinguisherClass,
      Description -> "For each member of FireExtinguisherClass, explicitly stated material in which this extinguishing agent can be applied to in a fire.",
      Category -> "Part Specifications"
    },
    FireExtinguisherAgent -> {
      Format -> Single,
      Class -> String,
      Pattern :> FireExtinguisherAgentP,
      Description -> "The material which the extinguishing agent for this fire extinguisher is made of.",
      Category -> "Part Specifications"
    },
    FireExtinguisherSize -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kilogram],
      Units -> Kilogram,
      Description -> "Gross weight of the fire extinguisher.",
      Category -> "Part Specifications"
    },
    Color -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> FireExtinguisherColorP,
      Description -> "The color of the fire extinguisher board.",
      Category -> "Part Specifications"
    }
  }
}];