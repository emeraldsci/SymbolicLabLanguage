(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* NOTE: SplitCells is the same as WashCells/ChangeMedia. *)
With[{insertMe=$SharedChangeMediaFields},
  DefineObjectType[Object[Method, SplitCells],{
    Description->"The group of default settings that should be used when splitting a given cell culture.",
    CreatePrivileges->None,
    Cache->Session,
    Fields-> insertMe
  }]
];