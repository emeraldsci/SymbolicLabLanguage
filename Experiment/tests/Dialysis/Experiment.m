(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentDialysis: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentDialysis*)

DefineTests[
	ExperimentDialysis,
	{
		(* --- Basic --- *)

		Example[{Basic, "Create a dialysis protocol for a given sample:"},
			ExperimentDialysis[Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]],
			ObjectP[Object[Protocol, Dialysis]]
		],
		Example[{Basic, "Create a dialysis protocol when pooling multiple samples together:"},
			ExperimentDialysis[{
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				{Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]}
			}],
			ObjectP[Object[Protocol, Dialysis]]
		],
		Example[{Basic, "Create a dialysis protocol for a mixture of containers and samples:"},
			ExperimentDialysis[{{Object[Container, Vessel, "50mL tube 1 for ExperimentDialysis tests"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]}}],
			ObjectP[Object[Protocol, Dialysis]]
		],

		(* --- Pooling --- *)

		Example[{Basic, "The sample volume of two samples are added together when pooled:"},
			options=ExperimentDialysis[
				{{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]}},
				Output->Options
			];
			Lookup[options,SampleVolume],
			0.036`Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Basic, "The sample volume of two samples not added together when it is not pooled:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
					Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options
			];
			Lookup[options,SampleVolume],
			{130*Milliliter, 0.035Liter},
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[{Additional, "Accepts {position, container} inputs:"},
			ExperimentDialysis[{{{"A1",Object[Container, Vessel, "50mL tube 1 for ExperimentDialysis tests"<> $SessionUUID]},{"A1",Object[Container, Vessel, "2mL tube 1 for ExperimentDialysis tests"<> $SessionUUID]}}}],
			ObjectP[Object[Protocol, Dialysis]]
		],

		(* --- Option Resolving -- *)

		Example[{Messages, "InstrumentPrecision", "Mix rates may only be specified in increments of 1 RPM:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixRate->306.11116 RPM,
				Output->Options
			];
			Lookup[options,DialysisMixRate],
			306 RPM,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages, "InstrumentPrecision", "Flow rates may only be specified in increments of 0.1 Milliliter/Minute:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				FlowRate->25.75 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,FlowRate],
			25.8 Milliliter/Minute,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages, "InstrumentPrecision", "Volumes may only be specified in increments of 1 Microliter:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				SampleVolume->60.8 Microliter,
				Output->Options
			];
			Lookup[options,SampleVolume],
			61 Microliter,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages, "InstrumentPrecision", "Temperature may only be specified in increments of 1 Celsius:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->45.8 Celsius,
				Output->Options
			];
			Lookup[options,DialysateTemperature],
			46 Celsius,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages, "InstrumentPrecision", "Soak times may only be specified in increments of 1 Second:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMembraneSoakTime->50.1 Second,
				Output->Options
			];
			Lookup[options,DialysisMembraneSoakTime],
			50 Second,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages, "InstrumentPrecision", "Dialysis times and measurement intervals may only be specified in increments of 1 Minute:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisTime->300.1Minute,
				Output->Options
			];
			Lookup[options,DialysisTime],
			300 Minute,
			Messages :> {
				Warning::InstrumentPrecision
			}
		],
		(* --- Invalid Inputs Tests --- *)

		Example[{Messages, "ConflictingStaticDialysisOptions", "The static dialysis options are only set if the DialysisMethod is StaticDialysis:"},
			ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->DynamicDialysis,
				DialysateContainer->Model[Container, Vessel, "id:aXRlGnZmOOJk"]
			],
			$Failed,
			Messages :> {
				Error::ConflictingStaticDialysisOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDynamicDialysisOptions", "The dynamic dialysis options are only set if the DialysisMethod is DynamicDialysis:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->StaticDialysis,
				FlowRate->6 Milliliter/Minute
			],
			$Failed,
			Messages :> {
				Error::ConflictingDynamicDialysisOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysisTooManySamples", "An error is thrown if too many samples are run in a single protocol:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfReplicates -> 100
			],
			$Failed,
			Messages :> {
				Error::DialysisTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DialysisMethodInstrumentMismatch", "The Instrument is appropriate for the DialysisMethod:"},
			ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->DynamicDialysis,
				Instrument -> Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"]
			],
			$Failed,
			Messages :> {
				Error::DialysisMethodInstrumentMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysateTemperatureInstrumentMismatch", "The Instrument can achieve the DialysateTemperature:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->4 Celsius,
				Instrument -> Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"]
			],
			$Failed,
			Messages :> {
				Error::DialysateTemperatureInstrumentMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleVolumeDialysisMembraneMismatch", "The SampleVolume can fit in the DialysisMembrane:"},
			ExperimentDialysis[
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMembrane -> Model[Container, Vessel, Dialysis, "id:8qZ1VW0VPbzp"],
				SampleVolume -> 100 Milliliter
			],
			$Failed,
			Messages :> {
				Error::SampleVolumeDialysisMembraneMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LargeDialysisSampleVolume", "The SampleVolume can fit in the largest DialysisMembrane:"},
			ExperimentDialysis[
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				SampleVolume -> All
			],
			$Failed,
			Messages :> {
				Error::LargeDialysisSampleVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LargeStaticDialysisSampleVolume", "The SampleVolume can fit in the largest DialysisMembrane:"},
			ExperimentDialysis[
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				SampleVolume -> 100Milliliter,
				DialysisMethod->StaticDialysis
			],
			$Failed,
			Messages :> {
				Error::LargeStaticDialysisSampleVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDynamicDialysisOptions", "The options for imaging the system are only not Null if the DialysisMethod is DynamicDialysis:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				ImageSystem -> True,
				DialysisMethod -> StaticDialysis
			],
			$Failed,
			Messages :> {
				Error::ConflictingDynamicDialysisOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleDialysisMembraneTemperature", "The DialysateTemperature between the MinTemperature and MaxTemperature of the DialysisMembrane:"},
			ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMembrane -> Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID],
				DialysateTemperature-> 60 Celsius
			],
			$Failed,
			Messages :> {
				Error::IncompatibleDialysisMembraneTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysateContainerVolume", "The DialysateVolume is between the MinVolume and MaxVolume of the Dialysis Container:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateContainer ->  Model[Container, Vessel, "id:aXRlGnZmOOJk"],
				DialysateVolume -> 1 Liter
			],
			$Failed,
			Messages :> {
				Error::DialysateContainerVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysisMixRateInstrumentMismatch", "The Instrument can achieve the DialysisMixRate:"},
			ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Instrument -> Model[Instrument, OverheadStirrer, "id:rea9jlRRmN05"],
				DialysisMixRate -> 1600 RPM
			],
			$Failed,
			Messages :> {
				Error::DialysisMixRateInstrumentMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDialysateSamplingVolume", "The DialysateSamplingVolume is less than the DialysateVolume:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateSamplingVolume -> {1 Liter, 1.2 Liter},
				DialysateVolume -> {1 Liter, 1 Liter}
			],
			$Failed,
			Messages :> {
				Error::ConflictingDialysateSamplingVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingRetentateSamplingVolume", "The RetentateSamplingVolume less than the SampleVolume:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateSampling->True,
				RetentateSamplingVolume -> {1.8 Milliliter, 1.2 Milliliter},
				SampleVolume -> {1 Milliliter, 1 Milliliter}
			],
			$Failed,
			Messages :> {
				Error::ConflictingRetentateSamplingVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDialysateContainerOut", "The DialysateSamplingVolume less than the max volume of the DialysateContainerOut:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateContainerOut -> Model[Container, Vessel, "id:3em6Zv9Njjbv"],
				SecondaryDialysateContainerOut -> Model[Container, Vessel, "50mL Tube"],
				TertiaryDialysateContainerOut -> Model[Container, Vessel, "50mL Tube"],
				DialysateSamplingVolume -> 1500 Milliliter,
				SecondaryDialysateSamplingVolume -> 1500 Milliliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingDialysateContainerOut,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingRetentateContainerOut", "The RetentateSamplingVolume is less than the max volume of the RetentateSamplingContainerOut:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateSampling->True,
				RetentateSamplingContainerOut -> Model[Container, Vessel, "2mL Tube"],
				SecondaryRetentateSampling->True,
				SecondaryRetentateSamplingContainerOut -> Model[Container, Vessel, "2mL Tube"],
				TertiaryRetentateSampling->True,
				TertiaryRetentateSamplingContainerOut -> Model[Container, Vessel, "2mL Tube"],
				RetentateSamplingVolume -> 3 Milliliter,
				SecondaryRetentateSamplingVolume -> 3 Milliliter
			],
			$Failed,
			Messages :> {
				Error::ConflictingRetentateContainerOut,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingRetentateContainerOutPlate", "The RetentateContainerOut of a sample in dialysis tubing is a vessel:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				DialysisMembrane ->  Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ConflictingRetentateContainerOutPlate,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingRetentateSamplingContainerOutPlate", "The RetentateSamplingContainerOut of a sample in dialysis tubing is a vessel:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateSamplingContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				DialysisMembrane ->  Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ConflictingRetentateSamplingContainerOutPlate,
				Error::InvalidOption
			}
		],
		Example[{Messages, "RetentateSamplingMismatch", "The RetentateSampling options are Null if the RetentateSampling is False:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateSamplingVolume -> {0.2 Milliliter, 0.2Milliliter},
				RetentateSampling -> {True, True},
				TertiaryRetentateSamplingVolume -> {0.18 Milliliter, 0.2 Milliliter},
				TertiaryRetentateSampling -> {True, False}
			],
			$Failed,
			Messages :> {
				Error::RetentateSamplingMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysateSamplingMismatch", "The DialysateSampling options are Null if the DialysateSampling is False:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateSamplingVolume -> {0.2 Milliliter, 0.2Milliliter},
				DialysateSampling -> {True, True},
				TertiaryDialysateSamplingVolume -> {0.18 Milliliter, 0.2 Milliliter},
				TertiaryDialysateSampling -> {True, False}
			],
			$Failed,
			Messages :> {
				Error::DialysateSamplingMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysisInstrumentMismatch", "The Instrument is not compatible with dialysis experiments.:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				Instrument->Model[Instrument, Vortex, "Multi Tube Vortex Genie 2"]
			],
			$Failed,
			Messages :> {
				Error::DialysisInstrumentMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysisMixTypeInstrumentMismatch", "The Instrument cannot support the DialysisMixType:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				Instrument->Model[Instrument, Vortex, "id:o1k9jAGq7pNA"],
				DialysisMixType->Stir
			],
			$Failed,
			Messages :> {
				Error::DialysisMixTypeInstrumentMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "UnresolvableDialysateContainer", "There are no beakers that can support the DialysateVolume:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateVolume->6Liter,
				DialysisMethod->StaticDialysis
			],
			$Failed,
			Messages :> {
				Error::UnresolvableDialysateContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NumberOfDialysisRoundsMismatch", "The Secondary, Tertiary, Quartinary and Quinary Dialysis options do not conflict with NumberOfDialysisRounds:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryRetentateSamplingVolume -> {0.1 Milliliter, 0.1 Milliliter},
				TertiaryRetentateSampling -> True,
				NumberOfDialysisRounds -> 2
			],
			$Failed,
			Messages :> {
				Error::NumberOfDialysisRoundsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NumberOfDialysisRoundsNullMismatch", "The Secondary, Tertiary, Quartinary and Quinary Dialysis options do not conflict with NumberOfDialysisRounds by being Null:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysisTime->Null,
				NumberOfDialysisRounds -> 2
			],
			$Failed,
			Messages :> {
				Error::NumberOfDialysisRoundsNullMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysisMembraneMWCOMismatch", "The MolecularWeightCutoff of Dialysis membrane matches the specified MolecularWeightCutoff:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMembrane -> Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID],
				MolecularWeightCutoff -> 3.5 Kilo Dalton
			],
			$Failed,
			Messages :> {
				Error::DialysisMembraneMWCOMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DialysisMembraneSoakMismatch", "The DialysisMembraneSoak options are only populated if DialysisMembraneSoak is True:"},
			ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMembraneSoak -> False,
				DialysisMembraneSoakTime -> 30 Minute
			],
			$Failed,
			Messages :> {
				Error::DialysisMembraneSoakMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InsufficientDialysateVolume", "The DialysisMembraneSoak options are only populated if DialysisMembraneSoak is True:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod -> DynamicDialysis,
				DialysateVolume -> 1.6 Liter
			],
			$Failed,
			Messages :> {
				Error::InsufficientDialysateVolume,
				Error::UnachievableDialysisFlowRate,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InsufficientStaticDialysateVolume", "The DialysisMembraneSoak options are only populated if DialysisMembraneSoak is True:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod -> StaticDialysis,
				DialysateVolume -> .9 Liter
			],
			ObjectP[Object[Protocol,Dialysis]],
			Messages :> {
				Warning::InsufficientStaticDialysateVolume
			}
		],
		Example[{Messages, "ConflictingDialysateContainerMixType", "The DialysateContainer is compatible with the DialysisMixType:"},
			ExperimentDialysis[
				{Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateContainer -> Model[Container, Vessel, "id:aXRlGnZmOOJk"],
				DialysisMixType -> Stir
			],
			$Failed,
			Messages :> {
				Error::ConflictingDialysateContainerMixType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDialysisMethodMixType", "The DialysisMixType is supported with the DialysisMethod:"},
			ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixType -> Stir,
				DialysisMethod -> EquilibriumDialysis],
			$Failed,
			Messages :> {
				Error::ConflictingDialysisMethodMixType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConfictingEquilibriumDialysateVolume", "The Dialysate can fit in the largest DialysisMembrane allowed for EquilibriumDialysis:"},
			ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateVolume -> .8 Milliliter,
				DialysisMethod -> EquilibriumDialysis],
			$Failed,
			Messages :> {
				Error::ConfictingEquilibriumDialysateVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingDialysisMethodMixType", "The DialysisMixType is supported with the DialysisMethod:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixType -> Vortex,
				DialysisMethod -> DynamicDialysis],
			$Failed,
			Messages :> {
				Error::ConflictingDialysisMethodMixType,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingNullStaticDialysisOptions", "The static dialysis options are not Null if the DialysisMethod is StaticDialysis:"},
			ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateContainer -> Null,
				DialysisMethod -> StaticDialysis],
			$Failed,
			Messages :> {
				Error::ConflictingNullStaticDialysisOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingNullDynamicDialysisOptions", "The dynamic dialysis options are not set to null if the DialysisMethod is DynamicDialysis:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				FlowRate -> Null,
				DialysisMethod -> DynamicDialysis],
			$Failed,
			Messages :> {
				Error::ConflictingNullDynamicDialysisOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NumberOfDialysisRoundsEquilibriumMismatch", "The NumberOfDialysisRounds is not greater than 1 if the DialysisMethod is EquilibriumDialysis:"},
			ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->2,
				DialysisMethod -> EquilibriumDialysis],
			$Failed,
			Messages :> {
				Error::NumberOfDialysisRoundsEquilibriumMismatch,
				Error::InvalidOption
			}
		],


		(* --- Options --- *)

		Example[{Options, DialysisMethod, "Specify the type of dialysis to be used on the sample:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod -> DynamicDialysis,
				Output->Options
			];
			Lookup[options, DialysisMethod],
			DynamicDialysis
		],
		Example[{Options, DialysisMethod, "Resolve the type of dialysis if DynamicDialysis specific options are set:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				FlowRate -> 10 Milliliter/Minute,
				Output->Options
			];
			Lookup[options, DialysisMethod],
			DynamicDialysis
		],
		Example[{Options, DialysisMethod, "Resolve the type of dialysis if StaticDialysis specific options are set:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixType ->Stir,
				Output->Options
			];
			Lookup[options, DialysisMethod],
			StaticDialysis
		],
		Example[{Options, DialysisMethod, "Resolve the type of dialysis if the samples have high enough volumes for dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options
			];
			Lookup[options, DialysisMethod],
			DynamicDialysis
		],
		Example[{Options, DialysisMethod, "Resolve the type of dialysis if the samples have low volumes:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, DialysisMethod],
			StaticDialysis
		],
		Example[{Options, DynamicDialysisMethod, "Specify the type of dynamic dialysis to be used on the sample:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DynamicDialysisMethod->SinglePass,
				Output->Options
			];
			Lookup[options, DynamicDialysisMethod],
			SinglePass
		],
		Example[{Options, DynamicDialysisMethod, "Resolve the type of dynamic dialysis to Null if the DialysisMethod is not DynamicDialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options, DynamicDialysisMethod],
			Null
		],
		Example[{Options, DynamicDialysisMethod, "Resolve the type of dynamic dialysis to Recirculation if the DialysateVolume will run out with the FlowRate and DialysisTime:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				FlowRate->5 Milliliter/Minute,
				DialysisTime->40 Hour,
				DialysateVolume->1.7 Liter,
				Output->Options
			];
			Lookup[options, DynamicDialysisMethod],
			Recirculation
		],
		Example[{Options, DynamicDialysisMethod, "Resolve the type of dynamic dialysis to SinglePass if the DialysateVolume will not run out with the FlowRate and DialysisTime:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				FlowRate->5 Milliliter/Minute,
				DialysisTime->20 Hour,
				Output->Options
			];
			Lookup[options, DynamicDialysisMethod],
			SinglePass
		],
		Example[{Options, NumberOfDialysisRounds, "Specify the number of dialysis rounds to be used on the sample:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options, NumberOfDialysisRounds],
			3
		],
		Example[{Options, NumberOfDialysisRounds, "Resolve the number of dialysis rounds to largest round that options are set for:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysisTime->3 Hour,
				Output->Options
			];
			Lookup[options, NumberOfDialysisRounds],
			2
		],
		Example[{Options, NumberOfDialysisRounds, "Resolve the number of dialysis rounds to 3 for static dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options, NumberOfDialysisRounds],
			3
		],
		Example[{Options, NumberOfDialysisRounds, "Resolve the number of dialysis rounds to 1 for dynamic dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options, NumberOfDialysisRounds],
			1
		],
		Example[{Options, FlowRate, "Specify the flow rate to be used during dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				FlowRate->10 Milliliter/Minute,
				Output->Options
			];
			Lookup[options, FlowRate],
			10 Milliliter/Minute
		],
		Example[{Options, FlowRate, "Resolve the flow rate to be used during dynamic dialysis to Null if we are not doing dynamic dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options, FlowRate],
			Null
		],
		Example[{Options, FlowRate, "Resolve the flow rate to be used during dynamic dialysis the DynamicDialysisMethod is Recirculating:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DynamicDialysisMethod->Recirculation,
				Output->Options
			];
			Lookup[options, FlowRate],
			25 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FlowRate, "Resolve the flow rate to be used during dynamic dialysis to the highest possible flow rate that will not run out of Dialysate:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisTime->10Hour,
				DialysateVolume->6Liter,
				Output->Options
			];
			Lookup[options, FlowRate],
			7.2 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FlowRate, "Resolve the flow rate to be used during dynamic dialysis to 25 Milliliter/Minute if the highest possible flow rate that will not run out of Dialysate is greater than 25 Milliliter/Minute:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisTime->2Hour,
				DialysateVolume->10Liter,
				Output->Options
			];
			Lookup[options, FlowRate],
			25 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Messages, "UnachievableDialysisFlowRate", "If lowest possible flow rate that will not run out of Dialysate is not possible with out pump, throw an error:"},
			ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisTime->40Hour,
				DialysateVolume->2Liter
			],
			$Failed,
			Messages :> {
				Error::UnachievableDialysisFlowRate,
				Error::InvalidOption
			}
		],
		Example[{Options, ImageSystem, "Specify if the system should be imaged during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				ImageSystem->True,
				Output->Options
			];
			Lookup[options, ImageSystem],
			True
		],
		Example[{Options, ImageSystem, "Resolve if the system should be imaged during dialysis for dynamic dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options, ImageSystem],
			True
		],
		Example[{Options, ImageSystem, "Resolve if the system should be imaged during dialysis for static dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options, ImageSystem],
			Null
		],
		(*)
		Example[{Options, ImagingInterval, "Specify the ImagingInterval to image the system during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				ImagingInterval->2 Hour,
				Output->Options
			];
			Lookup[options, ImagingInterval],
			2 Hour
		],
		Example[{Options, ImagingInterval, "Relsove the ImagingInterval if ImageSystem is True:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				ImageSystem->True,
				Output->Options
			];
			Lookup[options, ImagingInterval],
			1 Hour
		],
		Example[{Options, ImagingInterval, "Relsove the ImagingInterval to Null if ImageSystem is not True:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, ImagingInterval],
			Null
		],*)
		Example[{Options, ShareDialysateContainer, "Specify if the DialysateContainer should be shared by multiple samples during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				ShareDialysateContainer->True,
				Output->Options
			];
			Lookup[options, ShareDialysateContainer],
			True
		],
		Example[{Options, ShareDialysateContainer, "Resolve if the DialysateContainer should be shared by multiple samples during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMethod->StaticDialysis
			];
			Lookup[options, ShareDialysateContainer],
			True
		],
		Example[{Options, ShareDialysateContainer, "Resolve that the DialysateContainer should not be shared by multiple samples during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMethod->DynamicDialysis
			];
			Lookup[options, ShareDialysateContainer],
			False
		],
		Example[{Options, DialysisMembrane, "Specify the dialysis membrane that should be used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			];
			Lookup[options, DialysisMembrane],
			ObjectP[Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]]
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for dynamic dialysis by giving a MolecularWeightCutoff:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMethod->DynamicDialysis,
				MolecularWeightCutoff->8 Kilo Dalton
			];
			Lookup[options, DialysisMembrane][{Type,MolecularWeightCutoff}],
			{Model[Item, DialysisMembrane], 8.`Kilo Dalton}
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for dynamic dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMethod->DynamicDialysis
			];
			Lookup[options, DialysisMembrane][Type],
			Model[Item, DialysisMembrane]
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for EquilibriumDialysis by giving a MolecularWeightCutoff:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMethod->EquilibriumDialysis,
				MolecularWeightCutoff->8 Kilo Dalton
			];
			Lookup[options, DialysisMembrane][{Type,MolecularWeightCutoff}],
			{Model[Container, Plate, Dialysis], 8.`Kilo Dalton}
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for EquilibriumDialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMethod->EquilibriumDialysis
			];
			Lookup[options, DialysisMembrane][Type],
			Model[Container, Plate, Dialysis]
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for StaticDialysis by giving a MolecularWeightCutoff:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMethod->StaticDialysis,
				MolecularWeightCutoff->8 Kilo Dalton
			];
			Lookup[options, DialysisMembrane][{Type,MolecularWeightCutoff}],
			{Model[Container, Vessel, Dialysis], 8.`Kilo Dalton}
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for StaticDialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMethod->StaticDialysis
			];
			Lookup[options, DialysisMembrane][Type],
			Model[Container, Vessel, Dialysis]
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for StaticDialysis by giving a MolecularWeightCutoff for large samples:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMethod->StaticDialysis,
				MolecularWeightCutoff->8 Kilo Dalton
			];
			Lookup[options, DialysisMembrane][{Type,MolecularWeightCutoff}],
			{Model[Item, DialysisMembrane], 8.`Kilo Dalton}
		],
		Example[{Options, DialysisMembrane, "Resolve the dialysis membrane that should be used during dialysis for StaticDialysis for large samples:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMethod->StaticDialysis
			];
			Lookup[options, DialysisMembrane][Type],
			Model[Item, DialysisMembrane]
		],
		Example[{Messages, "NoAvailableDialysisMembrane", "There are dialysis membranes that match the specified molecular weight cutoff and sample volumes:"},
			ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				MolecularWeightCutoff->3.5 Kilo Dalton,
				DialysisMethod->EquilibriumDialysis
			],
			$Failed,
			Messages :> {
				Error::NoAvailableDialysisMembrane,
				Error::InvalidOption
			}
		],
		Example[{Options, MolecularWeightCutoff, "Specify the molecular weight cutoff of the dialysis membrane that should be used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				MolecularWeightCutoff->3.5 Kilo Dalton
			];
			Lookup[options, MolecularWeightCutoff],
			3.5 Kilo Dalton
		],
		Example[{Options, MolecularWeightCutoff, "Resolve the molecular weight cutoff of the dialysis membrane that should be used during dialysis from the dialysis membrane:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			];
			Lookup[options, MolecularWeightCutoff],
			8 Kilo Dalton
		],
		Example[{Options, SampleVolume, "Specify the amount of sample that should be put in the dialysis membrane:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				SampleVolume->0.1Milliliter
			];
			Lookup[options, SampleVolume],
			0.1Milliliter
		],
		Example[{Options, SampleVolume, "Specify that all of sample that should be put in the dialysis membrane:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				SampleVolume->All
			];
			Lookup[options, SampleVolume],
			0.001`Liter
		],
		Example[{Options, SampleVolume, "Resolve the amount sample that should be put in the dialysis membrane to the max volume of the dialysis membrane:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			];
			Lookup[options, SampleVolume],
			130 Milliliter
		],
		Example[{Options, SampleVolume, "Resolve the amount sample that should be put in the dialysis membrane to the max volume of the dialysis membrane container:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembrane->Model[Container, Vessel, Dialysis, "id:8qZ1VW0VPbzp"]
			];
			Lookup[options, SampleVolume],
			0.25`Milliliter
		],
		Example[{Options, SampleVolume, "Resolve the amount sample that should be put in the dialysis membrane to the volume of the sample:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			];
			Lookup[options, SampleVolume],
			0.035` Liter
		],
		Example[{Options, DialysisMembraneSoak, "Specify if the dialysis membrane should be soaked before the sample is loaded:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembraneSoak->False
			];
			Lookup[options, DialysisMembraneSoak],
			False
		],
		Example[{Options, DialysisMembraneSoak, "Resolve if the dialysis membrane should be soaked before the sample is loaded:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembraneSoakTime->1 Hour
			];
			Lookup[options, DialysisMembraneSoak],
			True
		],
		Example[{Options, DialysisMembraneSoak, "Resolve if the dialysis membrane should be soaked before the sample is loaded based on the membrane:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			];
			Lookup[options, DialysisMembraneSoak],
			False
		],
		Example[{Options, DialysisMembraneSoakVolume, "Specify the volume the dialysis membrane should be soaked in before the sample is loaded:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembraneSoakVolume->1 Liter
			];
			Lookup[options, DialysisMembraneSoakVolume],
			1 Liter
		],
		Example[{Options, DialysisMembraneSoakVolume, "Resolve the volume the dialysis membrane should be soaked in before the sample is loaded based on the membrane:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembrane->Model[Container, Vessel, Dialysis, "id:8qZ1VW0VPbzp"]
			];
			Lookup[options, DialysisMembraneSoakVolume],
			0.25 Milliliter
		],
		Example[{Options, DialysisMembraneSoakSolution, "Specify the solution the dialysis membrane should be soaked in before the sample is loaded:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembraneSoakSolution->Model[Sample, StockSolution, "Filtered PBS, Sterile"]
			];
			Lookup[options, DialysisMembraneSoakSolution],
			ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]
		],
		Example[{Options,DialysisMembraneSoakSolution, "Resolve the solution the dialysis membrane should be soaked in before the sample is loaded based on the membrane:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembrane->Model[Container, Vessel, Dialysis, "id:8qZ1VW0VPbzp"]
			];
			Lookup[options, DialysisMembraneSoakSolution],
			Model[Sample, "Milli-Q water"]
		],
		Example[{Options, DialysisMembraneSoakTime, "Specify the time the dialysis membrane should be soaked before the sample is loaded:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options,
				DialysisMembraneSoakTime->1 Hour
			];
			Lookup[options, DialysisMembraneSoakTime],
			1 Hour
		],
		Example[{Options, DialysisMembraneSoakTime, "Resolve the time the dialysis membrane should be soaked before the sample is loaded based on the membrane:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options,
				DialysisMembrane->Model[Container, Vessel, Dialysis, "id:8qZ1VW0VPbzp"]
			];
			Lookup[options, DialysisMembraneSoakTime],
			5.` Minute
		],
		Example[{Options, DialysisMixType, "Specify the type of mixing to be used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixType->Stir,
				Output->Options
			];
			Lookup[options, DialysisMixType],
			Stir
		],
		Example[{Options, DialysisMixType, "Resolve the type of mixing to Null for dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options, DialysisMixType],
			Null
		],
		Example[{Options, DialysisMixType, "Resolve the type of mixing to Vortex for equillibrium dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->EquilibriumDialysis,
				Output->Options
			];
			Lookup[options, DialysisMixType],
			Vortex
		],
		Example[{Options, DialysisMixType, "Resolve the type of mixing to stir for static dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options, DialysisMixType],
			Stir
		],
		Example[{Options, Instrument, "Specify the instrument to be used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Instrument->Model[Instrument, Vortex, "id:o1k9jAGq7pNA"],
				Output->Options
			];
			Lookup[options, Instrument],
			Model[Instrument, Vortex, "id:o1k9jAGq7pNA"]
		],
		Example[{Options, Instrument, "Resolve the instrument to be used during dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options, Instrument][Type],
			Model[Instrument, Dialyzer]
		],
		Example[{Options, Instrument, "Resolve the instrument to be used during for shaking:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixType->Vortex,
				Output->Options
			];
			Lookup[options, Instrument][Type],
			Model[Instrument, Vortex]
		],
		Example[{Options, Instrument, "Resolve the instrument to be used during for stirring:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixType->Stir,
				Output->Options
			];
			Lookup[options, Instrument][Type],
			Model[Instrument, OverheadStirrer]
		],
		Example[{Options, Instrument, "Resolve the instrument to be used during for no mixing and heating:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixType->Null,
				DialysisMethod->StaticDialysis,
				DialysateTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options, Instrument][Type],
			Model[Instrument, HeatBlock]
		],
		Example[{Options, Instrument, "Resolve the instrument to be used during for no mixing at Ambient temperature:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixType->Null,
				DialysisMethod->StaticDialysis,
				DialysateTemperature->Ambient,
				Output->Options
			];
			Lookup[options, Instrument],
			Null
		],
		Example[{Messages, "UnresolvableDialysisInstrument", "There is an instrument that can support the DialysisMethod, DialysisMixType, DialysisMixRate and DialysateTemperature:"},
			ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateTemperature->4 Celsius,
				DialysisMixType->Vortex
			],
			$Failed,
			Messages :> {
				Error::UnresolvableDialysisInstrument,
				Error::InvalidOption
			}
		],
		Example[{Options, DialysateTemperature, "Specify the temperature of the dialysate used during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options, DialysateTemperature],
			37 Celsius
		],
		Example[{Options, SecondaryDialysateTemperature, "Specify the temperature of the secondary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysateTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options, SecondaryDialysateTemperature],
			37 Celsius
		],
		Example[{Options, SecondaryDialysateTemperature, "Resolve the temperature of the secondary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->30 Celsius,
				NumberOfDialysisRounds->2,
				Output->Options
			];
			Lookup[options, SecondaryDialysateTemperature],
			30 Celsius
		],
		Example[{Options, TertiaryDialysateTemperature, "Specify the temperature of the tertiary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysateTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options, TertiaryDialysateTemperature],
			37 Celsius
		],
		Example[{Options, TertiaryDialysateTemperature, "Resolvethe temperature of the tertiary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->30 Celsius,
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options, TertiaryDialysateTemperature],
			30 Celsius
		],
		Example[{Options, QuaternaryDialysateTemperature, "Specify the temperature of the quaternary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysateTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateTemperature],
			37 Celsius
		],
		Example[{Options, QuaternaryDialysateTemperature, "Resolve the temperature of the quaternary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->30 Celsius,
				NumberOfDialysisRounds->4,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateTemperature],
			30 Celsius
		],
		Example[{Options, QuinaryDialysateTemperature, "Specify the temperature of the quinary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysateTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options, QuinaryDialysateTemperature],
			37 Celsius
		],
		Example[{Options, QuinaryDialysateTemperature, "Resolve the temperature of the quinary dialysate used during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->30 Celsius,
				NumberOfDialysisRounds->5,
				Output->Options
			];
			Lookup[options, QuinaryDialysateTemperature],
			30 Celsius
		],
		Example[{Options, DialysisTime, "Specify the amount of time the sample will be dialyzed:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisTime->8 Hour,
				Output->Options
			];
			Lookup[options, DialysisTime],
			8 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysisTime, "Resolve the amount of time the sample will be dialyzed for static dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options, DialysisTime],
			2 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysisTime, "Resolve the amount of time the sample will be dialyzed for equilibrium dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->EquilibriumDialysis,
				Output->Options
			];
			Lookup[options, DialysisTime],
			4 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysisTime, "Resolve the amount of time the sample will be dialyzed for recirculating dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DynamicDialysisMethod->Recirculation,
				Output->Options
			];
			Lookup[options, DialysisTime],
			8 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysisTime, "Resolve the amount of time the sample will be dialyzed for single pass dynamic dialysis with set DialysateVolume:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DynamicDialysisMethod->SinglePass,
				DialysateVolume->5Liter,
				FlowRate->5Milliliter/Minute,
				Output->Options
			];
			Lookup[options, DialysisTime],
			660 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DialysisTime, "Resolve the amount of time the sample will be dialyzed for single pass dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DynamicDialysisMethod->SinglePass,
				FlowRate->20Milliliter/Minute,
				Output->Options
			];
			Lookup[options, DialysisTime],
			425 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SecondaryDialysisTime, "Specify the amount of time the sample will be dialyzed in the second round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysisTime->8 Hour,
				Output->Options
			];
			Lookup[options, SecondaryDialysisTime],
			8 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, SecondaryDialysisTime, "Resolve the amount of time the sample will be dialyzed in the second round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfDialysisRounds->1,
				Output->Options
			];
			Lookup[options, SecondaryDialysisTime],
			Null
		],
		Example[{Options, SecondaryDialysisTime, "Resolve the amount of time the sample will be dialyzed in the second round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->2,
				Output->Options
			];
			Lookup[options, SecondaryDialysisTime],
			16 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, SecondaryDialysisTime, "Resolve the amount of time the sample will be dialyzed in the second round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options, SecondaryDialysisTime],
			2 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TertiaryDialysisTime, "Specify the amount of time the sample will be dialyzed in the third round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysisTime->8 Hour,
				Output->Options
			];
			Lookup[options,TertiaryDialysisTime],
			8 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TertiaryDialysisTime, "Resolve the amount of time the sample will be dialyzed in the third round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options,TertiaryDialysisTime],
			16 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuaternaryDialysisTime, "Specify the amount of time the sample will be dialyzed in the fourth round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysisTime->8 Hour,
				Output->Options
			];
			Lookup[options,QuaternaryDialysisTime],
			8 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuaternaryDialysisTime, "Resolve the amount of time the sample will be dialyzed in the fourth round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfDialysisRounds->5,
				Output->Options
			];
			Lookup[options,QuaternaryDialysisTime],
			2 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuinaryDialysisTime, "Specify the amount of time the sample will be dialyzed in the fifth round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysisTime->8 Hour,
				Output->Options
			];
			Lookup[options,QuinaryDialysisTime],
			8 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuinaryDialysisTime, "Resolve the amount of time the sample will be dialyzed in the fifth round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				NumberOfDialysisRounds->5,
				Output->Options
			];
			Lookup[options,QuinaryDialysisTime],
			16 Hour,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysisMixRate, "Specify the rate at which the dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixRate->300 RPM,
				Output->Options
			];
			Lookup[options,DialysisMixRate],
			300 RPM
		],
		Example[{Options, DialysisMixRate, "Resolve the rate at which the dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixType->Stir,
				Output->Options
			];
			Lookup[options,DialysisMixRate],
			250 RPM
		],
		Example[{Options, DialysisMixRate, "Resolve the rate at which the dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMixType->Vortex,
				Output->Options
			];
			Lookup[options,DialysisMixRate],
			500 RPM
		],
		Example[{Options, DialysisMixRate, "Resolve the rate at which the dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixType->Null,
				Output->Options
			];
			Lookup[options,DialysisMixRate],
			Null
		],
		Example[{Options, SecondaryDialysisMixRate, "Specify the rate at which the secondary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysisMixRate->300 RPM,
				Output->Options
			];
			Lookup[options,SecondaryDialysisMixRate],
			300 RPM
		],
		Example[{Options, SecondaryDialysisMixRate, "Resolve the rate at which the secondary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixRate->350 RPM,
				NumberOfDialysisRounds->2,
				Output->Options
			];
			Lookup[options,SecondaryDialysisMixRate],
			350 RPM
		],
		Example[{Options, TertiaryDialysisMixRate, "Specify the rate at which the tertiary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysisMixRate->300 RPM,
				Output->Options
			];
			Lookup[options,TertiaryDialysisMixRate],
			300 RPM
		],
		Example[{Options, TertiaryDialysisMixRate, "Resolve the rate at which the tertiary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixRate->350 RPM,
				NumberOfDialysisRounds->2,
				Output->Options
			];
			Lookup[options,TertiaryDialysisMixRate],
			Null
		],
		Example[{Options, QuaternaryDialysisMixRate, "Specify the rate at which the quaternary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysisMixRate->300 RPM,
				NumberOfDialysisRounds->4,
				Output->Options
			];
			Lookup[options,QuaternaryDialysisMixRate],
			300 RPM
		],
		Example[{Options, QuaternaryDialysisMixRate, "Resolve the rate at which the quaternary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixRate->350 RPM,
				NumberOfDialysisRounds->4,
				Output->Options
			];
			Lookup[options,QuaternaryDialysisMixRate],
			350 RPM
		],
		Example[{Options, QuinaryDialysisMixRate, "Specify the rate at which the quinary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysisMixRate->300 RPM,
				Output->Options
			];
			Lookup[options,QuinaryDialysisMixRate],
			300 RPM
		],
		Example[{Options, QuinaryDialysisMixRate, "Resolve the rate at which the quinary dialysate will be mixed during dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixRate->350 RPM,
				NumberOfDialysisRounds->4,
				Output->Options
			];
			Lookup[options,QuinaryDialysisMixRate],
			Null
		],
		Example[{Options, Dialysate, "Specify the buffer the sample should be put into to dialyze the sample:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Dialysate->Model[Sample, StockSolution, "Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,Dialysate],
			ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]
		],
		Example[{Options, SecondaryDialysate, "Specify the buffer the sample should be put into to dialyze the sample in the second round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysate->Model[Sample, StockSolution, "Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,SecondaryDialysate],
			ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]
		],
		Example[{Options, SecondaryDialysate, "Resolve the buffer the sample should be put into to dialyze the sample in the second round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Dialysate->Model[Sample, "Milli-Q water"],
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options,SecondaryDialysate],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Options, TertiaryDialysate, "Specify the buffer the sample should be put into to dialyze the sample in the third round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryDialysate->Model[Sample, StockSolution, "Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,TertiaryDialysate],
			ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]
		],
		Example[{Options, TertiaryDialysate, "Resolve the buffer the sample should be put into to dialyze the sample in the third round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Dialysate->Model[Sample, "Milli-Q water"],
				NumberOfDialysisRounds->2,
				Output->Options
			];
			Lookup[options,TertiaryDialysate],
			Null
		],
		Example[{Options, QuaternaryDialysate, "Specify the buffer the sample should be put into to dialyze the sample in the fourth round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuaternaryDialysate->Model[Sample, StockSolution, "Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,QuaternaryDialysate],
			ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]
		],
		Example[{Options, QuaternaryDialysate, "Resolve the buffer the sample should be put into to dialyze the sample in the fourth round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Dialysate->Model[Sample, "Milli-Q water"],
				NumberOfDialysisRounds->4,
				Output->Options
			];
			Lookup[options,QuaternaryDialysate],
			ObjectP[Model[Sample, "Milli-Q water"]]
		],
		Example[{Options, QuinaryDialysate, "Specify the buffer the sample should be put into to dialyze the sample in the fifth round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuinaryDialysate->Model[Sample, StockSolution, "Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,QuinaryDialysate],
			ObjectP[Model[Sample, StockSolution, "Filtered PBS, Sterile"]]
		],
		Example[{Options, QuinaryDialysate, "Resolve the buffer the sample should be put into to dialyze the sample in the fifth round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->4,
				Output->Options
			];
			Lookup[options,QuinaryDialysate],
			Null
		],
		Example[{Options, DialysateVolume, "Specify the volume of dialysate the sample should be put into to dialyze the sample:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateVolume->1.5Liter,
				Output->Options
			];
			Lookup[options,DialysateVolume],
			1.5Liter
		],
		Example[{Options, DialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample for dynamic dialysis:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options,DialysateVolume],
			10 Liter
		],
		Example[{Options, DialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample for equilibrium dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->EquilibriumDialysis,
				Output->Options
			];
			Lookup[options,DialysateVolume],
			750.` Microliter
		],
		Example[{Options, DialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample for small static dialysis samples:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis,
				SampleVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options,DialysateVolume],
			950.`Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample for large static dialysis samples:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis,
				SampleVolume->35 Milliliter,
				Output->Options
			];
			Lookup[options,DialysateVolume],
			1870.` Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, SecondaryDialysateVolume, "Specify the volume of dialysate the sample should be put into to dialyze the sample in the second round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysateVolume->1.1Liter,
				Output->Options
			];
			Lookup[options,SecondaryDialysateVolume],
			1.1Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, SecondaryDialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample in the second round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->1,
				Output->Options
			];
			Lookup[options,SecondaryDialysateVolume],
			Null
		],
		Example[{Options, TertiaryDialysateVolume, "Specify the volume of dialysate the sample should be put into to dialyze the sample in the third round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysateVolume->1.1Liter,
				Output->Options
			];
			Lookup[options,TertiaryDialysateVolume],
			1.1Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, TertiaryDialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample in the third round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateVolume->1.1Liter,
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options,TertiaryDialysateVolume],
			1.1Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuaternaryDialysateVolume, "Specify the volume of dialysate the sample should be put into to dialyze the sample in the fourth round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysateVolume->1.1Liter,
				Output->Options
			];
			Lookup[options,QuaternaryDialysateVolume],
			1.1Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuaternaryDialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample in the fourth round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options,QuaternaryDialysateVolume],
			Null
		],
		Example[{Options, QuinaryDialysateVolume, "Specify the volume of dialysate the sample should be put into to dialyze the sample in the fifth round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysateVolume->1.1Liter,
				Output->Options
			];
			Lookup[options,QuinaryDialysateVolume],
			1.1Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, QuinaryDialysateVolume, "Resolve the volume of dialysate the sample should be put into to dialyze the sample in the fifth round:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateVolume->1.1Liter,
				NumberOfDialysisRounds->5,
				Output->Options
			];
			Lookup[options,QuinaryDialysateVolume],
			1.1Liter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, DialysateContainer, "Specify the container the dialysate should be in when dialyzing the sample:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateContainer->Model[Container, Vessel, "id:kEJ9mqaVPPD8"],
				Output->Options
			];
			Lookup[options,DialysateContainer],
			ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]
		],
		Example[{Options, DialysateContainer, "Resolve the container the dialysate should be in when dialyzing the sample by dynamic dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options,DialysateContainer],
			Null
		],
		Example[{Options, DialysateContainer, "Resolve the container the dialysate should be in when dialyzing the sample in a beaker:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis,
				Output->Options
			];
			Lookup[options,DialysateContainer][Type],
			Model[Container,Vessel]
		],
		Example[{Options, SecondaryDialysateContainer, "Specify the container the dialysate should be in when dialyzing the sample during the second round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysateContainer->Model[Container, Vessel, "id:kEJ9mqaVPPD8"],
				Output->Options
			];
			Lookup[options,SecondaryDialysateContainer],
			ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]
		],
		Example[{Options, SecondaryDialysateContainer, "Resolve the container the dialysate should be in when dialyzing the sample during the second round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->1,
				Output->Options
			];
			Lookup[options,SecondaryDialysateContainer],
			Null
		],
		Example[{Options, TertiaryDialysateContainer, "Specify the container the dialysate should be in when dialyzing the sample during the third round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryDialysateContainer->Model[Container, Vessel, "id:kEJ9mqaVPPD8"],
				Output->Options
			];
			Lookup[options,TertiaryDialysateContainer],
			ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]
		],
		Example[{Options, TertiaryDialysateContainer, "Resolve the container the dialysate should be in when dialyzing the sample during the third round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateContainer->Model[Container, Vessel, "id:wqW9BP4Y0009"],
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options,TertiaryDialysateContainer],
			Model[Container, Vessel, "id:wqW9BP4Y0009"]
		],
		Example[{Options, QuaternaryDialysateContainer, "Specify the container the dialysate should be in when dialyzing the sample during the fourth round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuaternaryDialysateContainer->Model[Container, Vessel, "id:kEJ9mqaVPPD8"],
				Output->Options
			];
			Lookup[options, QuaternaryDialysateContainer],
			ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]
		],
		Example[{Options, QuaternaryDialysateContainer, "Resolve the container the dialysate should be in when dialyzing the sample during the fourth round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->3,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateContainer],
			Null
		],
		Example[{Options, QuinaryDialysateContainer, "Specify the container the dialysate should be in when dialyzing the sample during the fifth round:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuinaryDialysateContainer->Model[Container, Vessel, "id:kEJ9mqaVPPD8"],
				Output->Options
			];
			Lookup[options, QuinaryDialysateContainer],
			ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]
		],
		Example[{Options, QuinaryDialysateContainer, "Resolve the container the dialysate should be in when dialyzing the sample during the fifth round:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateContainer->Model[Container, Vessel, "id:wqW9BP4Y0009"],
				NumberOfDialysisRounds->5,
				Output->Options
			];
			Lookup[options, QuinaryDialysateContainer],
			Model[Container, Vessel, "id:wqW9BP4Y0009"]
		],
		Example[{Options, DialysateSampling, "Specify if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateSampling->True,
				Output->Options
			];
			Lookup[options, DialysateSampling],
			True
		],
		Example[{Options, DialysateSampling, "Resolve if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, DialysateSampling],
			True
		],
		Example[{Options, DialysateSampling, "Resolve if a sampling of dialysate should not be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Output->Options
			];
			Lookup[options, DialysateSampling],
			False
		],
		Example[{Options, DialysateSamplingVolume, "Specify the amount of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, DialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, DialysateSamplingVolume, "Resolve the amount of dialysate should be stored after equilibrium dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMethod->EquilibriumDialysis,
				Output->Options
			];
			Lookup[options, DialysateSamplingVolume],
			750` Microliter
		],
		Example[{Options, DialysateSamplingVolume, "Resolve the amount of dialysate should be stored after dynamic dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->DynamicDialysis,
				Output->Options
			];
			Lookup[options, DialysateSamplingVolume],
			Null
		],
		Example[{Options, DialysateSamplingVolume, "Resolve the amount of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateSampling->True,
				Output->Options
			];
			Lookup[options, DialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, SecondaryDialysateSampling, "Specify if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, SecondaryDialysateSampling],
			True
		],
		Example[{Options, SecondaryDialysateSampling, "Resolve if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, SecondaryDialysateSampling],
			True
		],
		Example[{Options, SecondaryDialysateSampling, "Resolve if a sampling of dialysate should not be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				NumberOfDialysisRounds->2,
				Output->Options
			];
			Lookup[options, SecondaryDialysateSampling],
			False
		],
		Example[{Options, SecondaryDialysateSamplingVolume, "Specify the amount of dialysate should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, SecondaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, SecondaryDialysateSamplingVolume, "Resolve the amount of dialysate should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, SecondaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, TertiaryDialysateSampling, "Specify if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, TertiaryDialysateSampling],
			True
		],
		Example[{Options, TertiaryDialysateSampling, "Resolve if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, TertiaryDialysateSampling],
			True
		],
		Example[{Options, TertiaryDialysateSamplingVolume, "Specify the amount of dialysate should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, TertiaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, TertiaryDialysateSamplingVolume, "Resolve the amount of dialysate should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, TertiaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, QuaternaryDialysateSampling, "Specify if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuaternaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateSampling],
			True
		],
		Example[{Options, QuaternaryDialysateSampling, "Resolve if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateSampling],
			True
		],
		Example[{Options, QuaternaryDialysateSamplingVolume, "Specify the amount of dialysate should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuaternaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, QuaternaryDialysateSamplingVolume, "Resolve the amount of dialysate should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, QuinaryDialysateSampling, "Specify if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuinaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, QuinaryDialysateSampling],
			True
		],
		Example[{Options, QuinaryDialysateSampling, "Resolve if a sampling of dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, QuinaryDialysateSampling],
			True
		],
		Example[{Options, QuinaryDialysateSamplingVolume, "Specify the amount of dialysate should be stored after the fifth round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuinaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, QuinaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, QuinaryDialysateSamplingVolume, "Resolve the amount of dialysate should be stored after the fifth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysateSampling->True,
				Output->Options
			];
			Lookup[options, QuinaryDialysateSamplingVolume],
			1 Milliliter
		],
		Example[{Options, DialysateStorageCondition, "Specify the non-default storage condition the dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, DialysateStorageCondition],
			Refrigerator
		],
		Example[{Options, SecondaryDialysateStorageCondition, "Specify the non-default storage condition the dialysate should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysateStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, SecondaryDialysateStorageCondition],
			Refrigerator
		],
		Example[{Options, TertiaryDialysateStorageCondition, "Specify the non-default storage condition the dialysate should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysateStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, TertiaryDialysateStorageCondition],
			Refrigerator
		],
		Example[{Options, QuaternaryDialysateStorageCondition, "Specify the non-default storage condition the dialysate should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysateStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateStorageCondition],
			Refrigerator
		],
		Example[{Options, QuinaryDialysateStorageCondition, "Specify the tnon-default storage condition the dialysate should be stored after the fifth round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuinaryDialysateStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, QuinaryDialysateStorageCondition],
			Refrigerator
		],
		Example[{Options, DialysateContainerOut, "Specify the container the dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, DialysateContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, DialysateContainerOut, "Resolve the container the dialysate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateSamplingVolume->5 Milliliter,
				Output->Options
			];
			Lookup[options, DialysateContainerOut][Type],
			Model[Container, Vessel]
		],
		Example[{Options, SecondaryDialysateContainerOut, "Specify the container the dialysate should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryDialysateContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, SecondaryDialysateContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, SecondaryDialysateContainerOut, "Resolve the container the dialysate should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryDialysateSamplingVolume->Null,
				Output->Options
			];
			Lookup[options, SecondaryDialysateContainerOut],
			Null
		],
		Example[{Options, TertiaryDialysateContainerOut, "Specify the container the dialysate should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryDialysateContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, TertiaryDialysateContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, TertiaryDialysateContainerOut, "Resolve the container the dialysate should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryDialysateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, TertiaryDialysateContainerOut][Type],
			Model[Container, Vessel]
		],
		Example[{Options, QuaternaryDialysateContainerOut, "Specify the container the dialysate should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuaternaryDialysateContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, QuaternaryDialysateContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, QuaternaryDialysateContainerOut, "Resolve the container the dialysate should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryDialysateSamplingVolume->Null,
				Output->Options
			];
			Lookup[options, QuaternaryDialysateContainerOut],
			Null
		],
		Example[{Options, QuinaryDialysateContainerOut, "Specify the container the dialysate should be stored after the fifth round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuinaryDialysateContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, QuinaryDialysateContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, QuinaryDialysateContainerOut, "Resolve the container the dialysate should be stored after the fifth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuinaryDialysateSamplingVolume->10 Milliliter,
				Output->Options
			];
			Lookup[options, QuinaryDialysateContainerOut][Type],
			Model[Container, Vessel]
		],
		Example[{Options, RetentateSampling, "Specify if the retentate should be sampled after the first round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				RetentateSampling->True,
				Output->Options
			];
			Lookup[options, RetentateSampling],
			True
		],
		Example[{Options, SecondaryRetentateSampling, "Specify if the retentate should be sampled after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryRetentateSampling->True,
				Output->Options
			];
			Lookup[options, SecondaryRetentateSampling],
			True
		],
		Example[{Options, TertiaryRetentateSampling, "Specify if the retentate should be sampled after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryRetentateSampling->True,
				Output->Options
			];
			Lookup[options, TertiaryRetentateSampling],
			True
		],
		Example[{Options, QuaternaryRetentateSampling, "Specify if the retentate should be sampled after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryRetentateSampling->True,
				Output->Options
			];
			Lookup[options, QuaternaryRetentateSampling],
			True
		],
		Example[{Options, RetentateSamplingVolume, "Specify the volume of retentate that should be sampled after the first round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateSampling->True,
				RetentateSamplingVolume->2Milliliter,
				Output->Options
			];
			Lookup[options, RetentateSamplingVolume],
			2Milliliter
		],
		Example[{Options, RetentateSamplingVolume, "Resolve the volume of retentate that should be sampled after the first round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				RetentateSampling->False,
				Output->Options
			];
			Lookup[options, RetentateSamplingVolume],
			Null
		],
		Example[{Options, SecondaryRetentateSamplingVolume, "Specify the volume of retentate that should be sampled after the second round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryRetentateSampling->True,
				SecondaryRetentateSamplingVolume->2Milliliter,
				Output->Options
			];
			Lookup[options, SecondaryRetentateSamplingVolume],
			2Milliliter
		],
		Example[{Options, SecondaryRetentateSamplingVolume, "Resolve the volume of retentate that should be sampled after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryRetentateSampling->True,
				Output->Options
			];
			Lookup[options, SecondaryRetentateSamplingVolume],
			{Quantity[0.00035, "Liters"], Quantity[1, "Milliliters"]}
		],
		Example[{Options, TertiaryRetentateSamplingVolume, "Specify the volume of retentate that should be sampled after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryRetentateSampling->True,
				TertiaryRetentateSamplingVolume->2Milliliter,
				Output->Options
			];
			Lookup[options, TertiaryRetentateSamplingVolume],
			2Milliliter
		],
		Example[{Options, TertiaryRetentateSamplingVolume, "Resolve the volume of retentate that should be sampled after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryRetentateSampling->True,
				Output->Options
			];
			Lookup[options, TertiaryRetentateSamplingVolume],
			0.00001`Liter
		],
		Example[{Options, QuaternaryRetentateSamplingVolume, "Specify the volume of retentate that should be sampled after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				QuaternaryRetentateSampling->True,
				QuaternaryRetentateSamplingVolume->2Milliliter,
				Output->Options
			];
			Lookup[options, QuaternaryRetentateSamplingVolume],
			2Milliliter
		],
		Example[{Options, QuaternaryRetentateSamplingVolume, "Resolve the volume of retentate that should be sampled after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Container, Vessel, "2L bottle for ExperimentDialysis tests"<> $SessionUUID],
				QuaternaryRetentateSampling->True,
				Output->Options
			];
			Lookup[options, QuaternaryRetentateSamplingVolume],
			1Milliliter
		],
		Example[{Options, RetentateSamplingStorageCondition, "Specify the non-default storage condition the retentate sample should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				RetentateSampling->True,
				RetentateSamplingStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, RetentateSamplingStorageCondition],
			Refrigerator
		],
		Example[{Options, SecondaryRetentateSamplingStorageCondition, "Specify the non-default storage condition the retentate sample should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryRetentateSampling->True,
				SecondaryRetentateSamplingStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, SecondaryRetentateSamplingStorageCondition],
			Refrigerator
		],
		Example[{Options, TertiaryRetentateSamplingStorageCondition, "Specify the non-default storage condition the retentate sample should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryRetentateSampling->True,
				TertiaryRetentateSamplingStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, TertiaryRetentateSamplingStorageCondition],
			Refrigerator
		],
		Example[{Options, QuaternaryRetentateSamplingStorageCondition, "Specify the non-default storage condition the retentate sample should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryRetentateSampling->True,
				QuaternaryRetentateSamplingStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, QuaternaryRetentateSamplingStorageCondition],
			Refrigerator
		],
		Example[{Options, RetentateSamplingContainerOut, "Specify the container the retentate sample should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateSampling->True,
				RetentateSamplingContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, RetentateSamplingContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, RetentateSamplingContainerOut, "Resolve the container the retentate sample should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				RetentateSampling->True,
				RetentateSamplingVolume->5 Milliliter,
				Output->Options
			];
			Lookup[options, RetentateSamplingContainerOut][Type],
			Model[Container, Vessel]
		],
		Example[{Options, SecondaryRetentateSamplingContainerOut, "Specify the container the retentate sample should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				SecondaryRetentateSampling->True,
				SecondaryRetentateSamplingContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, SecondaryRetentateSamplingContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, SecondaryRetentateSamplingContainerOut, "Resolve the container the retentate sample should be stored after the second round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				SecondaryRetentateSampling->False,
				SecondaryRetentateSamplingVolume->Null,
				Output->Options
			];
			Lookup[options, SecondaryRetentateSamplingContainerOut],
			Null
		],
		Example[{Options, TertiaryRetentateSamplingContainerOut, "Specify the container the retentate sample should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				TertiaryRetentateSampling->True,
				TertiaryRetentateSamplingContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, TertiaryRetentateSamplingContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, TertiaryRetentateSamplingContainerOut, "Resolve the container the retentate sample should be stored after the third round of dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				TertiaryRetentateSampling->True,
				TertiaryRetentateSamplingVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options, TertiaryRetentateSamplingContainerOut][Type],
			Model[Container, Vessel]
		],
		Example[{Options, QuaternaryRetentateSamplingContainerOut, "Specify the container the retentate sample should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryRetentateSampling->True,
				QuaternaryRetentateSamplingContainerOut->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options, QuaternaryRetentateSamplingContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]]
		],
		Example[{Options, QuaternaryRetentateSamplingContainerOut, "Resolve the container the retentate sample should be stored after the fourth round of dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				QuaternaryRetentateSampling->False,
				QuaternaryRetentateSamplingVolume->Null,
				Output->Options
			];
			Lookup[options, QuaternaryRetentateSamplingContainerOut],
			Null
		],
		Example[{Options, RetentateStorageCondition, "Specify the non-default storage condition the retentate should be stored after dialysis:"},
			options=ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				RetentateStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options, RetentateStorageCondition],
			Refrigerator
		],
		Example[{Options, RetentateContainerOut, "Specify the container the retentate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				RetentateContainerOut->Model[Container, Vessel, "50mL Tube"],
				Output->Options
			];
			Lookup[options, RetentateContainerOut],
			ObjectP[Model[Container, Vessel, "50mL Tube"]]
		],
		Example[{Options, RetentateContainerOut, "Resolve the container the retentate should be stored after dialysis:"},
			options=ExperimentDialysis[
				Object[Sample,  "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Output->Options
			];
			Lookup[options, RetentateContainerOut][Type],
			Model[Container, Vessel]
		],

		(* --- Additional option tests --- *)

		(* --- Sample prep option tests --- *)

		Example[{Options,NumberOfReplicates,"Specify the number of times an experiment of repeated:"},
			protocol=ExperimentDialysis[Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],NumberOfReplicates -> 2];
			Download[protocol,NumberOfReplicates],
			2,
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol=ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Template -> Null];
			Download[protocol,Template],
			Null,
			Variables:>{protocol}
		],
		Example[
			{Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			protocol=ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Name->"My particular ExperimentDialysis protocol"];
			Download[protocol,Name],
			"My particular ExperimentDialysis protocol",
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentDialysis[
				{"salty sample 1", "salty sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "salty sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "salty sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, StockSolution, "NaCl Solution in Water"], Destination -> "salty sample 1", Amount -> 1000 Microliter],
					Transfer[Source ->Model[Sample, StockSolution, "NaCl Solution in Water"], Destination -> "salty sample 2", Amount -> 1000 Microliter]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, PreparatoryPrimitives, "Use the PreparatoryPrimitives option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentDialysis[
				{"salty sample 1", "salty sample 2"},
				PreparatoryPrimitives -> {
					Define[Name -> "salty sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					Define[Name -> "salty sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, StockSolution, "NaCl Solution in Water"], Destination -> "salty sample 1", Amount -> 1000 Microliter],
					Transfer[Source ->Model[Sample, StockSolution, "NaCl Solution in Water"], Destination -> "salty sample 2", Amount -> 1000 Microliter]
				}
			];
			Download[protocol, PreparatoryPrimitives],
			{SampleManipulationP..},
			Variables :> {protocol}
		],
		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], IncubateAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Centrifuge -> True, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 35 Milliliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterMaterial -> PTFE, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentDialysis[{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]}, FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentDialysis[Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentDialysis[Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentDialysis[Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentDialysis[Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentDialysis[Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterAliquot -> 400 Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AliquotAmount -> 400 Microliter, Output -> Options];
			Lookup[options, AliquotAmount],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentDialysis[
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			"mySample1",
			Variables:>{options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, AssayVolume],
			400 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentDialysis[Object[Sample,"sample 4 in 2L bottle for ExperimentDialysis testing with concentration"<> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentDialysis[Object[Sample,"sample 4 in 2L bottle for ExperimentDialysis testing with concentration"<> $SessionUUID],
				TargetConcentration -> 500 Micromolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Acetone"],
				AssayVolume -> 400 Microliter,
				Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Acetone"]]
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 400*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 200*Microliter, AssayVolume -> 400 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Aliquot -> True,
				AliquotPreparation -> Manual,
				Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], AliquotContainer -> Model[Container, Plate, "24-well V-bottom 10 mL Deep Well Plate Sterile"], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "If multiple specified samples are in the same container but have different SamplesInStorageCondition values set, throw an error:"},
			ExperimentDialysis[
				{Object[Sample, "sample 5 in plate for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 6 in plate for ExperimentDialysis testing"<> $SessionUUID]},
				SamplesInStorageCondition -> {Refrigerator, Freezer}],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],
		(* Tests *)
		Test["Populate the StirBar, FloatingRacks fields for dialysis membranes that require floating racks:",
			prot = ExperimentDialysis[{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},DialysisMembrane->Model[Container, Vessel, Dialysis, "id:8qZ1VW0VPbzp"]];
			Download[prot, {StirBar, FloatingRacks}],
			{
				ObjectP[Model[Part, StirBar]],
				{ObjectP[Model[Container,FloatingRack]],ObjectP[Model[Container,FloatingRack]]}
			},
			Variables :> {prot}
		],
		Test["Populate the StirBar, DialysisClips and DialysisMembraneLengths fields for tube based dialysis membranes:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID],DialysisMethod->StaticDialysis];
			Download[prot, {StirBar, DialysisClips, DialysisMembraneLengths}],
			{
				ObjectP[Model[Part, StirBar]],
				{{ObjectP[Model[Part,DialysisClip]],ObjectP[Model[Part,DialysisClip]]}},
				{GreaterP[0 Millimeter]}
			},
			Variables :> {prot}
		],
		Test["Populate the RunTimes field:",
			prot = ExperimentDialysis[{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]}];
			Download[prot, RunTimes],
			{GreaterP[0Hour],GreaterP[0Hour]},
			Variables :> {prot}
		],
		Test["Populate the DialysisMethod field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis
			];
			Download[prot, DialysisMethod],
			StaticDialysis,
			Variables :> {prot}
		],
		Test["Populate the Instrument field:",
			prot = ExperimentDialysis[{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				Instrument->Model[Instrument, Dialyzer, "id:pZx9jo8j7DKe"]
			];
			Download[prot, Instrument],
			ObjectP[Model[Instrument, Dialyzer, "id:pZx9jo8j7DKe"]],
			Variables :> {prot}
		],
		Test["Populate the DialysateTemperature field:",
			prot = ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateTemperature->37Celsius
			];
			Download[prot, DialysateTemperature],
			37.`Celsius,
			Variables :> {prot}
		],
		Test["Populate the DialysisTime field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisTime->1Hour
			];
			Download[prot, DialysisTime],
			1.`Hour,
			Variables :> {prot}
		],
		Test["Populate the DialysateContainer field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysateContainer->Model[Container, Vessel, "id:wqW9BP4Y0009"]
			];
			Download[prot, DialysateContainer],
			{ObjectP[Model[Container, Vessel, "id:wqW9BP4Y0009"]]},
			Variables :> {prot}
		],
		Test["Populate the DialysisMixRate field:",
			prot = ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysisMixRate->300RPM
			];
			Download[prot, DialysisMixRate],
			300.`RPM,
			Variables :> {prot}
		],
		Test["Populate the FlowRate field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				FlowRate->5Milliliter/Minute
			];
			Download[prot, FlowRate],
			5.`Milliliter/Minute,
			Variables :> {prot}
		],
		Test["Populate the DialysisMembranes field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				DialysisMembrane->Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID]
			];
			Download[prot, DialysisMembranes],
			{ObjectP[Object[Item, DialysisMembrane]]},
			Variables :> {prot}
		],
		Test["Populate the Dialysates field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Dialysate->Model[Sample,"Milli-Q water"]
			];
			Download[prot, Dialysates],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables :> {prot}
		],
		Test["Populate the DialysateVolumes field:",
			prot = ExperimentDialysis[
				{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID], Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID]},
				DialysateVolume->1Liter
			];
			Download[prot, DialysateVolumes],
			{1000.`Milliliter,1000.`Milliliter},
			Variables :> {prot}
		],
		Test["Populate the RetentateStorageConditions field:",
			prot = ExperimentDialysis[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				RetentateStorageCondition->Refrigerator
			];
			Download[prot, RetentateStorageConditions],
			{Refrigerator},
			Variables :> {prot}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "ExperimentDialysis all site user" <> $SessionUUID]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		Module[{allObjects, existingObjects},
			allObjects = Flatten[{
				Object[Container, Bench, "Test bench for ExperimentDialysis tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 4 in 2L bottle for ExperimentDialysis testing with concentration"<> $SessionUUID],

				Object[Sample, "sample with no model in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "discarded sample in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 5 in plate for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 6 in plate for ExperimentDialysis testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentDialysis tests"<> $SessionUUID],

				Object[Container, Vessel, "discarded 50mL tube for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel, "no model 50mL tube for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel,"2L bottle for ExperimentDialysis tests with conc"<> $SessionUUID],
				Object[Container,Plate, "plate for ExperimentDialysis tests"<> $SessionUUID],

				Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID],

				Object[User, "ExperimentDialysis all site user" <> $SessionUUID],
				Object[Team, Financing, "all site financing team" <> $SessionUUID],
				Object[LaboratoryNotebook, "ExperimentDialysis all site user notebook" <> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, vessel1, vessel2, vessel3, vesselDiscarded, vesselNoModel, vesselConcentration, plate1,
					sample1, sample2, sample3, sampleDiscarded, sampleNoModel, sampleConcentration, samplePlate1, samplePlate2,
					allSiteUser, allSiteFinancingTeam, allSiteNotebook
				},

				(* create a user that has access to all site *)

				allSiteUser = Upload[<|
					Type -> Object[User],
					FirstName -> "AllSite",
					LastName -> "User",
					Status -> Active,
					DeveloperObject -> True,
					Name -> "ExperimentDialysis all site user" <> $SessionUUID,
					Email -> "ExperimentDialysisAllSiteUser" <> $SessionUUID <> "@emeraldcloudlab.com"
				|>];

				allSiteNotebook = Upload[<|
					Replace[Administrators] -> {Link[Object[User, "ExperimentDialysis all site user" <> $SessionUUID]]},
					Type -> Object[LaboratoryNotebook],
					DeveloperObject -> True,
					Name -> "ExperimentDialysis all site user notebook" <> $SessionUUID
				|>];

				allSiteFinancingTeam = Upload[<|
					Replace[Administrators] -> {Link[Object[User, "ExperimentDialysis all site user" <> $SessionUUID]]},
					DefaultMailingAddress -> Link[Object[Container, Site, "ECL-2"]],
					Replace[ExperimentSites] -> {
						Link[Object[Container, Site, "ECL-1"], FinancingTeams],
						Link[Object[Container, Site, "ECL-2"], FinancingTeams],
						Link[Object[Container, Site, "ECL-CMU"], FinancingTeams]
					},
					MaxComputationThreads -> 5,
					MaxThreads -> 0,
					Replace[Members] -> {Link[Object[User, "ExperimentDialysis all site user" <> $SessionUUID], FinancingTeams]},
					Replace[NotebooksFinanced] -> {Link[Object[LaboratoryNotebook, "ExperimentDialysis all site user notebook" <> $SessionUUID], Financers]},
					Type -> Object[Team, Financing],
					DeveloperObject -> True,
					Name -> "all site financing team" <> $SessionUUID|>];

				(*perform the fist upload*)
				{testBench}=Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentDialysis tests"<> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					|>
				}];

				{
					vessel1,
					vessel2,
					vessel3,
					vesselDiscarded,
					vesselNoModel,
					vesselConcentration,
					plate1
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2L Glass Bottle"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2L Glass Bottle"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentDialysis tests"<> $SessionUUID,
						"50mL tube 1 for ExperimentDialysis tests"<> $SessionUUID,
						"2L bottle for ExperimentDialysis tests"<> $SessionUUID,
						"discarded 50mL tube for ExperimentDialysis tests"<> $SessionUUID,
						"no model 50mL tube for ExperimentDialysis tests"<> $SessionUUID,
						"2L bottle for ExperimentDialysis tests with conc"<> $SessionUUID,
						"plate for ExperimentDialysis tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3,
					sampleDiscarded,
					sampleNoModel,
					sampleConcentration,
					samplePlate1,
					samplePlate2
				} = UploadSample[
					{
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3},
						{"A1", vesselDiscarded},
						{"A1", vesselNoModel},
						{"A1", vesselConcentration},
						{"A1", plate1},
						{"A2", plate1}
					},
					Name -> {
						"sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID,
						"sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID,
						"sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID,
						"discarded sample in 50mL tube for ExperimentDialysis testing"<> $SessionUUID,
						"sample with no model in 50mL tube for ExperimentDialysis testing"<> $SessionUUID,
						"sample 4 in 2L bottle for ExperimentDialysis testing with concentration"<> $SessionUUID,
						"sample 5 in plate for ExperimentDialysis testing"<> $SessionUUID,
						"sample 6 in plate for ExperimentDialysis testing"<> $SessionUUID
					},
					InitialAmount -> {
						1000*Microliter,
						35*Milliliter,
						1*Liter,
						35*Milliliter,
						35*Milliliter,
						1*Liter,
						1*Milliliter,
						1*Milliliter
					}
				];

				Upload[Flatten[{
					<|
						Object -> Object[Sample, "sample with no model in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
						Model -> Null
					|>,
					<|
						Object -> Object[Sample, "sample 4 in 2L bottle for ExperimentDialysis testing with concentration"<> $SessionUUID],
						Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
					|>,
					<|
						Type->Model[Item, DialysisMembrane],
						Name->"Test membrane for ExperimentDialysis tests"<> $SessionUUID,
						MaxTemperature->40 Celsius,
						MinTemperature->10 Celsius,
						FlatWidth->10Millimeter,
						MembraneMaterial->RegeneratedCellulose,
						VolumePerLength->0.33Liter/Meter,
						MolecularWeightCutoff->8 Kilo Dalton
					|>
				}]];

				UploadSampleStatus[sampleDiscarded, Discarded, FastTrack -> True];
			]
		]
	),

	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existingObjects},
			allObjects = Cases[Flatten[{
				$CreatedObjects,

				Object[Container, Bench, "Test bench for ExperimentDialysis tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 4 in 2L bottle for ExperimentDialysis testing with concentration"<> $SessionUUID],

				Object[Sample, "sample with no model in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "discarded sample in 50mL tube for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 5 in plate for ExperimentDialysis testing"<> $SessionUUID],
				Object[Sample, "sample 6 in plate for ExperimentDialysis testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentDialysis tests"<> $SessionUUID],

				Object[Container, Vessel, "discarded 50mL tube for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel, "no model 50mL tube for ExperimentDialysis tests"<> $SessionUUID],
				Object[Container, Vessel,"2L bottle for ExperimentDialysis tests with conc"<> $SessionUUID],
				Object[Container,Plate, "plate for ExperimentDialysis tests"<> $SessionUUID],

				Model[Item, DialysisMembrane, "Test membrane for ExperimentDialysis tests"<> $SessionUUID],

				Object[User, "ExperimentDialysis all site user" <> $SessionUUID],
				Object[Team, Financing, "all site financing team" <> $SessionUUID],
				Object[LaboratoryNotebook, "ExperimentDialysis all site user notebook" <> $SessionUUID]
			}], ObjectP[]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];

(* ::Subsection:: *)
(*ExperimentDialysisOptions*)

DefineTests[
	ExperimentDialysisOptions,
	{
		(* --- Basic --- *)

		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentDialysisOptions[Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisOptions testing"<> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for pooling multiple samples together:"},
			ExperimentDialysisOptions[{{Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisOptions testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisOptions testing"<> $SessionUUID]}, {Object[Sample, "sample 3 in 2L bottle for ExperimentDialysisOptions testing"<> $SessionUUID]}}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentDialysisOptions[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisOptions testing"<> $SessionUUID], OutputFormat -> List],
			{__Rule}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		Module[{allObjects, existingObjects},
			allObjects = Flatten[{
				Object[Container, Bench, "Test bench for ExperimentDialysisOptions tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisOptions testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisOptions testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysisOptions testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDialysisOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentDialysisOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentDialysisOptions tests"<> $SessionUUID]

			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, vessel1, vessel2, vessel3,	sample1, sample2, sample3
				},
				(*perform the fist upload*)
				{testBench}=Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentDialysisOptions tests"<> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					|>
				}];

				{
					vessel1,
					vessel2,
					vessel3
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2L Glass Bottle"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentDialysisOptions tests"<> $SessionUUID,
						"50mL tube 1 for ExperimentDialysisOptions tests"<> $SessionUUID,
						"2L bottle for ExperimentDialysisOptions tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3}
					},
					Name -> {
						"sample 1 in 2mL tube for ExperimentDialysisOptions testing"<> $SessionUUID,
						"sample 2 in 50mL tube for ExperimentDialysisOptions testing"<> $SessionUUID,
						"sample 3 in 2L bottle for ExperimentDialysisOptions testing"<> $SessionUUID
					},
					InitialAmount -> {
						1000*Microliter,
						35*Milliliter,
						1*Liter
					}
				];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existingObjects},
			allObjects = Cases[Flatten[{
				$CreatedObjects,

				Object[Container, Bench, "Test bench for ExperimentDialysisOptions tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisOptions testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisOptions testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysisOptions testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDialysisOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentDialysisOptions tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentDialysisOptions tests"<> $SessionUUID]
			}], ObjectP[]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];

(* ::Subsection:: *)
(*ValidExperimentDialysisQ*)
DefineTests[
	ValidExperimentDialysisQ,
	{
		(* --- Basic --- *)

		Example[{Basic, "Determine the validity of a Dialysis call on one sample:"},
			ValidExperimentDialysisQ[
				Object[Sample, "sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Determine the validity of a Dialysis call on multiple pooled samples:"},
			ValidExperimentDialysisQ[
				{
					{Object[Sample, "sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID]},
					{Object[Sample, "sample 3 in 2L bottle for ValidExperimentDialysisQ testing"<> $SessionUUID]}}
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentDialysisQ[
				{
					{Object[Sample, "sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID], Object[Sample, "sample 2 in 50mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID]},
					{Object[Sample, "sample 3 in 2L bottle for ValidExperimentDialysisQ testing"<> $SessionUUID]}
				},
				OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentDialysisQ[
				Object[Sample, "sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID],
				DialysisMethod->StaticDialysis,
				FlowRate->6 Milliliter/Minute, Verbose -> Failures
			],
			False
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		Module[{allObjects, existingObjects},
			allObjects = Flatten[{
				Object[Container, Bench, "Test bench for ValidExperimentDialysisQ tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ValidExperimentDialysisQ testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ValidExperimentDialysisQ tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ValidExperimentDialysisQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ValidExperimentDialysisQ tests"<> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];


		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, vessel1, vessel2, vessel3, sample1, sample2, sample3
				},
				(*perform the fist upload*)
				{testBench}=Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ValidExperimentDialysisQ tests"<> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]
					|>
				}];

				{
					vessel1,
					vessel2,
					vessel3
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2L Glass Bottle"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ValidExperimentDialysisQ tests"<> $SessionUUID,
						"50mL tube 1 for ValidExperimentDialysisQ tests"<> $SessionUUID,
						"2L bottle for ValidExperimentDialysisQ tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3}
					},
					Name -> {
						"sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID,
						"sample 2 in 50mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID,
						"sample 3 in 2L bottle for ValidExperimentDialysisQ testing"<> $SessionUUID
					},
					InitialAmount -> {
						1000*Microliter,
						35*Milliliter,
						1*Liter
					}
				];
			]
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existingObjects},
			allObjects = Cases[Flatten[{
				$CreatedObjects,

				Object[Container, Bench, "Test bench for ValidExperimentDialysisQ tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ValidExperimentDialysisQ testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ValidExperimentDialysisQ testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ValidExperimentDialysisQ tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ValidExperimentDialysisQ tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ValidExperimentDialysisQ tests"<> $SessionUUID]
			}], ObjectP[]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];

(* ::Subsection:: *)
(*ExperimentDialysisPreview*)

DefineTests[
	ExperimentDialysisPreview,
	{
		(* --- Basic --- *)

		Example[{Basic, "Return Null for one sample:"},
			ExperimentDialysisPreview[Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisPreview testing"<> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for mulitple samples:"},
			ExperimentDialysisPreview[{{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisPreview testing"<> $SessionUUID], Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisPreview testing"<> $SessionUUID]}}],
			Null
		],
		Example[{Basic, "Return Null for mulitple poooled samples:"},
			ExperimentDialysisPreview[{{Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisPreview testing"<> $SessionUUID],  Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisPreview testing"<> $SessionUUID]}, {Object[Sample, "sample 3 in 2L bottle for ExperimentDialysisPreview testing"<> $SessionUUID]}}],
			Null
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		Module[{allObjects, existingObjects},
			allObjects = Flatten[{
				Object[Container, Bench, "Test bench for ExperimentDialysisPreview tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisPreview testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisPreview testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysisPreview testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDialysisPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentDialysisPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentDialysisPreview tests"<> $SessionUUID]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];


		Block[{$DeveloperUpload = True},
			Module[
				{
					testBench, vessel1, vessel2, vessel3, sample1, sample2, sample3
				},
				(*perform the fist upload*)
				{testBench}=Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentDialysisPreview tests"<> $SessionUUID,
						DeveloperObject -> True,
						Site -> Link[$Site]|>
				}];

				{
					vessel1,
					vessel2,
					vessel3
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2L Glass Bottle"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack -> True,
					Name -> {
						"2mL tube 1 for ExperimentDialysisPreview tests"<> $SessionUUID,
						"50mL tube 1 for ExperimentDialysisPreview tests"<> $SessionUUID,
						"2L bottle for ExperimentDialysisPreview tests"<> $SessionUUID
					}
				];

				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					},
					{
						{"A1", vessel1},
						{"A1", vessel2},
						{"A1", vessel3}
					},
					Name -> {
						"sample 1 in 2mL tube for ExperimentDialysisPreview testing"<> $SessionUUID,
						"sample 2 in 50mL tube for ExperimentDialysisPreview testing"<> $SessionUUID,
						"sample 3 in 2L bottle for ExperimentDialysisPreview testing"<> $SessionUUID
					},
					InitialAmount -> {
						1000*Microliter,
						35*Milliliter,
						1*Liter
					}
				];
			]]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existingObjects},
			allObjects = Cases[Flatten[{
				$CreatedObjects,

				Object[Container, Bench, "Test bench for ExperimentDialysisPreview tests"<> $SessionUUID],

				Object[Sample, "sample 1 in 2mL tube for ExperimentDialysisPreview testing"<> $SessionUUID],
				Object[Sample, "sample 2 in 50mL tube for ExperimentDialysisPreview testing"<> $SessionUUID],
				Object[Sample, "sample 3 in 2L bottle for ExperimentDialysisPreview testing"<> $SessionUUID],

				Object[Container, Vessel, "2mL tube 1 for ExperimentDialysisPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "50mL tube 1 for ExperimentDialysisPreview tests"<> $SessionUUID],
				Object[Container, Vessel, "2L bottle for ExperimentDialysisPreview tests"<> $SessionUUID]
			}], ObjectP[]];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		]
	)
];