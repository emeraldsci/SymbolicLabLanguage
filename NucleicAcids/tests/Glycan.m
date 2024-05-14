
DefineTests[Glycan,
    {
        Example[{Basic, "Make a mannose glycan using the abbreviation:"},
            Glycan["Man"],
            _Clump
        ],
        Example[{Basic, "Make an altosamine glycan using the abbreviation:"},
            Glycan["AltN"],
            _Clump
        ],
        Example[{Basic, "Make an N-acetyl-glucosamine glycan using its abbreviation:"},
            Glycan["GlcNAc"],
            _Clump
        ],

        (* ----- Message tests ----- *)
        Example[{Messages, "InvalidInput", "Using an abbreviation with a typo leads to an error:"},
            Glycan["Gluc"],
            $Failed,
            Messages :> {Glycan::InvalidInput}
        ]
    }
];


(* GlycanSequence tests *)
DefineTests[GlycanSequence,
    {
        Example[{Basic, "Make a 3 unit long glycan sequence comprised of only mannose subunits:"},
            GlycanSequence["Man-Man-Man"],
            _Clump
        ],
        Example[{Basic, "Make a mixed glycan sequence comprised of only mannose, galactose, and allose subunits:"},
            GlycanSequence["Man-Gal-All"],
            _Clump
        ],
        Example[{Basic, "Change a glycan in the sequence after its initial creation:"},
            Module[
                {sequence},
                sequence = GlycanSequence["Man-Gal-All"];
                (*ClumpSet[sequence[Glycans], 1 -> Glycan["Alt"]];*)
                sequence[Glycans, 1] = Glycan["Alt"];
                sequence[Glycans, 1, GlycanName]
            ],
            "L-Altose"
        ],

        (* ----- Message tests ----- *)
        Example[{Messages, "InvalidGlycans", "Including an invalid glycan abbreviation causes an error:"},
            GlycanSequence["Man-Man-Mann"],
            $Failed,
            Messages :> {GlycanSequence::InvalidGlycans}
        ]
    }
];


(* GlycanStructure tests *)
DefineTests[GlycanStructure,
    {
        Example[{Basic, "Make a Y-shaped branched structure of 3 glycan sequences:"},
            GlycanStructure[
                {GlycanSequence["Man-Man-Man"], GlycanSequence["GlcNAc-AllN"], GlycanSequence["AltN-HexNAc"]},
                {1->2, 1->3}
            ],
            _Clump
        ],
        Example[{Basic, "Change a glycan sequence in an already created structure:"},
            Module[
                {structure},
                structure = GlycanStructure[
                    {GlycanSequence["Man-Man-Man"], GlycanSequence["GlcNAc-AllN"], GlycanSequence["AltN-HexNAc"]},
                    {1->2, 1->3}
                ];
                structure[Sequences, 2] = GlycanSequence["Glc-All"];
                structure
            ],
            _Clump
        ],
        Example[{Basic, "Change a single glycan in an already created structure:"},
            Module[
                {structure},
                structure = GlycanStructure[
                    {GlycanSequence["Man-Man-Man"], GlycanSequence["GlcNAc-AllN"], GlycanSequence["AltN-HexNAc"]},
                    {1->2, 1->3}
                ];
                structure[Sequences, 2, Glycans, 1] = Glycan["Glc"];
                structure[Sequences, 2, Glycans, 1, GlycanName]
            ],
            "D-Glucose"
        ],

        (* ----- Message tests ----- *)
        Example[{Messages, "InvalidBonds", "Attempting to bond sequences indices that are outside the number of input sequences results in an error:"},
            GlycanStructure[
                {GlycanSequence["Man-Man-Man"], GlycanSequence["GlcNAc-AllN"], GlycanSequence["AltN-HexNAc"]},
                {1->2, 1->5}
            ],
            $Failed,
            Messages :> {GlycanStructure::InvalidBonds}
        ]
    }
];


(* GlycanQ *)
DefineTests[GlycanQ,
    {
        Example[{Basic, "Test a mannose glycan:"},
            GlycanQ[Glycan["Man"]],
            True
        ],
        Example[{Basic, "Test an altosamine glycan:"},
            GlycanQ[Glycan["AltN"]],
            True
        ],
        Example[{Basic, "Evaluating for a sequence returns False:"},
            GlycanQ[GlycanSequence["GlcNAc-GulNAc"]],
            False
        ]
    }
];


(* GlycanSequenceQ *)
DefineTests[GlycanSequenceQ,
    {
        Example[{Basic, "Test a mannose glycan sequence:"},
            GlycanSequenceQ[GlycanSequence["Man-Man-Man"]],
            True
        ],
        Example[{Basic, "Test an aminated glycan sequence:"},
            GlycanSequenceQ[GlycanSequence["AltN-AllN-TalN"]],
            True
        ],
        Example[{Basic, "Evaluating on a Glycan returns False:"},
            GlycanSequenceQ[Glycan["GlcNAc"]],
            False
        ]
    }
];

(* GlycanStructureQ *)
DefineTests[GlycanStructureQ,
    {
        Example[{Basic, "Test a mannose glycan structure:"},
            GlycanStructureQ[GlycanStructure[
                {GlycanSequence["Man-Man"], GlycanSequence["Man-Man"], GlycanSequence["Man-Man"]},
                {1->2, 1->3}
            ]],
            True
        ],
        Example[{Basic, "Test a aminated glycan structure:"},
            GlycanStructureQ[GlycanStructure[
                {GlycanSequence["AltN-ManN"], GlycanSequence["AllN-GulN"], GlycanSequence["GalN-TalN"]},
                {1->2, 1->3}
            ]],
            True
        ],
        Example[{Basic, "Evaluating on a GlycanSequence returns False:"},
            GlycanStructureQ[GlycanSequence["Man-Man"]],
            False
        ]
    }
];

(* AvailableGlycans *)
DefineTests[AvailableGlycans,
    {
        Example[{Basic, "Evaluation returns a list of supported glycans:"},
            AvailableGlycans[],
            {_String..}
        ],
        Example[{Basic, "The available glycans contains galactose:"},
            ContainsAll[AvailableGlycans[], {"Gal"}],
            True
        ],
        Example[{Basic, "The available glycans contains gulosamine:"},
            ContainsAll[AvailableGlycans[], {"GulN"}],
            True
        ]
    }
];
