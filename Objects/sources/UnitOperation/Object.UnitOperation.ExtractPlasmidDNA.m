(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,ExtractPlasmidDNA],{
  Description -> "A detailed set of parameters that specifies an ExtractPlasmidDNA step within a larger protocol.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* --- SAMPLES AND SAMPLE LABELS --- *)

    SampleLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Sample],
        Model[Sample],
        Object[Container],
        Model[Container]
      ],
      Description -> "The cell samples whose membranes are to be ruptured.",
      Category -> "General",
      Migration -> SplitField
    },
    SampleString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "The cell samples whose membranes are to be ruptured.",
      Category -> "General",
      Migration -> SplitField
    },
    SampleLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
      IndexMatching -> SampleLink,
      Category -> "General"
    },
    SampleContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
      IndexMatching -> SampleLink,
      Category -> "General"
    },

    (* --- GENERAL OPTIONS --- *)

    MethodLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Method, Extraction, PlasmidDNA],
      Description->"For each member of SampleLink, the set of reagents and recommended operating conditions which are used to lyse the cell sample and to perform subsequent extraction unit operations. Custom indicates that all reagents and conditions are individually selected by the user. Oftentimes, these can come from kit manufacturer recommendations.",
      Category -> "General",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MethodExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Custom,
      Description->"For each member of SampleLink, the set of reagents and recommended operating conditions which are used to lyse the cell sample and to perform subsequent extraction unit operations. Custom indicates that all reagents and conditions are individually selected by the user. Oftentimes, these can come from kit manufacturer recommendations.",
      Category -> "General",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    ContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container into which the output sample resulting from the protocol is transferred.",
      Category->"General",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    ContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container into which the output sample resulting from the protocol is transferred.",
      Category->"General",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    ContainerOutWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description->"For each member of SampleLink, the well of the container into which the output sample resulting from the protocol is transferred.",
      Category -> "General",
      IndexMatching -> SampleLink
    },

    IndexedContainerOut -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer, ObjectP[{Object[Container],Model[Container]}]},
      Description->"For each member of SampleLink, the index and container of the sample determined from the ContainerOut option.",
      Category -> "General",
      IndexMatching -> SampleLink
    },

    ExtractedPlasmidDNALabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description->"For each member of SampleLink, a user defined word or phrase used to identify the sample that contains the extracted plasmid DNA sample, for use in downstream unit operations.",
      Category->"General",
      IndexMatching -> SampleLink
    },

    ExtractedPlasmidDNAContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description->"For each member of SampleLink, a user defined word or phrase used to identify the container that contains the extracted plasmid DNA sample, for use in downstream unit operations.",
      Category->"General",
      IndexMatching -> SampleLink
    },

    RoboticInstrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument, LiquidHandler],Model[Instrument, LiquidHandler]],
      Description->"The robotic liquid handler used (along with integrated instrumentation for heating, mixing, and other functions) to manipulate the cell sample in order to extract and purify targeted cellular components.",
      Category->"General"
    },

    (* --- LYSIS SHARED OPTIONS --- *)

    Lyse -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the input sample is lysed, breaking the cells' plasma membranes chemically and releasing the cell components into the chosen solution, creating a lysate to extract the plasmid DNA from. An input of live cells must be lysed before neutralization and purification. An input of lysate will not be lysed again before neutralization and purification.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    CellType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> CellTypeP,
      Description -> "For each member of SampleLink, the taxon of the organism or cell line from which the cell sample originates.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    CultureAdhesion -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Suspension, Adherent],
      Description -> "For each member of SampleLink, the manner in which the cell sample physically interacts with its container prior to lysis. Options include Adherent and Suspension.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    Dissociate -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if adherent cells in the input cell sample are dissociated from their container prior to cell lysis.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    NumberOfLysisSteps -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the cell sample is subjected to a unique set of conditions for disruption of the cell membranes.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    NumberOfLysisReplicates -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of wells into which the cell sample is aliquoted prior to the lysis experiment and subsequent unit operations, including extraction of cellular components such as nucleic acids, proteins, or organelles.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TargetCellCount -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0 EmeraldCell],
      Units -> EmeraldCell,
      Description -> "For each member of SampleLink, the number of cells in the experiment prior to the addition of LysisSolution. Note that the TargetCellCount, if specified, is obtained by aliquoting rather than by cell culture.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TargetCellConcentration -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 EmeraldCell/Milliliter],
      Units -> EmeraldCell/Milliliter,
      Description -> "For each member of SampleLink, the concentration of cells in the experiment prior to the addition of LysisSolution. Note that the TargetCellConcentration, if specified, is obtained by aliquoting and dilution rather than by cell culture.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    LysisAliquot -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if any of the input cell sample is transferred to a new container prior to lysis.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

		LysisAliquotAmountReal -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of SampleLink, the volume of LysisSolution which combines with the cell samples.",
			Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		LysisAliquotAmountExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[All],
			Description -> "For each member of SampleLink, the volume of LysisSolution which combines with the cell samples.",
			IndexMatching -> SampleLink,
			Category -> "Cell Lysis",
			Migration -> SplitField
		},
    
		LysisAliquotContainerString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the container into which a portion of the cell sample is transferred prior to cell lysis.",
			Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		LysisAliquotContainerExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Integer, ObjectP[Model[Container]]},
			Description -> "For each member of SampleLink, the container into which a portion of the cell sample is transferred prior to cell lysis.",
			Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
			Migration -> SplitField
		},
		LysisAliquotContainerLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "For each member of SampleLink, the container into which a portion of the cell sample is transferred prior to cell lysis.",
			Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
			Migration -> SplitField
		},

    LysisAliquotContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container into which the cell sample is aliquoted prior to cell lysis.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisPellet -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the cell sample is centrifuged to remove unwanted solution prior to addition of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisPelletingCentrifuge -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the centrifuge used to apply centrifugal force to the cell samples at PreLysisPelletingIntensity for PreLysisPelletingTime in order to remove unwanted solution prior to addition of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisPelletingIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 GravitationalAcceleration]],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or force applied to the cell sample to facilitate separation of the cells from the solution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisPelletingTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Minute],
      Units -> Minute,
      Description -> "For each member of SampleLink, the duration for which the cell sample is centrifuged at PreLysisPelletingIntensity to facilitate separation of the cells from the solution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisSupernatantVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the supernatant that is transferred to a new container after the cell sample is pelleted prior to optional dilution and addition of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PreLysisSupernatantVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[All],
      Description -> "For each member of SampleLink, the volume of the supernatant that is transferred to a new container after the cell sample is pelleted prior to optional dilution and addition of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PreLysisSupernatantStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant isolated from the cell sample is stored upon completion of this protocol.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PreLysisSupernatantStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the supernatant isolated from the cell sample is stored upon completion of this protocol.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PreLysisSupernatantContainerString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PreLysisSupernatantContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer, ObjectP[Model[Container]]},
      Description -> "For each member of SampleLink, the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PreLysisSupernatantContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "For each member of SampleLink, the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PreLysisSupernatantContainerWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the well of the container into which the supernatant is transferred after the cell sample is pelleted by centrifugation and stored for future use.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisSupernatantLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the supernatant which is transferred to a new container following pelleting of the cell sample by centrifugation, for use in downstream unit operations.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisSupernatantContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the new container into which the supernatant is transferred to a new container following pelleting of the cell sample by centrifugation, for use in downstream unit operations.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PreLysisDilute -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the cell sample is diluted prior to cell lysis.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    PreLysisDiluent -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution with which the cell sample is diluted prior to cell lysis.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    PreLysisDilutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of PreLysisDiluent added to the cell sample (or AliqoutAmount, if a portion of the cell sample has been aliquoted to an LysisAliquotContainer) prior to addition of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    LysisSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisSolutionVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of LysisSolution to be added to the cell sample.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    LysisSolutionVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[All],
      Description -> "For each member of SampleLink, the volume of LysisSolution to be added to the cell sample.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    
    LysisMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Shake, Pipette, None],
      Description -> "For each member of SampleLink, the manner in which the sample is mixed following combination of cell sample and LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the rate at which the sample is mixed by the selected LysisMixType during the LysisMixTime.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the duration for which the sample is mixed by the selected LysisMixType following combination of the cell sample and the LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    NumberOfLysisMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the sample is mixed by pipetting the LysisMixVolume up and down following combination of the cell sample and the LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SampleLink, the volume of the cell sample and LysisSolution displaced during each mix-by-pipette mix cycle.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the LysisMixTime, which occurs immediately before the LysisTime.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    LysisMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the LysisMixTime, which occurs immediately before the LysisTime.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    
    LysisMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the device used to mix the cell sample by shaking.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the minimum duration for which the LysisIncubationInstrument is maintained at the LysisTemperature to facilitate the disruption of cell membranes and release of cellular contents.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },
    
    LysisTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the LysisIncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    LysisTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, the temperature at which the LysisIncubationInstrument is maintained during the LysisTime, following the mixing of the cell sample and LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    LysisIncubationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the device used to cool or heat the cell sample to the LysisTemperature for the duration of the LysisTime.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisSolutionVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of SecondaryLysisSolution to be added to the cell sample in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SecondaryLysisSolutionVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[All],
      Description -> "For each member of SampleLink, the volume of SecondaryLysisSolution to be added to the cell sample in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SecondaryLysisMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Shake, Pipette, None],
      Description -> "For each member of SampleLink, the manner in which the sample is mixed following combination of cell sample and SecondaryLysisSolution in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the rate at which the sample is mixed by the selected SecondaryLysisMixType during the SecondaryLysisMixTime in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the duration for which the sample is mixed by the selected SecondaryLysisMixType following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryNumberOfLysisMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the sample is mixed by pipetting the SecondaryLysisMixVolume up and down following combination of the cell sample and the SecondaryLysisSolution in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SampleLink, the volume of the cell sample and SecondaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryLysisMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SecondaryLysisMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the SecondaryLysisMixTime, which occurs immediately before the SecondaryLysisTime in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SecondaryLysisMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the device used to mix the cell sample by shaking in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the minimum duration for which the SecondaryLysisIncubationInstrument is maintained at the SecondaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    SecondaryLysisTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the SecondaryLysisIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SecondaryLysisTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, the temperature at which the SecondaryLysisIncubationInstrument is maintained during the SecondaryLysisTime, following the mixing of the cell sample and SecondaryLysisSolution in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SecondaryLysisIncubationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the device used to cool or heat the cell sample to the SecondaryLysisTemperature for the duration of the SecondaryLysisTime in an optional second lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution employed for disruption of cell membranes, including enzymes, detergents, and chaotropics in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisSolutionVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of TertiaryLysisSolution to be added to the cell sample in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    TertiaryLysisSolutionVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[All],
      Description -> "For each member of SampleLink, the volume of TertiaryLysisSolution to be added to the cell sample in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    TertiaryLysisMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Shake, Pipette, None],
      Description -> "For each member of SampleLink, the manner in which the sample is mixed following combination of cell sample and TertiaryLysisSolution in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the rate at which the sample is mixed by the selected TertiaryLysisMixType during the TertiaryLysisMixTime in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the duration for which the sample is mixed by the selected TertiaryLysisMixType following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryNumberOfLysisMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the sample is mixed by pipetting the TertiaryLysisMixVolume up and down following combination of the cell sample and the TertiaryLysisSolution in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SampleLink, the volume of the cell sample and TertiaryLysisSolution displaced during each mix-by-pipette mix cycle in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryLysisMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    TertiaryLysisMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, the temperature at which the instrument heating or cooling the cell sample is maintained during the TertiaryLysisMixTime, which occurs immediately before the TertiaryLysisTime in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    TertiaryLysisMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the device used to mix the cell sample by shaking in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the minimum duration for which the TertiaryLysisIncubationInstrument is maintained at the TertiaryLysisTemperature to facilitate the disruption of cell membranes and release of cellular contents in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    TertiaryLysisTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the TertiaryLysisIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    TertiaryLysisTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Ambient],
      Description -> "For each member of SampleLink, the temperature at which the TertiaryLysisIncubationInstrument is maintained during the TertiaryLysisTime, following the mixing of the cell sample and TertiaryLysisSolution in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    TertiaryLysisIncubationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the device used to cool or heat the cell sample to the TertiaryLysisTemperature for the duration of the TertiaryLysisTime in an optional third lysis step.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    ClarifyLysate -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the lysate is centrifuged to remove cellular debris following incubation in the presence of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    ClarifyLysateCentrifuge -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the centrifuge used to apply centrifugal force to the cell samples at ClarifyLysateIntensity for ClarifyLysateTime in order to facilitate separation of suspended, insoluble cellular debris into a solid phase at the bottom of the container.",
      Category -> "Cell Lysis"
    },

    ClarifyLysateIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 GravitationalAcceleration]],
      Description -> "For each member of SampleLink, the rotational speed or force applied to the lysate to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    ClarifyLysateTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Units -> Minute,
      Description -> "For each member of SampleLink, the duration for which the lysate is centrifuged at ClarifyLysateIntensity to facilitate separation of insoluble cellular debris from the lysate solution following incubation in the presence of LysisSolution.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    ClarifiedLysateVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of lysate transferred to a new container following clarification by centrifugation.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    ClarifiedLysateVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[All],
      Description -> "For each member of SampleLink, the volume of lysate transferred to a new container following clarification by centrifugation.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PostClarificationPelletContainerString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the container in which the lysate resulting from cell lysis is located.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PostClarificationPelletContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer, ObjectP[Model[Container]]},
      Description -> "For each member of SampleLink, the container in which the lysate resulting from cell lysis is located.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PostClarificationPelletContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "For each member of SampleLink, the container in which the lysate resulting from cell lysis is located.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PostClarificationPelletContainerWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the well of ContainerOut in which the lysate resulting from cell lysis is located.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PostClarificationPelletLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container in which the lysate sample resulting from the disruption of cell membranes is located, for use in downstream unit operations.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PostClarificationPelletContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container in which the lysate sample resulting from the disruption of cell membranes is located, for use in downstream unit operations.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    PostClarificationPelletStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the pelleted sample resulting from the centrifugation of lysate to remove cellular debris is stored upon completion of this protocol.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PostClarificationPelletStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the pelleted sample resulting from the centrifugation of lysate to remove cellular debris is stored upon completion of this protocol.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    ClarifiedLysateContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_Integer, {_String, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    ClarifiedLysateContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    ClarifiedLysateContainerWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the well of the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    ClarifiedLysateContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container into which the lysate resulting from disruption of the input sample's cell membranes and subsequent clarification by centrifugation is transferred following cell lysis and clarification.",
      Category -> "Cell Lysis",
      IndexMatching -> SampleLink
    },

    (* --- NEUTRALIZATION OPTIONS --- *)

    Neutralize -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the cell lysate, a solution containing all of the extracted cell components, will be neutralized, altering the pH of the lysate to bring it closer to neutral (pH 7) in order to renature the plasmid DNA. This keeps the plasmid DNA soluble while other components are rendered (or remain) insoluble. Then the plasmid-rich supernatant is isolated by pelleting and aspiration for further purification.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationSeparationTechnique -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "For each member of SampleLink, indicates if the the solid precipitate and liquid supernatant are to be separated by centrifugation followed by pipetting of the supernatant (Pellet), or separated by passing the solution through a filter with a pore size large enough to allow the liquid phase to pass through, but not the solid precipitate (Filter).",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationReagent -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample],Model[Sample]],
      Description -> "For each member of SampleLink, a reagent which, when added to the lysate, will alter the pH of the lysate to bring it closer to neutral (pH 7) in order to renature the plasmid DNA. This keeps the plasmid DNA soluble while other components are rendered (or remain) insoluble.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationReagentVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the NeutralizationReagent that will be added to the lysate to encourage the renaturing of plasmid DNA and the precipitation of other cellular components for removal.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationReagentTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature that the NeutralizationReagent will be incubated at for the NeutralizationReagentEquilibrationTime before being added to the lysate, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    NeutralizationReagentTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature that the NeutralizationReagent will be incubated at for the NeutralizationReagentEquilibrationTime before being added to the lysate, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NeutralizationReagentEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the minimum duration during which the NeutralizationReagent will be kept at NeutralizationReagentTemperature before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "For each member of SampleLink, the manner in which the sample is agitated following the addition of the NeutralizationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample will be placed on a shaker at the NeutralizationMixRate for NeutralizationMixTime, while Pipetting indicates that NeutralizationMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfNeutralizationMixes. None indicates that no mixing occurs before incubation.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained in order to prepare a uniform mixture prior to incubation.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    NeutralizationMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained in order to prepare a uniform mixture prior to incubation.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NeutralizationMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used agitate the sample following the addition of NeutralizationReagent, in order to prepare a uniform mixture prior to incubation.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute that the lysate and NeutralizationReagent will be shaken at in order to prepare a uniform mixture prior to the incubation time.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time that the lysate and NeutralizationReagent will be shaken for, at at the specified NeutralizationMixRate, to prepare a uniform mixture prior to the incubation time.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NumberOfNeutralizationMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Description -> "For each member of SampleLink, the number of times the lysate and NeutralizationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to the incubation time.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined lysate and NeutralizationReagent displaced during each up and down pipetting cycle in order to prepare a uniform mixture prior to incubation.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationSettlingTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the combined lysate and NeutralizationReagent are left to settle, at the specified NeutralizationSettlingTemperature, in order to encourage crashing of precipitant following any mixing.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationSettlingInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used maintain the sample temperature at NeutralizationSettlingTemperature while the sample and NeutralizationReagent are left to settle, in order to encourage crashing of precipitant following any mixing.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationSettlingTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained during NeutralizationSettlingTime in order to encourage crashing of precipitant.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    NeutralizationSettlingTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained during NeutralizationSettlingTime in order to encourage crashing of precipitant.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NeutralizationFiltrationTechnique -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> AirPressure | Centrifuge,
      Description -> "For each member of SampleLink, the type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This will be done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFiltrationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used to apply force to the sample in order to facilitate its passage through the filter. Either by applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFilter -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container, Plate, Filter],Model[Container, Plate, Filter]],
      Description -> "For each member of SampleLink, the consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample after adding incubation with the NeutralizationReagent.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationPrefilterPoreSize -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> FilterSizeP,
      Units -> Micron,
      Description -> "For each member of SampleLink, the pore size of the prefilter membrane, which is placed above NeutralizationFilter, and is designed so that molecules larger than the specified prefilter pore size should not pass through this filter.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationPrefilterMembraneMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> FilterMembraneMaterialP,
      Description -> "For each member of SampleLink, the material from which the prefilter filtration membrane, which is placed above NeutralizationFilter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationPoreSize -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> FilterSizeP,
      Units -> Micron,
      Description -> "For each member of SampleLink, the pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationMembraneMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> FilterMembraneMaterialP,
      Description -> "For each member of SampleLink, the material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with membrane material.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFilterPosition -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the desired position in the Filter in which the samples are placed for the filtering.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFilterCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFiltrationPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFiltrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the samples will be exposed to either NeutralizationFiltrationPressure or NeutralizationFiltrationCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationFilterStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the conditions under which NeutralizationFilter will be stored after the protocol is completed.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    NeutralizationFilterStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the conditions under which NeutralizationFilter will be stored after the protocol is completed.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NeutralizationPelletVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the expected volume of the pellet after pelleting by centrifugation. This value is used to calculate the distance from the bottom of the container that the pipette tip will be held during aspiration of the supernatant. This calculated distance is such that the pipette tip should be held 2mm above the top of the pellet in order to prevent aspiration of the pellet. Overestimation of NeutralizationPelletVolume will result in less buffer being aspirated while underestimation of NeutralizationPelletVolume will risk aspiration of the pellet.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationPelletInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the centrifuge that will be used to apply centrifugal force to the samples at NeutralizationPelletCentrifugeIntensity for NeutralizationPelletCentrifugeTime in order to facilitate separation by Pellet of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationPelletCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or the force that will be applied to the neutralized lysate to facilitate precipitation of insoluble cellular components out of solution.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizationPelletCentrifugeTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the neutralized lysate will be centrifuged to facilitate precipitation of insoluble cellular components out of solution.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizedSupernatantTransferVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the supernatant that will be transferred to a new container after the insoluble molecules have been pelleted at the bottom of the starting container.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizedPelletStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the pellet of cell material will be stored at the completion of this protocol.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    NeutralizedPelletStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the set of parameters that define the temperature, safety, and other environmental conditions under which the pellet of cell material will be stored at the completion of this protocol.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NeutralizedPelletLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the solid pellet isolated after after the supernatant formed during neutralization is removed. This label is for use in downstream unit operations.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },

    NeutralizedPelletContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container that will contain the solid isolated after the supernatant formed during neutralization is removed. This label is for use in downstream unit operations.",
      Category -> "Neutralization",
      IndexMatching -> SampleLink
    },


    (* --- PURIFICATION OPTION --- *)

    Purification -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ( None | (LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation) | {(LiquidLiquidExtraction | Precipitation | SolidPhaseExtraction | MagneticBeadSeparation)..} ),
      Description -> "For each member of SampleLink, indicates the number of rudimentary purification steps, which techniques each step will use, and in what order the techniques will be carried out to isolate the target cell component. There are four rudimentary purification techniques: liquid-liquid extraction, precipitation, solid phase extraction (also known as using \"spin columns\"), and magnetic bead separation. Each technique can be run up to three times each and can be run in any order (as specified by the order of the list). Additional purification steps such as these or more advanced purification steps such as HPLC, FPLC, gels, etc. can be performed on the final product using scripts which call the corresponding functions (ExperimentLiquidLiquidExtraction, ExperimentPrecipitate, ExperimentSolidPhaseExtraction, ExperimentMagneticBeadSeparation, ExperimentHPLC, ExperimentFPLC, ExperimentAgaroseGelElectrophoresis, etc.).",
      Category -> "Purification",
      IndexMatching -> SampleLink
    },

    (* --- LIQUID-LIQUID EXTRACTION OPTIONS --- *)

    LiquidLiquidExtractionTechnique -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Pipette | PhaseSeparator,
      Description -> "For each member of SampleLink, The physical separation technique that is used to separate the aqueous and organic phase of a sample after solvent addition, mixing, and settling. Pipette uses a pipette to aspirate off either the aqueous or organic layer. PhaseSeparator uses a column with a hydrophobic frit, which allows the organic phase to pass freely through the frit, but physically blocks the aqueous phase from passing through.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionDevice -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container, Plate, PhaseSeparator], Model[Container, Plate, PhaseSeparator]],
      Description -> "For each member of SampleLink, the device which is used to physically separate the aqueous and organic phases.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionSelectionStrategy -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Positive | Negative,
      Description -> "For each member of SampleLink, indicates if additional rounds of extraction are performed on the impurity phase (Positive) or the target phase (Negative). Positive selection is used when the goal is to extract the maximum amount of target analyte from the impurity phase (maximizing yield). Negative selection is used when the goal is to remove impurities that may still exist in the target phase (maximizing purity).",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    IncludeLiquidBoundary -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[BooleanP],
      Description -> "For each member of SampleLink, indicates if the boundary layer (the liquid at the boundary of the organic phase and the aqueous phase) is aspirated along with the LiquidLiquidExtractionTargetPhase (therefore potentially collecting a small amount of the impurity phase) or if the boundary layer is not aspirated along with the LiquidLiquidExtractionTargetPhase (and therefore reducing the likelihood of collecting any of the impurity phase). This option is only applicable when LiquidLiquidExtractionTechnique is set to Pipette.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionTargetPhase -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Aqueous | Organic,
      Description -> "For each member of SampleLink, indicates the phase (Organic or Aqueous) that is collected during the extraction and carried forward to further purification steps or other experiments, which is the liquid layer that contains more of the dissolved target analyte after the liquid-liquid extraction settling time has elapsed and the phases are separated.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionTargetLayer -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(Top | Bottom)..},
      Description -> "For each member of SampleLink, indicates if the target phase (containing more of the target analyte) is the top layer or the bottom layer of the separated solution.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "For each member of SampleLink, the container that the sample that is aliquotted into, before the liquid liquid extraction is performed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    LiquidLiquidExtractionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer, ObjectP[Model[Container]]},
      Description -> "For each member of SampleLink, the container that the sample that is aliquotted into, before the liquid liquid extraction is performed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    LiquidLiquidExtractionContainerWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the well of the container that the sample that is aliquotted into, before the liquid liquid extraction is performed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    AqueousSolventLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the aqueous solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase for a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    AqueousSolventExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> None,
      Description -> "For each member of SampleLink, the aqueous solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase for a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    AqueousSolventVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of aqueous solvent that is added and mixed with the sample during each extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    AqueousSolventRatio -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Description -> "For each member of SampleLink, the ratio of the sample volume to the volume of aqueous solvent that is added to the sample in a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    OrganicSolventLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the organic solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase for a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    OrganicSolventExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> None,
      Description -> "For each member of SampleLink, the organic solvent that is added to the input sample (or the target phase or impurity phase from the previous extraction round if there is more than one liquid-liquid extraction round) in order to create an organic and aqueous phase for a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    OrganicSolventVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of organic solvent that is added and mixed with the sample during each extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    OrganicSolventRatio -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0],
      Description -> "For each member of SampleLink, the ratio of the sample volume to the volume of organic solvent that is added to the sample in a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionSolventAdditions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String, {Alternatives[ObjectP[{Model[Sample], Object[Sample]}], _String]..}, None]..},
      Description -> "For each member of SampleLink, and for each extraction round of a liquid-liquid extraction, the solvent(s) that are added to the sample in order to create a biphasic solution. NOTE: If no solvent will be added for one or more of the liquid-liquid extraction rounds, then set those rounds to Null. This equates to \"None\" in ExperimentExtractPlasmidDNA.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    DemulsifierString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration->SplitField
    },
    DemulsifierLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Sample], Object[Sample]],
      Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration->SplitField
    },
    DemulsifierExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> None,
      Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration->SplitField
    },


    DemulsifierAmountReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    DemulsifierAmountExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> None,
      Description -> "For each member of SampleLink, the solution that is added to the sample mixture in order to help promote complete phase separation and avoid emulsions.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    DemulsifierAdditions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {{(None | ObjectP[{Model[Sample], Object[Sample]}])..}..},
      Description -> "For each member of SampleLink, for each extraction round, the Demulsifier that is added to the sample mixture to help promote complete phase separation and avoid emulsions.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the set temperature of the incubation device that holds the extraction container during solvent/demulsifier addition, mixing, and settling in a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    LiquidLiquidExtractionTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the set temperature of the incubation device that holds the extraction container during solvent/demulsifier addition, mixing, and settling in a liquid-liquid extraction.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfLiquidLiquidExtractions -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the liquid-liquid extraction is performed using the specified extraction parameters first on the input sample, and then using the previous extraction round's target layer or impurity layer (based on the LiquidLiquidSelectionStrategy and LiquidLiquidExtractionTargetPhase).",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the sample mixture following the addition of the AqueousSolvent/OrganicSolvent and Demulsifier (if specified).",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the sample, AqueousSolvent/OrganicSolvent, and Demulsifier (if specified) are mixed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the frequency of rotation the mixing instrument uses to mechanically incorporate the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified).",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    NumberOfLiquidLiquidExtractionMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times the sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) are mixed when LiquidLiquidExtractionMixType is set to Pipette.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SampleLink, the volume of sample, AqueousSolvent/OrganicSolvent, and demulsifier (if specified) that is mixed when LiquidLiquidExtractionMixType is set to Pipette.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionSettlingTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the sample is allowed to settle and thus allow the organic and aqueous phases to separate after the AqueousSolvent/OrganicSolvent and Demulsifier (if specified) are added and optionally mixed. If LiquidLiquidExtractionTechnique is set to PhaseSeparator, the settling time starts once the sample is loaded into the phase separator (the amount of time for the organic phase to drain through the phase separator's hydrophobic frit).",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionCentrifuge -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the sample is centrifuged to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionCentrifugeInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument], Model[Instrument]],
      Description -> "For each member of SampleLink, the centrifuge that is used to spin the samples to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0*GravitationalAcceleration], GreaterEqualP[0*RPM]],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or the force that is applied to the samples via centrifugation to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionCentrifugeTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the amount of time that the samples are centrifuged to help separate the aqueous and organic layers, after the addition of solvent/demulsifier, mixing, and setting time has elapsed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidBoundaryVolume -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[GreaterEqualP[0 Microliter]],
      Description -> "For each member of SampleLink, for each extraction round, the volume of the target phase that is either overaspirated via Pipette when IncludeLiquidBoundary is set to True (by aspirating the boundary layer along with the LiquidLiquidExtractionTargetPhase and therefore potentially collecting a small amount of the impurity phase) or underaspirated via Pipette when IncludeLiquidBoundary is set to False (by not collecting all of the target phase and therefore reducing the likelihood of collecting any of the impurity phase).",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    LiquidLiquidExtractionTransferLayer -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(Top | Bottom)..},
      Description -> "For each member of SampleLink, indicates whether the top or bottom layer is transferred from the source sample after the organic and aqueous phases are separated. If the LiquidLiquidExtractionTargetLayer matches the LiquidLiquidExtractionTransferLayer, the sample that is transferred out is the target phase. Otherwise, if LiquidLiquidExtractionTargetLayer doesn't match LiquidLiquidExtractionTransferLayer, the sample that remains in the container after the transfer is the target phase.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    ImpurityLayerStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the conditions under which the impurity layer will be stored after the protocol is completed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    ImpurityLayerStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the conditions under which the impurity layer will be stored after the protocol is completed.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    ImpurityLayerContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "For each member of SampleLink, the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    ImpurityLayerContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {_Integer, ObjectP[Model[Container]]},
      Description -> "For each member of SampleLink, the container that the separated target layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    ImpurityLayerContainerOutWell -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the well of the container that the separated impurity layer is transferred into (either via Pipette or PhaseSeparator) after the organic and aqueous phases are separated.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    ImpurityLayerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container that contains the impurity layer, for use in downstream unit operations.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },

    ImpurityLayerContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container that contains the impurity layer, for use in downstream unit operations.",
      Category -> "Liquid-liquid Extraction",
      IndexMatching -> SampleLink
    },


    (* --- PRECIPITATION OPTIONS --- *)

    PrecipitationTargetPhase -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Solid | Liquid,
      Description -> "For each member of SampleLink, indicates if the target molecules in this sample are expected to be located in the solid precipitate or liquid supernatant after separating the two phases by pelleting or filtration.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationSeparationTechnique -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "For each member of SampleLink, indicates if the the solid precipitate and liquid supernatant are to be separated by centrifugation followed by pipetting of the supernatant (Pellet), or separated by passing the solution through a filter with a pore size large enough to allow the liquid phase to pass through, but not the solid precipitate (Filter).",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationReagent -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, a reagent which, when added to the sample, will help form the precipitate and encourage it to crash out of solution so that it can be collected if it will contain the target molecules, or discarded if the target molecules will only remain in the liquid phase.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationReagentVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SampleLink, the volume of PrecipitationReagent that will be added to the sample to help form the precipitate and encourage it to crash out of solution.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationReagentTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature that the PrecipitationReagent is incubated at for the PrecipitationReagentEquilibrationTime before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationReagentTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature that the PrecipitationReagent is incubated at for the PrecipitationReagentEquilibrationTime before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationReagentEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the minimum duration for which the PrecipitationReagent will be kept at PrecipitationReagentTemperature before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "For each member of SampleLink, the manner in which the sample is agitated following the addition of PrecipitationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample will be placed on a shaker at PrecipitationMixRate for PrecipitationMixTime, while Pipette indicates that PrecipitationMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationMixes. None indicates that no mixing occurs after adding PrecipitationReagent before incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used agitate the sample following the addition of PrecipitationReagent, in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute that the sample and PrecipitationReagent will be shaken at in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained during the PrecipitationMixTime in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained during the PrecipitationMixTime in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time that the sample and PrecipitationReagent will be shaken for, at the specified PrecipitationMixRate, in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    NumberOfPrecipitationMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times the sample and PrecipitationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined sample and PrecipitationReagent that is displaced during each up and down pipetting cycle in order to prepare a uniform mixture prior to incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the combined sample and PrecipitationReagent are left to settle, at the specified PrecipitationTemperature, in order to encourage crashing of precipitant following any mixing.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used maintain the sample temperature at PrecipitationTemperature while the sample and PrecipitationReagent are left to settle, in order to encourage crashing of precipitant following any mixing.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained during the PrecipitationTime in order to encourage crashing out of precipitant.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained during the PrecipitationTime in order to encourage crashing out of precipitant.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationFiltrationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used to apply force to the sample in order to facilitate its passage through the filter. Either by applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFiltrationTechnique -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Centrifuge | AirPressure,
      Description -> "For each member of SampleLink, the type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This will be done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFilter -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container, Plate, Filter], Model[Container, Plate, Filter]],
      Description -> "For each member of SampleLink, the consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample, after incubation with PrecipitationReagent.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationPrefilterPoreSize -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> FilterSizeP,
      Units -> Micron,
      Description -> "For each member of SampleLink, the pore size of the prefilter membrane, which is placed above PrecipitationFilter, and is designed so that molecules larger than the specified prefilter pore size should not pass through this filter.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationPrefilterMembraneMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> FilterMembraneMaterialP,
      Description -> "For each member of SampleLink, the material from which the prefilter filtration membrane, which is placed above PrecipitationFilter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationPoreSize -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> FilterSizeP,
      Units -> Micron,
      Description -> "For each member of SampleLink, the pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationMembraneMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> FilterMembraneMaterialP,
      Description -> "For each member of SampleLink, the material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFilterPosition -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the desired position in the PrecipitationFilter in which the samples are placed for the filtering.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFilterCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFiltrationPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFiltrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the samples will be exposed to either PrecipitationFiltrationPressure or PrecipitationFilterCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the PrecipitationPoreSize of PrecipitationFilter.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFiltrateVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of the filtrate that will be transferred into a new container, after passing through the filter thus having been separated from the molecules too large to pass through the filter.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationFilterStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, when PrecipitationFilterStorageCondition is not set to Disposal, PrecipitationFilterStorageCondition is the set of parameters that define the environmental conditions under which the filter used by this experiment will be stored after the protocol is completed.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationFilterStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, when PrecipitationFilterStorageCondition is not set to Disposal, PrecipitationFilterStorageCondition is the set of parameters that define the environmental conditions under which the filter used by this experiment will be stored after the protocol is completed.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationPelletVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the expected volume of the pellet after pelleting by centrifugation. This value is used to calculate the distance from the bottom of the container that the pipette tip will be held during aspiration of the supernatant. This calculated distance is such that the pipette tip should be held 2mm above the top of the pellet in order to prevent aspiration of the pellet. Overestimation of PrecipitationPelletVolume will result in less buffer being aspirated while underestimation of PrecipitationPelletVolume will risk aspiration of the pellet.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationPelletCentrifuge -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the centrifuge that will be used to apply centrifugal force to the samples at PrecipitationPelletCentrifugeIntensity for PrecipitationPelletCentrifugeTime in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationPelletCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or force that will be applied to the sample to facilitate precipitation of insoluble molecules out of solution.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationPelletCentrifugeTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the samples will be centrifuged at PrecipitationPelletCentrifugeIntensity in order to facilitate separation by pelleting of insoluble molecules from the liquid phase into a solid phase at the bottom of the container.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationSupernatantVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the supernatant that will be transferred to a new container after the insoluble molecules have been pelleted at the bottom of the starting container.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationNumberOfWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[0, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times PrecipitationWashSolution is added to the solid, mixed, and then separated again by either pelleting and aspiration if PrecipitationSeparationTechnique is set to Pellet, or by filtration if PrecipitationSeparationTechnique is set to Filter. The wash steps are performed in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample, after incubation with PrecipitationReagent.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of PrecipitationWashSolution which will used to help further wash impurities from the solid after the liquid phase has been separated from it. If PrecipitationSeparationTechnique is set to Filter, then this amount of PrecipitationWashSolution will be added to the filter containing the retentate. If PrecipitationSeparationTechnique is set to Pellet, then this amount of PrecipitationWashSolution will be added to the container containing the pellet.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashSolutionTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which PrecipitationWashSolution is incubated at during the PrecipitationWashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationWashSolutionTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which PrecipitationWashSolution is incubated at during the PrecipitationWashSolutionEquilibrationTime before being added to the solid in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationWashSolutionEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the minimum duration for which the PrecipitationWashSolution will be kept at PrecipitationWashSolutionTemperature before being used to help further wash impurities from the solid after the liquid phase has been separated from it.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "For each member of SampleLink, the manner in which the sample is agitated following addition of PrecipitationWashSolution, in order to help further wash impurities from the solid. Shake indicates that the sample will be placed on a shaker at the specified PrecipitationWashMixRate for PrecipitationWashMixTime, while Pipette indicates that PrecipitationWashMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationWashMixes. None indicates that no mixing occurs before incubation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used agitate the sample following the addition of PrecipitationWashSolution in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the rate at which the solid and PrecipitationWashSolution are mixed, for the duration of PrecipitationWashMixTime, in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained for the duration of PrecipitationWashMixTime in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the mixing device's heating/cooling block is maintained for the duration of PrecipitationWashMixTime in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the solid and PrecipitationWashSolution are mixed at PrecipitationWashMixRate in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationNumberOfWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times PrecipitationWashMixVolume of the PrecipitationWashSolution is mixed by pipetting up and down in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of PrecipitationWashSolution that is displaced by pipette during each wash mix cycle, for which the number of cycles are defined by NumberOfWashMixes.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashPrecipitationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the samples remain in PrecipitationWashSolution after any mixing has occurred, held at PrecipitationWashPrecipitationTemperature, in order to allow the solid to precipitate back out of solution before separation of WashSolution from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashPrecipitationInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used to maintain the sample and PrecipitationWashSolution at PrecipitationWashPrecipitationTemperature for the PrecipitationWashPrecipitationTime prior to separation.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashPrecipitationTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature which the samples in PrecipitationWashSolution are held at for the duration of PrecipitationWashPrecipitationTime in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationWashPrecipitationTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature which the samples in PrecipitationWashSolution are held at for the duration of PrecipitationWashPrecipitationTime in order to help further wash impurities from the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationWashCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or the force that will be applied to the sample in order to separate the PrecipitationWashSolution from the solid after any mixing and incubation steps have been performed. If PrecipitationSeparationTechnique is set to Filter, then the force is applied to the filter containing the retentate and PrecipitationWashSolution in order to facilitate the solution's passage through the filter and further wash impurities from the solid. If PrecipitationSeparationTechnique is set to Pellet, then the force is applied to the container containing the pellet and PrecipitationWashSolution in order to encourage the repelleting of the solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the target pressure applied to the filter containing the retentate and PrecipitationWashSolution in order to facilitate the solution's passage through the filter and help further wash impurities from the retentate.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationWashSeparationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the samples are exposed to PrecipitationWashPressure or PrecipitationWashCentrifugeIntensity in order to separate the PrecipitationWashSolution from the solid. If PrecipitationSeparationTechnique is set to Filter, then this separation is performed by passing the PrecipitationWashSolution through PrecipitationFilter by applying force of either PrecipitationWashPressure (if PrecipitationFiltrationTechnique is set to AirPressure) or PrecipitationWashCentrifugeIntensity (if PrecipitationFiltrationTechnique is set to Centrifuge). If PrecipitationSeparationTechnique is set to Pellet, then centrifugal force of PrecipitationWashCentrifugeIntensity is applied to encourage the solid to remain as, or return to, a pellet at the bottom of the container.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationDryingTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained for the duration of PrecipitationDryingTime after removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationDryingTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the incubation device's heating/cooling block is maintained for the duration of PrecipitationDryingTime after removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationDryingTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the amount of time for which the solid will be exposed to open air at PrecipitationDryingTemperature following final removal of PrecipitationWashSolution, in order to evaporate any residual PrecipitationWashSolution.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionBufferLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution into which the target molecules of the solid will be resuspended or redissolved. Setting PrecipitationResuspensionBuffer to None indicates that the sample will not be resuspended and that it will be stored as a solid, after any wash steps have been performed.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationResuspensionBufferExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> None,
      Description -> "For each member of SampleLink, the solution into which the target molecules of the solid will be resuspended or redissolved. Setting PrecipitationResuspensionBuffer to None indicates that the sample will not be resuspended and that it will be stored as a solid, after any wash steps have been performed.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationResuspensionBufferVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of PrecipitationResuspensionBuffer that will be added to the solid and mixed in an effort to resuspend or redissolve the solid into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionBufferTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature that the PrecipitationResuspensionBuffer is incubated at during the PrecipitationResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationResuspensionBufferTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature that the PrecipitationResuspensionBuffer is incubated at during the PrecipitationResuspensionBufferEquilibrationTime before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationResuspensionBufferEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the minimum duration for which the PrecipitationResuspensionBuffer will be kept at PrecipitationResuspensionBufferTemperature before being added to the sample in order to resuspend or redissolve the solid into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "For each member of SampleLink, the manner in which the sample is agitated following addition of PrecipitationResuspensionBuffer in order to encourage the solid phase to resuspend or redissolve into the buffer. Shake indicates that the sample will be placed on a shaker at the specified PrecipitationResuspensionMixRate for PrecipitationResuspensionMixTime at PrecipitationResuspensionMixTemperature, while Pipette indicates that PrecipitationResuspensionMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfPrecipitationResuspensionMixes. None indicates that no mixing occurs after adding PrecipitationResuspensionBuffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionMixInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the instrument used agitate the sample following the addition of PrecipitationResuspensionBuffer, in order to encourage the solid to redissolve or resuspend into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the rate at which the solid and PrecipitationResuspensionBuffer are shaken, for the duration of PrecipitationResuspensionMixTime at PrecipitationResuspensionMixTemperature, in order to encourage the solid to redissolve or resuspend into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the sample and PrecipitationResuspensionBuffer are held at for the duration of PrecipitationResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitationResuspensionMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the sample and PrecipitationResuspensionBuffer are held at for the duration of PrecipitationResuspensionMixTime in order to encourage the solid to redissolve or resuspend into the buffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitationResuspensionMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time that the solid and PrecipitationResuspensionBuffer is shaken for, at the specified PrecipitationResuspensionMixRate, in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationNumberOfResuspensionMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the PrecipitationResuspensionMixVolume of the PrecipitationResuspensionBuffer and solid are mixed pipetting up and down in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitationResuspensionMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of PrecipitationResuspensionBuffer that is displaced during each cycle of mixing by pipetting up and down, which is repeated for the number of times defined by NumberOfPrecipitationResuspensionMixes, in order to encourage the solid to redissolve or resuspend into the PrecipitationResuspensionBuffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitatedSampleContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitatedSampleContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container that contains the resuspended solid isolated after the protocol is completed.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitatedSampleStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if a buffer is specified for PrecipitationResuspensionBuffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    PrecipitatedSampleStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if a buffer is specified for PrecipitationResuspensionBuffer.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    PrecipitatedSampleLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the solid isolated after precipitation is completed, either as a solid, or as a solution if ResuspensionBuffer is not set to None. If SeparationTechnique is set to Filter, then the sample is the retentate comprised of molecules too large to pass through the filter after precipitation. If SeparationTechnique is set to Pellet, then the sample is the pellet after the supernatant formed during precipitation is removed. This label is for use in downstream unit operations.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    PrecipitatedSampleContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container that will contain the solid isolated after precipitation completed, either as a solid, or as a solution if ResuspensionBuffer is not set to None. If SeparationTechnique is set to Filter, then the sample contained in the container is the retentate comprised of molecules too large to pass through the filter after precipitation. If SeparationTechnique is set to Pellet, then the sample contained in the container is the pellet after the supernatant formed during precipitation is removed. This label is for use in downstream unit operations.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    UnprecipitatedSampleContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container that will contain the liquid phase after it is separated from the precipitated solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    UnprecipitatedSampleContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container that will contain the liquid phase after it is separated from the precipitated solid.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    UnprecipitatedSampleStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if ResuspensionBuffer is not set to None.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    UnprecipitatedSampleStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the set of parameters that define the environmental conditions under which the solid that is isolated during precipitation will be stored, either as a solid, or as a solution if ResuspensionBuffer is not set to None.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    UnprecipitatedSampleLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the liquid phase that is separated during this unit operation. If SeparationTechnique is set to Filter, then the sample is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample is the supernatant aspirated after the solid is pelleted using centrifugal force. This label is for use in downstream unit operations.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },

    UnprecipitatedSampleContainerLabel -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Relation -> Null,
      Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container that contains the liquid phase that is separated during this unit operation. If SeparationTechnique is set to Filter, then the sample contained in the container is the filtrate after it is separated from the molecules too large to pass through the filter. If SeparationTechnique is set to Pellet, then the sample contained in the container is the supernatant aspirated after the solid is pelleted using centrifugal force. This label is for use in downstream unit operations.",
      Category -> "Precipitation",
      IndexMatching -> SampleLink
    },


    (* --- SOLID PHASE EXTRACTION OPTIONS --- *)

    SolidPhaseExtractionStrategy -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Positive | Negative,
      Description -> "For each member of SampleLink, indicates if the target analyte or the impurities are adsorbed on the solid phase extraction column sorbent material while the other material passes through. Positive indicates that analytes of interest are adsorbed onto the extraction column sorbent and impurities pass through. Negative indicates that impurities adsorb onto the extraction column sorbent and target analytes pass through unretained.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionSeparationMode -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SeparationModeP,
      Description -> "For each member of SampleLink, the mechanism by which the mobile phase and solid support separate impurities from target analytes. IonExchange separates compounds based on charge where the sorbent material retains oppositely charged molecules on its surface. Affinity separates compounds based on \"Lock-and-Key\" model between molecules and sorbent materials, where the sorbent material selectively retains molecules of interest. SizeExclusion separates compounds based on hydrodynamic radius, which is proportional to molecular weight, where sorbent material allows smaller molecules to flow into pores while larger molecules bypass the pores and travel around the outside of the resin material. As a result, smaller molecules process though the column more slowly. Compounds elute in order of decreasing molecular weight.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionSorbent -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SolidPhaseExtractionFunctionalGroupP,
      Description -> "For each member of SampleLink, the chemistry of the solid phase material which interacts with the molecular components of the sample in order to retain either the target analyte(s) or the impurities on the extraction column. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionSorbent adsorbs the target analyte while impurities pass through. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionSorbent adsorbs impurities while the target analyte passes through unretained.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionCartridge -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      (*TODO::Relation needs to be updated if SPE widget is updated.*)
      Relation -> Alternatives[
        (* Cartridges *)
        Model[Container, ExtractionCartridge], Object[Container, ExtractionCartridge],
        (* Spin column *)
        Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
        (* Filter Plate *)
        Model[Container, Plate, Filter], Object[Container, Plate, Filter]
      ],
      Description -> "For each member of SampleLink, the container that is packed with SolidPhaseExtractionSorbent, which forms the stationary phase for extraction of the target analyte.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionTechnique -> {
      Format -> Multiple,
      Class -> Expression,
      (*TODO::Remove either AirPressure or Pressure when decision is made.*)
      Pattern :> Centrifuge | AirPressure | Pressure,
      Description -> "For each member of SampleLink, the type of force that is used to flush fluid through the SolidPhaseExtractionSorbent during Loading, Washing, and Eluting steps.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionInstrument -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument],Model[Instrument]],
      Description -> "For each member of SampleLink, the Instrument that generates force to flush fluid through the SolidPhaseExtractionSorbent during Loading, Washing, and Eluting steps.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionCartridgeStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the conditions under which SolidPhaseExtractionCartridge used by this experiment is stored after the protocol is completed.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SolidPhaseExtractionCartridgeStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the conditions under which SolidPhaseExtractionCartridge used by this experiment is stored after the protocol is completed.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SolidPhaseExtractionLoadingSampleVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of each individual input sample that is applied into the sorbent. LoadingSampleVolume is set to All, then all of pooled sample will be loaded in to ExtractionCartridge. If multiple samples are included in the same pool, individual samples are loaded sequentially.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionLoadingTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the sample is maintained during the SolidPhaseExtractionLoadingTemperatureEquilibrationTime, which occurs before loading the sample into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SolidPhaseExtractionLoadingTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the sample is maintained during the SolidPhaseExtractionLoadingTemperatureEquilibrationTime, which occurs before loading the sample into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SolidPhaseExtractionLoadingTemperatureEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the sample is held at the SolidPhaseExtractionLoadingTemperature before loading the sample into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionLoadingCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush the loading sample through the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionLoadingPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the amount of pressure applied to the SolidPhaseExtractionCartridge to flush the loading sample through the SolidPhaseExtractionSorbent in order to bind the target analyte(s) or impurities to the extraction column.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionLoadingTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time for which the SolidPhaseExtractionInstrument applies force to flush the loading sample through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to load the sample onto the column.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    CollectSolidPhaseExtractionLoadingFlowthrough -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the loaded sample solution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionLoadingFlowthroughContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container used to collect the loaded sample solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionLoadingTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SolidPhaseExtractionLoadingFlowthroughContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the loaded sample solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionLoadingTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SolidPhaseExtractionWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of SolidPhaseExtractionWashSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionWashTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SolidPhaseExtractionWashTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the SolidPhaseExtractionWashSolution is maintained during the SolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SolidPhaseExtractionWashTemperatureEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the SolidPhaseExtractionWashSolution is held at the SolidPhaseExtractionWashTemperature before adding the SolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionWashCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionWashPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionWashTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time for which the SolidPhaseExtractionInstrument applies force to flush SolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    CollectSolidPhaseExtractionWashFlowthrough -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if SolidPhaseExtractionWashSolution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionWashFlowthroughContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionWashTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SolidPhaseExtractionWashFlowthroughContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SolidPhaseExtractionWashTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SecondarySolidPhaseExtractionWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SecondarySolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SecondarySolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SecondarySolidPhaseExtractionWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of SecondarySolidPhaseExtractionWashSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, SecondarySolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, SecondarySolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SecondarySolidPhaseExtractionWashTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the SecondarySolidPhaseExtractionWashSolution is maintained during the SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SecondarySolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SecondarySolidPhaseExtractionWashTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the SecondarySolidPhaseExtractionWashSolution is maintained during the SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding SecondarySolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the SecondarySolidPhaseExtractionWashSolution is held at the SecondarySolidPhaseExtractionWashTemperature before adding the SecondarySolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SecondarySolidPhaseExtractionWashCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush SecondarySolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SecondarySolidPhaseExtractionWashPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the amount of pressure applied to the SolidPhaseExtractionCartridge to flush SecondarySolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SecondarySolidPhaseExtractionWashTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time for which the SolidPhaseExtractionInstrument applies force to flush SecondarySolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    CollectSecondarySolidPhaseExtractionWashFlowthrough -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if SecondarySolidPhaseExtractionWashSolution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SecondarySolidPhaseExtractionWashFlowthroughContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SecondarySolidPhaseExtractionWashTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SecondarySolidPhaseExtractionWashFlowthroughContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the SecondarySolidPhaseExtractionWashTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    TertiarySolidPhaseExtractionWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution that is flushed through SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, TertiarySolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, TertiarySolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    TertiarySolidPhaseExtractionWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of TertiarySolidPhaseExtractionWashSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique, in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Positive, TertiarySolidPhaseExtractionWashSolution removes impurities from the SolidPhaseExtractionSorbent while the TargetAnalyte is retained on the SolidPhaseExtractionSorbent. When SolidPhaseExtractionStrategy is set to Negative, TertiarySolidPhaseExtractionWashSolution removes the TargetAnalyte from the SolidPhaseExtractionSorbent while impurities are retained on the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    TertiarySolidPhaseExtractionWashTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the TertiarySolidPhaseExtractionWashSolution is maintained during the TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding TertiarySolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    TertiarySolidPhaseExtractionWashTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the TertiarySolidPhaseExtractionWashSolution is maintained during the TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime, which occurs before adding TertiarySolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the TertiarySolidPhaseExtractionWashSolution is held at the TertiarySolidPhaseExtractionWashTemperature before adding the TertiarySolidPhaseExtractionWashSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    TertiarySolidPhaseExtractionWashCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush TertiarySolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    TertiarySolidPhaseExtractionWashPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the amount of pressure applied to the SolidPhaseExtractionCartridge to flush TertiarySolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    TertiarySolidPhaseExtractionWashTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of time for which the SolidPhaseExtractionInstrument applies force to flush TertiarySolidPhaseExtractionWashSolution through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique in order to wash components of the cell lysate off of the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    CollectTertiarySolidPhaseExtractionWashFlowthrough -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if TertiarySolidPhaseExtractionWashSolution is collected after it is flushed through the SolidPhaseExtractionSorbent by the specified SolidPhaseExtractionTechnique (Centrifuge or Pressure).",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    TertiarySolidPhaseExtractionWashFlowthroughContainerOutExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        {_Integer, ObjectP[Model[Container]]},
        {_String, ObjectP[{Object[Container],Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}}
      ],
      Description->"For each member of SampleLink, the container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the TertiarySolidPhaseExtractionWashTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    TertiarySolidPhaseExtractionWashFlowthroughContainerOutLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the wash solution after it is flushed through the SolidPhaseExtractionSorbent during the TertiarySolidPhaseExtractionWashTime.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SolidPhaseExtractionElutionSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionElutionSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of SolidPhaseExtractionElutionSolution that is flushed through the SolidPhaseExtractionSorbent by the SolidPhaseExtractionTechnique in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionElutionSolutionTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the SolidPhaseExtractionElutionSolution is incubated for SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime before being flushed through the SolidPhaseExtractionSorbent to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent. The final temperature of the SolidPhaseExtractionElutionSolution is assumed to equilibrate with the SolidPhaseExtractionElutionSolutionTemperature.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    SolidPhaseExtractionElutionSolutionTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the SolidPhaseExtractionElutionSolution is incubated for SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime before being flushed through the SolidPhaseExtractionSorbent to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent. The final temperature of the SolidPhaseExtractionElutionSolution is assumed to equilibrate with the SolidPhaseExtractionElutionSolutionTemperature.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which SolidPhaseExtractionElutionSolution is held at the SolidPhaseExtractionElutionSolutionTemperature before adding the SolidPhaseExtractionElutionSolution into the SolidPhaseExtractionCartridge.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionElutionCentrifugeIntensity -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> Alternatives[
        GreaterEqualP[0 GravitationalAcceleration],
        GreaterEqualP[0 RPM]
      ],
      Units -> None,
      Description -> "For each member of SampleLink, the rotational speed or gravitational force at which the SolidPhaseExtractionCartridge is centrifuged to flush the SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionElutionPressure -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "For each member of SampleLink, the amount of pressure applied to the SolidPhaseExtractionCartridge to flush SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove target molecule(s) from the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    SolidPhaseExtractionElutionTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration for which the SolidPhaseExtractionInstrument applies force to the SolidPhaseExtractionCartridge to flush the SolidPhaseExtractionElutionSolution through the SolidPhaseExtractionSorbent in order to resuspend and remove the target molecule(s) from the SolidPhaseExtractionSorbent.",
      Category -> "Solid Phase Extraction",
      IndexMatching -> SampleLink
    },

    (* --- MAGNETIC BEAD SEPARATION OPTIONS --- *)

    MagneticBeadSeparationSelectionStrategy -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> ListableP[ListableP[MagneticBeadSeparationSelectionStrategyP]],
      Description -> "Tpecified if the target analyte (Positive) or contaminants (Negative) binds to the magnetic beads in order to isolate the target analyte. When the target analyte is bound to the magnetic beads (Positive), they are collected as SamplesOut during the elution step. When contaminants are bound to the magnetic beads (Negative), the target analyte remains in the supernatant and is collected as SamplesOut during the loading step.",
      Category -> "Magnetic Bead Separation"
    },

    MagneticBeadSeparationMode -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> ListableP[ListableP[Alternatives[Affinity,IonExchange,NormalPhase,ReversePhase]]],
      Description -> "The mechanism used to selectively isolate or remove targeted components from the samples by magnetic beads. Options include NormalPhase, ReversePhase, IonExchange, Affinity. In NormalPhase mode, magnetic beads are coated with polar molecules (mainly pure silica) and the mobile phase less polar causing the adsorption of polar targeted components. In ReversePhase mode, magnetic beads are coated with hydrophobic groups on the surface to bind targeted components. In IonExchange mode, magnetic beads coated with ion-exchange groups ionically bind charged targeted components. In Affinity mode, magnetic beads are coated with functional groups that can covalently conjugate ligands on targeted components.",
      Category -> "Magnetic Bead Separation"
    },

    MagneticBeadSeparationSampleVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of sample that is added to the magnetic beads in order to allow binding of target analyte or contaminant to the magnetic beads after the magnetic beads are optionally prewashed and equilibrated.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSampleVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the amount of sample that is added to the magnetic beads in order to allow binding of target analyte or contaminant to the magnetic beads after the magnetic beads are optionally prewashed and equilibrated.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationAnalyteAffinityLabel -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Molecule],
      Description -> "For each member of SampleLink, the target molecule in the sample that binds the immobilized ligand on the magnetic beads for affinity separation, applicable if MagneticBeadSeparationMode is set to Affinity. MagneticBeadSeparationAnalyteAffinityLabel is used to help set automatic options such as MagneticBeadAffinityLabel.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadAffinityLabel -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Molecule],
      Description -> "For each member of SampleLink, the molecule immobilized on the magnetic beads that specifically binds the target analyte for affinity separation, applicable if MagneticBeadSeparationMode is set to Affinity. MagneticBeadAffinityLabel is used to help set automatic options such as MagneticBeads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeads -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the superparamagnetic particles with surface coatings to bind target analyte or contaminants. They exhibit magnetic behavior only in the presence of an external magnetic field. The magnetic beads are pulled to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the supernatant.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volumetric amount of MagneticBeads that is added to the assay container prior to optional prewash and equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the used magnetic beads are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the used magnetic beads are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagnetizationRack -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container,Rack],
        Object[Container,Rack],
        Model[Item,MagnetizationRack],
        Object[Item,MagnetizationRack]
      ],
      Description -> "For each member of SampleLink, the magnetic rack used during magnetization that provides the magnetic force to attract the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationPreWashSolution after the elapse of PreWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationPreWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationPreWashSolution after the elapse of PreWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationEquilibrationCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationEquilibrationSolution after the elapse of EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationEquilibrationCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationEquilibrationSolution after the elapse of EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationLoadingCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated sample containing components that are not bound to the magnetic beads after the elapse of EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationLoadingCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated sample containing components that are not bound to the magnetic beads after the elapse of EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationWashSolution after the elapse of WashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationWashSolution after the elapse of WashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSecondaryWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSecondaryWashSolution after the elapse of SecondaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSecondaryWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSecondaryWashSolution after the elapse of SecondaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationTertiaryWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationTertiarySolution after the elapse of TertiaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationTertiaryWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationTertiarySolution after the elapse of TertiaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuaternaryWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationQuaternaryWashSolution after the elapse of QuaternaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuaternaryWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationQuaternaryWashSolution after the elapse of QuaternaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuinaryWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationQuinaryWashSolution after the elapse of QuinaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuinaryWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationQuinaryWashSolution after the elapse of QuinaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSenaryWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSenaryWashSolution after the elapse of SenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSenaryWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSenaryWashSolution after the elapse of SenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSeptenaryWashCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSeptenaryWashSolution after the elapse of SeptenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSeptenaryWashCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSeptenaryWashSolution after the elapse of SeptenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationElutionCollectionContainerLabelExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(_String|Null)..},
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated samples after the elapse of ElutionMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationElutionCollectionContainerLabelString -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> _String,
      Description -> "For each member of SampleLink, the user defined word or phrase used to identify the container for collecting the aspirated samples after the elapse of ElutionMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationPreWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationPreWashSolution that is added to the magnetic beads for each prewash prior to equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationPreWashSolution and the magnetic beads during each prewash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationPreWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationPreWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationPreWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationPreWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationPreWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationPreWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationPreWashMixVolume up and down following the addition of MagneticBeadSeparationPreWashSolution to the magnetic beads during each prewash in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationPreWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationPreWashSolution and magnetic beads is maintained during the MagneticBeadSeparationPreWashMix, which occurs after adding MagneticBeadSeparationPreWashSolution to the magnetic beads and before the MagneticBeadSeparationPreWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationPreWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationPreWashSolution and magnetic beads is maintained during the MagneticBeadSeparationPreWashMix, which occurs after adding MagneticBeadSeparationPreWashSolution to the magnetic beads and before the MagneticBeadSeparationPreWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationPreWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationPreWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationPreWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    PreWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationPreWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationPreWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashAspirationVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationPreWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of PreWashMagnetizationTime during each prewash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the aspirated used MagneticBeadSeparationPreWashSolution during the prewash(es) prior to equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationPreWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the aspirated used MagneticBeadSeparationPreWashSolution during the prewash(es) prior to equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationPreWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirate used MagneticBeadSeparationPreWashSolution during the prewashes prior to equilibration are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationPreWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirate used MagneticBeadSeparationPreWashSolution during the prewashes prior to equilibration are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationPreWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationPreWashSolution, mixing, magnetization, and aspirating solution prior to equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationPreWashSolution following the final prewash prior to equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationPreWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationPreWashSolution following the final prewash prior to equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibration -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are equilibrated to a condition for optimal bead-target binding prior to adding the samples to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution that is added to the magnetic beads in order to equilibrate them to a condition for optimal bead-target binding prior to sample loading.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationEquilibrationSolution that is added to the magnetic beads in order to equilibrate them to a condition for optimal bead-target binding prior to sample loading.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationEquilibrationSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationEquilibrationSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads are mixed by the selected MagneticBeadSeparationEquilibrationMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationEquilibrationMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationEquilibrationMixVolume up and down following the addition of MagneticBeadSeparationEquilibrationSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is maintained during the MagneticBeadSeparationEquilibrationMix, which occurs after adding MagneticBeadSeparationEquilibrationSolution to the magnetic beads and before the EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationEquilibrationMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is maintained during the MagneticBeadSeparationEquilibrationMix, which occurs after adding MagneticBeadSeparationEquilibrationSolution to the magnetic beads and before the EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationEquilibrationMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationEquilibrationMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    EquilibrationMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationEquilibrationMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationEquilibrationSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationEquilibrationSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationEquilibrationAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationEquilibrationSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of EquilibrationMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationEquilibrationCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[
        Alternatives[
          {_Integer, ObjectP[Model[Container]]},
          {_String, ObjectP[{Object[Container],Model[Container]}]},
          {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},
          Null
        ]],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationEquilibrationSolution during the equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationEquilibrationCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationEquilibrationSolution during the equilibration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationEquilibrationCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationEquilibrationSolution during equilibration are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationEquilibrationCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationEquilibrationSolution during equilibration are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationEquilibrationAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationEquilibrationSolution and prior to sample loading.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationEquilibrationAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationEquilibrationSolution after aspiration of the used MagneticBeadSeparationEquilibrationSolution and prior to sample loading.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of the sample and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the sample to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined sample and magnetic beads are mixed by the selected MagneticBeadSeparationLoadingMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined sample and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationLoadingMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined sample and magnetic beads is mixed by pipetting the MagneticBeadSeparationLoadingMixVolume up and down following the addition of sample to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined sample and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined sample and magnetic beads is maintained during the MagneticBeadSeparationLoadingMix, which occurs after adding sample to the magnetic beads and before the LoadingMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationLoadingMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined sample and magnetic beads is maintained during the MagneticBeadSeparationLoadingMix, which occurs after adding sample to the magnetic beads and before the LoadingMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationLoadingMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined sample and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationLoadingMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    LoadingMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationLoadingMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the sample solution containing components that are not bound to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used sample to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of LoadingMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationLoadingAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used sample to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of LoadingMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationLoadingCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[
        Alternatives[
          {_Integer, ObjectP[Model[Container]]},
          {_String, ObjectP[{Object[Container],Model[Container]}]},
          {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},
          Null
        ]],
      Description->"For each member of SampleLink, the container used to collect the sample solution containing components that are not bound to the magnetic beads after the elapse of LoadingMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationLoadingCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the sample solution containing components that are not bound to the magnetic beads after the elapse of LoadingMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationLoadingCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated sample solution containing components that are not bound to the magnetic beads are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationLoadingCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated sample solution containing components that are not bound to the magnetic beads are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationLoadingAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining sample solution after aspiration of sample solution containing components that are not bound to the magnetic beads and prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationLoadingAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining sample after aspiration of sample solution containing components that are not bound to the magnetic beads and prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSecondaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSecondaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationWashMixVolume up and down following the addition of MagneticBeadSeparationWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationWashSolution and magnetic beads is maintained during the MagneticBeadSeparationWashMix, which occurs after adding MagneticBeadSeparationWashSolution to the magnetic beads and before the WashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationWashSolution and magnetic beads is maintained during the MagneticBeadSeparationWashMix, which occurs after adding MagneticBeadSeparationWashSolution to the magnetic beads and before the WashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    WashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of WashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of WashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationSecondaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationWashSolution and prior to elution or optional MagneticBeadSeparationSecondaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationWashSolution after aspiration of the used MagneticBeadSeparationWashSolution and prior to elution or optional MagneticBeadSeparationSecondaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationTertiaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during SecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationTertiaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationSecondaryWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationSecondaryWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSecondaryWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationSecondaryWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationSecondaryWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSecondaryWashMixVolume up and down following the addition of MagneticBeadSeparationSecondaryWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSecondaryWashMix, which occurs after adding MagneticBeadSeparationSecondaryWashSolution to the magnetic beads and before the SecondaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSecondaryWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSecondaryWashMix, which occurs after adding MagneticBeadSeparationSecondaryWashSolution to the magnetic beads and before the SecondaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSecondaryWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationSecondaryWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    SecondaryWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationSecondaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSecondaryWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationSecondaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SecondaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSecondaryWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationSecondaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SecondaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSecondaryWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationSecondaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSecondaryWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationSecondaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSecondaryWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationSecondaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSecondaryWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationSecondaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationSecondaryWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationSecondaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationTertiaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSecondaryWashSolution and prior to elution or optional MagneticBeadSeparationTertiaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSecondaryWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSecondaryWashSolution after aspiration of the used MagneticBeadSeparationSecondaryWashSolution and prior to elution or optional MagneticBeadSeparationTertiaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during TertiaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationTertiaryWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationTertiaryWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationTertiaryWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationTertiaryWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationTertiaryWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationTertiaryWashMixVolume up and down following the addition of MagneticBeadSeparationTertiaryWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationTertiaryWashMix, which occurs after adding MagneticBeadSeparationTertiaryWashSolution to the magnetic beads and before the TertiaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationTertiaryWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationTertiaryWashMix, which occurs after adding MagneticBeadSeparationTertiaryWashSolution to the magnetic beads and before the TertiaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationTertiaryWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationTertiaryWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    TertiaryWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationTertiaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationTertiaryWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationTertiaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of TertiaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationTertiaryWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationTertiaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of TertiaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationTertiaryWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationTertiaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationTertiaryWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationTertiaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationTertiaryWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationTertiaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationTertiaryWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationTertiaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationTertiaryWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationTertiaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationTertiaryWashSolution and prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationTertiaryWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationTertiaryWashSolution after aspiration of the used MagneticBeadSeparationTertiaryWashSolution and prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuinaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during QuaternaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuinaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationQuaternaryWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationQuaternaryWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationQuaternaryWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationQuaternaryWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationQuaternaryWashMixVolume up and down following the addition of MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationQuaternaryWashMix, which occurs after adding MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads and before the QuaternaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuaternaryWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationQuaternaryWashMix, which occurs after adding MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads and before the QuaternaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuaternaryWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationQuaternaryWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    QuaternaryWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationQuaternaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationQuaternaryWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationQuaternaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of QuaternaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuaternaryWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationQuaternaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of QuaternaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuaternaryWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationQuaternaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuaternaryWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationQuaternaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuaternaryWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationQuaternaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuaternaryWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationQuaternaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationQuaternaryWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationQuaternaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationQuinaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationQuaternaryWashSolution and prior to elution or optional MagneticBeadSeparationQuinaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuaternaryWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationQuaternaryWashSolution after aspiration of the used MagneticBeadSeparationQuaternaryWashSolution and prior to elution or optional MagneticBeadSeparationQuinaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during QuinaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationQuinaryWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationQuinaryWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationQuinaryWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationQuinaryWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationQuinaryWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationQuinaryWashMixVolume up and down following the addition of MagneticBeadSeparationQuinaryWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationQuinaryWashMix, which occurs after adding MagneticBeadSeparationQuinaryWashSolution to the magnetic beads and before the QuinaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuinaryWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationQuinaryWashMix, which occurs after adding MagneticBeadSeparationQuinaryWashSolution to the magnetic beads and before the QuinaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuinaryWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationQuinaryWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    QuinaryWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationQuinaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationQuinaryWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationQuinaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of QuinaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuinaryWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationQuinaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of QuinaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuinaryWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationQuinaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuinaryWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationQuinaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationQuinaryWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationQuinaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationQuinaryWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationQuinaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationQuinaryWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationQuinaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationSenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationQuinaryWashSolution and prior to elution or optional MagneticBeadSeparationSenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationQuinaryWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationQuinaryWashSolution after aspiration of the used MagneticBeadSeparationQuinaryWashSolution and prior to elution or optional MagneticBeadSeparationSenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSeptenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during SenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSeptenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationSenaryWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationSenaryWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSenaryWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationSenaryWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationSenaryWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSenaryWashMixVolume up and down following the addition of MagneticBeadSeparationSenaryWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSenaryWashMix, which occurs after adding MagneticBeadSeparationSenaryWashSolution to the magnetic beads and before the SenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSenaryWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSenaryWashMix, which occurs after adding MagneticBeadSeparationSenaryWashSolution to the magnetic beads and before the SenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSenaryWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationSenaryWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    SenaryWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationSenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSenaryWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationSenaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSenaryWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationSenaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSenaryWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationSenaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSenaryWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationSenaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSenaryWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationSenaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSenaryWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationSenaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationSenaryWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationSenaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationSeptenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSenaryWashSolution and prior to elution or optional MagneticBeadSeparationSeptenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSenaryWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSenaryWashSolution after aspiration of the used MagneticBeadSeparationSenaryWashSolution and prior to elution or optional MagneticBeadSeparationSeptenaryWash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWash -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads during SeptenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationSeptenaryWashSolution that is added to the magnetic beads for each wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationSeptenaryWashSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationSeptenaryWashMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    NumberOfMagneticBeadSeparationSeptenaryWashMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSeptenaryWashMixVolume up and down following the addition of MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSeptenaryWashMix, which occurs after adding MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads and before the SeptenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSeptenaryWashMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSeptenaryWashMix, which occurs after adding MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads and before the SeptenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSeptenaryWashMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationSeptenaryWashMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    SeptenaryWashMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationSeptenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSeptenaryWashSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationSeptenaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SeptenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSeptenaryWashAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationSeptenaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SeptenaryWashMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSeptenaryWashCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[
        ListableP[ObjectP[{Model[Container], Object[Container]}],2],
        ListableP[{_Integer, ObjectP[Model[Container]]},2],
        ListableP[{_String, ObjectP[{Object[Container],Model[Container]}]},2],
        ListableP[{_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},2],
        ListableP[ListableP[ListableP[Null]]]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationSeptenaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSeptenaryWashCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the used MagneticBeadSeparationSeptenaryWashSolution aspirated during wash.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationSeptenaryWashCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationSeptenaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationSeptenaryWashCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated used MagneticBeadSeparationSeptenaryWashSolution during wash are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    NumberOfMagneticBeadSeparationSeptenaryWashes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the magnetic beads are washed by adding MagneticBeadSeparationSeptenaryWashSolution, mixing, magnetization, and aspirating solution prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashAirDry -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSeptenaryWashSolution and prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationSeptenaryWashAirDryTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSeptenaryWashSolution after aspiration of the used MagneticBeadSeparationSeptenaryWashSolution and prior to elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationElution -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the magnetic beads are rinsed in a different buffer condition in order to release the components bound to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    MagneticBeadSeparationElutionSolution -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SampleLink, the solution used to rinse the magnetic beads, providing a buffer condition in order to release the components bound to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationElutionSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the amount of MagneticBeadSeparationElutionSolution that is added to the magnetic beads for each elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    MagneticBeadSeparationElutionMix -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SampleLink, indicates if the solution is mixed following combination of MagneticBeadSeparationElutionSolution and the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    MagneticBeadSeparationElutionMixType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Shake | Pipette,
      Description -> "For each member of SampleLink, the style of motion used to mix the suspension following the addition of the MagneticBeadSeparationElutionSolution to the magnetic beads.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    MagneticBeadSeparationElutionMixTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration during which the combined MagneticBeadSeparationElutionSolution and magnetic beads is mixed by the selected MagneticBeadSeparationElutionMixType.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    MagneticBeadSeparationElutionMixRate -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "For each member of SampleLink, the number of rotations per minute at which the combined MagneticBeadSeparationElutionSolution and magnetic beads is shaken in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    NumberOfMagneticBeadSeparationElutionMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times that the combined MagneticBeadSeparationElutionSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationElutionMixVolume up and down following the addition of MagneticBeadSeparationElutionSolution to the magnetic beads in order to fully mix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationElutionMixVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of the combined MagneticBeadSeparationElutionSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    MagneticBeadSeparationElutionMixTemperatureReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationElutionSolution and magnetic beads is maintained during the MagneticBeadSeparationElutionMix, which occurs after adding MagneticBeadSeparationElutionSolution to the magnetic beads and before the ElutionMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationElutionMixTemperatureExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Ambient,
      Description -> "For each member of SampleLink, the temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationElutionSolution and magnetic beads is maintained during the MagneticBeadSeparationElutionMix, which occurs after adding MagneticBeadSeparationElutionSolution to the magnetic beads and before the ElutionMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationElutionMixTipType -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SampleLink, the type of pipette tips used to mix the combined MagneticBeadSeparationElutionSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationElutionMixTipMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SampleLink, the material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationElutionMix.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },
    
    ElutionMagnetizationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "For each member of SampleLink, the duration of magnetizing the magnetic beads after MagneticBeadSeparationElutionMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationElutionSolution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    },

    MagneticBeadSeparationElutionAspirationVolumeReal -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationElutionSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of ElutionMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationElutionAspirationVolumeExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> All,
      Description -> "For each member of SampleLink, the volume of used MagneticBeadSeparationElutionSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of ElutionMagnetizationTime.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationElutionCollectionContainerExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ListableP[
        Alternatives[
          {_Integer, ObjectP[Model[Container]]},
          {_String, ObjectP[{Object[Container],Model[Container]}]},
          {_String, {_Integer, ObjectP[{Object[Container],Model[Container]}]}},
          Null
        ]],
      Description->"For each member of SampleLink, the container used to collect the aspirated samples(s) during the elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationElutionCollectionContainerLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container]
      ],
      Description->"For each member of SampleLink, the container used to collect the aspirated samples(s) during the elution.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },

    MagneticBeadSeparationElutionCollectionStorageConditionLink -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[StorageCondition]],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated sample(s) during elution are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    MagneticBeadSeparationElutionCollectionStorageConditionExpression -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[SampleStorageTypeP, Disposal],
      Description -> "For each member of SampleLink, the non-default condition under which the aspirated sample(s) during elution are stored after the protocol is completed.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink,
      Migration -> SplitField
    },
    
    NumberOfMagneticBeadSeparationElutions -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[1,1],
      Units -> None,
      Description -> "For each member of SampleLink, the number of times the bound components on the magnetic beads are eluted by adding MagneticBeadSeparationElutionSolution, mixing, magnetization, and aspiration.",
      Category -> "Magnetic Bead Separation",
      IndexMatching -> SampleLink
    }

  }
}];