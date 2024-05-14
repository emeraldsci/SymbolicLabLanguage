(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,Wait],
	{
		Description->"A detailed set of parameters to pause for a specifed amount of time, before continuing with the execution of future unit operations.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Duration -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Minute,
				Description -> "The amount of time to pause before continuing the execution of future unit operations.",
				Category -> "General"
			}
		}
	}
];
