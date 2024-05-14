(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,PeristalticPump], {
	Description->"The model for Low pressure, low volume liquid pumping devices for continuous liquid transfers.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument,CrossFlowFiltration][PrimaryPump],
				Object[Instrument,CrossFlowFiltration][SecondaryPump]
			],
			Description->"The instrument that this pump is attached.",
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
		
		TubingType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],TubingType]],
			Pattern:>TubingTypeP,
			Description->"Material type the peristaltic pump is composed of.",
			Category->"Instrument Specifications",
			Abstract -> True
		},
		
		MinFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFlowRate]],
			Pattern:>GreaterP[(0*(Milliliter))/Minute],
			Description->"Minimum flow rate the pump can deliver.",
			Category->"Operating Limits"
		},
		
		MaxFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern:>GreaterP[(0*(Milliliter))/Minute],
			Description->"Minimum flow rate the pump can deliver.",
			Category->"Operating Limits"
		}
	}
}];