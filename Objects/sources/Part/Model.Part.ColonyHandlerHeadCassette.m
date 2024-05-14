(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

DefineObjectType[Model[Part,ColonyHandlerHeadCassette],
  {
    Description->"Tools used to pick spread or streak colonies onto plates.",
    CreatePrivileges->None,
    Cache->Session,
    Fields->{
      HeadDiameter -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The diameter of a single head on the colony handler head.",
        Category -> "Dimensions & Positions"
      },
      HeadLength -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Millimeter],
        Units -> Millimeter,
        Description -> "The length of a single head on the colony handler head from tip to head base.",
        Category -> "Dimensions & Positions"
      },
      NumberOfHeads -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> RangeP[1, 96],
        Description -> "The number of heads arrayed in grid format on the colony handler head.",
        Category -> "Dimensions & Positions"
      },
      Rows -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The number of rows of heads on the colony handler head.",
        Category -> "Dimensions & Positions"
      },
      Columns -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The number of columns of heads on the colony handler head.",
        Category -> "Dimensions & Positions"
      },
      Application -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> ColonyHandlerHeadCassetteTypeP, (* Pick | Spread | Streak *)
        Description -> "The colony handler head can perform on the colony handler.",
        Category -> "General"
      },
      PreferredCellLines -> {
        Format-> Multiple,
        Class -> Link,
        Pattern:>_Link,
        Relation->Model[Cell],
        Description->"The cell lines this colony handler head cassette is designed to pick.",
        Category->"General"
      }
    }
  }
];
