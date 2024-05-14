

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, PeptideSynthesizer], {
	Description->"Model of a Peptide Synthesizer that generates protein/PNA and performs cleaved and resin download.",
	CreatePrivileges->None,
	Cache->Session,
	Fields ->{
		DeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "Dead volume needed to fill the instrument lines.",
			Category -> "Instrument Specifications"
		}
	}
}];
