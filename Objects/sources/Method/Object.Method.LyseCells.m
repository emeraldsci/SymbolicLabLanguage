(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, LyseCells], {
  Description->"A method specifying conditions and reagents for the disruption of cell membranes and release of cellular components from a cell-containing sample.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    (* --- GENERAL INFORMATION --- *)

    CellType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> CellTypeP,
      Description -> "The taxon of the organism or cell line from which the cell sample originates.",
      Category -> "General"
    },
    TargetCellularComponent -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[CellularComponentP, Unspecified],
      Description -> "The class of biomolecule whose purification is desired following lysis of the cell sample and any subsequent extraction operations.",
      Category -> "General"
    },
    NumberOfLysisSteps -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "The number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes.",
      Category -> "General"
    },

    (* The method object does not specify fields for aliquoting and dilution options since these should instead resolve based on experiment scale *)

    (* --- PRELYSIS PELLETING --- *)

    PreLysisPellet -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if adherent cells in the input cell sample are dissociated from their container prior to cell lysis.",
      Category -> "Pelleting"
    },
    PreLysisPelletingIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or force applied to the cell sample to facilitate separation of the cells from the solution.",
      Category -> "Pelleting"
    },
    PreLysisPelletingTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the cell sample is centrifuged at PreLysisPelletingIntensity to facilitate separation of the cells from the solution.",
      Category -> "Pelleting"
    },

    (* --- CONDITIONS FOR FIRST LYSIS STEP --- *)

    LysisSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The amount that is transferred from the input cell sample to a new container in order to lyse a portion of the cell sample.",
      Category -> "Cell Lysis"
    },
    MixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> MixTypeP|None|Null,
      Description -> "The manner in which the solutions are mixed following combination of the cell samples and LysisSolutions.",
      Category -> "Mixing"
    },
    MixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "The rate at which the samples are mixed by the LysisMixType during the LysisMixTime.",
      Category -> "Mixing"
    },
    MixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the samples are mixed by the MixType following combination of the cell samples and the LysisSolution.",
      Category -> "Mixing"
    },
    NumberOfMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "The number of times that the samples are mixed by pipetting the LysisMixVolume up and down.",
      Category -> "Mixing"
    },
    MixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples is maintained during the LysisMixTime.",
      Category -> "Mixing"
    },
    LysisTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The minimum duration for which the LysisInstrument heating or cooling the cell samples are maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents.",
      Category -> "Cell Lysis"
    },
    LysisTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples is maintained during the LysisTime, following addition of the LysisSolution and mixing.",
      Category -> "Cell Lysis"
    },

    (* --- CONDITIONS FOR SECOND LYSIS STEP --- *)

    SecondaryLysisSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution intended to effect the disruption of cell membranes (including enzymes, detergents, and chaotropics) in the protocol's second lysis step.",
      Category -> "Cell Lysis"
    },
    SecondaryMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> MixTypeP,
      Description -> "The manner in which the solutions are mixed following combination of the cell samples and SecondaryLysisSolution in the protocol's second lysis step. Null implies that no mixing occurs during the second lysis step.",
      Category -> "Mixing"
    },
    SecondaryMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "The rate at which the samples are mixed by the SecondaryLysisMixType during the SecondaryLysisMixTime in the protocol's second lysis step.",
      Category -> "Mixing"
    },
    SecondaryMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      Description -> "The duration for which the samples are mixed by the SecondaryLysisMixType following combination of the cell samples and the SecondaryLysisSolution in the protocol's second lysis step.",
      Category -> "Mixing"
    },
    SecondaryNumberOfMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "The number of times that the samples are mixed by pipetting the SecondaryLysisMixVolume up and down in the protocol's second lysis step.",
      Category -> "Mixing"
    },
    SecondaryMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and SecondaryLysisSolution is maintained during the SecondaryLysisMixTime in the protocol's second lysis step.",
      Category -> "Mixing"
    },
    SecondaryLysisTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The minimum duration for which the LysisInstrument heating or cooling the cell samples are maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in the protocol's second lysis step.",
      Category -> "Cell Lysis"
    },
    SecondaryLysisTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and SecondaryLysisSolution is maintained during the SecondaryLysisTime, following addition of the SecondaryLysisSolution and mixing in the protocol's second lysis step.",
      Category -> "Cell Lysis"
    },

    (* --- CONDITIONS FOR THIRD LYSIS STEP --- *)

    TertiaryLysisSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution intended to effect the disruption of cell membranes (including enzymes, detergents, and chaotropics) in the protocol's third lysis step.",
      Category -> "Cell Lysis"
    },
    TertiaryMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> MixTypeP,
      Description -> "The manner in which the solutions are mixed following combination of the cell samples and TertiaryLysisSolution in the protocol's third lysis step. Null implies that no mixing occurs during the third lysis step.",
      Category -> "Mixing"
    },
    TertiaryMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "The rate at which the samples are mixed by the TertiaryLysisMixType during the TertiaryLysisMixTime in the protocol's third lysis step.",
      Category -> "Mixing"
    },
    TertiaryMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      Description -> "The duration for which the samples are mixed by the TertiaryLysisMixType following combination of the cell samples and the TertiaryLysisSolution in the protocol's third lysis step.",
      Category -> "Mixing"
    },
    TertiaryNumberOfMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "The number of times that the samples are mixed by pipetting the TertiaryLysisMixVolume up and down in the protocol's third lysis step.",
      Category -> "Mixing"
    },
    TertiaryMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and TertiaryLysisSolution is maintained during the TertiaryLysisMixTime in the protocol's third lysis step.",
      Category -> "Mixing"
    },
    TertiaryLysisTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The minimum duration for which the LysisInstrument heating or cooling the cell samples are maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in the protocol's third lysis step.",
      Category -> "Cell Lysis"
    },
    TertiaryLysisTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisInstrument heating or cooling the cell samples and TertiaryLysisSolution is maintained during the TertiaryLysisTime, following addition of the TertiaryLysisSolution and mixing in the protocol's third lysis step.",
      Category -> "Cell Lysis"
    },
    ClarifyLysate -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
      Category -> "Centrifugation"
    },
    ClarifyLysateIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or force applied to the lysate to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
      Category -> "Centrifugation"
    },
    ClarifyLysateTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the lysate is centrifuged at ClarifyLysateIntensity to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
      Category -> "Centrifugation"
    }
  }
}];