(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentBioconjugation: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentBioconjugation*)


DefineTests[ExperimentBioconjugation,
	{
		(*===Basic examples===*)
		Example[{Basic,"Generates a bioconjugation protocol from a nested list of inputs indicating the samples to be conjugated together:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			ObjectP[Object[Protocol,Bioconjugation]],
			TimeConstraint->1000
		],

		Example[{Basic,"Generates a bioconjugation protocol from a nested list of containers by pooling all the samples in the container at the conjugation step:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Container,Plate,"Experiment Bioconjugation test container 1"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			ObjectP[Object[Protocol,Bioconjugation]],
			TimeConstraint->1000
		],
		Example[{Basic,"Generates a bioconjugation protocol from model-less samples:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation model-less test sample"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			ObjectP[Object[Protocol,Bioconjugation]],
			TimeConstraint->1000
		],

		(*===Additional examples===*)

		(*===Messages tests===*)
		Example[{Messages,"DuplicatedBioconjugationSample","Do not allow duplicate samples in the same conjugation pool:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::DuplicatedBioconjugationSample,
				Error::InvalidInput
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ObjectDoesNotExist","Do not allow non-existent samples as inputs:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 10"], Object[Sample, "Experiment Bioconjugation test sample 12"]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Download::ObjectDoesNotExist
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ObjectDoesNotExist","Do not allow non-existent identity models as inputs:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 15"]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ObjectDoesNotExist
			},
			TimeConstraint->1000
		],
		Example[{Messages,"EmptyBioconjugationSampleContainer","Do not allow empty containers as inputs:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Container,Vessel,"Experiment Bioconjugation test empty container"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::EmptyBioconjugationSampleContainer
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidBatchProcessingOptions","ProcessingOrder and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ProcessingOrder->Parallel,
				ProcessingBatchSize->1
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidBatchProcessingOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPreWashOptions","PreWash and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreWash -> {{False, False}},
				PreWashMethod -> {{Pellet, Pellet}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPreWashOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPreWashMixOptions","PreWashMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreWashMix -> {{False, False}},
				PreWashMixType -> {{Invert, Invert}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPreWashMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPreWashResuspensionOptions","PreWashResuspension and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreWashResuspension -> {{False, False}},
				PreWashResuspensionTemperature -> {{Ambient, Ambient}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPreWashResuspensionOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPreWashResuspensionMixOptions","PreWashResuspensionMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreWashResuspensionMix -> {{False, False}},
				PreWashResuspensionMixType -> {{Pipette, Pipette}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPreWashResuspensionMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingActivationOptions","Activation and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				Activate -> {{False, False}},
				ActivationTemperature -> {{Ambient, Ambient}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingActivationOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingActivationMixOptions","ActivationMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ActivationMix -> {{False, False}},
				ActivationMixType -> {{Pipette, Pipette}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingActivationMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostActivationWashOptions","PostActivationWash and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostActivationWash -> {{False, False}},
				PostActivationNumberOfWashes -> {{3, 3}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostActivationWashOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostActivationWashMixOptions","PostActivationWashMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostActivationWashMix -> {{False, False}},
				PostActivationWashMixType -> {{Invert, Invert}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostActivationWashMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostActivationResuspensionOptions","PostActivationResuspension and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostActivationResuspension -> {{False, False}},
				PostActivationResuspensionTemperature -> {{Ambient, Ambient}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostActivationResuspensionOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostActivationResuspensionMixOptions","PostActivationResuspensionMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostActivationResuspensionMix -> {{False, False}},
				PostActivationResuspensionMixType -> {{Pipette, Pipette}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostActivationResuspensionMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"TooManyConjugationBuffers","Both ConjugationReactionBuffer and ConcentratedConjugationReactionBuffer cannot be specified:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ConjugationReactionBuffer -> {Model[Sample,"Milli-Q water"]},
				ConjugationReactionBufferVolume -> {10 Microliter},
				ConcentratedConjugationReactionBuffer ->{Model[Sample,"Milli-Q water"]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::TooManyConjugationBuffers,
				Error::InvalidConjugationDiluentVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"TooManyConjugationBufferOptions","Both ConjugationReactionBuffer and ConcentratedConjugationReactionBuffer related options cannot be specified:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ConjugationReactionBuffer -> {Model[Sample,"Milli-Q water"]},
				ConjugationReactionBufferVolume -> {10 Microliter},
				ConcentratedConjugationReactionBufferDilutionFactor ->{5}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::TooManyConjugationBufferOptions,
				Error::ConflictingConcentratedConjugationBufferOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingConjugationMixOptions","ConjugationMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ConjugationMix -> {False},
				ConjugationMixType -> {Invert}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingConjugationMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingQuenchOptions","QuenchReaction and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				QuenchConjugation -> {False},
				QuenchReagent -> {Model[Sample,StockSolution,"1x PBS from 10X stock"]},
				QuenchReagentVolume->{1 Microliter}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingQuenchOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostConjugationWorkupOptions","PostConjugationWorkup and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationWorkup -> {False},
				PostConjugationWorkupMethod -> {Pellet}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostConjugationWorkupOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostConjugationWorkupMixOptions","PostConjugationWorkupMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationWorkupMix -> {False},
				PostConjugationWorkupMixType -> {Invert}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostConjugationWorkupMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostConjugationResuspensionOptions","PostConjugationResuspension and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationResuspension -> {False},
				PostConjugationResuspensionMix -> {True}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostConjugationResuspensionOptions,
				Error::InvalidPostConjugationResuspensionMixVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostConjugationResuspensionMixOptions","PostConjugationResuspensionMix and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension -> {True},
				PostConjugationResuspensionMix -> {False},
				PostConjugationResuspensionMixType->{Invert}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostConjugationResuspensionMixOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"ConflictingPostConjugationMixUntilDissolvedOptions","PostConjugationResuspensionMixUntilDissolved and related options cannot conflict:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationResuspensionMixUntilDissolved -> {False},
				PostConjugationResuspensionMaxNumberOfMixes -> {5}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::ConflictingPostConjugationMixUntilDissolvedOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidPreWashOptions","PreWash related master switches cannot be True when PreWash->False:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreWash -> {{False,False}},
				PreWashMix -> {{True,True}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidPreWashOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidActivateOptions","Activate related master switches cannot be True when Activate->False:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				Activate -> {{False,False}},
				ActivationMix -> {{True,True}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidActivateOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidActivationReagentVolumes","ActivationReagentVolume can be calculated from reagent sample analytes or composition:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ActivationReagent->{{Model[Sample,StockSolution,"1x PBS from 10X stock"],Null}},
				ActivationReagentVolume->{{Null,Null}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidActivationReagentVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidActivationDiluentVolumes","ActivationDiluentVolumes are valid volumes:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample,StockSolution,"1x PBS from 10X stock"],Null}},
				ActivationReagentVolume->{{100 Microliter,Null}},
				ActivationDiluent->{{Model[Sample,StockSolution,"1x PBS from 10X stock"],Null}},
				ActivationDiluentVolume->{{Null,Null}}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidActivationDiluentVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidConjugationBufferVolumes","ConjugationBufferVolumes are valid volumes:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ConjugationReactionBuffer->{Model[Sample,StockSolution,"1x PBS from 10X stock"]},
				ConjugationReactionBufferVolume->{Null}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidConjugationBufferVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidConjugationMixVolumes","ConjugationMixVolumes are valid volumes and less than the total ConjugationReactionVolume:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ConjugationMixType->{Pipette},
				ConjugationMixVolume->{10 Milliliter}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidConjugationMixVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidQuenchReagentVolumes","QuenchReagentVolumes are valid volumes:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				QuenchReagent->{Model[Sample,StockSolution,"1x PBS from 10X stock"]},
				QuenchReagentVolume->{Null}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidQuenchReagentVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidQuenchMixVolumes","QuenchMixVolumes are valid volumes and less than the total QuenchReactionVolume:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				QuenchReagent->{Model[Sample,StockSolution,"1x PBS from 10X stock"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchMixVolume->{10 Milliliter}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidQuenchMixVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidQuenchingOptions","Quenching related master switches cannot be True when QuenchConjugation->False:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				QuenchConjugation->{False},
				QuenchMix->{True}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidQuenchingOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidPostConjugationOptions","PostConjugationWorkup related master switches cannot be True when PostConjugationWorkup->False:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationWorkup->{False},
				PostConjugationWorkupMix->{True}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidPostConjugationOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidPostConjugationResuspensionDiluentVolumes","PostConjugationResuspensionDiluentVolumes are valid volumes:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationResuspensionDiluent->{Model[Sample,StockSolution,"1x PBS from 10X stock"]},
				PostConjugationResuspensionDiluentVolume->{Null}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidPostConjugationResuspensionDiluentVolumes,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidPostConjugationResuspensionMixVolumes","PostConjugationResuspensionMixVolumes are valid volumes and less than the PostConjugationResuspensionDiluentVolume:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,StockSolution,"1x PBS from 10X stock"]},
				PostConjugationResuspensionDiluentVolume->{10 Microliter},
				PostConjugationResuspensionMixVolume->{100 Microliter}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidPostConjugationResuspensionMixVolumes,
				Error::InvalidPostConjugationOptions,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidSampleAnalyteConcentrations","Analytes can be identified in conjugation samples:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample Null identity model"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]}
			], { Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			ObjectP[],
			Messages:>{
				Warning::InvalidSampleAnalyteConcentrations
			},
			TimeConstraint->1000
		],
		Example[{Messages,"InvalidReactionVessel","Reaction vessel can accommodate the conjugation reaction and any subsequent quenching or workup:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationReactionBufferVolume->{2 Milliliter},
				ReactionVessel->{Model[Container,Vessel,"2mL Tube"]}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
			$Failed,
			Messages:>{
				Error::InvalidReactionVessel,
				Error::InvalidOption
			},
			TimeConstraint->1000
		],
		Example[{Messages,"UnknownReactantsStoichiometry","The reactant stoichiometric coefficients for the conjugation reaction are provided:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ProductStoichiometricCoefficient->{1}
			], {Warning::InvalidSampleAnalyteConcentrations}],
			ObjectP[],
			Messages:>{
				Warning::UnknownReactantsStoichiometry
			},
			TimeConstraint->1000
		],
		Example[{Messages,"UnknownProductStoichiometry","The product stoichiometric coefficients for the conjugation reaction are provided:"},
			Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}}
			], {Warning::InvalidSampleAnalyteConcentrations}],
			ObjectP[],
			Messages:>{
				Warning::UnknownProductStoichiometry
			},
			TimeConstraint->1000
		],

				(*===Options tests===*)
		Example[{Options,ReactionChemistry,"Specify the type of conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ReactionChemistry->{NHSester},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ReactionChemistry],
			{NHSester},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ExpectedYield,"Specify the expected yield of the conjugation product:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ExpectedYield->{100 Percent},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ExpectedYield],
			{100 Percent},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ProcessingOrder,"Specify the order in which the samples should be processed:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ProcessingOrder->Serial,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ProcessingOrder],
			Serial,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ProcessingBatchSize,"Specify the number of samples in each batch when ProcessingOrder->Batch:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ProcessingOrder->Batch,
				ProcessingBatchSize->1,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ProcessingBatchSize],
			1,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ProcessingBatches,"Specify the samples for each batch:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ProcessingOrder->Batch,
				ProcessingBatches->{
					{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				}
				},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ProcessingBatches],
			{
				{
					{ObjectP[{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID]}], ObjectP[{Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}]}
				}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ReactionVessel,"Specify the container in which the conjugation will occur:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ReactionVessel->{Model[Container,Vessel,"50mL Tube"]},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ReactionVessel],
			{ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ReactantsStoichiometricCoefficients,"Specify the number of reactant molecules that participate in the balanced conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ReactantsStoichiometricCoefficients],
			{{1,1}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ProductStoichiometricCoefficient,"Specify the number of conjugated molecules created by reaction of input molecules at the ratio indicated by ReactantsStoichiometricCoefficients:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ProductStoichiometricCoefficient],
			{1},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWash,"Specify that the samples should be PreWashed using the corresponding options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMethod->{{Null,Pellet}},
				PreWashNumberOfWashes->{{Null,1}},
				PreWashTime->{{Null,5 Minute}},
				PreWashTemperature->{{Null,Ambient}},
				PreWashBuffer->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashBufferVolume->{{Null,500 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PreWash,PreWashMethod,PreWashNumberOfWashes,PreWashTime,PreWashTemperature,PreWashBuffer,PreWashBufferVolume}],
			{
				{{False,True}},
				{{Null,Pellet}},
				{{Null,1}},
				{{Null,5 Minute}},
				{{Null,Ambient}},
				{{Null,ObjectP[Model[Sample,"Milli-Q water"]]}},
				{{Null,500 Microliter}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashMethod,"Specify the pre-wash method that should be used:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMethod->{{Null,Pellet}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashMethod],
			{{Null,Pellet}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashMagnetizationRack,"Specify the magnetized rack that the source/intermediate container will be placed in during the PreWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMethod -> {{Null,Magnetic}},
				PreWashMagnetizationRack -> {{Null,Model[Container, Rack, "DynaMag Magnet 2mL Tube Rack"]}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations,Error::MagnetizationOptionsMismatch,Error::InvalidOption}];
			Lookup[options,PreWashMagnetizationRack],
			{{Null,ObjectP[Model[Container, Rack, "DynaMag Magnet 2mL Tube Rack"]]}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashNumberOfWashes,"Specify the number of pre-wash that should be used:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashNumberOfWashes->{{Null,1}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashNumberOfWashes],
			{{Null,1}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashTime,"Specify the how long the sample should be pre-washed:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashTime->{{Null,5 Minute}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashTime],
			{{Null,5 Minute}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashTemperature,"Specify the temperature that the sample is held at during the PreWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashTemperature->{{Null,30*Celsius}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashTemperature],
			{{Null,30*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashBuffer,"Specify the reagent used to wash the sample prior to activation or conjugation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashBuffer->{{Null,Model[Sample,"Milli-Q water"]}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashBuffer],
			{{Null,ObjectP[Model[Sample,"Milli-Q water"]]}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashBufferVolume,"Specify the volume of the reagent used to wash the sample prior to activation or conjugation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashBuffer->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashBufferVolume->{{Null,500*Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashBufferVolume],
			{{Null,500*Microliter}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashCentrifugationIntensity,"Specify the gravitational force during the pre-wash centrifugation process:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashCentrifugationIntensity -> {{Null,805.14 GravitationalAcceleration}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::CentrifugePrecision}];
			Lookup[options,PreWashCentrifugationIntensity],
			{{Null,805.14 GravitationalAcceleration}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashCentrifugationTime,"Specify the duration the pre-wash centrifugation will last:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashCentrifugationTime -> {{Null, 1 Minute}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashCentrifugationTime],
			{{Null,1 Minute}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashCentrifugationTemperature,"Specify the temperature used for the pre-wash centrifugation process:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashCentrifugationTemperature -> {{Null, 30 Celsius}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashCentrifugationTemperature],
			{{Null,30 Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashMix,"Specify that the samples should be mixed with PreWashBuffer:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMix->{{False,True}},
				PreWashMixType->{{Null,Pipette}},
				PreWashMixVolume->{{Null,100 Microliter}},
				PreWashNumberOfMixes->{{Null,3}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PreWashMix,PreWashMixType,PreWashMixVolume,PreWashNumberOfMixes}],
			{
				{{False,True}},
				{{Null,Pipette}},
				{{Null,100 Microliter}},
				{{Null,3}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],

		Example[{Options,PreWashMixType,"Specify the method that should be used to mix the sample with PreWashBuffer:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMix->{{False,True}},
				PreWashMixType->{{Null,Pipette}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashMixType],
			{{Null,Pipette}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashMixVolume,"Specify the volume used to mix the samples by pipetting after dispensing of the PreWashBuffer:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMix->{{False,True}},
				PreWashMixType->{{Null,Pipette}},
				PreWashMixVolume->{{Null,100 Microliter}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashMixVolume],
			{{Null,100 Microliter}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashNumberOfMixes,"Specify the number of times that the samples should be mixed with the PreWashBuffer:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMix->{{False,True}},
				PreWashMixType->{{Null,Pipette}},
				PreWashMixVolume->{{Null,100 Microliter}},
				PreWashNumberOfMixes->{{Null,3}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashNumberOfMixes],
			{{Null,3}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashMixRate,"Specify the intensity at which the sample and wash buffer are mixed during incubation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashMix->{{False,True}},
				PreWashMixType->{{Null,Vortex}},
				PreWashMixRate->{{Null,5000*RPM}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashMixRate],
			{{Null,5000*RPM}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFiltrationType,"Specify the PreWashFiltrationType option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFiltrationType],
			{{PeristalticPump,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashInstrument,"Specify the PreWashInstrument option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				PreWashInstrument->{{Model[Instrument,PeristalticPump,"VWR Peristaltic Variable Pump PP3400"],Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashInstrument],
			{{ObjectP[Model[Instrument,PeristalticPump,"VWR Peristaltic Variable Pump PP3400"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFilter,"Specify the PreWashFilter option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				PreWashFilter->{{Model[Item,Filter,"id:jLq9jXvZjMXz"],Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFilter],
			{{ObjectP[Model[Item,Filter,"id:jLq9jXvZjMXz"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFilterStorageCondition,"Specify the PreWashFilterStorageCondition option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				PreWashFilterStorageCondition->Disposal,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFilterStorageCondition],
			Disposal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFilterMembraneMaterial,"Specify the PreWashFilterMembraneMaterial option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				PreWashFilterMembraneMaterial->{{PES,Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFilterMembraneMaterial],
			{{PES,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFilterPoreSize,"Specify the PreWashFilterPoreSize option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				PreWashFilterPoreSize->{{0.45*Micrometer,Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFilterPoreSize],
			{{0.45*Micrometer,Null}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashPrefilterMembraneMaterial,"Specify the PreWashPrefilterMembraneMaterial option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{Syringe,Automatic}},
				PreWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PreWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				PreWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashPrefilterMembraneMaterial],
			{{GxF,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashPrefilterPoreSize,"Specify the PreWashPrefilterPoreSize option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{Syringe,Automatic}},
				PreWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PreWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				PreWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashPrefilterPoreSize],
			{{1.*Micrometer,Null}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFiltrationSyringe,"Specify the PreWashFiltrationSyringe option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{Syringe,Automatic}},
				PreWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PreWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				PreWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				PreWashFiltrationSyringe->{{Model[Container,Syringe,"id:4pO6dMWvnn7z"],Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations,Error::VolumeTooLargeForSyringe,Error::InvalidOption}];
			Lookup[options,PreWashFiltrationSyringe],
			{{ObjectP[Model[Container,Syringe,"id:4pO6dMWvnn7z"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashSterileFiltration,"Specify the PreWashSterileFiltration option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashSterileFiltration->{{True,False}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashSterileFiltration],
			{{True,False}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFilterHousing,"Specify the PreWashFilterHousing option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFiltrationType->{{PeristalticPump,Automatic}},
				PreWashFilterHousing->{{Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFilterHousing],
			{{ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashFilterMolecularWeightCutoff,"Specify the PreWashFilterMolecularWeightCutoff option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactionVessel->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{True,False}},
				PreWashFilter->{{Model[Container,Vessel,Filter,"Centrifuge Filter, PES, 100K MWCO, 0.5mL filter"],Automatic}},
				PreWashFilterMolecularWeightCutoff->{{100*Kilogram/Mole,Automatic}},
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashFilterMolecularWeightCutoff],
			{{100*Kilogram/Mole,Null}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],

		Example[{Options,PreWashResuspension,"Specify that the samples should be resuspened after washing when PreWash->True:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionTime->{{Null,5 Minute}},
				PreWashResuspensionTemperature->{{Null,Ambient}},
				PreWashResuspensionDiluent->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashResuspensionDiluentVolume->{{Null,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PreWashResuspension,PreWashResuspensionTime,PreWashResuspensionTemperature,PreWashResuspensionDiluent,PreWashResuspensionDiluentVolume}],
			{
				{{False,True}},
				{{Null,5 Minute}},
				{{Null,Ambient}},
				{{Null,ObjectP[Model[Sample,"Milli-Q water"]]}},
				{{Null,100 Microliter}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionTime,"Specify the duration for the resuspension after the sample pre-wash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionTime->{{Null,5 Minute}},
				PreWashResuspensionTemperature->{{Null,Ambient}},
				PreWashResuspensionDiluent->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashResuspensionDiluentVolume->{{Null,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionTime],
			{{Null,5 Minute}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionTemperature,"Specify the temperature for the resuspension after the sample pre-wash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionTime->{{Null,5 Minute}},
				PreWashResuspensionTemperature->{{Null,Ambient}},
				PreWashResuspensionDiluent->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashResuspensionDiluentVolume->{{Null,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionTemperature],
			{{Null,Ambient}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionDiluent,"Specify the solution used to dilute the sample for the resuspension after the sample pre-wash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionTime->{{Null,5 Minute}},
				PreWashResuspensionTemperature->{{Null,Ambient}},
				PreWashResuspensionDiluent->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashResuspensionDiluentVolume->{{Null,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionDiluent],
			{{Null,ObjectP[Model[Sample,"Milli-Q water"]]}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionDiluentVolume,"Specify the solution volume used to dilute the sample for the resuspension after the sample pre-wash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionTime->{{Null,5 Minute}},
				PreWashResuspensionTemperature->{{Null,Ambient}},
				PreWashResuspensionDiluent->{{Null,Model[Sample,"Milli-Q water"]}},
				PreWashResuspensionDiluentVolume->{{Null,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionDiluentVolume],
			{{Null,100 Microliter}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionMix,"Specify that the samples should be mixed during PreWashResuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionMix->{{Null,True}},
				PreWashResuspensionMixType->{{Null,Pipette}},
				PreWashResuspensionMixVolume->{{Null,10 Microliter}},
				PreWashResuspensionNumberOfMixes->{{Null,10}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PreWashResuspensionMix,PreWashResuspensionMixType,PreWashResuspensionMixVolume,PreWashResuspensionNumberOfMixes}],
			{
				{{Null,True}},
				{{Null,Pipette}},
				{{Null,10 Microliter}},
				{{Null,10}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionMixType,"Specify the method used to mix the samples for PreWashResuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionMix->{{Null,True}},
				PreWashResuspensionMixType->{{Null,Pipette}},
				PreWashResuspensionMixVolume->{{Null,10 Microliter}},
				PreWashResuspensionNumberOfMixes->{{Null,10}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionMixType],
			{{Null,Pipette}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionMixVolume,"Specify the volume of the sample that will be mixed in each mixing cycle for PreWashResuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionMix->{{Null,True}},
				PreWashResuspensionMixType->{{Null,Pipette}},
				PreWashResuspensionMixVolume->{{Null,10 Microliter}},
				PreWashResuspensionNumberOfMixes->{{Null,10}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionMixVolume],
			{{Null,10 Microliter}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionNumberOfMixes,"Specify the number of cycles of the sample that will be mixed for PreWashResuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionMix->{{Null,True}},
				PreWashResuspensionMixType->{{Null,Pipette}},
				PreWashResuspensionMixVolume->{{Null,10 Microliter}},
				PreWashResuspensionNumberOfMixes->{{Null,10}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionNumberOfMixes],
			{{Null,10}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PreWashResuspensionMixRate,"Specify the mixing speed at which sample that will be mixed for PreWashResuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PreWash->{{False,True}},
				PreWashResuspension->{{False,True}},
				PreWashResuspensionMix->{{Null,True}},
				PreWashResuspensionMixType->{{Null,Vortex}},
				PreWashResuspensionMixRate->{{Null,800 RPM}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PreWashResuspensionMixRate],
			{{Null,800 RPM}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,Activate,"Specify that the desired samples should be activated prior to conjugation using the corresponding options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{Activate,ActivationReactionVolume,ActivationSampleVolume,ActivationReagent,ActivationReagentVolume,ActivationContainer,ActivationTime,ActivationTemperature}],
			{
				{{True,False}},
				{{110 Microliter,Null}},
				{{100 Microliter,Null}},
				{{ObjectP[Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"]],Null}},
				{{10 Microliter,Null}},
				{{ObjectP[Model[Container,Vessel,"2mL Tube"]],Null}},
				{{1Hour,Null}},
				{{Ambient,Null}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationReactionVolume,"Specify the total volume of the activation reaction including ActivationSampleVolume, ActivationReagentVolume, and ActivationDiluentVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationReactionVolume],
			{{110 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationSampleVolume,"Specify the volume of each conjugation sample that is used in the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationSampleVolume],
			{{100 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,TargetActivationSampleConcentration,"Specify the desired concentration of each conjugation sample in the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{50 Microliter,Null}},
				TargetActivationSampleConcentration->{{1 Milligram/Milliliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				TargetActivationReagentConcentration->{{1 Milligram/Milliliter,Null}},
				ActivationDiluent->{{Model[Sample, "Milli-Q water"],Null}},
				ActivationDiluentVolume->{{50 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,TargetActivationSampleConcentration],
			{{1 Milligram/Milliliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationReagent,"Specify the reagent that activates or modifies functional groups on the corresponding sample in preparation for conjugation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationReagent],
			{{ObjectP[Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationReagentVolume,"Specify the volume of the ActivationReagent that is used in the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationReagentVolume],
			{{10 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,TargetActivationReagentConcentration,"Specify the desired concentration of ActivationReagent in the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{50 Microliter,Null}},
				TargetActivationSampleConcentration->{{1 Milligram/Milliliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				TargetActivationReagentConcentration->{{1 Milligram/Milliliter,Null}},
				ActivationDiluent->{{Model[Sample, "Milli-Q water"],Null}},
				ActivationDiluentVolume->{{50 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,TargetActivationReagentConcentration],
			{{1 Milligram/Milliliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationDiluent,"Specify the reagent used to dilute the ActivationSampleVolume + ActivationReagentVolume to the final ActivationReactionVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{50 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationDiluent->{{Model[Sample, "Milli-Q water"],Null}},
				ActivationDiluentVolume->{{50 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationDiluent],
			{{ObjectP[Model[Sample, "Milli-Q water"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationDiluentVolume,"Specify the volume of the ActivationDiluent that is used in the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{50 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationDiluent->{{Model[Sample, "Milli-Q water"],Null}},
				ActivationDiluentVolume->{{50 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationDiluentVolume],
			{{50 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationContainer,"Specify the containers in which each sample is activated by mixing and incubation with ActivationReagent and ActivationDiluent:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationContainer],
			{{ObjectP[Model[Container,Vessel,"2mL Tube"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationTime,"Specify the duration of the activation reaction incubation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationTime],
			{{1Hour,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationTemperature,"Specify the temperature the sample is held at during the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationContainer->{{Model[Container,Vessel,"2mL Tube"],Null}},
				ActivationTime->{{1 Hour,Null}},
				ActivationTemperature->{{Ambient,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationTemperature],
			{{Ambient,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationMix,"Specify that the samples should be mixed with ActivationReagent:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationMix->{{True,False}},
				ActivationMixType->{{Pipette,Null}},
				ActivationMixVolume->{{50 Microliter,Null}},
				ActivationNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{ActivationMix,ActivationMixType,ActivationMixVolume,ActivationNumberOfMixes}],
			{
				{{True,False}},
				{{Pipette,Null}},
				{{50 Microliter,Null}},
				{{3,Null}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationMixType,"Specify the method used to mix the activation reaction before or during incubation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationMix->{{True,False}},
				ActivationMixType->{{Pipette,Null}},
				ActivationMixVolume->{{50 Microliter,Null}},
				ActivationNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationMixType],
			{{Pipette,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationMixVolume,"Specify the volume used to mix the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationMix->{{True,False}},
				ActivationMixType->{{Pipette,Null}},
				ActivationMixVolume->{{50 Microliter,Null}},
				ActivationNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationMixVolume],
			{{50 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationNumberOfMixes,"Specify the number of aspirate and dispense cycles or inversion cycles used to mix the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationMix->{{True,False}},
				ActivationMixType->{{Pipette,Null}},
				ActivationMixVolume->{{50 Microliter,Null}},
				ActivationNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationNumberOfMixes],
			{{3,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationMixRate,"Specify the rate at which the activation reaction is mixed during incubation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationMix->{{True,False}},
				ActivationMixType->{{Vortex,Null}},
				ActivationMixRate->{{800 RPM,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationMixRate],
			{{800 RPM,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWash,"Specify that the samples should be washed after Activation using the corresponding options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWash],
			{
				{True,False}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashMethod,"Specify the method that the samples should be washed after Activation using the corresponding options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashMethod],
			{
				{Pellet,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationNumberOfWashes,"Specify the number of time that the samples should be washed after activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationNumberOfWashes],
			{
				{1,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashTime,"Specify the time that the samples should be incubated during washing:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashTime],
			{
				{5 Minute,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashTemperature,"Specify the temperature that the samples should be hold during the post-activatoin wash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashTemperature],
			{
				{Ambient,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashBuffer,"Specify the reagent used to wash the samples after activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashBuffer],
			{
				{ObjectP[Model[Sample,"Milli-Q water"]],Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashBufferVolume,"Specify the volume of the buffer used to wash the sample after the activation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashBufferVolume],
			{
				{500 Microliter,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],


		Example[{Options,PostActivationWashMix,"Specify that the samples should be mixed during PostActivationWash according to the corresponding options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				PostActivationWashMix->{{True,False}},
				PostActivationWashMixType->{{Pipette,Null}},
				PostActivationWashMixVolume->{{250 Microliter,Null}},
				PostActivationWashNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostActivationWashMix,PostActivationWashMixType,PostActivationWashMixVolume,PostActivationWashNumberOfMixes}],
			{
				{{True,False}},
				{{Pipette,Null}},
				{{250 Microliter,Null}},
				{{3,Null}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashMixType,"Specify the method that the samples should be mixed during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				PostActivationWashMix->{{True,False}},
				PostActivationWashMixType->{{Pipette,Null}},
				PostActivationWashMixVolume->{{250 Microliter,Null}},
				PostActivationWashNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashMixType],
			{
				{Pipette,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashMixVolume,"Specify the volume used to mix the samples by pipetting during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				PostActivationWashMix->{{True,False}},
				PostActivationWashMixType->{{Pipette,Null}},
				PostActivationWashMixVolume->{{250 Microliter,Null}},
				PostActivationWashNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashMixVolume],
			{
				{250 Microliter,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashNumberOfMixes,"Specify the number of aspirate and dispense cycles or inversion cycles used to mix the samples during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				PostActivationWashMix->{{True,False}},
				PostActivationWashMixType->{{Pipette,Null}},
				PostActivationWashMixVolume->{{250 Microliter,Null}},
				PostActivationWashNumberOfMixes->{{3,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashNumberOfMixes],
			{
				{3,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashMixRate,"Specify the rate at which the samples should be mixed during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationNumberOfWashes->{{1,Null}},
				PostActivationWashTime->{{5 Minute,Null}},
				PostActivationWashTemperature->{{Ambient,Null}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				PostActivationWashMix->{{True,False}},
				PostActivationWashMixType->{{Stir,Null}},
				PostActivationWashMixRate->{{250 RPM,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashMixRate],
			{
				{250 RPM,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashInstrument,"Specify the instrument that should be used to perform PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashInstrument->{{Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],Automatic}},
				PostActivationWashBuffer->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationWashBufferVolume->{{500 Microliter,Null}},
				PostActivationWashMix->{{True,False}},
				PostActivationWashMixType->{{Stir,Null}},
				PostActivationWashMixRate->{{250 RPM,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashInstrument],
			{
				{ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],

		Example[{Options,PostActivationWashFilter,"Specify the filter that should be used to remove impurities from the sample during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFilter->{{Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 0.5mL filter"], Automatic}},
				PostActivationWashFilterMolecularWeightCutoff->{{100*Kilogram/Mole,Automatic}},
				PostActivationWashFilterStorageCondition->{{AmbientStorage,Disposal}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFilter],
			{
				{ObjectP[Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 0.5mL filter"]],Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFilterStorageCondition,"Specify the conditions under which the filter should be stored after the PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFilter->{{Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 0.5mL filter"], Automatic}},
				PostActivationWashFilterMolecularWeightCutoff->{{100*Kilogram/Mole,Automatic}},
				PostActivationWashFilterStorageCondition->{{AmbientStorage,Disposal}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFilterStorageCondition],
			{
				{AmbientStorage,Disposal}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashMagnetizationRack,"Specify the PostActivationWashMagnetizationRack option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Magnetic,Null}},
				PostActivationWashMagnetizationRack->{{Model[Container,Rack,"DynaMag Magnet 2mL Tube Rack"],Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashMagnetizationRack],
			{{ObjectP[Model[Container,Rack,"DynaMag Magnet 2mL Tube Rack"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFiltrationType,"Specify the PostActivationWashFiltrationType option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{Syringe,Automatic}},
				PostActivationWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PostActivationWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				PostActivationWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFiltrationType],
			{
				{Syringe,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFilterMembraneMaterial,"Specify the material of the filter that should be used to remove impurities from the sample during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{Syringe,Automatic}},
				PostActivationWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PostActivationWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				PostActivationWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFilterMembraneMaterial],
			{
				{PTFE,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashPrefilterMembraneMaterial,"Specify the material of the filter that should be used to for pre-filtration during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{Syringe,Automatic}},
				PostActivationWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PostActivationWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				PostActivationWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashPrefilterMembraneMaterial],
			{
				{GxF,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFilterPoreSize,"Specify the pore size of the filter that should be used to remove impurities from the sample during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{Syringe,Automatic}},
				PostActivationWashFilterPoreSize->{{0.22*Micrometer,Null}},
				PostActivationWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PostActivationWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				PostActivationWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFilterPoreSize],
			{
				{0.22*Micrometer,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFilterMolecularWeightCutoff,"Specify the molecular weight cutoff of the filter that should be used to remove impurities from the sample during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFilter->{{Model[Container, Vessel, Filter, "Centrifuge Filter, PES, 100K MWCO, 0.5mL filter"], Automatic}},
				PostActivationWashFilterMolecularWeightCutoff->{{100*Kilogram/Mole,Automatic}},
				PostActivationWashFilterStorageCondition->{{AmbientStorage,Disposal}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFilterMolecularWeightCutoff],
			{
				{100.*Kilogram/Mole,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashPrefilterPoreSize,"Specify the pore size of the filter for the pre-filtration during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{Syringe,Automatic}},
				PostActivationWashFilterPoreSize->{{0.22*Micrometer,Null}},
				PostActivationWashFilterMembraneMaterial->{{PTFE,Automatic}},
				PostActivationWashPrefilterMembraneMaterial->{{GxF,Automatic}},
				PostActivationWashPrefilterPoreSize->{{1.*Micrometer,Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashPrefilterPoreSize],
			{
				{1.*Micrometer,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFiltrationSyringe,"Specify the syringe used for filtration during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{Syringe,Automatic}},
				PostActivationWashFiltrationSyringe->{{Model[Container,Syringe,"id:4pO6dMWvnn7z"],Automatic}},
				PostActivationWashFilterMembraneMaterial->{{PTFE,Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFiltrationSyringe],
			{
				{ObjectP[Model[Container,Syringe,"id:4pO6dMWvnn7z"]],Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashSterileFiltration,"Specify the PostActivationWashSterileFiltration option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashSterileFiltration->{{True,False}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashSterileFiltration],
			{
				{True,False}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashFilterHousing,"Specify the PostActivationWashFilterHousing option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 3"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Filter,Null}},
				PostActivationWashFiltrationType->{{PeristalticPump,Automatic}},
				PostActivationWashFilterHousing->{{Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],Automatic}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationWashFilterHousing],
			{
				{ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashCentrifugationIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationWashCentrifugationIntensity->{{805.14 GravitationalAcceleration,Null}},
				PostActivationWashCentrifugationTime->{{1 Minute,Null}},
				PostActivationWashCentrifugationTemperature->{{30 Celsius,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::CentrifugePrecision}];
			Lookup[options,PostActivationWashCentrifugationIntensity],
			{{805.14 GravitationalAcceleration,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashCentrifugationTime,"Specify the amount of time for which the samples will be centrifuged during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationWashCentrifugationIntensity->{{805.14 GravitationalAcceleration,Null}},
				PostActivationWashCentrifugationTime->{{1 Minute,Null}},
				PostActivationWashCentrifugationTemperature->{{30 Celsius,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::CentrifugePrecision}];
			Lookup[options,PostActivationWashCentrifugationTime],
			{{1 Minute,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationWashCentrifugationTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during PostActivationWash:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationWashCentrifugationIntensity->{{805.14 GravitationalAcceleration,Null}},
				PostActivationWashCentrifugationTime->{{1 Minute,Null}},
				PostActivationWashCentrifugationTemperature->{{30 Celsius,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::CentrifugePrecision}];
			Lookup[options,PostActivationWashCentrifugationTemperature],
			{{30 Celsius,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspension,"Specify that the samples should be resuspended after PostActivationWash according to the corresponding options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostActivationResuspension,PostActivationResuspensionTime,PostActivationResuspensionTemperature,PostActivationResuspensionDiluent,PostActivationResuspensionDiluentVolume}],
			{
				{{True,False}},
				{{5 Minute,Null}},
				{{Ambient,Null}},
				{{ObjectP[Model[Sample,"Milli-Q water"]],Null}},
				{{100 Microliter,Null}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionTime,"Specify the duration of PostActivationResuspension incubation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionTime],
			{{5 Minute,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionTemperature,"Specify the temperature the sample is held at during the PostActivationResuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionTemperature],
			{{Ambient,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionDiluent,"Specify the reagent used to resuspend the sample after the PostActivationWash complete:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionDiluent],
			{{ObjectP[Model[Sample,"Milli-Q water"]],Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionDiluentVolume,"Specify the volume of the PostActivationResuspensionDiluent used to resuspend the sample after the PostActivationWash is complete:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionDiluentVolume],
			{{100 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionMix,"Specify that the sample should be mixed after dispensing of the resuspension buffer:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				PostActivationResuspensionMix->{{True,False}},
				PostActivationResuspensionMixType->{{Pipette,Null}},
				PostActivationResuspensionMixVolume->{{10 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostActivationResuspensionMix,PostActivationResuspensionMixType,PostActivationResuspensionMixVolume}],
			{
				{{True,False}},
				{{Pipette,Null}},
				{{10 Microliter,Null}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionMixType,"Specify the method used to resuspend the samples in PostActivationResuspensionDiluent:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				PostActivationResuspensionMix->{{True,False}},
				PostActivationResuspensionMixType->{{Pipette,Null}},
				PostActivationResuspensionMixVolume->{{10 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionMixType],
			{{Pipette,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionMixVolume,"Specify the volume used to mix the samples by pipetting after dispensing of the PostActivationResuspensionDiluent:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				PostActivationResuspensionMix->{{True,False}},
				PostActivationResuspensionMixType->{{Pipette,Null}},
				PostActivationResuspensionMixVolume->{{10 Microliter,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionMixVolume],
			{{10 Microliter,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionNumberOfMixes,"Specify the number of aspirate and dispense cycles or inversion cycles used to mix the sample during resuspension:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				PostActivationResuspensionMix->{{True,False}},
				PostActivationResuspensionMixType->{{Pipette,Null}},
				PostActivationResuspensionMixVolume->{{10 Microliter,Null}},
				PostActivationResuspensionNumberOfMixes->{{10,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostActivationResuspensionNumberOfMixes],
			{{10,Null}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostActivationResuspensionMixRate,"Specify the rate at which the sample and PostActivationResuspensionDiluent are mixed during incubation:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				PostActivationWash->{{True,False}},
				PostActivationWashMethod->{{Pellet,Null}},
				PostActivationResuspension->{{True,False}},
				PostActivationResuspensionTime->{{5Minute,Null}},
				PostActivationResuspensionTemperature->{{Ambient,Null}},
				PostActivationResuspensionDiluent->{{Model[Sample,"Milli-Q water"],Null}},
				PostActivationResuspensionDiluentVolume->{{100 Microliter,Null}},
				PostActivationResuspensionMix->{{True,False}},
				PostActivationResuspensionMixType->{{Vortex,Null}},
				PostActivationResuspensionMixRate->{{800 RPM,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostActivationResuspensionMix,PostActivationResuspensionMixType,PostActivationResuspensionMixRate}],
			{
				{{True,False}},
				{{Vortex,Null}},
				{{800 RPM,Null}}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ActivationSamplesOutStorageCondition,"Specify the storage condition of activated samples:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				Activate->{{True,False}},
				ActivationReactionVolume->{{110 Microliter,Null}},
				ActivationSampleVolume->{{100 Microliter,Null}},
				ActivationReagent->{{Model[Sample, "Alexa Fluor 488 Lightning Link Conjugation Modifier"],Null}},
				ActivationReagentVolume->{{10 Microliter,Null}},
				ActivationSamplesOutStorageCondition->{{Refrigerator,Null}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ActivationSamplesOutStorageCondition],
			{
				{Refrigerator,Null}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationReactionVolume,"Specify the total ConjugationReactionVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationReactionVolume],
			{200 Microliter},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationAmount,"Specify the amount of each sample to add to the conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationAmount],
			{{100 Microliter,100 Microliter}},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,TargetConjugationSampleConcentration,"Specify the TargetConjugationSampleConcentration option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				TargetConjugationSampleConcentration->100*Micromolar,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,TargetConjugationSampleConcentration],
			100*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConcentratedConjugationReactionBuffer,"Specify the ConcentratedConjugationReactionBuffer option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConcentratedConjugationReactionBuffer],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConcentratedConjugationReactionBufferDilutionFactor,"Specify the ConcentratedConjugationReactionBufferDilutionFactor option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				ConcentratedConjugationReactionBufferDilutionFactor->1,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConcentratedConjugationReactionBufferDilutionFactor],
			1,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationDiluentVolume,"Specify the ConjugationDiluentVolume option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationDiluentVolume],
			10*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationReactionBufferDiluent,"Specify the ConjugationReactionBufferDiluent option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				ConjugationReactionBufferDiluent->Model[Sample,StockSolution,"1x PBS from 10X stock"],
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationReactionBufferDiluent],
			ObjectP[Model[Sample,StockSolution,"1x PBS from 10X stock"]],
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationMixType,"Specify the ConjugationMixType option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				ConjugationMixType->Pipette,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationMixType],
			Pipette,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationMixVolume,"Specify the ConjugationMixVolume option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				ConjugationMixType->Pipette,
				ConjugationMixVolume->100*Microliter,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationMixVolume],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationNumberOfMixes,"Specify the ConjugationNumberOfMixes option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				ConjugationMixType->Pipette,
				ConjugationNumberOfMixes->5,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationNumberOfMixes],
			5,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationMixRate,"Specify the ConjugationMixRate option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConcentratedConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationDiluentVolume->10*Microliter,
				ConjugationMixType->Vortex,
				ConjugationMixRate->800*RPM,
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationMixRate],
			800*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationReactionBuffer,"Specify the buffer sample to add to the conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationReactionBuffer],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationReactionBufferVolume,"Specify the volume of buffer sample to add to the conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationReactionVolume->{200 Microliter},
				ConjugationAmount->{{100 Microliter,50 Microliter}},
				ConjugationReactionBuffer->{Model[Sample,"Milli-Q water"]},
				ConjugationReactionBufferVolume->{50 Microliter},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationReactionBufferVolume],
			{50 Microliter},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationTime,"Specify the incubationtime for the conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationTime->{18 Hour},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationTime],
			{18 Hour},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationTemperature,"Specify the incubation temperature for the conjugation reaction:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationTemperature->{4 Celsius},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,ConjugationTemperature],
			{4 Celsius},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,ConjugationMix,"Mix the conjugation reaction according to the desired options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationMix->{True},
				ConjugationMixType->{Shake},
				ConjugationMixRate->{800 RPM},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{ConjugationMixType,ConjugationMixRate}],
			{
				{Shake},
				{800 RPM}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchConjugation,"Stop the conjugation reaction after the desired incubation by adding quench reagents:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{QuenchConjugation,QuenchReactionVolume,QuenchReagent,QuenchReagentVolume,QuenchTime,QuenchTemperature}],
			{
				{True},
				{210 Microliter},
				{ObjectP[Model[Sample,"Milli-Q water"]]},
				{10 Microliter},
				{1 Hour},
				{Ambient}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchMix,"Mix the conjugation reaction with quench reagent:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{QuenchMix,QuenchMixType,QuenchMixVolume,QuenchNumberOfMixes}],
			{
				{True},
				{Pipette},
				{100 Microliter},
				{3}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchReactionVolume,"Specify the QuenchReactionVolume option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchReactionVolume],
			{210*Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchReagent,"Specify the QuenchReagent option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchReagent],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchReagentDilutionFactor,"Specify the QuenchReagentDilutionFactor option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				QuenchReagentDilutionFactor->1,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchReagentDilutionFactor],
			1,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchReagentVolume,"Specify the QuenchReagentVolume option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchReagentVolume],
			{10*Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchTime,"Specify the QuenchTime option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{Ambient},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchTime],
			{1*Hour},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchTemperature,"Specify the QuenchTemperature option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{30*Celsius},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchTemperature],
			{30*Celsius},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchMixType,"Specify the QuenchMixType option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{30*Celsius},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchMixType],
			{Pipette},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchMixVolume,"Specify the QuenchMixVolume option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{30*Celsius},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchMixVolume],
			{100*Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchNumberOfMixes,"Specify the QuenchNumberOfMixes option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{30*Celsius},
				QuenchMix->{True},
				QuenchMixType->{Pipette},
				QuenchMixVolume->{100 Microliter},
				QuenchNumberOfMixes->{3},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchNumberOfMixes],
			{3},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,QuenchMixRate,"Specify the QuenchMixRate option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				QuenchReactionVolume->{210 Microliter},
				QuenchReagent->{Model[Sample,"Milli-Q water"]},
				QuenchReagentVolume->{10 Microliter},
				QuenchTime->{1 Hour},
				QuenchTemperature->{30*Celsius},
				QuenchMix->{True},
				QuenchMixType->{Vortex},
				QuenchMixRate->800*RPM,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,QuenchMixRate],
			800*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainReactionMixture,"Specify the PredrainReactionMixture option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainReactionMixture],
			True,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainMethod,"Specify the PredrainMethod option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Pellet,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainMethod],
			Pellet,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainInstrument,"Specify the PredrainInstrument option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Pellet,
				PredrainInstrument->Model[Instrument,Centrifuge,"id:6V0npvmZ1l3Z"],
				Output->Options
			],{Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainInstrument],
			ObjectP[Model[Instrument,Centrifuge,"id:6V0npvmZ1l3Z"]],
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainCentrifugationIntensity,"Specify the PredrainCentrifugationIntensity option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Pellet,
				PredrainCentrifugationIntensity->1000*RPM,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainCentrifugationIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainCentrifugationTime,"Specify the PredrainCentrifugationTime option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Pellet,
				PredrainCentrifugationTime->5*Minute,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainCentrifugationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainTemperature,"Specify the PredrainTemperature option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Pellet,
				PredrainTemperature->5*Celsius,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainTemperature],
			5*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainMagnetizationRack,"Specify the PredrainMagnetizationRack option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Magnetic,
				PredrainMagnetizationRack->Model[Container,Rack,"DynaMag Magnet 2mL Tube Rack"],
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainMagnetizationRack],
			ObjectP[Model[Container,Rack,"DynaMag Magnet 2mL Tube Rack"]],
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PredrainMagnetizationTime,"Specify the PredrainMagnetizationTime option:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ConjugationAmount->{{100 Microliter,100 Microliter}},
				QuenchConjugation->{True},
				PredrainReactionMixture->True,
				PredrainMethod->Magnetic,
				PredrainMagnetizationTime->15*Second,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PredrainMagnetizationTime],
			15*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkup,"Process the samples after the conjugation reaction according to the desired options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostConjugationWorkup,PostConjugationWorkupMethod,PostConjugationWorkupBuffer,PostConjugationWorkupBufferVolume,PostConjugationWorkupIncubationTime,PostConjugationWorkupIncubationTemperature }],
			{
				{True},
				{Pellet},
				{ObjectP[Model[Sample,"Milli-Q water"]]},
				{100 Microliter},
				{10 Minute},
				{Ambient}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupMethod,"Process the samples after the conjugation reaction, specifying PostConjugationWorkupMethod:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupMethod],
			{Pellet},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupBuffer,"Process the samples after the conjugation reaction, specifiying PostConjugationWorkupBuffer:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupBuffer],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupBufferVolume,"Process the samples after the conjugation reaction, specifying PostConjugationWorkupBufferVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupBufferVolume],
			{100 Microliter},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupIncubationTime,"Process the samples after the conjugation reaction, specifying PostConjugationWorkupIncubationTime:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupIncubationTime],
			{10 Minute},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupIncubationTemperature,"Process the samples after the conjugation reaction, specifying PostConjugationWorkupIncubationTemperature:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupIncubationTemperature],
			{Ambient},
			Variables:>{options},
			TimeConstraint->1000
		],



		Example[{Options,PostConjugationWorkupMix,"Mix the post-conjugation sample and workup buffer according to the desired options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationWorkupMix->{True},
				PostConjugationWorkupMixType->{Shake},
				PostConjugationWorkupMixRate->{800 RPM},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostConjugationWorkupMix,PostConjugationWorkupMixType,PostConjugationWorkupMixRate}],
			{
				{True},
				{Shake},
				{800 RPM}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupMixType,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationWorkupMixType:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationWorkupMix->{True},
				PostConjugationWorkupMixType->{Shake},
				PostConjugationWorkupMixRate->{800 RPM},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupMixType],
			{Shake},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupMixRate,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationWorkupMixRate:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationWorkupMix->{True},
				PostConjugationWorkupMixType->{Shake},
				PostConjugationWorkupMixRate->{800 RPM},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupMixRate],
			{800 RPM},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupMixVolume,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationWorkupMixVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationWorkupMix->{True},
				PostConjugationWorkupMixType->{Pipette},
				PostConjugationWorkupMixVolume->{50 Microliter},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupMixVolume],
			{50 Microliter},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupNumberOfMixes,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationWorkupNumberOfMixes:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationWorkupMix->{True},
				PostConjugationWorkupMixType->{Pipette},
				PostConjugationWorkupNumberOfMixes->{5},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationWorkupNumberOfMixes],
			{5},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationCentrifugationIntensity,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationCentrifugationIntensity:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationCentrifugationIntensity->{1000 RPM},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationCentrifugationIntensity],
			{1000 RPM},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationCentrifugationTemperature,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationCentrifugationTemperature:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationCentrifugationTemperature->{30 Celsius},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationCentrifugationTemperature],
			{30 Celsius},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationCentrifugationTime,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationCentrifugationTime:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationCentrifugationTime->{10 Minute},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationCentrifugationTime],
			{10 Minute},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFilter,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFilter:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFilter->{Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations,Error::NoFilterAvailable,Error::InvalidOption}];
			Lookup[options,PostConjugationFilter],
			{ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFilterHousing,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFilterHousing:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFilterHousing->{Model[Instrument, FilterBlock, "Filter Block"]},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations,Error::FiltrationTypeAndFilterHousingMismatch,Error::InvalidOption}];
			Lookup[options,PostConjugationFilterHousing],
			{ObjectP[Model[Instrument, FilterBlock, "Filter Block"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFilterMembraneMaterial,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFilterMembraneMaterial:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFilterMembraneMaterial->{PTFE},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationFilterMembraneMaterial],
			{PTFE},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFilterMolecularWeightCutoff,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFilterMolecularWeightCutoff:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFilterMolecularWeightCutoff->{100*Kilogram/Mole},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationFilterMolecularWeightCutoff],
			{Quantity[100.`, ("Kilograms")/("Moles")]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFilterPoreSize,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFilterPoreSize:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFilterPoreSize->{0.45*Micrometer},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationFilterPoreSize],
			{0.45*Micrometer},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFilterStorageCondition,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFilterStorageCondition:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFilterStorageCondition->{Freezer},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationFilterStorageCondition],
			{Freezer},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFiltrationSyringe,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFiltrationSyringe:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFiltrationSyringe->{Model[Container,Syringe,"id:4pO6dMWvnn7z"]},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationFiltrationSyringe],
			{Model[Container,Syringe,"id:4pO6dMWvnn7z"]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationFiltrationType,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationFiltrationType:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationFiltrationType->{Vacuum},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationFiltrationType],
			{Vacuum},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationMagnetizationRack,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationMagnetizationRack:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Magnetic},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationMagnetizationRack->{Model[Container,Rack,"DynaMag Magnet 2mL Tube Rack"]},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations,Error::IncorrectlySpecifiedTransferOptions,Error::InvalidInput,Error::InvalidOption}];
			Lookup[options,PostConjugationMagnetizationRack],
			{ObjectP[Model[Container,Rack,"DynaMag Magnet 2mL Tube Rack"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationWorkupInstrument,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationWorkupInstrument:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients -> {{1, 1}},
				ProductStoichiometricCoefficient -> {1},
				PostConjugationWorkup -> True,
				PostConjugationWorkupBuffer -> Model[Sample, "Milli-Q water"],
				PostConjugationWorkupBufferVolume -> 20 Microliter,
				PostConjugationWorkupIncubationTime -> 5 Minute,
				PostConjugationWorkupIncubationTemperature -> 22 Celsius,
				PostConjugationWorkupMethod -> Pellet,
				PostConjugationWorkupInstrument -> {Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]},
				PostConjugationCentrifugationIntensity -> 100 RPM,
				PostConjugationCentrifugationTemperature -> 20 Celsius,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations, Error::IncompatibleCentrifuge, Error::InvalidOption}];
			Lookup[options,PostConjugationWorkupInstrument],
			{ObjectP[Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]]},
			Variables:>{options},
			TimeConstraint->1000
		],

		Example[{Options,PostConjugationPrefilterMembraneMaterial,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationPrefilterMembraneMaterial. Note that because the only filters with prefilters are disk filters for PeristalticPump, and the PeristalticPump only works on large volumes, this option can usually only be Null:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationPrefilterMembraneMaterial->{Null},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationPrefilterMembraneMaterial],
			{Null},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationSterileFiltration,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationSterileFiltration:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationSterileFiltration->{False},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationSterileFiltration],
			{False},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationPrefilterPoreSize,"Mix the post-conjugation sample and workup buffer, specifying PostConjugationPrefilterPoreSize. Note that because the only filters with prefilters are disk filters for PeristalticPump, and the PeristalticPump only works on large volumes, this option can usually only be Null:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Filter},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationPrefilterPoreSize->{Null},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations,Error::NoFilterAvailable,Error::InvalidOption}];
			Lookup[options,PostConjugationPrefilterPoreSize],
			{Null},
			Variables:>{options},
			TimeConstraint->1000
		],

		Example[{Options,PostConjugationResuspension,"Resuspend the sample after post-conjugation workup is complete:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostConjugationResuspension,PostConjugationResuspensionDiluent,PostConjugationResuspensionDiluentVolume }],
			{
				{True},
				{ObjectP[Model[Sample,"Milli-Q water"]]},
				{100 Microliter}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMix,"Resuspend the sample after post-conjugation workup is complete and mix according to the desired options:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10 Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMix->{True},
				PostConjugationResuspensionMixType->{Shake},
				PostConjugationResuspensionMixRate->{800 RPM},
				PostConjugationResuspensionMaxTime->{1 Hour},
				PostConjugationResuspensionMixUntilDissolved->{True},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,{PostConjugationResuspensionMix,PostConjugationResuspensionMixType,PostConjugationResuspensionMixRate,PostConjugationResuspensionMaxTime,PostConjugationResuspensionMixUntilDissolved }],
			{
				{True},
				{Shake},
				{800 RPM},
				{1 Hour},
				{True}
			},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionDiluent,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionDiluent:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionDiluent],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionDiluentVolume,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionDiluentVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionDiluentVolume],
			{100 Microliter},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMixType,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionMixType:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMixType->{Shake},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionMixType],
			{Shake},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionTime,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionTime:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionTime->{5Minute},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionTime],
			{5 Minute},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionTemperature,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionTemperature:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionTemperature-> {30 Celsius},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionTemperature],
			{30 Celsius},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMaxNumberOfMixes,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionMaxNumberOfMixes:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMaxNumberOfMixes->{20},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionMaxNumberOfMixes],
			{20},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMaxTime,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionMaxTime:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMaxTime-> {20 Minute},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionMaxTime],
			{20 Minute},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMixRate,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionMixRate:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMixRate->{200 RPM},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionMixRate],
			{200 RPM},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMixUntilDissolved,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionMixUntilDissolved:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMixUntilDissolved->{True},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionMixUntilDissolved],
			{True},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionMixVolume,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionMixVolume:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionMixVolume->{50 Microliter},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionMixVolume],
			{50 Microliter},
			Variables:>{options},
			TimeConstraint->1000
		],
		Example[{Options,PostConjugationResuspensionNumberOfMixes,"Resuspend the sample after post-conjugation workup is complete, specifying PostConjugationResuspensionNumberOfMixes:"},
			options=Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				PostConjugationWorkup->{True},
				PostConjugationWorkupMethod->{Pellet},
				PostConjugationWorkupBuffer->{Model[Sample,"Milli-Q water"]},
				PostConjugationWorkupBufferVolume->{100 Microliter},
				PostConjugationWorkupIncubationTime->{10Minute},
				PostConjugationWorkupIncubationTemperature->{Ambient},
				PostConjugationResuspension->{True},
				PostConjugationResuspensionDiluent->{Model[Sample,"Milli-Q water"]},
				PostConjugationResuspensionDiluentVolume->{100 Microliter},
				PostConjugationResuspensionNumberOfMixes->{5},
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options,PostConjugationResuspensionNumberOfMixes],
			{5},
			Variables:>{options},
			TimeConstraint->1000
		],



		Example[{Options, ImageSample, "Indicates the samples should be imaged after the experiment:"},
			options =Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				ImageSample->True,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options, ImageSample],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MeasureVolume,"Indicate that sample volumes should be measured after the experiment:"},
			options =Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				MeasureVolume->True,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,MeasureWeight,"Indicate that sample weight should be measured after the experiment:"},
			options =Quiet[ExperimentBioconjugation[
				{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				MeasureWeight->True,
				Output->Options
			], {Warning::InvalidSampleAnalyteConcentrations}];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options},
			TimeConstraint->1000
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be run with a bioconjugation experiment:"},
			protocol=Quiet[ExperimentBioconjugation[
				{
				{"BioConj sample 1","BioConj sample 2"}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"BioConj sample 1",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"BioConj sample 1",
						Amount->50*Milliliter
					],
					LabelContainer[
						Label->"BioConj sample 2",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"BioConj sample 2",
						Amount->50*Milliliter
					]
				}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol}
		],
		Example[{Options,PreparatoryPrimitives,"Specify prepared samples to be run with a bioconjugation experiment:"},
			protocol=Quiet[ExperimentBioconjugation[
				{
					{"BioConj sample 1","BioConj sample 2"}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				PreparatoryPrimitives->{
					Define[
						Name->"BioConj sample 1",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"BioConj sample 1",Amount->50*Milliliter
					],
					Define[
						Name->"BioConj sample 2",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"BioConj sample 2",Amount->50*Milliliter
					]
				}
			], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Download[protocol,PreparatoryPrimitives],
			{SampleManipulationP..},
			Variables:>{protocol}
		],
		(*incubate options*)
		Example[{Options,Incubate,"Perform a bioconjugation experiment on a single liquid sample with Incubation before measurement, using the default Incubate parameters:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Incubate->True,Output->Options], {Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Perform a bioconjugation experiment on a single liquid sample with Incubation before measurement for 10 minutes:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Incubate->True,IncubationTime->10 Minute,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Perform a bioconjugation experiment on a single liquid sample with MaxIncubation before measurement for 1 hour:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Incubate->True,MaxIncubationTime->1 Hour,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Perform a bioconjugation experiment on a single liquid sample with Incubation before measurement for 10 minutes at 30 degrees C:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Incubate->True,IncubationTime->10 Minute,IncubationTemperature->30 Celsius,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,IncubationTemperature],
			30 Celsius,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"Perform a bioconjugation experiment on a single liquid sample with Incubation before measurement and specify the Incubation instrument:"},
			Lookup[Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Incubate->True,IncubationInstrument->Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"],Output->Options],
				{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"Thermal-Lok  2510-1104"]],
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},IncubateAliquot->50 Milliliter,IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,IncubateAliquot],
			50 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},IncubateAliquot->50 Milliliter,IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,IncubateAliquotContainer],
			{{
				{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
				{2, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
			}},
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Mix->True,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Mix->True,MixType->Stir,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,MixType],
			Stir,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},MixUntilDissolved->True,MixType->Stir,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},AnnealingTime->40 Minute,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,AnnealingTime],
			40 Minute,
			Variables:>{options}
		],

		(*centrifuge options*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Centrifuge->True,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeIntensity->1000*RPM,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeTime->5*Minute,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeTemperature->30*Celsius,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeAliquot->50*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,CentrifugeAliquot],
			50 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeAliquot->50*Milliliter,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,CentrifugeAliquotContainer],
			{{
				{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
				{2, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
			}},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filtration->True,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FiltrationType->Syringe,FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FiltrationType],
			Syringe,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Filter->Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Error::NoFilterAvailable,Error::InvalidOption}];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterMaterial->PES,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterMaterial],
			PES,
			TimeConstraint -> 1000,
			Variables:>{options}
		],

		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment. Note that because the only filters with prefilters are disk filters for PeristalticPump, and the PeristalticPump only works on large volumes, this option can usually only be Null:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},PrefilterMaterial->Null,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,PrefilterMaterial],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterPoreSize->0.22*Micrometer,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			TimeConstraint -> 1000,
			Variables:>{options}
		],

		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment. Note that because the only filters with prefilters are disk filters for PeristalticPump, and the PeristalticPump only works on large volumes, this option can usually only be Null:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},PrefilterPoreSize->Null,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,PrefilterPoreSize],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane. This will resolve to Null for volumes we would use in this experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterHousing->Null,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterHousing],
			Null,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterAliquot->25 Milliliter,FiltrationType->Centrifuge,FilterTemperature->22*Celsius,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,FilterTemperature],
			22*Celsius,
			EquivalenceFunction->Equal,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],FilterSterile->False,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"50mL Tube"],FilterAliquot->50*Milliliter,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}];
			Lookup[options,FilterAliquot],
			50*Milliliter,
			EquivalenceFunction->Equal,
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterAliquotContainer],
			{{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},{2,ObjectP[Model[Container,Vessel,"50mL Tube"]]}}},
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterContainerOut],
			{{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},{2,ObjectP[Model[Container,Vessel,"50mL Tube"]]}}},
			TimeConstraint -> 1000,
			Variables:>{options}
		],
		(*Aliquot options*)
		Example[{Options,Aliquot,"Perform a bioconjugation experiment on a single liquid sample by first aliquotting the sample:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Aliquot->True,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},AliquotAmount->50*Milliliter,AliquotContainer->{
					{
						{1, Model[Container, Vessel, "50mL Tube"]},
						{2, Model[Container, Vessel, "50mL Tube"]}
					}
				},Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume, Warning::InsufficientVolume}];
			Lookup[options,AliquotAmount],
			50*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},AssayVolume->80*Milliliter,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume, Warning::InsufficientVolume}];
			Lookup[options,AssayVolume],
			80*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"Set the TargetConcentration option:"},
			options=Quiet[ExperimentBioconjugation[
				{{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				TargetConcentration->1*Millimolar,
				Output->Options
			],Warning::InvalidSampleAnalyteConcentrations];
			Lookup[options,TargetConcentration],
			1*Millimolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=Quiet[ExperimentBioconjugation[
				{{Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID]}},
				{Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]},
				ReactantsStoichiometricCoefficients->{{1,1}},
				ProductStoichiometricCoefficient->{1},
				TargetConcentration->1*Millimolar,
				TargetConcentrationAnalyte->Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
				Output->Options
			],Warning::InvalidSampleAnalyteConcentrations];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume, Warning::InsufficientVolume}];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,AliquotContainer->{{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]}},Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume, Warning::InsufficientVolume}];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->2,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->50*Microliter,AssayVolume->50*Milliliter,AliquotContainer->{{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]}},Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry, Error::MissingCacheField}];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Milliliter,AssayVolume->50*Milliliter,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume, Warning::InsufficientVolume}];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},AliquotSampleStorageCondition->Refrigerator,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},ConsolidateAliquots->True,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Aliquot->True,AliquotPreparation->Manual,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},AliquotContainer->{{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]}},Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry,Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume, Warning::InsufficientVolume}];
			Lookup[options,AliquotContainer],
			{{
				{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
				{2, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
			}},
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition,"Indicates how the samples out from the experiment should be stored::"},
			options=Quiet[ExperimentBioconjugation[{
				{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
			},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},SamplesOutStorageCondition->Freezer,Output->Options],
				{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options, SamplesOutStorageCondition],
			Freezer,
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},IncubateAliquotContainer->Model[Container,Vessel,"100 mL Glass Bottle"],IncubateAliquotDestinationWell->"A1",Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],FilterContainerOut->Model[Container,Vessel,"100 mL Glass Bottle"],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},DestinationWell->{{"A1", "A1"}},Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,DestinationWell],
			{{"A1", "A1"}},
			Variables:>{options}
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Name->"My Exploratory DynamicFoamAnalysis Test Protocol",Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Name],
			"My Exploratory DynamicFoamAnalysis Test Protocol"
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Template->Object[Protocol,Bioconjugation,"Parent Protocol for Template ExperimentBioconjugation tests"<>$SessionUUID],Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			Lookup[options,Template],
			ObjectP[Object[Protocol,Bioconjugation,"Parent Protocol for Template ExperimentBioconjugation tests"<>$SessionUUID]]
		],
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=Quiet[ExperimentBioconjugation[{
					{Object[Sample, "Experiment Bioconjugation test sample 1"<>$SessionUUID], Object[Sample, "Experiment Bioconjugation test sample 2"<>$SessionUUID]}
				},
				{Model[Molecule,Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID]},Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options],
			{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			TimeConstraint->1000,
			Variables:>{options}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	},
	Parallel->True,
	HardwareConfiguration -> HighRAM,
	(* NOTE: We have to turn these messages off in our SetUp as well since our tests run in parallel on Manifold. *)
	SetUp:>(
		$CreatedObjects = {};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True]
	),
	SymbolSetUp:>(
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjects,existingObjects},

			ClearMemoization[];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Model[Molecule, Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID],

				Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID],
				Model[Sample,"Experiment Bioconjugation model test sample 2"<>$SessionUUID],
				Model[Sample,"Experiment Bioconjugation model test sample Null identity model"<>$SessionUUID],

				Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 4"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 5"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample Null identity model"<>$SessionUUID],
				Object[Sample, "Experiment Bioconjugation model-less test sample"<>$SessionUUID],

				Object[Container,Plate,"Experiment Bioconjugation test container 1"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 2"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 3"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 4"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 5"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 6"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test empty container"<>$SessionUUID],
				Object[Protocol,Bioconjugation,"Parent Protocol for Template ExperimentBioconjugation tests"<>$SessionUUID]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

			Module[{allObjects},

				(*Upload empty containers*)
				UploadSample[
					{
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]},
						{"A1", Object[Container, Shelf, "Ambient Storage Shelf"]}
					},
					Name->{
						"Experiment Bioconjugation test container 1"<>$SessionUUID,
						"Experiment Bioconjugation test container 2"<>$SessionUUID,
						"Experiment Bioconjugation test container 3"<>$SessionUUID,
						"Experiment Bioconjugation test container 4"<>$SessionUUID,
						"Experiment Bioconjugation test container 5"<>$SessionUUID,
						"Experiment Bioconjugation test empty container"<>$SessionUUID,
						"Experiment Bioconjugation test container 6"<>$SessionUUID
					},
					Status->{
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					}
				];

				(*Upload new identity model for conjugation product*)
				UploadProtein[
					{
						"Experiment Bioconjugation test identity model 1"<>$SessionUUID
					},
					Species -> Model[Species, "Human"],
					Synonyms -> {
						{"TestProtein1"}
					},
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					MolecularWeight->1 Gram/Mole
				];

				(*Upload Model samples so we can upload new sample objects later.*)
				UploadSampleModel[
					{
						"Experiment Bioconjugation model test sample 1"<>$SessionUUID,
						"Experiment Bioconjugation model test sample 2"<>$SessionUUID,
						"Experiment Bioconjugation model test sample Null identity model"<>$SessionUUID
					},
					Composition-> {
						{{1 Milligram/Milliliter,Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]}},
						{{1 Milligram/Milliliter,Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]}},
						{{Null,Null}}
				 },
					IncompatibleMaterials->{{None},{None},{None}},
					Expires->{True,True,True},
					ShelfLife->{1 Year,1 Year,1 Year},
					UnsealedShelfLife->{2 Week,2 Week,2 Week},
					DefaultStorageCondition->{Model[StorageCondition,"Refrigerator"],Model[StorageCondition,"Refrigerator"],Model[StorageCondition,"Refrigerator"]},
					MSDSRequired->{False,False,False},
					BiosafetyLevel->{"BSL-1","BSL-1","BSL-1"},
					State->{Liquid,Liquid,Liquid}
				];

				(*Upload test sample objects. Place test objects in the specified test container objects*)
				UploadSample[
					{
						Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID],
						Model[Sample,"Experiment Bioconjugation model test sample 2"<>$SessionUUID],
						Model[Sample,"Experiment Bioconjugation model test sample Null identity model"<>$SessionUUID],

						Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID],
						Model[Sample,"Experiment Bioconjugation model test sample 2"<>$SessionUUID],

						Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID],
						Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID]
					},
					{
						{"A1",Object[Container,Vessel,"Experiment Bioconjugation test container 2"<>$SessionUUID]},
						{"A1",Object[Container,Vessel,"Experiment Bioconjugation test container 3"<>$SessionUUID]},
						{"A1",Object[Container,Vessel,"Experiment Bioconjugation test container 4"<>$SessionUUID]},

						{"A1",Object[Container,Plate,"Experiment Bioconjugation test container 1"<>$SessionUUID]},
						{"A2",Object[Container,Plate,"Experiment Bioconjugation test container 1"<>$SessionUUID]},

						{"A1",Object[Container,Vessel,"Experiment Bioconjugation test container 5"<>$SessionUUID]},
						{"A1",Object[Container,Vessel,"Experiment Bioconjugation test container 6"<>$SessionUUID]}
					},
					Name->{
						"Experiment Bioconjugation test sample 1"<>$SessionUUID,
						"Experiment Bioconjugation test sample 2"<>$SessionUUID,
						"Experiment Bioconjugation test sample Null identity model"<>$SessionUUID,
						"Experiment Bioconjugation test sample 4"<>$SessionUUID,
						"Experiment Bioconjugation test sample 5"<>$SessionUUID,
						"Experiment Bioconjugation model-less test sample"<>$SessionUUID,
						"Experiment Bioconjugation test sample 3"<>$SessionUUID
					},
					InitialAmount-> {200 Microliter,200 Microliter,200 Microliter,200 Microliter,200 Microliter,200 Microliter,25 Milliliter}
				];

				(*Upload analytes to the test objects*)
				Upload[MapThread[
					<|Object->#1, Replace[Analytes]->Link[#2]|>&,
					{
						{
							Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],
							Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID],
							Object[Sample,"Experiment Bioconjugation test sample Null identity model"<>$SessionUUID],
							Object[Sample,"Experiment Bioconjugation test sample 4"<>$SessionUUID],
							Object[Sample,"Experiment Bioconjugation test sample 5"<>$SessionUUID],
							Object[Sample, "Experiment Bioconjugation model-less test sample"<>$SessionUUID],
							Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID]
						},

						{
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID],
							Model[Molecule,Protein,"Experiment Bioconjugation test identity model 1"<>$SessionUUID]
						}
					}
				]];

				(*Make a test model-less sample object*)
				Upload[<|
					Object->Object[Sample,"Experiment Bioconjugation model-less test sample"<>$SessionUUID],
					Model->Null
				|>];

				Upload[
					<|
						Type -> Object[Protocol, Bioconjugation],
						Name -> "Parent Protocol for Template ExperimentBioconjugation tests"<>$SessionUUID,
						DeveloperObject -> True
					|>
				];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects=Flatten[{
					Model[Molecule, Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID],

					Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID],
					Model[Sample,"Experiment Bioconjugation model test sample 2"<>$SessionUUID],
					Model[Sample,"Experiment Bioconjugation model test sample Null identity model"<>$SessionUUID],

					Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],
					Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID],
					Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],
					Object[Sample,"Experiment Bioconjugation test sample 4"<>$SessionUUID],
					Object[Sample,"Experiment Bioconjugation test sample 5"<>$SessionUUID],
					Object[Sample,"Experiment Bioconjugation test sample Null identity model"<>$SessionUUID],
					Object[Sample, "Experiment Bioconjugation model-less test sample"<>$SessionUUID],

					Object[Container,Plate,"Experiment Bioconjugation test container 1"<>$SessionUUID],
					Object[Container,Vessel,"Experiment Bioconjugation test container 2"<>$SessionUUID],
					Object[Container,Vessel,"Experiment Bioconjugation test container 3"<>$SessionUUID],
					Object[Container,Vessel,"Experiment Bioconjugation test container 4"<>$SessionUUID],
					Object[Container,Vessel,"Experiment Bioconjugation test container 5"<>$SessionUUID],
					Object[Container,Vessel,"Experiment Bioconjugation test container 6"<>$SessionUUID],

					Object[Protocol,Bioconjugation,"Parent Protocol for Template ExperimentBioconjugation tests"<>$SessionUUID]

				}];

				(*Make all the test objects and models developer objects*)
				Upload[<|Object->#,DeveloperObject->True|>&/@allObjects];

			]
	),

	SymbolTearDown:>(

		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Flatten[{
				Model[Molecule, Protein, "Experiment Bioconjugation test identity model 1"<>$SessionUUID],

				Model[Sample,"Experiment Bioconjugation model test sample 1"<>$SessionUUID],
				Model[Sample,"Experiment Bioconjugation model test sample 2"<>$SessionUUID],
				Model[Sample,"Experiment Bioconjugation model test sample Null identity model"<>$SessionUUID],

				Object[Sample,"Experiment Bioconjugation test sample 1"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 2"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 3"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 4"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample 5"<>$SessionUUID],
				Object[Sample,"Experiment Bioconjugation test sample Null identity model"<>$SessionUUID],
				Object[Sample, "Experiment Bioconjugation model-less test sample"<>$SessionUUID],

				Object[Container,Plate,"Experiment Bioconjugation test container 1"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 2"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 3"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 4"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 5"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test container 6"<>$SessionUUID],
				Object[Container,Vessel,"Experiment Bioconjugation test empty container"<>$SessionUUID],

				Object[Protocol,Bioconjugation,"Parent Protocol for Template ExperimentBioconjugation tests"<>$SessionUUID]
			}];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		]
	)
];
