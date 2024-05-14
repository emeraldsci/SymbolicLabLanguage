(* ::Package:: *)

DefineObjectType[Object[Container,Vessel,BufferCartridge], {
	Description->"A cartridge to contain the cathode buffer for the genetic analyzer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {CathodeSequencingBuffer -> {
					Format -> Single,
					Class -> Link,
					Pattern :> _Link,
					Relation->Model[Sample],
					Description -> "The buffer run at the negative end of the capillary in the sequencing cartridge.",
					Category -> "Physical Properties"
				},
				BufferFillLineVolume -> {
					Format -> Computable,
					Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BufferFillLineVolume]],
					Pattern :> GreaterP[0 Microliter],
					Description -> "The volume of buffer the cartridge contains to fill the cartridge to the fill line. Cathode buffer should reach this level in order to run a DNA Sequencing experiment.",
					Category -> "Physical Properties"
				}
			}
	}
];
