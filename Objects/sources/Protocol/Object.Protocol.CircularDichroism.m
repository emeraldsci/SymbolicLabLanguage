

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, CircularDichroism], {
	Description->"A protocol for measuring the circular dichroism spectroscopy or intensities using the plate well in a plate reader.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PreparedPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the input plates have been prepared prior to the start of the experiment. If False, the sample will be transferred to the 'ReadPlate' for Data Collection.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument], Model[Instrument]
			],
			Description -> "The instrument used to measure the circular dichroism of samples.",
			Category -> "CircularDichroism Measurement",
			Abstract -> True
		},
		ReadPlate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Plate]|Model[Container,Plate],
			Description->"The 96-well plate holding all samples for a circular dichroism experiment loaded onto the instrument.",
			Category->"Sample Preparation"
		},
		SampleVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Liter Milli,
			Description -> "For each member of SamplesIn, the volume in the well or the amount of sample that was aliquoted into the ReadPlate.",
			Category -> "Sample Preparation",
			IndexMatching->SamplesIn
		},
		NumberOfReadings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of SamplesIn, the number of redundant readings taken by the detector and averaged over per each well.",
			Category -> "Optics",
			IndexMatching->SamplesIn
		},
		MinWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0Nanometer],
			Units->Nanometer,
			Description->"The minimum wavelength at which absorbance differences of the right-handed and left-handed circular polarized light was acquired.",
			Category->"Optics"
		},
		MaxWavelengths->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0Nanometer],
			Units->Nanometer,
			Description->"The maximum wavelength at which absorbance differences of the right-handed and left-handed circular polarized light was acquired.",
			Category->"Optics"
		},
		Wavelengths-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :>{({GreaterP[0 Nanometer] ..} | GreaterP[0 Nanometer] | Null) ..},
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the selected wavelengths at which sample's circular dichroism intensity is measured.",
			Category->"Optics"
		},
		StepSizes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the value of how often the spectrophotometer will record a circular dichroism absorbance measurement if the sample was scanned in a range of wavelength.",
			Category -> "Optics",
			IndexMatching->SamplesIn
		},
		PathLengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Millimeter,
			Description -> "For each member of SamplesIn, the distance light will travel from entering the sample to exiting it.",
			Category -> "Optics",
			IndexMatching->SamplesIn
		},
		(*---Plate specifie parameters---*)
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The plate path the instrument follows as it measures absorbance in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			Category -> "Optics"
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement to decrease evaporation.",
			Category -> "Optics"
		},
		PlateCover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Lid],
				Object[Item,Lid]
			],
			Description -> "The plate lid on the ReadPlate that is left on during reads to decrease evaporation. It is strongly recommended not to retain a cover because CircularDichroism can only read from top.",
			Category -> "Optics"
		},
		PlateSeal->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item],Object[Item]],
			Description->"The self-adhesive seal used to cover the Sample if it is a plate after Sample Preparation.",
			Category->"Sample Preparation",
			Developer->True
		},
		ReadPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move assay plates into the plate reader.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		AverageTime->{
			Format ->Single,
			Class-> Real,
			Pattern:> RangeP[0.06 Second, 18 Second],
			Units -> Second,
			Category-> "Optics",
			Description -> "The time on data collection for each measurment points. The collected data are averaged for this period of time and export as the result data point for this wavelength."
		},
		SamplesInWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of SamplesIn, the well on the read plate.",
			Category -> "General",
			IndexMatching->SamplesIn,
			Developer -> True
		},
		BlankWellToReference ->{
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of SamplesIn, the well on the read plate that used as the blank well.",
			Category -> "General",
			IndexMatching->SamplesIn,
			Developer -> True
		},
		NitrogenPurge->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if a weak nitron flow will purge the instrument during the data collection.",
			Category -> "Experimental Results",
			Developer -> True
		},
		(*--- Moat ---*)
		MoatSize -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of concentric perimeters of wells leave as blacnk or filled with MoatBuffer in order to avoid using those wells for the measurment and slow evaporation of inner assay samples.",
			Category -> "General"
		},
		MoatBuffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
			Category -> "General"
		},
		MoatVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Microliter,
			Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
			Category -> "General"
		},
		(*---Empty---*)
		EmptyWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "The wells on the read plate used for empty scan.",
			Category -> "General",
			Developer -> True
		},
		(*--- Blank ---*)
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SamplesIn, the model or sample used to generate a blank sample whose absorbance will be subtracted as background.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		BlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Microliter],
			Units -> Microliter,
			Description -> "For each member of Blanks, the volume of that sample that should be used for blank measurements.",
			Category -> "General",
			IndexMatching -> Blanks
		},
		UniqueBlanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The unique model or sample that will be transfer to ReadPlate and run during the measurement.",
			Category -> "General"
		},
		UniqueBlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of UniqueBlanks, the volume that aspirated into the desired wells on the read plate used for blanks.",
			IndexMatching -> UniqueBlanks,
			Category -> "General"
		},
		BlankWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of UniqueBlanks, the wells on the read plate used for blanks.",
			Category -> "General",
			IndexMatching -> UniqueBlanks,
			Developer -> True
		},
		ReadPlatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of all samples (SamplesIn, Blank and MoatBuffer) into desired wells.",
			Category -> "General",
			Developer -> True
		},
		ReadPlateManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation] | Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation] | Object[Notebook, Script],
			Description -> "The sample manipulations protocol used to transfer buffer into the ReadPlate.",
			Category -> "General"
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "The estimated amount of time remaining until when the current round of instrument processing is projected to finish.",
			Category -> "General",
			Units -> Minute,
			Developer -> True
		},
		CalculatingMolarEllipticitySpectrum->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicate the collected Ellipticity will be transferred to MolarEllipticity spectrum.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description -> "For each member of SamplesIn, the substance which its properties (enatiomeric excess or the 2nd structure composition) is analyzed from the dircular dichroism data.",
			IndexMatching -> SamplesIn,
			Category -> "Data Processing"
		},
		AnalyteConcentrations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Molar],
			Units->Micromolar,
			Description -> "For each member of SamplesIn, the known concentration of the analyte in the sample that is recorded.",
			IndexMatching -> SamplesIn,
			Category -> "Data Processing"
		},
		(*Enatiomeric Excess Masurement*)
		EnantiomericExcessMeasurement -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate the data from this measurement will be used to calculate the enantiomeric excess value of each of the sample.",
			Category -> "Enantiomeric Excess Measurement"
		},
		EnantiomericExcessWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Nanometer],
			Units->Nanometer,
			Description -> "The wavelength will be used to determined enantiomeric excess of SamplesIn.",
			Category -> "Enantiomeric Excess Measurement"
		},
		EnantiomericExcessStandards-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Input samples with a known enantiomeric excess values. Preferrable to be optical pure samples.",
			Category -> "Enantiomeric Excess Measurement"
		},

		EnantiomericExcessStandardValues-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[Percent],
			Units->Percent,
			Description -> "For each member of EnantiomericExcessStandards, the known enantiomeric excess value of the sample.",
			Category -> "Enantiomeric Excess Measurement",
			IndexMatching->EnantiomericExcessStandards
		},
		EnantiomericExcessStandardWells-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> WellP,
			Description -> "For each member of EnantiomericExcessStandards, the wells on the read plate used.",
			Category -> "Enantiomeric Excess Measurement",
			IndexMatching->EnantiomericExcessStandards,
			Developer -> True
		},
		EnantiomericExcessStandardTable->{
			Format->Multiple,
			Class->{Real,Real,Real},
			Pattern :> {GreaterEqualP[0 Nanometer], RangeP[-100 Percent, 100 Percent],UnitsP[0 AngularDegree]},
			Headers->{"Wavelengths","Enantiomeric Excess Value","Circular Dichroism Value"},
			Units->{Nanometer,Percent, AngularDegree Milli},
			IndexMatching->EnantiomericExcessStandards,
			Description -> "For each member of EnantiomericExcessStandards, the table of information for the standards used in the EnantiomericExcess measurments.",
			Category -> "Enantiomeric Excess Analysis"
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The absorbance data collected from the well with buffer alone.",
			Category -> "Experimental Results"
		},
		EmptyData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The absorbance data collected from the well with an empty well.",
			Category -> "Experimental Results"
		},
		(*---SampleTransferOut---*)
		SampleRecoveryPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP | SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of all samples (SamplesIn, Blank and MoatBuffer) from the Readplate to the ContainerOut.",
			Category -> "General",
			Developer -> True
		},
		SampleRecoveryManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation]|Object[Protocol, ManualSamplePreparation],
			Description -> "The sample manipulations protocol used to transfer samples from the ReadPlate to the ContainerOut.",
			Category -> "General"
		},
		(*---Cleaning ---*)
		FumeHood->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"The fume hood used to conduct clean up of the ReadPlate.",
			Category->"Cleaning",
			Developer -> True
		},
		HandWashReadPlate->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if the ReadPlate will need to be handwash, this is requred is the ReadPlate is made by quartz.",
			Category -> "Cleaning",
			Developer -> True
		},
		(*---Exporter/Importer Files---*)
		MethodFileName->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The name of the macro file with the run parameters.",
			Category->"General",
			Developer->True
		},
		MethodFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The methods file containing the run parameters for all samples in protocol.",
			Category->"General"
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the data file generated at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		ExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to convert and export data gathered by the instrument to the network drive.",
			Category -> "General",
			Developer -> True
		},
		ImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the import script file used to transfer raw data file to the network drive.",
			Category -> "General",
			Developer -> True
		}

	}
}];
