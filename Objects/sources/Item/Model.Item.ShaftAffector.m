(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item, ShaftAffector], {
	Description->"Model information for a shaft used to mix media during a dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ShaftType->{
			Format->Single,
			Class->Expression,
			Pattern:>ShaftTypeP,
			Description->"The means by which the affector is attached to the rotating shaft.",
			Category->"Physical Properties"
		},
		DesignatedInstallationPosition->{
			Format->Single,
			Class->Expression,
			Pattern:>LocationPositionP,
			Description->"The position in which the affector is installed in the dissolution apparatus. It is considered best practice to install the affector in the same position for each experiment to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		},
		MixingStrategy->{
			Format->Single,
			Class->Expression,
			Pattern:>Basket|Paddle,
			Description->"The type of the stirrer implement used to mix the samples during the dissolution experiment. By convention, the USP apparatus 1 is ofter referred to as a Paddle, and the USP apparatus 2 is often referred to as a Basket.",
			Category->"Physical Properties"
		}
	}
}];