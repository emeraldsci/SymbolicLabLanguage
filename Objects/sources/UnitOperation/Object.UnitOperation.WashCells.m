(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: User *)
(* :Date: 2023-06-12 *)

(* NOTE: WashCells is the same as ChangeMedia. *)
With[{insertMe=$SharedChangeMediaUnitOperationFields},
  DefineObjectType[Object[UnitOperation, WashCells],{
    Description->"The group of default settings that should be used when washing a given cell culture.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->insertMe
  }]
];
