(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, ConductivitySensor], {
	Description->"A probe used for in-line electrical conductivity and temperature measurements of a solution.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		(* ----- Model Information ----- *)
		
		SensorCertificate->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs for the quality certificate of this probe coming from the manufacturer.",
			Category -> "Model Information"
		},
		
		NominalCellConstant->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0],
			Description->"The value of the adjustment factor for the conductivity sensor. This value is reported by the manufacturer and is used to correct the recorded values during the experiment. Also known as the K-Value of the sensor.",
			Category->"General",
			Abstract->True
		},
		
		MinConductivity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinConductivity]],
			Pattern:>GreaterP[0 Milli Siemens/(Centimeter)],
			Description->"Minimum conductivity this sensor can measure.",
			Category->"Operating Limits"
		},
		
		MaxConductivity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxConductivity]],
			Pattern:>GreaterP[0 Milli Siemens/(Centimeter)],
			Description->"Maximum conductivity this sensor can measure.",
			Category->"Operating Limits",
			Abstract->True
		},
		
		MinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern:>GreaterP[0 Celsius],
			Description->"Minimum temperature this sensor can measure.",
			Category->"Operating Limits"
		},
		
		MaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern:>GreaterP[0 Celsius],
			Description->"Maximum temperature this sensor can measure.",
			Category->"Operating Limits"
		}
	}
}];
