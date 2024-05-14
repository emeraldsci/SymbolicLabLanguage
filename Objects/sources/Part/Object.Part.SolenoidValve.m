
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, SolenoidValve],
  {
    Description->"Object information for a valve that is used to control the flow of liquid or gas.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
      DateInstalled -> {
        Format -> Single,
        Class -> Date,
        Pattern :> _?DateObjectQ,
        Description -> "Date the part was installed in its current instrument.",
        Category -> "Organizational Information"
      },
      DateLastChecked -> {
        Format -> Single,
        Class -> Date,
        Pattern :> _?DateObjectQ,
        Description -> "Date the part was last serviced while in use in teh current instrument.",
        Category -> "Organizational Information"
      },
      ServiceLog -> {
        Format -> Multiple,
        Class -> {Date, Link},
        Pattern :> {_?DateObjectQ, _Link},
        Relation -> {
          None,
          Alternatives[
            Object[Protocol],
            Object[User],
            Object[Maintenance],
            Object[Qualification]
          ]
        },
        Headers -> {"Date Serviced","Responsible Party"},
        Description -> "Log of the dates and responsible parties for servicing this part.",
        Category -> "Organizational Information"
      }
    }
  }
];