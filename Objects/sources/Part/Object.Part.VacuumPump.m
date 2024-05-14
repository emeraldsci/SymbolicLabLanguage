(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part,VacuumPump],{
	Description->"Fluid pumping devices that generate a partial vacuum.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		Manufacturer->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Manufacturer]],
			Pattern:>_Link,
			Relation->Object[Company,Supplier],
			Description->"The company that originally manufactured this part.",
			Category->"Inventory"
		},

		UserManualFiles->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],Manufacturer]],
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"PDFs for the manuals or instruction guides for this part.",
			Category->"Organizational Information"
		}
	}
}];