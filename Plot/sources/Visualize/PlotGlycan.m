
(* ::Subsection:: *)
(*PlotGlycan*)

DefineOptions[PlotGlycan,
    Options :> {
        {
            OptionName -> ImageSize,
            Description -> "The size of the picture used to represent the glycan.",
            Default -> 25,
            AllowNull -> False,
            Widget -> Widget[Type->Number, Pattern:>RangeP[1,1000,1]],
            Category -> "General"
        }
    }
];

(* source code *)
PlotGlycan[glycanAbbreviation_String, myOps:OptionsPattern[]]:=Module[
    {glycanClump, safeOps},

    glycanClump = Glycan[glycanAbbreviation];

    safeOps = SafeOptions[PlotGlycan, ToList[myOps]];

    (* set the image size of the glycan according to the options *)
    glycanClump[ImageSize] = Lookup[safeOps, ImageSize];

    (* dereference the plot from the clump *)
    glycanClump[Plot]
];


(* ::Subsection:: *)
(*PlotGlycanSequence*)

DefineOptions[PlotGlycanSequence,
    Options :> {
        {
            OptionName -> GlycanDistance,
            Description -> "The distance between glycan graphics.",
            Default -> 3,
            AllowNull -> False,
            Widget -> Widget[Type->Number, Pattern:>RangeP[0.1,20]],
            Category -> "General"
        }
    },
    SharedOptions :> {PlotGlycan}
];

(* source code *)
PlotGlycanSequence[glycanSequence_String, myOps:OptionsPattern[]]:=Module[
    {glycanClump, safeOps},

    glycanClump = GlycanSequence[glycanSequence];

    safeOps = SafeOptions[PlotGlycanSequence, ToList[myOps]];

    (* set the image sizes of the glycans according to the options *)
    Map[
        ClumpSet[
            glycanClump[Glycans, #, ImageSize]&,
            ImageSize -> Lookup[safeOps, ImageSize]
        ],
        glycanClump[Glycans, Indices]
    ];

    (* set the glycan length from the options *)
    glycanClump[GlycanDistance] = Lookup[safeOps, GlycanDistance];

    (* dereference the plot from the clump *)
    glycanClump[Plot]
];


(* ::Subsection:: *)
(*PlotGlycanStructure*)
DefineOptions[PlotGlycanStructure,
    Options :> {
        {
            OptionName -> BranchLength,
            Description -> "The distance between glycan sequence graphics in the branched structure.",
            Default -> 4,
            AllowNull -> False,
            Widget -> Widget[Type->Number, Pattern:>RangeP[0.1,20]],
            Category -> "General"
        },
        {
            OptionName -> PlotAngle,
            Description -> "The distance between glycan sequence graphics in the branched structure.",
            Default -> 0 Degree,
            AllowNull -> False,
            Widget -> Widget[Type->Number, Pattern:>RangeP[-360 Degree, 360 Degree]],
            Category -> "General"
        },
        {
            OptionName -> ImageSize,
            Description -> "The size of the picture used to represent the glycan structure.",
            Default -> 50,
            AllowNull -> False,
            Widget -> Widget[Type->Number, Pattern:>RangeP[1,1000,1]],
            Category -> "General"
        }
    },
    SharedOptions :> {PlotGlycanSequence}
];

(* source code *)
PlotGlycanStructure[
    sequences:{_?(GlycanSequenceQ)..},
    bonds: {_Rule..},
    myOps:OptionsPattern[]
]:=Module[
    {glycanClump, safeOps},

    glycanClump = GlycanStructure[sequences, bonds];

    safeOps = SafeOptions[PlotGlycanStructure, ToList[myOps]];

    (* set the image size of the structure *)
    glycanClump[ImageSize] = Lookup[safeOps, ImageSize];

    (* set the glycan length for each of the sequences from the options *)
    Map[
        ClumpSet[
            glycanClump[Sequences, #],
            GlycanDistance -> Lookup[safeOps, GlycanDistance]
        ]&,
        glycanClump[Sequences, Indices]
    ];

    (* set the remaining options *)
    glycanClump[PlotAngle] = Lookup[safeOps, PlotAngle];
    glycanClump[BranchLength] = Lookup[safeOps, BranchLength];

    (* dereference the plot from the clump *)
    glycanClump[Plot]
];
