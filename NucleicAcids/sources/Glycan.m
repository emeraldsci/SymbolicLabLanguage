(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Glycan Clumps *)

(* clumplate for a single glycan *)
glycanClumplate = Clump[{

    (* --- inheritance and saving properties --- *)
    InheritFrom -> {"Blob"},
    Clumplate -> True,
    SaveAs -> "Glycan",

    (* --- variable properties --- *)
    GlycanName,
    Abbreviation,
    ColorSignature,

    (* --- derived properties *)
    Color :> RGBColor@@$This[ColorSignature],
    Center -> {0, 0},
    Shape :> Disk[$This[Center]],
    ImageSize -> 25,
    <|
        Name -> StructureGraphic,
        Remember -> False,
        Expression :> If[$This[ColorSignature] === Undefined,
            (*
                if color is undefined, then the key clump params haven't been set yet
                so return just a placeholder
            *)
            Graphics[{Gray, Disk[]}, ImageSize -> $This[ImageSize]],
            (* else resolve the graphic with tooltips *)
            Graphics[
                {
                    EdgeForm[{Black}],
                    $This[Color],
                    Tooltip[$This[Shape], $This[Abbreviation]]
                },
                ImageSize -> $This[ImageSize]
            ]
        ]
    |>,
    (* TODO: combine StructureGraphic with plot *)
    <|
        Name -> Plot,
        Remember -> False,
        Expression :> $This[StructureGraphic],
        Static -> True
    |>,
    <|
        Name -> Preview,
        Remember -> False,
        Expression :> $This[Plot]
    |>,
    DisplayProperty :> Preview
}];

(* glycan constructor *)
GlycanConstructor := ClumpGet[
    Clump[{
        InheritFrom->"Constructor",
        InputProperties->{InheritFrom,GlycanName,Abbreviation,ColorSignature}
    }],
    Constructor
];

(* create a helper for clump lists *)
ClumpList[list_List]:=Clump[{InheritFrom->{"List"}, Value->list}];



(* ::Subsection:: *)
(* GlycanSequence Clumps *)

(* glycan sequence clumplate *)
sequenceClumplate = Clump[{

    (* --- inheritance properties --- *)
    InheritFrom -> {"Blob"},
    Clumplate -> True,
    SaveAs -> "GlycanSequence",

    (* --- variable properties *)
    Glycans,

    (* --- derived properties *)
    GlycanGraphics :> Map[
        ($This[Glycans, #, StructureGraphic])&,
        $This[Glycans, Indices]
    ],
    CoordinateCenter -> {0, 0},
    GlycanDistance -> 3,
    (* TODO: change this, as glycan is no longer needed *)
    GlycanCenters :> Map[
        Function[{index},
            $This[CoordinateCenter] + {0, $This[GlycanDistance]}*(index - 1)
        ],
        $This[Glycans, Indices]
    ],
    <|
        Name -> Plot,
        Remember -> False,
        Expression :> Module[
        {lineGraph, graphPrimitives},

            (* make lines first *)
            lineGraph = Graphics[{Thick,Line[$This[GlycanCenters]]}];

            (* add glycan graphics onto the line vertices *)
            (* set all glycan centers to their correct values *)
            MapThread[
                ClumpSet[$This[Glycans, #1], Center -> #2] &,
                {$This[Glycans, Indices], $This[GlycanCenters]}
            ];

            (* get the graphics primitives *)
            graphPrimitives = Map[
                $This[Glycans, #, Plot] &,
                $This[Glycans, Indices]
            ];

            (* show the primitives *)
            Show[
                lineGraph,
                Sequence @@ graphPrimitives,
                ImageSize -> $This[Glycans, 1, ImageSize]
            ]
        ]
    |>,
    <|
        Name -> Preview,
        Remember -> False,
        Expression :> If[
            $This[Glycans] === Undefined,
            Graphics[{Gray, Disk[]}, ImageSize -> 25],
            $This[Plot]
        ]
    |>,
    DisplayProperty :> Preview
}];

(* sequence constructors *)
GS = Clump[{
    Constructor :> Function[
        Clump[{
            InheritFrom -> "GlycanSequence",
            Glycans -> Clump[{
                InheritFrom -> "List",
                Value -> {##}
            }]
        }]
    ]
}];
GSC := GS[Constructor];









(* ::Subsection:: *)
(* GlycanStructure Clumps *)

(* branched glycan clumps called glycan structures *)
glycanStructureClumplate = Clump[{

    (* --- Save as Clumplate --- *)
    Clumplate -> True,
    SaveAs -> "GlycanStructure",
    Type -> GlycanStructure, (* WIP: trying out a Type property, but it currently doesn't do anything *)

    (* === Fields ===*)

    (* --- Inherited Properties --- *)
    InheritFrom -> {"Blob"},

    (* --- Properties Set When Created --- *)
    Sequences,
    Bonds,

    (* --- Options Properties --- *)
    ImageSize -> 50,
    BranchLength -> 4,
    PlotAngle -> 0 Degree,
    CenterGraphics -> True,

    (* --- Computed Properties --- *)
    NumberOfSequences :> $This[Sequences][Length],
    PrimarySequenceIndex :> Module[
        {connectedIndices, primaryIndices},

        (* get all the downstream indices from the bonds property *)
        connectedIndices = Last /@ $This[Bonds];

        (* find the primary indices that are defined as the indices that are
        never in the downstream set *)
        primaryIndices = Complement[
            Range[$This[NumberOfSequences]],
            Union[connectedIndices]
        ];

        (* set the primary index as the first of the primary indices *)
        (* TODO: think about if we want to support multiple disconnected graphs *)
        primaryIndices[[1]]
    ],
    PrimarySequence :> $This[Sequences][$This[PrimarySequenceIndex]],
    TerminalSequences :> Module[
        {upstreamIndices, terminalIndices},

        (* get the sequence indices that are on the upstream side of the bonds *)
        upstreamIndices = First /@ $This[Bonds];

        (* find the terminal sequences which are never upstream of any other index *)
        terminalIndices = Complement[
            Range[$This[NumberOfSequences]],
            Union[upstreamIndices]
        ];

        (* return the actual sequences corresponding to the indices *)
        Part[$This[Sequences], terminalIndices]
    ],

    (* --- 'Internal' Graphics Properties ---*)
    (* initialized to empty lists, but are populated by helpers *)
    (* necessary to do it this way because these are populated recursively *)
    LineGraphics -> {},
    SequenceGraphics -> {},

    (*
    Because we store glycan sequences as references, updating the glycan properties directly triggers updates to all copies.
    Need to store key values locally in lists, so that we can control over each individual sequence by resetting relevant property.
    *)
    allCoordinateCenters :> {}, (* The position of the last glycan unit in the sequences. *)
    allGlycanCenters -> {},     (* The position of the all glycan units in the sequences. *)
    xBounds -> {},              (* The x bounds of the glycan sequences. *)
    yBounds -> {},              (* The y bounds of the glycan sequences. *)
    indexPath -> {},            (* The order in which the supplied glycan sequences are traversed by the recursive plotting function. *)


    (* === Methods === *)
    (* --- Methods for Graphics ---*)
    (*
    Preview calls Plot which calls both setGraphics and setBranchGraphics.
    setGraphics calls recursivelySetGraphics and either plotGlycanGraphicsWithCentering or plotGlycanGraphicsWithoutCentering.
    recursivelySetGraphics sets the initial positions of all the glycan sequences, resolving overlap as much as possible.
        It does NOT generate the actual graphics objects.
    If CenterGraphics->True (Default Behavior), plotGlycanGraphicsWithCentering is called,
        which centers/aligns glycanSequences which branch into more glycan sequences, but may cause new overlap for
        especially complex glycan structures.
    If CenterGraphics->False, plotGlycanGraphicsWithoutCentering is called which simply generates the graphics objects
        using the positons set by recursivelySetGraphics.
    setBranchGraphics generates the lines between the glycan sequence graphics objects.
    *)
    <|
        Name -> setGraphics,
        Remember -> False,
        Expression :> Module[
            {},

            (* Start by clearing line/sequence graphics, so that if we re-trigger plotting, we do not plot extra graphics objects. *)
            $This[LineGraphics] = {};
            $This[SequenceGraphics] = {};

            (*
            Also clear variables used to assist in plotting.
            Pre-allocate rather than append (except for index path), since the overlap check will loop an
              indeterminate number of times and we want to preserve index matching.
            *)
            $This[allCoordinateCenters] = ConstantArray[{}, $This[NumberOfSequences]];
            $This[allGlycanCenters] = ConstantArray[{}, $This[NumberOfSequences]];
            $This[xBounds] = ConstantArray[{}, $This[NumberOfSequences]];
            $This[yBounds] = ConstantArray[{}, $This[NumberOfSequences]];
            $This[indexPath] = {};

            (*
            Begin recursion.
            This function sets the positions of the glycan sequences, shifting them as needed to prevent overlap.
            It does NOT generate the actual plot. The plotted sequences are generated after.
            *)
            $This[recursivelySetGraphics][
                $This[PrimarySequence],
                $This[PrimarySequenceIndex]
            ];

            (* Traverse the glycan structure in the reserve order of how it was plotted, centering/aligning branches as needed. *)
            If[$This[CenterGraphics],
                Map[$This[plotGlycanGraphicsWithCentering][#]&, Reverse[$This[indexPath]]],
                Map[$This[plotGlycanGraphicsWithoutCentering][#]&, Reverse[$This[indexPath]]]
            ]
        ]
    |>,

    <|
        Name -> recursivelySetGraphics,
        Remember -> False,
        Expression :> Function[
            {sequence, index},
            Module[
                {
                    (* Vars for determining branches and initial displacement. *)
                    matchingBonds, neighborIndices, neighbors, numberOfNeighbors, branchPoint, relDisplacements, displacements,
                    (* Vars for checking overlap. *)
                    maxOverlapCorrections, allBounds, sequencePairIndicies, sequencePairBounds, truthList, isOverlapping
                },

                (* Track the order in which the sequences are plotted. *)
                $This[indexPath] = Append[$This[indexPath], index];

                (* Check if Glycan sequence would overlap with already plotted sequences. *)
                maxOverlapCorrections = 30;
                For[i=1, i<=maxOverlapCorrections, i++,
                    (* Calculate the x and y lower/upper bounds (with padding) to determine if glycans overlap. *)
                    (* Must use ReplacePart rather than $This[xBounds][[index]] because of Clump stuff. *)
                    $This[xBounds] = ReplacePart[$This[xBounds],
                        index-> {
                            sequence[GlycanCenters][[-1]][[1]] - 1.0, (* Left Bound - Subtract *)
                            sequence[GlycanCenters][[-1]][[1]] + 1.0  (* Right Bound - Add *)
                        }
                    ];
                    $This[yBounds] = ReplacePart[$This[yBounds],
                        index -> {
                            sequence[GlycanCenters][[1]][[2]] - 1.0,  (* Bottom Bound - Subtract *)
                            sequence[GlycanCenters][[-1]][[2]] + 1.0  (* Top Bound - Add *)
                        }
                    ];

                    (* Join the x and y bounds into a single index-matched list. *)
                    allBounds = MapThread[{#1, #2} &, {$This[xBounds], $This[yBounds]}];

                    (* Check if the sequence we are currently positioning overlaps with any of the already positioned sequences. *)
                    (* Generate list of index pairs / corresponding bounds for the pairs of sequences. *)
                    sequencePairIndicies = Map[{#,index}&, $This[indexPath][[;;-2]]];
                    sequencePairBounds = Map[allBounds[[#]]&, sequencePairIndicies];

                    (* Actually check the overlap overlap. *)
                    truthList = Map[checkOverlap2D@@#&, sequencePairBounds];
                    isOverlapping = MemberQ[truthList, True];

                    (* Shift sequence as needed. *)
                    If[isOverlapping,
                        (*
                        True - Yes Overlap, shift sequence to the right, re-check overlap.
                        Setting CoordinateCenter updates  the GlycanCenters in the GlycanSequence. Useful for calculating x and y bounds.
                        *)
                        ClumpSet[$This[Sequences][index], CoordinateCenter -> $This[Sequences][index][CoordinateCenter]
                            + $This[BranchLength]*{1.0,0}],

                        (* False - No Overlap, End Loop. *)
                        Break[]
                    ];

                ];

                (* Keep a list of the finalized glycan positions so that we can easily center sequences in next step. *)
                $This[allCoordinateCenters] = ReplacePart[$This[allCoordinateCenters], index->$This[Sequences][index][CoordinateCenter]];
                $This[allGlycanCenters] = ReplacePart[$This[allGlycanCenters], index->$This[Sequences][index][GlycanCenters]];

                (* Check for upstream neighbors and shift to good starting position. *)
                (* Find neighbors by looking for bonds with the same upstream index *)
                matchingBonds = Cases[$This[Bonds], HoldPattern[Rule[index, _]]];
                neighborIndices = Last /@ matchingBonds;
                neighbors = Map[$This[Sequences], neighborIndices];

                (* If no neighbors, return and move onto next sequence. *)
                If[MatchQ[neighbors, {}], Return[Nothing]];

                (* Calculate initial displacement and shift neighbors. *)
                (* Start by finding the branch point from which the lines will be drawn. *)
                branchPoint = sequence[GlycanCenters][[-1]];

                (* Find the initial displacements for the branches. *)
                numberOfNeighbors = Length[neighborIndices];
                relDisplacements = $This[BranchLength] * Map[{#,1}&, Range[-(numberOfNeighbors - 1)/2, (numberOfNeighbors - 1)/2, 1]];

                (* Add the branch point to the relative displacements. *)
                displacements = Map[(# + branchPoint)&, relDisplacements];

                (* Recurse by mapping over neighbors. *)
                MapThread[
                    Function[{neighbor, displacement, neighborIndex},
                        (
                            ClumpSet[neighbor, CoordinateCenter -> displacement];
                            $This[recursivelySetGraphics][neighbor, neighborIndex]
                        )
                    ],
                    {neighbors, displacements, neighborIndices}
                ]
            ]
        ]
    |>,

    <|
        Name -> plotGlycanGraphicsWithCentering,
        Remember -> False,
        Expression :> Function[{index},
            Module[{
                sequence, sequencePlot,
                matchingBonds, neighborIndices, neighbors, numberOfNeighbors,
                neighborCoordinateCenters, branchCoordinateCenter, medianIndex, newCoordinateCenter
            },
                (* Get sequence for index. *)
                sequence = $This[Sequences][index];

                (* Find neighbors by looking for bonds with the same upstream index *)
                matchingBonds = Cases[$This[Bonds], HoldPattern[Rule[index, _]]];
                neighborIndices = Last /@ matchingBonds;
                neighbors = Map[$This[Sequences], neighborIndices];
                numberOfNeighbors = Length[neighborIndices];

                (* Get neighbor positions. *)
                branchCoordinateCenter = $This[allCoordinateCenters][[index]];
                neighborCoordinateCenters = $This[allCoordinateCenters][[neighborIndices]];

                newCoordinateCenter = Which[
                    (* If 0 or 1 neighbors, use initial coordinate center. *)
                    MatchQ[numberOfNeighbors, Alternatives[0,1]],
                    branchCoordinateCenter,

                    (* If even number of neighbors, center the sequence. *)
                    MatchQ[numberOfNeighbors, GreaterEqualP[2,2]],
                    {
                        Mean[neighborCoordinateCenters[[;;,1]]],
                        branchCoordinateCenter[[2]]
                    },

                    (* If odd number of neighbors, align the sequence to middle neighbor. *)
                    MatchQ[numberOfNeighbors, GreaterEqualP[3,2]],
                    (
                        medianIndex = Ceiling[numberOfNeighbors / 2];
                        {
                            Sort[neighborCoordinateCenters][[medianIndex]][[1]],
                            branchCoordinateCenter[[2]]
                        }
                    )
                ];

                (*
                Set the new sequence coordinate center to trigger and update to the GlycanCenters.
                Update local list of AllCoordinateCenters and AllGlycanCenters.
                *)
                ClumpSet[sequence, CoordinateCenter -> newCoordinateCenter];
                $This[allCoordinateCenters] = ReplacePart[$This[allCoordinateCenters], index->newCoordinateCenter];
                $This[allGlycanCenters] = ReplacePart[$This[allGlycanCenters], index->sequence[GlycanCenters]];

                (* Generate graphics object and append to sequenceGraphics. *)
                sequencePlot = sequence[Plot];
                $This[SequenceGraphics] = Append[$This[SequenceGraphics], sequencePlot];
            ]
        ]
    |>,

    <|
        Name -> plotGlycanGraphicsWithoutCentering,
        Remember -> False,
        Expression :> Function[{index},
            Module[{branchCoordinateCenter, sequence, sequencePlot},

                (* Get sequence for index. *)
                sequence = $This[Sequences][index];

                (* Still need to reset sequence coordinate centers before plotting. *)
                branchCoordinateCenter = $This[allCoordinateCenters][[index]];
                ClumpSet[sequence, CoordinateCenter -> branchCoordinateCenter];
                $This[allCoordinateCenters] = ReplacePart[$This[allCoordinateCenters], index->branchCoordinateCenter];
                $This[allGlycanCenters] = ReplacePart[$This[allGlycanCenters], index->sequence[GlycanCenters]];

                (* Generate graphics object and append to sequenceGraphics. *)
                sequencePlot = sequence[Plot];
                $This[SequenceGraphics] = Append[$This[SequenceGraphics], sequencePlot];
            ]
        ]
    |>,

    <|
        Name -> setBranchGraphics,
        Remember -> False,
        Expression :> Module[
            {branchStart, branchEnd},

            (* Use the static list of allGlycanCenters to determine the start/end points for the line graphics. *)
            branchStart = Map[$This[allGlycanCenters][[#]][[-1]]&, $This[Bonds][[;; , 1]] ];
            branchEnd = Map[$This[allGlycanCenters][[#]][[1]]&, $This[Bonds][[;; , 2]] ];

            (*
            Create lines between branched sequences.
            This needs to be wrapped in a list so it can be joined with sequence graphics.
            *)
            $This[LineGraphics] = {Graphics[
                Join[{Thick}, MapThread[Line[{#1, #2}]&, {branchStart, branchEnd}]]
            ]};
        ]
    |>,

    <|
        Name -> Plot,
        Remember -> False,
        Expression :> Module[
            {graphicPrims},

            (* Plot calls setGraphics, which calls recursivelySetGraphics. *)
            $This[setGraphics];
            $This[setBranchGraphics];

            (* Join the list of graphic primitives generated by setGraphics. *)
            graphicPrims = Join[$This[LineGraphics], $This[SequenceGraphics]];

            (* Create the final graphic *)
            Rotate[
                Show[Sequence @@ graphicPrims, ImageSize -> $This[ImageSize]],
                $This[PlotAngle]
            ]
        ],
        Static -> True
    |>,

    (* --- Preview Property ---*)
    <|
        Name -> Preview,
        Remember -> False,
        (* if the sequences aren't set, the blob will be bad, so fill it with something for now. *)
        Expression :> If[$This[Sequences] === Undefined,
            Graphics[{Gray, Disk[]}, ImageSize -> 25],
            $This[Plot]
        ]
    |>,
    DisplayProperty :> Preview

}];



(* ::Subsection:: *)
(*Glycan*)

(* global variables *)
(* create a global var that contains a map between glycan name and primitive clump *)
$GlycanMap = {};


(* Glycan messages *)
Glycan::InvalidInput = "The input string, `1`, is not recognized. Look at AvailableGlycans[], and try again.";


(* function that will make a glycan clump from a string *)
Glycan[glycan_String] := Module[
    {candidateClump},

    (* get the candidate clump from the clump map *)
    (* if the clump map has not been set yet, then make it *)
    If[Not[MatchQ[$GlycanMap, {_Rule..}]],
        $GlycanMap = createGlycanMap[]
    ];
    candidateClump = Replace[glycan, $GlycanMap];

    (* if candidate clump didn't match on anyting return failed *)
    (* TODO: make a nice error message here *)
    If[MatchQ[candidateClump, _String],
        Message[Glycan::InvalidInput, glycan];
        $Failed,
        Clump[{InheritFrom -> candidateClump}]
    ]
];

(* pre-define all glycan colors for blobs *)
(* TODO: decide if these should be public symbols *)
GlycanBlue = {0, 114, 188}/255;
GlycanGreen = {0, 166, 81}/255;
GlycanYellow = {255, 212, 0}/255;
GlycanLightBlue = {143, 204, 233}/255;
GlycanPink = {246, 158, 161}/255;
GlycanPurple = {165, 67, 153}/255;
GlycanBrown = {161, 122, 77}/255;
GlycanOrange = {244, 121, 32}/255;
GlycanRed = {237, 28, 36}/255;

createGlycanMap[]:=Module[
    {
        (* glycan naming variables *)
        baseAbbrevs, baseNames, nacNames, nacAbbrevs, amineNames, amineAbbrevs,
        (* color-related variables *)
        colorSignatures,
        (* clumplates *)
        nacClumplate, amineClumplate,
        (* glycan clump variables *)
        baseClumps, nacClumps, amineClumps,
        (* maps *)
        baseMap, nacMap, amineMap
    },

    (* pre-specify all base names for glycans *)
    baseAbbrevs = {"Hex", "Glc", "Man", "Gal", "Gul", "Alt", "All", "Tal","Ido"};

    (* write out the chemical base names *)
    baseNames = {
        "Hexose", "D-Glucose", "D-Mannose", "D-Galactose", "D-Gulose",
        "L-Altose", "D-Allose", "D-Talose", "L-Idose"
    };

    (* create n-acetyl modified names *)
    nacNames = createNAcName /@ baseNames;
    nacAbbrevs = (StringJoin[#, "NAc"]&) /@ baseAbbrevs;

    (* create aminated modified names *)
    amineNames = createAmineName /@ baseNames;
    amineAbbrevs = (StringJoin[#, "N"]&) /@ baseAbbrevs;

    (* define the color signatures *)
    colorSignatures = {
      {1, 1, 1}, GlycanBlue, GlycanGreen, GlycanYellow, GlycanOrange,
      GlycanPink, GlycanPurple, GlycanLightBlue, GlycanBrown
    };

    (* map thread the clumps *)
    baseClumps = MapThread[
        GlycanConstructor[
            "Glycan", #1, #2, #3
        ] &,
        {baseNames, baseAbbrevs, colorSignatures}
    ];

    (* TODO: finish this before leaving *)
    (* create new clumplates that use different shapes for the amine and nac clumplates *)
    nacClumplate = Clump[{
    	InheritFrom -> {"Glycan"},
        Clumplate -> True,
    	Shape:>With[{dynamicCenter=$This[Center]},Rectangle[dynamicCenter-1,dynamicCenter+1]]
    }];

    amineClumplate = Clump[{
    	InheritFrom -> "Glycan",
    	Clumplate -> True,
    	Shape:>With[{center=$This[Center]},
        {
    		Style[Triangle[{
                center-1,MapThread[#1-#2&,{center,{1,-1}}],center+{1,-1}
            }], White],
    		Triangle[{center+1,MapThread[#1-#2&,{center,{1,-1}}],center+{1,-1}}]
    	}]
    }];

    (* using the new clumplates, make the NAc clumps *)
    nacClumps = MapThread[
        GlycanConstructor[
            nacClumplate, #1, #2, #3
        ] &,
        {nacNames, nacAbbrevs, colorSignatures}
    ];

    (* make the amine clumps *)
    amineClumps = MapThread[
        GlycanConstructor[
            amineClumplate, #1, #2, #3
        ] &,
        {amineNames, amineAbbrevs, colorSignatures}
    ];

    (* make the sub-maps for each of the created clumps *)
    baseMap = Thread[baseAbbrevs -> baseClumps];
    nacMap = Thread[nacAbbrevs -> nacClumps];
    amineMap = Thread[amineAbbrevs -> amineClumps];

    (* join them all of the sub-maps and return *)
    Join[baseMap, nacMap, amineMap]
];

createAmineName[baseName_String] := StringJoin[StringMost[baseName], "amine"];
createNAcName[baseName_String] := Module[
    {amine},
    amine = createAmineName[baseName];
    StringJoin["N-Acetyl-", amine]
];

(* ::Subsection:: *)
(*AvailableGlycans*)
AvailableGlycans[]:=Module[
    {},
    If[Not[MatchQ[$GlycanMap, {_Rule..}]],
        $GlycanMap = createGlycanMap[]
    ];
    Keys[$GlycanMap]
];








(* ::Subsection:: *)
(*GlycanSequence*)

(* Messages *)
GlycanSequence::InvalidGlycans = "Some input glycans in the sequence were invalid: `1`. Look at AvailableGlycans[], and try again.";

(* main code *)
GlycanSequence[sequence_String] := Module[
    {glycanStrings, glycans, badSequenceQ},

    (* split on dashes *)
    glycanStrings = StringSplit[sequence, "-"];

    (* create glycan clumps for each split *)
    glycans = Quiet[Glycan /@ glycanStrings, {Glycan::InvalidInput}];

    (* check for failures *)
    badSequenceQ = MatchQ[#, $Failed] & /@ glycans;
    If[Or @@ badSequenceQ,
        Message[GlycanSequence::InvalidGlycans, PickList[glycanStrings, badSequenceQ]];
        Return[$Failed]
    ];

    (* create clump glycan sequence *)
    Clump[{
        InheritFrom -> {"GlycanSequence"},
        Glycans :> ClumpList[glycans]
    }]
];









(* ::Subsection:: *)
(*GlycanStructure*)

(* Messages *)
GlycanStructure::InvalidBonds="Some of the bonds contained indices that do not map to any of the input sequences.";

(* main code *)
GlycanStructure[sequences : {_Clump?GlycanSequenceQ ..}, bonds : {_Rule ..}] := Module[
    {clumpListSequences, bondIndices},

    (* turn sequence list into a clumplist *)
    clumpListSequences = ClumpList[sequences];

    (* check that the are not outside the indices of the sequences *)
    bondIndices = Union[First/@bonds, Last/@bonds];
    If[Not[ContainsAll[clumpListSequences[Indices], bondIndices]],
        Message[GlycanStructure::InvalidBonds];
        Return[$Failed]
    ];

    (* make the structure clump *)
    Clump[{
        InheritFrom -> {"GlycanStructure"},
        (*
            if sequences is a clump, then it's likely a clump list
        *)
        Sequences -> clumpListSequences,
        Bonds -> bonds
    }]
];











(* ::Subsection:: *)
(*Glycan Q-functions*)


GlycanQ[glycan_]:=Quiet[Module[
    {inheritances},
    (* find all inheritances *)
    inheritances = findAllInheritances[glycan];
    TrueQ[ContainsAll[inheritances, {"Glycan"}]]
]];
GlycanSequenceQ[sequence_]:=Quiet[TrueQ[
    ContainsAll[findAllInheritances[sequence], {"GlycanSequence"}]
]];
GlycanStructureQ[sequence_]:=Quiet[TrueQ[
    ContainsAll[findAllInheritances[sequence], {"GlycanStructure"}]
]];

(* helper to find all inheritances *)
findAllInheritances[clump_Clump]:=Module[
    {inheritanceReaps},
    inheritanceReaps = Reap[findAllInheritancesRecursively[clump]];
    Flatten[inheritanceReaps[[2]]]
];
findAllInheritances[input_]:={};
findAllInheritancesRecursively[clump_]:=Module[
    {inheritances, clumpInheritances},

    (* look up the next inheritances from the clump and sow them upstream *)
    inheritances = Sow[ReplaceAll[
        ToList[clump[InheritFrom]],
        $Failed -> Nothing
    ]];

    (* find the clumpy inheritances for recursion *)
    clumpInheritances = Cases[inheritances, _Clump];

    (* recurse over the clumpy inheritances *)
    Map[findAllInheritancesRecursively, clumpInheritances]
];


(* Helper Function for Overlapping Glycan Plots *)
checkOverlap1D[range1_, range2_] := Module[{sortedRanges},
    sortedRanges = Sort[{range1, range2}];
    (* Highest lower bound is below other upper bound. *)
    sortedRanges[[2]][[1]] <= sortedRanges[[1]][[2]]
];

checkOverlap2D[{xbound1_, ybound1_}, {xbound2_, ybound2_}] :=
    Module[{},
        AllTrue[{
            checkOverlap1D[xbound1, xbound2],
            checkOverlap1D[ybound1, ybound2]
        }, TrueQ
        ]
    ];
