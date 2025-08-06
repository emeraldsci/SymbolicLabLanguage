(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentICPMS*)


DefineTests[ExperimentICPMS,
	{
		(* ===Basic=== *)
		Example[
			{Basic, "Unless otherwise specified, all metallic elements contained in the sample will be detected and quantified:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandard -> Null,
					Output -> Options
				],
				Elements
			],
			{"40Ca", "23Na", Sweep}
		],
		Example[
			{Basic, "For each element, its most abundant isotope and all other isotopes above 20% abundance will be quantified by default:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
					InternalStandard -> Null,
					Output -> Options],
				Elements
			],
			{"63Cu", "65Cu", Sweep}
		],
		Example[
			{Basic, "StandardType will be set to External by default if any element has QuantifyConcentration set to True:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Output -> Options
				],
				StandardType
			],
			External
		],
		Example[
			{Basic, "Multiple samples can be entered as the input simultaneously, which in that case all metallic elements contained in at least one sample will be selected as the Elements:"},
			Lookup[
				ExperimentICPMS[{Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID]},
					InternalStandard -> Null,
					Output -> Options
				],
				Elements
			],
			{"40Ca", "23Na", "63Cu", "65Cu", Sweep}
		],
		Example[
			{Basic, "Generate a protocol object by ExperimentICPMS function with External StandardType:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				StandardType -> External
			],
			ObjectP[Object[Protocol, ICPMS]]
		],
		Example[
			{Basic, "Generate a protocol object by ExperimentICPMS function with StandardAddition StandardType:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				StandardType -> StandardAddition
			],
			ObjectP[Object[Protocol, ICPMS]]
		],
		Example[
			{Basic, "Generate a protocol object by ExperimentICPMS function with no Standard:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				StandardType -> None, QuantifyConcentration -> False
			],
			ObjectP[Object[Protocol, ICPMS]]
		],
		(* TODO mark the beginning of Additional *)
		Example[
			{Additional, "Multiple samples can be entered as input, which results in a single protocol object:"},
			ExperimentICPMS[{Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID]}
			],
			ObjectP[Object[Protocol, ICPMS]]
		],
		Example[{Additional,"Required Resources","For ICP-MS, generate all required resources for a protocol with StandardType -> External:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride"<>$SessionUUID],
					StandardType -> External
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, InternalStandard, Blank, RinseSolution, Checkpoints, ExternalStandard, Cone, TuningStandard, ExternalStandardElements, ICPMSSampleContainers, BlankDiluent}
				]
			],
			True
		],
		Example[{Additional,"Required Resources","For ICP-MS, generate all required resources for a protocol with StandardType -> StandardAddition:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride"<>$SessionUUID],
					StandardType -> StandardAddition
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, InternalStandard, Blank, RinseSolution, Checkpoints, StandardSpikedSamples, Cone, TuningStandard, StandardAdditionElements, BlankDiluent}
				]
			],
			True
		],
		Example[{Additional,"Required Resources","For ICP-MS, generate all required resources for a protocol with StandardType -> None:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride"<>$SessionUUID],
					StandardType -> None, QuantifyConcentration -> False
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, InternalStandard, Blank, RinseSolution, Checkpoints, Cone, TuningStandard, ICPMSSampleContainers}
				]
			],
			True
		],
		Example[{Additional,"Required Resources","For ICP-MS, If InternalStandard -> Null no resource from InternalStandard will be generated:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride"<>$SessionUUID],
					StandardType -> None, QuantifyConcentration -> False, InternalStandard -> Null
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, Blank, RinseSolution, Checkpoints, Cone, TuningStandard, ICPMSSampleContainers}
				]
			],
			True
		],
		Example[{Additional,"Required Resources","For ICP-MS, If Rinse -> False resource from Rinse will still be generated:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride"<>$SessionUUID],
					StandardType -> None, QuantifyConcentration -> False, Rinse -> False
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, Blank, InternalStandard, Checkpoints, Cone, RinseSolution, TuningStandard, ICPMSSampleContainers}
				]
			],
			True
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentICPMS[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		(* TODO mark the beginning of options *)
		(* ===Options=== *)
		Example[
			{Options, Elements, "If a list of elements is specified, for each element, its most abundant isotope and all other isotopes above 20% abundance will be quantified by default:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
					Elements -> {Copper, Barium},
					InternalStandard -> Null,
					Output -> Options
				],
				Elements
			],
			{"63Cu", "65Cu", "138Ba"}
		],
		Example[
			{Options, IsotopeAbundanceThreshold, "IsotopeAbundanceThreshold can be changed so that any isotopes above this threshold will be detected:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
					Elements -> {Copper, Barium},
					InternalStandard -> Null,
					IsotopeAbundanceThreshold -> 10 Percent, Output -> Options
				],
				Elements
			],
			{"63Cu", "65Cu", "137Ba", "138Ba"}
		],
		Example[
			{Options, IsotopeAbundanceThreshold, "If no isotope for a given element is more abundant than the specified IsotopeAbundanceThreshold, the most abundant isotope will still be selected:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
					Elements -> {Germanium},
					InternalStandard -> Null,
					IsotopeAbundanceThreshold -> 50 Percent, Output -> Options
				],
				Elements
			],
			{"74Ge"},
			Messages:> {Warning::BelowThresholdIsotopesIncluded}
		],
		Example[
			{Options, IsotopeAbundanceThreshold, "When a list of isotopes is specified, this option is no longer valid; the exact list of isotopes will be measured:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
					Elements -> {"56Fe", "57Fe", "58Fe"},
					InternalStandard -> Null,
					IsotopeAbundanceThreshold -> 20 Percent, Output -> Options
				],
				Elements
			],
			{"56Fe", "57Fe", "58Fe"},
			Messages:> {Warning::LowAbundanceIsotopes}
		],
		Example[
			{Options, Elements, "Elements option can be directly specified as a list of isotopes, in that case the exact specified isotopes will be detected:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {"23Na", "40Ca"},
					InternalStandard -> Null,
					Output -> Options
				],
				Elements
			],
			{"23Na", "40Ca"}
		],
		Example[
			{Options, Elements, "When Elements options specified as a list of elements and resolve into a list of isotopes, all options index-matched to Elements will be properly duplicated and distributed to match the original Elements:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
					Elements -> {Copper, Sodium, Germanium, Sweep},
					PlasmaPower -> {Normal, Low, Normal, Normal},
					CollisionCellPressurization -> {True, False, False, False},
					CollisionCellGas -> {Helium, Null, Null, Null},
					CollisionCellGasFlowRate -> Automatic,
					DwellTime -> {0.04 Second, 0.03 Second, 0.02 Second, 0.01 Second},
					NumberOfReads -> {1, 2, 3, 4},
					ReadSpacing -> Automatic,
					Bandpass -> {Normal, Normal, Normal, Normal},
					InternalStandardElement -> {False, False, True, False},
					QuantifyConcentration -> {True, True, False, False},
					Output -> Options
				],
				{
					Elements,
					PlasmaPower,
					CollisionCellPressurization,
					CollisionCellGas,
					CollisionCellGasFlowRate,
					CollisionCellBias,
					DwellTime,
					NumberOfReads,
					ReadSpacing,
					Bandpass,
					InternalStandardElement,
					QuantifyConcentration
				}
			],
			{
				{"63Cu", "65Cu", "23Na", "70Ge", "72Ge", "74Ge", Sweep},
				{Normal, Normal, Low, Normal, Normal, Normal, Normal},
				{True, True, False, False, False, False, False},
				{Helium, Helium, Null, Null, Null, Null, Null},
				{4.5 Milliliter/Minute, 4.5 Milliliter/Minute, 0 Milliliter/Minute, 0 Milliliter/Minute, 0 Milliliter/Minute, 0 Milliliter/Minute, 0 Milliliter/Minute},
				{True, True, False, False, False, False, False},
				{0.04 Second, 0.04 Second, 0.03 Second, 0.02 Second, 0.02 Second, 0.02 Second, 0.01 Second},
				{1, 1, 2, 3, 3, 3, 4},
				{0.1 Gram / Mole, 0.1 Gram / Mole, 0.1 Gram / Mole, 0.1 Gram / Mole, 0.1 Gram / Mole, 0.1 Gram / Mole, 0.2 Gram / Mole},
				{Normal, Normal, Normal, Normal, Normal, Normal, Normal},
				{False, False, False, True, True, True, False},
				{True, True, True, False, False, False, False}
			}
		],
		Example[
			{Options, PlasmaPower, "If PlasmaPower is not specified, it automatically resolve to Low for alkali metals and Normal for everything else:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					Output -> Options
				],
				{Elements, PlasmaPower}
			],
			{{"23Na", "24Mg", "39K", "40Ca"}, {Low, Normal, Low, Normal}}
		],
		Example[
			{Options, PlasmaPower, "If PlasmaPower is specified, it will keep as is:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					PlasmaPower -> {Normal, Low, Low, Normal},
					Output -> Options
				],
				{Elements, PlasmaPower}
			],
			{{"23Na", "24Mg", "39K", "40Ca"}, {Normal, Low, Low, Normal}}
		],
		Example[
			{Options, QuantifyConcentration, "QuantifyConcentration always resolve to False for Sweep:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandard -> Null,
					Output -> Options
				],
				{Elements, QuantifyConcentration}
			],
			{{"40Ca", "23Na", Sweep}, {True, True, False}}
		],
		Example[
			{Options, QuantifyConcentration, "If InternalStandardElement for any element is set to True, QuantifyConcentration auto resolves to False for the same element:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Calcium, Scandium},
					InternalStandardElement -> {False, True},
					Output -> Options
				],
				{Elements, QuantifyConcentration}
			],
			{{"40Ca", "45Sc"}, {True, False}}
		],
		Example[
			{Options, QuantifyConcentration, "If QuantifyConcentration is specified, it will keep as is:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					QuantifyConcentration -> {True, False, True, False},
					Output -> Options
				],
				{Elements, QuantifyConcentration}
			],
			{{"23Na", "24Mg", "39K", "40Ca"}, {True, False, True, False}}
		],
		Example[
			{Options, CollisionCellPressurization, "If CollisionCellGas is set to non-Null non-Automatic, CollisionCellPressurization resolves to True:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					CollisionCellGas -> {Helium, Helium, Automatic, Null},
					Output -> Options
				],
				{CollisionCellGas, CollisionCellPressurization}
			],
			{{Helium, Helium, Null, Null}, {True, True, False, False}}
		],
		Example[
			{Options, CollisionCellPressurization, "If CollisionCellGas is set to non-zero, CollisionCellPressurization resolves to True:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					CollisionCellGasFlowRate -> {1.2 Milliliter/Minute, 4.3 Milliliter/Minute, 0 Milliliter/Minute, Automatic},
					Output -> Options
				],
				{CollisionCellGasFlowRate, CollisionCellPressurization}
			],
			{{1.2 Milliliter/Minute, 4.3 Milliliter/Minute, 0 Milliliter/Minute, 0 Milliliter/Minute}, {True, True, False, False}}
		],
		Example[
			{Options, CollisionCellGas, "If CollisionCellGas is specified, it will keep as is:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					CollisionCellPressurization -> {True, True, True, False},
					CollisionCellGas -> {Helium, Helium, Helium, Null},
					Output -> Options
				],
				{Elements, CollisionCellGas}
			],
			{{"23Na", "24Mg", "39K", "40Ca"}, {Helium, Helium, Helium, Null}}
		],
		Example[
			{Options, CollisionCellGas, "If CollisionCellPressurization is set to True, it resolves to Helium, otherwise resolves to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					CollisionCellPressurization -> {True, False, True, False},
					Output -> Options
				],
				{Elements, CollisionCellGas}
			],
			{{"23Na", "24Mg", "39K", "40Ca"}, {Helium, Null, Helium, Null}}
		],
		Example[
			{Options, CollisionCellGasFlowRate, "If CollisionCellGasFlowRate is specified, keep it as is; if it's not specified, set to 4.5 ml/min if CollisionCellGas is not Null, and 0 if CollisionCellGas is Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					CollisionCellPressurization -> {True, True, True, False},
					CollisionCellGasFlowRate -> {1.6 Milliliter/Minute, 7.2 Milliliter/Minute, Automatic, Automatic},
					Output -> Options
				],
				{CollisionCellGas, CollisionCellGasFlowRate}
			],
			{{Helium, Helium, Helium, Null}, {1.6 Milliliter/Minute, 7.2 Milliliter/Minute, 4.5 Milliliter/Minute, 0 Milliliter/Minute}}
		],
		Example[
			{Options, CollisionCellBias, "If CollisionCellBias is specified, keeps it as is, otherwise if CollisionCellGas is set or resolved to Helium, set to True:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					CollisionCellGas -> {Helium, Helium, Null, Null},
					CollisionCellBias -> {False, Automatic, Automatic, Automatic},
					Output -> Options
				],
				{CollisionCellGas, CollisionCellBias}
			],
			{{Helium, Helium, Null, Null}, {False, True, False, False}}
		],
		Example[
			{Options, DwellTime, "If DwellTime is specified, keep it as is, otherwise set t0 1 ms for Sweep and 10 ms for any actual isotopes:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium, Sweep},
					InternalStandard -> Null,
					DwellTime -> {2 Millisecond, 3 Millisecond, Automatic, Automatic, Automatic},
					Output -> Options
				],
				{Elements, DwellTime}
			],
			{{"23Na", "24Mg", "39K", "40Ca", Sweep}, {2 Millisecond, 3 Millisecond, 10 Millisecond, 10 Millisecond, 1 Millisecond}}
		],
		Example[
			{Options, NumberOfReads, "NumberOfReads will be the same as user-input:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					NumberOfReads -> {1, 2, 3, 4},
					Output -> Options
				],
				NumberOfReads
			],
			{1, 2, 3, 4}
		],
		Example[
			{Options, NumberOfReads, "NumberOfReads by default set to 1:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium},
					InternalStandard -> Null,
					Output -> Options
				],
				NumberOfReads
			],
			1
		],
		Example[
			{Options, ReadSpacing, "If ReadSpacing is specified, keep it as is, otherwise set to 0.2 g/mol for Sweep and 0.1 g/mol for actual isotopes:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium, Sweep},
					InternalStandard -> Null,
					ReadSpacing -> {0.05 Gram/Mole, 0.1 Gram/Mole, 0.2 Gram/Mole, Automatic, Automatic},
					Output -> Options
				],
				{Elements, ReadSpacing}
			],
			{{"23Na", "24Mg", "39K", "40Ca", Sweep}, {0.05 Gram/Mole, 0.1 Gram/Mole, 0.2 Gram/Mole, 0.1 Gram/Mole, 0.2 Gram/Mole}}
		],
		Example[
			{Options, ReadSpacing, "If a value lower than 0.05 g/mol is specified as ReadSpacing for Sweep, it will be changed to 0.05 g/mol:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Sweep},
					InternalStandard -> Null,
					ReadSpacing -> 0.02 Gram/Mole,
					Output -> Options
				],
				{Elements, ReadSpacing}
			],
			{{"23Na", "40Ca", Sweep}, {0.02 Gram/Mole, 0.02 Gram/Mole, 0.05 Gram/Mole}},
			Messages :> {Warning::ReadSpacingTooFineForSweep}
		],
		Example[
			{Options, Bandpass, "Bandpass will be kept unchanged from user-input:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium, Sweep},
					InternalStandard -> Null,
					Bandpass -> {Normal, High, Normal, High, Normal},
					Output -> Options
				],
				Bandpass
			],
			{Normal, High, Normal, High, Normal}
		],
		Example[
			{Options, StandardType, "If StandardType is specified, it will be kept as is:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> StandardAddition,
					Output -> Options
				],
				StandardType
			],
			StandardAddition
		],
		Example[
			{Options, StandardType, "If QuantifyConcentration set to False for all element, StandardType will automatically set to None:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					QuantifyConcentration -> False,
					Output -> Options
				],
				StandardType
			],
			None
		],
		Example[
			{Options, StandardType, "If ExternalStandard is specified, StandardType will automatically set to External:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
					Output -> Options
				],
				StandardType
			],
			External
		],
		Example[
			{Options, StandardType, "If ExternalStandardDilutionCurve is specified, StandardType will automatically set to External:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardDilutionCurve -> {{1 Milliliter, 9 Milliliter},{10 Milliliter, 0 Milliliter}},
					Output -> Options
				],
				StandardType
			],
			External
		],
		Example[
			{Options, StandardType, "If AdditionStandard is specified, StandardType will automatically set to StandardAddition:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					AdditionStandard -> Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
					Output -> Options
				],
				StandardType
			],
			StandardAddition
		],
		Example[
			{Options, StandardType, "If StandardAdditionCurve is specified, StandardType will automatically set to StandardAddition:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardAdditionCurve -> {{1}, {1.5}},
					Output -> Options
				],
				StandardType
			],
			StandardAddition
		],
		Example[
			{Options, ExternalStandard, "When attempt to auto-resolve any standard, only Model[Sample] objects which name contains both ICP and standard will appear in the search and be used as candidates:"},
			MemberQ[NamedObject[standardModelSearch["Memoization"]],#]&/@{
				Model[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID]
			},
			{True, False, True, True}
		],
		Example[
			{Options, ExternalStandard, "User can specify any sample as ExternalStandard, in that case there's no limitation on sample name:"},
			NamedObject[Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					Elements -> {Sodium, Aluminum},
					QuantifyConcentration-> True,
					Output -> Options
				],
				ExternalStandard
			]],
			{Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]}
		],
		Example[
			{Options, ExternalStandard, "If ExternalStandard is specified, it will be kept as is:"},
			NamedObject[Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					Output -> Options
				],
				ExternalStandard
			]],
			{Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]}
		],
		Example[
			{Options, ExternalStandard, "If StandardType is set or resolved to anything other than External, ExternalStandard will resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> StandardAddition,
					Output -> Options
				],
				ExternalStandard
			],
			Null
		],
		Example[
			{Options, ExternalStandard, "If ExternalStandard is not specified and StandardType set or resolved to External, one sample will be resolved as ExternalStandard if it covers all elements need quantification:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					Elements -> {Neptunium},
					QuantifyConcentration -> True,
					Output -> Options
				],
				ExternalStandard
			],
			ObjectP[Model[Sample]],
			Messages :> {Warning::BelowThresholdIsotopesIncluded, Error::NoAbundantIsotopeForQuantification, Error::InvalidOption}
		],
		Example[
			{Options, ExternalStandard, "If there isn't one sample that covers all elements need quantification, up tp 3 samples will be resolved as ExternalStandard to try to covers all elements need quantification:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					Elements -> {Neptunium, Berkelium, Mendelevium},
					QuantifyConcentration -> True,
					Output -> Options
				],
				ExternalStandard
			],
			{ObjectP[Model[Sample]], ObjectP[Model[Sample]], ObjectP[Model[Sample]]},
			Messages :> {Warning::BelowThresholdIsotopesIncluded, Error::NoAbundantIsotopeForQuantification, Error::InvalidOption}
		],
		Example[
			{Options, ExternalStandardElements, "ExternalStandardElements can be user-specified in the format of {isotope, concentration}. All molar concentrations will be converted to mass concentration:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					Elements -> {Sodium},
					ExternalStandardElements -> {{{"23Na", 10 Micromolar}, {"27Al", 1 Milligram/Milliliter}}},
					Output -> Options
				],
				ExternalStandardElements
			],
			{{{"23Na", MassConcentrationP}, {"27Al", EqualP[1 Milligram/Milliliter]}}}
		],
		Example[
			{Options, ExternalStandardElements, "ExternalStandardElements can be user-specified in the format of {element, concentration} list. Elements will be converted into all isotopes supported by ICPMS, and all molar concentrations will be converted into mass concentrations:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					ExternalStandardElements -> {{{Sodium, 10 Micromolar}, {Potassium, 1 Milligram/Liter}}},
					Elements -> {Sodium, Potassium},
					Output -> Options
				],
				ExternalStandardElements
			],
			{{{"23Na", MassConcentrationP}, {"39K", MassConcentrationP}}},
			Messages :> {Warning::NoAvailableStandard}
		],
		Example[
			{Options, ExternalStandardElements, "ExternalStandardElements can be user-specified in the format of element list. Elements will be converted into all isotopes supported by ICPMS, and concentrations will be auto-detected from Composition field of the standard. All molar concentrations will be converted into mass concentrations:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					Elements -> {Sodium, Aluminum},
					ExternalStandardElements -> {{Sodium, Aluminum}},
					Output -> Options
				],
				ExternalStandardElements
			],
			{{{"23Na", MassConcentrationP}, {"27Al", MassConcentrationP}}}
		],
		Example[
			{Options, ExternalStandardElements, "If ExternalStandardElements is set to Automatic, both elements and concentrations will be auto-detected from Composition field of the standard, and elements will be converted into all isotopes supported by ICPMS:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					Elements -> {Sodium, Aluminum, Cobalt, Arsenic},
					ExternalStandardElements -> {Automatic},
					Output -> Options
				],
				ExternalStandardElements
			],
			{{{"23Na", MassConcentrationP}, {"27Al", MassConcentrationP},{"59Co", MassConcentrationP},{"75As", MassConcentrationP}}}
		],
		Example[
			{Options, ExternalStandardElements, "If ExternalStandardElements is set to Automatic while ExternalStandard is set or resolved to {Null}, ExternalStandardElements will resolve to {Null}:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandard -> {Null},
					ExternalStandardElements -> {Automatic},
					QuantifyConcentration -> False,
					Output -> Options
				],
				ExternalStandardElements
			],
			{Null}
		],
		Example[
			{Options, InternalStandardElement, "If InternalStandard is specified while InternalStandardElement -> Automatic for all Elements, Element present in the internal standard will be automatically detected and InternalStandardElement set to True:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Germanium},
					InternalStandard -> Model[Sample, "ICP-MS Pharma internal standard 1"],
					Output -> Options
				],
				InternalStandardElement
			],
			{False, False, True, True, True}
		],
		Example[
			{Options, InternalStandardElement, "If InternalStandard is set to Null while InternalStandardElement -> Automatic for all Elements, InternalStandardElement resolves to False:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Germanium},
					InternalStandard -> Null,
					Output -> Options
				],
				InternalStandardElement
			],
			False
		],
		Example[
			{Options, InternalStandardElement, "If both InternalStandard and InternalStandardElement were set to Automatic, a standard will be autoresolved and extra elements as the internal standard element will be added into Elements option:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					Output -> Options
				],
				{Elements, InternalStandard}
			],
			{{"23Na", "40Ca", ICPMSNucleusP..}, ObjectP[]}
		],
		Example[
			{Options, StandardDilutionCurve, "StandardDilutionCurve can be set as a 3-level list, where outmost layer index match to ExternalStandard:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Germanium},
					ExternalStandard -> {Model[Sample, "ICP-MS Pharma internal standard 1"],Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					StandardDilutionCurve -> {{{1 Milliliter, 9 Milliliter},{3 Milliliter, 7 Milliliter}},{{1 Milliliter, 10}, {5 Milliliter, 2}}},
					Output -> Options
				],
				StandardDilutionCurve
			],
			{{{1 Milliliter, 9 Milliliter},{3 Milliliter, 7 Milliliter}},{{1 Milliliter, 9 Milliliter}, {5 Milliliter, 5 Milliliter}}}
		],
		Example[
			{Options, StandardDilutionCurve, "If StandardDilutionCurve set to Automatic, it resolves to Null if ExternalStandard is set to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					ExternalStandard -> Null,
					StandardType -> StandardAddition,
					StandardDilutionCurve -> Automatic,
					Output -> Options
				],
				StandardDilutionCurve
			],
			Null
		],
		Example[
			{Options, StandardDilutionCurve, "If StandardDilutionCurve set to Automatic and ExternalStandard exists, it resolves to a 3-level dilution:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					StandardType -> External,
					StandardDilutionCurve -> Automatic,
					Output -> Options
				],
				StandardDilutionCurve
			],
			{{VolumeP, VolumeP}, {EqualP[1 Milliliter], EqualP[2 Milliliter]}, {EqualP[3 Milliliter], EqualP[0 Milliliter]}}
		],
		Example[
			{Options, StandardDilutionCurve, "If StandardDilutionCurve set to Automatic and ExternalStandard exists, and isotope of highest concentration exceeds 10 mg/L, it resolves to a 3-level dilution so that highest concentration after dilution is 10 mg/L:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					StandardType -> External,
					ExternalStandard -> Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
					ExternalStandardElements ->{{Sodium, 100 Milligram/Liter}, {Calcium, 10 Milligram / Liter}},
					StandardDilutionCurve -> Automatic,
					Output -> Options
				],
				StandardDilutionCurve
			],
			{{EqualP[0.03000 Milliliter], EqualP[2.97 Milliliter]}, {EqualP[0.09000 Milliliter], EqualP[2.91 Milliliter]}, {EqualP[0.3000 Milliliter], EqualP[2.7000 Milliliter]}}
		],
		Example[
			{Options, Rinse, "Rinse option won't change after resolution:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Rinse -> False,
					Output -> Options
				],
				Rinse
			],
			False
		],
		Example[
			{Options, RinseSolution, "If RinseSolution is set to Automatic and Rinse set to True, it will resolve to the same solution as Blank:"},
			SameObjectQ[Sequence@@Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					RinseSolution -> Automatic,
					Rinse -> True,
					Output -> Options
				],
				{Blank, RinseSolution}
			]],
			True
		],
		Example[
			{Options, RinseSolution, "If RinseSolution is set to Automatic and Rinse set to False, it will not resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					RinseSolution -> Automatic,
					Rinse -> False,
					Output -> Options
				],
				RinseSolution
			],
			Except[Null]
		],
		Example[
			{Options, RinseTime, "If RinseTime is specified, it will be kept unchanged:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					RinseTime -> 56 Second,
					Rinse -> True,
					Output -> Options
				],
				RinseTime
			],
			EqualP[56 Second]
		],
		Example[
			{Options, RinseTime, "If RinseTime is set to Automatic while Rinse is set to True, it will resolve to 60 s:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					RinseTime -> Automatic,
					Rinse -> True,
					Output -> Options
				],
				RinseTime
			],
			EqualP[240 Second]
		],
		Example[
			{Options, RinseTime, "If RinseTime is set to Automatic while Rinse is set to False, it will resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					RinseTime -> Automatic,
					Rinse -> False,
					Output -> Options
				],
				RinseTime
			],
			Null
		],
		Example[
			{Options, MinMass, "If MinMass and/or MaxMass is specified, it will be kept unchanged:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					MinMass -> 10 Gram/Mole,
					MaxMass -> 200 Gram/Mole,
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{10 Gram/Mole, 200 Gram/Mole}
		],
		Example[
			{Options, MinMass, "If MinMass and/or MaxMass are automatic and Sweep is one of the resolved Elements, MinMass will resolve to 4.6 Gram/Mole, MaxMass will resolve to 245 Gram/Mole:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{4.6 Gram/Mole, 245 Gram/Mole}
		],
		Example[
			{Options, MinMass, "If MinMass and/or MaxMass are automatic and Sweep is not one of the resolved Elements, both options will resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{Null, Null}
		],
		Example[
			{Options, Digestion, "Digestion will be automatically set to True unless sample is liquid, Aqueous and acid without any biomolecules, judged by its corresponding fields:"},
			Lookup[
				ExperimentICPMS[{Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID]},
					Elements -> {Sodium, Calcium},
					Output -> Options
				],
				Digestion
			],
			{True, False}
		],
		Example[
			{Options, AdditionStandard, "If AdditionStandard is specified, it will be kept unchanged:"},
			SameObjectQ[Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					AdditionStandard -> Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
					Output -> Options
				],
				AdditionStandard
			], Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]],
			True
		],
		Example[
			{Options, AdditionStandard, "If StandardType is set or resolved to External, AdditionStandard will resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					Output -> Options
				],
				AdditionStandard
			],
			Null
		],
		Example[
			{Options, AdditionStandard, "If StandardType is set or resolved to None, AdditionStandard will resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> None,
					QuantifyConcentration -> False,
					Output -> Options
				],
				AdditionStandard
			],
			Null
		],
		Example[
			{Options, AdditionStandard, "If StandardType is set or resolved to StandardAddition, AdditionStandard will be resolved to one sample containing as many elements need quantification as possible:"},
			SameObjectQ[Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> StandardAddition,
					Output -> Options
				],
				AdditionStandard
			], Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]],
			True
		],
		Example[
			{Options, AdditionStandard, "When multiple samples present, it is possible to specify different AdditionStandard for different input samples:"},
			MapThread[
				SameObjectQ[#1, #2]&,
				{
					Lookup[
						ExperimentICPMS[{Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID]},
							Elements -> {Sodium},
							AdditionStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"], Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
							Output -> Options
						],
						AdditionStandard
					],
					{Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"], Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]}
				}
			],
			{True, True}
		],
		Example[
			{Options, AdditionStandard, "When multiple samples present, all samples with AdditionStandard -> Automatic will resolve the same AdditionStandard:"},
			MapThread[
				SameObjectQ[#1, #2]&,
				{
					Lookup[
						ExperimentICPMS[{Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID]},
							StandardType -> StandardAddition,
							AdditionStandard -> {Automatic, Automatic},
							Output -> Options
						],
						AdditionStandard
					],
					{Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"], Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]}
				}
			],
			{True, True}
		],
		Example[
			{Options, AdditionStandard, "If StandardType is set or resolved to None, AdditionStandard will resolve to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> None,
					QuantifyConcentration -> False,
					Output -> Options
				],
				AdditionStandard
			],
			Null
		],
		Example[
			{Options, StandardAdditionElements, "StandardAdditionElements can be user-specified in the format of {element, concentration} list. Elements will be converted into isotopes that presents in the resolved Elements field, and all molar concentrations will be converted into mass concentrations:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					AdditionStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					StandardAdditionElements -> {{{Sodium, 10 Micromolar}, {Potassium, 1 Milligram/Liter}}},
					Elements -> {Sodium, Potassium},
					IsotopeAbundanceThreshold -> 0 Percent,
					Output -> Options
				],
				StandardAdditionElements
			],
			{{{Sodium, MassConcentrationP}, {Potassium, EqualP[1 Milligram/Liter]}}}
		],
		Example[
			{Options, StandardAdditionElements, "StandardAdditionElements can be user-specified in the format of element list. Elements will be converted into isotopes that present in the resolved Elements field, and concentrations will be auto-detected from Composition field of the standard. All molar concentrations will be converted into mass concentrations:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					AdditionStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					Elements -> {Sodium, Aluminum},
					StandardAdditionElements -> {{Sodium, Aluminum}},
					Output -> Options
				],
				StandardAdditionElements
			],
			{{{Sodium, MassConcentrationP}, {Aluminum, MassConcentrationP}}}
		],
		Example[
			{Options, StandardAdditionElements, "If StandardAdditionElements is set to Automatic, both elements and concentrations will be auto-detected from Composition field of the standard, and elements will be converted into all isotopes supported by ICPMS:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					AdditionStandard -> {Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID]},
					Elements -> {Sodium, Aluminum, Cobalt, Arsenic},
					StandardAdditionElements -> {Automatic},
					Output -> Options
				],
				StandardAdditionElements
			],
			{{{Sodium, MassConcentrationP}, {Aluminum, MassConcentrationP},{Cobalt, MassConcentrationP},{Arsenic, MassConcentrationP}}}
		],
		Example[
			{Options, StandardAdditionElements, "If StandardAdditionElements is set to Automatic while AdditionStandard is set or resolved to {Null}, StandardAdditionElements will resolve to {Null}:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					AdditionStandard -> {Null},
					StandardAdditionElements -> {Automatic},
					QuantifyConcentration -> False,
					Output -> Options
				],
				StandardAdditionElements
			],
			{Null}
		],
		Example[
			{Options, StandardAdditionCurve, "StandardAdditionCurve can be set as a 2-level list, where outmost layer index match to input samples, and inner list consists a list of volumes of the standard:"},
			Lookup[
				ExperimentICPMS[{Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID]},
					Elements -> {Sodium, Calcium},
					AdditionStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"], Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					StandardAdditionCurve -> {{{1 Milliliter}, {2 Milliliter}},{{2 Milliliter}, {3 Milliliter}}},
					Output -> Options
				],
				StandardAdditionCurve
			],
			{{{1 Milliliter}, {2 Milliliter}},{{2 Milliliter}, {3 Milliliter}}}
		],
		Example[
			{Options, StandardAdditionCurve, "If StandardAdditionCurve set to Automatic, it resolves to Null if AdditionStandard is set to Null:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					AdditionStandard -> Null,
					StandardType -> External,
					StandardAdditionCurve -> Automatic,
					Output -> Options
				],
				StandardAdditionCurve
			],
			Null
		],
		Example[
			{Options, StandardAdditionCurve, "If StandardAdditionCurve set to Automatic and AdditionStandard exists, it resolves to a 3-level mixing, plus one without adding any standard:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					StandardType -> StandardAddition,
					StandardAdditionCurve -> Automatic,
					Output -> Options
				],
				StandardAdditionCurve
			],
			{{EqualP[0 Milliliter]},{EqualP[0.6000 Milliliter]}, {EqualP[1.2000 Milliliter]}, {EqualP[3.0000 Milliliter]}}
		],
		Example[
			{Options, StandardAdditionCurve, "If StandardAdditionCurve set to Automatic and ExternalStandard exists, and isotope of highest concentration exceeds 20 mg/L, it resolves to a 3-level mixing so that highest concentration after dilution is 10 mg/L, plus one without any standard:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					StandardType -> StandardAddition,
					AdditionStandard -> Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
					StandardAdditionElements ->{{Sodium, 100 Milligram/Liter}, {Calcium, 10 Milligram / Liter}},
					StandardAdditionCurve -> Automatic,
					Output -> Options
				],
				StandardAdditionCurve
			],
			{{EqualP[0 Milliliter]}, {EqualP[1/33 Milliliter]}, {VolumeP}, {EqualP[1/3 Milliliter]}}
		],
		Example[
			{Options, StandardAddedSample, "If StandardAddedSample is set to True, AdditionStandard and StandardAdditionCurve will be resolved to Null, and StandardAdditionElements will be read from input sample rather than AdditionStandard:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Fake Standard object Na Al As Co" <> $SessionUUID],
					StandardType -> StandardAddition,
					AdditionStandard -> Automatic,
					StandardAddedSample -> True,
					StandardAdditionElements -> Automatic,
					StandardAdditionCurve -> Automatic,
					Output -> Options
				],
				{AdditionStandard, StandardAdditionElements, StandardAdditionCurve}
			],
			{Null, {{Sodium, MassConcentrationP}, {Aluminum, MassConcentrationP},{Cobalt, MassConcentrationP},{Arsenic, MassConcentrationP}}, {{EqualP[0 Milliliter]}}}
		],
		Example[
			{Options, InternalStandardMixRatio, "If InternalStandardMixRatio is specified, keep it as is:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandardMixRatio -> 0.2,
					Output -> Options
				],
				InternalStandardMixRatio
			],
			0.2
		],
		Example[
			{Options, InternalStandardMixRatio, "If InternalStandardMixRatio is not specified, and InternalStandard is specified or resolved into an object, set to 0.111:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandardMixRatio -> Automatic,
					Output -> Options
				],
				InternalStandardMixRatio
			],
			0.111
		],
		Example[
			{Options, InternalStandardMixRatio, "If InternalStandardMixRatio is not specified, and InternalStandard is specified or resolved into Null, set to 0:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandardMixRatio -> Automatic,
					InternalStandard -> Null,
					Output -> Options
				],
				InternalStandardMixRatio
			],
			0
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentICPMS:"},
			Download[ExperimentICPMS["My Pooled Sample",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label -> "My Pooled Sample",
						Container -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *)
					],
					Transfer[
						Source -> {
							Object[Sample,"ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride"<>$SessionUUID],
							Object[Sample,"ExperimentICPMS Test Sample 2 with Copper (II) Sulfate"<>$SessionUUID]
						},
						Destination -> "My Pooled Sample",
						Amount -> {3000 Microliter, 2600 Microliter}
					]
				}
			],PreparatoryUnitOperations],
			{SamplePreparationP..}
		],
		(* TODO uncomment these two after building simulation function *)

		(* ===Messages=== *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentICPMS[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentICPMS[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentICPMS[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentICPMS[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[
				{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
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

				ExperimentICPMS[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[
				{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
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

				ExperimentICPMS[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[
			{Messages, "LowAbundanceIsotopes", "If Elements option is directly specified as a list of isotopes, and that list contains isotopes with 10% or lower natural abundance, a warning will be given:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {"56Fe", "57Fe", "58Fe"},
					InternalStandard -> Null,
					Output -> Options
				],
				Elements
			],
			{"56Fe", "57Fe", "58Fe"},
			Messages:> {Warning::LowAbundanceIsotopes}
		],
		Example[
			{Messages, "LowAbundanceIsotopes", "If Elements option is specified as a list of elements, the LowAbundanceIsotope warning will never be given:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID],
					Elements -> {Iron},
					InternalStandard -> Null,
					IsotopeAbundanceThreshold -> 1 Percent, Output -> Options
				],
				Elements
			],
			{"54Fe", "56Fe", "57Fe"}
		],
		Example[
			{Messages, "LowAbundanceIsotopes", "If Elements option is not specified at all, the LowAbundanceIsotope warning will never be given:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID],
					Elements -> Automatic,
					InternalStandard -> Null,
					IsotopeAbundanceThreshold -> 1 Percent, Output -> Options
				],
				Elements
			],
			{"54Fe", "56Fe", "57Fe", Sweep}
		],
		Example[
			{Messages, "InstrumentPrecision", "Precision of MinMass, MaxMass and ReadSpacing will be rounded to 0.01 Gram/Mole:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Sweep},
					InternalStandard -> Null,
					ReadSpacing -> {0.123456 Gram/Mole, 0.276543 Gram/Mole, 1/3 Gram/Mole},
					Output -> Options
				],
				{ReadSpacing}
			],
			{{0.12 Gram / Mole, 0.28 Gram / Mole, 0.33 Gram / Mole}},
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[
			{Messages, "InstrumentPrecision", "Precision of InjectionDuration and RinseTime will be rounded to 1 second:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InjectionDuration -> 33.3333333 Second,
					RinseTime -> 55.5555555 Second,
					Output -> Options
				],
				{InjectionDuration, RinseTime}
			],
			{33 Second, 56 Second},
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[
			{Messages, "InstrumentPrecision", "Precision of DwellTime will be rounded to 0.1 ms:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					DwellTime -> 1.23456 Millisecond,
					InternalStandard -> Null,
					Output -> Options
				],
				DwellTime
			],
			1.2 Millisecond,
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[
			{Messages, "InstrumentPrecision", "Precision of CollisionCellGasFlowRate will be rounded to 0.1 ml/min:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					CollisionCellGasFlowRate -> 3.796354 Milliliter/Minute,
					InternalStandard -> Null,
					Output -> Options
				],
				CollisionCellGasFlowRate
			],
			3.8 Milliliter/Minute,
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[
			{Messages, "ReadSpacingTooFineForSweep", "If ReadSpacing parameter for Sweep is set below 0.05 g/mol, it will be raised to 0.05 g/mol:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Sweep},
					InternalStandard -> Null,
					ReadSpacing -> 0.02 Gram/Mole,
					Output -> Options
				],
				{Elements, ReadSpacing}
			],
			{{"23Na", Sweep}, {EqualP[0.02 Gram/Mole], EqualP[0.05 Gram/Mole]}},
			Messages :> {Warning::ReadSpacingTooFineForSweep}
		],
		Example[
			{Messages, "CollisionCellBiasOnWithoutGas", "If CollisionCellBias set to True when CollisionCellPressurization set to False, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandard -> Null,
					CollisionCellPressurization -> False,
					CollisionCellBias -> True,
					Output -> Options
				],
				{CollisionCellPressurization, CollisionCellBias}
			],
			{False, True},
			Messages :> {Error::CollisionCellBiasOnWithoutGas, Error::InvalidOption}
		],
		Example[
			{Messages, "CollisionCellGasConflict", "If CollisionCellPressurization set to False but CollisionCellGas set to Non-Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Sweep},
					InternalStandard -> Null,
					CollisionCellPressurization -> False,
					CollisionCellGas -> {Helium, Helium, Null},
					CollisionCellBias -> False,
					Output -> Options
				],
				{CollisionCellPressurization, CollisionCellGas}
			],
			{False, {Helium, Helium, Null}},
			Messages :> {Message[Error::CollisionCellGasConflict, {"23Na", "40Ca"}], Error::InvalidOption}
		],
		Example[
			{Messages, "CollisionCellGasConflict", "If CollisionCellPressurization set to True but CollisionCellGas set to Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Sweep},
					InternalStandard -> Null,
					CollisionCellPressurization -> True,
					CollisionCellGas -> {Helium, Helium, Null},
					Output -> Options
				],
				{CollisionCellPressurization, CollisionCellGas}
			],
			{True, {Helium, Helium, Null}},
			Messages :> {Message[Error::CollisionCellGasConflict, {Sweep}], Error::InvalidOption}
		],
		Example[
			{Messages, "CollisionCellGasFlowRateConflict", "If CollisionCellGas set to Non-Null but CollisionCellGasFlowRate set to 0, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium, Sweep},
					InternalStandard -> Null,
					CollisionCellPressurization -> {True, True, True, False, False},
					CollisionCellGas -> {Helium, Helium, Automatic, Null, Automatic},
					CollisionCellGasFlowRate -> 0 Milliliter/Minute,
					Output -> Options
				],
				{CollisionCellGas, CollisionCellGasFlowRate}
			],
			{{Helium, Helium, Helium, Null, Null}, 0 Milliliter/Minute},
			Messages :> {Message[Error::CollisionCellGasFlowRateConflict, {"23Na", "24Mg", "39K"}], Error::InvalidOption}
		],
		Example[
			{Messages, "CollisionCellGasFlowRateConflict", "If CollisionCellGas set to Null but CollisionCellGasFlowRate set to non-zero, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Magnesium, Potassium, Calcium, Sweep},
					InternalStandard -> Null,
					CollisionCellPressurization -> {True, True, True, False, False},
					CollisionCellGas -> {Helium, Helium, Automatic, Null, Automatic},
					CollisionCellGasFlowRate -> 4.5 Milliliter/Minute,
					Output -> Options
				],
				{CollisionCellGas, CollisionCellGasFlowRate}
			],
			{{Helium, Helium, Helium, Null, Null}, 4.5 Milliliter/Minute},
			Messages :> {Message[Error::CollisionCellGasFlowRateConflict, {"40Ca", Sweep}], Error::InvalidOption}
		],
		Example[
			{Messages, "NonLiquidNonSolidSample", "If the PhysicalState of any input sample is neither Solid nor Liquid, an error will be thrown:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				Elements -> {Sodium},
				InternalStandard -> Null,
				CollisionCellPressurization -> {False}
			],
			$Failed,
			Messages :> {Error::NonLiquidNonSolidSample, Error::InvalidInput},
			SetUp :> {Upload[<|Object -> Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], State -> Null|>]},
			TearDown :> {Upload[<|Object -> Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID], State -> Liquid|>]}
		],
		Example[
			{Messages, "AttemptToQuantifySweep", "If QuantifyConcentration is set to True for Sweep, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Sweep},
					InternalStandard -> Null,
					QuantifyConcentration -> True,
					Output -> Options
				],
				QuantifyConcentration
			],
			True,
			Messages :> {Error::AttemptToQuantifySweep, Error::InvalidOption}
		],
		Example[
			{Messages, "AttemptToQuantifySweep", "If InternalStandardElement is set to True for Sweep, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Sweep},
					InternalStandardElement -> True,
					Output -> Options
				],
				InternalStandardElement
			],
			True,
			Messages :> {Error::AttemptToQuantifySweep, Warning::InternalStandardElementPresentInSample, Error::InvalidOption}
		],
		Example[
			{Messages, "InternalStandardElementPresentInSample", "If element with InternalStandardElement set to True present in at least one sample, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID],
					Elements -> {Iron, Sweep},
					InternalStandardElement -> {True, False},
					StandardType -> None,
					QuantifyConcentration -> False,
					Output -> Options
				],
				InternalStandardElement
			],
			{True, False},
			Messages :> {Warning::InternalStandardElementPresentInSample}
		],
		Example[
			{Messages, "CannotQuantifyInternalStandardElement", "If InternalStandardElement and QuantifyConcentration for any element is both set to True, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Calcium, Scandium},
					InternalStandardElement -> {False, True},
					QuantifyConcentration -> True,
					Output -> Options
				],
				{Elements, QuantifyConcentration, InternalStandardElement}
			],
			{{"40Ca", "45Sc"}, True, {False, True}},
			Messages :> {Error::CannotQuantifyInternalStandardElement, Warning::InternalStanardUnwantedElement, Error::InvalidOption}
		],
		Example[
			{Messages, "InternalStanardUnwantedElement", "If InternalStandardElement and QuantifyConcentration for any element is both set to True, warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {"113In", "115In"},
					InternalStandardElement -> {False, True},
					QuantifyConcentration -> {True, False},
					Output -> Options
				],
				{Elements, QuantifyConcentration, InternalStandardElement}
			],
			{{"113In", "115In"}, {True, False}, {False, True}},
			Messages :> {Warning::InternalStanardUnwantedElement, Warning::LowAbundanceIsotopes}
		],
		Example[
			{Messages, "InternalStandardElementAbsent", "If InternalStandardElement is specified but it doesn't present in the specified or resolved internal standard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Potassium},
					InternalStandardElement -> {False, True},
					QuantifyConcentration -> {True, False},
					InternalStandard -> Model[Sample, "ICP-MS Pharma internal standard 1"],
					Output -> Options
				],
				{Elements, QuantifyConcentration, InternalStandardElement}
			],
			{{"23Na", "39K"}, {True, False}, {False, True}},
			Messages :> {Warning::InternalStandardElementAbsent}
		],
		Example[
			{Messages, "InvalidExternalStandard", "If any of the ExternalStandard contains element that do not need to be quantified, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Sweep},
					InternalStandardElement -> False,
					QuantifyConcentration -> {True, False},
					ExternalStandard -> {Model[Sample, "ICP-MS Pharma internal standard 1"], Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					InternalStandard -> Null,
					Output -> Options
				],
				{Elements, ExternalStandard}
			],
			{{"23Na", Sweep}, {ObjectP[Model[Sample, "ICP-MS Pharma internal standard 1"]], ObjectP[Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]]}},
			Messages :> {Warning::InvalidExternalStandard}
		],
		Example[
			{Messages, "InvalidExternalStandardElements", "If only ExternalStandardElements is specified, StandardType will be resolve to External, but an error message is thrown since ExternalStandard is not specified:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					ExternalStandardElements -> {Sodium, Calcium},
					Output -> Options
				],
				StandardType
			],
			External,
			Messages :> {Error::InvalidExternalStandardElements, Error::InvalidOption}
		],
		Example[
			{Messages, "InvalidStandardAdditionElements", "If only StandardAdditionElements is specified, StandardType will be resolve to StandardAddition, but an error message is thrown since AdditionStandard is not specified:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardAdditionElements -> {Sodium, Calcium},
					Output -> Options
				],
				StandardType
			],
			StandardAddition,
			Messages :> {Error::InvalidStandardAdditionElements, Error::InvalidOption}
		],
		Example[
			{Messages, "NoAvailableAdditionStandard", "If some but not all elements that need quantification can be found in the AdditionStandard, a warning is thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> StandardAddition,
					Elements -> {Indium, Potassium},
					QuantifyConcentration -> True,
					InternalStandardElement -> False,
					AdditionStandard -> Model[Sample, "ICP-MS Pharma internal standard 1"],
					Output -> Options
				],
				StandardType
			],
			StandardAddition,
			Messages :> {Warning::NoAvailableAdditionStandard}
		],
		Example[
			{Messages, "NoStandardNecessary", "If QuantifyConcentration is set to False for all Elements but StandardType is set to External without manually specifying ExternalStandard, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					QuantifyConcentration -> False,
					StandardType -> External,
					Output -> Options
				],
				StandardType
			],
			External,
			Messages :> {Error::NoStandardNecessary, Error::InvalidOption}
		],
		Example[
			{Messages, "NoStandardNecessary", "If QuantifyConcentration is set to False for all Elements but StandardType is set to StandardAddition without manually specifying AdditionStandard, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					QuantifyConcentration -> False,
					StandardType -> StandardAddition,
					Output -> Options
				],
				StandardType
			],
			StandardAddition,
			Messages :> {Error::NoStandardNecessary, Error::InvalidOption}
		],
		Example[
			{Messages, "NoStandardNecessary", "If QuantifyConcentration is set to False for all Elements but StandardType is set to External with manually specified ExternalStandard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					QuantifyConcentration -> False,
					StandardType -> External,
					ExternalStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					Output -> Options
				],
				StandardType
			],
			External,
			Messages :> {Warning::NoStandardNecessary}
		],
		Example[
			{Messages, "NoStandardNecessary", "If QuantifyConcentration is set to False for all Elements but StandardType is set to StandardAddition with manually specified AdditionStandard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					QuantifyConcentration -> False,
					StandardType -> StandardAddition,
					AdditionStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					Output -> Options
				],
				StandardType
			],
			StandardAddition,
			Messages :> {Warning::NoStandardNecessary}
		],
		Example[
			{Messages, "StandardRecommended", "If QuantifyConcentration is set to True for at least one Element but StandardType is set to None, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> None,
					Output -> Options
				],
				StandardType
			],
			None,
			Messages :> {Warning::StandardRecommended}
		],
		Example[
			{Messages, "ExternalStandardPresence", "If ExternalStandard is not {Null} but StandardType is None, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> None,
					ExternalStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					QuantifyConcentration -> False,
					Output -> Options
				],
				StandardType
			],
			None,
			Messages :> {Error::ExternalStandardPresence, Error::InvalidOption}
		],
		Example[
			{Messages, "ExternalStandardPresence", "If ExternalStandard is not {Null} but StandardType is StandardAddition, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> StandardAddition,
					ExternalStandard -> {Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]},
					Output -> Options
				],
				StandardType
			],
			StandardAddition,
			Messages :> {Error::ExternalStandardPresence, Error::InvalidOption}
		],
		Example[
			{Messages, "ExternalStandardAbsence", "If ExternalStandard is {Null} but StandardType is External, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					ExternalStandard -> {Null},
					Output -> Options
				],
				StandardType
			],
			External,
			Messages :> {Error::ExternalStandardAbsence, Warning::NoAvailableStandard, Error::InvalidOption}
		],
		Example[
			{Messages, "NoAvailableStandard", "If ExternalStandard is user-specified, element contained in the standard will be auto-detected, and if any element that needs quantification do not present in any of the specified standard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					Elements -> {Sodium, Calcium},
					QuantifyConcentration -> True,
					ExternalStandard -> {Model[Sample, "ICP-MS Pharma internal standard 1"]},
					Output -> Options
				],
				StandardType
			],
			External,
			Messages :> {Warning::NoAvailableStandard, Warning::InvalidExternalStandard}
		],
		Example[
			{Messages, "NoAvailableStandard", "If ExternalStandard is auto-resolved but there exists at least one element which needs quantification that cannot be found in any of the resolved standard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					Elements -> {Sodium, Calcium, Technetium},
					QuantifyConcentration -> True,
					Output -> Options
				],
				StandardType
			],
			External,
			Messages :> {Warning::NoAvailableStandard, Warning::BelowThresholdIsotopesIncluded, Error::NoAbundantIsotopeForQuantification, Error::InvalidOption}
		],
		Example[
			{Messages, "NoAvailableStandard", "A max of 3 samples can be resolved for ExternalStandard. If there're still other elements need quantification, no more standard will be resolved even if a suitable standard exists, and a warning will be thrown:"},
			Length[Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					StandardType -> External,
					Elements -> {Sodium, Neptunium, Lawrencium, Einsteinium},
					QuantifyConcentration -> True,
					Output -> Options
				],
				ExternalStandard
			]],
			3,
			Messages :> {Warning::NoAvailableStandard, Warning::BelowThresholdIsotopesIncluded, Error::NoAbundantIsotopeForQuantification, Error::InvalidOption}
		],
		Example[
			{Messages, "NoInternalStandardElement", "If InternalStandard is specified but InternalStandardElements is set to False for all elements, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					InternalStandard -> Model[Sample, "ICP-MS Pharma internal standard 1"],
					InternalStandardElement -> False,
					Output -> Options
				],
				InternalStandardElement
			],
			False,
			Messages :> {Warning::NoInternalStandardElement}
		],
		Example[
			{Messages, "NoInternalStandardElement", "If InternalStandard is specified, but for all Elements which InternalStandardElement set to Automatic, none of them is in the internal standard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium},
					InternalStandard -> Model[Sample, "ICP-MS Pharma internal standard 1"],
					InternalStandardElement -> Automatic,
					Output -> Options
				],
				InternalStandardElement
			],
			False,
			Messages :> {Warning::NoInternalStandardElement}
		],
		Example[
			{Messages, "MissingElementsInStandards", "If any element specified in ExternalStandardElements option does not exist in composition field of the corresponding external standard, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Sweep},
					ExternalStandard -> Model[Sample, "ICP-MS Pharma internal standard 1"],
					ExternalStandardElements -> {Sodium, Germanium},
					InternalStandard -> Null,
					Output -> Options
				],
				InternalStandardElement
			],
			False,
			Messages :> {Warning::MissingElementsInStandards, Warning::NoAvailableStandard}
		],
		Example[
			{Messages, "InvalidRinse", "If Rinse is set to False but any rinse-related options are not Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Rinse -> False,
					RinseTime -> 30 Second,
					InternalStandard -> Null,
					Output -> Options
				],
				Rinse
			],
			False,
			Messages :> {Error::InvalidRinse, Error::InvalidOption}
		],
		Example[
			{Messages, "InvalidRinse", "If Rinse is set to False but any rinse-related options are not Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Rinse -> False,
					RinseTime -> 55 Second,
					InternalStandard -> Null,
					Output -> Options
				],
				Rinse
			],
			False,
			Messages :> {Error::InvalidRinse, Error::InvalidOption}
		],
		Example[
			{Messages, "InvalidRinseOptions", "If Rinse is set to True but any rinse-related options are  Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Rinse -> True,
					RinseTime -> Null,
					RinseSolution -> Automatic,
					InternalStandard -> Null,
					Output -> Options
				],
				Rinse
			],
			True,
			Messages :> {Error::InvalidRinseOptions, Error::InvalidOption}
		],
		Example[
			{Messages, "MinMaxMassInversion", "If MinMass is greater than or equal to MaxMass, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					MinMass -> 100 Gram/Mole,
					MaxMass -> 50 Gram/Mole,
					InternalStandard -> Null,
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{100 Gram/Mole, 50 Gram/Mole},
			Messages :> {Error::MinMaxMassInversion, Error::InvalidOption}
		],
		Example[
			{Messages, "MassRangeNarrow", "If difference between MinMass and MaxMass is within 10 g/mol, a warning will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					MinMass -> 100 Gram/Mole,
					MaxMass -> 102 Gram/Mole,
					InternalStandard -> Null,
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{100 Gram/Mole, 102 Gram/Mole},
			Messages :> {Warning::MassRangeNarrow}
		],
		Example[
			{Messages, "MissingMassRange", "If Sweep is in Elements option but MinMass or MaxMass set to Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					MinMass -> 100 Gram/Mole,
					MaxMass -> Null,
					InternalStandard -> Null,
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{100 Gram/Mole, Null},
			Messages :> {Error::MissingMassRange, Error::InvalidOption}
		],
		Example[
			{Messages, "InvalidMassRange", "If Sweep is not in Elements option but MinMass or MaxMass set to a quantity, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					MinMass -> 100 Gram/Mole,
					MaxMass -> Null,
					Elements -> {Sodium, Calcium},
					InternalStandard -> Null,
					Output -> Options
				],
				{MinMass, MaxMass}
			],
			{100 Gram/Mole, Null},
			Messages :> {Error::InvalidMassRange, Error::InvalidOption}
		],
		Example[
			{Messages, "DigestionNeededForNonLiquid", "If State of input sample is not liquid, Digestion cannot set to False, otherwise an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Solid Sample 1 with Sodium Chloride" <> $SessionUUID],
					Digestion -> {False},
					InternalStandard -> Null,
					Output -> Options
				],
				Digestion
			],
			{False},
			Messages :> {Error::DigestionNeededForNonLiquid, Error::InvalidOption}
		],
		Example[
			{Messages, "NoAvailableInternalStandard", "If at least one Element was specified as InternalStandardElement -> True while InternalStandard set to Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Technetium},
					InternalStandardElement -> {False, False, True},
					InternalStandard -> Null,
					Output -> Options
				],
				{InternalStandardElement, InternalStandard}
			],
			{{False, False, True}, Null},
			Messages :> {Error::NoAvailableInternalStandard, Error::InvalidOption, Warning::BelowThresholdIsotopesIncluded, Warning::InternalStandardElementAbsent}
		],
		Example[
			{Messages, "NoAvailableInternalStandard", "If at least one Element was specified as InternalStandardElement -> True and InternalStandard -> Automatic, but no good standard can be found and InternalStandard resolved to Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Technetium},
					InternalStandardElement -> {False, False, True},
					InternalStandard -> Automatic,
					Output -> Options
				],
				{InternalStandardElement, InternalStandard}
			],
			{{False, False, True}, Null},
			Messages :> {Error::NoAvailableInternalStandard, Error::InvalidOption, Warning::BelowThresholdIsotopesIncluded, Warning::InternalStandardElementAbsent}
		],
		Example[
			{Messages, "InternalStandardInvalidVolume", "If InternalStandard is not Null while InternalStandardMixRatio set to 0, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandard -> Automatic,
					InternalStandardMixRatio -> 0,
					Output -> Options
				],
				InternalStandardMixRatio
			],
			0,
			Messages :> {Error::InternalStandardInvalidVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "InternalStandardInvalidVolume", "If InternalStandard is Null while InternalStandardMixRatio set to non-zero, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					InternalStandard -> Null,
					InternalStandardMixRatio -> 0.2,
					Output -> Options
				],
				InternalStandardMixRatio
			],
			0.2,
			Messages :> {Error::InternalStandardInvalidVolume, Error::InvalidOption}
		],
		Example[
			{Messages, "UnableToFindInternalStandard", "If no Element was specified as InternalStandardElement -> True and InternalStandard -> Automatic, but no good standard can be found and InternalStandard resolved to Null, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {Sodium, Calcium, Plutonium, Americium, Berkelium, Lawrencium, Germanium},
					InternalStandardElement -> Automatic,
					InternalStandard -> Automatic,
					QuantifyConcentration -> False,
					Output -> Options
				],
				InternalStandard
			],
			Null,
			Messages :> {Error::UnableToFindInternalStandard, Error::InvalidOption, Warning::BelowThresholdIsotopesIncluded}
		],
		Example[
			{Messages, "NoAbundantIsotopeForQuantification", "If QuantifyElements -> True while among resolved list of isotopes with QuantifyConcentration -> True, at least one element contains only isotopes below 0.1% abundance, an error will be thrown:"},
			Lookup[
				ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
					Elements -> {"23Na", "46Ca"},
					QuantifyElements -> True,
					QuantifyConcentration -> True,
					Output -> Options
				],
				QuantifyElements
			],
			True,
			Messages :> {Error::NoAbundantIsotopeForQuantification, Error::InvalidOption, Warning::LowAbundanceIsotopes}
		],
		Example[
			{Messages, "SampleVolumeOverflow", "For StandardType -> StandardAddition, if any of the StandardAdditionCurve entry resulted in sample volume to exceed 15 mL, an error will be thrown:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				Elements -> {Sodium, Sweep},
				StandardType -> StandardAddition,
				AdditionStandard -> Model[Sample, "id:kEJ9mqJXr9k8"],
				StandardAdditionCurve -> {{{5}, {4}, {2}, {0}}},
				SampleAmount -> 5 Milliliter,
				Digestion -> False
			],
			$Failed,
			Messages :> {Error::SampleVolumeOverflow, Error::InvalidOption}
		],
		Example[
			{Messages, "StandardVolumeOverflow", "For StandardType -> External, if any of the StandardDilutionCurve entry resulted in sample volume to exceed 15 mL, an error will be thrown:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				Elements -> {Sodium, Sweep},
				StandardType -> External,
				ExternalStandard -> Model[Sample, "id:kEJ9mqJXr9k8"],
				StandardDilutionCurve -> {{20 Milliliter, 0 Milliliter}, {10 Milliliter, 10 Milliliter}},
				SampleAmount -> 5 Milliliter,
				Digestion -> False
			],
			$Failed,
			Messages :> {Error::StandardVolumeOverflow, Error::InvalidOption}
		],
		Example[
			{Messages, "UnsupportedElements", "If user requested any elements to be measured that are not supported by the resolved instrument, an error will be thrown:"},
			ExperimentICPMS[Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				Elements -> {Rutherfordium, Sweep},
				StandardType -> None,
				QuantifyConcentration -> False,
				Digestion -> False
			],
			$Failed,
			Messages :> {Error::UnsupportedElements, Error::InvalidOption}
		]
		(* TODO: End of Messages*)
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
	),
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
	SymbolSetUp :> (
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Test Solid Sample 1 with Sodium Chloride" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Test Fake Standard object Na Al As Co" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
				Object[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (I)" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (II)" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (III)" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (IV)" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (V)" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 1" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 2" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 3" <> $SessionUUID],
				Object[Container, Vessel, "ExperimentICPMS Test Container Fake stan-dard" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
				Model[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ExperimentICPMS"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
		Module[{otherFakeStandards},
			otherFakeStandards = Search[Model[Sample], StringContainsQ[Name, "ICPMS Fake Standard "]];
			If[Length[otherFakeStandards]>0,
				Quiet[EraseObject[otherFakeStandards, Force -> True, Verbose -> False]]
			];
		];
		Module[{firstUpload, secondUpload, testBench},
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				Name -> "Test Bench for ExperimentICPMS"<>$SessionUUID,
				DeveloperObject -> True,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Site -> Link[$Site]
			|>];
			Block[{$DeveloperUpload=True},
				UploadSample[
					{
						Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *),
						Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *),
						Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *),
						Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *),
						Model[Container, Vessel, "id:xRO9n3vk11pw"] (* "15mL Tube" *),
						Model[Container, Vessel, "id:1ZA60vLXrOo6"] (* "100 mL rectangular translucent white plastic bottle" *),
						Model[Container, Vessel, "id:1ZA60vLXrOo6"] (* "100 mL rectangular translucent white plastic bottle" *),
						Model[Container, Vessel, "id:1ZA60vLXrOo6"] (* "100 mL rectangular translucent white plastic bottle" *),
						Model[Container, Vessel, "id:1ZA60vLXrOo6"] (* "100 mL rectangular translucent white plastic bottle" *)
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"ExperimentICPMS Test Container for 15 ml sample (I)" <> $SessionUUID,
						"ExperimentICPMS Test Container for 15 ml sample (II)" <> $SessionUUID,
						"ExperimentICPMS Test Container for 15 ml sample (III)" <> $SessionUUID,
						"ExperimentICPMS Test Container for 15 ml sample (IV)" <> $SessionUUID,
						"ExperimentICPMS Test Container for 15 ml sample (V)" <> $SessionUUID,
						"ExperimentICPMS Test Container Fake Standard 1" <> $SessionUUID,
						"ExperimentICPMS Test Container Fake Standard 2" <> $SessionUUID,
						"ExperimentICPMS Test Container Fake Standard 3" <> $SessionUUID,
						"ExperimentICPMS Test Container Fake stan-dard" <> $SessionUUID
					}
				]
			];
			firstUpload = Upload[
				{
					Association[
						Type -> Model[Sample],
						Name -> "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID,
						Replace[Composition] -> {
							{10 Milligram/Liter, Link[Model[Molecule,"Neptunium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Plutonium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Americium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Curium"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						},
						Expires->False,
						State->Liquid, BiosafetyLevel->"BSL-1", Flammable -> False, Acid -> False, Base -> False,
						Pyrophoric->False, MSDSRequired->False, Replace[IncompatibleMaterials] -> {None},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					],
					Association[
						Type -> Model[Sample],
						Name -> "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID,
						Replace[Composition] -> {
							{10 Milligram/Liter, Link[Model[Molecule,"Berkelium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Californium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Einsteinium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Fermium"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						},
						Expires->False,
						State->Liquid, BiosafetyLevel->"BSL-1", Flammable -> False, Acid -> False, Base -> False,
						Pyrophoric->False, MSDSRequired->False, Replace[IncompatibleMaterials] -> {None},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					],
					Association[
						Type -> Model[Sample],
						Name -> "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID,
						Replace[Composition] -> {
							{10 Milligram/Liter, Link[Model[Molecule,"Mendelevium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Nobelium"]]},
							{10 Milligram/Liter, Link[Model[Molecule,"Lawrencium"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						},
						Expires->False,
						State->Liquid, BiosafetyLevel->"BSL-1", Flammable -> False, Acid -> False, Base -> False,
						Pyrophoric->False, MSDSRequired->False, Replace[IncompatibleMaterials] -> {None},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					],
					Association[
						Type -> Model[Sample],
						Name -> "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID,
						Replace[Composition] -> {
							{10 Micromolar, Link[Model[Molecule,"Sodium(1+)"]]},
							{10 Micromolar, Link[Model[Molecule,"Aluminum(3+)"]]},
							{10 Micromolar, Link[Model[Molecule,"Cobalt"]]},
							{10 Micromole/Liter, Link[Model[Molecule,"Arsenic"]]},
							{100 VolumePercent, Link[Model[Molecule, "Water"]]}
						},
						Expires->False,
						State->Liquid, BiosafetyLevel->"BSL-1", Flammable -> False, Acid -> False, Base -> False,
						Pyrophoric->False, MSDSRequired->False, Replace[IncompatibleMaterials] -> {None},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					]
				}
			];


			secondUpload = ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "id:8qZ1VWNmdLBD"] (* "Milli-Q water *),
					Model[Sample, "id:8qZ1VWNmdLBD"] (* "Milli-Q water *),
					Model[Sample, "id:8qZ1VWNmdLBD"] (* "Milli-Q water *),
					Model[Sample, "id:8qZ1VWNmdLBD"] (* "Milli-Q water *),
					Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID],
					Model[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
					Model[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
					Model[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID]
				},
				{
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (I)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (II)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (III)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (IV)" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container Fake stan-dard" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 1" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 2" <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 3" <> $SessionUUID]}
				},
				InitialAmount -> {
					5 Milliliter,
					5 Milliliter,
					5 Milliliter,
					1 Gram,
					100 Milliliter,
					100 Milliliter,
					100 Milliliter,
					100 Milliliter
				},
				Name -> {
					"ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID,
					"ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID,
					"ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID,
					"ExperimentICPMS Test Solid Sample 1 with Sodium Chloride" <> $SessionUUID,
					"ExperimentICPMS Test Fake Standard object Na Al As Co" <> $SessionUUID,
					"ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID,
					"ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID,
					"ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID
				}

			];

			Upload[
				{
					Association[
						Object -> Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Liquid,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{1 Gram/Liter, Link[Model[Molecule, "Calcium Nitrate"]], Now},
							{1 Millimolar, Link[Model[Molecule, "Sodium Chloride"]], Now}
						},
						DeveloperObject -> True
					],
					Association[
						Object -> Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Liquid,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{1 Gram/Liter, Link[Model[Molecule, "Copper(II) Sulfate"]], Now}
						},
						DeveloperObject -> True
					],
					Association[
						Object -> Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Liquid,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{1 Gram/Liter, Link[Model[Molecule, "Iron"]], Now}
						},
						Aqueous -> True,
						Acid -> True,
						DeveloperObject -> True
					],
					Association[
						Object -> Object[Sample, "ExperimentICPMS Test Solid Sample 1 with Sodium Chloride" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Solid,
						Replace[Composition] -> {
							{Null, Link[Model[Molecule, "Sodium Chloride"]], Now}
						},
						DeveloperObject -> True
					](*,
					Association[
						Object -> Object[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Liquid,
						DeveloperObject -> True
					],
					Association[
						Object -> Object[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Liquid,
						DeveloperObject -> True
					],
					Association[
						Object -> Object[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID],
						Type -> Object[Sample],
						State -> Liquid,
						DeveloperObject -> True
					]*)
				}
			]
		]
	),
	SymbolTearDown :> Module[{objects, existsFilter},
		(* list of test objects *)
		objects = {
			Object[Sample, "ExperimentICPMS Test Sample 1 with Calcium Nitrate and Sodium Chloride" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Test Sample 2 with Copper (II) Sulfate" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Test Sample 3 with Iron" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Test Solid Sample 1 with Sodium Chloride" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Test Fake Standard object Na Al As Co" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
			Object[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (I)" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (II)" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (III)" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (IV)" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container for 15 ml sample (V)" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 1" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 2" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container Fake Standard 3" <> $SessionUUID],
			Object[Container, Vessel, "ExperimentICPMS Test Container Fake stan-dard" <> $SessionUUID],
			Model[Sample, "ExperimentICPMS Fake standard 1 Np to Cm" <> $SessionUUID],
			Model[Sample, "ExperimentICPMS Fake stan-dard Na Al As Co" <> $SessionUUID],
			Model[Sample, "ExperimentICPMS Fake standard 2 Bk to Fm" <> $SessionUUID],
			Model[Sample, "ExperimentICPMS Fake standard 3 Md to Lr" <> $SessionUUID],
			Object[Container, Bench, "Test Bench for ExperimentICPMS"<>$SessionUUID]
		};

		(* Check whether the names we want to give below already exist in the database *)
		existsFilter = DatabaseMemberQ[objects];

		(* Erase any objects that we failed to erase in the last unit test. *)
		Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
	]
];

(* ::Subsection::Closed:: *)
(*ICPMSDefaultIsotopes*)

DefineTests[ICPMSDefaultIsotopes,
	{
		Example[
			{Basic, "Given a list of element symbols, this function will output a list of corresponding isotopes that are supported by ICPMS:"},
			ICPMSDefaultIsotopes[{Calcium, Iron, Magnesium}],
			{"40Ca", "56Fe", "24Mg"}
		],
		Example[
			{Basic, "This function can be applied on a single input:"},
			ICPMSDefaultIsotopes[Calcium],
			{"40Ca"}
		],
		Example[
			{Basic, "If there are multiple isotopes above 20% natural abundance, all of them will appear in the output:"},
			ICPMSDefaultIsotopes[{Calcium, Copper}],
			{"40Ca", "63Cu", "65Cu"}
		],
		Example[
			{Options, "User can set the IsotopeAbundanceThreshold, in which case isotopes below that threshold will not be selected:"},
			ICPMSDefaultIsotopes[{Calcium, Copper}, IsotopeAbundanceThreshold -> 0.5],
			{"40Ca", "63Cu"}
		],
		Example[
			{Options, "If Flatten is set to False, isotopes from the same element will be grouped together:"},
			ICPMSDefaultIsotopes[{Calcium, Copper}, Flatten -> False],
			{{"40Ca"}, {"63Cu", "65Cu"}}
		],
		Example[
			{Options, "If Flatten is set to False, isotopes from the same element will be grouped together:"},
			ICPMSDefaultIsotopes[{Calcium, Copper}, Flatten -> False],
			{{"40Ca"}, {"63Cu", "65Cu"}}
		],
		Example[
			{Options, "If Instrument option is specified, only isotopes supported by the instrument will be selected:"},
			ICPMSDefaultIsotopes[{Iron}, Instrument -> Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID], IsotopeAbundanceThreshold -> 0],
			{"56Fe"}
		],
		Example[
			{Options, "If Message is set to False, all messages will be suppressed but instead, all variables triggering messages will be included in the output:"},
			ICPMSDefaultIsotopes[
				{Sodium, Brass, Molybdenum, Aluminum},
				Instrument -> Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID],
				IsotopeAbundanceThreshold -> 0.4,
				Message -> False
			],
			{{"23Na", "98Mo"}, {"98Mo"}, {Brass}, {Aluminum}}
		],
		Example[
			{Messages, "BelowThresholdIsotopesIncluded", "If most abundant isotope of one element is below user-specified IsotopeAbundanceThreshold, it will still be included in output and a warning will be thrown:"},
			ICPMSDefaultIsotopes[{Molybdenum},  IsotopeAbundanceThreshold -> 0.3],
			{"98Mo"},
			Messages :> {ICPMSDefaultIsotopes::BelowThresholdIsotopesIncluded}
		],
		Example[
			{Messages, "InvalidElement", "If any input is not an element, it will be ignored and a message will be thrown:"},
			ICPMSDefaultIsotopes[{Iron, Brass}],
			{"56Fe"},
			Messages :> {ICPMSDefaultIsotopes::InvalidElement}
		],
		Example[
			{Messages, "UnsupportedElement", "If any input is not supported by the specified instrument, it will be ignored and a message will be thrown:"},
			ICPMSDefaultIsotopes[{Copper, Titanium}, Instrument -> Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID]],
			{},
			Messages :> {ICPMSDefaultIsotopes::UnsupportedElement}
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[]
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		If[DatabaseMemberQ[Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID]],
			EraseObject[Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID], Force -> True]
		];
		Upload[<|
			Type -> Model[Instrument, MassSpectrometer],
			Name -> "fake ICPMS instrument for unit test"<>$SessionUUID,
			Replace[SupportedElements] -> {Sodium, Calcium, Iron, Molybdenum},
			Replace[SupportedIsotopes] -> {"23Na", "40Ca", "56Fe", "98Mo"},
			DeveloperObject -> True
		|>]),
	SymbolTearDown :> If[DatabaseMemberQ[Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID]],
		EraseObject[Model[Instrument, MassSpectrometer, "fake ICPMS instrument for unit test"<>$SessionUUID], Force -> True]
	]
];