
DefineTests[AddTracingDefinition,{

    Test["Adds tracing definition to top",
        Module[{f},
            f[x_] := x^2;
            AddTracingDefinition[f,<||>];
            (* square definition should be second *)
            MatchQ[DownValues[f], {_, RuleDelayed[_, Power[_,2]]}]
        ],
        True
    ],
    Test["Tracing definition gets hit:",
        Module[{f},
            f[x_] := x^2;
            AddTracingDefinition[f,<||>];
            Block[{ECL`Web`TraceExpression},
                ECL`Web`TraceExpression[name_, _] := Throw[name, "TraceTest"];
            Catch[f[3], "TraceTest"]
        ]],
        _String?(StringStartsQ[#,"f"]&)
    ],
        Test["Tags get set:",
        Module[{f},
            f[x_] := x^2;
            AddTracingDefinition[f,<|"sll.function.category"->"Test"|>];
            Block[{ECL`Web`TraceExpression},
                ECL`Web`TagTrace["sll.function.category", "Test"] := Throw[True, "Tag"];
            Catch[f[3], "Tag"]
        ]],
        True
    ],

    Test["Regular definition still gets hit",
        Module[{f},
            f[x_] := x^2;
            AddTracingDefinition[f,<||>];
            f[2]
        ],
        4
    ],


    Test["All functions have tracing definitions on top:",
        Module[{plotFunctions, analysisFunctions, definitionContainsTraceBlockerQ},
            plotFunctions = Map[ Symbol, Flatten[ Values[ $CommandBuilderFunctions["Plot"] ] ] ];
            analysisFunctions = Map[ Symbol, Flatten[ Values[ $CommandBuilderFunctions["Analysis"] ] ] ];
            (* does left-hand side of first (top) definition contain the tracklog blocking symbol? *)
            definitionContainsTraceBlockerQ[symbol_Symbol] := StringContainsQ[ToString[DownValues[symbol][[1,1]]], "$tracelog"];
            (* 
                for some reason, PlotObject has an empty definition first ( PlotObject[{}] = {} ).  not sure how that ends up on top.  must be added somewhere after mine is added
                doesn't affect tracing real calls so just ignoring it for now
            *)
            definitionContainsTraceBlockerQ[ECL`PlotObject] := StringContainsQ[ToString[DownValues[ECL`PlotObject][[2,1]]], "$tracelog"]; 

            (* returning this way instead of single bool so that it's easier to figure out what (if anything) failed *)
            {
                "Plot" -> Select[ plotFunctions, Not[definitionContainsTraceBlockerQ[#]]& ],
                "Analysis" -> Select[ analysisFunctions, Not[definitionContainsTraceBlockerQ[#]]& ]
            }
        ],

        { Rule[_String, { }] .. }

    ],


    (*
        Block TraceExpression and turn it into a Throw, which throws the name of the function it's tracing, and Catch that
    *)
    Test["Plot call hits TraceExpression:",
        Block[{ECL`Web`TraceExpression},
            ECL`Web`TraceExpression[name:"EmeraldListLinePlot", _] := Throw[name, "TraceTest"];
            Catch[EmeraldListLinePlot[{{1, 2}, {3, 4}, {5, 6}}], "TraceTest"]
        ],
            "EmeraldListLinePlot"
     ],
    Test["Analysis call hits TraceExpression:",
        Block[{ECL`Web`TraceExpression},
            ECL`Web`TraceExpression[name:"AnalyzeFit", _] := Throw[name, "TraceTest"];
            Catch[AnalyzeFit[{{1, 2}, {3, 4}, {5, 6}},Upload->False], "TraceTest"]
        ],
            "AnalyzeFit"
     ]


}];