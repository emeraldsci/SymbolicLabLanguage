DefineUsage[PlotDesignOfExperiment,{
    BasicDefinitions -> {
        {"PlotDesignOfExperiment[doeAnalysis]","doePlot","Plots the objective function values and corresponding data objects for the given DOE analysis."},
        {"PlotDesignOfExperiment[doeScript]","doePlot","Plots the most recent analysis of the diven DOE script."}
    },
    Input:>{
        {"doeObject", ObjectP[Object[Analysis,DesignOfExperiment]], "An analysis object generated by a DesignOfExperiment call."},
        {"doeObject", ObjectP[Object[DesignOfExperiment]], "A DesignOfExperiment object generated by a DesignOfExperiment call."}
    },
    Output:>{
        {"doePlot",_Panel,"A figure showing the objective values along with their corresponding data plots."}
    },
    Author-> {"scicomp", "brad"},
    SeeAlso->{"DesignOfExperiment","AnalyzeDesignOfExperiment","RunScriptDesignOfExperiment"}
}
]