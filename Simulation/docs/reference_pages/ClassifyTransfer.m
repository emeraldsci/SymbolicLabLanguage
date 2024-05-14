(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-02-24 *)


(* ::Section::Closed:: *)
(*ClassifyTransfer*)
DefineUsage[ClassifyTransfer,
{
  BasicDefinitions -> {
		{
			Definition->{"ClassifyTransfer[RoboticTransfer]", "ClassifiedRoboticTransfer"},
			Description->"determines whether the automatic liquid handling event was successful or not by applying a machine learning model to the aspiration pressure data.",
			Inputs :> {
				{
					InputName->"RoboticTransfer",
					Widget->Adder[
						Widget[Type->Object, Pattern:> ObjectP[Object[UnitOperation, Transfer]]]
					],
					Expandable->False,
					Description->"A transfer unit operation created from a robotic sample preparation protocol."
				}
			},
			Outputs :> {
				{
					OutputName->"ClassifiedRoboticTransfer",
					Pattern:> ListableP[ObjectP[Object[UnitOperation, Transfer]]],
					Description->"The same object that represents the input robotic transfer with additional fields uploaded for the transfer classifications and confidences in those classifications."
				}
			}
		},
		{
			Definition->{"ClassifyTransfer[UnitOperations]", "UnitOpsWithClassifiedTransfers"},
			Description->"takes in a list of 'UnitOperations', selectively classifies the transfer objects in the list, and leaves the other unit operations untouched.",
			Inputs :> {
				{
					InputName->"UnitOperations",
					Widget->Adder[
						Widget[Type->Object, Pattern:> ObjectP[Object[UnitOperation]]]
					],
					Expandable->False,
					Description->"A unit operation created from a robotic sample preparation protocol."
				}
			},
			Outputs :> {
				{
					OutputName->"UnitOpsWithClassifiedTransfers",
					Pattern:> ListableP[ObjectP[Object[UnitOperation]]],
					Description->"The same objects that represent the input unit operations with the classifications and confidences uploaded for the transfer unit operations."
				}
			}
		}
	},
	MoreInformation -> {
		StringJoin[
			"The model is based on a Gaussian process classifier, which outputs likelihood values for each classification for a given input. These likelihoods are converted to probabilities through the softmax function.",
			" The model used a radial basis function kernel (RBF) with a length parameter of 1.0 to fit the correlations between features."
		],
		"The model is a binary classifier that outputs either Success or Failure for each aspiration. Since there are two labels, the classification is determined by the label that has a probability score of greater than 50%.",
		"The model was trained on three datasets, Object[UnitOperation, Transfer, \"id:GmzlKjzzX80M\"], Object[UnitOperation, Transfer, \"id:AEqRl9qqemY5\"], and Object[UnitOperation, Transfer, \"id:9RdZXvddV7Ga\"].",
		"Included in these datasets are transfers with (1) soapy/bubbly fluid, (2) partially aspirated samples in which the target transfer volume was greater than the volume in the sample container, (3) empty aspirations, and (4) successful aspirations.",
		StringJoin[
			"The aspiration pressure data in the transfer object was used to train the classifier.",
			" The pressure data was stripped of units and normalized between 0 and -1, then interpolated onto a uniform grid of time points before being passed to the classifier for training.",
			" The time data was also stripped of units and normalized to values between 0 and 1."
		],
		StringJoin[
			"A five-fold stratified K-fold algorithm was used for cross-validation. This algorithm ensures that each training set contains the same distribution of successful and unsuccessful transfers.",
			" The cross-validation was repeated 5 times to generate 25 accuracy scores. The average accuracy score of this model is 99.4%."
		]
	},
	SeeAlso -> {ExperimentRoboticSamplePreparation, ExperimentTransfer},
	Author -> {"scicomp", "tommy.harrelson"}
}
];