(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, BarcodeReader], {
	Description->"A model of device that scans 1D or 2D barcode and extracts the encoded information.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		BarcodeType->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BarcodeTypeP,
			Description->"The types of barcodes that the barcode reader can scan and decode.",
			Category->"Part Specifications",
			Abstract->True
		},
		ConnectionMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>ConnectionMethodP,
			Description->"The connection method between the barcode reader and a supported data processing device (a computer, a tablet or a mobile device).",
			Category->"Part Specifications",
			Abstract->True
		},
		SupportedInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Instrument]],
			Relation->Model[Instrument,CapillaryELISA][BarcodeReader],
			Description->"The instrument model that this barcode reader can be used with to scan kit information QR codes into the instrument's software.",
			Category->"Part Specifications",
			Abstract->True
		},
		CompatibleBatteryHousing->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BatteryHousingP,
			Description->"The battery housing form factor which the barcode reader accepts.",
			Category->"Part Specifications",
			Abstract->True
		}
	}
}];
