(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*AnalyzeComposition: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeComposition*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeComposition*)


DefineTests[AnalyzeComposition,
	{
		(* --------------------- BASIC --------------------*)
		Example[{Basic, "Given an HPLC protocol containing Standards with known concentrations of analytes, and SamplesIn containing unknown assays, compute the concentration of analytes in each assay sample:"},
			AnalyzeComposition[myHPLCProtocol],
			ObjectP[Object[Analysis,Composition]],
			TimeConstraint->5000
		],
		Test["Composition works on protocol with multiple analytes:",
			AnalyzeComposition[multiAnalyteHPLCProtocol],
			ObjectP[Object[Analysis,Composition]],
			TimeConstraint->5000
		],
		Example[{Basic, "Concentrations are calculated by fitting, for each analyte, a standard curve mapping analyte peak area to analyte concentration in input protocol Standards. Both standards and assays must have their HPLC data peak-picked. Analytes are considered to be the set of all Model[Molecule] objects assigned to peaks in the StandardData objects:"},
			PlotChromatography[
				Download[myHPLCProtocol, {Data[[1]], StandardData[[1]]}],
				Legend -> {"Assay", "Standard"},
				PlotLabel -> ""
			],
			ValidGraphicsP[],
			TimeConstraint->5000
		],
		Example[{Basic, "The concentrations of standards and assays are stored in the StandardCompositions and AssayCompositions fields of the resulting analysis object:"},
			AnalyzeCompositionPreview[myHPLCProtocol],
			_TabView,
			TimeConstraint->5000
		],
		Test["The concentrations of standards and assays are stored in the StandardCompositions and AssayCompositions fields of the resulting analysis object:",
			Download[AnalyzeComposition[multiAnalyteHPLCProtocol],{StandardCompositions[[1]],AssayCompositions[[;;5]]}],
			{
				{
					Quantity[0.12274999263500046, "Millimolar"],
					Quantity[0.5292300364507186, "Millimolar"],
					Quantity[0.2522475254517753, "Millimolar"],
					Quantity[0.14191805084072254, "Millimolar"]
				},
				{{Quantity[89.33113144171759, "Millimolar"]},
				{Quantity[81.92933468674973, "Millimolar"], "Not found", Quantity[6.917231033553602, "Millimolar"]},
				{Quantity[33.31249824442517, "Millimolar"], "Not found"}, {Quantity[34.59077496269007, "Millimolar"], "Not found"},
				{Quantity[66.75930913907457, "Millimolar"], "Not found"}}
			},
			Stubs:>{
				AnalyzeComposition[multiAnalyteHPLCProtocol]=First@AnalyzeComposition[Object[Protocol,HPLC,"id:qdkmxzq09ARa"],Upload->False]
			},
			EquivalenceFunction->RoundMatchQ[4],
			TimeConstraint->5000
		],
		Example[{Options,StandardData,"StandardData defaults to using the StandardData field in the input protocol:"},
			Lookup[
				AnalyzeCompositionOptions[multiAnalyteHPLCProtocol,
					StandardData->Automatic,
					OutputFormat->List
				],
				StandardData
			],
			{ObjectP[Object[Data,Chromatography]]..},
			TimeConstraint->5000
		],
		Example[{Options,StandardData,"Explicitly specify the Object[Data] measurements to use as standards for the composition analysis:"},
			AnalyzeComposition[multiAnalyteHPLCProtocol,
				StandardData->{
					Object[Data,Chromatography,"id:bq9LA0JJnBAd"],
					Object[Data,Chromatography,"id:01G6nvwwMKn1"],
					Object[Data,Chromatography,"id:dORYzZJJ10zE"],
					Object[Data,Chromatography,"id:E8zoYvNNARaN"],
					Object[Data,Chromatography,"id:N80DNj11eYaW"],
					Object[Data,Chromatography,"id:eGakldJJj1Px"],
					Object[Data,Chromatography,"id:Y0lXejMMnKal"],
					Object[Data,Chromatography,"id:vXl9j577JEVN"],
					Object[Data,Chromatography,"id:pZx9jo88YG1p"],
					Object[Data,Chromatography,"id:XnlV5jKK1bnN"],
					Object[Data,Chromatography,"id:D8KAEvGGNq8O"],
					Object[Data,Chromatography,"id:mnk9jORRlqnN"],
					Object[Data,Chromatography,"id:qdkmxzqqvAp1"]
				}
			],
			ObjectP[Object[Analysis,Composition]],
			TimeConstraint->5000
		],
		Example[{Options,StandardConcentrations,"StandardConcentrations will default to concentrations computed from the Composition field(s) of the objects in the Standard field of input protocol. Empty entries {} indicate no analytes could be assigned to picked-peaks in StandardData:"},
			Lookup[
				AnalyzeCompositionOptions[myHPLCProtocol,
					StandardConcentrations->Automatic,
					OutputFormat->List
				],
				StandardConcentrations
			],
			(*{
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}},
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}},
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}},
				{},
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}},
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}},
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}},
				{{Model[Molecule,"Cetylpyridinium Chloride"],5 MassPercent}}
			}*)
			{
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}},
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}},
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}},
				{},
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}},
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}},
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}},
				{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116, "Millimolar"]}}
			},
			TimeConstraint->5000
		],
		Example[{Options,StandardConcentrations,"Explicitly specify the concentrations of analyte for each Standard object in the protocol with arbitrary concentration units, using a list of {analyte,concentration} pairs for each Standard:"},
			AnalyzeCompositionPreview[myHPLCProtocol,
				StandardConcentrations->{
					{{Model[Molecule,"Cetylpyridinium Chloride"],3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"],3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"],3.0 PPM}},
					{},
					{{Model[Molecule,"Cetylpyridinium Chloride"],2.8 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"],2.8 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"],2.8 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"],2.8 PPM}}
				}
			],
			_TabView,
			TimeConstraint->5000
		],
		Example[{Options,ExcludeStandard,"Provide the indices of the standards that should be excluded from the analysis:"},
			AnalyzeComposition[multiAnalyteHPLCProtocol, ExcludeStandard->{11,12,13}],
			ObjectP[Object[Analysis,Composition]],
			TimeConstraint->5000
		],
		Example[{Options,PreferredConcentrationType,"AnalyzeComposition will attempt to convert concentrations to MolarConcentration by default:"},
			Download[AnalyzeComposition[multiAnalyteHPLCProtocol],StandardCompositions[[1]]],
			{
				Quantity[0.12274999263500047`,"Millimolar"],
				Quantity[0.5292300364507186`, "Millimolar"],
				Quantity[0.2522475254517753`, "Millimolar"],
				Quantity[0.14191805084072254`, "Millimolar"]
			},
			TimeConstraint->5000,
			Stubs:>{
				AnalyzeComposition[multiAnalyteHPLCProtocol]=First@AnalyzeComposition[Object[Protocol,HPLC,"id:qdkmxzq09ARa"],Upload->False]
			}
		],
		Example[{Options,PreferredConcentrationType,"Attempt to convert concentrations to mass concentrations. If not enough information (molecular weights, densities, sample volumes) is available from the analyte models, concentrations will remain in their original units:"},
			Download[AnalyzeComposition[multiAnalyteHPLCProtocol,PreferredConcentrationType->MassConcentration],StandardCompositions[[1]]],
			{
				Quantity[0.12274999263500047`, "Millimolar"],
				Quantity[0.5292300364507186`, "Millimolar"],
				Quantity[0.2522475254517753`, "Millimolar"],
				Quantity[0.14191805084072254`, "Millimolar"]
			},
			TimeConstraint->5000,
			Stubs:>{
				AnalyzeComposition[multiAnalyteHPLCProtocol,PreferredConcentrationType->MassConcentration]=First@AnalyzeComposition[Object[Protocol,HPLC,"id:qdkmxzq09ARa"],PreferredConcentrationType->MassConcentration,Upload->False]
			}
		],
		Example[{Options,UpdateSampleComposition,"Indicate whether the Composition fields of objects in the StandardsIn field of the input protocol should be updated with the results of this analysis:"},
			AnalyzeComposition[myHPLCProtocol,UpdateSampleComposition->False],
			ObjectP[Object[Analysis,Composition]],
			TimeConstraint->5000
		],
		Test["Composition update packets are valid uploads:",
			ValidUploadQ[AnalyzeComposition[myHPLCProtocol,UpdateSampleComposition->False,Upload->False]],
			True,
			TimeConstraint->5000
		],
		Test["Composition update packets are only generated if UpdateSampleComposition->True:",
			{
				Length@AnalyzeComposition[myHPLCProtocol,UpdateSampleComposition->False,Upload->False],
				Length@AnalyzeComposition[myHPLCProtocol,UpdateSampleComposition->True,Upload->False]
			},
			{2,18},
			TimeConstraint->5000
		],
		Example[{Options,Name,"Name to be used as the name of Object[Analysis, Composition] generated by the analysis:"},
			AnalyzeComposition[myHPLCProtocol,Name->"My Composition Analysis from "<>DateString[Now]],
			ObjectP[Object[Analysis,Composition]],
			TimeConstraint->5000
		],
		Test["Name option is incorporated into the final analysis upload packet:",
			Lookup[First@AnalyzeComposition[myHPLCProtocol,Name->"TestName",Upload->False],Name],
			"TestName"
		],

		Example[{Messages,"NoStandardsFound", "Protocols which are either missing standards or have not had their StandardData peak-picked will return an error:"},
			AnalyzeComposition[protocolMissingStandards],
			$Failed,
			Messages:>{
				Error::NoStandardsFound,
				Error::InvalidInput
			},
			TimeConstraint->5000
		],
		Example[{Messages,"NoStandardsForSamples", "Return a $Failed state if analytes of the SamplesIn of the input protocol cannot be matched to the composition of any included Standards:"},
			AnalyzeComposition[myHPLCProtocol,ExcludeStandard->Range[8]],
			$Failed,
			Messages:>{
				Error::NoStandardsForSamples,
				Error::InvalidInput
			},
			TimeConstraint->5000
		],
		Example[{Messages,"InvalidExcludeStandardsOption","Return a $Failed state if the ExcludeStandard option specifies indices which exceed the number of standards in the input protocol:"},
			AnalyzeComposition[myHPLCProtocol, ExcludeStandard->{4,9001}],
			$Failed,
			Messages:>{
				Error::InvalidExcludeStandardsOption,
				Error::InvalidOption
			},
			TimeConstraint->5000
		],
		Example[{Messages,"InvalidStandardsNoPeaks","Warning shows if any of the Standards do not have analytes assigned to their peaks in StandardData. Set ExcludeStandard->Automatic to exclude these standards automatically:"},
			AnalyzeComposition[myHPLCProtocol, ExcludeStandard->{}],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::InvalidStandardsNoPeaks},
			TimeConstraint->5000
		],
		Example[{Messages,"NoAnalytesFoundInStandards","Warning shows if for at least one analyte, there are no standards with a non-zero concentration of that analyte. This handles the case where all standards have a zero concentration of a given analyte:"},
			AnalyzeComposition[myHPLCProtocol, ExcludeStandard->{}],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::InvalidStandardsNoPeaks},
			TimeConstraint->5000
		],
		Example[{Messages,"InvalidStandardDataLength","If the length of the StandardData option does not match the length of the Standard field of the input protocol, a warning is displayed and the option will be ignored:"},
			AnalyzeComposition[myHPLCProtocol,
				StandardData->{
					Object[Data,Chromatography,"id:wqW9BP7zBl6w"],
					Object[Data,Chromatography,"id:rea9jlR5jO6O"]
				}
			],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::InvalidStandardDataLength},
			TimeConstraint->5000
		],
		Example[{Messages,"InvalidStandardDataReferences","If the data objects in the StandardData option do not point to the same data objects as the Standards field of the input protocol, a warning is displayed and the option will be ignored:"},
			AnalyzeComposition[myHPLCProtocol,
				StandardData->{
					Object[Data,Chromatography,"id:wqW9BP7zBl6w"],
					Object[Data,Chromatography,"id:rea9jlR5jO6O"],
					Object[Data,Chromatography,"id:n0k9mG89kWxp"],
					Object[Data,Chromatography,"id:01G6nvw6GxV4"],
					Object[Data,Chromatography,"id:M8n3rx0PrO5l"],
					Object[Data,Chromatography,"id:n0k9mG8OmVak"],
					Object[Data,Chromatography,"id:Z1lqpMzrpae5"],
					Object[Data,Chromatography,"id:pZx9jo8OjqJP"]
				}
			],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::InvalidStandardDataReferences},
			TimeConstraint->5000
		],
		Example[{Messages,"AnalytesNotFound","Show a warning if any of the analyte concentrations specified in StandardConcentrations cannot be matched to picked peaks:"},
			AnalyzeComposition[myHPLCProtocol,
				StandardConcentrations->{
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM},{Model[Molecule,"Glycine"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Benzene"], 3.0 PPM},{Model[Molecule,"Glycine"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}}
				}
			],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::AnalytesNotFound},
			TimeConstraint->5000
		],
		Example[{Messages,"InvalidStandardConcentrationLength","If the length of the StandardConcentrations option does not match the length of the Standard field of the input protocol, a warning is displayed and the option will be ignored:"},
			AnalyzeComposition[myHPLCProtocol,
				StandardConcentrations->{
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}}
				}
			],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::InvalidStandardConcentrationLength},
			TimeConstraint->5000
		],
		Example[{Messages,"StandardConcentrationIncompatibleUnits","All concentrations specified in StandardConcentrations must be given in compatible units:"},
			AnalyzeComposition[myHPLCProtocol,
				StandardConcentrations->{
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 Foot}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 Joule}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}}
				}
			],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::StandardConcentrationIncompatibleUnits},
			TimeConstraint->5000
		],
		Example[{Messages,"InvalidCompositionUpdate","Composition updating is only supported when standard concentrations are given in units that are compatible with supported units in CompositionP:"},
			AnalyzeComposition[myHPLCProtocol,
				StandardConcentrations->{
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}}
				},
				UpdateSampleComposition->True
			],
			ObjectP[Object[Analysis,Composition]],
			Messages:>{Warning::InvalidCompositionUpdate},
			TimeConstraint->5000
		],
		Test["Composition update packets are not generated if concentrations are set in units incompatible with CompositionP:",
			Length@AnalyzeComposition[myHPLCProtocol,
				StandardConcentrations->{
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}},
					{{Model[Molecule,"Cetylpyridinium Chloride"], 3.0 PPM}}
				},
				UpdateSampleComposition->True,
				Upload->False
			],
			2,
			Messages:>{Warning::InvalidCompositionUpdate},
			TimeConstraint->5000
		]
	},
	SymbolSetUp:>{
		ClearMemoization[];
		$CreatedObjects={};
	},
	SymbolTearDown:>{
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	},
	Variables:>{myHPLCProtocol,multiAnalyteHPLCProtocol,protocolMissingStandards},
	SetUp:>(
		myHPLCProtocol=Object[Protocol,HPLC,"id:rea9jlR5W0OO"];
		multiAnalyteHPLCProtocol=Object[Protocol,HPLC,"id:qdkmxzq09ARa"];
		protocolMissingStandards=Object[Protocol,HPLC,"id:xRO9n3BErnB7"];
	),
	Stubs:>{
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*AnalyzeCompositionOptions*)


(* Define Tests *)
DefineTests[AnalyzeCompositionOptions,
	{
		Example[{Basic, "Return the resolved options for a Composition analysis:"},
			AnalyzeCompositionOptions[myHPLCProtocol],
			_Grid
		],
		Example[{Basic, "Explicitly specified options will appear in the output:"},
			AnalyzeCompositionOptions[multiAnalyteHPLCProtocol, ExcludeStandard->{9,10,11,12,13}],
			_Grid
		],
		Example[{Options, OutputFormat, "By default, AnalyzeCompositionOptions returns a table:"},
			AnalyzeCompositionOptions[myHPLCProtocol],
			_Grid
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			AnalyzeCompositionOptions[myHPLCProtocol,OutputFormat->List],
			{
				PreferredConcentrationType -> MolarConcentration,
				StandardData -> {Object[Data, Chromatography, "id:wqW9BP7zBl6w"],
					Object[Data, Chromatography, "id:rea9jlR5jO6O"],
					Object[Data, Chromatography, "id:N80DNj1vNGVo"],
					Object[Data, Chromatography, "id:6V0npvmqpw18"],
					Object[Data, Chromatography, "id:M8n3rx0PrO5l"],
					Object[Data, Chromatography, "id:n0k9mG8OmVak"],
					Object[Data, Chromatography, "id:Z1lqpMzrpae5"],
					Object[Data, Chromatography, "id:pZx9jo8OjqJP"]},
				StandardConcentrations -> {{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}},
					{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}},
					{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}}, {},
					{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}},
					{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}},
					{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}},
					{{Model[Molecule, "Cetylpyridinium Chloride"], Quantity[1.3588555024824116`, "Millimolar"]}}},
				ExcludeStandard -> {4}, Name -> Null,
				UpdateSampleComposition -> False, Upload -> True}
		]
	},

	(* Setup and teardown actions for unit testing *)
	Stubs:>{
		(* Assign a test user to all created objects *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		ClearMemoization[];
	},
	Variables:>{myHPLCProtocol,multiAnalyteHPLCProtocol,protocolMissingStandards},
	SetUp:>(
		myHPLCProtocol=Object[Protocol,HPLC,"id:rea9jlR5W0OO"];
		multiAnalyteHPLCProtocol=Object[Protocol,HPLC,"id:qdkmxzq09ARa"];
		protocolMissingStandards=Object[Protocol,HPLC,"id:xRO9n3BErnB7"];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeCompositionPreview*)


(* Define Tests *)
DefineTests[AnalyzeCompositionPreview,
	{
		Example[{Basic, "Generate a preview for the Composition Analysis:"},
			AnalyzeCompositionPreview[myHPLCProtocol],
			_TabView
		],
		Example[{Basic, "Generate a preview for a Composition Analysis with multiple analytes being detected:"},
			AnalyzeCompositionPreview[multiAnalyteHPLCProtocol],
			_TabView
		],
		Example[{Basic, "Returns Null if errors in the corresponding AnalyzeComposition[] call prevent the preview from being generated:"},
			AnalyzeCompositionPreview[protocolMissingStandards],
			Null,
			Messages:>{Error::NoStandardsFound,Error::InvalidInput}
		]
	},

	(* Setup and teardown actions for unit testing *)
	Stubs:>{
		(* Assign a test user to all created objects *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		ClearMemoization[];
	},
	Variables:>{myHPLCProtocol,multiAnalyteHPLCProtocol,protocolMissingStandards},
	SetUp:>(
		myHPLCProtocol=Object[Protocol,HPLC,"id:rea9jlR5W0OO"];
		multiAnalyteHPLCProtocol=Object[Protocol,HPLC,"id:qdkmxzq09ARa"];
		protocolMissingStandards=Object[Protocol,HPLC,"id:xRO9n3BErnB7"];
	)
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeCompositionQ*)


(* Define Tests *)
DefineTests[ValidAnalyzeCompositionQ,
	{
		Example[{Basic, "Validate input for a composition analysis:"},
			ValidAnalyzeCompositionQ[myHPLCProtocol],
			True
		],
		Example[{Basic,"ValidAnalyzeCompositionQ returns False if an invalid option is passed:"},
			ValidAnalyzeCompositionQ[myHPLCProtocol,ExcludeStandard->"Taco"],
			False
		],
		Example[{Options, OutputFormat, "By default, ValidAnalyzeCompositionQ returns a boolean:"},
			ValidAnalyzeCompositionQ[multiAnalyteHPLCProtocol,OutputFormat->Boolean],
			True
		],
		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			ValidAnalyzeCompositionQ[multiAnalyteHPLCProtocol,OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose output indicating test passage/failure for each test:"},
			ValidAnalyzeCompositionQ[myHPLCProtocol,Verbose->True],
			True
		],
		Example[{Options, Verbose, "Print verbose messages for failures only:"},
			ValidAnalyzeCompositionQ[myHPLCProtocol,ExcludeStandard->"Taco",Verbose->Failures],
			False
		]
	},

	(* Setup and teardown actions for unit testing *)
	Stubs:>{
		(* Assign a test user to all created objects *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		ClearMemoization[];
	},
	Variables:>{myHPLCProtocol,multiAnalyteHPLCProtocol},
	SetUp:>(
		myHPLCProtocol=Object[Protocol,HPLC,"id:rea9jlR5W0OO"];
		multiAnalyteHPLCProtocol=Object[Protocol,HPLC,"id:qdkmxzq09ARa"];
	)
];


(* ::Section:: *)
(*End Test Package*)
