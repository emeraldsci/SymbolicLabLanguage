(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[DesignOfExperiment], {
	Description->"A study that systematically investigates the impact of specified parameters on experiments.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		(*Experiment Fields*)
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DesignOfExperiment`Private`DOEMethodP,
			Description -> "The algorithm that is used to enumerate the set of experimental inputs.",
			Category -> "Method Information"
		},
		Parameters -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Symbol,
			Description -> "The list of explicitly specified experiment settings for the design of experiment ProtocolType.",
			Category -> "Method Information"
		},
		Ranges -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {_?NumericQ ..},
			Description -> "For each member of Parameters, the values the parameter takes on.",
			Category -> "Method Information",
			IndexMatching -> Parameters
		},
		ObjectiveFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[AreaOfTallestPeak, MeanPeakSeparation, MeanPeakHeightWidthRatio, ResolutionOfTallestPeak],
			Description -> "The function used to score completed protocols for the different input parameters.",
			Category -> "Method Information"
		},
		MaxNumberOfExperiments -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0,1],
			Description -> "The highest possible number of experiments the design of experiment will run, although fewer experiments may be run.",
			Category -> "Method Information"
		},
		MaxNumberOfThreads -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0,1],
			Description -> "The highest number of threads devoted to this design of experiment at one time.",
			Category -> "Method Information"
		},
		(* Script fields *)
		Script -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Script][DesignOfExperiment],
			Description -> "The sequence of code that generates an experimental workflow for the design of experiment that is executed in the laboratory.",
			Category -> "Organizational Information"
		},
		PendingProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The list of protocols spawned by this design of experiment that are awaiting open experimental threads to run.",
			Category -> "Organizational Information"
		},
		RunningProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The list of protocols spawned by this the design of experiment which are currently running in the lab.",
			Category -> "Organizational Information"
		},
		CompletedProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The list of protocols spawned by this design of experiment that have run to completion.",
			Category -> "Organizational Information"
		},
		(* Results Fields *)
		CompletedParameters-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {__},
			Description -> "The explicitly specified experiment settings used for the set of physical experiments used in this design of experiment.",
			Category -> "Experimental Results"
		},
		CompletedData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of CompletedParameters, the data object run for the parameters.",
			Category -> "Experimental Results"
		},
		DesignOfExperimentAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "An evaluation of the variable parameters on the data generated in the experimental protocol.",
			Category -> "Experimental Results"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
