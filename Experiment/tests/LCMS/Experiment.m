(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Experiment LCMS: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*LCMS*)


(* ::Subsubsection:: *)
(*ExperimentLCMS*)




DefineTests[ExperimentLCMS,
	{
		(*===BASIC===*)
		Example[
			{Basic, "Automatically resolve of all options for sample when using QTOF as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]}
			];
			Download[protocol, {MassAnalyzer, MassSpectrometryInstrument, ResolvedOptions}],
			{QTOF, ObjectP[Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"]], OptionsPattern[]},
			Variables :> {protocol}
		],
		Example[
			{Basic, "Automatically resolve of all options for sample when using QQQ as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole
			];
			Download[protocol, {MassAnalyzer, MassSpectrometryInstrument, ResolvedOptions}],
			{TripleQuadrupole, ObjectP[Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"]], OptionsPattern[]},
			Variables :> {protocol}
		],
		Example[
			{Basic, "Specify the injection volume for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					InjectionVolume -> 10 Micro Liter
				][[1]];
				Lookup[packet, Replace[SampleVolumes]]
			),
			{10 Microliter, 10 Microliter, 10 Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		(*===ADDITIONAL===*)
		Example[
			{Additional, "Automatically resolve of all options for sample without a model:"},
			(
				packet = ExperimentLCMS[
					Object[Sample, "Test Sample 4 for ExperimentLCMS tests" <> $SessionUUID],
					Upload -> False][[1]];
				Lookup[packet, ResolvedOptions]
			),
			OptionsPattern[],
			Variables :> {packet}
		],
		Example[
			{Additional, "Be able to handle the complex, nest-index matched needed:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionWindow -> {
					{
						Span[0 Minute, 5 Minute],
						Span[6 Minute, 10 Minute]
					},
					{
						Span[0 Minute, 3 Minute],
						Span[4 Minute, 6 Minute],
						Span[6 Minute, 8 Minute]
					},
					Automatic
				},
				AcquisitionMode -> {
					Automatic,
					MS1MS2ProductIonScan,
					{
						MS1FullScan,
						DataDependent
					}
				}
			];
			Download[protocol, {AcquisitionWindows, AcquisitionModes}],
			{
				{
					{
						{Quantity[0, "Minutes"], Quantity[5, "Minutes"]},
						{Quantity[6, "Minutes"], Quantity[10, "Minutes"]}
					},
					{
						{Quantity[0, "Minutes"], Quantity[3, "Minutes"]},
						{Quantity[4, "Minutes"], Quantity[6, "Minutes"]},
						{Quantity[6, "Minutes"], Quantity[8, "Minutes"]}
					},
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[20., "Minutes"], Quantity[40., "Minutes"]}
					}
				},
				{
					{DataDependent, DataDependent},
					{
						MS1MS2ProductIonScan,
						MS1MS2ProductIonScan,
						MS1MS2ProductIonScan
					},
					{MS1FullScan, DataDependent}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 2):"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionWindow -> {
					{
						Span[0 Minute, 5 Minute],
						Span[6 Minute, 10 Minute]
					},
					{
						Span[0 Minute, 3 Minute],
						Span[4 Minute, 6 Minute],
						Span[6 Minute, 8 Minute]
					},
					Automatic
				},
				AcquisitionMode -> {
					Automatic,
					MS1MS2ProductIonScan,
					{
						MS1FullScan,
						DataDependent
					}
				},
				Output -> Options
			];
			Lookup[options, {AcquisitionWindow, AcquisitionMode}],
			{
				{
					{
						Quantity[0, "Minutes"] ;; Quantity[5, "Minutes"],
						Quantity[6, "Minutes"] ;; Quantity[10, "Minutes"]
					},
					{
						Quantity[0, "Minutes"] ;; Quantity[3, "Minutes"],
						Quantity[4, "Minutes"] ;; Quantity[6, "Minutes"],
						Quantity[6, "Minutes"] ;; Quantity[8, "Minutes"]
					},
					{
						Quantity[0., "Minutes"] ;; Quantity[19.99, "Minutes"],
						Quantity[20., "Minutes"] ;; Quantity[40., "Minutes"]
					}
				},
				{
					{DataDependent, DataDependent},
					{
						MS1MS2ProductIonScan,
						MS1MS2ProductIonScan,
						MS1MS2ProductIonScan
					},
					{MS1FullScan, DataDependent}
				}
			},
			Variables :> {options}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 3):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionWindow -> {
					{
						Span[0 Minute, 5 Minute],
						Span[6 Minute, 10 Minute]
					},
					Automatic
				},
				InclusionDomain -> {
					Automatic,
					{
						{Span[0 Minute, 5 Minute], Span[6 Minute, 10 Minute]},
						{Span[3 Minute, 6 Minute]}
					}
				},
				InclusionMass -> {
					{{
						{Only, 670 Gram / Mole}
					}},
					{{
						{Only, 670 Gram / Mole},
						{Only, 670 Gram / Mole}
					}}
				}
			];
			Download[protocol, {AcquisitionWindows, InclusionDomains, InclusionMasses}],
			{
				{
					{
						{Quantity[0, "Minutes"], Quantity[5, "Minutes"]},
						{Quantity[6, "Minutes"], Quantity[10, "Minutes"]}
					},
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[20., "Minutes"], Quantity[40., "Minutes"]}
					}
				},
				{
					{
						{{Quantity[0, "Minutes"], Quantity[5, "Minutes"]}},
						{{Quantity[6, "Minutes"], Quantity[10, "Minutes"]}}
					},
					{
						{
							{Quantity[0, "Minutes"], Quantity[5, "Minutes"]},
							{Quantity[6, "Minutes"], Quantity[10, "Minutes"]}
						},
						{{Quantity[3, "Minutes"], Quantity[6, "Minutes"]}}
					}
				},
				{
					{
						{{Only, Quantity[670, "Grams" / "Moles"]}},
						{{Only, Quantity[670, "Grams" / "Moles"]}}
					},
					{
						{
							{Only, Quantity[670, "Grams" / "Moles"]},
							{Only, Quantity[670, "Grams" / "Moles"]}
						},
						{{Only, Quantity[670, "Grams" / "Moles"]}}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 4):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopicExclusion -> 1 Gram / Mole,
				ColumnPrimeIsotopeRatioThreshold -> {0.1},
				ColumnPrimeIsotopeDetectionMinimum -> {{10 1 / Second, 20 1 / Second}}
			];
			Download[protocol, {ColumnPrimeIsotopeMassDifferences, ColumnPrimeIsotopeRatios, ColumnPrimeIsotopeDetectionMinimums}],
			{
				{{Quantity[1, "Grams" / "Moles"], Quantity[1, "Grams" / "Moles"]}},
				{{0.1, 0.1}},
				{
					{
						Quantity[10, "Seconds"^(-1)],
						Quantity[20, "Seconds"^(-1)]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 5):"},
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				AcquisitionMode -> DataDependent,
				InclusionDomain -> {5 Minute ;; 10 Minute, Full, Full},
				InclusionCollisionEnergy -> {50 Volt, 100 Volt}
			];
			Download[protocol, {InclusionMasses, InclusionDomains, InclusionCollisionEnergies}],
			{
				{
					{
						{{Preferential, Quantity[2, "Grams" / "Moles"]}},
						{{Preferential, Quantity[2, "Grams" / "Moles"]}},
						{{Preferential, Quantity[2, "Grams" / "Moles"]}}
					}
				},
				{
					{
						{{Quantity[5, "Minutes"], Quantity[10, "Minutes"]}},
						{{Quantity[13.33, "Minutes"], Quantity[26.66, "Minutes"]}},
						{{Quantity[26.67, "Minutes"], Quantity[40., "Minutes"]}}
					}
				},
				{{{Quantity[50, "Volts"]}, {Quantity[100, "Volts"]}, {Quantity[40, "Volts"]}}}
			},
			Variables :> {protocol}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 6):"},
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				AcquisitionSurvey -> 20,
				ChargeStateExclusionLimit -> {0, 10, 20},
				ChargeStateMassTolerance -> {200 Gram / Mole}
			];
			Download[protocol, {ChargeStateLimits, ChargeStateMassTolerances}],
			{
				{{0, 10, 20}},
				{
					{
						Quantity[200, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 7):"},
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				IsotopicExclusion -> 2 Gram / Mole,
				IsotopeRatioThreshold -> {0.1, 0.2, 0.2},
				IsotopeDetectionMinimum -> {10.1 * 1 / Second, 15 * 1 / Second}
			];
			Download[protocol, {IsotopeRatios, IsotopeDetectionMinimums}],
			{
				{{{0.1}, {0.2}, {0.2}}},
				{
					{
						{Quantity[10, "Seconds"^(-1)]},
						{Quantity[15, "Seconds"^(-1)]},
						{Quantity[10, "Seconds"^(-1)]}
					}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[
			{Additional, "Be able to handle the complex, nested-index matching needed (part 8):"},
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnPrimeInclusionDomain -> {5 Minute ;; 20 Minute},
				ColumnPrimeInclusionMass -> {Preferential, 400 Gram / Mole},
				ColumnPrimeInclusionCollisionEnergy -> {100 Volt, 230 Volt},
				ColumnPrimeInclusionDeclusteringVoltage -> {10 Volt, 102 Volt}
			];
			Download[protocol, {ColumnPrimeInclusionDomains, ColumnPrimeInclusionMasses, ColumnPrimeInclusionCollisionEnergies, ColumnPrimeInclusionDeclusteringVoltages}],
			{
				{
					{
						{Quantity[5, "Minutes"], Quantity[20, "Minutes"]},
						{Quantity[5, "Minutes"], Quantity[20, "Minutes"]}
					}
				},
				{
					{
						{Preferential, Quantity[400, "Grams" / "Moles"]},
						{Preferential, Quantity[400, "Grams" / "Moles"]}
					}
				},
				{{Quantity[100, "Volts"], Quantity[230, "Volts"]}},
				{{Quantity[10, "Volts"], Quantity[102, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Additional, "Be able to fill in the gaps for the acquisition window when both automatics and spans:"},
			(
				options = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					AcquisitionWindow -> {
						2. Minute ;; 4.66 Minute,
						Automatic,
						Automatic,
						7.33 Minute ;; 10. Minute,
						10.1 Minute ;; 11 Minute,
						Automatic,
						15 Minute ;; 20 Minute
					},
					Output -> Options
				];
				Lookup[options, AcquisitionWindow]
			),
			{Quantity[2.`, "Minutes"] ;; Quantity[4.66`, "Minutes"],
				Quantity[4.67`, "Minutes"] ;; Quantity[5.99`, "Minutes"],
				Quantity[6.`, "Minutes"] ;; Quantity[7.32`, "Minutes"],
				Quantity[7.33`, "Minutes"] ;; Quantity[10.`, "Minutes"],
				Quantity[10.1`, "Minutes"] ;; Quantity[11, "Minutes"],
				Quantity[11.01`, "Minutes"] ;; Quantity[14.99`, "Minutes"],
				Quantity[15, "Minutes"] ;; Quantity[20, "Minutes"]
			},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Test["Be able to upload absorbance as singelton wavelengths:",
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AbsorbanceWavelength -> {Quantity[273.`, "Nanometers"], Quantity[273.`, "Nanometers"], Quantity[273.`, "Nanometers"]}
			];
			Download[protocol, {ColumnPrimeAbsorbanceSelection, ColumnFlushAbsorbanceSelection}],
			{{Quantity[273., "Nanometers"]}, {Quantity[273., "Nanometers"]}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, InjectionVolume, "Specify the injection volume for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					InjectionVolume -> {10 Micro Liter, 10 Micro Liter, 10 Micro Liter}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					InjectionVolume
				]
			),
			{10 Micro Liter, 10 Micro Liter, 10 Micro Liter},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		(*===OPTIONS===*)
		(*all the injection table options and errors*)
		Example[
			{Options, InjectionTable, "Specify a custom measurement sequence to run for the experiment:"},
			customInjectionTable = {
				{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Blank, Model[Sample, "Milli-Q water"], 5 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], 4 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, 40Celsius, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]}
			};
			protocol = ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
			},
				InjectionTable -> customInjectionTable
			];
			Download[protocol, InjectionTable],
			{
				<|
					Type -> ColumnPrime,
					Sample -> Null,
					InjectionVolume -> Null,
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> Sample,
					Sample -> LinkP[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]],
					InjectionVolume -> Quantity[2., "Microliters"],
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> Blank,
					Sample -> LinkP[Model[Sample, "Milli-Q water"]],
					InjectionVolume -> Quantity[5., "Microliters"],
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> Sample,
					Sample -> LinkP[Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID]],
					InjectionVolume -> Quantity[2., "Microliters"],
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> ColumnFlush,
					Sample -> Null,
					InjectionVolume -> Null,
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> Standard,
					Sample -> LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],
					InjectionVolume -> Quantity[4., "Microliters"],
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> Sample,
					Sample -> LinkP[Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]],
					InjectionVolume -> Quantity[2., "Microliters"],
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[40., "DegreesCelsius"],
					Data -> Null
				|>,
				<|
					Type -> ColumnFlush,
					Sample -> Null,
					InjectionVolume -> Null,
					Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
					MassSpectrometry -> LinkP[Object[Method, MassAcquisition]],
					DilutionFactor -> Null,
					ColumnTemperature -> Quantity[45., "DegreesCelsius"],
					Data -> Null
				|>
			},
			Messages :> {Warning::OverwritingMassAcquisitionMethod},
			Variables :> {customInjectionTable, protocol}
		],
		Example[
			{Options, Column, "Specify the column to use:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					Column -> Model[Item, Column, "id:KBL5DvYOa5vv"]
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					Column
				]
			),
			Model[Item, Column, "id:KBL5DvYOa5vv"],
			Variables :> {packet}
		],
		Example[
			{Options, GuardColumn, "If guard column is specified as a cartridge-type column object, GuardCartridge is the preferred guard cartridge for that column's model:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				GuardColumn -> Object[Item, Column, "Test cartridge guard column object for ExperimentLCMS" <> $SessionUUID]
			];
			Download[protocol, {GuardColumn, GuardCartridge}],
			{LinkP[Object[Item, Column, "Test cartridge guard column object for ExperimentLCMS" <> $SessionUUID]], LinkP[Model[Item, Cartridge, Column, "Test model cartridge for ExperimentLCMS" <> $SessionUUID]]},
			Variables :> {protocol}
		],
		Example[
			{Options, GuardColumn, "If guard column is specified as a non-cartridge-type column model, GuardCartridge is not populated:"},
			Download[ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				GuardColumn -> Model[Item, Column, "SecurityGuard Guard Cartridge Kit"]
			], {GuardColumn, GuardCartridge}],
			{LinkP[Model[Item, Column, "SecurityGuard Guard Cartridge Kit"]], LinkP[Model[Item, Cartridge, Column, "SecurityGuard Cartridge for C18 Columns with 2.0-3.0mm ID"]]}
		],
		Example[{Options, ColumnSelector, "Specify the columns to use in series as models:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnSelector -> {Null, Model[Item, Column, "id:KBL5DvYOa5vv"], Null, Null}
			];
			Download[protocol, {Column, SecondaryColumn}],
			{LinkP[Model[Item, Column, "id:KBL5DvYOa5vv"]], Null},
			Variables :> {protocol}
		],
		Test["Handle multiple column options selected at once:",
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Column -> Automatic,
				ColumnSelector -> {Null, Automatic, Null, Automatic}
			];
			Download[protocol, {ColumnSelection[[1, Column]], Column}],
			{LinkP[], LinkP[]},
			Variables :> {protocol}
		],
		Test["Handle multiple column options selected at once (2):",
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Column -> Model[Item, Column, "id:KBL5DvYOa5vv"],
				ColumnSelector -> {Null, Model[Item, Column, "id:KBL5DvYOa5vv"], Null, Automatic}
			];
			Download[protocol, {ColumnSelection[[1, Column]], Column}],
			{LinkP[Model[Item, Column, "id:KBL5DvYOa5vv"]], LinkP[Model[Item, Column, "id:KBL5DvYOa5vv"]]},
			Variables :> {protocol}
		],
		Example[
			{Options, SecondaryColumn, "Specify two columns to use in series for all of the samples:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Column -> Model[Item, Column, "id:KBL5DvYOa5vv"],
				SecondaryColumn -> Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID]
			];
			Download[protocol, SecondaryColumn],
			LinkP[Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[
			{Options, TertiaryColumn, "Specify three columns to use in series for all of the samples:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Column -> Model[Item, Column, "id:KBL5DvYOa5vv"],
				SecondaryColumn -> Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID],
				TertiaryColumn -> Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS (2)" <> $SessionUUID]
			];
			Download[protocol, {ColumnSelection[[1, Column]], ColumnSelection[[1, SecondaryColumn]], ColumnSelection[[1, TertiaryColumn]]}],
			{
				LinkP[Model[Item, Column, "id:KBL5DvYOa5vv"]],
				LinkP[Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID]],
				LinkP[Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS (2)" <> $SessionUUID]]
			},
			Variables :> {protocol}
		],
		Example[{Options, MaxAcceleration, "Specify the change in speed at which the flow rate ramps:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				MaxAcceleration -> 10 Milliliter / Minute / Minute,
				Output -> Options
			];
			Lookup[options, MaxAcceleration],
			10 Milliliter / Minute / Minute,
			Variables :> {options}
		],
		Example[
			{Options, ChromatographyInstrument, "Specify the instrument to use to separate the sample mixture:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ChromatographyInstrument -> Model[Instrument, HPLC, "Waters Acquity UPLC I-Class PDA"]
			];
			Download[
				protocol,
				ChromatographyInstrument
			],
			ObjectP[Model[Instrument, HPLC, "Waters Acquity UPLC I-Class PDA"]],
			Variables :> {protocol}
		],
		Example[
			{Options, MassSpectrometerInstrument, "Specify the instrument to use to ionize, select, and detect molecules:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassSpectrometerInstrument -> Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]
			];
			Download[
				protocol,
				MassSpectrometryInstrument
			],
			ObjectP[Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]],
			Variables :> {protocol}
		],
		Example[
			{Options, MassAnalyzer, "Specify the type of manner to separate and detect ions:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				Output -> Options
			];
			Lookup[
				options,
				MassAnalyzer
			],
			TripleQuadrupole,
			Variables :> {options}
		],
		Example[
			{Options, MassAnalyzer, "Auto resolved mass analyzer to QTOF:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Output -> Options
			];
			Lookup[
				options,
				MassAnalyzer
			],
			QTOF,
			Variables :> {options}
		],
		Example[
			{Options, ColumnTemperature, "Specify the column temperature at which to run each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnTemperature -> 30 Celsius
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnTemperature
				]
			),
			30 Celsius,
			Variables :> {packet}
		],
		Example[
			{Options, FlowRate, "Specify the flow rate for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					FlowRate -> 1.5 Milli Liter / Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					FlowRate
				]
			),
			1.5 Milliliter / Minute,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, GradientA, "Specify the buffer A gradient for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					GradientA -> {
						{{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}},
						{{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}},
						{{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientA
				]
			),
			Table[{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}}, 3],
			Messages :> {Warning::HPLCGradientNotReequilibrated},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, GradientB, "Specify the buffer B gradient for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					GradientB -> {
						{{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}},
						{{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}},
						{{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientB
				]
			),
			Table[{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}}, 3],
			Messages :> {Warning::HPLCGradientNotReequilibrated},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, GradientC, "Specify the buffer C gradient for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					GradientC -> {
						{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}},
						{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}},
						{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientC
				]
			),
			Table[{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}}, 3],
			Messages :> {Warning::HPLCGradientNotReequilibrated},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, GradientD, "Specify the buffer D gradient for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					GradientD -> {
						{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}},
						{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}},
						{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientD
				]
			),
			Table[{{50.1 Minute, 100 Percent}, {55 Minute, 100 Percent}}, 3],
			Messages :> {Warning::HPLCGradientNotReequilibrated},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, Gradient, "Specify the existing gradient method for each sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					Gradient -> Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					Gradient
				]
			),
			ObjectP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]],
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[{Options, NeedleWashSolution, "Specify the solvent used to wash the injection needle:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				NeedleWashSolution -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, NeedleWashSolution],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[
			{Options, SampleTemperature, "Specify the autosampler temperature while the protocol runs:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				SampleTemperature -> 10 Celsius
			];
			Download[
				protocol,
				SampleTemperature
			],
			10. Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[
			{Options, SeparationMode, "Specify the type of chromatography for the protocol:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					SeparationMode -> ReversePhase
				][[1]];
				Lookup[
					packet,
					SeparationMode
				]
			),
			ReversePhase,
			Variables :> {packet}
		],
		Example[
			{Options, SeparationMode, "Automatically inherit SeparationMode from the specified column:"},
			packet = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Column -> Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID],
				Upload -> False
			][[1]];
			{Lookup[packet, SeparationMode], Download[Object[Item, Column, "id:L8kPEjnNOn9A"], Model[SeparationMode]]},
			_?(MatchQ[#[[1]], #[[2]]]&),
			Variables :> {packet}
		],
		Example[
			{Options, BufferA, "Specify the buffer A for the protocol:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BufferA -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]
				][[1]];
				Lookup[
					packet,
					BufferA
				]
			),
			ObjectP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],
			Variables :> {packet}
		],
		Example[
			{Options, BufferB, "Specify the buffer B for the protocol:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BufferB -> Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
				][[1]];
				Lookup[
					packet,
					BufferB
				]
			),
			ObjectP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]],
			Variables :> {packet}
		],
		Example[
			{Options, BufferC, "Specify the buffer C for the protocol:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"]
			];
			Download[ protocol, BufferC ],
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]],
			Variables :> {protocol}
		],
		Example[
			{Options, BufferD, "Specify the buffer D for the protocol:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BufferD -> Model[Sample, "Acetonitrile, HPLC Grade"]
				][[1]];
				Lookup[
					packet,
					BufferD
				]
			),
			ObjectP[Model[Sample, "Acetonitrile, HPLC Grade"]],
			Variables :> {packet}
		],

		(*do all of the mass spectrometry options*)
		Example[
			{Options, IonMode, "Specify if positively or negatively charged ions are analyzed:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]}, IonMode -> Positive];
			Download[protocol, IonModes],
			{Positive, Positive, Positive},
			Variables :> {protocol}
		],
		Example[
			{Options, ESICapillaryVoltage, "Specify the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ESICapillaryVoltage -> {
					1 Kilovolt,
					2 Kilovolt,
					0.8 Kilovolt
				}
			];
			Download[protocol, ESICapillaryVoltages],
			{
				1 Kilovolt,
				2 Kilovolt,
				0.8 Kilovolt
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DeclusteringVoltage, "Specify the voltage between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer):"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				DeclusteringVoltage -> {
					100 Volt,
					75 Volt,
					40 Volt
				}
			];
			Download[protocol, DeclusteringVoltages],
			{
				100 Volt,
				75 Volt,
				40 Volt
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StepwaveVoltage, "Specify The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StepwaveVoltage -> {
					100 Volt,
					75 Volt,
					40 Volt
				}
			];
			Download[protocol, StepwaveVoltages],
			{
				100 Volt,
				75 Volt,
				40 Volt
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, IonGuideVoltage, "Specify the electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IonGuideVoltage -> {
					8 Volt,
					-8 Volt,
					-9 Volt
				}
			];
			Download[protocol, IonGuideVoltages],
			{
				8 Volt,
				-8 Volt,
				-9 Volt
			},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[
			{Options, SourceTemperature, "Specify the temperature setting of the source block:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				SourceTemperature -> {
					100 Celsius,
					75 Celsius,
					130 Celsius
				}
			];
			Download[protocol, SourceTemperatures],
			{
				100. Celsius,
				75. Celsius,
				130. Celsius
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DesolvationTemperature, "Specify the temperature setting for heat element of the drying sheath gas:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				DesolvationTemperature -> {
					650 Celsius,
					500 Celsius,
					400 Celsius
				}
			];
			Download[protocol, DesolvationTemperatures],
			{
				650. Celsius,
				500. Celsius,
				400. Celsius
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, DesolvationGasFlow, "Specify the nitrogen gas flow ejected around the ESI capillary, used for solvent evaporation to produce single gas phase ions from the ion spray:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				DesolvationGasFlow -> {
					1200 Liter / Hour,
					1000 Liter / Hour,
					800 Liter / Hour
				}
			];
			Download[protocol, DesolvationGasFlows],
			{
				1200. Liter / Hour,
				1000. Liter / Hour,
				800. Liter / Hour
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ConeGasFlow, "Specify the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block):"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ConeGasFlow -> {
					300 Liter / Hour,
					30 Liter / Hour,
					100 Liter / Hour
				}
			];
			Download[protocol, ConeGasFlows],
			{
				300. Liter / Hour,
				30. Liter / Hour,
				100. Liter / Hour
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, Calibrant, "Specify A sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer. In the chosen ion polarity mode, the calibrant should contain at least 3 masses spread over the mass range of interest:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Calibrant -> Model[Sample, StockSolution, Standard, "Sodium Formate ESI Calibrant"]
			];
			Download[protocol, Calibrant],
			ObjectP[Model[Sample, StockSolution, Standard, "Sodium Formate ESI Calibrant"]],
			Variables :> {protocol}
		],
		Example[
			{Options, SecondCalibrant, "Specify A sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer. In the chosen ion polarity mode, the calibrant should contain at least 3 masses spread over the mass range of interest:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				SecondCalibrant -> Model[Sample, StockSolution, Standard, "POS PPG, 2E-7M (0.2 microMolar or 500:1), SciEX Standard"]];
			Download[protocol, SecondCalibrant],
			ObjectP[Model[Sample, StockSolution, Standard, "POS PPG, 2E-7M (0.2 microMolar or 500:1), SciEX Standard"]],
			Variables :> {protocol}
		],
		Example[
			{Options, MassSpectrometryMethod, "Specify previous instruction(s) for the analyte ionization, selection, fragmentation, and detection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassSpectrometryMethod -> Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]
			];
			Download[protocol, {InclusionMasses, InclusionCollisionEnergies}],
			{
				{
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					},
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					},
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					}
				},
				{
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					},
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					},
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::OverwritingMassAcquisitionMethod}
		],
		Example[
			{Options, AcquisitionWindow, "Specify the time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionWindow -> 0 Minute ;; 5 Minute
			];
			Download[protocol, AcquisitionWindows],
			{
				{{0 Minute, 5 Minute}},
				{{0 Minute, 5 Minute}},
				{{0 Minute, 5 Minute}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, AcquisitionMode, "Specify whether spectra to be collected should depend on properties of measured mass spectrum of the intact ions (DataDependent), systematically scan through all of the intact ions (DataIndependent), or to scan specified ions (Null) as set by MassDetection and/or FragmentMassDetection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionMode -> {DataDependent, {DataIndependent}, MS1FullScan}
			];
			Download[protocol, AcquisitionModes],
			{
				{DataDependent},
				{DataIndependent},
				{MS1FullScan}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, Fragment, "Specify whether to have ions dissociate upon collision with neutral gas species and to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS):"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Fragment -> {True, False, True}
			];
			Download[protocol, Fragmentations],
			{{True, False, True}, {True, False, True}, {True, False, True}},
			Variables :> {protocol}
		],
		Example[
			{Options, MassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. For Fragmentation->True, the intact ions will be selected for fragmentation:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassDetection -> {
					678 Dalton,
					200 Dalton ;; 3000Dalton,
					{450 Dalton, 567 Dalton}
				}
			];
			Download[protocol, {MinMasses, MaxMasses, MassSelections}],
			{
				{
					{Null, 200 Gram / Mole, Null},
					{Null, 200 Gram / Mole, Null},
					{Null, 200 Gram / Mole, Null}
				},
				{
					{Null, 3000 Gram / Mole, Null},
					{Null, 3000 Gram / Mole, Null},
					{Null, 3000 Gram / Mole, Null}
				},
				{
					{
						{678 Gram / Mole}, Null, {450 Gram / Mole, 567 Gram / Mole}
					},
					{
						{678 Gram / Mole}, Null, {450 Gram / Mole, 567 Gram / Mole}
					},
					{
						{678 Gram / Mole}, Null, {450 Gram / Mole, 567 Gram / Mole}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, MassDetection, "Specify the individual mass-to-charge ratio (m/z) to be recorded or selected for intact masses:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassDetection -> {
					678 Dalton,
					1500 Dalton
				}
			];
			Download[protocol, {MinMasses, MaxMasses, MassSelections}],
			{
				{
					{Null, Null}, {Null, Null}, {Null, Null}
				},
				{
					{Null, Null}, {Null, Null}, {Null, Null}
				},
				{
					{
						{678 Gram / Mole}, {1500 Gram / Mole}
					},
					{
						{678 Gram / Mole}, {1500 Gram / Mole}
					},
					{
						{678 Gram / Mole}, {1500 Gram / Mole}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ScanTime, "Specify the duration of time allowed to pass for each spectral acquisition for a given state of the instrument:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, ScanTimes],
			{
				{
					Quantity[0.1, "Seconds"],
					Quantity[0.2, "Seconds"],
					Quantity[0.4, "Seconds"]
				},
				{
					Quantity[0.1, "Seconds"],
					Quantity[0.2, "Seconds"],
					Quantity[0.4, "Seconds"]
				},
				{
					Quantity[0.1, "Seconds"],
					Quantity[0.2, "Seconds"],
					Quantity[0.4, "Seconds"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, FragmentMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				FragmentMassDetection -> {
					All,
					200 Dalton ;; 3000Dalton,
					{450 Dalton, 567 Dalton}
				}
			];
			Download[protocol, {FragmentMinMasses, FragmentMaxMasses, FragmentMassSelections}],
			{
				{
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					}
				},
				{
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					}
				},
				{
					{
						Null,
						Null,
						{
							Quantity[450, "Grams" / "Moles"],
							Quantity[567, "Grams" / "Moles"]
						}
					},
					{
						Null,
						Null,
						{
							Quantity[450, "Grams" / "Moles"],
							Quantity[567, "Grams" / "Moles"]
						}
					},
					{
						Null,
						Null,
						{
							Quantity[450, "Grams" / "Moles"],
							Quantity[567, "Grams" / "Moles"]
						}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, CollisionEnergy, "Specify the voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CollisionEnergy -> {{100 Volt}, {30 Volt}, {55 Volt}}
			];
			Download[protocol, {CollisionEnergies, LowCollisionEnergies, HighCollisionEnergies, FinalLowCollisionEnergies, FinalHighCollisionEnergies}],
			{{{{Quantity[100, "Volts"]}, {Quantity[30, "Volts"]}, {Quantity[55,
				"Volts"]}}, {{Quantity[100, "Volts"]}, {Quantity[30,
				"Volts"]}, {Quantity[55, "Volts"]}}, {{Quantity[100,
				"Volts"]}, {Quantity[30, "Volts"]}, {Quantity[55,
				"Volts"]}}}, {{Null, Null, Null}, {Null, Null, Null}, {Null,
				Null, Null}}, {{Null, Null, Null}, {Null, Null, Null}, {Null, Null,
				Null}}, {{Null, Null, Null}, {Null, Null, Null}, {Null, Null,
				Null}}, {{Null, Null, Null}, {Null, Null, Null}, {Null, Null,
				Null}}},
			Variables :> {protocol}
		],
		Example[
			{Options, CollisionEnergy, "Specify a list of collision energies for MRM when using QQQ as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				AcquisitionMode -> MultipleReactionMonitoring,
				MassDetection -> {{111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole}},
				FragmentMassDetection -> {{111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole}},
				CollisionEnergy -> {{{80 Volt, 78 Volt, 67 Volt, 23 Volt, 90 Volt}}}];
			Download[protocol, CollisionEnergies],
			{{{Quantity[80, "Volts"], Quantity[78, "Volts"], Quantity[67, "Volts"], Quantity[23, "Volts"], Quantity[90, "Volts"]}}},
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[
			{Options, CollisionEnergyMassProfile, "Specify the relationship of collision energy with the MassDetection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CollisionEnergyMassProfile -> {
					60Volt ;; 90Volt,
					(*this should be split across the acquisition windows*)
					{30 Volt ;; 100Volt, 60 Volt ;; 150Volt},
					60 Volt ;; 150Volt
				}
			];
			Download[protocol, {CollisionEnergies, LowCollisionEnergies, HighCollisionEnergies, FinalLowCollisionEnergies, FinalHighCollisionEnergies}],
			{
				{
					(* collision energy is not Null under DataIndependent*)
					{{40 Volt}},
					{Null, Null},
					{{40 Volt}}
				},
				{
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]}
				},
				{
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]}
				},
				{
					{Null},
					{Null, Null},
					{Null}
				},
				{
					{Null},
					{Null, Null},
					{Null}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, CollisionEnergyMassScan, "Specify Collision energy profile at the end of the scan from CollisionEnergy or CollisionEnergyScanProfile, as related to analyte mass:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CollisionEnergyMassScan -> {
					60Volt ;; 90Volt,
					(*this should be split across the acquisition windows*)
					{30 Volt ;; 100Volt, 100Volt ;; 150Volt},
					60 Volt ;; 150Volt
				}
			];
			Download[protocol, {FinalLowCollisionEnergies, FinalHighCollisionEnergies}],
			{
				{
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[100, "Volts"]},
					{Quantity[60, "Volts"]}
				},
				{
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, FragmentScanTime, "Specify the duration of the spectral scanning for each fragmentation of an intact ion:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				FragmentScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, FragmentScanTimes],
			{
				{
					Quantity[0.1, "Seconds"],
					Quantity[0.2, "Seconds"],
					Quantity[0.4, "Seconds"]
				},
				{
					Quantity[0.1, "Seconds"],
					Quantity[0.2, "Seconds"],
					Quantity[0.4, "Seconds"]
				},
				{
					Quantity[0.1, "Seconds"],
					Quantity[0.2, "Seconds"],
					Quantity[0.4, "Seconds"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, AcquisitionSurvey, "Specify the number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionSurvey -> {
					5,
					10,
					20
				}
			];
			Download[protocol, AcquisitionSurveys],
			{
				{ 5, 10, 20 },
				{ 5, 10, 20 },
				{ 5, 10, 20 }
			},
			Variables :> {protocol}
		],
		Example[
			{Options, MinimumThreshold, "Specify the minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MinimumThreshold -> {80000 ArbitraryUnit, 100000 ArbitraryUnit, 200000 ArbitraryUnit}
			];
			Download[protocol, MinimumThresholds],
			{
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, AcquisitionLimit, "Specify the maximum number of total ions for a specific intact ion. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionLimit -> {
					1000000 ArbitraryUnit,
					2000000 ArbitraryUnit,
					500000 ArbitraryUnit
				}
			];
			Download[protocol, AcquisitionLimits],
			{
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, CycleTimeLimit, "Specify the maximum duration for spectral scan measurement of fragment ions, as dictated by the initial survey in the first scan:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CycleTimeLimit -> {
					{5 Second},
					2 Second,
					10 Second
				}
			];
			Download[protocol, CycleTimeLimits],
			{
				{
					Quantity[5, "Seconds"]
				},
				{
					Quantity[2, "Seconds"]
				},
				{
					Quantity[10, "Seconds"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ExclusionDomain, "Specify when the ExclusionMasses are omitted in the chromatogram. Full indicates for the entire period:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ExclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					},
					{
						{
							Full,
							10Minute ;; 20Minute
						},
						{
							2 Minute ;; 5 Minute
						}
					}
				}
			];
			Download[protocol, ExclusionDomains],
			{
				{
					{
						{
							Quantity[0., "Minutes"],
							Quantity[40., "Minutes"]
						}
					}
				},
				{
					{
						{
							Quantity[5, "Minutes"],
							Quantity[6, "Minutes"]
						}
					},
					{
						{
							Quantity[7, "Minutes"],
							Quantity[9, "Minutes"]
						}
					}
				},
				{
					{
						{
							Quantity[0., "Minutes"],
							Quantity[19.99, "Minutes"]
						},
						{
							Quantity[10, "Minutes"],
							Quantity[20, "Minutes"]
						}
					},
					{
						{
							Quantity[2, "Minutes"],
							Quantity[5, "Minutes"]
						}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardExclusionDomain, "Specify Defines when the ExclusionMasses are omitted in the chromatogram. Full indicates for the entire period:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardExclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					},
					{
						{
							Full,
							10Minute ;; 20Minute
						},
						{
							2 Minute ;; 5 Minute
						}
					}
				}
			];
			Download[protocol, StandardExclusionDomains],
			{
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				},
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ExclusionMass, "Specify The intact ions (Target Mass) to omit. When the Mode is set to All, the mass is excluded for the entire ExclusionDomain. When the Mode is set to Once, the Mass is excluded in the first survey appearance, but considered for consequent ones:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ExclusionMass -> {
					{All, 500 Gram / Mole},
					{
						{
							{All, 789 Gram / Mole},
							{All, 899 Gram / Mole}
						},
						{
							{Once, 678 Gram / Mole},
							{Once, 567 Gram / Mole},
							{Once, 902 Gram / Mole}
						}
					},
					{
						{Once, 456 Gram / Mole},
						{Once, 901 Gram / Mole}
					}
				}
			];
			Download[protocol, ExclusionMasses],
			{
				{
					{
						{
							All,
							Quantity[500, "Grams" / "Moles"]
						}
					}
				},
				{
					{
						{
							All,
							Quantity[789, "Grams" / "Moles"]
						},
						{
							All,
							Quantity[899, "Grams" / "Moles"]
						}
					},
					{
						{
							Once,
							Quantity[678, "Grams" / "Moles"]
						},
						{
							Once,
							Quantity[567, "Grams" / "Moles"]
						},
						{
							Once,
							Quantity[902, "Grams" / "Moles"]
						}
					}
				},
				{
					{
						{
							Once,
							Quantity[456, "Grams" / "Moles"]
						}
					},
					{
						{
							Once,
							Quantity[901, "Grams" / "Moles"]
						}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ExclusionMassTolerance, "Specify For ExclusionMode -> TimeLimit or Once, the range above and below each ion in ExclusionMasses to consider for omission:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ExclusionMassTolerance -> {
					1 Gram / Mole,
					{2 Gram / Mole, 0.7 Gram / Mole},
					0.5 Gram / Mole
				}
			];
			Download[protocol, ExclusionMassTolerances],
			{
				{
					Quantity[1, "Grams" / "Moles"]
				},
				{
					Quantity[2, "Grams" / "Moles"],
					Quantity[0.7, "Grams" / "Moles"]
				},
				{
					Quantity[0.5, "Grams" / "Moles"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ExclusionRetentionTimeTolerance, "Specify If ExclusionMasses is in the Specific Times configuration, the range of time above and below the RetentionTime to consider for omission:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ExclusionRetentionTimeTolerance -> {
					1 Second,
					{2 Second, 10 Second},
					20 Second
				}
			];
			Download[protocol, ExclusionRetentionTimeTolerances],
			{
				{
					Quantity[1, "Seconds"]
				},
				{
					Quantity[2, "Seconds"],
					Quantity[10, "Seconds"]
				},
				{
					Quantity[20, "Seconds"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionDomain, "Specify Defines when the InclusionMass applies with respective to the chromatogram:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					},
					{
						{
							Full,
							10Minute ;; 20Minute
						},
						{
							2 Minute ;; 5 Minute
						}
					}
				}
			];
			Download[protocol, InclusionDomains],
			{
				{
					{
						{
							Quantity[0., "Minutes"],
							Quantity[40., "Minutes"]
						}
					}
				},
				{
					{
						{
							Quantity[5, "Minutes"],
							Quantity[6, "Minutes"]
						}
					},
					{
						{
							Quantity[7, "Minutes"],
							Quantity[9, "Minutes"]
						}
					}
				},
				{
					{
						{
							Quantity[0., "Minutes"],
							Quantity[19.99, "Minutes"]
						},
						{
							Quantity[10, "Minutes"],
							Quantity[20, "Minutes"]
						}
					},
					{
						{
							Quantity[2, "Minutes"],
							Quantity[5, "Minutes"]
						}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionMass, "Specify When AcquisitionMode is DataDependent, the ions (Target Mass) to prioritize during the survey scan for further fragmentation. When the Mode is Only, InclusionMass set to Only will solely be considered for surveys. When Mode is Preferential,:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionMass -> {
					{Only, 500 Gram / Mole},
					{
						{
							{Preferential, 789 Gram / Mole},
							{Only, 899 Gram / Mole}
						},
						{
							{Only, 678 Gram / Mole},
							{Preferential, 567 Gram / Mole},
							{Only, 902 Gram / Mole}
						}
					},
					{
						{Preferential, 456 Gram / Mole},
						{Only, 901 Gram / Mole}
					}
				}
			];
			Download[protocol, InclusionMasses],
			{
				{
					{
						{
							Only,
							Quantity[500, "Grams" / "Moles"]
						}
					}
				},
				{
					{
						{
							Preferential,
							Quantity[789, "Grams" / "Moles"]
						},
						{
							Only,
							Quantity[899, "Grams" / "Moles"]
						}
					},
					{
						{
							Only,
							Quantity[678, "Grams" / "Moles"]
						},
						{
							Preferential,
							Quantity[567, "Grams" / "Moles"]
						},
						{
							Only,
							Quantity[902, "Grams" / "Moles"]
						}
					}
				},
				{
					{
						{
							Preferential,
							Quantity[456, "Grams" / "Moles"]
						}
					},
					{
						{
							Only,
							Quantity[901, "Grams" / "Moles"]
						}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionCollisionEnergy, "Specify An overriding collision energy value that can be applied to the InclusionMass. Null will default to the CollisionEnergy option and related:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionCollisionEnergy -> {
					100 Volt,
					{
						{
							75 Volt,
							45 Volt
						},
						{
							67 Volt,
							56 Volt,
							90 Volt
						}
					},
					{
						45 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, InclusionCollisionEnergies],
			{
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionDeclusteringVoltage, "Specify An overriding source voltage value that can be applied to the InclusionMass. Null will default to the DeclusteringVoltage option:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionDeclusteringVoltage -> {
					100 Volt,
					{
						{
							75 Volt,
							45 Volt
						},
						{
							67 Volt,
							56 Volt,
							90 Volt
						}
					},
					{
						45 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, InclusionDeclusteringVoltages],
			{
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionChargeState, "Specify The maximum charge state of the InclusionMass to also consider for inclusion. For example, if this is set to 3 and the polarity is Positive, then +1,+2,+3 charge states will be considered as well:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionChargeState -> {
					{1, 2},
					{
						{1, 2},
						{1, 2, 3}
					},
					{0, 1}
				}
			];
			Download[protocol, InclusionChargeStates],
			{
				{{1}, {2}},
				{{1, 2}, {1, 2, 3}},
				{{0}, {1}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionScanTime, "Specify An overriding scan time duration that can be applied to the InclusionMass for the consequent fragmentation. Null will default to the FragmentScanTime option:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionScanTime -> {
					2 Second,
					{
						{
							3 Second,
							5 Second
						},
						{
							0.5 Second,
							0.2 Second,
							1 Second
						}
					},
					{
						4.5 Second,
						9 Second
					}
				}
			];
			Download[protocol, InclusionScanTimes],
			{
				{
					{
						Quantity[2, "Seconds"]
					}
				},
				{
					{
						Quantity[3, "Seconds"],
						Quantity[5, "Seconds"]
					},
					{
						Quantity[0.5, "Seconds"],
						Quantity[0.2, "Seconds"],
						Quantity[1, "Seconds"]
					}
				},
				{
					{
						Quantity[4.5, "Seconds"]
					},
					{
						Quantity[9, "Seconds"]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, InclusionMassTolerance, "Specify The range above and below each ion in InclusionMasses to consider for prioritization. For example, if set to 0.5 Gram/Mole, the total range is 1 Gram/Mole:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				InclusionMassTolerance -> {
					{
						2 Gram / Mole,
						1 Gram / Mole
					},
					{
						6 Gram / Mole
					},
					3 Gram / Mole
				}
			];
			Download[protocol, InclusionMassTolerances],
			{
				{
					Quantity[2, "Grams" / "Moles"],
					Quantity[1, "Grams" / "Moles"]
				},
				{
					Quantity[6, "Grams" / "Moles"]
				},
				{
					Quantity[3, "Grams" / "Moles"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, SurveyChargeStateExclusion, "Specify Indicates if to automatically fill ChargeState exclusion related options and leave out redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.):"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				SurveyChargeStateExclusion -> {
					{
						True,
						False
					},
					{
						True
					},
					False
				}
			];
			Download[protocol, ChargeStateSelections],
			{
				{
					{1, 2},
					Null
				},
				{
					{1, 2}
				},
				{
					Null
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, SurveyIsotopeExclusion, "Specify Indicates if to automatically fill MassIsotope exclusion related options and leave out redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole):"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				SurveyIsotopeExclusion -> {
					{
						True,
						False
					},
					{
						True
					},
					False
				}
			];
			Download[protocol, {IsotopeMassDifferences, IsotopeRatios, IsotopeDetectionMinimums}],
			{
				{
					{
						{
							Quantity[1, "Grams" / "Moles"]
						},
						Null
					},
					{
						{
							Quantity[1, "Grams" / "Moles"]
						}
					},
					{
						Null
					}
				},
				{
					{
						{
							0.1
						},
						Null
					},
					{
						{
							0.1
						}
					},
					{
						Null
					}
				},
				{
					{
						{
							Quantity[10, "Seconds"^(-1)]
						},
						Null
					},
					{
						{
							Quantity[10, "Seconds"^(-1)]
						}
					},
					{
						Null
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ChargeStateExclusionLimit, "Specify The number of ions to survey first with exclusion by ionic state. For example, if AcquisitionSurvey is 10 and this option is 5, then 5 ions will be surveyed with charge-state exclusion. For candidate ions of rank 6 to 10, no exclusion will be performed:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ChargeStateExclusionLimit -> {
					{5, 6},
					{10},
					3
				}
			];
			Download[protocol, ChargeStateLimits],
			{{5, 6}, {10}, {3}},
			Variables :> {protocol}
		],
		(* Prior to the ExpandIndexMatchedInputs update in April 2025, this resolved to a protocol with 3 acquisition windows for the first sample *)
		(* 4 acquisition windows for the second sample and 2 acquisition windows for the third sample. Now it resolves to a protocol where each sample *)
		(* has 3 acquisitions windows with 3, 4, and 2 ions excluded for each. This is also a valid protocol and as there have not been of these any protocols  *)
		(* actually run we have updated it. *)
		Example[
			{Options, ChargeStateExclusion, "Specify the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition. 1 refers to +1/-1, 2 refers to +2/-2, etc:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ChargeStateExclusion -> {
					{1, 2, 3},
					{1, 2, 3, 4},
					{2, 4}
				}
			];
			Download[protocol, ChargeStateSelections],
			{
				(* Sample 1 *)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4},
					(* Acquisition Window 3 *)
					{2, 4}
				},
				(* Sample 2 *)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4},
					(* Acquisition Window 3 *)
					{2, 4}
				},
				(* Sample 2 *)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4},
					(* Acquisition Window 3 *)
					{2, 4}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ChargeStateMassTolerance, "Specify When IsotopeExclusionMode is ChargedState, the range of m/z to consider for exclusion by ionic state property:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ChargeStateMassTolerance -> {
					{
						2 Gram / Mole,
						2.5 Gram / Mole
					},
					{
						3 Gram / Mole
					},
					1 Gram / Mole
				}
			];
			Download[protocol, ChargeStateMassTolerances],
			{
				{Quantity[2, "Grams" / "Moles"], Quantity[2.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, IsotopicExclusion, "Specify the m/z difference between monoisotopic ions as a criterion for survey exclusion:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IsotopicExclusion -> {
					{
						{1 Gram / Mole, 2 Gram / Mole},
						{1 Gram / Mole}
					},
					{
						{1 Gram / Mole, 2 Gram / Mole}
					},
					{1 Gram / Mole}
				}
			];
			Download[protocol, IsotopeMassDifferences],
			{
				{
					{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
					{Quantity[1, "Grams" / "Moles"]}
				},
				{{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]}},
				{{Quantity[1, "Grams" / "Moles"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, IsotopeRatioThreshold, "Specify isotopes for exclusion, this minimum relative magnitude between monoisotopic ions must be met:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IsotopeRatioThreshold -> {
					{
						{0.1, 0.05},
						{0.2}
					},
					{
						{0.3, 0.25}
					},
					{0.15}
				}
			];
			Download[protocol, IsotopeRatios],
			{
				{{0.1, 0.05}, {0.2}},
				{{0.3, 0.25}},
				{{0.15}}
			},
			Variables :> {protocol}
		],
		(* Prior to ExpandIndexMatchedInputs updates in April 2025 this resolved to a protocol with 2 acquisitions windows for the first and one for the latter samples. *)
		(* Now it resolves to a protocol with 3 acquisition windows for each measuring to isotopes in the first and one in each of the latter. As no protocols have been *)
		(* run in lab we decided to update the value of the test. *)
		Example[
			{Options, IsotopeDetectionMinimum, "Specify the acquisition rate of a given intact mass to consider for isotope exclusion in the survey:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IsotopeDetectionMinimum -> {
					{
						10 1 / Second,
						20 1 / Second
					},
					{
						15 1 / Second
					},
					25 1 / Second
				}
			];
			Download[protocol, IsotopeDetectionMinimums],
			{
				(* Sample 1 *)
				{
					(* Acquisition Window 1 *)
					{10 1/Second, 20 1/Second},
					(* Acquisition Window 2 *)
					{15 1/Second},
					(* Acquisition Window 3 *)
					{25 1/Second}
				},
				(* Sample 2 *)
				{
					(* Acquisition Window 1 *)
					{10 1/Second, 20 1/Second},
					(* Acquisition Window 2 *)
					{15 1/Second},
					(* Acquisition Window 3 *)
					{25 1/Second}
				},
				(* Sample 3 *)
				{
					(* Acquisition Window 1 *)
					{10 1/Second, 20 1/Second},
					(* Acquisition Window 2 *)
					{15 1/Second},
					(* Acquisition Window 3 *)
					{25 1/Second}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, IsotopeMassTolerance, "Specify the range of m/z around a mass to consider for exclusion:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IsotopeMassTolerance -> {
					{
						1 Gram / Mole,
						2 Gram / Mole
					},
					{
						0.5 Gram / Mole
					},
					3 Gram / Mole
				}
			];
			Download[protocol, IsotopeMassTolerances],
			{
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, IsotopeRatioTolerance, "Specify The range of relative magnitude around IsotopeRatio to consider for isotope exclusion:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IsotopeRatioTolerance -> {
					{
						10 Percent,
						25 Percent
					},
					{
						15 Percent
					},
					25 Percent
				}
			];
			Download[protocol, IsotopeRatioTolerances],
			{
				{Quantity[10, "Percent"], Quantity[25, "Percent"]},
				{Quantity[15, "Percent"]},
				{Quantity[25, "Percent"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, AbsorbanceWavelength, "Specify the physical properties of light passed through the flow for the PhotoDiodeArray (PDA) Detector:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AbsorbanceWavelength -> Span[300 Nanometer, 450 Nanometer]
			];
			Download[protocol, {MinAbsorbanceWavelengths, MaxAbsorbanceWavelengths}],
			{{300. Nanometer, 300. Nanometer, 300. Nanometer}, {450. Nanometer, 450. Nanometer, 450. Nanometer}},
			Variables :> {protocol}
		],
		Example[
			{Options, WavelengthResolution, "Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				WavelengthResolution -> 2.4 * Nanometer
			];
			Download[protocol, WavelengthResolutions],
			{2.4 * Nanometer, 2.4 * Nanometer, 2.4 * Nanometer},
			Variables :> {protocol}
		],
		Example[
			{Options, UVFilter, "Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				UVFilter -> True
			];
			Download[protocol, UVFilters],
			{True, True, True},
			Variables :> {protocol}
		],
		Example[
			{Options, AbsorbanceSamplingRate, "Specify the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AbsorbanceSamplingRate -> 10 / Second
			];
			Download[protocol, AbsorbanceSamplingRates],
			{10. * 1 / Second, 10. * 1 / Second, 10. * 1 / Second},
			Variables :> {protocol}
		],
		Example[
			{Options, DwellTime, "Specify dwell time when scaning the sample in single or a list or single wavelengths when using qqq as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				AcquisitionMode -> MultipleReactionMonitoring,
				MassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				FragmentMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				DwellTime -> 150 Millisecond
			];
			Download[protocol, DwellTimes],
			{
				{
					{Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, MassDetectionStepSize, "Specify the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				MassDetectionStepSize -> {{0.1 Gram / Mole}, {0.2 Gram / Mole}, {0.3 Gram / Mole}}];
			Download[protocol, MassDetectionStepSizes],
			{
				{Quantity[0.1, ("Grams") / ("Moles")]},
				{Quantity[0.2, ("Grams") / ("Moles")]},
				{Quantity[0.3, ("Grams") / ("Moles")]}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, CollisionCellExitVoltage, "Specify the value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				CollisionCellExitVoltage -> {{6 Volt}, {6 Volt}, {6 Volt}}
			];
			Download[protocol, CollisionCellExitVoltages],
			{{6 Volt}, {6 Volt}, {6 Volt}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, NeutralLoss, "Specify a neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				NeutralLoss -> {{123 Gram / Mole}}
			];
			Download[protocol, NeutralLosses],
			{{123 Gram / Mole}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, MultipleReactionMonitoringAssays, "Specify the ion corresponding to the compound of interest is targetted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				MultipleReactionMonitoringAssays -> {{{{456 Gram / Mole, 60Volt, 123Gram / Mole, 200Millisecond}}}}
			];
			Download[protocol, MultipleReactionMonitoringAssays],
			{{<|MS1Mass -> {Quantity[456, ("Grams") / ("Moles")]},
				CollisionEnergy -> {Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200, "Milliseconds"]}|>}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentLCMS[
				(* Small Molecule HPLC Standard Mix *)
				{Model[Sample, StockSolution, Standard, "id:01G6nvw7AOYE"], Model[Sample, StockSolution, Standard, "id:01G6nvw7AOYE"]},
				PreparedModelAmount -> 1 Milliliter,
				(* 96-well 2mL Deep Well Plate *)
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				(* Small Molecule HPLC Standard Mix *)
				{ObjectP[Model[Sample, StockSolution, Standard, "id:01G6nvw7AOYE"]]..},
				(* 96-well 2mL Deep Well Plate *)
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentLCMS[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True
			],
			ObjectP[Object[Protocol, LCMS]]
		],
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples for ExperimentLCMS:"},
			ExperimentLCMS["My NestedIndexMatching Sample",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My NestedIndexMatching Sample",
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source -> {
							Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
							Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID]
						},
						Destination -> "My NestedIndexMatching Sample",
						Amount -> {300 Microliter, 300 Microliter}
					]
				}
			],
			ObjectP[Object[Protocol, LCMS]],
			TimeConstraint -> 1000
		],
		Example[
			{Options, AliquotSampleLabel, "Specified the label of the samples, after they are aliquotted:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				AliquotSampleLabel -> Null,
				Output -> Options
			];
			Lookup[options, AliquotSampleLabel],
			{Null},
			Variables :> {options}
		],
		(* Standards *)
		Example[
			{Options, Standard, "Specify the sample to use as a standard:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
				StandardFrequency -> FirstAndLast
			];
			Download[protocol, Standards],
			{
				LinkP[Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"]],
				LinkP[Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"]]
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardAnalytes, "Specify the analyte for standards:"},
			options = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
				StandardAnalytes -> {Model[Molecule, "id:BYDOjvG676xE"]},
				Output -> Options
			];
			Lookup[options, StandardAnalytes],
			{Model[Molecule, "id:BYDOjvG676xE"]},
			Variables :> {options}
		],
		Example[
			{Options, Standard, "Specify multiple standards:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					Standard -> {
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
					}
				][[1]];
				Lookup[packet, Replace[Standards]]
			),
			{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]]..},
			Variables :> {packet}
		],
		Example[
			{Options, StandardFrequency, "Specify the frequency at which standards are run:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					StandardFrequency -> 2,
					BlankFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Standard, Sample, Blank, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, StandardFrequency, "StandardFrequency -> GradientChange will run a standard first, last, and before any unique gradient:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					StandardFrequency -> GradientChange,
					BlankFrequency -> FirstAndLast,
					GradientB -> {10 Percent, 20 Percent, 30 Percent},
					Upload -> False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			(* ColumnPrime is added because ColumnRefreshFrequency is default GradientChange *)
			{ColumnPrime, Blank, Standard, Sample, ColumnPrime, Standard, Sample, ColumnPrime, Standard, Sample, Blank, Standard, ColumnFlush},
			Variables :> {packets},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, StandardFrequency, "StandardFrequency -> First will only run a standard first:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					StandardFrequency -> First,
					BlankFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Blank, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, StandardFrequency, "StandardFrequency -> Last will only run a standard last:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					StandardFrequency -> Last,
					BlankFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, StandardFrequency, "StandardFrequency -> FirstAndLast will run a standard first and last:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					StandardFrequency -> FirstAndLast,
					BlankFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, StandardFrequency, "StandardFrequency -> None will run no standards:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					StandardFrequency -> None,
					BlankFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Sample, Sample, Sample, Blank, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, StandardInjectionVolume, "Specify the volume of standard to inject:"},
			packet = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				StandardInjectionVolume -> 15 Microliter,
				Upload -> False
			][[1]];
			Lookup[packet, Replace[StandardSampleVolumes]],
			{15 Microliter, 15 Microliter},
			Variables :> {packet}
		],
		Example[
			{Options, StandardColumnTemperature, "Specify the column temperature to run standard sample at:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Standard -> Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					StandardColumnTemperature -> 40 Celsius,
					Upload -> False
				][[1]];
				Lookup[packet, Replace[StandardColumnTemperatures]]
			),
			{40 Celsius, 40 Celsius},
			Messages :> {Warning::SampleMustBeMoved},
			Variables :> {packet}
		],
		Example[
			{Options, StandardGradientA, "Specify the buffer A gradient for each standard:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientA
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, StandardGradientB, "Specify the buffer B gradient for each standard:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientB -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientB
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, StandardGradientC, "Specify the buffer C gradient for each standard:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientC -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientC
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, StandardGradientD, "Specify the buffer D gradient for each standard:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientD -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientD
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, StandardFlowRate, "Specify the flow rate for each standard:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardFlowRate -> 1 Milliliter / Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardFlowRate
				]
			),
			1 Milliliter / Minute,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, StandardGradient, "Specify the method to use for the standards:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					StandardGradient -> Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID],
					Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
				][[1]];
				Lookup[packet, {Replace[Standards], Replace[StandardGradientMethods]}]
			),
			{{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]]..}, {LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]]..}},
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, StandardIonMode, "Specify if positively or negatively charged ions are analyzed for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIonMode -> Positive
			];
			Download[protocol, StandardIonModes],
			{Positive, Positive},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardMassSpectrometryMethod, "Specify previous instruction(s) for the analyte ionization, selection, fragmentation, and detection for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardMassSpectrometryMethod -> Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]
			];
			Download[protocol, {StandardInclusionMasses, StandardInclusionCollisionEnergies}],
			{
				{
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					},
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					}
				},
				{
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					},
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::OverwritingMassAcquisitionMethod}
		],
		Example[
			{Options, StandardESICapillaryVoltage, "Specify the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardESICapillaryVoltage -> {
					1 Kilovolt,
					2 Kilovolt,
					0.8 Kilovolt
				}
			];
			Download[protocol, StandardESICapillaryVoltages],
			{
				Quantity[1000., "Volts"],
				Quantity[2000., "Volts"],
				Quantity[800., "Volts"],
				Quantity[1000., "Volts"],
				Quantity[2000., "Volts"],
				Quantity[800., "Volts"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardDeclusteringVoltage, "Specify the voltage between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardDeclusteringVoltage -> {
					100. Volt,
					75. Volt,
					40. Volt
				}
			];
			Download[protocol, StandardDeclusteringVoltages],
			{
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"],
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardStepwaveVoltage, "Specify voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardStepwaveVoltage -> {
					100. Volt,
					75. Volt,
					40. Volt
				}
			];
			Download[protocol, StandardStepwaveVoltages],
			{
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"],
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardIonGuideVoltage, "Specify the electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIonGuideVoltage -> {
					8 Volt,
					-8 Volt,
					-9 Volt
				}
			];
			Download[protocol, StandardIonGuideVoltages],
			{
				8 Volt,
				-8 Volt,
				-9 Volt,
				8 Volt,
				-8 Volt,
				-9 Volt
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardSourceTemperature, "Specify the temperature setting of the source block for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardSourceTemperature -> {
					100 Celsius,
					75 Celsius,
					130 Celsius
				}
			];
			Download[protocol, StandardSourceTemperatures],
			{
				Quantity[100., "DegreesCelsius"],
				Quantity[75., "DegreesCelsius"],
				Quantity[130., "DegreesCelsius"],
				Quantity[100., "DegreesCelsius"],
				Quantity[75., "DegreesCelsius"],
				Quantity[130., "DegreesCelsius"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardDesolvationTemperature, "Specify the temperature setting for heat element of the drying sheath gas for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardDesolvationTemperature -> {
					650 Celsius,
					500 Celsius,
					400 Celsius
				}
			];
			Download[protocol, StandardDesolvationTemperatures],
			{
				Quantity[650., "DegreesCelsius"],
				Quantity[500., "DegreesCelsius"],
				Quantity[400., "DegreesCelsius"],
				Quantity[650., "DegreesCelsius"],
				Quantity[500., "DegreesCelsius"],
				Quantity[400., "DegreesCelsius"]
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardDesolvationGasFlow, "Specify the nitrogen gas flow ejected around the ESI capillary, used for solvent evaporation to produce single gas phase ions from the ion spray for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardDesolvationGasFlow -> {
					1200 Liter / Hour,
					1000 Liter / Hour,
					800 Liter / Hour
				}
			];
			Download[protocol, StandardDesolvationGasFlows],
			{
				Quantity[1200., "Liters" / "Hours"],
				Quantity[1000., "Liters" / "Hours"],
				Quantity[800., "Liters" / "Hours"],
				Quantity[1200., "Liters" / "Hours"],
				Quantity[1000., "Liters" / "Hours"],
				Quantity[800., "Liters" / "Hours"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardConeGasFlow, "Specify the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block) for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardConeGasFlow -> {
					300 Liter / Hour,
					30 Liter / Hour,
					100 Liter / Hour
				}
			];
			Download[protocol, StandardConeGasFlows],
			{
				Quantity[300., "Liters" / "Hours"],
				Quantity[30., "Liters" / "Hours"],
				Quantity[100., "Liters" / "Hours"],
				Quantity[300., "Liters" / "Hours"],
				Quantity[30., "Liters" / "Hours"],
				Quantity[100., "Liters" / "Hours"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardAcquisitionWindow, "Specify the time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAcquisitionWindow -> 0 Minute ;; 5 Minute
			];
			Download[protocol, StandardAcquisitionWindows],
			{
				{{Quantity[0, "Minutes"], Quantity[5, "Minutes"]}},
				{{Quantity[0, "Minutes"], Quantity[5, "Minutes"]}}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardAcquisitionMode, "Specify whether spectra to be collected should depend on properties of measured mass spectrum of the intact ions (DataDependent), systematically scan through all of the intact ions (DataIndependent), or to scan specified ions (Null) as set by MassDetection and/or FragmentMassDetection for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAcquisitionMode -> {DataDependent, MS1MS2ProductIonScan, MS1FullScan}
			];
			Download[protocol, StandardAcquisitionModes],
			{
				{DataDependent, MS1MS2ProductIonScan, MS1FullScan},
				{DataDependent, MS1MS2ProductIonScan, MS1FullScan}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardFragment, "Specify Determines whether to have ions dissociate upon collision with neutral gas species and to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS) for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardFragment -> {True, False, True}
			];
			Download[protocol, StandardFragmentations],
			{
				{True, False, True},
				{True, False, True}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. For Fragmentation->True, the intact ions will be selected for fragmentation for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardMassDetection -> {
					678 Dalton,
					200 Dalton ;; 3000Dalton,
					{450 Dalton, 567 Dalton}
				}
			];
			Download[protocol, {StandardMinMasses, StandardMaxMasses, StandardMassSelections}],
			{
				{
					{Null, Quantity[200, "Grams" / "Moles"], Null},
					{Null, Quantity[200, "Grams" / "Moles"], Null}
				},
				{
					{Null, Quantity[3000, "Grams" / "Moles"], Null},
					{Null, Quantity[3000, "Grams" / "Moles"], Null}
				},
				{
					{
						{Quantity[678, "Grams" / "Moles"]},
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					},
					{
						{Quantity[678, "Grams" / "Moles"]},
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardScanTime, "Specify the duration of time allowed to pass for each spectral acquisition for a given state of the instrument for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, StandardScanTimes],
			{
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]},
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardFragmentMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardFragmentMassDetection -> {All, 200 Dalton ;; 3000 Dalton, {450 Dalton, 567 Dalton}}
			];
			Download[protocol, {StandardFragmentMinMasses, StandardFragmentMaxMasses, StandardFragmentMassSelections}],
			{
				{
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					}
				},
				{
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					}
				},
				{
					{
						Null,
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					},
					{
						Null,
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardCollisionEnergy, "Specify the voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardCollisionEnergy -> {{100 Volt}, {30 Volt}, {55 Volt}}
			];
			Download[protocol, {
				StandardCollisionEnergies,
				StandardLowCollisionEnergies,
				StandardHighCollisionEnergies,
				StandardFinalLowCollisionEnergies,
				StandardFinalHighCollisionEnergies
			}],
			{{{{Quantity[100, "Volts"]}, {Quantity[30, "Volts"]}, {Quantity[55,
				"Volts"]}}, {{Quantity[100, "Volts"]}, {Quantity[30,
				"Volts"]}, {Quantity[55, "Volts"]}}}, {{Null, Null, Null}, {Null,
				Null, Null}}, {{Null, Null, Null}, {Null, Null, Null}}, {{Null,
				Null, Null}, {Null, Null, Null}}, {{Null, Null, Null}, {Null, Null,
				Null}}},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardCollisionEnergyMassProfile, "Specify the relationship of collision energy with the MassDetection for standard samples:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardCollisionEnergyMassProfile -> {
					60 Volt ;; 90Volt,
					(*this should be split across the acquisition windows*)
					{30 Volt ;; 100Volt, 60 Volt ;; 150Volt},
					60 Volt ;; 150Volt
				}
			];
			Download[protocol, {
				StandardCollisionEnergies,
				StandardLowCollisionEnergies,
				StandardHighCollisionEnergies,
				StandardFinalLowCollisionEnergies,
				StandardFinalHighCollisionEnergies
			}],
			{
				{
					{{40 Volt}},
					{Null, Null},
					{{40 Volt}},
					{{40 Volt}},
					{Null, Null},
					{{40 Volt}}
				},
				{
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]}
				},
				{
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]},
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]}
				},
				{
					{Null},
					{Null, Null},
					{Null},
					{Null},
					{Null, Null},
					{Null}
				},
				{
					{Null},
					{Null, Null},
					{Null},
					{Null},
					{Null, Null},
					{Null}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardCollisionEnergyMassScan, "Specify Collision energy profile at the end of the scan from CollisionEnergy or CollisionEnergyScanProfile, as related to analyte mass:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardCollisionEnergyMassScan -> {
					60Volt ;; 90Volt,
					(*this should be split across the acquisition windows*)
					{30 Volt ;; 100Volt, 100Volt ;; 150Volt},
					60 Volt ;; 150Volt
				}
			];
			Download[protocol, {
				StandardFinalLowCollisionEnergies,
				StandardFinalHighCollisionEnergies
			}],
			{
				{
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[100, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[100, "Volts"]},
					{Quantity[60, "Volts"]}
				},
				{
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]},
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardFragmentScanTime, "Specify the duration of the spectral scanning for each fragmentation of an intact ion for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardFragmentScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, StandardFragmentScanTimes],
			{
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]},
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardAcquisitionSurvey, "Specify the number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAcquisitionSurvey -> {
					5,
					10,
					20
				}
			];
			Download[protocol, StandardAcquisitionSurveys],
			{{5, 10, 20}, {5, 10, 20}},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardMinimumThreshold, "Specify the minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardMinimumThreshold -> {
					80000 ArbitraryUnit,
					100000 ArbitraryUnit,
					200000 ArbitraryUnit
				}
			];
			Download[protocol, StandardMinimumThresholds],
			{
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardAcquisitionLimit, "Specify the maximum number of total ions for a specific intact ion. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAcquisitionLimit -> {
					1000000 ArbitraryUnit,
					2000000 ArbitraryUnit,
					500000 ArbitraryUnit
				}
			];
			Download[protocol, StandardAcquisitionLimits],
			{
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardCycleTimeLimit, "Specify the maximum duration for spectral scan measurement of fragment ions, as dictated by the initial survey in the first scan for each standard measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardCycleTimeLimit -> {
					1 Second,
					2 Second,
					10 Second
				}
			];
			Download[protocol, StandardCycleTimeLimits],
			{
				{Quantity[1, "Seconds"], Quantity[2, "Seconds"], Quantity[10, "Seconds"]},
				{Quantity[1, "Seconds"], Quantity[2, "Seconds"], Quantity[10, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardExclusionMass, "Specify the intact ions to omit for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardExclusionMass -> {
					{All, 500 Gram / Mole},
					{
						{
							{Once, 789 Gram / Mole},
							{Once, 899 Gram / Mole}
						},
						{
							{All, 678 Gram / Mole},
							{All, 567 Gram / Mole},
							{All, 902 Gram / Mole}
						}
					},
					{
						{Once, 456 Gram / Mole},
						{Once, 901 Gram / Mole}
					}
				}
			];
			Download[protocol, StandardExclusionMasses],
			{
				{{{All, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Once, Quantity[789, "Grams" / "Moles"]},
						{Once, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{All, Quantity[678, "Grams" / "Moles"]},
						{All, Quantity[567, "Grams" / "Moles"]},
						{All, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Once, Quantity[456, "Grams" / "Moles"]}},
					{{Once, Quantity[901, "Grams" / "Moles"]}}
				},
				{{{All, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Once, Quantity[789, "Grams" / "Moles"]},
						{Once, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{All, Quantity[678, "Grams" / "Moles"]},
						{All, Quantity[567, "Grams" / "Moles"]},
						{All, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Once, Quantity[456, "Grams" / "Moles"]}},
					{{Once, Quantity[901, "Grams" / "Moles"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardExclusionMassTolerance, "Specify the range above and below each ion in ExclusionMasses to consider for omission for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardExclusionMassTolerance -> {
					1 Gram / Mole,
					{2 Gram / Mole, 0.7 Gram / Mole},
					0.5 Gram / Mole
				}
			];
			Download[protocol, StandardExclusionMassTolerances],
			{
				{Quantity[1, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[0.7, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[0.7, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardExclusionRetentionTimeTolerance, "Specify the range of time above and below the RetentionTime to consider for omission for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardExclusionRetentionTimeTolerance -> {
					1 Second,
					{2 Second, 10 Second},
					20 Second
				}
			];
			Download[protocol, StandardExclusionRetentionTimeTolerances],
			{
				{Quantity[1, "Seconds"]},
				{Quantity[2, "Seconds"], Quantity[10, "Seconds"]},
				{Quantity[20, "Seconds"]},
				{Quantity[1, "Seconds"]},
				{Quantity[2, "Seconds"], Quantity[10, "Seconds"]},
				{Quantity[20, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionDomain, "Specify when the InclusionMass applies with respective to the chromatogram for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					},
					{
						{
							Full,
							10Minute ;; 20Minute
						},
						{
							2 Minute ;; 5 Minute
						}
					}
				}
			];
			Download[protocol, StandardInclusionDomains],
			{
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				},
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionMass, "Specify the ions to prioritize during the survey scan for further fragmentation for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionMass -> {
					{Only, 500 Gram / Mole},
					{
						{
							{Preferential, 789 Gram / Mole},
							{Preferential, 899 Gram / Mole}
						},
						{
							{Only, 678 Gram / Mole},
							{Only, 567 Gram / Mole},
							{Only, 902 Gram / Mole}
						}
					},
					{
						{Preferential, 456 Gram / Mole},
						{Preferential, 901 Gram / Mole}
					}
				}
			];
			Download[protocol, StandardInclusionMasses],
			{
				{{{Only, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Preferential, Quantity[789, "Grams" / "Moles"]},
						{Preferential, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{Only, Quantity[678, "Grams" / "Moles"]},
						{Only, Quantity[567, "Grams" / "Moles"]},
						{Only, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Preferential, Quantity[456, "Grams" / "Moles"]}},
					{{Preferential, Quantity[901, "Grams" / "Moles"]}}
				},
				{{{Only, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Preferential, Quantity[789, "Grams" / "Moles"]},
						{Preferential, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{Only, Quantity[678, "Grams" / "Moles"]},
						{Only, Quantity[567, "Grams" / "Moles"]},
						{Only, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Preferential, Quantity[456, "Grams" / "Moles"]}},
					{{Preferential, Quantity[901, "Grams" / "Moles"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionCollisionEnergy, "Specify an overriding collision energy value that can be applied to the StandardInclusionMass for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionCollisionEnergy -> {
					100 Volt,
					{
						{
							75 Volt,
							45 Volt
						},
						{
							67 Volt,
							56 Volt,
							90 Volt
						}
					},
					{
						45 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, StandardInclusionCollisionEnergies],
			{
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}},
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionDeclusteringVoltage, "Specify an overriding source voltage value that can be applied to the InclusionMass for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionDeclusteringVoltage -> {
					100 Volt,
					{
						{
							75 Volt,
							45 Volt
						},
						{
							67 Volt,
							56 Volt,
							90 Volt
						}
					},
					{
						45 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, StandardInclusionDeclusteringVoltages],
			{
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}},
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionChargeState, "Specify the maximum charge state of the InclusionMass to also consider for inclusion for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionChargeState -> {
					{1, 2},
					{
						{1, 2},
						{1, 2, 3}
					},
					{0, 1}
				}
			];
			Download[protocol, StandardInclusionChargeStates],
			{
				{{1}, {2}},
				{{1, 2}, {1, 2, 3}},
				{{0}, {1}},
				{{1}, {2}},
				{{1, 2}, {1, 2, 3}},
				{{0}, {1}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionScanTime, "Specify an overriding scan time duration that can be applied to the InclusionMass for the consequent fragmentation for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionScanTime -> {
					2 Second,
					{
						{
							3 Second,
							5 Second
						},
						{
							0.5 Second,
							0.2 Second,
							1 Second
						}
					},
					{
						4.5 Second,
						9 Second
					}
				}
			];
			Download[protocol, StandardInclusionScanTimes],
			{
				{{Quantity[2, "Seconds"]}},
				{
					{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
					{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
				},
				{{Quantity[4.5, "Seconds"]}, {Quantity[9, "Seconds"]}},
				{{Quantity[2, "Seconds"]}},
				{
					{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
					{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
				},
				{{Quantity[4.5, "Seconds"]}, {Quantity[9, "Seconds"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardInclusionMassTolerance, "Specify the range above and below each ion in InclusionMasses to consider for prioritization for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardInclusionMassTolerance -> {
					{2 Gram / Mole, 1 Gram / Mole},
					{6 Gram / Mole},
					3 Gram / Mole
				}
			];
			Download[protocol, StandardInclusionMassTolerances],
			{
				{Quantity[2, "Grams" / "Moles"], Quantity[1, "Grams" / "Moles"]},
				{Quantity[6, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[1, "Grams" / "Moles"]},
				{Quantity[6, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardSurveyChargeStateExclusion, "Specify if to automatically fill ChargeState exclusion related options and leave out redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardSurveyChargeStateExclusion -> {
					{True, False},
					{True},
					False
				}
			];
			Download[protocol, StandardChargeStateSelections],
			{
				{{1, 2}, Null},
				{{1, 2}},
				{Null},
				{{1, 2}, Null},
				{{1, 2}},
				{Null}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardSurveyIsotopeExclusion, "Specify if to automatically fill MassIsotope exclusion related options and leave out redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardSurveyIsotopeExclusion -> {
					{
						True,
						False
					},
					{
						True
					},
					False
				}
			];
			Download[protocol, {StandardIsotopeMassDifferences, StandardIsotopeRatios, StandardIsotopeDetectionMinimums}],
			{
				{
					{{Quantity[1, "Grams" / "Moles"]}, Null},
					{{Quantity[1, "Grams" / "Moles"]}},
					{Null},
					{{Quantity[1, "Grams" / "Moles"]}, Null},
					{{Quantity[1, "Grams" / "Moles"]}},
					{Null}
				},
				{
					{{0.1}, Null},
					{{0.1}},
					{Null},
					{{0.1}, Null},
					{{0.1}},
					{Null}
				},
				{
					{{Quantity[10, "Seconds"^(-1)]}, Null},
					{{Quantity[10, "Seconds"^(-1)]}},
					{Null},
					{{Quantity[10, "Seconds"^(-1)]}, Null},
					{{Quantity[10, "Seconds"^(-1)]}},
					{Null}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardChargeStateExclusionLimit, "Specify the number of ions to survey first with exclusion by ionic state for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardChargeStateExclusionLimit -> {
					{5, 6},
					{10},
					3
				}
			];
			Download[protocol, StandardChargeStateLimits],
			{{5, 6}, {10}, {3}, {5, 6}, {10}, {3}},
			Variables :> {protocol}
		],
		(* See note on ChargeStateExclusion about how the test below resolved pre and post-ExpandIndexMatchedInputs update on April 2025 *)
		Example[
			{Options, StandardChargeStateExclusion, "Specify the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardChargeStateExclusion -> {
					{1, 2, 3},
					{1, 2, 3, 4}
				}
			];
			Download[protocol, StandardChargeStateSelections],
			{
				(* Injection 1 *)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4}
				},
				(* Injection 2*)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardChargeStateMassTolerance, "Specify the range of m/z to consider for exclusion by ionic state property for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardChargeStateMassTolerance -> {
					{
						2 Gram / Mole,
						2.5 Gram / Mole
					},
					{
						3 Gram / Mole
					},
					1 Gram / Mole
				}
			];
			Download[protocol, StandardChargeStateMassTolerances],
			{
				{Quantity[2, "Grams" / "Moles"], Quantity[2.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[2.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardIsotopicExclusion, "Specify The m/z difference between monoisotopic ions as a criterion for survey exclusion for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIsotopicExclusion -> {
					{
						{1 Gram / Mole, 2 Gram / Mole},
						{1 Gram / Mole}
					},
					{
						{1 Gram / Mole, 2 Gram / Mole}
					},
					{1 Gram / Mole}
				}
			];
			Download[protocol, StandardIsotopeMassDifferences],
			{
				{
					{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
					{Quantity[1, "Grams" / "Moles"]}
				},
				{{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]}},
				{{Quantity[1, "Grams" / "Moles"]}},
				{
					{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
					{Quantity[1, "Grams" / "Moles"]}
				},
				{{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]}},
				{{Quantity[1, "Grams" / "Moles"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardIsotopeRatioThreshold, "Specify this minimum relative magnitude between monoisotopic ions must be met for exclusion for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIsotopeRatioThreshold -> {
					{
						{0.1, 0.05},
						{0.2}
					},
					{
						{0.3, 0.25}
					},
					{0.15}
				}
			];
			Download[protocol, StandardIsotopeRatios],
			{
				{{0.1, 0.05}, {0.2}},
				{{0.3, 0.25}},
				{{0.15}},
				{{0.1, 0.05}, {0.2}},
				{{0.3, 0.25}},
				{{0.15}}
			},
			Variables :> {protocol}
		],
		(* See the Note on IsotopeDetectionMinimum for how this resolved pre and post-ExpandIndexMatchedInputs updates in April of 2025 *)
		Example[
			{Options, StandardIsotopeDetectionMinimum, "Specify the acquisition rate of a given intact mass to consider for isotope exclusion in the survey for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIsotopeDetectionMinimum -> {
					{10 1 / Second, 20 1 / Second},
					{15 1 / Second},
					25 1 / Second
				}
			];
			Download[protocol, StandardIsotopeDetectionMinimums],
			{
				(* Standard 1 *)
				{
					(* Acquisition Window 1 *)
					{10/Second, 20/Second},
					(* Acquisition Window 2 *)
					{15/Second},
					(* Acquisition Window 3 *)
					{25/Second}
				},
				(* Standard 2 *)
				{
					(* Acquisition Window 1 *)
					{10/Second, 20/Second},
					(* Acquisition Window 2 *)
					{15/Second},
					(* Acquisition Window 3 *)
					{25/Second}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardIsotopeMassTolerance, "Specify the range of m/z around a mass to consider for exclusion for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIsotopeMassTolerance -> {
					{
						1 Gram / Mole,
						2 Gram / Mole
					},
					{
						0.5 Gram / Mole
					},
					3 Gram / Mole
				}
			];
			Download[protocol, StandardIsotopeMassTolerances],
			{
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardIsotopeRatioTolerance, "Specify the range of relative magnitude around IsotopeRatio to consider for isotope exclusion for standard measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardIsotopeRatioTolerance -> {
					{
						10 Percent,
						25 Percent
					}
				}
			];
			Download[protocol, StandardIsotopeRatioTolerances],
			{
				{Quantity[10, "Percent"], Quantity[25, "Percent"]},
				{Quantity[10, "Percent"], Quantity[25, "Percent"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardAbsorbanceWavelength, "Specify the physical properties of light passed through the flow for the PhotoDiodeArray (PDA) Detector for each standard measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAbsorbanceWavelength -> Span[300 Nanometer, 400 Nanometer]
			];
			Download[protocol, {StandardMinAbsorbanceWavelengths, StandardMaxAbsorbanceWavelengths}],
			{{300. Nanometer, 300. Nanometer}, {400. Nanometer, 400. Nanometer}},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardWavelengthResolution, "Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for each standard measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardWavelengthResolution -> 2.4 * Nanometer
			];
			Download[protocol, StandardWavelengthResolutions],
			{ 2.4 * Nanometer, 2.4 * Nanometer},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardUVFilter, "Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors for each standard measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardUVFilter -> True
			];
			Download[protocol, StandardUVFilters],
			{True, True},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardAbsorbanceSamplingRate, "Specify the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time for each standard measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAbsorbanceSamplingRate -> 10 / Second
			];
			Download[protocol, StandardAbsorbanceSamplingRates],
			{Quantity[10., "Seconds"^(-1)], Quantity[10., "Seconds"^(-1)]},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardStorageCondition, "Specify the storage condition in which the standards should be stored after the protocol completes:"},
			(
				protocol = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Standard -> {
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
					},
					StandardStorageCondition -> Refrigerator
				];
				Download[protocol, StandardsStorageConditions]
			),
			{Refrigerator..},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardDwellTime, "Specify dwell time when scaning the sample in single or a list or single wavelengths when using qqq as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				StandardAcquisitionMode -> MultipleReactionMonitoring,
				StandardMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				StandardFragmentMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				StandardDwellTime -> 150 Millisecond
			];
			Download[protocol, StandardDwellTimes],
			{
				{{Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"]}},
				{{Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, StandardMassDetectionStepSize, "Specify the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				StandardMassDetectionStepSize -> {{0.2 Gram / Mole}}];
			Download[protocol, StandardMassDetectionStepSizes],
			{
				{Quantity[0.2, ("Grams") / ("Moles")]},
				{Quantity[0.2, ("Grams") / ("Moles")]}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardCollisionCellExitVoltage, "Specify the value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				StandardCollisionCellExitVoltage -> {{6 Volt}}
			];
			Download[protocol, StandardCollisionCellExitVoltages],
			{{6 Volt}, {6 Volt}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardNeutralLoss, "Specify a neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				StandardNeutralLoss -> {{123 Gram / Mole}}
			];
			Download[protocol, StandardNeutralLosses],
			{
				{Quantity[123, ("Grams") / ("Moles")]},
				{Quantity[123, ("Grams") / ("Moles")]}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, StandardMultipleReactionMonitoringAssays, "Specify the ion corresponding to the compound of interest is targetted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				StandardMultipleReactionMonitoringAssays -> {{{{456 Gram / Mole, 60Volt, 123Gram / Mole, 200Millisecond}}}}
			];
			Download[protocol, StandardMultipleReactionMonitoringAssays],
			{{<|MS1Mass -> {Quantity[456, ("Grams") / ("Moles")]},
				CollisionEnergy -> {Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200,
					"Milliseconds"]}|>}, {<|MS1Mass -> {Quantity[456, ("Grams") / (
				"Moles")]}, CollisionEnergy -> {Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200, "Milliseconds"]}|>}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		(* Blanks *)
		(* Blank Options *)
		Example[
			{Options, Blank, "Specify a blank to run:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet, {Replace[Blanks], Replace[BlankSampleVolumes], Replace[BlankGradientMethods]}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]]},
				{VolumeP},
				{ObjectP[]}
			},
			Variables :> {packet}
		],
		Example[
			{Options, Blank, "If any blank option is specified but Blank is not, Blank resolves to BufferA:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					BufferA -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankInjectionVolume -> 10 Microliter,
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet, {Replace[Blanks], Replace[BlankSampleVolumes], Replace[BlankGradientMethods]}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]]},
				{10 Microliter},
				{ObjectP[]}
			},
			Variables :> {packet}
		],
		Example[
			{Options, Blank, "Multiple blanks can be specified to run:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Blank -> {
						Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
						Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
					},
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet, {Replace[Blanks], Replace[BlankSampleVolumes], Replace[BlankGradientMethods]}]
			),
			{
				{
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]]
				},
				{VolumeP, VolumeP},
				{ObjectP[], ObjectP[]}
			},
			Variables :> {packet}
		],
		Example[
			{Options, Blank, "Blank options will expand to match length of the Blank option value:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Blank -> {
						Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
						Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
					},
					BlankInjectionVolume -> 10 Microliter,
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet, {Replace[Blanks], Replace[BlankSampleVolumes], Replace[BlankGradientMethods]}]
			),
			{
				{
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]]
				},
				{10 Microliter, 10 Microliter},
				{ObjectP[], ObjectP[]}
			},
			Variables :> {packet}
		],
		Example[
			{Options, BlankFrequency, "Specify the frequency at which blanks are run:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					BlankFrequency -> 2,
					StandardFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Blank, Sample, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, BlankFrequency, "BlankFrequency -> GradientChange will run a blank first, last, and before any unique gradient:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankFrequency -> GradientChange,
				StandardFrequency -> FirstAndLast,
				GradientB -> {10 Percent, 20 Percent, 30 Percent}
			];
			Download[protocol, InjectionTable[[All, Type]]],
			{ColumnPrime, Blank, Standard, Sample, ColumnPrime, Blank, Sample, ColumnPrime, Blank, Sample, Blank, Standard, ColumnFlush},
			Variables :> {protocol},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, BlankFrequency, "BlankFrequency -> First will only run a blank first:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					BlankFrequency -> First,
					StandardFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, BlankFrequency, "BlankFrequency -> Last will only run a blank last:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					BlankFrequency -> Last,
					StandardFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Standard, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, BlankFrequency, "BlankFrequency -> FirstAndLast will run a blank first and last:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					BlankFrequency -> FirstAndLast,
					StandardFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, BlankFrequency, "BlankFrequency -> None will run no blanks:"},
			(
				packets = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					BlankFrequency -> None,
					StandardFrequency -> FirstAndLast,
					Upload -> False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Standard, Sample, Sample, Sample, Standard, ColumnFlush},
			Variables :> {packets}
		],
		Example[
			{Options, BlankInjectionVolume, "Specify the volume of each blank to inject:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankInjectionVolume -> 10 Microliter,
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet, {Replace[Blanks], Replace[BlankSampleVolumes], Replace[BlankGradientMethods]}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]]},
				{10 Microliter},
				{ObjectP[]}
			},
			Variables :> {packet}
		],
		Example[
			{Options, BlankStorageCondition, "Specify the storage condition in which the blanks should be stored after the protocol completes:"},
			(
				protocol = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankStorageCondition -> Refrigerator
				];
				Download[protocol, BlanksStorageConditions]
			),
			{Refrigerator..},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankGradient, "Specify the method to use for the blank samples:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BlankGradient -> Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID],
					Blank -> Model[Sample, "Milli-Q water"]
				][[1]];
				Lookup[packet, Replace[BlankGradientMethods]]
			),
			{LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]]..},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, BlankAnalytes, "Specify which molecule will be used as the analyte for the blank:"},
			options = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Blank -> Model[Sample, "Milli-Q water"],
				BlankAnalytes -> {Model[Molecule, "id:vXl9j57PmP5D"]},
				Output -> Options
			];
			Lookup[options, BlankAnalytes],
			{Model[Molecule, "id:vXl9j57PmP5D"]},
			Variables :> {options}
		],
		Example[
			{Options, BlankColumnTemperature, "Specify the column temperature to run blank samples at:"},
			(
				protocol = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Blank -> Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					BlankColumnTemperature -> 40 Celsius
				];
				Download[protocol, BlankColumnTemperatures]
			),
			{40. Celsius, 40. Celsius},
			Messages :> {Warning::SampleMustBeMoved},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankGradientA, "Specify the buffer A gradient for each blank sample:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientA
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, BlankGradientB, "Specify the buffer B gradient for each blank:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientB -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientB
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, BlankGradientC, "Specify the buffer C gradient for each blank:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientC -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientC
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, BlankGradientD, "Specify the buffer D gradient for each blank:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientD -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientD
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, BlankFlowRate, "Specify the flow rate for each blank:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankFlowRate -> 1 Milliliter / Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankFlowRate
				]
			),
			1 Milliliter / Minute,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],

		Example[
			{Options, BlankIonMode, "Specify if positively or negatively charged ions are analyzed for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIonMode -> Positive
			];
			Download[protocol, BlankIonModes],
			{Positive, Positive},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankMassSpectrometryMethod, "Specify previous instruction(s) for the analyte ionization, selection, fragmentation, and detection for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankMassSpectrometryMethod -> Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]
			];
			Download[protocol, {BlankInclusionMasses, BlankInclusionCollisionEnergies}],
			{
				{
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					},
					{
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						},
						{
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]},
							{Preferential, Quantity[2, "Grams" / "Moles"]}
						}
					}
				},
				{
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					},
					{
						{Quantity[40, "Volts"], Quantity[40, "Volts"]},
						{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
					}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::OverwritingMassAcquisitionMethod}
		],
		Example[
			{Options, BlankESICapillaryVoltage, "Specify the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankESICapillaryVoltage -> {
					1 Kilovolt,
					2 Kilovolt,
					0.8 Kilovolt
				}
			];
			Download[protocol, BlankESICapillaryVoltages],
			{
				Quantity[1000., "Volts"],
				Quantity[2000., "Volts"],
				Quantity[800., "Volts"],
				Quantity[1000., "Volts"],
				Quantity[2000., "Volts"],
				Quantity[800., "Volts"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankDeclusteringVoltage, "Specify the voltage between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankDeclusteringVoltage -> {
					100 Volt,
					75 Volt,
					40 Volt
				}
			];
			Download[protocol, BlankDeclusteringVoltages],
			{
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"],
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankStepwaveVoltage, "Specify the voltage offset between the 1st and 2nd stage of the stepwave ion guide for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankStepwaveVoltage -> {
					100 Volt,
					75 Volt,
					40 Volt
				}
			];
			Download[protocol, BlankStepwaveVoltages],
			{
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"],
				Quantity[100., "Volts"],
				Quantity[75., "Volts"],
				Quantity[40., "Volts"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankIonGuideVoltage, "Specify the electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIonGuideVoltage -> {
					8 Volt,
					-8 Volt,
					-9 Volt
				}
			];
			Download[protocol, BlankIonGuideVoltages],
			{
				8 Volt,
				-8 Volt,
				-9 Volt,
				8 Volt,
				-8 Volt,
				-9 Volt
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankSourceTemperature, "Specify the temperature setting of the source block for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankSourceTemperature -> {
					100 Celsius,
					75 Celsius,
					130 Celsius
				}
			];
			Download[protocol, BlankSourceTemperatures],
			{
				Quantity[100., "DegreesCelsius"],
				Quantity[75., "DegreesCelsius"],
				Quantity[130., "DegreesCelsius"],
				Quantity[100., "DegreesCelsius"],
				Quantity[75., "DegreesCelsius"],
				Quantity[130., "DegreesCelsius"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankDesolvationTemperature, "Specify the temperature setting for heat element of the drying sheath gas for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankDesolvationTemperature -> {
					650 Celsius,
					500 Celsius,
					400 Celsius
				}
			];
			Download[protocol, BlankDesolvationTemperatures],
			{
				Quantity[650., "DegreesCelsius"],
				Quantity[500., "DegreesCelsius"],
				Quantity[400., "DegreesCelsius"],
				Quantity[650., "DegreesCelsius"],
				Quantity[500., "DegreesCelsius"],
				Quantity[400., "DegreesCelsius"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankDesolvationGasFlow, "Specify the nitrogen gas flow ejected around the ESI capillary, used for solvent evaporation to produce single gas phase ions from the ion spray for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankDesolvationGasFlow -> {
					1200 Liter / Hour,
					1000 Liter / Hour,
					800 Liter / Hour
				}
			];
			Download[protocol, BlankDesolvationGasFlows],
			{
				Quantity[1200., "Liters" / "Hours"],
				Quantity[1000., "Liters" / "Hours"],
				Quantity[800., "Liters" / "Hours"],
				Quantity[1200., "Liters" / "Hours"],
				Quantity[1000., "Liters" / "Hours"],
				Quantity[800., "Liters" / "Hours"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankConeGasFlow, "Specify the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block) for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankConeGasFlow -> {
					300 Liter / Hour,
					30 Liter / Hour,
					100 Liter / Hour
				}
			];
			Download[protocol, BlankConeGasFlows],
			{
				Quantity[300., "Liters" / "Hours"],
				Quantity[30., "Liters" / "Hours"],
				Quantity[100., "Liters" / "Hours"],
				Quantity[300., "Liters" / "Hours"],
				Quantity[30., "Liters" / "Hours"],
				Quantity[100., "Liters" / "Hours"]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankAcquisitionWindow, "Specify the time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAcquisitionWindow -> 0 Minute ;; 5 Minute
			];
			Download[protocol, BlankAcquisitionWindows],
			{
				{{Quantity[0, "Minutes"], Quantity[5, "Minutes"]}},
				{{Quantity[0, "Minutes"], Quantity[5, "Minutes"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankAcquisitionMode, "Specify whether spectra to be collected should depend on properties of measured mass spectrum of the intact ions (DataDependent), systematically scan through all of the intact ions (DataIndependent), or to scan specified ions (Null) as set by MassDetection and/or FragmentMassDetection for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAcquisitionMode -> {DataDependent, MS1MS2ProductIonScan, MS1FullScan}
			];
			Download[protocol, BlankAcquisitionModes],
			{
				{DataDependent, MS1MS2ProductIonScan, MS1FullScan},
				{DataDependent, MS1MS2ProductIonScan, MS1FullScan}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankFragment, "Specify Determines whether to have ions dissociate upon collision with neutral gas species and to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS) for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankFragment -> {True, False, True}
			];
			Download[protocol, BlankFragmentations],
			{
				{True, False, True},
				{True, False, True}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. For Fragmentation->True, the intact ions will be selected for fragmentation for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankMassDetection -> {
					678 Dalton,
					200 Dalton ;; 3000Dalton,
					{450 Dalton, 567 Dalton}
				}
			];
			Download[protocol, {BlankMinMasses, BlankMaxMasses, BlankMassSelections}],
			{
				{
					{Null, Quantity[200, "Grams" / "Moles"], Null},
					{Null, Quantity[200, "Grams" / "Moles"], Null}
				},
				{
					{Null, Quantity[3000, "Grams" / "Moles"], Null},
					{Null, Quantity[3000, "Grams" / "Moles"], Null}
				},
				{
					{
						{Quantity[678, "Grams" / "Moles"]},
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					},
					{
						{Quantity[678, "Grams" / "Moles"]},
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankScanTime, "Specify the duration of time allowed to pass for each spectral acquisition for a given state of the instrument for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, BlankScanTimes],
			{
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]},
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankFragmentMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankFragmentMassDetection -> {All, 200 Dalton ;; 3000 Dalton, {450 Dalton, 567 Dalton}}
			];
			Download[protocol, {BlankFragmentMinMasses, BlankFragmentMaxMasses, BlankFragmentMassSelections}],
			{
				{
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[20, "Grams" / "Moles"],
						Quantity[200, "Grams" / "Moles"],
						Null
					}
				},
				{
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					},
					{
						Quantity[16000, "Grams" / "Moles"],
						Quantity[3000, "Grams" / "Moles"],
						Null
					}
				},
				{
					{
						Null,
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					},
					{
						Null,
						Null,
						{Quantity[450, "Grams" / "Moles"], Quantity[567, "Grams" / "Moles"]}
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankCollisionEnergy, "Specify the voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankCollisionEnergy -> {{100 Volt}, {30 Volt}, {55 Volt}}
			];
			Download[protocol, {
				BlankCollisionEnergies,
				BlankLowCollisionEnergies,
				BlankHighCollisionEnergies,
				BlankFinalLowCollisionEnergies,
				BlankFinalHighCollisionEnergies
			}],
			{{{{Quantity[100, "Volts"]}, {Quantity[30, "Volts"]}, {Quantity[55,
				"Volts"]}}, {{Quantity[100, "Volts"]}, {Quantity[30,
				"Volts"]}, {Quantity[55, "Volts"]}}}, {{Null, Null, Null}, {Null,
				Null, Null}}, {{Null, Null, Null}, {Null, Null, Null}}, {{Null,
				Null, Null}, {Null, Null, Null}}, {{Null, Null, Null}, {Null, Null,
				Null}}},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankCollisionEnergyMassProfile, "Specify the relationship of collision energy with the MassDetection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankCollisionEnergyMassProfile -> {
					60 Volt ;; 90Volt,
					(*this should be split across the acquisition windows*)
					{30 Volt ;; 100Volt, 60 Volt ;; 150Volt},
					60 Volt ;; 150Volt
				}
			];
			Download[protocol, {
				BlankCollisionEnergies,
				BlankLowCollisionEnergies,
				BlankHighCollisionEnergies,
				BlankFinalLowCollisionEnergies,
				BlankFinalHighCollisionEnergies
			}],
			{
				{
					{{40 Volt}},
					{Null, Null},
					{{40 Volt}},
					{{40 Volt}},
					{Null, Null},
					{{40 Volt}}
				},
				{
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]}
				},
				{
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]},
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]}
				},
				{
					{Null},
					{Null, Null},
					{Null},
					{Null},
					{Null, Null},
					{Null}
				},
				{
					{Null},
					{Null, Null},
					{Null},
					{Null},
					{Null, Null},
					{Null}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankCollisionEnergyMassScan, "Specify Collision energy profile at the end of the scan from CollisionEnergy or CollisionEnergyScanProfile, as related to analyte mass:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankCollisionEnergyMassScan -> {
					60Volt ;; 90Volt,
					(*this should be split across the acquisition windows*)
					{30 Volt ;; 100Volt, 100Volt ;; 150Volt},
					60 Volt ;; 150Volt
				}
			];
			Download[protocol, {
				BlankFinalLowCollisionEnergies,
				BlankFinalHighCollisionEnergies
			}],
			{
				{
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[100, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[60, "Volts"]},
					{Quantity[30, "Volts"], Quantity[100, "Volts"]},
					{Quantity[60, "Volts"]}
				},
				{
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]},
					{Quantity[90, "Volts"]},
					{Quantity[100, "Volts"], Quantity[150, "Volts"]},
					{Quantity[150, "Volts"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankFragmentScanTime, "Specify the duration of the spectral scanning for each fragmentation of an intact ion for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankFragmentScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, BlankFragmentScanTimes],
			{
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]},
				{Quantity[0.1, "Seconds"], Quantity[0.2, "Seconds"], Quantity[0.4, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankAcquisitionSurvey, "Specify the number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAcquisitionSurvey -> {
					5,
					10,
					20
				}
			];
			Download[protocol, BlankAcquisitionSurveys],
			{{5, 10, 20}, {5, 10, 20}},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankMinimumThreshold, "Specify the minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankMinimumThreshold -> {
					80000 ArbitraryUnit,
					100000 ArbitraryUnit,
					200000 ArbitraryUnit
				}
			];
			Download[protocol, BlankMinimumThresholds],
			{
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[80000, IndependentUnit["ArbitraryUnits"]],
					Quantity[100000, IndependentUnit["ArbitraryUnits"]],
					Quantity[200000, IndependentUnit["ArbitraryUnits"]]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankAcquisitionLimit, "Specify the maximum number of total ions for a specific intact ion. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAcquisitionLimit -> {
					1000000 ArbitraryUnit,
					2000000 ArbitraryUnit,
					500000 ArbitraryUnit
				}
			];
			Download[protocol, BlankAcquisitionLimits],
			{
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				},
				{
					Quantity[1000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[2000000, IndependentUnit["ArbitraryUnits"]],
					Quantity[500000, IndependentUnit["ArbitraryUnits"]]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankCycleTimeLimit, "Specify the maximum duration for spectral scan measurement of fragment ions, as dictated by the initial survey in the first scan for each blank measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankCycleTimeLimit -> {
					1 Second,
					2 Second,
					10 Second
				}
			];
			Download[protocol, BlankCycleTimeLimits],
			{
				{Quantity[1, "Seconds"], Quantity[2, "Seconds"], Quantity[10, "Seconds"]},
				{Quantity[1, "Seconds"], Quantity[2, "Seconds"], Quantity[10, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankExclusionDomain, "Specify Defines when the ExclusionMasses are omitted in the chromatogram. Full indicates for the entire period:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankExclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					},
					{
						{
							Full,
							10Minute ;; 20Minute
						},
						{
							2 Minute ;; 5 Minute
						}
					}
				}
			];
			Download[protocol, BlankExclusionDomains],
			{
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				},
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankExclusionMass, "Specify the intact ions to omit for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankExclusionMass -> {
					{All, 500 Gram / Mole},
					{
						{
							{Once, 789 Gram / Mole},
							{Once, 899 Gram / Mole}
						},
						{
							{All, 678 Gram / Mole},
							{All, 567 Gram / Mole},
							{All, 902 Gram / Mole}
						}
					},
					{
						{Once, 456 Gram / Mole},
						{Once, 901 Gram / Mole}
					}
				}
			];
			Download[protocol, BlankExclusionMasses],
			{
				{{{All, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Once, Quantity[789, "Grams" / "Moles"]},
						{Once, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{All, Quantity[678, "Grams" / "Moles"]},
						{All, Quantity[567, "Grams" / "Moles"]},
						{All, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Once, Quantity[456, "Grams" / "Moles"]}},
					{{Once, Quantity[901, "Grams" / "Moles"]}}
				},
				{{{All, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Once, Quantity[789, "Grams" / "Moles"]},
						{Once, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{All, Quantity[678, "Grams" / "Moles"]},
						{All, Quantity[567, "Grams" / "Moles"]},
						{All, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Once, Quantity[456, "Grams" / "Moles"]}},
					{{Once, Quantity[901, "Grams" / "Moles"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankExclusionMassTolerance, "Specify the range above and below each ion in ExclusionMasses to consider for omission for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankExclusionMassTolerance -> {
					1 Gram / Mole,
					{2 Gram / Mole, 0.7 Gram / Mole},
					0.5 Gram / Mole
				}
			];
			Download[protocol, BlankExclusionMassTolerances],
			{
				{Quantity[1, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[0.7, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[0.7, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankExclusionRetentionTimeTolerance, "Specify the range of time above and below the RetentionTime to consider for omission for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankExclusionRetentionTimeTolerance -> {
					1 Second,
					{2 Second, 10 Second},
					20 Second
				}
			];
			Download[protocol, BlankExclusionRetentionTimeTolerances],
			{
				{Quantity[1, "Seconds"]},
				{Quantity[2, "Seconds"], Quantity[10, "Seconds"]},
				{Quantity[20, "Seconds"]},
				{Quantity[1, "Seconds"]},
				{Quantity[2, "Seconds"], Quantity[10, "Seconds"]},
				{Quantity[20, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionDomain, "Specify when the InclusionMass applies with respective to the chromatogram for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					},
					{
						{
							Full,
							10Minute ;; 20Minute
						},
						{
							2 Minute ;; 5 Minute
						}
					}
				}
			];
			Download[protocol, BlankInclusionDomains],
			{
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				},
				{{{Quantity[0., "Minutes"], Quantity[40., "Minutes"]}}},
				{
					{{Quantity[5, "Minutes"], Quantity[6, "Minutes"]}},
					{{Quantity[7, "Minutes"], Quantity[9, "Minutes"]}}
				},
				{
					{
						{Quantity[0., "Minutes"], Quantity[19.99, "Minutes"]},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionMass, "Specify the ions to prioritize during the survey scan for further fragmentation for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionMass -> {
					{Only, 500 Gram / Mole},
					{
						{
							{Preferential, 789 Gram / Mole},
							{Preferential, 899 Gram / Mole}
						},
						{
							{Only, 678 Gram / Mole},
							{Only, 567 Gram / Mole},
							{Only, 902 Gram / Mole}
						}
					},
					{
						{Preferential, 456 Gram / Mole},
						{Preferential, 901 Gram / Mole}
					}
				}
			];
			Download[protocol, BlankInclusionMasses],
			{
				{{{Only, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Preferential, Quantity[789, "Grams" / "Moles"]},
						{Preferential, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{Only, Quantity[678, "Grams" / "Moles"]},
						{Only, Quantity[567, "Grams" / "Moles"]},
						{Only, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Preferential, Quantity[456, "Grams" / "Moles"]}},
					{{Preferential, Quantity[901, "Grams" / "Moles"]}}
				},
				{{{Only, Quantity[500, "Grams" / "Moles"]}}},
				{
					{
						{Preferential, Quantity[789, "Grams" / "Moles"]},
						{Preferential, Quantity[899, "Grams" / "Moles"]}
					},
					{
						{Only, Quantity[678, "Grams" / "Moles"]},
						{Only, Quantity[567, "Grams" / "Moles"]},
						{Only, Quantity[902, "Grams" / "Moles"]}
					}
				},
				{
					{{Preferential, Quantity[456, "Grams" / "Moles"]}},
					{{Preferential, Quantity[901, "Grams" / "Moles"]}}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionCollisionEnergy, "Specify an overriding collision energy value that can be applied to the BlankInclusionMass for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionCollisionEnergy -> {
					100 Volt,
					{
						{
							75 Volt,
							45 Volt
						},
						{
							67 Volt,
							56 Volt,
							90 Volt
						}
					},
					{
						45 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, BlankInclusionCollisionEnergies],
			{
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}},
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionDeclusteringVoltage, "Specify an overriding source voltage value that can be applied to the InclusionMass for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionDeclusteringVoltage -> {
					100 Volt,
					{
						{
							75 Volt,
							45 Volt
						},
						{
							67 Volt,
							56 Volt,
							90 Volt
						}
					},
					{
						45 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, BlankInclusionDeclusteringVoltages],
			{
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}},
				{{Quantity[100, "Volts"]}},
				{
					{Quantity[75, "Volts"], Quantity[45, "Volts"]},
					{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
				},
				{{Quantity[45, "Volts"]}, {Quantity[90, "Volts"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionChargeState, "Specify the maximum charge state of the InclusionMass to also consider for inclusion for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionChargeState -> {
					{1, 2},
					{
						{1, 2},
						{1, 2, 3}
					},
					{0, 1}
				}
			];
			Download[protocol, BlankInclusionChargeStates],
			{
				{{1}, {2}},
				{{1, 2}, {1, 2, 3}},
				{{0}, {1}},
				{{1}, {2}},
				{{1, 2}, {1, 2, 3}},
				{{0}, {1}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionScanTime, "Specify an overriding scan time duration that can be applied to the InclusionMass for the consequent fragmentation for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionScanTime -> {
					2 Second,
					{
						{
							3 Second,
							5 Second
						},
						{
							0.5 Second,
							0.2 Second,
							1 Second
						}
					},
					{
						4.5 Second,
						9 Second
					}
				}
			];
			Download[protocol, BlankInclusionScanTimes],
			{
				{{Quantity[2, "Seconds"]}},
				{
					{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
					{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
				},
				{{Quantity[4.5, "Seconds"]}, {Quantity[9, "Seconds"]}},
				{{Quantity[2, "Seconds"]}},
				{
					{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
					{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
				},
				{{Quantity[4.5, "Seconds"]}, {Quantity[9, "Seconds"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankInclusionMassTolerance, "Specify the range above and below each ion in InclusionMasses to consider for prioritization for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionMassTolerance -> {
					{
						2 Gram / Mole,
						1 Gram / Mole
					},
					{
						6 Gram / Mole
					},
					3 Gram / Mole
				}
			];
			Download[protocol, BlankInclusionMassTolerances],
			{
				{Quantity[2, "Grams" / "Moles"], Quantity[1, "Grams" / "Moles"]},
				{Quantity[6, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[1, "Grams" / "Moles"]},
				{Quantity[6, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankSurveyChargeStateExclusion, "Specify if to automatically fill ChargeState exclusion related options and leave out redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankSurveyChargeStateExclusion -> {
					{
						True,
						False
					},
					{
						True
					},
					False
				}
			];
			Download[protocol, BlankChargeStateSelections],
			{
				{{1, 2}, Null},
				{{1, 2}},
				{Null},
				{{1, 2}, Null},
				{{1, 2}},
				{Null}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankSurveyIsotopeExclusion, "Specify if to automatically fill MassIsotope exclusion related options and leave out redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankSurveyIsotopeExclusion -> {
					{
						True,
						False
					},
					{
						True
					},
					False
				}
			];
			Download[protocol, {BlankIsotopeMassDifferences, BlankIsotopeRatios, BlankIsotopeDetectionMinimums}],
			{
				{
					{{Quantity[1, "Grams" / "Moles"]}, Null},
					{{Quantity[1, "Grams" / "Moles"]}},
					{Null},
					{{Quantity[1, "Grams" / "Moles"]}, Null},
					{{Quantity[1, "Grams" / "Moles"]}},
					{Null}
				},
				{
					{{0.1}, Null},
					{{0.1}},
					{Null},
					{{0.1}, Null},
					{{0.1}},
					{Null}
				},
				{
					{{Quantity[10, "Seconds"^(-1)]}, Null},
					{{Quantity[10, "Seconds"^(-1)]}},
					{Null},
					{{Quantity[10, "Seconds"^(-1)]}, Null},
					{{Quantity[10, "Seconds"^(-1)]}},
					{Null}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankChargeStateExclusionLimit, "Specify the number of ions to survey first with exclusion by ionic state for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankChargeStateExclusionLimit -> {
					{
						5,
						6
					},
					{
						10
					},
					3
				}
			];
			Download[protocol, BlankChargeStateLimits],
			{{5, 6}, {10}, {3}, {5, 6}, {10}, {3}},
			Variables :> {protocol}
		],
		(* See note on ChargeStateExclusion about how the test below resolved pre and post-ExpandIndexMatchedInputs update on April 2025 *)
		Example[{Options, BlankChargeStateExclusion, "Specify the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankChargeStateExclusion -> {
					{1, 2, 3},
					{1, 2, 3, 4}
				}
			];
			Download[protocol, BlankChargeStateSelections],
			{
				(* Blank 1 *)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4}
				},
				(* Blank 2 *)
				{
					(* Acquisition Window 1 *)
					{1, 2, 3},
					(* Acquisition Window 2 *)
					{1, 2, 3, 4}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankChargeStateMassTolerance, "Specify the range of m/z to consider for exclusion by ionic state property for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankChargeStateMassTolerance -> {
					{
						2 Gram / Mole,
						2.5 Gram / Mole
					},
					{
						3 Gram / Mole
					},
					1 Gram / Mole
				}
			];
			Download[protocol, BlankChargeStateMassTolerances],
			{
				{Quantity[2, "Grams" / "Moles"], Quantity[2.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]},
				{Quantity[2, "Grams" / "Moles"], Quantity[2.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankIsotopicExclusion, "Specify The m/z difference between monoisotopic ions as a criterion for survey exclusion for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIsotopicExclusion -> {
					{
						{1 Gram / Mole, 2 Gram / Mole},
						{1 Gram / Mole}
					},
					{
						{1 Gram / Mole, 2 Gram / Mole}
					},
					{1 Gram / Mole}
				}
			];
			Download[protocol, BlankIsotopeMassDifferences],
			{
				{
					{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
					{Quantity[1, "Grams" / "Moles"]}
				},
				{{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]}},
				{{Quantity[1, "Grams" / "Moles"]}},
				{
					{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
					{Quantity[1, "Grams" / "Moles"]}
				},
				{{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]}},
				{{Quantity[1, "Grams" / "Moles"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankIsotopeRatioThreshold, "Specify this minimum relative magnitude between monoisotopic ions must be met for exclusion for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIsotopeRatioThreshold -> {
					{
						{0.1, 0.05},
						{0.2}
					},
					{
						{0.3, 0.25}
					},
					{0.15}
				}
			];
			Download[protocol, BlankIsotopeRatios],
			{
				{{0.1, 0.05}, {0.2}},
				{{0.3, 0.25}},
				{{0.15}},
				{{0.1, 0.05}, {0.2}},
				{{0.3, 0.25}},
				{{0.15}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankIsotopeDetectionMinimum, "Specify the acquisition rate of a given intact mass to consider for isotope exclusion in the survey for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIsotopeDetectionMinimum -> {
					{
						10 1 / Second,
						20 1 / Second
					},
					{
						15 1 / Second
					},
					25 1 / Second
				}
			];
			Download[protocol, BlankIsotopeDetectionMinimums],
			{
				(* Blank 1 *)
				{
					(* Acquisition Window 1 *)
					{10/Second, 20/Second},
					(* Acquisition Window 2 *)
					{15/Second},
					(* Acquisition Window 3 *)
					{25/Second}
				},
				(* Blank 2 *)
				{
					(* Acquisition Window 1 *)
					{10/Second,20/Second},
					(* Acquisition Window 2 *)
					{15/Second},
					(* Acquisition Window 3 *)
					{25/Second}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankIsotopeMassTolerance, "Specify the range of m/z around a mass to consider for exclusion for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIsotopeMassTolerance -> {
					{
						1 Gram / Mole,
						2 Gram / Mole
					},
					{
						0.5 Gram / Mole
					},
					3 Gram / Mole
				}
			];
			Download[protocol, BlankIsotopeMassTolerances],
			{
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[0.5, "Grams" / "Moles"]},
				{Quantity[3, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankIsotopeRatioTolerance, "Specify the range of relative magnitude around IsotopeRatio to consider for isotope exclusion for blank measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIsotopeRatioTolerance -> {
					{
						10 Percent,
						25 Percent
					}
				}
			];
			Download[protocol, BlankIsotopeRatioTolerances],
			{
				{Quantity[10, "Percent"], Quantity[25, "Percent"]},
				{Quantity[10, "Percent"], Quantity[25, "Percent"]}
			},
			Variables :> {protocol}
		],

		Example[
			{Options, BlankAbsorbanceWavelength, "Specify the physical properties of light passed through the flow for the PhotoDiodeArray (PDA) Detector for each blank measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAbsorbanceWavelength -> Span[300 Nanometer, 450 Nanometer]
			];
			Download[protocol, {BlankMinAbsorbanceWavelengths, BlankMaxAbsorbanceWavelengths}],
			{{300. Nanometer, 300. Nanometer}, {450. Nanometer, 450. Nanometer}},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankWavelengthResolution, "Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for each blank measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankWavelengthResolution -> 2.4 * Nanometer
			];
			Download[protocol, BlankWavelengthResolutions],
			{2.4 * Nanometer, 2.4 * Nanometer},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankUVFilter, "Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors for each blank measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankUVFilter -> True
			];
			Download[protocol, BlankUVFilters],
			{True, True},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankAbsorbanceSamplingRate, "Specify the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time for each blank measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAbsorbanceSamplingRate -> 10 / Second
			];
			Download[protocol, BlankAbsorbanceSamplingRates],
			{
				Quantity[10., "Seconds"^(-1)],
				Quantity[10., "Seconds"^(-1)]
			},
			Variables :> {protocol}
		],
		Example[
			{Options, BlankDwellTime, "Specify dwell time when scaning the sample in single or a list or single wavelengths when using qqq as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				BlankAcquisitionMode -> MultipleReactionMonitoring,
				BlankMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				BlankFragmentMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				BlankDwellTime -> 150 Millisecond
			];
			Download[protocol, BlankDwellTimes],
			{
				{{Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"]}},
				{{Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"]}}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankMassDetectionStepSize, "Specify the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				BlankMassDetectionStepSize -> {{0.1 Gram / Mole}}];
			Download[protocol, BlankMassDetectionStepSizes],
			{
				{Quantity[0.1, ("Grams") / ("Moles")]},
				{Quantity[0.1, ("Grams") / ("Moles")]}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankCollisionCellExitVoltage, "Specify the value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				BlankCollisionCellExitVoltage -> {{6 Volt}}
			];
			Download[protocol, BlankCollisionCellExitVoltages],
			{{6 Volt}, {6 Volt}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankNeutralLoss, "Specify a neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				BlankNeutralLoss -> {{123 Gram / Mole}}
			];
			Download[protocol, BlankNeutralLosses],
			{
				{Quantity[123, ("Grams") / ("Moles")]},
				{Quantity[123, ("Grams") / ("Moles")]}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, BlankMultipleReactionMonitoringAssays, "Specify the ion corresponding to the compound of interest is targetted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				BlankMultipleReactionMonitoringAssays -> {{{{456 Gram / Mole, 60Volt, 123Gram / Mole, 200Millisecond}}}}
			];
			Download[protocol, BlankMultipleReactionMonitoringAssays],
			{{<|MS1Mass -> {Quantity[456, ("Grams") / ("Moles")]},
				CollisionEnergy -> {Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200,
					"Milliseconds"]}|>}, {<|MS1Mass -> {Quantity[456, ("Grams") / (
				"Moles")]}, CollisionEnergy -> {Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200, "Milliseconds"]}|>}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		(*Column Prime*)
		Example[
			{Options, ColumnRefreshFrequency, "Specify how frequently the column is flushed:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnRefreshFrequency -> 2
			];
			Download[protocol, InjectionTable[[All, Type]]],
			{ColumnPrime, Sample, Sample, ColumnPrime, Sample, ColumnFlush},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeGradient, "Specify the column prime gradient:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradient -> Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]
				][[1]];
				Lookup[packet, ColumnPrimeGradientMethod]
			),
			LinkP[Object[Method]],
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, ColumnPrimeTemperature, "Specify the column temperature for each column prime:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeTemperature -> 40 Celsius
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeTemperature
				]
			),
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnPrimeGradientA, "Specify the buffer A gradient for each column prime:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientA
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, ColumnPrimeGradientB, "Specify the buffer B gradient for each column prime:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientB -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientB
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, ColumnPrimeGradientC, "Specify the buffer C gradient for each column prime:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientC -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientC
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, ColumnPrimeGradientD, "Specify the buffer D gradient for each column prime:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientD -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientD
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options, ColumnPrimeFlowRate, "Specify the flow rate for each column prime:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeFlowRate -> 1 Milliliter / Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeFlowRate
				]
			),
			1 Milliliter / Minute,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnPrimeIonMode, "Specify if positively or negatively charged ions are analyzed for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIonMode -> Positive
			];
			Download[protocol, ColumnPrimeIonMode],
			Positive,
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeMassSpectrometryMethod, "Specify previous instruction(s) for the analyte ionization, selection, fragmentation, and detection for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeMassSpectrometryMethod -> Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]
			];
			Download[protocol, {ColumnPrimeInclusionMasses, ColumnPrimeInclusionCollisionEnergies}],
			{
				{
					{
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]}
					},
					{
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]}
					}
				},
				{
					{Quantity[40, "Volts"], Quantity[40, "Volts"]},
					{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
				}
			},
			Variables :> {protocol},
			Messages :> {Warning::OverwritingMassAcquisitionMethod}
		],
		Example[
			{Options, ColumnPrimeESICapillaryVoltage, "Specify the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeESICapillaryVoltage -> 1 Kilovolt
			];
			Download[protocol, ColumnPrimeESICapillaryVoltage],
			1 Kilovolt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeDeclusteringVoltage, "Specify the voltage between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeDeclusteringVoltage -> 100 Volt
			];
			Download[protocol, ColumnPrimeDeclusteringVoltage],
			100 Volt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeStepwaveVoltage, "Specify The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeStepwaveVoltage -> 100 Volt
			];
			Download[protocol, ColumnPrimeStepwaveVoltage],
			100 Volt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeIonGuideVoltage, "Specify the electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIonGuideVoltage -> 10 Volt
			];
			Download[protocol, ColumnPrimeIonGuideVoltage],
			10 Volt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeSourceTemperature, "Specify the temperature setting of the source block for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeSourceTemperature -> 100 Celsius
			];
			Download[protocol, ColumnPrimeSourceTemperature],
			100 Celsius,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeDesolvationTemperature, "Specify the temperature setting for heat element of the drying sheath gas for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeDesolvationTemperature -> 500 Celsius
			];
			Download[protocol, ColumnPrimeDesolvationTemperature],
			500 Celsius,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeDesolvationGasFlow, "Specify the nitrogen gas flow ejected around the ESI capillary, used for solvent evaporation to produce single gas phase ions from the ion spray for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeDesolvationGasFlow -> 1000 Liter / Hour
			];
			Download[protocol, ColumnPrimeDesolvationGasFlow],
			1000 Liter / Hour,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeConeGasFlow, "Specify the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block) for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeConeGasFlow -> 100 Liter / Hour
			];
			Download[protocol, ColumnPrimeConeGasFlow],
			100 Liter / Hour,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeAcquisitionWindow, "Specify the time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeAcquisitionWindow -> {0 Minute ;; 5 Minute, 7 Minute ;; 12 Minute}
			];
			Download[protocol, ColumnPrimeAcquisitionWindows],
			{
				Association[StartTime -> 0. Minute, EndTime -> 5. Minute],
				Association[StartTime -> 7. Minute, EndTime -> 12. Minute]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeAcquisitionMode, "Specify whether spectra to be collected should depend on properties of measured mass spectrum of the intact ions (DataDependent), systematically scan through all of the intact ions (DataIndependent), or to scan specified ions (Null) as set by MassDetection and/or FragmentMassDetection for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeAcquisitionMode -> {DataDependent, MS1FullScan, MS1FullScan}
			];
			Download[protocol, ColumnPrimeAcquisitionModes],
			{DataDependent, MS1FullScan, MS1FullScan},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeFragment, "Specify Determines whether to have ions dissociate upon collision with neutral gas species and to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS) for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeFragment -> {True, False, True}
			];
			Download[protocol, ColumnPrimeFragmentations],
			{True, False, True},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. For Fragmentation->True, the intact ions will be selected for fragmentation for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeMassDetection -> {
					Protein,
					200 Dalton ;; 3000Dalton,
					{450 Dalton, 567 Dalton}
				}
			];
			Download[protocol, {ColumnPrimeMinMasses, ColumnPrimeMaxMasses, ColumnPrimeMassSelections}],
			{
				{
					Quantity[2., "Grams" / "Moles"],
					Quantity[200., "Grams" / "Moles"],
					Null
				},
				{
					Quantity[20000., "Grams" / "Moles"],
					Quantity[3000., "Grams" / "Moles"],
					Null
				},
				{
					Null,
					Null,
					{
						Quantity[450, "Grams" / "Moles"],
						Quantity[567, "Grams" / "Moles"]
					}
				}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeScanTime, "Specify the duration of time allowed to pass for each spectral acquisition for a given state of the instrument for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, ColumnPrimeScanTimes],
			{0.1 Second, 0.2 Second, 0.4 Second},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeFragmentMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeFragmentMassDetection -> {All, 200 Dalton ;; 3000 Dalton, {450 Dalton, 567 Dalton}}
			];
			Download[protocol, {ColumnPrimeFragmentMinMasses, ColumnPrimeFragmentMaxMasses, ColumnPrimeFragmentMassSelections}],
			{
				{
					Quantity[20., "Grams" / "Moles"],
					Quantity[200., "Grams" / "Moles"],
					Null
				},
				{
					Quantity[16000., "Grams" / "Moles"],
					Quantity[3000., "Grams" / "Moles"],
					Null
				},
				{
					Null,
					Null,
					{
						Quantity[450, "Grams" / "Moles"],
						Quantity[567, "Grams" / "Moles"]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeCollisionEnergy, "Specify the voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeCollisionEnergy -> {{30 Volt}, {50 Volt}}
			];
			Download[protocol, {
				ColumnPrimeCollisionEnergies,
				ColumnPrimeLowCollisionEnergies,
				ColumnPrimeHighCollisionEnergies,
				ColumnPrimeFinalLowCollisionEnergies,
				ColumnPrimeFinalHighCollisionEnergies
			}],
			{{Quantity[30., "Volts"], Quantity[50., "Volts"]}, {Null,
				Null}, {Null, Null}, {Null, Null}, {Null, Null}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeCollisionEnergyMassProfile, "Specify the relationship of collision energy with the MassDetection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeCollisionEnergyMassProfile -> {30 Volt ;; 100Volt, 60 Volt ;; 150Volt}
			];
			Download[protocol, {
				ColumnPrimeCollisionEnergies,
				ColumnPrimeLowCollisionEnergies,
				ColumnPrimeHighCollisionEnergies,
				ColumnPrimeFinalLowCollisionEnergies,
				ColumnPrimeFinalHighCollisionEnergies
			}],
			{
				{
					Null,
					Null
				},
				{
					Quantity[30., "Volts"],
					Quantity[60., "Volts"]
				},
				{
					Quantity[100., "Volts"],
					Quantity[150., "Volts"]
				},
				{
					Null,
					Null
				},
				{
					Null,
					Null
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeCollisionEnergyMassScan, "Specify Collision energy profile at the end of the scan from CollisionEnergy or CollisionEnergyScanProfile, as related to analyte mass:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeCollisionEnergyMassScan -> {30 Volt ;; 100Volt, 150Volt}
			];
			Download[protocol, {
				ColumnPrimeCollisionEnergies,
				ColumnPrimeLowCollisionEnergies,
				ColumnPrimeHighCollisionEnergies,
				ColumnPrimeFinalLowCollisionEnergies,
				ColumnPrimeFinalHighCollisionEnergies
			}],
			{
				{
					Quantity[40., "Volts"],
					Quantity[40., "Volts"]
				},
				{
					Null,
					Null
				},
				{
					Null,
					Null
				},
				{
					Quantity[30., "Volts"],
					Quantity[150., "Volts"]
				},
				{
					Quantity[100., "Volts"],
					Quantity[150., "Volts"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeFragmentScanTime, "Specify the duration of the spectral scanning for each fragmentation of an intact ion for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeFragmentScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, ColumnPrimeFragmentScanTimes],
			{0.1 Second, 0.2 Second, 0.4 Second},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeAcquisitionSurvey, "Specify the number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeAcquisitionSurvey -> {
					5,
					10,
					20
				}
			];
			Download[protocol, ColumnPrimeAcquisitionSurveys],
			{
				5,
				10,
				20
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeMinimumThreshold, "Specify the minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeMinimumThreshold -> {
					80000 ArbitraryUnit,
					100000 ArbitraryUnit,
					200000 ArbitraryUnit
				}
			];
			Download[protocol, ColumnPrimeMinimumThresholds],
			{
				80000,
				100000,
				200000
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeAcquisitionLimit, "Specify the maximum number of total ions for a specific intact ion. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeAcquisitionLimit -> {
					1000000 ArbitraryUnit,
					2000000 ArbitraryUnit,
					500000 ArbitraryUnit
				}
			];
			Download[protocol, ColumnPrimeAcquisitionLimits],
			{
				1000000,
				2000000,
				500000
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeCycleTimeLimit, "Specify the maximum duration for spectral scan measurement of fragment ions, as dictated by the initial survey in the first scan for each column prime measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeCycleTimeLimit -> {
					1 Second,
					2 Second,
					10 Second
				}
			];
			Download[protocol, ColumnPrimeCycleTimeLimits],
			{
				1. Second,
				2. Second,
				10. Second
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeExclusionDomain, "Specify Defines when the ExclusionMasses are omitted in the chromatogram. Full indicates for the entire period:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeExclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					}
				}
			];
			{columnPrimeGradient,columnPrimeExclusionDomains}=Download[protocol, {ColumnPrimeGradientMethod[Gradient],ColumnPrimeExclusionDomains}];
			{
				columnPrimeExclusionDomains,
				(* The first ExclusionDomain time matches the first AcquisitionWindow, which is half of the gradient time. Allow a 1% room for rounding *)
				EqualQ[columnPrimeExclusionDomains[[1,1,2]],columnPrimeGradient[[-1,1]]/2 - 0.01Minute]
			},
			{
				{
					{
						{
							Quantity[0., "Minutes"],
							TimeP
						}
					},
					{
						{
							Quantity[5, "Minutes"],
							Quantity[6, "Minutes"]
						},
						{
							Quantity[7, "Minutes"],
							Quantity[9, "Minutes"]
						}
					}
				},
				True
			},
			Variables :> {protocol,columnPrimeGradient,columnPrimeExclusionDomains}
		],
		Example[
			{Options, ColumnPrimeExclusionMass, "Specify the intact ions to omit for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeExclusionMass -> {
					{
						{Once, 789 Gram / Mole},
						{Once, 899 Gram / Mole}
					},
					{
						{All, 678 Gram / Mole},
						{All, 567 Gram / Mole},
						{All, 902 Gram / Mole}
					}
				}
			];
			Download[protocol, ColumnPrimeExclusionMasses],
			{
				{
					{Once, Quantity[789, "Grams" / "Moles"]},
					{Once, Quantity[899, "Grams" / "Moles"]}
				},
				{
					{All, Quantity[678, "Grams" / "Moles"]},
					{All, Quantity[567, "Grams" / "Moles"]},
					{All, Quantity[902, "Grams" / "Moles"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeExclusionMassTolerance, "Specify the range above and below each ion in ExclusionMasses to consider for omission for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeExclusionMassTolerance -> {2 Gram / Mole, 0.7 Gram / Mole}
			];
			Download[protocol, ColumnPrimeExclusionMassTolerances],
			{Quantity[2., "Grams" / "Moles"], Quantity[0.7, "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeExclusionRetentionTimeTolerance, "Specify the range of time above and below the RetentionTime to consider for omission for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeExclusionRetentionTimeTolerance -> {10 Second, 30 Second}
			];
			Download[protocol, ColumnPrimeExclusionRetentionTimeTolerances],
			{10. Second, 30. Second},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeInclusionDomain, "Specify when the InclusionMass applies with respective to the chromatogram for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionDomain -> {
					{
						Full,
						10Minute ;; 20Minute
					},
					{
						2 Minute ;; 5 Minute
					}
				}
			];
			{columnPrimeGradient,columnPrimeInclusionDomains}=Download[protocol, {ColumnPrimeGradientMethod[Gradient],ColumnPrimeInclusionDomains}];
			{
				columnPrimeInclusionDomains,
				(* The first ExclusionDomain time matches the first AcquisitionWindow, which is half of the gradient time. Allow a 1% room for rounding *)
				EqualQ[columnPrimeInclusionDomains[[1,1,2]],columnPrimeGradient[[-1,1]]/2 - 0.01Minute]
			},
			{
				{
					{
						{Quantity[0., "Minutes"], TimeP},
						{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
					},
					{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
				},
				True
			},
			Variables :> {protocol,columnPrimeGradient,columnPrimeInclusionDomains}
		],
		Example[
			{Options, ColumnPrimeInclusionMass, "Specify the ions to prioritize during the survey scan for further fragmentation for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionMass -> {
					{
						{Preferential, 789 Gram / Mole},
						{Preferential, 899 Gram / Mole}
					},
					{
						{Only, 678 Gram / Mole},
						{Only, 567 Gram / Mole},
						{Only, 902 Gram / Mole}
					}
				}
			];
			Download[protocol, ColumnPrimeInclusionMasses],
			{
				{
					{Preferential, Quantity[789, "Grams" / "Moles"]},
					{Preferential, Quantity[899, "Grams" / "Moles"]}
				},
				{
					{Only, Quantity[678, "Grams" / "Moles"]},
					{Only, Quantity[567, "Grams" / "Moles"]},
					{Only, Quantity[902, "Grams" / "Moles"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeInclusionCollisionEnergy, "Specify an overriding collision energy value that can be applied to the ColumnPrimeInclusionMass for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionCollisionEnergy -> {
					{
						75 Volt,
						45 Volt
					},
					{
						67 Volt,
						56 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, ColumnPrimeInclusionCollisionEnergies],
			{
				{Quantity[75, "Volts"], Quantity[45, "Volts"]},
				{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeInclusionDeclusteringVoltage, "Specify an overriding source voltage value that can be applied to the InclusionMass for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionDeclusteringVoltage -> {
					{
						75 Volt,
						45 Volt
					},
					{
						67 Volt,
						56 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, ColumnPrimeInclusionDeclusteringVoltages],
			{
				{Quantity[75, "Volts"], Quantity[45, "Volts"]},
				{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeInclusionChargeState, "Specify the maximum charge state of the InclusionMass to also consider for inclusion for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionChargeState -> {
					{1, 2},
					{2, 4, 5}
				}
			];
			Download[protocol, ColumnPrimeInclusionChargeStates],
			{
				{1, 2},
				{2, 4, 5}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeInclusionScanTime, "Specify an overriding scan time duration that can be applied to the InclusionMass for the consequent fragmentation for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionScanTime -> {
					{
						3 Second,
						5 Second
					},
					{
						0.5 Second,
						0.2 Second,
						1 Second
					}
				}
			];
			Download[protocol, ColumnPrimeInclusionScanTimes],
			{
				{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
				{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeInclusionMassTolerance, "Specify the range above and below each ion in InclusionMasses to consider for prioritization for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeInclusionMassTolerance -> {
					2 Gram / Mole,
					1 Gram / Mole
				}
			];
			Download[protocol, ColumnPrimeInclusionMassTolerances],
			{Quantity[2., "Grams" / "Moles"], Quantity[1., "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeSurveyChargeStateExclusion, "Specify if to automatically fill ChargeState exclusion related options and leave out redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeSurveyChargeStateExclusion -> {
					True,
					False
				}
			];
			Download[protocol, ColumnPrimeChargeStateSelections],
			{{1, 2}, Null},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeSurveyIsotopeExclusion, "Specify if to automatically fill MassIsotope exclusion related options and leave out redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeSurveyIsotopeExclusion -> {
					True,
					False
				}
			];
			Download[protocol, {ColumnPrimeIsotopeMassDifferences, ColumnPrimeIsotopeRatios, ColumnPrimeIsotopeDetectionMinimums}],
			{
				{{Quantity[1, "Grams" / "Moles"]}, Null},
				{{0.1}, Null},
				{{Quantity[10, "Seconds"^(-1)]}, Null}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeChargeStateExclusionLimit, "Specify the number of ions to survey first with exclusion by ionic state for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeChargeStateExclusionLimit -> {
					5,
					6
				}
			];
			Download[protocol, ColumnPrimeChargeStateLimits],
			{5, 6},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeChargeStateExclusion, "Specify the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeChargeStateExclusion -> {
					{1, 2},
					{1}
				}
			];
			Download[protocol, ColumnPrimeChargeStateSelections],
			{{1, 2}, {1}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeChargeStateMassTolerance, "Specify the range of m/z to consider for exclusion by ionic state property for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeChargeStateMassTolerance -> {
					2 Gram / Mole,
					2.5 Gram / Mole
				}
			];
			Download[protocol, ColumnPrimeChargeStateMassTolerances],
			{
				2. Gram / Mole,
				2.5 Gram / Mole
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeIsotopicExclusion, "Specify The m/z difference between monoisotopic ions as a criterion for survey exclusion for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopicExclusion -> {
					{1 Gram / Mole, 2 Gram / Mole},
					{1 Gram / Mole}
				}
			];
			Download[protocol, ColumnPrimeIsotopeMassDifferences],
			{
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeIsotopeRatioThreshold, "Specify this minimum relative magnitude between monoisotopic ions must be met for exclusion for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopeRatioThreshold -> {
					{0.1, 0.05},
					{0.2}
				}
			];
			Download[protocol, ColumnPrimeIsotopeRatios],
			{{0.1, 0.05}, {0.2}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeIsotopeDetectionMinimum, "Specify the acquisition rate of a given intact mass to consider for isotope exclusion in the survey for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopeDetectionMinimum -> {
					10 1 / Second,
					20 1 / Second
				}
			];
			Download[protocol, ColumnPrimeIsotopeDetectionMinimums],
			{
				{
					Quantity[10, "Seconds"^(-1)],
					Quantity[20, "Seconds"^(-1)]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeIsotopeMassTolerance, "Specify the range of m/z around a mass to consider for exclusion for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopeMassTolerance -> {
					1 Gram / Mole,
					2 Gram / Mole
				}
			];
			Download[protocol, ColumnPrimeIsotopeMassTolerances],
			{Quantity[1., "Grams" / "Moles"], Quantity[2., "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeIsotopeRatioTolerance, "Specify the range of relative magnitude around IsotopeRatio to consider for isotope exclusion for column prime measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopeRatioTolerance -> {
					10 Percent,
					25 Percent
				}
			];
			Download[protocol, ColumnPrimeIsotopeRatioTolerances],
			{Quantity[10., "Percent"], Quantity[25., "Percent"]},
			Variables :> {protocol}
		],

		Example[
			{Options, ColumnPrimeAbsorbanceWavelength, "Specify the physical properties of light passed through the flow for the PhotoDiodeArray (PDA) Detector for each column prime measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeAbsorbanceWavelength -> Span[300 Nanometer, 450 Nanometer]
			];
			Download[protocol, {ColumnPrimeMinAbsorbanceWavelength, ColumnPrimeMaxAbsorbanceWavelength}],
			{300. Nanometer, 450. Nanometer},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeWavelengthResolution, "Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for each column prime measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeWavelengthResolution -> 2.4 * Nanometer
			];
			Download[protocol, ColumnPrimeWavelengthResolution],
			2.4 * Nanometer,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeUVFilter, "Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors for each column prime measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeUVFilter -> True
			];
			Download[protocol, ColumnPrimeUVFilter],
			True,
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeAbsorbanceSamplingRate, "Specify the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time for each column prime measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeAbsorbanceSamplingRate -> 10 / Second
			];
			Download[protocol, ColumnPrimeAbsorbanceSamplingRate],
			10. * 1 / Second,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeDwellTime, "Specify dwell time when scaning the sample in single or a list or single wavelengths when using qqq as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				ColumnPrimeAcquisitionMode -> MultipleReactionMonitoring,
				ColumnPrimeMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				ColumnPrimeFragmentMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				ColumnPrimeDwellTime -> 150 Millisecond
			];
			Download[protocol, ColumnPrimeDwellTimes],
			{{
				150 Millisecond,
				150 Millisecond,
				150 Millisecond,
				150 Millisecond,
				150 Millisecond
			}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnPrimeMassDetectionStepSize, "Specify the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnPrimeMassDetectionStepSize -> {0.3 Gram / Mole}];
			Download[protocol, ColumnPrimeMassDetectionStepSizes],
			{Quantity[0.3, ("Grams") / ("Moles")]},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeCollisionCellExitVoltage, "Specify the value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnPrimeCollisionCellExitVoltage -> {6 Volt}
			];
			Download[protocol, ColumnPrimeCollisionCellExitVoltages],
			{6 Volt},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeNeutralLoss, "Specify a neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnPrimeNeutralLoss -> {123 Gram / Mole}
			];
			Download[protocol, ColumnPrimeNeutralLosses],
			{123 Gram / Mole},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnPrimeMultipleReactionMonitoringAssays, "Specify the ion corresponding to the compound of interest is targetted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnPrimeMultipleReactionMonitoringAssays -> {{{456 Gram / Mole, 60Volt, 123Gram / Mole, 200Millisecond}}}
			];
			Download[protocol, ColumnPrimeMultipleReactionMonitoringAssays],
			{<|MS1Mass -> {Quantity[456, ("Grams") / ("Moles")]},
				CollisionEnergy -> {Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200, "Milliseconds"]}|>},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		(* -- Column Flush -- *)
		Example[
			{Options, ColumnFlushGradient, "Specify the column flush gradient:"},
			(
				protocol = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					ColumnFlushGradient -> Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]
				];
				Download[protocol, ColumnFlushGradientMethod]
			),
			LinkP[Object[Method]],
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushTemperature, "Specify the column temperature for each column flush:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushTemperature -> 40 Celsius
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushTemperature
				]
			),
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnFlushGradientA, "Specify the buffer A gradient for each column flush:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientA
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnFlushGradientB, "Specify the buffer B gradient for each column flush:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientB -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientB
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnFlushGradientC, "Specify the buffer C gradient for each column flush:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientC -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientC
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnFlushGradientD, "Specify the buffer D gradient for each column flush:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientD -> {{0 Minute, 10 Percent}, {5 Minute, 10 Percent}, {50 Minute, 100 Percent}, {50.1 Minute, 0 Percent}, {55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientD
				]
			),
			{{0 Minute, 10. Percent}, {5 Minute, 10. Percent}, {50 Minute, 100. Percent}, {50.1 Minute, 0. Percent}, {55 Minute, 0. Percent}},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnFlushFlowRate, "Specify the flow rate for each column flush:"},
			(
				packet = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushFlowRate -> 1 Milliliter / Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushFlowRate
				]
			),
			1 Milliliter / Minute,
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[
			{Options, ColumnFlushIonMode, "Specify if positively or negatively charged ions are analyzed for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIonMode -> Positive
			];
			Download[protocol, ColumnFlushIonMode],
			Positive,
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushMassSpectrometryMethod, "Specify previous instruction(s) for the analyte ionization, selection, fragmentation, and detection for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushMassSpectrometryMethod -> Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]
			];
			Download[protocol, {ColumnFlushInclusionMasses, ColumnFlushInclusionCollisionEnergies}],
			{
				{
					{
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]}
					},
					{
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]}
					}
				},
				{
					{Quantity[40, "Volts"], Quantity[40, "Volts"]},
					{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
				}
			},
			Variables :> {protocol},
			Messages : {Warning::OverwritingMassAcquisitionMethod}
		],
		Example[
			{Options, ColumnFlushESICapillaryVoltage, "Specify the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushESICapillaryVoltage -> 1 Kilovolt
			];
			Download[protocol, ColumnFlushESICapillaryVoltage],
			1. Kilovolt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushDeclusteringVoltage, "Specify the voltage between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer) for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushDeclusteringVoltage -> 100 Volt
			];
			Download[protocol, ColumnFlushDeclusteringVoltage],
			100 Volt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushStepwaveVoltage, "Specify The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushStepwaveVoltage -> 100 Volt
			];
			Download[protocol, ColumnFlushStepwaveVoltage],
			100 Volt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushIonGuideVoltage, "Specify the electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIonGuideVoltage -> 10 Volt
			];
			Download[protocol, ColumnFlushIonGuideVoltage],
			10 Volt,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushSourceTemperature, "Specify the temperature setting of the source block for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushSourceTemperature -> 100 Celsius
			];
			Download[protocol, ColumnFlushSourceTemperature],
			100 Celsius,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushDesolvationTemperature, "Specify the temperature setting for heat element of the drying sheath gas for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushDesolvationTemperature -> 500 Celsius
			];
			Download[protocol, ColumnFlushDesolvationTemperature],
			500 Celsius,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushDesolvationGasFlow, "Specify the nitrogen gas flow ejected around the ESI capillary, used for solvent evaporation to produce single gas phase ions from the ion spray for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushDesolvationGasFlow -> 1000 Liter / Hour
			];
			Download[protocol, ColumnFlushDesolvationGasFlow],
			1000 Liter / Hour,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushConeGasFlow, "Specify the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block) for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushConeGasFlow -> 100 Liter / Hour
			];
			Download[protocol, ColumnFlushConeGasFlow],
			100 Liter / Hour,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushAcquisitionWindow, "Specify the time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushAcquisitionWindow -> 0 Minute ;; 5 Minute
			];
			Download[protocol, ColumnFlushAcquisitionWindows],
			{Association[StartTime -> Quantity[0.`, "Minutes"], EndTime -> Quantity[5.`, "Minutes"]]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushAcquisitionMode, "Specify whether spectra to be collected should depend on properties of measured mass spectrum of the intact ions (DataDependent), systematically scan through all of the intact ions (DataIndependent), or to scan specified ions (Null) as set by MassDetection and/or FragmentMassDetection for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushAcquisitionMode -> {DataDependent, MS1FullScan, MS1FullScan}
			];
			Download[protocol, ColumnFlushAcquisitionModes],
			{DataDependent, MS1FullScan, MS1FullScan},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushFragment, "Specify Determines whether to have ions dissociate upon collision with neutral gas species and to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS) for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushFragment -> {True, False, True}
			];
			Download[protocol, ColumnFlushFragmentations],
			{True, False, True},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. For Fragmentation->True, the intact ions will be selected for fragmentation for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushMassDetection -> {
					678 Dalton,
					200 Dalton ;; 3000Dalton,
					{450 Dalton, 567 Dalton}
				}
			];
			Download[protocol, {ColumnFlushMinMasses, ColumnFlushMaxMasses, ColumnFlushMassSelections}],
			{
				{
					Null,
					Quantity[200., "Grams" / "Moles"],
					Null
				},
				{
					Null,
					Quantity[3000., "Grams" / "Moles"],
					Null
				},
				{
					{
						Quantity[678, "Grams" / "Moles"]
					},
					Null,
					{
						Quantity[450, "Grams" / "Moles"],
						Quantity[567, "Grams" / "Moles"]
					}
				}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushScanTime, "Specify the duration of time allowed to pass for each spectral acquisition for a given state of the instrument for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, ColumnFlushScanTimes],
			{0.1 Second, 0.2 Second, 0.4 Second},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushFragmentMassDetection, "Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushFragmentMassDetection -> {All, 200 Dalton ;; 3000 Dalton, {450 Dalton, 567 Dalton}}
			];
			Download[protocol, {ColumnFlushFragmentMinMasses, ColumnFlushFragmentMaxMasses, ColumnFlushFragmentMassSelections}],
			{
				{
					Quantity[20., "Grams" / "Moles"],
					Quantity[200., "Grams" / "Moles"],
					Null
				},
				{
					Quantity[16000., "Grams" / "Moles"],
					Quantity[3000., "Grams" / "Moles"],
					Null
				},
				{
					Null,
					Null,
					{
						Quantity[450, "Grams" / "Moles"],
						Quantity[567, "Grams" / "Moles"]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushCollisionEnergy, "Specify the voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushCollisionEnergy -> {{30 Volt}, {50 Volt}}
			];
			Download[protocol, {
				ColumnFlushCollisionEnergies,
				ColumnFlushLowCollisionEnergies,
				ColumnFlushHighCollisionEnergies,
				ColumnFlushFinalLowCollisionEnergies,
				ColumnFlushFinalHighCollisionEnergies
			}],
			{{Quantity[30., "Volts"], Quantity[50., "Volts"]}, {Null,
				Null}, {Null, Null}, {Null, Null}, {Null, Null}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushCollisionEnergyMassProfile, "Specify the relationship of collision energy with the MassDetection:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushCollisionEnergyMassProfile -> {30 Volt ;; 100Volt, 60 Volt ;; 150Volt}
			];
			Download[protocol, {
				ColumnFlushCollisionEnergies,
				ColumnFlushLowCollisionEnergies,
				ColumnFlushHighCollisionEnergies,
				ColumnFlushFinalLowCollisionEnergies,
				ColumnFlushFinalHighCollisionEnergies
			}],
			{
				{
					Null,
					Null
				},
				{
					Quantity[30., "Volts"],
					Quantity[60., "Volts"]
				},
				{
					Quantity[100., "Volts"],
					Quantity[150., "Volts"]
				},
				{
					Null,
					Null
				},
				{
					Null,
					Null
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushCollisionEnergyMassScan, "Specify Collision energy profile at the end of the scan from CollisionEnergy or CollisionEnergyScanProfile, as related to analyte mass:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushCollisionEnergyMassScan -> {30 Volt ;; 100Volt, 150Volt}
			];
			Download[protocol, {
				ColumnFlushCollisionEnergies,
				ColumnFlushLowCollisionEnergies,
				ColumnFlushHighCollisionEnergies,
				ColumnFlushFinalLowCollisionEnergies,
				ColumnFlushFinalHighCollisionEnergies
			}],
			{
				{
					Quantity[40., "Volts"],
					Quantity[40., "Volts"]
				},
				{
					Null,
					Null
				},
				{
					Null,
					Null
				},
				{
					Quantity[30., "Volts"],
					Quantity[150., "Volts"]
				},
				{
					Quantity[100., "Volts"],
					Quantity[150., "Volts"]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushFragmentScanTime, "Specify the duration of the spectral scanning for each fragmentation of an intact ion for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushFragmentScanTime -> {0.1 Second, 0.2 Second, 0.4 Second}
			];
			Download[protocol, ColumnFlushFragmentScanTimes],
			{0.1 Second, 0.2 Second, 0.4 Second},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushAcquisitionSurvey, "Specify the number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushAcquisitionSurvey -> {
					5,
					10,
					20
				}
			];
			Download[protocol, ColumnFlushAcquisitionSurveys],
			{
				5,
				10,
				20
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushMinimumThreshold, "Specify the minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushMinimumThreshold -> {
					80000 ArbitraryUnit,
					100000 ArbitraryUnit,
					200000 ArbitraryUnit
				}
			];
			Download[protocol, ColumnFlushMinimumThresholds],
			{
				80000,
				100000,
				200000
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushAcquisitionLimit, "Specify the maximum number of total ions for a specific intact ion. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushAcquisitionLimit -> {
					1000000 ArbitraryUnit,
					2000000 ArbitraryUnit,
					500000 ArbitraryUnit
				}
			];
			Download[protocol, ColumnFlushAcquisitionLimits],
			{
				1000000,
				2000000,
				500000
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushCycleTimeLimit, "Specify the maximum duration for spectral scan measurement of fragment ions, as dictated by the initial survey in the first scan for each column flush measurement:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushCycleTimeLimit -> {
					1 Second,
					2 Second,
					10 Second
				}
			];
			Download[protocol, ColumnFlushCycleTimeLimits],
			{Quantity[1.`, "Seconds"], Quantity[2.`, "Seconds"], Quantity[10.`, "Seconds"]},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushExclusionDomain, "Specify Defines when the ExclusionMasses are omitted in the chromatogram. Full indicates for the entire period:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushExclusionDomain -> {
					{
						Full
					},
					{
						5 Minute ;; 6 Minute,
						7 Minute ;; 9 Minute
					}
				}
			];
			Download[protocol, ColumnFlushExclusionDomains],
			{
				{
					{
						Quantity[0., "Minutes"],
						(* ExperimentHPLC is now updated to consider the volume/time required to fill the column with the final gradient. To make our test robust for any column dimensions/volume change, we turn this to a pattern match *)
						GreaterEqualP[Quantity[9., "Minutes"]]
					}
				},
				{
					{
						Quantity[5, "Minutes"],
						Quantity[6, "Minutes"]
					},
					{
						Quantity[7, "Minutes"],
						Quantity[9, "Minutes"]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushExclusionMass, "Specify the intact ions to omit for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushExclusionMass -> {
					{
						{All, 789 Gram / Mole},
						{All, 899 Gram / Mole}
					},
					{
						{Once, 678 Gram / Mole},
						{Once, 567 Gram / Mole},
						{Once, 902 Gram / Mole}
					}
				}
			];
			Download[protocol, ColumnFlushExclusionMasses],
			{
				{
					{
						All,
						Quantity[789, "Grams" / "Moles"]
					},
					{
						All,
						Quantity[899, "Grams" / "Moles"]
					}
				},
				{
					{
						Once,
						Quantity[678, "Grams" / "Moles"]
					},
					{
						Once,
						Quantity[567, "Grams" / "Moles"]
					},
					{
						Once,
						Quantity[902, "Grams" / "Moles"]
					}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushExclusionMassTolerance, "Specify the range above and below each ion in ExclusionMasses to consider for omission for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushExclusionMassTolerance -> {2 Gram / Mole, 0.7 Gram / Mole}
			];
			Download[protocol, ColumnFlushExclusionMassTolerances],
			{Quantity[2., "Grams" / "Moles"], Quantity[0.7, "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushExclusionRetentionTimeTolerance, "Specify the range of time above and below the RetentionTime to consider for omission for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushExclusionRetentionTimeTolerance -> {10 Second, 30 Second}
			];
			Download[protocol, ColumnFlushExclusionRetentionTimeTolerances],
			{10. Second, 30. Second},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionDomain, "Specify when the InclusionMass applies with respective to the chromatogram for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionDomain -> {
					{
						Full,
						10Minute ;; 20Minute
					},
					{
						2 Minute ;; 5 Minute
					}
				}
			];
			Download[protocol, ColumnFlushInclusionDomains],
			{
				{
					(* ExperimentHPLC is now updated to consider the volume/time required to fill the column with the final gradient. To make our test robust for any column dimensions/volume change, we turn this to a pattern match *)
					{Quantity[0., "Minutes"], TimeP},
					{Quantity[10, "Minutes"], Quantity[20, "Minutes"]}
				},
				{{Quantity[2, "Minutes"], Quantity[5, "Minutes"]}}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionMass, "Specify the ions to prioritize during the survey scan for further fragmentation for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionMass -> {
					{
						{Only, 789 Gram / Mole},
						{Only, 899 Gram / Mole}
					},
					{
						{Preferential, 678 Gram / Mole},
						{Preferential, 567 Gram / Mole},
						{Preferential, 902 Gram / Mole}
					}
				}
			];
			Download[protocol, ColumnFlushInclusionMasses],
			{
				{
					{Only, Quantity[789, "Grams" / "Moles"]},
					{Only, Quantity[899, "Grams" / "Moles"]}
				},
				{
					{Preferential, Quantity[678, "Grams" / "Moles"]},
					{Preferential, Quantity[567, "Grams" / "Moles"]},
					{Preferential, Quantity[902, "Grams" / "Moles"]}
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionCollisionEnergy, "Specify an overriding collision energy value that can be applied to the ColumnFlushInclusionMass for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionCollisionEnergy -> {
					{
						75 Volt,
						45 Volt
					},
					{
						67 Volt,
						56 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, ColumnFlushInclusionCollisionEnergies],
			{
				{Quantity[75, "Volts"], Quantity[45, "Volts"]},
				{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionDeclusteringVoltage, "Specify an overriding source voltage value that can be applied to the InclusionMass for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionDeclusteringVoltage -> {
					{
						75 Volt,
						45 Volt
					},
					{
						67 Volt,
						56 Volt,
						90 Volt
					}
				}
			];
			Download[protocol, ColumnFlushInclusionDeclusteringVoltages],
			{
				{Quantity[75, "Volts"], Quantity[45, "Volts"]},
				{Quantity[67, "Volts"], Quantity[56, "Volts"], Quantity[90, "Volts"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionChargeState, "Specify the maximum charge state of the InclusionMass to also consider for inclusion for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionChargeState -> {
					{1, 2},
					{2, 4, 5}
				}
			];
			Download[protocol, ColumnFlushInclusionChargeStates],
			{
				{1, 2},
				{2, 4, 5}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionScanTime, "Specify an overriding scan time duration that can be applied to the InclusionMass for the consequent fragmentation for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionScanTime -> {
					{
						3 Second,
						5 Second
					},
					{
						0.5 Second,
						0.2 Second,
						1 Second
					}
				}
			];
			Download[protocol, ColumnFlushInclusionScanTimes],
			{
				{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
				{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushInclusionMassTolerance, "Specify the range above and below each ion in InclusionMasses to consider for prioritization for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionMassTolerance -> {
					2 Gram / Mole,
					1 Gram / Mole
				}
			];
			Download[protocol, ColumnFlushInclusionMassTolerances],
			{Quantity[2., "Grams" / "Moles"], Quantity[1., "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushSurveyChargeStateExclusion, "Specify if to automatically fill ChargeState exclusion related options and leave out redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushSurveyChargeStateExclusion -> {
					True,
					False
				}
			];
			Download[protocol, ColumnFlushChargeStateSelections],
			{{1, 2}, Null},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushSurveyIsotopeExclusion, "Specify if to automatically fill MassIsotope exclusion related options and leave out redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushSurveyIsotopeExclusion -> {
					True,
					False
				}
			];
			Download[protocol, {ColumnFlushIsotopeMassDifferences, ColumnFlushIsotopeRatios, ColumnFlushIsotopeDetectionMinimums}],
			{
				{{Quantity[1, "Grams" / "Moles"]}, Null},
				{{0.1}, Null},
				{{Quantity[10, "Seconds"^(-1)]}, Null}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushChargeStateExclusionLimit, "Specify the number of ions to survey first with exclusion by ionic state for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushChargeStateExclusionLimit -> {
					5,
					6
				}
			];
			Download[protocol, ColumnFlushChargeStateLimits],
			{5, 6},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushChargeStateExclusion, "Specify the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushChargeStateExclusion -> {
					{1, 2},
					{1}
				}
			];
			Download[protocol, ColumnFlushChargeStateSelections],
			{{1, 2}, {1}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushChargeStateMassTolerance, "Specify the range of m/z to consider for exclusion by ionic state property for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushChargeStateMassTolerance -> {
					2 Gram / Mole,
					2.5 Gram / Mole
				}
			];
			Download[protocol, ColumnFlushChargeStateMassTolerances],
			{Quantity[2., "Grams" / "Moles"], Quantity[2.5, "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushIsotopicExclusion, "Specify The m/z difference between monoisotopic ions as a criterion for survey exclusion for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIsotopicExclusion -> {
					{1 Gram / Mole, 2 Gram / Mole},
					{1 Gram / Mole}
				}
			];
			Download[protocol, ColumnFlushIsotopeMassDifferences],
			{
				{Quantity[1, "Grams" / "Moles"], Quantity[2, "Grams" / "Moles"]},
				{Quantity[1, "Grams" / "Moles"]}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushIsotopeRatioThreshold, "Specify this minimum relative magnitude between monoisotopic ions must be met for exclusion for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIsotopeRatioThreshold -> {
					{0.1, 0.05},
					{0.2}
				}
			];
			Download[protocol, ColumnFlushIsotopeRatios],
			{{0.1, 0.05}, {0.2}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushIsotopeDetectionMinimum, "Specify the acquisition rate of a given intact mass to consider for isotope exclusion in the survey for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIsotopeDetectionMinimum -> {
					10 1 / Second,
					20 1 / Second
				}
			];
			Download[protocol, ColumnFlushIsotopeDetectionMinimums],
			{
				{
					Quantity[10, "Seconds"^(-1)],
					Quantity[20, "Seconds"^(-1)]
				}
			},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushIsotopeMassTolerance, "Specify the range of m/z around a mass to consider for exclusion for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIsotopeMassTolerance -> {
					1 Gram / Mole,
					2 Gram / Mole
				}
			];
			Download[protocol, ColumnFlushIsotopeMassTolerances],
			{Quantity[1., "Grams" / "Moles"], Quantity[2., "Grams" / "Moles"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushIsotopeRatioTolerance, "Specify the range of relative magnitude around IsotopeRatio to consider for isotope exclusion for column flush measurements:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIsotopeRatioTolerance -> {
					10 Percent,
					25 Percent
				}
			];
			Download[protocol, ColumnFlushIsotopeRatioTolerances],
			{Quantity[10., "Percent"], Quantity[25., "Percent"]},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushAbsorbanceWavelength, "Specify the physical properties of light passed through the flow for the PhotoDiodeArray (PDA) Detector for each column flush measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushAbsorbanceWavelength -> Span[300 Nanometer, 450 Nanometer]
			];
			Download[protocol, {ColumnFlushMinAbsorbanceWavelength, ColumnFlushMaxAbsorbanceWavelength}],
			{300. Nanometer, 450. Nanometer},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushWavelengthResolution, "Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for each column flush measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushWavelengthResolution -> 2.4 * Nanometer
			];
			Download[protocol, ColumnFlushWavelengthResolution],
			2.4 * Nanometer,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushUVFilter, "Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors for each column flush measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushUVFilter -> True
			];
			Download[protocol, ColumnFlushUVFilter],
			True,
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushAbsorbanceSamplingRate, "Specify the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time for each column flush measurement:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushAbsorbanceSamplingRate -> 10 / Second
			];
			Download[protocol, ColumnFlushAbsorbanceSamplingRate],
			10. * 1 / Second,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushDwellTime, "Specify dwell time when scaning the sample in single or a list or single wavelengths when using qqq as the mass analyzer:"},
			protocol = ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				ColumnFlushAcquisitionMode -> MultipleReactionMonitoring,
				ColumnFlushMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				ColumnFlushFragmentMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				ColumnFlushDwellTime -> 150 Millisecond
			];
			Download[protocol, ColumnFlushDwellTimes],
			{{
				150 Millisecond,
				150 Millisecond,
				150 Millisecond,
				150 Millisecond,
				150 Millisecond
			}},
			Variables :> {protocol}
		],
		Example[
			{Options, ColumnFlushMassDetectionStepSize, "Specify the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnFlushMassDetectionStepSize -> {0.3 Gram / Mole}];
			Download[protocol, ColumnFlushMassDetectionStepSizes],
			{Quantity[0.3, ("Grams") / ("Moles")]},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushCollisionCellExitVoltage, "Specify the value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnFlushCollisionCellExitVoltage -> {6 Volt}
			];
			Download[protocol, ColumnFlushCollisionCellExitVoltages],
			{6 Volt},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushNeutralLoss, "Specify a neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1):"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnFlushNeutralLoss -> {123 Gram / Mole}
			];
			Download[protocol, ColumnFlushNeutralLosses],
			{Quantity[123., ("Grams") / ("Moles")]},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, ColumnFlushMultipleReactionMonitoringAssays, "Specify the ion corresponding to the compound of interest is targetted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				ColumnFlushMultipleReactionMonitoringAssays -> {{{456 Gram / Mole, 60 Volt, 123 Gram / Mole,
					200 Millisecond}, {456 Gram / Mole, 60 Volt, 123 Gram / Mole,
					200 Millisecond}, {456 Gram / Mole, 60 Volt, 123 Gram / Mole,
					200 Millisecond}}}
			];
			Download[protocol, ColumnFlushMultipleReactionMonitoringAssays],
			{<|MS1Mass -> {Quantity[456, ("Grams") / ("Moles")],
				Quantity[456, ("Grams") / ("Moles")],
				Quantity[456, ("Grams") / ("Moles")]},
				CollisionEnergy -> {Quantity[60, "Volts"], Quantity[60, "Volts"],
					Quantity[60, "Volts"]},
				MS2Mass -> {Quantity[123, ("Grams") / ("Moles")],
					Quantity[123, ("Grams") / ("Moles")],
					Quantity[123, ("Grams") / ("Moles")]},
				DwellTime -> {Quantity[200, "Milliseconds"],
					Quantity[200, "Milliseconds"], Quantity[200, "Milliseconds"]}|>},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options, Detector, "Specify which detector(s) will be used to collect the data:"},
			options = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Detector -> {Temperature, PhotoDiodeArray},
				Output -> Options
			];
			Lookup[options, Detector],
			{Temperature, PhotoDiodeArray},
			Variables :> {options}
		],
		Example[
			{Options, Detector, "Specify only one detector that will be used to collect the data:"},
			options = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Detector -> PhotoDiodeArray,
				Output -> Options
			];
			Lookup[options, Detector],
			{PhotoDiodeArray},
			Variables :> {options}
		],
		Example[
			{Options, Analytes, "Specify which detector(s) will be used to collect the data:"},
			options = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Analytes -> {
					Model[Molecule, "id:eGakldJvLvbB"],
					Model[Molecule, "id:eGakldJvLvbB"],
					Model[Molecule, "id:eGakldJvLvbB"]
				},
				Output -> Options
			];
			Lookup[options, Analytes],
			{
				Model[Molecule, "id:eGakldJvLvbB"],
				Model[Molecule, "id:eGakldJvLvbB"],
				Model[Molecule, "id:eGakldJvLvbB"]
			},
			Variables :> {options}
		],
		(* funtopia shared options *)
		Example[{Options, NumberOfReplicates, "Indicate the number of times the experiment should be replicated:"},
			protocol = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], NumberOfReplicates -> 3];
			Download[protocol, InjectionTable[[All, Type]]],
			{ColumnPrime, Sample, Sample, Sample, ColumnFlush},
			Variables :> {protocol}
		],
		Example[{Options, ImageSample, "Indicate whether samples should be imaged afterwards:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], ImageSample -> False, Output -> Options];
			Lookup[options, ImageSample],
			False,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicate whether samples should be volume measured afterwards:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], MeasureVolume -> False, Output -> Options];
			Lookup[options, MeasureVolume],
			False,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicate whether samples should be weighed afterwards:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], MeasureWeight -> False, Output -> Options];
			Lookup[options, MeasureWeight],
			False,
			Variables :> {options}
		],

		Example[{Options, Name, "Specify the Name of the created LCMS object:"},
			(
				packet = ExperimentLCMS[
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Name -> "My special LCMS object name", Upload -> False][[1]];
				Lookup[packet, Name]
			),
			"My special LCMS object name",
			Variables :> {packet}
		],
		Example[{Options, Template, "Use a previous LCMS protocol as a template for a new one:"},
			protocol = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Template -> Object[Protocol, LCMS, "Test Template Protocol for ExperimentLCMS" <> $SessionUUID]
			];
			Download[protocol, SampleTemperature],
			20 * Celsius,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicate if the SamplesIn should be incubated at a fixed temperature prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Provide the temperature at which the SamplesIn should be incubated:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], IncubationTemperature -> 40 Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Indicate SamplesIn should be heated for 40 minutes prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], IncubationTime -> 40 Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Indicate the SamplesIn should be mixed and heated for up to 2 hours or until any solids are fully dissolved:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], MixUntilDissolved -> True, MaxIncubationTime -> 2 Hour, Output -> Options];
			Lookup[options, MaxIncubationTime],
			2 Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Indicate the instrument which should be used to heat SamplesIn:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], AnnealingTime -> 40 Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when transferring the input sample to a new container before incubation:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], IncubateAliquot -> 450 Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			450 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, IncubateAliquotContainer, "Indicate that the input samples should be transferred into 2mL tubes before the are incubated:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Mix, "Indicates if the SamplesIn should be  prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeInstrument, "Set the centrifuge that should be used to spin the input samples:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeIntensity, "Indicate the rotational speed which should be applied to the input samples during centrifugation:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CentrifugeIntensity -> 1000 RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeTime, "Specify the SamplesIn should be centrifuged for 2 minutes:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CentrifugeTime -> 2 Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			2 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeTemperature, "Indicate the temperature at which the centrifuge chamber should be held while the samples are being centrifuged:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CentrifugeTemperature -> 10 Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeAliquot, "Indicate the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CentrifugeAliquot -> 450 Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			450 Microliter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::AliquotRequired},
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeAliquotContainer, "Indicate that the input samples should be transferred into 2mL tubes before the are centrifuged:"},
			options = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Messages :> {Warning::AliquotRequired},
			Variables :> {options},
			TimeConstraint -> 240
		],
		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FilterInstrument -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], Filter -> Model[Item, Filter, "Membrane Filter, PTFE, 0.22um, 142mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Membrane Filter, PTFE, 0.22um, 142mm"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FilterPoreSize -> 0.22 Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], PrefilterPoreSize -> 1.` * Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.` * Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 Minute, Output -> Options];
			Lookup[options, FilterTime],
			20 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 30 Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			30 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FilterAliquot -> 200 Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			200 Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], FilterContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentLCMS[Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, Aliquot, "If input samples are not in a supported container, force aliquotting in correct container type:"},
			options = ExperimentLCMS[Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID], InjectionVolume -> 10 Microliter, Output -> Options];
			Lookup[options, {Aliquot, AliquotContainer}],
			{True, {{1, ObjectP@Model[Container, Plate, "96-well 2mL Deep Well Plate"]}}},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], AliquotAmount -> 0.08 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08 Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], AssayVolume -> 0.08 Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08 Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], TargetConcentration -> 45 Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			45 Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AmbiguousAnalyte}
		],
		Example[{Options, TargetConcentrationAnalyte, "Specify which analyte will used to track when diluting the aliquot the SamplesIn:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				TargetConcentrationAnalyte -> Model[Molecule, "id:eGakldJvLvbB"],
				TargetConcentration -> 45 Micromolar, Output -> Options
			];
			Lookup[options, TargetConcentration],
			45 Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Aliquot -> True, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
			Variables :> {options}
		],
		(*===MESSAGES===*)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentLCMS[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentLCMS[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentLCMS[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentLCMS[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		(* -- Rounding Tests -- *)
		Example[{Messages, "GradientPercentPrecision", "Return a warning when the percent in Gradient is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				GradientA -> {{0 Minute, 90.83298872598973 Percent}, {10 Minute, 70.83298872598973 Percent}},
				Output -> Options
			];
			Lookup[options, GradientA],
			{{0 Minute, 90.8 Percent}, {10 Minute, 70.8 Percent}},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "WavelengthPrecision", "Return a warning when the AbsorbanceWavelength is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				AbsorbanceWavelength -> 278.82579783927 Nanometer,
				Output -> Options
			];
			Lookup[options, AbsorbanceWavelength],
			279 Nanometer,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "FlowRatePrecision", "Return a warning when the FlowRate is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				FlowRate -> 0.57829279572972578978 Milliliter / Minute,
				Output -> Options
			];
			Lookup[options, FlowRate],
			0.58 Milliliter / Minute,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "MassPrecision", "Return a warning when a mass is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				StandardExclusionMassTolerance -> 3.9258287Dalton,
				Output -> Options
			];
			Lookup[options, StandardExclusionMassTolerance],
			{Quantity[3.9`, ("Grams") / ("Moles")]},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "VoltagePrecision", "Return a warning when a voltage is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				BlankStepwaveVoltage -> 20.9258287 Volt,
				Output -> Options
			];
			Lookup[options, BlankStepwaveVoltage],
			20.9 Volt,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "TimePrecision", "Return a warning when a time value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnPrimeExclusionDomain -> 0Minute ;; 20.9058287 Minute,
				Output -> Options
			];
			Lookup[options, ColumnPrimeExclusionDomain],
			{Quantity[0, "Minutes"] ;; Quantity[20.9, "Minutes"]},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "DimensionlessPrecision", "Return a warning when a dimensionless value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				IsotopeRatioThreshold -> 0.187892789,
				Output -> Options
			];
			Lookup[options, IsotopeRatioThreshold],
			{{0.19`}},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "PerSecondPrecision", "Return a warning when a 1/Second value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnFlushIsotopeDetectionMinimum -> 20.79257258957278 / Second,
				Output -> Options
			];
			FirstOrDefault@Lookup[options, ColumnFlushIsotopeDetectionMinimum],
			Quantity[21, 1 / ("Seconds")],
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		Example[{Messages, "PercentPrecision", "Return a warning when a percent value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				StandardIsotopeRatioTolerance -> 20.79257258957278 Percent,
				Output -> Options
			];
			Lookup[options, StandardIsotopeRatioTolerance],
			{21 Percent},
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "LargeVoltagePrecision", "Return a warning when a large voltage value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				BlankESICapillaryVoltage -> 1.892787598 Kilo * Volt,
				Output -> Options
			];
			Lookup[options, BlankESICapillaryVoltage],
			1.9 Kilo * Volt,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "TemperaturePrecision", "Return a warning when a temperature value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnPrimeSourceTemperature -> 147.892787598 Celsius,
				Output -> Options
			];
			Lookup[options, ColumnPrimeSourceTemperature],
			148 Celsius,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Messages, "AirFlowRatePrecision", "Return a warning when an air flow rate value is specified to unfeasible precision:"},
			options = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnFlushConeGasFlow -> 167.892787598 Liter / Hour,
				Output -> Options
			];
			Lookup[options, ColumnFlushConeGasFlow],
			168 Liter / Hour,
			Messages :> {
				Warning::InstrumentPrecision
			},
			Variables :> {options},
			EquivalenceFunction -> Equal
		],
		(* -- Messages -- *)
		Example[{Messages, "MassAnalyzerAndMassSpecInstrumentConflict", "MassAnalyzer and MassSpectrometerInstrument should matched with each other:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				MassSpectrometerInstrument ->
					Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"],
				MassAnalyzer -> TripleQuadrupole],
			$Failed,
			Messages :> {
				Error::MassAnalyzerAndMassSpecInstrumentConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OnlyOneCalibrantWillBeRan", "Only one calibrant will be run for using QTOF as the mass analyzer:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> QTOF,
				Calibrant -> Model[Sample, StockSolution, Standard, "id:AEqRl9KV3vPR"],
				SecondCalibrant -> Model[Sample, StockSolution, Standard, "id:1ZA60vLmN0mE"]
			],
			ObjectP[Object[Protocol, LCMS]],
			Messages :> {
				Warning::OnlyOneCalibrantWillBeRan
			}
		],
		Example[{Messages, "AcquisitionWindowTooLong", "Specified acquisition windows cannot exceed the gradient:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionWindow -> 0 Minute ;; 60 Minute
			],
			$Failed,
			Messages :> {
				Error::AcquisitionWindowTooLong,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LCMSCollisionEnergyAcquisitionModeConflict", "If the AcquisitionMode is not MultipleReactionMonitoring, the CollisionEnergies cannot be set to a list of single values. "},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				CollisionEnergy -> {{20 Volt, 40 Volt, 60 Volt}}
			],
			$Failed,
			Messages :> {
				Error::LCMSCollisionEnergyAcquisitionModeConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ExclusionModeMustBeSame", "ExclusionMasses must all have the same exclusion mode:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushExclusionMass -> {
					{
						{All, 789 Gram / Mole},
						{Once, 899 Gram / Mole}
					},
					{
						{Once, 678 Gram / Mole},
						{All, 567 Gram / Mole},
						{Once, 902 Gram / Mole}
					}
				}
			],
			$Failed,
			Messages :> {
				Error::ExclusionModeMustBeSame,
				Error::InvalidOption
			}
		],
		Example[{Messages, "GradientOutOfOrder", "If Gradient is a table, each entry must be ascending in time:"},
			ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{25. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{35.1 Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{40. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute}
				}
			],
			$Failed,
			Messages :> {
				Error::GradientOutOfOrder,
				Error::InvalidOption
			}
		],
		Example[{Messages, "GradientAmbiguity", "If Gradient is a table, then auxillary options lead to ambiguity:"},
			protocol = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{35. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{35.1 Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{40. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute}
				},
				GradientB -> 50 Percent
			];
			Download[protocol, GradientAs],
			{
				{
					{Quantity[0., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"]}
				}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::GradientAmbiguity
			}
		],
		Example[{Messages, "StandardOptionsButNoFrequency", "StandardFrequency cannot be None if other standard options are defined:"},
			ExperimentLCMS[ Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Standard -> Automatic,
				StandardInjectionVolume -> 15 Microliter,
				StandardFrequency -> None
			],
			$Failed,
			Messages :> {
				Error::StandardOptionsButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BlankOptionsButNoFrequency", "BlankFrequency cannot be None if other blank options are defined:"},
			ExperimentLCMS[ Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Blank -> Automatic,
				BlankInjectionVolume -> 15 Microliter,
				BlankFrequency -> None
			],
			$Failed,
			Messages :> {
				Error::BlankOptionsButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "AbsorbanceRateAdjusted", "Adjust the sampling rate if not an available value:"},
			protocol = ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AbsorbanceWavelength -> All,
				WavelengthResolution -> 1.2 Nanometer,
				AbsorbanceSamplingRate -> 30 * 1 / Second
			];
			Download[protocol, AbsorbanceSamplingRates],
			{
				Quantity[20., 1 / ("Seconds")],
				Quantity[20., 1 / ("Seconds")],
				Quantity[20., 1 / ("Seconds")]
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::AbsorbanceRateAdjusted}
		],
		Example[{Messages, "DataIndependentSoleWindow", "Return an error when DataIndependent is specified in a multi-acquisition window run:"},
			ExperimentLCMS[ Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				AcquisitionMode -> {MS1FullScan, DataIndependent}
			],
			$Failed,
			Messages :> {Error::DataIndependentSoleWindow, Error::InvalidOption}
		],
		Example[{Messages, "RemovedExtraGradientEntries", "Duplicate times in the gradients will be removed but a warning will be thrown:"},
			protocol = ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{35. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{35.1 Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute},
					{40. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter / Minute}
				}
			];
			Download[protocol, GradientAs],
			{
				{
					{Quantity[0., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"]}
				}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal,
			Messages :> {
				Warning::RemovedExtraGradientEntries
			}
		],
		Example[{Messages, "OverwritingGradient", "If a value in a supplied gradient is overwritten, then a new gradient method should be made:"},
			protocol = ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Gradient -> Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID],
				FlowRate -> 2 Milliliter / Minute
			];
			typesGradients = {Type, Gradient} /. Download[protocol, InjectionTable];
			downloadedITGradients = Download[Cases[typesGradients, {Sample, x_} :> x], Object];
			And[
				!MatchQ[downloadedITGradients, {ObjectP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID]]..}],
				MatchQ[downloadedITGradients, {ObjectP[Object[Method, Gradient]]..}]
			],
			True,
			Variables :> {protocol, typesGradients, downloadedITGradients},
			Messages :> {Warning::OverwritingGradient,Warning::HPLCGradientNotReequilibrated}
		],
		Example[{Messages, "GradientSingleton", "Return an error when the specified gradient only has one entry:"},
			ExperimentLCMS[ Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Gradient -> {{5 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter / Minute}}
			],
			$Failed,
			Messages :> {Error::GradientSingleton,Error::InvalidOption}
		],
		Example[{Messages, "IncompatibleMaterials", "Return a warning when a sample incompatible with the instrument:"},
			ExperimentLCMS[
				Object[Sample, "Test Incompatible Sample for ExperimentLCMS tests" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, LCMS]],
			Messages :> {Error::IncompatibleMaterials}
		],
		Example[
			{Messages, "RepeatedDetectors", "Duplicate entries in the Detector option are removed:"},
			options = ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Detector -> {Temperature, PhotoDiodeArray, PhotoDiodeArray, Temperature},
				Output -> Options
			];
			Lookup[options, Detector],
			{Temperature, PhotoDiodeArray},
			Messages :> {Warning::RepeatedDetectors},
			Variables :> {options}
		],
		Example[
			{Messages, "NonBinaryHPLC", "Non-binary gradients are not supported in ExperimentLCMS:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Gradient -> {
					{
						Quantity[0., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					},
					{
						Quantity[4., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					}
				}
			],
			$Failed,
			Messages :> { Error::NonBinaryHPLC, Warning::HPLCGradientNotReequilibrated, Error::InvalidOption}
		],
		Example[
			{Messages, "NonBinaryHPLC", "Non-binary gradients are not supported in ExperimentLCMS (2):"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Gradient -> Object[Method, Gradient, "LCMS Non-binary gradient for testing"]
			],
			$Failed,
			Messages :> {Error::InvalidOption, Warning::HPLCGradientNotReequilibrated,Error::NonBinaryHPLC}
		],
		(*Example[
		{Messages,"OverwritingMassAcquisitionMethod","If a MassAcquisition method is specified and mass spec options are specified separately, a new method will be created:"},
		Module[{customInjectionTable,packet},
			customInjectionTable={
				{ColumnPrime,Null,Null,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 1"<>$SessionUUID]},
				{Sample,Object[Sample, "Test Sample 1 for ExperimentLCMS tests"<>$SessionUUID],2 Microliter,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 2"<>$SessionUUID]},
				{Blank,Model[Sample,"Milli-Q water"],5 Microliter,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 2"<>$SessionUUID]},
				{Sample,Object[Sample, "Test Sample 2 for ExperimentLCMS tests"<>$SessionUUID],2 Microliter,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 2"<>$SessionUUID]},
				{ColumnFlush,Null,Null,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 1"<>$SessionUUID]},
				{Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],4 Microliter,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 2"<>$SessionUUID]},
				{Sample,Object[Sample, "Test Sample 3 for ExperimentLCMS tests"<>$SessionUUID],2 Microliter,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 2"<>$SessionUUID]},
				{ColumnFlush,Null,Null,Automatic,Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID],Object[Method,MassAcquisition,"LCMS Tests MassAcquisitionMethod 1"<>$SessionUUID]}
			};
			packet=ExperimentLCMS[{
				Object[Sample,"Test Sample 1 for ExperimentLCMS tests"<>$SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentLCMS tests"<>$SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentLCMS tests"<>$SessionUUID]
			},
				InjectionTable->customInjectionTable,
				StandardAcquisitionMode -> MS1MS2ProductIonScan,
				Upload->False
			];
			Lookup[packet[[1]], Replace[InjectionTable]]
		],
		{
			<|
				Type -> ColumnPrime,
				Sample -> Null,
				InjectionVolume -> Null,
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> Sample,
				Sample -> LinkP[Object[Sample,"Test Sample 1 for ExperimentLCMS tests"<>$SessionUUID]],
				InjectionVolume -> Quantity[2., "Microliters"],
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> Blank,
				Sample -> LinkP[Model[Sample,"Milli-Q water"]],
				InjectionVolume -> Quantity[5., "Microliters"],
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> Sample,
				Sample -> LinkP[Object[Sample,"Test Sample 2 for ExperimentLCMS tests"<>$SessionUUID]],
				InjectionVolume -> Quantity[2., "Microliters"],
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> ColumnFlush,
				Sample -> Null,
				InjectionVolume -> Null,
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> Standard,
				Sample -> LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],
				InjectionVolume -> Quantity[4., "Microliters"],
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> Sample,
				Sample -> LinkP[Object[Sample,"Test Sample 3 for ExperimentLCMS tests"<>$SessionUUID]],
				InjectionVolume -> Quantity[2., "Microliters"],
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>,
			<|
				Type -> ColumnFlush,
				Sample -> Null,
				InjectionVolume -> Null,
				Gradient -> LinkP[Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests"<>$SessionUUID]],
				DilutionFactor -> Null,
				ColumnTemperature -> Quantity[45., "DegreesCelsius"],
				Data -> Null,
				MassSpectrometry -> LinkP[Object[Method,MassAcquisition]]
			|>
		},
		Messages:>{Warning::HPLCGradientNotReequilibrated,Warning::OverwritingMassAcquisitionMethod}
	],*)
		Example[
			{Messages, "OverlappingAcquisitionWindows", "Acquisition Windows cannot be overlapping:"},
			ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionWindow -> {
					2. Minute ;; 4.66 Minute,
					4.67 Minute ;; 5.99 Minute,
					6. Minute ;; 7.32 Minute,
					7.33 Minute ;; 10. Minute,
					10.1 Minute ;; 12 Minute,
					11.1 Minute ;; 14.99 Minute,
					15 Minute ;; 20 Minute
				}
			],
			$Failed,
			Messages :> {Warning::InstrumentPrecision, Error::OverlappingAcquisitionWindows, Error::InvalidOption}
		],
		Example[
			{Messages, "FragmentConflict", "When Fragment disagrees with the AcquistionMode throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				Fragment -> {True, True, False},
				AcquisitionMode -> {MS1FullScan, MS1MS2ProductIonScan, DataDependent}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::FragmentConflict}
		],
		Example[
			{Messages, "MassDetectionConflict", "When MassDetection is incompatible with AcquisitionMode throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardMassDetection -> 500 Gram / Mole ;; 1500 Gram / Mole,
				StandardAcquisitionMode -> MS1MS2ProductIonScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::MassDetectionConflict}
		],
		Example[
			{Messages, "LCMSInvalidScanTime", "When the instrumentation is unable to scan a mass range in the specified ScanTime the function fails and an error is returned:"},
			ExperimentLCMS[Object[Sample,
				"Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				MassAnalyzer -> TripleQuadrupole, ScanTime -> 0.015 Second],
			$Failed,
			Messages :> {Error::InvalidOption, Error::LCMSInvalidScanTime}
		],
		Example[
			{Messages, "FragmentDetectionConflict", "When FragmentMassDetection is incompatible with the AcquisitionMode throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankFragmentMassDetection -> 500 Gram / Mole ;; 1500 Gram / Mole,
				BlankAcquisitionMode -> MS1FullScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::FragmentDetectionConflict}
		],
		Example[
			{Messages, "CollisionEnergyConflict", "When CollisionEnergy is incompatible with the AcquisitionMode throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeCollisionEnergy -> 50 Volt,
				ColumnPrimeAcquisitionMode -> MS1FullScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::CollisonEnergyConflict}
		],
		Example[
			{Messages, "CollisionEnergyProfileConflict", "When CollisionEnergy and CollisionEnergyScan are both defined throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushCollisionEnergy -> 40 Volt,
				ColumnFlushCollisionEnergyMassProfile -> 25 Volt ;; 78 Volt
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::CollisionEnergyProfileConflict}
		],
		Example[
			{Messages, "CollisionEnergyProfileConflict", "When CollisionEnergy and CollisionEnergyScan are both defined throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				AcquisitionMode -> DataIndependent,
				CollisionEnergy -> 40 Volt,
				CollisionEnergyMassProfile -> 25 Volt ;; 78 Volt
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::CollisionEnergyProfileConflict}
		],
		Example[
			{Messages, "CollisionEnergyScanConflict", "CollisionEnergyMassScan can only be defined when AcquisitionMode is DataDependent:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAcquisitionMode -> DataIndependent,
				StandardCollisionEnergyMassScan -> 25 Volt ;; 78 Volt
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::CollisionEnergyScanConflict}
		],
		Example[
			{Messages, "FragmentScanTimeConflict", "When FragmentScanTime is set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				FragmentScanTime -> 1 Second,
				AcquisitionMode -> DataIndependent
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::FragmentScanTimeConflict}
		],
		Example[
			{Messages, "AcquisitionSurveyConflict", "When AcquisitionSurvey is set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardAcquisitionSurvey -> 5,
				StandardAcquisitionMode -> MS1MS2ProductIonScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::AcquisitionSurveyConflict}
		],
		Example[
			{Messages, "AcquisitionLimitConflict", "When AcquisitionLimit is set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankAcquisitionLimit -> 800000 ArbitraryUnit,
				BlankAcquisitionMode -> MS1FullScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::AcquisitionLimitConflict}
		],
		Example[
			{Messages, "CycleTimeLimitConflict", "When CycleTimeLimit is set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeCycleTimeLimit -> 10 Minute,
				ColumnPrimeAcquisitionMode -> MS1MS2ProductIonScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::CycleTimeLimitConflict}
		],
		Example[
			{Messages, "ExclusionModeConflict", "When ExclusionMass options are set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushExclusionMass -> {All, 100 Gram / Mole},
				ColumnFlushAcquisitionMode -> DataIndependent
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ExclusionModeConflict}
		],
		Example[
			{Messages, "ExclusionMassToleranceConflict", "ExclusionMassTolerance must be set when ExclusionMass is; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ExclusionMassTolerance -> Null,
				ExclusionMass -> {All, 100 Gram / Mole}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ExclusionMassToleranceConflict}
		],
		Example[
			{Messages, "ExclusionRetentionTimeConflict", "ExclusionRetentionTime must be set when ExclusionMass options are; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardExclusionRetentionTimeTolerance -> Null,
				StandardExclusionMass -> {Once, 100 Gram / Mole}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ExclusionRetentionTimeConflict}
		],
		Example[
			{Messages, "InclusionModeConflict", "When InclusionMass related options are defined, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushInclusionMass -> {Preferential, 890 Gram / Mole},
				ColumnFlushAcquisitionMode -> MS1FullScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::InclusionModeConflict}
		],
		Example[
			{Messages, "InclusionMassToleranceConflict", "InclusionMassTolerance must be set when InclusionMass options are; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankInclusionMass -> {Only, 890 Gram / Mole},
				BlankInclusionMassTolerance -> Null
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::InclusionMassToleranceConflict}
		],
		Example[
			{Messages, "ChargeStateExclusionLimitConflict", "When ChargeStateExclusionLimit exceeds AcquisitionSurvey throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeChargeStateExclusionLimit -> 10,
				ColumnPrimeAcquisitionSurvey -> 5
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ChargeStateExclusionLimitConflict}
		],
		Example[
			{Messages, "ChargeStateExclusionConflict", "When ChargeStateExclusion options are set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ChargeStateExclusion -> {{1, 2}, {1, 2}, {1, 2}},
				AcquisitionMode -> MS1FullScan
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ChargeStateExclusionConflict}
		],
		Example[
			{Messages, "ChargeStateMassToleranceConflict", "ChargeStateMassTolerance must be set when ChargeStateExclusion options are; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				StandardChargeStateMassTolerance -> 1 Gram / Mole,
				StandardChargeStateExclusion -> Null
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ChargeStateMassToleranceConflict}
		],
		Example[
			{Messages, "IsotopicExclusionLimitConflict", "When IsotopicExclusionMass exceeds two entries throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				BlankIsotopicExclusion -> {{1 Gram / Mole, 2 Gram / Mole, 3 Gram / Mole}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::IsotopicExclusionLimitConflict}
		],
		Example[
			{Messages, "IsotopicExclusionMassConflict", "When IsotopicExclusionMass options are set, AcquisitionMode must be DataDependent; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnPrimeIsotopicExclusion -> {1 Gram / Mole},
				ColumnPrimeAcquisitionMode -> DataIndependent
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::IsotopicExclusionMassConflict}
		],
		Example[
			{Messages, "IsotopeMassToleranceConflict", "IsotopeMassTolerance must be set when ChargeStateExclusion or IsotopicExclusionMass options are; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnFlushIsotopeMassTolerance -> Null,
				ColumnFlushChargeStateExclusion -> {{1, 2}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::IsotopeMassToleranceConflict}
		],
		Example[
			{Messages, "IsotopeRatioToleranceConflict", "IsotopeRatioTolerance must be set when IsotopicExclusionMass options are; otherwise, throw an error and return $Failed:"},
			ExperimentLCMS[{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				IsotopeRatioTolerance -> Null,
				IsotopicExclusion -> {1 Gram / Mole}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::IsotopeRatioToleranceConflict}
		],
		Example[{Messages, "ColumnPrimeConflict", "Throw an error when column prime turned off, but an option is specified:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnRefreshFrequency -> Null,
				ColumnPrimeIonMode -> Negative
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ColumnPrimeConflict}
		],
		Example[{Messages, "ColumnFlushConflict", "Throw an error when column flush turned off, but an option is specified:"},
			customInjectionTable = {
				{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Automatic},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Automatic}
			};
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				InjectionTable -> customInjectionTable,
				ColumnFlushFragment -> True
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::ColumnFlushConflict},
			Variables :> {customInjectionTable}
		],
		Example[{Messages, "OnlyHPLCAvailable", "If a liquid chromatography device not amendable to LCMS is requested, an error is thrown:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ChromatographyInstrument -> Model[Instrument, HPLC, "Waters Acquity UPLC H-Class PDA"]
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::OnlyHPLCAvailable}
		],
		Example[
			{Messages, "InjectionTableForeignSamples", "The InjectionTable contains samples that are not in the input or doesn't account for all of the samples:"},
			customInjectionTable = {
				{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]}
			};

			ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
			},
				InjectionTable -> customInjectionTable
			],
			$Failed,
			Messages :> {
				Error::InjectionTableForeignSamples,
				Error::InvalidOption
			},
			Variables :> {customInjectionTable}
		],
		Example[
			{Messages, "InjectionTableStandardConflict", "Both InjectionTable and Standard are specified but have a mismatch:"},
			customInjectionTable = {
				{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], 4 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Standard, Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"], 4 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]}
			};

			ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID]
			},
				InjectionTable -> customInjectionTable,
				Standard -> {Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]}
			],
			$Failed,
			Messages :> {
				Error::InjectionTableStandardConflict,
				Error::InvalidOption
			},
			Variables :> {customInjectionTable}
		],
		Example[
			{Messages, "InjectionTableBlankConflict", "Both InjectionTable and Blank are specified but have a mismatch:"},
			customInjectionTable = {
				{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Blank, Model[Sample, "Milli-Q water"], 4 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Blank, Model[Sample, "Methanol"], 4 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]}
			};
			ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID]
			},
				InjectionTable -> customInjectionTable,
				Blank -> {Model[Sample, "Milli-Q water"]}
			],
			$Failed,
			Messages :> {
				Error::InjectionTableBlankConflict,
				Error::InvalidOption
			},
			Variables :> {customInjectionTable}
		],
		Example[{Messages, "IncompatibleColumnType", "Warning is thrown if specified Column's SeparationMode does not match the specified SeparationMode:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				SeparationMode -> ReversePhase,
				Column -> Model[Item, Column, "DNAPac PA200 4x250mm Column"]
			],
			$Failed,
			Messages :> {Error::HPLCColumnsCannotFitLCMS, Error::InvalidOption, Warning::IncompatibleColumnType}
		],
		Example[{Messages, "IncompatibleColumnType", "Warning is thrown if specified GuardColumn's SeparationMode does not match the specified SeparationMode:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				SeparationMode -> IonExchange,
				Column -> Model[Item, Column, "id:KBL5DvYOa5vv"],
				GuardColumn -> Model[Item, Column, "SecurityGuard Guard Cartridge Kit"]
			],
			ObjectP[Object[Protocol, LCMS]],
			Messages :> {Warning::IncompatibleColumnType}
		],
		Example[{Messages, "IncompatibleColumnTechnique", "Warning is thrown if specified Column's ChromatographyType is not HPLC:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Column -> Model[Item, Column, "HiTrap 5x5mL Desalting Column"]
			],
			$Failed,
			Messages :> {Error::HPLCColumnsCannotFitLCMS, Error::InvalidOption, Warning::IncompatibleColumnTechnique}
		],
		Example[{Messages, "InvalidGradientCompositionOptions", "Error if a specified gradient's total buffer composition is greater than 100%:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				GradientA -> {{0 Minute, 10 Percent}, {5 Minute, 90 Percent}},
				GradientB -> {{0 Minute, 90 Percent}, {5 Minute, 20 Percent}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::InvalidGradientCompositionOptions}
		],
		Example[{Messages, "InvalidGradientCompositionOptions", "Error if a specified standard gradient's total buffer composition is greater than 100%:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 90 Percent}},
				StandardGradientB -> {{0 Minute, 90 Percent}, {5 Minute, 20 Percent}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Warning::HPLCGradientNotReequilibrated,Error::InvalidGradientCompositionOptions}
		],
		Example[{Messages, "InvalidGradientCompositionOptions", "Error if a specified blank gradient's total buffer composition is greater than 100%:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 90 Percent}},
				BlankGradientB -> {{0 Minute, 90 Percent}, {5 Minute, 20 Percent}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Warning::HPLCGradientNotReequilibrated,Error::InvalidGradientCompositionOptions}
		],
		Example[{Messages, "InvalidGradientCompositionOptions", "Error if a specified column prime gradient's total buffer composition is greater than 100%:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnPrimeGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 90 Percent}},
				ColumnPrimeGradientB -> {{0 Minute, 90 Percent}, {5 Minute, 20 Percent}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Warning::HPLCGradientNotReequilibrated,Error::InvalidGradientCompositionOptions}
		],
		Example[{Messages, "InvalidGradientCompositionOptions", "Error if a specified column flush gradient's total buffer composition is greater than 100%:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				ColumnFlushGradientA -> {{0 Minute, 10 Percent}, {5 Minute, 90 Percent}},
				ColumnFlushGradientB -> {{0 Minute, 90 Percent}, {5 Minute, 20 Percent}}
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::InvalidGradientCompositionOptions}
		],
		Example[{Messages, "HPLCIncompatibleAliquotContainer", "Error if the specified container in which to aliquot the samples is not compatible with an HPLC instrument:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				AliquotAmount -> 50 Microliter,
				AssayVolume -> 200 Microliter,
				AliquotContainer -> Model[Container, Vessel, "2mL Tube"]
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::HPLCIncompatibleAliquotContainer, Error::AliquotContainers}
		],
		Example[{Messages, "IncompatibleContainerModel", "Error if aliquot is explicity prohibited and the input samples are in a container type that is not compatible with an HPLC instrument:"},
			ExperimentLCMS[
				Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID],
				Aliquot -> False
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::AliquotOptionMismatch}
		],
		Example[
			{Messages, "InjectionTableBlankFrequencyConflict", "Both InjectionTable and (StandardFrequency, BlankFrequency, nor ColumnRefreshFrequency) cannot be set at the same time:"},
			customInjectionTable = {
				{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Blank, Model[Sample, "Milli-Q water"], 5 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
				{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], 4 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{Sample, Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
				{ColumnFlush, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]}
			};
			ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
			},
				InjectionTable -> customInjectionTable,
				BlankFrequency -> 3
			],
			$Failed,
			Messages :> {
				Error::InjectionTableBlankFrequencyConflict,
				Error::InvalidOption
			},
			Variables :> {customInjectionTable}
		],
		Example[
			{Messages, "StandardsButNoFrequency", "StandardFrequency must not be None or Infinity when there are Standard samples:"},
			ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
			},
				Standard -> Model[Sample, "Milli-Q water"],
				StandardFrequency -> None
			],
			$Failed,
			Messages :> {
				Error::StandardsButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "BlankFrequencyNoBlanks", "BlankFrequency must be Automatic, Null, or None when there are no Blank samples:"},
			ExperimentLCMS[{
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
			},
				Blank -> Null,
				BlankFrequency -> FirstAndLast
			],
			$Failed,
			Messages :> {
				Error::BlankFrequencyNoBlanks,
				Error::BlankOptionsButNoBlank,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ColumnGap", "Columns specified in series cannot have gaps within:"},
			ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnSelector -> {Automatic, Model[Item, Column, "id:KBL5DvYOa5vv"], Null, Model[Item, Column, "id:1ZA60vwjbRla"]}
			],
			$Failed,
			Messages :> {
				Error::ColumnGap,
				Error::HPLCColumnsCannotFitLCMS,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ColumnSelectorConflict", "If ColumnSelector is specified, then any specified Columns must be represented within:"},
			ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnSelector -> {Automatic, Model[Item, Column, "id:KBL5DvYOa5vv"], Model[Item, Column, "id:1ZA60vwjbRla"], Null},
				Column -> Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::ColumnSelectorConflict,
				Message[Error::HPLCColumnsCannotFitLCMS],
				Error::InvalidOption
			}
		],
		Example[{Messages, "GuardColumnSelector", "If ColumnSelector and GuardColumn are both specified, then they must match:"},
			ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
				ColumnSelector -> {Null, Model[Item, Column, "id:KBL5DvYOa5vv"], Model[Item, Column, "id:1ZA60vwjbRla"], Null},
				GuardColumn -> Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::GuardColumnSelector,
				Error::HPLCColumnsCannotFitLCMS,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleColumnType", "If multiple columns are specified, a warning is thrown if any specified Column's SeparationMode does not match the specified Type:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				SeparationMode -> SizeExclusion,
				Column -> Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
				SecondaryColumn -> Model[Item, Column, "id:qdkmxzq7GA9V"]
			],
			$Failed,
			Messages :> {Warning::IncompatibleColumnType, Warning::VariableColumnTypes, Error::HPLCColumnsCannotFitLCMS, Error::InvalidOption}
		],
		Example[{Messages, "IncompatibleColumnTechnique", "If multiple columns are specified, a warning is thrown if any specified Column's ChromatographyType is not HPLC:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Column -> Model[Item, Column, "id:KBL5DvYOa5vv"],
				SecondaryColumn -> Model[Item, Column, "HiTrap 5x5mL Desalting Column"]
			],
			$Failed,
			Messages :> {Error::InvalidOption, Error::HPLCColumnsCannotFitLCMS, Warning::VariableColumnTypes, Warning::IncompatibleColumnTechnique}
		],
		Example[{Messages, "IncompatibleColumnTemperature", "If multiple columns are specified, a warning is thrown if the specified column temperature is outside any specified Column's compatible temperature range:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Column -> Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
				SecondaryColumn -> Model[Item, Column, "id:7X104vnnLxZZ"],
				ColumnTemperature -> 80Celsius
			],
			ObjectP[Object[Protocol, LCMS]],
			Messages :> {Warning::IncompatibleColumnTemperature}
		],
		Example[{Messages, "IncompatibleColumnTemperature", "If multiple columns are specified, a warning is thrown if the specified column temperature is outside any specified Column's compatible temperature range:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				Column -> Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
				SecondaryColumn -> Model[Item, Column, "id:7X104vnnLxZZ"],
				InjectionTable -> {
					{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, 80Celsius, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]}
				}
			],
			ObjectP[Object[Protocol, LCMS]],
			Messages :> {Warning::IncompatibleColumnTemperature,Warning::OverwritingMassAcquisitionMethod}
		],
		Example[{Messages, "InvalidVoltageOptions", "QQQ must use 150 Celsius as the Source Temperature:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				SourceTemperature -> 100 Celsius
			],
			$Failed,
			Messages :> {Error::InvalidSourceTemperature, Error::InvalidOption}
		],
		Example[{Messages, "InvalidVoltageOptions", "QTOF must use positive voltages:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				ESICapillaryVoltage -> -3000 Volt],
			$Failed,
			Messages :> {Error::InvalidVoltageOptions, Error::InvalidOption}
		],
		Example[{Messages, "InvalidGasFlowOptions", "QQQ must use pressure for gas flow options:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				ConeGasFlow -> 200 Liter / Hour],
			$Failed,
			Messages :> {Error::InvalidGasFlowOptions, Error::InvalidOption}
		],
		Example[{Messages, "InvalidVoltageOptions", "QQQ must use voltages that are consistent with ion mode:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				IonMode -> Negative,
				ESICapillaryVoltage -> 3000 Volt,
				MassAnalyzer -> TripleQuadrupole
			],
			$Failed,
			Messages :> {Error::InvalidVoltageOptions, Error::InvalidOption}
		],
		Example[{Messages, "InvalidCollisionVoltageOptions", "QQQ must speicify CollisionEnergy and CollisionCellExitVoltage that are consistent with ion mode:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				IonMode -> Positive,
				CollisionEnergy -> -40 Volt
			],
			$Failed,
			Messages :> {Error::InvalidCollisionVoltageOptions, Error::InvalidOption}
		],
		Example[{Messages, "InvalidCollisionVoltageOptions", "QTOF must use positive CollisionEnergy and CollisionCellExitVoltage must be Null:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> QTOF, IonMode -> Negative, CollisionEnergy -> -40 Volt
			],
			$Failed,
			Messages :> {Error::InvalidCollisionVoltageOptions, Error::InvalidOption}
		],
		Example[{Messages, "LCMSInvalidMultipleReactionMonitoringLengthOfInputOptions", "If using MultipleReactionMonitoring, all inputs (MassDetection,FragmentMassDetection,CollisionEnerigy and DwellTime) should have same length for each sample:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {
					{111 Gram / Mole, 222 Gram / Mole, 333 Gram / Mole}
				},
				FragmentMassDetection -> {
					{
						111 Gram / Mole, 222 Gram / Mole, 444 Gram / Mole, 555 Gram / Mole
					}
				},
				DwellTime -> {
					{
						110 Millisecond, 120 Millisecond, 130 Millisecond, 140 Millisecond
					}
				},
				AcquisitionMode -> MultipleReactionMonitoring
			],
			$Failed,
			Messages :> {Error::LCMSInvalidMultipleReactionMonitoringLengthOfInputOptions, Error::InvalidOption}
		],
		Example[{Messages, "InvalidGasFlowOptions", "QTOF must use flow rate for gas flow options:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> QTOF,
				ConeGasFlow -> 50 PSI
			],
			$Failed,
			Messages :> {Error::InvalidGasFlowOptions, Error::InvalidOption}
		],
		Example[{Messages, "MassAnalyzerAndAcquitionModeMismatched", "QTOF must use flow rate for gas flow options:"},
			ExperimentLCMS[
				{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]
				},
				MassAnalyzer -> QTOF,
				AcquisitionMode -> MultipleReactionMonitoring
			],
			$Failed,
			Messages :> {Error::MassAnalyzerAndAcquitionModeMismatched, Error::InvalidOption}
		],
		Example[{Messages, "LCMSAutoResolvedNeutralLoss", "Need to specify NeutralLoss:"},
			ExperimentLCMS[
				{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID]},
				MassAnalyzer -> TripleQuadrupole,
				AcquisitionMode -> NeutralIonLoss
			],
			ObjectP[Object[Protocol, LCMS]],
			Messages :> {Warning::LCMSAutoResolvedNeutralLoss}
		],
		Example[{Messages, "InjectionTableColumnGradientConflict", "Return an error when the injection table gradients are different for either ColumnPrime or ColumnFlush entries:"},

			ExperimentLCMS[Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				InjectionTable -> {
					{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]},
					{Sample, Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], 2 Microliter, Automatic, Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID]},
					{ColumnPrime, Null, Null, Automatic, Object[Method, Gradient, "Test Gradient Method 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID]}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableColumnGradientConflict, Error::InvalidOption}
		],
		(* This test may be removed if SciEx is able to correct the data artifact issue that results when the instrument is given these conditions. *)
		Example[{Messages, "InstrumentationLimitation", "If conditions that are known to produce artifacts on the QTRAP 6500 was specified an error is thrown:"},
			ExperimentLCMS[
				Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
				MassDetection -> Span[5 Gram/Mole, 1250 Gram/Mole],
				MassDetectionStepSize -> 0.1 Gram/Mole,
				ScanTime -> 0.5 Second
			],
			$Failed,
			Messages :> {Error::InstrumentationLimitation, Error::InvalidOption}
		]
	},
	Parallel -> True,
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		ClearDownload[];
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*delete the old objects in case they're still in the database*)
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Incompatible Sample for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 4 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID],
					Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test low volume sample for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test invalid sample (solid sample) for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test incompatible sample for ExperimentLCMS tests" <> $SessionUUID],
					Model[Sample, "Test chemical model incompatible with Sapphire for ExperimentLCMS" <> $SessionUUID],

					Object[Container, Plate, "Test plate 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Vessel, "Test large container 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Vessel, "Test invalid container 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Plate, "Test plate 2 (Sodium phosphate solid) for ExperimentLCMS test"],
					Object[Container, Plate, "Plate for low volume sample for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Plate, "Plate for sample 4 ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Plate, "Plate for sample 5 ExperimentLCMS tests" <> $SessionUUID],

					Object[Protocol, LCMS, "Test Template Protocol for ExperimentLCMS" <> $SessionUUID],
					Object[Protocol, LCMS, "My special LCMS protocol name" <> $SessionUUID],
					Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID],
					Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID],
					Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Method, Gradient, "Test Gradient Method 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Method, Gradient, "LCMS Non-binary gradient for testing"],

					Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS (2)" <> $SessionUUID],
					Model[Item, Column, "Test cartridge guard column model for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Column, "Test cartridge guard column object for ExperimentLCMS" <> $SessionUUID],
					Model[Item, Cartridge, Column, "Test model cartridge for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Cartridge, Column, "Test cartridge for ExperimentLCMS" <> $SessionUUID],
					Object[Container, Bench, "Fake bench for ExperimentLCMS tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{methodPacket1, firstSetUpload, samples, plate, largeContainer, plate2, tube, plate3, existingNamedProtocol, plate4,
			columnModel, guardColumnModel, bench, cartridgeModel, methodPacket2, method1, method2, method3, method4, methodPacket3,
			antiSapphireModel, plate5, methodPacket4, methodPacket5, method5, templateLCMSProtocol},

			(*create our method packets*)
			methodPacket1 = <|
				Replace[AcquisitionModes] -> {DataDependent, DataDependent},
				Replace[AcquisitionSurveys] -> {10, 10},
				Replace[AcquisitionWindows] -> {
					<|
						StartTime -> Quantity[0., "Minutes"],
						EndTime -> Quantity[4.99, "Minutes"]
					|>,
					<|
						StartTime -> Quantity[5., "Minutes"],
						EndTime -> Quantity[10., "Minutes"]
					|>
				},
				Calibrant -> Link[Model[Sample, StockSolution, Standard, "id:jLq9jXvWLNqx"]],
				Replace[CollisionEnergies] -> {{Quantity[40., "Volts"]}, {Quantity[40., "Volts"]}},
				ConeGasFlow -> Quantity[3., "Liters" / "Hours"],
				Replace[CycleTimeLimits] -> {Quantity[2.3, "Seconds"], Quantity[2.2, "Seconds"]},
				DeclusteringVoltage -> Quantity[40., "Volts"],
				DesolvationGasFlow -> Quantity[1200., "Liters" / "Hours"],
				DesolvationTemperature -> Quantity[600., "DegreesCelsius"],
				ESICapillaryVoltage -> Quantity[1000., "Volts"],
				Replace[Fragmentations] -> {True, True},
				Replace[FragmentMaxMasses] -> {
					Quantity[16000., "Grams" / "Moles"],
					Quantity[16000., "Grams" / "Moles"]
				},
				Replace[FragmentMinMasses] -> {Quantity[20., "Grams" / "Moles"], Quantity[20., "Grams" / "Moles"]},
				Replace[FragmentScanTimes] -> {Quantity[0.2, "Seconds"], Quantity[0.2, "Seconds"]},
				Replace[InclusionChargeStates] -> {{1, 1}, {1, 1, 1}},
				Replace[InclusionCollisionEnergies] -> {
					{Quantity[40, "Volts"], Quantity[40, "Volts"]},
					{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
				},
				Replace[InclusionDeclusteringVoltages] -> {
					{Quantity[40, "Volts"], Quantity[40, "Volts"]},
					{Quantity[40, "Volts"], Quantity[40, "Volts"], Quantity[40, "Volts"]}
				},
				Replace[InclusionDomains] -> {
					{
						{Quantity[0., "Minutes"], Quantity[4.99, "Minutes"]},
						{Quantity[0., "Minutes"], Quantity[4.99, "Minutes"]}
					},
					{
						{Quantity[5., "Minutes"], Quantity[10., "Minutes"]},
						{Quantity[5., "Minutes"], Quantity[10., "Minutes"]},
						{Quantity[5., "Minutes"], Quantity[10., "Minutes"]}
					}
				},
				Replace[InclusionMasses] -> {
					{
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]}
					},
					{
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]},
						{Preferential, Quantity[2, "Grams" / "Moles"]}
					}
				},
				Replace[InclusionMassTolerances] -> {Quantity[0.5, "Grams" / "Moles"], Quantity[0.5, "Grams" / "Moles"]},
				Replace[InclusionScanTimes] -> {
					{Quantity[3, "Seconds"], Quantity[5, "Seconds"]},
					{Quantity[0.5, "Seconds"], Quantity[0.2, "Seconds"], Quantity[1, "Seconds"]}
				},
				IonMode -> Positive,
				IonSource -> ESI,
				MassAnalyzer -> QTOF,
				Replace[MaxMasses] -> {
					Quantity[100000., "Grams" / "Moles"],
					Quantity[100000., "Grams" / "Moles"]
				},
				Replace[MinMasses] -> {Quantity[2., "Grams" / "Moles"], Quantity[2., "Grams" / "Moles"]},
				Replace[MultipleReactionMonitoringAssays] -> {
					<|
						MS1Mass -> Null,
						CollisionEnergy -> Null,
						MS2Mass -> Null,
						DwellTime -> Null
					|>,
					<|
						MS1Mass -> Null,
						CollisionEnergy -> Null,
						MS2Mass -> Null,
						DwellTime -> Null
					|>
				},
				Replace[ScanTimes] -> {Quantity[0.3, "Seconds"], Quantity[0.2, "Seconds"]},
				SourceTemperature -> Quantity[120., "DegreesCelsius"],
				StepwaveVoltage -> Quantity[50., "Volts"],
				Type -> Object[Method, MassAcquisition],
				DeveloperObject -> True,
				Name -> "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID
			|>;

			methodPacket2 = <|
				Replace[AcquisitionModes] -> {DataIndependent},
				Replace[AcquisitionWindows] -> {
					<|
						StartTime -> Quantity[0., "Minutes"],
						EndTime -> Quantity[10., "Minutes"]
					|>
				},
				Calibrant -> Link[Model[Sample, StockSolution, Standard, "id:jLq9jXvWLNqx"]],
				Replace[CollisionEnergies] -> {{Quantity[40., "Volts"]}},
				ConeGasFlow -> Quantity[3., "Liters" / "Hours"],
				DeclusteringVoltage -> Quantity[40., "Volts"],
				DesolvationGasFlow -> Quantity[1200., "Liters" / "Hours"],
				DesolvationTemperature -> Quantity[600., "DegreesCelsius"],
				ESICapillaryVoltage -> Quantity[1000., "Volts"],
				Replace[Fragmentations] -> {True},
				Replace[FragmentMaxMasses] -> {Quantity[16000., "Grams" / "Moles"]},
				Replace[FragmentMinMasses] -> {Quantity[20., "Grams" / "Moles"]},
				IonMode -> Negative,
				IonSource -> ESI,
				MassAnalyzer -> QTOF,
				Replace[MaxMasses] -> {Quantity[100000., "Grams" / "Moles"]},
				Replace[MinMasses] -> {Quantity[2., "Grams" / "Moles"]},
				Replace[MultipleReactionMonitoringAssays] -> {
					<|
						MS1Mass -> Null,
						CollisionEnergy -> Null,
						MS2Mass -> Null,
						DwellTime -> Null
					|>
				},
				Replace[ScanTimes] -> {Quantity[0.2, "Seconds"]},
				SourceTemperature -> Quantity[150., "DegreesCelsius"],
				StepwaveVoltage -> Quantity[40., "Volts"],
				Type -> Object[Method, MassAcquisition],
				DeveloperObject -> True,
				Name -> "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID
			|>;

			methodPacket3 = <|
				BufferA -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
				BufferB -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
				BufferC -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
				BufferD -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
				Replace[Gradient] -> {
					{
						Quantity[0., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					},
					{
						Quantity[20., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					}
				},
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[75., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[75, "Percent"]}
				},
				GradientB -> {
					{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
				},
				GradientC -> {
					{Quantity[0., "Minutes"], Quantity[25., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[25., "Percent"]}
				},
				GradientD -> {
					{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
				},
				InitialFlowRate -> Quantity[0.4, "Milliliters" / "Minutes"],
				Temperature -> Quantity[40., "DegreesCelsius"],
				Type -> Object[Method, Gradient],
				Name -> "LCMS Non-binary gradient for testing"
			|>;

			methodPacket4 = <|
				BufferA -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
				BufferB -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
				BufferC -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
				BufferD -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
				Replace[Gradient] -> {
					{
						Quantity[0., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					},
					{
						Quantity[20., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					}
				},
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[75., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[75, "Percent"]}
				},
				GradientB -> {
					{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
				},
				GradientC -> {
					{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
				},
				GradientD -> {
					{Quantity[0., "Minutes"], Quantity[25., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[25., "Percent"]}
				},
				Temperature -> Quantity[45., "DegreesCelsius"],
				Type -> Object[Method, Gradient],
				DeveloperObject -> False,
				Name -> "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID
			|>;

			methodPacket5 = <|
				BufferA -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
				BufferB -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
				BufferC -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
				BufferD -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
				Replace[Gradient] -> {
					{
						Quantity[0., "Minutes"],
						Quantity[76., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[24., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					},
					{
						Quantity[20., "Minutes"],
						Quantity[76., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[24., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters" / "Minutes"]
					}
				},
				GradientA -> {
					{Quantity[0., "Minutes"], Quantity[76., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[76, "Percent"]}
				},
				GradientB -> {
					{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
				},
				GradientC -> {
					{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
				},
				GradientD -> {
					{Quantity[0., "Minutes"], Quantity[24., "Percent"]},
					{Quantity[20., "Minutes"], Quantity[24., "Percent"]}
				},
				Temperature -> Quantity[45., "DegreesCelsius"],
				Type -> Object[Method, Gradient],
				DeveloperObject -> False,
				Name -> "Test Gradient Method 2 for ExperimentLCMS tests" <> $SessionUUID
			|>;

			firstSetUpload = List[
				methodPacket1,
				methodPacket2,
				methodPacket3,
				methodPacket4,
				methodPacket5,
				Association[
					Type -> Object[Container, Plate],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 1 for ExperimentLCMS tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 2 (Sodium phosphate solid) for ExperimentLCMS test"
				],
				Association[
					Type -> Object[Container, Vessel],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects],
					Name -> "Test large container 1 for ExperimentLCMS tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "Test invalid container 1 for ExperimentLCMS tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Protocol, LCMS],
					Site -> Link[$Site],
					Name -> "My special LCMS protocol name" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Plate for low volume sample for ExperimentLCMS tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Plate for sample 4 ExperimentLCMS tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Plate for sample 5 ExperimentLCMS tests" <> $SessionUUID
				],
				<|
					DeveloperObject -> True,
					Name -> "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID,
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Analytical,
					Diameter -> Quantity[4.5`, "Millimeters"],
					Dimensions -> {Quantity[0.005`, "Meters"], Quantity[0.01`, "Meters"], Quantity[0.01`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 10000,
					MaxpH -> 9.`,
					MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
					MaxTemperature -> Quantity[90.`, "DegreesCelsius"],
					MinFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[0.`, ("PoundsForce") / ("Inches")^2],
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingMaterial -> AerisCoreShell,
					PackingType -> Prepacked,
					ParticleSize -> Quantity[3.6`, "Micrometers"],
					PoreSize -> Quantity[100.`, "Angstroms"],
					Reusable -> True,
					Type -> Model[Item, Column],
					Replace[WettedMaterials] -> {AerisCoreShell}
				|>,
				<|
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Guard,
					Dimensions -> {Quantity[0.055`, "Meters"], Quantity[0.015`, "Meters"], Quantity[0.015`, "Meters"]},
					MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 1000,
					MaxpH -> 10.`,
					MaxPressure -> Quantity[3400.`, ("PoundsForce") / ("Inches")^2],
					MinFlowRate -> Quantity[0.05`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[1.`, ("PoundsForce") / ("Inches")^2],
					Name -> "Test cartridge guard column model for ExperimentLCMS" <> $SessionUUID,
					DeveloperObject -> True,
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingType -> Cartridge,
					ParticleSize -> Quantity[3.`, "Micrometers"],
					Reusable -> True,
					Type -> Model[Item, Column]
				|>,
				<|
					Name -> "Test model cartridge for ExperimentLCMS" <> $SessionUUID,
					DeveloperObject -> True,
					SeparationMode -> ReversePhase,
					Diameter -> Quantity[3.`, "Millimeters"],
					Dimensions -> {Quantity[0.215`, "Meters"], Quantity[0.115`, "Meters"], Quantity[0.165`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxNumberOfUses -> 100,
					Reusable -> True,
					Type -> Model[Item, Cartridge, Column]
				|>,
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for ExperimentLCMS tests" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site],
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Type -> Model[Sample],
					Name -> "Test chemical model incompatible with Sapphire for ExperimentLCMS" <> $SessionUUID,
					State -> Liquid,
					Replace[Composition] -> {{Null, Null}},
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Append[IncompatibleMaterials] -> Sapphire,
					DeveloperObject -> True
				|>
			];

			{
				method1,
				method2,
				method3,
				method4,
				method5,
				plate,
				plate2,
				largeContainer,
				tube,
				existingNamedProtocol,
				plate3,
				plate4,
				plate5,
				columnModel,
				guardColumnModel,
				cartridgeModel,
				bench,
				antiSapphireModel
			} = Upload[firstSetUpload];

			samples = UploadSample[
				{
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, "Test chemical model incompatible with Sapphire for ExperimentLCMS" <> $SessionUUID],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, "Dibasic Sodium Phosphate"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
					Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
					Model[Item, Column, "Test cartridge guard column model for ExperimentLCMS" <> $SessionUUID],
					Model[Item, Cartridge, Column, "Test model cartridge for ExperimentLCMS" <> $SessionUUID]
				},
				{
					{"A1", plate},
					{"A2", plate},
					{"A3", plate},
					{"A1", plate5},
					{"A1", largeContainer},
					{"A1", tube},
					{"A1", plate2},
					{"A1", plate3},
					{"A1", plate4},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench},
					{"Work Surface", bench}
				},
				InitialAmount -> {
					500 Microliter,
					500 Microliter,
					500 Microliter,
					500 Microliter,
					200 Milliliter,
					2000 Microliter,
					50 Milligram,
					300 Microliter,
					300 Microliter,
					Null,
					Null,
					Null,
					Null
				},
				Name -> {
					"Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID,
					"Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID,
					"Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID,
					"Test Incompatible Sample for ExperimentLCMS tests" <> $SessionUUID,
					"Large Container Sample for ExperimentLCMS" <> $SessionUUID,
					"Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID,
					"Test invalid sample (solid sample) for ExperimentLCMS tests" <> $SessionUUID,
					"Test low volume sample for ExperimentLCMS tests" <> $SessionUUID,
					"Test Sample 4 for ExperimentLCMS tests" <> $SessionUUID,
					"Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID,
					"Test cartridge-protected column object for ExperimentLCMS (2)" <> $SessionUUID,
					"Test cartridge guard column object for ExperimentLCMS" <> $SessionUUID,
					"Test cartridge for ExperimentLCMS" <> $SessionUUID
				},
				StorageCondition -> AmbientStorage
			];

			(*create our severed sample*)
			Upload[
				{
					Association[
						Object -> Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{50 Micromolar, Link[Model[Molecule, "Uracil"]], Now}
						},
						Site -> Link[$Site]
					],
					Association[
						Object -> Object[Sample, "Test Sample 4 for ExperimentLCMS tests" <> $SessionUUID],
						Site -> Link[$Site],
						Model -> Null
					],
					Association[
						Object -> Model[Item, Cartridge, Column, "Test model cartridge for ExperimentLCMS" <> $SessionUUID],
						PreferredGuardColumn -> Link@Model[Item, Column, "Test cartridge guard column model for ExperimentLCMS" <> $SessionUUID]
					],
					Association[
						Object -> Model[Item, Column, "Test cartridge guard column model for ExperimentLCMS" <> $SessionUUID],
						PreferredGuardCartridge -> Link@Model[Item, Cartridge, Column, "Test model cartridge for ExperimentLCMS" <> $SessionUUID]
					]
				}
			];

			(*Create a protocol that we'll use for template testing*)
			Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
				(*Create a protocol that we'll use for template testing*)
				templateLCMSProtocol = ExperimentLCMS[
					{Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID]},
					Name -> "Test Template Protocol for ExperimentLCMS" <> $SessionUUID,
					SampleTemperature -> 20 Celsius
				]
			];
		];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample, "Test Sample 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test Sample 4 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Large Container Sample for ExperimentLCMS" <> $SessionUUID],
					Object[Sample, "Test sample for invalid container for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test low volume sample for ExperimentLCMS tests" <> $SessionUUID],
					Object[Sample, "Test invalid sample (solid sample) for ExperimentLCMS tests" <> $SessionUUID],

					Object[Container, Plate, "Test plate 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Vessel, "Test large container 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Vessel, "Test invalid container 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Plate, "Test plate 2 (Sodium phosphate solid) for ExperimentLCMS test"],
					Object[Container, Plate, "Plate for low volume sample for ExperimentLCMS tests" <> $SessionUUID],
					Object[Container, Plate, "Plate for sample 4 ExperimentLCMS tests" <> $SessionUUID],

					Object[Protocol, LCMS, "Test Template Protocol for ExperimentLCMS" <> $SessionUUID],
					Object[Protocol, LCMS, "My special LCMS protocol name" <> $SessionUUID],
					Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 1" <> $SessionUUID],
					Object[Method, MassAcquisition, "LCMS Tests MassAcquisitionMethod 2" <> $SessionUUID],
					Object[Method, Gradient, "Test Gradient Method 1 for ExperimentLCMS tests" <> $SessionUUID],
					Object[Method, Gradient, "Test Gradient Method 2 for ExperimentLCMS tests" <> $SessionUUID],

					Model[Item, Column, "Test cartridge-protected column model for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentLCMS (2)" <> $SessionUUID],
					Model[Item, Column, "Test cartridge guard column model for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Column, "Test cartridge guard column object for ExperimentLCMS" <> $SessionUUID],
					Model[Item, Cartridge, Column, "Test model cartridge for ExperimentLCMS" <> $SessionUUID],
					Object[Item, Cartridge, Column, "Test cartridge for ExperimentLCMS" <> $SessionUUID],
					Object[Container, Bench, "Fake bench for ExperimentLCMS tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(*MassSpectrometryScan*)


DefineTests[MassSpectrometryScan,
	{
		Example[{Basic,"ExperimentLCMS would generate MassSpectrometryScan unit operations:"},
			Download[ExperimentLCMS[Object[Sample,"Test Sample 1 for MassSpectrometryScan "<> $SessionUUID]],MassSpectrometryScans],
			{{ObjectP[Object[UnitOperation, MassSpectrometryScan]] ..} ..}
		]
	},
	SymbolSetUp:>Module[{platePacket,plate},
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Site -> Link[$Site],DeveloperObject->True|>;
		plate=Upload[platePacket];
		UploadSample[
			Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
			{"A1",plate},
			Name->"Test Sample 1 for MassSpectrometryScan "<>$SessionUUID,
			InitialAmount -> 500 Microliter][[{Volume, VolumeLog}]]
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	],
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection:: *)
(*ExperimentLCMSOptions*)

DefineTests[
	ExperimentLCMSOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentLCMSOptions[Object[Sample,"ExperimentLCMSOptions Test Sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentLCMSOptions[Object[Sample,"ExperimentLCMSOptions Test Sample 3" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentLCMSOptions[Object[Sample,"ExperimentLCMSOptions Test Sample 1" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ExperimentLCMSOptions Test Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentLCMSOptions Test Sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentLCMSOptions Test Sample 3" <> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ExperimentLCMSOptions tests" <> $SessionUUID]
			};
			
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		
		];
		(*module for ecreating objects*)
		Module[{containerPackets,samplePackets},
			
			containerPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "Test plate 1 for ExperimentLCMSOptions tests" <> $SessionUUID
				]
			};
			
			Upload[containerPackets];
			
			samplePackets = UploadSample[
				{Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
				{{"A1",Object[Container,Plate,"Test plate 1 for ExperimentLCMSOptions tests" <> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentLCMSOptions tests" <> $SessionUUID]},{"A3",Object[Container,Plate,"Test plate 1 for ExperimentLCMSOptions tests" <> $SessionUUID]}},
				InitialAmount -> 500 Microliter,
				Name->{
					"ExperimentLCMSOptions Test Sample 1" <> $SessionUUID,
					"ExperimentLCMSOptions Test Sample 2" <> $SessionUUID,
					"ExperimentLCMSOptions Test Sample 3" <> $SessionUUID
				},
				Upload->False
			];
			
			Upload[samplePackets];
			
			Upload[<|Object->Object[Sample,"ExperimentLCMSOptions Test Sample 3" <> $SessionUUID],Status->Discarded,DeveloperObject->True|>];
		
		]
	
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentLCMSQ*)

DefineTests[
	ValidExperimentLCMSQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentLCMSQ[Object[Sample,"ValidExperimentLCMSQ Test Sample 1" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentLCMSQ[Object[Sample,"ValidExperimentLCMSQ Test Sample 3" <> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentLCMSQ[Object[Sample,"ValidExperimentLCMSQ Test Sample 1" <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentLCMSQ[Object[Sample,"ValidExperimentLCMSQ Test Sample 1" <> $SessionUUID],Verbose->True],
			True
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ValidExperimentLCMSQ Test Sample 1" <> $SessionUUID],
				Object[Sample,"ValidExperimentLCMSQ Test Sample 2" <> $SessionUUID],
				Object[Sample,"ValidExperimentLCMSQ Test Sample 3" <> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ValidExperimentLCMSQ tests" <> $SessionUUID]
			};
			
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		
		];
		(*module for creating objects*)
		Block[{$DeveloperUpload = True},
			Module[{containerPackets,samplePackets},

				containerPackets = {
					Association[
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
						Site -> Link[$Site],
						Name -> "Test plate 1 for ValidExperimentLCMSQ tests" <> $SessionUUID
					]
				};

				Upload[containerPackets];

				samplePackets = UploadSample[
					{Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
					{{"A1",Object[Container,Plate,"Test plate 1 for ValidExperimentLCMSQ tests" <> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ValidExperimentLCMSQ tests" <> $SessionUUID]},{"A3",Object[Container,Plate,"Test plate 1 for ValidExperimentLCMSQ tests" <> $SessionUUID]}},
					InitialAmount -> 500 Microliter,
					Name->{
						"ValidExperimentLCMSQ Test Sample 1" <> $SessionUUID,
						"ValidExperimentLCMSQ Test Sample 2" <> $SessionUUID,
						"ValidExperimentLCMSQ Test Sample 3" <> $SessionUUID
					},
					Upload->False
				];

				Upload[samplePackets];

				Upload[<|Object->Object[Sample,"ValidExperimentLCMSQ Test Sample 3" <> $SessionUUID],Status->Discarded,DeveloperObject->True|>]

			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	)
];


(* ::Subsubsection:: *)
(*ExperimentLCMSPreview*)

DefineTests[
	ExperimentLCMSPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentLCMS:"},
			ExperimentLCMSPreview[Object[Sample,"ExperimentLCMSPreview Test Sample 1" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentLCMSOptions:"},
			ExperimentLCMSOptions[Object[Sample,"ExperimentLCMSPreview Test Sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentLCMSQ:"},
			ValidExperimentLCMSQ[Object[Sample,"ExperimentLCMSPreview Test Sample 1" <> $SessionUUID]],
			True
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ExperimentLCMSPreview Test Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentLCMSPreview Test Sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentLCMSPreview Test Sample 3" <> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ExperimentLCMSPreview tests" <> $SessionUUID]
			};
			
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		
		];
		(*module for creating objects*)
		Block[{$DeveloperUpload = True},
			Module[{containerPackets,samplePackets},

				containerPackets = {
					Association[
						Type -> Object[Container, Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
						Site -> Link[$Site],
						Name -> "Test plate 1 for ExperimentLCMSPreview tests" <> $SessionUUID
					]
				};

				Upload[containerPackets];

				samplePackets = UploadSample[
					{Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
					{{"A1",Object[Container,Plate,"Test plate 1 for ExperimentLCMSPreview tests" <> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentLCMSPreview tests" <> $SessionUUID]},{"A3",Object[Container,Plate,"Test plate 1 for ExperimentLCMSPreview tests" <> $SessionUUID]}},
					InitialAmount -> 500 Microliter,
					Name->{
						"ExperimentLCMSPreview Test Sample 1" <> $SessionUUID,
						"ExperimentLCMSPreview Test Sample 2" <> $SessionUUID,
						"ExperimentLCMSPreview Test Sample 3" <> $SessionUUID
					},
					Upload->False
				];

				Upload[samplePackets];

				Upload[<|Object->Object[Sample,"ExperimentLCMSPreview Test Sample 3" <> $SessionUUID],Status->Discarded,DeveloperObject->True|>]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	)
];