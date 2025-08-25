(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*AliquotContainers*)


DefineUsage[AliquotContainers,
    {
        BasicDefinitions->{
            {
                Definition->{"AliquotContainers[myInstrument,mySample]","potentialAliquotContainers"},
                Description->"returns the potential the preferred containers that can both hold all of the volume of 'mySample' and fit on 'myInstrument'.",
                Inputs:>{
                    IndexMatching[
                        {
                            InputName->"myInstrument",
                            Description->"The instrument that we want to put 'mySample' on.",
                            Widget->Widget[
                                Type->Expression,
                                Pattern:>ObjectP[Model[Instrument]],
                                Size->Line
                            ],
                            Expandable->False
                        },
                        IndexName->"instruments"
                    ],
                    {
                        InputName->"mySample",
                        Description->"The sample that we want to put on 'myInstrument'.",
                        Widget->Widget[
                            Type->Expression,
                            Pattern:>ObjectP[Object[Sample]],
                            Size->Line
                        ],
                        Expandable->False
                    }
                },
                Outputs:>{
                    {
                        OutputName->"potentialAliquotContainers",
                        Description->"The preferred containers that can both hold all of the volume of 'mySample' and fit on 'myInstrument'.",
                        Pattern:>{ObjectP[Model[Container]]..}
                    }
                }
            }
        },
        SeeAlso->{
            "CompatibleFootprintQ",
            "UploadStorageCondition",
            "Upload"
        },
        Author->{"ben", "tyler.pabst", "charlene.konkankit", "thomas"}
    }];


(* ::Subsection::Closed:: *)
(*CompatibleFootprintQ*)


DefineUsage[CompatibleFootprintQ,
    {
        BasicDefinitions->{
            {
                Definition->{"CompatibleFootprintQ[myLocation,mySample]","compatibleFootprintQ"},
                Description->"returns a boolean that indicates if 'mySample' can fit onto one of the positions of 'myLocation'.",
                Inputs:>{
                    IndexMatching[
                        {
                            InputName->"myLocation",
                            Description->"The instrument or container that we want to put 'mySample' into.",
                            Widget->Widget[
                                Type->Expression,
                                Pattern:>{ObjectP[{Model[Instrument],Model[Container]}]..},
                                Size->Line
                            ],
                            NestedIndexMatching->True,
                            Expandable->False
                        },
                        {
                            InputName->"mySample",
                            Description->"The sample that we want to put on 'myLocation'.",
                            Widget->Widget[
                                Type->Expression,
                                Pattern:>ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample], Model[Container]}]],
                                Size->Line
                            ],
                            Expandable->False
                        },
                        IndexName->"locationAndSamples"
                    ]
                },
                Outputs:>{
                    {
                        OutputName->"compatibleFootprintQ",
                        Description->"Indicates if 'mySample' can fit onto one of the positions of 'myLocation'.",
                        Pattern:>BooleanP
                    }
                }
            }
        },
        SeeAlso->{
            "AliquotContainers",
            "UploadStorageCondition",
            "Upload"
        },
        Author->{"xu.yi", "waseem.vali", "malav.desai", "thomas", "wyatt"}
    }];

(* ::Subsection::Closed:: *)
(*RackFinder*)


DefineUsage[RackFinder,
    {
        BasicDefinitions->{
            {
                Definition->{"RackFinder[mySample]","compatibleModelRack"},
                Description->"returns a model rack that 'mySample' can fit onto one of the positions, or Null if a rack is not found.",
                Inputs:>{
                    {
                        InputName->"mySample",
                        Description->"The sample for which we want to identify a model rack.",
                        Widget->Widget[
                            Type->Expression,
                            Pattern:>ListableP[ObjectP[Object[Sample],Model[Container],Object[Container]]],
                            Size->Line
                        ],
                        Expandable->False
                    }
                },
                Outputs:>{
                    {
                        OutputName->"compatibleModelRack",
                        Description->"The model rack on which mySample can fit.",
                        Pattern:>ListableP[ObjectP[Model[Container,Rack]]]
                    }
                }
            }
        },
        SeeAlso->{
            "CompatibleFootprintQ"
        },
        Author->{"xu.yi", "waseem.vali", "malav.desai", "steven"}
    }];