(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* NOTE: If you're doing this, make sure that any files that use these $ shared fields are loaded AFTER this file, otherwise *)
(* you will get load errors. The Packager loads files from the UnitOperation/ folder alphabetically. *)
$ObjectUnitOperationPlateReaderBaseFields = {
	SampleLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample],
			Model[Container],
			Object[Container]
		],
		Description -> "The input substances whose absorbances are measured at specified wavelengths within a microfluidic chip, cuvette, or well plate.",
		Category -> "General",
		Migration->SplitField
	},
	SampleString -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Relation -> Null,
		Description -> "For each member of SampleLink, the input substances whose absorbances are measured at specified wavelengths within a microfluidic chip, cuvette, or well plate.",
		Category -> "General",
		IndexMatching -> SampleLink,
		Migration->SplitField
	},
	SampleExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
		Relation -> Null,
		Description -> "For each member of SampleLink, the samples that are being read.",
		Category -> "General",
		IndexMatching -> SampleLink,
		Migration->SplitField
	},
	SampleLabel -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Relation -> Null,
		Description -> "For each member of SampleLink, a user defined word or phrase used to identify the samples whose absorbances are measured in this assay for identification in sample preparation.",
		Category -> "General",
		IndexMatching -> SampleLink
	},
	SampleContainerLabel -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Relation -> Null,
		Description -> "For each member of SampleLink, a user defined word or phrase used to identify the source container that is being used in the experiment for identification in sample preparation.",
		Category -> "General",
		IndexMatching -> SampleLink
	},
	TemperatureReal->{
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterP[0 Celsius],
		Units->Celsius,
		Description -> "Indicates the temperature the samples will be held at prior to and during data acquisition within the instrument.",
		Category -> "General",
		Migration->SplitField
	},
	TemperatureExpression -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> Ambient,
		Description -> "Indicates the temperature the samples will held at prior to and during data acquisition within the instrument.",
		Category -> "General",
		Migration->SplitField
	},
	EquilibrationTime->{
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Minute],
		Units -> Minute,
		Description->"The length of time for which the samples incubate at the requested temperature prior to measuring the absorbance.",
		Category -> "Sample Handling"
	},
	TargetCarbonDioxideLevel -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Percent],
		Units -> Percent,
		Description -> "The target amount of carbon dioxide in the atmosphere in the plate reader chamber.",
		Category -> "Sample Handling"
	},
	TargetOxygenLevel -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Percent],
		Units -> Percent,
		Description -> "The target amount of oxygen in the atmosphere in the plate reader chamber. If specified, nitrogen gas is pumped into the chamber to force oxygen in ambient air out of the chamber until the desired level is reached.",
		Category -> "Sample Handling"
	},
	AtmosphereEquilibrationTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Minute],
		Units -> Minute,
		Description -> "The length of time for which the samples equilibrate at the requested oxygen and carbon dioxide level before being read.",
		Category -> "Sample Handling"
	},
	ReadDirection -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> ReadDirectionP,
		Description -> "The patterned path the instrument follows as it measures the absorbance of each plate well (i.e. sequential readings through a row or column). Refer to Figure 3.2 in ExperimentAbsorbanceSpectroscopy.",
		Category -> "General"
	},
	PrimaryInjectionSampleLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample],
			Object[Container],
			Model[Container]
		],
		Description->"For each member of SampleLink, the sample to be injected in the first round of injections in order to introduce a time sensitive reagent/sample into the plate before/during plate reader measurement.",
		IndexMatching -> SampleLink,
		Category -> "Injections",
		Migration->SplitField
	},
	PrimaryInjectionSampleExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> _String,
		Description->"For each member of SampleLink, the sample to be injected in the first round of injections in order to introduce a time sensitive reagent/sample into the plate before/during plate reader measurement.",
		IndexMatching -> SampleLink,
		Category -> "Injections",
		Migration->SplitField
	},
	SecondaryInjectionSampleLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample],
			Object[Container],
			Model[Container]
		],
		Description->"For each member of SampleLink, the sample to be injected in the second round of injections in order to introduce a time sensitive reagent/sample into the plate before/during plate reader measurement.",
		IndexMatching -> SampleLink,
		Category -> "Injections",
		Migration->SplitField
	},
	SecondaryInjectionSampleExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> _String,
		Description->"For each member of SampleLink, the sample to be injected in the second round of injections in order to introduce a time sensitive reagent/sample into the plate before/during plate reader measurement.",
		IndexMatching -> SampleLink,
		Category -> "Injections",
		Migration->SplitField
	},
	PrimaryInjectionVolume -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Microliter],
		Units -> Microliter,
		Description->"For each member of SampleLink, the amount of the primary sample injected into the plate during the first round of injections.",
		IndexMatching -> SampleLink,
		Category -> "Injections"
	},
	SecondaryInjectionVolume -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Microliter],
		Units -> Microliter,
		Description->"For each member of SampleLink, the amount of the secondary sample injected into the plate during the second round of injections.",
		IndexMatching -> SampleLink,
		Category -> "Injections"
	},
	PrimaryInjectionFlowRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
		Units -> (Liter Micro)/Second,
		Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the first round of injection.",
		Category -> "Injections"
	},
	SecondaryInjectionFlowRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
		Units -> (Liter Micro)/Second,
		Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the first round of injection.",
		Category -> "Injections"
	},
	Line1PrimaryPurgingSolvent -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description ->"The primary solvent with which the line 1 injector is washed before and after running the experiment.",
		Category -> "Injector Cleaning"
	},
	Line1SecondaryPurgingSolvent -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "The secondary solvent with which the line 1 injector is washed before and after running the experiment.",
		Category -> "Injector Cleaning"
	},
	Line2PrimaryPurgingSolvent -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "The primary solvent with which the line 2 injector is washed before and after running the experiment.",
		Category -> "Injector Cleaning"
	},
	Line2SecondaryPurgingSolvent -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "The secondary solvent with which the line 2 injector is washed before and after running the experiment.",
		Category -> "Injector Cleaning"
	},

	PlateReaderMix -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> BooleanP,
		Description -> "Indicates if the assay plate is agitated inside the plate reader chamber prior to measurement.",
		Category -> "Mixing"
	},
	PlateReaderMixRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*RPM],
		Units -> RPM,
		Description -> "The frequency at which the plate is agitated inside the plate reader chamber prior to measurement.",
		Category -> "Mixing"
	},
	PlateReaderMixTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Second],
		Units -> Second,
		Description -> "The length of time for which the plate is agitated inside the plate reader chamber prior to measurement.",
		Category -> "Mixing"
	},
	PlateReaderMixMode -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> MechanicalShakingP,
		Description -> "The shaking motion which should be used to mix the plate.",
		Category -> "Mixing"
	},
	SamplingPattern -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> PlateReaderSamplingP,
		Description -> "Specifies the pattern or set of points that are sampled within each well and averaged together to form a single data point. Ring indicates measurements will be taken in a circle concentric with the well with a diameter equal to the SamplingDistance. Spiral indicates readings will spiral inward toward the center of the well. Matrix reads a grid of points within a circle whose diameter is the SamplingDistance.",
		Category -> "Optics"
	},
	SamplingDistance -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Millimeter],
		Units -> Millimeter,
		Description -> "When SamplingPattern->Matrix, SamplingDistance is the length of the square that will be measured within the well diameter; SamplingDimension is an integer representing the number of squares forming a grid within the SamplingDistance.",
		Category -> "Optics"
	},
	RetainCover -> {
		Format -> Single,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement thereby decreasing evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover. When using the Cuvette Method, automatically set to True.",
		Category -> "General"
	}
};

$ObjectUnitOperationAbsorbanceSpectroscopyFields={
	Methods -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> AbsorbanceMethodP,
		Description -> "Indicates the type of vessel used to measure the absorbance of the samples. PlateReaders utilize an open well container where light traverses from top to bottom. Cuvette uses a square container with transparent sides where light traverses from the front to back at a fixed path length. Microfluidic uses small channels to load samples which are then gravity-driven towards chambers where light traverses from top to bottom and measured at a fixed path length.",
		Category -> "General"
	},
	Instrument -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Instrument, PlateReader],
			Object[Instrument, PlateReader],
			Object[Instrument,Spectrophotometer],
			Model[Instrument,Spectrophotometer]
		],
		Description -> "The instrument to shine light through the sample and measure the absorbance according to AbsorbanceMethod.",
		Category -> "General"
	},
	NumberOfReadings -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterEqualP[0, 1],
		Units -> None,
		Description -> "Number of redundant readings taken by the detector to determine a single averaged absorbance reading.",
		Category -> "General"
	},
	BlankAbsorbance -> {
		Format -> Single,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description->"Indicates if blank samples are prepared to account for the background signal when reading absorbance of the assay samples.",
		Category -> "Data Processing"
	},
	BlankLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "For each member of SampleLink, the model or sample used to generate a blank sample whose measurement will be subtracted as background.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink,
		Migration -> SplitField
	},
	SpectralBandwidth ->{
		Format->Single,
		Class->Real,
		Pattern:>GreaterP[0 Nanometer],
		Units->Nanometer,
		Description->"Indicates the physical size of the slit from which light passes out from the monochromator. The narrower the bandwidth, the greater the resolution in measurements.",
		Category->"Absorbance Measurement"
	},
	AcquisitionMix -> {
		Format -> Multiple,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description -> "For each member of SampleLink, indicates if the samples within the cuvette is mixed with a stir bar during data acquisition.",
		IndexMatching -> SampleLink,
		Category -> "Absorbance Measurement"
	},
	AcquisitionMixRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterP[0 RPM],
		Units -> RPM,
		Description -> "Indicates the rate at which the instrument rotates the magnetic driver while mixing the samples during data acquisition.",
		Category -> "Absorbance Measurement"
	},
	AdjustMixRate -> {
		Format -> Single,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description -> "When using a stir bar, if specified AcquisitionMixRate does not provide a uniform or consistent circular rotation of the magnetic bar, indicates if mixing should continue up to MaxStirAttempts in attempts to stir the samples. If stir bar is wiggling, decrease AcquisitionMixRate by AcquisitionMixRateIncrements and check if the stir bar is still wiggling. If it does, decrease by AcquisitionMixRateIncrements again. If still wiggling, repeat decrease process until MaxStirAttempts. If the stir bar is not moving/stationary, increase the AcquisitionMixRate by AcquisitionMixRateIncrements and check if the stir bar is still stationary. If it does, increase by AcquisitionMixRateIncrements again. If still stationary, repeat increase process until MaxStirAttempts. Mixing will occur during data acquisition.",
		Category -> "Absorbance Measurement"
	},
	MinAcquisitionMixRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 RPM],
		Description -> "Sets the lower limit the stirring rate is decreased to for sample mixing in the cuvette when attempting to mix the samples with a stir bar.",
		Category -> "Absorbance Measurement"
	},
	MaxAcquisitionMixRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*RPM],
		Description -> "Sets the upper limit the stirring rate is increased to for sample mixing in the cuvette when attempting to mix the samples with a stir bar.",
		Category -> "Absorbance Measurement"
	},
	AcquisitionMixRateIncrements -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*RPM],
		Description -> "Indicates the value to increase or decrease the mixing rate by in a stepwise fashion while attempting to mix the samples with a stir bar.",
		Category -> "Absorbance Measurement"
	},
	MaxStirAttempts -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterEqualP[1,1],
		Description -> "Indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt).",
		Category -> "Absorbance Measurement"
	},
	StirBar -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Part,StirBar],
			Object[Part,StirBar]
		],
		Description -> "For each member of SampleLink, indicates the stir bar inserted into the cuvette to mix the sample during data acquisition.",
		IndexMatching -> SampleLink,
		Category -> "Absorbance Measurement"
	},
	TemperatureMonitor -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> TemperatureMonitorTypeP,
		Description -> "The integrated detector on the spectrophotometer used to monitor temperature during the experiment. Possibilities include 'CuvetteBlock', indicating that a temperature sensor in the heater/chiller block will be monitored, and 'ImmersionProbe', indicating that a temperature sensor in a buffer-filled cuvette will be monitored.",
		Category -> "Absorbance Measurement"
	},
	BlankMeasurement -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> BooleanP,
		Description->"Indicates if a corresponding blank measurement, which consists of a separate container (well, chamber, or cuvette) than the input sample is in, will be performed prior to measuring the absorbance of the input samples. If using Cuvettes, the BlankAbsorbance will be read simultaneously with the input samples. In Microfluidic and well, it will include a list of blanks with the samples that are read.",
		Category -> "Data Processing"
	},
	BlanksLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "For each member of SampleLink, the object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SampleLink.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink,
		Migration -> SplitField
	},
	BlanksString -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Description -> "For each member of SampleLink, the object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SampleLink.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink,
		Migration -> SplitField
	},
	BlankVolumes -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterP[0 * Microliter],
		Units -> Microliter,
		Description -> "For each member of BlanksLink, the volume of the sample that should be used for blank measurements.",
		Category -> "Data Processing",
		IndexMatching -> BlanksLink
	},
	BlankData -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Data],
		Description -> "For each member of BlanksLink, the absorbance data collected from the well, chamber, or cuvette with buffer alone.",
		Category -> "Data Processing",
		IndexMatching -> BlanksLink
	},
	BlankContainers -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Container],
			Object[Container],
			Model[Container, Cuvette],
			Object[Container, Cuvette]
		],
		Description -> "For each member of BlanksLink, indicates the container that the absorbance of BlankLink is read in. The absorbance of the blank container itself will be subtracted out of the SampleLink absorbance along with BlankLink sample.",
		Category -> "Data Processing",
		IndexMatching -> BlanksLink
	},
	SamplingDimension -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "When SamplingPattern->Matrix, SamplingDistance is the length of the square that will be measured within the well diameter; SamplingDimension is an integer representing the number of squares forming a grid within the SamplingDistance.",
		Category -> "Optics"
	},
	MoatSize -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterEqualP[0, 1],
		Units -> None,
		Description -> "The number of concentric perimeters of wells filled with MoatBuffer in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MoatBuffer -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Object[Sample],Model[Sample]],
		Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MoatVolume -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Microliter],
		Units -> Microliter,
		Description -> "The volume which each moat well is filled with in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MicrofluidicChipLoading -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> Alternatives[Robotic, Manual],
		Description -> "Indicates if the SampleLink are loaded by a robotic liquid handler or manually into the assay container.",
		Category -> "General"
	},
	BlankLabel -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Description -> "For each member of SampleLink, the label of the object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SampleLink.",
		Category -> "General",
		IndexMatching -> SampleLink
	},
	InjectionSampleStorageCondition -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> SampleStorageTypeP|Disposal,
		Description -> "The storage conditions under which any injections samples used in this experiment are stored after their usage in this experiment.",
		Category -> "Sample Storage"
	},
	ContainerOut -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Container],
			Object[Container]
		],
		Description -> "For each member of SampleLink, the container that the samples are transferred to after the assay is completed.",
		IndexMatching -> SampleLink,
		Category -> "Sample Storage"
	},
	RecoupSample -> {
		Format -> Multiple,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description -> "For each member of SampleLink, indicates if the aliquot used to measure the absorbance should be returned to source container after each reading.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink
	}
};
$ObjectUnitOperationPlateReaderKineticInjectionFields = {
	TertiaryInjectionSample -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description->"For each member of SampleLink, the sample to be injected in the third round of injections in order to introduce a time sensitive reagent/sample into the plate before/during absorbance measurement.",
		IndexMatching -> SampleLink,
		Category -> "Injections"
	},
	QuaternaryInjectionSample -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description->"For each member of SampleLink, the sample to be injected in the fourth round of injections in order to introduce a time sensitive reagent/sample into the plate before/during absorbance measurement.",
		IndexMatching -> SampleLink,
		Category -> "Injections"
	},
	TertiaryInjectionVolume -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Microliter],
		Units -> Microliter,
		Description->"For each member of SampleLink, the amount of the tertiary sample injected in the third round of injections.",
		IndexMatching -> SampleLink,
		Category -> "Injections"
	},
	QuaternaryInjectionVolume -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0 Microliter],
		Units -> Microliter,
		Description->"For each member of SampleLink, the amount of the quaternary sample injected in the fourth round of injections.",
		IndexMatching -> SampleLink,
		Category -> "Injections"
	},
	TertiaryInjectionFlowRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
		Units -> (Liter Micro)/Second,
		Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the third round of injection.",
		Category -> "Injections"
	},
	QuaternaryInjectionFlowRate -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[(0*(Micro*Liter))/Second],
		Units -> (Liter Micro)/Second,
		Description -> "The speed at which samples are transferred from the injection containers into the assay plate during the fourth round of injection.",
		Category -> "Injections"
	},
	PrimaryInjectionTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Second],
		Units -> Minute,
		Description->"The time at which the first round of injections starts.",
		Category -> "Injections"
	},
	SecondaryInjectionTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Second],
		Units -> Minute,
		Description->"The time at which the second round of injections starts.",
		Category -> "Injections"
	},
	TertiaryInjectionTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Second],
		Units -> Minute,
		Description->"The time at which the third round of injections starts.",
		Category -> "Injections"
	},
	QuaternaryInjectionTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0 * Second],
		Units -> Minute,
		Description->"The time at which the fourth round of injections starts.",
		Category -> "Injections"
	}
};

$ObjectUnitOperationFluorescenceIntensityFields = {
	DelayTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterP[0*Microsecond],
		Units -> Microsecond,
		Description -> "The amount of time allowed to pass after excitation before fluorescence measurement begins.",
		Category -> "Fluorescence Measurement"
	},
	ReadTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterP[0*Microsecond],
		Units -> Microsecond,
		Description -> "The amount of time for which the fluorescence measurement reading occurs.",
		Category -> "Fluorescence Measurement"
	},
	Mode -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> FluorescenceModeP,
		Description -> "The type of fluorescence reading performed.",
		Category -> "Fluorescence Measurement"
	},
	WavelengthSelection -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> WavelengthSelectionP,
		Description -> "The method used to obtain the emission and excitation wavelengths.",
		Category -> "Fluorescence Measurement"
	},
	ExcitationWavelength -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description -> "The wavelengths of light used to excite the samples.",
		Category -> "Fluorescence Measurement"
	},
	EmissionWavelength -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description -> "For each member of ExcitationWavelength, the wavelengths at which fluorescence emitted from the samples is measured.",
		IndexMatching -> ExcitationWavelength,
		Category -> "Fluorescence Measurement"
	},
	DualEmissionWavelength -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description->"For each member of ExcitationWavelength, the wavelength at which fluorescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
		IndexMatching -> ExcitationWavelength,
		Category -> "Fluorescence Measurement"
	},
	Gain -> {
		Format -> Multiple,
		Class -> VariableUnit,
		Pattern :> GreaterP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
		Description->"For each member of ExcitationWavelength, the gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
		IndexMatching -> ExcitationWavelength,
		Category -> "Optics"
	},
	DualEmissionGain -> {
		Format -> Multiple,
		Class -> VariableUnit,
		Pattern :> GreaterEqualP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
		Description->"For each member of ExcitationWavelength, the gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
		IndexMatching -> ExcitationWavelength,
		Category -> "Optics"
	},
	MicrofluidicChipLoading -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> Alternatives[Robotic, Manual],
		Description -> "The loading method for microfluidic chips.",
		Category -> "General"
	}
};

$ObjectUnitOperationNephelometryFields = {
	Instrument -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Instrument, Nephelometer],
			Object[Instrument, Nephelometer]
		],
		Description -> "The Nephelometer used for this plate reader experiment step.",
		Category -> "General"
	},
	Method -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> NephelometryMethodTypeP,
		Description->"The type of experiment nephelometric measurements are collected for. CellCount involves measuring the amount of scattered light from cells suspended in solution in order to quantify the number of cells in solution. CellCountParameterizaton involves measuring the amount of scattered light from a series of diluted samples from a cell culture, and quantifying the cells by another method, such as making titers, plating, incubating, and counting colonies, or by counting with a microscope. A standard curve is then created with the data to relate cell count to nephelometry readings for future cell count quantification. For the method Solubility, scattered light from suspended particles in solution will be measured, at a single time point or over a time period. Reagents can be injected into the samples to study their effects on solubility, and dilutions can be performed to determine the point of saturation.",
		Category -> "General",
		Abstract -> True
	},
	PreparedPlate -> {
		Format -> Single,
		Class -> Boolean,
		Pattern :> BooleanP,
		Units -> None,
		Description -> "Indicates if the samples are prepared already in the assay plate and the plate is read directly without further sample preparation.",
		Category -> "Sample Preparation"
	},
	Analyte -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> IdentityModelTypeP,
		Description -> "For each member of SampleLink, the compound or cell line of interest for which solubility or cell count is determined.",
		IndexMatching -> SampleLink,
		Category -> "Sample Preparation"
	},
	Blanks -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "For each member of SampleLink, the object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SampleLink.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink,
		Migration -> SplitField
	},
	BeamAperture -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Millimeter],
		Units -> Millimeter,
		Description -> "The diameter of the opening allowing the source laser light to pass through to the samples.",
		Category -> "Optics"
	},
	BeamIntensity -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Percent],
		Units -> Percent,
		Description -> "The percentage of the total amount of the laser source light passed through to hit the samples.",
		Category -> "Optics"
	},
	QuantifyCellCount -> {
		Format -> Multiple,
		Class -> Boolean,
		Pattern :> BooleanP,
		IndexMatching -> SampleLink,
		Description -> "For each member of SampleLink, indicates if the number of cells in the samples is determined.",
		Category -> "Analysis & Reports"
	},
	InputConcentration -> {
		Format -> Multiple,
		Class -> VariableUnit,
		Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
		IndexMatching -> SampleLink,
		Description -> "For each member of SampleLink, the collection of dilutions that will be performed on the samples before nephelometric measurements are taken.",
		Category -> "Sample Preparation"
	},
	DilutionCurve -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> {GreaterEqualP[0Microliter],GreaterEqualP[0Microliter]} | {GreaterEqualP[0Microliter],GreaterEqualP[0,1]},
		IndexMatching -> SampleLink,
		Description -> "For each member of SampleLink, the collection of dilutions that will be performed on the samples before nephelometric measurements are taken.",
		Category -> "Sample Preparation"
	},
	SerialDilutionCurve -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> {GreaterEqualP[0Microliter],GreaterEqualP[0Microliter],GreaterEqualP[1,1]} | {GreaterEqualP[0Microliter], {GreaterEqualP[0, 1],GreaterEqualP[1, 1]}} | {GreaterEqualP[0Microliter], {GreaterEqualP[0, 1]...}},
		IndexMatching -> SampleLink,
		Description -> "For each member of SampleLink, the collection of dilutions that will be performed on the samples before nephelometric measurements are taken.",
		Category -> "Sample Preparation"
	},
	Diluent->{
		Format->Multiple,
		Class->Link,
		Pattern:>_Link,
		Relation->Alternatives[Object[Sample],Model[Sample]],
		Description->"For each member of SampleLink, the sample that is used to dilute the sample to a concentration series.",
		IndexMatching -> SampleLink,
		Category->"Sample Preparation"
	},

	MoatSize -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterEqualP[0, 1],
		Units -> None,
		Description -> "The number of concentric perimeters of wells filled with MoatBuffer in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MoatBuffer -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Object[Sample],Model[Sample]],
		Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MoatVolume -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Microliter],
		Units -> Microliter,
		Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	SettlingTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Second],
		Units -> Second,
		Description -> "The time between the movement of the plate and the beginning of the measurement. It reduces potential vibration of the samples in plate due to the stop and go motion of the plate carrier.",
		Category -> "Measurement"
	},
	ReadStartTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Second],
		Units -> Second,
		Description -> "The time at which nephelometry measurement readings will begin, after the plate is in position and the SettlingTime has passed.",
		Category -> "Measurement"
	},
	IntegrationTime -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterP[0 Second],
		Units -> Second,
		Description -> "The amount of time that light is measured for each reading. Higher IntegrationTime leads to higher measures of light intensity.",
		Category -> "Measurement"
	},

	PrimaryInjectionSampleStorageCondition -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> SampleStorageTypeP|Disposal,
		Description -> "The storage conditions under which the first injection sample used in this experiment should be stored after its usage in this experiment.",
		Category -> "Injections"
	},
	SecondaryInjectionSampleStorageCondition -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> SampleStorageTypeP|Disposal,
		Description -> "The storage conditions under which second injection sample used in this experiment should be stored after its usage in this experiment.",
		Category -> "Injections"
	},
	BlankMeasurement -> {
		Format -> Single,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description->"Indicates if for each SamplesIn, a corresponding blank measurement, which consists of a separate container (well or cuvette) than SamplesIn, will be performed, prior to measuring the absorbance of samples. If using Cuvettes, the BlankMeasurement will be read at the same time as the SamplesIn.",
		Category -> "Analysis & Reports"
	},
	BlankLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Sample],
			Object[Sample]
		],
		Description -> "For each member of SampleLink, the model or sample used to generate a blank sample whose measurement will be subtracted as background.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink,
		Migration -> SplitField
	},
	BlankString -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Description -> "For each member of SampleLink, the model or sample used to generate a blank sample whose measurement will be subtracted as background.",
		Category -> "Data Processing",
		IndexMatching -> SampleLink,
		Migration -> SplitField
	},
	BlankVolume -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterP[0 * Microliter],
		Units -> Microliter,
		Description -> "For each member of BlankLink, The amount of liquid of the Blank that should be transferred out and used to blank measurements. Set BlankVolume to Null to indicate blanks should be read inside their current containers.",
		Category -> "Data Processing",
		IndexMatching -> BlankLink
	},
	BlankLabel -> {
		Format -> Multiple,
		Class -> String,
		Pattern :> _String,
		Description -> "For each member of SampleLink, the label of the blank sample being used.",
		Category -> "General",
		IndexMatching -> SampleLink
	},
	BlankData -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Data],
		Description -> "For each member of BlankLink, the absorbance data collected from the well with buffer alone.",
		Category -> "Data Processing",
		IndexMatching -> BlankLink
	}
};

$ObjectUnitOperationFluorescenceMultipleBaseFields = {
	FocalHeightReal -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Meter],
		Units -> Meter Milli,
		Description -> "For each member of EmissionWavelength, The height above the assay plates from which the readings are made.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelength
	},
	FocalHeightExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> Alternatives[Auto],
		Description -> "For each member of EmissionWavelength, The height above the assay plates from which the readings are made.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelength
	},
	AdjustmentSampleExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> Alternatives[FullPlate, _String, {LocationPositionP|_Integer, ObjectP[{Model[Container], Object[Container]}]|_String}],
		Description -> "For each member of EmissionWavelength, The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelength
	},
	AdjustmentSampleLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Sample]|Model[Sample],
		Description -> "For each member of EmissionWavelength, The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelength
	},
	AdjustmentSampleIndexedMultipleIntegerLink -> {
		Format -> Multiple,
		Class -> {Integer,Link},
		Pattern :> {GreaterP[0,1], _Link | Null},
		Relation -> {Null, Object[Sample]|Model[Sample]},
		Units -> {None, None},
		Headers -> {"Index","Sample"},
		Description -> "For each member of EmissionWavelength, The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelength
	}
};

$ObjectUnitOperationFluorescenceSingleBaseFields = {
	FocalHeightReal -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Meter],
		Units -> Meter Milli,
		Description -> "The height above the assay plates from which the readings are made.",
		Migration -> SplitField,
		Category -> "Optics"
	},
	FocalHeightExpression -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> Alternatives[Auto],
		Description -> "The height above the assay plates from which the readings are made.",
		Migration -> SplitField,
		Category -> "Optics"
	},
	AdjustmentSampleExpression -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> Alternatives[FullPlate, _String, {LocationPositionP|_Integer, ObjectP[{Model[Container], Object[Container]}]|_String}],
		Description -> "The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics"
	},
	AdjustmentSampleLink -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Sample]|Model[Sample],
		Description -> "The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics"
	},
	AdjustmentSampleIndexedSingleIntegerLink -> {
		Format -> Single,
		Class -> {Integer,Link},
		Pattern :> {GreaterP[0,1], _Link | Null},
		Relation -> {Null, Object[Sample]|Model[Sample]},
		Units -> {None, None},
		Headers -> {"Index","Sample"},
		Description -> "The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics"
	}
};


$ObjectUnitOperationFluorescenceBaseFields = {
	Instrument -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Model[Instrument, PlateReader],
			Object[Instrument, PlateReader]
		],
		Description -> "The plate reader used for this plate reader experiment step.",
		Category -> "General"
	},
	InjectionSampleStorageCondition -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> SampleStorageTypeP|Disposal,
		Description -> "The storage conditions under which any injections samples used in this experiment should be stored after their usage in this experiment.",
		Category -> "Sample Storage"
	},
	NumberOfReadings -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterEqualP[0, 1],
		Units -> None,
		Description -> "The number of redundant readings taken by the detector and averaged over per each well.",
		Category -> "General"
	},
	SamplingDimension -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0,1],
		Description -> "Specifies the size of the grid used for Matrix sampling. For example SamplingDimension->3 scans a 3 x 3 grid.",
		Category -> "Fluorescence Measurement"
	},
	ReadLocation -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> ReadLocationP,
		Description -> "Indicates if the plate will be illuminated and read from top or bottom.",
		Category -> "Optics"
	},
	MoatSize -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterEqualP[0, 1],
		Units -> None,
		Description -> "The number of concentric perimeters of wells filled with MoatBuffer in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MoatBuffer -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Object[Sample],Model[Sample]],
		Description -> "The sample each moat well is filled with in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	},
	MoatVolume -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Microliter],
		Units -> Microliter,
		Description -> "The volume which each moat is filled with in order to slow evaporation of inner assay samples.",
		Category -> "Sample Preparation"
	}
};

$ObjectUnitOperationFluorescenceFields = {
	SpectralScanExpression -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> ListableP[FluorescenceScanTypeP],
		Description -> "The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics"
	},
	SpectralScanMultiple -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> Alternatives[FluorescenceScanTypeP],
		Description->"Indicates if fluorescence should be recorded using a fixed excitation wavelength and a range of emission wavelengths (Emission) or using a fixed emission wavelength and a range of excitation wavelengths (Excitation).",
		Migration -> SplitField,
		Category -> "Optics"
	},
	EmissionWavelength -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description -> "The wavelength at which fluorescence emitted from the samples is measured.",
		Category -> "Optics",
		Abstract -> True
	},
	ExcitationWavelength -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description -> "The wavelength of light used to excite the samples.",
		Category -> "Optics",
		Abstract -> True
	},
	EmissionWavelengthRange -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> _Span,
		Description -> "The wavelength at which fluorescence emitted from the samples is measured.",
		Category -> "Optics"
	},
	ExcitationWavelengthRange -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> _Span,
		Description -> "The wavelength of light used to excite the samples.",
		Category -> "Optics"
	},
	ExcitationScanGain -> {
		Format -> Single,
		Class -> VariableUnit,
		Pattern :> GreaterEqualP[0*Volt] | RangeP[0*Percent, 100*Percent],
		Description->"The gain which should be applied to the signal reaching the primary detector during the excitation scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
		Category -> "Optics"
	},
	EmissionScanGain -> {
		Format -> Single,
		Class -> VariableUnit,
		Pattern :> GreaterEqualP[0*Volt] | RangeP[0*Percent, 100*Percent],
		Description->"The gain which should be applied to the signal reaching the primary detector during the emission scan. This may be specified either as a direct voltage, or as a percentage (which indicates that the gain should be set such that the AdjustmentSample fluoresces at that percentage of the instrument's dynamic range).",
		Category -> "Optics"
	},
	AdjustmentEmissionWavelength -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description->"The wavelength at which fluorescence should be read in order to perform automatic adjustments of gain and focal height values at run time.",
		Category -> "Optics"
	},
	AdjustmentExcitationWavelength -> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description->"The wavelength at which the sample should be excited in order to perform automatic adjustments of gain and focal height values at run time.",
		Category -> "Optics"
	}
};

$ObjectUnitOperationLuminescenceIntensityFields = {
	WavelengthSelection -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> LuminescenceWavelengthSelectionP,
		Description->"Indicates if the emission wavelengths should be obtained by filters or monochromators.",
		Category -> "Optics"
	},
	EmissionWavelengthReal -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description->"The wavelength(s) at which luminescence emitted from the sample should be measured.",
		Category -> "Optics",
		Migration -> SplitField
	},
	EmissionWavelengthExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> Alternatives[NoFilter],
		Description->"The wavelength(s) at which luminescence emitted from the sample should be measured.",
		Category -> "Optics",
		Migration -> SplitField
	},
	DualEmissionWavelength -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Nano*Meter],
		Units -> Meter Nano,
		Description->"For each member of EmissionWavelengthReal, the wavelength at which luminescence emitted from the sample should be measured with the secondary detector (simultaneous to the measurement at the emission wavelength done by the primary detector).",
		IndexMatching -> EmissionWavelengthReal,
		Category -> "Optics"
	},
	Gain -> {
		Format -> Multiple,
		Class -> VariableUnit,
		Pattern :> GreaterEqualP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
		Description->"For each member of EmissionWavelengthReal, the gain which should be applied to the signal reaching the primary detector.",
		IndexMatching -> EmissionWavelengthReal,
		Category -> "Optics"
	},
	DualEmissionGain -> {
		Format -> Multiple,
		Class -> VariableUnit,
		Pattern :> GreaterEqualP[0*Microvolt] | RangeP[0*Percent, 100*Percent],
		Description->"For each member of EmissionWavelengthReal, the gain which should be applied to the signal reaching the secondary detector.",
		IndexMatching -> EmissionWavelengthReal,
		Category -> "Optics"
	},
	FocalHeightReal -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Meter],
		Units -> Meter Milli,
		Description -> "For each member of EmissionWavelengthReal, The height above the assay plates from which the readings are made.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelengthReal
	},
	FocalHeightExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> Alternatives[Auto],
		Description -> "For each member of EmissionWavelengthReal, The height above the assay plates from which the readings are made.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelengthReal
	},
	AdjustmentSampleExpression -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> Alternatives[FullPlate, _String, {LocationPositionP|_Integer, ObjectP[{Model[Container], Object[Container]}]|_String}],
		Description -> "For each member of EmissionWavelengthReal, The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelengthReal
	},
	AdjustmentSampleLink -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Sample]|Model[Sample],
		Description -> "For each member of EmissionWavelengthReal, The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelengthReal
	},
	AdjustmentSampleIndexedMultipleIntegerLink -> {
		Format -> Multiple,
		Class -> {Integer,Link},
		Pattern :> {GreaterP[0,1], _Link | Null},
		Relation -> {Null, Object[Sample]|Model[Sample]},
		Units -> {None, None},
		Headers -> {"Index","Sample"},
		Description -> "For each member of EmissionWavelengthReal, The sample used to determine the gain percentage and focal height adjustments.",
		Migration -> SplitField,
		Category -> "Optics",
		IndexMatching -> EmissionWavelengthReal
	}
};

With[{
	insertMe=Sequence@@$ObjectUnitOperationAbsorbanceSpectroscopyFields,
	insertMe2=Sequence@@$ObjectUnitOperationPlateReaderBaseFields
},
	DefineObjectType[Object[UnitOperation,AbsorbanceIntensity], {
		Description->"A detailed set of parameters that specifies a single absorbance intensity reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Wavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Nanometer],
				Units -> Nanometer,
				Description -> "For each member of SampleLink, the specific wavelength(s) which should be used to measure absorbance in the samples.",
				Category -> "Optics"
			},
			QuantifyConcentration -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				IndexMatching -> SampleLink,
				Description -> "For each member of SampleLink, indicates if the concentration of the sample is determined.",
				Category -> "Quantification"
			},
			QuantificationAnalyte -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> IdentityModelTypeP,
				Description -> "For each member of SampleLink, the substance whose concentration should be determined during this experiment.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},

			insertMe,
			insertMe2
		}
	}]
];
