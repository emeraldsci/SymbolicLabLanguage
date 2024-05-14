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
                Description->"provides a graphical plot the provided mass spectra.",
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
            }
        },
        SeeAlso -> {},
        Author -> {"scicomp"},
        Preview->True
    }
];
