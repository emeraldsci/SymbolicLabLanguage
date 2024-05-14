(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[
	Model[Maintenance, RefillReservoir, LiquidParticleCounter],
	{
		Description -> "Definition of a set of parameters for a maintenance protocol that refills the ProbeStorageContainer of a liquid particle counter.",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields->{
			ReservoirLocationName->{
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The position name where the container is placed on the instrument.",
				Category -> "General"
			}
		}
	}
];
