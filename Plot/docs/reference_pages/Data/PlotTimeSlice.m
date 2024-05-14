
(* ::Section::Closed:: *)
(*PlotTimeSlice*)


DefineUsage[PlotTimeSlice,
    {
        BasicDefinitions -> {
            {
                Definition -> {"PlotTimeSlice[object, time]", "plot"},
                Description -> "plots a slice of a 3D field at given 'time' for the input 'object'.",
                Inputs :> {
                    {
                        InputName -> "object",
                        Description -> "The object containing the data to be plotted.",
                        Widget -> Widget[
                            Type->Object,
                            Pattern:>ObjectP[Object[Data, ChromatographyMassSpectra]],
                            ObjectTypes->{Object[Data, ChromatographyMassSpectra]}
                        ]
                    },
                    {
                        InputName -> "time",
                        Description -> "The time value that determines the slice that is plotted.",
                        Widget -> Widget[
                            Type->Quantity,
                            Pattern:>GreaterEqualP[0 Minute],
                            Units -> {Minute, {Minute, Second, Hour}}
                        ]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "plot",
                        Description -> "The mass spectrum slice you wish to plot.",
                        Pattern :> ValidGraphicsP[]
                    }
                }
            }
        },
        SeeAlso -> {"PlotMassSpectrometry", "TimeSliceSpans", "SaveTimeSliceSpans", "TimeSlice"},
        Author -> {"tommy.harrelson"}
    }
];


(* ::Section::Closed:: *)
(*TimeSlice*)


DefineUsage[TimeSlice,
    {
        BasicDefinitions -> {
            {
                Definition -> {"TimeSlice[object, time]", "slice"},
                Description -> "returns the a slice of a 3D field at the given 'time' slice for the input 'object'.",
                Inputs :> {
                    {
                        InputName -> "object",
                        Description -> "The object containing the data to be plotted.",
                        Widget -> Widget[
                            Type->Object,
                            Pattern:>ObjectP[Object[Data, ChromatographyMassSpectra]],
                            ObjectTypes->{Object[Data, ChromatographyMassSpectra]}
                        ]
                    },
                    {
                        InputName -> "time",
                        Description -> "The time value that determines the slice that is plotted.",
                        Widget -> Widget[
                            Type->Quantity,
                            Pattern:>GreaterEqualP[0 Minute],
                            Units -> {Minute, {Minute, Second, Hour}}
                        ]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "slice",
                        Description -> "The mass spectrum slice data.",
                        Pattern :> {UnitsCoordinatesP[]..}
                    }
                }
            }
        },
        SeeAlso -> {"TimeSliceSpans", "SaveTimeSliceSpans", "PlotTimeSlice"},
        Author -> {"tommy.harrelson"}
    }
];


(* ::Section::Closed:: *)
(*TimeSliceSpans*)


DefineUsage[TimeSliceSpans,
    {
        BasicDefinitions -> {
            {
                Definition -> {"TimeSliceSpans[object, field]", "spans"},
                Description -> "returns the slice spans of a 3D 'field' for the input 'object'.",
                Inputs :> {
                    {
                        InputName -> "object",
                        Description -> "The object containing the data to be plotted.",
                        Widget -> Widget[
                            Type->Object,
                            Pattern:>ObjectP[Object[Data, ChromatographyMassSpectra]],
                            ObjectTypes->{Object[Data, ChromatographyMassSpectra]}
                        ]
                    },
                    {
                        InputName -> "field",
                        Description -> "The BigQuantityArray field that will be processed to find spans.",
                        Widget -> Widget[
                            Type->Enumeration,
                            Pattern:>Alternatives[IonAbundance3D, Absorbance3D]
                        ]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "spans",
                        Description -> "An association between a time value and its indexed span, which describes the starting and ending elements of a time slice in the BigQuantityArray field.",
                        Pattern :> Association[{(UnitsP[Minute] -> {_Integer, _Integer})..}]
                    }
                }
            }
        },
        SeeAlso -> {"SaveTimeSliceSpans", "TimeSlice", "PlotTimeSlice"},
        Author -> {"tommy.harrelson"}
    }
];


(* ::Section::Closed:: *)
(*SaveTimeSliceSpans*)


DefineUsage[SaveTimeSliceSpans,
    {
        BasicDefinitions -> {
            {
                Definition -> {"SaveTimeSliceSpans[object, field]", "cloudFile"},
                Description -> "saves the slice spans of a 3D 'field' for the input 'object' to a 'cloudFile'.",
                Inputs :> {
                    {
                        InputName -> "object",
                        Description -> "The object containing the data to be plotted.",
                        Widget -> Widget[
                            Type->Object,
                            Pattern:>ObjectP[Object[Data, ChromatographyMassSpectra]],
                            ObjectTypes->{Object[Data, ChromatographyMassSpectra]}
                        ]
                    },
                    {
                        InputName -> "field",
                        Description -> "The BigQuantityArray field that will be processed to find spans.",
                        Widget -> Widget[
                            Type->Enumeration,
                            Pattern:>Alternatives[IonAbundance3D, Absorbance3D]
                        ]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "cloudFile",
                        Description -> "The spans are saved to an Amazon S3 cloud file for future use.",
                        Pattern :> ObjectP[Object[EmeraldCloudFile]]
                    }
                }
            }
        },
        SeeAlso -> {"TimeSliceSpans", "TimeSlice", "PlotTimeSlice"},
        Author -> {"tommy.harrelson"}
    }
];