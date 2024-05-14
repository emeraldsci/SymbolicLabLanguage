(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, Extraction, PlasmidDNA], {
  Description -> "A method specifying conditions and reagents for the extraction and isolation of plasmid DNA from a cell-containing sample.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* Neutralization *)

    Neutralize -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the cell lysate, a solution containing all of the extracted cell components, will be neutralized, altering the pH of the lysate to bring it closer to neutral (pH 7) in order to renature the plasmid DNA. This keeps the plasmid DNA soluble while other components are rendered (or remain) insoluble. Then the plasmid-rich supernatant is isolated by pelleting and aspiration for further purification.",
      Category -> "Neutralization"
    },
    NeutralizationSeparationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "Indicates if the the solid precipitate and liquid supernatant are to be separated by centrifugation followed by pipetting of the supernatant (Pellet), or separated by passing the solution through a filter with a pore size large enough to allow the liquid phase to pass through, but not the solid precipitate (Filter).",
      Category -> "Neutralization"
    },
    NeutralizationReagent -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample],Model[Sample]],
      Description -> "A reagent which, when added to the lysate, will alter the pH of the lysate to bring it closer to neutral (pH 7) in order to renature the plasmid DNA. This keeps the plasmid DNA soluble while other components are rendered (or remain) insoluble.",
      Category -> "Neutralization"
    },
    NeutralizationReagentTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature that the NeutralizationReagent will be incubated at for the NeutralizationReagentEquilibrationTime before being added to the lysate, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Neutralization"
    },
    NeutralizationReagentEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the NeutralizationReagent will be kept at NeutralizationReagentTemperature before being added to the sample, which will help form the precipitate and encourage it to crash out of solution once it has been added to the sample.",
      Category -> "Neutralization"
    },
    NeutralizationMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "The manner in which the sample is agitated following the addition of the NeutralizationReagent to the sample, in order to prepare a uniform mixture prior to incubation. Shake indicates that the sample will be placed on a shaker at the NeutralizationMixRate for NeutralizationMixTime, while Pipetting indicates that NeutralizationMixVolume of the sample will be pipetted up and down for the number of times specified by NumberOfNeutralizationMixes. None indicates that no mixing occurs before incubation.",
      Category -> "Neutralization"
    },
    NeutralizationMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the mixing device's heating/cooling block is maintained in order to prepare a uniform mixture prior to incubation.",
      Category -> "Neutralization"
    },
    NeutralizationMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 RPM],
      Units -> RPM,
      Description -> "The number of rotations per minute that the lysate and NeutralizationReagent will be shaken at in order to prepare a uniform mixture prior to the incubation time.",
      Category -> "Neutralization"
    },
    NeutralizationMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The duration of time that the lysate and NeutralizationReagent will be shaken for, at at the specified NeutralizationMixRate, to prepare a uniform mixture prior to the incubation time.",
      Category -> "Neutralization"
    },
    NumberOfNeutralizationMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Description -> "The number of times the lysate and NeutralizationReagent are mixed by pipetting up and down in order to prepare a uniform mixture prior to the incubation time.",
      Category -> "Neutralization"
    },
    NeutralizationSettlingTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The duration for which the combined lysate and NeutralizationReagent are left to settle, at the specified NeutralizationSettlingTemperature, in order to encourage crashing of precipitant following any mixing.",
      Category -> "Neutralization"
    },
    NeutralizationSettlingTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the incubation device's heating/cooling block is maintained during NeutralizationSettlingTime in order to encourage crashing of precipitant.",
      Category -> "Neutralization"
    },
    NeutralizationFiltrationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> AirPressure | Centrifuge,
      Description -> "The type of dead-end filtration used to apply force to the sample in order to facilitate its passage through the filter. This will be done by either applying centrifugal force to the filter in a centrifuge, or by applying increased air pressure using a pressure manifold.",
      Category -> "Neutralization"
    },
    NeutralizationFilter -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container, Plate, Filter],Model[Container, Plate, Filter]],
      Description -> "The consumable container with an embedded filter which is used to separate the solid and liquid phases of the sample after adding incubation with the NeutralizationReagent.",
      Category -> "Neutralization"
    },
    NeutralizationPrefilterPoreSize -> {
      Format -> Single,
      Class -> Real,
      Pattern :> FilterSizeP,
      Units -> Micron,
      Description -> "The pore size of the prefilter membrane, which is placed above NeutralizationFilter, and is designed so that molecules larger than the specified prefilter pore size should not pass through this filter.",
      Category -> "Neutralization"
    },
    NeutralizationPrefilterMembraneMaterial -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> FilterMembraneMaterialP,
      Description -> "The material from which the prefilter filtration membrane, which is placed above NeutralizationFilter, is composed. Solvents used should be carefully selected to be compatible with the membrane material.",
      Category -> "Neutralization"
    },
    NeutralizationPoreSize -> {
      Format -> Single,
      Class -> Real,
      Pattern :> FilterSizeP,
      Units -> Micron,
      Description -> "The pore size of the filter which is designed such that molecules larger than the specified pore size should not pass through this filter.",
      Category -> "Neutralization"
    },
    NeutralizationMembraneMaterial -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> FilterMembraneMaterialP,
      Description -> "The material from which the filtration membrane is composed. Solvents used should be carefully selected to be compatible with membrane material.",
      Category -> "Neutralization"
    },
    NeutralizationFilterCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> GreaterP[0, RPM] | GreaterP[0, GravitationalAcceleration],
      Units -> None,
      Description -> "The rotational speed or force that will be applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
      Category -> "Neutralization"
    },
    NeutralizationFiltrationPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description -> "The pressure applied to the sample in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
      Category -> "Neutralization"
    },
    NeutralizationFiltrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The duration for which the samples will be exposed to either NeutralizationFiltrationPressure or NeutralizationFiltrationCentrifugeIntensity in order to force the liquid through the filter and facilitate separation of the liquid phase from the insoluble molecules that are larger than the NeutralizationPoreSize of NeutralizationFilter.",
      Category -> "Neutralization"
    },
    NeutralizationPelletCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or the force that will be applied to the neutralized lysate to facilitate precipitation of insoluble cellular components out of solution.",
      Category -> "Neutralization"
    },
    NeutralizationPelletCentrifugeTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The duration for which the neutralized lysate will be centrifuged to facilitate precipitation of insoluble cellular components out of solution.",
      Category -> "Neutralization"
    }
  }
}];