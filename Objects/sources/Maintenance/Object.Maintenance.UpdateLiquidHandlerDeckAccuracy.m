(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance,UpdateLiquidHandlerDeckAccuracy],{
	Description->"A protocol that measure the offsets of the various positions on deck of the Hamilton liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		Qualification -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification,MeasureLiquidHandlerDeckAccuracy],
			Description -> "The qualification protocol run after calibration to verify it.",
			Category -> "Experimental Results"
		}
	}
}]