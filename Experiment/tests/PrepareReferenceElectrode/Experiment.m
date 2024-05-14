(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentPrepareReferenceElectrode*)


DefineTests[ExperimentPrepareReferenceElectrode,
	{
		(* ============ *)
		(* == BASICS == *)
		(* ============ *)

		Example[{Basic, "Prepare a reference electrode of the input target model:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "Prepare a reference electrode of a target model from a source un-prepared or a previously prepared reference electrode:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "Prepare multiple reference electrodes of provided target models:"},
			ExperimentPrepareReferenceElectrode[{
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]
			}],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "Use multiple input source reference electrodes to prepare reference electrodes of provided target models:"},
			ExperimentPrepareReferenceElectrode[
				{
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for PrepareReferenceElectrode tests " <> $SessionUUID]
				},
				{
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]
				}
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Basic, "Prepare a reference electrode of a target model from a source un-prepared or a previously prepared reference electrode, and use the container of the source electrode as the input:"},
			ExperimentPrepareReferenceElectrode[
				Object[Container, Vessel, "Example container with electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* ============= *)
		(* == OPTIONS == *)
		(* ============= *)

		(* -- PolishReferenceElectrode -- *)
		Example[{Options, PolishReferenceElectrode, "Use the PolishReferenceElectrode to indicate the non-working part (the part does not directly contact the experiment solution) of the source reference electrode should be polished with a piece of 1200 grit sandpaper if rust is found in this part:"},
			options = ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PolishReferenceElectrode -> True,
				Output->Options
			];
			Lookup[options, PolishReferenceElectrode],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* -- PrimaryWashingSolution -- *)
		Example[{Options, PrimaryWashingSolution, "Use the PrimaryWashingSolution to indicate if the reference electrode should be washed by the solution specified by the PrimaryWashingSolution before the electrode priming step:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Model[Sample, "Milli-Q water"],
				Output->Options
			];
			SameObjectQ[Lookup[options, PrimaryWashingSolution], Model[Sample, "Milli-Q water"]],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- NumberOfPrimaryWashings -- *)
		Example[{Options, NumberOfPrimaryWashings, "Use the NumberOfPrimaryWashings to indicate the number of washing cycles performed with PrimaryWashingSolution. A full washing cycle includes rinsing the full surface areas of the electrode metal wiring or plate and the electrode glass tube (both inside and outside), with approximately 10 mL of solution:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Model[Sample, "Milli-Q water"],
				NumberOfPrimaryWashings -> 3,
				Output->Options
			];
			Lookup[options, NumberOfPrimaryWashings],
			3,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- SecondaryWashingSolution -- *)
		Example[{Options, SecondaryWashingSolution, "Use the SecondaryWashingSolution to indicate if the reference electrode should be washed by the solution specified by the SecondaryWashingSolution after the washing of PrimaryWashingSolution and before the electrode priming step:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Model[Sample, "Milli-Q water"],
				SecondaryWashingSolution -> Model[Sample, "Acetonitrile, Electronic Grade"],
				Output->Options
			];
			SameObjectQ[Lookup[options, SecondaryWashingSolution], Model[Sample, "Acetonitrile, Electronic Grade"]],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- NumberOfSecondaryWashings -- *)
		Example[{Options, NumberOfSecondaryWashings, "Use the NumberOfSecondaryWashings to indicate the number of washing cycles performed with SecondaryWashingSolution. A full washing cycle includes rinsing the full surface areas of the electrode metal wiring or plate and the electrode glass tube (both inside and outside), with approximately 10 mL of solution:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Model[Sample, "Milli-Q water"],
				NumberOfPrimaryWashings -> 3,
				SecondaryWashingSolution -> Model[Sample, "Acetonitrile, Electronic Grade"],
				NumberOfSecondaryWashings -> 3,
				Output->Options
			];
			Lookup[options, NumberOfSecondaryWashings],
			3,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- NumberOfPrimings -- *)
		Example[{Options, NumberOfPrimings, "Use the NumberOfPrimings to indicate the number of priming cycles performed with ReferenceSolution defined in the target reference electrode model. A full priming cycle includes rinsing the full surface areas of the electrode metal wiring or plate and the electrode glass tube (only inside):"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				NumberOfPrimings -> 3,
				Output->Options
			];
			Lookup[options, NumberOfPrimings],
			3,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- PrimingVolume -- *)
		Example[{Options, PrimingVolume, "Use the PrimingVolume to indicate the volume of the ReferenceSolution used to prime the reference electrode metal wire or plate and the inside of the glass tube in each priming cycle:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimingVolume -> 10 Milliliter,
				Output->Options
			];
			Lookup[options, PrimingVolume],
			10 Milliliter,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- PrimingSoakTime -- *)
		Example[{Options, PrimingSoakTime, "Use the PrimingSoakTime to indicate the duration of the reference electrode metal wire or plate will be soaked in the ReferenceSolution within the glass tube after the last priming cycle:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimingSoakTime -> 10 Minute,
				Output->Options
			];
			Lookup[options, PrimingSoakTime],
			10 Minute,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- ReferenceSolutionVolume -- *)
		Example[{Options, ReferenceSolutionVolume, "Use the ReferenceSolutionVolume to indicate the volume of the ReferenceSolution the electrode's glass tube is filled with. The ReferenceSolutionVolume should be within the range of 95% and 105% of the SolutionVolume defined by the reference electrode model being prepared:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				ReferenceSolutionVolume -> 1 Milliliter,
				Output->Options
			];
			Lookup[options, ReferenceSolutionVolume],
			1 Milliliter,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- Template -- *)
		Example[{Options, Template, "Use the ReferenceSolutionVolume to indicate the volume of the ReferenceSolution the electrode's glass tube is filled with. The ReferenceSolutionVolume should be within the range of 95% and 105% of the SolutionVolume defined by the reference electrode model being prepared:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				Template -> Object[Protocol, PrepareReferenceElectrode, "Example template protocol for PrepareReferenceElectrode tests " <> $SessionUUID],
				Output->Options
			];
			MatchQ[Lookup[options, Template], ObjectReferenceP[Object[Protocol, PrepareReferenceElectrode, "Example template protocol for PrepareReferenceElectrode tests " <> $SessionUUID]]],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* -- Name -- *)
		Example[{Options, Name, "Use the Name option to give the protocol a name:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				Name -> "Example Prepare Reference Electrode Protocol",
				Output -> Options
			];
			Lookup[options, Name],
			"Example Prepare Reference Electrode Protocol",
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		(* -- MeasureWeight -- *)
		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				MeasureWeight -> True,
				Output -> Options
			];
			Lookup[options, MeasureWeight],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		(* -- MeasureVolume -- *)
		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				MeasureVolume -> True,
				Output -> Options
			];
			Lookup[options, MeasureVolume],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		(* -- ImageSample -- *)
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				ImageSample -> True,
				Output -> Options
			];
			Lookup[options, ImageSample],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		(* -- SamplesOutStorageCondition -- *)
		Example[{Options, SamplesOutStorageCondition, "Indicates how the generated reference electrodes of the experiment should be stored:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				SamplesOutStorageCondition -> AmbientStorage,
				Output -> Options
			];
			Lookup[options, SamplesOutStorageCondition],
			AmbientStorage,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],

		(* -- NumberOfReplicates -- *)
		Example[{Options, NumberOfReplicates, "Specify the number of duplicated reference electrode of the same model should be prepared:"},
			options = ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				NumberOfReplicates -> 3,
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			3,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {options}
		],


		(* ============== *)
		(* == MESSAGES == *)
		(* ============== *)

		(* -- PREInputListsConflictingLength -- *)
		Example[{Messages, "Mismatching Lengths of source electrodes and target reference electrode models", "If the input source reference electrode list and the target reference electrode model list do have have the same length, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				{
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for PrepareReferenceElectrode tests " <> $SessionUUID]
				},
				{
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {Error::PREInputListsConflictingLength, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREBlankModel -- *)
		Example[{Messages, "Target reference electrode is a Blank model", "If input target reference electrode model is a Blank model (with its Blank field set to Null and does not have a reference solution defined), an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PREBlankModel, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Blank -> Null
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]]
				|>]
			)
		],

		(* -- PRENoReferenceElectrodeInContainer -- *)
		Example[{Messages, "No reference electrode in the provided container", "If the a container without any reference electrode stored in it is used as the input, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Container, Vessel, "Example container without electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PRENoReferenceElectrodeInContainer, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREDuplicatedSourceReferenceElectrodes -- *)
		Example[{Messages, "Duplicated input source reference electrodes", "If there are duplicated electrodes in the input source reference electrode list, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				{
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID]
				},
				{
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> {Error::PREDuplicatedSourceReferenceElectrodes, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREDiscardedSourceReferenceElectrodes -- *)
		Example[{Messages, "Discarded input source reference electrodes", "If there are discarded electrodes in the input source reference electrode(s), an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PREDiscardedSourceReferenceElectrodes, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Status -> Discarded
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Status -> Available
				|>]
			)
		],

		(* -- PREDeprecatedReferenceElectrodeModels -- *)
		Example[{Messages, "Deprecated target reference electrode model", "If there are deprecated models in the input target reference electrode model(s), an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PREDeprecatedReferenceElectrodeModels, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Deprecated -> True
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Deprecated -> Null
				|>]
			)
		],

		(* -- PREUnpreparableReferenceElectrodeModels -- *)
		Example[{Messages, "Unpreparable target reference electrode model", "If there are unpreparable models in the input target reference electrode model(s), an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PREUnpreparableReferenceElectrodeModels, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Preparable -> False
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Preparable -> True
				|>]
			)
		],

		(* -- PRETooManyTargetReferenceElectrodeModelInputs -- *)
		Example[{Messages, "Too many reference electrodes to be prepared", "If there are more than 10 target reference electrodes to be prepared, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				ConstantArray[Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID], 15]
			],
			$Failed,
			Messages :> {Error::PRETooManyTargetReferenceElectrodeModelInputs, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREMismatchingBlank -- *)
		Example[{Messages, "Mismatching Blank models", "If the target reference electrode's Blank model is different from the source reference electrode Blank model (when the source reference electrode itself is a Blank model) or the Blank model defined in source reference electrode, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PREMismatchingBlank, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"]]
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]]
				|>]
			)
		],

		(* -- PREReferenceElectrodeTypeSwitching -- *)
		Example[{Messages, "ReferenceElectrodeType Switching", "If the source reference electrode is not a Blank electrode or electrode model, and the target reference electrode model is of another ReferenceElectrodeType different from the source reference electrode, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::PREReferenceElectrodeTypeSwitching, Error::InvalidInput},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREReferenceCouplingSampleSwitchingWarning -- *)
		Example[{Messages, "ReferenceCouplingSample Switching", "If the source reference electrode is not a Blank electrode or electrode model, and the target reference electrode model is of another ReferenceElectrodeType different from the source reference electrode, a warning will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			Messages :> {Warning::PREReferenceCouplingSampleSwitchingWarning},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					ReferenceCouplingSample -> Link[Model[Sample, "Potassium Chloride"]]
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>]
			)
		],

		(* -- PRENonNullNumberOfReplicatesForReferenceElectrodeObject -- *)
		Example[{Messages, NumberOfReplicates, "If the NumberOfReplicates options is specified to an integer when there is at least one input source reference electrode Object, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				NumberOfReplicates -> 3
			],
			$Failed,
			Messages :> {Error::PRENonNullNumberOfReplicatesForReferenceElectrodeObject, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRESourceReferenceElectrodeNeedsPolishing -- *)
		Example[{Messages, PolishReferenceElectrode, "If the input reference electrode has rust found on its non-working part (the part does not directly contact the experiment solution) and the PolishReferenceElectrode options is set to False, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PolishReferenceElectrode -> False
			],
			$Failed,
			Messages :> {Error::PRESourceReferenceElectrodeNeedsPolishing, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Replace[RustCheckingLog] -> {{DateObject["2021-01-17"], NonWorkingPart, Link[Object[User, Emerald, Developer, "Example user for PrepareReferenceElectrode tests " <> $SessionUUID]]}}
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Replace[RustCheckingLog] -> Null
				|>]
			)
		],

		(* -- PRESourceReferenceElectrodeWorkingPartRustWarning -- *)
		Example[{Messages, "Source reference electrode working part rust", "If the source reference electrode has rust observed on its working part (the part that directly contacts the experiment solution), a warning will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			Messages :> {Warning::PRESourceReferenceElectrodeWorkingPartRustWarning},
			SetUp :>(
				$CreatedObjects={};
				Upload[<|
					Object -> Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Replace[RustCheckingLog] -> {{DateObject["2021-01-17"], WorkingPart, Link[Object[User, Emerald, Developer, "Example user for PrepareReferenceElectrode tests " <> $SessionUUID]]}}
				|>]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
				Upload[<|
					Object -> Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Replace[RustCheckingLog] -> Null
				|>]
			)
		],

		(* -- PRENonNullNumberOfPrimaryWashings -- *)
		Example[{Messages, NumberOfPrimaryWashings, "If the NumberOfPrimaryWashings is set to an integer when the PrimaryWashingSolution is set to Null, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Null,
				NumberOfPrimaryWashings -> 3
			],
			$Failed,
			Messages :> {Error::PRENonNullNumberOfPrimaryWashings, Warning::PRENullPrimaryWashingSolutionWarning, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREMissingNumberOfPrimaryWashings -- *)
		Example[{Messages, NumberOfPrimaryWashings, "If the NumberOfPrimaryWashings is set to Null when the PrimaryWashingSolution is set to a washing solution, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Model[Sample, "Milli-Q water"],
				NumberOfPrimaryWashings -> Null
			],
			$Failed,
			Messages :> {Error::PREMissingNumberOfPrimaryWashings, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRESameWashingSolutions -- *)
		Example[{Messages, "Same washing solutions", "If the PrimaryWashingSolution and SecondaryWashingSolution are set to the same washing solution, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Model[Sample, "Milli-Q water"],
				SecondaryWashingSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::PRESameWashingSolutions, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREMissingPrimaryWashingSolution -- *)
		Example[{Messages, "Missing PrimaryWashingSolution", "If the PrimaryWashingSolution is set to Null and SecondaryWashingSolution is set to a washing solution, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Null,
				SecondaryWashingSolution -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::PREMissingPrimaryWashingSolution, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRENonNullNumberOfSecondaryWashings -- *)
		Example[{Messages, NumberOfSecondaryWashings, "If the NumberOfSecondaryWashings is set to an integer when the SecondaryWashingSolution is set to Null, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				SecondaryWashingSolution -> Null,
				NumberOfSecondaryWashings -> 3
			],
			$Failed,
			Messages :> {Error::PRENonNullNumberOfSecondaryWashings, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREMissingNumberOfSecondaryWashings -- *)
		Example[{Messages, NumberOfSecondaryWashings, "If the NumberOfSecondaryWashings is set to Null when the SecondaryWashingSolution is set to a washing solution, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				SecondaryWashingSolution -> Model[Sample, "Milli-Q water"],
				NumberOfSecondaryWashings -> Null
			],
			$Failed,
			Messages :> {Error::PREMissingNumberOfSecondaryWashings, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRENullPrimaryWashingSolutionWarning -- *)
		Example[{Messages, "Null PrimaryWashingSolution", "If the PrimaryWashingSolution is set to Null, a warning will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimaryWashingSolution -> Null
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			Messages :> {Warning::PRENullPrimaryWashingSolutionWarning},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRETooSmallPrimingVolume -- *)
		Example[{Messages, PrimingVolume, "If the specified PrimingVolume is less than 1.5 Milliliter, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimingVolume -> 1 Milliliter
			],
			$Failed,
			Messages :> {Error::PRETooSmallPrimingVolume, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRETooSmallReferenceSolutionVolume -- *)
		Example[{Messages, ReferenceSolutionVolume, "If the specified ReferenceSolutionVolume is less than 95% of the SolutionVolume defined in the target reference electrode model, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				ReferenceSolutionVolume -> 0.1 Milliliter
			],
			$Failed,
			Messages :> {Error::PRETooSmallReferenceSolutionVolume, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PRETooLargeReferenceSolutionVolume -- *)
		Example[{Messages, ReferenceSolutionVolume, "If the specified ReferenceSolutionVolume is greater than 105% of the SolutionVolume defined in the target reference electrode model, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				ReferenceSolutionVolume -> 100 Milliliter
			],
			$Failed,
			Messages :> {Error::PRETooLargeReferenceSolutionVolume, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREDisposalSamplesOutStorageCondition -- *)
		Example[{Messages, SamplesOutStorageCondition, "If the SamplesOutStorageCondition is set to Disposal, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				SamplesOutStorageCondition -> Disposal
			],
			$Failed,
			Messages :> {Error::PREDisposalSamplesOutStorageCondition, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- PREIncompatibleSamplesOutStorageCondition -- *)
		Example[{Messages, SamplesOutStorageCondition, "If the SamplesOutStorageCondition is not set to AmbientStorage or Null, an error will be thrown:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				SamplesOutStorageCondition -> Refrigerator
			],
			$Failed,
			Messages :> {Error::PREIncompatibleSamplesOutStorageCondition, Error::InvalidOption},
			SetUp :>(
				$CreatedObjects={}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ---------------------- *)
		(* -- GENERAL MESSAGES -- *)
		(* ---------------------- *)

		(* -- rounding option precision -- *)
		Example[{Messages, "Options with too high precisions", "If an option is given with higher precision than the instrument can achieve, the value is rounded to the instrument precision and a warning is displayed:"},
			ExperimentPrepareReferenceElectrode[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
				PrimingVolume -> 3.1 Milliliter
			],
			ObjectP[Object[Protocol, PrepareReferenceElectrode]],
			Messages :> {Warning::InstrumentPrecision},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects, Force->True, Verbose->False];
				Unset[$CreatedObjects]
			)
		]


		(* =========== *)
		(* == TESTS == *)
		(* =========== *)

	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Example bench for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Test protocol *)
					Object[Protocol, PrepareReferenceElectrode, "Example template protocol for PrepareReferenceElectrode tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, sandpaper,

					(* Model Molecules and Samples *)
					solventSampleModelObject, testMolecule, testSolventSampleModel, referenceSolution, referenceCouplingSample,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8, referenceElectrode9,

					(* Containers *)
					container1, container2,

					(* ElectrodeRack *)
					rack1,

					(* test user *)
					testUser
				},

				(* set up the test user *)
				testUser = Upload[<|
					Type -> Object[User, Emerald, Developer],
					Name -> "Example user for PrepareReferenceElectrode tests " <> $SessionUUID
				|>];

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name->"Example bench for PrepareReferenceElectrode tests " <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Name -> "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 1 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				testMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for PrepareReferenceElectrode tests " <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				testSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for PrepareReferenceElectrode tests " <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[testMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for PrepareReferenceElectrode tests " <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for PrepareReferenceElectrode tests " <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for PrepareReferenceElectrode tests " <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up test reference electrodes and containers for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8,

					container1, container2,

					rack1,

					sandpaper
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1,

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Rack, "Electrode Imaging Holder for IKA Electrodes"],

						Model[Item, Consumable, Sandpaper, "3M 1200 Grit Sandpaper"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},

						{"Work Surface", testBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,

							Available,
							Available,

							Available,

							Available
						},
					Name->
						{
							"Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example bare reference electrode 2 for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example bare reference electrode 3 for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example AgCl reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example Pseudo Ag reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example model reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID,

							"Example container with electrode for PrepareReferenceElectrode tests " <> $SessionUUID,
							"Example container without electrode for PrepareReferenceElectrode tests " <> $SessionUUID,

							"Example electrode rack for PrepareReferenceElectrode tests " <> $SessionUUID,

							"Example sandpaper for PrepareReferenceElectrode tests " <> $SessionUUID
						}
				];

				(* Upload the reference electrode that is in the container *)
				referenceElectrode9 = UploadSample[
					Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
					{"A1", container1},
					Name -> "Example bare reference electrode within container for PrepareReferenceElectrode tests " <> $SessionUUID
				];

				(* upload the test objects *)
				Upload[
					<|
						Object->#,
						AwaitingStorageUpdate->Null
					|> &/@Cases[
						Flatten[
							{
								(* Object Reference Electrodes *)
								referenceElectrode1, referenceElectrode2, referenceElectrode3,
								referenceElectrode4, referenceElectrode5, referenceElectrode6,
								referenceElectrode7, referenceElectrode8, referenceElectrode9,

								container1, container2,

								sandpaper
							}
						],
						ObjectP[]
					]
				];

				(* --------------------- *)
				(* --- TEST PROTOCOL --- *)
				(* --------------------- *)

				(* Set $CreatedObjects to {} to catch all of the resources and other objects created by the Experiment function calls *)
				$CreatedObjects={};

				Quiet[
					ExperimentPrepareReferenceElectrode[
						Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],
						Name-> "Example template protocol for PrepareReferenceElectrode tests " <> $SessionUUID
					]
				];

				(* Make all of the objects created during the protocol developer objects *)
				Upload[<|Object->#, DeveloperObject->True|> &/@Cases[Flatten[$CreatedObjects], ObjectP[]]];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Example bench for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for PrepareReferenceElectrode tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for PrepareReferenceElectrode tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for PrepareReferenceElectrode tests " <> $SessionUUID],

					(* Test protocol *)
					Object[Protocol, PrepareReferenceElectrode, "Example template protocol for PrepareReferenceElectrode tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];




(* ::Subsection:: *)
(*ExperimentPrepareReferenceElectrodeOptions*)


(* ------------------------------------------------ *)
(* -- ExperimentPrepareReferenceElectrodeOptions -- *)
(* ------------------------------------------------ *)


DefineTests[ExperimentPrepareReferenceElectrodeOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentPrepareReferenceElectrodeOptions[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID]
			],
			_Grid
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentPrepareReferenceElectrodeOptions[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
				PrimingVolume -> 1 Milliliter
			],
			_Grid,
			Messages :> {Error::PRETooSmallPrimingVolume, Error::InvalidOption}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentPrepareReferenceElectrodeOptions[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
				OutputFormat->List
			],
			{(_Rule|_RuleDelayed)..}
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench,  "Example bench for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, sandpaper,

					(* Model Molecules and Samples *)
					solventSampleModelObject, testMolecule, testSolventSampleModel, referenceSolution, referenceCouplingSample,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8, referenceElectrode9,

					(* Containers *)
					container1, container2,

					(* ElectrodeRack *)
					rack1,

					(* test user *)
					testUser
				},

				(* set up the test user *)
				testUser = Upload[<|
					Type -> Object[User, Emerald, Developer],
					Name -> "Example user for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID
				|>];

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name-> "Example bench for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Name -> "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 1 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				testMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				testSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[testMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up test reference electrodes and containers for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8,

					container1, container2,

					rack1,

					sandpaper
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1,

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Rack, "Electrode Imaging Holder for IKA Electrodes"],

						Model[Item, Consumable, Sandpaper, "3M 1200 Grit Sandpaper"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},

						{"Work Surface", testBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,

							Available,
							Available,

							Available,

							Available
						},
					Name->
						{
							"Example bare reference electrode 1 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example bare reference electrode 2 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example bare reference electrode 3 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example AgCl reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example Pseudo Ag reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example model reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,

							"Example container with electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,
							"Example container without electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,

							"Example electrode rack for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID,

							"Example sandpaper for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID
						}
				];

				(* Upload the reference electrode that is in the container *)
				referenceElectrode9 = UploadSample[
					Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
					{"A1", container1},
					Name -> "Example bare reference electrode within container for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID
				];

					(* upload the test objects *)
					Upload[
						<|
							Object->#,
							AwaitingStorageUpdate->Null
						|> &/@Cases[
							Flatten[
								{
									(* Object Reference Electrodes *)
									referenceElectrode1, referenceElectrode2, referenceElectrode3,
									referenceElectrode4, referenceElectrode5, referenceElectrode6,
									referenceElectrode7, referenceElectrode8, referenceElectrode9,

									container1, container2,

									sandpaper
								}
							],
							ObjectP[]
						]
					];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench,  "Example bench for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for ExperimentPrepareReferenceElectrodeOptions tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];


(* ::Subsection:: *)
(*ValidExperimentPrepareReferenceElectrodeQ*)


(* ----------------------------------------------- *)
(* -- ValidExperimentPrepareReferenceElectrodeQ -- *)
(* ----------------------------------------------- *)


DefineTests[ValidExperimentPrepareReferenceElectrodeQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issues:"},
			ValidExperimentPrepareReferenceElectrodeQ[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentPrepareReferenceElectrodeQ[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
				PrimingVolume -> 1 Milliliter
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidExperimentPrepareReferenceElectrodeQ[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentPrepareReferenceElectrodeQ[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
				Verbose->True
			],
			True
		]
	},


	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Example bench for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, sandpaper,

					(* Model Molecules and Samples *)
					solventSampleModelObject, testMolecule, testSolventSampleModel, referenceSolution, referenceCouplingSample,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8, referenceElectrode9,

					(* Containers *)
					container1, container2,

					(* ElectrodeRack *)
					rack1,

					(* test user *)
					testUser
				},

				(* set up the test user *)
				testUser = Upload[<|
					Type -> Object[User, Emerald, Developer],
					Name -> "Example user for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID
				|>];

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name->"Example bench for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Replace[Authors] -> {Link[Object[User, Emerald, Developer, "Example user for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID]]},
					Name -> "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 1 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]],
					Price -> 200 USD
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				testMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				testSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[testMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up test reference electrodes and containers for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8,

					container1, container2,

					rack1,

					sandpaper
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1,

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Rack, "Electrode Imaging Holder for IKA Electrodes"],

						Model[Item, Consumable, Sandpaper, "3M 1200 Grit Sandpaper"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},

						{"Work Surface", testBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,

							Available,
							Available,

							Available,

							Available
						},
					Name->
						{
							"Example bare reference electrode 1 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example bare reference electrode 2 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example bare reference electrode 3 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example AgCl reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example Pseudo Ag reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example model reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,

							"Example container with electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,
							"Example container without electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,

							"Example electrode rack for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID,

							"Example sandpaper for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID
						}
				];

				(* Upload the reference electrode that is in the container *)
				referenceElectrode9 = UploadSample[
					Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
					{"A1", container1},
					Name -> "Example bare reference electrode within container for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID
				];

					(* upload the test objects *)
					Upload[
						<|
							Object->#,
							AwaitingStorageUpdate->Null
						|> &/@Cases[
							Flatten[
								{
									(* Object Reference Electrodes *)
									referenceElectrode1, referenceElectrode2, referenceElectrode3,
									referenceElectrode4, referenceElectrode5, referenceElectrode6,
									referenceElectrode7, referenceElectrode8, referenceElectrode9,

									container1, container2,

									sandpaper
								}
							],
							ObjectP[]
						]
					];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Example bench for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for ValidExperimentPrepareReferenceElectrodeQ tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];




(* ::Subsection:: *)
(*ExperimentPrepareReferenceElectrodePreview*)


(* ------------------------------------------------ *)
(* -- ExperimentPrepareReferenceElectrodePreview -- *)
(* ------------------------------------------------ *)


DefineTests[ExperimentPrepareReferenceElectrodePreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentPrepareReferenceElectrode:"},
			ExperimentPrepareReferenceElectrodePreview[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID]
			],
			Null
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentPrepareReferenceElectrodeOptions:"},
			ExperimentPrepareReferenceElectrodeOptions[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID]
			],
			_Grid
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentPrepareReferenceElectrodeQ:"},
			ValidExperimentPrepareReferenceElectrodeQ[
				Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID]
			],
			True
		]
	},

	(*build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Example bench for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, sandpaper,

					(* Model Molecules and Samples *)
					solventSampleModelObject, testMolecule, testSolventSampleModel, referenceSolution, referenceCouplingSample,

					(* Model Reference Electrodes *)
					referenceElectrodeModel1,

					(* Object Reference Electrodes *)
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8, referenceElectrode9,

					(* Containers *)
					container1, container2,

					(* ElectrodeRack *)
					rack1,

					(* test user *)
					testUser
				},

				(* set up the test user *)
				testUser = Upload[<|
					Type -> Object[User, Emerald, Developer],
					Name -> "Example user for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID
				|>];

				(* set up test bench as a location for the vessel *)
				testBench = Upload[
					<|
						Type->Object[Container, Bench],
						Model->Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name->"Example bench for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
						DeveloperObject->True,
						StorageCondition->Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up test reference electrode model *)
				referenceElectrodeModel1 = Upload[<|
					Type -> Model[Item, Electrode, ReferenceElectrode],
					DeveloperObject -> True,
					Name -> "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
					Replace[Synonyms] -> {"Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID},
					Dimensions -> {3 Millimeter, 3 Millimeter, 64 Millimeter},
					DefaultStorageCondition -> Link[Model[StorageCondition,"Ambient Storage, Flammable"]],
					MaxNumberOfUses -> 200,
					Replace[WettedMaterials] -> {Silver,Glass},
					Replace[WiringConnectors] -> {{"Electrode Wiring Connector", ElectraSynElectrodeThreadedPlug, None}},
					WiringLength -> 64 Millimeter,

					BulkMaterial -> Silver,
					Coated -> False,
					ElectrodeShape -> Rod,
					ElectrodePackagingMaterial -> Glass,
					MinPotential -> -2.5 Volt,
					MaxPotential -> 2.5 Volt,
					MaxNumberOfPolishings -> 50,
					SonicationSensitive -> True,
					Preparable -> True,

					(* ReferenceElectrode Fields *)
					ReferenceElectrodeType-> "Ag/Ag+",
					Blank -> Link[Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]],
					RecommendedRefreshPeriod -> 2 Month,
					RecommendedSolventType -> Organic,
					ReferenceSolution -> Link[Model[Sample, StockSolution, "0.01M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]],
					SolutionVolume -> 1 Milliliter,
					ReferenceCouplingSample -> Link[Model[Sample, "Silver nitrate"]]
				|>];

				(* set up test solvent sample and solvent molecule *)
				solventSampleModelObject = CreateID[Model[Sample]];

				testMolecule = Upload[Association[
					Type -> Model[Molecule],
					Name -> "Example Molecule for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
					DefaultSampleModel -> Link[solventSampleModelObject]
				]];

				testSolventSampleModel = Upload[Association[
					Object -> solventSampleModelObject,
					Name -> "Example Solvent Sample for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
					Replace[Composition] -> {{100 VolumePercent, Link[testMolecule]}},
					Replace[Analytes] -> {
						Link[Model[Molecule, "Example Molecule for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID]]
					}
				]];

				(* set up test reference solution and reference coupling sample models *)
				referenceSolution = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example ReferenceSolution for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,

					Replace[Composition] -> {
						{100 VolumePercent, Link[Model[Molecule, "Water"]]},
						{1 Molar, Link[Model[Molecule, "Potassium Chloride"]]}
					},

					Solvent -> Link[Model[Sample, "Milli-Q water"]],

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				referenceCouplingSample = Upload[Association[
					Type -> Model[Sample],
					Name -> "Example Reference Coupling Sample for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,

					Replace[Analytes] -> {
						Link[Model[Molecule, "Potassium Chloride"]]
					}
				]];

				(* set up test reference electrodes and containers for our tests *)
				{
					referenceElectrode1, referenceElectrode2, referenceElectrode3,
					referenceElectrode4, referenceElectrode5, referenceElectrode6,
					referenceElectrode7, referenceElectrode8,

					container1, container2,

					rack1,

					sandpaper
				}=UploadSample[
					{
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "3M KCl Ag/AgCl Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "Pseudo Silver Wire Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.1M AgNO3 Ag/Ag+ Reference Electrode"],
						Model[Item, Electrode, ReferenceElectrode, "0.01M AgNO3 Ag/Ag+ Reference Electrode"],
						referenceElectrodeModel1,

						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],

						Model[Container, Rack, "Electrode Imaging Holder for IKA Electrodes"],

						Model[Item, Consumable, Sandpaper, "3M 1200 Grit Sandpaper"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},
						{"Work Surface", testBench},

						{"Work Surface", testBench},

						{"Work Surface", testBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,

							Available,
							Available,

							Available,

							Available
						},
					Name->
						{
							"Example bare reference electrode 1 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example bare reference electrode 2 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example bare reference electrode 3 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example AgCl reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example Pseudo Ag reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example Ag/Ag+ high concentration reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example Ag/Ag+ low concentration reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example model reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,

							"Example container with electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,
							"Example container without electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,

							"Example electrode rack for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID,

							"Example sandpaper for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID
						}
				];

				(* Upload the reference electrode that is in the container *)
				referenceElectrode9 = UploadSample[
					Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"],
					{"A1", container1},
					Name -> "Example bare reference electrode within container for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID
				];

					(* upload the test objects *)
					Upload[
						<|
							Object->#,
							AwaitingStorageUpdate->Null
						|> &/@Cases[
							Flatten[
								{
									(* Object Reference Electrodes *)
									referenceElectrode1, referenceElectrode2, referenceElectrode3,
									referenceElectrode4, referenceElectrode5, referenceElectrode6,
									referenceElectrode7, referenceElectrode8, referenceElectrode9,

									container1, container2,

									sandpaper
								}
							],
							ObjectP[]
						]
					];
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Example bench for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Sandpaper *)
					Object[Item, Consumable, Sandpaper, "Example sandpaper for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Model Molecules and Samples *)
					Model[Molecule, "Example Molecule for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Model[Sample, "Example Solvent Sample for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Model[Sample, "Example ReferenceSolution for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Model[Sample, "Example Reference Coupling Sample for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Model Reference Electrodes *)
					Model[Item, Electrode, ReferenceElectrode, "Example Reference Electrode Model for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Object Reference Electrodes *)
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 1 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 2 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode 3 for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example bare reference electrode within container for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example AgCl reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Pseudo Ag reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ high concentration reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example Ag/Ag+ low concentration reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Item, Electrode, ReferenceElectrode, "Example model reference electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Containers *)
					Object[Container, Vessel, "Example container with electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],
					Object[Container, Vessel, "Example container without electrode for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Electrode Rack *)
					Object[Container, Rack, "Example electrode rack for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID],

					(* Example user *)
					Object[User, Emerald, Developer, "Example user for ExperimentPrepareReferenceElectrodePreview tests " <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects=PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True, Verbose->False]
		]
	)
];

