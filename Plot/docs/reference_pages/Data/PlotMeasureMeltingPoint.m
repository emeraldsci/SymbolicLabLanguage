(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotMeasureMeltingPoint*)


DefineUsage[PlotMeasureMeltingPoint,
    {
        BasicDefinitions -> {
            {
                Definition->{"PlotMeasureMeltingPoint[meltingPointData]", "plot"},
                Description->"provides a graphical 'plot' of the provided 'meltingPointData.",
                Inputs:>{
                    {
                        InputName->"meltingPointData",
                        Description->"The melting point data you wish to plot.",
                        Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data, MeltingPoint]]]
                    }
                },
                Outputs:>{
                    {
                        OutputName->"plot",
                        Description->"A graphical representation of the melting point data.",
                        Pattern:>ValidGraphicsP[]
                    }
                }
            },
            {
                Definition -> {"PlotMeasureMeltingPoint[protocol]", "plot"},
                Description -> "creates a 'plot' of the melting point data found in the Data field of 'protocol'.",
                Inputs :> {
                    {
                        InputName -> "protocol",
                        Description -> "The protocol object containing melting point data objects.",
                        Widget -> Alternatives[
                            Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, MeasureMeltingPoint]]]
                        ]
                    }
                },
                Outputs :> {
                    {
                        OutputName -> "plot",
                        Description -> "The figure generated from data found in the MeasureMeltingPoint protocol.",
                        Pattern :> ValidGraphicsP[]
                    }
                }
            }
        },
        SeeAlso -> {},
        Author -> {"scicomp"},
        Preview->True
    }
];
