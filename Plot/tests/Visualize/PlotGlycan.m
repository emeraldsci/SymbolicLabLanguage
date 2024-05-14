(* ::Section:: *)
(*PlotGlycan*)
DefineTests[PlotGlycan,
    {
        Example[{Basic, "Plot a mannose glycan using its abbreviation:"},
            PlotGlycan["Man"],
            _Graphics
        ],
        Example[{Basic, "Plot a glucosamine glycan using its abbreviation:"},
            PlotGlycan["GlcN"],
            _Graphics
        ],
        Example[{Basic, "Plot an N-acetyl-galactosamine glycan using its abbreviation:"},
            PlotGlycan["GalNAc"],
            _Graphics
        ],

        (* ----- Options tests ----- *)
        Example[{Options, ImageSize, "Make a larger mannose plot with the ImageSize option:"},
            PlotGlycan["Man", ImageSize->50],
            _Graphics
        ]
    }
];


(* ::Section:: *)
(*PlotGlycanSequence*)
DefineTests[PlotGlycanSequence,
    {
        Example[{Basic, "Plot a mannose glycan sequence using abbreviations separated by dashes:"},
            PlotGlycanSequence["Man-Man-Man"],
            _Graphics
        ],
        Example[{Basic, "Plot a mixed glycan sequence using proper abbreviations:"},
            PlotGlycanSequence["Man-GlcN-GalNAc"],
            _Graphics
        ],

        (* ----- Options tests ----- *)
        Example[{Options, ImageSize, "Make a larger mannose sequence plot with the ImageSize option:"},
            PlotGlycanSequence["Man-Man-Man", ImageSize->50],
            _Graphics
        ],
        Example[{Options, GlycanDistance, "Change the separation between glycan subunits with the GlycanDistance option:"},
            PlotGlycanSequence["Man-Man-Man", GlycanDistance->5],
            _Graphics
        ]
    }
];


(* ::Section:: *)
(*PlotGlycanStructure*)
DefineTests[PlotGlycanStructure,
    {
        Example[{Basic, "Plot a branched mannose glycan structure using glycan sequences and bonds as inputs:"},
            PlotGlycanStructure[
                {GlycanSequence["Man-Man-Man"], GlycanSequence["Man-Man"], GlycanSequence["Man-Man-Man-Man"]},
                {1->2, 1->3}
            ],
            Rotate[_Graphics, ___]
        ],
        Example[{Basic, "Plot a branched glycan structure with mixed glycan sequences:"},
            PlotGlycanStructure[
                {GlycanSequence["ManN-ManNAc-Glc"], GlycanSequence["HexN-AllNAc"], GlycanSequence["GalN-GulNAc-AltN-Man"]},
                {1->2, 1->3}
            ],
            Rotate[_Graphics, ___]
        ],

        (* ----- Options tests ----- *)
        Example[{Options, ImageSize, "Make a larger mannose structure plot with the ImageSize option:"},
            PlotGlycanStructure[
                {GlycanSequence["Man-Man-Man"], GlycanSequence["Man-Man"], GlycanSequence["Man-Man-Man-Man"]},
                {1->2, 1->3},
                ImageSize->100
            ],
            Rotate[_Graphics, ___]
        ],
        Example[{Options, GlycanDistance, "Change the separation between glycan subunits with the GlycanDistance option:"},
            PlotGlycanStructure[
                {GlycanSequence["ManN-ManNAc-Glc"], GlycanSequence["HexN-AllNAc"], GlycanSequence["GalN-GulNAc-AltN-Man"]},
                {1->2, 1->3},
                GlycanDistance->5
            ],
            Rotate[_Graphics, ___]
        ],
        Example[{Options, BranchLength, "Change the branch separation between glycan sequences with the BranchLength option:"},
            PlotGlycanStructure[
                {GlycanSequence["ManN-ManNAc-Glc"], GlycanSequence["HexN-AllNAc"], GlycanSequence["GalN-GulNAc-AltN-Man"]},
                {1->2, 1->3},
                BranchLength->6
            ],
            Rotate[_Graphics, ___]
        ],
        Example[{Options, PlotAngle, "Rotate the glycan structure plot with the PlotAngle option:"},
            PlotGlycanStructure[
                {GlycanSequence["ManN-ManNAc-Glc"], GlycanSequence["HexN-AllNAc"], GlycanSequence["GalN-GulNAc-AltN-Man"]},
                {1->2, 1->3},
                PlotAngle->90 Degree
            ],
            Rotate[_Graphics, ___]
        ]
    }
];
