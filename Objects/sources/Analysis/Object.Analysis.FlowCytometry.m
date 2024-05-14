(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,FlowCytometry],{
	Description->"Clustering analysis used to partition flow cytometry data and obtain cell counts.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ClusterLabels->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"The name assigned to each cluster of cells partitioned in the analysis.",
			Category->"Analysis & Reports"
		},
		ClusterAssignments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Cell],
			Description->"For each member of ClusterLabels, the putative cell identity model associated with that cluster.",
			Category->"Analysis & Reports",
			IndexMatching->ClusterLabels
		},
		CellCounts->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0.0 Milliliter^-1],
			Units->Milliliter^-1,
			Description->"For each member of ClusterLabels, the number of cells in that cluster per milliliter of input sample.",
			Category->"Analysis & Reports",
			IndexMatching->ClusterLabels
		},
		AbsoluteCellCounts->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"For each member of ClusterLabels, the absolute number of cells in that cluster.",
			Category->"Analysis & Reports",
			IndexMatching->ClusterLabels
		},
		NumberOfDimensions->{
			Format->Single,
			Class->Integer,
			Pattern:>_Integer,
			Description->"The dimensionality of each data point in the reference flow cytometry data. There are three dimensions (peak height, width, and area) per detector for which data was collected.",
			Category->"Analysis & Reports"
		},
		DimensionLabels->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"A label indicating the detector (excitation and emission wavelengths) and measurement (peak height, width, or area) to which each dimension of the reference flow cytometry data corresponds.",
			Category->"Analysis & Reports"
		},
		DimensionUnits->{
			Format->Multiple,
			Class->Expression,
			Pattern:>UnitsP[],
			Description->"For each member of DimensionLabels, the physical units associated with that dimension.",
			Category->"Analysis & Reports",
			IndexMatching->DimensionLabels
		},
		ClusteredData->{
			Format->Single,
			Class->Compressed,
			Pattern:>_Association,
			Units->None,
			Description->"An association containing reference flow cytometry data points partitioned into groups, labeled by names from ClusterLabels.",
			Category->"Analysis & Reports"
		},
		CompensationMatrix->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,CompensationMatrix],
			Description->"The compensation matrix used to compensate for spillover of fluorophores into other detectors.",
			Category->"Data Processing"
		},
		ClusterAnalysisTree->{
			Format->Single,
			Class->Compressed,
			Pattern:>_Graph,
			Units->None,
			Description->"A directed tree graph, where each node is a clustering analysis packet, describing the sequence of clustering analyses used to generate this flow cytometry analysis.",
			Category->"Data Processing"
		},
		ClustersAnalyses->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Analysis,Clusters][FlowCytometryAnalyses],
			Description->"Clustering analyses used in this flow cytometry analysis.",
			Category -> "General"
		}
	}
}];
