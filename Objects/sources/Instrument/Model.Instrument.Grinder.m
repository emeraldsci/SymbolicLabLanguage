(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Grinder], {
  Description->"Model of an instrument for grinding powders into smaller powder particles.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    GrinderType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> GrinderTypeP, (*BallMill|KnifeMill|MortarGrinder*)
      Description -> "Method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
      Category -> "Instrument Specifications"
    },
    GrindingMaterial -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> GrindingMaterialP(*Dry, Wet*),
      Description -> "Grinding conditions or physical states of the sample that can be ground in the instruments of this model.",
      Category -> "Instrument Specifications"
    },
    MinGrindingRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "Minimum vibrational or rotational frequency that the grinding tool can operate.",
      Category -> "Operating Limits"
    },
    MaxGrindingRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "Maximum vibrational or rotational frequency that the grinding tool can operate.",
      Category -> "Operating Limits"
    },
    MotionRange -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Millimeter],
      Units -> Millimeter,
      Description -> "The distance of back and force linear motion that the grinding tool travels during operation.",
      Category -> "Operating Limits"
    },
    MinMortarRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "Minimum rotational frequency of the mortar of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    MaxMortarRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "Maximum rotational frequency of the mortar of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    MinPestleRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "Minimum rotational frequency of the pestle of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    MaxPestleRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*RPM],
      Units -> RPM,
      Description -> "Maximum rotational frequency of the pestle of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    (*   Capacity -> {
      Format -> Multiple,
      Class -> {
        Number->Integer,(*TODO Position and FootPrint; PositionDefinitions*)
        Volume->Real
      },
      Pattern :> {
        Number -> GreaterP[0],
        Volume -> GreaterP[0]
      },
      Units -> {
        Number -> None,
        Volume -> Milliliter
      },
      Headers -> {
        Number -> "Number of Tubes/Chambers",
        Volume -> "Volume of Tubes/Chambers"
      },
      Description -> "Maximum number and volume of tubes or grinding chambers that can be used by the grinder.",
      Category -> "Instrument Specifications"
    },*)
    MinAmount -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Milliliter],
      Units -> Milliliter,
      Description -> "The least volume of the sample that can be efficiently ground by the instrument of this model.",
      Category -> "Operating Limits"
    },
    MaxAmount -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Milliliter],
      Units -> Milliliter,
      Description -> "The greatest volume of the sample that can be ground by the instrument of this model.",
      Category -> "Operating Limits"
    },
    MinTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Second],
      Units -> Second,
      Description -> "The minimum operation time that can be set by the timer of the instrument of this model.",
      Category -> "Operating Limits"
    },
    MaxTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Second],
      Units -> Second,
      Description -> "The maximum operation time that can be set by the timer of the instrument of this model.",
      Category -> "Operating Limits"
    },
    FeedFineness -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Millimeter],
      Units -> Millimeter,
      Description -> "The maximum solid particle size that can be used in the grinder of this model.",
      Category -> "Operating Limits"
    },
    FinalFineness -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Micrometer],
      Units -> Micrometer,
      Description -> "The average particle size of the output of the grinder of this model.",
      Category -> "Operating Limits"
    }
  }
}];