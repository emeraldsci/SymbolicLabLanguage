(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)

(* ::Title:: *)
(* ExperimentWashCellsOptions: Tests *)
DefineTests[
	ExperimentWashCellsOptions,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentWashCells call to wash a cell sample with media:"},
			ExperimentWashCellsOptions[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCellsOptions) " <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentWashCells call to wash a container with a cell sample with media:"},
			ExperimentWashCellsOptions[Object[Container, Plate, "Test mammalian plate 0 (for ExperimentWashCellsOptions)" <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentWashCells call to wash multiple cell samples at the same time:"},
			ExperimentWashCellsOptions[{
				Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCellsOptions) " <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCellsOptions) " <> $SessionUUID]
			}],
			_Grid
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Generate a resolved list of options for an ExperimentWashCells call to wash a cell sample with media:"},
			ExperimentWashCellsOptions[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCellsOptions) " <> $SessionUUID], OutputFormat -> List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentWashCells, #], $Failed, {Error::Pattern}],
				{(_Rule | _RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp :> SetUpWashCellsChangeMediaTest[ExperimentWashCellsOptions],

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		TearDownWashCellsChangeMediaTest[ExperimentWashCellsOptions]
	)
];

(* ::Title:: *)
(* ValidExperimentWashCellsQ *)
DefineTests[
	ValidExperimentWashCellsQ,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Validate an ExperimentWashCells call to wash the cells in a single sample:"},
			ValidExperimentWashCellsQ[Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentWashCellsQ) " <> $SessionUUID]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentWashCells call to wash the cells in multiple samples:"},
			ValidExperimentWashCellsQ[{
				Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentWashCellsQ) " <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentWashCellsQ) " <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic, "Validate an ExperimentWashCells call to wash the cells in a single container:"},
			ValidExperimentWashCellsQ[Object[Container, Plate, "Test mammalian plate 0 (for ValidExperimentWashCellsQ)" <> $SessionUUID]],
			True
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Validate an ExperimentWashCells call to wash the cells in a sample, returning an ECL Test Summary:"},
			ValidExperimentWashCellsQ[Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentWashCellsQ) " <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentWashCells call to wash the cells in a sample, printing a verbose summary of tests as they are run:"},
			ValidExperimentWashCellsQ[Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentWashCellsQ) " <> $SessionUUID], Verbose -> True],
			True
		]
	},
	SymbolSetUp :> SetUpWashCellsChangeMediaTest[ValidExperimentWashCellsQ],

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		TearDownWashCellsChangeMediaTest[ValidExperimentWashCellsQ]
	)
];

(* ::Title:: *)
(* ExperimentWashCellsPreview *)
DefineTests[
	ExperimentWashCellsPreview,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a preview for an ExperimentWashCells call to wash the cells in a single sample (will always be Null):"},
			ExperimentWashCellsPreview[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCellsPreview) " <> $SessionUUID]],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentWashCells call to wash the cells in a multiple samples:"},
			ExperimentWashCellsPreview[{
				Object[Sample, "Adherent mammalian cell sample (Test for ExperimentWashCellsPreview) " <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample (Test for ExperimentWashCellsPreview) " <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentWashCells call to wash the cells in a single container:"},
			ExperimentWashCellsPreview[Object[Container, Plate, "Test mammalian plate 0 (for ExperimentWashCellsPreview)" <> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp :> SetUpWashCellsChangeMediaTest[ExperimentWashCellsPreview],

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		TearDownWashCellsChangeMediaTest[ExperimentWashCellsPreview]
	)
];

(* ::Title:: *)
(* ExperimentChangeMediaOptions: Tests *)
DefineTests[
	ExperimentChangeMediaOptions,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentChangeMedia call to wash a cell sample with media:"},
			ExperimentChangeMediaOptions[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentChangeMediaOptions) " <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentChangeMedia call to wash a container with a cell sample with media:"},
			ExperimentChangeMediaOptions[Object[Container, Plate, "Test mammalian plate 0 (for ExperimentChangeMediaOptions)" <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentChangeMedia call to wash multiple cell samples at the same time:"},
			ExperimentChangeMediaOptions[{
				Object[Sample, "Adherent mammalian cell sample (Test for ExperimentChangeMediaOptions) " <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample (Test for ExperimentChangeMediaOptions) " <> $SessionUUID]
			}],
			_Grid
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Generate a resolved list of options for an ExperimentChangeMedia call to wash a cell sample with media:"},
			ExperimentChangeMediaOptions[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentChangeMediaOptions) " <> $SessionUUID], OutputFormat -> List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentChangeMedia, #], $Failed, {Error::Pattern}],
				{(_Rule | _RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp :> SetUpWashCellsChangeMediaTest[ExperimentChangeMediaOptions],

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		TearDownWashCellsChangeMediaTest[ExperimentChangeMediaOptions]
	)
];

(* ::Title:: *)
(* ValidExperimentChangeMediaQ *)
DefineTests[
	ValidExperimentChangeMediaQ,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Validate an ExperimentChangeMedia call to wash the cells in a single sample:"},
			ValidExperimentChangeMediaQ[Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentChangeMediaQ) " <> $SessionUUID]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentChangeMedia call to wash the cells in multiple samples:"},
			ValidExperimentChangeMediaQ[{
				Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentChangeMediaQ) " <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample (Test for ValidExperimentChangeMediaQ) " <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic, "Validate an ExperimentChangeMedia call to wash the cells in a single container:"},
			ValidExperimentChangeMediaQ[Object[Container, Plate, "Test mammalian plate 0 (for ValidExperimentChangeMediaQ)" <> $SessionUUID]],
			True
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Validate an ExperimentChangeMedia call to wash the cells in a sample, returning an ECL Test Summary:"},
			ValidExperimentChangeMediaQ[Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentChangeMediaQ) " <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentChangeMedia call to wash the cells in a sample, printing a verbose summary of tests as they are run:"},
			ValidExperimentChangeMediaQ[Object[Sample, "Adherent mammalian cell sample (Test for ValidExperimentChangeMediaQ) " <> $SessionUUID], Verbose -> True],
			True
		]
	},
	SymbolSetUp :> SetUpWashCellsChangeMediaTest[ValidExperimentChangeMediaQ],

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		TearDownWashCellsChangeMediaTest[ValidExperimentChangeMediaQ]
	)
];

(* ::Title:: *)
(* ExperimentChangeMediaPreview *)
DefineTests[
	ExperimentChangeMediaPreview,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a preview for an ExperimentChangeMedia call to wash the cells in a single sample (will always be Null):"},
			ExperimentChangeMediaPreview[Object[Sample, "Adherent mammalian cell sample (Test for ExperimentChangeMediaPreview) " <> $SessionUUID]],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentChangeMedia call to wash the cells in a multiple samples:"},
			ExperimentChangeMediaPreview[{
				Object[Sample, "Adherent mammalian cell sample (Test for ExperimentChangeMediaPreview) " <> $SessionUUID],
				Object[Sample, "Suspension mammalian cell sample (Test for ExperimentChangeMediaPreview) " <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentChangeMedia call to wash the cells in a single container:"},
			ExperimentChangeMediaPreview[Object[Container, Plate, "Test mammalian plate 0 (for ExperimentChangeMediaPreview)" <> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp :> SetUpWashCellsChangeMediaTest[ExperimentChangeMediaPreview],

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		TearDownWashCellsChangeMediaTest[ExperimentChangeMediaPreview]
	)
];