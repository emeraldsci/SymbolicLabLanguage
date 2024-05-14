(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, BarcodeReader], {
	Description->"A device that scans 1D or 2D barcode and extracts the encoded information.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		BarcodeType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],BarcodeType]],
			Pattern:>BarcodeTypeP,
			Description->"The types of barcodes that the barcode reader can scan and decode.",
			Category->"Part Specifications",
			Abstract->True
		},
		ConnectionMethod->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],ConnectionMethod]],
			Pattern:>ConnectionMethodP,
			Description->"The connection method between the barcode reader and a supported data processing device (a computer, a tablet or a mobile device).",
			Category->"Part Specifications",
			Abstract->True
		},
		ConnectedInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Instrument]],
			Relation->Object[Instrument,CapillaryELISA][BarcodeReader],
			Description->"The instrument that this barcode reader is used with to scan kit information QR codes into the instrument's software.",
			Category->"Part Specifications",
			Abstract->True
		}
	}
}];
