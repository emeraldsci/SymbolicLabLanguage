(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

$SharedChangeMediaFields={
    CellType -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> CellTypeP,
        Description -> "The taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, Insect, Plant, and Yeast.",
        Category -> "General"
    },
    RoboticInstrument -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
            Object[Instrument],
            Model[Instrument]
        ],
        Description -> "The instrument that transfers the sample and buffers between containers to execute the protocol.",
        Category -> "General"
    },
    CultureAdhesion -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> Alternatives[Suspension, Adherent],
        Description -> "Indicates how the cell sample physically interacts with its container prior to washing cells/changing media. Options include Adherent and Suspension (including any microbial liquid media).",
        Category -> "General"
    },
    CellIsolationTechnique -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> Pellet | Aspirate,
        Description -> "The technique used to remove impurities, debris, and media from cell samples prior to washing cells or changing media. Suspension cells are centrifuged to separate the cells from the media or buffer. Adherent cells remain attached to the bottom of the culture plate whereas the media can be removed via aspiration.",
        Category -> "General"
    },
    CellIsolationInstrument -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
            Object[Instrument],
            Model[Instrument]
        ],
        Description -> "The instrument used to isolate the cell sample prior to washing cells or changing media. Centrifuging separates cells from media, forming a cell pellet. The supernatant is removed or harvested, leaving the cell pellet in the container.",
        Category -> "General"
    },
    CellIsolationTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Minute],
        (* Pattern :> RangeP[0 Minute, $MaxExperimentTime],*)
        Units -> Minute,
        Description -> "The amount of time to centrifuge the cell samples prior to washing cells or changing media. Centrifuging is intended to separate cells from media.",
        Category -> "Media Aspiration"
    },
    CellPelletIntensity -> {
        Format -> Single,
        Class -> VariableUnit,
        Pattern :> GreaterP[0 * RPM] | GreaterP[0 * GravitationalAcceleration],
        Units -> None,
        Description -> "The rotational speed or force applied to the cell sample by centrifugation prior to washing cells or changing media. Centrifuging is intended to separate cells from media, forming a cell pellet.",
        Category -> "Media Aspiration"
    },
    CellAspirationAngle -> {
        Format -> Single,
        Class -> VariableUnit,
        Pattern :> GreaterP[0 AngularDegree],
        Units -> None,
        Description -> "Indicates the tilting angle of the adherent cell culture plate when aspirating off the input sample media. See figure XXX.", (*show a figure*)
        Category -> "Media Aspiration"
    },
    AliquotSourceMedia -> {
        Format -> Single,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "Indicates if sample of source media is collected for future analysis prior to washing.",
        Category -> "Media Aspiration"
    },
    AliquotMediaStorageCondition -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> SampleStorageTypeP | Disposal,
        Description -> "Indicates the conditions under which separated source media are saved after cell isolation.",
        Category -> "Media Aspiration"
    },
    NumberOfWashes -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The number of times the sample is washed with WashSolution, prior to replenishment with fresh media, in order to wash trace amounts of media and metabolites from the cells.",
        Category -> "Washing"
    },
    WashSolution -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
            Model[Sample]
        ],
        Description -> "The buffer used to wash the cell sample after removing media.",
        Category -> "Washing"
    },
    WashSolutionTemperature -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Celsius],
        Units -> Celsius,
        Description -> "The temperature of the wash solution in cell wash experiment.",
        Category -> "Washing"
    },
    WashSolutionEquilibrationTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Minute],
        (* Pattern :> RangeP[0 Minute, $MaxExperimentTime],*)
        Units -> Minute,
        Description -> "The WashSolution will be incubated for a minimum duration of this time at WashSolutionEquilibrationTemperature prior to washing the live cell sample.",
        Category -> "Washing"
    },
    WashMixType -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> RoboticMixTypeP | None,
        Description -> "Indicates the style of motion (Shake or Pipette) used to mix the cell sample with WashSolution.",
        Category -> "Washing"
    },
    WashMixInstrument -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
            Object[Instrument],
            Model[Instrument]
        ],
        Description -> "The instrument used to mix the cell sample with WashSolution via Shake.",
        Category -> "Washing"
    },
    WashMixTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Minute],
        (* Pattern :> RangeP[0 Minute, $MaxExperimentTime],*)
        Units -> Minute,
        Description -> "Duration of time to mix the cell sample with WashSolution via Shake.",
        Category -> "Washing"
    },
    WashMixRate -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 RPM],
        Units -> RPM,
        Description -> "The rate at which the sample is mixed with WashSolution via the selected WashMixType for the duration specified by WashMixTime.",
        Category -> "Washing"
    },
    NumberOfWashMixes -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The number of pipetting cycles (drawing liquid up into the pipette and dispensing back down out of the pipette) used to mix the live cell samples with WashSolution.",
        Category -> "Washing"
    },
    WashTemperature -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Celsius],
        Units -> Celsius,
        Description -> "The temperature of the device that is used to mix the live cells in WashSolution.",
        Category -> "Washing"
    },
    WashIsolationTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Minute],
        (* Pattern :> RangeP[0 Minute, $MaxExperimentTime],*)
        Units -> Minute,
        Description -> "The amount of time to pellet the cell samples prior to changing media. Centrifuging is intended to separate cells from media.",
        Category -> "Washing"
    },
    WashPelletIntensity -> {
        Format -> Single,
        Class -> VariableUnit,
        Pattern :> GreaterP[0 * RPM] | GreaterP[0 * GravitationalAcceleration],
        Units -> None,
        Description -> "The rotational speed or force applied to the cell sample by centrifugation prior to changing media. Centrifuging is intended to separate cells from media, forming a cell pellet.",
        Category -> "Washing"
    },
    WashAspirationAngle -> {
        Format -> Single,
        Class -> VariableUnit,
        Pattern :> GreaterP[0 AngularDegree],
        Units -> None,
        Description -> "Indicates the tilting angle of the adherent cell culture plate to aspirate off the wash buffer. The tilt causes the liquid to pool on one edge of the container, thereby making it easier to aspirate off the liquid.",
        Category -> "Washing"
    },
    ResuspensionMedia -> { (* Notice: This link cannot be downloaded *)
        Format -> Single,
        Class -> Expression,
        Pattern :> _Link | None,
        Description -> "The media used to resuspend the cell pellet after washing with WashSolution.",
        Category -> "Media Replenishment"
    },
    ResuspensionMediaTemperature -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Celsius],
        Units -> Celsius,
        Description -> "The temperature of the media used to resuspend the cell sample.",
        Category -> "Media Replenishment"
    },
    ResuspensionMediaEquilibrationTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Minute],
        (* Pattern :> RangeP[0 Minute, $MaxExperimentTime],*)
        Units -> Minute,
        Description -> "Indicates the ResuspensionMedia is incubated at ResuspensionMediaTemperature for at least this amount of time prior to resuspending the cell sample.",
        Category -> "Media Replenishment"
    },
    ResuspensionMixType -> {
        Format -> Single,
        Class -> Expression,
        Pattern :> RoboticMixTypeP | None,
        Description -> "Indicates the style of motion (Shake or Pipette) used to resuspend the cell sample with ResuspensionMedia. If ResuspensionMixType is set to None, the cells will not be mixed with the ResuspensionMedia.",
        Category -> "Media Replenishment"
    },
    ResuspensionTemperature -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Celsius],
        Units -> Celsius,
        Description -> "The temperature of the device that is used to resuspend the cells in ResuspensionMedia.",
        Category -> "Media Replenishment"
    },
    ResuspensionMixInstrument -> {
        Format -> Single,
        Class -> Link,
        Pattern :> _Link,
        Relation -> Alternatives[
            Object[Instrument],
            Model[Instrument]
        ],
        Description -> "The instrument used to resuspend the cell sample with ResuspensionMedia.",
        Category -> "Media Replenishment"
    },
    ResuspensionMixTime -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 Minute],
        (* Pattern :> RangeP[0 Minute, $MaxExperimentTime],*)
        Units -> Minute,
        Description -> "Duration of time to mix the cell sample with ResuspensionMedia.",
        Category -> "Media Replenishment"
    },
    ResuspensionMixRate -> {
        Format -> Single,
        Class -> Real,
        Pattern :> GreaterP[0 RPM],
        Units -> RPM,
        Description -> "The shaking rate to mix cell sample with the ResuspensionMedia over the ResuspensionMediaMixTime.",
        Category -> "Media Replenishment"
    },
    NumberOfResuspensionMixes -> {
        Format -> Single,
        Class -> Integer,
        Pattern :> GreaterP[0, 1],
        Description -> "The number of pipetting cycles (drawing liquid up into the pipette and dispensing back down out of the pipette) used to resuspend the cell sample in ResuspensionMedia.",
        Category -> "Media Replenishment"
    },
    ReplateCells -> {
        Format -> Single,
        Class -> Boolean,
        Pattern :> BooleanP,
        Description -> "Indicates whether the sample is transferred into new container.",
        Category -> "Media Replenishment"
    }
};

(* NOTE: WashCells is the same as ChangeMedia. *)
With[{insertMe=$SharedChangeMediaFields},
    DefineObjectType[Object[Method, ChangeMedia],{
        Description->"The group of default settings that should be used when changing media for a given cell culture.",
        CreatePrivileges->None,
        Cache->Session,
        Fields->insertMe
    }]
];