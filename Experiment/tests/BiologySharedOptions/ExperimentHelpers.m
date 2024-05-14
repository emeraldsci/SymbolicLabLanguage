(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* Unit Testing *)

DefineTests[
  removeConflictingNonAutomaticOptions,
  {
    Example[{Basic, "Returns processed options with Automatic replaced by child function's default:"},
      removeConflictingNonAutomaticOptions[Precipitate, {
        TargetPhase -> Automatic,
        PrecipitationReagentEquilibrationTime -> Automatic
      }],
      KeyValuePattern[{
        TargetPhase->Solid,
        PrecipitationReagentEquilibrationTime ->EqualP[5 Minute]
      }]
    ],
    Example[{Basic, "Returns processed options with Automatic replaced by child function's default if the input is a list of Automatics or a mix of Automatic and values:"},
      removeConflictingNonAutomaticOptions[Precipitate, {
        TargetPhase -> {Automatic,Automatic},
        PrecipitationReagentEquilibrationTime -> {Automatic,10 Minute}
      }],
      KeyValuePattern[{
        TargetPhase-> {Solid,Solid},
        PrecipitationReagentEquilibrationTime ->{EqualP[5 Minute],EqualP[10 Minute]}
      }]
    ]
  },

  Stubs :> {
    $DeveloperUpload = True,
    $EmailEnabled = False,
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];