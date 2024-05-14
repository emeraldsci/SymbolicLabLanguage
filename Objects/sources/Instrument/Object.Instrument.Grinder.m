(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Grinder], {
  Description->"An instrument for grinding powders into smaller powder particles.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    GrinderType -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],GrinderType]],
      Pattern :> GrinderTypeP,
      Description -> "Method for reducing the size of the powder particles (grinding the sample into a fine powder). Options include BallMill, KnifeMill, and automated MortarGrinder. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.",
      Category -> "Instrument Specifications"
    },
    GrindingMaterial -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],GrindingMaterial]],
      Pattern :> {GrindingMaterialP..}(*Dry, Wet*),
      Description -> "Grinding conditions or physical states of the sample that can be ground in this instrument.",
      Category -> "Instrument Specifications"
    },
    MinGrindingRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinGrindingRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Minimum vibrational or rotational frequency that the grinding tool can operate.",
      Category -> "Operating Limits"
    },
    MaxGrindingRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxGrindingRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Maximum vibrational or rotational frequency that the grinding tool can operate.",
      Category -> "Operating Limits"
    },
    MotionRange -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MotionRange]],
      Pattern :> GreaterP[0*Millimeter],
      Description -> "The distance of back and force linear motion that the grinding tool travels during operation.",
      Category -> "Operating Limits"
    },
    MinMortarRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinMortarRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Minimum rotational frequency of the mortar of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    MaxMortarRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxMortarRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Maximum rotational frequency of the mortar of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    MinPestleRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinPestleRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Minimum rotational frequency of the pestle of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    MaxPestleRate -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxPestleRate]],
      Pattern :> GreaterP[0*RPM],
      Description -> "Maximum rotational frequency of the pestle of an automated mortar grinder. Mortar grinders move both mortar and pestle during operation.",
      Category -> "Operating Limits"
    },
    (*    Capacity -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Capacity]],
      Pattern :> {
        Number -> {GreaterP[0]..},
        Volume -> {GreaterP[0]..}
      },
      Headers -> {
        Number -> "Number of Tubes/Chambers",
        Volume -> "Volume of Tubes/Chambers"
      },
      Description -> "Maximum number and volume of tubes or grinding chambers that can be used by the grinder.",
      Category -> "Instrument Specifications"
    },*)
    MinAmount -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinAmount]],
      Pattern :> GreaterP[0*Milliliter],
      Description -> "The least volume of the sample that can be efficiently ground by this instrument.",
      Category -> "Operating Limits"
    },
    MaxAmount -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxAmount]],
      Pattern :> GreaterP[0*Milliliter],
      Description -> "The greatest volume of the sample that can be ground by the instrument of this model.",
      Category -> "Operating Limits"
    },
    MinTime -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTime]],
      Pattern :> GreaterP[0*Second],
      Description -> "The minimum operation time that can be set by the timer of this instrument.",
      Category -> "Operating Limits"
    },
    MaxTime -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTime]],
      Pattern :> GreaterP[0*Second],
      Description -> "The maximum operation time that can be set by the timer of this instrument.",
      Category -> "Operating Limits"
    },
    FeedFineness -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],FeedFineness]],
      Pattern :> GreaterP[0*Millimeter],
      Description -> "The maximum solid particle size that can be used in this instrument.",
      Category -> "Operating Limits"
    },
    FinalFineness -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],FinalFineness]],
      Pattern :> GreaterP[0*Micrometer],
      Description -> "The average particle size of the output of this instrument.",
      Category -> "Operating Limits"
    }
  }
}];