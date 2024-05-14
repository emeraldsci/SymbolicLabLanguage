(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[LearningModel], {
	Description->"A mathematical model, with parameters trained on experimental data, that predicts OutputState from InputState.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(******************************)
		(* Organizational Information *)
		(******************************)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A unique name for this learning model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who created this learning model.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(***
			Subtyping -

				Object[LearningModel, <Application>, <Algorithm>]
					Application -> Experiment Type? (think about this a bit more )
					Algorithm ->

				Object[LearningModel, DNASequencing, BayesCall]
				Object[LearningModel, NMR, <to be named>]

				ExperimentFunctions should be calling SimulateNMRData[]

		***)

		(*********************)
		(* Model Information *)
		(*********************)
		ModelType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[NearestNeighbors, NeuralNetwork, BayesianNetwork],
			Description -> "The type of model that this LearningModel object implements.",
			Category -> "Model Information",
			Abstract -> True
		},
		PredictionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Deterministic|Probabilistic,
			Description -> "Indicates whether this LearningModel makes a single prediction, or a list of predictions with associated probabilities.",
			Category -> "Model Information",
			Abstract -> True
		},
		(*LearningType -> {
			Persistent|Static
			PersistentLearner -> points to many versions of itself, defaults to most recent
				-> Make read-only copies of itself and link to these?
 				-> How frequently/ what to name versions/ etc?
		},*)
		ReadOnly -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "True indicates that this model is read-only and cannot be updated by training.",
			Category -> "Model Information",
			Abstract -> True
		},


		(*******************************************************************************)
		(** Don't make shared? E.g. keep the interface open for different model types **)
		(*******************************************************************************)
		ModelEquation -> {
			(*
				This makes sense for some models, and is ugly for others. E.g. for a Bayesian model,
				the parameters are just matrices and the equation is matrix algebra linking the
				input to output state. However, how do you convey NearestNeighbors?
			*)

			(* Storing code
				- Function pages in CC (scripts pre-load these)

 				prefixes, libraries, consistent naming; then ModelEquation/code points to the SLL library,
					(point to a .m file, but need knowledge of what function/inside to call)
				  retain ability for users to custom-code their own things
					@Thomas

				Store the function call as a pure function
					-> (#1,#2 hash ) - be careful

				Dependencies - probably okay though? Need a copy of their source code.

				Can always link to an EmeraldCloudFile
					(take some time to understand how the function pages are handled by CC)
      *)

			Format -> Single,
			Class -> Expression,
			Pattern :> Except[_String],
			Description -> "The symbolic expression representing the mathematical mapping of input to output state in this learning model.",
			Category -> "Model Information",
			Abstract -> True
		}
	}
}];
