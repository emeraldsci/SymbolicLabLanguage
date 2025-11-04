(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, BarcodeInventory], {
	Description->"A maintenance protocol that attaches barcode with SLL object ID on newly received items.",
	CreatePrivileges->None,
    Cache->Session,
    Fields -> {
        BarcodedItems -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Container],
                Object[Item],
                Object[Part],
                Object[Sensor],
                Object[Plumbing],
                Object[Wiring],
                Object[Instrument]
            ],
            Description -> "The items which SLL object stickers will be printed and affixed in this maintenance.",
            Category -> "General"
        },
        BatchedItems -> {
            Format -> Multiple,
            Class -> Expression,
            Pattern :> {ObjectReferenceP[]..},
            Units -> None,
            Description -> "The items which SLL object stickers will be printed and affixed in this maintenance, divided into batches.",
            Category -> "Batching",
            Developer -> True
        },
        Covers -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Item, Cap],
                Object[Item, Lid],
                Object[Item, PlateSeal]
            ],
            Description -> "The cover of the items which SLL object stickers will be printed and affixed in this maintenance.",
            Category -> "General"
        },
        BatchedCovers -> {
            Format -> Multiple,
            Class -> Expression,
            Pattern :> {(ObjectReferenceP[] | Null)..},
            Units -> None,
            Description -> "The cover of the items which SLL object stickers will be printed and affixed in this maintenance, divided into batches.",
            Category -> "Batching",
            Developer -> True
        },
        VerifiedStickers -> {
            Format -> Multiple,
            Class -> Expression,
            Pattern :> {ObjectReferenceP[]..},
            Units -> None,
            Description -> "For each member of BatchedItems, indicates the stickers that the operator needs to scan explicitly after printing, in order to verify they have picked up the correct roll of stickers.",
            IndexMatching -> BatchedItems,
            Category -> "General",
            Developer -> True
        },
        (* TODO Consider change this to a Boolean field *)
        BatchingTypes -> {
            Format -> Multiple,
            Class -> Expression,
            Pattern :> Alternatives[Kit, BulkContainer],
            Description -> "For each member of BatchedItems, indicates if all items in the batch belong to the same kit which contains multiple different components, or are identical copies of the same product.",
            Category -> "General",
            IndexMatching -> BatchedItems,
            Developer -> True
        },
        BulkContainers -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Container],
            Description -> "For each member of BatchedItems, indicate the inventory bag where objects pending labeling are located (when present).",
            Category -> "General",
            IndexMatching -> BatchedItems
        },
        Products -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Product],
            Description -> "For each member of BatchedItems, indicate the SLL object which contains ordering information.",
            Category -> "General",
            IndexMatching -> BatchedItems
        },
        AwaitingLabelingBin -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Container, Rack],
            Description -> "The bin that holds all items that need to be labeled before the start of this maintenance.",
            Category -> "General"
        },
        DiscardBulkContainer -> {
            Format -> Multiple,
            Class -> Boolean,
            Pattern :> BooleanP,
            Description -> "For each member of BatchedItems, indicates if the BulkContainer should be discarded after all items in this batch have been stickered.",
            Category -> "General",
            IndexMatching -> BatchedItems,
            Developer -> True
        },
        LabeledItemsBin -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Container, Rack], Model[Container, Rack]],
            Description -> "The bin object that holds all items which the labeling has completed.",
            Category -> "General"
        },
        BatchLengths -> {
            Format -> Multiple,
            Class -> Integer,
            Pattern :> GreaterP[0],
            Description -> "For each member of BatchedItems, indicates the number of items to be barcoded in that batch.",
            Category -> "General",
            IndexMatching -> BatchedItems,
            Developer -> True
        },
        LabelingStation -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[Object[Container, Bench], Object[Container, OperatorCart], Model[Container, Bench], Model[Container, OperatorCart]],
            Description -> "The bench where labels will be applied to the items within this maintenance.",
            Category -> "Operations Information",
            Developer -> True
        },
        RackPlacements -> {
            Format -> Multiple,
            Class -> {Link, Expression},
            Pattern :> {_Link, {LocationPositionP..}},
            Relation -> {Alternatives[Object[Container, Rack], Model[Container, Rack]], Null},
            Description -> "The placement of the bins on the labeling bench during this maintenance.",
            Category -> "Operations Information",
            Headers -> {"Bin", "Position"}
        },
        Receiving -> {
            Format -> Single,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Maintenance, ReceiveInventory][BarcodeInventories],
            Description -> "The ReceiveInventory maintenance object which triggered this barcoding maintenance.",
            Category -> "Organizational Information"
        },
        CoverPlacements -> {
            Format -> Multiple,
            Class -> {Link, Link},
            Pattern :> {_Link,_Link},
            Relation -> {Object[Container],Alternatives[Object[Item, Cap],Object[Item, Lid], Object[Item, PlateSeal]]},
            Headers -> {"Container","Cover"},
            Description -> "The covers paired with their respective containers.",
            Category -> "Inventory"
        },
        StickeringParameters -> {
            Format -> Multiple,
            Class -> {
                StickerModel -> Link,
                StickerPositionImage -> Link,
                StickerPositionOnReceiving -> Boolean,
                PositionStickerPlacementImage -> Link,
                Positions -> Integer,
                StickerConnectionOnReceiving -> Boolean,
                ConnectionStickerPlacementImage -> Link,
                Connectors -> Integer,
                StickerSize -> Expression,
                BarcodeTag -> Link
            },
            Pattern :> {
                StickerModel -> _Link,
                StickerPositionImage -> _Link,
                StickerPositionOnReceiving -> BooleanP,
                PositionStickerPlacementImage -> _Link,
                Positions -> GreaterEqualP[0],
                StickerConnectionOnReceiving -> BooleanP,
                ConnectionStickerPlacementImage -> _Link,
                Connectors -> GreaterEqualP[0],
                StickerSize -> StickerSizeP,
                BarcodeTag -> _Link
            },
            Relation -> {
                StickerModel -> Model[Item,Sticker],
                StickerPositionImage -> Object[EmeraldCloudFile],
                StickerPositionOnReceiving -> Null,
                PositionStickerPlacementImage -> Object[EmeraldCloudFile],
                Positions -> Null,
                StickerConnectionOnReceiving -> Null,
                ConnectionStickerPlacementImage -> Object[EmeraldCloudFile],
                Connectors -> Null,
                StickerSize -> Null,
                BarcodeTag -> Model[Item, Consumable]
            },
            Description -> "For each member of BatchedItems, indicate the parameters for affixing SLL object stickers.",
            Category -> "Inventory",
            Developer -> True
        },
        CoverStickeringParameters -> {
            Format -> Multiple,
            Class -> {
                Barcode -> Boolean,
                StickerModel -> Link,
                StickerSize -> Expression,
                BarcodeTag -> Link,
                CoveredContainer -> Boolean
            },
            Pattern :> {
                Barcode -> BooleanP,
                StickerModel -> _Link,
                StickerSize -> StickerSizeP,
                BarcodeTag -> _Link,
                CoveredContainer -> BooleanP
            },
            Relation -> {
                Barcode -> Null,
                StickerModel -> Model[Item,Sticker],
                StickerSize -> Null,
                BarcodeTag -> Model[Item, Consumable],
                CoveredContainer -> Null
            },
            Description -> "For each member of BatchedItems, indicate the parameters for affixing SLL object stickers on the covers, if applicable.",
            Category -> "Inventory",
            Developer -> True
        },
        CurrentItems -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Container],
                Object[Item],
                Object[Part],
                Object[Sensor],
                Object[Plumbing],
                Object[Wiring],
                Object[Instrument]
            ],
            Description -> "The items which SLL object stickers will be printed and affixed in this current iteration. This field will only be populated if operator need to verify every single stickers.",
            Category -> "Batching",
            Developer -> True
        },
        CurrentCovers -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Item, Cap],
                Object[Item, Lid],
                Object[Item, PlateSeal]
            ],
            Description -> "The covers of the items which SLL object stickers will be printed and affixed in this current iteration. This field will only be populated if operator need to verify every single stickers.",
            Category -> "Batching",
            Developer -> True
        },
        CurrentPositionStickers -> {
            Format -> Multiple,
            Class -> String,
            Pattern :> _String,
            Description -> "All position stickers of the current item that operator needs to affix.",
            Category -> "Batching",
            Developer -> True
        },
        CurrentConnectionStickers -> {
            Format -> Multiple,
            Class -> String,
            Pattern :> _String,
            Description -> "All position stickers of the current item that operator needs to affix.",
            Category -> "Batching",
            Developer -> True
        },
        RetryState -> {
            Format -> Single,
            Class -> Boolean,
            Pattern :> BooleanP,
            Description -> "Indicates if the connector or position stickers scanned by operator was incorrect and needs a retry.",
            Category -> "Batching",
            Developer -> True
        },
        VolumeMeasuredSamples -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Container],
            Description -> "The container objects that are liquids and need to be volume measured upon being received.",
            Category -> "Inventory"
        },
        WeightMeasuredSamples -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Container],
            Description -> "The container objects that are solids or liquids with density informed, and need to be weighed upon being received.",
            Category -> "Inventory"
        },
        CountMeasuredSamples -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Object[Container],
            Description -> "The container objects that contain tablets or sachets and need to be counted upon being received.",
            Category -> "Inventory"
        }
    }
}];
