(*The standalone app LabelPeaks does not work with CommandBuilder.
  Plans are to move this functionality into interactive AnalyzePeaksPreview *)
Options[LabelPeaks]={ReferenceField->Automatic};


LabelPeaks::CorruptedObject = "The fields Position and Height are of unequal lengths: `1` and `2` respectively.";
LabelPeaks::UnknownDataType = "Field `1` of reference data object is of unknown Head = `2`.";

LabelPeaks::InvalidInput = "Input `1` is not an Object[Analysis,Peaks], or an Object[Data] with analyzed peaks.";
LabelPeaks::NoPeaksPossible = "Input type `1` does not support peaks information.";
LabelPeaks::NoPeaksAnalysis = "No peaks information found associated with `1`. Run AnalyzePeaks on input object to identify and analyze peaks.";
LabelPeaks::NoProtocol = "As of this version, LabelPeaks does not support labeling peaks in Object[Protocol]."
LabelPeaks::InvalidField = "Option value ReferenceField->`2` for `1` is expected to be Automatic or one of `3` containing data with associated peaks information.";
LabelPeaks::NoPeaks = "Zero peaks are recorded in `1`. There is nothing to label: exiting LabelPeaks.";

(*We use RuleCondition to return the input in case anything fails internally.*)
LabelPeaks[obj_, opts:OptionsPattern[]]:=
    RuleCondition[Catch[
        iDispatchLabelPeaks[
            obj
            ,OptionValue[ReferenceField]]
        ,"LabelPeaks",If[MatchQ[#,$Failed],Fail,#]&]
    ];




(*OVERLOAD 1:  User inputs Object[Analysis,Peaks] => Load applet on object*)
iDispatchLabelPeaks[obj: ObjectP[Object[Analysis,Peaks]], field_] := iLabelPeaks[obj];

(*OVERLOAD 2: User inputs Object[Data] => look for associated peak analysis object*)
iDispatchLabelPeaks[obj: ObjectP[Object[Data]], field_] :=
    If[(*First check that input Object[Data] subtype can be analyzed by AnalyzePeaks at all*)
        MatchQ[obj,ObjectP[LegacySLL`Private`peaksLookup[[All, 1]]]]
        ,Which[
        (*User put in no Field: look in all fields that can potentially contain Object[Analysis, Peaks] *)
        field===Automatic
        ,With[{peaksAnalysisList=Quiet[Flatten@DeleteCases[Download[obj, Evaluate[Lookup[LegacySLL`Private`peaksLookup,obj[Type]][[All, 2]]] ],Null|$Failed]]}
            ,
            If[Length[peaksAnalysisList]==0
                ,Message[LabelPeaks::NoPeaksAnalysis,obj];Throw[Fail,"LabelPeaks"]
                ,iLabelPeaks[Extract[peaksAnalysisList,Ordering[DeleteCases[Download[peaksAnalysisList, DateCreated],Null|$Failed], -1]][Object]]
            ]
        ]

        (*User put in a specific Field to analyze*)
        ,MemberQ[Lookup[LegacySLL`Private`peaksLookup,obj[Type]][[All, 1]],field]
        ,With[{peaksAnalysisList=Quiet[Download[obj,Evaluate@Lookup[Lookup[LegacySLL`Private`peaksLookup,obj[Type]],field]]]}
            ,If[MatchQ[peaksAnalysisList,{___,ObjectP[Object[Analysis,Peaks]]}]
                (*If there is a link to a Object[Analysis, Peaks] => Load applet on link*)
                ,iLabelPeaks[Last[peaksAnalysisList][Object]]
                (*Otherwise no peaks analysis has been done, issue an error and exit.*)
                ,Message[LabelPeaks::NoPeaksAnalysis,HoldForm[obj[field]]];Throw[Fail,"LabelPeaks"]
            ]
        ]

        (*User put in some other field, or complete rubbish*)
        ,True
        ,Message[LabelPeaks::InvalidField,obj,field,Lookup[LegacySLL`Private`peaksLookup,obj[Type]][[All, 1]]];Throw[Fail,"LabelPeaks"]
    ]
        ,Message[LabelPeaks::NoPeaksPossible,obj[Type]];Throw[Fail,"LabelPeaks"]
    ];

(*OVERLOAD 3: User puts in Object[Protocol]*)
iDispatchLabelPeaks[obj: ObjectP[Object[Protocol]], field_] := (Message[LabelPeaks::NoProtocol];Throw[Fail,"LabelPeaks"]);

(*OVERLOAD 4: BAD INPUT*)
iDispatchLabelPeaks[obj_, _] := (Message[LabelPeaks::InvalidInput,obj];Throw[Fail,"LabelPeaks"]);



iLabelPeaks[obj:ObjectP[Object[Analysis,Peaks]]]:=
    iCreateDialogCell[
        Column[{
            (*addPeaksInteractiveElements places the labels on top of the base graph.  Used in AnalyzePeaksPreview*)
            addPeaksInteractiveElements[PlotObject[obj], {obj}, {Download[obj,ResolvedOptions]}]
            (*Draw the "Cancel"/"Accept Labels" buttons just below the graph*)
            ,Row[{
                iDialogCellButton["Cancel",obj]
                ,Spacer[25]
                ,iDialogCellButton["Accept labels",
                    (*Clicking on "Accept labels" uploads the updated Object[Analysis].*)
                    Upload[
                        <|Object->obj,
                            Replace[PeakLabel]->PreviewValue[analyzePeaks$dvar, PeakLabels],
                            Replace[PeakAssignment]->Link/@labelPeaks$ObjectData["PeakAssignmentField"]
                        |>
                    ]
                ]
            }]}
            ,Alignment->Right
        ]
    ]
(*iCreateDialogCell creates the cell containing the LabelPeaks interactive graphics.
It also puts the main evaluation kernel on hold until the application is terminated or aborted.*)
iCreateDialogCell[content_]:=
    Block[{$PlotPeaksDone=False,$PlotPeaksReturnValue=Null,$NewCell},
        CellPrint[Cell[ExpressionCell[
            ToBoxes[DynamicWrapper[content,$NewCell=EvaluationCell[],DestroyAfterEvaluation -> True]]
        ], "Output"]];

        CheckAbort[While[Not[$PlotPeaksDone], Pause[0.1]], NotebookDelete[$NewCell];$PlotPeaksReturnValue=$Aborted];
        NotebookDelete[$NewCell];
        $PlotPeaksReturnValue
    ];

SetAttributes[iDialogCellButton,HoldRest];

iDialogCellButton[text_,action_]:=Button[text, $PlotPeaksDone=True; $PlotPeaksReturnValue=action];
