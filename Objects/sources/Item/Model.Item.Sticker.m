(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Sticker], {
	Description->"Model information for a type of sheet-fed sticker used for labeling samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BarcodeType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BarcodeTypeP,
			Description -> "Type of barcode on the stickers.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		AspectRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Ratio of the number of columns vs the number of rows of stickers on a sheet.",
			Category -> "Dimensions & Positions"
		},
		Rows -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of rows of stickers in the sheet.",
			Category -> "Dimensions & Positions"
		},
		Columns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of columns of stickers in the sheet.",
			Category -> "Dimensions & Positions"
		},
		HorizontalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "Distance from the left edge of the sheet to the edge of the first sticker.",
			Category -> "Dimensions & Positions"
		},
		VerticalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "Distance from the top edge of the sheet to the edge of the first sticker.",
			Category -> "Dimensions & Positions"
		},
		HorizontalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one sticker to the next in a given row.",
			Category -> "Dimensions & Positions"
		},
		VerticalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one sticker to the next in a given column.",
			Category -> "Dimensions & Positions"
		},
		Width -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Horizontal size of each individual sticker.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		Height -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Vertical size of each individual sticker.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		BarcodeHorizontalPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The relative horizontal position of the center of the barcode within the coordinate system of a single sticker.",
			Category -> "Dimensions & Positions"
		},
		BarcodeVerticalPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The relative vertical position of the center of the barcode within the coordinate system of a single sticker.",
			Category -> "Dimensions & Positions"
		},
		BarcodeMaxWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum horizontal size of the barcode on the sticker. The barcode will be scaled to fit within the allotted space based on whichever dimension is limiting.",
			Category -> "Dimensions & Positions"
		},
		BarcodeMaxHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum vertical size of the barcode on the sticker. The barcode will be scaled to fit within the allotted space based on whichever dimension is limiting.",
			Category -> "Dimensions & Positions"
		},
		BarcodeSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The horizontal size of the barcode on the sticker; the vertical size of the barcode will be scaled proportionally.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		StickersPerSheet -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Number of stickers on a sheet.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		TextHorizontalPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The relative horizontal position of the middle of the text block within the coordinate system of a single barcode sticker.",
			Category -> "Dimensions & Positions"
		},
		TextVerticalPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The relative vertical position of the top edge of the text block within the coordinate system of a single barcode sticker.",
			Category -> "Dimensions & Positions"
		},
		TextVerticalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The distance between lines of text in the text block.",
			Category -> "Dimensions & Positions"
		},
		TextBoxWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The width of the text boxes on the sticker; this is the maximum allowable space that text can occupy without encroaching on other sticker elements.",
			Category -> "Dimensions & Positions"
		},
		TextSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "The maximum size of the text on the sticker (the size of a single character, scaled as a fraction of the size of the sticker itself).",
			Category -> "Dimensions & Positions"
		},
		BorderWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The width of the printable border around a piggyback sticker's main sticker area.",
			Category -> "Dimensions & Positions"
		},
		CharacterLimit -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The maximum number of characters that fit on a single line of text at the maximum size 'TextSize' in this sticker configuration.",
			Category -> "Dimensions & Positions"
		},
		StickerSize->{
			Format -> Single,
			Class -> Expression,
			Pattern :> StickerSizeP,
			Description -> "The size of label on which the object information is printed.",
			Category -> "Dimensions & Positions"
		},
		StickerType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> StickerTypeP,
			Description -> "Indicates if the sticker's barcode encodes an Object's ID or a Position within an object in the form {Position Name, Container Object}.",
			Category -> "Dimensions & Positions"
		},

	(* --- DEPRECATED -- DELETE AFTER NEW PRINTSTICKERS IS MERGED TO MASTER --- *)
		LogoHorizontalPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The relative horizontal position of the top-left corner of the Emerald logo within the coordinate system of a single barcode sticker.",
			Category -> "Dimensions & Positions"
		},
		LogoVerticalPosition -> {
			Format -> Single,
			Class -> Real,
			Pattern :> _?DistanceQ,
			Units -> Meter Milli,
			Description -> "The relative vertical position of the top-left corner of the Emerald logo within the coordinate system of a single barcode sticker.",
			Category -> "Dimensions & Positions"
		},
		LogoSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The horizontal size of the logo on the sticker; the vertical size of the logo will be scaled proportionally.",
			Category -> "Dimensions & Positions"
		},
		LogoTransparency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1],
			Units -> None,
			Description -> "The transparency of the logo, from 0 (totally opaque) to 1 (totally transparent).",
			Category -> "Dimensions & Positions"
		},
		PrinterOffsets -> {
			Format -> Multiple,
			Class -> {String, Real, Real},
			Pattern :> {PrinterModelP, _?DistanceQ, _?DistanceQ},
			Units -> {None, Meter Milli, Meter Milli},
			Description -> "Printing offsets specific to a given printer. These offsets are added to the position of each sticker before the stickers are arranged and sent to the printer.",
			Category -> "Dimensions & Positions",
			Headers->{"Printer Name","Printer X-Offset", "Printer Y-Offset"}
		}
	}
}];
