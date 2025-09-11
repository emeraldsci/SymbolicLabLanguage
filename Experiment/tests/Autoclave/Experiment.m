(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentAutoclave: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*ExperimentAutoclave*)

DefineTests[ExperimentAutoclave,
	{
		(* Basic *)
		Example[{Basic, "Accepts a sample object:"},
			ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID]],
			ObjectP[Object[Protocol, Autoclave]]
		],
		Example[{Basic, "Accepts an empty container vessel object:"},
			ExperimentAutoclave[Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID]],
			ObjectP[Object[Protocol, Autoclave]]
		],
		Example[{Basic, "Accepts an empty container rack object:"},
			ExperimentAutoclave[Object[Container, Rack,"Test Empty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID]],
			ObjectP[Object[Protocol, Autoclave]]
		],
		Example[{Basic, "Accepts a mixture of sample objects, container objects, and empty container vessel objects:"},
			ExperimentAutoclave[{Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Object[Sample,"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID]}],
			ObjectP[Object[Protocol, Autoclave]]
		],
		(* Additional *)
		Example[{Additional,"Accepts a Model-less sample:"},
			ExperimentAutoclave[Object[Sample,"Model-less water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID]],
			ObjectP[Object[Protocol, Autoclave]]
		],
		(* Messages *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentAutoclave[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentAutoclave[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentAutoclave[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentAutoclave[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"InvalidAutoclaveContainer","If the input is a sample, it has to be in an Object[Container,Vessel]:"},
			ExperimentAutoclave[Object[Sample,"Available test 50 uL water sample in a plate for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InvalidAutoclaveContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidAutoclaveContainer","If the input is a container with contents, it has to be an Object[Container,Vessel], or failed:"},
			ExperimentAutoclave[Object[Container,Rack,"Test NonEmpty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InvalidAutoclaveContainer,
				Error::InvalidAutoclaveProgramForBags,
				Error::InvalidInput,
				Error::InvalidOption,
				Warning::OptionPattern
			}
		],
		Example[{Messages,"InvalidAutoclaveContainer","If the input is a container with contents, it has to be an Object[Container,Vessel]:"},
			ExperimentAutoclave[Object[Container,Rack,"Test NonEmpty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InvalidAutoclaveContainer,
				Error::InvalidAutoclaveProgramForBags,
				Error::InvalidInput,
				Error::InvalidOption,
				Warning::OptionPattern
			}
		],
		Example[{Messages,"DiscardedSamples","The input container cannot have a Status of Discarded:"},
			ExperimentAutoclave[{Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Discarded test container for ExperimentAutoclave" <> $SessionUUID]}],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedSamples","The input sample cannot have a Status of Discarded:"},
			ExperimentAutoclave[{Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Object[Sample,"Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID]}],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DuplicateAutoclaveInputs","Each input sample or container can only be present once in the list of ExperimentAutoclave inputs:"},
			ExperimentAutoclave[{Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID]}],
			$Failed,
			Messages:>{
				Error::DuplicateAutoclaveInputs,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NotEnoughAutoclaveSpace","The total footprint of the input objects cannot be larger than 0.25 square meters:"},
			ExperimentAutoclave[{Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID]}],
			$Failed,
			Messages:>{
				Error::NotEnoughAutoclaveSpace,
				Error::DuplicateAutoclaveInputs,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InputTooLargeForAutoclave","No inputs can have any dimension that is longer than 0.5 meters:"},
			ExperimentAutoclave[Object[Container,Vessel,"Too large container for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InputTooLargeForAutoclave,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidEmptyAutoclaveContainer","Any input empty container must have a MaxTemperature of 120 Celsius or higher:"},
			ExperimentAutoclave[Object[Container,Vessel,"Empty test 50mL Tube for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::InvalidEmptyAutoclaveContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"UnsafeAutoclaveContainerContents","Any contents of input containers must not be Flammable, Acid, Base, Pyrophoric, WaterReactive, or Radioactive:"},
			ExperimentAutoclave[Object[Container,Vessel,"Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::UnsafeAutoclaveContainerContents,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ContainerWithSolidContentsNotAutoclaveSafe","Any input container with Solid Contents must be autoclave-safe. Solids cannot be automatically transferred via Aliquot:"},
			ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with Solid Contents for ExperimentAutoclave" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ContainerWithSolidContentsNotAutoclaveSafe,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidAutoclaveProgramForBags","The AutoclaveProgram option cannot be set to Liquid if SterilizationBag is specified:"},
			ExperimentAutoclave[
				Object[Item,Septum,"Test Septum for ExperimentAutoclave"<>$SessionUUID],
				SterilizationBag->Model[Container,Bag,Autoclave,"Small Autoclave Bag"],
				AutoclaveProgram->Liquid
			],
			$Failed,
			Messages:>{
				Error::InvalidAutoclaveProgramForBags,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidAutoclaveProgram","The AutoclaveProgram option cannot be set to Universal if any of the inputs are a liquid or contains a liquid:"},
			ExperimentAutoclave[{Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID]},AutoclaveProgram->Universal],
			$Failed,
			Messages:>{
				Error::InvalidAutoclaveProgram,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DuplicateName","If the Name option is specified, it cannot be identical to an existing Object[Protocol,Autoclave] Name:"},
			ExperimentAutoclave[Object[Container,Vessel,"Test container 2 for ExperimentAutoclave" <> $SessionUUID],Name->"LegacyID:5"],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AutoclaveContainerTooFull","Any liquid samples must not have a higher Volume than 3/4 of the MaxVolume of the Container they are in:"},
			options=ExperimentAutoclave[Object[Container,Vessel,"Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclave" <> $SessionUUID],Output->Options];
			Lookup[options,Name,{}],
			Null,
			Messages:>{
				Warning::AutoclaveContainerTooFull
			},
			Variables :> {options}
		],
		Example[{Messages,"NonEmptyContainerNotAutoclaveSafe","Any liquid samples must be in autoclave-safe containers:"},
			options=ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID],Output->Options];
			Lookup[options,Name,{}],
			Null,
			Messages:>{
				Warning::NonEmptyContainerNotAutoclaveSafe
			},
			Variables :> {options}
		],
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs contain temporal links:"},
			ExperimentAutoclave[Link[Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Now]
			],
			ObjectP[Object[Protocol,Autoclave]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages,"InputTooLargeForAutoclaveBag","An Item assigned to be placed in an autoclave bag using the SterilizationBag Option must not be too large to fit in the bag:"},
			ExperimentAutoclave[
				Object[Item,"Test Large Item for ExperimentAutoclave" <> $SessionUUID],
				SterilizationBag -> Model[Container,Bag,Autoclave,"Large Autoclave Bag"]
			],
			$Failed,
			Messages:>{
				Error::InputTooLargeForAutoclaveBag,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleSterilizationMethods","A Warning is thrown if an input is specified to be placed in a sterilization bag that is incompatible with autoclaving:"},
			ExperimentAutoclave[
				Object[Item,Septum,"Test Septum for ExperimentAutoclave" <> $SessionUUID],
				SterilizationBag -> Object[Container,Bag,Autoclave,"Test Incompatible Autoclave Bag for ExperimentAutoclave" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,Autoclave]],
			Messages:>{
				Warning::IncompatibleSterilizationMethods
			}
		],
		Example[{Messages,"NoValidAutoclaveBagModels","An error is thrown if an input would be placed in an autoclave bag based on its Model's SterilizationBag Field, but no bag models that are compatible with autoclaving exist in the database:"},
			ExperimentAutoclave[
				Object[Item,Septum,"Test SterilizationBag Septum for ExperimentAutoclave" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::NoValidAutoclaveBagModels,
				Error::InvalidInput
			},
			Stubs:>{
				Experiment`Private`possibleAutoclaveBagModelsSearch[_]:={}
			}
		],

		(* Options *)
		Example[{Options,AutoclaveProgram,"When AutoclaveProgram -> Automatic, it is automatically resolved. In the following example, since the input is a liquid, AutoclaveProgram resolves to Liquid:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],AutoclaveProgram->Automatic,Output->Options];
			Lookup[options,AutoclaveProgram],
			Liquid,
			Variables :> {options}
		],
		Example[{Options,AutoclaveProgram,"When AutoclaveProgram -> Automatic, it is automatically resolved. In the following example, since the input is an empty container, AutoclaveProgram resolves to Universal:"},
			options=ExperimentAutoclave[Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],AutoclaveProgram->Automatic,Output->Options];
			Lookup[options,AutoclaveProgram],
			Universal,
			Variables :> {options}
		],
		Example[{Options,Instrument,"When Instrument->Automatic, it is automatically resolved to Model[Instrument,Autoclave,\"id:KBL5DvYl3z1N\"]:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Instrument->Automatic,Output->Options];
			Lookup[options,Instrument],
			Model[Instrument,Autoclave,"id:KBL5DvYl3z1N"],
			Variables :> {options}
		],
		Example[{Options,Instrument,"The function accepts an Instrument Object:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Instrument->Object[Instrument,Autoclave,"Test Autoclave Instrument for ExperimentAutoclave Tests" <> $SessionUUID],Output->Options];
			Lookup[options,Instrument],
			ObjectReferenceP[Object[Instrument,Autoclave,"Test Autoclave Instrument for ExperimentAutoclave Tests" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options,Confirm,"If Confirm -> True, skip InCart and go directly to Processing (or ShippingMaterials):"},
			Download[ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Confirm->True],Status],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			Download[ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],CanaryBranch -> "d1cacc5a-948b-4843-aa46-97406bbfc368"],CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options,Name,"Name the protocol for Autoclave:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Output->Options,Name->"Super cool test protocol"];
			Lookup[options,Name],
			"Super cool test protocol",
			Variables :> {options}
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentAutoclave[Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],Template->Object[Protocol,Autoclave,"Test Autoclave option template protocol" <> $SessionUUID],Output->Options];
			Lookup[options,Instrument],
			Object[Instrument, Autoclave, "id:4pO6dMWvnrd8"],
			Variables :> {options}
		],

		(* --- Sample Prep unit tests --- *)
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"],Output->Options];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->240
		],
		(* PreparatoryUnitOperations Option *)
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be autoclaved:"},
			options=ExperimentAutoclave[{"LB Sample Container 1","LB Sample Container 2"},
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"LB Sample Container 1",
						Container->Model[Container, Vessel, "2L Glass Bottle"]
					],
					LabelContainer[
						Label->"LB Sample Container 2",
						Container->Model[Container, Vessel, "1L Glass Bottle"]
					],
					Transfer[
						Source->Model[Sample, "LB Broth Miller"],
						Amount->20*Gram,
						Destination->"LB Sample Container 1"
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Amount->1*Liter,
						Destination->"LB Sample Container 1"
					],
					Transfer[
						Source->Model[Sample, "LB Broth Miller"],
						Amount->10*Gram,
						Destination->"LB Sample Container 2"
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Amount->500*Milliliter,
						Destination->"LB Sample Container 2"
					]
				},
				Output->Options
			];
			Lookup[options,AutoclaveProgram],
			Liquid,
			Variables :> {options}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], IncubateAliquot -> 300*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			300*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2L Glass Bottle"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], Centrifuge -> True,AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM,AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], CentrifugeTime -> 5*Minute,AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius,AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], CentrifugeAliquot -> 20*Milliliter,AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, CentrifugeAliquot],
			20*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], CentrifugeAliquotContainer->Model[Container, Vessel, "id:bq9LA0dBGGR6"],AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], Filtration -> True, Output -> Options,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"]];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclave" <> $SessionUUID], FiltrationType -> Syringe, FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"],Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclave" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], FilterMaterial -> PES,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], PrefilterMaterial -> GxF,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],FilterContainerOut->Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, FilterContainerOut->Model[Container, Vessel, "id:3em6Zv9NjjN8"],Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], FilterSterile -> True,FilterContainerOut->Model[Container, Vessel, "2L Glass Bottle, Sterile"], Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], FilterAliquot -> 300*Milliliter,FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterAliquot],
			300*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "1L Glass Bottle"],FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "1L Glass Bottle"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2L Glass Bottle"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], Aliquot->True, AliquotContainer->Model[Container, Vessel, "2L Glass Bottle"],Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentAutoclave[
				Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				AliquotContainer->Model[Container, Vessel, "2L Glass Bottle"],
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"mySample1"},
			Variables:>{options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], AliquotAmount -> 300*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			300*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], AssayVolume -> 300*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			300*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclave" <> $SessionUUID], TargetConcentration -> 5*Micromolar,AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentAutoclave[Object[Container,Vessel,"Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclave" <> $SessionUUID], TargetConcentration -> 5*Micromolar,TargetConcentrationAnalyte->Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentAutoclave Tests" <> $SessionUUID],AliquotContainer->Model[Container, Vessel, "250mL Glass Bottle"],Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectReferenceP[Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentAutoclave Tests" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->250*Milliliter,AssayVolume->500*Milliliter,AliquotContainer -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->250*Milliliter,AssayVolume->500*Milliliter,AliquotContainer -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->250*Milliliter,AssayVolume->500*Milliliter,AliquotContainer -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->250*Milliliter,AssayVolume->500*Milliliter,AliquotContainer -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, AliquotContainer->Model[Container, Vessel, "2L Glass Bottle"],Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "The non-default conditions under which any samples used by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator,Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual,AliquotContainer->Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2L Glass Bottle"]]}},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Messages :> {Warning::PostProcessingSterileSamples},
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Messages :> {Warning::PostProcessingSterileSamples},
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID], MeasureWeight -> False, Output -> Options];
			Lookup[options, MeasureWeight],
			False,
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],IncubateAliquotDestinationWell -> "A1",AliquotContainer->Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID],CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],FilterAliquotDestinationWell -> "A1",FilterContainerOut -> Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAutoclave[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],DestinationWell -> "A1",AliquotContainer->Model[Container, Vessel, "2L Glass Bottle"], Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options,SterilizationBag,"An input Item can be assigned to be placed into an autoclave bag using the SterilizationBag Option:"},
			options=ExperimentAutoclave[
				Object[Item,Septum,"Test Septum for ExperimentAutoclave" <> $SessionUUID],
				SterilizationBag -> Model[Container,Bag,Autoclave,"Small Autoclave Bag"],
				Output -> Options
			];
			Lookup[options,SterilizationBag],
			ObjectP[Model[Container,Bag,Autoclave]],
			Variables :> {options}
		],
		Example[{Options,SterilizationBag,"An input Item whose Model has SterilizationBag->True is automatically assigned to be placed into an autoclave bag:"},
			options=ExperimentAutoclave[
				{
					Object[Item,Septum,"Test SterilizationBag Septum for ExperimentAutoclave" <> $SessionUUID],
					Object[Item,Septum,"Test Septum for ExperimentAutoclave" <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options,SterilizationBag],
			{
				ObjectP[Model[Container,Bag,Autoclave]],
				Null
			},
			Variables :> {options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentAutoclave[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "id:J8AY5jwzPPR7"](* 250mL Glass Bottle *),
				PreparedModelAmount -> 10 Milliliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "id:J8AY5jwzPPR7"]]..},
				{EqualP[10 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentAutoclave[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "id:J8AY5jwzPPR7"](*250mL Glass Bottle*),
				PreparedModelAmount -> 10 Milliliter,
				Aliquot -> True,
				(* Had to include this as the default AliquotContainer was not Autoclave safe. *)
				AliquotContainer -> Model[Container, Vessel, "id:J8AY5jwzPPR7"],
				Mix -> True
			],
			ObjectP[Object[Protocol, Autoclave]]]
	},
	SetUp :> ($CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:> (

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Plate, "Test container 1 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Discarded test container for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Too large container for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 50mL Tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with Model-less water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Rack, "Test NonEmpty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Rack, "Test Empty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID],

				Object[Instrument, Autoclave, "Test Autoclave Instrument for ExperimentAutoclave Tests" <> $SessionUUID],

				Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentAutoclave Tests" <> $SessionUUID],

				Model[Sample, "10mer Test DNA for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 50 uL water sample in a plate for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Sodium Chloride test sample in a 50mL tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Model-less water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Protocol, Autoclave, "Test Autoclave option template protocol" <> $SessionUUID],


				Model[Item,Septum,"Test Septum Model for ExperimentAutoclave" <> $SessionUUID],
				Model[Item,Septum,"Test SterilizationBag Septum Model for ExperimentAutoclave" <> $SessionUUID],
				Model[Item,"Test Large Item Model for ExperimentAutoclave" <> $SessionUUID],
				Model[Container,Bag,Autoclave,"Test Incompatible Autoclave Bag Model for ExperimentAutoclave" <> $SessionUUID],

				Object[Item,Septum,"Test Septum for ExperimentAutoclave" <> $SessionUUID],
				Object[Item,Septum,"Test SterilizationBag Septum for ExperimentAutoclave" <> $SessionUUID],
				Object[Item,"Test Large Item for ExperimentAutoclave" <> $SessionUUID],
				Object[Item, Tips,"Available Hamilton barrier tips in Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID],
				Object[Container,Bag,Autoclave,"Test Incompatible Autoclave Bag for ExperimentAutoclave" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[PickList[allObjects,existsFilter], Force -> True, Verbose -> False]]
		];

		Module[
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12,
				emptyContainer13, emptyContainer14, emptyContainer15, emptyContainer16, fakeInstrument, available50MicroliterWaterSample,
				available500MilliliterWaterSample, discardedSample, discarded400MilliliterWaterSample, saltSample,
				available1800MilliliterWaterSample, available25MilliliterWaterSample, nHexaneSample,
				available1mLWaterSample, oligomerSample, modellessWaterSample,hamiltonTipInbox,
				testSeptumModel,testSterilizationBagSeptumModel,testLargeItemModel,testIncompatibleBagModel,
				testSeptum,testSterilizationBagSeptum,testLargeItem,testIncompatibleBag},

			(* Create some empty containers and fake instrument *)
			{
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12,
				emptyContainer13, emptyContainer14, emptyContainer15, emptyContainer16,
				fakeInstrument} = Upload[{
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
					Name -> "Test container 1 for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 2 for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Discarded test container for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 4 for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:o1k9jAKOwwB7"], Objects],
					Name -> "Too large container for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Empty test 50mL Tube for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with Solid Contents for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with Model-less water sample inside for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Rack],
					Model -> Link[Model[Container, Rack, "Sterile Hamilton Tip Box"], Objects],
					Name -> "Test NonEmpty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Rack],
					Model -> Link[Model[Container, Rack, "Sterile Hamilton Tip Box"], Objects],
					Name -> "Test Empty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Instrument, Autoclave],
					Model -> Link[Model[Instrument, Autoclave, "Unisteri 559-1ED"], Objects],
					Name -> "Test Autoclave Instrument for ExperimentAutoclave Tests" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(* Create a Model[Molecule,Oligomer] Identity Model for the TargetConcentration unit test *)
			Upload[
				<|
					Type -> Model[Molecule, Oligomer],
					Name -> "Test 10mer Model[Molecule,Oligomer] for ExperimentAutoclave Tests" <> $SessionUUID,
					PolymerType -> DNA,
					Molecule -> ToStrand["ACTGTGGACT"],
					DeveloperObject -> True
				|>
			];

			(* Create some Models for testing purposes *)
			Upload[
				<|
					Type -> Model[Sample],
					Name -> "10mer Test DNA for ExperimentAutoclave" <> $SessionUUID,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Replace[Composition] -> {
						{20 * Micromolar, Link[Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentAutoclave Tests" <> $SessionUUID]]},
						{100 * VolumePercent, Link[Model[Molecule, "Water"]]}
					}
				|>
			];

			(* Create some samples inside of containers for testing purposes *)
			{available50MicroliterWaterSample, available500MilliliterWaterSample, discardedSample, discarded400MilliliterWaterSample,
				saltSample, available1800MilliliterWaterSample, available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample,
				oligomerSample, modellessWaterSample,hamiltonTipInbox} = UploadSample[
				{
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:BYDOjv1VA88z"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:qdkmxzq019R1"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "10mer Test DNA for ExperimentAutoclave" <> $SessionUUID],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Item, Tips, "id:rea9jl1orrY3"]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer8},
					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13},
					{"A1", emptyContainer14},
					{"A1", emptyContainer15}
				},
				Name -> {
					"Available test 50 uL water sample in a plate for ExperimentAutoclave" <> $SessionUUID,
					"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					"Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					"Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					"Sodium Chloride test sample in a 50mL tube for ExperimentAutoclave" <> $SessionUUID,
					"Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					"Available test 25 mL water sample in a 50mL tube for ExperimentAutoclave" <> $SessionUUID,
					"Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID,
					"Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID,
					"Model-less water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID,
					"Available Hamilton barrier tips in Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID
				}
			];


			(* Make a test protocol for the Template option unit test *)
			Upload[
				{
					<|
						Type -> Object[Protocol, Autoclave],
						DeveloperObject -> True,
						Name -> "Test Autoclave option template protocol" <> $SessionUUID,
						ResolvedOptions -> {Instrument -> Object[Instrument, Autoclave, "id:4pO6dMWvnrd8"]}
					|>
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object -> available50MicroliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 50 * Microliter|>,
				<|Object -> available500MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 500 * Milliliter|>,
				<|Object -> emptyContainer3, Status -> Discarded|>,
				<|Object -> discarded400MilliliterWaterSample, Status -> Discarded, DeveloperObject -> True, Volume -> 400 * Milliliter|>,
				<|Object -> emptyContainer5, Status -> Available|>,
				<|Object -> emptyContainer6, Status -> Available|>,
				<|Object -> emptyContainer7, Status -> Available|>,
				<|Object -> saltSample, Status -> Available, DeveloperObject -> True, Mass -> 2 * Gram|>,
				<|Object -> available1800MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1800 * Milliliter|>,
				<|Object -> available25MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 25 * Milliliter|>,
				<|Object -> nHexaneSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Liter|>,
				<|Object -> available1mLWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>,
				<|Object -> oligomerSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>,
				<|Object -> modellessWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 500 * Milliliter, Model -> Null|>,
				<|Object -> hamiltonTipInbox, Status -> Available, DeveloperObject -> True|>
			}];

			(* Create Item Models for autoclave bag testing *)
			{
				testSeptumModel,
				testSterilizationBagSeptumModel,
				testLargeItemModel,
				testIncompatibleBagModel
			}=Upload[{
				<|
					Type->Model[Item,Septum],
					Name->"Test Septum Model for ExperimentAutoclave" <> $SessionUUID,
					Dimensions->{0.03 Meter,0.03 Meter,0.001 Meter},
					DeveloperObject->True
				|>,
				<|
					Type->Model[Item,Septum],
					Name->"Test SterilizationBag Septum Model for ExperimentAutoclave" <> $SessionUUID,
					Dimensions->{0.03 Meter,0.03 Meter,0.001 Meter},
					SterilizationBag->True,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Item],
					Name->"Test Large Item Model for ExperimentAutoclave" <> $SessionUUID,
					Dimensions->{0.30 Meter,0.30 Meter,0.30 Meter},
					DeveloperObject->True
				|>,
				<|
					Type->Model[Container,Bag,Autoclave],
					Name->"Test Incompatible Autoclave Bag Model for ExperimentAutoclave" <> $SessionUUID,
					Dimensions->{13.3 Centimeter,25.4 Centimeter,1 Millimeter},
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Open, MaxWidth -> 13.3 Centimeter, MaxDepth -> 25.4 Centimeter, MaxHeight -> 1 Millimeter|>},
					Replace[SterilizationMethods]->{EthyleneOxide,HydrogenPeroxide},
					DeveloperObject->True
				|>
			}];

			(* Create Item Objects for autoclave bag testing *)
			{
				testSeptum,
				testSterilizationBagSeptum,
				testLargeItem,
				testIncompatibleBag
			}=Upload[{
				<|
					Type->Object[Item,Septum],
					Model->Link[testSeptumModel,Objects],
					Name->"Test Septum for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					Status->Available,
					Restricted->True,
					DeveloperObject->True
				|>,
				<|
					Type->Object[Item,Septum],
					Model->Link[testSterilizationBagSeptumModel,Objects],
					Name->"Test SterilizationBag Septum for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					Status->Available,
					Restricted->True,
					DeveloperObject->True
				|>,
				<|
					Type->Object[Item],
					Model->Link[testLargeItemModel,Objects],
					Name->"Test Large Item for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					Status->Available,
					Restricted->True,
					DeveloperObject->True
				|>,
				<|
					Type->Object[Container,Bag,Autoclave],
					Model->Link[testIncompatibleBagModel,Objects],
					Name->"Test Incompatible Autoclave Bag for ExperimentAutoclave" <> $SessionUUID,
					Site->Link[$Site],
					Status->Available,
					Restricted->True,
					DeveloperObject->True
				|>
			}];

		];
	),
	SymbolTearDown :> (

		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Plate, "Test container 1 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Discarded test container for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Too large container for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 50mL Tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with Model-less water sample inside for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Rack, "Test NonEmpty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID],
				Object[Container, Rack, "Test Empty Hamilton Tip Box for ExperimentAutoclave" <> $SessionUUID],

				Object[Instrument, Autoclave, "Test Autoclave Instrument for ExperimentAutoclave Tests" <> $SessionUUID],

				Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentAutoclave Tests" <> $SessionUUID],

				Model[Sample, "10mer Test DNA for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 50 uL water sample in a plate for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Sodium Chloride test sample in a 50mL tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclave" <> $SessionUUID],
				Object[Sample, "Model-less water sample in a 2 L glass bottle for ExperimentAutoclave" <> $SessionUUID],
				Object[Protocol, Autoclave, "Test Autoclave option template protocol" <> $SessionUUID],

				Model[Item,Septum,"Test Septum Model for ExperimentAutoclave" <> $SessionUUID],
				Model[Item,Septum,"Test SterilizationBag Septum Model for ExperimentAutoclave" <> $SessionUUID],
				Model[Item,"Test Large Item Model for ExperimentAutoclave" <> $SessionUUID],
				Model[Container,Bag,Autoclave,"Test Incompatible Autoclave Bag Model for ExperimentAutoclave" <> $SessionUUID],

				Object[Item,Septum,"Test Septum for ExperimentAutoclave" <> $SessionUUID],
				Object[Item,Septum,"Test SterilizationBag Septum for ExperimentAutoclave" <> $SessionUUID],
				Object[Item,"Test Large Item for ExperimentAutoclave" <> $SessionUUID],
				Object[Item, Tips,"Available Hamilton barrier tips in Hamilton Tip Box for ExperimentAutoclave " <> $SessionUUID],
				Object[Container,Bag,Autoclave,"Test Incompatible Autoclave Bag for ExperimentAutoclave" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[PickList[allObjects,existsFilter], Force -> True, Verbose -> False]];
		];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsection::Closed:: *)
(* ExperimentAutoclaveOptions *)

DefineTests[
	ExperimentAutoclaveOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentAutoclaveOptions[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentAutoclaveOptions[Object[Sample,"Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentAutoclaveOptions[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Plate, "Test container 1 for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Discarded test container for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Too large container for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 50mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Model[Sample, "10mer Test DNA for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 50 uL water sample in a plate for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Sodium Chloride test sample in a 50mL tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[allObjects, existsFilter],
				Force -> True,
				Verbose -> False
			]];
		];

		Module[
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12,
				emptyContainer13, available50MicroliterWaterSample, available500MilliliterWaterSample, discardedSample,
				discarded400MilliliterWaterSample, saltSample, available1800MilliliterWaterSample,
				available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample, oligomerSample},

			(* Create some empty containers *)
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10,
				emptyContainer11, emptyContainer12, emptyContainer13} = Upload[{
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
					Name -> "Test container 1 for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 2 for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Discarded test container for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 4 for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:o1k9jAKOwwB7"], Objects],
					Name -> "Too large container for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Empty test 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Empty test 50mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with Solid Contents for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclaveOptions" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>
			}];

			(* Create some Models for testing purposes *)
			Upload[<|Type -> Model[Sample], Name -> "10mer Test DNA for ExperimentAutoclaveOptions" <> $SessionUUID, DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]], Replace[Composition] -> {{Null, Null}}|>];

			(* Create some samples for testing purposes *)
			{available50MicroliterWaterSample, available500MilliliterWaterSample, discardedSample, discarded400MilliliterWaterSample, saltSample, available1800MilliliterWaterSample,
				available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample, oligomerSample} = UploadSample[
				{
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:BYDOjv1VA88z"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:qdkmxzq019R1"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "10mer Test DNA for ExperimentAutoclaveOptions" <> $SessionUUID]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer8},
					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13}
				},
				Name -> {
					"Available test 50 uL water sample in a plate for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Sodium Chloride test sample in a 50mL tube for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Available test 25 mL water sample in a 50mL tube for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID,
					"Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object -> available50MicroliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 50 * Microliter|>,
				<|Object -> available500MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 500 * Milliliter|>,
				<|Object -> emptyContainer3, Status -> Discarded|>,
				<|Object -> discarded400MilliliterWaterSample, Status -> Discarded, DeveloperObject -> True, Volume -> 400 * Milliliter|>,
				<|Object -> emptyContainer5, Status -> Available|>,
				<|Object -> emptyContainer6, Status -> Available|>,
				<|Object -> emptyContainer7, Status -> Available|>,
				<|Object -> saltSample, Status -> Available, DeveloperObject -> True, Mass -> 2 * Gram|>,
				<|Object -> available1800MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1800 * Milliliter|>,
				<|Object -> available25MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 25 * Milliliter|>,
				<|Object -> nHexaneSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Liter|>,
				<|Object -> available1mLWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>,
				<|Object -> oligomerSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>
			}];
		]
	),
	SymbolTearDown:> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = {
				Object[Container, Plate, "Test container 1 for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Discarded test container for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Too large container for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Empty test 50mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclaveOptions" <> $SessionUUID],
				Model[Sample, "10mer Test DNA for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 50 uL water sample in a plate for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Sodium Chloride test sample in a 50mL tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID],
				Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclaveOptions" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[allObjects, existsFilter],
				Force -> True,
				Verbose -> False
			]];
		];
	),
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];

(* ExperimentAutoclavePreview *)
DefineTests[
	ExperimentAutoclavePreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentAutoclave:"},
			ExperimentAutoclavePreview[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentAutoclaveOptions:"},
			ExperimentAutoclaveOptions[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentAutoclaveQ[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID]],
			True
		]
	},
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects =
				{
					Object[Container, Plate, "Test container 1 for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Discarded test container for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Too large container for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Empty test 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Empty test 50mL Tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Model[Sample, "10mer Test DNA for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 50 uL water sample in a plate for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Sodium Chloride test sample in a 50mL tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 25 mL water sample in a 50mL tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclavePreview" <> $SessionUUID]
				};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		];
		Module[
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7,
				emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12, emptyContainer13,
				available50MicroliterWaterSample, available500MilliliterWaterSample, discardedSample,
				discarded400MilliliterWaterSample, saltSample, available1800MilliliterWaterSample,
				available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample, oligomerSample},

			(* Create some empty containers *)
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10,
				emptyContainer11, emptyContainer12, emptyContainer13} = Upload[{
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
					Name -> "Test container 1 for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 2 for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Discarded test container for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 4 for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:o1k9jAKOwwB7"], Objects],
					Name -> "Too large container for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Empty test 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Empty test 50mL Tube for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with Solid Contents for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with 25mL water sample inside for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclavePreview" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(* Create some Models for testing purposes *)
			Upload[<|Type -> Model[Sample], Name -> "10mer Test DNA for ExperimentAutoclavePreview" <> $SessionUUID, DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]], Replace[Composition] -> {{Null, Null}}|>];

			(* Create some samples for testing purposes *)
			{available50MicroliterWaterSample, available500MilliliterWaterSample, discardedSample, discarded400MilliliterWaterSample, saltSample, available1800MilliliterWaterSample,
				available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample, oligomerSample} = UploadSample[
				{
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:BYDOjv1VA88z"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:qdkmxzq019R1"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "10mer Test DNA for ExperimentAutoclavePreview" <> $SessionUUID]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer8},
					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13}
				},
				Name -> {
					"Available test 50 uL water sample in a plate for ExperimentAutoclavePreview" <> $SessionUUID,
					"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID,
					"Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID,
					"Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID,
					"Sodium Chloride test sample in a 50mL tube for ExperimentAutoclavePreview" <> $SessionUUID,
					"Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID,
					"Available test 25 mL water sample in a 50mL tube for ExperimentAutoclavePreview" <> $SessionUUID,
					"Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID,
					"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclavePreview" <> $SessionUUID,
					"Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclavePreview" <> $SessionUUID
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object -> available50MicroliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 50 * Microliter|>,
				<|Object -> available500MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 500 * Milliliter|>,
				<|Object -> emptyContainer3, Status -> Discarded|>,
				<|Object -> discarded400MilliliterWaterSample, Status -> Discarded, DeveloperObject -> True, Volume -> 400 * Milliliter|>,
				<|Object -> emptyContainer5, Status -> Available|>,
				<|Object -> emptyContainer6, Status -> Available|>,
				<|Object -> emptyContainer7, Status -> Available|>,
				<|Object -> saltSample, Status -> Available, DeveloperObject -> True, Mass -> 2 * Gram|>,
				<|Object -> available1800MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1800 * Milliliter|>,
				<|Object -> available25MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 25 * Milliliter|>,
				<|Object -> nHexaneSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Liter|>,
				<|Object -> available1mLWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>,
				<|Object -> oligomerSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter, Concentration -> 100 * Micromolar|>
			}];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects=
				{
					Object[Container,Plate,"Test container 1 for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Discarded test container for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test container 4 for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Too large container for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Empty test 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Empty test 50mL Tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test 50mL Tube with Solid Contents for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test 2 L glass bottle with 1.8 L water sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test 50mL Tube with 25mL water sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test 2 L glass bottle with 1 L of n-Hexane inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test 2 mL Tube with 1 mL water sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Container,Vessel,"Test 2 mL Tube with 1 mL oligomer sample inside for ExperimentAutoclavePreview" <> $SessionUUID],
					Model[Sample,"10mer Test DNA for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 50 uL water sample in a plate for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Discarded test 500 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Discarded test 400 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Sodium Chloride test sample in a 50mL tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 1800 mL water sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 25 mL water sample in a 50mL tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 1 L n-Hexane sample in a 2 L glass bottle for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 1 mL water sample in a 2 mL Tube for ExperimentAutoclavePreview" <> $SessionUUID],
					Object[Sample,"Available test 1 mL oligomer sample in a 2 mL Tube for ExperimentAutoclavePreview" <> $SessionUUID]
				};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter=DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
		]
	),
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];

(* ValidExperimentAutoclaveQ *)
DefineTests[
	ValidExperimentAutoclaveQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentAutoclaveQ[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentAutoclaveQ[Object[Container,Vessel,"Discarded test container for ValidExperimentAutoclaveQ" <> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentAutoclaveQ[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentAutoclaveQ[Object[Sample,"Available test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],Verbose->True],
			True
		]
	},
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects =
				{
					Object[Container, Plate, "Test container 1 for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Discarded test container for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Too large container for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Empty test 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Empty test 50mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Model[Sample, "10mer Test DNA for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 50 uL water sample in a plate for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Sodium Chloride test sample in a 50mL tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 25 mL water sample in a 50mL tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID]
				};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[allObjects, existsFilter],
				Force -> True,
				Verbose -> False
			]];

		];
		Module[
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12,
				emptyContainer13, emptyContainer14, emptyContainer15, available50MicroliterWaterSample, available500MilliliterWaterSample,
				discardedSample, discarded400MilliliterWaterSample, saltSample, available1800MilliliterWaterSample,
				available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample, oligomerSample},

			(* Create some empty containers *)
			{emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8, emptyContainer9, emptyContainer10,
				emptyContainer11, emptyContainer12, emptyContainer13} = Upload[{
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
					Name -> "Test container 1 for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 2 for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Discarded test container for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test container 4 for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:o1k9jAKOwwB7"], Objects],
					Name -> "Too large container for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Empty test 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Empty test 50mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with Solid Contents for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1.8 L water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], Objects],
					Name -> "Test 50mL Tube with 25mL water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"], Objects],
					Name -> "Test 2 L glass bottle with 1 L of n-Hexane inside for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:3em6Zv9NjjN8"], Objects],
					Name -> "Test 2 mL Tube with 1 mL oligomer sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID,
					Site->Link[$Site],
					DeveloperObject -> True
				|>
			}];

			(* Create some Models for testing purposes *)
			Upload[<|Type -> Model[Sample], Name -> "10mer Test DNA for ValidExperimentAutoclaveQ" <> $SessionUUID, DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]], Replace[Composition] -> {{Null, Null}}|>];

			(* Create some samples for testing purposes *)
			{available50MicroliterWaterSample, available500MilliliterWaterSample, discardedSample, discarded400MilliliterWaterSample, saltSample, available1800MilliliterWaterSample,
				available25MilliliterWaterSample, nHexaneSample, available1mLWaterSample, oligomerSample} = UploadSample[
				{
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:BYDOjv1VA88z"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:qdkmxzq019R1"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "10mer Test DNA for ValidExperimentAutoclaveQ" <> $SessionUUID]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer8},
					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13}
				},
				Name -> {
					"Available test 50 uL water sample in a plate for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Available test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Discarded test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Discarded test 400 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Sodium Chloride test sample in a 50mL tube for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Available test 1800 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Available test 25 mL water sample in a 50mL tube for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Available test 1 L n-Hexane sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Available test 1 mL water sample in a 2 mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID,
					"Available test 1 mL oligomer sample in a 2 mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object -> available50MicroliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 50 * Microliter|>,
				<|Object -> available500MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 500 * Milliliter|>,
				<|Object -> emptyContainer3, Status -> Discarded|>,
				<|Object -> discarded400MilliliterWaterSample, Status -> Discarded, DeveloperObject -> True, Volume -> 400 * Milliliter|>,
				<|Object -> emptyContainer5, Status -> Available|>,
				<|Object -> emptyContainer6, Status -> Available|>,
				<|Object -> emptyContainer7, Status -> Available|>,
				<|Object -> saltSample, Status -> Available, DeveloperObject -> True, Mass -> 2 * Gram|>,
				<|Object -> available1800MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1800 * Milliliter|>,
				<|Object -> available25MilliliterWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 25 * Milliliter|>,
				<|Object -> nHexaneSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Liter|>,
				<|Object -> available1mLWaterSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter|>,
				<|Object -> oligomerSample, Status -> Available, DeveloperObject -> True, Volume -> 1 * Milliliter, Concentration -> 100 * Micromolar|>
			}];
		];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjects, existsFilter},
			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects =
				{
					Object[Container, Plate, "Test container 1 for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Discarded test container for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Too large container for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Empty test 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Empty test 50mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube with Solid Contents for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 L glass bottle with 1.8 L water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube with 25mL water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 L glass bottle with 1 L of n-Hexane inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 mL Tube with 1 mL water sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Container, Vessel, "Test 2 mL Tube with 1 mL oligomer sample inside for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Model[Sample, "10mer Test DNA for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 50 uL water sample in a plate for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Discarded test 500 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Discarded test 400 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Sodium Chloride test sample in a 50mL tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1800 mL water sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 25 mL water sample in a 50mL tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1 L n-Hexane sample in a 2 L glass bottle for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1 mL water sample in a 2 mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID],
					Object[Sample, "Available test 1 mL oligomer sample in a 2 mL Tube for ValidExperimentAutoclaveQ" <> $SessionUUID]
				};

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[allObjects, existsFilter],
				Force -> True,
				Verbose -> False
			]];

		]
	),
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];
