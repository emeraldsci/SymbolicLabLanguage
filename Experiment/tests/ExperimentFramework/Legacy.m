(* ::Package:: *)

(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(* SampleManipulation framework (Deprecated) legacy unit tests *)



(* ::Subsection:: *)
(*Consolidation*)



DefineTests[Consolidation,
	{
		Example[{Basic,"Create a primitive for combining multiple samples into one empty container:"},
			Consolidation[
				Sources->{
					Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 2 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 3 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 4 in plate for Consolidation UnitOperation unit test "<>$SessionUUID]
				},
				Amounts->{100 Microliter,100 Microliter,200 Microliter,50 Microliter},
				Destination->Model[Container,Vessel,"2mL Tube"]
			],
			_Consolidation
		],
		Example[{Basic,"Combine a specific sample and a general chemical model into an existing sample:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID]
			],
			_Consolidation
		],
		Example[{Basic,"Combine a specific sample and a general chemical model into a generic container model:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Model[Container,Vessel,"2mL Tube"]
			],
			_Consolidation
		],
		Example[{Options,TipType,"Specify the tip model to use:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
			],
			_Consolidation
		],
		Example[{Options,TipSize,"Specify the tip size to use:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				TipSize->300 Microliter
			],
			_Consolidation
		],
		Example[{Options,TipType,"Specify the tip type and size to use:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				TipType->WideBore,
				TipSize->300 Microliter
			],
			_Consolidation
		],
		Example[{Options,TransferType,"Specify the nature of the Sources to help automatically determine other pipetting parameters:"},
			Consolidation[
				Sources->{Object[Sample,"My Slurry Sample for Consolidation UnitOperation unit test "<>$SessionUUID],Object[Sample,"My Slurry Sample for Consolidation UnitOperation unit test "<>$SessionUUID]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Model[Container,Vessel,"2mL Tube"],
				TransferType->Slurry
			],
			_Consolidation
		],
		Example[{Options,AspirationRate,"Specify the flow rate at which a Sources should be drawn into a pipette tip upon aspiration:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationRate->200 Microliter/Second
			],
			_Consolidation
		],
		Example[{Options,DispenseRate,"Specify the flow rate at which a Sources is expelled from the pipette tip as it is dispensed to the Destination:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseRate->10 Microliter/Second
			],
			_Consolidation
		],
		Example[{Options,OverAspirationVolume,"Specify the volume of air drawn into the pipette tip at the end of the aspiration of a liquid:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				OverAspirationVolume->30 Microliter
			],
			_Consolidation
		],
		Example[{Options,OverDispenseVolume,"Specify the volume of air drawn blown out at the end of the dispensing of a liquid:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				OverDispenseVolume->30 Microliter
			],
			_Consolidation
		],
		Example[{Options,AspirationWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after an aspiration:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationWithdrawalRate->0.5 Millimeter/Second
			],
			_Consolidation
		],
		Example[{Options,DispenseWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after a dispense:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseWithdrawalRate->5 Millimeter/Second
			],
			_Consolidation
		],
		Example[{Options,AspirationEquilibrationTime,"Specify the delay length the pipette waits after aspirating before it is removed from the liquid:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationEquilibrationTime->5 Second
			],
			_Consolidation
		],
		Example[{Options,DispenseEquilibrationTime,"Specify the delay length the pipette waits after dispensing before it is removed from the liquid:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseEquilibrationTime->0.5 Second
			],
			_Consolidation
		],
		Example[{Options,AspirationMix,"Indicate that the Sources should be mixed before aspirating:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter
			],
			_Consolidation
		],
		Example[{Options,AspirationNumberOfMixes,"Specify the number of times the Sources should be aspirated and dispensed quickly to mix before aspiration:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->10,
				AspirationMixVolume->150 Microliter
			],
			_Consolidation
		],
		Example[{Options,AspirationMixVolume,"Specify the volume of the Sources that should be aspirated and dispensed quickly to mix before aspiration:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->250 Microliter
			],
			_Consolidation
		],
		Example[{Options,AspirationMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter,
				AspirationMixRate->300 Microliter/Second
			],
			_Consolidation
		],
		Example[{Options,DispenseMix,"Indicate that the Destination should be mixed after dispensing the Sources. Mixing will occur after each source transfer, not just at the end:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->200 Microliter
			],
			_Consolidation
		],
		Example[{Options,DispenseNumberOfMixes,"Specify the number of times the Destination should be aspirated and dispensed quickly to mix after dispensing the Sources:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->10,
				DispenseMixVolume->150 Microliter
			],
			_Consolidation
		],
		Example[{Options,DispenseMixVolume,"Specify the volume of the Destination that should be aspirated and dispensed quickly to mix after dispensing the Sources:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter
			],
			_Consolidation
		],
		Example[{Options,DispenseMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid after a dispense:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter,
				DispenseMixRate->30 Microliter/Second
			],
			_Consolidation
		],
		Example[{Options,AspirationPosition,"Specify the location from which liquid should be aspirated:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationPosition->LiquidLevel,
				AspirationPositionOffset->3 Millimeter
			],
			_Consolidation
		],
		Example[{Options,DispensePosition,"Specify the location from which liquid should be dispensed:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispensePosition->Bottom,
				DispensePositionOffset->3 Millimeter
			],
			_Consolidation
		],
		Example[{Options,AspirationPositionOffset,"Specify the distance from the top of the container from which liquid should be aspirated:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				AspirationPosition->Top,
				AspirationPositionOffset->3 Millimeter
			],
			_Consolidation
		],
		Example[{Options,DispensePositionOffset,"Specify the distance from the top from which liquid should be dispensed:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DispensePosition->Top,
				DispensePositionOffset->3 Millimeter
			],
			_Consolidation
		],
		Example[{Options,PipettingMethod,"Specify a pipetting method object from which pipetting parameters should be used. Any additional specified pipetting parameters will override the object's value:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				PipettingMethod->Model[Method,Pipetting,"Aqueous"]
			],
			_Consolidation
		],
		Example[{Options,CorrectionCurve,"Specify the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				CorrectionCurve->{
					{0 Microliter,0 Microliter},
					{50 Microliter,60 Microliter},
					{150 Microliter,180 Microliter},
					{300 Microliter,345 Microliter}
				}
			],
			_Consolidation
		],
		Example[{Options,DynamicAspiration,"Indicate that the liquid(s) being transferred has a high vapor pressure and droplet prevention should be used:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Object[Sample,"Once Glorious Water Sample for Consolidation UnitOperation unit test "<>$SessionUUID],
				DynamicAspiration->True
			],
			_Consolidation
		],
		Example[{Options,InWellSeparation,"Indicate that droplets from multiple samples are transferred into and physically separated in the same destination well:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Nanoliter,100 Nanoliter},
				Destination->{Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],"A1"},
				InWellSeparation->True
			],
			_Consolidation
		],
		Example[{Attributes,Protected,"The Consolidation Head is protected:"},
			Consolidation[
				Sources->{Object[Sample,"Test chemical 1 in plate for Consolidation UnitOperation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
				Amounts->{20 Microliter,100 Microliter},
				Destination->Model[Container,Vessel,"2mL Tube"]
			],
			_Consolidation
		]
	}
];


(* ::Subsection:: *)
(*Define*)


DefineTests[Define,
	{
		Example[{Basic,"Create a primitive to tag a sample reference with a specified name:"},
			Define[
				Name->"My special sample's name",
				Sample->Object[Sample,"My special sample for Define UnitOperation unit test "<>$SessionUUID]
			],
			_Define
		],
		Example[{Basic,"Define a name for a model:"},
			Define[
				Name->"My named model reference",
				Sample->Model[Sample,"Methanol"]
			],
			_Define
		],
		Example[{Basic,"Define a name for a container:"},
			Define[
				Name->"My named container",
				Container->Object[Container,Vessel,"My vessel for Define UnitOperation unit test "<>$SessionUUID]
			],
			_Define
		],
		Example[{Basic,"Define a name for a container model:"},
			Define[
				Name->"My named container model",
				Container->Model[Container,Vessel,"2mL Tube"]
			],
			_Define
		],
		Example[{Basic,"Define a name for a sample at a particular location:"},
			Define[
				Name->"My named sample defined by its position",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3"
			],
			_Define
		],
		Example[{Additional,"Define a plate and a sample within that plate:"},
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Define[
					Name->"My Sample",
					Sample->{"My Plate","A1"}
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"My Sample",
					Amount->100 Microliter
				]
			},
			{_Define,_Define,_Transfer}
		],
		Example[{Options,Sample,"When the Sample key is specified, the Name refers to the specified sample or model:"},
			Define[
				Name->"My sample reference",
				Sample->Object[Sample,"My special sample for Define UnitOperation unit test "<>$SessionUUID]
			],
			_Define
		],
		Example[{Options,Container,"When the Container key is specified and the Well key is not specified, the Name refers to the specified container or container model:"},
			Define[
				Name->"My container reference",
				Container->Object[Container,Vessel,"My vessel for Define UnitOperation unit test "<>$SessionUUID]
			],
			_Define
		],
		Example[{Options,Well,"When the Container and Well keys are specified, the Name refers to the sample at this location (even if it does not yet exist):"},
			Define[
				Name->"My sample reference",
				Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				Well->"B1"
			],
			_Define
		],
		Example[{Options,ContainerName,"Name the container of a specified sample:"},
			Define[
				Name->"My sample reference",
				Sample->Object[Sample,"My chemical for Define UnitOperation unit test "<>$SessionUUID],
				ContainerName->"My sample's container reference"
			],
			_Define
		],
		Example[{Options,Model,"Specify the model of the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				Model->Model[Sample,StockSolution,"My special stock solution model"]
			],
			_Define
		],
		Example[{Options,StorageCondition,"Specify the storage condition of the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				StorageCondition->Refrigerator
			],
			_Define
		],
		Example[{Options,ExpirationDate,"Specify the expiration date of the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ExpirationDate->Now+2 Month
			],
			_Define
		],
		Example[{Options,SamplesOut,"Indicate that the sample which will be created should be included in the SamplesOut of the protocol:"},
			Define[
				Name->"My model reference",
				Container->Model[Sample,"Methanol"],
				SamplesOut->True
			],
			_Define
		],
		Example[{Options,ModelType,"Specify the type of the model created for the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelType->Model[Sample,StockSolution],
				ModelName->"My new model"
			],
			_Define
		],
		Example[{Options,ModelName,"Specify the name of the model created for the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution]
			],
			_Define
		],
		Example[{Options,TransportTemperature,"Specify the transportation temperature for the model created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				TransportTemperature->45 Celsius,
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution]
			],
			_Define
		],
		Example[{Options,State,"Specify the state of the model created for the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution],
				State->Liquid
			],
			_Define
		],
		Example[{Options,Expires,"Indicate if of the model created for the sample that will be created at a particular location will expire:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution],
				Expires->True
			],
			_Define
		],
		Example[{Options,ShelfLife,"Specify the shelf life of the model created for the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution],
				ShelfLife->2 Month
			],
			_Define
		],
		Example[{Options,UnsealedShelfLife,"Specify the unsealed shelf life of the model created for the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution],
				UnsealedShelfLife->1 Month
			],
			_Define
		],
		Example[{Options,DefaultStorageCondition,"Specify the storage condition of the model created for the sample that will be created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				ModelName->"My new model",
				ModelType->Model[Sample,StockSolution],
				DefaultStorageCondition->Freezer
			],
			_Define
		],
		Example[{Attributes,Protected,"The Define head is protected:"},
			Define[
				Name->"My name",
				Sample->Object[Sample,"Test chemical 1 in plate for Define UnitOperation unit test "<>$SessionUUID]
			],
			_Define
		]
	}
];



(* ::Subsection:: *)
(*MoveToMagnet*)


DefineTests[MoveToMagnet,
	{
		Example[{Basic,"Create a primitive to subject a container to magnetization:"},
			MoveToMagnet[
				Sample->Object[Container,Plate,"Test 96-well Plate for MoveToMagnet UnitOperation unit test "<>$SessionUUID]
			],
			_MoveToMagnet
		],
		Example[{Basic,"Create a primitive to subject a sample to magnetization:"},
			MoveToMagnet[
				Sample->Object[Sample,"Test Sample for MoveToMagnet UnitOperation unit test "<>$SessionUUID]
			],
			_MoveToMagnet
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjs
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Plate,"Test 96-well Plate for MoveToMagnet UnitOperation unit test "<>$SessionUUID],
						Object[Sample,"Test Sample for MoveToMagnet UnitOperation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs,Force->True,Verbose->False];
			$CreatedObjects={};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			Upload[<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
				Name->"Test 96-well Plate for MoveToMagnet UnitOperation unit test "<>$SessionUUID,
				DeveloperObject->True
			|>];

			UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",Object[Container,Plate,"Test 96-well Plate for MoveToMagnet UnitOperation unit test "<>$SessionUUID]},
				InitialAmount->1 Milliliter,
				Name->"Test Sample for MoveToMagnet UnitOperation unit test "<>$SessionUUID
			];
		];
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjs
			},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Plate,"Test 96-well Plate for MoveToMagnet UnitOperation unit test "<>$SessionUUID],
						Object[Sample,"Test Sample for MoveToMagnet UnitOperation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs,Force->True,Verbose->False];
			Unset[$CreatedObjects];
		]
	}
];



(* ::Subsection:: *)
(*ReadPlate*)


DefineTests[ReadPlate,
	{
		Example[{Basic,"Create a primitive for acquiring plate reader data of a set of samples:"},
			ReadPlate[
				Sample->{
					Object[Sample,"Test chemical 1 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 2 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 3 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 4 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID]
				},
				Type->AbsorbanceKinetics,
				Wavelength->200 Nanometer;;600 Nanometer,
				RunTime->10 Minute
			],
			_ReadPlate
		],
		Example[{Basic,"Specify the blanks for each Sample:"},
			ReadPlate[
				Sample->{
					Object[Sample,"Test chemical 1 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 2 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID]
				},
				Type->AbsorbanceKinetics,
				Wavelength->200 Nanometer;;600 Nanometer,
				RunTime->10 Minute,
				Blank->{
					Object[Sample,"Test chemical 3 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 4 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID]
				}
			],
			_ReadPlate
		],
		Example[{Basic,"Options for the corresponding Experiment function of the ReadPlate Type are available:"},
			ReadPlate[
				Sample->{
					Object[Sample,"Test chemical 1 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 2 in plate for ReadPlate UnitOperation unit test "<>$SessionUUID]
				},
				Type->FluorescenceSpectroscopy,
				PrimaryInjectionSample->{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				PrimaryInjectionVolume->{4 Microliter,4 Microliter},
				ExcitationWavelength->485 Nanometer,
				EmissionWavelength->590 Nanometer
			],
			_ReadPlate
		]
	}
];



(* ::Subsection:: *)
(*RemoveFromMagnet*)


DefineTests[RemoveFromMagnet,
	{
		Example[{Basic,"Create a primitive to remove a container from magnetization:"},
			RemoveFromMagnet[
				Sample->Object[Container,Plate,"Test 96-well Plate for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID]
			],
			_RemoveFromMagnet
		],
		Example[{Basic,"Create a primitive to remove a sample from magnetization:"},
			RemoveFromMagnet[
				Sample->Object[Sample,"Test Sample for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID]
			],
			_RemoveFromMagnet
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjs
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Plate,"Test 96-well Plate for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID],
						Object[Sample,"Test Sample for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs,Force->True,Verbose->False];
			$CreatedObjects={};

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			Upload[<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],
				Name->"Test 96-well Plate for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID,
				DeveloperObject->True
			|>];

			UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",Object[Container,Plate,"Test 96-well Plate for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID]},
				InitialAmount->1 Milliliter,
				Name->"Test Sample for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID
			];
		];
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjs
			},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Plate,"Test 96-well Plate for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID],
						Object[Sample,"Test Sample for RemoveFromMagnet UnitOperation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjs=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs,Force->True,Verbose->False];
			Unset[$CreatedObjects];
		]
	}
];


