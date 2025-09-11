(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentTotalProteinQuantification: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*ExperimentTotalProteinQuantification*)

DefineTests[
	ExperimentTotalProteinQuantification,
	{
		(* -- Basic Examples -- *)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID]],
			ObjectP[Object[Protocol,TotalProteinQuantification]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			ExperimentTotalProteinQuantification[Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantification tests"<>$SessionUUID]],
			ObjectP[Object[Protocol,TotalProteinQuantification]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a mixture of sample objects and non-empty container objects:"},
			ExperimentTotalProteinQuantification[{Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],Object[Container,Vessel,"Test container 3 for ExperimentTotalProteinQuantification tests"<>$SessionUUID]}],
			ObjectP[Object[Protocol,TotalProteinQuantification]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Additional Examples -- *)
		(* -- Message tests -- *)
		(* Error Messages before option resolution *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentTotalProteinQuantification[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentTotalProteinQuantification[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentTotalProteinQuantification[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentTotalProteinQuantification[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentTotalProteinQuantification[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentTotalProteinQuantification[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"Discarded Samples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test discarded test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"TooManyTotalProteinQuantificationInputs","No more than 80 samples can be analyzed in one protocol:"},
			ExperimentTotalProteinQuantification[Table[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],81],StandardCurveReplicates->1],
			$Failed,
			Messages :> {
				Error::TooManyTotalProteinQuantificationInputs,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidTotalProteinQuantificationStandardCurveOptions","If ProteinStandards is Null, non of ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent can be Null:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ProteinStandards->Null,ConcentratedProteinStandard->Null],
			$Failed,
			Messages :> {
				Error::InvalidTotalProteinQuantificationStandardCurveOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationAssayTypeDetectionModeMismatch","The AssayType and DetectionMode must not be in conflict:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->BCA,DetectionMode->Fluorescence],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationAssayTypeDetectionModeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationAbsorbanceFluorescenceOptionsMismatch","The AssayType and/or DetectionMode which require an absorbance assay are not in conflict with the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->BCA,ExcitationWavelength->550*Nanometer],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationAbsorbanceFluorescenceOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationFluorescenceOptionsMismatch","The AssayType and/or DetectionMode which require a fluorescence assay are not in conflict with the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->FluorescenceQuantification,ExcitationWavelength->Null],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationFluorescenceOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationNullFluorescenceOptionsMismatch","If any of ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain are Null, none of the others can be specified:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],ExcitationWavelength->Null,EmissionReadLocation->Top],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationNullFluorescenceOptionsMismatch,
				Error::TotalProteinQuantificationFluorescenceOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TotalProteinQuantificationReagentNotOptimal", "If the specified QuantificationReagent is not the default QuantificationReagent Model for the AssayType, a warning message is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->Bradford,QuantificationReagent -> Model[Sample, StockSolution, "id:XnlV5jK8B0lo"], Output -> Options];
			Lookup[options, QuantificationReagent],
			Model[Sample, StockSolution, "id:XnlV5jK8B0lo"],
			Variables :> {options},
			Messages :> {
				Warning::TotalProteinQuantificationReagentNotOptimal
			}
		],
		Example[{Messages, "TotalProteinQuantificationMultipleProteinStandardIdentityModels", "If the specified ProteinStandards don't all have the same Model[Molecule,Protein] in their Composition field, a warning message is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],ProteinStandards->{Model[Sample,"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.5 mg/mL Bovine gamma-Globulin Standard - Quick Start BGG Standard Set"]}, Output -> Options];
			Lookup[options, ProteinStandards],
			{ObjectP[Model[Sample,"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]],ObjectP[Model[Sample,"0.5 mg/mL Bovine gamma-Globulin Standard - Quick Start BGG Standard Set"]]},
			Variables :> {options},
			Messages :> {
				Warning::TotalProteinQuantificationMultipleProteinStandardIdentityModels
			}
		],
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs contain temporal links:"},
			ExperimentTotalProteinQuantification[Link[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],Now]
			],
			ObjectP[Object[Protocol,TotalProteinQuantification]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages, "TotalProteinQuantificationDuplicateProteinStandards", "If the specified ProteinStandards contain a duplicate entry, a warning message is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],ProteinStandards -> {Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.75 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"2 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]}, Output -> Options];
			Lookup[options, ProteinStandards],
			{ObjectP[Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]],ObjectP[Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]],ObjectP[Model[Sample,"0.75 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]],ObjectP[Model[Sample,"1 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]],ObjectP[Model[Sample,"1.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]],ObjectP[Model[Sample,"2 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]]},
			Variables :> {options},
			Messages :> {
				Warning::TotalProteinQuantificationDuplicateProteinStandards
			}
		],
		Example[{Messages,"TotalProteinQuantificationInvalidQuantificationWavelengthSpan","If the QuantificationWavelength is specified as a Span, the first element must be a shorter wavelength than the last:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], QuantificationWavelength->600*Nanometer;;550*Nanometer],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationInvalidQuantificationWavelengthSpan,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationCustomAssayTypeInvalid","If the AssayType has been specified as Custom, the QuantificationReagent option must also be specified:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->Custom],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationCustomAssayTypeInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationWavelengthMismatch","The smallest member of QuantificationWavelength must be at least 25 nm larger than the ExcitationWavelength:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->FluorescenceQuantification,ExcitationWavelength->540*Nanometer,QuantificationWavelength->550*Nanometer],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationWavelengthMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationInvalidQuantificationWavelengthList","If the QuantificationWavelength option is specified as a List, it cannot contain any duplicate values:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],QuantificationWavelength->{500,550,600,550}*Nanometer],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationInvalidQuantificationWavelengthList,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationInvalidVolumes","The sum of the LoadingVolume and QuantificationReagentVolume cannot be larger than 300 uL:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], LoadingVolume->150*Microliter,QuantificationReagentVolume->200*Microliter],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationInvalidVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationUnsupportedInstrument","The specified instrument must be either of Model Model[Instrument, PlateReader, \"id:mnk9jO3qDzpY\"] (FLUOstar Omega) or Model[Instrument, PlateReader, \"id:E8zoYvNkmwKw\"] (CLARIOstar):"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Instrument->Object[Instrument, PlateReader, "Luna Lovegood"]],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationUnsupportedInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationInstrumentOptionMismatch","The specified instrument option must not be in conflict with the AssayType or DetectionMode options:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->Bradford,Instrument->Model[Instrument, PlateReader,"CLARIOstar"]],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationInstrumentOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationInstrumentFluoresceneceOptionsMisMatch","The specified instrument option must not be in conflict with the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],Instrument->Model[Instrument, PlateReader,"CLARIOstar"],ExcitationWavelength->Null],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationInstrumentFluoresceneceOptionsMisMatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationReactionOptionsMisMatch","The QuantificationReactionTime and QuantificationReactionTemperature options cannot be in conflict. One cannot be Null if the other is specified:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], QuantificationReactionTime->Null,QuantificationReactionTemperature->50*Celsius],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationReactionOptionsMisMatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationConcentratedProteinStandardInvalid","The ConcentratedProteinStandard must have InitialMassConcentration informed if it is a Model, or either TotalProteinConcentration or MassConcentration informed if it is an Object:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ConcentratedProteinStandard->Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationConcentratedProteinStandardInvalid,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinQuantificationNullProteinStandardConcentration","All members of ProteinStandards must have InitialMassConcentration informed if they are Models, or either TotalProteinConcentration or MassConcentration informed if they are Objects:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ProteinStandards->{Model[Sample,"0.125 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample, "Milli-Q water"]}],
			$Failed,
			Messages :> {
				Error::TotalProteinQuantificationNullProteinStandardConcentration,
				Warning::TotalProteinQuantificationMultipleProteinStandardIdentityModels,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TotalProteinQuantificationLoadingVolumeLow", "If the QuantificationReagentVolume has been set to a larger than default volume which necessitates that the LoadingVolume resolves to a smaller than default volume, a warning is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], QuantificationReagentVolume -> 298*Microliter, Output -> Options];
			Lookup[options, LoadingVolume],
			2*Microliter,
			Variables :> {options},
			Messages :> {
				Warning::TotalProteinQuantificationLoadingVolumeLow
			}
		],
		Example[{Messages, "TotalProteinQuantificationTotalVolumeLow", "If the sum of the LoadingVolume and the QuantificationReagentVolume options is less than 60 uL, a warning is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], LoadingVolume->20*Microliter,QuantificationReagentVolume -> 30*Microliter, Output -> Options];
			Lookup[options, LoadingVolume],
			20*Microliter,
			Variables :> {options},
			Messages :> {
				Warning::TotalProteinQuantificationTotalVolumeLow
			}
		],
		Example[{Messages, "NonDefaultTotalProteinQuantificationReaction", "If the QuantificationReactionTime or QuantificationReactionTemperature options are specified and the AssayType is not BCA, a warning is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->Bradford,QuantificationReactionTime->30*Minute, Output -> Options];
			Lookup[options, AssayType],
			Bradford,
			Variables :> {options},
			Messages :> {
				Warning::NonDefaultTotalProteinQuantificationReaction
			}
		],
		Example[{Messages, "TotalProteinQuantificationQuantificationReagentVolumeLow", "If the LoadingVolume has been set to a larger than default volume which necessitates that the QuantificationReagentVolume resolves to a smaller than default volume, a warning is thrown:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], LoadingVolume -> 150*Microliter, Output -> Options];
			Lookup[options, QuantificationReagentVolume],
			150*Microliter,
			Variables :> {options},
			Messages :> {
				Warning::TotalProteinQuantificationQuantificationReagentVolumeLow
			}
		],
		Example[{Messages,"NotEnoughTotalProteinQuantificationWellsAvailable","The maximum number of available wells in the QuantificationPlate is 96:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], NumberOfReplicates->10,StandardCurveReplicates->12],
			$Failed,
			Messages :> {
				Error::NotEnoughTotalProteinQuantificationWellsAvailable,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidTotalProteinConcentratedProteinStandardOptions","If informed, the ConcentratedProteinStandard must have an InitialMassConcentration, TotalProteinConcentration, or MassConcentration that is equal to or larger than the largest concentration in StandardCurveConcentrations:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ConcentratedProteinStandard->Model[Sample, "0.75 mg/mL Bovine gamma-Globulin Standard - Quick Start BGG Standard Set"],StandardCurveConcentrations->{0.05,0.1,0.2,0.6,2}*Milligram/Milliliter],
			$Failed,
			Messages :> {
				Error::InvalidTotalProteinConcentratedProteinStandardOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalProteinStandardCurveConcentrationsTooLow","If informed, the ConcentratedProteinStandard must have an InitialMassConcentration, TotalProteinConcentration, or MassConcentration that is equal to or smaller than 400 times the smallest value of StandardCurveConcentrations:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ConcentratedProteinStandard->Model[Sample,"2 mg/mL Bovine Serum Albumin Standard"],StandardCurveConcentrations->{0.001,0.002,0.003,0.02,2}*Milligram/Milliliter],
			$Failed,
			Messages :> {
				Error::TotalProteinStandardCurveConcentrationsTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidTotalProteinResolvedExcitationWavelength","If the DetectionMode is Fluorescence, the QuantificationWavelength must be larger than 344 nm or the ExcitationWavelength will resolve to a wavelength too close to the QuantificationWavelength:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->FluorescenceQuantification,QuantificationWavelength->340*Nanometer],
			$Failed,
			Messages :> {
				Error::InvalidTotalProteinResolvedExcitationWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidTotalProteinFluorescenceQuantificationWavelength","If the DetectionMode is Fluorescence, the QuantificationWavelength must be no larger than 740 nm:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayType->FluorescenceQuantification,QuantificationWavelength->800*Nanometer],
			$Failed,
			Messages :> {
				Error::InvalidTotalProteinFluorescenceQuantificationWavelength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingStandardsStorageCondition","If ProteinStandards is Null, ProteinStandardsStorageCondition cannot be specified:"},
			ExperimentTotalProteinQuantification[Object[Sample, "Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ProteinStandards -> Null, ProteinStandardsStorageCondition -> Freezer],
			$Failed,
			Messages :> {
				Error::ConflictingStandardsStorageCondition,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingStandardsStorageCondition","If ConcentratedProteinStandard is Null, ConcentratedProteinStandardStorageCondition cannot be specified:"},
			ExperimentTotalProteinQuantification[Object[Sample, "Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ConcentratedProteinStandard -> Null, ConcentratedProteinStandardStorageCondition -> Freezer],
			$Failed,
			Messages :> {
				Error::ConflictingStandardsStorageCondition,
				Error::InvalidOption
			}
		],

		(* - Option Unit Tests - *)
		(* Option Precision Tests *)
		Example[{Options,StandardCurveConcentrations,"Rounds specified StandardCurveConcentrations to the nearest 0.001 mg/mL:"},
			roundedStandardCurveConcentrationsOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				StandardCurveConcentrations->{0.0101,0.02,0.1,0.2,0.3,0.4}*Milligram/Milliliter,Output->Options];
			Lookup[roundedStandardCurveConcentrationsOptions,StandardCurveConcentrations],
			{0.01,0.02,0.1,0.2,0.3,0.4}*Milligram/Milliliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LoadingVolume,"Rounds specified LoadingVolume to the nearest 0.1 uL:"},
			roundedLoadingVolumeOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				LoadingVolume->4.98*Microliter,Output->Options];
			Lookup[roundedLoadingVolumeOptions,LoadingVolume],
			5*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,QuantificationReagentVolume,"Rounds specified QuantificationReagentVolume to the nearest 0.1 uL:"},
			roundedQuantificationReagentVolumeOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReagentVolume->249.99*Microliter,Output->Options];
			Lookup[roundedQuantificationReagentVolumeOptions,QuantificationReagentVolume],
			250*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,QuantificationReactionTime,"Rounds specified QuantificationReactionTime to the nearest 1 min:"},
			roundedQuantificationReactionTimeOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReactionTime->5.3*Minute,AssayType->BCA,Output->Options];
			Lookup[roundedQuantificationReactionTimeOptions,QuantificationReactionTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,QuantificationReactionTemperature,"Rounds specified QuantificationReactionTemperature to the nearest 1 degree Celsius:"},
			roundedQuantificationReactionTemperatureOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReactionTemperature->37.1*Celsius,AssayType->BCA,Output->Options];
			Lookup[roundedQuantificationReactionTemperatureOptions,QuantificationReactionTemperature],
			37*Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,ExcitationWavelength,"Rounds specified ExcitationWavelength to the nearest 1 nm:"},
			roundedExcitationWavelengthOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ExcitationWavelength->450.3*Nanometer,AssayType->FluorescenceQuantification,Output->Options];
			Lookup[roundedExcitationWavelengthOptions,ExcitationWavelength],
			450*Nanometer,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,QuantificationTemperature,"Rounds specified QuantificationTemperature to the nearest 1 Celsius:"},
			roundedQuantificationTemperatureOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationTemperature->28.1*Celsius,Output->Options];
			Lookup[roundedQuantificationTemperatureOptions,QuantificationTemperature],
			28*Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,QuantificationEquilibrationTime,"Rounds specified QuantificationEquilibrationTime to the nearest 1 minute:"},
			roundedQuantificationEquilibrationTimeOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationEquilibrationTime->3.2*Minute,Output->Options];
			Lookup[roundedQuantificationEquilibrationTimeOptions,QuantificationEquilibrationTime],
			3*Minute,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,EmissionGain,"Rounds specified EmissionGain to the nearest 1 percent:"},
			roundedEmissionGainOptions=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				EmissionGain->87.4*Percent, AssayType->FluorescenceQuantification,Output->Options];
			Lookup[roundedEmissionGainOptions,EmissionGain],
			87*Percent,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		(* - Options with Defaults Tests - *)
		Example[{Options,StandardCurveReplicates,"The StandardCurveReplicates option defaults to 2:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				Output->Options];
			Lookup[options,StandardCurveReplicates],
			2,
			Variables :> {options}
		],
		(* - Option Resolution Tests - *)
		Example[{Options,AssayType,"The AssayType option defaults to Bradford if the supplied QuantificationReagent is of Model Model[Sample, \"Quick Start Bradford 1x Dye Reagent\"]:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReagent->Model[Sample, "Quick Start Bradford 1x Dye Reagent"],Output->Options];
			Lookup[options,AssayType],
			Bradford,
			Variables :> {options}
		],
		Example[{Options,AssayType,"The AssayType option defaults to BCA if the supplied QuantificationReagent is of Model Model[Sample,StockSolution,\"Pierce BCA Protein Assay Quantification Reagent\"]:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReagent->Model[Sample,StockSolution,"Pierce BCA Protein Assay Quantification Reagent"],Output->Options];
			Lookup[options,AssayType],
			BCA,
			Variables :> {options}
		],
		Example[{Options,AssayType,"The AssayType option defaults to FluorescenceQuantification if the supplied QuantificationReagent is of Model Model[Sample,StockSolution,\"Quant-iT Protein Assay Quantification Reagent\"]:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReagent->Model[Sample,StockSolution,"Quant-iT Protein Assay Quantification Reagent"],Output->Options];
			Lookup[options,AssayType],
			FluorescenceQuantification,
			Variables :> {options}
		],
		Example[{Options,AssayType,"The AssayType option defaults to Bradford if the QuantificationReagent is not specified and the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,AssayType],
			Bradford,
			Variables :> {options}
		],
		Example[{Options,AssayType,"The AssayType option defaults to FluorescenceQuantification if the QuantificationReagent is not specified and the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,Output->Options];
			Lookup[options,AssayType],
			FluorescenceQuantification,
			Variables :> {options}
		],
		Example[{Options,AssayType,"The AssayType option defaults to Bradford if neither the QuantificationReagent nor the DetectionMode is not specified, and none of the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options have been specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				Output->Options];
			Lookup[options,AssayType],
			Bradford,
			Variables :> {options}
		],
		Example[{Options,AssayType,"The AssayType option defaults to FluorescenceQuantification if neither the QuantificationReagent nor the DetectionMode is not specified, and any of the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options have been specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ExcitationWavelength->500*Nanometer,Output->Options];
			Lookup[options,AssayType],
			FluorescenceQuantification,
			Variables :> {options}
		],
		Example[{Options,DetectionMode,"The DetectionMode option defaults to Fluorescence if the AssayType is set to FluorescenceQuantification:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,DetectionMode],
			Fluorescence,
			Variables :> {options}
		],
		Example[{Options,DetectionMode,"The DetectionMode option defaults to Absorbance if the AssayType is set to Bradford or BCA:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,Output->Options];
			Lookup[options,DetectionMode],
			Absorbance,
			Variables :> {options}
		],
		Example[{Options,DetectionMode,"The DetectionMode option defaults to Fluorescence if the AssayType is Custom and any of the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options are specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Custom,QuantificationReagent->Object[Sample,"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID],EmissionReadLocation->Top,Output->Options];
			Lookup[options,DetectionMode],
			Fluorescence,
			Variables :> {options}
		],
		Example[{Options,DetectionMode,"The DetectionMode option defaults to Fluorescence if none of the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options are specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Custom,QuantificationReagent->Object[Sample,"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID],Output->Options];
			Lookup[options,DetectionMode],
			Absorbance,
			Variables :> {options}
		],
		Example[{Options,Instrument,"The Instrument option defaults to Model[Instrument, PlateReader, \"FLUOstar Omega\"] if the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,Instrument],
			Model[Instrument, PlateReader, "FLUOstar Omega"],
			Variables :> {options}
		],
		Example[{Options,Instrument,"The Instrument option defaults to Model[Instrument, PlateReader, \"CLARIOstar\"] if the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,DetectionMode->Fluorescence,Output->Options];
			Lookup[options,Instrument],
			Model[Instrument, PlateReader, "CLARIOstar"],
			Variables :> {options}
		],
		Example[{Options,Instrument,"The function accepts an Object as the Instrument Option:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,DetectionMode->Fluorescence,Instrument->Object[Instrument,PlateReader,"Test CLARIOStar Instrument for ExperimentTotalProteinQuantification tests"<>$SessionUUID],Output->Options];
			Lookup[options,Instrument],
			ObjectP[Object[Instrument,PlateReader,"Test CLARIOStar Instrument for ExperimentTotalProteinQuantification tests"<>$SessionUUID]],
			Variables :> {options}
		],
		Example[{Options,QuantificationReagent,"The QuantificationReagent option defaults to Model[Sample, StockSolution, \"Quant-iT Protein Assay Quantification Reagent\"] if the AssayType is FluorescenceQuantification:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,QuantificationReagent],
			Model[Sample, StockSolution, "Quant-iT Protein Assay Quantification Reagent"],
			Variables :> {options}
		],
		Example[{Options,QuantificationReagent,"The QuantificationReagent option defaults to Model[Sample, \"Quick Start Bradford 1x Dye Reagent\"] if the AssayType is Bradford:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,Output->Options];
			Lookup[options,QuantificationReagent],
			Model[Sample, "Quick Start Bradford 1x Dye Reagent"],
			Variables :> {options}
		],
		Example[{Options,QuantificationReagent,"The QuantificationReagent option defaults to Model[Sample, StockSolution, \"Pierce BCA Protein Assay Quantification Reagent\"] if the AssayType is BCA:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,Output->Options];
			Lookup[options,QuantificationReagent],
			Model[Sample, StockSolution, "Pierce BCA Protein Assay Quantification Reagent"],
			Variables :> {options}
		],
		Example[{Options,QuantificationReactionTime,"The QuantificationReactionTime option defaults to Null if the QuantificationReactionTemperature has been specified as Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				QuantificationReactionTemperature->Null,Output->Options];
			Lookup[options,QuantificationReactionTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,QuantificationReactionTime,"The QuantificationReactionTime option defaults to 1 hour if the AssayType is BCA and the QuantificationReactionTemperature has not been specified as Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,Output->Options];
			Lookup[options,QuantificationReactionTime],
			1*Hour,
			Variables :> {options}
		],
		Example[{Options,QuantificationReactionTime,"The QuantificationReactionTime option defaults to 5 minutes if the AssayType is not BCA and the QuantificationReactionTemperature was specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,QuantificationReactionTemperature->30*Celsius,Output->Options];
			Lookup[options,QuantificationReactionTime],
			5*Minute,
			Variables :> {options},
			Messages:>{
				Warning::NonDefaultTotalProteinQuantificationReaction
			}
		],
		Example[{Options,QuantificationReactionTime,"The QuantificationReactionTime option defaults to Null if the AssayType is not BCA and the QuantificationReactionTemperature was not specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,Output->Options];
			Lookup[options,QuantificationReactionTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,QuantificationReactionTemperature,"The QuantificationReactionTemperature option defaults to Null if the QuantificationReactionTemperature has been specified as or has defaulted to Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,QuantificationReactionTemperature->Null,Output->Options];
			Lookup[options,QuantificationReactionTemperature],
			Null,
			Variables :> {options}
		],
		Example[{Options,QuantificationReactionTemperature,"The QuantificationReactionTemperature option defaults to 25 Celsius if the QuantificationReactionTemperature has been specified or has defaulted to a non-Null value:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,QuantificationReactionTime->15*Minute,Output->Options];
			Lookup[options,QuantificationReactionTemperature],
			25*Celsius,
			Variables :> {options}
		],
		Example[{Options,ExcitationWavelength,"The ExcitationWavelength option defaults to Null if the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,ExcitationWavelength],
			Null,
			Variables :> {options}
		],
		Example[{Options,ExcitationWavelength,"The ExcitationWavelength option defaults to 470 nanometers if the DetectionMode is Fluorescence and the QuantificationWavelength option was not specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,ExcitationWavelength],
			470*Nanometer,
			Variables :> {options}
		],
		Example[{Options,ExcitationWavelength,"The ExcitationWavelength option defaults to 320 nanometers if the DetectionMode is Fluorescence and the QuantificationWavelength option includes a wavelength that is less than or equal to 370 nanometers:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,QuantificationWavelength->360*Nanometer,Output->Options];
			Lookup[options,ExcitationWavelength],
			320*Nanometer,
			Variables :> {options}
		],
		Example[{Options,ExcitationWavelength,"The ExcitationWavelength option defaults to the lower of 470 nanometers or the QuantificationWavelength minus 50 nanometers if the DetectionMode is Fluorescence and the QuantificationWavelength option includes a wavelength that is greater than 370 nanometers:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,QuantificationWavelength->{550,600,650}*Nanometer,Output->Options];
			Lookup[options,ExcitationWavelength],
			470*Nanometer,
			Variables :> {options}
		],
		Example[{Options,EmissionGain,"The EmissionGain option defaults to 90 percent if the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,EmissionGain],
			90*Percent,
			Variables :> {options}
		],
		Example[{Options,EmissionGain,"The EmissionGain option defaults to Null if the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,EmissionGain],
			Null,
			Variables :> {options}
		],
		Example[{Options,NumberOfEmissionReadings,"The NumberOfEmissionReadings option defaults to 100 if the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,NumberOfEmissionReadings],
			100,
			Variables :> {options}
		],
		Example[{Options,NumberOfEmissionReadings,"The NumberOfEmissionReadings option defaults to Null if the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,NumberOfEmissionReadings],
			Null,
			Variables :> {options}
		],
		Example[{Options,EmissionAdjustmentSample,"The EmissionAdjustmentSample option defaults to Null if the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,EmissionAdjustmentSample],
			Null,
			Variables :> {options}
		],
		Example[{Options,EmissionAdjustmentSample,"The EmissionAdjustmentSample option defaults to FullPlate if the DetectionMode is Fluorescence and the Instrument has a model Model[Instrument, PlateReader, \"CLARIOstar\"]:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,Instrument->Model[Instrument, PlateReader, "CLARIOstar"],Output->Options];
			Lookup[options,EmissionAdjustmentSample],
			FullPlate,
			Variables :> {options}
		],
		(* TODO: Test becomes relevant when there are more than 2 accepted instruments for TotalProteinQuantification
		Example[{Options,EmissionAdjustmentSample,"The EmissionAdjustmentSample option defaults to HighestConcentration if the DetectionMode is Fluorescence and the Instrument does not have a model Model[Instrument, PlateReader, \"CLARIOstar\"]:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,EmissionAdjustmentSample],
			HighestConcentration,
			Variables :> {options}
		],
		*)
		Example[{Options,EmissionReadLocation,"The EmissionReadLocation option defaults to Top if the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,EmissionReadLocation],
			Top,
			Variables :> {options}
		],
		Example[{Options,EmissionReadLocation,"The EmissionReadLocation option defaults to Null if the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,EmissionReadLocation],
			Null,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"The QuantificationWavelength option defaults to 595 nanometers if the AssayType is Bradford:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,Output->Options];
			Lookup[options,QuantificationWavelength],
			595*Nanometer,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"The QuantificationWavelength option defaults to 562 nanometers if the AssayType is BCA:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,Output->Options];
			Lookup[options,QuantificationWavelength],
			562*Nanometer,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"The QuantificationWavelength option defaults to 570 nanometers if the AssayType is FluorescenceQuantification:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,QuantificationWavelength],
			570*Nanometer,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"The QuantificationWavelength option defaults to 570 nanometers if the AssayType is Custom and the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Custom,QuantificationReagent->Object[Sample,"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID],DetectionMode->Fluorescence,Output->Options];
			Lookup[options,QuantificationWavelength],
			570*Nanometer,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"The QuantificationWavelength option defaults to 595 nanometers if the AssayType is Custom and the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Custom,QuantificationReagent->Object[Sample,"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID],DetectionMode->Absorbance,Output->Options];
			Lookup[options,QuantificationWavelength],
			595*Nanometer,
			Variables :> {options}
		],
		Example[{Options,LoadingVolume,"The LoadingVolume option defaults to 10 uL if the DetectionMode is Fluorescence and the is QuantificationReagentVolume has not been specified or is less than or equal to 290 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,DetectionMode->Fluorescence,Output->Options];
			Lookup[options,LoadingVolume],
			10*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingVolume,"The LoadingVolume option defaults to 300 uL minus the QuantificationReagentVolume if the DetectionMode is Fluorescence and the is QuantificationReagentVolume is larger than 290 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,DetectionMode->Fluorescence,QuantificationReagentVolume->294*Microliter,Output->Options];
			Lookup[options,LoadingVolume],
			6*Microliter,
			Variables :> {options},
			Messages:>{
				Warning::TotalProteinQuantificationLoadingVolumeLow
			}
		],
		Example[{Options,LoadingVolume,"The LoadingVolume option defaults to 25 uL if the AssayType is BCA and the is QuantificationReagentVolume has not been specified or is less than or equal to 275 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,Output->Options];
			Lookup[options,LoadingVolume],
			25*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingVolume,"The LoadingVolume option defaults to 300 uL minus the QuantificationReagentVolume if the AssayMode is BCA and the is QuantificationReagentVolume is larger than 275 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,QuantificationReagentVolume->288*Microliter,Output->Options];
			Lookup[options,LoadingVolume],
			12*Microliter,
			Variables :> {options},
			Messages:>{
				Warning::TotalProteinQuantificationLoadingVolumeLow
			}
		],
		Example[{Options,LoadingVolume,"The LoadingVolume option defaults to 5 uL if the AssayType is Bradford or Null, the DetectionMode is Absorbance, and the is QuantificationReagentVolume has not been specified or is less than or equal to 295 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,Output->Options];
			Lookup[options,LoadingVolume],
			5*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingVolume,"The LoadingVolume option defaults to 300 uL minus the QuantificationReagentVolume if the AssayMode is Bradford or Null, the DetectionMode is Absorbance, and the is QuantificationReagentVolume is larger than 295 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,QuantificationReagentVolume->297*Microliter,Output->Options];
			Lookup[options,LoadingVolume],
			3*Microliter,
			Variables :> {options},
			Messages:>{
				Warning::TotalProteinQuantificationLoadingVolumeLow
			}
		],
		Example[{Options,QuantificationReagentVolume,"The QuantificationReagentVolume option defaults to 200 uL if the DetectionMode is Fluorescence and the is LoadingVolume has not been specified or is less than or equal to 100 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,DetectionMode->Fluorescence,Output->Options];
			Lookup[options,QuantificationReagentVolume],
			200*Microliter,
			Variables :> {options}
		],
		Example[{Options,QuantificationReagentVolume,"The QuantificationReagentVolume option defaults to 300 uL minus the QuantificationReagentVolume if the DetectionMode is Fluorescence and the is LoadingVolume is larger than 100 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,DetectionMode->Fluorescence,LoadingVolume->120*Microliter,Output->Options];
			Lookup[options,QuantificationReagentVolume],
			180*Microliter,
			Variables :> {options},
			Messages:>{
				Warning::TotalProteinQuantificationQuantificationReagentVolumeLow
			}
		],
		Example[{Options,QuantificationReagentVolume,"The QuantificationReagentVolume option defaults to 250 uL if the AssayType is BCA and the is LoadingVolume has not been specified or is less than or equal to 50 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,Output->Options];
			Lookup[options,QuantificationReagentVolume],
			200*Microliter,
			Variables :> {options}
		],
		Example[{Options,QuantificationReagentVolume,"The QuantificationReagentVolume option defaults to 300 uL minus the QuantificationReagentVolume if the AssayMode is BCA and the is LoadingVolume is larger than 100 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->BCA,LoadingVolume->125*Microliter,Output->Options];
			Lookup[options,QuantificationReagentVolume],
			175*Microliter,
			Variables :> {options},
			Messages:>{
				Warning::TotalProteinQuantificationQuantificationReagentVolumeLow
			}
		],
		Example[{Options,QuantificationReagentVolume,"The QuantificationReagentVolume option defaults to 200 uL if the AssayType is Bradford or Null, the DetectionMode is Absorbance, and the is LoadingVolume has not been specified or is less than or equal to 100 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,Output->Options];
			Lookup[options,QuantificationReagentVolume],
			250*Microliter,
			Variables :> {options}
		],
		Example[{Options,QuantificationReagentVolume,"The QuantificationReagentVolume option defaults to 300 uL minus the QuantificationReagentVolume if the AssayMode is Bradford or Null, the DetectionMode is Absorbance, and the is LoadingVolume is larger than 50 uL:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->Bradford,LoadingVolume->75*Microliter,Output->Options];
			Lookup[options,QuantificationReagentVolume],
			225*Microliter,
			Variables :> {options},
			Messages:>{
				Warning::TotalProteinQuantificationQuantificationReagentVolumeLow
			}
		],
		Example[{Options,ProteinStandards,"The ProteinStandards option defaults to the Quick Start BSA Standard Set if the DetectionMode is Absorbance and none of the ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent options are specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,Output->Options];
			Lookup[options,ProteinStandards],
			{Model[Sample,"0.125 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.75 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"2 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]},
			Variables :> {options}
		],
		Example[{Options,ProteinStandards,"The ProteinStandards option defaults to the Quant-iT Protein Assay Standard Set if the DetectionMode is Fluorescence and none of the ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent options are specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				AssayType->FluorescenceQuantification,Output->Options];
			Lookup[options,ProteinStandards],
			{Model[Sample,"25 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"50 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"100 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"200 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"300 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"400 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"500 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"]},
			Variables :> {options}
		],
		Example[{Options,ProteinStandards,"The ProteinStandards option defaults to Null if any of the ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent options are specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ProteinStandardDiluent->Model[Sample, "Milli-Q water"],Output->Options];
			Lookup[options,ProteinStandards],
			Null,
			Variables :> {options}
		],
		Example[{Options,ConcentratedProteinStandard,"The ConcentratedProteinStandard option defaults to Null if the ProteinStandards are specified or automatically are set to anything except Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ProteinStandards->{Model[Sample,"0.125 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.75 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"2 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]},Output->Options];
			Lookup[options,ConcentratedProteinStandard],
			Null,
			Variables :> {options}
		],
		Example[{Options,ConcentratedProteinStandard,"The ConcentratedProteinStandard option defaults to Model[Sample,\"2 mg/mL Bovine Serum Albumin Standard\"] if the ProteinStandards are specified as Null or are automatically set to be Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ProteinStandards->Null,Output->Options];
			Lookup[options,ConcentratedProteinStandard],
			Model[Sample,"2 mg/mL Bovine Serum Albumin Standard"],
			Variables :> {options}
		],
		Example[{Options,ConcentratedProteinStandardStorageCondition,"Indicates the desired storage condition of the ConcentratedProteinStandard after use in the experiment:"},
			options=ExperimentTotalProteinQuantification[Object[Sample, "Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ProteinStandards -> Null, ConcentratedProteinStandardStorageCondition -> Freezer, Output->Options];
			Lookup[options,ConcentratedProteinStandardStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options,ProteinStandardsStorageCondition,"Indicates the desired storage condition of ProteinStandards after use in the experiment:"},
			options=ExperimentTotalProteinQuantification[Object[Sample, "Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ProteinStandardsStorageCondition -> Freezer, Output->Options];
			Lookup[options,ProteinStandardsStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options,StandardCurveConcentrations,"The StandardCurveConcentrations option defaults to Null if the ProteinStandards are specified or automatically are set to anything except Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				Output->Options];
			Lookup[options,StandardCurveConcentrations],
			Null,
			Variables :> {options}
		],
		Example[{Options,StandardCurveConcentrations,"The StandardCurveConcentrations option defaults to {0.125,0.25,0.5,0.75,1,1.5,2}*(Milligram/Milliliter) if the DetectionMode is Absorbance and the ProteinStandards are specified as Null or are automatically set to be Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Absorbance,ProteinStandards->Null,Output->Options];
			Lookup[options,StandardCurveConcentrations],
			{0.125,0.25,0.5,0.75,1,1.5,2}*(Milligram/Milliliter),
			Variables :> {options}
		],
		Example[{Options,StandardCurveConcentrations,"The StandardCurveConcentrations option defaults to {0.025,0.05,0.1,0.2,0.3,0.4,0.5}*(Milligram/Milliliter) if the DetectionMode is Fluorescence and the ProteinStandards are specified as Null or are automatically set to be Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				DetectionMode->Fluorescence,AssayType->FluorescenceQuantification,ProteinStandards->Null,Output->Options];
			Lookup[options,StandardCurveConcentrations],
			{0.025,0.05,0.1,0.2,0.3,0.4,0.5}*(Milligram/Milliliter),
			Variables :> {options}
		],
		Example[{Options,ProteinStandardDiluent,"The ProteinStandardDiluent option defaults to Model[Sample, \"Milli-Q water\"] if the ProteinStandards are specified as Null or are automatically set to be Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ProteinStandards->Null,Output->Options];
			Lookup[options,ProteinStandardDiluent],
			Model[Sample, "Milli-Q water"],
			Variables :> {options}
		],
		Example[{Options,ProteinStandardDiluent,"The ProteinStandardDiluent option defaults to Null if the ProteinStandards are specified or automatically set to be anything except Null:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				Output->Options];
			Lookup[options,ProteinStandardDiluent],
			Null,
			Variables :> {options}
		],
		Example[{Options,StandardCurveBlank,"The StandardCurveBlank option defaults to the StandardCurveDiluent if either the ProteinStandardDiluent or ConcentratedProteinStandard have been specified:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ProteinStandardDiluent->Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID],Output->Options];
			Lookup[options,StandardCurveBlank],
			ObjectP[Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID]],
			Variables :> {options}
		],
		Example[{Options,StandardCurveBlank,"The StandardCurveBlank option defaults to Model[Sample, \"Milli-Q water\"] if either the ProteinStandardDiluent has been set to or has resolved to Null and the DetectionMode is Absorbance:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ProteinStandardDiluent->Null,DetectionMode->Absorbance,Output->Options];
			Lookup[options,StandardCurveBlank],
			Model[Sample, "Milli-Q water"],
			Variables :> {options}
		],
		Example[{Options,StandardCurveBlank,"The StandardCurveBlank option defaults to Model[Sample,\"0 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"] if either the ProteinStandardDiluent has been set to or has resolved to Null and the DetectionMode is Fluorescence:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ConcentratedProteinStandard->Null,DetectionMode->Fluorescence,Output->Options];
			Lookup[options,StandardCurveBlank],
			Model[Sample,"0 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],
			Variables :> {options}
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],Template->Object[Protocol,TotalProteinQuantification,"Test TotalProteinQuantification option template protocol"<>$SessionUUID],Output->Options];
			Lookup[options,AssayType],
			FluorescenceQuantification,
			Variables :> {options}
		],
		Example[{Options,Name,"Name the protocol for TotalProteinQuantification:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],Name->"Super cool test protocol",Output->Options];
			Lookup[options,Name],
			"Super cool test protocol",
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"The maximum number of available wells in the QuantificationPlate is 96:"},
			ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], NumberOfReplicates->10,StandardCurveReplicates->12],
			$Failed,
			Messages :> {
				Error::NotEnoughTotalProteinQuantificationWellsAvailable,
				Error::InvalidOption
			}
		],
		(* - Sample Prep unit tests - *)
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to have their TotalProteinConcentrations measured:"},
			options=ExperimentTotalProteinQuantification[{"Container 1","Container 2"},
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Container 1",
						Container->Model[Container, Vessel, "2mL Tube"]
					],
					LabelContainer[
						Label->"Container 2",
						Container->Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source->Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
						Amount->200*Microliter,
						Destination->"Container 1"
					],
					Transfer[
						Source->Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
						Amount->100*Microliter,
						Destination->"Container 2"
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Amount->100*Microliter,
						Destination->"Container 2"
					]
				},
				Output->Options
			];
			Lookup[options,AssayType],
			Bradford,
			Variables:>{options}
		],

		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True,Output->Options];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->600
		],

		(* Incubate Options *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], IncubateAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* Centrifuge Options *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], CentrifugeTemperature -> 30*Celsius,CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"],AliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], CentrifugeAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		(* Filter Options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FiltrationType -> Syringe,Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterMaterial -> PES,FilterContainerOut->Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID],PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius,Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		(* Aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Aliquot->True,Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AliquotAmount -> 0.5*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayVolume -> 0.5*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test 10 kDa test protein sample for ExperimentTotalProteinQuantification"<>$SessionUUID], TargetConcentration -> 5*Micromolar, AssayVolume->100*Microliter,Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test 10 kDa test protein sample for ExperimentTotalProteinQuantification"<>$SessionUUID], TargetConcentration -> 5*Micromolar,TargetConcentrationAnalyte->Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinQuantification Tests"<>$SessionUUID],AssayVolume->100*Microliter,Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinQuantification Tests"<>$SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],
				BufferDilutionFactor->2,
				BufferDiluent->Model[Sample, "Milli-Q water"],
				AliquotAmount->0.2*Milliliter,
				AssayVolume->0.5*Milliliter,
				Output -> Options
			];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				BufferDiluent->Model[Sample, "Milli-Q water"],
				AliquotAmount->0.1*Milliliter,
				AssayVolume->0.8*Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				AliquotAmount->0.2*Milliliter,
				AssayVolume->0.8*Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AliquotSampleStorageCondition -> Refrigerator,Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentTotalProteinQuantification[{Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID]}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],IncubateAliquotDestinationWell -> "A1",AliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentTotalProteinQuantification[Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentTotalProteinQuantification[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "2mL Tube"],
				PreparedModelAmount -> 1.5 Milliliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "2mL Tube"]]..},
				{EqualP[1.5 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentTotalProteinQuantification[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, TotalProteinQuantification]]
		]
	},
	Parallel -> True,
	HardwareConfiguration -> HighRAM,
	TurnOffMessages :> {Warning::SamplesOutOfStock,Warning::InstrumentUndergoingMaintenance},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User,"Test user for notebook-less test protocols"]
	},
	SetUp:>(
		$CreatedObjects = {};
		ClearMemoization[]
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>(

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentTotalProteinQuantification tests"<>$SessionUUID],

					Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],

					Object[Instrument,PlateReader,"Test CLARIOStar Instrument for ExperimentTotalProteinQuantification tests"<>$SessionUUID],

					Model[Molecule,Protein,"Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinQuantification Tests"<>$SessionUUID],
					Model[Sample,"10 kDa test protein for ExperimentTotalProteinQuantification"<>$SessionUUID],


					Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test discarded test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test 10 kDa test protein sample for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Protocol,TotalProteinQuantification,"Test TotalProteinQuantification option template protocol"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					fakeBench,
					container1,container2,container3,container4,container5,
					sample1,sample2,sample3,sample4,sample5
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentTotalProteinQuantification tests"<>$SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],Site->Link[$Site]|>];

				{
					container1,
					container2,
					container3,
					container4,
					container5
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> Available,
					Name->{
						"Test container 1 for ExperimentTotalProteinQuantification tests"<>$SessionUUID,
						"Test container 2 for ExperimentTotalProteinQuantification tests"<>$SessionUUID,
						"Test container 3 for ExperimentTotalProteinQuantification tests"<>$SessionUUID,
						"Test container 4 for ExperimentTotalProteinQuantification tests"<>$SessionUUID,
						"Test container 5 for ExperimentTotalProteinQuantification tests"<>$SessionUUID
					}
				];

				(* Create a test Model[Molecule,Protein] to populate the Composition field of the test protein input for the TargetConcentration unit test *)
				Upload[
					<|
						Type->Model[Molecule,Protein],
						Name->"Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinQuantification Tests"<>$SessionUUID,
						MolecularWeight->10*(Kilogram/Mole),
						DeveloperObject->True
					|>
				];

				(* Create test protein Models - and a fake instrument *)
				Upload[{
					<|
						Type->Model[Sample],
						Name->"10 kDa test protein for ExperimentTotalProteinQuantification"<>$SessionUUID,
						Replace[Authors]->{Link[Object[User,Emerald,Developer,"spencer.clark"]]},
						DeveloperObject->True,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						Replace[Composition]->{
							{20*Micromolar,Link[Model[Molecule, Protein, "Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinQuantification Tests"<>$SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						}
					|>,
					<|
						Type->Object[Instrument,PlateReader],
						Model->Link[Model[Instrument, PlateReader, "CLARIOstar"],Objects],
						Name->"Test CLARIOStar Instrument for ExperimentTotalProteinQuantification tests"<>$SessionUUID,
						DeveloperObject->True,
						Site->Link[$Site]
					|>
				}];

				{
					sample1,
					sample2,
					sample3,
					sample4,
					sample5
				}=UploadSample[
					{
						Model[Sample, "id:WNa4ZjKMrPeD"],
						Model[Sample, "id:WNa4ZjKMrPeD"],
						Model[Sample, "Milli-Q water"],
						Model[Sample,"10 kDa test protein for ExperimentTotalProteinQuantification"<>$SessionUUID],
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5}
					},
					InitialAmount->{
						1*Milliliter,
						1*Milliliter,
						25*Milliliter,
						1*Milliliter,
						25*Milliliter
					},
					Name->{
						"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID,
						"Test discarded test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID,
						"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID,
						"Test 10 kDa test protein sample for ExperimentTotalProteinQuantification"<>$SessionUUID,
						"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,container3,container4,container5,sample1,sample2,sample3,sample4,sample5}], ObjectP[]]];

				Upload[Cases[Flatten[{
					<|Object -> sample1, Status -> Available|>,
					<|Object -> sample2, Status -> Discarded|>,
					<|Object -> sample3, Status -> Available|>,
					<|Object -> sample4, Status -> Available|>,
					<|Object -> sample5, Status -> Available|>
				}], PacketP[]]];

				(* Make a test protocol for the Template option unit test *)
				Upload[
					{
						<|
							Type->Object[Protocol,TotalProteinQuantification],
							DeveloperObject->True,
							Name->"Test TotalProteinQuantification option template protocol"<>$SessionUUID,
							ResolvedOptions->{AssayType->FluorescenceQuantification}
						|>
					}
				];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentTotalProteinQuantification tests"<>$SessionUUID],

					Object[Container,Vessel,"Test container 1 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 3 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],
					Object[Container,Vessel,"Test container 5 for ExperimentTotalProteinQuantification tests"<>$SessionUUID],

					Object[Instrument,PlateReader,"Test CLARIOStar Instrument for ExperimentTotalProteinQuantification tests"<>$SessionUUID],

					Model[Molecule,Protein,"Test 10 kDa Model[Molecule,Protein] for ExperimentTotalProteinQuantification Tests"<>$SessionUUID],
					Model[Sample,"10 kDa test protein for ExperimentTotalProteinQuantification"<>$SessionUUID],


					Object[Sample,"Test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test discarded test lysate for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test 25 mL water sample in 50mL Tube for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test 10 kDa test protein sample for ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Sample,"Test non-default QuantificationReagent ExperimentTotalProteinQuantification"<>$SessionUUID],
					Object[Protocol,TotalProteinQuantification,"Test TotalProteinQuantification option template protocol"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	)
];
