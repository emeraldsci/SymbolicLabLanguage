(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item], {
  Description->"A subsidiary object used to support the daily running of experiment and the laboratory.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    (* --- Organizational Information --- *)
    Name -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "A unique name used to identify this item.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    CurrentProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol][Resources],
        Object[Maintenance][Resources],
        Object[Qualification][Resources]
      ],
      Description -> "The experiment, maintenance, or Qualification that is currently using this item.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    CurrentSubprotocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol],
        Object[Maintenance],
        Object[Qualification]
      ],
      Description -> "The specific protocol or subprotocol that is currently using this item.",
      Category -> "Organizational Information",
      Developer -> True
    },
    Missing -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object was not found at its database listed location and that troubleshooting will be required to locate it.",
      Category -> "Organizational Information",
      Developer -> True
    },
    DateMissing -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "Date the sample was set Missing.",
      Category -> "Organizational Information"
    },
    MissingLog -> {
      Format -> Multiple,
      Class -> {Date, Boolean, Link},
      Pattern :> {_?DateObjectQ, BooleanP, _Link},
      Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
      Description -> "A log of changes made to this sample's Missing status.",
      Headers -> {"Date", "Restricted", "Responsible Party"},
      Category -> "Organizational Information"
    },
    Restricted -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if this item must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this item's model.",
      Category -> "Organizational Information"
    },
    RestrictedLog -> {
      Format -> Multiple,
      Class -> {Date, Boolean, Link},
      Pattern :> {_?DateObjectQ, BooleanP, _Link},
      Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
      Description -> "A log of changes made to this item's restricted status.",
      Headers -> {"Date", "Restricted", "Responsible Party"},
      Category -> "Organizational Information"
    },
    Destination -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Site],
      Description -> "If this item is in transit, the site where the item is being shipped to.",
      Category -> "Organizational Information"
    },
    Site -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Site],
      Description -> "The ECL site at which this item currently resides.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    SiteLog->{
      Format->Multiple,
      Headers->{"Date", "Site", "Responsible Party"},
      Class->{Date, Link, Link},
      Pattern:>{_?DateObjectQ, _Link, _Link},
      Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
      Description->"The site history of the item.",
      Category->"Container Information"
    },
    Status -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> SampleStatusP,
      Description -> "Current status of the item. Options include Stocked (not yet in circulation), Available (in active use), and Discarded (discarded).",
      Category -> "Organizational Information",
      Abstract -> True
    },
    StatusLog -> {
      Format -> Multiple,
      Class -> {Expression, Expression, Link},
      Pattern :> {_?DateObjectQ, SampleStatusP, _Link},
      Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
      Description -> "A log of changes made to the item's status.",
      Headers -> {"Date","Status","Responsible Party"},
      Category -> "Organizational Information",
      Developer -> True
    },
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    },

    (*--- Container Information ---*)
    Container -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container][Contents, 2],
        Object[Instrument][Contents, 2]
      ],
      Description -> "The container in which this item is physically located.",
      Category -> "Container Information"
    },
    LocationLog -> {
      Format -> Multiple,
      Class -> {Date, Expression, Link, String, Link},
      Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
      (* NOTE: The non-two-way-link version should only be used for covers and their containers. Covers don't actually go *)
      (* into a real position on the container and therefore shouldn't be shown in the contents log. *)
      Relation -> {Null, Null, Object[Container] | Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
      Description -> "The location history of the item. Lines recording a movement to container and position of {Null, Null} respectively indicate the item being discarded.",
      Category -> "Container Information",
      Headers ->{"Date","Change Type","Container","Position","Responsible Party"}
    },
    Position -> {
      Format -> Single,
      Class -> String,
      Pattern :> LocationPositionP,
      Description -> "The name of the position in this item's container where this item is physically located.",
      Category -> "Container Information"
    },
    Well -> {
      Format -> Single,
      Class -> String,
      Pattern :> WellP,
      Description -> "The microplate well in which this item is physically located.",
      Category -> "Container Information"
    },
    StackedAbove -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container][StackedBelow],
        Object[Item][StackedBelow],
        Object[Part][StackedBelow]
      ],
      Description -> "The container, item, or part placed directly on top of this object. Items in a stack are moved together as a single unit.",
      Category -> "Container Information"
    },
    StackedBelow -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container][StackedAbove],
        Object[Item][StackedAbove],
        Object[Part][StackedAbove]
      ],
      Description -> "The Container, Item or Part upon which this item is stacked. Items in a stack are moved as a single item.",
      Category -> "Container Information"
    },
    StoredOnCart -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if this item is permanently stored on operator carts.",
      Category -> "Container Information"
    },
    ResourcePickingGrouping -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Object[Instrument]
      ],
      Description -> "The parent container of this object which can be used to give the object's approximate location and to see show its proximity to other objects which may be resource picked at the same time or in use by the same protocol.",
      Category -> "Container Information"
    },

    (* --- Operating Limits --- *)
    NumberOfHours -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Hour],
      Units -> Hour,
      Description -> "The amount of time this part has been used during experiments.",
      Category -> "Operating Limits",
      Abstract -> True
    },
    NumberOfUses -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0, 1],
      Units -> None,
      Description -> "The number of individual uses that this part has been utilized for during experiments.",
      Category -> "Operating Limits"
    },

    (* --- Dimensions & Positions --- *)
    MaterialDimensions -> {
      Format -> Single,
      Class -> {Real, Real},
      Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
      Units ->{Meter,Meter},
      Description -> "The actual dimensions of this material.",
      Category -> "Dimensions & Positions",
      Headers -> {"X Direction (Width)","Y Direction (Length)"}
    },
    MaterialDimensionsLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Real, Link},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0*Meter], GreaterEqualP[0*Meter], _Link},
      Relation -> {Null, Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
      Units -> {None, Meter, Meter, None},
      Description -> "A historical record of the dimensions of the material.",
      Category -> "Physical Properties",
      Headers -> {"Date","X Direction (Width)","Y Direction (Length)","Responsible Party"}
    },
    CuttableWidth -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CuttableWidth]],
      Pattern :> BooleanP,
      Description -> "Indicates if this items length can but cut lengthwise, decreasing the width of the item.",
      Category -> "Dimensions & Positions"
    },
    CuttableLength -> {
      Format -> Computable,
      Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CuttableLength]],
      Pattern :> BooleanP,
      Description -> "Indicates if this items length can but cut crosswise, decreasing the length of the item.",
      Category -> "Dimensions & Positions"
    },

    (* --- Quality Assurance --- *)
    Certificates -> {
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
		  Object[Report, Certificate][ItemCertified],
		  Object[Report, Certificate][ItemsCertified]
	  ],
      Description->"The quality assurance documentation and data for this item.",
      Category->"Quality Assurance"
    },

    (* --- Physical Properties --- *)
    AppearanceLog -> {
      Format -> Multiple,
      Class -> {Date, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Object[Data], Object[Protocol]},
      Units -> {None, None, None},
      Description -> "A historical record of when the item was imaged.",
      Category -> "Physical Properties",
      Headers -> {"Date","Data","Protocol"}
    },
    Count -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0,1],
      Units -> None,
      Description -> "The current number of individual items that are part of this item.",
      Category -> "Physical Properties"
    },
    CountLog -> {
      Format -> Multiple,
      Class -> {Date, Integer, Link},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0,1], _Link},
      Relation -> {Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification] | Object[Product] | Object[User]},
      Units -> {None, None, None},
      Description -> "A historical record of the count of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","Count","Responsible Party"}
    },
    Mass -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Gram],
      Units -> Gram,
      Description -> "The most recently measured mass of the item.",
      Category -> "Physical Properties"
    },
    MassLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Link, Expression},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0*Gram], _Link, WeightMeasurementStatusP},
      Relation -> {Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User], Null},
      Units -> {None, Gram, None, None},
      Description -> "A historical record of the measured weight of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","Weight","Responsible Party","Measurement Type"}
    },
    Volume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Liter],
      Units -> Liter,
      Description -> "The most recently measured volume of the item.",
      Category -> "Physical Properties"
    },
    VolumeLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Link, Expression},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0*Liter], _Link, VolumeMeasurementStatusP},
      Relation -> {Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User], Null},
      Units -> {None, Liter, None, None},
      Description -> "A historical record of the measured volume of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","Volume","Responsible Party","Measurement Type"}
    },
    Density -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[(0*Gram)/Liter],
      Units -> Gram/(Liter Milli),
      Description ->  "The most recently measured density of the item.",
      Category -> "Physical Properties"
    },
    DensityLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Link},
      Pattern :> {_?DateObjectQ, GreaterP[(0*Gram)/Liter], _Link},
      Relation -> {Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
      Units -> {None, Gram/(Liter Milli), None},
      Description -> "A historical record of the measured density of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","Density","Responsible Party"}
    },
    DensityDistribution -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> DistributionP[Gram/(Liter Milli)],
      Description -> "The statistical distribution of the density.",
      Category -> "Physical Properties"
    },
    pH -> {
      Format -> Single,
      Class -> Real,
      Pattern :> NumericP,
      Units -> None,
      Description -> "The most recently measured pH of the item.",
      Category -> "Physical Properties"
    },
    pHLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Link},
      Pattern :> {_?DateObjectQ, NumericP, _Link},
      Relation -> {Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification] | Object[User]},
      Units -> {None, None, None},
      Description -> "A historical record of the measured pH of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","pH","Responsible Party"}
    },
    (*fields below are phasing out*)
    Concentration -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Micromolar],
      Units -> Micromolar,
      Description -> "The most recently calculated concentration of the item.",
      Category -> "Physical Properties",
      Developer -> True
    },
    ConcentrationLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Link},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0*Micromolar], _Link},
      Relation -> {Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification]|Object[User]},
      Units -> {None, Micromolar, None},
      Description -> "A historical record of the concentration of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","Molar Concentration","Responsible Party"},
      Developer -> True
    },
    MassConcentration -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Gram)/Liter],
      Units -> Gram/Liter,
      Description -> "The most recently calculated mass of the constituent(s) divided by the volume of the mixture.",
      Category -> "Physical Properties",
      Developer -> True
    },
    MassConcentrationLog -> {
      Format -> Multiple,
      Class -> {Date, Real, Link},
      Pattern :> {_?DateObjectQ, GreaterEqualP[(0*Gram)/Liter], _Link},
      Relation -> {Null, Null, Object[Protocol] | Object[Analysis] | Object[Product] | Object[Maintenance] | Object[Qualification]|Object[User]},
      Units -> {None, Gram/Liter, None},
      Description -> "A historical record of the measured mass concentration of the item.",
      Category -> "Physical Properties",
      Headers -> {"Date","Mass Concentration","Responsible Party"},
      Developer -> True
    },

    (* --- Item History ---*)
    Protocols -> { (* Note: Protocols like Autoclave can take in items. *)
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol][SamplesIn],
        Object[Protocol][SamplesOut]
      ],
      Description -> "All protocols that used this item at any point during their execution in the lab.",
      Category -> "Item History"
    },
    Source -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Transaction],
        Object[Protocol],
        Object[Protocol][PurchasedItems],
        Object[Qualification],
        Object[Qualification][PurchasedItems],
        Object[Maintenance],
        Object[Maintenance][PurchasedItems]
      ],
      Description -> "The transaction or protocol that is responsible for generating this item.",
      Category -> "Item History"
    },
    TransfersIn -> { (* Note: The only things that can transfer into items are gels. *)
      Format -> Multiple,
      Class -> {Date, VariableUnit, Link, Link, Expression},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit], _Link, _Link, TransferCompletenessP},
      Relation -> {Null, Null, Object[Sample][TransfersOut,3], Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification], Null},
      Units -> {None, None, None, None, None},
      Description -> "Materials transfered into this item from other samples.",
      Category -> "Item History",
      Headers -> {"Date","Target Amount","Origin Sample","Responsible Party","Transfer Type"}
    },
    TransfersOut -> {
      Format -> Multiple,
      Class -> {Date, VariableUnit, Link, Link, Expression},
      Pattern :> {_?DateObjectQ, GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit], _Link, _Link, TransferCompletenessP},
      Relation -> {Null, Null, Object[Sample][TransfersIn,3], Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification], Null},
      Units -> {None, None, None, None, None},
      Description -> "Materials transfered out of this item and into other samples.",
      Category -> "Item History",
      Headers -> {"Date","Target Amount","Origin Sample","Responsible Party","Transfer Type"}
    },
    AutoclaveLog -> {
      Format -> Multiple,
      Class -> {Date, Link},
      Pattern :> {_?DateObjectQ, _Link},
      Relation -> {Null, Object[Protocol]},
      Units -> {None, None},
      Description -> "A historical record of when the item was last autoclaved.",
      Category -> "Item History",
      Headers ->{"Date","Protocol"}
    },
    DishwashLog -> {
      Format -> Multiple,
      Class -> {Date, Link},
      Pattern :> {_?DateObjectQ, _Link},
      Relation -> {Null, Object[Maintenance, Dishwash][CleanLabware]|Object[Maintenance, Handwash][CleanLabware]|Object[Maintenance, Dishwash][CleanCovers]},
      Units -> {None, None},
      Description -> "A historical record of when the container was last washed.",
      Category -> "Item History",
      Headers -> {"Date","Dishwash Protocol"}
    },

    (* --- Experimental Results ---*)
    Data -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Data, Chromatography][Columns],
        Object[Data, LCMS][Columns],
        Object[Data, Weight][WeighBoat],
        Object[Data, Chromatography][GuardColumn],
        Object[Data, Chromatography][GuardCartridge],
        Object[Data, ChromatographyMassSpectra][Columns],
        Object[Data, ChromatographyMassSpectra][Column],
        Object[Data, ChromatographyMassSpectra][SecondaryColumn],
        Object[Data, ChromatographyMassSpectra][TertiaryColumn],
        Object[Data, ChromatographyMassSpectra][GuardColumn],
        Object[Data, ChromatographyMassSpectra][GuardCartridge],
        Object[Data][SamplesIn]
      ],
      Description -> "Experimental data involved in the creation or consumption of the item.",
      Category -> "Experimental Results"
    },

    (* --- Storage & Handling --- *)
    StorageCondition -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[StorageCondition],
      Description -> "The conditions under which this item should be kept when not in use by an experiment.",
      Category -> "Storage & Handling"
    },
    StorageConditionLog -> {
      Format -> Multiple,
      Class -> {Date, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
      Description -> "A record of changes made to the conditions under which this item should be kept when not in use by an experiment.",
      Headers -> {"Date","Condition","Responsible Party"},
      Category -> "Storage & Handling"
    },
    StoragePositions->{
      Format -> Multiple,
      Class -> {Link, String},
      Pattern :> {_Link, LocationPositionP},
      Relation -> {Object[Container]|Object[Instrument], Null},
      Description -> "The specific containers and positions in which this item is to be stored, allowing more granular organization within storage locations for this item's storage condition.",
      Category -> "Storage & Handling",
      Headers->{"Storage Container", "Storage Position"},
      Developer -> True
    },
    StorageSchedule -> {
      Format -> Multiple,
      Class -> {Date, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
      Description -> "The planned storage condition changes to be performed.",
      Headers -> {"Date", "Condition", "Responsible Party"},
      Category -> "Storage & Handling"
    },
    AwaitingStorageUpdate -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this item has been scheduled for movement to a new storage condition.",
      Category -> "Storage & Handling",
      Developer -> True
    },
    AwaitingDisposal -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if this item is marked for disposal once it is no longer required for any outstanding experiments.",
      Category -> "Storage & Handling"
    },
    DisposalLog -> {
      Format -> Multiple,
      Class -> {Expression, Boolean, Link},
      Pattern :> {_?DateObjectQ, BooleanP, _Link},
      Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
      Description -> "A log of changes made to when this item is marked as awaiting disposal by the AwaitingDisposal Boolean.",
      Headers -> {"Date","Awaiting Disposal","Responsible Party"},
      Category -> "Storage & Handling"
    },
    BiohazardDisposal -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates whether the item should be disposed of as biohazardous waste if disposed of, though it is not necessarily designated for disposal at this time.",
      Category -> "Storage & Handling"
    },
    Expires -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this item expires after a given amount of time.",
      Category -> "Storage & Handling",
      Abstract -> True
    },
    ShelfLife -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Day],
      Units -> Day,
      Description -> "The length of time after DateCreated this item is recommended for use before it should be discarded.",
      Category -> "Storage & Handling",
      Abstract -> True
    },
    UnsealedShelfLife -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Day],
      Units -> Day,
      Description -> "The length of time after DateUnsealed this item is recommended for use before it should be discarded.",
      Category -> "Storage & Handling",
      Abstract -> True
    },
    TransportTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "The temperature at which the item should be incubated while transported between instruments during experimentation.",
      Category -> "Storage & Handling"
    },
    AsepticTransportContainerType -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> AsepticTransportContainerTypeP,
      Description -> "Indicates how this item is contained in an aseptic barrier and if it needs to be decanted before being used in a protocol, maintenance, or qualification.",
      Category -> "Storage & Handling"
    },
    ThawTemperature -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Kelvin],
      Units -> Celsius,
      Description -> "The temperature that items of this model should be thawed at before using in experimentation.",
      Category -> "Storage & Handling"
    },
    ThawTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Second],
      Units -> Minute,
      Description -> "The time that items of this model should be thawed before using in experimentation. If the items are still not thawed after this time, thawing will continue until the items are fully thawed.",
      Category -> "Storage & Handling"
    },
    MaxThawTime -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0*Second],
      Units -> Minute,
      Description -> "The maximum time that items of this model should be thawed before using in experimentation.",
      Category -> "Storage & Handling"
    },

    (* --- Plumbing Information --- *)
    Connectors -> {
      Format -> Multiple,
      Class -> {String, Expression, Expression, Real, Real, Expression},
      Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
      Units -> {None, None, None, Inch, Inch, None},
      Description -> "Specifications for the interfaces on this item that may connect to other plumbing components or instrument ports.",
      Category -> "Plumbing Information",
      Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"}
    },
    Connections -> {
      Format -> Multiple,
      Class -> {String, Link, String},
      Pattern :> {ConnectorNameP, _Link, ConnectorNameP},
      Relation -> {
        Null,
        Alternatives[
          Object[Plumbing][Connections, 2],
          Object[Instrument][Connections, 2],
          Object[Item][Connections,2],
          Object[Part][Connections,2],
          Object[Container][Connections, 2]
        ],
        Null
      },
      Description -> "A list of the plumbing components to which this item is connected to allow flow of liquids/gases.",
      Category -> "Plumbing Information",
      Headers -> {"Connector Name","Connected Object","Object Connector Name"}
    },
    ConnectionLog -> {
      Format -> Multiple,
      Class -> {Date, Expression, String, Link, String, Link},
      Pattern :> {_?DateObjectQ, Connect | Disconnect, ConnectorNameP, _Link, ConnectorNameP, _Link},
      Relation -> {
        Null,
        Null,
        Null,
        Object[Plumbing][ConnectionLog, 4] | Object[Part][ConnectionLog, 4] | Object[Instrument][ConnectionLog, 4] | Object[Container][ConnectionLog, 4] | Object[Item][ConnectionLog, 4],
        Null,
        Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]
      },
      Description -> "The plumbing connection history of this item.",
      Category -> "Plumbing Information",
      Headers -> {"Date","Change Type","Connector Name","Connected Object", "Object Connector Name","Responsible Party"}
    },
    ConnectorGrips -> {
      Format -> Multiple,
      Class -> {String, Expression, Real, Real, Real},
      Pattern :> {ConnectorNameP, ConnectorGripTypeP, GreaterP[0 Inch], GreaterEqualP[0 Newton*Meter], GreaterP[0 Newton*Meter]},
      Units -> {None, None, Inch, Newton*Meter, Newton*Meter},
      Description -> "For each member of Connectors, specifications for a region on this item that may be used in concert with tools or fingers to assist in establishing a Connection to the Connector. Connector Name denotes the Connector to which a grip corresponds. Grip Type indicates the form the grip takes. Options include Flats or Knurled. Flats are parallel faces on the body of an object designed interface with the mouth of a wrench. Knurled denotes that a pattern is etched into the body of an object to increase roughness. Grip Size is the distance across flats or the diameter of the grip. Min torque is the lower bound energetic work required to make a leak-proof seal via rotational force. Max torque is the upper bound after which the fitting may be irreparably distorted or damaged.",
      Category -> "Plumbing Information",
      Headers -> {"Connector Name", "Grip Type", "Grip Size", "Min Torque", "Max Torque"},
      IndexMatching -> Connectors
    },
    Ferrules -> {
      Format -> Multiple,
      Class -> {String, Link, Real},
      Pattern :> {ConnectorNameP, _Link, GreaterP[0*Milli*Meter]},
      Relation -> {Null, Object[Part,Ferrule][InstalledLocation], Null},
      Units -> {None, None, Milli Meter},
      Description -> "A list of the compressible sealing rings that have been attached to the connecting ports on this item.",
      Category -> "Plumbing Information",
      Headers -> {"Connector Name", "Installed Ferrule","Ferrule Offset"}
    },
    Nuts -> {
      Format -> Multiple,
      Class -> {String, Link, Expression},
      Pattern :> {ConnectorNameP, _Link, ConnectorGenderP|None},
      Relation -> {Null, Object[Part,Nut][InstalledLocation], Null},
      Description -> "A list of the ferrule-compressing connector components that have been attached to the connecting ports on this item.",
      Category -> "Plumbing Information",
      Headers -> {"Connector Name", "Installed Nut", "Connector Gender"}
    },
    PlumbingFittingsLog -> {
      Format -> Multiple,
      Class -> {Date, String, Expression, Link, Link, Real, Link},
      Pattern :> {_?DateObjectQ, ConnectorNameP, ConnectorGenderP|None, _Link, _Link, GreaterP[0*Milli*Meter], _Link},
      Relation -> {Null, Null, Null, Object[Part,Nut], Object[Part,Ferrule], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
      Units -> {None, None, None, None, None, Milli*Meter, None},
      Description -> "The history of the connection type present at each connector on this item.",
      Headers -> {"Date", "Connector Name", "Connector Gender", "Installed Nut", "Installed Ferrule", "Ferrule Offset", "Responsible Party"},
      Category -> "Plumbing Information"
    },
    PlumbingSizeLog -> {
      Format -> Multiple,
      Class -> {Date, String, Real, Real, Link},
      Pattern :> {_?DateObjectQ, ConnectorNameP, GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], _Link},
      Relation -> {Null, Null, Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
      Units -> {None, None, Milli*Meter, Milli*Meter, None},
      Description -> "The history of the length of each connector on this item.",
      Headers -> {"Date", "Connector Name", "Connector Trimmed Length", "Final Plumbing Length", "Responsible Party"},
      Category -> "Plumbing Information"
    },
    Size -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Meter],
      Units -> Meter,
      Description -> "The length of this item, in the direction of fluid flow.",
      Category -> "Plumbing Information"
    },

    (* --- Wiring Information --- *)
    WiringConnections -> {
      Format -> Multiple,
      Class -> {String, Link, String},
      Pattern :> {WiringConnectorNameP, _Link, WiringConnectorNameP},
      Relation -> {
        Null,
        Alternatives[
          Object[Wiring][WiringConnections, 2],
          Object[Instrument][WiringConnections, 2],
          Object[Item][WiringConnections, 2],
          Object[Part][WiringConnections, 2],
          Object[Container][WiringConnections, 2]
        ],
        Null
      },
      Headers -> {"Wiring Connector Name", "Connected Object", "Object Wiring Connector Name"},
      Description -> "A list of the wiring components to which this item is directly connected to allow the flow of electricity.",
      Category -> "Wiring Information"
    },
    WiringConnectionLog -> {
      Format -> Multiple,
      Class -> {Date, Expression, String, Link, String, Link},
      Pattern :> {_?DateObjectQ, Connect|Disconnect, WiringConnectorNameP, _Link, WiringConnectorNameP, _Link},
      Relation -> {
        Null,
        Null,
        Null,
        Alternatives[
          Object[Wiring][WiringConnectionLog, 4],
          Object[Instrument][WiringConnectionLog, 4],
          Object[Item][WiringConnectionLog, 4],
          Object[Part][WiringConnectionLog, 4],
          Object[Container][WiringConnectionLog, 4]
        ],
        Null,
        Alternatives[Object[User], Object[Protocol], Object[Qualification], Object[Maintenance]]
      },
      Headers -> {"Date", "Change Type", "Wiring Connector Name", "Connected Object", "Object Wiring Connector Name", "Responsible Party"},
      Description -> "The wiring connection history of this item.",
      Category -> "Wiring Information"
    },
    WiringConnectors -> {
      Format -> Multiple,
      Class -> {String, Expression, Expression},
      Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
      Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
      Description -> "Specifications for the wiring interfaces of this item that may plug into and conductively connect to other wiring components or instrument wiring connectors.",
      Category -> "Wiring Information"
    },
    WiringDiameters -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "For each member of WiringConnectors, its effective conductive diameter.",
      Category -> "Wiring Information",
      IndexMatching -> WiringConnectors
    },
    WiringLength -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Centimeter],
      Units -> Centimeter,
      Description -> "The length of this item, in the direction of electricity flow.",
      Category -> "Wiring Information"
    },
    WiringLengthLog -> {
      Format -> Multiple,
      Class -> {Date, String, Real, Real, Link},
      Pattern :> {_?DateObjectQ, WiringConnectorNameP, GreaterP[0 Millimeter], GreaterP[0 Millimeter], _Link},
      Relation -> {Null, Null, Null, Null, Object[User]|Object[Protocol]|Object[Qualification]|Object[Maintenance]},
      Units -> {None, None, Millimeter, Millimeter, None},
      Headers -> {"Date", "Wiring Connector Name", "Wiring Connector Trimmed Length", "Final Wiring Length", "Responsible Party"},
      Description -> "The history of the length of each connector on this item.",
      Category -> "Wiring Information"
    },

    (* --- Inventory --- *)
    Product -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Product][Samples],
      Description -> "Contains ordering and product information as well as shipping and receiving instructions for the item.",
      Category -> "Inventory"
    },
    SerialNumber -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "Identification number for this part.",
      Category -> "Inventory"
    },
    Order -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Transaction, Order],
        Object[Transaction, DropShipping]
      ],
      Description -> "The transaction that generated this item.",
      Category -> "Inventory"
    },
    KitComponents -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Sample][KitComponents],
        Object[Item][KitComponents],
        Object[Container][KitComponents],
        Object[Part][KitComponents],
        Object[Plumbing][KitComponents],
        Object[Wiring][KitComponents],
        Object[Sensor][KitComponents]
      ],
      Description -> "All other items that were received as part of the same kit as this item.",
      Category -> "Inventory"
    },
    Receiving -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Maintenance, ReceiveInventory][Items],
      Description -> "The MaintenanceReceiveInventory in which this item was received.",
      Category -> "Inventory"
    },
    QCDocumentationFiles -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "PDFs of any QC documentation that arrived with the item.",
      Category -> "Inventory"
    },
    LabelImage -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "Image of the label of this item.",
      Category -> "Inventory"
    },
    BatchNumber -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "A identifier for the particular batch that this item was created in.",
      Category -> "Inventory"
    },
    DateStocked -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "Date the item was created or entered into Emerald's inventory system.",
      Category -> "Inventory"
    },
    DateUnsealed -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "Date the packaging on the item was first opened in the lab.",
      Category -> "Inventory"
    },
    DatePurchased -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description ->  "Date ownership of this item was transferred to the user.",
      Category -> "Inventory"
    },
    DateDiscarded -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "Date the item was discarded into waste.",
      Category -> "Inventory"
    },
    DateLastUsed -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "Date this item was last handled in any way.",
      Category -> "Inventory"
    },
    ExpirationDate -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "Date after which this item is considered expired and users will be warned about using it in protocols.",
      Category -> "Inventory"
    },

    (* --- Health & Safety --- *)
    Sterile -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this item is presently considered free of both microbial contamination and any microbial cell samples. To preserve this sterile state, the item is handled with aseptic techniques during experimentation and storage.",
      Category -> "Health & Safety"
    },
    NucleaseFree -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this item is presently considered to be not contaminated with DNase and RNase.",
      Category -> "Health & Safety"
    },
    NucleicAcidFree -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description->"Indicates if this item is presently considered to be not contaminated with DNA and RNA.",
      Category -> "Health & Safety"
    },
    PyrogenFree -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if item is presently considered to be not contaminated with endotoxin.",
      Category -> "Health & Safety"
    },

    (* --- Qualifications & Maintenance --- *)
    RecentQualifications -> {
      Format -> Multiple,
      Class -> {Expression, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Object[Qualification], Model[Qualification]},
      Description -> "List of the most recent Qualifications run on this part for each model Qualification in QualificationFrequency.",
      Category -> "Qualifications & Maintenance",
      Abstract -> True,
      Headers ->  {"Date Completed", "Qualification Object","Qualification Model Object"}
    },
    QualificationLog -> {
      Format -> Multiple,
      Class -> {Expression, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Object[Qualification], Model[Qualification]},
      Description -> "List of all the Qualifications that target this part and are not an unlisted protocol.",
      Category -> "Qualifications & Maintenance",
      Headers ->   {"Date Run", "Qualification Object", "Qualification Object Model"},
      Developer -> True
    },
    Qualified -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates if this item has passed its most recent qualification.",
      Category -> "Qualifications & Maintenance",
      Developer -> True
    },
    QualificationResultsLog -> {
      Format -> Multiple,
      Class -> {
        Date -> Date,
        Qualification -> Link,
        Result -> Expression
      },
      Pattern :> {
        Date -> _?DateObjectQ,
        Qualification -> _Link,
        Result -> QualificationResultP
      },
      Relation -> {
        Date -> Null,
        Qualification -> Object[Qualification],
        Result -> Null
      },
      Headers -> {
        Date -> "Date Evaluated",
        Qualification -> "Qualification",
        Result -> "Result"
      },
      Description -> "A record of the qualifications run on this item and their results.",
      Category -> "Qualifications & Maintenance"
    },
    QualificationExtensionLog -> {
      Format -> Multiple,
      Class -> {Link, Expression, Expression, Link, Expression, String},
      Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
      Relation -> {Model[Qualification], Null, Null, Object[User], Null, Null},
      Description -> "A list of amendments made to the regular qualification schedule of this item, and the reason for the deviation.",
      Category -> "Qualifications & Maintenance",
      Headers -> {"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
    },
    Maintenance -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Maintenance][Target],
        Object[Maintenance, StorageUpdate][ScheduledMoves],
        Object[Maintenance, StorageUpdate][MovedItems],
        Object[Maintenance, Replace][ReplacementParts]
      ],
      Description -> "Maintenance(s) the parts underwent.",
      Category -> "Qualifications & Maintenance"
    },
    RecentMaintenance -> {
      Format -> Multiple,
      Class -> {Expression, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Object[Maintenance], Model[Maintenance]},
      Description -> "List of the most recent maintenances run on this part for each modelMaintenance in MaintenanceFrequency.",
      Category -> "Qualifications & Maintenance",
      Abstract -> True,
      Headers -> {"Date","Maintenance","Maintenance Model"}
    },
    MaintenanceLog -> {
      Format -> Multiple,
      Class -> {Expression, Link, Link},
      Pattern :> {_?DateObjectQ, _Link, _Link},
      Relation -> {Null, Object[Maintenance], Model[Maintenance]},
      Description -> "List of all the maintenances that target this part and are not an unlisted protocol.",
      Category -> "Qualifications & Maintenance",
      Headers ->  {"Date Run", "Maintenance Object", "Maintenance Object Model"}
    },
    MaintenanceExtensionLog -> {
      Format -> Multiple,
      Class -> {Link, Expression, Expression, Link, Expression, String},
      Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, MaintenanceExtensionCategoryP, _String},
      Relation -> {Model[Maintenance], Null, Null, Object[User], Null, Null},
      Description -> "A list of amendments made to the regular maintenance schedule of this item, and the reason for the deviation.",
      Category -> "Qualifications & Maintenance",
      Headers -> {"Maintenance Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
    },


    (* --- Resources --- *)
    RequestedResources -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Resource, Sample][RequestedSample],
      Description -> "The list of resource requests for this item that have not yet been Fulfilled.",
      Category -> "Resources",
      Developer -> True
    },

    (* --- Migration Support --- *)
    NewStickerPrinted -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if a new sticker with a hashphrase has been printed for this object and therefore the hashphrase should be shown in engine when scanning the object.",
      Category -> "Migration Support",
      Developer -> True
    },
    LegacyID -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
      Category -> "Migration Support",
      Developer -> True
    }
  }
}];
