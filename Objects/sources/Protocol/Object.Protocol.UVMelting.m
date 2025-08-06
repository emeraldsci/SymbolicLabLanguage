

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, UVMelting], {
	Description->"A protocol to determine thermodynamic properties of samples by measuring absorbance while varying temperature.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		AssayBufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of PooledSamplesIn, the volume of buffer to be included in the reaction mixture.",
			Category -> "Aliquoting",
			IndexMatching -> PooledSamplesIn,
			Developer -> True
		},
		ConcentratedBufferVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of PooledSamplesIn, the volume of concentrated buffer to be included in the reaction mixture.",
			Category -> "Aliquoting",
			IndexMatching -> PooledSamplesIn,
			Developer -> True
		},
		BufferDiluentVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of PooledSamplesIn, the volume of buffer diluent to be included in the reaction mixture to dilute the concentrated buffer by BufferDilutionRatio.",
			Category -> "Aliquoting",
			IndexMatching -> PooledSamplesIn,
			Developer -> True
		},
		(* Note: SamplesInAliquots is Deprecated. This information is now inside the shared field AliquotSamplePreparation *)
		SamplesInAliquots -> {
			Format -> Multiple,
			Class -> {Link, Real, Real, Link},
			Pattern :> {_Link, VolumeP, ConcentrationP, _Link},
			Relation -> {Object[Sample][Protocols], Null, Null, Model[Container] | Object[Container]},
			Units -> {None, Liter Micro, Micro Molar, None},
			Description -> "The aliquots to be transferred from source samples into reaction cuvettes.",
			Category -> "Aliquoting",
			Headers -> {"Sample", "Aliquot Volume", "Target Concentration", "Cuvette"}
		},
		(* Note: TargetConcentrationGroupings is Deprecated. This information is now inside the shared field AliquotSamplePreparation *)
		TargetConcentrationGroupings -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ConcentrationP..},
			Units -> None,
			Description -> "For each member of PooledSamplesIn, the overall target concentration of each component oligomer in the final reaction.",
			Category -> "Aliquoting",
			IndexMatching -> PooledSamplesIn
		},
		(* Note: AliquotVolumeGroupings is Deprecated. This information is now inside the shared field AliquotSamplePreparation *)
		AliquotVolumeGroupings -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {VolumeP..},
			Units -> None,
			Description -> "For each member of PooledSamplesIn, the volume of each component oligomer aliquoted into the reaction cuvette.",
			Category -> "Aliquoting",
			IndexMatching -> PooledSamplesIn
		},

		PooledMixSamplePreparation -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixType->Expression,
				NumberOfMixes -> Integer,
				MixVolume -> Real,
				Incubate -> Boolean
			},
			Pattern :> {
				Mix -> BooleanP,
				MixType->(Invert|Pipette),
				NumberOfMixes -> GreaterP[0],
				MixVolume -> GreaterP[0 Microliter],
				Incubate -> BooleanP
			},
			Units -> {
				Mix -> None,
				MixType->None,
				NumberOfMixes -> None,
				MixVolume -> Microliter,
				Incubate -> None
			},
			Relation -> {
				Mix -> Null,
				MixType->Null,
				NumberOfMixes -> Null,
				MixVolume -> Null,
				Incubate -> Null
			},
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, parameters describing how the pooled samples should be mixed prior to the start of the experiment.",
			Category -> "Sample Preparation"
		},

		NestedIndexMatchingMixSamplePreparation -> {
			Format -> Multiple,
			Class -> {
				Mix -> Boolean,
				MixType->Expression,
				NumberOfMixes -> Integer,
				MixVolume -> Real,
				Incubate -> Boolean
			},
			Pattern :> {
				Mix -> BooleanP,
				MixType->(Invert|Pipette),
				NumberOfMixes -> GreaterP[0],
				MixVolume -> GreaterP[0 Microliter],
				Incubate -> BooleanP
			},
			Units -> {
				Mix -> None,
				MixType->None,
				NumberOfMixes -> None,
				MixVolume -> Microliter,
				Incubate -> None
			},
			Relation -> {
				Mix -> Null,
				MixType->Null,
				NumberOfMixes -> Null,
				MixVolume -> Null,
				Incubate -> Null
			},
			IndexMatching -> PooledSamplesIn,
			Description -> "For each member of PooledSamplesIn, parameters describing how the pooled samples should be mixed prior to the start of the experiment.",
			Category -> "Sample Preparation"
		},
		Cuvettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of PooledSamplesIn, the cuvette in which the reaction is mixed and assayed.",
			Category -> "Cuvette Preparation",
			IndexMatching -> PooledSamplesIn
		},
		ReferenceSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The sample used to reference the sample temperature readings during heating and cooling.",
			Category -> "Cuvette Preparation",
			Developer -> True
		},
		ReferenceCuvette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Cuvette] | Object[Container, Cuvette],
			Description -> "The cuvette used to hold the reference sample.",
			Category -> "Cuvette Preparation",
			Developer -> True
		},
		TemperatureProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, TemperatureProbe] | Object[Part, TemperatureProbe],
			Description -> "The part used to monitor the temperature of the reference cuvette during heating and cooling.",
			Category -> "Cuvette Preparation"
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
			Category -> "Cuvette Preparation",
			Developer -> True
		},
		BlankMeasurement -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Specifies whether blank (buffer-only) measurements will be recorded prior to adding the experimental samples to the cuvettes and performing melting and cooling curve readings.",
			Category -> "Blanking",
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
			Description -> "For each member of SamplesIn, the model or sample used to generate a blank sample whose absorbance will be subtracted as background.",
			Category -> "Blanking",
			IndexMatching -> SamplesIn
		},
		BlankPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description -> "A set of instructions specifying the preparation of cuvettes with buffer for blanking the instrument prior to measurement.",
			Category -> "Blanking",
			Developer -> True
		},
		PoolingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description -> "A set of instructions specifying the aliquoting of the experimental samples into the cuvettes prior to reading in the spectrophotometer.",
			Category -> "Cuvette Preparation",
			Developer -> True
		},
		BlankManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation]|Object[Protocol, RoboticSamplePreparation]|Object[Protocol, ManualSamplePreparation]|Object[Notebook, Script],
			Description -> "The sample manipulation protocol used to prepare the buffer-containing cuvettes for blanking the instrument prior to the experiment.",
			Category -> "Blanking",
			Developer -> True
		},
		PoolingManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation]|Object[Protocol, RoboticSamplePreparation]|Object[Protocol, ManualSamplePreparation]|Object[Notebook, Script],
			Description -> "The sample manipulation protocol used to aliquot experimental samples into cuvettes for reading in a spectrophotometer.",
			Category -> "Cuvette Preparation",
			Developer -> True
		},
		StoragePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description -> "A set of instructions specifying the transfer of the pooled samples from the cuvettes into the ContainersOut for storage after the experiment.",
			Category -> "Storage Information",
			Developer -> True
		},
		StorageManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation]|Object[Protocol, RoboticSamplePreparation]|Object[Protocol, ManualSamplePreparation]|Object[Notebook, Script],
			Description -> "The sample manipulation protocol used to transfer the pooled samples from the cuvettes into the ContainersOut for storage after the experiment.",
			Category -> "Storage Information",
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
		Wavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength at which the absorbance readings are recorded.",
			Category -> "Optical Information",
			Abstract -> True
		},
		MinWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The lower limit of the wavelength range over which sample absorbance is read.",
			Category -> "Optical Information",
			Abstract -> True
		},
		MaxWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The upper limit of the wavelength range over which sample absorbance is read.",
			Category -> "Optical Information",
			Abstract -> True
		},
		BaselineAdjustmentWavelength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Wavelength], Field[MinWavelength], Field[MaxWavelength]},Experiment`Private`baselineAdjustmentWavelengthString[Field[Wavelength], Field[MinWavelength], Field[MaxWavelength]]],
			Pattern :> _String,
			Description -> "The wavelength setting to be entered into the spectrophotometer software for baseline adjustment.",
			Category -> "Optical Information",
			Developer -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The instrument used to detect UV-Vis absorbance during this experiment.",
			Category -> "Thermocycling"
		},
		TemperatureRampOrder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ThermodynamicCycleP,
			Description -> "The order of temperature ramping to be performed in each cycle.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time to hold the temperature at the thermocycling endpoints.",
			Category -> "Thermocycling"
		},
		StepEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The time to hold the temperature between each temperature step and the next.",
			Category -> "Thermocycling"
		},
		TemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Hour],
			Units -> Celsius / Hour,
			Description -> "The rate at which the temperature is changed in the course of one cycle.",
			Category -> "Thermocycling"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The low temperature in the melting and cooling curves.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The high temperature in the melting and cooling curves.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		NumberOfCycles -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of heating and cooling cycles to be performed.",
			Category -> "Thermocycling",
			Abstract -> True
		},
		TemperatureResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The change in temperature from one melting or cooling curve step to the next at which absorbance data is recorded.",
			Category -> "Thermocycling"
		},
		TemperatureMonitor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TemperatureMonitorTypeP,
			Description -> "The integrated detector on the spectrophotometer used to monitor temperature during the experiment. Possibilities include 'CuvetteBlock', indicating that a temperature sensor in the heater/chiller block will be monitored, and 'ImmersionProbe', indicating that a temperature sensor in a buffer-filled cuvette will be monitored.",
			Category -> "Thermocycling"
		},
		ThermocyclingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The estimated amount of time that the UV melting curve analysis will take to complete.",
			Category -> "Thermocycling"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to place the cuvettes to be analyzed into the block of the spectrophotometer.",
			Category -> "Thermocycling",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		ContainerPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The batch lengths corresponding to the ContainerPlacements batching field.",
			Developer -> True,
			Category -> "Batching"
		},
		ReferenceCuvettePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to place the reference cuvette(s) to be analyzed into the block of the spectrophotometer.",
			Category -> "Thermocycling",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		ScriptCommand -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The ADL script command used to load the absorbance thermodynamics module.",
			Category -> "Data Processing",
			Developer -> True
		},
		DataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The data file containing the results of the absorbance thermodynamics experiment.",
			Category -> "Data Processing"
		},
		DataFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the data file generated at the conclusion of the experiment.",
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
		MethodFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The method file containing parameters for automated execution of the experiment.",
			Category -> "Data Processing"
		},
		MethodFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name used for the method file generated at the conclusion of the experiment.",
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
		CuvetteWasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "The cuvette washer instrument used to wash cuvettes after the absorbance thermodynamics experiment.",
			Category -> "Cleaning"
		},
		(* Note: NitrogenGasValve is deprecated. We instead have a resource for the BlowGun *)
		NitrogenGasValve -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part],
			Description -> "The nitrogen valve used to dry cuvettes after washing.",
			Category -> "Cleaning"
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
		AbsorbanceData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The individual absorbance readings of each sample and each temperature step generated by this protocol.",
			Category -> "Experimental Results"
		}

	}
}];
