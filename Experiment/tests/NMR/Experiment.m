(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentNMR*)
 

DefineTests[ExperimentNMR,
	{
		Example[{Basic, "Obtain an NMR spectrum of a given sample:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Basic, "Obtain an NMR spectrum of the sample inside a given container:"},
			ExperimentNMR[Object[Container, Vessel, "Test container 7 for ExperimentNMR tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Basic, "Obtain an NMR spectrum of the sample inside a given position of a given container:"},
			ExperimentNMR[{"A1", Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Basic, "Obtain NMR spectra of multiple samples:"},
			ExperimentNMR[{Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Additional, "Obtain an NMR spectrum of a given sample:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR Test chemical with no subtype" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Additional,"Obtain NMR spectra of a given sample with severed Model link:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (80 uL)" <> $SessionUUID]],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			ExperimentNMR[{Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID]}, Template -> Object[Protocol, NMR, "NMR Protocol 1" <> $SessionUUID, UnresolvedOptions]],
			ObjectP[Object[Protocol, NMR]]
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			Download[
				ExperimentNMR[{Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID]}, Template -> Object[Protocol, NMR, "NMR Protocol 1" <> $SessionUUID, UnresolvedOptions]],
				{Nuclei, SampleTemperatures}

			],
			{
				{"13C", "13C"},
				{-10*Celsius, -10*Celsius}
			},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Nucleus, "Use the Nucleus option to set which nucleus will be read in the experiment:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Nucleus -> "13C", Output -> Options];
			Lookup[options, Nucleus],
			"13C",
			Variables :> {options}
		],
		Example[{Options, DeuteratedSolvent, "Use the DeuteratedSolvent option to set which deuterated solvent in which to dissolve the sample:"},
			Download[ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Chloroform], DeuteratedSolvents],
			{ObjectP[Model[Sample, "Chloroform-d"]]},
			Variables :> {options}
		],
		Example[{Options, SolventVolume, "Use the DeuteratedSolvent option to set how much of the specified solvent is used to dissolve the sample:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Chloroform-d"], SolventVolume -> 800*Microliter, Output -> Options];
			Lookup[options, SolventVolume],
			800*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SolventVolume, "If SolventVolume is directly set to 0 Milliliter, then no solvent will be used and the sample will be loaded into NMR tubes directly:"},
			protocol = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 8 (1.5 mL)" <> $SessionUUID], DeuteratedSolvent -> DMSO, SolventVolume -> 0 Milliliter];
			Download[protocol, SolventVolumes],
			{0 Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, SampleAmount, "Use the SampleAmount option to set how much of the sample is dissolved in the deuterated solvent:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> 6*Milligram, DeuteratedSolvent -> Model[Sample, "Chloroform-d"], Output -> Options];
			Lookup[options, SampleAmount],
			6*Milligram,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SampleTemperature, "Use the SampleTemperature option to set the temperature at which the sample will be held prior to and during data collection:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, SampleTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "Use the NumberOfScans option to set the number of pulse and read cycles that will be averaged together for a given sample:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfScans -> 64, Output -> Options];
			Lookup[options, NumberOfScans],
			64,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "If NumberOfScans is left Automatic, resolves based on the provided Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, NumberOfScans],
			{16, 1024, 16, 32},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfDummyScans, "Use the NumberOfDummyScans option to set the number of scans performed before the receiver is turned on and data is collected for each sample.:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfDummyScans -> 64, Output -> Options];
			Lookup[options, NumberOfDummyScans],
			64,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfDummyScans, "If NumberOfDummyScans is left Automatic, resolves based on the provided Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, NumberOfDummyScans],
			{2, 4, 4, 4},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AcquisitionTime, "Use the AcquisitionTime option to set the length of time during which the NMR signal is sampled and digitized per scan:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], AcquisitionTime -> 7*Second, Output -> Options];
			Lookup[options, AcquisitionTime],
			7*Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AcquisitionTime, "If AcquisitionTime is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, AcquisitionTime],
			{4*Second, 1.1*Second, 0.6*Second, 0.4*Second},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RelaxationDelay, "Use the RelaxationDelay option to set the length of time before the pulse and acquisition steps happen during a given scan:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], RelaxationDelay -> 7*Second, Output -> Options];
			Lookup[options, RelaxationDelay],
			7*Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RelaxationDelay, "If RelaxationDelay is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, RelaxationDelay],
			{1 Second, 2 Second, 1 Second, 2 Second},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, PulseWidth, "Use the PulseWidth option to set the length of time during which the radio frequency pulse is turned on and the sample is irradiated per scan:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseWidth -> 8*Microsecond, Output -> Options];
			Lookup[options, PulseWidth],
			8*Microsecond,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, PulseWidth, "If PulseWidth is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, PulseWidth],
			{10*Microsecond, 10*Microsecond, 15*Microsecond, 14*Microsecond},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FlipAngle, "Use the FlipAngle option to set the angle of rotation of the first radio frequency pulse per scan:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], FlipAngle -> 90*AngularDegree, Output -> Options];
			Lookup[options, FlipAngle],
			90*AngularDegree,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FlipAngle, "If FlipAngle is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, FlipAngle],
			{30*AngularDegree, 30*AngularDegree, 90*AngularDegree, 30*AngularDegree},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FlipAngle, "If FlipAngle is left Automatic for Nucleus -> 1H, resolve based on the WaterSuppression method:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "1H", "1H", "1H"},
				WaterSuppression -> {None, Presaturation, WATERGATE, ExcitationSculpting},
				Output -> Options
			];
			Lookup[options, FlipAngle],
			{30*AngularDegree, 90*AngularDegree, 90*AngularDegree, 90*AngularDegree},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SpectralDomain, "Use the SpectralDomain option to set the range of the observed frequencies for a given spectrum:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SpectralDomain -> Span[10*PPM, 30*PPM], Output -> Options];
			Lookup[options, SpectralDomain],
			Span[10*PPM, 30*PPM],
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SpectralDomain, "If SpectralDomain is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				Output -> Options
			];
			Lookup[options, SpectralDomain],
			{Span[-4 PPM, 16 PPM], Span[-20 PPM, 220 PPM], Span[-220 PPM, 20 PPM], Span[-250 PPM, 150 PPM]},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, WaterSuppression, "Use the WaterSuppression option to specify the method for removing the water peak in the spectrum:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], WaterSuppression -> Presaturation, DeuteratedSolvent -> Water, Output -> Options];
			Lookup[options, WaterSuppression],
			Presaturation,
			Variables :> {options}
		],
		Example[{Options, TimeCourse, "Use the TimeCourse option to indicate if multiple spectra should be run over time:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TimeCourse -> True, Output -> Options];
			Lookup[options, TimeCourse],
			True,
			Variables :> {options}
		],
		Example[{Options, TimeInterval, "Specify the duration between collection of NMR spectra over time with the TimeInterval option:"},
			protocol = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TimeInterval -> 10 Minute];
			Download[protocol, TimeIntervals],
			{10 Minute},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, NumberOfTimeIntervals, "Specify the number of time intervals at the end of which another NMR specturm is collected:"},
			protocol = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfTimeIntervals -> 5];
			Download[protocol, NumberOfTimeIntervals],
			{5},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, TotalTimeCourse, "Specify the total length of time across which to collect the desired number of NMR spectra:"},
			protocol = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TotalTimeCourse -> 1 Hour, NumberOfTimeIntervals -> 5];
			Download[protocol, TotalTimeCourses],
			{1 Hour},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, TotalTimeCourse, "Use the TotalTimeCourse to determine the DataAcquisitionTime:"},
			protocol = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TotalTimeCourse -> 1 Hour, NumberOfTimeIntervals -> 5];
			Download[protocol, DataCollectionTime],
			65 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to repeat an NMR sample preparation and reading of a provided sample.  This is functionally equivalent to listing the same sample n times in the input:"},
			Download[
				ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfReplicates -> 2],
				SamplesIn
			],
			{ObjectP[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]]}
		],
		Test["If using NumberOfReplicates (or the same samples in multiple experiments), pick the appropriate number of NMR tubes/spinners:",
			protocol = ExperimentNMR[
				{Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Object[Sample, "ExperimentNMR Test chemical in sealed tube" <> $SessionUUID]},
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
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"], Output -> Options];
			Lookup[options, NMRTube],
			ObjectP[Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"]],
			Variables :> {options}
		],
		Example[{Options, Instrument, "Use the Instrument option to set the instrument model or object that will be used during this experiment:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Instrument -> Object[Instrument, NMR, "Magneto"], Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, NMR, "Magneto"]],
			Variables :> {options}
		],
		Example[{Options, NMRTube, "If a sample is already in an NMR tube, the NMRTubes field is populated with that same container directly:"},
			protocol = ExperimentNMR[{Object[Sample, "ExperimentNMR Test chemical in sealed tube" <> $SessionUUID], Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID]}, NMRTube -> {Model[Container, Vessel, "Sealed NMR Tube"], Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"]}];
			Download[protocol, {NMRTubes, NMRSpinners}],
			{
				{ObjectP[Object[Container, Vessel, "Test container 8 for ExperimentNMR tests" <> $SessionUUID]], ObjectP[Object[Container, Vessel, "Test container 9 for ExperimentNMR tests" <> $SessionUUID]]},
				{ObjectP[Model[Container, NMRSpinner]], Null}
			},
			Variables :> {protocol}
		],
		Example[{Options, UseExternalStandard, "Specify to use a sample with an external standard:"},
			protocol = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID]
				},
				UseExternalStandard -> True];
			Download[protocol, {UseExternalStandards,SealedCoaxialInserts,SealedCoaxialInsertContainers}],
			{
				{True,True},
				{
					LinkP[Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]],
					LinkP[Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]]
				},
				{
					LinkP[Model[Container, Bag, "2 x 3 Inch Plastic Bag For NMR Sealed Inserts"]],
					LinkP[Model[Container, Bag, "2 x 3 Inch Plastic Bag For NMR Sealed Inserts"]]
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, UseExternalStandard, "Can specify an external standard while using non-deuterated solvent:"},
			protocol = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				UseExternalStandard -> True,
				DeuteratedSolvent -> Model[Sample, "Milli-Q water"]
			];
			Download[protocol, {SolventVolumes,UseExternalStandards,SealedCoaxialInserts,SealedCoaxialInsertContainers}],
			{
				{Quantity[0.4, "Milliliters"]},
				{True},
				{LinkP[Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]]},
				{LinkP[Model[Container, Bag, "2 x 3 Inch Plastic Bag For NMR Sealed Inserts"]]}
			},
			Variables :> {protocol},
			Messages:>{Warning::NonStandardSolvent}
		],
		Example[{Options, SealedCoaxialInsert, "Specify which sealed coaxial insert should be used as the external standards for a NMR experiment:"},
			protocol = ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID]
				},
				SealedCoaxialInsert -> {Null,Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]}];
			Download[protocol, {UseExternalStandards,SealedCoaxialInserts}],
			{
				{False,True},
				{
					Null,
					LinkP[Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]]
				}
			},
			Variables :> {protocol}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "If multiple specified samples are in the same container but have different SamplesInStorageCondition values set, throw an error:"},
			ExperimentNMR[{Object[Sample, "ExperimentNMR Test chemical in deep well plate 1" <> $SessionUUID], Object[Sample, "ExperimentNMR Test chemical in deep well plate 2" <> $SessionUUID]}, SamplesInStorageCondition -> {Refrigerator, Freezer}],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables :> {options}
		],

		Example[{Options, Confirm, "Set Confirm -> True to immediately confirm protocol upon its creation:"},
			Download[ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Confirm -> True], Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options, Name, "Set name of the new protocol:"},
			Download[ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "NMR protocol 24601"], Name],
			"NMR protocol 24601"
		],

		(* --- Sample prep option tests --- *)
		Example[{Options, PreparatoryPrimitives, "Use the PreparatoryPrimitives option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentNMR[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryPrimitives -> {
					Define[Name -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					Define[Name -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				}
			];
			Download[protocol, PreparatoryPrimitives],
			{SampleManipulationP..},
			Variables :> {protocol}

		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentNMR[
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
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID], FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Acetone"], AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Acetone"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],

		(* --- Messages tests --- *)
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentNMR[Link[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, NMR]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (Discarded)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "DeprecatedModels", "If the provided sample has a deprecated model, an error will be thrown:"},
			ExperimentNMR[Object[Sample,"ExperimentNMR New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages, "NMRTooManySamples", "If too many samples are used for one protocol, an error will be thrown:"},
			ExperimentNMR[ConstantArray[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], 97], DeuteratedSolvent -> Model[Sample, "Chloroform-d"]],
			$Failed,
			Messages :> {
				Error::NMRTooManySamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "UnsupportedNMRTube", "If the specified NMRTube are not currently supported by the ECL, an error will be thrown:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "2mL Tube"]],
			$Failed,
			Messages :> {
				Error::UnsupportedNMRTube,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NonStandardSolvent", "If the specified DeuteratedSolvent is not a standard deuterated solvent, throw a warning but continue:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol, NMR]],
			Messages :> {Warning::NonStandardSolvent}
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> 50*Microliter],
			$Failed,
			Messages :> {
				Error::SampleAmountStateConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples after aliquoting:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 10*Milligram],
			$Failed,
			Messages :> {
				Error::SampleAmountStateConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountTooHigh", "If the SampleAmount is above the amount available after sample prep, throw an error:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 110*Microliter],
			$Failed,
			Messages :> {
				Error::SampleAmountTooHigh,
				Error::InvalidOption,
				Error::NotEnoughRequiredAmount,
				Error::InvalidInput
			}
		],
		Example[{Messages, "WaterSuppressionIncompatible", "If WaterSuppression is set, Nucleus must be set to 1H:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], WaterSuppression -> WATERGATE, DeuteratedSolvent -> Water, Nucleus -> "13C"],
			$Failed,
			Messages :> {
				Error::WaterSuppressionIncompatible,
				Error::No30DegFlipAngleForWaterSuppression,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NMRTubesIncompatible", "If NMRTube is set to the Sealed NMR Tube, the sample must already be in that container model:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "Sealed NMR Tube"]],
			$Failed,
			Messages :> {
				Error::NMRTubesIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is already in an NMR tube, SolventVolume must be Null:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR Test chemical in sealed tube" <> $SessionUUID], SolventVolume -> 600*Microliter, NMRTube -> Model[Container, Vessel, "Sealed NMR Tube"]],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is already in an NMR tube, SampleAmount must be Null:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR Test chemical in sealed tube" <> $SessionUUID], SampleAmount -> 5*Microliter, NMRTube -> Model[Container, Vessel, "Sealed NMR Tube"]],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is not already in an NMR tube, SampleAmount and SolventVolume must not be Null:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> Null],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleAmountNull", "If a sample is not already in an NMR tube, SampleAmount and SolventVolume must not be Null:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SolventVolume -> Null],
			$Failed,
			Messages :> {
				Error::SampleAmountNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ZeroSpectralDomain", "SpectralDomain must not be of length zero:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], SpectralDomain -> Span[5 PPM, 5 PPM]],
			$Failed,
			Messages :> {
				Error::ZeroSpectralDomain,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KineticOptionsRequiredTogether", "If TimeCourse -> False, timing options may not be set to anything but Null:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TimeCourse -> False, TimeInterval -> 4 Minute],
			$Failed,
			Messages :> {
				Error::KineticOptionsRequiredTogether,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KineticOptionsIncompatibleNucleus", "If TimeCourse -> True, Nucleus must be 1H:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TimeCourse -> True, Nucleus -> "13C"],
			$Failed,
			Messages :> {
				Error::KineticOptionsIncompatibleNucleus,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KineticOptionMismatch", "TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse cannot be contradictory:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TimeInterval -> 5 Minute, NumberOfTimeIntervals -> 5, TotalTimeCourse -> 1 Hour],
			$Failed,
			Messages :> {
				Error::KineticOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TimeIntervalTooSmall", "TimeInterval must not be less than NumberOfScans * (AcquisitionTime + RelaxationDelay):"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], TimeInterval -> 1 Minute, NumberOfScans -> 16, AcquisitionTime -> 2 Second, RelaxationDelay -> 2 Second],
			$Failed,
			Messages :> {
				Error::TimeIntervalTooSmall,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KineticOptionsWaterSuppression", "TimeCourse cannot be True when WaterSuppression is also specified:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], WaterSuppression -> WATERGATE, TimeCourse -> True],
			$Failed,
			Messages :> {
				Error::KineticOptionsWaterSuppression,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingExternalStandardOptions", "If UseExternalStandard is False, SealedCoaxialInsert cannot be specified:"},
			ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID]
				},
				SealedCoaxialInsert -> {Null,Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]},
				UseExternalStandard -> False
			],
			$Failed,
			Messages :> {
				Error::ConflictingExternalStandardOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingExternalStandardOptions", "If UseExternalStandard is True, SealedCoaxialInsert must be specified:"},
			ExperimentNMR[
				{
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID]
				},
				SealedCoaxialInsert -> {Null,Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]},
				UseExternalStandard -> True
			],
			$Failed,
			Messages :> {
				Error::ConflictingExternalStandardOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages, "KineticOptionsWaterSuppression", "Sealed sample cannot use external standards:"},
			ExperimentNMR[
				{
					Object[Sample,"ExperimentNMR Test chemical in sealed tube"<>$SessionUUID],
					Object[Sample,"ExperimentNMR Test chemical in normal NMR tube"<>$SessionUUID]
				},
				NMRTube->{Model[Container,Vessel,"Sealed NMR Tube"],Model[Container,Vessel,"NMR Tube, 5 mm x 103.5 mm"]},
				UseExternalStandard->True
			],
			$Failed,
			Messages :> {
				Error::SealedNMRTubeCannotUseExternalStandards,
				Error::InvalidOption
			}
		],
		Example[{Messages, "No30DegFlipAngleFor19F", "When Nucleus -> 19F, FlipAngle cannot be set to 30 AngularDegree:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], FlipAngle -> 30*AngularDegree, Nucleus -> "19F"],
			$Failed,
			Messages :> {
				Error::No30DegFlipAngleFor19F,
				Error::InvalidOption
			}
		],
		Example[{Messages, "No30DegFlipAngleForWaterSuppression", "When WaterSuppression -> WATERGATE|ExcitationSculpting, FlipAngle cannot be set to 30 AngularDegree:"},
			ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID], FlipAngle -> 30*AngularDegree, Nucleus -> "1H", WaterSuppression -> ExcitationSculpting],
			$Failed,
			Messages :> {
				Error::No30DegFlipAngleForWaterSuppression,
				Error::InvalidOption
			}
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	(* un comment this out when Variables works the way we would expect it to*)
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
					Object[Container, Bench, "Test bench for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 9 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 10 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 11 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test sealed external standard vessel for ExperimentNMR tests" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in sealed tube" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in deep well plate 1" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in deep well plate 2" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Plate, "Test plate with two samples for ExperimentNMR tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR Exerternal Standards Sealed" <> $SessionUUID],
					Object[Protocol, NMR, "NMR Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, NMR, "NMR Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, testProtocol1, sample8, container8, testProtSubObjs,
					completeTheTestProtocol, container9, sample9, container10, sample10, container11, sample11, container12,
					sample12, sample13, container13, sample14, container14, sample15},

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentNMR tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
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
					container13,
					container14
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
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "3mm NMR Sealed Coaxial Insert with 3-(Trimethylsilyl)propionic-2,2,3,3-d4 in Deuterium Oxide"]
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
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name -> {
						"Test container 1 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 2 for ExperimentNMR tests" <> $SessionUUID,
						"Test crystallization plate 1 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 3 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 4 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 5 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 6 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 7 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 8 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 9 for ExperimentNMR tests" <> $SessionUUID,
						"Test container 10 for ExperimentNMR tests" <> $SessionUUID,
						"Test plate with two samples for ExperimentNMR tests" <> $SessionUUID,
						"Test container 11 for ExperimentNMR tests" <> $SessionUUID,
						"Test sealed external standard vessel for ExperimentNMR tests" <> $SessionUUID
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
					sample14,
					sample15
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
						},
						Model[Sample, "0.1% w/w Solution Of (Trimethylsilyl)propionic-2,2,3,3-d4 Acid Sodium Salt In Deuterium Oxide"]
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
						{"A1", container13},
						{"A1", container14}
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
						1.5*Milliliter,
						0.5*Milliliter
					},
					Name -> {
						"ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 1 (Deprecated Model)" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID,
						"ExperimentNMR Test chemical in sealed tube" <> $SessionUUID,
						"ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID,
						"ExperimentNMR Test chemical with no subtype" <> $SessionUUID,
						"ExperimentNMR Test chemical in deep well plate 1" <> $SessionUUID,
						"ExperimentNMR Test chemical in deep well plate 2" <> $SessionUUID,
						"ExperimentNMR New Test Chemical 8 (1.5 mL)" <> $SessionUUID,
						"ExperimentNMR Exerternal Standards Sealed" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, Site -> Link[$Site], AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[
					{
						container, container2, container3, container4, container5, container6, container7, container8,
						container9, container10, container11, container12, container13, container14, sample, sample2,
						sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
						sample13, sample14, sample15
					}
				], ObjectP[]]];
				Upload[Cases[Flatten[{
					<|Object -> sample2, Model -> Null|>,
					<|Object -> sample5, Concentration -> 5*Millimolar|>,
					<|Object -> sample6, Status -> Discarded, Model -> Null|>,
					<|Object -> sample11, Model -> Null|>
				}], PacketP[]]];
				Upload[<|Object -> sample5, Model -> Null, Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}|>];

				testProtocol1 = ExperimentNMR[Object[Sample, "ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID], Name -> "NMR Protocol 1" <> $SessionUUID, Confirm -> True, Nucleus -> "13C", SampleTemperature -> -10*Celsius];
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
					Object[Container, Bench, "Test bench for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 9 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 10 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 11 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Vessel, "Test sealed external standard vessel for ExperimentNMR tests" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in sealed tube" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in normal NMR tube" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in deep well plate 1" <> $SessionUUID],
					Object[Sample, "ExperimentNMR Test chemical in deep well plate 2" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMR tests" <> $SessionUUID],
					Object[Container, Plate, "Test plate with two samples for ExperimentNMR tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 1 (Deprecated Model)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR New Test Chemical 8 (1.5 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMR Exerternal Standards Sealed" <> $SessionUUID],
					Object[Protocol, NMR, "NMR Protocol 1" <> $SessionUUID],
					Download[Object[Protocol, NMR, "NMR Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentNMRQ*)

DefineTests[ValidExperimentNMRQ,
	{
		Example[{Basic, "Obtain an NMR spectrum of a given sample:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID]],
			True
		],
		Example[{Basic, "Obtain an NMR spectrum of a given sample with no subtype:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ Test chemical with no subtype"<> $SessionUUID]],
			True
		],
		Example[{Basic, "Obtain NMR spectra of multiple samples:"},
			ValidExperimentNMRQ[{Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (100 uL)"<> $SessionUUID]}],
			True
		],
		Example[{Basic, "Obtain an NMR spectrum of the sample inside a given container:"},
			ValidExperimentNMRQ[Object[Container, Vessel, "Test container 7 for ValidExperimentNMRQ tests"<> $SessionUUID]],
			True
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			ValidExperimentNMRQ[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				}
			],
			True,
			Variables :> {protocol}

		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentNMRQ[Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Discarded)"<> $SessionUUID], Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentNMRQ[Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Discarded)"<> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ValidExperimentNMRQ[Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Discarded)"<> $SessionUUID]],
			False
		],
		Example[{Messages, "DeprecatedModels", "If the provided sample has a deprecated model, an error will be thrown:"},
			ValidExperimentNMRQ[Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Deprecated Model)"<> $SessionUUID]],
			False
		],
		Example[{Messages, "NMRTooManySamples", "If too many samples are used for one protocol, an error will be thrown:"},
			ValidExperimentNMRQ[ConstantArray[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], 97], DeuteratedSolvent -> Model[Sample, "Chloroform-d"]],
			False
		],
		Example[{Messages, "UnsupportedNMRTube", "If the specified NMRTube are not currently supported by the ECL, an error will be thrown:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], NMRTube -> Model[Container, Vessel, "2mL Tube"]],
			False
		],
		Example[{Messages, "NonStandardSolvent", "If the specified DeuteratedSolvent is not a standard deuterated solvent, throw a warning but continue:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Milli-Q water"], Output -> Options],
			True
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], SampleAmount -> 50*Microliter],
			False
		],
		Example[{Messages, "SampleAmountStateConflict", "If SampleAmount is specified, its units must match the units of the input samples after aliquoting:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 10*Milligram],
			False
		],
		Example[{Messages, "SampleAmountTooHigh", "If the SampleAmount is above the amount available after sample prep, throw an error:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], Aliquot -> True, AliquotAmount -> 10*Milligram, AssayVolume -> 100*Microliter, SampleAmount -> 110*Microliter],
			False
		],
		Example[{Messages, "KineticOptionsRequiredTogether", "If TimeCourse -> False, timing options may not be set to anything but Null:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], TimeCourse -> False, TimeInterval -> 4 Minute],
			False
		],
		Example[{Messages, "KineticOptionsIncompatibleNucleus", "If TimeCourse -> True, Nucleus must be 1H:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], TimeCourse -> True, Nucleus -> "13C"],
			False
		],
		Example[{Messages, "KineticOptionMismatch", "TimeInterval, NumberOfTimeIntervals, and TotalTimeCourse cannot be contradictory:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], TimeInterval -> 5 Minute, NumberOfTimeIntervals -> 5, TotalTimeCourse -> 1 Hour],
			False
		],
		Example[{Messages, "TimeIntervalTooSmall", "TimeInterval must not be less than NumberOfScans * (AcquisitionTime + RelaxationDelay):"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], TimeInterval -> 1 Minute, NumberOfScans -> 16, AcquisitionTime -> 2 Second, RelaxationDelay -> 2 Second],
			False
		],
		Example[{Messages, "KineticOptionsWaterSuppression", "TimeCourse cannot be True when WaterSuppression is also specified:"},
			ValidExperimentNMRQ[Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID], WaterSuppression -> WATERGATE, TimeCourse -> True],
			False
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
					Object[Container, Bench, "Test bench for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (100 uL)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (80 uL)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (25 mL)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (1.5 mL, 5 mM)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical in crystallization plate (0.1 mL)"<> $SessionUUID],
					Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Discarded)"<> $SessionUUID],
					Object[Sample, "ValidExperimentNMRQ Test chemical with no subtype"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Deprecated Model)"<> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, container2, container3, sample, sample2, sample3, container4, sample4, sample5,
					container5, sample6, container6, container7, sample7, sample9, container9, sample8, container8},

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ValidExperimentNMRQ tests"<> $SessionUUID, DeveloperObject -> True, Site -> Link[$Site], StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
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
						"Test container 1 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 2 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test crystallization plate 1 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 3 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 4 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 5 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 6 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 7 for ValidExperimentNMRQ tests"<> $SessionUUID,
						"Test container 8 for ValidExperimentNMRQ tests"<> $SessionUUID
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
						"ValidExperimentNMRQ New Test Chemical 1 (100 uL)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical 1 (80 uL)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical in crystallization plate (0.1 mL)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical 1 (25 mL)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical 1 (1.5 mL, 5 mM)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical 1 (Discarded)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical 1 (Deprecated Model)"<> $SessionUUID,
						"ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID,
						"ValidExperimentNMRQ Test chemical with no subtype"<> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container, container2, sample, sample2, sample, container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7, sample8, container8, sample9, container9}], ObjectP[]]];
				Upload[Cases[Flatten[{
					<|Object -> sample, Model -> Null|>,
					<|Object -> sample2, Model -> Null|>,
					<|Object -> sample3, Model -> Null|>,
					<|Object -> sample4, Model -> Null|>,
					<|Object -> sample5, Concentration -> 5*Millimolar, Model -> Null|>,
					<|Object -> sample6, Status -> Discarded, Model -> Null|>,
					<|Object -> sample8, Model -> Null|>,
					<|Object -> sample9, Model -> Null|>
				}], PacketP[]]];
				Upload[<|Object -> sample5, Model -> Null, Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}|>];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Sample, "ValidExperimentNMRQ Test chemical with no subtype"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (100 uL)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (80 uL)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (25 mL)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (1.5 mL, 5 mM)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical in crystallization plate (0.1 mL)"<> $SessionUUID],
					Object[Sample, "ValidExperimentNMRQ New Test Chemical 1 (100 mg)"<> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ValidExperimentNMRQ tests"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Discarded)"<> $SessionUUID],
					Object[Sample,"ValidExperimentNMRQ New Test Chemical 1 (Deprecated Model)"<> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentNMROptions*)

DefineTests[ExperimentNMROptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for one sample without a subtype:"},
			ExperimentNMROptions[Object[Sample, "ExperimentNMROptions Test chemical with no subtype" <> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples:"},
			ExperimentNMROptions[{Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMROptions New Test Chemical 1 (100 uL)" <> $SessionUUID]}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options rather than a table:"},
			ExperimentNMROptions[{Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], Object[Sample,"ExperimentNMROptions New Test Chemical 1 (100 uL)" <> $SessionUUID]}, OutputFormat -> List],
			{__Rule}
		],
		Example[{Options, Nucleus, "Use the Nucleus option to set which nucleus will be read in the experiment:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], Nucleus -> "13C", OutputFormat -> List];
			Lookup[options, Nucleus],
			"13C",
			Variables :> {options}
		],
		Example[{Options, DeuteratedSolvent, "Use the DeuteratedSolvent option to set which deuterated solvent in which to dissolve the sample:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Chloroform, OutputFormat -> List];
			Lookup[options, DeuteratedSolvent],
			Chloroform,
			Variables :> {options}
		],
		Example[{Options, SolventVolume, "Use the DeuteratedSolvent option to set how much of the specified solvent is used to dissolve the sample:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], DeuteratedSolvent -> Model[Sample, "Chloroform-d"], SolventVolume -> 800*Microliter, OutputFormat -> List];
			Lookup[options, SolventVolume],
			800*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SampleAmount, "Use the SampleAmount option to set how much of the sample is dissolved in the deuterated solvent:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleAmount -> 6*Milligram, DeuteratedSolvent -> Model[Sample, "Chloroform-d"], OutputFormat -> List];
			Lookup[options, SampleAmount],
			6*Milligram,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SampleTemperature, "Use the SampleTemperature option to set the temperature at which the sample will be held prior to and during data collection:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], SampleTemperature -> 40*Celsius, OutputFormat -> List];
			Lookup[options, SampleTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "Use the NumberOfScans option to set the number of pulse and read cycles that will be averaged together for a given sample:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfScans -> 64, OutputFormat -> List];
			Lookup[options, NumberOfScans],
			64,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfScans, "If NumberOfScans is left Automatic, resolves based on the provided Nucleus:"},
			options = ExperimentNMROptions[
				{
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				OutputFormat -> List
			];
			Lookup[options, NumberOfScans],
			{16, 1024, 16, 32},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AcquisitionTime, "Use the AcquisitionTime option to set the length of time during which the NMR signal is sampled and digitized per scan:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], AcquisitionTime -> 7*Second, OutputFormat -> List];
			Lookup[options, AcquisitionTime],
			7*Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AcquisitionTime, "If AcquisitionTime is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMROptions[
				{
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				OutputFormat -> List
			];
			Lookup[options, AcquisitionTime],
			{4*Second, 1.1*Second, 0.6*Second, 0.4*Second},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RelaxationDelay, "Use the RelaxationDelay option to set the length of time before the pulse and acquisition steps happen during a given scan:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], RelaxationDelay -> 7*Second, OutputFormat -> List];
			Lookup[options, RelaxationDelay],
			7*Second,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, RelaxationDelay, "If RelaxationDelay is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMROptions[
				{
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				OutputFormat -> List
			];
			Lookup[options, RelaxationDelay],
			{1 Second, 2 Second, 1 Second, 2 Second},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, PulseWidth, "Use the PulseWidth option to set the length of time during which the radio frequency pulse is turned on and the sample is irradiated per scan:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], PulseWidth -> 8*Microsecond, OutputFormat -> List];
			Lookup[options, PulseWidth],
			8*Microsecond,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, PulseWidth, "If PulseWidth is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMROptions[
				{
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				OutputFormat -> List
			];
			Lookup[options, PulseWidth],
			{10*Microsecond, 10*Microsecond, 15*Microsecond, 14*Microsecond},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SpectralDomain, "Use the SpectralDomain option to set the range of the observed frequencies for a given spectrum:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], SpectralDomain -> Span[-5 PPM, 25 PPM], OutputFormat -> List];
			Lookup[options, SpectralDomain],
			Span[-5 PPM, 25 PPM],
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, SpectralDomain, "If SpectralDomain is left Automatic, resolve based on the specified Nucleus:"},
			options = ExperimentNMROptions[
				{
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID]
				},
				Nucleus -> {"1H", "13C", "19F", "31P"},
				OutputFormat -> List
			];
			Lookup[options, SpectralDomain],
			{Span[-4 PPM, 16 PPM], Span[-20 PPM, 220 PPM], Span[-220 PPM, 20 PPM], Span[-250 PPM, 150 PPM]},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NumberOfReplicates, "Use the NumberOfReplicates option to repeat an NMR sample preparation and reading of a provided sample.  This is functionally equivalent to listing the same sample n times in the input:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], NumberOfReplicates -> 2, OutputFormat -> List];
			Lookup[options, NumberOfReplicates],
			2,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, NMRTube, "Use the Tube option to set the model of NMR tube that will be used during this experiment:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], NMRTube -> Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"], OutputFormat -> List];
			Lookup[options, NMRTube],
			ObjectP[Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"]],
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, OutputFormat -> List];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "Use the SamplesOutStorageCondition option to set the StorageCondition to which the SamplesOut will be set at the end of the protocol:"},
			options = ExperimentNMROptions[Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID], SamplesOutStorageCondition -> Refrigerator, OutputFormat -> List];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentNMROptions[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				},
				OutputFormat -> List
			];
			Lookup[options, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
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
					Object[Container, Bench, "Test bench for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]
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

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentNMROptions tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
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
						"Test container 1 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 2 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test crystallization plate 1 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 3 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 4 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 5 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 6 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 7 for ExperimentNMROptions tests" <> $SessionUUID,
						"Test container 8 for ExperimentNMROptions tests" <> $SessionUUID
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
						"ExperimentNMROptions New Test Chemical 1 (100 uL)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical 1 (80 uL)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical 1 (25 mL)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID,
						"ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID,
						"ExperimentNMROptions Test chemical with no subtype" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container, container2, sample, sample2, (*sample,*) container3, sample3, container4, sample4, sample5, sample6, container5, container6, sample7, container7, sample8, container8, sample9, container9}], ObjectP[]]];
				Upload[Cases[Flatten[{
					<|Object -> sample, Model -> Null|>,
					<|Object -> sample2, Model -> Null|>,
					<|Object -> sample3, Model -> Null|>,
					<|Object -> sample4, Model -> Null|>,
					<|Object -> sample5, Concentration -> 5*Millimolar, Model -> Null|>,
					<|Object -> sample6, Status -> Discarded|>,
					<|Object -> sample8, Model -> Null|>,
					<|Object -> sample9, Model -> Null|>
				}], PacketP[]]];
				Upload[<|Object -> sample5, Model -> Null, Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}|>];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 8 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions Test chemical with no subtype" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (100 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (80 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (25 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (1.5 mL, 5 mM)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical in crystallization plate (0.1 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentNMROptions New Test Chemical 1 (100 mg)" <> $SessionUUID],
					Object[Container, Plate, "Test crystallization plate 1 for ExperimentNMROptions tests" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
					Object[Sample,"ExperimentNMROptions New Test Chemical 1 (Deprecated Model)" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentNMRPreview*)

DefineTests[ExperimentNMRPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentNMRPreview[Object[Sample, "ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for multiple samples:"},
			ExperimentNMRPreview[{Object[Sample, "ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID], Object[Sample,"ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID]}],
			Null
		],
		Example[{Basic, "Return Null for multiple samples:"},
			ExperimentNMRPreview[{Object[Sample, "ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID], Object[Sample,"ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID]}],
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
					Object[Container, Bench, "Test bench for ExperimentNMRPreview tests "<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMRPreview tests "<>$SessionUUID],
					Object[Sample,"ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{testBench, container, sample},

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentNMRPreview tests "<>$SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
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
						"Test container 1 for ExperimentNMRPreview tests "<>$SessionUUID
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
						"ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID
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
					Object[Container, Bench, "Test bench for ExperimentNMRPreview tests "<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for ExperimentNMRPreview tests "<>$SessionUUID],
					Object[Sample,"ExperimentNMRPreview New Test Chemical 1 (100 uL) "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
