(*addPeaksInteractiveElements wraps the graphics produced by AnalyzePeaksPreview and adds additional label buttons to
the Epilog.  It also makes some on-the-fly surgical operations to EventHandlers to make Zoomable work with the buttons *)
addPeaksInteractiveElements[baseGraphic_, peaksPackets_,resolvedOptions_]:=
    Module[{newGraphicsObj,labelButtonArray, optionValuePeakLabels, optionValuePeakAssignments},

        If[Length[peaksPackets]>1,
            labelPeaks$ObjectData = getPeaksDataFromObject[peaksPackets];
            optionValuePeakLabels = Lookup[resolvedOptions,PeakLabels];
            optionValuePeakAssignments = Lookup[resolvedOptions,PeakAssignments];
            ,

            labelPeaks$ObjectData = getPeaksDataFromObject[First@peaksPackets];
            optionValuePeakLabels = Lookup[First@resolvedOptions,PeakLabels];
            optionValuePeakAssignments = Lookup[First@resolvedOptions,PeakAssignments];
        ];

        (* ========= Collect data, and set up variables for use in CB ===========*)
        (*Get the resolved options from peaks analysis, and establish a Kernel symbol dvar for use by Command Builder*)
        analyzePeaks$dvar=SetupPreviewSymbol[
            AnalyzePeaks,
            Null,
            {
                PeakLabels->optionValuePeakLabels,
                PeakAssignments->optionValuePeakAssignments
                (*Additional options to be enabled for interactivity go here*)
            },
            PreviewSymbol->Null
        ];


        (* ========= Prepare Base Graphic ===========*)
        (*Prepare the base graphic by changing the epilogs and eventhandlers used in the plot.
         Otherwise, the interactivity does not work consistently.*)

        (*isZoomable tracks whether to turn off zoomable mechanism when mouse is over one of the labels.
          Without it, clicking on a label also triggers zoom out mechanism.
          Preferably isZoomable is a DynamicModule variable.*)
        isZoomable=True;

        (*Store the front-end box object for the graphic so that we can attach the custom dialog cell to it*)
        newGraphicsObj=DynamicWrapper[baseGraphic,$analyzePeaksPreviewBox=EvaluationBox[], SingleEvaluation->True];

        (*Inject isZoomable boolean into EventHandler*)
        newGraphicsObj=ReplaceAll[newGraphicsObj,EventHandler[body_,eventList_]:>(
            EventHandler[
                body
                (*Do not trigger zoomable mechanism if mouse is over one of the buttons*)
                ,eventList/.HoldPattern[RuleDelayed[event_, action_]] :> RuleDelayed[event, If[isZoomable, action]]
                (*Allow events to get passed down to the buttons*)
                ,PassEventsUp->False,PassEventsDown->True])];

        newGraphicsObj=ReplaceAll[newGraphicsObj,
            HoldPattern[
                (*Remove the redundant labels included as part of AnalyzePeaksPreview --
                    they will be supplied by the interactive buttons*)
                Rule[Epilog, stuff_]] :> (Epilog -> (stuff /. _Text :> Sequence[]))];

        (*Create the table of label buttons, one at each coordinate pair coord={x,y}*)
        labelButtonArray = MapIndexed[labelButton, Lookup[labelPeaks$ObjectData,"PeakPoints"], {-2}];

        (*
            Attach the label buttons in Epilog. Even though adding dynamic in Epilog is less stable, we do it for two reasons.
            1.  It is very challenging to add the buttons directly into the list of graphics primitives, which may be
                arbitrarily deep inside the newGraphicsObj expression.
            2.  Even after adding buttons to the graphics, the buttons do not to respond to mouse-clicks event-handlers.
                Because the zoomable eventhandler is wrapped around the whole Graphics object, any eventhandler buttons
                added to the Graphics (inside) will be intercepted by the outer eventhandler.
        *)

        If[TrueQ[$CCD],
            (*On CCD (MMA 12.2) new Zoomable is being used, which moves the Epilog into main graphics.
            So the option Epilog is absernt.*)
            With[{labelButtonArray=labelButtonArray},
                If[Length[resolvedOptions]===1,

                    (*Singleton*)
                    newGraphicsObj=ReplaceAll[newGraphicsObj,
                        Graphics[prims_, opts___] :> Graphics[Append[prims,labelButtonArray], opts]]
                    ,

                    (*Multiple, index matched*)
                    newGraphicsObj=newGraphicsObj/.SlideView[graphicsList_List]:>
                        SlideView[MapThread[
                            ReplaceAll[#1, Graphics[prims_, opts___] :> Graphics[prims, opts, Epilog->#2]]&,
                            {graphicsList,labelButtonArray}]]
                ]
            ],



                (*On CC (MMA 12.0) old Zoomable is being used.*)
                With[{labelButtonArray=labelButtonArray},
                    If[Length[resolvedOptions]===1,

                        (*Singleton*)
                         newGraphicsObj=ReplaceAll[newGraphicsObj,
                            HoldPattern[(Epilog->stuff_)]:>
                                Epilog->{stuff,
                                    labelButtonArray
                                    (*Additional preview elements go here*)
                                }]
                        ,

                        (*Multiple, index matched*)
                        newGraphicsObj=newGraphicsObj/.SlideView[graphicsList_List]:>
                            SlideView[MapThread[ReplaceAll[#1,
                                HoldPattern[(Epilog->stuff_)]:>
                                    (Epilog->{stuff,#2})]&,
                                {graphicsList,labelButtonArray}]]
                    ]
                ]
        ];


        newGraphicsObj
    ];

(*
    getPeaksDataFromObject extracts information from the peaks analysis packet needed to build the graphical interactivity.
    Input: Object[Analysis, Peaks] or packet
    Output: Association
*)

(*listable case (object or packet):  Map singleton case over each packet.  Then, combine the resulting list of
associations into a single association of values that are index-matched with the objects.*)
getPeaksDataFromObject[objs:{__Association}]:= Merge[getPeaksDataFromObject /@ objs, Identity];

(*singleton case.  Should be an Object[Analysis,Peaks] or packet*)
getPeaksDataFromObject[obj_]:=
    Module[{xPos,height,start,end,baselinefunction,peakPoints,peakAssignmentField,peakPositionTolerance,
        referenceObjType,compositionList,compositionNameModelList},

        (*Start by extracting the relevant peaks data from the packet/object*)
        {referenceObjType,compositionList,xPos,height,start,end,baselinefunction,peakAssignmentField}=
            Check[
                (*Quiet Download::Part because if there are no Reference then we can continue without offering
                Model[Molecule] -- all labels are custom labels.  In that case Download returns $Failed for those fields*)
                Quiet[
                    Download[obj,
                        {
                            Reference[[1]][Type],
                            Reference[[1]][SamplesIn][Composition],
                            Position,
                            Height,
                            PeakRangeStart,
                            PeakRangeEnd,
                            BaselineFunction,
                            PeakAssignment
                        }],
                    {Download::Part}
                ]
                ,Throw[$Failed,"LabelPeaks"]
            ];

        (*peakAssignmentField is used only if called from LabelPeaks*)
        peakAssignmentField=
            If[Length[xPos]===0,
                (*If there are no peaks, set assignments to empty lists*)
                {}
                ,
                (*otherwise take the current peakAssignmentField and pad it a list of Nulls indexed-matched with peaks*)
                PadRight[peakAssignmentField, Length[xPos],Null]
            ];

        (*Get the list of Models and their names from the SamplesIn field of the reference obj.
          These are needed to create the list of Model[Molecule] to choose from when assigning labels to the peaks.*)
        compositionNameModelList=getModelNameListsFromSamplesIn[compositionList];

        (*Assemble the (x,y) coordinates of all identified peaks*)
        (*The referenceObject type needs to be passed in so that the correct scaling function is determined.*)
        peakPoints=assemblePeakXYCoordinates[xPos, height, baselinefunction, referenceObjType];

        (*Store the position and their widths to facilitate filling out PeakAssignments option to AnalyzePeaks interactively.*)
        peakPositionTolerance=Transpose[{xPos, end-start}];

        (*Return the data*)
        <|
            "PeakPoints"->peakPoints,
            "PeakPositionTolerance"->peakPositionTolerance,
            "CompositionNameModelList"->compositionNameModelList,
            "PeakAssignmentField"->peakAssignmentField
        |>
    ];



(*assemblePeakXYCoordinates takes the peak xPos, height and baseline function and builds a list of x-y pairs
corresponding the x-y coordinates of the peaks.  referenceObjectType is used to apply scaling functions for special cases.*)

assemblePeakXYCoordinates[xPos_,height_,baselinefunction_,referenceObjectType_]:=Module[{peakPoints},
    (*Transpose[{xPos,height}] transforms it into a list of (x,y) coordinate pairs of the peaks.*)
    (*BUT, the Height field gives only the distance of the peak above the baseline function,
        and not the y-coordinate.  To get the (x,y) coordinate of the peaks, need to add the
        baseline values to each y-coordinate.*)
    peakPoints={#,baselinefunction[#]+#2}& @@@ Transpose[{xPos,height}];

    (* Scaling functions for special cases *)
    Switch[referenceObjectType,
        (*Object[Data,NMR] has a scaling function of -1 for its reference data.
            That means we have to negate x-coordinates of the peak points.*)
        Object[Data,NMR],
        {-#1, #2} & @@@  peakPoints,
        (*Object[Data,AgaroseGelElectrophoresis] has a scaling function of Log[10] for its reference data.
            That means we have to rescale x-coordinates of the peak points.*)
        Object[Data,AgaroseGelElectrophoresis],
        {Log10[#1], #2} & @@@ peakPoints,

        _,
        peakPoints
    ]
];

(*
getModelNameListsFromSamplesIn turns a compositionList of the form:
    {
        {
            {99.501VolumePercent,Link[Model[Molecule,"id:vXl9j57PmP5D"],"KBL5DVrO353J"]},
            {4.1765mM,Link[Model[Molecule,Oligomer,"id:1ZA60vL51z9w"],"jLq9jRx0k9k1"]},
            {2.62224mM,Link[Model[Molecule,Oligomer,"id:Z1lqpMzRZrnz"],"7X104WYNZ0ZA"]},
                ...
        },
        ...
    }
into a list of {"Molecule name", Model[...]} pairs of the form:
    {
        {"Water",Model[Molecule,"id:vXl9j57PmP5D"]},
        {"Glycine-Tyrosine",Model[Molecule,Oligomer,"id:1ZA60vL51z9w"]},
        {"Valine-Tyrosine-Valine",Model[Molecule,Oligomer,"id:Z1lqpMzRZrnz"]},
        ...
    }
*)
getModelNameListsFromSamplesIn[$Failed] := {};
getModelNameListsFromSamplesIn[compositionList_]:=
    Module[{processedCompositionList,compositionModelList,compositionNameList},
        (*Start by downloading the Composition from the reference Object[Data].*)
        (*compositionList=Download[referenceObj,SamplesIn[Composition]];*)


        (*For multiple SamplesIn, each one will supply a list of Compositions, so join them, and delete any duplicated entries*)
        processedCompositionList=DeleteDuplicates[Join@@compositionList];
        (*Sometimes compositionList has {_,Null,_} in it.  That means customer doesn't want to disclose that component, so we remove them from the list.*)
        processedCompositionList=DeleteCases[processedCompositionList, {_,Null,_} ,{1}];

        (*Split the list of Model[Molecule] from the Name which is a String.*)

        {compositionModelList, compositionNameList} =
            If[Length[processedCompositionList]===0,
                {{},{}}
                ,
                {processedCompositionList[[All,2,1]], compositionModelList[Name]}
            ];
        (*Transpose converts to form: {{name1,model1},{name2,model2},...}*)
        Transpose[{compositionNameList,compositionModelList}]
    ];

(*labelButton draws a clickable button positioned 10 pixels to the right of xy-coordinate, and assigns it an index idx.*)
labelButton[{}, _]:={};

labelButton[point:{_,_}, idx_]:=
    With[{analyzePeaks$dvar=analyzePeaks$dvar},
        Inset[
            EmeraldLabelButton[
                (*Content of label: the peak label text*)
                Dynamic[labelExtract[analyzePeaks$dvar,idx],TrackedSymbols:>{analyzePeaks$dvar}],
                (*Function to run when clicked on*)
                openlabelPeaksContextMenu[EvaluationBox[],idx],
                {"MouseEntered":>(isZoomable=False),"MouseExited":>(isZoomable=True)}
            ],
            Offset[{10,12},point],
            {Left,Top}
        ]
    ];

(*Function to attach a cell containing the context menu of Model[Molecule] *)
openlabelPeaksContextMenu[labelBox_, idx_]:=
    FrontEndExecute[
        FrontEnd`AttachCell[labelBox,
            Cell@BoxData@ToBoxes@labelPeaksContextMenu[idx],
            {Offset[{0, -4}, 0], {Left, Bottom}}, {Left, Top},
            "ClosingActions"->"OutsideMouseClick"]
    ];


(*labelPeaksContextMenu constructs the dropdown menu of Model[Molecule] that users can select to assign to a peak.
In addition, "Other..." and "None" are presented.*)
labelPeaksContextMenu[idx_]:=
    Module[{compList, listOfModelMoleculeItems, otherMenuItem, noneMenuItem},

        compList=If[Length[idx]===1,
            labelPeaks$ObjectData["CompositionNameModelList"],
            labelPeaks$ObjectData["CompositionNameModelList"][[First@idx]]
        ];

        (*Build list of MenuItems of Molecules*)
        listOfModelMoleculeItems=
            If[
                Length[compList]!=0,
                (*If there are contents in the SamplesIn CompositionList, then populate context menu with the samples*)
                modelMoleculeMenuItem[#1,idx]& /@ compList,

                (*Otherwise, if there are not, include an unclickable item indicating no components were found*)
                {EmeraldMenuItem[{Null,"no components found"},Null]}
            ];

        (*Menu item that brings up a custom dialog box*)
        otherMenuItem=EmeraldMenuItem[{Null,"Other..."},
            NotebookDelete[EvaluationCell[]];
            createCustomPeakNameDialogCell[idx,Extract[labelPeaks$ObjectData["PeakPositionTolerance"],idx]]
        ];

        (*Menu item that restores label to index string associated with the peak*)
        noneMenuItem=EmeraldMenuItem[{Null,"None"},
            NotebookDelete[EvaluationCell[]];
            labelPeaks$ObjectData["PeakAssignmentField"]=ReplacePart[labelPeaks$ObjectData["PeakAssignmentField"],idx->Null];
            LogPreviewChanges[analyzePeaks$dvar,
                {
                    PeakLabels->ReplacePart[PreviewValue[analyzePeaks$dvar, PeakLabels],idx->ToString[Last[idx]]],
                    PeakAssignments->clearPeakAssignment[analyzePeaks$dvar, idx, Extract[labelPeaks$ObjectData["PeakPositionTolerance"],idx]]
                }]
        ];

        EmeraldContextMenu[Join[listOfModelMoleculeItems,{otherMenuItem,noneMenuItem}]]
    ];



(*Model[Molecule] icon*)
chemicalIcon=Image[Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ic_object_Molecule gray30.png"}]],ImageSize->16];

modelMoleculeMenuItem[{compName_,compModel_},idx_]:=
    EmeraldMenuItem[{chemicalIcon,compName},
        (*Update PeakLabels and PeakAssignments to chosen molecule*)
        labelPeaks$ObjectData["PeakAssignmentField"]=ReplacePart[labelPeaks$ObjectData["PeakAssignmentField"],idx->compModel];
        LogPreviewChanges[analyzePeaks$dvar,
            {
                PeakLabels->
                    ReplacePart[PreviewValue[analyzePeaks$dvar, PeakLabels],idx->compName],
                PeakAssignments->
                    newPeakAssignment[
                        analyzePeaks$dvar,
                        idx,
                        Insert[Extract[labelPeaks$ObjectData["PeakPositionTolerance"],idx],compModel,2]
                    ]
            }
        ];
        NotebookDelete[EvaluationCell[]]
    ];

createCustomPeakNameDialogCell[idx_, {min_,max_}]:=
    With[{modelMoleculeTypes=Types[Model[Molecule]]},
        FrontEndExecute[
            FrontEnd`AttachCell[$analyzePeaksPreviewBox,
                Cell[BoxData@ToBoxes[
                    DynamicModule[{choice,enteredString,enteredID,moleculeSubtype,errorText=""}
                        (*DynamicModule has Initialization, see below*)

                        ,Framed[Panel[Column[{
                        (*=====RadioButton-InputField combo for custom string=====*)
                        Item["Enter a custom label for peak " <> ToString[idx, InputForm],Alignment -> Left]
                        ,groupedInputField[Dynamic[choice],Dynamic[enteredString],Dynamic[errorText]]
                        ,Spacer[0]

                        (*=====RadioButton-InputField combo input Model[Molecule] name/ID =====*)
                        ,Item["or enter a Model[Molecule] ID or Name:",Alignment -> Left]
                        ,groupedModelField[modelMoleculeTypes,Dynamic[choice],Dynamic[moleculeSubtype],Dynamic[enteredID],Dynamic[errorText]]

                        (*=====Area to display an error message, in case input Model[Molecule] does not exist=====*)
                        ,Item[Style[Dynamic[errorText],Red]]

                        (*===== OK/Cancel buttons =====*)
                        ,Item[Row[{
                            CancelButton[NotebookDelete[EvaluationCell[]]]
                            ,acceptCustomLabelDialogButton[
                                Dynamic[choice],Dynamic[enteredString],Dynamic[moleculeSubtype],Dynamic[enteredID],Dynamic[errorText], {idx, {min,max}}
                            ]}]
                            ,Alignment -> Right]},Selectable->False]
                        ,Background -> RGBColor[.95,.95,.95]]
                        ,RoundingRadius -> 5, FrameMargins -> None
                    ],Initialization:>
                        (
                            enteredString=Replace[Extract[PreviewValue[analyzePeaks$dvar, PeakLabels],idx],Null->""];
                            With[{model=getPeakAssignmentModel[analyzePeaks$dvar, idx, {min,max}]},
                                If[model===Null
                                    ,choice="String"; enteredID=""; moleculeSubtype=Model[Molecule]
                                    ,choice="ModelChemical"; enteredID=model[ID]; moleculeSubtype=model[Type]
                                ]
                            ]
                        )
                    ]]
                    (*
                        When the dialog box is created, we want the correct InputField to be highlighted:
                        If the label already has a Model[Molecule] assigned to it, highlight the ID InputField.
                        Otherwise, default to the custom string InputField.
                        The highlighting is achieved with MoveCursorToInputField.
                        Since we only want this to happen once (on displaying the attached cell), we wrap Refresh[...,None].
                    *)
                    ,CellDynamicExpression:>
                    Refresh[FrontEnd`MoveCursorToInputField[
                        EvaluationNotebook[]
                        ,If[PreviewValue[analyzePeaks$dvar, PeakAssignments]==={} || PreviewValue[analyzePeaks$dvar, PeakAssignments][[idx]]===Null,"peakNameInputField","peakNameIDField"]
                    ],None]],
                {Automatic,{Center,Center}},
                "ClosingActions"->"OutsideMouseClick"
            ]
        ]];


groupedInputField[Dynamic[choice_],Dynamic[enteredString_],Dynamic[errorText_]]:=
    Item[EventHandler[
        Row[{
            RadioButton[Dynamic[choice],"String"]
            ,Spacer[5]
            ,InputField[Dynamic[enteredString], String
                ,FieldSize -> {{10,25},{1,3}}
                ,ContinuousAction -> False
                ,FieldHint->"custom label"
                ,BoxID -> "peakNameInputField"]}],
        {
            "MouseUp":>If[choice=!="String",choice="String";errorText="";FrontEnd`MoveCursorToInputField[EvaluationNotebook[],"peakNameInputField"]]
            ,{"KeyDown", "\t"}:>(choice="ModelChemical";errorText="")
            ,"ReturnKeyDown" :> MathLink`CallFrontEndHeld[FrontEnd`Value[FEPrivate`FindAndClickDefaultButton[]]]
            ,"EscapeKeyDown" :> MathLink`CallFrontEndHeld[FrontEnd`Value[FEPrivate`FindAndClickCancelButton[]]]
        },PassEventsDown->True]
        ,Alignment -> Left
        ,BaseStyle -> {12,Dynamic[If[choice==="String",RGBColor[0,0,0],Gray]], "ControlStyle"}]

modelInputFieldEvaluationFunction[enteredID_,modelMoleculeTypes_,Dynamic[moleculeSubtype_]] := Function[
    enteredID=StringReplace[#
        ,
        {
            (*If string is an ID, switch the subtype to Model[]*)
            StringExpression[StartOfString,idString:StringExpression["id:",Array[WordCharacter&,12,1,StringExpression]],EndOfString]:>(moleculeSubtype=Model[];idString)
            (*If input is surrounded by quotation marks, strip them*)
            ,StringExpression[StartOfString,"\"",idString:StringExpression["id:",Array[WordCharacter&,12,1,StringExpression]],"\"",EndOfString]:>(moleculeSubtype=Model[];idString)
            (*If a full Object ID was copied in, change moleculeSubtype to corresponding type, and just include ID/Name*)
            ,StringExpression[StartOfString,"Model[",WhitespaceCharacter...,"Molecule",WhitespaceCharacter...,",",__,"]",EndOfString]:>
            Replace[MakeExpression[#,StandardForm],
                {HoldComplete[Model[typeSeq:PatternSequence[Molecule,___],string_String]]/;MemberQ[modelMoleculeTypes,Model[typeSeq]]:>
                    StringReplace[string,
                        {
                            StringExpression[StartOfString,"id:",Array[WordCharacter&,12,1,StringExpression],EndOfString]:>(moleculeSubtype=Model[];string)
                            ,StringExpression[StartOfString,__,EndOfString]->(moleculeSubtype=Model[typeSeq];string)
                        }]
                    ,
                    _:>#
                }]
            ,StringExpression[StartOfString,"\"",inside___,"\"",EndOfString]:>inside
        }
    ]
]

(*This row of radio button, and a custom input field that allows the selection of a Constellation model*)
groupedModelField[modelMoleculeTypes_,Dynamic[choice_],Dynamic[moleculeSubtype_],Dynamic[enteredID_],Dynamic[errorText_]]:=
    Item[EventHandler[
        Row[{
            RadioButton[Dynamic[choice],"ModelChemical"],
            Spacer[9],
            (*This produces a popup menu of a list of model Molecule types*)
            MouseAppearance[PopupMenu[
                Dynamic[moleculeSubtype],
                modelMoleculeTypes,
                Null,
                Dynamic[
                    Style[
                        StringReplacePart[
                            ToString[moleculeSubtype],
                            If[moleculeSubtype===Model[],"\"",", \""],
                            {-1,-1}
                        ],
                        If[choice==="ModelChemical","Link","Inherited"]
                    ],
                    TrackedSymbols:>{moleculeSubtype,choice}
                ],
                Appearance->None],"LinkHand"
            ],
            (*This is an inputfield for the ID*)
            InputField[
                Dynamic[enteredID,modelInputFieldEvaluationFunction[enteredID,modelMoleculeTypes,Dynamic[moleculeSubtype]]],
                String,
                FieldSize -> {{8,25},{1,3}},
                FieldHint->"ID or Name",
                ContinuousAction -> True,
                BoxID -> "peakNameIDField"]
            (*This is the closing quote marks on the right side *)
            ,Style["\"]","Output"]}]
        ,{
            "MouseUp":>If[choice=!="ModelChemical",choice="ModelChemical";errorText="";FrontEnd`MoveCursorToInputField[EvaluationNotebook[],"peakNameIDField"]]
            ,{"KeyDown", "\t"}:>(choice="String";errorText="")
            ,"ReturnKeyDown" :> MathLink`CallFrontEndHeld[FrontEnd`Value[FEPrivate`FindAndClickDefaultButton[]]]
            ,"EscapeKeyDown" :> MathLink`CallFrontEndHeld[FrontEnd`Value[FEPrivate`FindAndClickCancelButton[]]]
        }
        ,PassEventsDown->True]
        ,Alignment->Left
        ,BaseStyle->{12,Dynamic[If[choice==="ModelChemical",RGBColor[0,0,0],Gray]], "ControlStyle"}];


(*
    This helper function takes the user-input custom string and Model[Molecule] object and accepts it.
    It will populate the PeakLabels option with the appropriate string,
    and populate the PeakAssignments option with the appropriate label.
*)
acceptCustomLabelDialogButton[Dynamic[choice_],Dynamic[enteredString_],Dynamic[moleculeSubtype_],Dynamic[enteredID_],Dynamic[errorText_],{idx_,{min_,max_}}] :=
    DefaultButton[
        If[choice==="String",
            NotebookDelete[EvaluationCell[]];
            labelPeaks$ObjectData["PeakAssignmentField"]=ReplacePart[labelPeaks$ObjectData["PeakAssignmentField"],idx->Null];
            LogPreviewChanges[analyzePeaks$dvar,
                {PeakLabels->ReplacePart[PreviewValue[analyzePeaks$dvar, PeakLabels],idx->enteredString]
                    ,PeakAssignments->clearPeakAssignment[analyzePeaks$dvar, idx, Extract[labelPeaks$ObjectData["PeakPositionTolerance"],idx]]}]
            ,
            acceptModelMoleculeFromCustomDialogBox[Dynamic[moleculeSubtype],Dynamic[enteredID],Dynamic[errorText],{idx,{min,max}}]
        ]
    ];

acceptModelMoleculeFromCustomDialogBox[Dynamic[moleculeSubtype_],Dynamic[enteredID_],Dynamic[errorText_],{idx_,{min_,max_}}]:=
    Module[{downloadedNameAndID},
        (*First download the selected model from Constellation*)
        downloadedNameAndID=
            Quiet[Check[
                Download[Append[moleculeSubtype,enteredID],{Name,Object}]
                ,{$Failed,$Failed},{Download::ObjectDoesNotExist,Download::MismatchedType}
            ],{Download::ObjectDoesNotExist,Download::MismatchedType}];


        If[First[downloadedNameAndID]=!=$Failed
            ,
            (*If the download failed, then the object does not exist*)
            labelPeaks$ObjectData["PeakAssignmentField"]=ReplacePart[labelPeaks$ObjectData["PeakAssignmentField"],idx->downloadedNameAndID[[2]]];
            LogPreviewChanges[analyzePeaks$dvar,
                {
                    PeakLabels->ReplacePart[PreviewValue[analyzePeaks$dvar, PeakLabels], idx->downloadedNameAndID[[1]]],
                    PeakAssignments->newPeakAssignment[analyzePeaks$dvar, idx, {min,downloadedNameAndID[[2]],max}]
                }];
            NotebookDelete[EvaluationCell[]]
            ,
            (*If the download failed, then the object does not exist.  Display*)
            errorText = ToString[Append[moleculeSubtype,enteredID], InputForm] <> " could not be found."
        ]
    ]

(*labelExtract is used to display the text in each label button associated with each peak.
It checks whether the labels are in collapsed from, and if so, take the appropriate label from
the collapsed list*)
labelExtract[dVar_,idx_]:=
    If[(*If idx is of the form {objectIndex, peakIndex} AND dVar[PeakLabels] is NOT in expanded form*)
        MatchQ[idx,{_,_}] && Not[MatchQ[dVar[PeakLabels],{_List..}]]
        ,(*then, the pull from the peakIndex*)
        dVar[PeakLabels][[Last@idx]]
        ,(*otherwise extract the peak label as intended*)
        Extract[dVar[PeakLabels],idx]
    ]

(*clearPeakAssignment is used in menu item None and custom label choice = string.
It looks for something that matches {pos, Model, tolerance} and removes it from the
preview variable dVar.*)
(*Singleton case*)
clearPeakAssignment[dVar_, {_Integer}, {min_, max_}] :=
    DeleteCases[
        PreviewValue[dVar, PeakAssignments]
        , {min, _, max}
    ];
(*Multiple case*)
clearPeakAssignment[dVar_, idx_, {min_, max_}] :=
    MapAt[
        DeleteCases[#, {min, _, max}]&
        ,PreviewValue[dVar, PeakAssignments]
        ,First[idx]];

(*Singleton case*)
getPeakAssignmentModel[dVar_, {_Integer}, {min_, max_}] :=
    First[Cases[PreviewValue[dVar, PeakAssignments],{min, model_, max}:>model,{1},1],Null];
(*multiple case*)
getPeakAssignmentModel[dVar_, idx_, {min_, max_}] :=
    First[Cases[PreviewValue[dVar, PeakAssignments][[First@idx]],{min, model_, max}:>model,{1},1],Null];

(*new peak assignment first appends {pos, Model, tolerance}.
It then checks whether the position tolerance already appears in the list, and deletes it.*)
(*Singletone case*)
newPeakAssignment[dVar_, {_Integer}, pa : {_, ObjectP[Model[Molecule]], _}] :=
    Module[{newAssignment},
        newAssignment = Prepend[PreviewValue[dVar, PeakAssignments], pa];
        DeleteDuplicatesBy[newAssignment, #[[{1, 3}]] &]
    ];
(*Multiple case*)
newPeakAssignment[dVar_, idx_, pa : {_, ObjectP[Model[Molecule]], _}] :=
    Module[{newAssignmentAtIndex},
        newAssignmentAtIndex = Prepend[PreviewValue[dVar, PeakAssignments][[First@idx]], pa];
        newAssignmentAtIndex = DeleteDuplicatesBy[newAssignmentAtIndex, #[[{1, 3}]] &];
        ReplacePart[PreviewValue[dVar, PeakAssignments], First[idx]->newAssignmentAtIndex]
    ];
