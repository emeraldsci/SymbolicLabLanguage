(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Physics, ExtinctionCoefficients], {
  Description -> "Extinction coefficients for an oligomer set. Denotes how strongly each monomer or a pair of monomers absorbs a particular wavelength of light per sample path length.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    (* --- Model Information --- *)
    OligomerPhysics -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Physics, Oligomer][ExtinctionCoefficients],
      Description -> "The physical model containing parameters for the oligomer that this extinction coefficient information is associated with.",
      Category -> "Model Information"
    },
    (* --- Physical Properties --- *)
    Wavelengths -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 * Nanometer],
      Units -> Nanometer,
      Description -> "The source wavelengths employed in determining the extinction coefficients of this oligomer set.",
      Category -> "Physical Properties"
    },
    MolarExtinctions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{_String, GreaterEqualP[0*Liter/Centimeter/Mole]}..},
      Description -> "For each member of Wavelengths, the extinction coefficients, in the form: {{Oligomer Subset,Molar Extinction}..}.",
      Category -> "Physical Properties",
      IndexMatching -> Wavelengths
    },
    HyperchromicityCorrections -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {Rule[_String,GreaterEqualP[0.0]]..},
      Description -> "For each member of Wavelengths, the correction factor to the extinction coefficient for each fraction of the duplex sequence of the given base pair, in the form: {Base Pair->Correction Factor..}.",
      Category -> "Physical Properties",
      IndexMatching -> Wavelengths
    }
  }
}];
