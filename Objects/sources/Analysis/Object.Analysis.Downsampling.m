(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis,Downsampling],{
	Description->"Downsampling analysis for reducing the file size of large data arrays.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		OriginalDimension->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The dimension in the original dataset to which each dimension in the downsampled dataset corresponds to. The last entry of this list is assumed to be the dependent-variable dimension.",
			Category -> "General"
		},
		DataUnits->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UnitsP[],
			Description -> "For each member of OriginalDimension, the units associated with that dimension.",
			Category -> "General",
			IndexMatching->OriginalDimension
		},
		SamplingGridPoints->{
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {NumericP, NumericP, NumericP},
			Units -> {None, None, None},
			Description -> "For each member of OriginalDimension, the minimum, maximum, and spacing of grid points sampled in that dimension. Null for the last dimension.",
			Headers -> {"Min","Max","Spacing"},
			Category -> "General",
			IndexMatching->OriginalDimension
		},
		NoiseThreshold->{
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[NumericP|None],
			Units -> None,
			Description -> "Data points with magnitude less than this threshold in the dependent-variable dimension (last entry of OriginalDimension) will be set to zero in DownsampledData. For None, no Threshold was applied.",
			Category -> "General"
		},
		DownsampledData->{
			Format->Single,
			Class->Expression,
			Pattern:>_SparseArray,
			Description->"A sparse matrix representation of the downsampled data.",
			Category->"Analysis & Reports"
		},
		DownsampledDataFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation -> Object[EmeraldCloudFile],
			Description->"A Mathematica .MX binary file containing the DownsampledData.",
			Category->"Data Processing"
		}
	}
}];
