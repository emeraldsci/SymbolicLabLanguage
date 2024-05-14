DefineObjectType[Object[StorageAvailability], {
  Description->"The capacity of a position to store additional objects. Object may be stored as 3-D piles, in a collection of objects on a 2-D surface, or individually in a footprinted position.",
  CreatePrivileges->None,
  Cache->Download,
  Fields -> {
    Position -> {
      Format -> Single,
      Class -> String,
      Pattern :> LocationPositionP,
      Description -> "The name of the position whose available storage capacity is represented by this object.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    Container -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container][StorageAvailability, 2],
        Object[Instrument][StorageAvailability, 2]
      ],
      Description -> "The container housing the position whose available storage capacity is represented by this object.",
      Category -> "Organizational Information"
    },
    ContainerModel -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Container],
        Model[Instrument]
      ],
      Description -> "The model of the container housing the position whose available storage capacity is represented by this object.",
      Category -> "Organizational Information"
    },
    StorageFormat -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> StorageFormatP,
      Description -> "The style of storage currently provided by this container position. Undefined refers to an Open Footprint position which does not yet have contents. Footprint indicates that this position can only accept a single item of compatible dimension or Footprint. Open indicates that the contents are packed on a flat surface in their required orientation. Pile indicates that the position can only accept objects that can be piled with it's existing contents.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    Full -> {
      Format -> Single,
      Class -> Boolean,
      Pattern :> BooleanP,
      Description -> "Indicates if the position is entirely filled and cannot be used for further storage until objects are removed.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    ProvidedStorageCondition -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[StorageCondition],
      Description -> "The physical conditions such as temperature, humidity, or chemical compatibility this position provides for samples stored long term within it.",
      Category -> "Storage & Handling"
    },

    (* -- Usage -- *)
    Status ->{
      Format -> Single,
      Class -> Expression,
      Pattern :> StorageAvailabilityStatusP,(*(InUse|Available|Discarded|Restricted|Reserved|Inactive|Invalid|Missing|Unsynced|Overflow)*)
      Description -> "The current usage of this storage position. InUse indicates that the container is InUse by a protocol or located in a non-storage area, and not available for storage. Available indicates that no requests have been made for this specific position. Discarded indicates that the container is Discarded/Retired. Restricted indicates that the container is a LocalCache and can only be used for specific objects. Reserved indicates that the object is being held for a specific protocol that has requested it. Inactive indicates that the container cannot be selected for storage due to its models properties. Invalid indicates that the position associated with the StorageAvailability does not exist in the model. Missing indicates that the object associated with the StorageAvailability is missing. Unsynced indicates that the state of the object has changed in such a way that it cannot be used until its properties are recomputed using UploadStorageAvailability. Overflow indicates that the contents of an Open or Pile position exceed the available space in the position.",
      Category -> "Organizational Information"
    },
    StatusLog->{
      Format->Multiple,
      Class->{Expression, Expression, Link},
      Pattern:>{_?DateObjectQ, StorageAvailabilityStatusP, _Link},
      Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
      Description->"A log of changes made to the status of the storage availability.",
      Headers->{"Date", "Status", "Responsible Party"},
      Category->"Organizational Information",
      Developer->True
    },
    CurrentProtocol -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Protocol][ReservedStorageAvailability],
        Object[Maintenance][ReservedStorageAvailability],
        Object[Qualification][ReservedStorageAvailability],
        Object[Protocol],
        Object[Maintenance],
        Object[Qualification]
      ],
      Description -> "The Protocol, Maintenance, or Qualification currently requesting this position for storage.  If not a bidirectional link, this storage availability object has been reserved manually and thus this field must be cleared manually rather than through normal engine steps.",
      Category -> "Organizational Information"
    },
    Site -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Container,Site],
      Description -> "The ECL site within which the storage availability is located.",
      Category -> "Organizational Information",
      Abstract -> True
    },

    (* -- Footprinted position -- *)
    Footprint -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> (FootprintP|Open),
      Description -> "The form factor provided by this position.",
      Category -> "Dimensions & Positions",
      Abstract -> True
    },
    MaxPositionHeight -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "The maximum height of an item that can fit in this position.",
      Category -> "Dimensions & Positions"
    },
    MaxPositionWidth -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "The maximum width of an item that can fit in this position.",
      Category -> "Dimensions & Positions"
    },
    MaxPositionDepth -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterP[0 Millimeter],
      Units -> Millimeter,
      Description -> "The maximum depth of an item that can fit in this position.",
      Category -> "Dimensions & Positions"
    },
    (* -- Non-pile open position -- *)
    TotalAvailableArea -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Centimeter^2],
      Units -> Centimeter^2,
      Description -> "The total amount of surface area in this position in which additional objects can be stored.",
      Category -> "Dimensions & Positions"
    },
    AvailableSpaceDimensions -> {
      Format -> Single,
      Class -> {Real,Real},
      Pattern :> {GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
      Units -> {Millimeter,Millimeter},
      Description -> "The width and depth of a rectangular empty space in this position within which additional objects can be stored.",
      Category -> "Dimensions & Positions",
      Headers -> {"Width", "Depth"}
    },
    TransverseAvailableSpaceDimensions -> {
      Format -> Single,
      Class -> {Real,Real},
      Pattern :> {GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
      Units -> {Millimeter,Millimeter},
      Description -> "The width and depth of an rectangle empty space in this position within which additional objects can be stored. This space is either perpendicular to area defined by AvailableSpaceDimensions or seperate from it.",
      Category -> "Dimensions & Positions",
      Headers -> {"Width", "Depth"}
    },
    (* -- Pile subfields -- *)
    ModelPiled -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Item],
        Model[Container],
        Model[Part],
        Model[Plumbing],
        Model[Wiring]
      ],
      Description -> "The model of the objects currently stored in an unordered pile within this position.",
      Category -> "Dimensions & Positions"
    },
    TotalVolume -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[0*Centimeter^3],
      Units -> Centimeter^3,
      Description -> "The volume available for the storage of piles when the position is empty.",
      Category -> "Dimensions & Positions"
    },
    NumberOfPiledObjects -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Description -> "The count of piled objects currently in the position.",
      Category -> "Dimensions & Positions"
    },
    AvailablePileCapacity -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterEqualP[0],
      Description -> "The number of objects (of ModelPiled) that can be added to the pile without exceeding the TotalVolume. This is calculated based on the PackingDensity of the objects being stored.",
      Category -> "Dimensions & Positions"
    },
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information",
      Developer -> True
    }
  }
}];