(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* NOTE: WashCells is the same as ChangeMedia. *)
With[{insertMe=$SharedChangeMediaFields},
    DefineObjectType[Object[Method, WashCells],{
        Description->"The group of default settings that should be used when washing a given cell culture.",
        CreatePrivileges->None,
        Cache->Session,
        Fields->insertMe
    }]
];
