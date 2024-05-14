(* ::Subsubsection:: *)
(*ExperimentSerialDilutePreview*)

DefineUsage[ExperimentSerialDilutePreview,
    {
        BasicDefinitions -> {
            {
                Definition->{"ExperimentSerialDilutePreview[Objects]","Preview"},
                Description -> "returns the preview for ExperimentSerialDilute when it is called on 'objects'.",
                Inputs:>{
                    IndexMatching[
                        {
                            InputName -> "Objects",
                            Description-> "The sample to be serially diluted.",
                            Widget->Widget[
                                Type->Object,
                                Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                                ObjectTypes->{Object[Sample],Object[Container]},
                                Dereference->{
                                    Object[Container]->Field[Contents[[All,2]]]
                                }
                            ],
                            Expandable->False
                        },
                        IndexName->"experiment samples"
                    ]
                },
                Outputs:>{
                    {
                        OutputName->"Preview",
                        Description -> "Graphical preview representing the output of ExperimentSerialDilute. This value is always Null.",
                        Pattern :> Null
                    }
                }
            }
        },
        MoreInformation -> {"This function currently does not return any preview."},
        SeeAlso -> {
            "ExperimentSerialDilute",
            "ValidExperimentDiluteQ",
            "ExperimentSerialDiluteOptions",
            "ExperimentSampleManipulation",
            "Transfer",
            "Mix",
            "Aliquot"
        },
        Author -> {"daniel.shlian", "tyler.pabst", "steven"}
    }
];



(* ::Subsection:: *)
(*ExperimentSerialDiluteOptions*)


DefineUsage[ExperimentSerialDiluteOptions,
    {
        BasicDefinitions -> {
            {
                Definition->{"ExperimentSerialDiluteOptions[objects]","calculatedOptions"},
                Description->"returns the calculated options for ExperimentSerialDiluteOptions when it is called on 'objects'.",
                Inputs:>{
                    IndexMatching[
                        {
                            InputName -> "samples",
                            Description -> "The samples to be serially diluted.",
                            Widget ->
                                Widget[
                                    Type -> Object,
                                    Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                                    Dereference -> {
                                        Object[Container] -> Field[Contents[[All, 2]]]
                                    }
                                ],

                            Expandable -> False
                        },
                        IndexName -> "experiment samples"
                    ]
                },
                Outputs:>{
                    {
                        OutputName->"calculatedOptions",
                        Description -> "Calculated options when ExperimentSerialDiluteOptions is called on the input samples.",
                        Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
                    }
                }
            }
        },
        MoreInformation -> {
            "This function returns the calculated options that would be fed to ExperimentSerialDiluteOptions if it were called on these input samples."
        },
        SeeAlso -> {
            "ExperimentSerialDilute",
            "ValidExperimentSerialDiluteQ",
            "ExperimentSampleManipulation",
            "ExperimentDilute",
            "ExperimentAliquot",
            "ExperimentTransfer"
        },
        Author -> {"daniel.shlian", "tyler.pabst", "steven"}
    }
];



(* ::Subsection:: *)
(*ValidExperimentSerialDiluteQ*)


DefineUsage[ValidExperimentSerialDiluteQ,
    {
        BasicDefinitions -> {
            {
                Definition->{"ValidExperimentSerialDiluteQ[objects]","bools"},
                Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentSerialDilute.",
                Inputs:>{
                    IndexMatching[
                        {
                            InputName -> "samples",
                            Description -> "The samples to be serially diluted.",
                            Widget ->
                                Widget[
                                    Type -> Object,
                                    Pattern :> ObjectP[{Object[Sample], Object[Container]}],
                                    Dereference -> {
                                        Object[Container] -> Field[Contents[[All, 2]]]
                                    }
                                ],

                            Expandable -> False
                        },
                        IndexName -> "experiment samples"
                    ]
                },
                Outputs:>{
                    {
                        OutputName->"bools",
                        Description -> "A True/False value indicating whether the ExperimentSerialDilute call is valid or not.",
                        Pattern :> _EmeraldTestSummary| BooleanP
                    }
                }
            }
        },
        MoreInformation -> {},
        SeeAlso -> {
            "ExperimentSerialDilute",
            "ValidExperimentSerialDiluteOptions",
            "ExperimentSampleManipulation",
            "ExperimentDilute",
            "ExperimentAliquot",
            "ExperimentTransfer"
        },
        Author -> {"daniel.shlian", "tyler.pabst", "steven"}
    }
];