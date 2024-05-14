(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item, CrossFlowFilter], {
	Description->"A device used to remove particles above a certain size from a sample with cross-flow filtration.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		(* ---------- General ---------- *)
		
		ShearConditionsGraph->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ShearConditionsGraph]],
			Pattern:>_Link,
			Description->"Describes the relationship between flow rate and membrane shear.",
			Category->"General"
		},
		
		QualityCertificate->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"The quality certificate provided by the manufacturer for this filter.",
			Category->"General"
		},
		
		(* ---------- Physical Properties ---------- *)

		FilterType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],FilterType]],
			Pattern:>CrossFlowFilterTypeP,
			Description->"The classification of the filter type based on the configuration of the membrane.",
			Category->"Physical Properties",
			Abstract->True
		},
		
		ModuleFamily->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ModuleFamily]],
			Pattern:>CrossFlowFilterModuleP,
			Description->"The classification of the filter module based on its physical size.",
			Category->"Physical Properties",
			Abstract->True
		},

		SizeCutoff->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],SizeCutoff]],
			Pattern:>GreaterP[0 Kilodalton]|GreaterP[0 Micron],
			Description->"The largest diameter or molecular weight of the molecules that can cross the membrane.",
			Category->"Physical Properties",
			Abstract->True
		},

		MembraneMaterial->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MembraneMaterial]],
			Pattern:>CrossFlowFilterMembraneMaterialP,
			Description->"The chemistry of the material used to filter the sample.",
			Category->"Physical Properties",
			Abstract->True
		},

		ModuleCondition->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ModuleCondition]],
			Pattern:>Alternatives[Dry,PreWetted,Sterile],
			Description->"Describes the sterility and wetness status of the filter at the time of packaging.",
			Category->"Physical Properties"
		},
		
		NumberOfFibers->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],NumberOfFibers]],
			Pattern:>GreaterP[0],
			Description->"Describes how many filter tubes are bundled together to form the filter.",
			Category->"Physical Properties"
		},

		FiberInnerDiameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],FiberInnerDiameter]],
			Pattern:>GreaterP[0 Meter],
			Description->"The diameter of the filter tubes that make up the entire filter module.",
			Category->"Physical Properties"
		},

		EffectiveLength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],EffectiveLength]],
			Pattern:>GreaterP[0 Meter],
			Description->"The distance between the inlet and the outlet of the filter.",
			Category->"Physical Properties"
		},

		FilterSurfaceArea->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],FilterSurfaceArea]],
			Pattern:>GreaterP[0 Meter^2],
			Description->"The total amount of membrane area that is available for filtering.",
			Category->"Physical Properties"
		},

		MinVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinVolume]],
			Pattern:>GreaterP[0 Liter],
			Description->"The minimum amount of solution that can be processed by the filter.",
			Category->"Physical Properties"
		},

		MaxVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVolume]],
			Pattern:>GreaterP[0 Liter],
			Description->"The maximum amount of solution that can be processed by the filter.",
			Category->"Physical Properties"
		},
		
		DefaultFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DefaultFlowRate]],
			Pattern:>GreaterP[0 Milliliter/Minute],
			Description->"The flow rate at which the shear rate along the membrane is 6000 per second.",
			Category -> "General"
		},

		(* ---------- Plumbing Information ---------- *)

		InletRetentateConnectionType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],InletRetentateConnectionType]],
			Pattern:>CrossFlowConnectorP,
			Description->"The type of fitting needed to plumb the feed into the filter.",
			Category->"Plumbing Information"
		},

		InletRetentateConnectionSize->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],InletRetentateConnectionSize]],
			Pattern:>GreaterP[0 Inch],
			Description->"The size of fitting needed to plumb the feed into the filter.",
			Category->"Plumbing Information"
		},

		PermeateConnectionType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PermeateConnectionType]],
			Pattern:>CrossFlowConnectorP,
			Description->"The type of fitting needed to plumb the permeate out of the filter.",
			Category->"Plumbing Information"
		},

		PermeateConnectionSize->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],PermeateConnectionSize]],
			Pattern:>GreaterP[0 Inch],
			Description->"The size of fitting needed to plumb the permeate out of the filter.",
			Category->"Plumbing Information"
		}
	}
}];
