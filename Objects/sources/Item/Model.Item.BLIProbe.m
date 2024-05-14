(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, BLIProbe], {
  Description->"Model information for a fiber-optic bio-sensor which is used in Bio-Layer Interferometry (BLI) experiments.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {
    ProbeSurfaceComposition-> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Molecule],
      Description -> "The chemical or biological species which compose the coating on the bio-probe surface.",
      Category -> "Physical Properties"
    },
    Racked -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates whether the probes are pre-loaded into racks with defined probe positions.",
      Category -> "Physical Properties"
    },
    IntendedAnalyte-> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BLIAnalyteTypeP,
      Description -> "The types of species that may interact directly with the probe surface. Note that it some cases the probe surface may be modified to target a different set of analytes.",
      Category -> "Operating Limits"
    },
    RecommendedApplication-> {
      Format ->  Multiple,
      Class -> Expression,
      Pattern :> BLIApplicationsP,
      Description -> "The types of BLI experiments that the probe is intended for, as stated by the manufacturer in the product documentation.",
      Category -> "Operating Limits"
    },
    MaximumBioLayerThickness-> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Nanometer],
      Units->Nanometer,
      Description -> "The maximum bio-layer thickness that can be accurately measured by this probe.",
      Category -> "Operating Limits"
    },
    QuantitationDynamicRange-> {
      Format -> Multiple,
      Class -> {Real,Real},
      Pattern :> {GreaterP[0 (Gram Micro)/(Liter Milli)],GreaterP[0 (Gram Micro)/(Liter Milli)]},
      Units ->{(Gram Micro)/(Liter Milli), (Gram Micro)/(Liter Milli)},
      (* Pattern :> {_Link,GreaterP[0 (Gram Micro)/(Liter Milli)],GreaterP[0 (Gram Micro)/(Liter Milli)]},
      Units ->{Null, (Gram Micro)/(Liter Milli), (Gram Micro)/(Liter Milli)},*)
      Relation->{Null,Null},
      Description -> "The range of analyte concentration for which this probe functions optimally for a given compatible instrument. Dynamic range might vary for different background conditions and acquisition rates, and is based on testing of intended analyte molecules. The values are given as {instrument, lowerbound, upperbound}.",
      Headers -> {"Minimum concentration","Maximum concentration"},
      Category -> "Operating Limits"
    },
    QuantitationRegeneration-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[BooleanP,AnalyteDependent,ProteinDependent],
      Description -> "Indicates if the probe can be regenerated to perform multiple successive quantitation measurements. AnalyteDependent indicates that probe regeneration depends on the species which is associated to the probe surface, and that any assays using regeneration should be user validated. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    KineticsRegeneration-> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[BooleanP,AnalyteDependent,ProteinDependent],
      Description -> "Indicates if the probe can be regenerated to perform multiple successive kinetics measurements. AnalyteDependent indicates that probe regeneration depends on the species which is associated to the probe surface, and that any assays using regeneration should be user validated. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationSolutions-> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation->Model[Sample],
      Description -> "Indicates one or more solutions which can be used to regenerate the probe surface. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationDuration-> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Second],
      Units->Second,
      Description -> "The recommended amount of time for which the bio-probe is immersed in regeneration solution. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationShakeRate-> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[100 Hertz, 1500 Hertz],
      Units->Hertz,
      Description -> "The recommended shake-rate while the bio-probe is immersed in regeneration solution. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    },
    RegenerationCycles-> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0,1],
      Description -> "The recommended number of regeneration cycles, which is the number of times that the bio-probe is exposed to the regeneration solution. Regeneration returns the probe surface to the original condition.",
      Category -> "Operating Limits"
    }
  }
}];
