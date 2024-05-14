(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*CriticalMicelleConcentration: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*AnalyzeCriticalMicelleConcentration*)

DefineTests[AnalyzeCriticalMicelleConcentration,
	{
		Example[{Basic, "Given an Object[Protocol,MeasureSurfaceTension], AnalyzeCriticalMicelleConcentration returns an Analysis Object:"},
			analysis=AnalyzeCriticalMicelleConcentration[Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]];
			PlotCriticalMicelleConcentration[analysis],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given an Object[Data,SurfaceTension], AnalyzeCriticalMicelleConcentration returns an Analysis Object:"},
			AnalyzeCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"AnalyzeCriticalMicelleConcentration populates the PreMicellarFit, PostMicellarFit, CriticalMicelleConcentration, ApparentPartitioningCoefficient, SurfaceExcessConcentration, CrossSectionalArea, MaxSurfacePressure fields:"},
			AnalyzeCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]];
			First[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID][CriticalMicelleConcentrationAnalyses]][[{PreMicellarFit, PostMicellarFit, CriticalMicelleConcentration, ApparentPartitioningCoefficient, SurfaceExcessConcentration, CrossSectionalArea, MaxSurfacePressure}]],
			{
				LinkP[Object[Analysis, Fit]],
				LinkP[Object[Analysis, Fit]],
				GreaterP[0 Molar],
				GreaterP[0 /Molar],
				GreaterP[0 Mole/Meter^2],
				GreaterP[0 Meter^2],
				GreaterP[0 Milli Newton/Meter]
			},
			SetUp:>(
				$CreatedObjects = {};

			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"AnalyzeCriticalMicelleConcentration populates the TargetMolecules, Concentrations, SurfaceTensions, Temperatures, SurfacePressures fields:"},
			AnalyzeCriticalMicelleConcentration[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]];
			First[Object[Data, SurfaceTension,  "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID][CriticalMicelleConcentrationAnalyses]][[{TargetMolecules, Concentrations, SurfaceTensions, Temperatures, SurfacePressures}]],
			{
				{LinkP[Model[Molecule]]},
				{GreaterEqualP[0 Molar]..},
				{GreaterP[0 Milli Newton/Meter]..},
				{GreaterP[0 Celsius]..},
				{GreaterP[0 Milli Newton/Meter]..}
			},
			SetUp:>(
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Template, "Use options from previous CriticalMicelleConcentration analysis:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Template -> Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
				],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			SetUp:>(
				(*make an analysis object to test the template*)
				Module[{testanalyzeobject},
					testanalyzeobject=AnalyzeCriticalMicelleConcentration[
						Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]
					];
					Upload[<|Object -> testanalyzeobject, Name -> "test template" <> $SessionUUID|>]
				];
			)
		],
		Example[{Options,TargetMolecule, "Specify the molecule used to calculate concentration:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				TargetMolecules->{Model[Molecule, "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]},
				Output->Options];
			Lookup[options,TargetMolecules],
			{ObjectP[Model[Molecule, "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]]},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,TargetMolecules, "Resolve the molecule used to calculate concentration from the sample's composition:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,TargetMolecules],
			{ObjectP[Model[Molecule, "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]]},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,TargetMolecules, "Resolve the molecule used to calculate concentration from the sample's Analytes field:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with analyte" <> $SessionUUID],
				Output->Options];
			Lookup[options,TargetMolecules],
			{Model[Molecule, "id:vXl9j57PmP5D"]},
			SetUp:>(
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
			)
		],
		Example[{Options,TargetMolecules, "Add the concentrations of multiple target molecules:"},
			protocol=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with NACL" <> $SessionUUID],
				TargetMolecules->{Model[Molecule, "id:BYDOjvG676mq"],Model[Molecule, "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID]}
			];
			Download[protocol,Concentrations],
			{Quantity[4.9826756719692815`, "Millimolar"],
				Quantity[4.28515850246846`, "Millimolar"],
				Quantity[3.685263110257817`, "Millimolar"],
				Quantity[3.169371667580911`, "Millimolar"],
				Quantity[2.7256820570488203`, "Millimolar"],
				Quantity[2.344112164015359`, "Millimolar"],
				Quantity[2.0159580636313765`, "Millimolar"],
				Quantity[1.733743623148656`, "Millimolar"],
				Quantity[1.4910345556774547`, "Millimolar"],
				Quantity[2.988327701243484`, "Millimolar"],
				Quantity[1.1027924739440482`, "Millimolar"],
				Quantity[0.9484133406472847`, "Millimolar"],
				Quantity[0.815644989029073`, "Millimolar"],
				Quantity[0.7014603236423478`, "Millimolar"],
				Quantity[0.603264300603401`, "Millimolar"],
				Quantity[0.518811892484915`, "Millimolar"],
				Quantity[0.44618347778387274`, "Millimolar"],
				Quantity[0.3837219473395502`, "Millimolar"],
				Quantity[0.3300053592978606`, "Millimolar"],
				Quantity[0.28380592155787165`, "Millimolar"],
				Quantity[0.2440765927043335`, "Millimolar"],
				Quantity[0.20990815030170049`, "Millimolar"],
				Quantity[0.`, "Millimolar"]},
			SetUp:>(
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
			)
		],
		Example[{Messages,"InsuffientDataPoints","If there are not enough data points, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests insufficient data points" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InsuffientDataPoints,
				Error::InvalidInput
			},
			SetUp:>(
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
			)
		],
		Example[{Messages,"MissingTargetMolecules","If the sample has no Target molecule, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				TargetMolecules->{Model[Molecule, "id:wqW9BP7JmJe9"]}],
			$Failed,
			Messages:>{
				Error::MissingTargetMolecules,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
			)
		],
		Example[{Options,PreMicellarRange, "Resolve the Range used to calculate fit the data in the premicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,PreMicellarRange],
			Quantity[37.77, ("Millinewtons")/("Meters")] ;; Quantity[57.12, ("Millinewtons")/("Meters")],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PreMicellarRange, "Specify the Range used to calculate fit the data in the premicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarRange->Quantity[39, ("Millinewtons")/("Meters")] ;; Quantity[65, ("Millinewtons")/("Meters")],
				Output->Options];
			Lookup[options,PreMicellarRange],
			Quantity[39, ("Millinewtons")/("Meters")] ;; Quantity[65, ("Millinewtons")/("Meters")],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PostMicellarRange, "Specify the Range used to calculate fit the data in the postmicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarRange->Quantity[35, ("Millinewtons")/("Meters")] ;; Quantity[45, ("Millinewtons")/("Meters")],
				Output->Options];
			Lookup[options,PostMicellarRange],
			Quantity[35, ("Millinewtons")/("Meters")] ;; Quantity[45, ("Millinewtons")/("Meters")],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PostMicellarRange, "Resolve the Range used to calculate fit the data in the postmicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,PostMicellarRange],
			Quantity[33.9, ("Millinewtons")/("Meters")] ;; Quantity[37.77, ("Millinewtons")/("Meters")],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PreMicellarDomain, "Specify the Domain used to calculate fit the data in the premicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarDomain->0.1 Molar;;2 Milli Molar,
				Output->Options];
			Lookup[options,PreMicellarDomain],
			0.1 Molar;;2 Milli Molar,
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PostMicellarDomain, "Specify the Domain used to calculate fit the data in the postmicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarDomain->2Milli Molar;;5 Milli Molar,
				Output->Options];
			Lookup[options,PostMicellarDomain],
			2Milli Molar;;5 Milli Molar,
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PreMicellarDomain, "Specify the Domain used to calculate fit the data in the premicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarDomain->2Molar;;0.1 Milli Molar,
				Output->Options];
			Lookup[options,PreMicellarDomain],
			2Molar;;0.1 Milli Molar,
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PostMicellarDomain, "Specify the Domain used to calculate fit the data in the postmicellar region of the plot:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarDomain->5Milli Molar;;2 Milli Molar,
				Output->Options];
			Lookup[options,PostMicellarDomain],
			5Milli Molar;;2 Milli Molar,
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"UnresolvableTargetMolecules","If the sample has a composition of only Null, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null Composition" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::UnresolvableTargetMolecules,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
			)
		],
		Example[{Options,Exclude, "Specify samples to be excluded from the fit:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Exclude->{Object[Sample,"Test aliquotSample 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID]},
				Output->Options];
			Lookup[options,Exclude],
			{ObjectP[Object[Sample,"Test aliquotSample 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID]]},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ConflictingPreMicellarDomain","If PreMicellarDomain and PreMicellarRange are both set, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarDomain->0.1 Milli Molar;;2Milli Molar,
				PreMicellarRange->39 Milli Newton/Meter ;;70 Milli Newton/Meter
			],
			$Failed,
			Messages:>{
				Error::ConflictingPreMicellarDomain,
				Error::InvalidOption
			},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ConflictingPostMicellarDomain","If PreMicellarDomain and PreMicellarRange are both set, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarDomain->2 Milli Molar;;5Milli Molar,
				PostMicellarRange->0 Milli Newton/Meter ;;40 Milli Newton/Meter
			],
			$Failed,
			Messages:>{
				Error::ConflictingPostMicellarDomain,
				Error::InvalidOption
			},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"MissingPreMicellarDomain","If neither PreMicellarDomain and PreMicellarRange are set, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarRange->Null
			],
			$Failed,
			Messages:>{
				Error::MissingPreMicellarDomain,
				Error::InvalidOption
			},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"MissingPostMicellarDomain","If neither PreMicellarDomain and PreMicellarRange are set, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarRange->Null
			],
			$Failed,
			Messages:>{
				Error::MissingPostMicellarDomain,
				Error::InvalidOption
			},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"EmptyPreMicellarRegion","If there are no points in the EmptyPreMicellarRegion, throw a warning:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarRange->80Milli Newton/Meter;;90Milli Newton/Meter
			],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			Messages:>{
				Warning::EmptyPreMicellarRegion
			},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"EmptyPostMicellarRegion","If there are no points in the EmptyPreMicellarRegion, throw a warning:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarRange->20Milli Newton/Meter;;25Milli Newton/Meter
			],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			Messages:>{
				Warning::EmptyPostMicellarRegion
			},
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ConflictingPreMicellarDomainUnits","If a PreMicellarDomain is given and the sample's concentration cannot be converted to Molar, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID],
				PreMicellarDomain->0.1 Milli Molar;;2Milli Molar
			],
			$Failed,
			Messages:>{
				Warning::UnableToConvertConcentration,
				Error::ConflictingPreMicellarDomainUnits,
				Warning::EmptyPreMicellarRegion,
				Error::InvalidOption
			},
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects];
			)
		],
		Example[{Messages,"ConflictingPostMicellarDomainUnits","If a PostMicellarDomain is given and the sample's concentration cannot be converted to Molar, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID],
				PostMicellarDomain->2 Milli Molar;;5Milli Molar
			],
			$Failed,
			Messages:>{
				Warning::UnableToConvertConcentration,
				Error::ConflictingPostMicellarDomainUnits,
				Warning::EmptyPostMicellarRegion,
				Error::InvalidOption
			},
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects];
			)
		],
		Example[{Messages,"UnableToConvertConcentration","If a PostMicellarDomain is given and the sample's concentration cannot be converted to Molar, throw an error:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID]
			],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			Messages:>{
				Warning::UnableToConvertConcentration
			},
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"MissingExcludedSamples","Give an error stating that the samples to be excluded from the fit are not present in the data:"},
		AnalyzeCriticalMicelleConcentration[
			Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
			Exclude->{Object[Sample, "id:aXRlnnnnLXBX"]}],
			$Failed,
		Messages:>{
			Error::MissingExcludedSamples,
			Error::InvalidOption
		},
		SetUp :> (
			$CreatedObjects = {}
		),
		TearDown :> (
			EraseObject[$CreatedObjects, Force -> True];
			Unset[$CreatedObjects]
		)
		],
		Example[{Additional,"Excepts a PreMicellarRange with a span that is not smallest to largest:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PreMicellarRange->70 Milli*Newton/Meter;;40 Milli*Newton/Meter],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Excepts a PostMicellarRange with a span that is not smallest to largest:"},
			AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				PostMicellarRange->40 Milli*Newton/Meter;;30 Milli*Newton/Meter],
			ObjectP[Object[Analysis, CriticalMicelleConcentration]],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ConflictingDiluents","Warn that the inputted data objects have different diluents:"},
			options=AnalyzeCriticalMicelleConcentration[
				{Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests conflicting diluent" <> $SessionUUID]},
				Output->Options];
			Lookup[options,DiluentSurfaceTension],
			72.8 Milli Newton / Meter,
			Messages:>{
				Warning::ConflictingDiluents
			},
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,DiluentSurfaceTension, "Specify the surface tension of the diluent used in the fit:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				DiluentSurfaceTension->72 Milli Newton/Meter,
				Output->Options];
			Lookup[options,DiluentSurfaceTension],
			72 Milli Newton/Meter,
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,DiluentSurfaceTension, "Resolve the surface tension of the diluent used in the fit to the surface tension of the diluent:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,DiluentSurfaceTension],
			72.8 Milli Newton/Meter,
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,DiluentSurfaceTension, "Resolve the surface tension of the diluent used in the fit to the surface tension of water:"},
			options=AnalyzeCriticalMicelleConcentration[
				Object[Data,SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests diluentNullST" <> $SessionUUID],
				Output->Options];
			Lookup[options,DiluentSurfaceTension],
			72.8 Milli Newton/Meter,
			SetUp :> (
				$CreatedObjects = {};
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects];
			)
		]
	},

SymbolSetUp :> {
	Module[{objs, existingObjs},
		objs = Quiet[Cases[
			Flatten[{
				(* Model Molecules *)
				Model[Molecule, "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Model[Molecule, "Test model molecule CTAB - Null MW - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],

				(* Containers *)
				Object[Container,Vessel,"Test diluent container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test calibrant container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test samplesIn container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test samplesInNullMW container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container with Analyte for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container with NACL for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test conflicting diluent container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test diluentNullST container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test nullCompositionSample container for analyzeCriticalMicelleConcentration" <> $SessionUUID],

				(* Samples *)
				Object[Sample,"Test diluent for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test calibrant for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test samplesIn for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test samplesInNullMW for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample with Analyte for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample with NACL for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test conflicting diluent for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test diluentNullST for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test nullCompositionSample for analyzeCriticalMicelleConcentration" <> $SessionUUID],

				(* Data *)
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW 2" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with NACL" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with analyte" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests insufficient data points" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests conflicting diluent" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests diluentNullST" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null Composition" <> $SessionUUID],

				(* Protocol & Analysis*)
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID],
				Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
			}],
			ObjectP[]
		]];
		existingObjs = PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False]
	];

	Module[
		{
			testMolecule, testMoleculeNullMW, containerNameList, containerPackets,allTestContainers,diluent,diluentNullST, conflictingDiluent,calibrant, samplesIn, samplesInNullMW,
			aliquotSample1, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
			aliquotSample8, aliquotSample9, aliquotSample10, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
			aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
			aliquotSample22, aliquotSample23, aliquotSampleNullMW1, aliquotSampleNullMW2, aliquotSampleNullMW3, aliquotSampleNullMW4, aliquotSampleNullMW5,
			aliquotSampleNullMW6, aliquotSampleNullMW7, aliquotSampleNullMW8, aliquotSampleNullMW9, aliquotSampleNullMW10, aliquotSampleNullMW11,
			aliquotSampleNullMW12, aliquotSampleNullMW13, aliquotSampleNullMW14, aliquotSampleNullMW15, aliquotSampleNullMW16, aliquotSampleNullMW17,
			aliquotSampleNullMW18, aliquotSampleNullMW19, aliquotSampleNullMW20, aliquotSampleNullMW21, aliquotSampleNullMW22,aliquotSampleNullMW23,
			nullCompositionSample,aliquotSampleWithNACL,aliquotSampleWithAnalyte,volumePercents, waterVolumePercents,massPercents,CTABMassPercents,CTABMassPercentsNullMW,
			compositions,compositionsNullMW,testDilutionFactors,testSurfaceTensions,testTemperatures,dataPackets, protocolObjectPackets
		},

		(* Make test CTAB molecules, one with no Molecular Weight *)
		testMolecule = Quiet[UploadMolecule[
			BiosafetyLevel -> "BSL-1",
			CAS -> "57-09-0",
			DOTHazardClass -> "Class 0",
			ExactMass -> Quantity[363.2500624387201`, ("Grams")/("Moles")],
			Fuming->True,
			Flammable->False,
			IUPAC -> "hexadecyl(trimethyl)azanium;bromide",
			InChI -> "InChI=1S/C19H42N.BrH/c1-5-6-7-8-9-10-11-12-13-14-15-16-17-18-19-20(2,3)4;/h5-19H2,1-4H3;1H/q+1;/p-1",
			InChIKey -> "LZZYPRNAOMGNLH-UHFFFAOYSA-M",
			IncompatibleMaterials -> {None},
			MSDSRequired-> False,
			MeltingPoint -> Quantity[240.`, "DegreesCelsius"],
			MolecularFormula -> "C19H42BrN",
			MolecularWeight -> Quantity[364.6, ("Grams")/("Moles")],
			Name -> "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID,
			ParticularlyHazardousSubstance -> False,
			Pyrophoric -> False,
			Radioactive -> False,
			State -> Solid,
			UNII -> "L64N7M9BWR",
			WaterReactive -> False
		],
			Warning::SimilarMolecules
		];

		testMoleculeNullMW = Quiet[UploadMolecule[
			BiosafetyLevel -> "BSL-1",
			CAS -> "57-09-0",
			DOTHazardClass -> "Class 0",
			ExactMass -> Quantity[363.2500624387201`, ("Grams")/("Moles")],
			Fuming->True,
			Flammable->False,
			IUPAC -> "hexadecyl(trimethyl)azanium;bromide",
			InChI -> "InChI=1S/C19H42N.BrH/c1-5-6-7-8-9-10-11-12-13-14-15-16-17-18-19-20(2,3)4;/h5-19H2,1-4H3;1H/q+1;/p-1",
			InChIKey -> "LZZYPRNAOMGNLH-UHFFFAOYSA-M",
			IncompatibleMaterials -> {None},
			MSDSRequired-> False,
			MeltingPoint -> Quantity[240.`, "DegreesCelsius"],
			MolecularFormula -> "C19H42BrN",
			MolecularWeight -> Null,
			Name -> "Test model molecule CTAB - Null MW - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID,
			ParticularlyHazardousSubstance -> False,
			Pyrophoric -> False,
			Radioactive -> False,
			State -> Solid,
			UNII -> "L64N7M9BWR",
			WaterReactive -> False
		],
			Warning::SimilarMolecules
		];

		(* Create test containers *)
		containerNameList = Flatten[
			{
				"Test diluent container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test diluentNullST container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test conflicting diluent container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test calibrant container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test samplesIn container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test samplesInNullMW container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				Table["Test aliquotSample container " <> ToString[i] <> " for analyzeCriticalMicelleConcentration" <> $SessionUUID,{i,1,23}],
				Table["Test aliquotSampleNullMW container " <> ToString[i] <> " for analyzeCriticalMicelleConcentration" <> $SessionUUID,{i,1,23}],
				"Test nullCompositionSample container for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test aliquotSample container with NACL for analyzeCriticalMicelleConcentration" <> $SessionUUID,
				"Test aliquotSample container with Analyte for analyzeCriticalMicelleConcentration" <> $SessionUUID
			}
		];

		containerPackets = Map[
			<|
			  Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],
				Name->#,
				DeveloperObject->True
			|>&,
			containerNameList
		];

		allTestContainers=Upload[containerPackets];


		(* Create the sample objects *)
		(* Thread the compositions together *)
		volumePercents = {99.8178, 99.8433, 99.8652, 99.8841, 99.9003, 99.9143, 99.9263, 99.9366, 99.9455, 99.9531, 99.9597, 99.9653, 99.9702, 99.9743, 99.9779, 99.981, 99.9837, 99.986, 99.9879, 99.9896, 99.9911, 99.9923} * VolumePercent;
		waterVolumePercents = ({#, Model[Molecule, "Water"]}) & /@ volumePercents;
		massPercents = {0.182215, 0.156707, 0.134769, 0.115903, 0.0996774, 0.0857235, 0.073723, 0.0634025, 0.0545267, 0.0468935, 0.0403288, 0.0346832, 0.0298279, 0.0256522, 0.0220612, 0.0189728, 0.0163168, 0.0140326, 0.0120682, 0.0103787, 0.00892581, 0.00767628} * MassPercent;
		CTABMassPercents = ({#, testMolecule}) & /@ massPercents;
		CTABMassPercentsNullMW = ({#, testMoleculeNullMW}) & /@ massPercents;
		compositions = Append[MapThread[{#1,#2}&,{waterVolumePercents,CTABMassPercents}],{{100 VolumePercent,Model[Molecule,"Water"]}}];
		compositionsNullMW = Append[MapThread[{#1,#2}&,{waterVolumePercents,CTABMassPercentsNullMW}],{{100 VolumePercent,Model[Molecule,"Water"]}}];

		(* Version with proper Model[Molecule] *)
		{
			diluent,
			diluentNullST,
			conflictingDiluent,
			calibrant,
			samplesIn,
			samplesInNullMW,
			aliquotSample1,
			aliquotSample2,
			aliquotSample3,
			aliquotSample4,
			aliquotSample5,
			aliquotSample6,
			aliquotSample7,
			aliquotSample8,
			aliquotSample9,
			aliquotSample10,
			aliquotSample11,
			aliquotSample12,
			aliquotSample13,
			aliquotSample14,
			aliquotSample15,
			aliquotSample16,
			aliquotSample17,
			aliquotSample18,
			aliquotSample19,
			aliquotSample20,
			aliquotSample21,
			aliquotSample22,
			aliquotSample23,
			aliquotSampleNullMW1,
			aliquotSampleNullMW2,
			aliquotSampleNullMW3,
			aliquotSampleNullMW4,
			aliquotSampleNullMW5,
			aliquotSampleNullMW6,
			aliquotSampleNullMW7,
			aliquotSampleNullMW8,
			aliquotSampleNullMW9,
			aliquotSampleNullMW10,
			aliquotSampleNullMW11,
			aliquotSampleNullMW12,
			aliquotSampleNullMW13,
			aliquotSampleNullMW14,
			aliquotSampleNullMW15,
			aliquotSampleNullMW16,
			aliquotSampleNullMW17,
			aliquotSampleNullMW18,
			aliquotSampleNullMW19,
			aliquotSampleNullMW20,
			aliquotSampleNullMW21,
			aliquotSampleNullMW22,
			aliquotSampleNullMW23,
			nullCompositionSample,
			aliquotSampleWithNACL,
			aliquotSampleWithAnalyte
		}=ECL`InternalUpload`UploadSample[
			Join[
				{{{100 VolumePercent, Model[Molecule, "Water"]}}},
				{{{100 VolumePercent, Model[Molecule, "Water"]}}},
				{{{100 VolumePercent, Model[Molecule, "Water"]}, {Null, Model[Molecule, "Sodium n-Dodecyl Sulfate"]}}},
				{{{100 VolumePercent, Model[Molecule, "Water"]}}},
				{{{99.8178 VolumePercent, Model[Molecule, "Water"]}, {0.182215 MassPercent, testMolecule}}},
				{{{99.8178 VolumePercent, Model[Molecule, "Water"]}, {0.182215 MassPercent, testMoleculeNullMW}}},
				compositions,
				compositionsNullMW,
				{{{100 VolumePercent, Model[Molecule, "Water"]}}},
				{{{99.9531 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]]}, {0.0468935 MassPercent, testMolecule}, {0.01 MassPercent, Link[Model[Molecule, "id:BYDOjvG676mq"]]}}},
				{{{99.8178 VolumePercent, Model[Molecule, "Water"]}, {0.182215 MassPercent, testMolecule}}}
			],
			{"A1",#}&/@allTestContainers,
			Name -> Join[
				{
					"Test diluent for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test diluentNullST for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test conflicting diluent for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test calibrant for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test samplesIn for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test samplesInNullMW for analyzeCriticalMicelleConcentration" <> $SessionUUID
				},
				Table["Test aliquotSample " <> ToString[i] <> " for analyzeCriticalMicelleConcentration" <> $SessionUUID,{i,1,23}],
				Table["Test aliquotSampleNullMW " <> ToString[i] <> " for analyzeCriticalMicelleConcentration" <> $SessionUUID,{i,1,23}],
				{
					"Test nullCompositionSample for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test aliquotSample with NACL for analyzeCriticalMicelleConcentration" <> $SessionUUID,
					"Test aliquotSample with Analyte for analyzeCriticalMicelleConcentration" <> $SessionUUID
				}
			]
		];

		(* Manually update needed changes to samples *)
		Upload[
			{
				<|Object->nullCompositionSample,Replace[Composition]->{{Null,Null}}|>,
				<|Object->diluentNullST,SurfaceTension->Null|>,
				<|Object->aliquotSampleWithAnalyte,Replace[Analytes]->Link[Model[Molecule, "id:vXl9j57PmP5D"]]|>
			}
		];

		(* Make all samples developer objects *)
		Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[{testMolecule,testMoleculeNullMW,{
			diluent,
			diluentNullST,
			conflictingDiluent,
			calibrant,
			samplesIn,
			samplesInNullMW,
			aliquotSample1,
			aliquotSample2,
			aliquotSample3,
			aliquotSample4,
			aliquotSample5,
			aliquotSample6,
			aliquotSample7,
			aliquotSample8,
			aliquotSample9,
			aliquotSample10,
			aliquotSample11,
			aliquotSample12,
			aliquotSample13,
			aliquotSample14,
			aliquotSample15,
			aliquotSample16,
			aliquotSample17,
			aliquotSample18,
			aliquotSample19,
			aliquotSample20,
			aliquotSample21,
			aliquotSample22,
			aliquotSample23,
			aliquotSampleNullMW1,
			aliquotSampleNullMW2,
			aliquotSampleNullMW3,
			aliquotSampleNullMW4,
			aliquotSampleNullMW5,
			aliquotSampleNullMW6,
			aliquotSampleNullMW7,
			aliquotSampleNullMW8,
			aliquotSampleNullMW9,
			aliquotSampleNullMW10,
			aliquotSampleNullMW11,
			aliquotSampleNullMW12,
			aliquotSampleNullMW13,
			aliquotSampleNullMW14,
			aliquotSampleNullMW15,
			aliquotSampleNullMW16,
			aliquotSampleNullMW17,
			aliquotSampleNullMW18,
			aliquotSampleNullMW19,
			aliquotSampleNullMW20,
			aliquotSampleNullMW21,
			aliquotSampleNullMW22,
			aliquotSampleNullMW23,
			nullCompositionSample
		}}]];

		(* Set the test data *)
		testDilutionFactors = {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594, 0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078, 0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587, 0.048985, 0.0421276, 0.};
		testSurfaceTensions = {34.8, 34.6, 35.1, 35.1, 34.9, 34.5, 34.3, 33.9, 34.4, 34.9, 40.7, 46.3, 49.3, 54.1, 58.3, 63.3, 67.2, 68.9, 69.9, 71.1, 71.4, 69.4, 72.6} * (Millinewton/Meter);
		testTemperatures = {27.3, 27.2, 27.2, 27.1, 27.1, 27.1, 27.1, 27.1, 27.1, 27.1, 27., 27.3, 27.2, 27.2, 27.1, 27.1, 27.1, 27.1, 27.1, 27.1, 27.1, 27., 27.1} * Celsius;

		(* Make test data packets *)
		dataPackets={
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{
					aliquotSample1, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
					aliquotSample8, aliquotSample9, aliquotSample10, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
					aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
					aliquotSample22,aliquotSample23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{
					aliquotSample1, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
					aliquotSample8, aliquotSample9, aliquotSample10, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
					aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
					aliquotSample22,aliquotSample23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesInNullMW, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{aliquotSampleNullMW1, aliquotSampleNullMW2, aliquotSampleNullMW3, aliquotSampleNullMW4, aliquotSampleNullMW5,
					aliquotSampleNullMW6, aliquotSampleNullMW7, aliquotSampleNullMW8, aliquotSampleNullMW9, aliquotSampleNullMW10, aliquotSampleNullMW11,
					aliquotSampleNullMW12, aliquotSampleNullMW13, aliquotSampleNullMW14, aliquotSampleNullMW15, aliquotSampleNullMW16, aliquotSampleNullMW17,
					aliquotSampleNullMW18, aliquotSampleNullMW19, aliquotSampleNullMW20, aliquotSampleNullMW21, aliquotSampleNullMW22, aliquotSampleNullMW23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW 2" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesInNullMW, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{aliquotSampleNullMW1, aliquotSampleNullMW2, aliquotSampleNullMW3, aliquotSampleNullMW4, aliquotSampleNullMW5,
					aliquotSampleNullMW6, aliquotSampleNullMW7, aliquotSampleNullMW8, aliquotSampleNullMW9, aliquotSampleNullMW10, aliquotSampleNullMW11,
					aliquotSampleNullMW12, aliquotSampleNullMW13, aliquotSampleNullMW14, aliquotSampleNullMW15, aliquotSampleNullMW16, aliquotSampleNullMW17,
					aliquotSampleNullMW18, aliquotSampleNullMW19, aliquotSampleNullMW20, aliquotSampleNullMW21, aliquotSampleNullMW22, aliquotSampleNullMW23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null Composition" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> ConstantArray[Link[nullCompositionSample,Data],23],
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests diluentNullST" <> $SessionUUID,
				Replace[Diluent] -> Link[diluentNullST],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{
					aliquotSample1, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
					aliquotSample8, aliquotSample9, aliquotSample10, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
					aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
					aliquotSample22,aliquotSampleNullMW23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests conflicting diluent" <> $SessionUUID,
				Replace[Diluent] -> Link[conflictingDiluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{
					aliquotSample1, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
					aliquotSample8, aliquotSample9, aliquotSample10, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
					aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
					aliquotSample22,aliquotSampleNullMW23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests insufficient data points" <> $SessionUUID,
				Replace[Diluent] -> Link[conflictingDiluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> {Link[aliquotSample1,Data]},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> {testSurfaceTensions[[1]]},
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with analyte" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{
					aliquotSampleWithAnalyte, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
					aliquotSample8, aliquotSample9, aliquotSample10, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
					aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
					aliquotSample22,aliquotSampleNullMW23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>,
			<|
				Type -> Object[Data, SurfaceTension],
				Name -> "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with NACL" <> $SessionUUID,
				Replace[Diluent] -> Link[diluent],
				Replace[SamplesIn] -> {Link[samplesIn, Data]},
				Replace[AliquotSamples] -> (Link[#,Data]&)/@{
					aliquotSample1, aliquotSample2,aliquotSample3, aliquotSample4, aliquotSample5, aliquotSample6, aliquotSample7,
					aliquotSample8, aliquotSample9, aliquotSampleWithNACL, aliquotSample11, aliquotSample12, aliquotSample13, aliquotSample14,
					aliquotSample15, aliquotSample16, aliquotSample17, aliquotSample18, aliquotSample19, aliquotSample20, aliquotSample21,
					aliquotSample22,aliquotSampleNullMW23},
				Replace[DilutionFactors] -> testDilutionFactors,
				Replace[SurfaceTensions] -> testSurfaceTensions,
				Replace[Temperatures] -> testTemperatures
			|>
		};

		Upload[dataPackets];

		(*Make a test protocol object*)
		protocolObjectPackets = {
			Association[
				Type -> Object[Protocol, MeasureSurfaceTension],
				Name -> "Test protocol object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID,
				(*add the data*)
				Replace[Data] -> {Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID], Protocol],
					Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2" <> $SessionUUID], Protocol]},
				Replace[Calibrant] -> {Link[calibrant]},
				DateCompleted -> Now
			],
			Association[
				Type -> Object[Protocol, MeasureSurfaceTension],
				Name -> "Test protocol object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID,
				(*add the data*)
				Replace[Data] -> {Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID], Protocol],
					Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW 2" <> $SessionUUID], Protocol]},
				Replace[Calibrant] -> {Link[calibrant]},
				DateCompleted -> Now
			]
		};

		Upload[protocolObjectPackets];
	];

},

SymbolTearDown:> {
	Module[{allObjects, existingObjects},

		(* Make a list of all of the fake objects we uploaded for these tests *)
		allObjects = Quiet[Cases[
			Flatten[{
				(* Model Molecules *)
				Model[Molecule, "Test model molecule CTAB - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Model[Molecule, "Test model molecule CTAB - Null MW - for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],

				(* Containers *)
				Object[Container,Vessel,"Test diluent container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test calibrant container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test samplesIn container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test samplesInNullMW container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container with Analyte for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container with NACL for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test conflicting diluent container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test diluentNullST container for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSample container 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test aliquotSampleNullMW container 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Container,Vessel,"Test nullCompositionSample container for analyzeCriticalMicelleConcentration" <> $SessionUUID],

				(* Samples *)
				Object[Sample,"Test diluent for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test calibrant for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test samplesIn for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test samplesInNullMW for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample with Analyte for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample with NACL for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test conflicting diluent for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test diluentNullST for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSample 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 1 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 2 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 3 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 4 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 5 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 6 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 7 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 8 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 9 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 10 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 11 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 12 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 13 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 14 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 15 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 16 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 17 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 18 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 19 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 20 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 21 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 22 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test aliquotSampleNullMW 23 for analyzeCriticalMicelleConcentration" <> $SessionUUID],
				Object[Sample,"Test nullCompositionSample for analyzeCriticalMicelleConcentration" <> $SessionUUID],

				(* Data *)
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests 2" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null MW 2" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with NACL" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests, aliquot sample with analyte" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests insufficient data points" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests conflicting diluent" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests diluentNullST" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for analyzeCriticalMicelleConcentration tests Null Composition" <> $SessionUUID],

				(* Protocol & Analysis*)
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests" <> $SessionUUID],
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for analyzeCriticalMicelleConcentration tests Null MW" <> $SessionUUID],
				Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
			}],
			ObjectP[]
		]];

		(*Check whether the created objects and models exist in the database*)
		existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

		(*Erase all the created objects and models*)
		Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

	];
}
];

(* ::Subsubsection:: *)
(*AnalyzeCriticalMicelleConcentrationOptions*)

DefineTests[AnalyzeCriticalMicelleConcentrationOptions,
	{
		Example[{Basic,"Display the option values which will be used in the analysis:"},
			AnalyzeCriticalMicelleConcentrationOptions[Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID]],
			_Grid,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			AnalyzeCriticalMicelleConcentrationOptions[
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID],
				Exclude->{Object[Sample, "id:aXRlnnnnLXBX"]}],
			_Grid,
			Messages:>{
				Error::MissingExcludedSamples,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			AnalyzeCriticalMicelleConcentrationOptions[Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	},

	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests 2" <> $SessionUUID],
					Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Module[{dataPackets, protocolObjectPacket},

			(*Make test data packets.*)
			dataPackets = {
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				],
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests 2" <> $SessionUUID,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				]
			};

			Upload[dataPackets];

			(*Make a test protocol object*)
			protocolObjectPacket = Association[
				Type -> Object[Protocol, MeasureSurfaceTension],
				Name -> "Test protocol object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID,
				(*add the data*)
				Replace[Data] -> {Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID], Protocol],
					Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests 2" <> $SessionUUID], Protocol]},
				Replace[Calibrant] -> {Link[Object[Sample, "id:O81aEBZenRO3"]]},
				DateCompleted -> Now
			];

			Upload[protocolObjectPacket];
		];

	},

	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects = {
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationOptions tests 2" <> $SessionUUID],
				Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		];
	}
];

(* ::Subsubsection:: *)
(*AnalyzeCriticalMicelleConcentrationPreview*)

DefineTests[AnalyzeCriticalMicelleConcentrationPreview,
	{
		Example[{Basic,"Given an input protocol, AnalyzeTotalProteinQuantificationPreview outputs a TabView showing the Surface Tension Curve and fitting parameters:"},
			AnalyzeCriticalMicelleConcentrationPreview[Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID]],
			_TabView,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"If you wish to understand how the Analysis will be performed, try using AnalyzeCriticalMicelleConcentrationOptions:"},
			AnalyzeCriticalMicelleConcentrationOptions[Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID]],
			_Grid,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidAnalyzeCriticalMicelleConcentrationQ:"},
			ValidAnalyzeCriticalMicelleConcentrationQ[Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID]],
			True,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	},

	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests 2" <> $SessionUUID],
					Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Module[{dataPackets, protocolObjectPacket},

			(*Make test data packets.*)
			dataPackets = {
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				],
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests 2" <> $SessionUUID,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				]
			};

			Upload[dataPackets];

			(*Make a test protocol object*)
			protocolObjectPacket = Association[
				Type -> Object[Protocol, MeasureSurfaceTension],
				Name -> "Test protocol object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID,
				(*add the data*)
				Replace[Data] -> {Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID], Protocol],
					Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests 2" <> $SessionUUID], Protocol]},
				Replace[Calibrant] -> {Link[Object[Sample, "id:O81aEBZenRO3"]]},
				DateCompleted -> Now
			];

			Upload[protocolObjectPacket];
		];

	},

	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects = {
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for AnalyzeCriticalMicelleConcentrationPreview tests 2" <> $SessionUUID],
				Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		];
	}
];

(* ::Subsubsection:: *)
(*ValidAnalyzeCriticalMicelleConcentrationQ*)
DefineTests[ValidAnalyzeCriticalMicelleConcentrationQ,
	{
		Example[{Options, OutputFormat, "Change output format to TestSummary:"},
			ValidAnalyzeCriticalMicelleConcentrationQ[Object[Protocol, MeasureSurfaceTension, "Test protocol object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidAnalyzeCriticalMicelleConcentrationQ, outputting false:"},
			ValidAnalyzeCriticalMicelleConcentrationQ[
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID],
				PostMicellarDomain->2 Milli Molar;;5Milli Molar,
				PostMicellarRange->0 Milli Newton/Meter ;;40 Milli Newton/Meter
			],
			False,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidAnalyzeCriticalMicelleConcentrationQ, outputting true:"},
			ValidAnalyzeCriticalMicelleConcentrationQ[Object[Protocol, MeasureSurfaceTension, "Test protocol object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID]],
			True,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	},

	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Protocol, MeasureSurfaceTension, "Test protocol object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID],
					Object[Data, SurfaceTension, "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests 2" <> $SessionUUID],
					Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Module[{dataPackets, protocolObjectPacket},

			(*Make test data packets.*)
			dataPackets = {
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				],
				Association[
					Type -> Object[Data, SurfaceTension],
					Name -> "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests 2" <> $SessionUUID,
					Replace[Diluent] -> Link[Object[Sample, "id:O81aEBZenRO3"]],
					Replace[SamplesIn] -> {Link[Object[Sample, "id:pZx9jo8wPM9p"], Data]},
					Replace[AliquotSamples] -> {Link[Object[Sample, "id:7X104vnGrXww"], Data], Link[Object[Sample, "id:O81aEBZeb8M1"], Data], Link[
						Object[Sample, "id:GmzlKjPrbmMN"], Data], Link[Object[Sample, "id:AEqRl9Km8EMd"], Data], Link[Object[Sample, "id:o1k9jAGvm1BE"], Data], Link[
						Object[Sample, "id:zGj91a7nKGpx"], Data], Link[Object[Sample, "id:lYq9jRxwvYB4"], Data], Link[Object[Sample, "id:L8kPEjn1b8M6"], Data], Link[
						Object[Sample, "id:E8zoYvNrb8Mb"], Data], Link[Object[Sample, "id:Y0lXejMoL0Bo"], Data], Link[Object[Sample, "id:kEJ9mqRxbEBL"], Data], Link[
						Object[Sample, "id:P5ZnEjdpb5ME"], Data], Link[Object[Sample, "id:3em6ZvLX8ePM"], Data], Link[Object[Sample, "id:D8KAEvGmw8ML"], Data], Link[
						Object[Sample, "id:aXRlGn6YLXBX"], Data], Link[Object[Sample, "id:wqW9BP7NKqZO"], Data], Link[Object[Sample, "id:J8AY5jDnb8MB"], Data], Link[
						Object[Sample, "id:8qZ1VW0A9qJn"], Data], Link[Object[Sample, "id:rea9jlRwKeB3"], Data], Link[Object[Sample, "id:bq9LA0JW5qML"], Data], Link[
						Object[Sample, "id:KBL5Dvw0xBMv"], Data], Link[Object[Sample, "id:jLq9jXvwbL5R"], Data], Link[Object[Sample, "id:eGakldJ65GBo"], Data]},
					Replace[DilutionFactors] -> {1., 0.860009, 0.739616, 0.636077, 0.547032, 0.470453, 0.404594,
						0.347954, 0.299244, 0.257353, 0.221326, 0.190342, 0.163696, 0.14078,
						0.121072, 0.104123, 0.0895469, 0.0770112, 0.0662303, 0.0569587,
						0.048985, 0.0421276, 0.},
					Replace[SurfaceTensions] -> {Quantity[34.8, ("Millinewtons") / ("Meters")],
						Quantity[34.6, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[35.1, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[34.5, ("Millinewtons") / ("Meters")],
						Quantity[34.3, ("Millinewtons") / ("Meters")],
						Quantity[33.9, ("Millinewtons") / ("Meters")],
						Quantity[34.4, ("Millinewtons") / ("Meters")],
						Quantity[34.9, ("Millinewtons") / ("Meters")],
						Quantity[40.7, ("Millinewtons") / ("Meters")],
						Quantity[46.3, ("Millinewtons") / ("Meters")],
						Quantity[49.3, ("Millinewtons") / ("Meters")],
						Quantity[54.1, ("Millinewtons") / ("Meters")],
						Quantity[58.3, ("Millinewtons") / ("Meters")],
						Quantity[63.3, ("Millinewtons") / ("Meters")],
						Quantity[67.2, ("Millinewtons") / ("Meters")],
						Quantity[68.9, ("Millinewtons") / ("Meters")],
						Quantity[69.9, ("Millinewtons") / ("Meters")],
						Quantity[71.1, ("Millinewtons") / ("Meters")],
						Quantity[71.4, ("Millinewtons") / ("Meters")],
						Quantity[69.4, ("Millinewtons") / ("Meters")],
						Quantity[72.6, ("Millinewtons") / ("Meters")]},
					Replace[Temperatures] ->{Quantity[27.3, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27., "DegreesCelsius"], Quantity[27.3, "DegreesCelsius"],
						Quantity[27.2, "DegreesCelsius"], Quantity[27.2, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27.1, "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"], Quantity[27., "DegreesCelsius"],
						Quantity[27.1, "DegreesCelsius"]}
				]
			};

			Upload[dataPackets];

			(*Make a test protocol object*)
			protocolObjectPacket = Association[
				Type -> Object[Protocol, MeasureSurfaceTension],
				Name -> "Test protocol object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID,
				(*add the data*)
				Replace[Data] -> {Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID], Protocol],
					Link[Object[Data, SurfaceTension, "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests 2" <> $SessionUUID], Protocol]},
				Replace[Calibrant] -> {Link[Object[Sample, "id:O81aEBZenRO3"]]},
				DateCompleted -> Now
			];

			Upload[protocolObjectPacket];
		];

	},

	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects = {
				Object[Protocol, MeasureSurfaceTension, "Test protocol object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests" <> $SessionUUID],
				Object[Data, SurfaceTension, "Test serial dilution sample data object for ValidAnalyzeCriticalMicelleConcentrationQ tests 2" <> $SessionUUID],
				Object[Analysis,CriticalMicelleConcentration,"test template" <> $SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		];
	}
];

(* ::Section:: *)
(*End Test Package*)
