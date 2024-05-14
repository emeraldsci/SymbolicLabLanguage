(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software,DatabaseRefresh], {
    Description->"Represents a full run of SLL unit tests.",
    CreatePrivileges->None,
    Cache->Download,
    Fields -> {
        (* Note that DateCreated is inherited from Object.Software *)
        DateStarted -> {
            Format -> Single,
            Class -> Date,
            Pattern :> _DateObject,
            Description -> "The date and time that this DB refresh Manifold job started running.",
            AdminViewOnly -> True,
            Category -> "Organizational Information"
        },
        DateCompleted -> {
            Format -> Single,
            Class -> Date,
            Pattern :> _DateObject,
            Description -> "The date and time that all this DB refresh Manifold job finished running.",
            AdminViewOnly -> True,
            Category -> "Organizational Information"
        },
        Status -> {
            Format -> Single,
            Class -> Expression,
            Pattern :> DatabaseRefreshStatusP,
            Description -> "Whether the DB refresh Manifold job is currently started or has completed.",
            AdminViewOnly -> True,
            Category -> "Organizational Information"
        },
        ErrorMessage -> {
            Format -> Single,
            Class -> String,
            Pattern :> _String,
            Description -> "In the event of an error, a description of the reason behind the error.",
            AdminViewOnly -> True,
            Category -> "Troubleshooting"
        }
    }
}];
