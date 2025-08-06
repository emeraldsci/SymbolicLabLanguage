(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection:: *)
(*ExperimentNMR2D*)

DefineTests[ExperimentNMR2D,
	{
		Example[{Basic, "Obtain an NMR spectrum of a given sample:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Additional, "Obtain an NMR spectrum of a given sample with no subtype:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D Test chemical with no subtype" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Basic, "Obtain an NMR spectrum of the sample inside a given container:"},
			ExperimentNMR2D[Object[Container, Vessel, "Test container 7 for ExperimentNMR2D tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Basic, "Obtain an NMR spectrum of the sample inside a given position of a given container:"},
			ExperimentNMR2D[{"A1", Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR2D tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Basic, "Obtain NMR spectra of multiple samples:"},
			ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Additional,"Obtain NMR spectra of a given sample with severed Model link:"},
			ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (80 uL)" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the amount of an input Model[Sample] and the container in which it is to be prepared:"},
			options = ExperimentNMR2D[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "2mL Tube"],
				PreparedModelAmount -> 1 Milliliter,
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
				{ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentNMR2D[
				Model[Sample, "Caffeine"],
				PreparedModelAmount -> 5 Milligram,
				MixType -> Vortex, IncubationTime -> 10 Minute
			],
			ObjectP[Object[Protocol, NMR2D]]
		],
		Example[{Options, ExperimentType, "Use the ExperimentType option to set which spectroscopic method will be used to obtain the 2D NMR spectrum:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> TOCSY, Output -> Options];
			Lookup[options, ExperimentType],
			TOCSY,
			Variables :> {options}
		],
		Example[{Options, ExperimentType, "If not specified, ExperimentType is set based on the IndirectNucleus and TOCSYMixTime options:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, IndirectNucleus -> {"1H", "1H", "13C"}, TOCSYMixTime -> {Automatic, 70*Millisecond, Automatic}, Output -> Options];
			Lookup[options, ExperimentType],
			{COSY, TOCSY, HSQC},
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "Use the NumberOfScans option to set the number of pulse and read cycles that will be averaged together that are applied to each sample for each directly measured free induction decay (FID):"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> COSY, NumberOfScans -> 8, Output -> Options];
			Lookup[options, NumberOfScans],
			8,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "If not set, NumberOfScans is set according to the ExperimentType:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID]}, ExperimentType -> {COSY, ROESY}, Output -> Options];
			Lookup[options, NumberOfScans],
			{2, 16},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfDummyScans, "Use the NumberOfDummyScans option to set the number of scans performed before the receiver is turned on and data is collected for each directly measured free induction decay (FID):"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> COSY, NumberOfDummyScans -> 8, Output -> Options];
			Lookup[options, NumberOfDummyScans],
			8,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfDummyScans, "If not set, NumberOfDummyScans is set according to the ExperimentType:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID]}, ExperimentType -> {COSY, ROESY}, Output -> Options];
			Lookup[options, NumberOfDummyScans],
			{16, 32},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* There is only one options for DirectNucleus right now, so it is currently a hidden option and we don't want to run this test. *)
		(*Example[{Options, DirectNucleus, "Use the DirectNucleus option to set the nucleus that will be read repeatedly and directly over the course of the experiment:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectNucleus -> "1H", Output -> Options];
			Lookup[options, DirectNucleus],
			"1H",
			Variables :> {options}
		],*)
		Example[{Options, IndirectNucleus, "Use the IndirectNucleus option to set the nucleus whose spectrum is measured through the modulation of the directly-measured spectrum of the DirectNucleus over time:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], IndirectNucleus -> "15N", Output -> Options];
			Lookup[options, IndirectNucleus],
			"15N",
			Variables :> {options},
			Stubs :> {$DeveloperSearch = True}
		],
		Example[{Options, IndirectNucleus, "If not specified, IndirectNucleus is set to 1H if ExperimentType is a homonuclear experiment, or 13C if a heteronuclear experiment:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, ExperimentType -> {NOESY, HMBC}, Output -> Options];
			Lookup[options, IndirectNucleus],
			{"1H", "13C"},
			Variables :> {options}
		],
		Example[{Options, DirectNumberOfPoints, "Use the DirectNumberOfPoints option to specify the number of data points collected for each directly-measured free induction decay (FID):"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectNumberOfPoints -> 4096, Output -> Options];
			Lookup[options, DirectNumberOfPoints],
			4096,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DirectNumberOfPoints, "If DirectAcquisitionTime and DirectSpectralDomain are directly specified, calculate the DirectNumberOfPoints using the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>):"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectAcquisitionTime -> 0.3 Second, DirectSpectralDomain -> Span[-0.1 PPM, 14 PPM], Output -> Options];
			Lookup[options, DirectNumberOfPoints],
			2115,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DirectAcquisitionTime, "Use the DirectAcquisitionTime option to specify the length of time during which the NMR signal is sampled and digitized per directly-measured scan:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectAcquisitionTime -> 0.3*Second, Output -> Options];
			Lookup[options, DirectAcquisitionTime],
			0.3*Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DirectAcquisitionTime, "If DirectNumberOfPoints and DirectSpectralDomain are directly specified, calculate the DirectAcquisitionTime using the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>):"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectNumberOfPoints -> 4096, DirectSpectralDomain -> Span[-0.1 PPM, 14 PPM], Output -> Options];
			Lookup[options, DirectAcquisitionTime],
			0.581 Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DirectSpectralDomain, "Use the DirectSpectralDomain option to specify the range of the observed frequencies for the directly-observed nucleus:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> COSY, DirectSpectralDomain -> Span[-2.0 PPM, 14 PPM], Output -> Options];
			Lookup[options, DirectSpectralDomain],
			Span[-2.0 PPM, 14 PPM],
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DirectSpectralDomain, "If DirectAcquisitionTime and DirectNumberOfPoints are directly specified, calculate the DirectSpectralDomain using the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>) and the specified ExperimentType:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectAcquisitionTime -> 0.3 Second, DirectNumberOfPoints -> 2048, Output -> Options];
			Lookup[options, DirectSpectralDomain],
			(* TODO the precision here is too much but since RoundOptionPrecision doesn't work with spans yet this is what we get.  fix this once it does *)
			_Span,
			(*EquivalenceFunction -> Equal,*)
			Variables :> {options}
		],
		Example[{Options, IndirectNumberOfPoints, "Use the IndirectNumberOfPoints option to specify the number of directly-measured free induction decays (FIDs) collected that together constitute the FIDs of the indirectly-measured nucleus:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], IndirectNumberOfPoints -> 2048, Output -> Options];
			Lookup[options, IndirectNumberOfPoints],
			2048,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IndirectNumberOfPoints, "If not specified, IndirectNumberOfPoints is set based on the ExperimentType option:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, ExperimentType -> {COSY, DQFCOSY}, Output -> Options];
			Lookup[options, IndirectNumberOfPoints],
			{128, 256},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IndirectNumberOfPoints, "Use the IndirectNumberOfPoints option to specify the number of directly-measured free induction decays (FIDs) collected that together constitute the FIDs of the indirectly-measured nucleus:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], IndirectNumberOfPoints -> 2048, Output -> Options];
			Lookup[options, IndirectNumberOfPoints],
			2048,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IndirectSpectralDomain, "Use the IndirectSpectralDomain option to specify the range of the observed frequencies for the indirectly-observed nucleus:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> COSY, IndirectSpectralDomain -> Span[-2.0 PPM, 14 PPM], Output -> Options];
			Lookup[options, IndirectSpectralDomain],
			Span[-2.0 PPM, 14 PPM],
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IndirectSpectralDomain, "If not specified, IndirectSpectralDomain is set based on the ExperimentType and IndirectNucleus options:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, ExperimentType -> {COSY, HMBC, HMBC}, IndirectNucleus -> {"1H", "13C", "15N"}, Output -> Options];
			Lookup[options, IndirectSpectralDomain],
			{
				Span[-0.5 PPM, 12.5 PPM],
				Span[-10 PPM, 210 PPM],
				Span[-50 PPM, 350 PPM]
			},
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {$DeveloperSearch = True}
		],
		(* TODO once we support NUS put it in here *)
		(*Example[{Options, SamplingMethod, "Use the SamplingMethod to set the method of spacing the directly-measured Free Induction Decays (FIDs) to create the 2D spectrum:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplingMethod -> TraditionalSampling, Output -> Options];
			Lookup[options, SamplingMethod],
			TraditionalSampling,
			Variables :> {options}
		],*)
		(* TODO once we support NUS uncomment this task *)
		(*Example[{Options, SamplingMethod, "If not specified, SamplingMethod is set to TraditionalSampling if ExperimentType is a homonuclear experiment, or NonUniformSampling if ExperimentType is a heteronuclear experiment:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, ExperimentType -> {COSY, HMBC}, Output -> Options];
			Lookup[options, SamplingMethod],
			{TraditionalSampling, NonUniformSampling},
			Variables :> {options}
		],*)
		Example[{Options, TOCSYMixTime, "Use the TOCSYMixTime option to set the duration of the spin-lock sequence prior to data collection for TOCSY, HSQCTOCSY, or HMQCTOCSY options:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], TOCSYMixTime -> 90 Millisecond, Output -> Options];
			Lookup[options, {TOCSYMixTime, ExperimentType}],
			{90 Millisecond, TOCSY},
			Variables :> {options}
		],
		Example[{Options, TOCSYMixTime, "If not specified, TOCSYMixTime is set to Null if ExperimentType is a non-TOCSY experiment, 80 Millisecond if ExperimentType -> TOCSY | HMQCTOCSY, or 60 Millisecond if ExperimentType -> HSQCTOCSY:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, ExperimentType -> {COSY, TOCSY, HSQCTOCSY}, Output -> Options];
			Lookup[options, TOCSYMixTime],
			{Null, 80 Millisecond, 60 Millisecond},
			Variables :> {options}
		],
		Example[{Options, PulseSequence, "Use the PulseSequence option to specify a custom pulse sequence for this experiment according to the Bruker format.  Note that this will always throw a warning:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseSequence -> Object[EmeraldCloudFile, "Test 90 Degree Pulse Sequence"], Output -> Options];
			Lookup[options, PulseSequence],
			ObjectP[Object[EmeraldCloudFile]],
			Variables :> {options},
			Messages :> {Warning::PulseSequenceSpecified}
		],
		Example[{Options, PulseSequence, "If a direct string is specified for the pulse sequence rather than a cloud file, a cloud file is created containing this string:"},
			protocol = ExperimentNMR2D[
				Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID],
				PulseSequence -> ";zg\n;avance-version (12/01/11)\n;1D sequence\n;\n;$CLASS=HighRes\n;$DIM=1D\n;$TYPE=\n;$SUBTYPE=\n;$COMMENT=\n\n\n#include <Avance.incl>\n\n\n\"acqt0=-p1*2/3.1416\"\n\n\n1 ze\n2 30m\n  d1\n  p1 ph1\n  go=2 ph31\n  30m mc #0 to 2 F0(zd)\nexit\n\n\nph1=0 2 2 0 1 3 3 1\nph31=0 2 2 0 1 3 3 1\n\n\n;pl1 : f1 channel - power level for pulse (default)\n;p1 : f1 channel -  high power pulse\n;d1 : relaxation delay; 1-5 * T1\n;ns: 1 * n, total number of scans: NS * TD0\n\n\n\n;$Id: zg,v 1.11 2012/01/31 17:49:31 ber Exp $"
			];
			Download[protocol, PulseSequences],
			{ObjectP[Object[EmeraldCloudFile]]},
			Variables :> {protocol},
			Messages :> {Warning::PulseSequenceSpecified}
		],
		Example[{Options, WaterSuppression, "Use the WaterSuppression option to specify the method for removing the water peak in the 1D spectrum prior to the 2D spectrum:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> HSQC, WaterSuppression -> Presaturation, DeuteratedSolvent -> Water, Output -> Options];
			Lookup[options, WaterSuppression],
			Presaturation,
			Variables :> {options}
		],
		Example[{Options, Probe, "Use the Probe option to specify the part inserted into the NMR that excites nuclear spins, detects the signal, and collects data:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Probe -> Model[Part, NMRProbe, "SmartProbe (5 mm)"], Output -> Options];
			Lookup[options, Probe],
			ObjectP[Model[Part, NMRProbe, "SmartProbe (5 mm)"]],
			Variables :> {options}
		],
		Example[{Options, Probe, "If not specified, Probe is set to Model[Part, NMRProbe, \"Inverse Triple Resonance (TXI) Probe (5 mm)\"] if IndirectNucleus includes 15N, or Model[Part, NMRProbe, \"SmartProbe (5 mm)\"] otherwise:"},
			options = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, IndirectNucleus -> {"1H", "13C", "15N"}, Output -> Options];
			Lookup[options, Probe],
			Model[Part, NMRProbe, "Inverse Triple Resonance (TXI) Probe (5 mm)"],
			Variables :> {options},
			Stubs :> {$DeveloperSearch = True}
		],
		Example[{Options, Probe, "If Probe is set to Model[Part, NMRProbe, \"Inverse Triple Resonance (TXI) Probe (5 mm)\"], populate the ShimmingStandard, ShimmingStandardSpinner, and DepthGauge fields:"},
			protocol = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID]}, IndirectNucleus -> {"1H", "13C", "15N"}];
			Download[protocol, {ShimmingStandard, ShimmingStandardSpinner, DepthGauge}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Container, NMRSpinner]],
				ObjectP[Model[Part, NMRDepthGauge]]
			},
			Variables :> {protocol},
			Stubs :> {$DeveloperSearch = True}
		],
		Example[{Options, DeuteratedSolvent, "Use the DeuteratedSolvent option to set which deuterated solvent in which to dissolve the sample:"},
			Download[ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Chloroform], DeuteratedSolvents],
			{ObjectP[Model[Sample, "Chloroform-d"]]},
			Variables :> {options}
		],
		Example[{Options, SolventVolume, "Use the DeuteratedSolvent option to set how much of the specified solvent is used to dissolve the sample:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Chloroform-d"], SolventVolume -> 800*Microliter, Output -> Options];
			Lookup[options, SolventVolume],
			800*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SolventVolume, "If SolventVolume is directly set to 0 Milliliter, then no solvent will be used and the sample will be loaded into NMR tubes directly:"},
			protocol = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 8 (1.5 mL)" <> $SessionUUID], DeuteratedSolvent -> DMSO, SolventVolume -> 0 Milliliter];
			Download[protocol, SolventVolumes],
			{0 Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, SampleAmount, "Use the SampleAmount option to set how much of the sample is dissolved in the deuterated solvent:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> 6*Milligram, DeuteratedSolvent -> Model[Sample, "Chloroform-d"], Output -> Options];
			Lookup[options, SampleAmount],
			6*Milligram,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SampleTemperature, "Use the SampleTemperature option to set the temperature at which the sample will be held prior to and during data collection:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, SampleTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to repeat an NMR sample preparation and reading of a provided sample.  This is functionally equivalent to listing the same sample n times in the input:"},
			Download[
				ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfReplicates -> 2],
				SamplesIn
			],
			{ObjectP[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID]]}
		],
		Test["If using NumberOfReplicates (or the same samples in multiple experiments), pick the appropriate number of NMR tubes/spinners:",
			protocol = ExperimentNMR2D[
				{Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample, "ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID]},
				NumberOfReplicates -> 2,
				NMRTube -> {Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"], Model[Container, Vessel, "Sealed NMR Tube"]}
			];
			requiredResources = Download[protocol, RequiredResources];
			{
				Tally[Download[Select[requiredResources, MatchQ[#[[2]], NMRTubes]&][[All, 1]], Object]],
				Download[protocol, NMRSpinners]
			},
			{
				{
					{ObjectP[Object[Resource, Sample]], 2},
					{ObjectP[Object[Resource, Sample]], 2}
				},
				{Null, Null, ObjectP[Model[Container, NMRSpinner]], ObjectP[Model[Container, NMRSpinner]]}
			},
			Variables :> {protocol, requiredResources}
		],
		Example[{Options, NMRTube, "Use the NMRTube option to set the model of NMR tube that will be used during this experiment:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"], Output -> Options];
			Lookup[options, NMRTube],
			ObjectP[Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"]],
			Variables :> {options}
		],
		Example[{Options, NMRTube, "If a sample is already in an NMR tube, the NMRTubes field is populated with that same container directly:"},
			protocol = ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID], Object[Sample, "ExperimentNMR2D Test chemical in normal NMR tube" <> $SessionUUID]}, NMRTube -> {Model[Container, Vessel, "Sealed NMR Tube"], Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"]}];
			Download[protocol, {NMRTubes, NMRSpinners}],
			{
				{ObjectP[Object[Container, Vessel, "Test container 8 for ExperimentNMR2D tests" <> $SessionUUID]], ObjectP[Object[Container, Vessel, "Test container 9 for ExperimentNMR2D tests" <> $SessionUUID]]},
				{ObjectP[Model[Container, NMRSpinner]], Null}
			},
			Variables :> {protocol}
		],
		Example[{Options, Instrument, "Use the Instrument option to set the instrument model or object that will be used during this experiment:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Instrument -> Object[Instrument, NMR, "Magneto"], Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, NMR, "Magneto"]],
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "If multiple specified samples are in the same container but have different SamplesInStorageCondition values set, throw an error:"},
			ExperimentNMR2D[{Object[Sample, "ExperimentNMR2D Test chemical in deep well plate 1" <> $SessionUUID], Object[Sample, "ExperimentNMR2D Test chemical in deep well plate 2" <> $SessionUUID]}, SamplesInStorageCondition -> {Refrigerator, Freezer}],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			options = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, Confirm, "Set Confirm -> True to immediately confirm protocol upon its creation:"},
			Download[ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Confirm -> True], Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options, CanaryBranch, "Specify the CanaryBranch on which the protocol is run:"},
			Download[ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CanaryBranch -> "d1cacc5a-948b-4843-aa46-97406bbfc368"], CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options, Name, "Set name of the new protocol:"},
			Download[ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "NMR2D protocol "<>$SessionUUID], Name],
			"NMR2D protocol "<>$SessionUUID
		],

		Example[{Options, Template, "Set options based on the protocol in the Template option:"},
			Download[ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Template -> Object[Protocol, NMR2D, "NMR2D Protocol 1" <> $SessionUUID]], ExperimentTypes],
			{ROESY}
		],

		(* --- Sample prep option tests --- *)
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentNMR2D[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Water"], AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Water"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],

		(* --- Messages tests --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentNMR2D[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentNMR2D[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentNMR2D[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentNMR2D[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentNMR2D[Link[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, NMR2D]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (Discarded)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "If the provided sample has a deprecated model, an error will be thrown:"},
			ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NMRTooManySamples", "If too many samples are used for one protocol, an error will be thrown:"},
			ExperimentNMR2D[ConstantArray[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], 97], DeuteratedSolvent -> Model[Sample, "Chloroform-d"]],
			$Failed,
			Messages :> {
				Error::NMRTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnsupportedNMRTube", "If the specified NMRTube are not currently supported by the ECL, an error will be thrown:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "2mL Tube"]],
			$Failed,
			Messages :> {
				Error::UnsupportedNMRTube,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NonStandardSolvent", "If the specified DeuteratedSolvent is not a standard deuterated solvent, throw a warning but continue:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol, NMR2D]],
			Messages :> {Warning::NonStandardSolvent}
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> 50*Microliter],
			$Failed,
			Messages :> {
				Error::SampleAmountStateConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples after aliquoting:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 10*Milligram],
			$Failed,
			Messages :> {
				Error::SampleAmountStateConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountTooHigh", "If the SampleAmount is above the amount available after sample prep, throw an error:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 110*Microliter],
			$Failed,
			Messages :> {
				Error::SampleAmountTooHigh,
				Error::InvalidOption,
				Error::NotEnoughRequiredAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "WaterSuppression2DIncompatible", "If WaterSuppression is set, IndirectNucleus must be set to 13C or 15N (or ExperimentType must be set to an experiment that supports IndirectNucleus being set to this value):"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], WaterSuppression -> WATERGATE, DeuteratedSolvent -> Water, ExperimentType -> COSY],
			$Failed,
			Messages :> {
				Error::WaterSuppression2DIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExperimentTypeNucleusIncompatible", "If ExperimentType and IndirectNucleus are not compatible, throw an error:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> COSY, IndirectNucleus -> "13C"],
			$Failed,
			Messages :> {
				Error::ExperimentTypeNucleusIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DirectAcquisitionParametersIncompatible", "If DirectAcquisitionTime, DirectNumberOfPoints, and DirectSpectralDomain are all specified, they must follow the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>):"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectNumberOfPoints -> 2048, DirectAcquisitionTime -> 0.2*Second, DirectSpectralDomain -> Span[0 PPM, 8 PPM]],
			$Failed,
			Messages :> {
				Error::DirectAcquisitionParametersIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TOCSYMixTimeIncompatible", "If ExperimentType is not a TOCSY variant, TOCSYMixTime must be Null:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], TOCSYMixTime -> 80*Millisecond, ExperimentType -> ROESY],
			$Failed,
			Messages :> {
				Error::TOCSYMixTimeIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PulseSequenceSpecified", "If a pulse sequence is directly specified, throw a warning:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseSequence -> Object[EmeraldCloudFile, "Test 90 Degree Pulse Sequence"]],
			ObjectP[Object[Protocol, NMR2D]],
			Messages :> {Warning::PulseSequenceSpecified}
		],
		Example[{Messages, "PulseSequenceMustBeTextFile", "If the pulse sequence is specified, the file must be a text file:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseSequence -> Object[EmeraldCloudFile, "Pulse Sequence Programming Tutorial"]],
			$Failed,
			Messages :> {Error::PulseSequenceMustBeTextFile, Warning::PulseSequenceSpecified, Error::InvalidOption}
		],
		Example[{Messages, "NMRTubesIncompatible", "If NMRTube is set to the Sealed NMR Tube, the sample must already be in that container model:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "Sealed NMR Tube"]],
			$Failed,
			Messages :> {
				Error::NMRTubesIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is already in an NMR tube, SolventVolume must be Null:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID], SolventVolume -> 600*Microliter, NMRTube -> Model[Container, Vessel, "Sealed NMR Tube"]],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is already in an NMR tube, SampleAmount must be Null:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID], SampleAmount -> 5*Microliter, NMRTube -> Model[Container, Vessel, "Sealed NMR Tube"]],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is not already in an NMR tube, SampleAmount must not be Null:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> Null],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is not already in an NMR tube, SolventVolume must not be Null:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], SolventVolume -> Null],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ZeroSpectralDomain", "If the length of DirectSpectralDomain is 0 PPM, an error is thrown:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectSpectralDomain -> Span[5 PPM, 5 PPM]],
			$Failed,
			Messages :> {
				Error::ZeroSpectralDomain,
				Error::DirectAcquisitionParametersIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ZeroSpectralDomain", "If the length of IndirectSpectralDomain is 0 PPM, an error is thrown:"},
			ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID], IndirectSpectralDomain -> Span[5 PPM, 5 PPM]],
			$Failed,
			Messages :> {
				Error::ZeroSpectralDomain,
				Error::InvalidOption
			}
		],

		(* various tests *)
		Test["Populate ProbeDisconnectionSlot field:",
			prot = ExperimentNMR2D[Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID]];
			Download[prot, ProbeDisconnectionSlot],
			{ObjectP[Model[Instrument, NMR]], "Cable Slot"},
			Variables :> {prot}
		]
	},
	Stubs :> {
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
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
					Object[Container, Bench, "Test bench for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 9 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 10 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 11 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical in normal NMR tube" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
					Object[Protocol, NMR2D, "NMR2D Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, NMR2D, "NMR2D Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}],
					Object[Sample, "ExperimentNMR2D Test chemical in deep well plate 1" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical in deep well plate 2" <> $SessionUUID],
					Object[Container, Plate, "Test plate with two samples for ExperimentNMR2D tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, fakeProtocol1, sample8, container8, fakeProtSubObjs,
					completeTheFakeProtocol, container9, sample9, container10, sample10, container11, sample11, container12,
					sample12, sample13, sample14, container13},

				testBench = Upload[<|Type -> Object[Container, Bench], Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentNMR2D tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container11,
					container12,
					container13
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
						Model[Container, Vessel, "Sealed NMR Tube"],
						Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
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
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Test container 1 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 2 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test crystallization plate 1 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 3 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 4 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 5 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 6 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 7 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 8 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 9 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 10 for ExperimentNMR2D tests" <> $SessionUUID,
						"Test plate with two samples for ExperimentNMR2D tests" <> $SessionUUID,
						"Test container 11 for ExperimentNMR2D tests" <> $SessionUUID
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
					sample9,
					sample10,
					sample11,
					sample12,
					sample13,
					sample14
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
						Model[Sample, "Caffeine"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Toluene, Anhydrous"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						{
							{8 Milligram / Milliliter, Model[Molecule, "Caffeine"]},
							{100 VolumePercent, Model[Molecule, "Dimethyl sulfoxide-d6"]}
						}
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
						{"A1", container9},
						{"A1", container10},
						{"A1", container11},
						{"A1", container12},
						{"A2", container12},
						{"A1", container13}
					},
					InitialAmount -> {
						100*Microliter,
						80*Microliter,
						0.1*Milliliter,
						25*Milliliter,
						1.5*Milliliter,
						100*Microliter,
						100*Microliter,
						100*Milligram,
						500*Microliter,
						500*Microliter,
						100*Microliter,
						100*Microliter,
						100*Microliter,
						1.5*Milliliter
					},
					Name -> {
						"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 1 (Deprecated Model)" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID,
						"ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID,
						"ExperimentNMR2D Test chemical in normal NMR tube" <> $SessionUUID,
						"ExperimentNMR2D Test chemical with no subtype" <> $SessionUUID,
						"ExperimentNMR2D Test chemical in deep well plate 1" <> $SessionUUID,
						"ExperimentNMR2D Test chemical in deep well plate 2" <> $SessionUUID,
						"ExperimentNMR2D New Test Chemical 8 (1.5 mL)" <> $SessionUUID
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null, Site -> Link[$Site]|> & /@ Cases[Flatten[
					{
						container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13,
						sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14
					}
				], ObjectP[]]];
				Upload[Cases[Flatten[{
					<|Object -> sample2, Model -> Null, Site -> Link[$Site]|>,
					<|Object -> sample5, Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]], Now}}, Site -> Link[$Site]|>,
					<|Object -> sample6, Status -> Discarded, Model->Null, Site -> Link[$Site]|>,
					<|Object -> sample11, Model -> Null, Site -> Link[$Site]|>
				}], PacketP[]]];

				fakeProtocol1 = ExperimentNMR2D[Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "NMR2D Protocol 1" <> $SessionUUID, Confirm -> True, ExperimentType -> ROESY, SampleTemperature -> -10*Celsius];
				completeTheFakeProtocol = UploadProtocolStatus[fakeProtocol1, Completed, FastTrack -> True];
				fakeProtSubObjs = Flatten[Download[fakeProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Cases[Flatten[{fakeProtocol1, fakeProtSubObjs}], ObjectP[]]]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 9 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 10 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 11 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical in sealed tube" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical in normal NMR tube" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR2D tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2D New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
					Object[Protocol, NMR2D, "NMR2D Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, NMR2D, "NMR2D Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}],
					Object[Sample, "ExperimentNMR2D Test chemical in deep well plate 1" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2D Test chemical in deep well plate 2" <> $SessionUUID],
					Object[Container, Plate, "Test plate with two samples for ExperimentNMR2D tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection:: *)
(*ValidExperimentNMR2DQ*)

DefineTests[ValidExperimentNMR2DQ,
	{
		Example[{Basic, "Obtain an NMR spectrum of a given sample:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID]],
			True
		],
		Example[{Basic, "Obtain an NMR spectrum of a given sample with no subtype:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ Test chemical with no subtype" <> $SessionUUID]],
			True
		],
		Example[{Basic, "Obtain NMR spectra of multiple samples:"},
			ValidExperimentNMR2DQ[{Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (100 uL)" <> $SessionUUID]}],
			True
		],
		Example[{Basic, "Obtain an NMR spectrum of the sample inside a given container:"},
			ValidExperimentNMR2DQ[Object[Container, Vessel, "Test container 7 for ValidExperimentNMR2DQ tests" <> $SessionUUID]],
			True
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			ValidExperimentNMR2DQ[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				}
			],
			True
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentNMR2DQ[Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Discarded)" <> $SessionUUID], Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentNMR2DQ[Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Discarded)" <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ValidExperimentNMR2DQ[Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Discarded)" <> $SessionUUID]],
			False
		],
		Example[{Messages, "DeprecatedModels", "If the provided sample has a deprecated model, an error will be thrown:"},
			ValidExperimentNMR2DQ[Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]],
			False
		],
		Example[{Messages, "NMRTooManySamples", "If too many samples are used for one protocol, an error will be thrown:"},
			ValidExperimentNMR2DQ[ConstantArray[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], 97], DeuteratedSolvent -> Model[Sample, "Chloroform-d"]],
			False
		],
		Example[{Messages, "UnsupportedNMRTube", "If the specified NMRTube are not currently supported by the ECL, an error will be thrown:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "2mL Tube"]],
			False
		],
		Example[{Messages, "NonStandardSolvent", "If the specified DeuteratedSolvent is not a standard deuterated solvent, throw a warning but continue:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Milli-Q water"]],
			True
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> 50*Microliter],
			False
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples after aliquoting:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 10*Milligram],
			False
		],
		Example[{Messages, "SampleAmountTooHigh", "If the SampleAmount is above the amount available after sample prep, throw an error:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 110*Microliter],
			False
		],
		Example[{Messages, "ExperimentTypeNucleusIncompatible", "If ExperimentType and IndirectNucleus are not compatible, throw an error:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], ExperimentType -> COSY, IndirectNucleus -> "13C"],
			False
		],
		Example[{Messages, "DirectAcquisitionParametersIncompatible", "If DirectAcquisitionTime, DirectNumberOfPoints, and DirectSpectralDomain are all specified, they must follow the formula DirectAcquisitionTime == (DirectNumberOfPoints * 1e06) / ((Max[DirectSpectralDomain] - Min[DirectSpectralDomain]) * <frequency of NMR for relevant nucleus>):"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectNumberOfPoints -> 2048, DirectAcquisitionTime -> 0.2*Second, DirectSpectralDomain -> Span[0 PPM, 8 PPM]],
			False
		],
		Example[{Messages, "TOCSYMixTimeIncompatible", "If ExperimentType is not a TOCSY variant, TOCSYMixTime must be Null:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], TOCSYMixTime -> 80*Millisecond, ExperimentType -> ROESY],
			False
		],
		Example[{Messages, "PulseSequenceSpecified", "If a pulse sequence is directly specified, throw a warning:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseSequence -> Object[EmeraldCloudFile, "Test 90 Degree Pulse Sequence"]],
			True
		],
		Example[{Messages, "PulseSequenceMustBeTextFile", "If the pulse sequence is specified, the file must be a text file:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseSequence -> Object[EmeraldCloudFile, "Pulse Sequence Programming Tutorial"]],
			False
		],
		Example[{Messages, "ZeroSpectralDomain", "If the length of DirectSpectralDomain is 0 PPM, an error is thrown:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], DirectSpectralDomain -> Span[5 PPM, 5 PPM]],
			False
		],
		Example[{Messages, "ZeroSpectralDomain", "If the length of IndirectSpectralDomain is 0 PPM, an error is thrown:"},
			ValidExperimentNMR2DQ[Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID], IndirectSpectralDomain -> Span[5 PPM, 5 PPM]],
			False
		]
	},
	Stubs :> {
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
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
					Object[Container, Bench, "Test bench for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, NMR2D, "NMR2D Protocol 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Sample, "ValidExperimentNMR2DQ Test chemical with no subtype" <> $SessionUUID],
					Download[Object[Protocol, NMR2D, "NMR2D Protocol 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, sample8, container8, sample9, container9},

				testBench = Upload[<|Type -> Object[Container, Bench], Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ValidExperimentNMR2DQ tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
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
						"Test container 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 2 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test crystallization plate 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 3 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 4 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 5 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 6 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 7 for ValidExperimentNMR2DQ tests" <> $SessionUUID,
						"Test container 8 for ValidExperimentNMR2DQ tests" <> $SessionUUID
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
						Model[Sample, "Caffeine"],
						Model[Sample, "Toluene, Anhydrous"]
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
						100*Milligram,
						100*Microliter
					},
					Name -> {
						"ValidExperimentNMR2DQ New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID,
						"ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID,
						"ValidExperimentNMR2DQ Test chemical with no subtype" <> $SessionUUID
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container, container2, sample, sample2, sample, container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7, sample8, container8, sample9, container9}], ObjectP[]]];
				Upload[Cases[Flatten[{
					<|Object -> sample2, Model -> Null|>,
					<|Object -> sample5, Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]], Now}}|>,
					<|Object -> sample6, Status -> Discarded|>,
					<|Object -> sample9, Model -> Null|>
				}], PacketP[]]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Sample, "ValidExperimentNMR2DQ Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ValidExperimentNMR2DQ New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ValidExperimentNMR2DQ New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, NMR2D, "NMR2D Protocol 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID],
					Download[Object[Protocol, NMR2D, "NMR2D Protocol 1 for ValidExperimentNMR2DQ tests" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection:: *)
(*ExperimentNMR2DOptions*)

DefineTests[ExperimentNMR2DOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentNMR2DOptions[Object[Sample, "ExperimentNMR2DOptions New Test Chemical 1 (100 mg)" <> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples:"},
			ExperimentNMR2DOptions[{Object[Sample, "ExperimentNMR2DOptions New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (100 uL)" <> $SessionUUID]}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options rather than a table:"},
			ExperimentNMR2DOptions[{Object[Sample, "ExperimentNMR2DOptions New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (100 uL)" <> $SessionUUID]}, OutputFormat -> List],
			{__Rule}
		]
	},
	Stubs :> {
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
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
					Object[Container, Bench, "Test bench for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2DOptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, NMR2D, "NMR2D Protocol 1 for ExperimentNMR2DOptions Tests" <> $SessionUUID],
					Download[Object[Protocol, NMR2D, "NMR2D Protocol 1 for ExperimentNMR2DOptions Tests" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, fakeProtocol1, sample8, container8, fakeProtSubObjs, completeTheFakeProtocol},

				testBench = Upload[<|Type -> Object[Container, Bench], Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentNMR2DOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
				{
					container,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "id:pZx9jo8x59oP"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "15mL Tube"]
					},
					{
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
						"Test container 1 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test container 2 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test crystallization plate 1 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test container 3 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test container 4 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test container 5 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test container 6 for ExperimentNMR2DOptions tests" <> $SessionUUID,
						"Test container 7 for ExperimentNMR2DOptions tests" <> $SessionUUID
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
					sample8
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
						Model[Sample, "Caffeine"]
					},
					{
						{"A1", container},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8}
					},
					InitialAmount -> {
						100*Microliter,
						80*Microliter,
						0.1*Milliliter,
						25*Milliliter,
						1.5*Milliliter,
						100*Microliter,
						100*Microliter,
						100*Milligram
					},
					Name -> {
						"ExperimentNMR2DOptions New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID,
						"ExperimentNMR2DOptions New Test Chemical 1 (100 mg)" <> $SessionUUID
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container, container2, sample, sample2, sample, container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7, sample8, container8}], ObjectP[]]];
				Upload[Cases[Flatten[{
					<|Object -> sample5, Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]], Now}}|>,
					<|Object -> sample6, Status -> Discarded|>
				}], PacketP[]]];

				fakeProtocol1 = ExperimentNMR2D[Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "NMR2D Protocol 1 for ExperimentNMR2DOptions Tests" <> $SessionUUID, Confirm -> True, ExperimentType -> ROESY, SampleTemperature -> -10*Celsius];
				completeTheFakeProtocol = UploadProtocolStatus[fakeProtocol1, Completed, FastTrack -> True];
				fakeProtSubObjs = Flatten[Download[fakeProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Cases[Flatten[{fakeProtocol1, fakeProtSubObjs}], ObjectP[]]]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR2DOptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR2DOptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR2DOptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Protocol, NMR2D, "NMR2D Protocol 1 for ExperimentNMR2DOptions Tests" <> $SessionUUID],
					Download[Object[Protocol, NMR2D, "NMR2D Protocol 1 for ExperimentNMR2DOptions Tests" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection:: *)
(*ExperimentNMR2DPreview*)

DefineTests[ExperimentNMR2DPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentNMR2DPreview[Object[Sample, "ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"]],
			Null
		],
		Example[{Basic, "Return  Null for multiple samples:"},
			ExperimentNMR2DPreview[{Object[Sample, "ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"], Object[Sample,"ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"]}],
			Null
		],
		Example[{Basic, "Return  Null for multiple samples:"},
			ExperimentNMR2DPreview[{Object[Sample, "ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"], Object[Sample,"ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"]}],
			Null
		]
	},
	Stubs:>{
		$EmailEnabled=False
	},
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
					Object[Container, Bench, "Test bench for ExperimentNMR2DPreview tests"],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR2DPreview tests"],
					Object[Sample,"ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, sample},

				testBench = Upload[<|Type -> Object[Container, Bench], Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentNMR2DPreview tests", DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
				{
					container
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Test container 1 for ExperimentNMR2DPreview tests"
					}
				];
				{
					sample
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container}
					},
					InitialAmount -> {
						100*Microliter
					},
					Name -> {
						"ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"
					}
				];
				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container, sample}], ObjectP[]]];
				Upload[Cases[Flatten[{<|Object -> sample, Model->Null|>}], ObjectP[]]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentNMR2DPreview tests"],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR2DPreview tests"],
					Object[Sample,"ExperimentNMR2DPreview New Test Chemical 1 (100 uL)"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
