(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Label Peaks Tests*)


DefineTests[LabelPeaks,{
    Example[
        {Basic,"Label peaks in chromatography data:"}
        ,
        LabelPeaks[Object[Analysis, Peaks, "id:54n6evLDxArv"]]
        ,
        _Column
        ,
        Stubs:>{Analysis`Private`iCreateDialogCell[content_]:=content}
    ],

    Test["helper function -- assemblePeakXYCoordinates:",
        assemblePeakXYCoordinates[{1.98}, {110.58},
            Piecewise[{{Piecewise[{{0.248, 1.82 <= #1 <= 2.44}}, Indeterminate],
                0. <= #1 <= 3.01}}, Indeterminate] &, Object[Data, Chromatography]],
        {{1.98`, 110.828`}}
    ],

    Test["helper function -- getModelNameListsFromSamplesIn:",
        getModelNameListsFromSamplesIn[
            {
                {
                    {Quantity[2., "Milligrams"/"Liters"], Link[Model[Molecule, "id:E8zoYvN6m61A"], "01G6nvW8pJl1"]},
                    {Quantity[90., IndependentUnit["VolumePercent"]], Link[Model[Molecule, "id:vXl9j57PmP5D"], "1ZA60vWK48Xa"]}
                }
            }
        ],
        {{"Caffeine",Model[Molecule,"id:E8zoYvN6m61A"]},{"Water",Model[Molecule,"id:vXl9j57PmP5D"]}}
    ],

    Test["helper function -- getPeaksDataFromObject, from an object in Constellation:",
        getPeaksDataFromObject[Object[Analysis, Peaks, "id:54n6evLDxArv"]],
        KeyValuePattern[{
            "PeakPoints" -> {{1.98`, 110.8394`}},
            "PeakPositionTolerance" -> {{1.98`, _}},
            "CompositionNameModelList" ->
                {
                    {"Caffeine", Model[Molecule, "id:E8zoYvN6m61A"]},
                    {"Water", Model[Molecule, "id:vXl9j57PmP5D"]}
                },
            "PeakAssignmentField" -> {Null}}]
    ],

    Test["helper function -- getPeaksDataFromObject, packet arising from raw XY data:",
        getPeaksDataFromObject[
            <|
            Type -> Object[Analysis, Peaks],
            Reference -> {},
            Name -> Null,
            Position -> {},
            Height -> {},
            PeakRangeStart -> {},
            PeakRangeEnd -> {},
            BaselineFunction -> (Piecewise[{{2., 1. <= # <= 3.}}, Indeterminate]& ),
            PeakAssignment -> Null
        |>],
        KeyValuePattern[
            {
                "PeakPoints" -> {},
                "PeakPositionTolerance" -> {},
                "CompositionNameModelList" -> {},
                "PeakAssignmentField" -> {}
            }
        ]
    ],

    Example[
        {Basic,"Label peaks in PAGE data:"}
        ,
        LabelPeaks[AnalyzePeaks[Object[Data, PAGE, "id:vXl9j575r44Z"]]]
        ,
        _Column
        ,
        Stubs:>{Analysis`Private`iCreateDialogCell[content_]:=content}
    ],

    Example[
        {Basic,"Label peaks in mass spectrometry data:"}
        ,
        LabelPeaks[Object[Data, MassSpectrometry, "id:Z1lqpMzB5jRL"]]
        ,
        _Column
        ,
        Stubs:>{Analysis`Private`iCreateDialogCell[content_]:=content}
    ],

    Test["Issue an error if ReferenceField does not point to a valid field belonging to object:",
        LabelPeaks[Object[Data, MassSpectrometry, "id:Z1lqpMzB5jRL"], ReferenceField -> NMRSpectrumPeaksAnalyses],
        LabelPeaks[Object[Data, MassSpectrometry, "id:Z1lqpMzB5jRL"], ReferenceField -> NMRSpectrumPeaksAnalyses],
        Messages:>{LabelPeaks::InvalidField}
    ],

    Test["Issue an error if ReferenceField does not point to a field with existing peaks analysis:",
        LabelPeaks[Object[Data, Chromatography, "id:54n6evLDx4WY"], ReferenceField -> QuaternaryFluorescence],
        LabelPeaks[Object[Data, Chromatography, "id:54n6evLDx4WY"], ReferenceField -> QuaternaryFluorescence],
        Messages:>{LabelPeaks::NoPeaksAnalysis}
    ]

}];


(* ::Section:: *)
(*End Test Package*)
