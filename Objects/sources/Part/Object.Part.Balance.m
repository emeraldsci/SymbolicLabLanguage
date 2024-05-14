(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,Balance],{
	Description->"The model of a device for measurement of weight.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument,CrossFlowFiltration][FeedScale],
				Object[Instrument,CrossFlowFiltration][PermeateScale]
			],
			Description->"The instrument that this balance is attached.",
			Category->"Instrument Specifications"
		},
		
		Manufacturer->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Manufacturer]],
			Pattern:>_Link,
			Relation->Object[Company,Supplier],
			Description->"The company that originally manufactured this model of instrument.",
			Category->"Inventory"
		},
		
		UserManualFiles->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Manufacturer]],
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDFs for the manuals or instruction guides for this model of instrument.",
			Category->"Organizational Information"
		},
		
		Resolution->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Resolution]],
			Pattern:>GreaterP[0*Gram],
			Description->"The smallest change in mass that corresponds to a change in displayed value. Also known as readability, increment, scale division.",
			Category->"Instrument Specifications"
		},
		
		MinWeight->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinWeight]],
			Pattern:>GreaterP[0*Gram],
			Description->"Minimum mass the instrument can weigh.",
			Category->"Operating Limits"
		},
		
		MaxWeight->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxWeight]],
			Pattern:>GreaterP[0*Gram],
			Description->"Maximum mass the instrument can weigh.",
			Category->"Operating Limits"
		}
	}
}];
