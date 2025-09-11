(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: XuYi *)
(* :Date: 2025-02-24 *)

(* ::Subsection:: *)
(*PlotAdjustpH*)


DefineUsage[PlotAdjustpH,
  {
    BasicDefinitions->{
      {
        Definition->{"PlotAdjustpH[adjustpHObjects]","plot"},
        Description->"provides a graphical plot of spectra belonging to 'adjustpHObjects'.",

        Inputs:>{
          {
            InputName->"adjustpHObjects",
            Description->"One or more objects containing absorbance spectra.",
            Widget->If[
              TrueQ[$ObjectSelectorWorkaround],
              Alternatives[
                "Enter object(s):"->Widget[
                  Type->Expression,
                  Pattern:>ListableP[ObjectP[Object[Data,pHAdjustment]]],
                  Size->Line
                ],
                "Select object(s):"->Adder@Widget[
                  Type->Object,
                  Pattern:>ObjectP[Object[Data,pHAdjustment]],
                  ObjectTypes->{Object[Data,pHAdjustment]}]
              ],
              Alternatives[
                "Single Object"->Widget[
                  Type->Object,
                  Pattern:>ObjectP[Object[Data,pHAdjustment]],
                  ObjectTypes->{Object[Data,pHAdjustment]}],
                "Multiple Objects"->Adder@Widget[
                  Type->Object,
                  Pattern:>ObjectP[Object[Data,pHAdjustment]],
                  ObjectTypes->{Object[Data,pHAdjustment]}]
              ]
            ]
          }
        },
        Outputs:>{
          {
            OutputName->"plot",
            Description->"A graphical representation of the spectra.",
            Pattern:>ValidGraphicsP[]
          }
        }
      },
      {
        Definition -> {"PlotAdjustpH[protocol]", "plot"},
        Description -> "creates a 'plot' of spectra belonging to the data objects found in the Data field of 'protocol'.",
        Inputs :> {
          {
            InputName -> "protocol",
            Description -> "The protocol object containing pHAdjustment data objects.",
            Widget -> Alternatives[
              Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, AdjustpH]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "plot",
            Description -> "The figure generated from data found in the AdjustpH protocol.",
            Pattern :> ValidGraphicsP[]
          }
        }
      }
    },
    SeeAlso -> {
      "PlotObject",
      "PlotpH"
    },
    Author -> {"xu.yi"},
    Preview->True
  }
];