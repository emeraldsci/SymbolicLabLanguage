(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, BLIProbe], {
  Description->"Information for a fiber-optic bio-sensor which is used in Bio-Layer Interferometry (BLI) measurements.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    ProbeSurfaceComposition-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ProbeSurfaceComposition]],
      Pattern :> _Link,
      Relation -> Model[Molecule],
      Description -> "The chemical or biological species which compose the coating on the bio-probe surface.",
      Category -> "Physical Properties"
    },
    IntendedAnalyte-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],IntendedAnalyte]],
      Pattern :> BLIAnalyteTypeP,
      Description -> "The types of species that may interact directly with the probe surface. Note that it some cases the probe surface may be modified to target a different set of analytes.",
      Category -> "Operating Limits"
    },
    RecommendedApplication-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RecommendedApplication]],
      Pattern :> BLIApplicationsP,
      Description -> "The types of BLI experiments that the probe is intended for, as stated by the manufacturer in the product documentation.",
      Category -> "Operating Limits"
    },
    MaximumBioLayerThickness-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaximumBioLayerThickness]],
      Pattern :> GreaterP[0 Nanometer],
      Description -> "The maximum bio-layer thickness that can be accurately measured by this probe.",
      Category -> "Operating Limits"
    },
    QuantitationDynamicRange-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],QuantitationDynamicRange]],
      Pattern :> {_Link,GreaterP[0 (Microgram/Milliliter)],GreaterP[0  (Microgram/Milliliter)]},
      Relation -> {Model[Instrument, BioLayerInterferometer],Null,Null},
      Description -> "The range of analyte concentration for which this probe functions optimally for a given compatible instrument. Dynamic range might vary for different background conditions and acquisition rates, and is based on testing of intended analyte molecules. The values are given as {instrument, lowerbound, upperbound}.",
      Category -> "Operating Limits"
    },
    QuantitationRegeneration-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],QuantitationRegeneration]],
      Pattern :> Alternatives[BooleanP,AnalyteDependent],
      Description -> "Indicates if the probe can be regenerated to perform multiple successive quantitation measurements. AnalyteDependent indicates that probe regeneration depends on the species which is associated to the probe surface, and that any assays using regeneration should be user validated. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    KineticsRegeneration-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],KineticsRegeneration]],
      Pattern :> Alternatives[BooleanP,AnalyteDependent],
      Description -> "Indicates if the probe can be regenerated to perform multiple successive kinetics measurements. AnalyteDependent indicates that probe regeneration depends on the species which is associated to the probe surface, and that any assays using regeneration should be user validated. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationSolutions-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RegenerationSolutions]],
      Pattern :> _Link,
      Relation -> Model[Sample],
      Description -> "Indicates one or more solutions which can be used to regenerate the probe surface. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationDuration-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RegenerationDuration]],
      Pattern :> GreaterP[0 Second],
      Description -> "The recommended amount of time for which the bio-probe is immersed in regeneration solution. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationShakeRate-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RegenerationShakeRate]],
      Pattern :> RangeP[100 Hertz, 1500 Hertz],
      Description -> "The recommended shake-rate while the bio-probe is immersed in regeneration solution. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationCycles-> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],RegenerationCycles]],
      Pattern :> GreaterP[0,1],
      Description -> "The recommended number of regeneration cycles, which is the number of times that the bio-probe is exposed to the regeneration solution. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    }
  }
}];
