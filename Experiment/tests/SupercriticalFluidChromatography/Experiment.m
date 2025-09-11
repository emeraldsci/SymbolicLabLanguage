(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentSupercriticalFluidChromatography: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentSupercriticalFluidChromatography*)


(* ::Subsubsection:: *)
(*ExperimentSupercriticalFluidChromatography*)

DefineTests[ExperimentSupercriticalFluidChromatography,
  {

    Example[
      {Basic,"Automatically resolve of all options for a set of samples:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        OutputFormat->List
      ];
      Lookup[options,Instrument],
      ObjectP[Model[Instrument, SupercriticalFluidChromatography, "Waters UPC2 PDA QDa"]],
      Variables:>{options}
    ],
    Example[
      {Basic,"Automatically resolve of all options for samples with a defined InjectionTable:"},

      customInjectionTable={
        {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
      };
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionTable->customInjectionTable,
        OutputFormat->List
      ];
      Lookup[options,Instrument],
      ObjectP[Model[Instrument, SupercriticalFluidChromatography, "Waters UPC2 PDA QDa"]],
      Variables:>{customInjectionTable,options}
    ],

    (*resolution tests*)

    Example[{Additional,"Automatically assumes a Standard sample if any of the standard options were specified:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        StandardAbsorbanceWavelength->450*Nanometer,
        OutputFormat->List
      ];
      Lookup[options,Standard],
      ListableP[ObjectP[]],
      Variables :> {options}
    ],
    Example[{Additional,"Automatically assumes a Blank sample if any of the blank options were specified:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        BlankAbsorbanceSamplingRate->40*1/Second,
        OutputFormat->List
      ];
      Lookup[options,Blank],
      ListableP[ObjectP[]],
      Variables :> {options}
    ],
    Example[{Additional,"Resolve a complex array of Standard and Blank options:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        Standard -> {Automatic, Automatic, Automatic},
        Blank -> {Automatic, Model[Sample, "Methanol - LCMS grade"]},
        StandardFrequency -> Automatic,
        BlankFrequency -> Automatic,
        OutputFormat->List
      ];
      Lookup[options,Blank],
      ListableP[ObjectP[]],
      Variables :> {options}
    ],
    Example[{Additional,"Be able to measure a sample with no model informed:"},
      ExperimentSupercriticalFluidChromatography[
        Object[Sample, "ExperimentSFC Test Sample 4" <> $SessionUUID]
      ],
      ObjectP[Object[Protocol,SupercriticalFluidChromatography]]
    ],
    Example[{Additional,"Specify many options simultaneously (similar to qualification procedures):"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CosolventA->Model[Sample, "Methanol - LCMS grade"],
        CosolventB->Model[Sample, "Methanol - LCMS grade"],
        CosolventC->Model[Sample, "Methanol - LCMS grade"],
        CosolventD->Model[Sample, "Methanol - LCMS grade"],
        Gradient->ConstantArray[Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID],3],
        ColumnPrimeGradient->Object[Method, SupercriticalFluidGradient, "ExperimentSupercriticalFluidChromatography System Prime Gradient"],
        ColumnFlushGradient->Object[Method, SupercriticalFluidGradient, "ExperimentSupercriticalFluidChromatography System Prime Gradient"],
        ColumnSelector -> {Model[Item, Column, "Torus 2-PIC Column"]},
        AbsorbanceWavelength->273 Nanometer,
        InjectionVolume -> 2 Microliter
      ],
      ObjectP[Object[Protocol,SupercriticalFluidChromatography]],
      Variables :> {protocol},
      Messages:>{Warning::CosolventConflict}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentSupercriticalFluidChromatography[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentSupercriticalFluidChromatography[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentSupercriticalFluidChromatography[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentSupercriticalFluidChromatography[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
	(*injection Table must match the order and repetition of the input samples*)
	Example[{Messages,"InjectionTableForeignSamples","Return an error when the injection table is specified but has a different order and repetition to that of the input samples:"},
		  customInjectionTable={
        {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
		    (*removed sample 1 here*)
        {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
      };

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionTable->customInjectionTable,
        OutputFormat->List
      ];

      Lookup[options,Standard],
      ObjectP[],
      Messages:>{
        Error::InjectionTableForeignSamples,
	      Error::InvalidOption
      },
      Variables :> {options,customInjectionTable}
  ],

	(*injection Table standard conflict checks*)
	Example[{Messages,"InjectionTableStandardFrequencyConflict","Return an error when the injection table is specified and conflicts with a specified StandardFrequency:"},
		customInjectionTable={
        {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
      };

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionTable->customInjectionTable,
		    StandardFrequency->FirstAndLast,
        OutputFormat->List
      ];

      Lookup[options,StandardFrequency],
      FirstAndLast,
      Messages:>{
        Error::InjectionTableStandardFrequencyConflict,
	      Error::InvalidOption
      },
      Variables :> {options,customInjectionTable}
    ],

	(*injection Table standard conflict checks*)
	Example[{Messages,"InjectionTableStandardConflict","Return an error when the injection table is specified and conflicts with a specified Standard:"},
		customInjectionTable={
        {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
      };

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionTable->customInjectionTable,
		Standard->Model[Sample,"Milli-Q water"],
        OutputFormat->List
      ];

      Lookup[options,Standard],
      ObjectP[],
      Messages:>{
        Error::InjectionTableStandardConflict,
        Error::InvalidOption
      },
      Variables :> {options,customInjectionTable}
    ],


	(*injection Table blank conflict checks*)
	Example[{Messages,"InjectionTableBlankFrequencyConflict","Return an error when the injection table is specified and conflicts with a specified BlankFrequency:"},
		customInjectionTable={
      {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
    };

    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      InjectionTable->customInjectionTable,
      BlankFrequency->First,
      OutputFormat->List
    ];

    Lookup[options,BlankFrequency],
    First,
    Messages:>{
      Error::InjectionTableBlankFrequencyConflict,
      Error::InvalidOption
    },
    Variables :> {options,customInjectionTable}
  ],
	Example[{Messages,"InjectionTableBlankConflict","Return an error when the injection table is specified and conflicts with a specified Blank:"},
    customInjectionTable={
      {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
    };

    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      InjectionTable->customInjectionTable,
      Blank->Model[Sample,"Acetonitrile, LCMS grade"],
      OutputFormat->List
    ];

    Lookup[options,Blank],
    ObjectP[],
    Messages:>{
      Error::InjectionTableBlankConflict,
      Error::InvalidOption
    },
    Variables :> {options,customInjectionTable}
  ],

	(*column resolution and error checking*)
	 Example[{Additional,"Automatically resolves to the appropriate column based on the SeparationMode:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        SeparationMode->Chiral,
        OutputFormat->List
      ];
      Lookup[options,Column],
      ListableP[ObjectP[Model[Item, Column, "id:4pO6dM5kPeoX"]]], (*Lux 5 Angstrom Amylose*)
      Variables :> {options}
    ],

	Example[{Messages,"InjectionTableColumnConflictSFC","Return an error when the injection table is specified and conflicts with a specified Column:"},
		customInjectionTable={
      {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
    };

    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      InjectionTable->customInjectionTable,
      StandardColumn->Model[Item, Column, "Lux 5 Angstrom Amylose"],
      OutputFormat->List
    ];

    Lookup[options,Column],
    ObjectP[],
    Messages:>{
      Error::InjectionTableColumnConflictSFC,
      Error::InvalidOption
    },
    Variables :> {customInjectionTable,options}
  ],

	Example[{Messages,"ColumnSelectorConflict","Return an error when the injection table is specified and conflicts with a specified Column:"},

    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      ColumnSelector->{Model[Item, Column, "Torus 2-PIC Column"]},
      Column->Model[Item, Column, "Viridis BEH Column, 5 um 4.6 x 50 mm"],
      OutputFormat->List
    ];

    Lookup[options,Column],
    ObjectP[],
    Messages:>{
      Error::ColumnSelectorConflict,
      Error::InvalidOption
    },
    Variables :> {options}
  ],

	Example[{Messages,"SelectorInjectionTableConflict","Return an error when the injection table is specified and conflicts with the ColumnSelector:"},
		customInjectionTable={
      {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
    };

    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      InjectionTable->customInjectionTable,
  ColumnSelector->{Model[Item, Column, "Lux 5 Angstrom Amylose"]},
      OutputFormat->List
    ];

    Lookup[options,Column],
    ObjectP[],
    Messages:>{
      Error::SelectorInjectionTableConflict,
      Error::InvalidOption
    },
    Variables :> {customInjectionTable,options}
  ],

	Example[{Messages,"CosolventConflict","Surface warning when the cosolvent within a gradient method differs from the resolved one:"},

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Gradient->Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID],
        CosolventB->Model[Sample, "id:Z1lqpMGjeev0"],
        OutputFormat->List
      ];

      Lookup[options,Column],
      ObjectP[],
      Messages:>{
        Warning::CosolventConflict
      },
      Variables :> {options}
    ],

	Example[{Messages,"ScanTimeAdjusted","Surface warning a ScanTime is rounded:"},

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankScanTime->0.432 Second,
        OutputFormat->List
      ];

      Lookup[options,BlankScanTime],
      0.5 Second,
      Messages:>{
        Warning::ScanTimeAdjusted
      },
      Variables :> {options}
    ],

	(*errors from the absorbance detector resolution*)
	Example[{Messages,"WavelengthResolutionConflict","Return an error when the AbsorbanceWavelength is not a range (e.g. singleton value) and WavelengthResolution is specified to a value:"},

      ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeAbsorbanceWavelength->280*Nanometer,
        ColumnPrimeWavelengthResolution->1.2*Nanometer
      ],
      $Failed,
      Messages:>{
        Error::WavelengthResolutionConflict,
        Error::InvalidOption
      }
    ],

	Example[{Messages,"WavelengthResolutionAdjusted","Surface a warning when WavelengthResolution is rounded:"},

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardWavelengthResolution->8.432 Nanometer,
        OutputFormat->List
      ];

      Lookup[options,StandardWavelengthResolution],
      8.4*Nanometer,
      Messages:>{
        Warning::WavelengthResolutionAdjusted
      },
      Variables :> {options}
    ],
	Example[{Messages,"AbsorbanceRateAdjusted","Surface warning a AbsorbanceSamplingRate is rounded:"},

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushAbsorbanceSamplingRate->14 * 1/Second,
        OutputFormat->List
      ];

      Lookup[options,ColumnFlushAbsorbanceSamplingRate],
      10*1/Second,
      EquivalenceFunction -> Equal,
      Messages:>{
        Warning::AbsorbanceRateAdjusted
      },
      Variables :> {options}
    ],

    (*rounded option precision testing*)
    Example[{Messages,"GradientPercentPrecision","Return a warning when the percent in Gradient is specified to unfeasible precision:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        CO2Gradient->{{0 Minute, 90.83298872598973 Percent},{10 Minute, 70.83298872598973 Percent}},
        OutputFormat->List
      ];
      Lookup[options,CO2Gradient],
      {{0 Minute, 91 Percent},{10 Minute, 71 Percent}},
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Messages,"GradientTimePrecision","Return a warning when the time in Gradient is specified to unfeasible precision:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        StandardGradientA->{{0 Minute, 3 Percent},{9.289987288972727 Minute, 30 Percent}},
        OutputFormat->List
      ];
      Lookup[options,StandardGradientA],
      {{0 Minute, 3 Percent},{9.3 Minute, 30 Percent}},
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Messages,"FlowRatePrecision","Return a warning when the time in FlowRate is specified to unfeasible precision:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        BlankFlowRate->2.929045900953279047 Milliliter/Minute,
        OutputFormat->List
      ];
      Lookup[options,BlankFlowRate],
      2.9*Milliliter/Minute,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Messages,"BackPressurePrecision","Return a warning when the BackPressure is specified to unfeasible precision:"},

      customGradient={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 1987.8928972987620 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2200.629876207829 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        ColumnPrimeGradient->customGradient,
        OutputFormat->List
      ];
      Lookup[options,ColumnPrimeBackPressure][[1,2]],
      1988*PSI,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options,customGradient}
    ],
    Example[{Messages,"WavelengthResolutionAdjusted","Return a warning when the time in AbsorbanceResolution is specified to unfeasible precision and not a multiple of 1.2*Nanometer:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        WavelengthResolution->3.01 Nanometer,
        OutputFormat->List
      ];
      Lookup[options,WavelengthResolution],
      3.6 Nanometer,
      Messages:>{
        Warning::WavelengthResolutionAdjusted
      },
      Variables :> {options}
    ],

	(*all of the gradient resolution testing*)

	Example[
      {Additional,"Automatically resolve the gradient from the specification of GradientStart, GradientEnd, and GradientDuration:"},

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientStart->10*Percent,
        GradientEnd->25*Percent,
        GradientDuration->15*Minute,
        OutputFormat->List
      ];
      Lookup[options,CO2Gradient],
      {{0. Minute,90. Percent},{15 Minute,75. Percent}},
      Variables:>{options}
    ],

    Example[{Messages,"GradientStartEndConflict","If GradientStart is specified but GradientEnd is not, throw error:"},
      ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientStart->10*Percent
      ],
      $Failed,
      Messages:>{
        Error::InvalidOption,
        Error::GradientStartEndConflict
      }
    ],

	Example[{Messages,"InvalidGradientComposition","Return error when the defined gradient doesn't add up to 100%:"},

    customGradient={
      {0 Minute, 97 Percent, 6 Percent, 0 Percent, 0 Percent, 0 Percent, 1987 PSI, 3 Milliliter/Minute},
      {3 Minute, 90 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
      {3.1 Minute, 80 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
      {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
      {7 Minute, 90 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 2200 PSI, 3 Milliliter/Minute},
      {10 Minute, 60 Percent, 30 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
    };

    ExperimentSupercriticalFluidChromatography[
      Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
      ColumnFlushGradient->customGradient
    ],
    $Failed,
    Messages:>{
      Error::InvalidGradientComposition,
      Error::InvalidOption
    },
    Variables :> {customGradient}
  ],

  Example[{Messages,"NonbinaryGradientDefined","Return error when a non-binary gradient is defined (i.e. more than one of GradientA, B, C, or D):"},

    customGradient={
      {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 1987 PSI, 3 Milliliter/Minute},
      {3 Minute, 90 Percent, 5 Percent, 5 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
      {3.1 Minute, 80 Percent, 10 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
      {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
      {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2200 PSI, 3 Milliliter/Minute},
      {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
    };

    ExperimentSupercriticalFluidChromatography[
      Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
      ColumnFlushGradient->customGradient
    ],
    $Failed,
    Messages:>{
      Error::NonbinaryGradientDefined,
      Error::InvalidOption
    },
    Variables :> {customGradient}
  ],


	Example[{Messages,"InjectionTableGradientConflict","Return an error when the injection table gradient is specified and conflicts with the GradientOption:"},
		  customInjectionTable={
        {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
      };

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionTable->customInjectionTable,
		    ColumnFlushGradient->Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 2" <> $SessionUUID],
        OutputFormat->List
      ];

      Lookup[options,ColumnFlushGradient],
      ObjectP[],
      Messages:>{
        Error::InjectionTableGradientConflict,
		    Error::InvalidOption
      },
      Variables :> {customInjectionTable,options}
    ],

	Example[{Messages,"InjectionTableColumnGradientConflict","Return an error when the injection table gradients are different for the same column for different ColumnPrime or ColumnFlush entries:"},
		customInjectionTable={
      {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 2" <> $SessionUUID]},
      {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
    };

    ExperimentSupercriticalFluidChromatography[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      InjectionTable->customInjectionTable
    ],

    $Failed,
    Messages:>{
      Error::InjectionTableColumnGradientConflict,
      Error::InvalidOption
    },
    Variables :> {customInjectionTable}
  ],

    Example[{Messages,"GradientShortcutConflict","Shortcut Start/End options can not be used at the same time as the GradientA/B/C/D options when GradientDuration is specified:"},
      ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientStart -> 20 Percent,
        GradientEnd -> 50 Percent,
        GradientDuration -> 20 Minute,
        GradientA -> 50 Percent
      ],
      $Failed,
      Messages:>{
        Error::GradientShortcutConflict,
        Error::InvalidGradientComposition,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"GradientShortcutAmbiguity","If Shortcut Start/End options and GradientA/B/C/D options are specified but they conflict with each other, throw a warning and resolve the gradient based on the former set of options:"},
      (
        options = ExperimentSupercriticalFluidChromatography[
          Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
          GradientStart -> 20 Percent,
          GradientEnd -> 80 Percent,
          GradientA -> 10 Percent,
          Output -> Options
        ];
        Lookup[options,Gradient][[All,3]]
      ),
      {10Percent..},
      Messages:>{
        Warning::GradientShortcutAmbiguity,
        Error::NonbinaryGradientDefined,
        Error::InvalidOption
      },
      Variables :> {options}
    ],

    Example[{Messages,"SharedContainerStorageCondition","The specified SamplesInStorageCondition is fullfillable for samples sharing the same container:"},
      ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID]},
        SamplesInStorageCondition->{AmbientStorage,Refrigerator}
      ],
      $Failed,
      Messages:>{
        Error::SharedContainerStorageCondition,
        Error::InvalidOption
      }
    ],

  (*injection table resolution*)
  Example[
    {Additional,"A custom injection table can be partially resolved, and Automatic entries will be resolved:"},

    customInjectionTable={
      {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Automatic},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Automatic,Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Standard,Automatic,2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
      {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
    };

    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      InjectionTable->customInjectionTable,
      OutputFormat->List
    ];
    Flatten@Lookup[options,InjectionTable],
    {Except[Automatic]..},
    Variables:>{customInjectionTable,options}
  ],
  Example[
    {Additional,"Work with a non-standard sample container that we haven't considered:"},
    ExperimentSupercriticalFluidChromatography[
      Object[Sample,"ExperimentSFC Test Sample 5 (high recovery vial)" <> $SessionUUID]
    ],
    ObjectP[Object[Protocol,SupercriticalFluidChromatography]]
  ],

  (*Option testing*)

  Example[
    {Options,Instrument,"Specify the measurement and collection device on which the protocol is to be run:"},
    protocol=Quiet[ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      Instrument->Object[Instrument,SupercriticalFluidChromatography,"Harari"]
    ],{Warning::InstrumentUndergoingMaintenance}];
    Download[protocol,Instrument],
    ObjectP[Object[Instrument,SupercriticalFluidChromatography,"Harari"]],
    Variables:>{protocol}
  ],
  Example[
    {Options,Scale,"Specify if the experiment is intended purify or analyze material:"},
    options=ExperimentSupercriticalFluidChromatographyOptions[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      Scale->Analytical,
      OutputFormat -> List
    ];
    Lookup[options,Scale],
    Analytical,
    Variables:>{options}
  ],
  Example[
    {Options,SeparationMode,"Specify the category of separation to be used. This option is used to resolve the column, cosolvents, and column temperatures:"},
    protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      SeparationMode->NormalPhase
    ];
    Download[protocol,SeparationMode],
    NormalPhase,
    Variables:>{protocol}
  ],
  Example[
    {Options,Detector,"Specify the type measurement to employ for measuring the analyte properties:"},
    protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},Detector-> PhotoDiodeArray];
    Download[protocol,Detectors],
    {Temperature, Pressure, PhotoDiodeArray, MassSpectrometry},
    Variables:>{protocol}
  ],
  Example[
    {Options,Column,"Specify the stationary phase through which the CO2, Cosolvent, and input samples flow:"},
    protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      Column->{Model[Item, Column, "id:P5ZnEjdmGDoE"],Model[Item, Column, "id:rea9jlRbE5Vx"],Model[Item, Column, "id:P5ZnEjdmGDoE"]}
    ];
    Download[protocol,Columns],
    {ObjectP[Model[Item, Column, "id:P5ZnEjdmGDoE"]],ObjectP[Model[Item, Column, "id:rea9jlRbE5Vx"]],ObjectP[Model[Item, Column, "id:P5ZnEjdmGDoE"]]},
    Variables:>{protocol}
  ],
  Example[
    {Options,ColumnSelector,"Specify all the columns loaded into the Instrument's column selector and referenced in Column, StandardColumn, and BlankColumn options:"},
    protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      ColumnSelector->{Model[Item, Column, "id:P5ZnEjdmGDoE"],Model[Item, Column, "id:rea9jlRbE5Vx"]}
    ];
    Download[protocol,ColumnSelection],
    {ObjectP[Model[Item, Column, "id:P5ZnEjdmGDoE"]],ObjectP[Model[Item, Column, "id:rea9jlRbE5Vx"]]},
    Variables:>{protocol}
  ],
  Example[
    {Options,ColumnTemperature,"Specify the temperature of the Column throughout the measurement:"},
    protocol=ExperimentSupercriticalFluidChromatography[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
      ColumnTemperature->40*Celsius
    ];
    Download[protocol,ColumnTemperatures],
    {40.*Celsius,40.*Celsius,40.*Celsius},
    Variables:>{protocol}
  ],
  Example[
    {Options,ColumnOrientation,"Specify the direction of the Column with respect to the flow:"},
    protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},ColumnOrientation->Reverse];
    Download[protocol,ColumnOrientation],
    {Reverse},
    Variables:>{protocol}
  ],
  Example[
    {Options,NumberOfReplicates,"Specify the number of times to repeat measurements on each provided sample(s). If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted:"},
    protocol=ExperimentSupercriticalFluidChromatography[
      {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},NumberOfReplicates->2];
    Download[protocol,NumberOfReplicates],
    2,
    Variables:>{protocol}
  ],
    Example[
      {Options,CosolventA,"Specify the solvent pumped through the first channel to supplement the supercritical CO2 mobile phase:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CosolventA->Model[Sample, "Heptane (HPLC grade)"]
      ];
      Download[protocol,CosolventA],
      ObjectP[Model[Sample, "Heptane (HPLC grade)"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,CosolventB,"Specify the solvent pumped through the second channel to supplement the supercritical CO2 mobile phase:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CosolventB->Model[Sample, "Acetonitrile, LCMS grade"]
      ];
      Download[protocol,CosolventB],
      ObjectP[Model[Sample, "Acetonitrile, LCMS grade"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,CosolventC,"Specify the solvent pumped through the third channel to supplement the supercritical CO2 mobile phase:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CosolventC->Model[Sample, "Methanol - LCMS grade"]
      ];
      Download[protocol,CosolventC],
      ObjectP[Model[Sample, "Methanol - LCMS grade"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,CosolventD,"Specify the solvent pumped through the fourth channel to supplement the supercritical CO2 mobile phase:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CosolventD->Model[Sample, "id:lYq9jRxWD1OB"]
      ];
      Download[protocol,CosolventD],
      ObjectP[Model[Sample, "id:lYq9jRxWD1OB"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,InjectionTable,"Specify the order of sample, Standard, and Blank sample loading into the Instrument during measurement and/or collection. Also includes the flushing and priming of the column:"},
      customInjectionTable={
        {ColumnPrime,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Blank,Model[Sample,"Heptane (HPLC grade)"],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID],3 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],2 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {Sample,Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID],5 Microliter,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]},
        {ColumnFlush,Null,Null,Model[Item, Column, "Torus 2-PIC Column"],Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID]}
      };
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionTable->customInjectionTable
      ];
      Length@Download[protocol,InjectionTable],
      8,
      Variables:>{protocol,customInjectionTable}
    ],
    Example[
      {Options,SampleTemperature,"Specify the temperature at which the samples, Standard, and Blank are kept in the instrument's autosampler prior to injection on the column:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        SampleTemperature->5*Celsius
      ];
      Download[protocol,SampleTemperature],
      5.*Celsius,
      EquivalenceFunction -> Equal,
      Variables:>{protocol}
    ],
    Example[
      {Options,InjectionVolume,"Specify the physical quantity of sample loaded into the flow path for measurement and/or collection:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        InjectionVolume->5*Microliter
      ];
      Download[protocol,SampleVolumes],
      {5.*Microliter,5.*Microliter, 5.*Microliter},
      Variables:>{protocol}
    ],
    Example[
      {Options,NeedleWashSolution,"Specify the solvent used to wash the injection needle before each sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        NeedleWashSolution->Model[Sample, "id:Y0lXejGKdEDW"]
      ];
      Download[protocol,NeedleWashSolution],
      ObjectP[Model[Sample, "id:Y0lXejGKdEDW"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,CO2Gradient,"Specify the composition of the supercritical CO2 within the flow, defined for specific time points:"},

      co2gradient={
        {0 Minute, 97 Percent},
        {3 Minute, 80 Percent},
        {3.1 Minute, 80 Percent},
        {5 Minute, 77 Percent},
        {7 Minute, 60 Percent},
        {10 Minute, 60 Percent}
      };

      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CO2Gradient->co2gradient
      ];
      Download[protocol,CO2Gradient],
      {co2gradient..},
      Variables:>{protocol,co2gradient}
    ],
    Example[
      {Options,GradientA,"Specify the composition of CosolventA within the flow, defined for specific time points:"},

      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientA->gradient
      ];
      Download[protocol,GradientA],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,GradientB,"Specify the composition of CosolventB within the flow, defined for specific time points:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientB->gradient
      ];
      Download[protocol,GradientB],
      {gradient..},
      Variables:>{protocol}
    ],
    Example[
      {Options,GradientC,"Specify the composition of CosolventC within the flow, defined for specific time points:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientC->gradient
      ];
      Download[protocol,GradientC],
      {gradient..},
      Variables:>{protocol}
    ],
    Example[
      {Options,GradientD,"Specify the composition of CosolventD within the flow, defined for specific time points:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientD->gradient
      ];
      Download[protocol,GradientD],
      {gradient..},
      Variables:>{protocol}
    ],
    Example[
      {Options,FlowRate,"Specify the speed of the fluid through the pump:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]}
        ,FlowRate->2.5 Milliliter/Minute
      ];
      Download[protocol,FlowRate],
      {(2.5 Milliliter/Minute)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,MaxAcceleration,"Specify the maximum allowed change per time in FlowRate:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MaxAcceleration->25 (Milliliter/Minute/Minute)
      ];
      Download[protocol,MaxAcceleration],
      25. (Milliliter/Minute/Minute),
      EquivalenceFunction -> Equal,
      Variables:>{protocol}
    ],
    Example[
      {Options,GradientStart,"Specify the starting CosolventA composition in the fluid flow:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientStart->10 Percent,
        GradientEnd->50 Percent,
        GradientDuration->12 Minute,
        OutputFormat->List
      ];
      Lookup[options,GradientStart],
      10 Percent,
      Variables:>{options}
    ],
    Example[
      {Options,GradientEnd,"Specify the final CosolventA composition in the fluid flow:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientStart->10 Percent,
        GradientEnd->50 Percent,
        GradientDuration->12 Minute,
        OutputFormat->List
      ];
      Lookup[options,GradientEnd],
      50 Percent,
      Variables:>{options}
    ],
    Example[
      {Options,GradientDuration,"Specify the duration of CosolventA gradient:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        GradientStart->10 Percent,
        GradientEnd->50 Percent,
        GradientDuration->12 Minute,
        OutputFormat->List
      ];
      Lookup[options,GradientDuration],
      12 Minute,
      Variables:>{options}
    ],
    Example[
      {Options,EquilibrationTime,"Specify the duration of equilibration at the starting buffer composition at the start of a GradientA:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        EquilibrationTime->1*Minute,
        Output->Options
      ];
      Lookup[options,EquilibrationTime],
      1*Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,FlushTime,"Specify the duration of equilibration at the final buffer composition at the end of a GradientA:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FlushTime->0.5*Minute,
        Output->Options
      ];
      Lookup[options,FlushTime],
      0.5*Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,Gradient,"Specify the composition over time in the fluid flow:"},

      gradient={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Gradient->gradient,
        OutputFormat->List
      ];
      Lookup[options,Gradient],
      gradient,
      Variables:>{options}
    ],
    Example[
      {Options,BackPressure,"Specify the pressure differential between the outlet of the system and the atmosphere:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BackPressure->3000 PSI
      ];
      Download[protocol,BackPressures],
      {(3000*PSI)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,IonMode,"Specify whether positively or negatively charged ions are analyzed:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        IonMode->Negative
      ];
      Download[protocol,IonModes],
      {Negative,Negative,Negative},
      Variables:>{protocol}
    ],
    Example[
      {Options,MakeupSolvent,"Specify the buffer mixed with column effluent in flow path to mass spectrometer:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},MakeupSolvent->Model[Sample, StockSolution, "90% Methanol with 0.1% formic acid and 0.1% ammonium acetate"]];
      Download[protocol,MakeupSolvent],
      ObjectP[Model[Sample, StockSolution, "90% Methanol with 0.1% formic acid and 0.1% ammonium acetate"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,Calibrant,"Specify a sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer (currently, this cannot be changed):"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},Calibrant->Model[Sample, "qDa Detector Calibrant solution"]];
      Download[protocol,Calibrant],
      ObjectP[Model[Sample, "qDa Detector Calibrant solution"]],
      Variables:>{protocol}
    ],
    Example[
      {Options,MakeupFlowRate,"Specify the speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},MakeupFlowRate-> 500 Microliter/Minute];
      Download[protocol,MakeupFlowRates],
      {(500 Microliter/Minute|500. Microliter/Minute)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,MassDetection,"Specify the mass-to-charge ratios (m/z) to be recorded during analysis:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MassDetection->{179 Gram/Mole,225 Gram/Mole, 356 Gram/Mole}
      ];
      Download[protocol,MassSelection],
      {{179 Gram/Mole,225 Gram/Mole, 356 Gram/Mole}..},
      Variables:>{protocol}
    ],
    Example[
      {Options,ScanTime,"Specify the duration of time allowed to pass between each spectral acquisition:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ScanTime->0.05*Second
      ];
      Download[protocol,ScanTimes],
      {0.05*Second,0.05*Second,0.05*Second},
      Variables:>{protocol}
    ],
    Example[
      {Options,ProbeTemperature,"Specify the temperature of the spray needle introducing sample into the mass spectrometry detector:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ProbeTemperature->150 Celsius
      ];
      Download[protocol,ProbeTemperatures],
      {150.*Celsius,150.*Celsius,150.*Celsius},
      Variables:>{protocol}
    ],
    Example[
      {Options,ESICapillaryVoltage,"Specify the applied voltage differential between the injector and the inlet plate for the mass spectrometry:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ESICapillaryVoltage->1 Kilovolt
      ];
      Download[protocol,ESICapillaryVoltages],
      {Quantity[1000., "Volts"], Quantity[1000., "Volts"],  Quantity[1000., "Volts"]},
      Variables:>{protocol}
    ],
    Example[
      {Options,SamplingConeVoltage,"Specify the voltage differential between ion spray entry and the quadrupole mass analyzer:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        SamplingConeVoltage->50*Volt
      ];
      Download[protocol,SamplingConeVoltages],
      {50. Volt,50. Volt,50. Volt},
      Variables:>{protocol}
    ],
    Example[
      {Options,MassDetectionGain,"Specify the arbitrarily-scaled signal amplification for the mass spectrometry measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MassDetectionGain->10
      ];
      Download[protocol,MassDetectionGains],
      {10.,10.,10.},
      Variables:>{protocol}
    ],
    Example[
      {Options,AbsorbanceWavelength,"Specify the physical properties of light passed through the flow for the PhotoDiodeArray (PDA) Detector:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AbsorbanceWavelength->Span[300 Nanometer,600 Nanometer]
      ];
      Download[protocol,{MinAbsorbanceWavelengths,MaxAbsorbanceWavelengths}],
      {{300. Nanometer,300. Nanometer,300. Nanometer},{600. Nanometer,600. Nanometer,600. Nanometer}},
      Variables:>{protocol}
    ],
    Example[
      {Options,WavelengthResolution,"Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        WavelengthResolution->2.4*Nanometer
      ];
      Download[protocol,WavelengthResolutions],
      {2.4*Nanometer,2.4*Nanometer,2.4*Nanometer},
      Variables:>{protocol}
    ],
    Example[
      {Options,UVFilter,"Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PhotoDiodeArray detectors:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        UVFilter->True
      ];
      Download[protocol,UVFilters],
      {True,True,True},
      Variables:>{protocol}
    ],
    Example[
      {Options,AbsorbanceSamplingRate,"Specify the frequency of absorbance measurement. Lower values will be less susceptible to noise but will record less frequently across time:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AbsorbanceSamplingRate-> 10/Second
      ];
      Download[protocol,AbsorbanceSamplingRates],
      {10.*1/Second,10.*1/Second,10.*1/Second},
      Variables:>{protocol}
    ],
    Example[
      {Options,Standard,"Specify a reference compound to inject to the instrument, often used for quantification or to check internal measurement consistency:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Standard->Model[Sample, StockSolution, "SFC MS Standard Mix 1"]
      ];
      Download[protocol,Standards],
      {ObjectP[Model[Sample, StockSolution, "SFC MS Standard Mix 1"]]..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardInjectionVolume,"Specify the volume of each Standard to inject:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardInjectionVolume->3 Microliter
      ];
      Download[protocol,StandardSampleVolumes],
      {3. Microliter,3. Microliter},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardFrequency,"Specify the frequency at which Standard measurements will be inserted in the measurement sequence:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardFrequency->2,
        OutputFormat->List
      ];
      Lookup[options,StandardFrequency],
      2,
      Variables:>{options}
    ],
    Example[
      {Options,StandardColumn,"Specify the corresponding column to use for each standard sample:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardColumn->Model[Item, Column, "id:rea9jlRbE5Vx"]
      ];
      Download[protocol,StandardColumns],
      {ObjectP[Model[Item, Column, "id:rea9jlRbE5Vx"]]..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardColumnTemperature,"Specify The column's temperature at which the Standard gradient and measurement is run:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardColumnTemperature->50*Celsius
      ];
      Download[protocol,StandardColumnTemperatures],
      {(50.*Celsius)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardCO2Gradient,"Specify the composition of the supercritical CO2 within the flow, defined for specific time points for standard samples gradient:"},
      co2gradient={
        {0 Minute, 97 Percent},
        {3 Minute, 80 Percent},
        {3.1 Minute, 80 Percent},
        {5 Minute, 77 Percent},
        {7 Minute, 60 Percent},
        {10 Minute, 60 Percent}
      };

      protocol=ExperimentSupercriticalFluidChromatography[

        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardCO2Gradient->co2gradient
      ];
      Download[protocol,StandardCO2Gradient],
      {co2gradient..},
      Variables:>{protocol,co2gradient}
    ],
    Example[
      {Options,StandardGradientA,"Specify the composition of CosolventA within the flow, defined for specific time points for Standard measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardGradientA->gradient
      ];
      Download[protocol,StandardGradientA],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,StandardGradientB,"Specify the composition of CosolventB within the flow, defined for specific time points for Standard measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardGradientB->gradient
      ];
      Download[protocol,StandardGradientB],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,StandardGradientC,"Specify The composition of CosolventC within the flow, defined for specific time points for Standard measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardGradientC->gradient
      ];
      Download[protocol,StandardGradientC],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,StandardGradientD,"Specify the composition of CosolventD within the flow, defined for specific time points for Standard measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardGradientD->gradient];
      Download[protocol,StandardGradientD],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,StandardFlowRate,"Specify the speed of the fluid through the system for Standard measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardFlowRate->2 Milliliter/Minute
      ];
      Download[protocol,StandardFlowRates],
      {(2 Milliliter/Minute)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardGradient,"Specify the composition over time in the fluid flow for Standard samples. Specific parameters of an object can be overridden by specific options:"},

      gradient={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent,0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 100 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardGradient->gradient];
      Download[protocol,StandardGradientMethods],
      {ObjectP[Object[Method]]..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardGradientDuration,"Specify duration of the standard gradient:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample,"ExperimentSFC Test Sample 1" <> $SessionUUID]},
        StandardGradientDuration->15 Minute,
        Output->Options
      ];
      Lookup[options,StandardGradientDuration],
      15 Minute,
      Variables:>{options}
    ],
    Example[
      {Options,StandardBackPressure,"Specify the pressure differential between the outlet of the system and the atmosphere for Standard sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardBackPressure->2500 PSI
      ];
      Download[protocol,StandardBackPressures],
      {(2500 PSI)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardIonMode,"Specify if positively or negatively charged ions are analyzed for Standard samples:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardIonMode->Negative
      ];
      Download[protocol,StandardIonModes],
      {Negative..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardMakeupFlowRate,"Specify the speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of Standard samples:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardMakeupFlowRate->400 Microliter/Minute];
      Download[protocol,StandardMakeupFlowRates],
      {((400 Microliter/Minute)|(400. Microliter/Minute))..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardMassDetection,"Specify The mass-to-charge ratios (m/z) to be recorded during analysis for Standard sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardMassDetection->Span[60 Gram/Mole,250 Gram/Mole]
      ];
      Download[protocol,{StandardMinMasses,StandardMaxMasses}],
      {{(60. Gram/Mole)..},{(250. Gram/Mole)..}},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardScanTime,"Specify the duration of time allowed to pass between each spectral acquisition for Standard sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardScanTime->0.1 Second];
      Download[protocol,StandardScanTimes],
      {(0.1 Second)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardProbeTemperature,"Specify the temperature of the spray needle introducing sample into the mass spectrometry detector for Standard sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardProbeTemperature->75 Celsius
      ];
      Download[protocol,StandardProbeTemperatures],
      {(75. Celsius)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardESICapillaryVoltage,"Specify the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardESICapillaryVoltage->0.3 Kilovolt
      ];
      Download[protocol,StandardESICapillaryVoltages],
      {(300. Volt)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardSamplingConeVoltage,"Specify the voltage differential between ion spray entry and the quadrupole mass analyzer for Standard sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardSamplingConeVoltage->45 Volt];
      Download[protocol,StandardSamplingConeVoltages],
      {(45. Volt)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardMassDetectionGain,"Specify the arbitrarily-scaled signal amplification for the mass spectrometry measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardMassDetectionGain->2
      ];
      Download[protocol,StandardMassDetectionGains],
      {(2.)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardAbsorbanceWavelength,"Specify the physical properties of light passed through the flow for the PhotoDiodeArray Detector for Standard measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardAbsorbanceWavelength->273 Nanometer
      ];
      Download[protocol,StandardAbsorbanceSelection],
      {{273 Nanometer}..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardWavelengthResolution,"Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for Standard measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardWavelengthResolution->4.8*Nanometer
      ];
      Download[protocol,StandardWavelengthResolutions],
      {(4.8 Nanometer)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardUVFilter,"Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for Standard measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardUVFilter->False
      ];
      Download[protocol,StandardUVFilters],
      {(False)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardAbsorbanceSamplingRate,"Specify the frequency of Standard measurement for absorbance:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardAbsorbanceSamplingRate->80*1/Second
      ];
      Download[protocol,StandardAbsorbanceSamplingRates],
      {(80.*1/Second)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,StandardStorageCondition,"Specify the non-default conditions under which any standards used by this experiment should be stored after the protocol is completed:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        StandardStorageCondition->Disposal
      ];
      Download[protocol,StandardsStorageConditions],
      {Disposal..},
      Variables:>{protocol}
    ],
    Example[
      {Options,Blank,"Specify a sample containing just buffer and no analytes, often used to check for background compounds present in the buffer or coming off the column:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Blank->Model[Sample, "Heptane (HPLC grade)"]
      ];
      Download[protocol,Blanks],
      {ObjectP[Model[Sample, "Heptane (HPLC grade)"]]..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankInjectionVolume,"Specify the volume of each Blank to inject:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankInjectionVolume->6 Microliter
      ];
      Download[protocol,BlankSampleVolumes],
      {(6. Microliter)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankFrequency,"Specify the frequency at which Blank measurements will be inserted in the measurement sequence:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankFrequency->Last,
        OutputFormat->List
      ];
      Lookup[options,BlankFrequency],
      Last,
      Variables:>{options}
    ],
    Example[
      {Options,BlankColumn,"Specify the corresponding column to use for each Blank sample:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankColumn->Model[Item, Column, "Lux 5 Angstrom Amylose"]
      ];
      Download[protocol,BlankColumns],
      {ObjectP[Model[Item, Column, "Lux 5 Angstrom Amylose"]]..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankColumnTemperature,"Specify the column's temperature at which the Blank gradient and measurement is run:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankColumnTemperature->35*Celsius
      ];
      Download[protocol,BlankColumnTemperatures],
      {35. Celsius,35. Celsius},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankCO2Gradient,"Specify the composition of the supercritical CO2 within the flow, defined for specific time points for Blank samples:"},
      co2gradient={
        {0 Minute, 97 Percent},
        {3 Minute, 80 Percent},
        {3.1 Minute, 80 Percent},
        {5 Minute, 77 Percent},
        {7 Minute, 60 Percent},
        {10 Minute, 60 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankCO2Gradient->co2gradient
      ];
      Download[protocol,BlankCO2Gradient],
      {co2gradient..},
      Variables:>{protocol,co2gradient}
    ],
    Example[
      {Options,BlankGradientA,"Specify the composition of CosolventA within the flow, defined for specific time points for Blank measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankGradientA->gradient
      ];
      Download[protocol,BlankGradientA],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,BlankGradientB,"Specify the composition of CosolventB within the flow, defined for specific time points for Blank measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankGradientB->gradient
      ];
      Download[protocol,BlankGradientB],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,BlankGradientC,"Specify the composition of CosolventC within the flow, defined for specific time points for Blank measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankGradientC->gradient
      ];
      Download[protocol,BlankGradientC],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,BlankGradientD,"Specify the composition of CosolventD within the flow, defined for specific time points for Blank measurement:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankGradientD->gradient
      ];
      Download[protocol,BlankGradientD],
      {gradient..},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,BlankFlowRate,"Specify the speed of the fluid through the system for Blank measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankFlowRate->2.2 Milliliter/Minute
      ];
      Download[protocol,BlankFlowRates],
      {(2.2 Milliliter/Minute)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankGradient,"Specify the composition over time in the fluid flow for Blank samples:"},
      gradient={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankGradient->gradient,
        Output->Options
      ];
      Lookup[options,BlankGradient],
      gradient,
      Variables:>{options,gradient}
    ],
    Example[{Options,BlankGradientDuration,"Specify duration of the blank gradient:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample,"ExperimentSFC Test Sample 1" <> $SessionUUID]},
        BlankGradientDuration->15 Minute,
        Output->Options
      ];
      Lookup[options,BlankGradientDuration],
      15 Minute,
      Variables:>{options}
    ],
    Example[
      {Options,BlankBackPressure,"Specify the pressure differential between the outlet of the system and the atmosphere for Blank sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankBackPressure->3000*PSI
      ];
      Download[protocol,BlankBackPressures],
      {(3000*PSI)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankIonMode,"Specify if positively or negatively charged ions are analyzed for Blank samples:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankIonMode->Negative
      ];
      Download[protocol,BlankIonModes],
      {Negative..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankMakeupFlowRate,"Specify the speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of Blank samples:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankMakeupFlowRate->300. Microliter/Minute
      ];
      Download[protocol,BlankMakeupFlowRates],
      {((300. Microliter/Minute)|(300 Microliter/Minute))..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankMassDetection,"Specify the mass-to-charge ratios (m/z) to be recorded during analysis for Blank sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankMassDetection->{179 Gram/Mole,225 Gram/Mole, 356 Gram/Mole}
      ];
      Download[protocol,BlankMassSelection],
      {{179 Gram/Mole,225 Gram/Mole, 356 Gram/Mole}..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankScanTime,"Specify the duration of time allowed to pass between each spectral acquisition for Blank sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankScanTime->0.5 Second
      ];
      Download[protocol,BlankScanTimes],
      {(0.5 Second)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankProbeTemperature,"Specify the temperature of the spray needle introducing sample into the mass spectrometry detector for Blank sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankProbeTemperature->90 Celsius
      ];
      Download[protocol,BlankProbeTemperatures],
      {(90. Celsius)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankESICapillaryVoltage,"Specify the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize Blank samples:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankESICapillaryVoltage->1.1 Kilovolt
      ];
      Download[protocol,BlankESICapillaryVoltages],
      {(1100. Volt)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankSamplingConeVoltage,"Specify the voltage differential between ion spray entry and the quadrupole mass analyzer for Blank sample measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankSamplingConeVoltage->55*Volt
      ];
      Download[protocol,BlankSamplingConeVoltages],
      {(55.*Volt)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankMassDetectionGain,"Specify the arbitrarily-scaled signal amplification for the mass spectrometry measurement for Blanks:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankMassDetectionGain->3
      ];
      Download[protocol,BlankMassDetectionGains],
      {(3.)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankAbsorbanceWavelength,"Specify the physical properties of light passed through the flow for the PhotoDiodeArray Detector for Blank measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankAbsorbanceWavelength->{267 Nanometer}
      ];
      Download[protocol,BlankMinAbsorbanceWavelengths],
      {(267. Nanometer)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankWavelengthResolution,"Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for Blank measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankWavelengthResolution->3.6*Nanometer
      ];
      Download[protocol,BlankWavelengthResolutions],
      {(3.6*Nanometer)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankUVFilter,"Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for Blank measurement:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankUVFilter->True
      ];
      Download[protocol,BlankUVFilters],
      {True..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankAbsorbanceSamplingRate,"Specify the frequency of Blank measurement. Lower values will be less susceptible to noise but will record less frequently across time:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankAbsorbanceSamplingRate->1 * 1/Second
      ];
      Download[protocol,BlankAbsorbanceSamplingRates],
      {(1.*1/Second)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,BlankStorageCondition,"Specify the non-default conditions under which any Blank samples used by this experiment should be stored after the protocol is completed:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BlankStorageCondition->Freezer
      ];
      Download[protocol,BlanksStorageConditions],
      {Freezer..},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnRefreshFrequency,"Specify the frequency at which procedures to clear out and re-prime the column will be inserted into the order of analyte injections:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnRefreshFrequency->3,
        OutputFormat->List
      ];
      Lookup[options,ColumnRefreshFrequency],
      3,
      Variables:>{options}
    ],
    Example[
      {Options,ColumnPrimeColumnTemperature,"Specify the column's temperature at which the ColumnPrime gradient and measurement is run:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeColumnTemperature->65 Celsius
      ];
      Download[protocol,ColumnPrimeTemperatures],
      {65. Celsius},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeCO2Gradient,"Specify the composition of the supercritical CO2 within the flow, defined for specific time points for ColumnPrime runs:"},

      co2gradient={
        {0 Minute, 97 Percent},
        {3 Minute, 80 Percent},
        {3.1 Minute, 80 Percent},
        {5 Minute, 77 Percent},
        {7 Minute, 60 Percent},
        {10 Minute, 60 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeCO2Gradient->co2gradient
      ];
      Download[protocol,ColumnPrimeCO2Gradient],
      {co2gradient},
      Variables:>{protocol,co2gradient}
    ],
    Example[
      {Options,ColumnPrimeGradientA,"Specify the composition of CosolventA within the flow, defined for specific time points for ColumnPrime runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeGradientA->gradient
      ];
      Download[protocol,ColumnPrimeGradientA],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnPrimeGradientB,"Specify the composition of CosolventB within the flow, defined for specific time points for ColumnPrime runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeGradientB->gradient
      ];
      Download[protocol,ColumnPrimeGradientB],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnPrimeGradientC,"Specify the composition of CosolventC within the flow, defined for specific time points for ColumnPrime runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeGradientC->gradient
      ];
      Download[protocol,ColumnPrimeGradientC],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnPrimeGradientD,"Specify the composition of CosolventD within the flow, defined for specific time points for ColumnPrime runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeGradientD->gradient
      ];
      Download[protocol,ColumnPrimeGradientD],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnPrimeFlowRate,"Specify the speed of the fluid through the system for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeFlowRate->1.7*Milliliter/Minute
      ];
      Download[protocol,ColumnPrimeFlowRates],
      {(1.7*Milliliter/Minute)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeGradientDuration,"Specify the duration of the ColumnPrime runs:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeGradientDuration->20 Minute,
        OutputFormat->List
      ];
      Lookup[options,ColumnPrimeGradientDuration],
      20*Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,ColumnPrimeGradient,"Specify the composition over time in the fluid flow for ColumnPrime runs:"},
      gradient={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeGradient->gradient,
        Output->Options
      ];
      Lookup[options,ColumnPrimeGradient],
      gradient,
      Variables:>{options,gradient}
    ],
    Example[
      {Options,ColumnPrimeBackPressure,"Specify the pressure differential between the outlet of the system and the atmosphere for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeBackPressure->2400 PSI
      ];
      Download[protocol,ColumnPrimeBackPressure],
      {2400*PSI},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeIonMode,"Specify if positively or negatively charged ions are analyzed for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeIonMode->Positive
      ];
      Download[protocol,ColumnPrimeIonModes],
      {Positive},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeMakeupFlowRate,"Specify the speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeMakeupFlowRate->600. Microliter/Minute
      ];
      Download[protocol,ColumnPrimeMakeupFlowRates],
      {600. Microliter/Minute},
      EquivalenceFunction->Equal,
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeMassDetection,"Specify the mass-to-charge ratios (m/z) to be recorded during analysis for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeMassDetection->Span[60 Gram/Mole,300 Gram/Mole]
      ];
      Download[protocol,{ColumnPrimeMinMasses, ColumnPrimeMaxMasses}],
      {{60. Gram/Mole},{300. Gram/Mole}},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeScanTime,"Specify the duration of time allowed to pass between each spectral acquisition for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeScanTime->0.5 Second
      ];
      Download[protocol,ColumnPrimeScanTimes],
      {(0.5 Second)},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeProbeTemperature,"Specify the temperature of the spray needle introducing sample into the mass spectrometry detector for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeProbeTemperature->130 Celsius
      ];
      Download[protocol,ColumnPrimeProbeTemperatures],
      {130. Celsius},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeESICapillaryVoltage,"Specify the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules for each column prime run:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeESICapillaryVoltage->0.9 Kilovolt
      ];
      Download[protocol,ColumnPrimeESICapillaryVoltages],
      {900. Volt},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeSamplingConeVoltage,"Specify the voltage differential between ion spray entry and the quadrupole mass analyzer for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeSamplingConeVoltage->45 Volt
      ];
      Download[protocol,ColumnPrimeSamplingConeVoltages],
      {45. Volt},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeMassDetectionGain,"Specify the arbitrarily-scaled signal amplification for the mass spectrometry measurement for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeMassDetectionGain->7
      ];
      Download[protocol,ColumnPrimeMassDetectionGains],
      {7.},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeAbsorbanceWavelength,"Specify the physical properties of light passed through the flow for the PhotoDiodeArray Detector for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeAbsorbanceWavelength->Span[250 Nanometer,700 Nanometer]
      ];
      Download[protocol,{ColumnPrimeMinAbsorbanceWavelengths,ColumnPrimeMaxAbsorbanceWavelengths}],
      {{250. Nanometer},{700. Nanometer}},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeWavelengthResolution,"Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeWavelengthResolution->4.8*Nanometer
      ];
      Download[protocol,ColumnPrimeWavelengthResolutions],
      {4.8*Nanometer},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeUVFilter,"Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for ColumnPrime runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeUVFilter->True
      ];
      Download[protocol,ColumnPrimeUVFilter],
      {True},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnPrimeAbsorbanceSamplingRate,"Specify the frequency of ColumnPrime runs. Lower values will be less susceptible to noise but will record less frequently across time:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnPrimeAbsorbanceSamplingRate->20 * 1/Second
      ];
      Download[protocol,ColumnPrimeAbsorbanceSamplingRates],
      {20. * 1/Second},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushColumnTemperature,"Specify the column's temperature at which the ColumnFlush gradient and measurement is run:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushColumnTemperature->65 Celsius
      ];
      Download[protocol,ColumnFlushTemperatures],
      {65. Celsius},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushCO2Gradient,"Specify the composition of the supercritical CO2 within the flow, defined for specific time points for ColumnFlush runs:"},

      co2gradient={
        {0 Minute, 97 Percent},
        {3 Minute, 80 Percent},
        {3.1 Minute, 80 Percent},
        {5 Minute, 77 Percent},
        {7 Minute, 60 Percent},
        {10 Minute, 60 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushCO2Gradient->co2gradient
      ];
      Download[protocol,ColumnFlushCO2Gradient],
      {co2gradient},
      Variables:>{protocol,co2gradient}
    ],
    Example[
      {Options,ColumnFlushGradientA,"Specify the composition of CosolventA within the flow, defined for specific time points for ColumnFlush runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushGradientA->gradient
      ];
      Download[protocol,ColumnFlushGradientA],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnFlushGradientB,"Specify the composition of CosolventB within the flow, defined for specific time points for ColumnFlush runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushGradientB->gradient
      ];
      Download[protocol,ColumnFlushGradientB],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnFlushGradientC,"Specify the composition of CosolventC within the flow, defined for specific time points for ColumnFlush runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushGradientC->gradient
      ];
      Download[protocol,ColumnFlushGradientC],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnFlushGradientD,"Specify the composition of CosolventD within the flow, defined for specific time points for ColumnFlush runs:"},
      gradient={
        {0 Minute, 10 Percent},
        {3 Minute, 15 Percent},
        {3.1 Minute, 30 Percent},
        {5 Minute, 10 Percent},
        {7 Minute, 10 Percent},
        {10 Minute, 50 Percent}
      };
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushGradientD->gradient
      ];
      Download[protocol,ColumnFlushGradientD],
      {gradient},
      Variables:>{protocol,gradient}
    ],
    Example[
      {Options,ColumnFlushFlowRate,"Specify the speed of the fluid through the system for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushFlowRate->1.7*Milliliter/Minute
      ];
      Download[protocol,ColumnFlushFlowRates],
      {(1.7*Milliliter/Minute)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushGradientDuration,"Specify the duration of the ColumnFlush runs:"},
      options=ExperimentSupercriticalFluidChromatographyOptions[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushGradientDuration->20 Minute,
        OutputFormat->List
      ];
      Lookup[options,ColumnFlushGradientDuration],
      20*Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,ColumnFlushGradient,"Specify the composition over time in the fluid flow for ColumnFlush runs:"},
      gradient={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushGradient->gradient,
        Output->Options
      ];
      Lookup[options,ColumnFlushGradient],
      gradient,
      Variables:>{options,gradient}
    ],
    Example[
      {Options,ColumnFlushBackPressure,"Specify the pressure differential between the outlet of the system and the atmosphere for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushBackPressure->2400 PSI
      ];
      Download[protocol,ColumnFlushBackPressures],
      {2400*PSI},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushIonMode,"Specify if positively or negatively charged ions are analyzed for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushIonMode->Positive
      ];
      Download[protocol,ColumnFlushIonModes],
      {Positive},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushMakeupFlowRate,"Specify the speed of the MakeupSolvent to supplement column effluent for the mass spectrometry measurement of ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushMakeupFlowRate->600. Microliter/Minute
      ];
      Download[protocol,ColumnFlushMakeupFlowRates],
      {600. Microliter/Minute},
      EquivalenceFunction->Equal,
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushMassDetection,"Specify the mass-to-charge ratios (m/z) to be recorded during analysis for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushMassDetection->Span[60 Gram/Mole,300 Gram/Mole]
      ];
      Download[protocol,{ColumnFlushMinMasses, ColumnFlushMaxMasses}],
      {{60. Gram/Mole},{300. Gram/Mole}},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushScanTime,"Specify the duration of time allowed to pass between each spectral acquisition for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushScanTime->0.1 Second
      ];
      Download[protocol,ColumnFlushScanTimes],
      {(0.1 Second)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushProbeTemperature,"Specify the temperature of the spray needle introducing sample into the mass spectrometry detector for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushProbeTemperature->130 Celsius
      ];
      Download[protocol,ColumnFlushProbeTemperatures],
      {130. Celsius},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushESICapillaryVoltage,"Specify the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules for each column prime run:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushESICapillaryVoltage->1.0 Kilovolt
      ];
      Download[protocol,ColumnFlushESICapillaryVoltages],
      {1000. Volt},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushSamplingConeVoltage,"Specify the voltage differential between ion spray entry and the quadrupole mass analyzer for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushSamplingConeVoltage->45 Volt
      ];
      Download[protocol,ColumnFlushSamplingConeVoltages],
      {45. Volt},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushMassDetectionGain,"Specify the arbitrarily-scaled signal amplification for the mass spectrometry measurement for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushMassDetectionGain->7
      ];
      Download[protocol,ColumnFlushMassDetectionGains],
      {7.},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushAbsorbanceWavelength,"Specify the physical properties of light passed through the flow for the PhotoDiodeArray Detector for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushAbsorbanceWavelength->Span[250 Nanometer,700 Nanometer]
      ];
      Download[protocol,{ColumnFlushMinAbsorbanceWavelengths,ColumnFlushMaxAbsorbanceWavelengths}],
      {{250. Nanometer},{700. Nanometer}},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushWavelengthResolution,"Specify the increment of wavelength for the range of light passed through the flow for absorbance measurement with the PDA detector for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushWavelengthResolution->9.6*Nanometer
      ];
      Download[protocol,ColumnFlushWavelengthResolutions],
      {(9.6*Nanometer)..},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushUVFilter,"Specify whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for the PDA detector for ColumnFlush runs:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushUVFilter->True
      ];
      Download[protocol,ColumnFlushUVFilters],
      {True},
      Variables:>{protocol}
    ],
    Example[
      {Options,ColumnFlushAbsorbanceSamplingRate,"Specify the frequency of ColumnFlush runs. Lower values will be less susceptible to noise but will record less frequently across time:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ColumnFlushAbsorbanceSamplingRate->20 * 1/Second
      ];
      Download[protocol,ColumnFlushAbsorbanceSamplingRates],
      {20. * 1/Second},
      Variables:>{protocol}
    ],
    Example[
      {Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},Template->Null];
      Download[protocol,Template],
      Null,
      Variables:>{protocol}
    ],
    Example[
      {Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
      protocol=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Name->"My particular ExperimentSupercriticalFluidChromatography protocol" <> $SessionUUID
      ];
      Download[protocol,Name],
      "My particular ExperimentSupercriticalFluidChromatography protocol" <> $SessionUUID,
      Variables:>{protocol}
    ],
    Example[
      {Options,Upload,"Specify if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
      packets=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Upload->False
      ],
      {PacketP[Object[Protocol,SupercriticalFluidChromatography]],___},
      Variables:>{protocol}
    ],
    Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
      options = ExperimentSupercriticalFluidChromatography[
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
    Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
      ExperimentSupercriticalFluidChromatography[
        Model[Sample, "Ammonium hydroxide"],
        PreparedModelAmount -> 0.5 Milliliter,
        Aliquot -> True,
        Mix -> True
      ],
      ObjectP[Object[Protocol, SupercriticalFluidChromatography]]
    ],
    Example[
      {Options,PreparatoryUnitOperations,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSamplePreparation:"},
      protocol=ExperimentSupercriticalFluidChromatography[{Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CosolventA->"My Cosolvent with additive",
        PreparatoryUnitOperations->{
          LabelContainer[
            Label -> "My Cosolvent with additive Container",
            Container -> Model[Container, Vessel, "1L Glass Bottle"]
          ],
          Transfer[
            Source -> Model[Sample, "Methanol - LCMS grade"],
            Destination -> "My Cosolvent with additive Container",
            Amount -> 500 Milliliter
          ],
          Transfer[
            Source -> Model[Sample, "Heptafluorobutyric acid"],
            Destination -> "My Cosolvent with additive Container",
            Amount -> 1 Milliliter
          ],
          LabelSample[
            Label -> "My Cosolvent with additive",
            Sample -> {"A1", "My Cosolvent with additive Container"}
          ]
        }
      ],
      ObjectP[Object[Protocol,SupercriticalFluidChromatography]],
      Variables:>{protocol}
    ],

    (*all the sample prep stuff*)
    Example[
      {Options,Incubate,"Specify if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Incubate->True,
        Output->Options
      ];
      Lookup[options,Incubate],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,IncubationTemperature,"Specify the temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        IncubationTemperature->40 Celsius,
        Output->Options
      ];
      Lookup[options,IncubationTemperature],
      40 Celsius,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,IncubationTime,"Specify duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        IncubationTime->40 Minute,
        Output->Options
      ];
      Lookup[options,IncubationTime],
      40 Minute,
      Variables:>{options}
    ],
    Example[
      {Options,Mix,"Specify the samples should be mixed while incubated, prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Mix->True,
        Output->Options
      ];
      Lookup[options,Mix],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,MixType,"Specify the style of motion used to mix the samples, prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MixType->Vortex,
        Output->Options
      ];
      Lookup[options,MixType],
      Vortex,
      Variables:>{options}
    ],
    Example[
      {Options,MixUntilDissolved,"Specify if the samples should be mixed in an attempt dissolve any solute prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MixUntilDissolved->True,
        Output->Options
      ];
      Lookup[options,MixUntilDissolved],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,MaxIncubationTime,"Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MaxIncubationTime->1 Hour,
        Output->Options
      ];
      Lookup[options,MaxIncubationTime],
      1 Hour,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,IncubationInstrument,"Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        IncubationInstrument->Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
        Output->Options
      ];
      Lookup[options,IncubationInstrument],
      ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
      Variables:>{options}
    ],
    Example[
      {Options,AnnealingTime,"Specify minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AnnealingTime->20 Minute,
        Output->Options
      ];
      Lookup[options,AnnealingTime],
      20 Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,IncubateAliquotContainer,"Specify the container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],
        Output->Options
      ];
      Lookup[options,IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,IncubateAliquotDestinationWell,"Specify the position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        IncubateAliquotDestinationWell->"A1",
        Output->Options
      ];
      Lookup[options,IncubateAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[
      {Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        IncubateAliquot->0.5*Milliliter,
        Output->Options
      ];
      Lookup[options,IncubateAliquot],
      0.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,Centrifuge,"Specify if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Centrifuge->True,
        Output->Options
      ];
      Lookup[options,Centrifuge],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeInstrument,"Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"],
        Output->Options
      ];
      Lookup[options,CentrifugeInstrument],
      ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeIntensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeIntensity->1000 RPM,
        Output -> Options
      ];
      Lookup[options,CentrifugeIntensity],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeTime,"Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeTime->2 Minute,
        Output -> Options
      ];
      Lookup[options,CentrifugeTime],
      2 Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeTemperature,"Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeTemperature->10 Celsius,
        Output -> Options
      ];
      Lookup[options,CentrifugeTemperature],
      10 Celsius,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeAliquotContainer,"Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"],
        Output -> Options
      ];
      Lookup[options,CentrifugeAliquotContainer],
      {{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeAliquotDestinationWell->"A1",
        Output -> Options
      ];
      Lookup[options,CentrifugeAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[
      {Options,CentrifugeAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        CentrifugeAliquot->0.5 Milliliter,
        Output -> Options
      ];
      Lookup[options,CentrifugeAliquot],
      0.5 Milliliter,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,Filtration,"Specify if the SamplesIn should be filter prior to starting the experiment or any aliquoting:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Filtration->True,
        Output -> Options
      ];
      Lookup[options,Filtration],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,FiltrationType,"Specify the type of filtration method that should be used to perform the filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FiltrationType->Syringe,
        Output -> Options
      ];
      Lookup[options,FiltrationType],
      Syringe,
      Variables:>{options}
    ],
    Example[
      {Options,FilterInstrument,"Specify the instrument that should be used to perform the filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"ExperimentSFC Large Test Sample 1" <> $SessionUUID],
        FilterInstrument->Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
        Output -> Options
      ];
      Lookup[options,FilterInstrument],
      ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,Filter,"Specify whether to filter in order to remove impurities from the input samples prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"ExperimentSFC Large Test Sample 1" <> $SessionUUID],
        Filter->Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"],
        Output -> Options
      ];
      Lookup[options,Filter],
      ObjectP[Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"]],
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterMaterial->PES,
        Output -> Options
      ];
      Lookup[options,FilterMaterial],
      PES,
      Variables:>{options}
    ],
    Example[
      {Options,PrefilterMaterial,"Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"Test sample for invalid container for ExperimentSFC tests" <> $SessionUUID],
        PrefilterMaterial->GxF,
        Output -> Options
      ];
      Lookup[options,PrefilterMaterial],
      GxF,
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterPoreSize,"Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterPoreSize->0.22 Micrometer,
        Output -> Options
      ];
      Lookup[options,FilterPoreSize],
      0.22 Micrometer,
      Variables:>{options}
    ],
    Example[
      {Options,PrefilterPoreSize,"Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"Test sample for invalid container for ExperimentSFC tests" <> $SessionUUID],
        PrefilterPoreSize->1.`*Micrometer,
        Output -> Options
      ];
      Lookup[options,PrefilterPoreSize],
      1.`*Micrometer,
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterSyringe,"Specify the syringe used to force that sample through a filter:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"Test sample for invalid container for ExperimentSFC tests" <> $SessionUUID],
        FiltrationType->Syringe,
        FilterSyringe->Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
        Output -> Options
      ];
      Lookup[options,FilterSyringe],
      ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterHousing,"Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"ExperimentSFC Large Test Sample 1" <> $SessionUUID],
        FiltrationType->PeristalticPump,
        FilterHousing->Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],
        Output -> Options
      ];
      Lookup[options,FilterHousing],
      ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterIntensity->1000 RPM,
        Output -> Options
      ];
      Lookup[options,FilterIntensity],
      1000 RPM,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,FilterTime,"Specify the time for which the samples will be centrifuged during filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterTime->5 Minute,
        Output -> Options
      ];
      Lookup[options,FilterTime],
      5 Minute,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,FilterTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample,"Test sample for invalid container for ExperimentSFC tests" <> $SessionUUID],
        FiltrationType -> Centrifuge,
        FilterTemperature->10 Celsius,
        Output -> Options
      ];
      Lookup[options,FilterTemperature],
      10 Celsius,
      EquivalenceFunction -> Equal,
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterContainerOut,"Specify the container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample, "ExperimentSFC Large Test Sample 1" <> $SessionUUID],
        FilterContainerOut->Model[Container, Vessel, "250mL Glass Bottle"],
        Output -> Options
      ];
      Lookup[options,FilterContainerOut],
      {1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
      Messages:>{
        Warning::AliquotRequired
      },
      Variables:>{options}
    ],
    Example[
      {Options,FilterAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterAliquotDestinationWell->"A1",
        Output -> Options
      ];
      Lookup[options,FilterAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[
      {Options,FilterAliquotContainer,"Specify the container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterAliquotContainer->Model[Container, Vessel, "2mL Tube"],
        Output -> Options
      ];
      Lookup[options,FilterAliquotContainer],
      {{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
      Variables:>{options}
    ],
    Example[
      {Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterAliquot->0.5 Milliliter,
        Output -> Options
      ];
      Lookup[options,FilterAliquot],
      0.5 Milliliter,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
    Example[
      {Options,FilterSterile,"Specify if the filtration of the samples should be done in a sterile environment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        FilterSterile->True,
        Output -> Options
      ];
      Lookup[options,FilterSterile],
      True,
      Variables:>{options}
    ],*)
    Example[
      {Options,Aliquot,"Specify if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Aliquot->True,
        Output -> Options
      ];
      Lookup[options,Aliquot],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,AliquotAmount,"Specify the amount of a sample that should be transferred from the input samples into aliquots:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AliquotAmount->0.08 Milliliter,
        Output -> Options
      ];
      Lookup[options,AliquotAmount],
      0.08 Milliliter,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,AliquotSampleLabel,"Set name labels for aliquots taken from the input samples:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        Aliquot->True,
        AliquotSampleLabel->{"Sample 1 aliquot", "Sample 2 aliquot", "Sample 3 aliquot"},
        Output -> Options
      ];
      Lookup[options,AliquotSampleLabel],
      {"Sample 1 aliquot", "Sample 2 aliquot", "Sample 3 aliquot"},
      Variables:>{options}
    ],
    Example[
      {Options,TargetConcentration,"Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        TargetConcentration -> 450 Micromolar,
        Output -> Options
      ];
      Lookup[options,TargetConcentration],
      EqualP[450 Micromolar],
      Variables:>{options}
    ],
    Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
      options = ExperimentSupercriticalFluidChromatography[Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], TargetConcentration -> 500 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Acetone"], InjectionVolume -> 10 Microliter,Output -> Options];
      Lookup[options, TargetConcentrationAnalyte],
      ObjectP[Model[Molecule, "Acetone"]],
      Variables :> {options}
    ],
    Example[
      {Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        AssayVolume->0.08*Milliliter,
        Output -> Options
      ];
      Lookup[options,AssayVolume],
      0.08*Milliliter,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AssayVolume -> 100 Microliter,
        AliquotAmount -> 20 Microliter,
        Output -> Options
      ];
      Lookup[options,ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables:>{options}
    ],
    Example[
      {Options,BufferDilutionFactor,"Specify the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AssayVolume -> 100 Microliter,
        AliquotAmount -> 20 Microliter,
        Output -> Options
      ];
      Lookup[options,BufferDilutionFactor],
      10,
      EquivalenceFunction -> Equal,
      Variables:>{options}
    ],
    Example[
      {Options,BufferDiluent,"Specify the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        BufferDiluent -> Model[Sample, "Methanol - LCMS grade"],
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AssayVolume -> 100 Microliter,
        AliquotAmount -> 20 Microliter,
        Output -> Options
      ];
      Lookup[options,BufferDiluent],
      ObjectP[Model[Sample, "Methanol - LCMS grade"]],
      Variables:>{options}
    ],
    Example[
      {Options,AssayBuffer,"Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AssayVolume -> 100 Microliter,
        AliquotAmount -> 20 Microliter,
        Output -> Options
      ];
      Lookup[options,AssayBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables:>{options}
    ],
    Example[
      {Options,AliquotSampleStorageCondition,"Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the options is completed:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AliquotSampleStorageCondition->Refrigerator,
        Output -> Options
      ];
      Lookup[options,AliquotSampleStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],
    Example[
      {Options,DestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        DestinationWell->"A1",
        Output -> Options
      ];
      Lookup[options,DestinationWell],
      {"A1","A1","A1"},
      Variables:>{options}
    ],
    Example[
      {Options,AliquotContainer,"Specify the container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"],
        Output -> Options
      ];
      Lookup[options,AliquotContainer],
      {
        {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
        {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
        {1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
      },
      Variables:>{options}
    ],
    Example[
      {Options,AliquotPreparation,"Specify the desired scale at which liquid handling used to generate aliquots will occur:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        AliquotPreparation->Manual,
        Output -> Options
      ];
      Lookup[options,AliquotPreparation],
      Manual,
      Variables:>{options}
    ],
    Example[
      {Options,ConsolidateAliquots,"Specify if identical aliquots should be prepared in the same container/position:"},
      options=ExperimentSupercriticalFluidChromatography[
        Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID],
        Aliquot->True, ConsolidateAliquots -> True,
        Output -> Options
      ];
      Lookup[options,ConsolidateAliquots],
      True,
      Variables:>{options}
    ],
    Example[
      {Options,MeasureWeight,"Specify if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MeasureWeight->False,
        Output -> Options
      ];
      Lookup[options,MeasureWeight],
      False,
      Variables:>{options}
    ],
    Example[
      {Options,MeasureVolume,"Specify if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        MeasureVolume->False,
        Output -> Options
      ];
      Lookup[options,MeasureVolume],
      False,
      Variables:>{options}
    ],
    Example[
      {Options,ImageSample,"Specify if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        ImageSample->False,
        Output -> Options
      ];
      Lookup[options,ImageSample],
      False,
      Variables:>{options}
    ],
    Example[
      {Options,SamplesInStorageCondition,"Specify The non-default conditions under which any samples going into this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition:"},
      options=ExperimentSupercriticalFluidChromatography[
        {Object[Sample, "ExperimentSFC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentSFC Test Sample 3" <> $SessionUUID]},
        SamplesInStorageCondition->AmbientStorage,
        Output -> Options
      ];
      Lookup[options,SamplesInStorageCondition],
      AmbientStorage,
      Variables:>{options}
    ]
  },
  (* without this, telescope crashes and the test fails *)
  HardwareConfiguration->HighRAM,
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    ClearMemoization[];

    (*module for deleting created objects*)
    Module[{objects, existingObjects},
      objects={
        Object[Sample,"ExperimentSFC Test Sample 1" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Test Sample 2" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Test Sample 3" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Test Sample 4" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Test Sample 5 (high recovery vial)" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Large Test Sample 1" <> $SessionUUID],
        Object[Sample,"Test sample for invalid container for ExperimentSFC tests" <> $SessionUUID],
        Object[Container,Plate,"Test plate 1 for ExperimentSFC tests" <> $SessionUUID],
        Object[Container,Plate,"Test plate 2 for ExperimentSFC tests" <> $SessionUUID],
        Object[Container,Vessel,"Test large container 1 for ExperimentSFC tests" <> $SessionUUID],
        Object[Container, Vessel, "Test invalid container 1 for ExperimentSFC tests" <> $SessionUUID],
        Object[Container, Vessel, "Test high-recovery container for ExperimentSFC tests" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 2" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 3" <> $SessionUUID],
        Object[Protocol,SupercriticalFluidChromatography,"My particular ExperimentSupercriticalFluidChromatography protocol" <> $SessionUUID]
      };

      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]

    ];
    (*module for ecreating objects*)
    Module[{containerPackets,samplePackets,gradientOne,gradientTwo,gradientPackets},

      containerPackets = {
        Association[
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
          Name -> "Test plate 1 for ExperimentSFC tests" <> $SessionUUID,
          Site -> Link[$Site]
        ],
        Association[
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
          Name -> "Test plate 2 for ExperimentSFC tests" <> $SessionUUID,
          Site -> Link[$Site]
        ],
        Association[
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects],
          Name -> "Test large container 1 for ExperimentSFC tests" <> $SessionUUID,
          Site -> Link[$Site]
        ],
        Association[
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
          Name -> "Test invalid container 1 for ExperimentSFC tests" <> $SessionUUID,
          Site -> Link[$Site]
        ],
        Association[
          Type -> Object[Container, Vessel],
          Model -> Link[Model[Container, Vessel,"1mL HPLC Vial (total recovery)"], Objects],
          Name -> "Test high-recovery container for ExperimentSFC tests" <> $SessionUUID,
          Site -> Link[$Site]
        ]
      };

      (*Gradient format -Time, CO2Composition, CosolventAComposition, CosolventBComposition, CosolventCComposition, CosolventDComposition, BackPressure, FlowRate*)

      gradientOne={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

	    gradientTwo={
        {0 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {4 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {4.1 Minute, 80 Percent, 0 Percent, 20 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 0 Percent, 40 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      gradientPackets={
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientOne,
          CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFC Test Gradient Object 1" <> $SessionUUID
        ],
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientTwo,
          CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFC Test Gradient Object 2" <> $SessionUUID
        ],
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientOne,
		      CosolventA-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventB->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFC Test Gradient Object 3" <> $SessionUUID
        ]
      };

      Upload[Join[containerPackets,gradientPackets]];

      samplePackets = UploadSample[
        {
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],
          Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]
        },
        {
          {"A1",Object[Container,Plate,"Test plate 1 for ExperimentSFC tests" <> $SessionUUID]},
          {"A2",Object[Container,Plate,"Test plate 1 for ExperimentSFC tests" <> $SessionUUID]},
          {"A3",Object[Container,Plate,"Test plate 1 for ExperimentSFC tests" <> $SessionUUID]},
          {"A1",Object[Container,Plate,"Test plate 2 for ExperimentSFC tests" <> $SessionUUID]},
          {"A1",Object[Container,Vessel,"Test large container 1 for ExperimentSFC tests" <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test invalid container 1 for ExperimentSFC tests" <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test high-recovery container for ExperimentSFC tests" <> $SessionUUID]}
        },
        InitialAmount ->
            {
              500 Microliter,
              500 Microliter,
              500 Microliter,
              500 Microliter,
              200 Milliliter,
              2000 Microliter,
              1000 Microliter
            },
        Name->{
          "ExperimentSFC Test Sample 1" <> $SessionUUID,
          "ExperimentSFC Test Sample 2" <> $SessionUUID,
          "ExperimentSFC Test Sample 3" <> $SessionUUID,
          "ExperimentSFC Test Sample 4" <> $SessionUUID,
          "ExperimentSFC Large Test Sample 1" <> $SessionUUID,
          "Test sample for invalid container for ExperimentSFC tests" <> $SessionUUID,
          "ExperimentSFC Test Sample 5 (high recovery vial)" <> $SessionUUID
        },
        Upload->False
      ];

      Upload[samplePackets];

      (*sever the link to the model*)
      Upload[
        {
          Association[
            Object -> Object[Sample,"ExperimentSFC Test Sample 1" <> $SessionUUID],
            Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
          ],
          Association[
            Object -> Object[Sample,"ExperimentSFC Test Sample 4" <> $SessionUUID],
            Model -> Null
          ]
        }
      ];

    ]

  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    (*constant false positive error on Manifold tests. please take out when that's fixed*)
    If[MatchQ[$OperatingSystem, "Unix"], On[Download::ObjectDoesNotExist]];
    Module[{objects, existingObjects},
      objects={
        Object[Sample,"ExperimentSFC Test Sample 1" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Test Sample 2" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Test Sample 3" <> $SessionUUID],
        Object[Sample,"ExperimentSFC Large Test Sample 1" <> $SessionUUID],
        Object[Container,Plate,"Test plate 1 for ExperimentSFC tests" <> $SessionUUID],
        Object[Container,Vessel,"Test large container 1 for ExperimentSFC tests" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 1" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 2" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFC Test Gradient Object 3" <> $SessionUUID],
        Object[Protocol,SupercriticalFluidChromatography,"My particular ExperimentSupercriticalFluidChromatography protocol" <> $SessionUUID]
      };

      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]

    ]
  ),
  Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];


(* ::Subsubsection:: *)
(*ExperimentSupercriticalFluidChromatographyOptions*)

DefineTests[
  ExperimentSupercriticalFluidChromatographyOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentSupercriticalFluidChromatographyOptions[Object[Sample,"ExperimentSFCOptions Test Sample 1" <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentSupercriticalFluidChromatographyOptions[Object[Sample,"ExperimentSFCOptions Test Sample 3" <> $SessionUUID]],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentSupercriticalFluidChromatographyOptions[Object[Sample,"ExperimentSFCOptions Test Sample 1" <> $SessionUUID],OutputFormat->List],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    ClearMemoization[];
    $CreatedObjects={};

    (*constant false positive error on Manifold tests. please take out when that's fixed*)
    If[MatchQ[$OperatingSystem, "Unix"], Off[Download::ObjectDoesNotExist]];
    (*module for deleting created objects*)
    Module[{objects, existingObjects},
      objects={
        Object[Container, Bench,  "Test bench for ExperimentSFCOptions tests"<> $SessionUUID],
        Object[Sample,"ExperimentSFCOptions Test Sample 1" <> $SessionUUID],
        Object[Sample,"ExperimentSFCOptions Test Sample 2" <> $SessionUUID],
        Object[Sample,"ExperimentSFCOptions Test Sample 3" <> $SessionUUID],
        Object[Container,Plate,"Test plate 1 for ExperimentSFCOptions tests" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCOptions Test Gradient Object 1" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCOptions Test Gradient Object 2" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCOptions Test Gradient Object 3" <> $SessionUUID]
      };

      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]

    ];
    (*module for creating objects*)
    Module[{testBench,samplePackets,gradientOne,gradientTwo,gradientPackets},
    Block[{$DeveloperUpload = True},

      (* Create a test bench *)
      testBench = Upload[<|
        Type -> Object[Container, Bench],
        Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
        Name -> "Test bench for ExperimentSFCOptions tests"<> $SessionUUID,
        Site -> Link[$Site]
      |>];

      UploadSample[Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        {"Work Surface", testBench},
        Name -> "Test plate 1 for ExperimentSFCOptions tests" <> $SessionUUID
      ];

      (*Gradient format -Time, CO2Composition, CosolventAComposition, CosolventBComposition, CosolventCComposition, CosolventDComposition, BackPressure, FlowRate*)

      gradientOne={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      gradientTwo={
        {0 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {4 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {4.1 Minute, 80 Percent, 0 Percent, 20 Percent, 10 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 0 Percent, 40 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      gradientPackets={
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientOne,
          CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFCOptions Test Gradient Object 1" <> $SessionUUID
        ],
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientTwo,
          CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFCOptions Test Gradient Object 2" <> $SessionUUID
        ],
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientOne,
          CosolventA-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventB->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFCOptions Test Gradient Object 3" <> $SessionUUID
        ]
      };

      Upload[gradientPackets];

      samplePackets = UploadSample[
        {Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
        {{"A1",Object[Container,Plate,"Test plate 1 for ExperimentSFCOptions tests" <> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentSFCOptions tests" <> $SessionUUID]},{"A3",Object[Container,Plate,"Test plate 1 for ExperimentSFCOptions tests" <> $SessionUUID]}},
        InitialAmount -> 500 Microliter,
        Name->{
          "ExperimentSFCOptions Test Sample 1" <> $SessionUUID,
          "ExperimentSFCOptions Test Sample 2" <> $SessionUUID,
          "ExperimentSFCOptions Test Sample 3" <> $SessionUUID
        },
        Upload->False
      ];

      Upload[samplePackets];

      Upload[<|Object->Object[Sample,"ExperimentSFCOptions Test Sample 3" <> $SessionUUID],Status->Discarded|>];

      ];
    ];

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
(*ValidExperimentSupercriticalFluidChromatographyQ*)

DefineTests[
  ValidExperimentSupercriticalFluidChromatographyQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentSupercriticalFluidChromatographyQ[Object[Sample,"ExperimentSFCValidQ Test Sample 1" <> $SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentSupercriticalFluidChromatographyQ[Object[Sample,"ExperimentSFCValidQ Test Sample 3" <> $SessionUUID]],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentSupercriticalFluidChromatographyQ[Object[Sample,"ExperimentSFCValidQ Test Sample 1" <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentSupercriticalFluidChromatographyQ[Object[Sample,"ExperimentSFCValidQ Test Sample 1" <> $SessionUUID],Verbose->True],
      True
    ]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    ClearMemoization[];

    (*module for deleting created objects*)
    Module[{objects, existingObjects},
      objects={
        Object[Sample,"ExperimentSFCValidQ Test Sample 1" <> $SessionUUID],
        Object[Sample,"ExperimentSFCValidQ Test Sample 2" <> $SessionUUID],
        Object[Sample,"ExperimentSFCValidQ Test Sample 3" <> $SessionUUID],
        Object[Container,Plate,"Test plate 1 for ExperimentSFCValidQ tests" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCValidQ Test Gradient Object 1" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCValidQ Test Gradient Object 2" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCValidQ Test Gradient Object 3" <> $SessionUUID]
      };

      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]

    ];
    (*module for ecreating objects*)
    Module[{containerPackets,samplePackets,gradientOne,gradientTwo,gradientPackets},

      containerPackets = {
        Association[
          Type -> Object[Container, Plate],
          Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
          Name -> "Test plate 1 for ExperimentSFCValidQ tests" <> $SessionUUID,
          Site -> Link[$Site]
        ]
      };

      (*Gradient format -Time, CO2Composition, CosolventAComposition, CosolventBComposition, CosolventCComposition, CosolventDComposition, BackPressure, FlowRate*)

      gradientOne={
        {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      gradientTwo={
        {0 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {4 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {4.1 Minute, 80 Percent, 0 Percent, 20 Percent, 10 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {5 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {7 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
        {10 Minute, 60 Percent, 0 Percent, 40 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
      };

      gradientPackets={
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientOne,
          CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFCValidQ Test Gradient Object 1" <> $SessionUUID
        ],
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientTwo,
          CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFCValidQ Test Gradient Object 2" <> $SessionUUID
        ],
        Association[
          Type->Object[Method,SupercriticalFluidGradient],
          Replace[Gradient]->gradientOne,
          CosolventA-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
          CosolventB->Link[Model[Sample, "Methanol - LCMS grade"]],
          CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
          CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
          Name->"ExperimentSFCValidQ Test Gradient Object 3" <> $SessionUUID
        ]
      };

      Upload[Join[containerPackets,gradientPackets]];

      samplePackets = UploadSample[
        {Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
        {{"A1",Object[Container,Plate,"Test plate 1 for ExperimentSFCValidQ tests" <> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentSFCValidQ tests" <> $SessionUUID]},{"A3",Object[Container,Plate,"Test plate 1 for ExperimentSFCValidQ tests" <> $SessionUUID]}},
        InitialAmount -> 500 Microliter,
        Name->{
          "ExperimentSFCValidQ Test Sample 1" <> $SessionUUID,
          "ExperimentSFCValidQ Test Sample 2" <> $SessionUUID,
          "ExperimentSFCValidQ Test Sample 3" <> $SessionUUID
        },
        Upload->False
      ];

      Upload[samplePackets];

      Upload[<|Object->Object[Sample,"ExperimentSFCValidQ Test Sample 3" <> $SessionUUID],Status->Discarded,DeveloperObject->True|>]

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
(*ExperimentSupercriticalFluidChromatographyPreview*)

DefineTests[
  ExperimentSupercriticalFluidChromatographyPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentSupercriticalFluidChromatography:"},
      ExperimentSupercriticalFluidChromatographyPreview[Object[Sample,"ExperimentSFCPreview Test Sample 1" <> $SessionUUID]],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentSupercriticalFluidChromatographyOptions:"},
      ExperimentSupercriticalFluidChromatographyOptions[Object[Sample,"ExperimentSFCPreview Test Sample 1" <> $SessionUUID]],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentSupercriticalFluidChromatographyQ:"},
      ValidExperimentSupercriticalFluidChromatographyQ[Object[Sample,"ExperimentSFCPreview Test Sample 1" <> $SessionUUID]],
      True
    ]
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    ClearMemoization[];
    $CreatedObjects={};

    (*module for deleting created objects*)
    Module[{objects, existingObjects},
      objects={
        Object[Container, Bench,  "Test bench for ExperimentSFCPreview tests"<> $SessionUUID],
        Object[Sample,"ExperimentSFCPreview Test Sample 1" <> $SessionUUID],
        Object[Sample,"ExperimentSFCPreview Test Sample 2" <> $SessionUUID],
        Object[Sample,"ExperimentSFCPreview Test Sample 3" <> $SessionUUID],
        Object[Container,Plate,"Test plate 1 for ExperimentSFCPreview tests" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCPreview Test Gradient Object 1" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCPreview Test Gradient Object 2" <> $SessionUUID],
        Object[Method,SupercriticalFluidGradient,"ExperimentSFCPreview Test Gradient Object 3" <> $SessionUUID]
      };

      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]

    ];
    (*module for creating objects*)
    Module[{testBench,samplePackets,gradientOne,gradientTwo,gradientPackets},
      Block[{$DeveloperUpload = True},

        (* Create a test bench *)
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test bench for ExperimentSFCPreview tests"<> $SessionUUID,
          Site -> Link[$Site]
        |>];

        UploadSample[Model[Container, Plate, "96-well 2mL Deep Well Plate"],
          {"Work Surface", testBench},
          Name -> "Test plate 1 for ExperimentSFCPreview tests" <> $SessionUUID
        ];

        (*Gradient format -Time, CO2Composition, CosolventAComposition, CosolventBComposition, CosolventCComposition, CosolventDComposition, BackPressure, FlowRate*)

        gradientOne={
          {0 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {3 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {3.1 Minute, 80 Percent, 20 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {5 Minute, 97 Percent, 3 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {7 Minute, 90 Percent, 10 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {10 Minute, 60 Percent, 40 Percent, 0 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
        };

        gradientTwo={
          {0 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {4 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {4.1 Minute, 80 Percent, 0 Percent, 20 Percent, 10 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {5 Minute, 97 Percent, 0 Percent, 3 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {7 Minute, 90 Percent, 0 Percent, 10 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute},
          {10 Minute, 60 Percent, 0 Percent, 40 Percent, 0 Percent, 0 Percent, 2000 PSI, 3 Milliliter/Minute}
        };

        gradientPackets={
          Association[
            Type->Object[Method,SupercriticalFluidGradient],
            Replace[Gradient]->gradientOne,
            CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
            CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
            CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
            CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
            Name->"ExperimentSFCPreview Test Gradient Object 1" <> $SessionUUID
          ],
          Association[
            Type->Object[Method,SupercriticalFluidGradient],
            Replace[Gradient]->gradientTwo,
            CosolventA->Link[Model[Sample, "Methanol - LCMS grade"]],
            CosolventB-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
            CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
            CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
            Name->"ExperimentSFCPreview Test Gradient Object 2" <> $SessionUUID
          ],
          Association[
            Type->Object[Method,SupercriticalFluidGradient],
            Replace[Gradient]->gradientOne,
            CosolventA-> Link@(Model[Sample, "Heptane (HPLC grade)"]),
            CosolventB->Link[Model[Sample, "Methanol - LCMS grade"]],
            CosolventC-> Link@(Model[Sample, "Isopropanol, LCMS Grade"]),
            CosolventD-> Link@(Model[Sample, "Acetonitrile, HPLC Grade"]),
            Name->"ExperimentSFCPreview Test Gradient Object 3" <> $SessionUUID
          ]
        };

        Upload[gradientPackets];

        samplePackets = UploadSample[
          {Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
          {{"A1",Object[Container,Plate,"Test plate 1 for ExperimentSFCPreview tests" <> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentSFCPreview tests" <> $SessionUUID]},{"A3",Object[Container,Plate,"Test plate 1 for ExperimentSFCPreview tests" <> $SessionUUID]}},
          InitialAmount -> 500 Microliter,
          Name->{
            "ExperimentSFCPreview Test Sample 1" <> $SessionUUID,
            "ExperimentSFCPreview Test Sample 2" <> $SessionUUID,
            "ExperimentSFCPreview Test Sample 3" <> $SessionUUID
          },
          Upload->False
        ];

        Upload[samplePackets];

        Upload[<|Object->Object[Sample,"ExperimentSFCPreview Test Sample 3" <> $SessionUUID],Status->Discarded|>]

      ];
    ];

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
