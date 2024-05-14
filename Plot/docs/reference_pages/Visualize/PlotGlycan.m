(* ::Section:: *)
(*PlotGlycan*)
DefineUsage[PlotGlycan,
    {
        BasicDefinitions -> {
            {
                Definition -> {"PlotGlycan[Abbrev]", "Graphic"},
                Description -> "plots a glycan 'Graphic' according to the input 'Abbrev'.",
                Inputs :> {
                    {
                        InputName -> "Abbrev",
                        Description -> "A commonly accepted abbreviation of a glycan.",
                        Widget -> Widget[Type->String, Pattern:>_String, Size->Word]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "Graphic",
                        Description -> "A visual representation of the glycan corresponding to the input abbreviation.",
                        Pattern :> ValidGraphicsP[]
                    }
                }
            }
        },
        SeeAlso -> {
            "PlotGlycanSequence",
            "PlotGlycanStructure",
            "Glycan",
            "GlycanSequence",
            "GlycanStructure"
        },
        Author -> {"tommy.harrelson"}
    }
];


(* ::Section:: *)
(*PlotGlycanSequence*)
DefineUsage[PlotGlycanSequence,
    {
        BasicDefinitions -> {
            {
                Definition -> {"PlotGlycanSequence[sequenceString]", "graphic"},
                Description -> "plots a glycan sequence 'graphic' according to the input 'sequenceString'.",
                Inputs :> {
                    {
                        InputName -> "sequenceString",
                        Description -> "A string of commonly accepted glycan abbreviations separated by dashes.",
                        Widget -> Widget[Type->String, Pattern:>_String, Size->Word]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "graphic",
                        Description -> "A visual representation of the glycan sequence corresponding to the input.",
                        Pattern :> ValidGraphicsP[]
                    }
                }
            }
        },
        SeeAlso -> {
            "PlotGlycan",
            "PlotGlycanStructure",
            "Glycan",
            "GlycanSequence",
            "GlycanStructure"
        },
        Author -> {"tommy.harrelson"}
    }
];


(* ::Section:: *)
(*PlotGlycanStructure*)
DefineUsage[PlotGlycanStructure,
    {
        BasicDefinitions -> {
            {
                Definition -> {"PlotGlycanStructure[sequences, bonds]", "graphic"},
                Description -> "plots a glycan structure 'graphic' given a list of 'sequences' and 'bonds'.",
                Inputs :> {
                    {
                        InputName -> "sequences",
                        Description -> "A list of GlycanSequence's that are constructed from a string of abbreviations separated by dashes.",
                        Widget -> Widget[Type->Expression, Pattern:>_?GlycanSequenceQ, Size->Word]
                    },
                    {
                        InputName -> "bonds",
                        Description -> "A list of rules that describe which sequences are bound together.",
                        Widget -> Adder[
                            Widget[Type->Expression, Pattern:>Rule[_Integer,_Integer], Size->Word]
                        ]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "graphic",
                        Description -> "A visual representation of the glycan structure corresponding to the input.",
                        Pattern :> Rotate[ValidGraphicsP[],___]
                    }
                }
            }
        },
        SeeAlso -> {
            "PlotGlycan",
            "PlotGlycanSequence",
            "Glycan",
            "GlycanSequence",
            "GlycanStructure"
        },
        Author -> {"tommy.harrelson"}
    }
];
