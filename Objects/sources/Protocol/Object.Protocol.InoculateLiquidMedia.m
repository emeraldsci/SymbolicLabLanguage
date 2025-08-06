(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

DefineObjectType[Object[Protocol, InoculateLiquidMedia],{
  Description -> "A protocol for transferring cells (e.g., cell suspension or inoculum) into fresh liquid media to initiate culture growth.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    (* General *)
    InoculationSource -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> InoculationSourceProtocolObjectP, (* LiquidMedia|AgarStab|FreezeDried|FrozenGlycerol *)
      Description -> "The type of the media (Solid, Liquid, AgarStab, FreezeDried, or FrozenGlycerol) where the source cells are stored before the experiment.",
      Category -> "General"
    },
    TransferEnvironments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Instrument, BiosafetyCabinet], Object[Instrument, BiosafetyCabinet]],
      Description -> "For each member of SamplesIn, the environment in which the inoculation is performed for the input sample (e.g., cell suspension or inoculum).",
      IndexMatching -> SamplesIn,
      Category -> "General"
    },
    Instruments -> {
      Format -> Multiple,
      Class -> Link,
      Relation -> Alternatives[Object[Instrument, Pipette], Model[Instrument, Pipette]],
      Pattern :> _Link,
      Description -> "For each member of SamplesIn, the instrument that is used to transfer cells (e.g., cell suspension or inoculum) into fresh liquid media to initiate culture growth.",
      IndexMatching -> SamplesIn,
      Category -> "General"
    },
    MediaPreparationUnitOperation -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A set of instructions specifying the filling of the destination container with fresh media.",
      Category -> "General"
    },
    MediaPreparationProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Protocol, ManualCellPreparation]],
      Description -> "The sub protocol that populates the destination media containers with media prior to the inoculation.",
      Category -> "General"
    },
    InoculationTransferUnitOperation -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> SamplePreparationP,
      Description -> "A set of instructions specifying resuspending the cells, and dispensing the cell suspension to destination container. If InoculationSource is FreezeDried, the instruction involves resuspending the powder-form input sample to resuspesion, and aspirating resuspended cells to destination media containers. If InoculationSource is LiquidMedia, the instruction involves mixing the cells and dispensing the cells to destination media containers.",
      Category -> "General"
    },
    InoculationTransferProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Protocol, ManualCellPreparation]],
      Description -> "The sub protocol to perform the inoculation. If InoculationSource is FreezeDried, the subprotocol adds resuspension media to the input sample, and aspirates resuspended cells to destination media containers. If InoculationSource is LiquidMedia, the subprotocol mixes the cells and dispenses the cells to destination media containers.",
      Category -> "General"
    },
    (* InitialTransfer *)
    InoculationTips -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item, Tips], Object[Item, Tips]],
      Description -> "For each member of SamplesIn, the pipette tips attached to a manual pipette instrument or robotic hamilton workcell during inoculation to aspirate and dispense the cells.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    InoculationTipTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> TipTypeP,
      Description -> "For each member of SamplesIn, the type of pipette tips used to aspirate and dispense the cells during the inoculation.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    InoculationTipMaterials -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> MaterialP,
      Description -> "For each member of SamplesIn, the material of the pipette tips used to aspirate and dispense the cells during the inoculation.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    SourceMixTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Pipette|Swirl,
      Description -> "For each member of SamplesIn, the type of mixing that is performed in the container of the input sample before the inoculation. Pipette performs NumberOfSourceMixes aspiration/dispense cycle(s) of SourceMixVolume using a pipette. Swirl has the operator place the container on the surface of the TransferEnvironment and perform NumberOfSourceMixes clockwise rotations of the container. This option is only applicable if InoculationSource is LiquidMedia.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    NumberOfSourceMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "For each member of SamplesIn, the number of times that the cells are mixed in the input container. When SourceMixType is Pipette, it refers to the number of times of aspirate-dispense cycles. When SourceMixType is Swirl, it refers to the number of clockwise motions applied to the input container.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    SourceMixVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the amount repeatedly aspirated and dispensed via pipette from the input sample in order to mix the source cells before the inoculation. The same pipette and tips used in the inoculation are used to mix the source cells. This option is only applicable if SourceMixType is Pipette.. The same pipette and tips used in the inoculation will be used to mix the source cells.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    TransferVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Milliliter,
      Description -> "For each member of SamplesIn, the amount of suspended source cells to transfer to the destination container. Applicable only when the input sample is in liquid form or resuspended from freeze-dried powder.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    NumberOfSourceScrapes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "For each member of SamplesIn, the number of times that the input sample is scraped with the inoculation tip prior to introducing the tip into the destination media for inoculation. This option is only applicable if InoculationSource is FrozenGlycerol.",
      IndexMatching -> SamplesIn,
      Category -> "Inoculation"
    },
    (* Resuspension *)
    ResuspensionMedia -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SamplesIn, the liquid, nutrient-rich solution added to the input sample in freeze-dried powder in order to resuspend the cells.",
      IndexMatching -> SamplesIn,
      Category -> "Resuspension"
    },
    ResuspensionMediaVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the amount of liquid media added to the source samples in order to resuspend the cells.",
      IndexMatching -> SamplesIn,
      Category -> "Resuspension"
    },
    ResuspensionMixTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Pipette],
      Description -> "For each member of SamplesIn, the type of mixing of the cells in resuspension after adding ResuspensionMedia to the input sample. When set to Pipette, Instrument performs NumberOfResuspensionMixes aspiration/dispense cycle(s) of ResuspensionMixVolume.",
      IndexMatching -> SamplesIn,
      Category -> "Resuspension"
    },
    NumberOfResuspensionMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "For each member of SamplesIn, the number of times the aspiration/dispense cycle(s) is repeated using Instrument after adding ResuspensionMedia to the input sample.",
      IndexMatching -> SamplesIn,
      Category -> "Resuspension"
    },
    ResuspensionMixVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the amount repeatedly aspirated and dispensed via Instrument from the cells in resuspension in order to mix after adding ResuspensionMedia to the source sample in freeze-dried powder. The same pipette and tips used to add the ResuspensionMedia will be used to mix the cell resuspension.",
      IndexMatching -> SamplesIn,
      Category -> "Resuspension"
    },
    (* Deposit *)
    DestinationMedia -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "For each member of SamplesIn, the liquid, nutrient-rich solution added to the destination container to provide the necessary conditions for cell growth following inoculation.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    MediaVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the amount of fresh media pre-loaded into the DestinationMediaContainer prior to the addition of the input sample (e.g., cell suspension or inoculum).",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationMediaContainers -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "For each member of SamplesIn, the container containing liquid media into which the cells are deposited.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationWells -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> WellPositionP | LocationPositionP,
      Description -> "For each member of SamplesIn, the position in the DestinationMediaContainer to move the source cells.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationMixTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> InoculationMixTypeP,
      Description -> "For each member of SamplesIn, the type of mixing that is performed immediately after the input sample (e.g., cell suspension or inoculum) is dispensed into the destination container. Pipette performs DestinationNumberOfMixes aspiration/dispense cycle(s) of DestinationMixVolume using a pipette.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationNumberOfMixes -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "For each member of SamplesIn, the number of times the cells are mixed in the destination container after they are deposited.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    DestinationMixVolumes -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Microliter],
      Units -> Microliter,
      Description -> "For each member of SamplesIn, the volume that is repeatedly aspirated and dispensed via pipetting from the destination sample in order to mix the destination sample immediately after the inoculation occurs.",
      IndexMatching -> SamplesIn,
      Category -> "Deposit"
    },
    SamplesInStorageCondition -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SampleStorageTypeP|Disposal,
      Description -> "For each member of SamplesIn, the non-default condition under which the samples in should be stored after the protocol is completed.",
      Category -> "Sample Storage",
      IndexMatching -> SamplesIn
    },
    SamplesOutStorageCondition -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> SampleStorageTypeP|Disposal,
      Description -> "For each member of SamplesIn, the non-default condition under which the samples out should be stored after the protocol is completed.",
      Category -> "Sample Storage",
      IndexMatching -> SamplesIn
    },
    (* Developer *)
    RequiredObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container]| Model[Container] | Object[Sample] | Model[Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part],
      Description -> "Objects required for the protocol.",
      Category -> "General",
      Developer -> True
    },
    RequiredInstruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument] | Object[Instrument],
      Description -> "Instruments required for the protocol.",
      Category -> "General",
      Developer -> True
    },
    SetUpTransferEnvironments -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the TransferEnvironment needs to be set up at the beginning of that iteration of the protocol loop.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    TearDownTransferEnvironments -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the TransferEnvironment needs to be torn down at the end of that iteration of the protocol loop.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    ReleaseInstruments -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each sample, whether the Pipette needs to be released at the end of this iteration of the protocol loop.",
      Category -> "General",
      Developer -> True
    },
    ReleaseTips -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each sample, whether the Tips needs to be released at the end of this iteration of the protocol loop.",
      Category -> "General",
      Developer -> True
    },
    CoverSamplesIns -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the sample should be covered at the end of this iteration of the protocol loop.",
      Category -> "General",
      Developer -> True
    },
    CoverDestinationContainers -> {
      Format -> Multiple,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, whether the DestinationContainer should be covered after the inoculation.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    PlateSeal -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Item, PlateSeal],
      Description -> "Indicates the plate seal model used to cover any DestinationMediaContainers that have footprint Plate after the inoculation.",
      Category -> "Deposit"
    },
    CapRacks -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container, Rack],
        Object[Container, Rack]
      ],
      Description -> "The cap racks that should be moved into the biosafety cabinet at the beginning of setting up the transfer environment.",
      Category -> "General",
      Developer -> True
    },
    MovementObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Object[Item],
        Object[Sample],
        Object[Instrument]
      ],
      Description -> "The objects to move onto the TransferEnvironment's work surface after it is selected. Note that this excludes everything that is going into a biosafety cabinet; those are handled separately since those need to use the placement task, not the movement task.",
      Category -> "General",
      Developer -> True
    },
    WasteBins -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Container, WasteBin], Object[Container, WasteBin]],
      Description -> "For each member of SamplesIn, the container holding the WasteBag in which solid waste will be disposed while working in the BSC.",
      Category -> "General",
      Developer -> True,
      IndexMatching -> SamplesIn
    },
    WasteBags -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item, Consumable], Object[Item, Consumable]],
      Description -> "For each member of SamplesIn, the waste bag brought into the biosafety cabinet and placed in the WasteBin to collect biohazardous waste generated while working in the BSC.",
      Category -> "General",
      Developer -> True,
      IndexMatching -> SamplesIn
    },
    BiosafetyCabinetPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container],
          Object[Item],
          Object[Sample],
          Object[Instrument],
          Object[Part]
        ],
        Object[Instrument, BiosafetyCabinet],
        Null
      },
      Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which objects should be moved into the transfer environment's biosafety cabinet at the beginning of setting up the transfer environment.",
      Category -> "General",
      Developer -> True
    },
    CollectionObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Object[Item],
        Object[Sample],
        Object[Instrument]
      ],
      Description -> "The objects to remove from the TransferEnvironment's work surface when before it is released.",
      Category -> "General",
      Developer -> True
    },
    BiosafetyWasteBinPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Container, WasteBin],
          Model[Container, WasteBin]
        ],
        Alternatives[
          Object[Instrument, BiosafetyCabinet],
          Model[Instrument, BiosafetyCabinet]
        ],
        Null
      },
      Headers -> {"Waste bin to move", "BSC to move to", "Position to move to"},
      Description -> "The specific positions into which waste bin objects should be moved into the biosafety cabinet.",
      Category -> "General",
      Developer -> True
    },
    BiosafetyWasteBagPlacements -> {
      Format -> Multiple,
      Class -> {Link, Link, String},
      Pattern :> {_Link, _Link, LocationPositionP},
      Relation -> {
        Alternatives[
          Object[Item, Consumable],
          Model[Item, Consumable]
        ],
        Alternatives[
          Object[Container, WasteBin],
          Model[Container, WasteBin]
        ],
        Null
      },
      Headers -> {"Waste Bag to move", "Waste Bin to move to", "Position to move to"},
      Description -> "The specific positions into which waste bag objects should be moved into waste bins.",
      Category -> "General",
      Developer -> True
    },
    BiosafetyWasteBinTeardowns -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container, WasteBin],
        Model[Container, WasteBin]
      ],
      Description -> "For each member of SamplesIn, the specific waste bin that should be removed from the biosafety cabinet.",
      Category -> "General",
      Developer -> True,
      IndexMatching -> SamplesIn
    },
    BiosafetyWasteBagTeardowns -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item, Consumable],
        Model[Item, Consumable]
      ],
      Description -> "For each member of SamplesIn, the specific items that should be removed from the biosafety cabinet.",
      Category -> "General",
      Developer -> True,
      IndexMatching -> SamplesIn
    },
    CryogenicGloves -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Item, Glove], Object[Item, Glove]],
      Description -> "The gloves used to safely pick samples from CryogenicStorage during this protocol.",
      Category -> "Sample Storage",
      Developer -> True
    },
    CryogenicSamples -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
      Description -> "The inoculation sources to be picked from cryogenic storage.",
      Category -> "Sample Storage",
      Developer -> True
    },
    NonCryogenicSamples -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Sample], Model[Sample], Object[Container], Model[Container]],
      Description -> "The inoculation sources to be picked from non-cryogenic storage.",
      Category -> "Sample Storage",
      Developer -> True
    }
  }
}];
