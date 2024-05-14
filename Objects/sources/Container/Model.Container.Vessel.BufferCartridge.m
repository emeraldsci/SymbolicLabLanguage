(* ::Package:: *)

DefineObjectType[Model[Container,Vessel,BufferCartridge], {
	Description->"A model of a cartridge to contain the cathode buffer for the genetic analyzer instrument used in DNA sequencing experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {CathodeSequencingBuffer -> {
					Format -> Single,
					Class -> Link,
					Pattern :> _Link,
					Relation->Model[Sample],
					Description -> "The pH-change resistant solution that is run at the negative end of the capillary in the sequencing cartridge.",
					Category -> "Physical Properties"
				},
				BufferFillLineVolume -> {
					Format -> Single,
					Class -> Real,
					Pattern :> GreaterP[0 Microliter],
					Units->Milliliter,
					Description -> "The volume of buffer the cartridge contains such that the cartridge to the fill line. Cathode buffer should reach this level in order to run a DNA Sequencing experiment.",
					Category -> "Physical Properties"
				},
				State -> {
					Format -> Single,
					Class -> Expression,
					Pattern :> ModelStateP,
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Physical Properties"
				}
			}
	}
];
