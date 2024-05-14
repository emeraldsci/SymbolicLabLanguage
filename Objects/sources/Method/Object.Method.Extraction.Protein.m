(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, Extraction, Protein], {
  Description -> "A method specifying conditions and reagents for the extraction and isolation of protein from a cell-containing sample.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* Neutralization *)

    TargetProtein -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[ObjectP[Model[Molecule,Protein]],All],
      Description -> "The target protein that is isolated from SamplesIn during protein extraction. If isolating a specific target protein that is antigen, antibody, or his-tagged, subsequent isolation can happen via affinity column or affinity-based magnetic beads during purification. If isolating all proteins, purification can happen via liquid liquid extraction, solid phase extraction, magnetic bead separation, or precipitation.",
      Category -> "General"
    },
    LysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisSolution is incubated during the LysisSolutionEquilibrationTime before addition to the cell sample.",
      Category -> "Cell Lysis"
    },
    LysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the LysisSolution is incubated at LysisSolutionTemperature before addition to the cell sample.",
      Category -> "Cell Lysis"
    },
    SecondaryLysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the SecondaryLysisSolution is incubated during the SecondaryLysisSolutionEquilibrationTime before addition to the sample after the sample during the optional secondary lysis.",
      Category -> "Cell Lysis"
    },
    SecondaryLysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the SecondaryLysisSolution is incubated at SecondaryLysisSolutionTemperature before addition to the sample during the optional secondary lysis.",
      Category -> "Cell Lysis"
    },
   TertiaryLysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the TertiaryLysisSolution is incubated during the TertiaryLysisSolutionEquilibrationTime before addition to the sample after the sample during the optional tertiary lysis.",
      Category -> "Cell Lysis"
    },
    TertiaryLysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the TertiaryLysisSolution is incubated at TertiaryLysisSolutionTemperature before addition to the sample during the optional tertiary lysis.",
      Category -> "Cell Lysis"
    }
  }
}];