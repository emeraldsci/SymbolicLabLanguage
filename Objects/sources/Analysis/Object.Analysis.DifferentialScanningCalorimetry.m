(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, DifferentialScanningCalorimetry], {
    (*Past tense*)
    Description->"Analysis that determined the thermodynamic parameters associated with a differential scanning calorimetry experiment. Examples of thermodynamic parameters include melting temperature and onset temperature of melting.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
        Protocol -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Protocol,DifferentialScanningCalorimetry],
            Description -> "The experimental protocol that generated the data analyzed in this object.",
            Category -> "General"
        },
        PeaksAnalyses -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Analysis,Peaks],
            Description -> "The peaks analysis object that was created during the differential scanning calorimetry analysis.",
            Category -> "Analysis & Reports"
        },
        MeltingTemperatures -> {
            Format -> Multiple,
            Class -> Real,
            Pattern :> GreaterP[0 Celsius],
            Units -> Celsius,
            Description -> "The list of melting temperatures that occur in the sample. Multiple melting points can be observed when the sample has multiple analytes or when an analyte contains components with different binding energies.",
            Category -> "Analysis & Reports"
        },
        OnsetTemperature -> {
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterP[0 Celsius],
            Units -> Celsius,
            Description -> "The temperature at which the melting behavior begins to be observable in the differential enthalpy scan.",
            Category -> "Analysis & Reports"
        },
        MeltingDifferentialEnthalpies -> {
            Format -> Multiple,
            Class -> Real,
            Pattern :> UnitsP[KilocaloriesThermochemical/Celsius],
            Units -> KilocaloriesThermochemical/Celsius,
            Description -> "For each member of MeltingTemperatures, we store the differential enthalpy value at which melting is observed.",
            Category -> "Analysis & Reports",
            IndexMatching -> MeltingTemperatures
        },
        OnsetDifferentialEnthalpy -> {
            Format -> Single,
            Class -> Real,
            Pattern :> UnitsP[KilocaloriesThermochemical/Celsius],
            Units -> KilocaloriesThermochemical/Celsius,
            Description -> "The differential enthalpy value that corresponds with the temperature at which the onset of melting is observed.",
            Category -> "Analysis & Reports"
        }
    }
}];
