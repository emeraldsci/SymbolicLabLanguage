(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, GraduatedCylinder], {
	Description->"A graduated cylinder device for high precision measurement of large volumes.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Resolution]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Resolution of the cylinder's volume-indicating markings, the volume between gradation subdivisions.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		DedicatedInstrument ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Dispenser][MeasuringDevices],
			Description -> "A dispenser instrument for which this container serves as a dedicated measuring device.",
			Category -> "Storage Information"
		},
		Graduations->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Graduations]],
			Pattern :> {GreaterEqualP[0 Milliliter]..},
			Description -> "The markings on this cylinder used to indicate the fluid's fill level.",
			Abstract->True,
			Category -> "Container Specifications"
		}
	}
}];
