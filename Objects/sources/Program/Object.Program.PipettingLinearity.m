

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program, PipettingLinearity], {
	Description->"A program to check the pipetting linearity of the tip based liquid handling robots.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Source -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The locations of the source material to be pipetted, including plate and well information.",
			Category -> "Robotic Liquid Handling"
		},
		Destination -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotSequenceP,
			Description -> "The destinations for the source material, including plate and well information.",
			Category -> "Robotic Liquid Handling"
		},
		Volume -> {
			Format -> Single,
			Class -> String,
			Pattern :> Patterns`Private`robotNumberListP,
			Description -> "Volume of material (in microliters)to be pipetted into the destination wells.",
			Category -> "Robotic Liquid Handling"
		}
	}
}];
