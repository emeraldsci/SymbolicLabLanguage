(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,IRSpectroscopy],{
  Description->"A protocol for measuring the Infrared spectrum of a sample by means of a spectrophotometer.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    Instrument->{ (*the instrument resource*)
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument,Spectrophotometer],
        Object[Instrument,Spectrophotometer]
      ],
      Description -> "The spectrophotometer devices used to perform Infrared measurement.",
      Category -> "Absorbance Measurement"
    },
    Blanks->{ (*Blank resources*)
      Format->Multiple,
      Class->Link,
      Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
      Relation->Object[Sample]|Model[Sample],
      Description->"For each member of SamplesIn, the samples whose background will be subtracted from the corresponding sample spectrum.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    BlankAmounts -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> (RangeP[1 Microliter, 500 Microliter]|RangeP[1 Milligram, 500 Milligram]),
      Units -> None,
      Description -> "For each member of SamplesIn, the amount of Blanks that was used to subtract an Infrared background from the SamplesIn spectrum.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    PressBlank -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Units -> None,
      Description -> "For each member of SamplesIn, specifies whether pressure is applied to the Blanks sample through measurement.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    BlankContainerPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (Null|SampleManipulationP),
      Description -> "For each member of SamplesIn, instructions specifying the transfers of blanking solution onto the measurement apparatus in order to subtract from the sample spectrum.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    BlankContainerManipulations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "For each member of SamplesIn, the specific subprotocol performed to transfer the blanking solution onto the measurement apparatus in order to subtract from the sample spectrum.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SampleAmount -> {
      Format -> Multiple,
      Class -> VariableUnit,
      Pattern :> (RangeP[1 Microliter, 500 Microliter]|RangeP[1 Milligram, 500 Milligram]),
      Units -> None,
      Description -> "For each member of SamplesIn, the amount that was loaded onto the instrument for measurement.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    PressSample -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Units -> None,
      Description -> "For each member of SamplesIn, specifies whether pressure is applied to the sample through measurement.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SampleContainerPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (Null|SampleManipulationP),
      Description -> "For each member of SamplesIn, instructions each specifying the transfer of samples onto the measurement apparatus.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SampleContainerManipulations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "For each member of SamplesIn, the specific subprotocol performed to transfer samples onto the measurement apparatus.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SuspensionSolutions->{ (*Suspension solution resources*)
      Format->Multiple,
      Class->Link,
      Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
      Relation->Object[Sample]|Model[Sample],
      Description->"A solution added to the sample in order to make a slurry before spectroscopy measurement.",
      Category->"Sample Preparation"
    },
    SuspensionSolutionVolume -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> RangeP[1 Microliter, 500 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the amount of a liquid that was added to the sample in order to make a slurry before measurement.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SuspensionSolutionPrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (Null|SampleManipulationP),
      Description -> "For each member of SamplesIn, instructions specifying the transfer of solution onto the sample to mix into a slurry prior to measurement.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    SuspensionSolutionManipulations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "For each member of SamplesIn, the specific subprotocol performed to transfer a solution onto the sample to mix into a slurry prior to measurement.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    LoadingSamples->{
      Format->Multiple,
      Class->{
        Blanks->Link,
        Sample->Link,
        SuspensionSolutions->Link
      },
      Pattern:>{
        Blanks->ObjectP[{Object[Sample]}],
        Sample->ObjectP[{Object[Sample]}],
        SuspensionSolutions->ObjectP[{Object[Sample]}]
      },
      Relation->{
        Blanks->Object[Sample],
        Sample->Object[Sample],
        SuspensionSolutions->Object[Sample]
      },
      Description->"For each member of SamplesIn, the temporary samples taken from SamplesIn, Blanks, and/or SuspensionSolutions that were placed onto the instrument for measurement and consequently disposed or recouped.",
      Category->"Sample Preparation",
      IndexMatching -> SamplesIn
    },
    Balance -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Instrument],
        Model[Instrument]
      ],
      Description -> "The preferred device used to weigh any samples.",
      Category -> "Sample Preparation",
      Developer -> True
    },
	DataFilePaths -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> FilePathP,
		Description -> "For each member of SamplesIn, the file paths where the processed diffraction data files are located.",
		Category -> "General",
		IndexMatching -> SamplesIn,
		Developer -> True
	},
	MethodFilePaths -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> FilePathP,
		Description -> "For each member of SamplesIn, the file paths where the method information are located.",
		Category -> "General",
		IndexMatching -> SamplesIn,
		Developer -> True
	},
    MinWavenumber-> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0* 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "For each member of SamplesIn, the minimum wavenumber of the absorbance spectrum. Might be converted from MaxWavelength.",
      Category -> "Absorbance Measurement",
      IndexMatching -> SamplesIn
    },
    MaxWavenumber-> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0* 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "For each member of SamplesIn, the maximum wavenumber of the absorbance spectrum. Might be converted from MinWavelength.",
      Category -> "Absorbance Measurement",
      IndexMatching -> SamplesIn
    },
    WavenumberResolution-> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0* 1/Centimeter],
      Units -> 1/Centimeter,
      Description -> "For each member of SamplesIn, the grading of the wavenumbers measured from MinWavenumber to MaxWavenumber.",
      Category -> "Absorbance Measurement",
      IndexMatching -> SamplesIn
    },
    NumberOfReadings -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "For each member of SamplesIn, the number of readings taken and averaged in order to record each data point.",
      Category -> "Absorbance Measurement",
      IndexMatching -> SamplesIn
    },
    IntegrationTime -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Second],
      Units -> Second,
      Description -> "For each member of SamplesIn, the amount of time the measurement occurs and is averaged over.",
      Category -> "Absorbance Measurement",
      IndexMatching -> SamplesIn
    },
    ExportDirectory -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "For each member of SamplesIn, the file path to where the macro and data were stored.",
      Category -> "Experimental Results",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    RecoupSample->{
      Format->Multiple,
      Class->Boolean,
      Pattern:>BooleanP,
      Description->"For each member of SamplesIn, specifies whether the sample should be recovered back into the container after measurement.",
      Category->"Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    RecoupSamplePrimitives -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> (Null|SampleManipulationP),
      Description -> "For each member of SamplesIn,instructions specifying the transfer of the sample back into the origin container after measurement.",
      Category -> "Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    RecoupSampleManipulations -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Protocol],
      Description -> "For each member of SamplesIn, the specific subprotocol performed to transfer the sample back into the origin container after measurement.",
      Category -> "Sample Post-Processing",
      IndexMatching -> SamplesIn
    },
    BlankData -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Data][Protocol],
      Description -> "For each member of SamplesIn, the data associated with Blanks by this protocol.",
      Category -> "Experimental Results",
      IndexMatching -> SamplesIn
    }
  }
}];
