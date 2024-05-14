

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, AbsorbanceSpectroscopy], {
	Description->"A protocol for reading plate well absorbances in a plate reader.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		AssayPlatePrep -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "The protocol used to prepare the input samples prior to absorbance measurements.",
			Category -> "Sample Preparation"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Minute],
			Units -> Minute,
			Description -> "The length of time for which the samples incubate at the requested temperature prior to measuring the absorbance.",
			Category -> "Sample Preparation"
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
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "Indicates the temperature the samples will held at prior to measuring absorbance and during data acquisition within the instrument.",
			Category -> "Absorbance Measurement",
			Abstract -> True
		},
		TemperatureMonitor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TemperatureMonitorTypeP,
			Description -> "The integrated detector on the spectrophotometer used to monitor temperature during the experiment. Possibilities include 'CuvetteBlock', indicating that a temperature sensor in the heater/chiller block will be monitored, and 'ImmersionProbe', indicating that a temperature sensor in a buffer-filled cuvette will be monitored.",
			Category -> "Absorbance Measurement"
		},
		TemperatureProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, TemperatureProbe] | Object[Part, TemperatureProbe],
			Description -> "The part used to monitor the temperature of the reference cuvette during absorbance measurement.",
			Category -> "Sample Preparation"
		},
		Methods -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AbsorbanceMethodP,
			Description -> "Indicates the vessel in which an absorbance assay will be performed. Microfluidic is a low volume chamber with fixed path length. Cuvette is a square container with transparent sides that measures absorbance at a fixed path length. PlateReader uses a wells in a plate which does not have a fixed path length.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument to shine light through the sample and measure the absorbance according to AbsorbanceMethod.",
			Category -> "Absorbance Measurement",
			Abstract -> True
		},
		NumberOfReadings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Number of redundant readings taken by the detector to determine a single averaged absorbance reading.",
			Category -> "Absorbance Measurement"
		},
		ReadDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReadDirectionP,
			Description -> "The plate path the instrument follows as it measures absorbance in each well, for instance reading all wells in a row before continuing on to the next row (Row).",
			Category -> "Absorbance Measurement"
		},
		RetainCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the plate seal or lid on the assay container should not be taken off during measurement thereby decreasing evaporation. When this option is set to True, injections cannot be performed as it's not possible to inject samples through the cover. When using the Cuvette Method, automatically set to True.",
			Category -> "Absorbance Measurement"
		},
		SpectralBandwidth ->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Nanometer],
			Units->Nanometer,
			Description->"Indicates the physical size of the slit from which light passes out from the monochromator. The smaller the bandwidth, the greater the resolution in measurements.",
			Category->"Absorbance Measurement"
		},
		AcquisitionMix -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates whether the samples within the cuvette are mixed with a stir bar during data acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Absorbance Measurement"
		},
		NominalAcquisitionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units -> RPM,
			Description -> "Indicates the target/set rate at which the samples within the cuvette are mixed with a stir bar during data acquisition.",
			Category -> "Absorbance Measurement"
		},
		ActualAcquisitionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 RPM],
			Units -> RPM,
			Description -> "Indicates the final rate at which the samples within the cuvette were able to be stably mixed at with a stir bar during data acquisition.",
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
			Units-> RPM,
			Description -> "Sets the lower limit stirring rate to be decreased to for sample mixing in the cuvette when attempting to mix the samples with a stir bar.",
			Category -> "Absorbance Measurement"
		},
		MaxAcquisitionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units-> RPM,
			Description -> "Sets the upper limit stirring rate to be decreased to for sample mixing in the cuvette when attempting to mix the samples with a stir bar.",
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
			Class -> Real,
			Pattern :> GreaterEqualP[1,1],
			Description -> "For each member of SamplesIn, indicates the maximum number of attempts to mix the samples with a stir bar. One attempt designates each time AdjustMixRate changes the AcquisitionMixRate (i.e. each decrease/increase is equivalent to 1 attempt.",
			Category -> "Absorbance Measurement"
		},
		StirringError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if uniform stirring was not achieved within the cuvette after MaxStirAttempts during the setup of the assay.",
			Category -> "Absorbance Measurement"
		},
		StirAttemptsCounter->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1,1],
			Description->"The stir attempt number that is currently being tested.",
			Category -> "General",
			Developer->True
		},
		StirBar -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,StirBar],
				Object[Part,StirBar]
			],
			Description -> "For each member of SamplesIn, indicates the stir bar inserted into the cuvette to mix the sample during data acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Absorbance Measurement"
		},
		StirBarRetriever -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, StirBarRetriever],
				Model[Part, StirBarRetriever]
			],
			Description -> "The magnet and handle used to remove the StirBar from the Dialysate.",
			Category -> "Sample Storage",
			Developer -> True
		},
		Cuvettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the cuvette in which the reaction is mixed and assayed.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		CuvetteRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The rack used to hold cuvettes stable to avoid spillage or damage during transport.",
			Category -> "Sample Preparation",
			Developer -> True
		},
		BlowGun -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to blow dry the interior of the cuvettes used during this experiment after washing, by spraying them with a stream of nitrogen gas.",
			Category -> "Cleaning",
			Developer -> True
		},
		CuvetteWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "The cuvette washer instrument used to wash cuvettes after the absorbance thermodynamics experiment.",
			Category -> "Cleaning"
		},
		SamplingPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateReaderSamplingP,
			Description -> "Specifies the pattern or set of points that are sampled within each well and averaged together to form a single data point. Ring indicates measurements will be taken in a circle concentric with the well with a diameter equal to the SamplingDistance. Spiral indicates readings will spiral inward toward the center of the well. Matrix reads a grid of points within a circle whose diameter is the SamplingDistance.",
			Category -> "Absorbance Measurement"
		},
		SamplingDistance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Millimeter],
			Units -> Millimeter,
			Description -> "When SamplingPattern->Matrix, SamplingDistance is the length of the square that will be measured within the well diameter; SamplingDimension is an integer representing the number of squares forming a grid within the SamplingDistance.",
			Category -> "Absorbance Measurement"
		},
		SamplingDimension -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "When SamplingPattern->Matrix, SamplingDistance is the length of the square that will be measured within the well diameter; SamplingDimension is an integer representing the number of squares forming a grid within the SamplingDistance.",
			Category -> "Absorbance Measurement"
		},
		BlankMeasurement -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Specifies whether blank (buffer-only) measurements will be recorded prior to adding the experimental samples to the cuvettes and performing melting and cooling curve readings.",
			Category -> "Blanking",
			Developer -> True
		},
		BlankAbsorbance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The absorbance measured from the container with buffer alone.",
			Category -> "Experimental Results"
		},
		QuantifyConcentration -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the concentration of the samples should be determined. Automatically calls AnalyzeAbsorbanceConcentration to update the concentration of analytes on completion of the experiment.",
			Category -> "Analysis & Reports"
		},
		QuantificationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "The wavelength at which quantification analysis is performed to determine concentration.",
			Category -> "Analysis & Reports"
		},
		QuantifyConcentrations -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the concentration of the samples should be determined. Automatically calls AnalyzeAbsorbanceConcentration to update the concentration of analytes on completion of the experiment..",
			Category -> "Analysis & Reports"
		},
		QuantificationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, the wavelength at which quantification analysis is performed to determine concentration.",
			Category -> "Analysis & Reports"
		},
		QuantificationAnalytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> IdentityModelTypeP,
			Description -> "For each member of SamplesIn, the substance whose concentration is measured by this protocol.",
			Category -> "Analysis & Reports",
			IndexMatching -> SamplesIn
		},
		QuantificationAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, AbsorbanceQuantification][Protocol],
			Description -> "Analyses performed using AnalyzeAbsorbanceConcentration to determine the concentration of samples in this protocol.",
			Category -> "Analysis & Reports"
		},
		ScriptCommand -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The ADL script command used to load the absorbance module.",
			Category -> "Data Processing",
			Developer -> True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the method file containing parameters for automated execution of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		SettingsFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file paths for the executable files that set the measurement parameters and run the experiment.",
			Category -> "General",
			Developer -> True
		},
		AssayPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move assay container into the instrument.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		ReferenceCuvettePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to place the reference cuvette(s) to be analyzed into the block of the spectrophotometer.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		RecoupSample->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, indicates if the aliquot used to measure the absorbance should be returned to source container after each reading.",
			Category -> "Cleaning"
		},
		MicrofluidicChips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, MicrofluidicChip],
				Object[Container, MicrofluidicChip]
			],
			Description -> "The microfluidic chips used to house sample for absorbance measurement with a fixed path length for easy concentration assessment of the samples by Beers law.",
			Category -> "General",
			Developer -> True
		},
		MicrofluidicChipRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack],
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "The rack that holds the microfluidic chips used to house the samples.",
			Category -> "General",
			Developer -> True
		},
		NitrogenPurge->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the experiment is run under purge with dry nitrogen gas to avoid condensation of moisture and blocking of the cuvette windows at low temperatures.",
			Category -> "Sensor Information"
		},
		InitialPurgePressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure data of the nitrogen gas connected to the spectrophotometer before starting the run.",
			Category -> "Sensor Information",
			Developer -> True
		},
		PurgePressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure log for the nitrogen gas connected to the spectrophotometer chamber.",
			Category -> "Sensor Information",
			Developer -> True
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the data file generated at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		RawDataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the data file containing raw, unblanked data generated at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the data file generated at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the method file generated at the conclusion of the experiment.",
			Category -> "Data Processing",
			Developer -> True
		},
		MicrofluidicChipLoading->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[Robotic, Manual],
			Description->"The loading method for microfluidic chips.",
			Category -> "General"
		},
		MicrofluidicChipPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of samples into the microfluidic chips used to house sample for absorbance measurement.",
			Category -> "General",
			Developer -> True
		},
		MicrofluidicChipManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to transfer samples into the microfluidic chips used to house sample for absorbance measurement.",
			Category -> "General"
		},
		MicrofluidicChipManualLoadingPipette->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Instrument,Pipette]|Object[Instrument,Pipette],
			Description->"The multichannel pipette that is used to manually load samples onto microfluidic chips manually.",
			Category -> "Sample Loading"
		},
		MicrofluidicChipManualLoadingTips->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Item,Tips]|Object[Item,Tips],
			Description->"The pipette tips that are used to manually load samples onto microfluidic chips.",
			Category -> "Sample Loading"
		},
		MicrofluidicChipManualLoadingTuples->{
			Format->Multiple,
			Class->{Sources->Link,Destinations->Link, SourceWell->Expression, DestinationWell->Expression},
			Pattern:>{Sources->_Link,Destinations->_Link, SourceWell->_String, DestinationWell->_String},
			Relation->{Sources->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],Destinations->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Rack]|Object[Container,Rack], SourceWell->Null, DestinationWell->Null},
			Description->"The pipetting instructions used to manually load samples onto microfluidic chips.",
			Category -> "Sample Loading"
		},
		MicrofluidicChipManualLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the manual transfers of samples into the microfluidic chips used to house sample for absorbance measurement.",
			Category -> "General",
			Developer -> True
		},
		MicrofluidicChipManualLoadingManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to manually transfer unspotted samples into the microfluidic chips used to house sample for absorbance measurement.",
			Category -> "General"
		},
		MicrofluidicChipPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to move the microfluidic chips onto the chip rack.",
			Headers -> {"Chip to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		MicrofluidicChipSamplePlacements -> {
			Format -> Multiple,
			Class ->{
				Sample->Link,
				MicrofluidicChipRack->Link,
				Position->Expression
			},
			Pattern :> {
				Sample->_Link,
				MicrofluidicChipRack->_Link,
				Position->LocationPositionP
			},
			Relation -> {
				Sample->Object[Sample],
				MicrofluidicChipRack->Object[Container],
				Position->Null
			},
			Description -> "A list of placement for each sample on the microfluidic chip rack used to house the samples.",
			Category -> "General",
			Developer -> True
		},
		MicrofluidicChipSamplePlacementSuccess-> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of MicrofluidicChipSamplePlacements, specifies spotting success based on operator visual assessment.",
			Category -> "General",
			IndexMatching -> MicrofluidicChipSamplePlacements,
			Developer -> True
		},
		MicrofluidicChipRetryPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the manual transfers of any unspotted samples into the microfluidic chips used to house sample for absorbance measurement.",
			Category -> "General",
			Developer -> True
		},
		MicrofluidicChipRetryManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, SampleManipulation],
			Description -> "A sample manipulation protocol used to manually transfer unspotted samples into the microfluidic chips used to house sample for absorbance measurement.",
			Category -> "General"
		},
		SingleCuvetteReadWells -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The raw wells, as recorded by the operator, that indicated which wells of the microfluidic chip could only be read through a single cuvette, indicating these data may be of potentially low quality or these wells suffered from poor chip loading.",
			Category -> "Data Processing",
			Developer -> True
		},
		MagnifyingGlass -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, MagnifyingGlass],
				Object[Item, MagnifyingGlass]
			],
			Description -> "The magnifying glass used to verify microfluidic chip spotting.",
			Category -> "General"
		},
		UnavailableData -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of Data, indicates whether the MeasuredAbsorbance is Null.",
			Category -> "General",
			IndexMatching -> Data,
			Developer -> True
		},
		BlankContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate],
				Model[Container, Cuvette],
				Object[Container, Cuvette]
			],
			Description -> "Indicates the container that BlankVolume should be transferred to for measuring absorbance of the SamplesIn. If BlankVolume is Null, indicates the blanks should be read inside their current containers.",
			Category -> "Blanking"
		},
		BlankContainerPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfers of blanks into the plates used to house sample for absorbance measurement.",
			Category -> "Blanking",
			Developer -> True
		},
		BlankContainerManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "A sample manipulation protocol used to transfer blanks into the plates used to house sample for absorbance measurement.",
			Category -> "Blanking"
		},
		CuvetteSamplePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the preparation of cuvettes with buffer for blanking the instrument prior to measurement.",
			Category -> "General",
			Developer -> True
		},
		CuvetteSampleManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The sample manipulation protocol used to prepare the buffer-containing cuvettes for blanking the instrument prior to the experiment.",
			Category -> "General",
			Developer -> True
		},
		StoragePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the samples from the cuvettes into the ContainersOut for storage after the experiment.",
			Category -> "Sample Storage",
			Developer -> True
		},
		StorageManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The sample manipulation protocol used to transfer the samples from the cuvettes into the ContainersOut for storage after the experiment.",
			Category -> "Sample Storage",
			Developer -> True
		},
		MoatPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the aliquoting of MoatBuffer into MoatWells in order to create the moat to slow evaporation of inner assay samples.",
			Category -> "General",
			Developer -> True
		},
		MoatManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The sample manipulations protocol used to transfer buffer into the moat wells.",
			Category -> "General"
		},
		PumpPrimingFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which performs the pump priming when executed.",
			Category -> "General",
			Developer -> True
		},
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of SamplesIn, the object or source used to generate a blank sample (i.e. buffer only, water only, etc.) whose absorbance is subtracted as background from the absorbance readings of the SamplesIn to take accound for any artifacts.",
			Category -> "Blanking",
			IndexMatching -> SamplesIn
		},
		EquilibrationSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample used to equilibrate the fixed path length microfluidic chips prior to taking blank spectra and sample measurement.",
			Category -> "Absorbance Measurement",
			Developer -> True
		},
		BlankVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Microliter],
			Units -> Microliter,
			Description -> "For each member of Blanks, the volume of that sample that should be used for blank measurements.",
			Category -> "Blanking",
			IndexMatching -> Blanks
		},

		(* -- Injections -- *)
		PrimaryInjections -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Object[Sample]|Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the first injection into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Injected Sample", "Amount Injected"},
			Category -> "Injections"
		},
		SecondaryInjections -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> { _Link, GreaterEqualP[0*Micro*Liter] | Null},
			Relation -> {Object[Sample]|Model[Sample], Null},
			Units -> {None, Liter Micro},
			Description -> "For each member of SamplesIn, a description of the second injection into the assay plate.",
			IndexMatching -> SamplesIn,
			Headers -> {"Injected Sample", "Amount Injected"},
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
		InjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample loaded into the first injector position on the instrument.",
			Category -> "Injections"
		},
		SecondaryInjectionSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The sample loaded into the second injector position on the instrument.",
			Category -> "Injections"
		},
		InjectionStorageCondition -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which any injections samples used in this experiment should be stored after their usage in this experiment.",
			Category -> "Sample Storage"
		},
		MinCycleTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The minimum duration of time each measurement will take, as determined by the Plate Reader software.",
			Category -> "Cycling",
			Developer -> True
		},

		PlateReaderMix -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the assay plate is agitated inside the plate reader chamber prior to absorbance reads.",
			Category -> "Mixing"
		},
		PlateReaderMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The frequency at which the plate is agitated inside the plate reader chamber prior to absorbance reads.",
			Category -> "Mixing"
		},
		PlateReaderMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the plate is agitated inside the plate reader chamber prior to absorbance reads.",
			Category -> "Mixing"
		},
		PlateReaderMixMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MechanicalShakingP,
			Description -> "The mode of shaking which should be used to mix the plate.",
			Category -> "Mixing"
		},

	(* -- Injector Cleaning -- *)
		InjectorCleaningFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path for the executable file which pumps cleaning solvents through the injectors.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect waste during injector cleaning.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		SecondarySolventWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "An additional container used to collect overflow waste during injector cleaning.",
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryPreppingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which the injectors are washed prior to running the experiment.",
			Category -> "Injector Cleaning"
		},
		SecondaryPreppingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which the injectors are washed prior to running the experiment.",
			Category -> "Injector Cleaning"
		},
		PreppingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position prior to running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		PrimaryFlushingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The primary solvent with which to wash the injectors after running the experiment.",
			Category -> "Injector Cleaning"
		},
		SecondaryFlushingSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The secondary solvent with which to wash the injectors after running the experiment.",
			Category -> "Injector Cleaning"
		},
		FlushingSolutionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Object[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move cleaning solvents into position after running the experiment.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		WasteContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to move the waste container(s) into position.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "Injector Cleaning",
			Developer -> True
		},
		CleaningRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the cleaning solvent containers when the lines are prepped and flushed.",
			Category -> "Placements",
			Developer -> True
		},

		(* -- Placements -- *)
		InjectionPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container]| Object[Container] | Object[Sample] | Model[Sample], Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "A list of placements used to move the injection containers into position.",
			Headers -> {"Object to Place", "Destination Object","Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		InjectionRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container]| Object[Container],
			Description -> "The instrument rack which holds the injection containers during sample priming and injection.",
			Category -> "Placements",
			Developer -> True
		},

		(* -- Retry Logic -- *)
		RetryState -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Whether or not the retry branch should be entered.",
			Category -> "General",
			Developer -> True
		},
		RetrySampleIndices -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[0, 1]...},
			Description -> "A list of integers referring to the indices of SamplesIn to be retried.",
			Category -> "General",
			Developer -> True
		},
		RetryMicrofluidicChips -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Link..},
			Relation ->{Alternatives[
				Model[Container, MicrofluidicChip],
				Object[Container, MicrofluidicChip]
			]},
			Description -> "The microfluidic chips used to house sample for absorbance measurement for each retry step.",
			Category -> "General",
			Developer -> True
		},
		CurrentRetryMicrofluidicChips ->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,MicrofluidicChip],
				Object[Container,MicrofluidicChip]
			],
			Description->"The microfluidic chips used to house sample for absorbance measurement for the curreht retry step.",
			Category->"General",
			Developer->True
		},
		RetryMicrofluidicChipPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SampleManipulationP..},
			Description -> "A set of instructions specifying the transfers of samples into the microfluidic chips for each retry step.",
			Category -> "General",
			Developer -> True
		},
		RetrySettingsFilePaths -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {FilePathP..},
			Description -> "The file paths for the executable files that set the measurement parameters and run the experiment for each retry step.",
			Category -> "General",
			Developer -> True
		},
		RetryMicrofluidicChipSamplePlacements -> {
			Format -> Multiple,
			Class ->Expression,
			Pattern :>{{
				KeyValuePattern[
					{Sample -> _Link,
					MicrofluidicChipRack -> _Link,
					Position -> LocationPositionP}
				]..
			}..},
			Relation ->{{
				Sample->Object[Sample],
				MicrofluidicChipRack->Object[Container],
				Position->Null
			}},
			Description -> "A list of placement for each sample on the microfluidic chip rack for each retry step.",
			Category -> "General",
			Developer -> True
		},
		RetryAssayPlatePlacements -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{_Link, {LocationPositionP..}}..},
			Relation -> {{Object[Container], Null}},
			Description -> "A list of placements used to move assay plates into the plate reader for each retry step.",
			Category -> "General",
			Developer -> True
		},
		CurrentRetryAssayPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to move assay plates into the plate reader for the current retry step.",
			Headers -> {"Object to Place", "Placement Tree"},
			Category -> "General",
			Developer -> True
		},
		RetryDataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the data file generated at the conclusion of the experiment for each retry step.",
			Category -> "General",
			Developer -> True
		},
		RetryRawDateFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the data file containing raw, unblanked data generated at the conclusion of the experiment.",
			Category -> "General",
			Developer -> True
		}
	}
}];
