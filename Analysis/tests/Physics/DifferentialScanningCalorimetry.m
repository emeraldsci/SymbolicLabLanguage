
(* Define tests for AnalyzeDifferentialScanningCalorimetry *)
DefineTestsWithCompanions[
    AnalyzeDifferentialScanningCalorimetry,
    {
        (* ----- Basic tests ----- *)
        Example[{Basic, "Analyze the thermodynamic parameters of a differential scanning calorimetry data object:"},
            AnalyzeDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"]],
            ObjectP[Object[Analysis, DifferentialScanningCalorimetry]]
        ],
        Example[{Basic, "Analyze the thermodynamic parameters of a list of differential scanning calorimetry data objects:"},
            AnalyzeDifferentialScanningCalorimetry[{Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"], Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"]}],
            {ObjectP[Object[Analysis, DifferentialScanningCalorimetry]], ObjectP[Object[Analysis, DifferentialScanningCalorimetry]]}
        ],
        Example[{Basic, "Analyze the thermodynamic parameters of a differential scanning calorimetry protocol:"},
            AnalyzeDifferentialScanningCalorimetry[Object[Protocol, DifferentialScanningCalorimetry, "id:6V0npvmNR0rG"]],
            {ObjectP[Object[Analysis, DifferentialScanningCalorimetry]]..}
        ],

        (* ----- Options tests ----- *)
        Example[{Options, BaselineFeatureWidth, "Control the features that are picked up by the nonlinear baseline by tuning the BaselineFeatureWidth option:"},
            AnalyzeDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"], BaselineFeatureWidth->15],
            ObjectP[Object[Analysis, DifferentialScanningCalorimetry]]
        ],
        Example[{Options, SmoothingRadius, "Tell the analysis to ignore peaks due to noise by changing the SmoothingRadius option:"},
            AnalyzeDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"], SmoothingRadius->10],
            ObjectP[Object[Analysis, DifferentialScanningCalorimetry]]
        ],
        Example[{Options, Threshold, "Change the threshold to ignore impurity melting peaks to correctly determine the onset of melting of the desired analyte:"},
            AnalyzeDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"], Threshold->0.005],
            ObjectP[Object[Analysis, DifferentialScanningCalorimetry]]
        ]
    },
    Variables :> {dscDataObject, dscDataObject1, dscDataObject2, dscProtocol},
    SymbolSetUp :> (
        dscDataObject = Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"];
        dscDataObject1 = Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"];
        dscDataObject2 = Object[Data, DifferentialScanningCalorimetry, "id:dORYzZJ7vW75"];
        dscProtocol = Object[Protocol, DifferentialScanningCalorimetry, "id:6V0npvmNR0rG"];
    )
];
