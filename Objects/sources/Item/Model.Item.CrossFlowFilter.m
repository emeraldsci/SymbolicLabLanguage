(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, CrossFlowFilter], {
	Description->"Model information for a device module used to remove particles above a certain size from a sample with cross-flow filtration.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		(* ---------- General ---------- *)
		
		ShearConditionsGraph->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"Describes the relationship between flow rate and membrane shear.",
			Category->"General"
		},
		
		(* ---------- Physical Properties ---------- *)
		
		FilterType->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossFlowFilterTypeP,
			Description->"The classification of the filter type based on the configuration of the membrane.",
			Category->"Physical Properties",
			Abstract->True
		},
		
		ModuleFamily->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossFlowFilterModuleP,
			Description->"The classification of the filter module based on its physical size.",
			Category->"Physical Properties",
			Abstract->True
		},
		
		SizeCutoff->{
			Format->Single,
			Class->VariableUnit,
			Pattern:>Alternatives[GreaterP[0 Kilodalton],GreaterP[0 Micron]],
			Description->"The largest diameter or molecular weight of the molecules that can cross the membrane.",
			Category->"Physical Properties",
			Abstract->True
		},
		
		MembraneMaterial->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossFlowFilterMembraneMaterialP,
			Description->"The chemistry of the material used to filter the sample.",
			Category->"Physical Properties",
			Abstract->True
		},
		
		ModuleCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossFlowModuleConditionP,
			Description->"Describes the sterility and wetness status of the filter at the time of packaging.",
			Category->"Physical Properties"
		},
		
		NumberOfFibers->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Describes how many filter tubes are bundled inside the filter module.",
			Category->"Physical Properties"
		},
		
		FiberInnerDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Meter],
			Units->Millimeter,
			Description->"The diameter of the filter tubes that make up the entire filter module.",
			Category->"Physical Properties"
		},
		
		EffectiveLength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Meter],
			Units->Centimeter,
			Description->"The distance between the inlet and the outlet of the filter.",
			Category->"Physical Properties"
		},
		
		FilterSurfaceArea->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0 Meter^2],
			Units->Centimeter^2,
			Description->"The total amount of membrane area that is available for filtering.",
			Category->"Physical Properties"
		},
		
		MinVolume->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0 Liter],
			Units->Milliliter,
			Description->"The minimum amount of solution that can be processed by the filter.",
			Category->"Physical Properties"
		},
		
		MaxVolume->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0 Liter],
			Units->Milliliter,
			Description->"The maximum amount of solution that can be processed by the filter.",
			Category->"Physical Properties"
		},
		
		DefaultFlowRate->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterP[0 Milliliter/Minute],
			Units->Milliliter/Minute,
			Description->"The flow rate at which the shear rate along the membrane is 6000 per second.",
			Category -> "General"
		},
		
		(* ---------- Plumbing Information ---------- *)
		
		InletRetentateConnectionType->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossFlowConnectorP,
			Description->"The type of fitting needed to plumb the feed into the filter.",
			Category->"Plumbing Information"
		},
		
		InletRetentateConnectionSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Inch],
			Units->Inch,
			Description->"The diameter of fitting needed to plumb the feed into the filter.",
			Category->"Plumbing Information"
		},
		
		PermeateConnectionType->{
			Format->Single,
			Class->Expression,
			Pattern:>CrossFlowConnectorP,
			Description->"The type of fitting needed to plumb the permeate out of the filter.",
			Category->"Plumbing Information"
		},
		
		PermeateConnectionSize->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Inch],
			Units->Inch,
			Description->"The diameter of fitting needed to plumb the permeate out of the filter.",
			Category->"Plumbing Information"
		}
	}
}];
