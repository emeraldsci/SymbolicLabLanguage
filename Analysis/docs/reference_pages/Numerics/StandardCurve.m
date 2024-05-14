(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeStandardCurve*)

nestedFieldQ[arg_Symbol] := True;
nestedFieldQ[head_Symbol[arg_]] := nestedFieldQ[arg];
nestedFieldQ[_] := False;
nestedFieldP = _?nestedFieldQ|_Field|_Symbol;

DefineUsage[AnalyzeStandardCurve,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeStandardCurve[dataToTransform, RawStandardData]", "object"},
        Description -> "fits a standard curve to 'RawStandardData' and applies it to 'dataToTransform', then stores the result in 'object'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "dataToTransform",
              Description -> "Data points to transform using fitted standard curve.",
              Widget -> Adder[
                Alternatives[
                  "Numeric Values"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]],
                  "Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]],
                  "Object and Field"->{
                    "Object"->Alternatives[
                      "Single"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Single object contains one or more {x,y} data points."],
                      "Multiple"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]]
                    ],
                    "Field"->Widget[Type->Expression,Pattern:>Automatic|nestedFieldP,BoxText->"Use 'Automatic' for default field.",PatternTooltip->"Object Field where data is located.", Size->Line]
                  },
                  "Expression"->Widget[Type->Expression,Pattern:>_?QuantityVectorQ,Size->Line]
                ],
                Orientation->Vertical
              ]
            },
            IndexName -> "Input Data"
          ],
          {
            InputName -> "RawStandardData",
            Description -> "Existing standard curve, or data points to fit a standard curve to.",
            Widget -> Alternatives[
              "Existing Fit"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],PatternTooltip->"Existing standard curve to apply to data."],
              "Numerical Coordinates"->Adder[
                {
                  "X"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line],
                  "Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]
                }
              ],
              "Object(s)"->Alternatives[
                "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                "Paired Objects"->Adder[
                  {
                    "X"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ],
                    "Y"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ]
                  }
                ]
              ],
              "{Object(s),Fields}"->{
                "Object(s)"->Alternatives[
                  "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                  "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                  "Paired Objects"->Adder[
                    {
                      "X"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ],
                      "Y"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ]
                    }
                  ]
                ],
                "Field"->{
                  "X"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word],
                  "Y"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word]
                }
              },
              "Expression"->Widget[Type->Expression,Pattern:>MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ|Automatic,PatternTooltip->"The set of data points to fit to.",Size->Line]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The analysis object containing results from fitting and applying standard curves.",
            Pattern :> ObjectP[Object[Analysis, StandardCurve]]
          }
        }
      },
      {
        Definition -> {"AnalyzeStandardCurve[rawStandardData]", "object"},
        Description -> "fits a standard curve to 'RawStandardData' only, then stores the result in 'object'.",
        Inputs :> {
          {
            InputName -> "RawStandardData",
            Description -> "Existing standard curve, or data points to fit a standard curve to.",
            Widget -> Alternatives[
              "Existing Fit"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],PatternTooltip->"Existing standard curve to apply to data."],
              "Numerical Coordinates"->Adder[
                {
                  "X"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line],
                  "Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]
                }
              ],
              "Object(s)"->Alternatives[
                "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                "Paired Objects"->Adder[
                  {
                    "X"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ],
                    "Y"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ]
                  }
                ]
              ],
              "{Object(s),Fields}"->{
                "Object(s)"->Alternatives[
                  "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                  "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                  "Paired Objects"->Adder[
                    {
                      "X"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ],
                      "Y"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ]
                    }
                  ]
                ],
                "Field"->{
                  "X"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word],
                  "Y"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word]
                }
              },
              "Expression"->Widget[Type->Expression,Pattern:>MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ|Automatic,PatternTooltip->"The set of data points to fit to.",Size->Line]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The analysis object containing results from fitted standard curves.",
            Pattern :> ObjectP[Object[Analysis, StandardCurve]]
          }
        }
      },
      {
        Definition -> {"AnalyzeStandardCurve[CapillaryELISAProtocol]", "objects"},
        Description -> "applies standard curve analysis to experimental protocols for which default analysis has been defined.",
        Inputs :> {
          {
            InputName -> "CapillaryELISAProtocol",
            Description -> "The experimental protocol to apply standard analysis to. See input pattern for supported protocol types.",
            Widget -> Alternatives[
              "Capillary ELISA"->Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,CapillaryELISA]]]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "objects",
            Description -> "The analysis object(s) containing results from fitting and applying standard curves.",
            Pattern :> ObjectP[Object[Analysis,StandardCurve]]
          }
        }
      },
      {
        Definition -> {"AnalyzeStandardCurve[dataToTransform, standardCurveObject]", "object"},
        Description -> "gets fitted results from 'standardCurveObject' and applies it to 'dataToTransform', then stores the result in a new 'object'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "dataToTransform",
              Description -> "Data points to transform using fitted standard curve.",
              Widget -> Adder[
                Alternatives[
                  "Numeric Values"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]],
                  "Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]],
                  "Object and Field"->{
                    "Object"->Alternatives[
                      "Single"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Single object contains one or more {x,y} data points."],
                      "Multiple"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]]
                    ],
                    "Field"->Widget[Type->Expression,Pattern:>Automatic|nestedFieldP,BoxText->"Use 'Automatic' for default field.",PatternTooltip->"Object Field where data is located.", Size->Line]
                  },
                  "Expression"->Widget[Type->Expression,Pattern:>_?QuantityVectorQ,Size->Line]
                ],
                Orientation->Vertical
              ]
            },
            IndexName -> "Input Data"
          ],
          {
            InputName -> "standardCurveObject",
            Description -> "Existing analysis object Object[Analysis, StandardCurve]. This object must have ReferenceStandardCurve field Null.",
            Widget -> Alternatives[
                "Standard Curve"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,StandardCurve]]]
              ]
          }
        },
        Outputs :> {
          {
            OutputName -> "object",
            Description -> "The analysis object containing results from fitting and applying standard curves.",
            Pattern :> ObjectP[Object[Analysis, StandardCurve]]
          }
        }
      }
  },
    SeeAlso -> {
      "AnalyzeStandardCurveOptions",
      "AnalyzeStandardCurvePreview",
      "ValidAnalyzeStandardCurveQ",
      "AnalyzeFit"
    },
    Author -> {"scicomp", "brad", "kevin.hou"},
    Preview->True
  }
];


(* ::Subsubsection:: *)
(*AnalyzeStandardCurveOptions*)

DefineUsage[AnalyzeStandardCurveOptions,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeStandardCurveOptions[dataToTransform, standardData]", "resolvedOptions"},
        Description -> "returns the 'resolvedOptions' for AnalyzeStandardCurve['dataToTransform','standardData'], wherein all Automatic options have been resolved to fixed values.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "dataToTransform",
              Description -> "Data points to transform using fitted standard curve.",
              Widget -> Adder[
                Alternatives[
                  "Numeric Values"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]],
                  "Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]],
                  "Object and Field"->{
                    "Object"->Alternatives[
                      "Single"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Single object contains one or more {x,y} data points."],
                      "Multiple"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]]
                    ],
                    "Field"->Widget[Type->Expression,Pattern:>Automatic|nestedFieldP,BoxText->"Use 'Automatic' for default field.",PatternTooltip->"Object Field where data is located.", Size->Line]
                  },
                  "Expression"->Widget[Type->Expression,Pattern:>_?QuantityVectorQ,Size->Line]
                ],
                Orientation->Vertical
              ]
            },
            IndexName -> "Input Data"
          ],
          {
            InputName -> "standardData",
            Description -> "Existing standard curve, or data points to fit a standard curve to.",
            Widget -> Alternatives[
              "Existing Fit"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],PatternTooltip->"Existing standard curve to apply to data."],
              "Numerical Coordinates"->Adder[
                {
                  "X"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line],
                  "Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]
                }
              ],
              "Object(s)"->Alternatives[
                "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                "Paired Objects"->Adder[
                  {
                    "X"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ],
                    "Y"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ]
                  }
                ]
              ],
              "{Object(s),Fields}"->{
                "Object(s)"->Alternatives[
                  "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                  "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                  "Paired Objects"->Adder[
                    {
                      "X"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ],
                      "Y"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ]
                    }
                  ]
                ],
                "Field"->{
                  "X"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word],
                  "Y"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word]
                }
              },
              "Expression"->Widget[Type->Expression,Pattern:>MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ|Automatic,PatternTooltip->"The set of data points to fit to.",Size->Paragraph]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "resolvedOptions",
            Description -> "The resolved options for AnalyzeStandardCurve when called on dataToTransform and standardData.",
            Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
          }
        }
      }
    },
    SeeAlso -> {
      "AnalyzeStandardCurve",
      "AnalyzeStandardCurvePreview",
      "ValidAnalyzeStandardCurveQ"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];


(* ::Subsubsection:: *)
(*AnalyzeStandardCurvePreview*)

DefineUsage[AnalyzeStandardCurvePreview,
  {
    BasicDefinitions -> {
      {
        Definition -> {"AnalyzeStandardCurvePreview[dataToTransform, standardData]", "preview"},
        Description -> "returns a graphical preview of AnalyzeStandardCurve['dataToTransform','standardData'].",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "dataToTransform",
              Description -> "Data points to transform using fitted standard curve.",
              Widget -> Adder[
                Alternatives[
                  "Numeric Values"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]],
                  "Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]],
                  "Object and Field"->{
                    "Object"->Alternatives[
                      "Single"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Single object contains one or more {x,y} data points."],
                      "Multiple"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]]
                    ],
                    "Field"->Widget[Type->Expression,Pattern:>Automatic|nestedFieldP,BoxText->"Use 'Automatic' for default field.",PatternTooltip->"Object Field where data is located.", Size->Line]
                  },
                  "Expression"->Widget[Type->Expression,Pattern:>_?QuantityVectorQ,Size->Line]
                ],
                Orientation->Vertical
              ]
            },
            IndexName -> "Input Data"
          ],
          {
            InputName -> "standardData",
            Description -> "Existing standard curve, or data points to fit a standard curve to.",
            Widget -> Alternatives[
              "Existing Fit"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],PatternTooltip->"Existing standard curve to apply to data."],
              "Numerical Coordinates"->Adder[
                {
                  "X"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line],
                  "Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]
                }
              ],
              "Object(s)"->Alternatives[
                "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                "Paired Objects"->Adder[
                  {
                    "X"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ],
                    "Y"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ]
                  }
                ]
              ],
              "{Object(s),Fields}"->{
                "Object(s)"->Alternatives[
                  "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                  "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                  "Paired Objects"->Adder[
                    {
                      "X"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ],
                      "Y"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ]
                    }
                  ]
                ],
                "Field"->{
                  "X"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word],
                  "Y"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word]
                }
              },
              "Expression"->Widget[Type->Expression,Pattern:>MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ|Automatic,PatternTooltip->"The set of data points to fit to.",Size->Paragraph]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "preview",
            Description -> "The graphical preview representing the output of AnalyzeStandardCurve.",
            Pattern :> ValidGraphicsP[]|Null
          }
        }
      }
  },
    SeeAlso -> {
      "AnalyzeStandardCurve",
      "AnalyzeStandardCurveOptions",
      "ValidAnalyzeStandardCurveQ",
      "PlotFit"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];


(* ::Subsubsection:: *)
(*ValidAnalyzeStandardCurveQ*)

DefineUsage[ValidAnalyzeStandardCurveQ,
  {
    BasicDefinitions -> {
      {
        Definition -> {"ValidAnalyzeStandardCurveQ[dataToTransform, standardData]", "boolean"},
        Description -> "checks whether AnalyzeStandardCurve['dataToTransform','standardData'] is a valid function call.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "dataToTransform",
              Description -> "Data points to transform using fitted standard curve.",
              Widget -> Adder[
                Alternatives[
                  "Numeric Values"->Adder[Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]],
                  "Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]],
                  "Object and Field"->{
                    "Object"->Alternatives[
                      "Single"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Single object contains one or more {x,y} data points."],
                      "Multiple"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Each object contains one {x,y} data point."]]
                    ],
                    "Field"->Widget[Type->Expression,Pattern:>Automatic|nestedFieldP,BoxText->"Use 'Automatic' for default field.",PatternTooltip->"Object Field where data is located.", Size->Line]
                  },
                  "Expression"->Widget[Type->Expression,Pattern:>_?QuantityVectorQ,Size->Line]
                ],
                Orientation->Vertical
              ]
            },
            IndexName -> "Input Data"
          ],
          {
            InputName -> "standardData",
            Description -> "Existing standard curve, or data points to fit a standard curve to.",
            Widget -> Alternatives[
              "Existing Fit"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,Fit]],PatternTooltip->"Existing standard curve to apply to data."],
              "Numerical Coordinates"->Adder[
                {
                  "X"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line],
                  "Y"->Widget[Type->Expression,Pattern:>(UnitsP[]|DistributionP[]),Size->Line]
                }
              ],
              "Object(s)"->Alternatives[
                "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                "Paired Objects"->Adder[
                  {
                    "X"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ],
                    "Y"->Alternatives[
                      Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units.",Size->Word],
                      Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                    ]
                  }
                ]
              ],
              "{Object(s),Fields}"->{
                "Object(s)"->Alternatives[
                  "Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"A single object containing a list of {x,y} pairs to fit the standard curve to."],
                  "List of Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]],
                  "Paired Objects"->Adder[
                    {
                      "X"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ],
                      "Y"->Alternatives[
                        Widget[Type->Expression,Pattern:>UnitsP[],PatternTooltip->"A number or distribution, with or without units",Size->Word],
                        Widget[Type->Object,Pattern:>ObjectP[Object[]],PatternTooltip->"Object containing a single {x,y} data point."]
                      ]
                    }
                  ]
                ],
                "Field"->{
                  "X"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word],
                  "Y"->Widget[Type->Expression,Pattern:>None|nestedFieldP,PatternTooltip->"Default is Automatic, use None for non-object input",Size->Word]
                }
              },
              "Expression"->Widget[Type->Expression,Pattern:>MatrixP[UnitsP[]|DistributionP[]]|_?QuantityMatrixQ|Automatic,PatternTooltip->"The set of data points to fit to.",Size->Paragraph]
            ]
          }
        },
        Outputs :> {
          {
            OutputName -> "boolean",
            Description -> "The value indicating whether the AnalyzeStandardCurve call is valid. The return value can be changed via the OutputFormat option.",
            Pattern :> _EmeraldTestSummary|BooleanP
          }
        }
      }
  },
    SeeAlso -> {
      "AnalyzeStandardCurve",
      "AnalyzeStandardCurveOptions",
      "AnalyzeStandardCurvePreview"
    },
    Author -> {"scicomp", "brad", "kevin.hou"}
  }
];