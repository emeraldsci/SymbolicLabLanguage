(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,FiberSampleHolder],{
	Description->"Model information for a fiber sample holder used to hold the fiber samples and mount into the single fiber tensiometer instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AssociatedAccessories,1],
			Description -> "A list of instruments for which this model is an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		}
	}
}];
