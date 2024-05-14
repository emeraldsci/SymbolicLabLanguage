(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ExperimentVisualInspection,{
   BasicDefinitions->{
      {
         Definition->{"ExperimentVisualInspection[Samples]","Protocol"},
         Description->"generates a 'Protocol' object for obtaining video recordings of the provided 'Samples' as they are agitated one at a time, in order to detect any visible particulates in the 'Samples'.",
         Inputs:>{
            IndexMatching[
               {
                  InputName->"Samples",
                  Description->"The samples to be inspected or the containers directly storing the samples to be inspected.",
                  Widget->Widget[
                     Type->Object,
                     Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                     ObjectTypes->{Object[Sample],Object[Container]},
                     Dereference->{
                        Object[Container]->Field[Contents[[All,2]]]
                     }
                  ],
                  Expandable -> False
               },
               IndexName->"experiment samples"
            ]
         },
         Outputs:>{
            {
               OutputName->"Protocol",
               Description->"Protocol generated to obtain video recordings of the input sample.",
               Pattern:>ListableP[ObjectP[Object[Protocol,VisualInspection]]]
            }
         }
      }
   },
   MoreInformation->{},
   SeeAlso->{
      "ExperimentVisualInspectionOptions",
      "ValidExperimentVisualInspectionQ",
      "ExperimentImageSample"
   },
   Author->{"eunbin.go", "jihan.kim"}
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentVisualInspectionOptions*)


DefineUsage[ExperimentVisualInspectionOptions,
   {
      BasicDefinitions -> {
         {
            Definition -> {"ExperimentVisualInspectionOptions[Objects]", "ResolvedOptions"},
            Description -> "returns the resolved options for ExperimentVisualInspection when it is called on 'Objects'.",
            Inputs:>{
               IndexMatching[
                  {
                     InputName->"Objects",
                     Description->"The samples to be inspected or the containers directly storing the samples to be inspected.",
                     Widget->Widget[
                        Type->Object,
                        Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                        ObjectTypes->{Object[Sample],Object[Container]},
                        Dereference->{
                           Object[Container]->Field[Contents[[All,2]]]
                        }
                     ]
                  },
                  IndexName->"experiment samples"
               ]
            },
            Outputs :> {
               {
                  OutputName -> "ResolvedOptions",
                  Description -> "Resolved options when ExperimentVisualInspection is called on the input objects.",
                  Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
               }
            }
         }
      },
      MoreInformation -> {
         "This function returns the resolved options that would be fed to ExperimentVisualInspection if it were called on these input objects."
      },
      SeeAlso -> {
         "ExperimentVisualInspection",
         "ValidExperimentVisualInspectionQ"
      },
      Author -> {"eunbin.go", "jihan.kim"}
   }
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentVisualInspectionQ*)


DefineUsage[ValidExperimentVisualInspectionQ,
   {
      BasicDefinitions -> {
         {
            Definition -> {"ValidExperimentVisualInspectionQ[Objects]", "Booleans"},
            Description -> "checks whether the provided 'Objects' and specified options are valid for calling ExperimentVisualInspection.",
            Inputs:>{
               IndexMatching[
                  {
                     InputName->"Objects",
                     Description->"The samples to be inspected or the containers directly storing the samples to be inspected.",
                     Widget->Widget[
                        Type->Object,
                        Pattern:>ObjectP[{Object[Sample],Object[Container]}],
                        ObjectTypes->{Object[Sample],Object[Container]},
                        Dereference->{
                           Object[Container]->Field[Contents[[All,2]]]
                        }
                     ]
                  },
                  IndexName->"experiment samples"
               ]
            },
            Outputs :> {
               {
                  OutputName -> "Booleans",
                  Description -> "Whether or not the ExperimentVisualInspection call is valid. Return value can be changed via the OutputFormat option.",
                  Pattern :> _EmeraldTestSummary| BooleanP
               }
            }
         }
      },
      SeeAlso -> {
         "ExperimentVisualInspection",
         "ExperimentVisualInspectionOptions"
      },
      Author -> {"eunbin.go", "jihan.kim"}
   }
];