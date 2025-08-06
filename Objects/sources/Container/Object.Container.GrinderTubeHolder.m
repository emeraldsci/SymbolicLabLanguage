(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, GrinderTubeHolder], {
    Description -> "A Container used in some models of grinders to securely position the sample tubes during the grinding process.",
    CreatePrivileges->None,
    Cache->Download,
    Fields -> {
        Side -> {
            Format -> Single,
            Class -> Expression,
            Pattern :> Left|Right,
            Description -> "Determines whether a grinding tube holder should be placed in the left or right grinding station if the grinder has two grinding stations.",
            Category -> "General",
            Developer -> True
        }
    }
}];