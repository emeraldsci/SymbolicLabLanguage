(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, DesignOfExperiment], {
	Description -> "Object containing the analyses that determines the set of experiment input parameters that optimizes the desired objective function.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ProtocolType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TypeP[Object[Protocol]],
			Description -> "The type of protocol being optimized in this design of experiment.",
			Category -> "Organizational Information"
		},

		(* ------ Optimization Settings Fields ------ *)

		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Custom | DesignOfExperiment`Private`DOEMethodP,
			Description -> "The algorithm that is used to enumerate the set of experimental inputs.",
			Category -> "Analysis & Reports" (*"Optimization Settings"*)
		},
		ObjectiveFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[AreaOfTallestPeak, MeanPeakSeparation, MeanPeakHeightWidthRatio, ResolutionOfTallestPeak],
			Description -> "The function used to score completed protocols for the different input parameters.",
			Category -> "Analysis & Reports" (*"Optimization Settings"*)
		},
		ParameterSpace -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_Symbol..},
			Description -> "The list of explicitly specified experiment option names that are varied during this design of experiment.",
			Category -> "Analysis & Reports" (*"Optimization Settings"*)
		},

		(* ------ Experimental Results Fields ------ *)

		Protocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The list of protocols spawned by this design of experiment that have run to completion.",
			Category -> "Experimental Results"
		},
		ExperimentParameters-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {__},
			Description -> "The explicitly specified experiment settings used for the set of physical experiments used in this design of experiment.",
			Category -> "Experimental Results"
		},
		Data -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of ExperimentParameters, the data object created from those options.",
			Category -> "Experimental Results",
			IndexMatching -> ExperimentParameters
		},

		(* ------ Optimization Results Fields ------ *)

		ObjectiveValues -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> UnitsP[],
			Description -> "For each member of ExperimentParameters, the objective function evaluated on the data object(s) generated during each experimental protocol.",
			Category -> "Analysis & Reports", (*"Optimization Results",*)
			IndexMatching -> ExperimentParameters
		},
		OptimalParameters -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> List[__],
			Description -> "For each member of ParameterSpace, the optimal value for each of the instrument settings/experimental conditions that were varied during this design of experiment.",
			Category -> "Analysis & Reports", (*"Optimization Results",*)
			IndexMatching -> ParameterSpace
		},
		OptimalObjectiveValue -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> UnitsP[],
			Description -> "The maximal attained value of the optimization function in this study.",
			Category -> "Analysis & Reports" (*"Optimization Results"*)
		}
	}

}];
