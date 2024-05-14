(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, Extraction, SubcellularProtein], {
  Description -> "A method specifying conditions and reagents for the extraction, subcellular fractionation, and isolation of protein from a cell-containing sample.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* General *)

    TargetProtein -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Alternatives[ObjectP[Model[Molecule,Protein]],All],
      Description -> "The target protein that is isolated from SamplesIn during protein extraction. If isolating a specific target protein that is antigen, antibody, or his-tagged, subsequent isolation can happen via affinity column or affinity-based magnetic beads during purification. If isolating all proteins, purification can happen via liquid liquid extraction, solid phase extraction, magnetic bead separation, or precipitation.",
      Category -> "General"
    },
    TargetSubcellularFraction -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> DuplicateFreeListableP[Alternatives[Cytosolic, Membrane, Nuclear]],
      Description -> "The subcellular protein fraction(s) of interest from SamplesIn. One or more subcellular fractions can be chosen from Cytosolic, Membrane, and Nuclear. Note that in order to access the membrane proteins and nuclear proteins, cytosolic proteins must be first extracted. Therefore, if TargetSubcellularFraction is set to Membrane or Nuclear, the FractionationOrder option is automatically set to extract the Cytosolic proteins first.",
      Category -> "General"
    },

    (* Lysis *)

    LysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the LysisSolution is incubated during the LysisSolutionEquilibrationTime before addition to the cell sample.",
      Category -> "Cell Lysis"
    },
    LysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the LysisSolution is incubated at LysisSolutionTemperature before addition to the cell sample.",
      Category -> "Cell Lysis"
    },
    SecondaryLysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the SecondaryLysisSolution is incubated during the SecondaryLysisSolutionEquilibrationTime before addition to the sample after the sample during the optional secondary lysis.",
      Category -> "Cell Lysis"
    },
    SecondaryLysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the SecondaryLysisSolution is incubated at SecondaryLysisSolutionTemperature before addition to the sample during the optional secondary lysis.",
      Category -> "Cell Lysis"
    },
   TertiaryLysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the TertiaryLysisSolution is incubated during the TertiaryLysisSolutionEquilibrationTime before addition to the sample after the sample during the optional tertiary lysis.",
      Category -> "Cell Lysis"
    },
    TertiaryLysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Second,
      Description -> "The minimum duration during which the TertiaryLysisSolution is incubated at TertiaryLysisSolutionTemperature before addition to the sample during the optional tertiary lysis.",
      Category -> "Cell Lysis"
    },

    (* Fractionation *)
    FractionationOrder -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> DuplicateFreeListableP[Alternatives[Cytosolic, Membrane, Nuclear]],
      Description -> "The sequence of subcellular fractions that are separated out from the lysate sample. Due to its highly soluble nature, the cytosolic fraction separates out first if any subcellular fraction is targeted even if Cytosolic is not in TargetSubcellularFraction. The subsequent order of Membrane and Nuclear is interchangeable since different solutions can be applied to solubilize membranes or lyse the nuclei. Note that the FractionationOrder option is a superset of the subcellular protein fractions of interest as specified in the TargetSubcellularFraction option.",
      Category -> "Fractionation"
    },
    FractionationFilter -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        (* Cartridges *)
        Model[Container, ExtractionCartridge], Object[Container, ExtractionCartridge],
        (* Spin column *)
        Model[Container, Vessel, Filter], Object[Container, Vessel, Filter],
        (* Filter Plate *)
        Model[Container, Plate, Filter], Object[Container, Plate, Filter]
      ],
      Description -> "The consumable container with an embedded filter which is used to retain the insoluble components on the filter and to separate the soluble fraction as the filtrate by flushing the sample through the pores in the filter. The sample is introduced into the filter when the fractionation technique is Filter for the first time according to the FractionationOrder, and the separation techniques following this fractionation step have to be Filter because the targets of the subsequent steps are retained on the filter. For example, if the FractionationOrder is {Cytosolic,Membrane,Nuclear} with CytosolicFractionationTechnique->Pellet and Membrane FractionationTechnique->Filter, the sample is introduced onto the FractionationFilter after membrane solubilization, and NuclearWashSeparationTechnique and NuclearFractionationTechnique need to be Filter as well.",
      Category -> "Fractionation"
    },
    CytosolicFractionationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "The type of force used to separate soluble protein-containing cytosolic fractions apart from insoluble fractions and components including membrane proteins, organelles, intact nuclei, cell debris, etc. Options include Pellet and Filter. With Pellet, the soluble cytosolic fraction is separated out by centrifugation as the supernatant from the insoluble membrane-bound proteins and intact nuclei. With Filter, the cytosolic fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. When CytosolicFractionationTechnique is set to Null, no cytosolic fractionation step is performed, and the lysate sample is directly subject to purification.",
      Category -> "Fractionation"
    },
    CytosolicFractionationPelletIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components in the lysate and to separate the cytosolic fraction as the supernatant during CytosolicFractionation.",
      Category -> "Fractionation"
    },
    CytosolicFractionationPelletTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the sample is subject to the CytosolicFractionationPelletIntensity in order to pellet the insoluble components in the lysate and to separate the cytosolic fraction as the supernatant during CytosolicFractionation.",
      Category -> "Fractionation"
    },
    CytosolicFractionationFilterTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Centrifuge | AirPressure,
      Description->"The type of force used to flush the cell lysate sample through the FractionationFilter in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
      Category -> "Fractionation"
    },
    CytosolicFractionationFilterCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the cell lysate sample through the FractionationFilter during the CytosolicFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
      Category -> "Fractionation"
    },
    CytosolicFractionationFilterPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description->"The amount of pressure applied to flush the lysate sample through the through the FractionationFilter during the CytosolicFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
      Category -> "Fractionation"
    },
    CytosolicFractionationFilterTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration of time for which force is applied to flush the lysate sample through the through the FractionationFilter by the specified CytosolicFractionationFilterTechnique and CytosolicFractionationFilterInstrument,in order to retain the insoluble components on the filter and to separate the cytosolic fraction as the filtrate during CytosolicFractionation.",
      Category -> "Fractionation"
    },
    CytosolicFractionationCollectionContainerTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the sample collection container is maintained during the CytosolicFractionationCollectionContainerEquilibrationTime before the supernatant or filtrate sample from pelleting or filtering during cytosolic fractionation is transferred into it.",
      Category -> "Fractionation"
    },
    CytosolicFractionationCollectionContainerEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the the sample collection container is maintained at CytosolicFractionationCollectionContainerTemperature before the supernatant or filtrate sample from pelleting or filtering during cytosolic fractionation is transferred into it.",
      Category -> "Fractionation"
    },
    NumberOfMembraneWashes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> RangeP[0, 50, 1],
      Units -> None,
      Description->"The number of times the pellet or filter from cytosolic fractionation or membrane fractionation, depending on the FractionationOrder, is rinsed in order to remove non-membrane-bound protein contamination as much as possible. The pellet is rinsed by adding MembraneWashSolution, mixing, incubating (optional), pelleting, and aspirating. The filter is rinsed by adding MembraneWashSolution, incubating, and filtering.",
      Category -> "Fractionation"
    },
    MembraneWashSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution used to rinse the the pellet or filter from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) in order to remove non-membrane-bound protein contamination as much as possible.",
      Category -> "Fractionation"
    },
    MembraneWashSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the MembraneWashSolution is maintained during the MembraneWashSolutionEquilibrationTime before addition to the pellet or filter in order to rinse during each pre membrane solubilization wash.",
      Category -> "Fractionation"
    },
    MembraneWashSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the MembraneWashSolution is maintained at MembraneWashSolutionTemperature before addition to the pellet or filter to rinse during each pre membrane solubilization wash.",
      Category -> "Fractionation"
    },
    MembraneWashMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "The manner in which the solution is mixed following the combination of MembraneWashSolution and the pellet from the previous fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each pre membrane solubilization wash. Only applicable when the previous fractionation technique is Pellet.",
      Category -> "Fractionation"
    },
    MembraneWashMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[30 RPM, 2500 RPM],
      Units -> RPM,
      Description->"The rate at which the sample is mixed by the selected MembraneWashMixType during the MembraneWashMixTime.",
      Category -> "Fractionation"
    },
    MembraneWashMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the instrument heating or cooling the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) is maintained during the MembraneWashMixTime, which occurs immediately before the MembraneWashIncubationTime or MembraneWashPelletTime if MembraneWashIncubationTime is Null or 0 Minute.",
      Category -> "Fractionation"
    },
    MembraneWashMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration for which the sample is mixed by the selected MembraneWashMixType following the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder).",
      Category -> "Fractionation"
    },
    NumberOfMembraneWashMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description->"The number of times that the sample is mixed by pipetting the MembraneWashMixVolume up and down following the combination of MembraneWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder).",
      Category -> "Fractionation"
    },
    MembraneWashIncubationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The minimum duration for which the Instrument heating or cooling the mixed pellet and the MembraneWashSolution is maintained at the MembraneWashIncubationTemperature to facilitate washing of the pellet in order to remove non-membrane-bound protein contamination as much as possible. The MembraneWashIncubationTime occurs immediately after MembraneWashMixTime.",
      Category -> "Fractionation"
    },
    MembraneWashIncubationTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description->"The temperature at which the instrument heating or cooling the mixed pellet and the MembraneWashSolution is maintained during the MembraneWashIncubationTime.",
      Category -> "Fractionation"
    },
    MembraneWashSeparationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "The type of force used to separate the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder). Options include Pellet and Filter. With Pellet, the possibly remaining cytosolic fraction or nuclear fraction is separated out by centrifugation as the supernatant from the insoluble membrane-bound proteins. With Filter, the possibly remaining cytosolic fraction or nuclear fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. If last used technique is Pellet, MembraneWashTechnique can be Pellet or Filter. However, if last used technique is Filter, MembraneWashTechnique can only be Filter.",
      Category -> "Fractionation"
    },
    MembraneWashPelletIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder) rinsed into the MembraneWashSolution as the supernatant during each pre membrane solubilization wash.",
      Category -> "Fractionation"
    },
    MembraneWashPelletTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the sample is subject to the MembraneWashPelletIntensity in order to pellet the insoluble components and to separate the possibly remaining cytosolic fraction or nuclear fraction (depending on the FractionationOrder) rinsed into the MembraneWashSolution as the supernatant during each pre membrane solubilization wash.",
      Category -> "Fractionation"
    },
    MembraneWashFilterTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Centrifuge | AirPressure,
      Description->"The type of force used to flush the incubated (optional) MembraneWashSolution through the working filter from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder) in order to rinse away the non-membrane-bound protein contamination as much as possible.",
      Category -> "Fractionation"
    },
    MembraneWashFilterCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the incubated (optional) MembraneWashSolution through the working filter during the MembraneWashFilterTime, in order to rinse away the non-membrane-bound protein contamination as much as possible.",
      Category -> "Fractionation"
    },
    MembraneWashFilterPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description->"The amount of pressure applied to flush the incubated (optional) MembraneWashSolution through the working filter during the MembraneWashFilterTime, in order to rinse away the non-membrane-bound protein contamination as much as possible during MembraneWash.",
      Category -> "Fractionation"
    },
    MembraneWashFilterTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration of time for which force is applied to flush the incubated (optional) MembraneWashSolution through the working filter by the specified MembraneWashFilterTechnique and MembraneWashFilterInstrument,in order to rinse away the non-membrane-bound protein contamination as much as possible during MembraneWash.",
      Category -> "Fractionation"
    },
    MembraneWashCollectionContainerTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the sample collection container is maintained during the MembraneWashCollectionContainerEquilibrationTime before the supernatant from pelleting or the filtrate from filtering during each pre membrane solubilization wash is transferred into it.",
      Category -> "Fractionation"
    },
    MembraneWashCollectionContainerEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the the sample collection container is maintained at MembraneWashCollectionContainerTemperature before the supernatant from pelleting or the filtrate from filtering during each pre membrane solubilization wash is transferred into it.",
      Category -> "Fractionation"
    },
    
    MembraneSolubilizationSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution, usually containing mild and selective detergents, added to the pellet or filter from the optional pre membrane solubilization wash or the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder), in order to solubilize the integral and attached membrane proteins. If CellType is eukaryotic and if nuclear fractionation is to be performed after membrane fractionation, the MembraneSolubilizationSolution needs to have limited digestive power towards nuclear membrane.",
      Category -> "Fractionation"
    },
    MembraneSolubilizationSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the MembraneSolubilizationSolution is maintained during the MembraneSolubilizationSolutionEquilibrationTime before addition to the pellet or filter.",
      Category -> "Fractionation"
    },
    MembraneSolubilizationSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the MembraneSolubilizationSolution is maintained at MembraneSolubilizationSolutionTemperature before addition to the pellet or filter.",
      Category -> "Fractionation"
    },
    MembraneSolubilizationMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "The manner in which the solution is mixed following the combination of MembraneSolubilizationSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each membrane solubilization mix. Only applicable when the technique for the previous step (either the optional pre membrane solubilization wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order) is Pellet.",
      Category -> "Fractionation"
    },
    MembraneSolubilizationMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[30 RPM, 2500 RPM],
      Units -> RPM,
      Description->"The rate at which the sample is mixed by the selected MembraneSolubilizationMixType during the MembraneSolubilizationMixTime.",
      Category -> "Fractionation"
    },
    MembraneSolubilizationMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the Instrument heating or cooling the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional pre membrane solubilization wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order) is maintained during the MembraneSolubilizationMixTime, which occurs immediately before the MembraneSolubilizationTime (or MembraneFractionationPelletTime if MembraneSolubilizationTime is Null or 0 Minute).",
      Category -> "Fractionation"
    },
    MembraneSolubilizationMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration for which the sample is mixed by the selected MembraneSolubilizationMixType following the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional pre membrane solubilization wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order).",
      Category -> "Fractionation"
    },
    NumberOfMembraneSolubilizationMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description->"The number of times that the sample is mixed by pipetting the MembraneSolubilizationMixVolume up and down following the combination of MembraneSolubilizationSolution and the pellet from the previous step (either the optional pre membrane solubilization wash, or one of cytosolic frationation and nuclear fractionation depending on the fractionation order).",
      Category -> "Fractionation"
    },
    MembraneSolubilizationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration for which the instrument heating or cooling the filter with added MembraneSolubilizationSolution or the mixed pellet and the MembraneSolubilizationSolution is maintained at the MembraneSolubilizationTemperature to facilitate solubilization of the integral or attached membrane proteins. The MembraneSolubilizationTime occurs immediately after MembraneSolubilizationMixTime.",
      Category -> "Fractionation"
    },
    MembraneSolubilizationTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description->"The temperature at which the Instrument heating or cooling the mixed pellet and the MembraneSolubilizationSolution is maintained during the MembraneSolubilizationTime.",
      Category -> "Fractionation"
    },
    
    MembraneFractionationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "The type of force used to separate membrane fraction containing solubilized membrane proteins apart from insoluble fractions and components including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder. Options include Pellet and Filter. With Pellet, the soluble membrane fraction is separated out by centrifugation as the supernatant. With Filter, the membrane fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. When MembraneFractionationTechnique is set to Null, no membrane fractionation step is performed.",
      Category -> "Fractionation"
    },
    MembraneFractionationPelletIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components, including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder, and to separate the membrane fraction containing the solubilized membrane-bound proteins as the supernatant during MembraneFractionation.",
      Category -> "Fractionation"
    },
    MembraneFractionationPelletTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the sample is subject to the MembraneFractionationPelletIntensity in order to pellet the insoluble components, including cell debris and possibly intact nuclei if Nuclear is not preceding Membrane in FractionationOrder, and to separate the membrane fraction containing the solubilized membrane-bound proteins as the supernatant during MembraneFractionation.",
      Category -> "Fractionation"
    },
    MembraneFractionationFilterTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Centrifuge | AirPressure,
      Description->"The type of force used to flush the sample from membrane solubilization through the FractionationFilter in order to retain the insoluble components on the filter and to separate the membrane fraction containing solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
      Category -> "Fractionation"
    },
    MembraneFractionationFilterCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the sample from membrane solubilization through the FractionationFilter during the MembraneFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the membrane fraction containing the solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
      Category -> "Fractionation"
    },
    MembraneFractionationFilterPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description->"The amount of pressure applied to flush the sample from membrane solubilization through the through the FractionationFilter during the MembraneFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the membrane fraction containing the solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
      Category -> "Fractionation"
    },
    MembraneFractionationFilterTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration of time for which force is applied to flush the sample from membrane solubilization through the through the FractionationFilter by the specified MembraneFractionationFilterTechnique and MembraneFractionationFilterInstrument,in order to retain the insoluble components on the filter and to separate the membrane fraction containing the solubilized membrane-bound proteins as the filtrate during MembraneFractionation.",
      Category -> "Fractionation"
    },
    MembraneFractionationCollectionContainerTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the sample collection container is maintained during the MembraneFractionationCollectionContainerEquilibrationTime before the supernatant or filtrate sample from pelleting or filtering during membrane fractionation is transferred into it.",
      Category -> "Fractionation"
    },
    MembraneFractionationCollectionContainerEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the the sample collection container is maintained at MembraneFractionationCollectionContainerTemperature before the supernatant or filtrate sample from pelleting or filtering during membrane fractionation is transferred into it.",
      Category -> "Fractionation"
    },
    NumberOfNuclearWashes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> RangeP[0, 50, 1],
      Units -> None,
      Description->"The number of times the pellet or filter from cytosolic fractionation or membrane fractionation, depending on the FractionationOrder, is rinsed in order to remove non-nuclear protein contamination as much as possible. The pellet is rinsed by adding NuclearWashSolution, mixing, incubating (optional), pelleting, and aspirating. The filter is rinsed by adding NuclearWashSolution, incubating, and filtering.",
      Category -> "Fractionation"
    },
    NuclearWashSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution used to rinse the the pellet or filter from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) in order to remove non-nuclear protein contamination as much as possible.",
      Category -> "Fractionation"
    },
    NuclearWashSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the NuclearWashSolution is maintained during the NuclearWashSolutionEquilibrationTime before addition to the pellet or filter in order to rinse during each pre nuclear lysis wash.",
      Category -> "Fractionation"
    },
    NuclearWashSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the NuclearWashSolution is maintained at NuclearWashSolutionTemperature before addition to the pellet or filter to rinse during each pre nuclear lysis wash.",
      Category -> "Fractionation"
    },
    NuclearWashMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "The manner in which the solution is mixed following the combination of NuclearWashSolution and the pellet from the previous fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each pre nuclear lysis wash. Only applicable when the previous fractionation technique is Pellet.",
      Category -> "Fractionation"
    },
    NuclearWashMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[30 RPM, 2500 RPM],
      Units -> RPM,
      Description->"The rate at which the sample is mixed by the selected NuclearWashMixType during the NuclearWashMixTime.",
      Category -> "Fractionation"
    },
    NuclearWashMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the instrument heating or cooling the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) is maintained during the NuclearWashMixTime, which occurs immediately before the NuclearWashIncubationTime or NuclearWashPelletTime if NuclearWashIncubationTime is Null or 0 Minute.",
      Category -> "Fractionation"
    },
    NuclearWashMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration for which the sample is mixed by the selected NuclearWashMixType following the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or nuclear fractionation, depending on the FractionationOrder).",
      Category -> "Fractionation"
    },
    NumberOfNuclearWashMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description->"The number of times that the sample is mixed by pipetting the NuclearWashMixVolume up and down following the combination of NuclearWashSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder).",
      Category -> "Fractionation"
    },
    NuclearWashIncubationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The minimum duration for which the Instrument heating or cooling the mixed pellet and the NuclearWashSolution is maintained at the NuclearWashIncubationTemperature to facilitate washing of the pellet in order to remove non-nuclear protein contamination as much as possible. The NuclearWashIncubationTime occurs immediately after NuclearWashMixTime.",
      Category -> "Fractionation"
    },
    NuclearWashIncubationTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description->"The temperature at which the instrument heating or cooling the mixed pellet and the NuclearWashSolution is maintained during the NuclearWashIncubationTime.",
      Category -> "Fractionation"
    },
    NuclearWashSeparationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "The type of force used to separate the insoluble components and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder). Options include Pellet and Filter. With Pellet, the possibly remaining cytosolic fraction or membrane fraction is separated out by centrifugation as the supernatant from the intact nuclei. With Filter, the possibly remaining cytosolic fraction or membrane fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. If last used technique is Pellet, NuclearWashTechnique can be Pellet or Filter. However, if last used technique is Filter, NuclearWashTechnique can only be Filter.",
      Category -> "Fractionation"
    },
    NuclearWashPelletIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components and intact nuclei and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder) rinsed into the NuclearWashSolution as the supernatant during each pre nuclear lysis wash.",
      Category -> "Fractionation"
    },
    NuclearWashPelletTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the sample is subject to the NuclearWashPelletIntensity in order to pellet the insoluble components and intact nuclei and to separate the possibly remaining cytosolic fraction or membrane fraction (depending on the FractionationOrder) rinsed into the NuclearWashSolution as the supernatant during each pre nuclear lysis wash.",
      Category -> "Fractionation"
    },
    NuclearWashFilterTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Centrifuge | AirPressure,
      Description->"The type of force used to flush the incubated (optional) NuclearWashSolution through the working filter from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder) in order to rinse away the non-nuclear protein contamination as much as possible.",
      Category -> "Fractionation"
    },
    NuclearWashFilterCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the incubated (optional) NuclearWashSolution through the working filter during the NuclearWashFilterTime, in order to rinse away the non-nuclear protein contamination as much as possible.",
      Category -> "Fractionation"
    },
    NuclearWashFilterPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description->"The amount of pressure applied to flush the incubated (optional) NuclearWashSolution through the working filter during the NuclearWashFilterTime, in order to rinse away the non-nuclear protein contamination as much as possible during NuclearWash.",
      Category -> "Fractionation"
    },
    NuclearWashFilterTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration of time for which force is applied to flush the incubated (optional) NuclearWashSolution through the working filter by the specified NuclearWashFilterTechnique and NuclearWashFilterInstrument,in order to rinse away the non-nuclear protein contamination as much as possible during NuclearWash.",
      Category -> "Fractionation"
    },
    NuclearWashCollectionContainerTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the sample collection container is maintained during the NuclearWashCollectionContainerEquilibrationTime before the supernatant from pelleting or the filtrate from filtering during each pre nuclear lysis wash is transferred into it.",
      Category -> "Fractionation"
    },
    NuclearWashCollectionContainerEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the the sample collection container is maintained at NuclearWashCollectionContainerTemperature before the supernatant from pelleting or the filtrate from filtering during each pre nuclear lysis wash is transferred into it.",
      Category -> "Fractionation"
    },

    NuclearLysisSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution, usually containing mild and selective detergents, added to the pellet or filter from the optional pre nuclear lysis wash or the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder), in order to break the nuclear envelope and release the components inside including nuclear proteins. Nucleic acids are commonly digested during nuclear lysis. If CellType is eukaryotic and if membrane fractionation is to be performed after nuclear fractionation, the NuclearLysisSolution needs to have limited solubilization power towards membrane-bound proteins.",
      Category -> "Fractionation"
    },
    NuclearLysisSolutionTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the NuclearLysisSolution is maintained during the NuclearLysisSolutionEquilibrationTime before addition to the pellet or filter.",
      Category -> "Fractionation"
    },
    NuclearLysisSolutionEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the NuclearLysisSolution is maintained at NuclearLysisSolutionTemperature before addition to the pellet or filter.",
      Category -> "Fractionation"
    },
    NuclearLysisMixType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Shake | Pipette | None,
      Description -> "The manner in which the solution is mixed following the combination of NuclearLysisSolution and the pellet from the last fractionation step (cytosolic fractionation or membrane fractionation, depending on the FractionationOrder). None specifies that no mixing occurs each nuclear lysis mix. Only applicable when the technique for the previous step (either the optional pre nuclear lysis wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order) is Pellet.",
      Category -> "Fractionation"
    },
    NuclearLysisMixRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[30 RPM, 2500 RPM],
      Units -> RPM,
      Description->"The rate at which the sample is mixed by the selected NuclearLysisMixType during the NuclearLysisMixTime.",
      Category -> "Fractionation"
    },
    NuclearLysisMixTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the Instrument heating or cooling the combination of NuclearLysisSolution and the pellet from the previous step (either the optional pre nuclear lysis wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order) is maintained during the NuclearLysisMixTime, which occurs immediately before the NuclearLysisTime (or NuclearFractionationPelletTime if NuclearLysisTime is Null or 0 Minute).",
      Category -> "Fractionation"
    },
    NuclearLysisMixTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration for which the sample is mixed by the selected NuclearLysisMixType following the combination of NuclearLysisSolution and the pellet from the previous step (either the optional pre nuclear lysis wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order).",
      Category -> "Fractionation"
    },
    NumberOfNuclearLysisMixes -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> RangeP[1, 50, 1],
      Units -> None,
      Description->"The number of times that the sample is mixed by pipetting the NuclearLysisMixVolume up and down following the combination of NuclearLysisSolution and the pellet from the previous step (either the optional pre nuclear lysis wash, or one of cytosolic frationation and membrane fractionation depending on the fractionation order).",
      Category -> "Fractionation"
    },
    NuclearLysisTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration for which the instrument heating or cooling the filter with added NuclearLysisSolution or the mixed pellet and the NuclearLysisSolution is maintained at the NuclearLysisTemperature to facilitate digestion of nuclear envelope. The NuclearLysisTime occurs immediately after NuclearLysisMixTime.",
      Category -> "Fractionation"
    },
    NuclearLysisTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description->"The temperature at which the Instrument heating or cooling the mixed pellet and the NuclearLysisSolution is maintained during the NuclearLysisTime.",
      Category -> "Fractionation"
    },
    NuclearFractionationTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Pellet | Filter,
      Description -> "The type of force used to separate nuclear fraction, containing nuclear components released by lysing the nuclei, apart from insoluble fractions and components including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder. Options include Pellet and Filter. With Pellet, the released nuclear fraction is separated out by centrifugation as the supernatant. With Filter, the nuclear fraction is collected as filtrate by applying a positive pressure to force the sample through a solid phase separation column. When NuclearFractionationTechnique is set to Null, no nuclear fractionation step is performed.",
      Category -> "Fractionation"
    },
    NuclearFractionationPelletIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description -> "The rotational speed or the force that is applied to the samples in order to pellet the insoluble components, including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder, and to separate the nuclear fraction containing the nuclear proteins as the supernatant during NuclearFractionation.",
      Category -> "Fractionation"
    },
    NuclearFractionationPelletTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Second],
      Units -> Minute,
      Description -> "The duration for which the sample is subject to the NuclearFractionationPelletIntensity in order to pellet the insoluble components, including cell debris and possibly insoluble membrane proteins if Membrane is not preceding Nuclear in FractionationOrder, and to separate the nuclear fraction containing the nuclear proteins as the supernatant during NuclearFractionation.",
      Category -> "Fractionation"
    },
    NuclearFractionationFilterTechnique -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> Centrifuge | AirPressure,
      Description->"The type of force used to flush the sample from nuclear lysis through the FractionationFilter in order to retain the insoluble components on the filter and to separate the nuclear fraction containing nuclear proteins as the filtrate during NuclearFractionation.",
      Category -> "Fractionation"
    },
    NuclearFractionationFilterCentrifugeIntensity -> {
      Format -> Single,
      Class -> VariableUnit,
      Pattern :> Alternatives[GreaterEqualP[0 GravitationalAcceleration], GreaterEqualP[0 RPM]],
      Units -> None,
      Description->"The rotational speed or gravitational force at which the sample is centrifuged to flush the sample from nuclear lysis through the FractionationFilter during the NuclearFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the nuclear fraction containing the nuclear proteins as the filtrate during NuclearFractionation.",
      Category -> "Fractionation"
    },
    NuclearFractionationFilterPressure -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 PSI],
      Units -> PSI,
      Description->"The amount of pressure applied to flush the sample from nuclear lysis through the through the FractionationFilter during the NuclearFractionationFilterTime, in order to retain the insoluble components on the filter and to separate the nuclear fraction containing the nuclear proteins as the filtrate during NuclearFractionation.",
      Category -> "Fractionation"
    },
    NuclearFractionationFilterTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description->"The duration of time for which force is applied to flush the sample from nuclear lysis through the through the FractionationFilter by the specified NuclearFractionationFilterTechnique and NuclearFractionationFilterInstrument,in order to retain the insoluble components on the filter and to separate the nuclear fraction containing the nuclear proteins as the filtrate during NuclearFractionation.",
      Category -> "Fractionation"
    },
    NuclearFractionationCollectionContainerTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Celsius, 110 Celsius],
      Units -> Celsius,
      Description -> "The temperature at which the sample collection container is maintained during the NuclearFractionationCollectionContainerEquilibrationTime before the supernatant or filtrate sample from pelleting or filtering during nuclear fractionation is transferred into it.",
      Category -> "Fractionation"
    },
    NuclearFractionationCollectionContainerEquilibrationTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> RangeP[0 Second, 72 Hour],
      Units -> Second,
      Description -> "The duration for which the the sample collection container is maintained at NuclearFractionationCollectionContainerTemperature before the supernatant or filtrate sample from pelleting or filtering during nuclear fractionation is transferred into it.",
      Category -> "Fractionation"
    }
  }
}];