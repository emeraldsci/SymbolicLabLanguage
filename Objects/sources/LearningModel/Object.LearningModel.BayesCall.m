(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[LearningModel,BayesCall], {
	Description->"
		A Bayesian Network model which uses a four-channel DNA sequencing electropherogram as input
		to predict nucleobase probabilities for each peak in the input electropherogram.
		This model is an implementation of the base-calling algorithm of
 		Kao et al. described in Object[Report, Literature, \"id:J8AY5jDL8ZdB\"]
	",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* Store the API in the object *)

		(* Give user the ability to upload source code Ben Smith/Thomas/Steven R.? (Think App Store) *)

		(*********************************)
		(* Input State (stores patterns) *)
		(*********************************)
		SequencingTraces -> {
			Format -> Single,
			Class -> {Expression, Expression},
			Pattern :> {_Symbol, _},
			Headers -> {"Symbol", "Pattern"},
			Description -> "Pattern describing a unitless N-by-4 array representing a DNA sequencing chromatogram or electropherogram,
				where each row is a sequential scan,
				and the four columns correspond to the signal from A, C, T, and G, in that order.",
			Category -> "Input State Patterns"
		},
		(* CoordinatesP?(Last[Dimensions[#]]===4)& *)

		(**********************************)
		(* Output State (stores patterns) *)
		(**********************************)
		BaseProbabilities -> {
			Format -> Single,
			Class -> {Expression, Expression},
			Pattern :> {_Symbol, _},
			Headers -> {"Symbol", "Pattern"},
			Description -> "Pattern describing an M-by-4 array representing base probabilities,
				where M in the number of identified peaks in the input sequencing traces,
				and the four columns correspond to the probability that each peak is signal corresponding to
				bases A, C, T, and G, in that order.",
			Category -> "Output State Patterns"
		},
		(* CoordinatesP?(Last[Dimensions[#]]===4)& *)

		(**************)
		(* Parameters *)
		(**************)
		CrosstalkMatrix -> {
			Format -> Single,
			Class -> {Expression, Compressed},
			Pattern :> {_Symbol, MatrixP[GreaterP[0.0]]},
			Headers -> {"Symbol", "Value"},
			Description -> "A 4x4 matrix where the {i,j}th element denotes
				the signal in channel i due to the concentration of a base in channel j.
				Off-diagonal elements indicate interference, or \"cross-talk\" betweeen bases.
			",
			Category -> "Parameters"
		},
		(* X, {{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1}} *)

		IntensityVariance -> {
			Format -> Single,
			Class -> {Expression, Compressed},
			Pattern :> {_Symbol, MatrixP[GreaterP[0.0]]},
			Headers -> {"Symbol", "Value"},
			Description -> "The covariance matrix of the four-dimensional gaussian noise used to model stochasticity in intensity.",
			Category -> "Parameters"
		},
		(* \[Sigma], {.. 4x4 matrix } *)

		IntensityDecayVariance -> {
			Format -> Single,
			Class -> {Expression, Compressed},
			Pattern :> {_Symbol, GreaterP[0.0,1.0]},
			Headers -> {"Symbol", "Value"},
			Description -> "The variance of the gaussian noise process used to model signal intensity decay.",
			Category -> "Parameters"
		},
		(* \[sigma], 0.01 *)

		AutocorrelationFactor -> {
			Format -> Single,
			Class -> {Expression, Compressed},
			Pattern :> {_Symbol, RangeP[0.0,1.0]},
			Headers -> {"Symbol", "Value"},
			Description -> "The weights on the two previous gaussian noise values when modeling gaussian noise.
				If set to zero, then the noise process is uncorrelated and each noise value is independent.
				If set to one, the noise process is fully correlated and all noise values are the same random value.
			",
			Category -> "Parameters"
		},
		(* d, 0.3 *)

		ResidualIntensityFactor -> {
			Format -> Single,
			Class -> {Expression, Compressed},
			Pattern :> {_Symbol, RangeP[0.0,1.0]},
			Headers -> {"Symbol", "Value"},
			Description -> "The fraction of intensity at cycle t due to the intensity at cycle t-1.",
			Category -> "Parameters"
		},
		(* alpha, 0.01 *)

		PhasingProbability -> {
			Format -> Single,
			Class -> {Expression, Number},
			Pattern :> {_Symbol, RangeP[0.0,1.0]},
			Headers -> {"Symbol", "Value"},
			Description -> "The probability that zero new bases (instead of one) are synthesized in a synthesis cycle.",
			Category -> "Parameters"
		},
		(* p, 0.01 *)

		PrephasingProbability -> {
			Format -> Single,
			Class -> {Expression, Number},
			Pattern :> {_Symbol, RangeP[0.0,1.0]},
			Headers -> {"Symbol", "Value"},
			Description -> "The probability that two new bases (instead of one) are synthesized in a synthesis cycle.",
			Category -> "Parameters"
		}
		(* q, 0.01 *)

	}
}];





(* NOTES:


(*** Usage Examples ***)

(* The learning model interface will be very strict, so the input to the model
	 must be formatted in a specific way *)
DNAseqTraces=Transpose@Download[Object[Data,DNASequencing,"id:123"],
	{
		SequencingElectropherogramChannel1,
		SequencingElectropherogramChannel2,
		SequencingElectropherogramChannel3,
		SequencingElectropherogramChannel4
	}
];


(* Pattern checking occurs in the inside of the function, and reads fields from the learning model *)
ApplyLearningModel[
	Object[LearningModel,BayesCall,"id:xyz"],
	{DNAseqtraces}
]


(* Training data must have labels (outputs) which match the patterns in the learning model object *)
TrainLearningModel[
	Object[LearningModel,BayesCall,"id:xyz"],
	{DNAseqtraces},
	{
		{
			(* "A", "C", "T", "G" probabilities *)
			{0.25,0.5,0.25,0.0},
			{0.01,0.01,0.90,0.08},
			...
		}
	}
]


(*** What _IS_ tensorflow ***)


(* The user-facing functions should have a very clean interface for learning models,
   as Analysis and Simulation functions will handle passing the correct patterns to the models *)
AnalyzeDNASequencing[
	Object[Data,DNASequencing,"id:123"],
	Method->BayesCall
	LearningModel->Object[LearningModel,DNASequencing,BayesCall,"123"] (* Optional Argument *)
]


(* In option resolution; check current user object to determine which learning model to call
		userObj/financing team sets preferences

		Need a public facing function:
		PreferredLearningModel[Type] -> "id:12345"

*)


*)
