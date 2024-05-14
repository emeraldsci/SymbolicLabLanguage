DOETestPlotP = HoldPattern[DynamicModule[_List, _EventHandler, __]];

DefineTests[PlotDesignOfExperiment,{
    Example[{Basic,"Plot the objective function values and corresponding data objects for a one-dimensional optimization:"},
        PlotDesignOfExperiment[OneDAnalysis],
        DOETestPlotP
    ],
    Example[{Basic,"Plot the objective function values and corresponding data objects for a two-dimensional optimization:"},
        PlotDesignOfExperiment[TwoDAnalysis],
        DOETestPlotP
    ],
    Example[{Basic,"Plot the objective function values and corresponding data objects for an uneven two-dimensional optimization:"},
        PlotDesignOfExperiment[UnevenTwoDAnalysis],
        DOETestPlotP
    ]
},
SetUp :> {
    hplcProtocol1 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 1 Milliliter/Minute, ColumnTemperature -> 30 Celsius];
    hplcProtocol2 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 2 Milliliter/Minute, ColumnTemperature -> 30 Celsius];
    hplcProtocol3 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 5 Milliliter/Minute, ColumnTemperature -> 30 Celsius];
    hplcProtocol4 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 2 Milliliter/Minute, ColumnTemperature -> 40 Celsius];
    hplcProtocol5 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 5 Milliliter/Minute, ColumnTemperature -> 40 Celsius];

    OneDAnalysis = AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2, hplcProtocol3},
    ParameterSpace -> {FlowRate}, ObjectiveFunction -> AreaOfTallestPeak];

    TwoDAnalysis = AnalyzeDesignOfExperiment[{hplcProtocol2, hplcProtocol3, hplcProtocol4, hplcProtocol5},
    ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak];

    UnevenTwoDAnalysis = AnalyzeDesignOfExperiment[{hplcProtocol2, hplcProtocol3, hplcProtocol4, hplcProtocol5},
    ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak];
}
]
