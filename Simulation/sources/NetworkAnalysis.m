(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Network Analysis*)


(* ::Subsubsection::Closed:: *)
(*reactionsToGraphU*)

Authors[reactionsToGraphU]:={"scicomp", "brad"};
reactionsToGraphU[reactions_] :=
    Graph[reactions/.{Rule[a_,b_]:> a<->b,Equilibrium[a_,b_]:>a<->b}];


(* ::Subsubsection::Closed:: *)
(*reactionsToGraphD*)

Authors[reactionsToGraphD]:={"scicomp", "brad"};

reactionsToGraphD[reactions_] :=
    Graph[reactions/.{Rule[a_,b_]:> a\[DirectedEdge]b,Equilibrium[a_,b_]:>Sequence@@{a\[DirectedEdge]b,b\[DirectedEdge]a}}];


(* ::Subsubsection::Closed:: *)
(*networkDefficiency*)


networkDefficiency[reactions_] :=
    Module[ {d,l,n,s,graph},
        graph = reactionsToGraphU[reactions];
        s = MatrixRank[stoichiometricMatrix[reactions]];
        l = Length[linkageClasses[graph]];
        n = VertexCount[graph];
        d = n-l-s
    ];


(* ::Subsubsection::Closed:: *)
(*analyzeNetwork*)


analyzeNetworkTable[reactions_] :=
    Module[ {symbolReactions,stringVars},
		stringVars=Union[Cases[reactions,_String,Infinity]];
		symbolReactions=reactions/.Thread[Rule[stringVars,Unique/@stringVars]];
        TableForm[{
        {"ReactionMechanism",ToString[reactions]},
        {"Species",ToString[SpeciesList[reactions]]},
        {"Structures",ToString[SpeciesList[reactions,Attributes->Complex]]},
        {"Linkages",ToString[linkageClasses[reactions]]},
        {"Defficiency",ToString[networkDefficiency[symbolReactions]]},
        {"Reversibility",If[ StronglyReversibleNetworkQ[symbolReactions],
                             "Strong",
                             If[ WeaklyReversibleNetworkQ[symbolReactions],
                                 "Weak",
                                 "None"
                             ]
                         ]},
        {"Equilibrium",If[ WeaklyReversibleNetworkQ[symbolReactions]&&ZeroDefficiencyNetworkQ[symbolReactions],
                           "Non-zero steady-state",
                           "Some species converge to zero"
                       ]},
        {"Strictly Decreasing Species",ToString[SpeciesList[reactions,Attributes->StrictlyDecreasing]]},
        {"Strictly Increasing Species",ToString[SpeciesList[reactions,Attributes->StrictlyIncreasing]]},
        {"",""}
        }]
    ];


ZeroDefficiencyNetworkQ[reactions_] :=
    Module[ {d,l,n,s,graph},
        graph = reactionsToGraphU[reactions];
        s = MatrixRank[stoichiometricMatrix[reactions]];
        l = Length[linkageClasses[graph]];
        n = VertexCount[graph];
        d = n-l-s;
        If[ d==0,
            True,
            False
        ]
    ];

WeaklyReversibleNetworkQ[reactions:{(_Rule|_Equilibrium)..}] :=
    WeaklyReversibleNetworkQ[reactionsToGraphD[reactions]];
WeaklyReversibleNetworkQ[reactionsGraph_Graph] :=
    With[ {mat = GraphDistanceMatrix[reactionsGraph]},
        If[ Position[mat,Infinity]==Position[Transpose[mat],Infinity],
            True,
            False
        ]
    ];

StronglyReversibleNetworkQ[reactions:{(_Rule|_Equilibrium)..}] :=
    StronglyReversibleNetworkQ[reactionsToGraphD[reactions]];
StronglyReversibleNetworkQ[reactionsGraph_Graph] :=
    With[ {mat = GraphDistanceMatrix[reactionsGraph]},
        If[ mat==Transpose[mat],
            True,
            False
        ]
    ]



(* ::Section:: *)
(*End*)