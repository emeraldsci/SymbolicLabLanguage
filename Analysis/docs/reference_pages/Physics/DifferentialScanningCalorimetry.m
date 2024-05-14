
DefineUsageWithCompanions[AnalyzeDifferentialScanningCalorimetry,
{
    BasicDefinitions -> {
        {
            Definition -> {"AnalyzeDifferentialScanningCalorimetry[DataObjects]","AnalysisObjects"},
            Description -> "finds the onset temperature, melting temperatures, and any other relevant thermodynamic parameters.",
            Inputs :> {
                {
                    InputName -> "DataObjects",
                    Description -> "A list of data objects of the type Object[Data,DifferentialScanningCalorimetry] that are to be analyzed.",
                    Widget -> Adder[Widget[
                        Type->Object,
                        Pattern:>ObjectP[Object[Data,DifferentialScanningCalorimetry]],
                        ObjectTypes -> {Object[Data,DifferentialScanningCalorimetry]}
                    ]]
                }
            },
            Outputs :> {
                {
                    OutputName -> "AnalysisObjects",
                    Description -> "The object references that point to the analyzed data in Constellation.",
                    Pattern :> ObjectP[Object[Data,DifferentialScanningCalorimetry]]
                }
            }
        }
    },
    SeeAlso -> {
        "PlotDifferentialScanningCalorimetry",
        "ExperimentDifferentialScanningCalorimetry"
    },
    Author -> {
        "tommy.harrelson"
    }
}];
