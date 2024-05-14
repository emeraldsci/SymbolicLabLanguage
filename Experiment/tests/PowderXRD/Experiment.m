(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentPowderXRD*)


DefineTests[ExperimentPowderXRD,
	{
		Example[{Basic, "Perform a powder X-ray diffraction experiment on one sample:"},
			ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID]],
			ObjectP[Object[Protocol, PowderXRD]]
		],
		Example[{Basic, "Perform a powder X-ray diffraction experiment on provided samples:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, PowderXRD]]
		],
		Example[{Additional, "Use container as the input:"},
			ExperimentPowderXRD[{Object[Container, Vessel,"Container 1 for ExperimentPowderXRD tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, PowderXRD]]
		],
		Example[{Additional, "Use {Position,Container} as the input:"},
			ExperimentPowderXRD[{"A1",Object[Container, Vessel,"Container 1 for ExperimentPowderXRD tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, PowderXRD]]
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Template -> Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID]],
			ObjectP[Object[Protocol, PowderXRD]]
		],
		Example[{Options, Template, "Options specified for the template protocol are set for the new protocol:"},
			Download[
				ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Template -> Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID]],
				{ExposureTimes, NumberOfReplicates, Template}
			],
			{
				{0.3*Second, 0.3*Second, 0.3*Second, 0.3*Second, 0.3*Second, 0.3*Second, 0.3*Second, 0.3*Second},
				4,
				ObjectP[Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID]]
			}
		],
		Example[{Options, Current, "Specify the current of the Instrument in a given PowderXRD experiment:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Current -> 20*Milliampere, Output -> Options];
			Lookup[options, Current],
			20*Milliampere,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Specify the number of replicates for a given PowderXRD experiment:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, NumberOfReplicates -> 3, Output -> Options];
			Lookup[options, NumberOfReplicates],
			3,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Test["Populate the XRDParameters field with the index matching fields that resolve to be the same thing and Null for others:",
			Download[
				ExperimentPowderXRD[
					{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]},
					ExposureTime -> 0.1*Second,
					OmegaAngleIncrement -> {0.1*AngularDegree, 1*AngularDegree},
					DetectorDistance -> {60.*Millimeter, 70.*Millimeter},
					DetectorRotation -> Fixed,
					MinOmegaAngle -> 0.*AngularDegree,
					MaxOmegaAngle -> 5.*AngularDegree,
					FixedDetectorAngle -> 0.*AngularDegree
				],
				XRDParameters
			],
			<|
				ExposureTime -> 0.1*Second,
				DetectorDistance -> Null,
				OmegaAngleIncrement -> Null,
				DetectorRotation -> Fixed,
				MinOmegaAngle -> 0.*AngularDegree,
				MaxOmegaAngle -> 5.*AngularDegree,
				MinDetectorAngle -> 0.*AngularDegree,
				MaxDetectorAngle -> 0.*AngularDegree,
				DetectorAngleIncrement -> Null
			|>,
			EquivalenceFunction -> AssociationMatchQ
		],
		Test["Populate the PlateFileName field with a string:",
			Download[
				ExperimentPowderXRD[
					{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]},
					ExposureTime -> 0.1*Second,
					OmegaAngleIncrement -> {0.1*AngularDegree, 1*AngularDegree},
					DetectorDistance -> {60.*Millimeter, 70.*Millimeter},
					DetectorRotation -> Fixed,
					MinOmegaAngle -> 0.*AngularDegree,
					MaxOmegaAngle -> 5.*AngularDegree,
					FixedDetectorAngle -> 0.*AngularDegree
				],
				PlateFileName
			],
			_String
		],
		Test["Populate the SampleHandler and CrystallizationPlate fields with values:",
			Download[
				ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}],
				{SampleHandler, CrystallizationPlate}
			],
			{
				ObjectP[Model[Container, Rack, "XtalCheck"]],
				ObjectP[Model[Container, Plate, "In Situ-1 Crystallization Plate"]]
			}
		],
		Test["Perform a powder X-ray diffraction experiment on a model-less sample:",
			ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Model-less)" <> $SessionUUID]],
			ObjectP[Object[Protocol, PowderXRD]]
		],
		Example[{Options, ExposureTime, "Specify the exposure time for each given sample in a PowderXRD experiment:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, ExposureTime -> {0.1*Second, 0.03*Second}, Output -> Options];
			Lookup[options, ExposureTime],
			{0.1*Second, 0.03*Second},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, OmegaAngleIncrement, "Specify the omega angle increment for each given sample in a PowderXRD experiment:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, OmegaAngleIncrement -> {0.1*AngularDegree, 1*AngularDegree}, Output -> Options];
			Lookup[options, OmegaAngleIncrement],
			{0.1*AngularDegree, 1*AngularDegree},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorDistance, "Specify the detector distance for each given sample in a PowderXRD experiment:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 200*Millimeter}, Output -> Options];
			Lookup[options, DetectorDistance],
			{60*Millimeter, 200*Millimeter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorDistance, "DetectorDistance automatically resolves to the smallest value allowed given the constraints provided by the omega and detector angles:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> {-4.99*AngularDegree, -17.24*AngularDegree}, MaxOmegaAngle -> {4.99*AngularDegree, 17.24*AngularDegree}, Output -> Options];
			Lookup[options, DetectorDistance],
			{60*Millimeter, 70*Millimeter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorRotation, "Specify whether the DetectorRotation option should be Fixed or Sweeping for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}, Output -> Options];
			Lookup[options, DetectorRotation],
			{Fixed, Sweeping},
			Variables :> {options}
		],
		Example[{Options, DetectorRotation, "If FixedDetectorAngle, MinOmegaAngle, or MaxOmegaAngle are specified, DetectorRotation resolves to Fixed; otherwise it resolves to Sweeping:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> {0*AngularDegree, Null}, Output -> Options];
			Lookup[options, DetectorRotation],
			{Fixed, Sweeping},
			Variables :> {options}
		],
		Example[{Options, MinOmegaAngle, "Specify the minimum angle between the sample and X-ray source for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> -10*AngularDegree, Output -> Options];
			Lookup[options, MinOmegaAngle],
			-10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MinOmegaAngle, "If not specified, MinOmegaAngle resolves to the lowest value allowed by the specified DetectorDistance and/or DetectorRotation options:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}, Output -> Options];
			Lookup[options, MinOmegaAngle],
			{-4.99*AngularDegree, -17.24*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MinOmegaAngle, "MinOmegaAngle and MaxOmegaAngle values are stored in the OmegaAngles field:"},
			Download[
				ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}],
				OmegaAngles
			],
			{
				{-4.99*AngularDegree, 4.99*AngularDegree},
				{-17.24*AngularDegree, 17.24*AngularDegree},
				{Null, Null}
			},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MaxOmegaAngle, "Specify the maximum angle between the sample and X-ray source for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxOmegaAngle -> 10*AngularDegree, Output -> Options];
			Lookup[options, MaxOmegaAngle],
			10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxOmegaAngle, "If not specified, MaxOmegaAngle resolves to the largest value allowed by the specified DetectorDistance and/or DetectorRotation options:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}, Output -> Options];
			Lookup[options, MaxOmegaAngle],
			{4.99*AngularDegree, 17.24*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FixedDetectorAngle, "Specify the fixed angle between the detector and X-ray source for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> 10*AngularDegree, Output -> Options];
			Lookup[options, FixedDetectorAngle],
			10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FixedDetectorAngle, "FixedDetectorAngle resolves to 0 AngularDegree if DetectorRotation -> Fixed, and Null if DetectorRotation -> Sweeping:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}, Output -> Options];
			Lookup[options, FixedDetectorAngle],
			{0*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FixedDetectorAngle, "FixedDetectorAngle populates both entries of DetectorAngles:"},
			Download[
				ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}],
				DetectorAngles
			],
			{
				{0*AngularDegree, 0*AngularDegree},
				{0*AngularDegree, 81.24*AngularDegree}
			},
			EquivalenceFunction -> Equal
		],
		Example[{Options, MinDetectorAngle, "Specify the minimum angle between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> -10*AngularDegree, Output -> Options];
			Lookup[options, MinDetectorAngle],
			-10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MinDetectorAngle, "MinDetectorAngle automatically resolves to 0 AngularDegree if DetectorRotation -> Sweeping, or Null if DetectorRotation -> Fixed:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Sweeping, Fixed}, Output -> Options];
			Lookup[options, MinDetectorAngle],
			{0*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxDetectorAngle, "Specify the maximum angle between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> 80*AngularDegree, Output -> Options];
			Lookup[options, MaxDetectorAngle],
			80*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxDetectorAngle, "MaxDetectorAngle automatically resolves to the largest value allowed by the specified DetectorDistance if DetectorRotation -> Sweeping, or Null if DetectorRotation -> Fixed:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, 70*Millimeter}, DetectorRotation -> {Sweeping, Sweeping, Fixed}, Output -> Options];
			Lookup[options, MaxDetectorAngle],
			{56.74*AngularDegree, 68.99*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorAngleIncrement, "Specify increment between the angles between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorAngleIncrement -> 20*AngularDegree, Output -> Options];
			Lookup[options, DetectorAngleIncrement],
			20*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorAngleIncrement, "DetectorAngleIncrement resolves to 0.25 * (the difference between MaxDetectorAngle and MinDetectorAngle), or Null if DetectorRotation -> Fixed:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> {0*AngularDegree, Null}, MaxDetectorAngle -> {80*AngularDegree, Null}, DetectorRotation -> {Sweeping, Fixed}, Output -> Options];
			Lookup[options, DetectorAngleIncrement],
			{20*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Specify the storage condition for the SamplesIn:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, SamplesInStorageCondition -> {AmbientStorage, Null}, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			{AmbientStorage, Null},
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Specify the storage condition for the SamplesIn and expand properly with NumberOfReplicates:"},
			Download[ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, SamplesInStorageCondition -> {AmbientStorage, Null}, NumberOfReplicates -> 2], SamplesInStorage],
			{AmbientStorage, AmbientStorage, Null, Null}
		],
		Example[{Options, SamplesOutStorageCondition, "Specify the storage condition for the SamplesOut:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, SamplesOutStorageCondition -> {AmbientStorage, Null}, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			{AmbientStorage, Null},
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Specify the storage condition for the SamplesOut and expand properly with NumberOfReplicates:"},
			Download[ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, SamplesInStorageCondition -> {AmbientStorage, Null}, NumberOfReplicates -> 2], SamplesInStorage],
			{AmbientStorage, AmbientStorage, Null, Null}
		],
		Example[{Options, ImageXRDPlate, "Specify whether to image the crystallization plate after loading and drying but prior to reading:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, ImageXRDPlate -> True, Output -> Options];
			Lookup[options, ImageXRDPlate],
			True
		],
		Example[{Options, SpottingVolume, "Specify how much volume to load onto each well of the crystallization plate:"},
			Download[ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, SpottingVolume -> {3 Microliter, 2 Microliter}], SpottingVolumes],
			{3 Microliter, 2 Microliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Instrument, "Specify the instrument to be used in this experiment:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Instrument -> Model[Instrument, Diffractometer, "XtaLAB Synergy-R"], Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, Diffractometer, "XtaLAB Synergy-R"]]
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentPowderXRD[Link[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, PowderXRD]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "DiscardedSamples", "Throws an error if trying to run on discarded samples:"},
			ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Discarded)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "Throws an error if trying to run on samples with deprecated models:"},
			ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "PowderXRDTooManySamples", "Throws an error if trying to run on too many samples:"},
			ExperimentPowderXRD[ConstantArray[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], 98], SpottingVolume -> 1 Microliter, Aliquot -> True],
			$Failed,
			Messages :> {
				Error::PowderXRDTooManySamples,
				Error::InvalidInput
			},
			TimeConstraint -> 300
		],
		Example[{Messages, "DuplicateName", "Throws an error if trying set Name to the same as an existing protocol object:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Name -> "PowderXRD Protocol 1" <> $SessionUUID],
			$Failed,
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FixedOptionsWhileSweeping", "FixedDetectorAngle may not be specified when DetectorRotation -> Sweeping:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> 10*AngularDegree, DetectorRotation -> Sweeping],
			$Failed,
			Messages :> {
				Error::FixedOptionsWhileSweeping,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SweepingOptionsWhileFixed", "MinDetectorAngle, MaxDetectorAngle, and/or DetectorAngleIncrement may not be specified when DetectorRotation -> Fixed:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> 80*AngularDegree, DetectorRotation -> Fixed],
			$Failed,
			Messages :> {
				Error::SweepingOptionsWhileFixed,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MinOmegaAboveMax", "MinOmegaAngle cannot be greater than MaxOmegaAngle:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> 10*AngularDegree, MaxOmegaAngle -> 5*AngularDegree],
			$Failed,
			Messages :> {
				Error::MinOmegaAboveMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MinDetectorAngleAboveMax", "MinDetectorAngle cannot be greater than MaxDetectorAngle:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> 10*AngularDegree, MaxDetectorAngle -> 5*AngularDegree],
			$Failed,
			Messages :> {
				Error::MinDetectorAngleAboveMax,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DetectorAngleIncrementTooLarge", "DetectorAngleIncrement cannot be greater than the difference between MaxDetectorAngle and MinDetectorAngle:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> 10*AngularDegree, MaxDetectorAngle -> 20*AngularDegree, DetectorAngleIncrement -> 15 AngularDegree],
			$Failed,
			Messages :> {
				Error::DetectorAngleIncrementTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DetectorAngleIncrementTooLarge", "The difference between MaxDetectorAngle and MinDetectorAngle cannot be less than the minimum DetectorAngleIncrement:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> 10*AngularDegree, MaxDetectorAngle -> 10.05*AngularDegree],
			$Failed,
			Messages :> {
				Error::DetectorAngleIncrementTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OmegaAngleIncrementTooLarge", "OmegaAngleIncrement cannot be greater than the difference between MaxOmegaAngle and MinOmegaAngle:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> 10*AngularDegree, MaxOmegaAngle -> 11*AngularDegree, OmegaAngleIncrement -> 2 AngularDegree],
			$Failed,
			Messages :> {
				Error::OmegaAngleIncrementTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OmegaAngleIncrementTooLarge", "The difference between MaxOmegaAngle and MinOmegaAngle cannot be less than the minimum OmegaAngleIncrement:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> 10*AngularDegree, MaxOmegaAngle -> 10.05*AngularDegree],
			$Failed,
			Messages :> {
				Error::OmegaAngleIncrementTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FixedOptionsRequiredTogether", "FixedDetectorAngle cannot be set to Null while DetectorRotation -> Fixed:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> Null, DetectorRotation -> Fixed],
			$Failed,
			Messages :> {
				Error::FixedOptionsRequiredTogether,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SweepingOptionsRequiredTogether", "MinDetectorAngle, MaxDetectorAngle, and/or DetectorAngleIncrement cannot be set to Null while DetectorRotation -> Sweeping:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> {Automatic, Null, Automatic}, MinDetectorAngle -> {Null, Automatic, Automatic}, DetectorAngleIncrement -> {Automatic, Automatic, Null}, DetectorRotation -> Sweeping],
			$Failed,
			Messages :> {
				Error::SweepingOptionsRequiredTogether,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FixedOptionsWhileSweeping", "MinOmegaAngle and MaxOmegaAngle must be Null if DetectorRotation -> Sweeping:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> {Automatic, -5*AngularDegree}, MaxOmegaAngle -> {10*AngularDegree, Automatic}, DetectorRotation -> Sweeping],
			$Failed,
			Messages :> {
				Error::FixedOptionsWhileSweeping,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DetectorTooClose", "DetectorDistance may not be closer than is allowed by the specified angles:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> -17.24*AngularDegree, DetectorDistance -> 60*Millimeter],
			$Failed,
			Messages :> {
				Error::DetectorTooClose,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PowderXRDHighVolume", "If the volume of the sample or specified AssayVolume is greater than 100 uL, throw a warning:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, PowderXRD]],
			Messages :> {
				Warning::PowderXRDHighVolume
			}
		],
		Example[{Messages, "AliquotRequired", "If Aliquot resolves to True without any aliquot options being specified, throw a warning:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (12 mL)" <> $SessionUUID]}, Output -> Options],
			{__Rule},
			Messages :> {Warning::AliquotRequired, Warning::PowderXRDHighVolume}
		],

		Example[{Messages, "SpottingVolumeTooLarge", "If the SpottingVolume is greater than the AssayVolume for a given sample, throw an error:"},
			ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (12 mL)" <> $SessionUUID]}, AssayVolume -> 4 Microliter, SpottingVolume -> 5 Microliter],
			$Failed,
			Messages :> {
				Error::SpottingVolumeTooLarge,
				Error::InvalidOption
			}
		],

		(* examples for all the shared options *)
		Example[{Options, Aliquot, "Aliquot resolves to True if the sample needs to be moved into the proper container, and False if it does not need to be:"},
			options = ExperimentPowderXRD[{Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (12 mL)" <> $SessionUUID]}, Output -> Options];
			Lookup[options, Aliquot],
			{False, True},
			Messages :> {
				Warning::PowderXRDHighVolume,
				Warning::AliquotRequired
			},
			Variables :> {options}
		],
		Example[{Options, Confirm, "Set Confirm -> True to immediately confirm protocol upon its creation:"},
			Download[ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Confirm -> True], Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options, Name, "Set name of the new protocol:"},
			Download[ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "PowderXRD protocol 24601"], Name],
			"PowderXRD protocol 24601"
		],

		Example[{Options, PreparatoryPrimitives, "Use the PreparatoryPrimitives option to pre-create standard solutions to perform experiments on:"},
			protocol = ExperimentPowderXRD[
				{"NIST standard sample 1", "NIST standard sample 2"},
				PreparatoryPrimitives -> {
					Define[Name -> "NIST standard sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					Define[Name -> "NIST standard sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 1",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 2",
						Amount -> 10*Milligram
					],
					Aliquot[
						Source -> Model[Sample, "Milli-Q water"],
						Amounts -> {80*Microliter, 80*Microliter},
						Destinations -> {"NIST standard sample 1", "NIST standard sample 2"}
					]
				}
			];
			Download[protocol, PreparatoryPrimitives],
			{SampleManipulationP..},
			Variables :> {protocol}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to pre-create standard solutions to perform experiments on:"},
			protocol = ExperimentPowderXRD[
				{"NIST standard sample 1", "NIST standard sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "NIST standard sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "NIST standard sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 1",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 2",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
						Amount -> {80*Microliter, 80*Microliter},
						Destination -> {"NIST standard sample 1", "NIST standard sample 2"}
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],

		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		(* the mix ones are also broken *)
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Water"], AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Water"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, AliquotSampleLabel, "Set the AliquotSampleLabel option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, AliquotSampleLabel -> "aliquot sample label 1", Output -> Options];
			Lookup[options, AliquotSampleLabel],
			"aliquot sample label 1",
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		]

	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 7 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 8 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentPowderXRD New Test Chemical 1 (12 mL)" <> $SessionUUID],
					Object[Container, Plate, "Crystallization plate 1 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Model-less)" <> $SessionUUID],
					Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, testProtocol1, sample8, container8, sample9, container9, testProtSubObjs, completeTheTestProtocol},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for ExperimentPowderXRD tests" <> $SessionUUID, DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "id:pZx9jo8x59oP"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Container 1 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 2 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Crystallization plate 1 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 3 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 4 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 5 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 6 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 7 for ExperimentPowderXRD tests" <> $SessionUUID,
						"Container 8 for ExperimentPowderXRD tests" <> $SessionUUID
					}
				];

				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						(* this model is deprecated *)
						Model[Sample, "LCMS Grade Water, 4 Liter"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9}
					},
					InitialAmount -> {
						100*Microliter,
						80*Microliter,
						0.1*Milliliter,
						25*Milliliter,
						1.5*Milliliter,
						100*Microliter,
						100*Microliter,
						12*Milliliter,
						100*Microliter
					},
					Name -> {
						"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (Deprecated Model)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (12 mL)" <> $SessionUUID,
						"ExperimentPowderXRD New Test Chemical 1 (Model-less)" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container, container2, sample, sample2, sample, container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7, sample8, container8, sample9, container9}], ObjectP[]]];

				Upload[Cases[Flatten[{
					<|Object -> sample5, Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]]}}|>,
					<|Object -> sample6, Status -> Discarded|>
				}], PacketP[]]];

				Upload[<|
					Object->Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Model-less)" <> $SessionUUID],
					Model->Null
				|>];

				testProtocol1 = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "PowderXRD Protocol 1" <> $SessionUUID, Confirm -> True, ExposureTime -> 0.3*Second, NumberOfReplicates -> 4];
				completeTheTestProtocol = UploadProtocolStatus[testProtocol1, Completed, FastTrack -> True];
				testProtSubObjs = Flatten[Download[testProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Cases[Flatten[{testProtocol1, testProtSubObjs}], ObjectP[]]]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 7 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 8 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentPowderXRD New Test Chemical 1 (12 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Model-less)" <> $SessionUUID],
					Object[Container, Plate, "Crystallization plate 1 for ExperimentPowderXRD tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRD New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, PowderXRD, "PowderXRD Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentPowderXRDQ*)

DefineTests[ValidExperimentPowderXRDQ,
	{
		Example[{Basic, "Perform a powder X-ray diffraction experiment on one sample:"},
			ValidExperimentPowderXRDQ[Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID]],
			True
		],
		Example[{Basic, "Perform a powder X-ray diffraction experiment on provided samples:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}],
			True
		],
		Example[{Options, Verbose, "Print the failing tests if Verbose -> Failures:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Verbose -> Failures, MinOmegaAngle -> {Automatic, -4.99*AngularDegree}, MaxOmegaAngle -> {10*AngularDegree, Automatic}, DetectorRotation -> Sweeping],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary and not a Boolean if OutputFormat -> TestSummary:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, OutputFormat -> TestSummary, MinOmegaAngle -> {Automatic, -4.99*AngularDegree}, MaxOmegaAngle -> {10*AngularDegree, Automatic}, DetectorRotation -> Sweeping],
			_EmeraldTestSummary
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Template -> Object[Protocol, PowderXRD, "ValidPowderXRDQ Protocol 1" <> $SessionUUID]],
			True
		],
		Example[{Options, Current, "Specify the current of the Instrument in a given PowderXRD experiment:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Current -> 20*Milliampere],
			True
		],
		Example[{Options, NumberOfReplicates, "Specify the number of replicates for a given PowderXRD experiment:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, NumberOfReplicates -> 3],
			True
		],
		Example[{Options, ExposureTime, "Specify the exposure time for each given sample in a PowderXRD experiment:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, ExposureTime -> {0.1*Second, 0.03*Second}],
			True
		],
		Example[{Options, OmegaAngleIncrement, "Specify the omega angle increment for each given sample in a PowderXRD experiment:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, OmegaAngleIncrement -> {0.1*AngularDegree, 1*AngularDegree}],
			True
		],
		Example[{Options, DetectorDistance, "Specify the detector distance for each given sample in a PowderXRD experiment:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 200*Millimeter}],
			True
		],
		Example[{Options, DetectorDistance, "DetectorDistance automatically resolves to the smallest value allowed given the constraints provided by the omega and detector angles:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> {-4.99*AngularDegree, -17.24*AngularDegree}, MaxOmegaAngle -> {4.99*AngularDegree, 17.24*AngularDegree}],
			True
		],
		Example[{Options, DetectorRotation, "Specify whether the DetectorRotation option should be Fixed or Sweeping for each sample:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}],
			True
		],
		Example[{Options, DetectorRotation, "If MinDetectorAngle, MaxDetectorAngle, or DetectorAngleIncrement are specified, DetectorRotation resolves to Sweeping; otherwise it resolves to Fixed:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> {0*AngularDegree, Null}],
			True
		],
		Example[{Options, MinOmegaAngle, "Specify the minimum angle between the sample and X-ray source for each sample:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> -10*AngularDegree],
			True
		],
		Example[{Options, MinOmegaAngle, "If not specified, MinOmegaAngle resolves to the lowest value allowed by the specified DetectorDistance and/or DetectorRotation options:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}],
			True
		],
		Example[{Options, MaxOmegaAngle, "Specify the maximum angle between the sample and X-ray source for each sample:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxOmegaAngle -> 10*AngularDegree],
			True
		],
		Example[{Options, MaxOmegaAngle, "If not specified, MaxOmegaAngle resolves to the largest value allowed by the specified DetectorDistance and/or DetectorRotation options:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}],
			True
		],
		Example[{Options, FixedDetectorAngle, "Specify the fixed angle between the detector and X-ray source for each sample:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> 10*AngularDegree],
			True
		],
		Example[{Options, FixedDetectorAngle, "FixedDetectorAngle resolves to 0 AngularDegree if DetectorRotation -> Fixed, and Null if DetectorRotation -> Sweeping:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}],
			True
		],
		Example[{Options, MinDetectorAngle, "Specify the minimum angle between the detector and X-ray source when sweeping the detector for each sample:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> -10*AngularDegree],
			True
		],
		Example[{Options, MinDetectorAngle, "MinDetectorAngle automatically resolves to 0 AngularDegree if DetectorRotation -> Sweeping, or Null if DetectorRotation -> Fixed:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Sweeping, Fixed}],
			True
		],
		Example[{Options, MaxDetectorAngle, "Specify the maximum angle between the detector and X-ray source when sweeping the detector for each sample:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> 80*AngularDegree],
			True
		],
		Example[{Options, MaxDetectorAngle, "MaxDetectorAngle automatically resolves to the largest value allowed by the specified DetectorDistance if DetectorRotation -> Sweeping, or Null if DetectorRotation -> Fixed:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, 70*Millimeter}, DetectorRotation -> {Sweeping, Sweeping, Fixed}],
			True
		],
		Example[{Options, DetectorAngleIncrement, "Specify increment between the angles between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorAngleIncrement -> 20*AngularDegree, Output -> Options],
			True
		],
		Example[{Options, DetectorAngleIncrement, "DetectorAngleIncrement resolves to 0.25 * (the difference between MaxDetectorAngle and MinDetectorAngle), or Null if DetectorRotation -> Fixed:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> {0*AngularDegree, Null}, MaxDetectorAngle -> {80*AngularDegree, Null}, DetectorRotation -> {Sweeping, Fixed}],
			True
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to pre-create standard solutions to perform experiments on:"},
			ValidExperimentPowderXRDQ[
				{"NIST standard sample 1", "NIST standard sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "NIST standard sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "NIST standard sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 1",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 2",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
						Amount -> {80*Microliter, 80*Microliter},
						Destination -> {"NIST standard sample 1", "NIST standard sample 2"}
					]
				}
			],
			True
		],
		Example[{Messages, "DiscardedSamples", "Throws an error if trying to run on discarded samples:"},
			ValidExperimentPowderXRDQ[Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (Discarded)" <> $SessionUUID]],
			False
		],
		Example[{Messages, "DeprecatedModels", "Throws an error if trying to run on samples with deprecated models:"},
			ValidExperimentPowderXRDQ[Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]],
			False
		],
		Example[{Messages, "DuplicateName", "Throws an error if trying set Name to the same as an existing protocol object:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Name -> "ValidPowderXRDQ Protocol 1" <> $SessionUUID],
			False
		],
		Example[{Messages, "FixedOptionsWhileSweeping", "FixedDetectorAngle may not be specified when DetectorRotation -> Sweeping:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> 10*AngularDegree, DetectorRotation -> Sweeping],
			False
		],
		Example[{Messages, "SweepingOptionsWhileFixed", "MinDetectorAngle, MaxDetectorAngle, and/or DetectorAngleIncrement may not be specified when DetectorRotation -> Fixed:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> 80*AngularDegree, DetectorRotation -> Fixed],
			False
		],
		Example[{Messages, "MinOmegaAboveMax", "MinOmegaAngle cannot be greater than MaxOmegaAngle:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> 10*AngularDegree, MaxOmegaAngle -> 4.99*AngularDegree],
			False
		],
		Example[{Messages, "MinDetectorAngleAboveMax", "MinDetectorAngle cannot be greater than MaxDetectorAngle:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> 10*AngularDegree, MaxDetectorAngle -> 4.99*AngularDegree],
			False
		],
		Example[{Messages, "DetectorAngleIncrementTooLarge", "DetectorAngleIncrement cannot be greater than the difference between MaxDetectorAngle and MinDetectorAngle:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> 10*AngularDegree, MaxDetectorAngle -> 20*AngularDegree, DetectorAngleIncrement -> 15 AngularDegree],
			False
		],
		Example[{Messages, "DetectorAngleIncrementTooLarge", "The difference between MaxDetectorAngle and MinDetectorAngle cannot be less than the minimum DetectorAngleIncrement:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> 10*AngularDegree, MaxDetectorAngle -> 10.05*AngularDegree],
			False
		],
		Example[{Messages, "OmegaAngleIncrementTooLarge", "OmegaAngleIncrement cannot be greater than the difference between MaxOmegaAngle and MinOmegaAngle:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> 10*AngularDegree, MaxOmegaAngle -> 11*AngularDegree, OmegaAngleIncrement -> 2 AngularDegree],
			False
		],
		Example[{Messages, "OmegaAngleIncrementTooLarge", "The difference between MaxOmegaAngle and MinOmegaAngle cannot be less than the minimum OmegaAngleIncrement:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> 10*AngularDegree, MaxOmegaAngle -> 10.05*AngularDegree],
			False
		],
		Example[{Messages, "FixedOptionsRequiredTogether", "FixedDetectorAngle cannot be set to Null while DetectorRotation -> Fixed:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> Null, DetectorRotation -> Fixed],
			False
		],
		Example[{Messages, "SweepingOptionsRequiredTogether", "MinDetectorAngle, MaxDetectorAngle, and/or DetectorAngleIncrement cannot be set to Null while DetectorRotation -> Sweeping:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> {Automatic, Null, Automatic}, MinDetectorAngle -> {Null, Automatic, Automatic}, DetectorAngleIncrement -> {Automatic, Automatic, Null}, DetectorRotation -> Sweeping],
			False
		],
		Example[{Messages, "FixedOptionsWhileSweeping", "MinOmegaAngle and MaxOmegaAngle must be Null if DetectorRotation -> Sweeping:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> {Automatic, -4.99*AngularDegree}, MaxOmegaAngle -> {10*AngularDegree, Automatic}, DetectorRotation -> Sweeping],
			False
		],
		Example[{Messages, "DetectorTooClose", "DetectorDistance may not be closer than is allowed by the specified angles:"},
			ValidExperimentPowderXRDQ[{Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> -17.24*AngularDegree, DetectorDistance -> 60*Millimeter],
			False
		],
		Example[{Messages, "PowderXRDHighVolume", "If dealing with a volume over 100 uL, throw a warning:"},
			ValidExperimentPowderXRDQ[Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID]],
			True
		],
		Example[{Messages, "SpottingVolumeTooLarge", "If the SpottingVolume is greater than the AssayVolume for a given sample, throw an error:"},
			ValidExperimentPowderXRDQ[Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayVolume -> 4 Microliter, SpottingVolume -> 5 Microliter],
			False
		]

	},
	Stubs:>{
		$EmailEnabled=False
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)

	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{existingObjs, objs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Container, Plate, "Crystallization plate 1 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, PowderXRD, "ValidPowderXRDQ Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, PowderXRD, "ValidPowderXRDQ Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
			{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
				container5, sample6, container6, container7, sample7, testProtocol1, testProtSubObjs, completeTheTestProtocol},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						Site -> Link[$Site],
						DeveloperObject -> True
					|>
				];

				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "id:pZx9jo8x59oP"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Container 1 for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						"Container 2 for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						"Crystallization plate 1 for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						"Container 3 for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						"Container 4 for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						"Container 5 for ValidExperimentPowderXRDQ tests" <> $SessionUUID,
						"Container 6 for ValidExperimentPowderXRDQ tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						(* this model is deprecated *)
						Model[Sample, "LCMS Grade Water, 4 Liter"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7}
					},
					InitialAmount -> {
						100*Microliter,
						80*Microliter,
						0.1*Milliliter,
						25*Milliliter,
						1.5*Milliliter,
						100*Microliter,
						100*Microliter
					},
					Name -> {
						"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ValidExperimentPowderXRDQ New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ValidExperimentPowderXRDQ New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ValidExperimentPowderXRDQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ValidExperimentPowderXRDQ New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ValidExperimentPowderXRDQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2, sample, container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7}], ObjectP[]]];

				Upload[Flatten[{
					<|Object -> sample5, Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]]}}|>,
					<|Object -> sample6, Status -> Discarded|>
				}]];

				testProtocol1 = ExperimentPowderXRD[Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "ValidPowderXRDQ Protocol 1" <> $SessionUUID, Confirm -> True, ExposureTime -> 0.3*Second, NumberOfReplicates -> 4];
				completeTheTestProtocol = UploadProtocolStatus[testProtocol1, Completed, FastTrack -> True];
				testProtSubObjs = Flatten[Download[testProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Cases[Flatten[{testProtocol1, testProtSubObjs}], ObjectP[]]]
			]

		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{existingObjs, objs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Container, Plate, "Crystallization plate 1 for ValidExperimentPowderXRDQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ValidExperimentPowderXRDQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, PowderXRD, "ValidPowderXRDQ Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, PowderXRD, "ValidPowderXRDQ Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentPowderXRDOptions*)

DefineTests[ExperimentPowderXRDOptions,
	{
		Example[{Basic, "Perform a powder X-ray diffraction experiment on one sample:"},
			ExperimentPowderXRDOptions[Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Perform a powder X-ray diffraction experiment on provided samples:"},
			ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}],
			_Grid
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, OutputFormat -> List],
			{__Rule}
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Template -> Object[Protocol, PowderXRD, "PowderXRD Options Protocol 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, Template],
			ObjectP[Object[Protocol, PowderXRD, "PowderXRD Options Protocol 1" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Current, "Specify the current of the Instrument in a given PowderXRD experiment:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Current -> 20*Milliampere, OutputFormat -> List];
			Lookup[options, Current],
			20*Milliampere,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Specify the number of replicates for a given PowderXRD experiment:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, NumberOfReplicates -> 3, OutputFormat -> List];
			Lookup[options, NumberOfReplicates],
			3,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ExposureTime, "Specify the exposure time for each given sample in a PowderXRD experiment:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, ExposureTime -> {0.1*Second, 0.03*Second}, OutputFormat -> List];
			Lookup[options, ExposureTime],
			{0.1*Second, 0.03*Second},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, OmegaAngleIncrement, "Specify the omega angle increment for each given sample in a PowderXRD experiment:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, OmegaAngleIncrement -> {0.1*AngularDegree, 1*AngularDegree}, OutputFormat -> List];
			Lookup[options, OmegaAngleIncrement],
			{0.1*AngularDegree, 1*AngularDegree},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorDistance, "Specify the detector distance for each given sample in a PowderXRD experiment:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 200*Millimeter}, OutputFormat -> List];
			Lookup[options, DetectorDistance],
			{60*Millimeter, 200*Millimeter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorDistance, "DetectorDistance automatically resolves to the smallest value allowed given the constraints provided by the omega and detector angles:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> {-4.99*AngularDegree, -17.24*AngularDegree}, MaxOmegaAngle -> {4.99*AngularDegree, 17.24*AngularDegree}, OutputFormat -> List];
			Lookup[options, DetectorDistance],
			{60*Millimeter, 70*Millimeter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorRotation, "Specify whether the DetectorRotation option should be Fixed or Sweeping for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}, OutputFormat -> List];
			Lookup[options, DetectorRotation],
			{Fixed, Sweeping},
			Variables :> {options}
		],
		Example[{Options, DetectorRotation, "If MinDetectorAngle, MaxDetectorAngle, or DetectorAngleIncrement are specified, DetectorRotation resolves to Sweeping; otherwise it resolves to Fixed:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> {0*AngularDegree, Null}, OutputFormat -> List];
			Lookup[options, DetectorRotation],
			{Sweeping, Fixed},
			Variables :> {options}
		],
		Example[{Options, MinOmegaAngle, "Specify the minimum angle between the sample and X-ray source for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinOmegaAngle -> -10*AngularDegree, OutputFormat -> List];
			Lookup[options, MinOmegaAngle],
			-10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MinOmegaAngle, "If not specified, MinOmegaAngle resolves to the lowest value allowed by the specified DetectorDistance and/or DetectorRotation options:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}, OutputFormat -> List];
			Lookup[options, MinOmegaAngle],
			{-4.99*AngularDegree, -17.24*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxOmegaAngle, "Specify the maximum angle between the sample and X-ray source for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxOmegaAngle -> 10*AngularDegree, OutputFormat -> List];
			Lookup[options, MaxOmegaAngle],
			10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxOmegaAngle, "If not specified, MaxOmegaAngle resolves to the largest value allowed by the specified DetectorDistance and/or DetectorRotation options:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, Automatic}, DetectorRotation -> {Fixed, Fixed, Sweeping}, OutputFormat -> List];
			Lookup[options, MaxOmegaAngle],
			{4.99*AngularDegree, 17.24*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FixedDetectorAngle, "Specify the fixed angle between the detector and X-ray source for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, FixedDetectorAngle -> 10*AngularDegree, OutputFormat -> List];
			Lookup[options, FixedDetectorAngle],
			10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FixedDetectorAngle, "FixedDetectorAngle resolves to 0 AngularDegree if DetectorRotation -> Fixed, and Null if DetectorRotation -> Sweeping:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Fixed, Sweeping}, OutputFormat -> List];
			Lookup[options, FixedDetectorAngle],
			{0*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MinDetectorAngle, "Specify the minimum angle between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> -10*AngularDegree, OutputFormat -> List];
			Lookup[options, MinDetectorAngle],
			-10*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MinDetectorAngle, "MinDetectorAngle automatically resolves to 0 AngularDegree if DetectorRotation -> Sweeping, or Null if DetectorRotation -> Fixed:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorRotation -> {Sweeping, Fixed}, OutputFormat -> List];
			Lookup[options, MinDetectorAngle],
			{0*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxDetectorAngle, "Specify the maximum angle between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MaxDetectorAngle -> 80*AngularDegree, OutputFormat -> List];
			Lookup[options, MaxDetectorAngle],
			80*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxDetectorAngle, "MaxDetectorAngle automatically resolves to the largest value allowed by the specified DetectorDistance if DetectorRotation -> Sweeping, or Null if DetectorRotation -> Fixed:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorDistance -> {60*Millimeter, 70*Millimeter, 70*Millimeter}, DetectorRotation -> {Sweeping, Sweeping, Fixed}, OutputFormat -> List];
			Lookup[options, MaxDetectorAngle],
			{56.74*AngularDegree, 68.99*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorAngleIncrement, "Specify increment between the angles between the detector and X-ray source when sweeping the detector for each sample:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, DetectorAngleIncrement -> 20*AngularDegree, OutputFormat -> List];
			Lookup[options, DetectorAngleIncrement],
			20*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DetectorAngleIncrement, "DetectorAngleIncrement resolves to 0.25 * (the difference between MaxDetectorAngle and MinDetectorAngle), or Null if DetectorRotation -> Fixed:"},
			options = ExperimentPowderXRDOptions[{Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID]}, MinDetectorAngle -> {0*AngularDegree, Null}, MaxDetectorAngle -> {80*AngularDegree, Null}, DetectorRotation -> {Sweeping, Fixed}, OutputFormat -> List];
			Lookup[options, DetectorAngleIncrement],
			{20*AngularDegree, Null},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to pre-create standard solutions to perform experiments on:"},
			options = ExperimentPowderXRDOptions[
				{"NIST standard sample 1", "NIST standard sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "NIST standard sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "NIST standard sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 1",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 2",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
						Amount -> {80*Microliter, 80*Microliter},
						Destination -> {"NIST standard sample 1", "NIST standard sample 2"}
					]
				},
				OutputFormat -> List
			];
			Lookup[options, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {options}
		]
	},
	Stubs:>{
		$EmailEnabled=False
	},

	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)

	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{existingObjs, objs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Container, Plate, "Crystallization plate 1 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, PowderXRD, "PowderXRD Options Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, PowderXRD, "PowderXRD Options Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, testProtocol1, testProtSubObjs, completeTheTestProtocol},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						Site -> Link[$Site],
						DeveloperObject -> True
					|>
				];

				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "id:pZx9jo8x59oP"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Container 1 for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						"Container 2 for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						"Crystallization plate 1 for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						"Container 3 for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						"Container 4 for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						"Container 5 for ExperimentPowderXRDOptions tests" <> $SessionUUID,
						"Container 6 for ExperimentPowderXRDOptions tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						(* this model is deprecated *)
						Model[Sample, "LCMS Grade Water, 4 Liter"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7}
					},
					InitialAmount -> {
						100*Microliter,
						80*Microliter,
						0.1*Milliliter,
						25*Milliliter,
						1.5*Milliliter,
						1.5*Milliliter,
						1.5*Milliliter
					},
					Name -> {
						"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ExperimentPowderXRDOptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ExperimentPowderXRDOptions New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentPowderXRDOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentPowderXRDOptions New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentPowderXRDOptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2, sample, container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7}], ObjectP[]]];
				Upload[Flatten[{
					<|Object -> sample5, Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]]}}|>,
					<|Object -> sample6, Status -> Discarded|>
				}]];

				testProtocol1 = ExperimentPowderXRD[Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "PowderXRD Options Protocol 1" <> $SessionUUID, Confirm -> True, ExposureTime -> 0.3*Second, NumberOfReplicates -> 4];
				completeTheTestProtocol = UploadProtocolStatus[testProtocol1, Completed, FastTrack -> True];
				testProtSubObjs = Flatten[Download[testProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Flatten[{testProtocol1, testProtSubObjs}]]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{existingObjs, objs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Container, Plate, "Crystallization plate 1 for ExperimentPowderXRDOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDOptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, PowderXRD, "PowderXRD Options Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, PowderXRD, "PowderXRD Options Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentPowderXRDPreview*)

DefineTests[ExperimentPowderXRDPreview,
	{
		Example[{Basic, "Perform a powder X-ray diffraction experiment on one sample:"},
			ExperimentPowderXRDPreview[Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (100 uL)" <> $SessionUUID]],
			Null
		],
		Example[{Basic, "Perform a powder X-ray diffraction experiment on provided samples:"},
			ExperimentPowderXRDPreview[{Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (80 uL)" <> $SessionUUID]}],
			Null
		],
		Example[{Basic, "Perform a powder X-ray diffraction experiment on provided samples when specifying some options:"},
			ExperimentPowderXRDPreview[{Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (80 uL)" <> $SessionUUID]}, Current -> 20*Milliampere],
			Null
		]
	},
	Stubs:>{
		$EmailEnabled=False
	},

	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)

	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		With[
			{existingObjs = Select[
				{
					Object[Container, Bench, "Bench for ExperimentPowderXRDPreview tests"],
					Object[Container, Vessel, "Container 1 for ExperimentPowderXRDPreview tests"],
					Object[Container, Vessel, "Container 2 for ExperimentPowderXRDPreview tests"],
					Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (80 uL)" <> $SessionUUID]
				},
				DatabaseMemberQ[#]&
			]},
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, sample, sample2},

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ExperimentPowderXRDPreview tests" <> $SessionUUID, DeveloperObject -> True|>];
				{
					container,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Container 1 for ExperimentPowderXRDPreview tests" <> $SessionUUID,
						"Container 2 for ExperimentPowderXRDPreview tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container},
						{"A1", container2}
					},
					InitialAmount -> {
						100*Microliter,
						80*Microliter
					},
					Name -> {
						"ExperimentPowderXRDPreview New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentPowderXRDPreview New Test Chemical 1 (80 uL)" <> $SessionUUID
					}
				];
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2}], ObjectP[]]
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		With[
			{existingObjs = Select[
				{
					Object[Container, Bench, "Bench for ExperimentPowderXRDPreview tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 1 for ExperimentPowderXRDPreview tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentPowderXRDPreview tests" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentPowderXRDPreview New Test Chemical 1 (80 uL)" <> $SessionUUID]
				},
				DatabaseMemberQ[#]&
			]},
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
