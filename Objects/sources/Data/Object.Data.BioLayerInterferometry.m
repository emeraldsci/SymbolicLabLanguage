(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, BioLayerInterferometry], {
  Description -> "The data generated from bio-layer interferometry experiment showing the change in probe bio-layer thickness as a function of time and the solution it is immersed in.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    DataType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[Kinetics, Quantitation, AssayDevelopment, EpitopeBinning],
      Description -> "The type of experiment from which the data was generated.",
      Category -> "General"
    },

    (* -- General information -- *)

    Temperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 * Kelvin],
      Units -> Celsius,
      Description -> "The temperature of the assay plate during the sample measurement.",
      Category-> "Method Information"
    },
    NumberOfRepeats -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0],
      Description -> "The number of identical measurement sequences performed on each input sample.",
      Category-> "Method Information"
    },
    BioProbe -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item, BLIProbe],Object[Item, BLIProbe]],
      Description->"The type of BLI probe used to measure the data gathered in this experiment.",
      Category -> "General"
    },

    WellData -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for each well: {\"Time\", \"Bio-Layer Thickness\"}. The information about the well position is contained in the index matched WellInformation field.",
      Category -> "Experimental Results"
    },

    WellInformation -> {
      Format -> Multiple,
      Class -> {
        Integer,
        Integer,
        Integer,
        Integer,
        Expression,
        Link
      },
      Pattern :> {
        GreaterP[0],
        GreaterP[0],
        GreaterP[0],
        GreaterP[0],
        BLIPrimitiveNameP,
        _Link
      },
      Units -> {None, None, None, None, None, None},
      Relation -> {Null, Null, Null, Null, Null, (Object[Sample]|Model[Sample])},
      Description -> "A table containing information about the well for which the data is contained in WellData.",
      Headers -> {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"},
      Category -> "Experimental Results"
    },

    MeasuredWellPositions -> {
      Format -> Multiple,
      Class -> {
        Integer,
        Integer,
        Integer,
        Integer,
        Expression,
        Link
      },
      Pattern :> {
        GreaterP[0],
        GreaterP[0],
        GreaterP[0],
        GreaterP[0],
        BLIPrimitiveNameP,
        _Link
      },
      Units -> {None, None, None, None, None, None},
      Relation -> {Null, Null, Null, Null, Null, (Object[Sample])},
      Description -> "A table with position of the wells from which the quantitation, association, or competition data was generated. This field is index matched to the relevant data fields.",
      Headers -> {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"},
      Category -> "Experimental Results"
    },

    (* -- probe condition fields -- *)

    LoadedSpecies -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The species which were loaded onto the probe during LoadSurface steps prior to the sample measurement.",
      Category -> "General"
    },
    ActivationSpecies -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The solutions used to activate the probe surface prior to loading with the LoadedSpecies.",
      Category -> "General"
    },
    QuenchSpecies -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The solutions used to passivate un-reacted surface sites after loading the probe surface with the LoadedSpecies.",
      Category -> "General"
    },

    (* -- Kinetics specific data fields -- *)

    KineticsAssociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for association steps of each dilution in the form: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    KineticsAssociationBaselines -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for reference wells measured in parallel with the samples wells during the association step.",
      Category -> "Experimental Results"
    },
    KineticsDissociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for dissociation steps of each dilution in the form: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    KineticsDissociationBaselines -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for reference wells measured in parallel with the samples wells during the association step.",
      Category -> "Experimental Results"
    },
    KineticsDilutionConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 Nano Molar], GreaterEqualP[0* Gram/Liter],GreaterEqualP[0*Milligram/Milliliter]],
      Description -> "The concentration of each dilution used in the kinetic assay of this sample.",
      Category -> "General"
    },

    (* -- Quantitation specific data fields -- *)

    QuantitationAnalyteAssociation -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for the association of the analyte to the probe surface: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "General"
    },
    QuantitationAnalyteDetection -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for the detection step following the association of the analyte to the probe surface: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    QuantitationAnalyteDetectionBaseline -> {
      Format -> Single,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "Data for the non-sample well measured in parallel with the analyte detection step.",
      Category -> "Experimental Results"
    },
    QuantitationStandardAssociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for the association of the standard to the probe surface: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    QuantitationStandardDetection -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for the detection step following the association of the standard to the probe surface: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    QuantitationStandardDetectionBaselines -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "Data for the non sample well measured in parallel with the standard detection step. The baselines are matched to the QuantitationStandardDetection.",
      Category -> "Experimental Results"
    },
    QuantitationStandardDilutionConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> (GreaterEqualP[0 Milligram/Milliliter]|GreaterEqualP[0 Nanomolar]),
      Units -> None,
      Description -> "The concentration of each dilution in the quantitation standard curve.",
      Category -> "General"
    },

    (* -- binning specific fields -- *)

    CompetingSolutions -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Sample],
      Description -> "The species that the analyte-loaded probe were immersed in to assess competitive binding.",
      Category -> "General"
    },
    CompetitionData -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for each competition step: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    BinningType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[PreMix, Tandem, Sandwich],
      Description -> "The type of binning assay from which the data was generated.",
      Category -> "General"
    },

    (* development specific fields *)
    (*note that here each sample may get several data objects out since the measurements are done on the same samples*)
    DevelopmentAssociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for each competition step: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    DevelopmentDissociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for each competition step: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    (*we might also have dilutions, in which case use these fields*)
    DevelopmentDilutionsAssociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for association steps of each dilution in the form: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    DevelopmentDilutionsDissociation -> {
      Format -> Multiple,
      Class -> QuantityArray,
      Pattern :> QuantityCoordinatesP[{Second,Nanometer}],
      Units -> {Second, Nanometer},
      Description -> "The raw data for dissociation steps of each dilution in the form: {\"Time\", \"Bio-Layer Thickness\"}.",
      Category -> "Experimental Results"
    },
    DevelopmentDilutionConcentrations -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 Nano Molar], GreaterEqualP[0* Gram/Liter],GreaterEqualP[0*Milligram/Milliliter]],
      Description -> "The concentration of each dilution used in the assay of this sample.",
      Category -> "General"
    },
    KineticsAnalysis -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "A list of kinetics analysis conducted on this data.",
      Category -> "Analysis & Reports"
    },
    QuantitationAnalysis -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "A list of quantitation analysis conducted on this data.",
      Category -> "Analysis & Reports"
    },
    BinningAnalysis -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "The binning analysis of this data.",
      Category -> "Analysis & Reports"
    },
    DetectionLimitAnalysis -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Analysis][Reference],
      Description -> "A list of detection limit analysis conducted on this data.",
      Category -> "Analysis & Reports"
    }
  }
}];