

Warning::AnalysisObjectNotExist="The Data Object `1` does not have an analysis object associated with it. A provisional analysis object will be generated with default options.";

(*If the input is data object, redirect to its protocol*)
PlotMeasureMeltingPoint[dataObj:ObjectP[Object[Data, MeltingPoint]]]:=Module[{protocol},
    protocol = Download[dataObj, Protocol];
    PlotMeasureMeltingPoint[protocol]
];

(*If the input is analysis object, redirect to its data' protocol*)

(*This function will plot all data and analysis objects under the same protocol, even the input is a single data/analysis object.*)
PlotMeasureMeltingPoint[protocol:ObjectP[Object[Protocol, MeasureMeltingPoint]]]/;$CCD:=Module[
    {protocolObj, dataObjList, analysisObjList, analysisExistsQ, analysisPacket},

    protocolObj = protocol[Object];
    {dataObjList, analysisObjList} = Download[protocol, {Data, Data[MeltingAnalyses]}];

    (*Check if all analysis objects exist. If existing return the fields of analysis object. Otherwise it will run the analysis function with a warning message*)
    analysisExistsQ = Transpose[MapThread[checkAnalysisObjectExists, {dataObjList, analysisObjList}]];

    analysisPacket = getAnalysisPackets[dataObjList, analysisObjList, analysisExistsQ];
    (* only use the first packet, which in principle assumes that the analyses all correspond to the same protocol *)
    plotMeasureMeltingPointHelper[analysisPacket]
];

getAnalysisPackets[dataList_, analysisList_, analysisQList_] := If[First[analysisQList],
    First[analysisList],
    AnalyzeMeltingPoint[First[dataList], Upload -> False]
];


(*For MM version < 12.1, VideoStream does not exist. The interactive plot will not contain video file (for Command Builder only) and the layout is different. *)
PlotMeasureMeltingPoint[protocol:ObjectP[Object[Protocol, MeasureMeltingPoint]]]/;($CCD==False):=Module[
    {dataObjList, analysisObjList},

    (*check if all analysis objects exist, otherwise it will run the analysis function with a warning message*)
    {dataObjList, analysisObjList} = Download[protocol, {Data, Data[MeltingAnalyses]}];
    plotMeasureMeltingPointHelperV12[First[analysisObjList]]
];




(*helper functions*)
(*In the case that data object exits, but its analysis object does not, it will run the analysis function first.*)
checkAnalysisObject[linkedDataObj_, linkedAnalysisObj_]:=Module[{dataObj, analysisObj, analysisPacket},

    dataObj = Download[linkedDataObj, Object];
    analysisObj = Download[linkedAnalysisObj, Object];

    If[Not[NullQ[dataObj]],
        If[NullQ[analysisObj],

            (*if analysis object is Null, run the analysis function*)
            Message[Warning::AnalysisObjectNotExist, dataObj];
            analysisPacket = ECL`AnalyzeMeltingPoint[dataObj, Upload->False];
            Lookup[analysisPacket, {USPharmacopeiaMeltingRange, BritishPharmacopeiaMeltingPoint, JapanesePharmacopeiaMeltingPoint}],

            (*if analysis object exists, return the fields value*)
            Download[analysisObj, {USPharmacopeiaMeltingRange, BritishPharmacopeiaMeltingPoint, JapanesePharmacopeiaMeltingPoint}]
        ]
    ]
];
checkAnalysisObjectExists[linkedDataObj_, linkedAnalysisObj_]:=Module[{dataObj, analysisObj, analysisPacket},

    dataObj = Download[linkedDataObj, Object];
    analysisObj = Download[linkedAnalysisObj, Object];

    Not[NullQ[dataObj]] && Not[NullQ[analysisObj]]
];


(*Make an association for labeled points*)
coordinatesAssociation[lsts_List, usp_, bp_, jp_] := Module[
    {
        pointXYUSP, pointXYBP, pointXYJP, assoList, bpList, jpList, totalSampleN
    },
    (*The desired return format is
         <|
            1-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>,
            2-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>,
            3-> <|"USP"->{point1, point2}, "BP"->{point1}, "JP"->{point1}|>
         |>*)
    totalSampleN = Length[lsts];
    bpList = {#} & /@ bp;
    jpList = {#} & /@ jp;

    pointXYUSP = MapThread[getXYPoint, {lsts, usp}];
    pointXYBP = MapThread[getXYPoint, {lsts, bpList}];
    pointXYJP = MapThread[getXYPoint, {lsts, jpList}];

    assoList = MapThread[<|"USP" -> #1, "BP" -> #2, "JP" -> #2|> &, {pointXYUSP, pointXYBP, pointXYJP}];
    AssociationThread[Range[totalSampleN], assoList]
];
getXYPoint[x_List, target_] := First[Cases[x, {#, _}]] & /@ target;

(*Icon for EmeraldMenuBar*)
menuIcon[color_, bgColor_, selectQ_] := Module[{offset=0.1},
    (*selectQ will determine with Graphics to return*)
    If[selectQ,
        Graphics[{
            (*outside color layer*)
            {color, Rectangle[{0, 0}, {1, 1}]},
            (*middle white layer*)
            {bgColor, Rectangle[{0 + offset, 0 + offset}, {1 - offset, 1 - offset}]},
            (*internal colored layer*)
            {color, Rectangle[{0 + 2.3*offset, 0 + 2.3*offset}, {1 - 2.3*offset, 1 - 2.3*offset}]}
        }, ImageSize -> {15, 15}],
        Graphics[{
            (*internal colored layer*)
            {color, Rectangle[{0 + 2.3*offset, 0 + 2.3*offset}, {1 - 2.3*offset, 1 - 2.3*offset}]}
        }, ImageSize -> {10, 10}]
    ]
];

(*Icon for play button, In this case the size is {30, 30}*)
buttonPlay[bgColor_, frontColor_, size_] := Graphics[
    {
        {EdgeForm[{emeraldPlotDefaultGray, Thick}], {bgColor, Rectangle[{0, 0}, size]}},
        {Directive[frontColor, Thick], Line[{{9, 11}/30*size, {9, 19}/30*size}]},
        {Directive[frontColor, Thick], Triangle[{{12, 9}/30*size, {22, 15}/30*size, {12, 21}/30*size}]}
    },
    ImageSize -> size
];

(*Icon for pause button*)
buttonPause[bgColor_, frontColor_, size_] := Graphics[
    {
        {EdgeForm[{emeraldPlotDefaultGray, Thick}], {bgColor, Rectangle[{0, 0}, size]}},
        {Directive[frontColor, Thickness[0.15]], Line[{{10, 11}/30*size, {10, 19}/30*size}]},
        {Directive[frontColor, Thickness[0.15]], Line[{{18, 11}/30*size, {18, 19}/30*size}]}
    },
    (*In this case the size is {30, 30}*)
    ImageSize -> size
];

(*Icon for slider selection*)
poly2[var_] := Polygon[{
    Offset[{0, -9}, {var, 0}], Offset[{4, -4}, {var, 0}], Offset[{4, 14}, {var, 0}], Offset[{-4, 14}, {var, 0}], Offset[{-4, -4}, {var, 0}]
}];

(*Icon primitive on top of video*)
iconPrimitive[posX_, posY_, size_, color_, selectQ_] := If[
    selectQ,
    selectedIconPrimitive[posX, posY, size, Black, color],
    unselectedIconPrimitive[posX + 3, posY + 3, size - 6, color]
];

(*Icon for selected on top of video*)
selectedIconPrimitive[x_, y_, size_, bgColor_, ftColor_] := Module[{offsetMargin=2},
    {
        (*outside box*)
        ftColor, Rectangle[{x, y}, {x + size, y + size}],
        (*middle white layer*)
        bgColor, Rectangle[{x + offsetMargin, y + offsetMargin}, {x + size - offsetMargin, y + size - offsetMargin}],
        (*internal colored layer*)
        ftColor, Rectangle[{x + 2*offsetMargin, y + 2*offsetMargin}, {x + size - 2*offsetMargin, y + size - 2*offsetMargin}]
    }
];

(*Icon for unselected on top of video*)
unselectedIconPrimitive[x_, y_, size_, color_] := {color, Rectangle[{x, y}, {x + size, y + size}]};

(*Epilog to display coordinates with dashed lines*)
singlePointEpilog[{mpx : NumericP, mpy : NumericP}, xMin_, yMin_, color_] := {
    color, Dashed, Thick, Line[{{mpx, yMin}, {mpx, mpy}}],
    color, Dashed, Thick, Line[{{xMin, mpy}, {mpx, mpy}}],
    Text[
        Framed[Style[ToString[Round[mpy, 0.1]] <> "%", FontSize -> 16], Background -> White, FrameMargins -> 1, FrameStyle -> None],
        {If[mpx - xMin > 1, Max[xMin + 0.1*(mpx - xMin), xMin + 0.2], xMin + 0.1*(mpx - xMin)], mpy},
        {-1, 0}
    ],
    Text[
        Framed[Style[ToString[Round[mpx, 0.1]] <> "\[Degree]C", FontSize -> 16], Background -> White, FrameMargins -> 1, FrameStyle -> None],
        {mpx, Max[yMin + 0.1*(mpy - yMin), yMin + 4]}
    ]
};

(*PopupMenu with modified style*)
popupMenuSelectStandard[Dynamic[selection_], lst_List] := PopupMenu[
    Dynamic[selection],
    lst,
    lst[[1]],
    Row[{
        Panel[
            Style[Dynamic[selection], emeraldPlotDefaultDarkerGray, 12, Bold, Background -> White],
            ImageSize -> {10*Max[StringLength[lst]], 20}, Appearance -> None, Alignment -> {Center, Center}
            ],
        Panel[
            Style["\[FilledDownTriangle]", 16, Bold, emeraldPlotDefaultGray, Background -> White],
            ImageSize -> {20, 20}, Appearance -> None, Alignment -> {Center, Center}
            ]
        },
        Frame -> True, FrameStyle -> Directive[emeraldPlotDefaultGray, Thick], FrameMargins -> None
    ],
    MenuStyle -> Directive[emeraldPlotDefaultDarkerGray, 12, Bold]
];
