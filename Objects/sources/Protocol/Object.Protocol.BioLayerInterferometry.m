(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, BioLayerInterferometry], {
  Description -> "A protocol describing the sample, assay, and instrument parameters for a bio-layer interferometry experiment.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* ------------------------- *)
    (* --- Method Information ---*)
    (* ------------------------- *)

    Instrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument],
        Object[Instrument]
      ],
      Description -> "The device used for the BioLayerInterferometry protocol.",
      Category -> "General"
    },
    ExperimentType -> {
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Kinetics, Quantitation, EpitopeBinning, AssayDevelopment],
      Description-> "The type of bio-layer interferometry assay performed in this protocol.",
      Category -> "General"
    },
    BioProbes -> {
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
        Model[Item, BLIProbe],
        Object[Item, BLIProbe]
      ],
      Description-> "The surface-functionalized fiber-optic probes used to measure analyte binding and dissociation in the bio-layer interferometry experiment.",
      Category -> "General"
    },
    ProbeRackPlate -> {
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
        Model[Container, Plate],
        Object[Container, Plate]
      ],
      Description-> "The 96 well plate used to equilibrate probes in the probe rack.",
      Category -> "General"
    },
    RepeatMeasurements -> {
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0,1],
      Description-> "The number of times that the indicated measurement type is performed on a each sample.",
      Category -> "General"
    },
    AcquisitionRate -> {
      Format->Single,
      Class->Real,
      Pattern:>Alternatives[2 Hertz, 5 Hertz, 10 Hertz, 2. Hertz, 5. Hertz, 10.Hertz],
      Units -> Hertz,
      Description-> "The rate at which data points are recorded.",
      Category -> "General"
    },
    PlateCover-> {
      Format->Single,
      Class->Link,
      Pattern:> _Link,
      Relation -> Alternatives[
        Model[Part, BLIPlateCover],
        Object[Part, BLIPlateCover]
      ],
      Description-> "The plate cover is used to prevent evaporation from the assay plate during the experiment.",
      Category -> "General"
    },
    Temperature -> {
      Format->Single,
      Class-> Real,
      Pattern:> Alternatives[GreaterP[0*Kelvin], Ambient],
      Units -> Celsius,
      Description-> "The temperature of the 96-well plate in which the assay is conducted.",
      Category -> "General"
    },


    (* ------------------------- *)
    (* --- Assay Preparation --- *)
    (* ------------------------- *)

    ProbeRackEquilibrationTime -> {
      Format->Single,
      Class-> Real,
      Pattern:> GreaterP[0*Minute],
      Units -> Minute,
      Description-> "The minimum amount of time for which bio-probes used in the assay are immersed in ProbeRackEquilibrationBuffer while in the probe rack, prior to use. All bio-probes used in this experiment remain immersed in the ProbeEquilibrationBufferSolution until required for the assay.",
      Category -> "General"
    },
    ProbeRackEquilibrationBuffer -> {
      Format->Single,
      Class -> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Object[Sample],
        Model[Sample]
      ],
      Description-> "The buffer used to equilibrate bio-probes in the bio-probe rack.",
      Category -> "General"
    },
    ProbeRackPlatePrimitives->{
      Format->Multiple,
      Class->Expression,
      Pattern:>(SampleManipulationP|SamplePreparationP),
      Description -> "A set of instructions specifying loading of the probe rack plate with the required solutions.",
      Category -> "Sample Preparation"
    },
    ProbeRackPlateManipulation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,SampleManipulation],
      Description->"A sample manipulation protocol used to load the probe rack plate with buffer.",
      Category -> "Sample Preparation"
    },
    StartDelay -> {
      Format->Single,
      Class-> Real,
      Pattern:> GreaterEqualP[0*Minute],
      Units -> Minute,
      Description-> "The amount of time for which the assay plate is located in the instrument prior to beginning the assay.",
      Category -> "General"
    },
    StartDelayShake -> {
      Format->Single,
      Class-> Expression,
      Pattern:> BooleanP,
      Description-> "Indicates if the assay 96 well plate is shaken during the start delay time.",
      Category -> "General"
    },
    AssayPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Container,Plate] | Model[Container,Plate],
      Description->"The plate which contains input samples and other solutions used in the bio-layer interferometry experiment.",
      Category -> "General"
    },
    AssayPlatePrimitives->{
      Format->Multiple,
      Class->Expression,
      Pattern:>(SampleManipulationP|SamplePreparationP),
      Description -> "A set of instructions specifying the loading of the assay plate with the required solutions.",
      Category -> "Sample Preparation"
    },
    AssayPlateManipulation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation]|Object[Notebook,Script],
      Description->"A sample manipulation protocol used to load the assay plate.",
      Category -> "Sample Preparation"
    },

    (* -------------------------------------------- *)
    (* -- Named Solutions and Storage Conditions -- *)
    (* -------------------------------------------- *)

    Standard -> {
      Format->Single,
      Class -> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Object[Sample],
        Model[Sample]
      ],
      Description-> "The standard solution used for reference in the assay.",
      Category -> "General"
    },
    StandardStorageCondition->{
      Format->Single,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal),
      Description->"The storage condition under which Standard should be stored after its usage in the experiment.",
      Category->"Sample Storage"
    },
    (*Note: this field is populated by the LoadSolution, TestLoadingSolutions, or TestInteractionSolutions options*)
    LoadSolutions -> {
      Format->Multiple,
      Class -> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Object[Sample],
        Model[Sample]
      ],
      Description-> "The solution(s) used to load the probe surface with a specified ligand which interacts with the solution phase analyte.",
      Category -> "General"
    },
    LoadSolutionsStorageConditions -> {
      Format->Multiple,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal),
      Description->"The storage condition under which LoadSolutions should be stored after their usage in the experiment.",
      Category->"Sample Storage"
    },

    (* ------------------------- *)
    (* --- Assay Development --- *)
    (* ------------------------- *)

    DevelopmentType -> {
      Format->Single,
      Class ->Expression,
      Pattern:>Alternatives[ScreenDetectionLimit, ScreenBuffer, ScreenInteraction, ScreenLoading, ScreenRegeneration, ScreenActivation],
      Description -> "The type of assay development conducted in this experiment.",
      Category -> "General"
    },

    (* ------------------------ *)
    (* --- SAMPLE DILUTIONS --- *)
    (* ------------------------ *)

    (* --- MIXING PARAMETERS --- *)

    DilutionNumberOfMixes->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterP[0],
      Description->"The number of times the DilutionMixVolume will be pipetted in and out of each dilution/solution prepared in this assay.",
      Category -> "General"
    },
    DilutionMixRate->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 Microliter/Second],
      Units -> Microliter/Second,
      Description->"The rate at which solution will be pipetted in and out to mix each dilution/solution prepared in this assay.",
      Category -> "General"
    },
    DilutionMixVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0 Microliter],
      Units -> Microliter,
      Description->"The volume of solution which will be pipetted in and out to mix each dilution/solution prepared in this assay.",
      Category -> "General"
    },

    (* --- KINETICS --- *)
    KineticsSampleDiluent -> {
      Format->Multiple,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "For each member of SamplesIn, the solution that is used to dilute the sample to generate the dilution series used for a Kinetics assay.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    KineticsSampleFixedDilutions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {({GreaterEqualP[0*Microliter],GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]}|Null)...},
      Description -> "For each member of SamplesIn, the linear dilutions series for use in a Kinetics assay given as {SampleAmount, DiluentVolume, DilutionName}, where DilutionName is the integer used to reference this solution in the AssayPrimitives.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    KineticsSampleFixedDilutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying preparation of a linear dilution series.",
      Category -> "Sample Preparation"
    },
    KineticsSampleFixedDilutionsManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,SampleManipulation],
      Description -> "The specific sub-protocol performed to generate fixed dilutions for a Kinetics assay.",
      Category -> "Sample Preparation"
    },
    KineticsSampleFixedDilutionsPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->(Object[Container,Plate] | Model[Container,Plate]|Model[Container, Vessel]|Object[Container, Vessel]),
      Description->"The plate(s) which are used to prepare dilutions that require volumes larger than 250 Microliter. Dilutions of smaller volumes occur on the assay plate.",
      Category -> "General"
    },
    KineticsSampleSerialDilutions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {({GreaterEqualP[0*Microliter],GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]}|Null)...},
      Description -> "For each member of SamplesIn, the serial dilutions series for use in a Kinetics assay given as {TransferAmount, DiluentVolume, DilutionName}, where DilutionName is the integer used to reference this solution in the AssayPrimitives.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    KineticsSampleSerialDilutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying preparation of dilution series.",
      Category -> "Sample Preparation"
    },
    KineticsSampleSerialDilutionsManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,SampleManipulation],
      Description -> "The specific sub-protocol performed to perform dilutions for association measurement.",
      Category -> "Sample Preparation"
    },
    KineticsSampleSerialDilutionsPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->(Object[Container,Plate] | Model[Container,Plate]|Model[Container, Vessel]|Object[Container, Vessel]),
      Description->"The plate(s) which are used to prepare dilution series require volumes larger than 250 Microliter.",
      Category -> "General"
    },

    (* --- DEVELOPMENT PARAMETERS --- *)
    DevelopmentSampleDiluent -> {
      Format->Multiple,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "For each member of SamplesIn, the solution that is used to dilute the input samples for ScreenDetectionLimit experiments.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    DevelopmentSampleFixedDilutions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {({GreaterEqualP[0*Microliter],GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]}|Null)...},
      Description -> "For each member of SamplesIn, the linear dilutions series for the input samples for use in a Development assay given as {SampleAmount, DiluentVolume, DilutionName}, where DilutionName is the integer used to reference this solution in the AssayPrimitives.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    DevelopmentSampleFixedDilutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying preparation of a linear dilution series.",
      Category -> "Sample Preparation"
    },
    DevelopmentSampleFixedDilutionsManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,SampleManipulation],
      Description -> "The specific sub-protocol performed to generate linear dilutions.",
      Category -> "Sample Preparation"
    },
    DevelopmentSampleFixedDilutionsPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->(Object[Container,Plate] | Model[Container,Plate]|Model[Container, Vessel]|Object[Container, Vessel]),
      Description->"The plate(s) which are used to prepare dilution series which include a dilution with volumes larger than 250 Microliter.",
      Category -> "General"
    },

    DevelopmentSampleSerialDilutions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {({GreaterEqualP[0*Microliter],GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]}|Null)...},
      Description -> "For each member of SamplesIn, the serial dilutions series for use in a Development assay given as {TransferAmount, DiluentVolume, DilutionName}, where DilutionName is the integer used to reference this solution in the AssayPrimitives.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    DevelopmentSampleSerialDilutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying preparation of dilution series.",
      Category -> "Sample Preparation"
    },
    DevelopmentSampleSerialDilutionsManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,SampleManipulation],
      Description -> "The specific sub-protocol performed to perform dilutions for association measurement.",
      Category -> "Sample Preparation"
    },
    DevelopmentSampleSerialDilutionsPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->(Object[Container,Plate] | Model[Container,Plate]|Model[Container, Vessel]|Object[Container, Vessel]),
      Description->"The plate(s) which are used to prepare dilution series which include a dilution with volumes larger than 250 Microliter.",
      Category -> "General"
    },


    (* --- QUANTITATION PARAMETERS --- *)
    QuantitationParameters -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern:> Alternatives[StandardCurve, StandardWell, BlankWell, AmplifiedDetection, EnzymeLinked],
      Description -> "The modifications on a basic quantitation experiment.",
      Category -> "General"
    },
    QuantitationStandard -> {
      Format->Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "The solution with a known amount of analyte, which is used to generate a standard curve for the quantitation of analyte concentration in the input samples.",
      Category->"Standard Curve"
    },
    QuantitationStandardStorageCondition->{
      Format->Single,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal),
      Description->"The storage condition under which QuantitationStandard should be stored after its usage in the experiment.",
      Category->"Sample Storage"
    },
    QuantitationStandardDiluent -> {
      Format->Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "The solution which is used to dilute the QuantitationStandardSolution to create a standard curve.",
      Category->"Standard Curve"
    },
    QuantitationStandardFixedDilutions -> {
      Format -> Multiple,
      Class -> {Real, Real, Expression},
      Pattern :> {GreaterEqualP[0*Microliter], GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]},
      Units-> {Microliter, Microliter, None},
      Description -> "The list of dilutions of QuantitationStandardSolution with QuantitationStandardDiluent. These fixed dilutions are used to create a standard curve for a Quantitation assay.",
      Category->"Standard Curve",
      Headers ->{"Standard Amount", "Diluent Volume", "Solution Name"}
    },
    QuantitationStandardFixedDilutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying the transfer of solutions to create the Quantitation standard linear dilutions.",
      Category -> "Sample Preparation"
    },
    QuantitationStandardFixedDilutionsManipulation -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,SampleManipulation],
      Description -> "The specific subprotocol performed to create the Quantitation standard linear dilutions.",
      Category -> "Sample Preparation"
    },
    QuantitationStandardFixedDilutionsPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->(Object[Container,Plate] | Model[Container,Plate]|Model[Container, Vessel]|Object[Container, Vessel]),
      Description->"The plate(s) which are used to prepare dilution series which include a dilution with volumes larger than 250 Microliter.",
      Category -> "General"
    },
    QuantitationStandardSerialDilutions -> {
      Format -> Multiple,
      Class -> {Real, Real, Expression},
      Pattern :> {GreaterEqualP[0*Microliter], GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]},
      Units-> {Microliter, Microliter, None},
      Description -> "The list of dilutions of QuantitationStandardSolution with QuantitationStandardDiluent. These serial dilutions are used to create a standard curve for a Quantitation assay.",
      Category->"Standard Curve",
      Headers ->{"Transfer Amount", "Diluent Volume", "Solution Name"}
    },
    QuantitationStandardSerialDilutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying the transfer of solutions to create the Quantitation standard serial dilutions.",
      Category -> "Sample Preparation"
    },
    QuantitationStandardSerialDilutionsManipulation -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol,SampleManipulation],
      Description -> "The specific subprotocol performed to create the Quantitation standard serial dilutions.",
      Category -> "Sample Preparation"
    },
    QuantitationStandardSerialDilutionsPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->(Object[Container,Plate] | Model[Container,Plate]|Model[Container, Vessel]|Object[Container, Vessel]),
      Description->"The plate(s) which are used to prepare dilution series which include a dilution with volumes larger than 250 Microliter.",
      Category -> "General"
    },
    QuantitationEnzyme -> {
      Format->Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "The solution containing an enzyme used to amplify the singal from a bound analyte.",
      Category -> "General"
    },
    QuantitationEnzymeStorageCondition->{
      Format->Single,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal),
      Description->"The storage condition under which QuantitationEnzyme should be stored after its usage in the experiment.",
      Category->"Sample Storage"
    },


    (* ----------------------- *)
    (* --- EPITOPE BINNING --- *)
    (* ----------------------- *)

    BinningType -> {
      Format -> Single,
      Class -> Expression,
      Pattern:> Alternatives[PreMix, Sandwich,Tandem],
      Description -> "The assay configuration for EpitopeBinning.",
      Category -> "General"
    },
    AntigenSolution -> {
      Format->Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "The solution containing antigen used in an epitope binning assay and to create PreMix solutions.",
      Category->"Sample Preparation"
    },
    AntigenSolutionStorageCondition->{
      Format->Single,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal),
      Description->"The storage condition under which AntigenSolution should be stored after its usage in the experiment.",
      Category->"Sample Storage"
    },
    PreMixDiluent -> {
      Format->Single,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description-> "The solution used to lower the concentration in generating PreMix solutions used in some epitope binning assays.",
      Category->"Sample Preparation"
    },

    PreMixSolutions -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {GreaterEqualP[0*Microliter], GreaterEqualP[0*Microliter], GreaterEqualP[0*Microliter], Alternatives[_String,ObjectP[{Model[Sample], Object[Sample]}]]},
      Description -> "For each member of SamplesIn, the PreMix solutions required to perform a PreMix type Epitope Binning assay. The Antibody solutions are the input samples, and the solution is referred to in the AssayStepPrimitives by the Solution Name. The form of this field is: {Antibody Amount, Antigen Amount, Diluent Amount, Solution Name}, where Solution Name is the string used to reference this solution in the AssayPrimitives.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    PreMixSolutionsPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (SampleManipulationP|SamplePreparationP),
      Description -> "Instructions specifying the PreMix solution preparation.",
      Category -> "Sample Preparation"
    },



    (* ------------------------ *)
    (* --- Assay Definition --- *)
    (* ------------------------ *)

    InitialSequence->{
      Format->Single,
      Class->Expression,
      Pattern:>{BLIPrimitiveNameP..},
      Description->"The sequential list of assay steps which are performed for the first sample measured by a given probe.",
      Category -> "General"
    },
    RepeatedSequence->{
      Format->Single,
      Class->Expression,
      Pattern:>{BLIPrimitiveNameP..},
      Description->"The sequential list of assay steps which are repeated using the same probe for each requested sample or standard.",
      Category -> "General"
    },
    AssayPrimitives->{
      Format->Single,
      Class->Expression,
      Pattern:>{ValidBLIPrimitiveP..},
      Description->"The sequential list of every assay step performed in this protocol.
      PreMix solutions, and dilution series used for quantitation standard curves or kinetics association may be referred to by their solution name, as assigned in the PreMixSolutions, AnalyteDilutions, or QuantitationStandardDilutions fields.
      When prepared as indicated in their respective sample manipulation primitives, these solutions appear as Objects.",
      Category -> "General"
    },
    AssayOverview->{
      Format ->Multiple,
      Class -> {Integer, Integer, Integer, Integer, Expression},
      Pattern:>{GreaterP[0,1], GreaterP[0,1], RangeP[1,12,1], RangeP[1,12,1], BLIPrimitiveNameP},
      Description ->"The bio-probe, assay number, and assay plate column associated with each assay step.",
      Category -> "General",
      Headers ->{"Assay Number","Assay Step","Plate Column Number","Probe Number","Step Type"}
    },
    PlateLayout -> {
      Format -> Multiple,
      Class -> {Expression, Expression, Expression, Expression, Expression, Expression, Expression, Expression},
      Pattern :> {(ObjectP[{Object[Sample], Model[Sample]}]|_String), (ObjectP[{Object[Sample], Model[Sample]}]|_String), (ObjectP[{Object[Sample], Model[Sample]}]|_String),
        (ObjectP[{Object[Sample], Model[Sample]}]|_String), (ObjectP[{Object[Sample], Model[Sample]}]|_String),(ObjectP[{Object[Sample], Model[Sample]}]|_String),
        (ObjectP[{Object[Sample], Model[Sample]}]|_String), (ObjectP[{Object[Sample], Model[Sample]}]|_String)},
      Description -> "The layout of solutions in the assay plate, grouped by column. Nulls represent empty wells.",
      Headers->{"A","B","C","D","E","F","G","H"},
      Category->"Sample Preparation"
    },


    (* ------------------------ *)
    (* --- DEVELOPER FIELDS --- *)
    (* ------------------------ *)

    ObjectsManifest -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
      Description -> "A list of objects which occupy wells in the assay or probe rack plate. After UploadProtocol, this will serve as Key with ResourcesManifest as the values to populate the primitives with the resourced objects.",
      Category->"Sample Preparation",
      Developer -> True
    },
    OriginalSamplesIn -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
      Description -> "The original SamplesIn, used to populate the PlateLayout and primitives after the WorkingSamples are made.",
      Category -> "Sample Preparation",
      Developer -> True
    },
    ResourcesManifest -> {
      Format -> Multiple,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[
        Model[Sample],
        Object[Sample]
      ],
      Description -> "A list of resourced objects which occupy wells in the assay or probe rack plate. After UploadProtocol, this will serve as the Values with ObjectsManifest to populate the primitive with resource objects.",
      Category->"Sample Preparation",
      Developer -> True
    },


    (* ------------------------------ *)
    (* --- Sample Post-Processing --- *)
    (* ------------------------------ *)

    SaveAssayPlate -> {
      Format -> Single,
      Class -> Expression,
      Pattern:> BooleanP,
      Description -> "Indicates if the assay plate was saved or discarded after the assay was completed.",
      Category -> "Sample Post-Processing"
    },
    RecoupSample -> {
      Format->Multiple,
      Class->Expression,
      Pattern:> BooleanP,
      Description-> "For each member of SamplesIn, indicates if the samples used in this experiment are transferred back into the original container upon completion of the assay.",
      Category->"Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    RecoupSamplePrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> {(SampleManipulationP|SamplePreparationP)...},
      Description -> "For each member of SamplesIn, instructions specifying the transfer of the sample back into the original container after completion of the assay.",
      Category -> "Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    RecoupSampleManipulation -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation],
      Description -> "For each member of SamplesIn, the specific subprotocol performed to transfer the sample back into the origin container after completion of the assay.",
      Category -> "Sample Post-Processing",
      IndexMatching -> SamplesIn
    },


    (* -------------------------- *)
    (* -------- General --------- *)
    (* -------------------------- *)

    MethodFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path of the folder containing the protocol file which contains the experiment parameters.",
      Category -> "General",
      Developer -> True
    },
    MethodFileName -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The name of the protocol file containing the experiment parameters.",
      Category -> "General",
      Developer -> True
    },
    DataFilePath -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path of the folder containing the data file generated at the conclusion of the experiment.",
      Category -> "General",
      Developer -> True
    },
    DataFileName -> {
      Format -> Single,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path of the data file generated at the conclusion of the experiment.",
      Category -> "General",
      Developer -> True
    },
    InstrumentRunTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Minute],
      Units -> Minute,
      Description -> "The estimated amount of time it will take for the assay to run.",
      Category -> "General",
      Developer -> True
    },
    ProbesUsed -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0],
      Description -> "The number of probes that will be used during this assay.",
      Category -> "General",
      Developer -> True
    },


    (* ---------------------------- *)
    (* --- Experimental Results --- *)
    (* ---------------------------- *)

    MethodFile->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[EmeraldCloudFile],
      Description -> "The file containing the run information.",
      Category -> "Experimental Results"
    },
    DataFile -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation->Object[EmeraldCloudFile],
      Description -> "The file containing the unprocessed data generated by the instrument.",
      Category -> "Experimental Results"
    }
  }
}];