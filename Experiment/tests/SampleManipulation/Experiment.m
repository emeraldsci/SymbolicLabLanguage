(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Manipulation Primitives*)


(* ::Subsubsection::Closed:: *)
(*Transfer*)


DefineTests[Transfer,
	{
		Example[{Basic,"Create a transfer manipulation primitive for a transfer from a source sample to an empty destination container:"},
			Transfer[
				Source->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->25 Milliliter,
				Destination->Object[Container,Vessel,"Test 50mL tube for Transfer UnitOperation unit test "<>$SessionUUID]
			],
			_Transfer
		],
		Example[{Basic,"Create a transfer manipulation primitive for a transfer from a source sample to another existing sample:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID]
			],
			_Transfer
		],
		Example[{Basic,"Create a transfer primitive for moving a chemical to an empty container without requesting a particular sample:"},
			Transfer[
				Source->Model[Sample,"Methanol"],
				Amount->10 Milliliter,
				Destination->Object[Container,Vessel,"Test 50mL tube for Transfer UnitOperation unit test "<>$SessionUUID]
			],
			_Transfer
		],
		Example[{Additional,"Transfer primitives can also contain solid amounts:"},
			Transfer[
				Source->Model[Sample,"Sodium Chloride"],
				Amount->5 Gram,
				Destination->Object[Container,Vessel,"Test 50mL tube for Transfer UnitOperation unit test "<>$SessionUUID]
			],
			_Transfer
		],
		Example[{Options,TipType,"Specify the tip model to use:"},
			Transfer[
				Source -> Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->250 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
			],
			_Transfer
		],
		Example[{Options,TipSize,"Specify the tip size to use:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->250 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				TipSize->300 Microliter
			],
			_Transfer
		],
		Example[{Options,TipType,"Specify the tip type and size to use:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->250 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				TipType->WideBore,
				TipSize->300 Microliter
			],
			_Transfer
		],
		Example[{Options,Resuspension,"Indicate that the transfer is intended to resuspend a solid destination sample:"},
			Transfer[
				Source->Model[Sample,"Methanol"],
				Amount->250 Microliter,
				Destination->Object[Sample,"My Lyophilized Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				Resuspension->True
			],
			_Transfer
		],
		Example[{Options,TransferType,"Specify the nature of the Source sample to help automatically determine other pipetting parameters:"},
			Transfer[
				Source->Object[Sample,"My Slurry Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->250 Microliter,
				Destination->Model[Container,Vessel,"2mL Tube"],
				TransferType->Slurry
			],
			_Transfer
		],
		Example[{Options,AspirationRate,"Specify the flow rate at which a Source should be drawn into a pipette tip upon aspiration:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationRate->200 Microliter/Second
			],
			_Transfer
		],
		Example[{Options,DispenseRate,"Specify the flow rate at which a Source is expelled from the pipette tip as it is dispensed to the Destination:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseRate->10 Microliter/Second
			],
			_Transfer
		],
		Example[{Options,OverAspirationVolume,"Specify the volume of air drawn into the pipette tip at the end of the aspiration of a liquid:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				OverAspirationVolume->30 Microliter
			],
			_Transfer
		],
		Example[{Options,OverDispenseVolume,"Specify the volume of air drawn blown out at the end of the dispensing of a liquid:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				OverDispenseVolume->30 Microliter
			],
			_Transfer
		],
		Example[{Options,AspirationWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after an aspiration:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationWithdrawalRate->0.5 Millimeter/Second
			],
			_Transfer
		],
		Example[{Options,DispenseWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after a dispense:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseWithdrawalRate->5 Millimeter/Second
			],
			_Transfer
		],
		Example[{Options,AspirationEquilibrationTime,"Specify the delay length the pipette waits after aspirating before it is removed from the liquid:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationEquilibrationTime->5 Second
			],
			_Transfer
		],
		Example[{Options,DispenseEquilibrationTime,"Specify the delay length the pipette waits after dispensing before it is removed from the liquid:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseEquilibrationTime->0.5 Second
			],
			_Transfer
		],
		Example[{Options,AspirationMix,"Indicate that the Source should be mixed before aspirating:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter
			],
			_Transfer
		],
		Example[{Options,AspirationNumberOfMixes,"Specify the number of times the Source should be aspirated and dispensed quickly to mix before aspiration:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->10,
				AspirationMixVolume->150 Microliter
			],
			_Transfer
		],
		Example[{Options,AspirationMixVolume,"Specify the volume of the Source that should be aspirated and dispensed quickly to mix before aspiration:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->250 Microliter
			],
			_Transfer
		],
		Example[{Options,AspirationMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter,
				AspirationMixRate->300 Microliter/Second
			],
			_Transfer
		],
		Example[{Options,DispenseMix,"Indicate that the Destination should be mixed after dispensing the Source:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->200 Microliter
			],
			_Transfer
		],
		Example[{Options,DispenseNumberOfMixes,"Specify the number of times the Destination should be aspirated and dispensed quickly to mix after dispensing the source:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->10,
				DispenseMixVolume->150 Microliter
			],
			_Transfer
		],
		Example[{Options,DispenseMixVolume,"Specify the volume of the Destination that should be aspirated and dispensed quickly to mix after dispensing the source:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter
			],
			_Transfer
		],
		Example[{Options,DispenseMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid after a dispense:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter,
				DispenseMixRate->30 Microliter/Second
			],
			_Transfer
		],
		Example[{Options,AspirationPosition,"Specify the location from which liquid should be aspirated:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationPosition->LiquidLevel,
				AspirationPositionOffset->3 Millimeter
			],
			_Transfer
		],
		Example[{Options,DispensePosition,"Specify the location from which liquid should be dispensed:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispensePosition->Bottom,
				DispensePositionOffset->3 Millimeter
			],
			_Transfer
		],
		Example[{Options,AspirationPositionOffset,"Specify the distance from the top of the container from which liquid should be aspirated:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				AspirationPosition->Top,
				AspirationPositionOffset->3 Millimeter
			],
			_Transfer
		],
		Example[{Options,DispensePositionOffset,"Specify the distance from the top from which liquid should be dispensed:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DispensePosition->Top,
				DispensePositionOffset->3 Millimeter
			],
			_Transfer
		],
		Example[{Options,PipettingMethod,"Specify a pipetting method object from which pipetting parameters should be used. Any additional specified pipetting parameters will override the object's value:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				PipettingMethod->Model[Method,Pipetting,"Aqueous"]
			],
			_Transfer
		],
		Example[{Options,CorrectionCurve,"Specify the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				CorrectionCurve->{
					{0 Microliter,0 Microliter},
					{50 Microliter,60 Microliter},
					{150 Microliter,180 Microliter},
					{300 Microliter,345 Microliter}
				}
			],
			_Transfer
		],
		Example[{Options,DynamicAspiration,"Indicate that the liquid being transferred has a high vapor pressure and droplet prevention should be used:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->250 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for Transfer UnitOperation unit test "<>$SessionUUID],
				DynamicAspiration->True
			],
			_Transfer
		],
		Example[{Options,InWellSeparation,"Indicate that droplets from multiple samples are transferred into and physically separated in the same destination well:"},
			Transfer[
				Source->Object[Sample,"Test chemical 1 in plate for Transfer UnitOperation unit test "<>$SessionUUID],
				Amount->100 Nanoliter,
				Destination->{Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],"A1"},
				InWellSeparation->True
			],
			_Transfer
		],
		Example[{Attributes,Protected,"The Transfer Head is protected:"},
			Transfer[
				Source->Model[Sample,"Sodium Chloride"],
				Amount->5 Gram,
				Destination->Object[Container,Vessel,"Test 50mL tube for Transfer UnitOperation unit test "<>$SessionUUID]
			],
			_Transfer
		]
	}
];


(* ::Subsubsection:: *)
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


(* ::Subsubsection:: *)
(*Resuspend*)


DefineTests[Resuspend,
	{
		Example[{Basic,"Create a resuspend manipulation primitive for the resuspension of a solid sample in its current container:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->25 Milliliter
			],
			_Resuspend
		],
		Example[{Basic,"Create a resuspend primitive for the resuspension of a solid sample using strings from a define primitive:"},
			Resuspend[
				Sample->"Source Salt Sample for Resuspend UnitOperation unit test "<>$SessionUUID,
				Volume->10 Milliliter
			],
			_Resuspend
		],
		Example[{Basic,"Resuspend primitives can also contain counted amounts:"},
			Resuspend[
				Sample->Object[Sample,"Ibuprofen Sample (10 Tablets) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->40 Milliliter
			],
			_Resuspend
		],
		Example[{Options,Volume,"Specify how much Diluent should be used to resuspend the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->10 Milliliter
			],
			_Resuspend
		],
		Example[{Options,Diluent,"Specify what diluent in which to resuspend the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Ibuprofen Sample (10 Tablets) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->10 Milliliter,
				Diluent->Model[Sample,"Methanol"]
			],
			_Resuspend
		],
		Example[{Options,MixType,"Specify how the sample should be mixed after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->25 Milliliter,
				MixType->Invert
			],
			_Resuspend
		],
		Example[{Options,MixUntilDissolved,"Specify if the sample should be mixed until it is dissolved after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->25 Milliliter,
				MixUntilDissolved->True
			],
			_Resuspend
		],
		Example[{Options,MixVolume,"Specify if the volume with which to mix the sample by pipetting after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				MixType->Pipette,
				MixVolume->1 Milliliter
			],
			_Resuspend
		],
		Example[{Options,NumberOfMixes,"Specify if the number of mixes with which to mix the sample by pipetting or inversion after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				MixType->Invert,
				NumberOfMixes->12
			],
			_Resuspend
		],
		Example[{Options,MaxNumberOfMixes,"Specify if the maximum number of mixes with which to mix the sample by pipetting or inversion if MixUntilDissolved -> True after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				MixType->Invert,
				MixUntilDissolved->True,
				MaxNumberOfMixes->24
			],
			_Resuspend
		],
		Example[{Options,IncubationTime,"Specify if the length of time the sample is mixed/incubated after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				IncubationTime->10 Minute
			],
			_Resuspend
		],
		Example[{Options,MaxIncubationTime,"Specify if the maximum length of time the sample is mixed/incubated until dissolved after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				MixUntilDissolved->True,
				IncubationTime->10 Minute,
				MaxIncubationTime->20 Minute
			],
			_Resuspend
		],
		Example[{Options,IncubationTemperature,"Specify if the temperature at which the sample is mixed/incubated after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				IncubationTemperature->50 Celsius,
				IncubationTime->10 Minute
			],
			_Resuspend
		],
		Example[{Options,IncubationInstrument,"Specify if the instrument that performs the mixing/incubating of the sample after diluent is added to the source sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				IncubationInstrument->Model[Instrument,Shaker,"Genie Temp-Shaker 300"],
				IncubationTime->10 Minute
			],
			_Resuspend
		],
		Example[{Options,AnnealingTime,"Specify the minimum duration for which the sample should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passe:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->2 Milliliter,
				IncubationTime->10 Minute,
				AnnealingTime->10 Minute
			],
			_Resuspend
		],
		Example[{Options,TipType,"Specify the tip model to use for transferring the diluent to resuspend the sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->250 Microliter,
				TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
			],
			_Resuspend
		],
		Example[{Options,TipSize,"Specify the tip size to use for transferring the diluent to resuspend the sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->250 Microliter,
				TipSize->300 Microliter
			],
			_Resuspend
		],
		Example[{Options,TipType,"Specify the tip type and size to use:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->250 Microliter,
				TipType->WideBore,
				TipSize->300 Microliter
			],
			_Resuspend
		],
		Example[{Options,AspirationRate,"Specify the flow rate at which a Diluent should be drawn into a pipette tip upon aspiration:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationRate->200 Microliter/Second
			],
			_Resuspend
		],
		Example[{Options,DispenseRate,"Specify the flow rate at which a Diluent is expelled from the pipette tip as it is dispensed to the sample:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseRate->200 Microliter/Second
			],
			_Resuspend
		],
		Example[{Options,OverAspirationVolume,"Specify the volume of air drawn into the pipette tip at the end of the aspiration of a liquid:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				OverAspirationVolume->30 Microliter
			],
			_Resuspend
		],
		Example[{Options,OverDispenseVolume,"Specify the volume of air drawn blown out at the end of the dispensing of a liquid:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				OverDispenseVolume->30 Microliter
			],
			_Resuspend
		],
		Example[{Options,AspirationWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after an aspiration:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationWithdrawalRate->0.5 Millimeter/Second
			],
			_Resuspend
		],
		Example[{Options,DispenseWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after a dispense:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseWithdrawalRate->5 Millimeter/Second
			],
			_Resuspend
		],
		Example[{Options,AspirationEquilibrationTime,"Specify the delay length the pipette waits after aspirating before it is removed from the liquid:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationEquilibrationTime->5 Second
			],
			_Resuspend
		],
		Example[{Options,DispenseEquilibrationTime,"Specify the delay length the pipette waits after dispensing before it is removed from the liquid:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseEquilibrationTime->0.5 Second
			],
			_Resuspend
		],
		Example[{Options,AspirationMix,"Indicate that the Diluent should be mixed before aspirating:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter
			],
			_Resuspend
		],
		Example[{Options,AspirationNumberOfMixes,"Specify the number of times the Diluent should be aspirated and dispensed quickly to mix before aspiration:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->10,
				AspirationMixVolume->150 Microliter
			],
			_Resuspend
		],
		Example[{Options,AspirationMixVolume,"Specify the volume of the Diluent that should be aspirated and dispensed quickly to mix before aspiration:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->250 Microliter
			],
			_Resuspend
		],
		Example[{Options,AspirationMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter,
				AspirationMixRate->300 Microliter/Second
			],
			_Resuspend
		],
		Example[{Options,DispenseMix,"Indicate that the sample should be mixed after dispensing the Diluent:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->200 Microliter
			],
			_Resuspend
		],
		Example[{Options,DispenseNumberOfMixes,"Specify the number of times the Diluent should be aspirated and dispensed quickly to mix after dispensing the diluent:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->10,
				DispenseMixVolume->150 Microliter
			],
			_Resuspend
		],
		Example[{Options,DispenseMixVolume,"Specify the volume of the Diluent that should be aspirated and dispensed quickly to mix after dispensing the source:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter
			],
			_Resuspend
		],
		Example[{Options,DispenseMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid after a dispense:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter,
				DispenseMixRate->30 Microliter/Second
			],
			_Resuspend
		],
		Example[{Options,AspirationPosition,"Specify the location from which liquid should be aspirated:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationPosition->LiquidLevel,
				AspirationPositionOffset->3 Millimeter
			],
			_Resuspend
		],
		Example[{Options,DispensePosition,"Specify the location from which liquid should be dispensed:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispensePosition->Bottom,
				DispensePositionOffset->3 Millimeter
			],
			_Resuspend
		],
		Example[{Options,AspirationPositionOffset,"Specify the distance from the top of the container from which liquid should be aspirated:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				AspirationPosition->Top,
				AspirationPositionOffset->3 Millimeter
			],
			_Resuspend
		],
		Example[{Options,DispensePositionOffset,"Specify the distance from the top from which liquid should be dispensed:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DispensePosition->Top,
				DispensePositionOffset->3 Millimeter
			],
			_Resuspend
		],
		Example[{Options,PipettingMethod,"Specify a pipetting method object from which pipetting parameters should be used. Any additional specified pipetting parameters will override the object's value:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				PipettingMethod->Model[Method,Pipetting,"Aqueous"]
			],
			_Resuspend
		],
		Example[{Options,CorrectionCurve,"Specify the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				CorrectionCurve->{
					{0 Microliter,0 Microliter},
					{50 Microliter,60 Microliter},
					{150 Microliter,180 Microliter},
					{300 Microliter,345 Microliter}
				}
			],
			_Resuspend
		],
		Example[{Options,DynamicAspiration,"Indicate that the liquid being transferred has a high vapor pressure and droplet prevention should be used:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID],
				DynamicAspiration->True
			],
			_Resuspend
		],
		Example[{Attributes,Protected,"The Resuspend Head is protected:"},
			Resuspend[
				Sample->Object[Sample,"Salt Sample 2 (150 Milligram) for Resuspend UnitOperation unit test "<>$SessionUUID],
				Volume->300 Microliter,
				Diluent->Object[Sample,"Once Glorious Water Sample for Resuspend UnitOperation unit test "<>$SessionUUID]
			],
			_Resuspend
		]
	}
];


(* ::Subsubsection:: *)
(*Aliquot*)


DefineTests[Aliquot,
	{
		Example[{Basic,"Create a primitive for adding a chemical model to multiple samples:"},
			Aliquot[
				Source->Model[Sample,"Methanol"],
				Amounts->{100 Microliter,100 Microliter,100 Microliter,100 Microliter},
				Destinations->{
					Object[Sample,"Test chemical 1 in plate for Aliquot UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 2 in plate for Aliquot UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 3 in plate for Aliquot UnitOperation unit test "<>$SessionUUID],
					Object[Sample,"Test chemical 4 in plate for Aliquot UnitOperation unit test "<>$SessionUUID]
				}
			],
			_Aliquot
		],
		Example[{Basic,"Create a primitive that will aliquot a buffer solution into a series of empty tubes:"},
			Aliquot[
				Source->Model[Sample,StockSolution,"70% Ethanol"],
				Amounts->{50 Milliliter,50 Milliliter,50 Milliliter},
				Destinations->{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				}
			],
			_Aliquot
		],
		Example[{Basic,"Create a primitive for dividing an existing sample between multiple empty plate wells:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				}
			],
			_Aliquot
		],
		Example[{Options,TipType,"Specify the tip model to use:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
			],
			_Aliquot
		],
		Example[{Options,TipSize,"Specify the tip size to use:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				TipSize->300 Microliter
			],
			_Aliquot
		],
		Example[{Options,TipType,"Specify the tip type and size to use:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				TipType->WideBore,
				TipSize->300 Microliter
			],
			_Aliquot
		],
		Example[{Options,TransferType,"Specify the nature of the Source sample to help automatically determine other pipetting parameters:"},
			Aliquot[
				Source->Object[Sample,"My Slurry Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amount->250 Microliter,
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				TransferType->Slurry
			],
			_Aliquot
		],
		Example[{Options,AspirationRate,"Specify the flow rate at which a Source should be drawn into a pipette tip upon aspiration:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationRate->200 Microliter/Second
			],
			_Aliquot
		],
		Example[{Options,DispenseRate,"Specify the flow rate at which a Source is expelled from the pipette tip as it is dispensed to the Destinations:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseRate->10 Microliter/Second
			],
			_Aliquot
		],
		Example[{Options,OverAspirationVolume,"Specify the volume of air drawn into the pipette tip at the end of the aspiration of a liquid:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				OverAspirationVolume->30 Microliter
			],
			_Aliquot
		],
		Example[{Options,OverDispenseVolume,"Specify the volume of air drawn blown out at the end of the dispensing of a liquid:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				OverDispenseVolume->30 Microliter
			],
			_Aliquot
		],
		Example[{Options,AspirationWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after an aspiration:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationWithdrawalRate->0.5 Millimeter/Second
			],
			_Aliquot
		],
		Example[{Options,DispenseWithdrawalRate,"Specify the speed at which the pipette is removed from the liquid after a dispense:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseWithdrawalRate->5 Millimeter/Second
			],
			_Aliquot
		],
		Example[{Options,AspirationEquilibrationTime,"Specify the delay length the pipette waits after aspirating before it is removed from the liquid:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationEquilibrationTime->5 Second
			],
			_Aliquot
		],
		Example[{Options,DispenseEquilibrationTime,"Specify the delay length the pipette waits after dispensing before it is removed from the liquid:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseEquilibrationTime->0.5 Second
			],
			_Aliquot
		],
		Example[{Options,AspirationMix,"Indicate that the Source should be mixed before aspirating:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter
			],
			_Aliquot
		],
		Example[{Options,AspirationNumberOfMixes,"Specify the number of times the Source should be aspirated and dispensed quickly to mix before aspiration:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationMix->True,
				AspirationNumberOfMixes->10,
				AspirationMixVolume->150 Microliter
			],
			_Aliquot
		],
		Example[{Options,AspirationMixVolume,"Specify the volume of the Source that should be aspirated and dispensed quickly to mix before aspiration:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->250 Microliter
			],
			_Aliquot
		],
		Example[{Options,AspirationMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid before it is aspirated:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationMix->True,
				AspirationNumberOfMixes->3,
				AspirationMixVolume->150 Microliter,
				AspirationMixRate->300 Microliter/Second
			],
			_Aliquot
		],
		Example[{Options,DispenseMix,"Indicate that the Destinations should be mixed after dispensing the Source:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->200 Microliter
			],
			_Aliquot
		],
		Example[{Options,DispenseNumberOfMixes,"Specify the number of times the Destinations should be aspirated and dispensed quickly to mix after dispensing the source:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseMix->True,
				DispenseNumberOfMixes->10,
				DispenseMixVolume->150 Microliter
			],
			_Aliquot
		],
		Example[{Options,DispenseMixVolume,"Specify the volume of the Destinations that should be aspirated and dispensed quickly to mix after dispensing the source:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter
			],
			_Aliquot
		],
		Example[{Options,DispenseMixRate,"Specify the speed at which liquid is aspirated and dispensed in a liquid after a dispense:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispenseMix->True,
				DispenseNumberOfMixes->3,
				DispenseMixVolume->250 Microliter,
				DispenseMixRate->30 Microliter/Second
			],
			_Aliquot
		],
		Example[{Options,AspirationPosition,"Specify the location from which liquid should be aspirated:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationPosition->LiquidLevel,
				AspirationPositionOffset->3 Millimeter
			],
			_Aliquot
		],
		Example[{Options,DispensePosition,"Specify the location from which liquid should be dispensed:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispensePosition->Bottom,
				DispensePositionOffset->3 Millimeter
			],
			_Aliquot
		],
		Example[{Options,AspirationPositionOffset,"Specify the distance from the top of the container from which liquid should be aspirated:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				AspirationPosition->Top,
				AspirationPositionOffset->3 Millimeter
			],
			_Aliquot
		],
		Example[{Options,DispensePositionOffset,"Specify the distance from the top from which liquid should be dispensed:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DispensePosition->Top,
				DispensePositionOffset->3 Millimeter
			],
			_Aliquot
		],
		Example[{Options,PipettingMethod,"Specify a pipetting method object from which pipetting parameters should be used. Any additional specified pipetting parameters will override the object's value:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				PipettingMethod->Model[Method,Pipetting,"Aqueous"]
			],
			_Aliquot
		],
		Example[{Options,CorrectionCurve,"Specify the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				CorrectionCurve->{
					{0 Microliter,0 Microliter},
					{50 Microliter,60 Microliter},
					{150 Microliter,180 Microliter},
					{300 Microliter,345 Microliter}
				}
			],
			_Aliquot
		],
		Example[{Options,DynamicAspiration,"Indicate that the liquid(s) being transferred has a high vapor pressure and droplet prevention should be used:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				},
				DynamicAspiration->True
			],
			_Aliquot
		],
		Example[{Options,InWellSeparation,"Indicate that droplets from multiple samples are transferred into and physically separated in the same destination well:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Nanoliter,50 Nanoliter,50 Nanoliter},
				Destinations->{
					{Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],"A1"},
					{Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],"A2"},
					{Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],"A3"}
				},
				InWellSeparation->True
			],
			_Aliquot
		],
		Example[{Attributes,Protected,"The Aliquot head is protected:"},
			Aliquot[
				Source->Object[Sample,"Once Glorious Water Sample for Aliquot UnitOperation unit test "<>$SessionUUID],
				Amounts->{50 Microliter,50 Microliter,50 Microliter,50 Microliter},
				Destinations->{
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A2"},
					{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A3"}
				}
			],
			_Aliquot
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Mix*)


DefineTests[Mix,
	{
		Example[{Basic,"Create a primitive to specify mixing by pipetting for a sample in a plate well:"},
			Mix[Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],MixVolume->300 Microliter,NumberOfMixes->1],
			_Mix
		],
		Example[{Basic,"Create a primitive that requests multiple up-and-down pipettings of the sample for mixing:"},
			Mix[Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],MixVolume->300 Microliter,NumberOfMixes->10],
			_Mix
		],
		Example[{Basic,"Create a primitive that requests mixing by vortexing:"},
			Mix[Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],MixType->Vortex,Time->10 Second],
			_Mix
		],
		Example[{Additional,"Create a primitive that only draws a small amount of sample for mixing:"},
			Mix[Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],MixVolume->10 Microliter,NumberOfMixes->10],
			_Mix
		],
		Example[{Options,TipType,"Specify the tip model to use:"},
			Mix[
				Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],
				MixVolume->200 Microliter,
				NumberOfMixes->3,
				TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
			],
			_Mix
		],
		Example[{Options,TipSize,"Specify the tip size to use:"},
			Mix[
				Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],
				MixVolume->200 Microliter,
				NumberOfMixes->3,
				TipSize->300 Microliter
			],
			_Mix
		],
		Example[{Options,TipType,"Specify the tip type and size to use:"},
			Mix[
				Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],
				MixVolume->200 Microliter,
				NumberOfMixes->3,
				TipType->WideBore,
				TipSize->300 Microliter
			],
			_Mix
		],
		Example[{Additional,"Specify the flow rate at which the sample should be aspirated and dispensed while mixing:"},
			Mix[
				Source->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],
				MixVolume->10 Microliter,
				NumberOfMixes->10,
				MixFlowRate->300 Microliter/Second
			],
			_Mix
		],
		Example[{Attributes,Protected,"The Mix head is protected:"},
			Mix[Sample->Object[Sample,"Test chemical 1 in plate for Mix UnitOperation unit test "<>$SessionUUID],MixVolume->10 Microliter,NumberOfMixes->10],
			_Mix
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FillToVolume*)


DefineTests[FillToVolume,
	{
		Example[{Basic,"Create a fill to volume manipulation primitive for a transfer from a source sample to an empty destination container, specifying volume measurement to occur via the Ultrasonic method:"},
			FillToVolume[
				Source->Object[Sample,"Once Glorious Water Sample for FillToVolume UnitOperation unit test "<>$SessionUUID],
				FinalVolume->25 Milliliter,
				Destination->Object[Container,Vessel,"Test 50mL tube for FillToVolume UnitOperation unit test "<>$SessionUUID],
				Method->Ultrasonic
			],
			_FillToVolume
		],
		Example[{Basic,"Create a fill to volume manipulation primitive for a transfer from a source sample to another existing sample:"},
			FillToVolume[
				Source->Object[Sample,"Test chemical 1 in plate for FillToVolume UnitOperation unit test "<>$SessionUUID],
				FinalVolume->300 Microliter,
				Destination->Object[Sample,"Once Glorious Water Sample for FillToVolume UnitOperation unit test "<>$SessionUUID]
			],
			_FillToVolume
		],
		Example[{Basic,"Create a fill to volume manipulation primitive for transferring a chemical to an empty container without requesting a particular sample:"},
			FillToVolume[
				Source->Model[Sample,"Methanol"],
				FinalVolume->10 Milliliter,
				Destination->Object[Container,Vessel,"Test 50mL tube for FillToVolume UnitOperation unit test "<>$SessionUUID]
			],
			_FillToVolume
		],
		Example[{Basic,"Create a fill to volume primitive for moving a chemical to an empty container without requesting a particular sample or container:"},
			FillToVolume[
				Source->Model[Sample,"Methanol"],
				FinalVolume->10 Milliliter,
				Destination->Model[Container,Vessel,"50mL Tube"]
			],
			_FillToVolume
		],
		Example[{Attributes,Protected,"The FillToVolume Head is protected:"},
			FillToVolume[
				Source->Model[Sample,"Sodium Chloride"],
				FinalVolume->5 Gram,
				Destination->Object[Container,Vessel,"Test 50mL tube for FillToVolume UnitOperation unit test "<>$SessionUUID]
			],
			_FillToVolume
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Incubate*)


DefineTests[Incubate,
	{
		Example[{Basic,"Create a primitive to specify incubating a sample for 1 Minute at 40 Celsius:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius
			],
			_Incubate
		],
		Example[{Basic,"Specify that the Sample should be mixed while incubating:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				MixRate->200 RPM
			],
			_Incubate
		],
		Example[{Basic,"Specify a final temperature to hold the sample(s) at after the specified incubation Time has elapsed:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				ResidualTemperature->4 Celsius
			],
			_Incubate
		],
		Example[{Additional,"All Incubate fields are listable allowing multiple sources to be incubated simultaneously:"},
			Incubate[
				Sample->{Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for Incubate UnitOperation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for Incubate UnitOperation unit test "<>$SessionUUID]},
				Time->{1 Minute,2 Minute,3 Minute},
				Temperature->{10 Celsius,20 Celsius,30 Celsius}
			],
			_Incubate
		],
		Example[{Additional,"If a singleton field value is specified, it will be applied to all sources:"},
			Incubate[
				Sample->{Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for Incubate UnitOperation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for Incubate UnitOperation unit test "<>$SessionUUID]},
				Time->5 Minute,
				Temperature->{10 Celsius,20 Celsius,30 Celsius}
			],
			_Incubate
		],
		Example[{Additional,"MicroLiquidHandling","Specify a final rate to mix the sample(s) after the specified Time has elapsed:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				MixRate->200 RPM,
				ResidualMixRate->100 RPM
			],
			_Incubate
		],
		Example[{Additional,"MicroLiquidHandling","Specify that the heating block should be brought to the specified temperature before any samples are exposed to it:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				Preheat->True
			],
			_Incubate
		],
		Example[{Additional,"MicroLiquidHandling","Specify that the sample(s) should be held at the specified incubation Temperature after Time has elapsed:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				ResidualIncubation->True
			],
			_Incubate
		],
		Example[{Additional,"MicroLiquidHandling","Specify that the sample(s) should be held at the specified MixRate after Time has elapsed:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				MixRate->200 RPM,
				ResidualMix->True
			],
			_Incubate
		],
		Example[{Additional,"MacroLiquidHandling","Specify that the sample(s) should stay inside the incubation device after the heater has been switched off:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius,
				MixRate->200 RPM,
				AnnealingTime->1 Minute
			],
			_Incubate
		],
		Example[{Additional,"MacroLiquidHandling","Specify that the sample incubation should be continued (MixUntilDissolved) up to MaxTime in an attempt dissolve any solute:"},
			Incubate[
				Sample->Object[Sample,"Once Glorious Water Sample for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->30 Minute,
				Temperature->50 Celsius,
				MixUntilDissolved->True,
				MaxTime->2 Hour
			],
			_Incubate
		],
		Example[{Additional,"MacroLiquidHandling","Specify the instrument that should be used to incubate and mix the sample:"},
			Incubate[
				Sample->Object[Sample,"Once Glorious Water Sample for Incubate UnitOperation unit test "<>$SessionUUID],
				MixType->Roll,
				MixRate->12 Revolution/Minute,
				Instrument->Model[Instrument,Roller,"id:Vrbp1jKKZw6z"],
				Time->1 Hour,
				Temperature->37 Celsius
			],
			_Incubate
		],
		Example[{Additional,"MacroLiquidHandling","Specify that the sample should be mixed by Invert:"},
			Incubate[
				Sample->Object[Sample,"Once Glorious Water Sample for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->Null,
				Temperature->Null,
				MixType->Invert,
				NumberOfMixes->3,
				MixUntilDissolved->True,
				MaxNumberOfMixes->10
			],
			_Incubate
		],
		Example[{Attributes,Protected,"The Incubate head is protected:"},
			Incubate[
				Sample->Object[Sample,"Test chemical 1 in plate for Incubate UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Temperature->40 Celsius
			],
			_Incubate
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Wait*)


DefineTests[Wait,
	{
		Example[{Basic,"Create a primitive to specify a pause during the execution of a set of manipulations:"},
			Wait[Duration->10 Second],
			_Wait
		],
		Example[{Basic,"The Wait primitive can accept any amount of time greater than 0:"},
			Wait[Duration->1 Hour],
			_Wait
		]
	}
];



(* ::Subsubsection::Closed:: *)
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
		Example[{Options,TransportWarmed,"Specify the transportation temperature for the model created at a particular location:"},
			Define[
				Name->"My sample reference",
				Container->Object[Container,Plate,"My Plate for Define UnitOperation unit test "<>$SessionUUID],
				Well->"B3",
				TransportWarmed->45 Celsius,
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



(* ::Subsubsection::Closed:: *)
(*LabelSample*)


DefineTests[LabelSample,
	{
		Example[{Basic,"Create a primitive to tag a sample reference with a specified name:"},
			LabelSample[
				Label->"My special sample's name",
				Sample->Object[Sample,"My special sample for LabelSample UnitOperation unit test "<>$SessionUUID]
			],
			_LabelSample
		],
		Example[{Basic,"Define a name for a sample at a particular location:"},
			LabelSample[
				Label->"My named sample defined by its position",
				Container->Object[Container,Plate,"My Plate for LabelSample UnitOperation unit test "<>$SessionUUID],
				Well->"B3"
			],
			_LabelSample
		],
		Example[{Basic,"Define a name for a model:"},
			LabelSample[
				Label->"My named model reference",
				Sample->Model[Sample,"Methanol"]
			],
			_LabelSample
		],
		Example[{Additional,"Specify the amount for the defined sample:"},
			LabelSample[
				Label->"My water sample",
				Sample->Model[Sample,"Milli-Q water"],
				Amount->50 Milliliter
			],
			_LabelSample
		],
		Example[{Additional,"Provide additional EHS information for the defined sample:"},
			LabelSample[
				Label->"My special sample's name",
				Sample->Object[Sample,"My special sample for LabelSample UnitOperation unit test "<>$SessionUUID],
				State->Liquid,
				Flammable->True
			],
			_LabelSample
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*LabelContainer*)


DefineTests[LabelContainer,
	{
		Example[{Basic,"Create a primitive to tag a container reference with a specified name:"},
			LabelContainer[
				Label->"My special container's name",
				Container->Object[Sample,"My special container for LabelContainer UnitOperation unit test "<>$SessionUUID]
			],
			_LabelContainer
		],
		Example[{Basic,"Define a name for a container model to be used for follow-up experiments:"},
			LabelContainer[
				Label->"My named model reference",
				Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			_LabelContainer
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*SolidPhaseExtraction*)
DefineTests[SolidPhaseExtraction,
	{
		Example[{Basic,"Create a primitive to perform solid phase extraction on sample:"},
			SolidPhaseExtraction[
				Sample -> Object[Sample,"Chemical in Plate 1"]
			],
			_SolidPhaseExtraction
		],
		Example[{Basic,"Specify multiple samples to perform solid phase extraction :"},
			SolidPhaseExtraction[
				Sample -> {Object[Sample,"Chemical in Plate 1"],Object[Sample,"Chemical in Plate 2"]}
			],
			_SolidPhaseExtraction
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*Filter*)


DefineTests[Filter,
	{
		Example[{Basic,"Create a primitive to specify filtering a sample by applying 40 PSI to a filter plate for 1 minute (micro liquid handling scale):"},
			Filter[
				Sample->Object[Sample,"Test chemical 1 in plate for Filter UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Pressure->40 PSI
			],
			_Filter
		],
		Example[{Basic,"Specify multiple samples to filter (micro liquid handling scale):"},
			Filter[
				Sample->{Object[Sample,"Test chemical 1 in plate for Filter UnitOperation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for Filter UnitOperation unit test "<>$SessionUUID]},
				Time->1 Minute,
				Pressure->40 PSI
			],
			_Filter
		],
		Example[{Basic,"Specify multiple samples to filter (macro liquid handling scale):"},
			Filter[
				Sample->{Object[Sample,"Filter Sample with 3L (I) for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID],Object[Sample,"Filter Sample with 3L (II) for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID]},
				FiltrationType->PeristalticPump,
				Instrument->Model[Instrument,PeristalticPump,"VWR Peristaltic Variable Pump PP3400"],
				PoreSize->Quantity[0.22`,"Micrometers"],
				FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]
			],
			_Filter
		],
		Example[{Options,Pressure,"Specify the pressure to apply to the filter plate (micro liquid handling scale):"},
			Filter[
				Sample->Object[Sample,"Test chemical 1 in plate for Filter UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Pressure->40 PSI
			],
			_Filter
		],
		Example[{Options,Time,"Specify the duration for which the pressure is applied to the filter plate (micro liquid handling scale):"},
			Filter[
				Sample->Object[Sample,"Test chemical 1 in plate for Filter UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Pressure->40 PSI
			],
			_Filter
		],
		Example[{Options,CollectionContainer,"Specify that the filtrate should be collected into a specific plate model or object (micro liquid handling scale):"},
			Filter[
				Sample->Object[Sample,"Test chemical 1 in plate for Filter UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Pressure->40 PSI,
				CollectionContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			_Filter
		],(* TODO: uncomment once supported
		Example[{Additional,"MacroLiquidHandling","Specify the parameters (like time, intensity and temperature) for filtering by centrifugation and a centrifuge filter:"},
			Filter[
				Sample->{Object[Sample,"Filter Sample with 1mL for SM Macro testing"]},
				FiltrationType->Centrifuge,
				Intensity->1000 RPM,
				Time-> 20 Minute,
				Temperature->30 Celsius
			],
			_Filter
		],
		Example[{Additional,"MacroLiquidHandling","Specify the instrument and filter that should be used for filtering when using a centrifuge:"},
			Filter[
				Sample->{Object[Sample,"Filter Sample with 1mL for SM Macro testing"]},
				FiltrationType->Centrifuge,
				Instrument->Model[Instrument,Centrifuge,"Avanti J-15R"],
				Filter->Model[Container,Vessel,Filter,"id:GmzlKjPYBJ8M"]
			],
			_Filter
		], *)
		Example[{Additional,"MacroLiquidHandling","A filter macro primitive can be used to filter multiple sample in a filter plate directly into a deep well plate :"},
			Filter[
				Sample->{Object[Sample,"Filter Sample 1 in filter plate 2 for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID],Object[Sample,"Filter Sample 2 in filter plate 2 for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID]},
				FiltrationType->Vacuum,
				CollectionContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			_Filter
		],
		Example[{Additional,"MacroLiquidHandling","Specify the membrane material and pore size that should be used for filtering when using a syringe:"},
			Filter[
				Sample->{Object[Sample,"Filter Sample with 15mL for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID]},
				FiltrationType->Syringe,
				Syringe->Model[Container,Syringe,"id:P5ZnEj4P88OL"],
				PoreSize->Quantity[0.22`,"Micrometers"]
			],
			_Filter
		],
		Example[{Additional,"MacroLiquidHandling","Specify the filter and filter housing to be used for filtering when using a peristaltic pump:"},
			Filter[
				Sample->{Object[Sample,"Filter Sample with 3L (I) for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID],Object[Sample,"Filter Sample with 3L (II) for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID]},
				FiltrationType->PeristalticPump,
				Instrument->Model[Instrument,PeristalticPump,"VWR Peristaltic Variable Pump PP3400"],
				PoreSize->Quantity[0.22`,"Micrometers"],
				FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]
			],
			_Filter
		],
		Example[{Additional,"MacroLiquidHandling","Specify that the filtering should occur under sterile conditions when using a vacuum pump:"},
			Filter[
				Sample->{Object[Sample,"Filter Sample with 3L (I) for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID],Object[Sample,"Filter Sample with 3L (II) for SM Macro testing for Filter UnitOperation unit test "<>$SessionUUID]},
				FiltrationType->Vacuum,
				Filter->Model[Item,Filter,"id:01G6nvwlw3kD"],
				Sterile->True
			],
			_Filter
		],
		Example[{Attributes,Protected,"The Filter head is protected:"},
			Filter[
				Sample->Object[Sample,"Test chemical 1 in plate for Filter UnitOperation unit test "<>$SessionUUID],
				Time->1 Minute,
				Pressure->40 PSI
			],
			_Filter
		]
	}
];



(* ::Subsubsection::Closed:: *)
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



(* ::Subsubsection::Closed:: *)
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



(* ::Subsection::Closed:: *)
(* Centrifuge *)


DefineTests[Centrifuge,
	{
		Example[{Basic,"Create a primitive to centrifuge a tube using default settings:"},
			Centrifuge[
				Sample->Object[Container,Vessel,"Test tube 1 for Centrifuge UnitOperation unit test "<>$SessionUUID]
			],
			_Centrifuge
		],
		Example[{Basic,"Centrifuge options can be provided as single values or as a list:"},
			Centrifuge[
				{Object[Container,Vessel,"Test tube 1 for Centrifuge UnitOperation unit test "<>$SessionUUID],Object[Container,Vessel,"Test tube 2 for Centrifuge UnitOperation unit test "<>$SessionUUID]},
				Intensity->3000 RPM,
				Time->{5 Minute,10 Minute}
			],
			_Centrifuge
		],
		Example[{Options,Time,"Indicate that the sample should be centrifuged for 5 minutes:"},
			Centrifuge[
				Sample->Object[Container,Vessel,"Test Vessel 1 for Centrifuge UnitOperation unit test "<>$SessionUUID],
				Time->5 Minute
			],
			_Centrifuge
		],
		Example[{Options,Temperature,"Indicate that the sample should be centrifuged at 37 Celsius:"},
			Centrifuge[
				Sample->{Object[Container,Vessel,"Test tube 1 for Centrifuge UnitOperation unit test "<>$SessionUUID],Object[Container,Vessel,"Test tube 2 for Centrifuge UnitOperation unit test "<>$SessionUUID]},
				Temperature->37 Celsius
			],
			_Centrifuge
		],
		Example[{Options,Intensity,"Indicate that the sample should be centrifuged at 3000 RPM:"},
			Centrifuge[
				Sample->Object[Sample,"Test Sample 1 for Centrifuge UnitOperation unit test "<>$SessionUUID],
				Intensity->3000 RPM
			],
			_Centrifuge
		],
		Example[{Options,Instrument,"Indicate the instrument which should be used to centrifuge the samples:"},
			Centrifuge[
				Sample->Object[Container,Vessel,"Test Vessel 1 for Centrifuge UnitOperation unit test "<>$SessionUUID],
				Instrument->Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"]
			],
			_Centrifuge
		]
	}
];


(* ::Subsection::Closed:: *)
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



(* ::Subsubsection::Closed:: *)
(*Cover*)


DefineTests[Cover,
	{
		Example[{Basic,"Create a primitive to cover a container with a universal lid:"},
			Cover[Sample->Object[Sample,"Test chemical 1 in plate for Cover UnitOperation unit test "<>$SessionUUID]],
			_Cover
		],
		Example[{Basic,"Create a primitive to cover a container with a specific lid:"},
			Cover[
				Sample->Object[Sample,"Test chemical 1 in plate for Cover UnitOperation unit test "<>$SessionUUID],
				Cover->Model[Item,Lid,"Universal Black Lid"]
			],
			_Cover
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*Uncover*)


DefineTests[Uncover,
	{
		Example[{Basic,"Create a primitive to remove the cover from a container:"},
			Uncover[Sample->Object[Sample,"Test chemical 1 in plate for Uncover UnitOperation unit test "<>$SessionUUID]],
			_Uncover
		],
		Example[{Basic,"Uncover a defined container:"},
			Uncover[
				Sample->"My container for Uncover UnitOperation unit test "<>$SessionUUID
			],
			_Uncover
		]
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentSampleManipulation*)


DefineTests[ExperimentSampleManipulation,
	{
		Example[{Basic,"Transfer a specified volume of a sample to an empty container:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Transfer a sample into another existing sample by directly specifying the source and destination samples:"},
			protocol=ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Basic,"Transfer enough of the sample into the container until a desired final volume is reached:"},
			protocol=ExperimentSampleManipulation[{FillToVolume[Source->Model[Sample,"Methanol"],FinalVolume->40 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Basic,"Transfer a chemical to an empty container without specifying a particular sample:"},
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Isopropanol"],Amount->15 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Basic,"Transfer a chemical to any empty container of a given type:"},
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Isopropanol"],Amount->15 Milliliter,Destination->Model[Container,Vessel,"15mL Tube"]]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate a sample at a specified temperature for a specified amount of time:"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Pellet two samples and then transfer into the collected supernatant:"},
			protocol=ExperimentSampleManipulation[{
				Define[
					Name->"sample 1",
					Container->Model[Container,Vessel,"50mL Tube"]
				],
				Define[
					Name->"supernatant collection container",
					Container->Model[Container,Vessel,"50mL Tube"]
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample 1",
					Amount->10 Milliliter
				],
				Pellet[
					Sample->"sample 1",
					SupernatantDestination->"supernatant collection container",
					SupernatantVolume->All
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"supernatant collection container",
					Amount->1 Milliliter
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Basic pelleting test 1:",
			ExperimentSampleManipulation[{
				Define[
					Name->"samp",
					Container->Model[Container,Vessel,"2mL Tube"],
					Well->"A1",
					ContainerName->"tube"
				],
				Transfer[
					Source->Model[Sample,"Methanol"],
					Destination->"samp",
					Amount->1 Milliliter
				],
				Pellet[
					Sample->"samp"
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Basic pelleting test 2:",
			ExperimentSampleManipulation[{
				Define[
					Name->"supernatant collection container",
					Container->Model[Container,Vessel,"50mL Tube"]
				],

				Pellet[
					Sample->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID][Contents][[All,2]][Object],
					SupernatantDestination->"supernatant collection container"
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Basic pelleting test 3:",
			ExperimentSampleManipulation[{
				Define[
					Name->"supernatant collection container",
					Container->Model[Container,Vessel,"50mL Tube"]
				],

				Pellet[
					Sample->Object[Container,Vessel,"50mL Tube of Water"],
					SupernatantDestination->"supernatant collection container"
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specific sample locations may be used in lieu of direct samples:"},
			ExperimentSampleManipulation[{Transfer[Source->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"},Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Transfer both solids (tablet and non-tablet) and liquids to prepare a buffer solution:"},
			ExperimentSampleManipulation[{
				Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Model[Sample,"Aspirin (tablet)"],Amount->4,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify a series of sample transfers within a plate; transfer samples both to other samples and to empty wells within the plate:"},
			ExperimentSampleManipulation[{
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->25 Microliter,Destination->Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->500 Microliter,Destination->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"G6"}],
				Transfer[Source->Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->100 Microliter,Destination->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"B7"}],
				Transfer[Source->Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->76 Microliter,Destination->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"E3"}],
				Transfer[Source->Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->24 Microliter,Destination->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"E3"}]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Additional Manipulations","Use the Consolidation manipulation to combine multiple sources into a single destination:"},
			ExperimentSampleManipulation[{
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Amounts->{100 Microliter,100 Microliter,200 Microliter,50 Microliter},
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Additional Manipulations","Use the Consolidation manipulation to combine multiple sources into a single destination, all with same volume:"},
			protocol = ExperimentSampleManipulation[{
				Consolidation[
					Sources->{
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Amounts->50 Microliter, (* Primary purpose of this test is to make sure a non-list input works. *)
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			}];
			Download[protocol][ResolvedManipulations][[1]][Amount],
			List[List[Quantity[50,"Microliters"]],List[Quantity[50,"Microliters"]],List[Quantity[50,"Microliters"]],List[Quantity[50,"Microliters"]]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Additional Manipulations","Use the Aliquot manipulation to prepare multiple aliquots from a buffer solution stock:"},
			protocol=ExperimentSampleManipulation[{
				Aliquot[
					Source->Model[Sample,StockSolution,"70% Ethanol"],
					Amounts->{50 Milliliter,50 Milliliter,50 Milliliter,50 Milliliter},
					Destinations->{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]}
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Mix Primitive","Use the Mix manipulation to mix a given sample by pipetting before transferring out of it:"},
			ExperimentSampleManipulation[{
				Mix[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],MixVolume->300 Microliter,NumberOfMixes->5],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Mix Primitive","Use the Mix manipulation to mix a given sample by Vortex before transferring out of it:"},
			ExperimentSampleManipulation[{
				Mix[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],MixType->Vortex,Time->30 Second],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				$CreatedObjects=.;
			)
		],
		Example[{Additional,"Mix Primitive","Use the Mix manipulation to mix a previously defined sample by Sonication:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"MyStdSample",
					ContainerName->"myStandardContainer",
					Container->Model[Container,Vessel,"250mL Glass Bottle"],
					ShelfLife->34 Day,
					ModelName->"MyStdModel"<>" "<>ToString[Unique[]],
					ModelType->Model[Sample,StockSolution]
				],
				Transfer[
					Source->Model[Sample,"id:eGakldJaY101"],
					Destination->"myStandardContainer",
					Amount->25 Milligram
				],
				Mix[
					Sample->"myStandardContainer",
					MixType->Sonicate,
					Time->10 Minute
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={};),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				$CreatedObjects=.;
			)
		],
		Example[{Messages,"MissingMixKeys","Error if a Mix primitive does not include the required keys:"},
			ExperimentSampleManipulation[{
				Mix[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					MixType->Pipette
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amount->50 Microliter,
					Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}],
			$Failed,
			SetUp:>($CreatedObjects={};),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				$CreatedObjects=.;
			),
			Messages:>{Error::MissingMixKeys,Error::InvalidInput}
		],
		Example[{Additional,"Additional Manipulations","Combine a series of liquid handling operations:"},
			ExperimentSampleManipulation[{
				Aliquot[
					Source->Model[Sample,StockSolution,"70% Ethanol"],
					Amounts->{100 Microliter,100 Microliter,100 Microliter,100 Microliter},
					Destinations->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				],
				Mix[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],MixVolume->300 Microliter,NumberOfMixes->5],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Amounts->{100 Microliter,100 Microliter,200 Microliter,50 Microliter},
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Resuspend Primitive","Resuspend a sample in its current position with the specified volume of diluent:"},
			protocol=ExperimentSampleManipulation[{
				Resuspend[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Volume->100 Microliter]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Resuspend Primitive","Resuspend a sample in its current position with the specified volume of diluent, then incubate the resulting mixture:"},
			protocol=ExperimentSampleManipulation[
				{Resuspend[Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for ExperimentSampleManipulation unit test "<>$SessionUUID],Volume->1 Milliliter,IncubationTime->10 Minute,IncubationTemperature->40 Celsius]},
				LiquidHandlingScale->MacroLiquidHandling
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Resuspend Primitive","Transfer a solid sample into a new container and resuspend the sample in that container:"},
			protocol=ExperimentSampleManipulation[{
				Define[Name->"my50mLTube",Container->Model[Container,Vessel,"50mL Tube"]],
				Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->"my50mLTube"],
				Resuspend[Sample->"my50mLTube",Volume->48.5 Milliliter]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Resuspend Primitive","Transfer a solid sample into a new container, resuspend the sample in that container, and transfer it to another container:"},
			protocol=ExperimentSampleManipulation[{
				Define[Name->"my50mLTube",Container->Model[Container,Vessel,"50mL Tube"]],
				Define[Name->"my50mLTube 2",Container->Model[Container,Vessel,"50mL Tube"]],
				Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->"my50mLTube"],
				Resuspend[Sample->"my50mLTube",Volume->48.5 Milliliter],
				Transfer[Source->"my50mLTube",Destination->"my50mLTube 2",Amount->20 Milliliter]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Resuspend Primitive","The Resuspend primitive gets converted into a Transfer and (optionally) an Incubate:"},
			protocol=ExperimentSampleManipulation[
				{Resuspend[Sample->Object[Sample,"Salt Sample 1 (100 Milligram) for ExperimentSampleManipulation unit test "<>$SessionUUID],Volume->1 Milliliter,IncubationTime->10 Minute,IncubationTemperature->40 Celsius]},
				LiquidHandlingScale->MacroLiquidHandling
			];
			Download[protocol,ResolvedManipulations],
			{_Transfer,_Incubate},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate Primitive","Incubate multiple samples simultaneously (MicroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate Primitive","Specify that the Source should be mixed while incubating (MicroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius,
					MixRate->200 RPM
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate Primitive","Specify a final temperature to hold the sample(s) at after the specified incubation Time has elapsed (MicroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius,
					ResidualTemperature->4 Celsius
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate Primitive","Specify that the heating block should be brought to the specified temperature before any samples are exposed to it (MicroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius,
					Preheat->True
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate Primitive","Specify that the sample(s) should be held at a specified MixRate after Time has elapsed (MicroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius,
					MixRate->200 RPM,
					ResidualMixRate->100 RPM
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Incubate Primitive","For incubation at macro liquid handling scale, specify which MixType and Instrument should be utilized to perform the incubation:"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
					MixType->Roll,
					MixRate->12 Revolution/Minute,
					Instrument->Model[Instrument,Roller,"id:Vrbp1jKKZw6z"],
					Time->1 Hour,
					Temperature->37 Celsius
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Incubate Primitive","For incubation at macro liquid handling scale, keys that are not specified are resolved like ExperimentIncubate would resolve them:"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
					MixType->Shake
				]
			}];
			{#[Temperature],#[Time],#[MixRate],#[Instrument]}&/@Download[protocol,ResolvedManipulations],
			{{{Ambient},{15 Minute},{RPMP},{ObjectP[Model[Instrument,Shaker]]}}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Incubate Primitive","Specify that the sample(s) should be kept in the Incubate device after the heating has been turned off (MacroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius,
					MixRate->200 RPM,
					AnnealingTime->5 Minute
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Incubate Primitive","Specify that the sample incubation should be continued (MixUntilDissolved) up to MaxTime in an attempt dissolve any solute:"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
					MixType->Roll,
					MixRate->12 Revolution/Minute,
					Instrument->Model[Instrument,Roller,"id:Vrbp1jKKZw6z"],
					Time->1 Hour,
					Temperature->37 Celsius,
					MixUntilDissolved->True,
					MaxTime->2 Hour
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],


		Example[{Additional,"Incubate Primitive","Specify that the sample(s) should be held at the specified incubation Temperature after Time has elapsed (MacroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->10 Minute,
					Temperature->37 Celsius,
					ResidualIncubation->True
				]
			}];
			(#[ResidualTemperature])&/@Download[protocol,ResolvedManipulations],
			{{37 Celsius}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Incubate Primitive","If ResidualMixRate and ResidualTemperature are specified, MixRate and Temperature resolve to the these settings (MacroLiquidHandling):"},
			protocol=ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						ResidualMixRate->168 RPM,
						ResidualTemperature->30 Celsius
					]
				}
			];
			{#[Temperature],#[MixRate]}&/@Download[protocol,ResolvedManipulations],
			{{{30 Celsius},{168 Revolution/Minute}}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Incubate Primitive","Use the Incubate manipulation to incubate a previously defined sample (MacroLiquidHandling):"},
			ExperimentSampleManipulation[{
				Define[
					Name->"MyStdSample",
					ContainerName->"myStandardContainer",
					Container->Model[Container,Vessel,"250mL Glass Bottle"],
					ShelfLife->34 Day,
					ModelName->"MyStdModel"<>" "<>ToString[Unique[]],
					ModelType->Model[Sample,StockSolution]
				],
				Transfer[
					Source->Model[Sample,"id:eGakldJaY101"],
					Destination->"myStandardContainer",
					Amount->25 Milligram
				],
				Incubate[
					Sample->{"myStandardContainer","myStandardContainer"},
					MixType->Shake,
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={};),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				$CreatedObjects=.;
			)
		],

		Example[{Additional,"Incubate Primitive","Mix primitive can also act as an Incubate primitive:"},
			protocol=ExperimentSampleManipulation[{
				Mix[
					Sample->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Incubate Primitive","Incubate primitive can also act as a Mix primitive:"},
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					MixVolume->100 Microliter,
					NumberOfMixes->3
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		Example[{Additional,"Container Model Tagging","Container models may be assigned to variable names in order to reference them across multiple manipulations; this function call will combine sodium chloride and water in the same, to-be-determined 50mL tube:"},
			protocol=ExperimentSampleManipulation[
				{
					Define[Name->"my50mLTube",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->"my50mLTube"],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->"my50mLTube"]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Additional,"Container Model Tagging","Model containers may also be tagged with unique symbols directly in the manipulations in order to reference the same future container across multiple manipulations; this form is especially useful when calling ExperimentSampleManipulation from another function:"},
			Module[{myTag},
				myTag=Unique[];
				ExperimentSampleManipulation[
					{
						Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->{myTag,Model[Container,Vessel,"50mL Tube"]}],
						Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->{myTag,Model[Container,Vessel,"50mL Tube"]}],
						Transfer[Source->{myTag,Model[Container,Vessel,"50mL Tube"]},Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
					}
				]
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Wait Primitive","Add a Wait primitive to pause for a specified amount of time between manipulations:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->300 Microliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]
					],
					Wait[Duration->1 Minute],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->200 Microliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Wait Primitive","Add a Wait primitive to pause for a specified amount of time between manipulations on the macro liquid handling scale:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->300 Microliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]
					],

					Wait[Duration->10 Minute],

					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->30 Minute,
						Temperature->37 Celsius,
						MixType->Shake
					]
				},
				LiquidHandlingScale->MacroLiquidHandling
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Wait Primitive","Add a Wait primitive to pause for a specified amount of time after a series of primitives, before storing the samples away:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->30 Minute,
						Temperature->37 Celsius,
						MixType->Shake
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->300 Microliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]
					],
					Wait[Duration->5 Minute]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Pipetting Parameters","Parameters defining the method by which liquid is manipulated can be specified or will be automatically resolved for Transfer, Consolidation, and Aliquot:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->20 Microliter,
						Destination->{"My Plate","A1"},
						AspirationRate->40 Microliter/Second,
						DispenseRate->10 Microliter/Second,
						DispensePosition->Bottom,
						DispensePositionOffset->10 Millimeter
					],
					Aliquot[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amounts->{100 Microliter,200 Microliter,300 Microliter},
						Destinations->{
							{"My Plate","A1"},
							{"My Plate","A2"},
							{"My Plate","A3"}
						},
						AspirationRate->100 Microliter/Second,
						DispenseRate->200 Microliter/Second,
						DispensePosition->LiquidLevel,
						DispensePositionOffset->3 Millimeter
					],
					Consolidation[
						Sources->{
							Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]
						},
						Amounts->{50 Microliter,100 Microliter,200 Microliter},
						Destination->{"My Plate","A4"},
						AspirationMix->True,
						AspirationMixVolume->20 Microliter,
						AspirationNumberOfMixes->4,
						DispenseMix->True,
						DispenseMixVolume->10 Microliter,
						DispenseNumberOfMixes->5
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->20 Microliter,
						Destination->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						AspirationRate->40 Microliter/Second,
						DispenseRate->10 Microliter/Second,
						DispensePosition->LiquidLevel,
						DispensePositionOffset->5 Millimeter
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Pipetting Parameters","Use TouchOff Transfer mode to slowly and gently transfer a small-volume sample to a chip for reading in the Lunatic spectrometer:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->2 Microliter,
						Destination->{Object[Container,Plate,"Fake Lunatic plate for ExperimentSampleManipulation unit tests"],"A1"},
						DispensePosition->TouchOff
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Pipetting Parameters","Parameters defining the method by which a sample is mixed can be specified:"},
			ExperimentSampleManipulation[
				{
					Mix[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixVolume->200 Microliter,
						NumberOfMixes->10,
						MixPosition->LiquidLevel,
						MixFlowRate->200 Microliter/Second
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Pipetting Parameters","All pipetting parameters are resolved for relevant manipulations:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->200 Microliter,
							Destination->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
							AspirationRate->250 Microliter/Second,
							DispenseRate->10 Microliter/Second
						]
					}
				];
				Map[
					First/@{
						#[AspirationRate],
						#[DispenseRate],
						#[OverAspirationVolume],
						#[OverDispenseVolume],
						#[AspirationWithdrawalRate],
						#[DispenseWithdrawalRate],
						#[AspirationEquilibrationTime],
						#[DispenseEquilibrationTime],
						#[CorrectionCurve],
						#[AspirationMixRate],
						#[DispenseMixRate],
						#[AspirationMix],
						#[DispenseMix],
						#[AspirationMixVolume],
						#[DispenseMixVolume],
						#[AspirationNumberOfMixes],
						#[DispenseNumberOfMixes],
						#[AspirationPosition],
						#[DispensePosition],
						#[AspirationPositionOffset],
						#[DispensePositionOffset]
					}&,
					Download[myProtocol,ResolvedManipulations]
				]
			),
			{Map[
				Lookup[pipettingParameterSet,#]&,
				{
					AspirationRate,
					DispenseRate,
					OverAspirationVolume,
					OverDispenseVolume,
					AspirationWithdrawalRate,
					DispenseWithdrawalRate,
					AspirationEquilibrationTime,
					DispenseEquilibrationTime,
					CorrectionCurve,
					AspirationMixRate,
					DispenseMixRate,
					AspirationMix,
					DispenseMix,
					AspirationMixVolume,
					DispenseMixVolume,
					AspirationNumberOfMixes,
					DispenseNumberOfMixes,
					AspirationPosition,
					DispensePosition,
					AspirationPositionOffset,
					DispensePositionOffset
				}
			]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Pipetting Parameters","A pipetting method object can be specified to describe the method by which a manipulation should be executed:"},
			(
				myPipettingMethod=UploadPipettingMethod[
					AspirationRate->250 Microliter/Second,
					DispenseRate->10 Microliter/Second,
					AspirationEquilibrationTime->2 Second,
					DispenseEquilibrationTime->7 Second
				];

				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->200 Microliter,
							Destination->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
							PipettingMethod->myPipettingMethod
						]
					}
				];

				Map[
					First/@{
						#[AspirationRate],
						#[DispenseRate],
						#[AspirationEquilibrationTime],
						#[DispenseEquilibrationTime]
					}&,
					Download[myProtocol,ResolvedManipulations]
				]
			),
			{{250 Microliter/Second,10 Microliter/Second,2 Second,7 Second}},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myPipettingMethod}
		],
		Example[{Additional,"Pipetting Parameters","Pipetting parameters from a specified method can be overwritten:"},
			(
				myPipettingMethod=UploadPipettingMethod[
					AspirationRate->250 Microliter/Second,
					DispenseRate->10 Microliter/Second,
					AspirationEquilibrationTime->2 Second,
					DispenseEquilibrationTime->7 Second
				];

				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->200 Microliter,
							Destination->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
							PipettingMethod->myPipettingMethod,
							AspirationRate->20 Microliter/Second
						]
					}
				];

				Map[
					First/@{
						#[AspirationRate],
						#[DispenseRate],
						#[AspirationEquilibrationTime],
						#[DispenseEquilibrationTime]
					}&,
					Download[myProtocol,ResolvedManipulations]
				]
			),
			{{20 Microliter/Second,10 Microliter/Second,2 Second,7 Second}},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myPipettingMethod}
		],
		Example[{Additional,"Pipetting Parameters","By default pipetting parameters will be taken from the source model's PipettingMethod (if it exists):"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Model[Sample,"Test Model with PipettingMethod"],
							Amount->200 Microliter,
							Destination->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"}
						]
					}
				];

				{
					First@Map[
						First/@{
							#[AspirationRate],
							#[DispenseRate],
							#[AspirationEquilibrationTime],
							#[DispenseEquilibrationTime]
						}&,
						Download[myProtocol,ResolvedManipulations]
					],
					Download[
						Model[Sample,"Test Model with PipettingMethod"],
						{
							PipettingMethod[AspirationRate],
							PipettingMethod[DispenseRate],
							PipettingMethod[AspirationEquilibrationTime],
							PipettingMethod[DispenseEquilibrationTime]
						}
					]
				}
			),
			_?((Equal@@#)&),
			SetUp:>(
				$CreatedObjects={};

				If[!DatabaseMemberQ[Model[Sample,"Test Model with PipettingMethod"]],
					Upload[<|
						DeveloperObject->True,
						Expires->False,
						Flammable->False,
						Replace[IncompatibleMaterials]->{None},
						Name->"Test Model with PipettingMethod",
						State->Liquid,
						Replace[Synonyms]->{"Test Model with PipettingMethod"},
						Type->Model[Sample]
					|>]
				];

				If[!DatabaseMemberQ[Model[Method,Pipetting,"Test PipettingMethod method"]],
					UploadPipettingMethod[
						"Test PipettingMethod method",
						Model->Model[Sample,"Test Model with PipettingMethod"],
						AspirationRate->250 Microliter/Second,
						DispenseRate->10 Microliter/Second,
						AspirationEquilibrationTime->2 Second,
						DispenseEquilibrationTime->7 Second
					]
				];
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Pipetting Parameters","A source model's default pipetting parameters can be overwritten with a manipulation's specified parameters:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Model[Sample,"Test Model with PipettingMethod"],
							Amount->200 Microliter,
							Destination->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"},
							AspirationRate->5 Microliter/Second
						]
					}
				];
				{
					First[Download[myProtocol,ResolvedManipulations]][AspirationRate][[1]],
					Download[Model[Sample,"Test Model with PipettingMethod"],PipettingMethod[AspirationRate]]
				}
			),
			{5 Microliter/Second,250 Microliter/Second},
			EquivalenceFunction->Equal,
			SetUp:>(
				$CreatedObjects={};

				If[!DatabaseMemberQ[Model[Sample,"Test Model with PipettingMethod"]],
					Upload[<|
						DeveloperObject->True,
						Expires->False,
						Flammable->False,
						Replace[IncompatibleMaterials]->{None},
						Name->"Test Model with PipettingMethod",
						State->Liquid,
						Replace[Synonyms]->{"Test Model with PipettingMethod"},
						Type->Model[Sample]
					|>]
				];

				If[!DatabaseMemberQ[Model[Method,Pipetting,"Test PipettingMethod method"]],
					UploadPipettingMethod[
						"Test PipettingMethod method",
						Model->Model[Sample,"Test Model with PipettingMethod"],
						AspirationRate->250 Microliter/Second,
						DispenseRate->10 Microliter/Second,
						AspirationEquilibrationTime->2 Second,
						DispenseEquilibrationTime->7 Second
					]
				];
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Pipetting Parameters","DynamicAspiration can be used to indicate that droplet prevention should be used during liquid transfer:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"},
							DynamicAspiration->True
						],
						Aliquot[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amounts->{20 Microliter},
							Destinations->{{"My Plate","A2"}}
						]
					}
				];
				#[DynamicAspiration]&/@(Download[myProtocol,ResolvedManipulations][[2;;]])
			),
			{{True,False}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Pipetting Parameters","When DynamicAspiration is True OverAspiration and OverDispenseVolume default to 1 Microliter:"},
			myProtocol=ExperimentSampleManipulation[
				{
					Transfer[
						Source->Model[Sample,"Test sample model without pipetting method for ExperimentSampleManipulation unit test " <> $SessionUUID],
						Destination->Model[Container,Vessel,"2mL Tube"],
						Amount->200Microliter,
						DynamicAspiration->True
					]
				}
			];
			Map[
				First/@{#[DynamicAspiration],#[OverAspirationVolume],#[OverDispenseVolume]}&,
				Download[myProtocol,ResolvedManipulations]
			],
			{{True, 1 Microliter, 1 Microliter}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Tip Parameters","The tip model used in a manipulation can be specified for Transfer, Consolidation, Aliquot, and Mix primitives:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"},
							TipType->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]
						],
						Aliquot[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amounts->{20 Microliter},
							Destinations->{{"My Plate","A2"}},
							TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
						],
						Mix[
							Sample->{{"My Plate","A1"},{"My Plate","A2"}},
							MixVolume->10 Microliter,
							NumberOfMixes->3,
							TipType->Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]
						]
					}
				];
				#[TipType]&/@(Download[myProtocol,ResolvedManipulations][[2;;]])
			),
			{
				Download[
					{Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]},
					Object
				],
				Download[
					{Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"],Model[Item,Tips,"1000 uL Hamilton barrier tips, sterile"]},
					Object
				]
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Tip Parameters","The tip size used in a manipulation can be specified:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"},
							TipSize->1000 Microliter
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[2]][TipType]
			),
			{Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Tip Parameters","The tip size and a tip type can be specified for use in a manipulation:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"},
							TipSize->300 Microliter,
							TipType->WideBore
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[2]][TipType][Object]
			),
			{Model[Item, Tips, "id:D8KAEvGD8RMR"]}, (*"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"*)
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Tip Parameters","The tip type can be specified and the tip size will be automatically resolved for use in a manipulation:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->150 Microliter,
							Destination->{"My Plate","A1"},
							TipType->WideBore
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[2]][TipType][Object]
			),
			{Model[Item, Tips, "id:D8KAEvGD8RMR"]}, (*"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"*)
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Tip Parameters","If a manipulation uses a container that is only compatible with certain tip types, a compatible tip type is automatically chosen:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->30 Microliter,
							Destination->Model[Container,Vessel,"50mL Tube"]
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[1]][TipType][Object]
			),
			{Model[Item, Tips, "id:o1k9jAKOwwEA"]}, (*300 uL Hamilton tips, non-sterile*)
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Tip Parameters","When $50uLTipShortage is True, default to 300ul tips:"},
			(
				Block[{$50uLTipShortage=True},
					myProtocol=ExperimentSampleManipulation[
						{
							Define[
								Name->"My Plate",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Transfer[
								Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Amount->20 Microliter,
								Destination->{"My Plate","A1"}
							]
						}
					]
				];
				Download[#[TipType]&/@(Download[myProtocol,ResolvedManipulations][[2;;]]),Object]
			),
			{{Download[Model[Item,Tips,"300 uL Hamilton tips, non-sterile"],Object]}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Test["Not-yet-fulfilled resources will influence which tip is used for a transfer if their requested container is only compatible with some tips:",
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Model[Sample,"Dimethylformamide, Reagent Grade"],
							Amount->970 Microliter,
							Destination->{"My Plate","A1"}
						],
						Transfer[
							Source->Model[Sample,"Dimethylformamide, Reagent Grade"],
							Amount->970 Microliter,
							Destination->{"My Plate","A2"}
						],
						Transfer[
							Source->Model[Sample,"Dimethylformamide, Reagent Grade"],
							Amount->970 Microliter,
							Destination->{"My Plate","A3"}
						],
						(* This transfer should use a 300ul tip *)
						Transfer[
							Source->Model[Sample,"Dimethylformamide, Reagent Grade"],
							Amount->60 Microliter,
							Destination->{"My Plate","A4"}
						],
						(* This transfer should use a 300ul tip because the 50ul tip can't fit in a 50mL tube
						(which is what the DMF's resource should request) *)
						Transfer[
							Source->Model[Sample,"Dimethylformamide, Reagent Grade"],
							Amount->10 Microliter,
							Destination->{"My Plate","A5"}
						],
						(* This should successfully resolve to using a 50ul tip *)
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Amount->10 Microliter,
							Destination->{"My Plate","A6"}
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[2]][TipType][Object]
			),
			{
				ObjectReferenceP[Model[Item, Tips, "id:J8AY5jDvl5lE"]], (*"1000 uL Hamilton tips, non-sterile"*)
				ObjectReferenceP[Model[Item, Tips, "id:J8AY5jDvl5lE"]], (*"1000 uL Hamilton tips, non-sterile"*)
				ObjectReferenceP[Model[Item, Tips, "id:J8AY5jDvl5lE"]], (*"1000 uL Hamilton tips, non-sterile"*)
				ObjectReferenceP[Model[Item, Tips, "id:o1k9jAKOwwEA"]], (*300 uL Hamilton tips, non-sterile*)
				ObjectReferenceP[Model[Item, Tips, "id:o1k9jAKOwwEA"]], (*300 uL Hamilton tips, non-sterile*)
				ObjectReferenceP[Model[Item, Tips, "id:D8KAEvdqzzmm"]] (*"50 uL Hamilton tips, non-sterile"*)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Test["Request extra tips in order to account for the number of tips abandoned per tip stack level by hamilton's tip counting library:",
			(
				myProtocol=ExperimentSampleManipulation[
					Flatten[{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Map[
							Transfer[
								Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Amount->30 Microliter,
								Destination->{"My Plate",#},
								TipSize->1000 Microliter
							]&,
							Flatten[AllWells[]]
						]
					}]
				];
				(* Make sure UpdateCount is getting set while we're at it *)
				Download[
					Cases[Download[myProtocol,RequiredResources],{resource_,PipetteTips,___}:>Download[resource,Object]],
					{Amount,UpdateCount}
				]
			),
			{OrderlessPatternSequence[
				{96 Unit,False},
				{24 Unit,False}
			]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol},
			TimeConstraint->500
		],

		Test["Tip counting supports MultiProbeHead taking the entirety of the previous tip level:",
			(
				myProtocol=ExperimentSampleManipulation[{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Plate","A1"},
						Amount->60 Microliter
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->({"My Plate",#}&/@Flatten[AllWells[]]),
						Amount->60 Microliter
					]
				}];

				Download[
					Cases[Download[myProtocol,RequiredResources],{resource_,PipetteTips,___}:>Download[resource,Object]],
					Amount
				]
			),
			{_?(#>(96*2)&)},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol},
			TimeConstraint->500
		],


		Example[{Messages,"IncompatibleTipSize","Error if a TipSize is specified that is not compatible with any liquid handlers:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->150 Microliter,
						Destination->{"My Plate","A1"},
						TipSize->200 Microliter
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::IncompatibleTipSize},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"TipTypeDoesNotExistForSize","Error if a specified TipSize does not exist for a specified TipType:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->150 Microliter,
						Destination->{"My Plate","A1"},
						TipSize->50 Microliter,
						TipType->WideBore
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::TipTypeDoesNotExistForSize},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"TipTypeSizeDoesNotExist","Error if a specified TipSize does not match the MaxVolume of the TipType specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->150 Microliter,
						Destination->{"My Plate","A1"},
						TipSize->50 Microliter,
						TipType->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::TipTypeSizeDoesNotExist},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"TipSizeIncompatibleWithContainers","Error if a specified TipType is incompatible with a container:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->25 Microliter,
						Destination->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
						TipType->Model[Item,Tips,"50 uL Hamilton tips, non-sterile"]
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::TipSizeIncompatibleWithContainers},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"LiquidHandlerNotCompatibleWithTipType","Error if a set of manipulations requires tips that cannot fit on a specified liquid handler's deck:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->25 Microliter,
						Destination->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
						TipType->Model[Item,Tips,"200 uL tips, non-sterile"]
					]
				},
				LiquidHandler->Model[Instrument,LiquidHandler,"id:kEJ9mqaW7xZP"]
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::LiquidHandlerNotCompatibleWithTipType},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"IncompatibleTipForMixVolume","Error if a specified tip has a maximum aspiration volume less than the volume being mixed in a Mix primitive:"},
			ExperimentSampleManipulation[
				{
					Mix[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixVolume->500 Microliter,
						NumberOfMixes->3,
						TipType->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->25 Microliter,
						Destination->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
						TipType->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::IncompatibleTipForMixVolume},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"IncompatiblePipettingParametersScale","Error if MacroLiquidHandling is required but a TipType is specified:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->200 Milliliter,
						Destination->Model[Container,Vessel,"250mL Glass Bottle"],
						TipType->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::IncompatiblePipettingParametersScale},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],

		Example[{Messages,"TooManyTipsRequired","Error if a set of manipulations will require more tips than can fit on the deck:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate 1",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Plate 2",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Plate 3",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Plate 4",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Plate 5",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Plate 6",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Aliquot[
						Source->Model[Sample,"Milli-Q water"],
						Amounts->Table[25 Microliter,96],
						Destinations->Map[
							{"My Plate 1",#}&,
							Flatten@AllWells[]
						],
						TipType->Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"]
					],
					Aliquot[
						Source->Model[Sample,"Milli-Q water"],
						Amounts->Table[25 Microliter,96],
						Destinations->Map[
							{"My Plate 2",#}&,
							Flatten@AllWells[]
						],
						TipType->Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"]
					],
					Aliquot[
						Source->Model[Sample,"Milli-Q water"],
						Amounts->Table[25 Microliter,96],
						Destinations->Map[
							{"My Plate 3",#}&,
							Flatten@AllWells[]
						],
						TipType->Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"]
					],
					Aliquot[
						Source->Model[Sample,"Milli-Q water"],
						Amounts->Table[25 Microliter,96],
						Destinations->Map[
							{"My Plate 4",#}&,
							Flatten@AllWells[]
						],
						TipType->Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"]
					],
					Aliquot[
						Source->Model[Sample,"Milli-Q water"],
						Amounts->Table[25 Microliter,96],
						Destinations->Map[
							{"My Plate 5",#}&,
							Flatten@AllWells[]
						],
						TipType->Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"]
					],
					Aliquot[
						Source->Model[Sample,"Milli-Q water"],
						Amounts->Table[25 Microliter,96],
						Destinations->Map[
							{"My Plate 6",#}&,
							Flatten@AllWells[]
						],
						TipType->Model[Item,Tips,"300 uL Hamilton barrier tips, sterile"]
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::TooManyTipsRequired},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			TimeConstraint->10000
		],

		Example[{Messages,"MultiProbeHeadInvalidTransfer","Error if a MultiProbeHead transfer is not specified with exactly 96 wells:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"source plate",
						Container->Model[Container,Plate,"96-well 1mL Deep Well Plate"]
					],
					Define[
						Name->"destination plate",
						Container->Model[Container,Plate,"96-well 1mL Deep Well Plate"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->{{"source plate","A1"},{"source plate","A2"}},
						Volume->100 Microliter
					],
					Transfer[
						Source->{{"source plate","A1"},{"source plate","A2"}},
						Destination->{{"destination plate","A1"},{"destination plate","A2"}},
						Volume->50 Microliter,
						DeviceChannel->MultiProbeHead
					]
				},
				OptimizePrimitives->False
			],
			$Failed,
			Messages:>{Error::MultiProbeHeadInvalidTransfer}
		],

		(* Define Primitive Examples *)
		Example[{Additional,"Define Primitive","The Define primitive's Sample key can be used to name a model. If a name is defined as a model, this name will represent the same sample wherever it appears in primitives:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Water Sample",
							Sample->Model[Sample,"Milli-Q water"]
						],
						Transfer[
							Source->"My Water Sample",
							Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->1.5 Milliliter
						],
						Transfer[
							Source->"My Water Sample",
							Destination->Model[Container,Vessel,"2mL Tube"],
							Amount->1.5 Milliliter
						]
					}
				];
				#[Source]&/@Download[myProtocol,ResolvedManipulations][[2;;]]
			),
			{{{"My Water Sample"},{"My Water Sample"},{"My Water Sample"},{"My Water Sample"}}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Define Primitive","The Define primitive's Sample key can be used to name a specific sample. If a name is defined as a specific sample, the name can be used throughout the input list of primitives as a sample reference:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Specific Water Sample",
							Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
						],
						Transfer[
							Source->Model[Sample, "Trifluoroacetic acid, HPLC grade"],
							Destination->"My Specific Water Sample",
							Amount->1.5 Milliliter
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[2]][Destination]
			),
			{{"My Specific Water Sample"}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Define Primitive","The Define primitive's Container key can be used to name a model container. If a name is defined as a model container, this name will represent to same container wherever it appears in primitives:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Vessel",
							Container->Model[Container,Vessel,"2mL Tube"]
						],
						Consolidation[
							Sources->{Model[Sample,"Milli-Q water"],Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
							Destination->"My Vessel",
							Amounts->{500 Microliter,200 Microliter}
						]
					}
				];
				Download[myProtocol,ResolvedManipulations][[2]][Destination]
			),
			{{"My Vessel"},{"My Vessel"}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Define Primitive","The Define primitive's Container key can be used to name a specific container. If a name is defined as a container, this name will represent to same container wherever it appears in primitives:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->{"My Plate","A1"},
							Amount->10 Microliter
						]
					}
				];
				Join@@MapThread[
					Transpose[{##}]&,
					Download[myProtocol,ResolvedManipulations][[2]][{Destination,ResolvedDestinationLocation}]
				]
			),
			{{
				{"My Plate","A1"},
				{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"}
			}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Define Primitive","A sample can be named via Define using its location. If the location is defined, this name will represent the sample at the specified location wherever it appears in primitives:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Sample",
							Sample->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"}
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"My Sample",
							Amount->10 Microliter
						]
					}
				];
				Join@@MapThread[
					Transpose[{##}]&,
					Download[myProtocol,ResolvedManipulations][[2]][{Destination,ResolvedDestinationLocation,DestinationSample}]
				]
			),
			{{
				"My Sample",
				{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"},
				Download[Object[Sample, "Filter Sample in DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID], Object]
			}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Define Primitive","A Define primitive can name both a sample and its container:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Sample",
							Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							ContainerName->"My Sample's Plate"
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"My Sample",
							Amount->10 Microliter
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->{"My Sample's Plate","A2"},
							Amount->10 Microliter
						]
					}
				];
				Join@@MapThread[
					Transpose[{##}]&,
					Download[myProtocol,ResolvedManipulations][[2]][{Destination,ResolvedDestinationLocation,DestinationSample}]
				]
			),
			{
				{
					"My Sample",
					{Download[Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object],"A1"},
					Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]
				},
				{
					{"My Sample's Plate","A2"},
					{Download[Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object],"A2"},
					Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]
				}
			},
			ObjectP[Object[Protocol]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],

		Example[{Additional,"Define Primitive","A Define primitive can name a model and specify the container model in which it should exist:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Sample",
							Sample->Model[Sample,"Methanol"],
							Container->Model[Container,Vessel,"2mL Tube"]
						],
						Transfer[
							Source->"My Sample",
							Destination->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->50 Microliter
						]
					}
				];

				{requiredObjects,requiredResources}=Download[myProtocol,{RequiredObjects,RequiredResources}];

				sampleResourcePosition=First[FirstPosition[requiredObjects,{"My Sample",_},{1}]];

				resource=FirstCase[
					requiredResources,
					{resource:ObjectP[],RequiredObjects,sampleResourcePosition,2}:>resource
				];

				Download[resource,ContainerModels[Object]]
			),
			{Download[Model[Container,Vessel,"2mL Tube"],Object]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol,requiredObjects,requiredResources,sampleResourcePosition,resource}
		],

		Example[{Additional,"Define Primitive","A Define primitive can describe the sample that will be created in a particular location:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Container->Model[Container,Vessel,"2mL Tube"],
						Model->Model[Sample,"Milli-Q water"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My New Sample",
						Amount->50 Microliter
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol,requiredObjects,requiredResources,sampleResourcePosition,resource}
		],

		Example[{Additional,"Define Primitive","A Define primitive can describe the properties of a new model sample that must be created to describe the sample that will end up in a particular location:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Container->Model[Container,Vessel,"2mL Tube"],
						ModelType->Model[Sample],
						ModelName->"My New Model",
						TransportWarmed->50 Celsius
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My New Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol,requiredObjects,requiredResources,sampleResourcePosition,resource}
		],
		Example[{Additional,"Define Primitive","A Define primitive can describe a specific position in a plate:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Sample",
							Sample->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"}
						],
						Transfer[
							Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Destination->"My Sample",
							Amount->50 Microliter
						]
					}
				];

				{requiredObjects,resolvedManipulations}=Download[myProtocol,{RequiredObjects,ResolvedManipulations}];

				sample=First[resolvedManipulations][Sample];

				MemberQ[requiredObjects,{First[sample],_}]
			),
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol,requiredObjects,resolvedManipulations,sample}
		],
		Test["If a Define primitive defines a Name/Sample that is never used as a source, only include the container in the RequiredObjects:",
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My New Sample",
							Sample->Model[Sample,"Milli-Q water"],
							ContainerName->"My New Container",
							Container->Model[Container,Vessel,"250mL Glass Bottle"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"My New Container",
							Amount->100 Milliliter
						],
						Mix[
							Sample->"My New Sample",
							Time->1 Minute,
							MixType->Shake
						]
					}
				];
				Download[myProtocol,RequiredObjects][[All,1]]
			),
			_?(And[MemberQ[#,"My New Container"],!MemberQ[#,"My New Sample"]]&),
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],

		Example[{Messages,"MissingDefineKeys","The Name or ContainerName and Sample or Container keys must be specified in a Define primitive:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Name",
						Model->Model[Sample,"Milli-Q water"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Name",
						Amount->50 Microliter
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::MissingDefineKeys}
		],

		Example[{Messages,"InvalidName","The Name or ContainerName in a Define primitive cannot be a well position:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"A1",
						Sample->Model[Sample,"Milli-Q water"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"A1",
						Amount->50 Microliter
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::InvalidName}
		],

		Example[{Messages,"ModelNameExists","Error if a ModelName is specified that is already used:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Sample",
						Container->Model[Container,Vessel,"2mL Tube"],
						ModelName->"Milli-Q water",
						ModelType->Model[Sample]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Sample",
						Amount->50 Microliter
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::ModelNameExists}
		],

		Example[{Messages,"DuplicateModelName","Error if a ModelName is used multiple times:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Sample 1",
						Container->Model[Container,Vessel,"2mL Tube"],
						ModelName->"My special model name",
						ModelType->Model[Sample]
					],
					Define[
						Name->"My Sample 2",
						Container->Model[Container,Vessel,"2mL Tube"],
						ModelName->"My special model name",
						ModelType->Model[Sample]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Sample 1",
						Amount->50 Microliter
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Sample 2",
						Amount->50 Microliter
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::DuplicateModelName}
		],
		Example[{Messages,"DuplicateSamplesDefined","Error if the same sample was Defined multiple times:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate 1",
						Container->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]
					],
					Define[
						Name->"My Sample 1",
						Sample->{"My Plate 1","A1"}
					],
					Define[
						Name->"My Sample 2",
						Sample->{"My Plate 1","A1"}
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Sample 1",
						Amount->50 Microliter
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Sample 2",
						Amount->50 Microliter
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidInput,Error::DuplicateSamplesDefined}
		],
		Example[{Additional,"Centrifuge Primitive","Counterweight weights are calculated for the appropriate amount of mass in a spun plate:"},
			myProtocol=ExperimentSampleManipulation[
				{
					Define[
						Name->"my plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->{"my plate","A1"},
						Amount->500 Microliter
					],
					Centrifuge[
						Sample->"my plate",
						Time->5 Minute,
						Intensity->500 RPM
					]
				}
			];
			Download[myProtocol,ResolvedManipulations][[-1]][Counterweight],
			{ObjectP[Model[Item,Counterweight,"id:kEJ9mqaVPAaL"]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Centrifuge Primitive","Counterweight weights take into consideration existing samples in a plate:"},
			myProtocol=ExperimentSampleManipulation[
				{
					Centrifuge[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->5 Minute,
						Intensity->500 RPM
					]
				}
			];
			Download[myProtocol,ResolvedManipulations][[1]][Counterweight],
			{ObjectP[Model[Item,Counterweight,"id:kEJ9mqaVPAaL"]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Centrifuge Primitive","Counterweight weights take into consideration added samples in a plate during the course of the sample manipulation:"},
			myProtocol=ExperimentSampleManipulation[
				Join[
					{
						Define[
							Name->"my plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->{"my plate","A1"},
							Amount->500 Microliter
						],
						Centrifuge[
							Sample->"my plate",
							Time->5 Minute,
							Intensity->500 RPM
						]
					},
					Map[
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->{"my plate",#},
							Amount->500 Microliter
						]&,
						Flatten[AllWells[]][[2;;30]]
					],
					{
						Centrifuge[
							Sample->"my plate",
							Time->5 Minute,
							Intensity->500 RPM
						]
					}
				]
			];
			Flatten[(#[Counterweight])&/@Cases[Download[myProtocol,ResolvedManipulations],_Centrifuge]],
			{ObjectP[Model[Item,Counterweight,"id:kEJ9mqaVPAaL"]],ObjectP[Model[Item,Counterweight,"id:xRO9n3vk1Jjq"]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Filter Primitive","The Filter primitive can be used to pass samples through a filter at a specified pressure for a specified amount of time (micro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Additional,"Filter Primitive","A filtering's filtrate and residue's models can be specified using Define primitives (micro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Filter Residue",
						Sample->{"My Filter Plate","A1"},
						Model->Model[Sample,"Milli-Q water"]
					],
					Define[
						Name->"My Filtrate",
						Sample->{"My Collection Plate","A1"},
						Model->Model[Sample,"Milli-Q water"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{{"My Filter Plate","A1"},{"My Filter Plate","A2"}},
						Pressure->20 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate"
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],


		Example[{Additional,"Filter Primitive","Transferring into and out of the collection plate after its contents from the filter plate have been filtered is possible, allowing for the manipulation of the filtrate (micro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Wash Solution",
						Sample->Model[Sample,"Milli-Q water"],
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate"
					],
					Transfer[
						Source->"My Wash Solution",
						Destination->{"My Filter Plate","A1"},
						Amount->500 Microliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate"
					],
					Transfer[
						Source->{"My Collection Plate","A1"},
						Destination->Model[Container,Vessel,"2mL Tube"],
						Amount->200 Microliter,
						AspirationNumberOfMixes->3,
						AspirationMixVolume->100 Microliter
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Additional,"Filter Primitive","The Filter primitive can be used to pass samples through a filter on the macro liquid handling scale using a variety of different techniques:"},
			myProtocol=ExperimentSampleManipulation[
				{
					Filter[
						Sample->{Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID]}
					]
				},
				LiquidHandlingScale->MacroLiquidHandling
			];
			First[Download[myProtocol,ResolvedManipulations]][FiltrationType],
			{PeristalticPump,Syringe},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			),
			Variables:>{myProtocol}
		],
		Example[{Additional,"Filter Primitive","For samples with volumes above 50 mL, specify how the samples should be filtered using a peristaltic pump and a filter housing (macro liquid handling scale):"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{Object[Sample,"Filter Sample with 3L (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Filter Sample with 3L (II) for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						FiltrationType->PeristalticPump,
						Instrument->Model[Instrument,PeristalticPump,"VWR Peristaltic Variable Pump PP3400"],
						PoreSize->Quantity[0.22`,"Micrometers"],
						FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],
		Example[{Additional,"Filter Primitive","For samples with volumes between 2 and 50 mL, specify how the sample should be filtered using a a syringe and a syringe filter (macro liquid handling scale):"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->Object[Sample,"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
						FiltrationType->Syringe,
						Instrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],
						Syringe->Model[Container,Syringe,"id:P5ZnEj4P88OL"],
						PoreSize->Quantity[0.22`,"Micrometers"]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],
		Example[{Additional,"Filter Primitive","If a sample is already in the filter plate, filter it into a deep well plate via Vacuum filtration on a filter block (macro liquid handling scale):"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{Object[Sample,"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						FiltrationType->Vacuum,
						CollectionContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"],
						FilterHousing->Model[Instrument,FilterBlock,"Filter Block"]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Additional,"Filter Primitive","Filter multiple samples directly from a filter plate and collect them in 1 collection plate via Vacuum filtration on a filter block (macro liquid handling scale):"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{
							Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Object[Sample,"Filter Sample 2 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						FiltrationType->Vacuum,
						CollectionContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"],
						FilterHousing->Model[Instrument,FilterBlock,"Filter Block"]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Additional,"Filter Primitive","Filter a sample directly from a two-part filter vessel and collect them in the bottom part of the filter via Vacuum filtration (macro liquid handling scale):"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{Object[Sample,"Filter Test Sample with 500 mL (II) for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						FiltrationType->Vacuum
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Additional,"Filter Primitive","Use the Filter manipulation to filter a previously defined sample by Syringe (macro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Container",
						Container->Model[Container,Vessel,"id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->"My Container",
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Container"},
						FiltrationType->Syringe,
						Filter->Model[Item,Filter,"id:n0k9mG8A5OJw"]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],
		Example[{Additional,"Filter Primitive","Define the collection container for collecting the filtrate of a sample filtered by Syringe filtering (macro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Container",
						Container->Model[Container,Vessel,"id:3em6Zv9NjjN8"]
					],
					Filter[
						Sample->Object[Container,Vessel,"Filter Container for 1mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						FiltrationType->Syringe,
						CollectionContainer->"My Container"
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterContainerAccess","Only one filter plate is allowed to be transferred into at a time (between filterations, so that the filtered material does not drip onto the liquid handling deck):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate 1",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate 1",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Filter Plate 2",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate 2",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],

					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate 1","A1"},
						Amount->1 Milliliter
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate 2","A1"},
						Amount->1 Milliliter
					],

					Filter[
						Sample->{"My Filter Plate 1","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate 1"
					],
					Filter[
						Sample->{"My Filter Plate 2","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate 2"
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterContainerAccess,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidCollectionContainerAccess","Collection plates are not allowed to be transferred into/out of when they are stacked under the filter plate (when the corresponding filter plate is being loaded in preparation for filteration):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],

					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Collection Plate","A1"},
						Amount->1 Milliliter
					],

					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate"
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidCollectionContainerAccess,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidTransferFilterPlatePrimitive","Transfers into multiple filter plates within a single primitive are now allowed (since only one filter plate can be stacked on the collection plate at a time, to prevent dripping onto the deck):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate 1",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate 1",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Filter Plate 2",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate 2",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],

					Transfer[
						Source->{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->{{"My Filter Plate 1","A1"},{"My Filter Plate 2","A1"}},
						Amount->1 Milliliter
					],

					Filter[
						Sample->{"My Filter Plate 1","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate 1"
					],
					Filter[
						Sample->{"My Filter Plate 2","A1"},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate 2"
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidTransferFilterPlatePrimitive,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterSourcePrimitive","Micro filter primitives can only have samples from the same container, since the MPE2 can only filter one filter plate/collection plate stack at a time:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate 1",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Filter Plate 2",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Collection Plate 1",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],

					Filter[
						Sample->{{"My Filter Plate 1","A1"},{"My Filter Plate 2","A1"}},
						Pressure->40 PSI,
						Time->10 Second,
						CollectionContainer->"My Collection Plate 1"
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterSourcePrimitive,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"IncompatibleCollectionContainer","A Filter primitive must have a compatible CollectionContainer specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->4 Microliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second,
						CollectionContainer->Model[Container,Plate,MALDI,"96-well Ground Steel MALDI Plate"]
					]
				}
			],
			$Failed,
			Messages:>{Error::IncompatibleCollectionContainer,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"IncompatibleFilterContainer","A Filter primitive must use a compatible filter container specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, PTFE, 0.22um, 1.5mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::IncompatibleFilterContainer,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterContainerAccess","Only one filter plate is allowed to be transferred into at a time (between filterations, so that the filtered material does not drip onto the liquid handling deck):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate 1",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Define[
						Name->"My Filter Plate 2",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate 1","A1"},
						Amount->1 Milliliter
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate 2","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate 1","A1"},
						Pressure->20 PSI,
						Time->10 Second
					],
					Filter[
						Sample->{"My Filter Plate 2","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterContainerAccess,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterSampleSpecification","A Filter primitive must specify a sample in its Sample key:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->"My Filter Plate",
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterSampleSpecification,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterSampleLocation","A Filter primitive's Sample must be in a filter plate:"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterSampleLocation,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterSampleLocation","A Filter primitive's Sample referenced name must be in a filter plate:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterSampleLocation,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"InvalidFilterSampleLocation","A Filter primitive's Sample referenced container must be a filter plate:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 500uL Round Bottom DSC Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Plate","A1"},
						Amount->250 Microliter
					],
					Filter[
						Sample->{"My Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidFilterSampleLocation,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"ConflictingFilterPrimitiveKeys","A Filter primitive's keys must be specific for either micro or macro liquid handling, but not both:"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						FiltrationType->PeristalticPump,
						Pressure->20 PSI
					]
				},
				LiquidHandlingScale->MacroLiquidHandling
			],
			$Failed,
			Messages:>{Error::ConflictingFilterPrimitiveKeys,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"FilterManipConflictsWithScale","A Filter primitive's keys must match the liquid handling scale specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				},
				LiquidHandlingScale->MacroLiquidHandling
			],
			$Failed,
			Messages:>{Error::FilterManipConflictsWithScale,Error::InvalidOption},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"MissingMicroFilterKeys","For micro liquid handling scale, the Filter primitive's keys 'Pressure' and 'Time' are required:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"}
					]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::MissingMicroFilterKeys,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"TooManyMacroFilterCollectionPlates","Filtering on macro liquid handling scale does not support samples that would require multiple collection containers if one of them is a plate:"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{
							Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]
						},
						FiltrationType->Vacuum
					]
				}
			],
			$Failed,
			Messages:>{Error::TooManyMacroFilterCollectionPlates,Error::TooManyMacroFilterContainers,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"TooManyMacroFilterContainers","Filtering on macro liquid handling scale does not support multiple plates as input into one filter primitive:"},
			ExperimentSampleManipulation[
				{
					Filter[
						Sample->{
							Object[Sample,"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]
						},
						FiltrationType->Vacuum
					]
				}
			],
			$Failed,
			Messages:>{Error::TooManyMacroFilterContainers,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],


		Example[{Messages,"Error::InvalidCollectionContainer","On micro liquid handling scale, a Filter primitive's CollectionContainer must be a plate, and that plate currently must be of the type 'Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]':"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second,
						CollectionContainer->Model[Container,Vessel,"50mL Tube"]
					]
				}
			],
			$Failed,
			Messages:>{Error::IncompatibleCollectionContainer,Error::InvalidCollectionContainer,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],

		Example[{Messages,"Error::FilterManipConflictsWithResolvedScale","If a primitive requires macro liquid handling scale (here the Incubate primitive), the Filter primitive's keys cannot be requiring micro liquid handling:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->1 Milliliter
					],
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->30 Minute,
						Temperature->37 Celsius,
						MixType->Shake
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Pressure->20 PSI,
						Time->10 Second
					]
				}
			],
			$Failed,
			Messages:>{Error::FilterManipConflictsWithResolvedScale,Error::InvalidInput},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			)
		],
		(* MoveToMagnet/RemoveFromMagnet Examples *)
		Example[{Additional,"MoveToMagnet and RemoveFromMagnet Primitives","The MoveToMagnet and RemoveFromMagnet primitives can be used to perform magnetic bead-based purification:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Object[Sample,"Fake Liquid Sample for ExperimentSampleManipulation Testing"],
						Amount->200 Microliter,
						Destination->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"}
					],
					Mix[
						Sample->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixVolume->100 Microliter,
						NumberOfMixes->10
					],
					MoveToMagnet[
						Sample->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]
					],
					Wait[
						Duration->10 Minute
					],
					Transfer[
						Source->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"},
						Amount->180 Microliter,
						Destination->{Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],"A2"}
					],
					RemoveFromMagnet[
						Sample->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False];Unset[$CreatedObjects])
		],
		Example[{Messages,"IncompatibleMagnetContainer","The sample in the MoveToMagnet/RemoveFromMagnets primitive(s) must be in a 96-well plate:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Tube",
						Container->Model[Container,Vessel,"2mL Tube"]
					],
					MoveToMagnet[
						Sample->"My Tube"
					]
				}
			],
			$Failed,
			Messages:>{Error::IncompatibleMagnetContainer,Error::InvalidInput}
		],
		Example[{Messages,"FilterMagnetPrimitives","The Filter and MoveToMagnet/RemoveFromMagnet primitives can't both be specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Filter Plate",
						Container->Model[Container,Plate,Filter,"Plate Filter, GlassFiber, 30.0um, 1mL"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Filter Plate","A1"},
						Amount->100 Microliter
					],
					Filter[
						Sample->{"My Filter Plate","A1"},
						Time->10 Second
					],
					MoveToMagnet[
						Sample->Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]
					]
				}
			],
			$Failed,
			Messages:>{Error::FilterMagnetPrimitives,Error::InvalidInput}
		],

		Example[{Messages,"InvalidModelTypeName","ModelName and ModelType must be specified together in Define primitives:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Container->Model[Container,Vessel,"2mL Tube"],
						ModelType->Model[Sample],
						TransportWarmed->50 Celsius
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My New Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidModelTypeName,Error::InvalidInput}
		],
		Example[{Messages,"InvalidSampleContainer","Sample must be a location or Container must be specified if ModelType/ModelName are specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Sample->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						ModelType->Model[Sample],
						ModelName->"My New Model",
						TransportWarmed->50 Celsius
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My New Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidSampleContainer,Error::InvalidInput}
		],
		Example[{Messages,"InvalidModelParameters","ModelType and ModelName must be specified if any model parameters (TransportWarmed, State, Expires, ShelfLife, UnsealedShelfLife, or DefaultStorageCondition) are specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Container->Model[Container,Vessel,"2mL Tube"],
						TransportWarmed->50 Celsius
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My New Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidModelParameters,Error::InvalidInput}
		],
		Example[{Messages,"InvalidContainerName","Container must be specified or Sample must specify a location if ContainerName is specified:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Sample->Model[Sample,"Methanol"],
						ContainerName->"My Container"
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My New Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidContainerName,Error::InvalidInput}
		],
		Example[{Messages,"InvalidModelSpecification","Model cannot be specified as well as ModelType or ModelName:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My New Sample",
						Container->Model[Container,Vessel,"2mL Tube"],
						Model->Model[Sample,"Methanol"],
						ModelType->Model[Sample],
						ModelName->"My New Model",
						TransportWarmed->50 Celsius
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My New Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidModelSpecification,Error::InvalidInput}
		],
		Example[{Messages,"InvalidSampleParameters","StorageCondition or ExpirationDate can only be specified for samples that do not already exist:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Sample",
						Sample->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						StorageCondition->Freezer
					],
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidSampleParameters,Error::InvalidInput}
		],

		Example[{Messages,"InvalidNameReference","Names referred to by any primitives must have an associated Define primitive :"},
			ExperimentSampleManipulation[
				{
					Consolidation[
						Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Destination->"My Sample",
						Amounts->{50 Microliter,100 Microliter}
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidNameReference,Error::InvalidInput}
		],

		Example[{Options,Confirm,"Directly confirms a protocol into the operations queue:"},
			Quiet[
				ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},Confirm->True][Status],
				{Warning::SamplesOutOfStock,Warning::ExpiredSamples}
			],
			Processing|ShippingMaterials|Backlogged,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Name,"Give the protocol a name:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},Name->"My new protocol"][Name],
			"My new protocol",
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Name,"Name is Null if not specified:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]}][Name],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandlingScale,"A micro liquid handling robot will be used if the requested manipulation amounts are below 5mL, and all containers involved can be placed on the robot deck:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->Automatic][LiquidHandlingScale],
			MicroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandlingScale,"Manipulations will be performed at macro scale if any samples/models involved in the manipulations are marked as liquid handler incompatible:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"THF Sample in Tube"],Amount->100 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->Automatic][LiquidHandlingScale],
			MacroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandlingScale,"Specify explicitly that a micro liquid handling robot should be used to complete the requested manipulations:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling][LiquidHandlingScale],
			MicroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandlingScale,"Request that manipulations be performed at macro scale:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MacroLiquidHandling][LiquidHandlingScale],
			MacroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandlingScale,"Macro liquid handling will be used if manipulation amounts exceed 5mL, or if any solid transfers are involved:"},
			ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
				},
				LiquidHandlingScale->Automatic
			][LiquidHandlingScale],
			MacroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandlingScale,"If MicroLiquidHandling is explicitly requested, large volumes will be split into a series of repeated transfers:"},
			ExperimentSampleManipulation[{
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			},
				LiquidHandlingScale->MicroLiquidHandling
			][LiquidHandlingScale],
			MicroLiquidHandling,
			Messages:>{Warning::ManyTransfersRequired},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Resolve to MacroLiquidHandling if volumes >5mL are being used and no liquid handling scale if specified:",
			ExperimentSampleManipulation[{
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}][LiquidHandlingScale],
			MacroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandler,"A liquid handler will be resolved based on the resolved liquid handling scale:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling,LiquidHandler->Automatic][LiquidHandler][Name],
			"Super STAR",
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandler,"MacroLiquidHandling scale does not require a liquid handler instrument:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MacroLiquidHandling,LiquidHandler->Automatic][LiquidHandler],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandler,"Specify that a particular liquid handler model should be used:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling,LiquidHandler->Model[Instrument,LiquidHandler,"microbioSTAR"]][LiquidHandler][Name],
			"microbioSTAR",
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,LiquidHandler,"Specify the exact liquid handler to be used:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling,LiquidHandler->Object[Instrument,LiquidHandler,"Snoop Lion"]][LiquidHandler][Name],
			"Snoop Lion",
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,MeasureWeight,"Indicate that sample weights should be updated after the requested manipulations are performed:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},MeasureWeight->True][MeasureWeight],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,MeasureVolume,"Indicate that sample volumes should be updated after the requested manipulations are performed:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},MeasureVolume->True][MeasureVolume],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,ImageSample,"Indicate that new images should be taken of all samples after the requested manipulations are performed:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},ImageSample->True][ImageSample],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PreferredSampleImageOrientation,"Indicate that new images should be taken of all samples after the requested manipulations are performed:"},
			ExperimentSampleManipulation[
				{Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amount->300 Microliter,
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]},
				ImageSample->True,
				PreferredSampleImageOrientation->Top
			][PreferredSampleImageOrientation],
			Top,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,SamplesOutStorageCondition,"Set the storage condition in which newly-generated samples will be stored after the manipulations are completed:"},
			Lookup[ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->48.5 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
				},
				SamplesOutStorageCondition->Refrigerator
			][ResolvedOptions],SamplesOutStorageCondition],
			Refrigerator,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,SamplesInStorageCondition,"Set the storage condition for existing samples:"},
			ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->10 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
				},
				SamplesInStorageCondition->Refrigerator
			][SamplesInStorage],
			{Refrigerator..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PlaceLids,"Indicates if lids are placed on all plates after the manipulations have completed:"},
			options=ExperimentSampleManipulation[
				{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
				PlaceLids->True,
				Output->Options
			];
			Lookup[options,PlaceLids],
			True,
			Variables:>{options},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,TareWeighContainers,"Specify that empty containers should not be tare weighed prior to use:"},
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},TareWeighContainers->False],
				TaredContainers
			],
			{},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,TareWeighContainers,"If SamplesOutStorageCondition is specified as Disposal and TareWeighContainers as Automatic, no containers will be tared prior to use:"},
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},SamplesOutStorageCondition->Disposal],
				TaredContainers
			],
			{},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,TareWeighContainers,"TareWeighContainers automatically resolves to True if storage condition of samples out is default and no samples will go to TareContainers:"},
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},TareWeighContainers->Automatic],
				TaredContainers
			],
			{ObjectP[Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,TareWeighContainers,"If TareWeighContainers->True, empty containers will be marked for tare weighing prior to use:"},
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},TareWeighContainers->True],
				TaredContainers
			],
			{ObjectP[]..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"MissingTareWeight","If TareWeighContainers->False and any empty containers' models lack TareWeight, returns an error and does not create a protocol:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Model[Container,Vessel,"Vessel model without TareWeight"<>$SessionUUID]]},TareWeighContainers->False],
			$Failed,
			Messages:>{
				Error::InvalidOption,
				Error::MissingTareWeight
			},
			SetUp:>{
				$CreatedObjects={},
				If[!DatabaseMemberQ[Model[Container,Vessel,"Vessel model without TareWeight"<>$SessionUUID]],
					Upload[
						<|
							Type->Model[Container,Vessel],
							Name->"Vessel model without TareWeight"<>$SessionUUID,
							DeveloperObject->True,
							MaxVolume->50 Milliliter,
							Footprint->Conical50mLTube,
							Replace@Positions->{<|Name->"A1",Footprint->Null,MaxWidth->Quantity[0.028575,"Meters"],MaxDepth->Quantity[0.028575,"Meters"],MaxHeight->Quantity[0.1143,"Meters"]|>},
							TareWeight->Null
						|>
					]
				]
			},
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"DuplicateName","If a sample manipulation protocol already exists with the specified name, returns and error and does not create a protocol:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},Name->"Existing protocol"],
			$Failed,
			SetUp:>{
				$CreatedObjects={},
				If[!DatabaseMemberQ[Object[Protocol,SampleManipulation,"Existing protocol"]],
					Upload[<|
						Type->Object[Protocol,SampleManipulation],
						Name->"Existing protocol",
						DeveloperObject->True
					|>]
				]
			},
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::DuplicateName,Error::InvalidOption
			}
		],

		Example[{Messages,"TransferTypeDefaulted","TransferType will be defaulted if the provided value is inconsistent with the requested amount:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],TransferType->Solid]}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Warning::TransferTypeDefaulted
			}
		],
		Example[{Messages,"FillToVolumeDestinationsNotUnique","An error will be thrown if multiple FillToVolume primitives use the same destination container:"},
			ExperimentSampleManipulation[
				{
					Define[Name->"My Vessel",Container->Model[Container,Vessel,"15mL Tube"]],
					FillToVolume[Source->Model[Sample,"Isopropanol"],FinalVolume->15 Milliliter,Destination->"My Vessel"],
					FillToVolume[Source->Model[Sample,"Methanol"],FinalVolume->25 Milliliter,Destination->"My Vessel"]
				}
			],
			$Failed,
			Messages:>{
				Error::FillToVolumeDestinationsNotUnique,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NotCalibratedFillToVolumeDestination","An error will be thrown if FilLToVolume primitives have destination container models without a calibration populated:"},
			ExperimentSampleManipulation[
				{
					FillToVolume[
						Source->Model[Sample,"Isopropanol"],
						FinalVolume->15 Milliliter,
						Destination->Model[Container,Vessel,"35mL Amber Glass Vial"]
					]
				}
			],
			$Failed,
			Messages:>{
				Error::NotCalibratedFillToVolumeDestination,
				Error::InvalidInput
			}
		],
		(* TODO: currently wrong patterned sample manipulations also throw the SampleManipulationAmountOutOfRange error message. Need to fix in main function then fix this test *)
		Example[{Messages,"InvalidPrimitiveValue","An error will be thrown if any manipulation keys do not match expected patterns:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->10 Siemens,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			$Failed,
			Messages:>{
				Error::InvalidPrimitiveValue,
				Error::InvalidInput
			}
		],
		Example[{Messages,"PrimitiveAmountsInputInvalid","An error will be thrown if the lengths of the Amounts key and Sources/Destinations key for Aliquot or Consolidation primitives don't match:"},
			ExperimentSampleManipulation[
				{Aliquot[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amounts->{10Microliter},
					Destinations->{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				]}
			],
			$Failed,
			Messages:>{
				Error::PrimitiveAmountsInputInvalid,
				Error::InvalidInput
			}
		],
		Example[{Messages,"PrimitiveInputLengthsInvalid","An error will be thrown if the lengths of the Source and Destination key for Transfer primitives don't match:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"test plate",
						Container->Model[Container,Plate,"id:01G6nvkKrrYm"]
					],
					Transfer[
						Source->{Model[Sample,"id:O81aEBZnWMRO"]},
						Destination->{{"test plate","A1"},{"test plate","B1"}},
						Amount->1 Microliter
					]
				}
			],
			$Failed,
			Messages:>{
				Error::PrimitiveInputLengthsInvalid,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InWellSeparationKeyNotAllowed","An error will be thrown if any manipulation contains InWellSeparation Key as it is not supported by ExperimentSampleManipulation:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->10 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],InWellSeparation->True]}],
			$Failed,
			Messages:>{
				Error::InWellSeparationKeyNotAllowed,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ZeroAmountRemoved","If an amount of 0 is specified in a manipulation, it will be automatically removed, along with the corresponding source/destination:"},
			protocol=ExperimentSampleManipulation[{
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
					Amounts->{0 Milliliter,100 Microliter},
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}];
			{#[Source],#[Amount]}&/@protocol[ResolvedManipulations],
			{
				{{{{_Symbol,Model[Sample,"id:vXl9j5qEnnRD"]}}},{{100 Microliter}}}
			},
			Messages:>{
				Warning::ZeroAmountRemoved
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Messages,"ZeroAmountRemoved","If an amount of 0 is specified in a manipulation, it will be automatically removed, along with the corresponding source/destination:"},
			protocol=ExperimentSampleManipulation[{
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
					Amounts->{0 Milliliter,100 Microliter},
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}];
			{#[Source],#[Amount]}&/@protocol[ResolvedManipulations],
			{
				{{{{_Symbol,Model[Sample,"id:vXl9j5qEnnRD"]}}},{{100 Microliter}}}
			},
			Messages:>{},
			Stubs:>{$ECLApplication=Engine},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Messages,"ZeroAmountManipulationRemoved","If an entire manipulation has only zero amounts, it will be automatically removed from the manipulations list:"},
			protocol=ExperimentSampleManipulation[{
				Transfer[Source->Model[Sample,"Methanol"],Amount->0 Liter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
					Amounts->{0 Milliliter,100 Microliter},
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}];
			{#[Source],#[Amount]}&/@protocol[ResolvedManipulations],
			{
				{{{{_Symbol,Model[Sample,"id:vXl9j5qEnnRD"]}}},{{100 Microliter}}}
			},
			Messages:>{
				Warning::ZeroAmountRemoved,
				Warning::ZeroAmountManipulationRemoved
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Messages,"ZeroAmountManipulationRemoved","If an entire manipulation has only zero amounts, it will be automatically removed from the manipulations list. However, warnings will only be displayed if not in Engine:"},
			protocol=ExperimentSampleManipulation[{
				Transfer[Source->Model[Sample,"Methanol"],Amount->0 Liter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
					Amounts->{0 Milliliter,100 Microliter},
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}];
			{#[Source],#[Amount]}&/@protocol[ResolvedManipulations],
			{
				{{{{_Symbol,Model[Sample,"id:vXl9j5qEnnRD"]}}},{{100 Microliter}}}
			},
			Messages:>{},
			Stubs:>{$ECLApplication=Engine},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Messages,"AllManipulationsRemoved","If ALL provided manipulations are automatically removed due to containing zero amounts, a hard error will be returned and no protocol generated:"},
			ExperimentSampleManipulation[{
				Transfer[Source->Model[Sample,"Methanol"],Amount->0 Liter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Model[Sample,"Methanol"]},
					Amounts->{0 Milliliter,0 Microliter},
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}],
			$Failed,
			Messages:>{
				Warning::ZeroAmountRemoved,
				Warning::ZeroAmountManipulationRemoved,
				Error::AllManipulationsRemoved,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedSamples","Discarded samples may not be involved in manipulations; inclusion of any such samples or containers will result in an error:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Discarded Water Sample"],Amount->1 Milliliter,Destination->Model[Container,Vessel,"50mL Tube"]]}],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","Models marked as deprecated may not be involved in manipulations; inclusion of such models will result in an error:"},
			ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Methanol"],Amount->1 Milliliter,Destination->Model[Container,Vessel,"Deprecated Legacy 46mL Tube"]]}],
			$Failed,
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"EmptySourceContainer","An error will be thrown if the source container is empty for a Transfer primitive:"},
			ExperimentSampleManipulation[{Transfer[Source->Model[Container,Vessel,"15mL Tube"],Amount->2 Milliliter,Destination->Model[Container,Vessel,"50mL Tube"]]}],
			$Failed,
			Messages:>{
				Error::EmptySourceContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DrainedWell","A warning will be thrown if, based on current sample volume information, a manipulation is expected to draw more from a given sample than will exist at that time:"},
			ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 7 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amount->500 Microliter,
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			Messages:>{
				Warning::DrainedWell
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"DrainedWell","The DrainedWell check will take into account previous manipulations that supplement existing sample volumes, and not throw an error in this case:"},
			ExperimentSampleManipulation[{
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Object[Sample,"Test chemical 7 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 7 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->500 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"OverfilledWell","An error will be thrown if at any point, a destination will have more volume added to it than it can contain:"},
			ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->2 Liter,Destination->Model[Container,Vessel,"50mL Tube"]]}],
			$Failed,
			Messages:>{
				Error::OverfilledWell,
				Error::InvalidInput
			}
		],
		Example[{Messages,"OverfilledWell","Transfers into the same destination will be considered cumulatively when determining whether a destination location is overfilled:"},
			ExperimentSampleManipulation[
				{
					Define[Name->"my50mLTube",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->15 Milliliter,Destination->"my50mLTube"],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->15 Milliliter,Destination->"my50mLTube"],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->15 Milliliter,Destination->"my50mLTube"],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->15 Milliliter,Destination->"my50mLTube"]
				}
			],
			$Failed,
			Messages:>{
				Error::OverfilledWell,
				Error::InvalidInput
			}
		],
		Example[{Messages,"SampleManipulationAmountOutOfRange","An error will be thrown if any manipulations fall outside currently-measurable ranges:"},
			ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->1 Picogram,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}],
			$Failed,
			Messages:>{
				Error::SampleManipulationAmountOutOfRange,
				Error::InvalidInput
			}
		],
		Example[{Messages,"MicroScaleNotPossible","An error will be thrown if an explicitly-provided liquid handling scale is not compatible with the requested manipulations; in this case, a solid transfer cannot be performed at micro scale:"},
			ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Sodium Chloride"],Amount->5 Gram,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling],
			$Failed,
			Messages:>{
				Error::MicroScaleNotPossible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleChemicals","An error will be thrown if micro liquid handling is requested, but any of the input samples or models have been marked as automated liquid handler-incompatible:"},
			ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Tetrahydrofuran, Reagent Grade"],Amount->100 Microliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling],
			$Failed,
			Messages:>{
				Error::IncompatibleChemicals,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnusedLiquidHandler","A warning will be thrown if a liquid handler instrument is provided but will not be used due to the liquid handling scale:"},
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MacroLiquidHandling,LiquidHandler->Model[Instrument,LiquidHandler,"microbioSTAR"]],
			ObjectP[Object[Protocol,SampleManipulation]],
			Messages:>{
				Warning::UnusedLiquidHandler
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"IncompatibleIncubationFootprints","Incubate primitives do not support containers with footprints that are not Plate:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"destination",
					Container->Model[Container,Vessel,"50mL Tube"]],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"destination",Amount->970 Microliter
				],
				Incubate[
					Sample->"destination",
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}],
			$Failed,
			Messages:>{Error::IncompatibleIncubationFootprints,Error::InvalidInput}
		],
		Example[{Messages,"ConflictingIncubation","Incubate primitives cannot specify different parameters for the same container or samples in the same container:"},
			ExperimentSampleManipulation[{
				Incubate[
					Sample->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Time->{10 Minute,15 Minute},
					Temperature->37 Celsius
				]
			}],
			$Failed,
			Messages:>{Error::ConflictingIncubation,Error::InvalidInput}
		],
		Example[{Messages,"ConflictingCoolingShaking","Cooling and Shaking cannot be performed on the same sample at MicroLiquidHandling scale:"},
			ExperimentSampleManipulation[{
				Incubate[
					Sample->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Time->10Minute,
					Temperature->4 Celsius,
					MixRate->100 RPM
				]
			}],
			$Failed,
			Messages:>{Error::ConflictingCoolingShaking,Error::InvalidInput}
		],
		Example[{Messages,"TooManyIncubationContainers","Incubate primitives cannot use more than four incubators (only four or fewer containers can be residually incubated or mixed):"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate 1",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My Plate 2",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Define[
						Name->"My New Sample 1",
						Sample->Model[Sample,"Dimethylformamide, Reagent Grade"]
					],
					Define[
						Name->"My New Sample 2",
						Sample->Model[Sample,"Dimethylformamide, Reagent Grade"]
					],
					Incubate[
						Sample->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						Time->10 Minute,
						Temperature->37 Celsius,
						ResidualIncubation->True,
						ResidualTemperature->37 Celsius
					],
					Incubate[
						Sample->{"My Plate 1","My Plate 2"},
						Time->10 Minute,
						Temperature->37 Celsius,
						ResidualIncubation->True,
						ResidualTemperature->37 Celsius
					],
					Incubate[
						Sample->{"My New Sample 1","My New Sample 2"},
						Time->{10 Minute,15 Minute},
						Temperature->37 Celsius,
						ResidualIncubation->True,
						ResidualTemperature->37 Celsius
					]
				}
			],
			$Failed,
			Messages:>{Error::TooManyIncubationContainers,Error::InvalidInput}
		],
		Example[{Messages,"InvalidIncubatePrimitive","An error will be thrown if the Incubate primitive lists keys that are specific for both MicroLiquidHandling and MacroLiquidHandling scales:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->10 Minute,
						Temperature->37 Celsius,
						AnnealingTime->5 Minute,
						Preheat->True
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidIncubatePrimitive,Error::InvalidInput}
		],
		Example[{Messages,"IncubateManipConflictsWithScale","An error will be thrown if the Incubate primitive lists keys that are specific for MicroLiquidHandling while LiquidHandlingScale is set to MacroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->10 Minute,
						Temperature->37 Celsius,
						Preheat->True
					]
				},
				LiquidHandlingScale->MacroLiquidHandling
			],
			$Failed,
			Messages:>{Error::IncubateManipConflictsWithScale,Error::InvalidOption}
		],

		Example[{Messages,"IncubateManipConflictsWithScale","An error will be thrown if the Incubate primitive lists keys that are specific for MacroLiquidHandling while LiquidHandlingScale is set to MicroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->10 Minute,
						Temperature->37 Celsius,
						AnnealingTime->5 Minute
					]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::IncubateManipConflictsWithScale,Error::InvalidOption}
		],
		Example[{Messages,"IncubateManipConflictsWithScale","An error will be thrown if the Resuspend primitive lists keys that are specific for MacroLiquidHandling while LiquidHandlingScale is set to MicroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Resuspend[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Volume->100 Microliter,
						IncubationTime->10 Minute,
						IncubationTemperature->37 Celsius,
						AnnealingTime->5 Minute
					]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::IncubateManipConflictsWithScale,Error::InvalidOption}
		],
		Example[{Messages,"IncubateManipConflictsWithResolvedScale","An error will be thrown if Incubate primitives have keys specific to MicroLiquidHandling, however another primitive requires the scale MacroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->10 Minute,
						Temperature->37 Celsius,
						Preheat->True
					],
					FillToVolume[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						FinalVolume->25 Milliliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]
					]
				}
			],
			$Failed,
			Messages:>{Error::IncubateManipConflictsWithResolvedScale,Error::InvalidInput}
		],

		Example[{Messages,"MicroPrimitiveMissingKeys","An error will be thrown if Incubate primitives are missing keys that are required for MicroLiquidHandling, when the scale was user-specified to MicroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->10 Minute
						(* Temperature is missing *)
					]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::MicroPrimitiveMissingKeys,Error::InvalidInput}
		],

		Example[{Messages,"MicroPrimitiveMissingKeys","An error will be thrown if Resuspend primitives are missing keys that are required for MicroLiquidHandling but mixing is still desired, when the scale was user-specified to MicroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Resuspend[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Volume->100 Microliter,
						(* Time is missing *)
						IncubationTemperature->40 Celsius
					]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::MicroPrimitiveMissingKeys,Error::InvalidInput}
		],


		Example[{Messages,"MicroPrimitiveMissingKeys","An error will be thrown if Incubate primitives are missing keys that are required for MicroLiquidHandling, when the scale was resolved to MicroLiquidHandling (for instance because no other primitive required macro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Temperature->30 Celsius
						(* Time is missing *)
					]
				}
			],
			$Failed,
			Messages:>{Error::MicroPrimitiveMissingKeys,Error::InvalidInput}
		],

		Example[{Messages,"ResidualMixNeeded","An error will be thrown if ResidualIncubation is specified or resolved to True, and ResidualMix set to False, even though we're shaking (MacroLiquidHandling):"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						Temperature->30 Celsius,
						ResidualIncubation->True,
						ResidualMix->False
					]
				}
			],
			$Failed,
			Messages:>{Error::ResidualMixNeeded,Error::InvalidInput}
		],
		Example[{Messages,"ResidualIncubationNeeded","ResidualIncubation cannot be False when ResidualMix is set to True:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						Temperature->30 Celsius,
						ResidualIncubation->False,
						ResidualMix->True
					]
				}
			],
			$Failed,
			Messages:>{Error::ResidualIncubationNeeded,Error::InvalidInput}
		],

		Example[{Messages,"InvalidResidualIncubation","ResidualIncubation cannot be False when ResidualTemperature is specified (macro liquid handling):"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						Temperature->30 Celsius,
						ResidualIncubation->False,
						ResidualTemperature->30 Celsius
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidResidualIncubation,Error::InvalidInput}
		],

		Example[{Messages,"InvalidResidualTemperature","On MacroLiquidHandling scale, ResidualTemperature has to be identical to Temperature:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						Temperature->30 Celsius,
						ResidualIncubation->True,
						ResidualTemperature->25 Celsius
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidResidualTemperature,Error::InvalidInput}
		],

		Example[{Messages,"InvalidResidualMix","ResidualMix cannot be False when ResidualMixRate is specified (macro liquid handling):"},
			(* This will also throw the other ResidualMixNeeded message which can't be avoided since ResidualIncubation is resolved via ResidualMixRate *)
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						Temperature->30 Celsius,
						ResidualMix->False,
						ResidualMixRate->168 RPM
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidResidualMix,Error::ResidualMixNeeded,Error::InvalidInput}
		],

		Example[{Messages,"InvalidResidualMixRate","On MacroLiquidHandling scale, ResidualMixRate has to be identical to MixRate:"},
			(* This will also throw the other ResidualMixNeeded message which can't be avoided since ResidualIncubation is resolved via ResidualMixRate *)
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						MixType->Shake,
						Time->10 Minute,
						Temperature->30 Celsius,
						MixRate->100 RPM,
						ResidualMix->True,
						ResidualMixRate->168 RPM
					]
				}
			],
			$Failed,
			Messages:>{Error::InvalidResidualMixRate,Error::InvalidInput}
		],

		Example[{Messages,"FillToVolumeConflictsWithScale","An error will be thrown if the specified LiquidHandlingScale is MicroLiquidHandling, while the manipulations contain a FillToVolume primitive:"},
			ExperimentSampleManipulation[
				{FillToVolume[
					Source->Model[Sample,"Methanol"],
					FinalVolume->40 Milliliter,
					Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::FillToVolumeConflictsWithScale,Error::InvalidOption}
		],

		Example[{Messages,"MicroScaleNotPossible","An error will be thrown if the specified LiquidHandlingScale is MicroLiquidHandling, while the manipulations require MacroLiquidHandling:"},
			ExperimentSampleManipulation[
				{
					Transfer[
						Source->Model[Sample,"Sodium Chloride"],
						Amount->5 Milligram,
						Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]
					]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{Error::MicroScaleNotPossible,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleLiquidHandler","An error will be thrown if the specified LiquidHandler cannot accommodate Incubate primitives:"},
			ExperimentSampleManipulation[
				{
					Incubate[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Time->10 Minute,
						Temperature->37 Celsius
					]
				},
				LiquidHandlingScale->MicroLiquidHandling,
				LiquidHandler->Model[Instrument,LiquidHandler,"id:aXRlGnZmOd9m"]
			],
			$Failed,
			Messages:>{Error::IncompatibleLiquidHandler,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLiquidHandler","An error will be thrown if a provided LiquidHandler option cannot accommodate the manipulations:"},
			ExperimentSampleManipulation[{
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]
			},LiquidHandlingScale->MicroLiquidHandling,LiquidHandler->Model[Instrument,LiquidHandler,"Hamilton STARlet"]],
			$Failed,
			Messages:>{
				Error::InvalidLiquidHandler,
				Error::InvalidOption
			},
			TimeConstraint->300
		],
		Example[{Messages,"TooManyContainers","If the desired scale is micro liquid handling, but more containers are provided than will fit on any current micro liquid handling robot deck, an error will be thrown:"},
			ExperimentSampleManipulation[{
				Aliquot[Destinations->ConstantArray[Model[Container,Vessel,"50mL Tube"],13],Amounts->ConstantArray[300 Microliter,13],Source->Model[Sample,"Milli-Q water"]]
			},LiquidHandlingScale->MicroLiquidHandling,LiquidHandler->Automatic,ParentProtocol->Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::TooManyContainers,
				Error::InvalidInput
			}
		],
		Example[{Messages,"VentilatedOpenContainer","Throws errors if substances requiring a fume hood are set to be transferred into open containers:"},
			ExperimentSampleManipulation[{
				Define[Sample->Model[Sample,"Isoprene"],Name->"isoprene"],
				Transfer[Source->"isoprene",Amount->1 Milliliter,Destination->Model[Container,Vessel,"50mL Pyrex Beaker"]]
			}],
			$Failed,
			Messages:>{Error::VentilatedOpenContainer}
		],
		Test["Allow child protocols to skip the open container check:",
			ExperimentSampleManipulation[
				{
					Define[Sample->Model[Sample,"Isoprene"],Name->"isoprene"],
					Transfer[Source->"isoprene",Amount->1 Milliliter,Destination->Model[Container,Vessel,"50mL Pyrex Beaker"]]
				},
				ParentProtocol->Object[Protocol,MassSpectrometry,"Parent Protocol for ExperimentSampleManipulation Open Container Test"]
			],
			ObjectP[],
			SetUp:>(
				$CreatedObjects={};
				Upload[<|Type->Object[Protocol,MassSpectrometry],Name->"Parent Protocol for ExperimentSampleManipulation Open Container Test"|>]
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		(* Example[{Messages,"ModelOverMicroMax","If the liquid handling scale is micro, but a single model source is required in an amount larger than the maximum that can be held in one reservoir on the robot deck, an error will be thrown:"},
			ExperimentSampleManipulation[
				{
					myTube1=Model[Container,Vessel,"50mL Tube"],
					myTube2=Model[Container,Vessel,"50mL Tube"],
					myTube3=Model[Container,Vessel,"50mL Tube"],
					myTube4=Model[Container,Vessel,"50mL Tube"],
					myTube5=Model[Container,Vessel,"50mL Tube"],
					myTube6=Model[Container,Vessel,"50mL Tube"]
				},
				{
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube1],

					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube2],

					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube3],

					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube4],

					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube5],

					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6],
					Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Amount->5 Milliliter,Destination->myTube6]
				},
				LiquidHandlingScale->MicroLiquidHandling
			],
			$Failed,
			Messages:>{
				Error::ModelOverMicroMax,
				Error::InvalidInput
			},
			TimeConstraint->500
		], *)

		Test["Populate the PipetteTips field for a MicroLiquidHandling protocol:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]}][PipetteTips],
			{ObjectP[Model[Item,Tips]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Return Upload-ready packets when Upload->False:",
			ExperimentSampleManipulation[{
				Aliquot[
					Source->Model[Sample,StockSolution,"70% Ethanol"],
					Amounts->{100 Microliter,100 Microliter,100 Microliter,100 Microliter},
					Destinations->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				],
				Mix[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],MixVolume->300 Microliter,NumberOfMixes->5],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Amounts->{100 Microliter,100 Microliter,200 Microliter,50 Microliter},
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			},Upload->False],
			_?ValidUploadQ
		],
		Test["Return valid protocol with Upload->True:",
			ExperimentSampleManipulation[{
				Aliquot[
					Source->Model[Sample,StockSolution,"70% Ethanol"],
					Amounts->{100 Microliter,100 Microliter,100 Microliter,100 Microliter},
					Destinations->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				],
				Mix[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],MixVolume->300 Microliter,NumberOfMixes->5],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Amounts->{100 Microliter,100 Microliter,200 Microliter,50 Microliter},
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			},Upload->True],
			_?ValidObjectQ,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Set the ParentProtocol field - and set Author to Null - when ParentProtocol option is passed:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},ParentProtocol->Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]][[{ParentProtocol,Author}]],
			{LinkP[Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]],Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Skip drained well messages when ParentProtocol is set:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->2.2 Milliliter,Destination->Model[Container,Vessel,"2mL Tube"]]},ParentProtocol->Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{Error::OverfilledWell,Error::InvalidInput}
		],
		Test["Skip drained well/overfilled well messages when FastTrack is True:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->2.2 Milliliter,Destination->Model[Container,Vessel,"2mL Tube"]]},FastTrack->True],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Empty containers or model containers will be placed in the TaredContainers field for tare-weighing:",
			ExperimentSampleManipulation[{
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}][TaredContainers],
			{LinkP[Model[Container,Vessel,"2mL Tube"]],LinkP[Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Do NOT tare-weigh empty containers that already have a tare weight:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Container,Vessel,"Empty 50mL Falcon Tube with Tare Weight"]]}][TaredContainers],
			{},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["In RequiredObjects, container models will be tagged and samples/containers will be identified solely by their object reference:",
			ExperimentSampleManipulation[
				{
					Define[Name->"myTube",Container->Model[Container,Vessel,"2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->"myTube"],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->300 Microliter,Destination->"myTube"],
					Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]],
					Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
				}
			][RequiredObjects],
			{OrderlessPatternSequence[
				{{_Symbol,ObjectReferenceP[Model[Sample,"Milli-Q water"]]},LinkP[Model[Sample,"Milli-Q water"]]},
				{"myTube",LinkP[Model[Container,Vessel,"2mL Tube"]]},
				{{_Symbol,ObjectReferenceP[Model[Container,Vessel,"2mL Tube"]]},LinkP[Model[Container,Vessel,"2mL Tube"]]},
				{ObjectReferenceP[Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
				{ObjectReferenceP[Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}
			]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["If a single Transfer requires more than a known maximum of a chemical component, don't split it and assume the resource picking consolidation system will handle it:",
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Methanol"],Amount->5 Liter,Destination->Model[Container,Vessel,"10L Polypropylene Carboy"]]}];
			(First/@First/@{#[Source],#[Amount],#[Destination]})&/@Download[protocol,ResolvedManipulations],
			{{
				{sourceTag1_Symbol,ObjectReferenceP[Model[Sample,"Methanol"]]},
				_?((#==5 Liter)&),
				{_Symbol,ObjectReferenceP[Model[Container,Vessel,"10L Polypropylene Carboy"]]}
			}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If a single manipulation requires more than a known maximum of specifically water, do NOT split it:",
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->5 Liter,Destination->Model[Container,Vessel,"20L Polypropylene Carboy"]]}];
			(First/@First/@{#[Source],#[Amount],#[Destination]})&/@Download[protocol,ResolvedManipulations],
			{
				{
					{_Symbol,ObjectReferenceP[Model[Sample,"Milli-Q water"]]},
					_?((#==5 Liter)&),
					{_Symbol,ObjectReferenceP[Model[Container,Vessel,"20L Polypropylene Carboy"]]}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["When using a specific sample, include the required Amount in requested resources:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->{Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"},
					Amount->100 Microliter,
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				],
				Aliquot[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amounts->{100 Microliter},
					Destinations->{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				],
				Consolidation[
					Sources->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					Amounts->{100 Microliter},
					Destination->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
				]
			}];

			resources=Cases[
				Download[protocol,RequiredResources],
				{_,RequiredObjects,___}
			][[All,1]];

			resourceTuples=Download[resources,{Sample,Amount}];

			Cases[resourceTuples,{LinkP[Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],amount_}:>amount],
			{300. Microliter},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			EquivalenceFunction->Equal,
			Variables:>{protocol,resources,resourceTuples}
		],
		Test["When splitting sample model resources, request multiple required resources:",
			Lookup[
				DeleteDuplicatesBy[
					Select[
						ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Methanol"],Amount->5 Liter,Destination->Model[Container,Vessel,"10L Polypropylene Carboy"]]},Upload->False],
						MatchQ[#,PacketP[Object[Resource,Sample]]]&&MemberQ[Lookup[#,Replace[Models]],LinkP[Model[Sample,"Methanol"]]]&
					],
					(#[Object])&
				],
				Amount
			],
			{5.5 Liter}
		],
		Test["Split model resources if manipulations in total require more than the single sample maximum:",
			protocol=ExperimentSampleManipulation[
				{
					Define[Name->"myBottle",Container->Model[Container,Vessel,"10L Polypropylene Carboy"]],
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->"myBottle"],
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->"myBottle"],
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->"myBottle"]
				}
			];
			Download[protocol,RequiredObjects],
			{OrderlessPatternSequence[
				{"myBottle",LinkP[Model[Container,Vessel,"10L Polypropylene Carboy"]]},
				{{sourceTag1_Symbol,ObjectReferenceP[Model[Sample,"Methanol"]]},LinkP[Model[Sample,"Methanol"]]},
				{{sourceTag2_Symbol,ObjectReferenceP[Model[Sample,"Methanol"]]},LinkP[Model[Sample,"Methanol"]]}
			]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If one model is needed in an amount larger than what a single robotic reservoir can hold, two resources are created:",
			protocol=ExperimentSampleManipulation[
				Join[
					{
						Define[Name->"plate1",Container->Model[Container,Plate,"id:E8zoYveRllM7"]],
						Define[Name->"plate2",Container->Model[Container,Plate,"id:E8zoYveRllM7"]]
					},
					Flatten@Map[
						{
							Transfer[
								Source->Model[Sample,StockSolution,"70% Ethanol"],
								Volume->3.5 Milliliter,
								Destination->{"plate1",#},
								TipSize->1000 Microliter
							],
							Transfer[
								Source->Model[Sample,StockSolution,"70% Ethanol"],
								Volume->3.5 Milliliter,
								Destination->{"plate2",#},
								TipSize->1000 Microliter
							]
						}&,
						Flatten[AllWells[36,OutputFormat->Position]]
					]
				],
				LiquidHandlingScale->MicroLiquidHandling
			];
			Download[
				Cases[protocol[RequiredResources],{_,RequiredObjects,___}][[All,1]],
				Models
			],
			{
				OrderlessPatternSequence[
					{LinkP[Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"]]},
					{LinkP[Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"]]},
					{LinkP[Model[Container,Plate,"id:E8zoYveRllM7"]]},
					{LinkP[Model[Container,Plate,"id:E8zoYveRllM7"]]}
				]
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol},
			TimeConstraint->500
		],
		Test["Requests 1.1x the volume needed to complete the transfer:",
			protocol=ExperimentSampleManipulation[
				{Transfer[Source->Model[Sample,StockSolution,"70% Ethanol"],Volume->125 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]},
				LiquidHandlingScale->MicroLiquidHandling
			];
			Download[
				Cases[protocol[RequiredResources],{_,RequiredObjects,___}][[All,1]],
				{Models,Amount}
			],
			{
				OrderlessPatternSequence[
					{{LinkP@Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"]},_?((#>125 Microliter)&)},
					{{LinkP@Model[Container,Vessel,"id:3em6Zv9NjjN8"]},Null}
				]
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Detect a liquid handler-incompatible chemical even if directly provided as a sample:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"THF Sample in Tube"],Amount->100 Microliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling],
			$Failed,
			Messages:>{
				Error::IncompatibleChemicals,
				Error::InvalidOption
			}
		],
		Test["Detect a liquid handler-incompatible chemical even if buried in the contents of an input container:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Container,Vessel,"50mL Tube with THF"],Amount->100 Microliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MicroLiquidHandling],
			$Failed,
			Messages:>{
				Error::IncompatibleChemicals,
				Error::InvalidOption
			}
		],
		Test["PreFlush is not populated if bufferbot is not used, even if the option value is provided:",
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Milli-Q water"],Amount->5 Liter,Destination->Model[Container,Vessel,"20L Polypropylene Carboy"]]},PreFlush->True];
			Download[protocol,PreFlush],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Populate SamplesIn and ContainersIn with all known objects:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amount->50 Microliter,
					Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[
					Source->Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amount->50 Microliter,
					Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}];
			Download[protocol,{SamplesIn[Object],ContainersIn[Object]}],
			{
				{
					ObjectReferenceP[Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					ObjectReferenceP[Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]
				},
				{
					ObjectReferenceP[Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					ObjectReferenceP[Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulation unit test "<>$SessionUUID]],ObjectReferenceP[Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Skip discarded samples check when FastTrack is True:",
			ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Discarded Water Sample"],Amount->50 Milliliter,Destination->Model[Container,Vessel,"50mL Tube"]]},FastTrack->True],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Skip deprecated models check when FastTrack is True:",
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Methanol"],Amount->50 Milliliter,Destination->Model[Container,Vessel,"Deprecated Legacy 46mL Tube"]]},FastTrack->True],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Tie an order to the protocol using OrderFulfilled option:",
			Download[ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Discarded Water Sample"],Amount->50 Milliliter,Destination->Model[Container,Vessel,"50mL Tube"]]},FastTrack->True,OrderFulfilled->{Object[Transaction,Order,"Fake Order to tie to SM"]}],OrdersFulfilled[Object]],
			{ObjectReferenceP[Object[Transaction,Order,"Fake Order to tie to SM"]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Tie a resource to the protocol using PreparedResources option:",
			Download[ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Discarded Water Sample"],Amount->50 Milliliter,Destination->Model[Container,Vessel,"50mL Tube"]]},FastTrack->True,PreparedResources->{Object[Resource,Sample,"Fake Resource for SM PreparedREsources Option"]}],PreparedResources[Object]],
			{ObjectReferenceP[Object[Resource,Sample,"Fake Resource for SM PreparedREsources Option"]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["RentContainer property of prepared resources is passed to any resources created to generate the sample:",
			protocol=ExperimentSampleManipulation[{Transfer[Source->Model[Sample,"Isopropanol"],Amount->15 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]},LiquidHandlingScale->MacroLiquidHandling,PreparedResources->{Object[Resource,Sample,"Fake Resource for SM PreparedREsources Option"]}];
			Select[Download[protocol,RequiredResources[[All,1]]],MatchQ[#[Object],ObjectP[Object[Resource,Sample]]]&][RentContainer],
			{True..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Split model resources if manipulations if preparing resources with different RentContainer fields:",
			protocol=ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->Model[Container,Vessel,"Amber Glass Bottle 4 L"]],
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->Model[Container,Vessel,"Amber Glass Bottle 4 L"]]
				},
				PreparedResources->{
					Object[Resource,Sample,"Fake Resource for SM PreparedREsources Option"],
					Object[Resource,Sample,"fake Res 2 for SM PrepREsource Option"]
				}
			];
			Download[protocol,RequiredObjects],
			{OrderlessPatternSequence[
				{{containerTag1_Symbol,ObjectReferenceP[Model[Container,Vessel,"Amber Glass Bottle 4 L"]]},LinkP[Model[Container,Vessel,"Amber Glass Bottle 4 L"]]},
				{{containerTag2_Symbol,ObjectReferenceP[Model[Container,Vessel,"Amber Glass Bottle 4 L"]]},LinkP[Model[Container,Vessel,"Amber Glass Bottle 4 L"]]},
				{{sourceTag1_Symbol,ObjectReferenceP[Model[Sample,"Methanol"]]},LinkP[Model[Sample,"Methanol"]]},
				{{sourceTag2_Symbol,ObjectReferenceP[Model[Sample,"Methanol"]]},LinkP[Model[Sample,"Methanol"]]}
			]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Resources generated for preparation of the manipulations pass the index-matched RentContainer boolean from PreparedResources option:",
			protocol=ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->Model[Container,Vessel,"Amber Glass Bottle 4 L"]],
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->Model[Container,Vessel,"Amber Glass Bottle 4 L"]]
				},
				PreparedResources->{
					Object[Resource,Sample,"Fake Resource for SM PreparedREsources Option"],
					Object[Resource,Sample,"fake Res 2 for SM PrepREsource Option"]
				}
			];
			Module[{manips,reqObjIndices,reqResourceEntries},

				(* get the Manipulations field,RequiredObjects field, and RequiredResources field *)
				{manips,requiredObjects,requiredResources}=Download[protocol,{ResolvedManipulations,RequiredObjects,RequiredResources}];

				(* index of the releveant required objects entry for each source *)
				reqObjIndices=Map[
					First[FirstPosition[requiredObjects[[All,1]],#,Null,{1},Heads->False]]&,
					Join@@((Join@@#[Source])&/@manips)
				];

				(* get the associated req resource entry *)
				reqResourceEntries=FirstCase[requiredResources,{_,RequiredObjects,#,_}]&/@reqObjIndices;

				(* Download the RentContainer field *)
				Download[reqResourceEntries[[All,1]],RentContainer]
			],
			{True,Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Resources generated for preparation of the manipulations pass the index-matched RentContainer boolean from RentContainer option:",
			protocol=ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->Model[Container,Vessel,"Amber Glass Bottle 4 L"]],
					Transfer[Source->Model[Sample,"Methanol"],Amount->2 Liter,Destination->Model[Container,Vessel,"Amber Glass Bottle 4 L"]]
				},
				RentContainer->{True,False}
			];
			Module[{manips,reqObjIndices,reqResourceEntries},

				(* get the Manipulations field,RequiredObjects field, and RequiredResources field *)
				{manips,requiredObjects,requiredResources}=Download[protocol,{ResolvedManipulations,RequiredObjects,RequiredResources}];

				(* index of the releveant required objects entry for each source *)
				reqObjIndices=reqObjIndices=Map[
					First[FirstPosition[requiredObjects[[All,1]],#,Null,{1},Heads->False]]&,
					Join@@((Join@@#[Source])&/@manips)
				];

				(* get the associated req resource entry *)
				reqResourceEntries=FirstCase[requiredResources,{_,RequiredObjects,#,_}]&/@reqObjIndices;

				(* Download the RentContainer field *)
				Download[reqResourceEntries[[All,1]],RentContainer]
			],
			{True,Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Populate RackPlacements with HPLC rack if an HPLC vial is involved at micro scale:",
			Download[ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Model[Container,Vessel,"HPLC vial (high recovery)"]]}],RackPlacements],
			{{ObjectP[Model[Container,Rack,"id:Z1lqpMGjeejo"]],{"Deck Slot","HPLC Carrier Slot"}}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Test["Resolves ImageSample to the value of the root protocol when it is only one level up:",
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]},ParentProtocol->Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				ImageSample
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Test["Resolves ImageSample to the value of the root protocol when it is only multiple levels up:",
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]},ParentProtocol->Object[Protocol,PAGE,"PAGE Root for SM Test"]],
				ImageSample
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Test["Resolves ImageSample to True if the parent does not have an ImageSample option:",
			Download[
				ExperimentSampleManipulation[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]},ParentProtocol->Object[Maintenance,Clean,"Maintenance Parent for SM Test"]],
				ImageSample
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Macro liquid handling will be used if any tablet transfers are involved:",
			ExperimentSampleManipulation[
				{
					Transfer[Source->Model[Sample,"Aspirin (tablet)"],Amount->4,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->2.5 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]
				}
			][LiquidHandlingScale],
			MacroLiquidHandling,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Test["Tablets work in Transfer, Aliquot, and Consolidation primitives with the source as either a model or an object:",
			protocol=ExperimentSampleManipulation[{
				Aliquot[
					Source->Object[Sample,"Test tablet 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Amounts->{1,2},
					Destinations->{Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				],
				Aliquot[
					Source->Model[Sample,"Aspirin (tablet)"],
					Amounts->{3,4},
					Destinations->{Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				],
				Transfer[Source->Model[Sample,"Aspirin (tablet)"],Amount->5,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test tablet 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],Amount->6,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Consolidation[
					Sources->{Object[Sample,"Test tablet 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],Model[Sample,"Aspirin (tablet)"]},
					Amounts->{7,8},
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If a tablet transfer with model as the source asks for more tablets than are in a single bottle,  don't split it and assume the resource picking consolidation system will handle it:",
			With[{manipulations=
				Download[
					ExperimentSampleManipulation[
						{Transfer[Source->Model[Sample,"Aspirin (tablet)"],Amount->600,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]]}
					],
					ResolvedManipulations]
			},(First/@First/@#[{Amount,Destination,Source}]) &/@manipulations
			],
			{
				{
					600,
					ObjectReferenceP[Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					{_,ObjectReferenceP[Model[Sample,"Aspirin (tablet)"]]}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["When CE vials are incubated, VesselRackPlacements is populated:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Incubate[
					Sample->{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}];
			Download[protocol,VesselRackPlacements],
			{{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],_String}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["When multiple CE Vials are incubated differently, use multiple vessel racks:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Incubate[
					Sample->{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Time->10 Minute,
					Temperature->37 Celsius
				],
				Incubate[
					Sample->{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}];
			{vialPlacements,requiredResources}=Download[protocol,{VesselRackPlacements,RequiredResources}];
			{vialPlacements,Cases[requiredResources,{resource:ObjectP[],VesselRackPlacements,_,2}:>Download[resource,Object]]},
			{
				{
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A1"}
				},
				_?DuplicateFreeQ
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol,vialPlacements,requiredResources}
		],
		Test["When multiple CE Vials are incubated the same, use the same vessel rack:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Incubate[
					Sample->{
						{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
						{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]}
					},
					Time->10 Minute,
					Temperature->37 Celsius
				],
				Incubate[
					Sample->{
						{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
						{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]}
					},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}];
			{vialPlacements,requiredResources}=Download[protocol,{VesselRackPlacements,RequiredResources}];
			{vialPlacements,Cases[requiredResources,{resource:ObjectP[],VesselRackPlacements,_,2}:>Download[resource,Object]]},
			{
				{
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A2"}
				},
				_?SameQ
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol,vialPlacements,requiredResources}
		],
		Test["If CE Vials are used without being incubated, use the Hamilton CE vial rack by populating RackPlacements:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{3,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
					Amount->100 Microliter
				],
				Incubate[
					Sample->{
						{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
						{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]}
					},
					Time->10 Minute,
					Temperature->37 Celsius
				],
				Incubate[
					Sample->{
						{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
						{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]}
					},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}];
			Download[protocol,{VesselRackPlacements,RackPlacements}],
			{
				{
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A2"}
				},
				{{LinkP[Model[Container,Rack]],{_String..}}}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If a sample in a CE Vial is incubated, place it in a SBS CE vial rack:",
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->{
						Object[Sample,"Test chemical in HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						{1,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]},
						{2,Model[Container,Vessel,"id:jLq9jXvxr6OZ"]}
					},
					Time->10 Minute,
					Temperature->37 Celsius
				]
			}];
			Download[protocol,VesselRackPlacements],
			{
				{LinkP[Object[Sample,"Test chemical in HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Model[Container,Rack]],"A1"},
				{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A2"},
				{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack]],"A3"}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If a 8x43mm Glass Reaction Vial is being used in any Incubation use an appropriate rack by populating VesselRackPlacements:",
			protocol=ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Temperature->70 Celsius,
					Time->5 Minute
				]
			}];
			Download[protocol,VesselRackPlacements],
			(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
			{
				{
					LinkP[Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],
					"A1"
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If a 8x43mm Glass Reaction Vial is being used in any Mix use an appropriate rack by populating VesselRackPlacements:",
			protocol=ExperimentSampleManipulation[{
				Mix[
					Sample->Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
					NumberOfMixes->2,
					MixVolume->30 Microliter
				]
			}];
			Download[protocol,VesselRackPlacements],
			(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
			{
				{
					LinkP[Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],
					"A1"
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If a 8x43mm Glass Reaction Vial is being used in any Transfer, use an appropriate rack by populating VesselRackPlacements:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destination->{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destination->{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
					Amount->100 Microliter
				]
			}];
			Download[protocol,VesselRackPlacements],
			(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
			{{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["If multiple 8x43mm Glass Reaction Vials are being used in multiple manipulations, place all in a rack:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destination->{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
					Amount->100 Microliter
				],
				Aliquot[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destinations->{
						{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
						{2,Model[Container,Vessel,"id:4pO6dM5WvJKM"]}
					},
					Amounts->{100 Microliter,100 Microliter}
				],
				Consolidation[
					Sources->{
						{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
						{2,Model[Container,Vessel,"id:4pO6dM5WvJKM"]}
					},
					(* "8x43mm Glass Reaction Vial" *)
					Destination->{3,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
					Amounts->{50 Microliter,50 Microliter}
				]
			}];
			{vesselPlacements,requiredResources}=Download[protocol,{VesselRackPlacements,RequiredResources}];
			{vesselPlacements,Cases[requiredResources,{resource:ObjectP[],VesselRackPlacements,_,2}:>Download[resource,Object]]},
			(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
			{
				{
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"B1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"C1"}
				},
				_?SameQ
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol,vesselPlacements,requiredResources}
		],
		Test["If some 8x43mm Glass Reaction Vials are being incubated (in the same way) but others are not, use two racks:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destination->{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
					Amount->100 Microliter
				],
				Aliquot[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destinations->{
						{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
						{2,Model[Container,Vessel,"id:4pO6dM5WvJKM"]}
					},
					Amounts->{100 Microliter,100 Microliter}
				],
				Consolidation[
					Sources->{
						{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
						{2,Model[Container,Vessel,"id:4pO6dM5WvJKM"]}
					},
					(* "8x43mm Glass Reaction Vial" *)
					Destination->{3,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},
					Amounts->{50 Microliter,50 Microliter}
				],
				Incubate[
					Sample->Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Temperature->70 Celsius,
					Time->5 Minute
				]
			}];
			{vesselPlacements,requiredResources}=Download[protocol,{VesselRackPlacements,RequiredResources}];
			{vesselPlacements,Cases[requiredResources,{resource:ObjectP[],VesselRackPlacements,_,2}:>Download[resource,Object]]},
			(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
			{
				{
					{LinkP[Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"B1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"C1"}
				},
				_?(And[
					!MatchQ[#[[1]],Alternatives@@(#[[2;;]])],
					SameQ@@(#[[2;;]])
				]&)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol,vesselPlacements,requiredResources}
		],
		Test["If some 8x43mm Glass Reaction Vials are being incubated in different ways and others are not at all, use as many unique racks as necessary to make sure they are separately incubated:",
			protocol=ExperimentSampleManipulation[{
				Define[
					Name->"Glass Vial 1",
					Container->Model[Container,Vessel,"id:4pO6dM5WvJKM"]
				],
				Define[
					Name->"Glass Vial 2",
					Container->Model[Container,Vessel,"id:4pO6dM5WvJKM"]
				],
				Define[
					Name->"Glass Vial 3",
					Container->Model[Container,Vessel,"id:4pO6dM5WvJKM"]
				],
				Define[
					Name->"Glass Vial 4",
					Container->Model[Container,Vessel,"id:4pO6dM5WvJKM"]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					(* "8x43mm Glass Reaction Vial" *)
					Destination->"Glass Vial 1",
					Amount->100 Microliter
				],
				Incubate[
					Sample->{
						Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						"Glass Vial 2"
					},
					Temperature->70 Celsius,
					Time->5 Minute
				],
				Incubate[
					Sample->"Glass Vial 3",
					Temperature->70 Celsius,
					Time->5 Minute
				],
				Incubate[
					Sample->"Glass Vial 4",
					Temperature->70 Celsius,
					Time->10 Minute
				]
			}];
			{vesselPlacements,requiredResources}=Download[protocol,{VesselRackPlacements,RequiredResources}];
			{vesselPlacements,Cases[requiredResources,{resource:ObjectP[],VesselRackPlacements,_,2}:>Download[resource,Object]]},
			(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
			{
				{
					{LinkP[Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"B1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"},
					{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"}
				},
				(* First two should be in the same rack, the 2nd and 3rd should be in their own unique racks *)
				_?(And[
					MatchQ@@(#[[{1,2}]]),
					!MatchQ[#[[1]],Alternatives@@(#[[3;;]])],
					!SameQ@@(#[[3;;]])
				]&)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol,vesselPlacements,requiredResources}
		],
		Test["Supports use of Avant vial and vial rack in the same way the 8x43mm Glass Reaction Vials are handled:",
			protocol=ExperimentSampleManipulation[{
				Define[
					Name->"My Vial",
					Container->Model[Container,Vessel,"22x45mm screw top vial 10mL"]
				],
				Define[
					Name->"My Other Vial",
					Container->Model[Container,Vessel,"8x43mm Glass Reaction Vial"]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->"My Vial",
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->"My Vial",
					Amount->100 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->"My Other Vial",
					Amount->100 Microliter
				]
			}];
			Download[protocol,VesselRackPlacements],
			{
				(* {"22x45mm screw top vial 10mL", "Avant Autosampler 10 mL Vial Rack", position} *)
				{LinkP[Model[Container,Vessel,"id:eGakldJ6p35e"]],LinkP[Model[Container,Rack,"id:dORYzZJDL69w"]],"A1"},
				(* {"8x43mm Glass Reaction Vial", "8x43mm glass vial heater-shaker block", position} *)
				{LinkP[Model[Container,Vessel]],LinkP[Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],"A1"}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Test["Returns $Failed if the options requested in a Mix primitive are invalid:",
			ExperimentSampleManipulation[{Mix[Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],MixType->Vortex,MixRate->50 RPM]}],
			$Failed,
			Messages:>{Error::VortexNoInstrumentForRate,Error::MixTypeIncorrectOptions,Error::InvalidOption}
		],
		Test["Returns $Failed if the options requested in a Incubate primitive are invalid (in this case MacroLiquidHandling cannot handle -100 degree incubation):",
			ExperimentSampleManipulation[{
				Incubate[
					Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Time->30 Minute,
					Temperature->-100 Celsius]
			},
				LiquidHandlingScale->MacroLiquidHandling
			],
			$Failed,
			Messages:>{Error::Pattern,Error::InvalidOption}
		],
		Test["Does not attempt to record the TareWeight for immobile containers:",
			Download[
				ExperimentSampleManipulation[{
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->50 Microliter,Destination->Object[Container,Vessel,"Sample Manipulation Immobile Container"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->50 Microliter,Destination->Object[Container,Vessel,"Sample Manipulation Non-immobile Container"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->50 Microliter,Destination->Model[Container,Vessel,"Sample Manipulation Immobile Container Model"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->50 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]
				}],
				TaredContainers
			],
			{ObjectP[],ObjectP[]},
			Stubs:>{$DeveloperSearch=True},
			SetUp:>(
				$CreatedObjects={};
				Module[{modelVesselID},
					modelVesselID=CreateID[Model[Container,Vessel]];
					Upload[{
						<|
							Object->modelVesselID,
							Name->"Sample Manipulation Immobile Container Model",
							Immobile->True
						|>,
						<|
							Type->Object[Container,Vessel],
							Model->Link[modelVesselID,Objects],
							DeveloperObject->True,
							Name->"Sample Manipulation Immobile Container"
						|>,
						<|
							Type->Object[Container,Vessel],
							Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
							DeveloperObject->True,
							Name->"Sample Manipulation Non-immobile Container"
						|>
					}];
				]
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				EraseObject[
					PickList[
						{
							Object[Container,Vessel,"Sample Manipulation Immobile Container"],
							Object[Container,Vessel,"Sample Manipulation Non-immobile Container"]
						},
						DatabaseMemberQ[{
							Object[Container,Vessel,"Sample Manipulation Immobile Container"],
							Object[Container,Vessel,"Sample Manipulation Non-immobile Container"]
						}],
						True
					],
					Force->True,
					Verbose->False
				]
			)
		],
		Test["Does not record the tare weights for any containers if the protocol is fulfilling a resource request:",
			Download[
				ExperimentSampleManipulation[
					{Transfer[Source->Model[Sample,"Methanol"],Amount->50 Microliter,Destination->Model[Container,Vessel,"2mL Tube"]]},
					PreparedResources->{myResource}
				],
				TaredContainers
			],
			{},
			SetUp:>(
				$CreatedObjects={};
				myResource=Upload[<|Type->Object[Resource,Sample]|>]
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{myResource}
		],
		Example[{Options,OptimizePrimitives,"When OptimizePrimitives is True (its default value), liquid handling primitives are merged and modified to be most efficient for the instrument executing the transfers:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"}
						],
						Aliquot[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amounts->{20 Microliter,40 Microliter},
							Destinations->{{"My Plate","A2"},{"My Plate","A3"}}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","A4"}
						]
					},
					OptimizePrimitives->True
				];
				myOptimizedTransfer=Download[myProtocol,ResolvedManipulations][[2]];

				{
					myOptimizedTransfer[Source],
					myOptimizedTransfer[Destination],
					myOptimizedTransfer[Amount]
				}
			),
			{
				Download[
					{
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
					},
					Object
				],
				{
					{{"My Plate","A1"}},
					{{"My Plate","A2"}},
					{{"My Plate","A3"}},
					{{"My Plate","A4"}}
				},
				{
					{20 Microliter},
					{20 Microliter},
					{40 Microliter},
					{10 Microliter}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myOptimizedTransfer}
		],
		Example[{Options,OptimizePrimitives,"Primitive optimization may re-order primitives to be most efficient for the liquid handler when there is no order-dependence to the transfers:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","A2"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","A3"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","B1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","C1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","D1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","E1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","F1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","G1"}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","H1"}
						]
					},
					OptimizePrimitives->True
				];
				myOptimizedTransfers=Download[myProtocol,ResolvedManipulations][[2;;]];

				(#[Destination])&/@myOptimizedTransfers
			),
			{
				{
					{{"My Plate","A1"}},
					{{"My Plate","B1"}},
					{{"My Plate","C1"}},
					{{"My Plate","D1"}},
					{{"My Plate","E1"}},
					{{"My Plate","F1"}},
					{{"My Plate","G1"}},
					{{"My Plate","H1"}}
				},
				{
					{{"My Plate","A2"}},
					{{"My Plate","A3"}}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myOptimizedTransfers}
		],
		Example[{Options,OptimizePrimitives,"When OptimizePrimitives is False, liquid handling primitives not merged and modified, resulting in a protocol that may take significantly longer compared to an optimized protocol:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->20 Microliter,
							Destination->{"My Plate","A1"}
						],
						Aliquot[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amounts->{20 Microliter,40 Microliter},
							Destinations->{{"My Plate","A2"},{"My Plate","A3"}}
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->10 Microliter,
							Destination->{"My Plate","A4"}
						]
					},
					OptimizePrimitives->False
				];
				myNonOptimizedTransfers=Download[myProtocol,ResolvedManipulations][[2;;]];

				Map[
					{#[Source],#[Destination],#[Amount]}&,
					myNonOptimizedTransfers
				]
			),
			{
				{
					Download[{{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}},Object],
					{{{"My Plate","A1"}}},
					{{20 Microliter}}
				},
				{
					Download[
						{
							{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
						},
						Object
					],
					{
						{{"My Plate","A2"}},
						{{"My Plate","A3"}}
					},
					{
						{20 Microliter},
						{40 Microliter}
					}
				},
				{
					Download[{{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}},Object],
					{{{"My Plate","A4"}}},
					{{10 Microliter}}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myNonOptimizedTransfers}
		],
		Example[{Options,OptimizePrimitives,"When possible, primitive(s) that make up a \"plate stamping\" action are performed simultaneously using a MultiProbeHead device:"},
			(
				myProtocol=ExperimentSampleManipulation[
					Join[
						{
							Define[
								Name->"My Plate",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Define[
								Name->"My Plate 2",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->({"My Plate",#}&/@Flatten[AllWells[]]),
								Amount->970 Microliter
							],
							Transfer[
								Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Destination->{"My Plate","A1"},
								Amount->30 Microliter
							],
							Transfer[
								Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Destination->{"My Plate","A2"},
								Amount->30 Microliter
							]
						},
						Map[
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->{"My Plate 2",#},
								Amount->970 Microliter
							]&,
							Flatten[AllWells[]][[;;-2]]
						],
						{
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->{"My Plate 2",Flatten[AllWells[]][[-1]]},
								Amount->970 Microliter
							]
						}
					]
				];

				Download[myProtocol,ResolvedManipulations]
			),
			{
				_Define,
				_Define,
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&),
				_Transfer?(MatchQ[#[DeviceChannel],{SingleProbe1,SingleProbe2}]&),
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol},
			TimeConstraint->500
		],
		Test["Does not use a MultiProbeHead device when a magnetic position is involved as it's not possible to transfer from this position:",
			(
				myProtocol=ExperimentSampleManipulation[
					Join[
						{
							Define[
								Name->"My Plate",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Define[
								Name->"My Plate 2",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Transfer[
								Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Destination->{"My Plate","A1"},
								Amount->30 Microliter
							],
							MoveToMagnet[
								Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID]
							],
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->({"My Plate 2",#} &/@Flatten[AllWells[]]),
								Amount->970 Microliter
							]
						}
					]
				];
				Download[myProtocol,ResolvedManipulations]
			),
			{
				_Define,
				_Define,
				_Transfer,
				_MoveToMagnet,
				_Transfer?(MatchQ[#[DeviceChannel],{SingleProbe1,SingleProbe2,SingleProbe3,SingleProbe4,SingleProbe5,SingleProbe6,SingleProbe7,SingleProbe8}]&)..
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol},
			TimeConstraint->500
		],
		Example[{Options,OptimizePrimitives,"Mix primitive(s) that make up a \"plate stamping\" action are also performed simultaneously using a MultiProbeHead device:"},
			(
				myProtocol=ExperimentSampleManipulation[
					Join[
						{
							Define[
								Name->"My Plate",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Define[
								Name->"My Plate 2",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->({"My Plate",#}&/@Flatten[AllWells[]]),
								Amount->970 Microliter
							],
							Transfer[
								Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Destination->{"My Plate","A1"},
								Amount->30 Microliter
							],
							Transfer[
								Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Destination->{"My Plate","A2"},
								Amount->30 Microliter
							],
							Mix[
								Sample->{"My Plate","A1"},
								NumberOfMixes->3,
								MixVolume->100 Microliter
							],
							Mix[
								Sample->{"My Plate","A2"},
								NumberOfMixes->3,
								MixVolume->100 Microliter
							]
						},
						Map[
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->{"My Plate 2",#},
								Amount->970 Microliter
							]&,
							Flatten[AllWells[]][[;;-2]]
						],
						{
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->{"My Plate 2",Flatten[AllWells[]][[-1]]},
								Amount->970 Microliter
							]
						},
						Map[
							Mix[
								Sample->{"My Plate 2",#},
								NumberOfMixes->3,
								MixVolume->970 Microliter
							]&,
							Flatten[AllWells[]]
						]
					]
				];

				Download[myProtocol,ResolvedManipulations]
			),
			{
				_Define,
				_Define,
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&),
				_Transfer?(MatchQ[#[DeviceChannel],{SingleProbe1,SingleProbe2}]&),
				_Mix?(MatchQ[#[DeviceChannel],{SingleProbe1,SingleProbe2}]&),
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&),
				_Mix?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol},
			TimeConstraint->500
		],
		Example[{Options,OptimizePrimitives,"Plate-stamping a 384-well plate will be done using a MultiProbeHead if the source and destination wells are in a MultiProbeHead-compatible pattern (ie: every 4th row and column):"},
			(
				validWellSets=Transpose[PartitionRemainder[Flatten@AllWells[NumberOfWells->384],4]];

				myProtocol=ExperimentSampleManipulation[
					Join[
						{Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"id:pZx9jo83G0VP"]
						]},
						Map[
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->{"My Plate",#},
								Amount->5 Microliter
							]&,
							validWellSets[[1]]
						],
						MapThread[
							Transfer[
								Source->{"My Plate",#1},
								Destination->{"My Plate",#2},
								Amount->5 Microliter
							]&,
							{validWellSets[[1]],validWellSets[[2]]}
						]
					]
				];

				Download[myProtocol,ResolvedManipulations]
			),
			{
				_Define,
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&),
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{validWellSets,myProtocol},
			TimeConstraint->500
		],
		Example[{Options,OptimizePrimitives,"If all samples in a plate are being transferred, the transfer can be done using a MultiProbeHead:"},
			(
				myProtocol=ExperimentSampleManipulation[
					Join[
						{
							Define[
								Name->"My Plate 1",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Define[
								Name->"My Plate 2",
								Container->Model[Container,Plate,"id:pZx9jo83G0VP"]
							],
							Transfer[
								Source->(Object[Sample,#]&/@Table["MultiProbeHead test sample "<>ToString[x],{x,Range[96]}]),
								Destination->({"My Plate 1",#} &/@Flatten[AllWells[]]),
								Amount->500 Microliter
							]
						},
						MapThread[
							Transfer[
								Source->{"My Plate 1",#1},
								Destination->{"My Plate 2",#2},
								Amount->5 Microliter
							]&,
							{
								Flatten[AllWells[]],
								Transpose[PartitionRemainder[Flatten@AllWells[NumberOfWells->384],4]][[2]]
							}
						]
					]
				];

				Download[myProtocol,ResolvedManipulations]
			),
			{
				_Define,
				_Define,
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&),
				_Transfer?(MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]]&)
			},
			SetUp:>(
				$CreatedObjects={};

				Module[{plate},

					plate=Upload[
						Association[
							Type->Object[Container,Plate],
							Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
							DeveloperObject->True
						]
					];

					If[!DatabaseMemberQ[Object[Sample,"MultiProbeHead test sample 1"]],
						UploadSample[
							Table[Model[Sample,"Milli-Q water"],96],
							Map[{#,plate}&,Flatten[AllWells[]]],
							InitialAmount->1.5 Milliliter,
							Name->Table["MultiProbeHead test sample "<>ToString[x],{x,Range[96]}]
						],
						Object[Sample,#]&/@Table["MultiProbeHead test sample "<>ToString[x],{x,Range[96]}]
					];
				]
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			TimeConstraint->1000
		],
		Example[{Options,OptimizePrimitives,"AspirationPosition resolves to Bottom when MultiProbeHead is being used:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->({"My Plate",#}&/@Flatten[AllWells[]]),
							Amount->970 Microliter
						]
					}
				];

				Download[myProtocol,ResolvedManipulations]
			),
			{
				_Define,
				_Transfer?(And[
					MatchQ[#[DeviceChannel],Table[MultiProbeHead,96]],
					MatchQ[#[AspirationPosition],Table[Bottom,96]]
				]&)
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol},
			TimeConstraint->500
		],
		Example[{Additional,"Multi-probe Transfer Syntax","Transfer primitive keys are listable:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->{
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
							},
							Amount->{20 Microliter,20 Microliter,40 Microliter,10 Microliter},
							Destination->{{"My Plate","A1"},{"My Plate","A2"},{"My Plate","A3"},{"My Plate","A4"}}
						]
					}
				];
				myTransfer=Download[myProtocol,ResolvedManipulations][[2]];

				{
					myTransfer[Source],
					myTransfer[Destination],
					myTransfer[Amount]
				}
			),
			{
				Download[
					{
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
					},
					Object
				],
				{
					{{"My Plate","A1"}},
					{{"My Plate","A2"}},
					{{"My Plate","A3"}},
					{{"My Plate","A4"}}
				},
				{
					{20 Microliter},
					{20 Microliter},
					{40 Microliter},
					{10 Microliter}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myTransfer}
		],
		Example[{Additional,"Multi-probe Transfer Syntax","Source, Destination, and Amount key values will automatically expand in length:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->{20 Microliter,20 Microliter,40 Microliter,10 Microliter},
							Destination->{{"My Plate","A1"},{"My Plate","A2"},{"My Plate","A3"},{"My Plate","A4"}}
						]
					}
				];
				myTransfer=Download[myProtocol,ResolvedManipulations][[2]];

				{
					myTransfer[Source],
					myTransfer[Destination],
					myTransfer[Amount]
				}
			),
			{
				Download[
					{
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
					},
					Object
				],
				{
					{{"My Plate","A1"}},
					{{"My Plate","A2"}},
					{{"My Plate","A3"}},
					{{"My Plate","A4"}}
				},
				{
					{20 Microliter},
					{20 Microliter},
					{40 Microliter},
					{10 Microliter}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myTransfer}
		],
		Example[{Additional,"Multi-probe Transfer Syntax","Large-volume transfers are split into multiple pipetting steps:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->1.5 Milliliter,
							Destination->{"My Plate","A1"}
						],
						Transfer[
							Source->{
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
							},
							Amount->{1.5 Milliliter,200 Microliter,1.5 Milliliter},
							Destination->{
								{"My Plate","A2"},
								{"My Plate","A3"},
								{"My Plate","A4"}
							}
						]
					}
				];
				myTransfer=Download[myProtocol,ResolvedManipulations][[2]];

				{
					myTransfer[Source],
					myTransfer[Destination],
					myTransfer[Amount],
					myTransfer[TipType]
				}
			),
			{
				Download[
					{
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						{Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]}
					},
					Object
				],
				{
					{{"My Plate","A1"}},
					{{"My Plate","A2"}},
					{{"My Plate","A3"}},
					{{"My Plate","A4"}},
					{{"My Plate","A1"}},
					{{"My Plate","A2"}},
					{{"My Plate","A4"}}
				},
				{
					{_?((#==970 Microliter)&)},
					{_?((#==970 Microliter)&)},
					{_?((#==200 Microliter)&)},
					{_?((#==970 Microliter)&)},
					{_?((#==530 Microliter)&)},
					{_?((#==530 Microliter)&)},
					{_?((#==530 Microliter)&)}
				},
				{
					ObjectP[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]],
					ObjectP[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]],
					ObjectP[Model[Item,Tips,"300 uL Hamilton tips, non-sterile"]],
					ObjectP[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]],
					ObjectP[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]],
					ObjectP[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]],
					ObjectP[Model[Item,Tips,"1000 uL Hamilton tips, non-sterile"]]
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myTransfer}
		],
		Example[{Additional,"ReadPlate Primitive","Use a ReadPlate primitive to collect data from a plate-reader:"},
			(
				myProtocol=ExperimentSampleManipulation[{
					Define[
						Name->"My Container",
						Container->Model[Container,Plate,"96-well Black Wall Plate"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A1"},
						Volume->200 Microliter
					],
					ReadPlate[
						Sample->{"My Container","A1"},
						Type->FluorescenceKinetics
					]
				}]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"ReadPlate Primitive","Specify the sample you'd like to inject into every sample of a ReadPlate primitive:"},
			(
				myProtocol=ExperimentSampleManipulation[{
					Define[
						Name->"My Container",
						Container->Model[Container,Plate,"96-well Black Wall Plate"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A1"},
						Volume->200 Microliter
					],
					ReadPlate[
						Sample->{"My Container","A1"},
						Type->FluorescenceKinetics,
						PrimaryInjectionSample->Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						PrimaryInjectionVolume->4 Microliter,
						PrimaryInjectionTime->10 Minute
					]
				}]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"ReadPlate Primitive","The injected sample specified in a ReadPlate primitive can be a model:"},
			(
				myProtocol=ExperimentSampleManipulation[{
					Define[
						Name->"My Container",
						Container->Model[Container,Plate,"96-well Black Wall Plate"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A1"},
						Volume->200 Microliter
					],
					ReadPlate[
						Sample->{"My Container","A1"},
						Type->FluorescenceKinetics,
						PrimaryInjectionSample->Model[Sample,"id:8qZ1VWNmdLBD"],
						PrimaryInjectionVolume->4 Microliter,
						PrimaryInjectionTime->10 Minute
					]
				}]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"ReadPlate Primitive","Use ExperimentAbsorbanceKinetics options in a ReadPlate primitive:"},
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Container",
							Container->Model[Container,Plate,"96-well Black Wall Plate"]
						],
						Transfer[
							Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Destination->{"My Container","A1"},
							Volume->200 Microliter
						],
						Transfer[
							Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Destination->{"My Container","A2"},
							Volume->200 Microliter
						],
						ReadPlate[
							Sample->{"My Container","A1"},
							Type->AbsorbanceKinetics,
							Wavelength->400 Nanometer;;600 Nanometer,
							RunTime->5 Minute,
							Blank->{"My Container","A2"}
						]
					}
				]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"ReadPlate Primitive","Multiple volumes can be specified for sample injections:"},
			(
				myProtocol=ExperimentSampleManipulation[{
					Define[
						Name->"My Container",
						Container->Model[Container,Plate,"96-well Black Wall Plate"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A1"},
						Volume->100 Microliter
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A2"},
						Volume->100 Microliter
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A3"},
						Volume->100 Microliter
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A4"},
						Volume->100 Microliter
					],
					ReadPlate[
						Sample->{
							{"My Container","A1"},
							{"My Container","A2"},
							{"My Container","A3"},
							{"My Container","A4"}
						},
						Type->FluorescenceKinetics,
						PrimaryInjectionSample->{
							Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Null,
							Null,
							Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]
						},
						PrimaryInjectionVolume->{4 Microliter,Null,Null,4 Microliter},
						PrimaryInjectionTime->10 Minute
					]
				}]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Additional,"ReadPlate Primitive","The injected sample specified in a ReadPlate primitive can be a model:"},
			(
				myProtocol=ExperimentSampleManipulation[{
					Define[
						Name->"My Container",
						Container->Model[Container,Plate,"96-well Black Wall Plate"]
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->{"My Container","A1"},
						Volume->200 Microliter
					],
					ReadPlate[
						Sample->{{"My Container","A1"}},
						Type->FluorescenceKinetics,
						PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						PrimaryInjectionVolume->{2 Microliter},
						PrimaryInjectionTime->10 Minute,
						SecondaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
						SecondaryInjectionVolume->{2 Microliter},
						SecondaryInjectionTime->20 Minute
					]
				}]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol}
		],
		Example[{Messages,"TooManyInjectionSamples","A maximum of two unique injection samples can be used across all ReadPlate primitives:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"My Container",
					Container->Model[Container,Plate,"96-well Black Wall Plate"]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{"My Container","A1"},
					Volume->200 Microliter
				],
				ReadPlate[
					Sample->{{"My Container","A1"}},
					Type->FluorescenceKinetics,
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					PrimaryInjectionVolume->{2 Microliter},
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->{Object[Sample,"Injection test sample 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					SecondaryInjectionVolume->{2 Microliter},
					SecondaryInjectionTime->20 Minute
				],
				ReadPlate[
					Sample->{{"My Container","A1"}},
					Type->FluorescenceKinetics,
					PrimaryInjectionSample->{Object[Sample,"Injection test sample 3 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					PrimaryInjectionVolume->{2 Microliter},
					PrimaryInjectionTime->10 Minute
				]
			}],
			$Failed,
			Messages:>{Error::TooManyInjectionSamples,Error::InvalidInput}
		],
		Example[{Messages,"TooManyReadPlateContainers","A single ReadPlate primitive must have samples and blanks in the same container:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"My Container",
					Container->Model[Container,Plate,"96-well Black Wall Plate"]
				],
				Define[
					Name->"My Container 2",
					Container->Model[Container,Plate,"96-well Black Wall Plate"]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{"My Container","A1"},
					Volume->200 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{"My Container","A2"},
					Volume->200 Microliter
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{"My Container","A3"},
					Volume->200 Microliter
				],
				ReadPlate[
					Sample->{{"My Container","A1"},{"My Container","A2"}},
					Type->AbsorbanceKinetics,
					Wavelength->400 Nanometer;;600 Nanometer,
					RunTime->5 Minute,
					Blank->{"My Container 2","A3"}
				]
			}],
			$Failed,
			Messages:>{Error::TooManyReadPlateContainers,Error::InvalidInput}
		],
		Example[{Messages,"IncompatibleReadPlatePlateModels","Multiple ReadPlate primitives may not use both 96-well and 384-well plates in a single sample manipulation:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"testPlate",
					Container->Model[Container,Plate,"384-well qPCR Optical Reaction Plate"]
				],

				Aliquot[
					Source->Model[Sample,"id:8qZ1VWNmdLBD"],
					Destinations->{{"testPlate","K2"},{"testPlate","I2"},{"testPlate","J2"},{"testPlate","D2"}},
					Amounts->Table[15 Microliter,4]
				],

				ReadPlate[
					Sample->{{"testPlate","K2"},{"testPlate","I2"},{"testPlate","J2"},{"testPlate","D2"}},
					Type->AbsorbanceKinetics,
					Wavelength->400 Nanometer;;600 Nanometer,
					RunTime->10 Minute
				],

				Define[
					Name->"testPlate2",
					Container->Model[Container,Plate,"id:6V0npvK611zG"]
				],

				Aliquot[
					Source->Model[Sample,"id:8qZ1VWNmdLBD"],
					Destinations->{{"testPlate2","A2"},{"testPlate2","B2"},{"testPlate2","C2"},{"testPlate2","D2"}},
					Amounts->Table[15 Microliter,4]
				],

				ReadPlate[
					Sample->{{"testPlate2","A2"},{"testPlate2","B2"},{"testPlate2","C2"},{"testPlate2","D2"}},
					Type->AbsorbanceKinetics,
					Wavelength->400 Nanometer;;600 Nanometer,
					RunTime->10 Minute
				]
			}],
			$Failed,
			Messages:>{Error::IncompatibleReadPlatePlateModels,Error::InvalidInput}
		],
		(* Make sure if they're both 384 well plates this is all ok *)
		Test["Multiple ReadPlate primitives that all use 384-well plates in a single sample manipulation are ok:",
			ExperimentSampleManipulation[{
				Define[
					Name->"testPlate",
					Container->Model[Container,Plate,"384-well qPCR Optical Reaction Plate"]
				],
				Aliquot[
					Source->Model[Sample,"id:8qZ1VWNmdLBD"],
					Destinations->{{"testPlate","K2"},{"testPlate","I2"},{"testPlate","J2"},{"testPlate","D2"}},
					Amounts->Table[15 Microliter,4]
				],
				ReadPlate[
					Sample->{{"testPlate","K2"},{"testPlate","I2"},{"testPlate","J2"},{"testPlate","D2"}},
					Type->FluorescenceKinetics,
					EmissionWavelength->511 Nanometer,
					ExcitationWavelength->487 Nanometer
				],
				Define[
					Name->"testPlate2",
					Container->Model[Container,Plate,"384-well qPCR Optical Reaction Plate"]
				],
				Aliquot[
					Source->Model[Sample,"id:8qZ1VWNmdLBD"],
					Destinations->{{"testPlate2","A2"},{"testPlate2","B2"},{"testPlate2","C2"},{"testPlate2","D2"}},
					Amounts->Table[15 Microliter,4]
				],
				ReadPlate[
					Sample->{{"testPlate2","A2"},{"testPlate2","B2"},{"testPlate2","C2"},{"testPlate2","D2"}},
					Type->FluorescenceKinetics,
					EmissionWavelength->511 Nanometer,
					ExcitationWavelength->487 Nanometer
				]
			}],
			ObjectP[Object[Protocol,SampleManipulation]]
		],

		Test["Lidded plates are only read on the CLARIOstar:",
			protocol=ExperimentSampleManipulation[{
				Define[
					Name->"readPlate",
					Container->Model[Container,Plate,"96-well Black Wall Greiner Plate"]
				],
				Define[
					Name->"sample1",
					Sample->{"readPlate","A1"}
				],
				Define[
					Name->"sample2",
					Sample->{"readPlate","A2"}
				],
				Define[
					Name->"sample3",
					Sample->{"readPlate","A3"}
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample1",
					Volume->100 Microliter
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample2",
					Volume->100 Microliter
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample3",
					Volume->100 Microliter
				],
				Cover[
					Sample->"readPlate"
				],
				ReadPlate[
					Sample->{"sample1","sample2","sample3"},
					Type->FluorescenceKinetics,
					EmissionWavelength->520 Nanometer,
					ExcitationWavelength->485 Nanometer,
					Gain->65 Percent,
					AdjustmentSample->"sample3",
					Temperature->37 Celsius,
					RunTime->30 Minute,
					ReadLocation->Bottom
				]
			}];
			Download[protocol,PlateReader],
			ObjectP[Model[Instrument,PlateReader,"id:E8zoYvNkmwKw"]],
			Variables:>{protocol}
		],

		Test["Lidded plates are only read on the CLARIOstar even if there are unlidded ReadPlate primitives:",
			protocol=ExperimentSampleManipulation[{
				Define[
					Name->"readPlate",
					Container->Model[Container,Plate,"96-well Black Wall Greiner Plate"]
				],
				Define[
					Name->"sample1",
					Sample->{"readPlate","A1"}
				],
				Define[
					Name->"sample2",
					Sample->{"readPlate","A2"}
				],
				Define[
					Name->"sample3",
					Sample->{"readPlate","A3"}
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample1",
					Volume->100 Microliter
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample2",
					Volume->100 Microliter
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"sample3",
					Volume->100 Microliter
				],
				ReadPlate[
					Sample->{"sample1","sample2","sample3"},
					Type->FluorescenceKinetics,
					EmissionWavelength->520 Nanometer,
					ExcitationWavelength->485 Nanometer,
					Gain->65 Percent,
					AdjustmentSample->"sample3",
					Temperature->37 Celsius,
					RunTime->30 Minute,
					ReadLocation->Bottom
				],
				Cover[
					Sample->"readPlate"
				],
				ReadPlate[
					Sample->{"sample1","sample2","sample3"},
					Type->FluorescenceKinetics,
					EmissionWavelength->520 Nanometer,
					ExcitationWavelength->485 Nanometer,
					Gain->65 Percent,
					AdjustmentSample->"sample3",
					Temperature->37 Celsius,
					RunTime->30 Minute,
					ReadLocation->Bottom
				]
			}];
			Download[protocol,PlateReader],
			ObjectP[Model[Instrument,PlateReader,"id:E8zoYvNkmwKw"]],
			Variables:>{protocol}
		],

		Test["An error is shown if a lidded plate read is specified along with a liquid handler without an integrated CLARIOstar:",
			ExperimentSampleManipulation[
				{
					Define[
						Name->"readPlate",
						Container->Model[Container,Plate,"96-well Black Wall Greiner Plate"]
					],
					Define[
						Name->"sample1",
						Sample->{"readPlate","A1"}
					],
					Define[
						Name->"sample2",
						Sample->{"readPlate","A2"}
					],
					Define[
						Name->"sample3",
						Sample->{"readPlate","A3"}
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"sample1",
						Volume->100 Microliter
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"sample2",
						Volume->100 Microliter
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Destination->"sample3",
						Volume->100 Microliter
					],
					Cover[
						Sample->"readPlate"
					],
					ReadPlate[
						Sample->{"sample1","sample2","sample3"},
						Type->FluorescenceKinetics,
						EmissionWavelength->520 Nanometer,
						ExcitationWavelength->485 Nanometer,
						Gain->65 Percent,
						AdjustmentSample->"sample3",
						Temperature->37 Celsius,
						RunTime->30 Minute,
						ReadLocation->Bottom
					]
				},
				LiquidHandler->Object[Instrument,LiquidHandler,"Jay Z"]
			],
			$Failed,
			Messages:>{Error::InvalidLiquidHandler,Error::InvalidOption}
		],

		Example[{Messages,"InvalidReadPlateSample","A ReadPlate primitive's Sample key specifies a sample, model, or container and well position:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"My Container",
					Container->Model[Container,Plate,"96-well Black Wall Plate"]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
					Destination->{"My Container","A1"},
					Volume->200 Microliter
				],
				ReadPlate[
					Sample->"My Container",
					Type->AbsorbanceKinetics,
					Wavelength->400 Nanometer;;600 Nanometer,
					RunTime->5 Minute
				]
			}],
			$Failed,
			Messages:>{Error::InvalidReadPlateSample,Error::InvalidInput}
		],
		Example[{Messages,"EmptyWells","A ReadPlate primitive's has to specify a sample in a plate and not an empty well:"},
			ExperimentSampleManipulation[{
				Define[
					Name->"plate",
					Container->Model[Container,Plate,"384-well Black Flat Bottom Plate"]
				],
				Aliquot[
					Source->Model[Sample,"Milli-Q water"],
					Destinations->({"plate",#}&/@{"A1","A2","A3"}),
					Amounts->50 Microliter
				],
				ReadPlate[
					Sample->({"plate",#}&/@{"A1","A2","A3","A4","A5"}),
					Type->FluorescenceKinetics,
					RunTime->2 Minute
				]
			},LiquidHandlingScale->MicroLiquidHandling],
			$Failed,
			Messages:>{Error::EmptyWells,Error::InvalidInput}
		],
		Example[{Additional,"Cover Primitive","Cover a sample after transferring into it:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->200 Microliter,
						Destination->{"My Plate","A1"}
					],
					Cover[Sample->"My Plate"]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Cover Primitive","Cover a sample with a specific lid type:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->200 Microliter,
						Destination->{"My Plate","A1"}
					],
					Cover[
						Sample->"My Plate",
						Cover->Model[Item,Lid,"Universal Black Lid"]
					]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Additional,"Cover Primitive","Cover all samples to start a protocol and uncover them to transfer:"},
			ExperimentSampleManipulation[
				{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Cover[Sample->"My Plate"],
					Uncover[Sample->"My Plate"],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->200 Microliter,
						Destination->{"My Plate","A1"}
					],
					Cover[Sample->"My Plate"]
				}
			],
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Test["Primitives cannot be merged if a Source of one primitive is a Destination in the primitive before it:",
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"My Plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Transfer[
							Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
							Amount->200 Microliter,
							Destination->{"My Plate","A1"}
						],
						Transfer[
							Source->{
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
								Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
							},
							Amount->{200 Microliter,200 Microliter,200 Microliter},
							Destination->{
								{"My Plate","A2"},
								{"My Plate","A3"},
								{"My Plate","A4"}
							}
						],
						Transfer[
							Source->{"My Plate","A2"},
							Amount->200 Microliter,
							Destination->{"My Plate","A5"}
						]
					}
				];
				myTransfers=Download[myProtocol,ResolvedManipulations][[2;;]];

				{#[Source],#[Destination]}&/@myTransfers
			),
			{
				{
					{
						{ObjectP[Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
						{ObjectP[Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
						{ObjectP[Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]},
						{ObjectP[Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID]]}
					},
					{
						{{"My Plate","A1"}},
						{{"My Plate","A2"}},
						{{"My Plate","A3"}},
						{{"My Plate","A4"}}
					}
				},
				{
					{
						{{"My Plate","A2"}}
					},
					{
						{{"My Plate","A5"}}
					}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myTransfers}
		],
		Test["When primitives are split or Aliquot/Consolidation primitives are converted to Transfers, models are appropriately tagged:",
			(
				myProtocol=ExperimentSampleManipulation[
					{
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Amount->1.5 Milliliter,
							Destination->Model[Container,Vessel,"2mL Tube"]
						],
						Aliquot[
							Source->Model[Sample,"Milli-Q water"],
							Amounts->{1.5 Milliliter,200 Microliter},
							Destinations->{
								Model[Container,Vessel,"2mL Tube"],
								Model[Container,Vessel,"2mL Tube"]
							}
						],
						Consolidation[
							Sources->{
								Model[Sample,"Milli-Q water"],
								Model[Sample,"Dimethylformamide, Reagent Grade"]
							},
							Amounts->{1.1 Milliliter,200 Microliter},
							Destination->Model[Container,Vessel,"2mL Tube"]
						]
					}
				];
				myTransfer=Download[myProtocol,ResolvedManipulations][[1]];

				{myTransfer[Destination],myTransfer[Amount]}
			),
			{
				_?(And[
					(* First transfer is split into 2 pipettings that should use the same destination *)
					MatchQ[#[[1]],#[[2]]],
					!MatchQ[#[[1]],Alternatives@@(#[[3;;]])],
					!MatchQ[#[[2]],Alternatives@@(#[[3;;]])],

					(* First source of Aliquot is split into 2 pipettings that should use the same destination *)
					MatchQ[#[[3]],#[[4]]],
					!MatchQ[#[[3]],Alternatives@@(#[[5;;]])],
					!MatchQ[#[[4]],Alternatives@@(#[[5;;]])],

					(* Second source of Aliquot should be unique *)
					!MatchQ[#[[5]],Alternatives@@(#[[6;;]])],

					(* Consolidation should all use the same destination *)
					SameQ[#[[6]],#[[7]],#[[8]]]
				]&),
				{
					{_?((#==970 Microliter)&)},
					{_?((#==530 Microliter)&)},
					{_?((#==970 Microliter)&)},
					{_?((#==530 Microliter)&)},
					{_?((#==200 Microliter)&)},
					{_?((#==970 Microliter)&)},
					{_?((#==130 Microliter)&)},
					{_?((#==200 Microliter)&)}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{myProtocol,myTransfer}
		],
		Test["Allows transfers of substances requiring a fume hood provided they are not into open containers:",
			ExperimentSampleManipulation[{
				Define[
					Sample->Model[Sample,"Isoprene"],
					Name->"isoprene"
				],
				Transfer[
					Source->"isoprene",
					Amount->1 Milliliter,
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			}],
			ObjectP[Object[Protocol]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Test["Recognizes if substances requiring a fume hood are set to be transferred into open containers when given models or objects:",
			{
				ExperimentSampleManipulation[{
					Define[
						Container->Model[Container,Vessel,"50mL Pyrex Beaker"],
						Name->"container"
					],
					Transfer[
						Source->Model[Sample,"Isoprene"],
						Amount->1 Milliliter,
						Destination->"container"
					]
				}],
				ExperimentSampleManipulation[{
					Transfer[
						Source->Object[Sample,"Ventilated test sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->1 Milliliter,
						Destination->Model[Container,Vessel,"50mL Pyrex Beaker"]
					]
				}]
			},
			{$Failed,$Failed},
			Messages:>{Error::VentilatedOpenContainer,Error::VentilatedOpenContainer},
			SetUp:>Module[{tube},
				$CreatedObjects={};

				If[DatabaseMemberQ[Object[Sample,"Ventilated test sample for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					EraseObject[{Object[Sample,"Ventilated test sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},Force->True,Verbose->False]
				];

				tube=Upload[<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],DeveloperObject->True|>];
				UploadSample[Model[Sample,"Isoprene"],{"A1",tube},InitialAmount->1.5 Milliliter,Name->"Ventilated test sample for ExperimentSampleManipulation unit test "<>$SessionUUID]
			],
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Test["Create a sample manipulation to transfer water into a tube and then centrifuge it for 5 minutes:",
			ExperimentSampleManipulation[{
				Define[Name->"Centrifuge Vessel",Container->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->1 Milliliter,Destination->"Centrifuge Vessel"],
				Centrifuge[Sample->"Centrifuge Vessel"]
			}],
			ObjectP[Object[Protocol,SampleManipulation]]
		],
		Example[{Messages,"InvalidCentrifugePrimitives","Returns $Failed if samples cannot be centrifuged:"},
			ExperimentSampleManipulation[{
				Define[Name->"Centrifuge Vessel",Container->Model[Container,Vessel,"1L Glass Bottle"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->500 Milliliter,Destination->"Centrifuge Vessel"],
				Centrifuge[Sample->"Centrifuge Vessel"],
				Centrifuge[Sample->Object[Sample,"Centrifuge Test Sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]]
			}],
			$Failed,
			Messages:>{Error::InvalidCentrifugePrimitives,Error::InvalidInput}
		],
		Test["Resolves LiquidHandlingScale to MacroLiquidHandling if the manipulations contain a centrifuge primitive for a 2mL tube:",
			Download[
				ExperimentSampleManipulation[{
					Centrifuge[Sample->Object[Sample,"Centrifuge Test Sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->1 Milliliter,Destination->Model[Container,Plate,"96-well 2mL Deep Well Plate"]]
				}],
				LiquidHandlingScale
			],
			MacroLiquidHandling
		],
		Test["Generates a protocol with LiquidHandlingScale resolved to MicroLiquidHandling when centrifuging a pcr plate:",
			Download[
				ExperimentSampleManipulation[{
					Define[Name->"pcr plate",Container->Model[Container,Plate,"96-well PCR Plate"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->100 Microliter,Destination->{"pcr plate","A1"}],
					Centrifuge[Sample->"pcr plate",Intensity->1000*RPM,Time->30*Second]
				}],
				LiquidHandlingScale
			],
			MicroLiquidHandling
		],
		Test["Generates a protocol with LiquidHandlingScale resolved to MicroLiquidHandling when centrifuging a 2mL DWP:",
			Download[
				ExperimentSampleManipulation[{
					Define[Name->"dwp",Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->1 Milliliter,Destination->{"dwp","A1"}],
					Centrifuge[Sample->"dwp",Intensity->1000*RPM,Time->30*Second]
				}],
				LiquidHandlingScale
			],
			MicroLiquidHandling
		],
		Test["Split Mixes and Transfers who may take more than 5 minutes (the maximum allowed for hamilton):",
			(
				protocol=ExperimentSampleManipulation[{
					Mix[
						Sample->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						NumberOfMixes->50,
						MixVolume->900 Microliter,
						MixFlowRate->100 Microliter/Second
					],
					Transfer[
						Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->100 Microliter,
						AspirationMixVolume->900 Microliter,
						AspirationNumberOfMixes->50,
						DispenseMixVolume->900 Microliter,
						DispenseNumberOfMixes->50
					]
				}];
				Download[protocol,ResolvedManipulations]
			),
			{
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={5})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={5})&),
				_Transfer?((!Or@@Join[Lookup[First[#],AspirationMix],Lookup[First[#],DispenseMix]])&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={15})&),
				_Mix?((Lookup[First[#],NumberOfMixes]=={5})&)
			},
			SetUp:>($CreatedObjects={};),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			Variables:>{protocol}
		],

		(* Lid spacer tests *)
		Test["A lid spacer is used if plate(s) are specified that require the lid to sit above the surface of the plate to avoid disturbing samples:",
			Download[
				myProtocol=ExperimentSampleManipulation[
					{
						Define[
							Name->"Source water plate",
							Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
						],
						Define[
							Name->"Source water",
							Sample->{"Source water plate","A1"}
						],
						Define[
							Name->"DynePlate",
							Container->Model[Container,Plate,"id:8qZ1VW06z9Zp"]
						],
						Transfer[
							Source->Model[Sample,"Milli-Q water"],
							Destination->"Source water",
							Amount->1 Milliliter
						],
						Transfer[
							Source->"Source water",
							Destination->{"DynePlate","A1"},
							Amount->50 Microliter
						]
					}
				],
				LidSpacerPlacements
			],
			{{LinkP[Model[Item,LidSpacer]],{}}},
			SetUp:>($CreatedObjects={};),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Test["Multiple lid spacers are requested if multiple spacer-requiring plates are being used:",
			DeleteDuplicates[Cases[
				Download[
					myProtocol=ExperimentSampleManipulation[
						{
							Define[
								Name->"Source water plate",
								Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
							],
							Define[
								Name->"Source water",
								Sample->{"Source water plate","A1"}
							],
							Define[
								Name->"DynePlate",
								Container->Model[Container,Plate,"id:8qZ1VW06z9Zp"]
							],
							Define[
								Name->"DynePlate 2",
								Container->Model[Container,Plate,"id:8qZ1VW06z9Zp"]
							],
							Transfer[
								Source->Model[Sample,"Milli-Q water"],
								Destination->"Source water",
								Amount->1 Milliliter
							],
							Transfer[
								Source->"Source water",
								Destination->{"DynePlate","A1"},
								Amount->50 Microliter
							],
							Transfer[
								Source->"Source water",
								Destination->{"DynePlate 2","A1"},
								Amount->50 Microliter
							]
						}
					],
					RequiredResources
				],
				{res_,LidSpacerPlacements,__}:>res[Object]
			]],
			{Repeated[ObjectP[Object[Resource,Sample]],{2}]},
			SetUp:>($CreatedObjects={};),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects])
		],
		Example[{Messages,"TransferStateAmountMismatch","Prints a message and returns $Failed if a request to transfer a liquid gives the transfer amount as a mass:"},
			ExperimentSampleManipulation[{
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Amount->1 Gram,
					Destination->Model[Container,Vessel,"2mL Tube"]
				]
			}],
			$Failed,
			Messages:>{Error::TransferStateAmountMismatch}
		],
		Test["The LidPlacements field is empty if PlaceLids->False:",
			Download[
				ExperimentSampleManipulation[{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Amount->1 Milliliter,
						Destination->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],"A1"}
					]
				},PlaceLids->False],
				LidPlacements
			],
			{}
		],
		Test["Supports the CounterbalanceWeight key in Filter and Centrifuge:",
			ExperimentSampleManipulation[{
				Define[Name->"tube",Container->Model[Container,Vessel,"2mL Tube"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->600 Microliter,Destination->"tube"],
				Filter[Sample->"tube",FiltrationType->Centrifuge,CounterbalanceWeight->{0.9 Gram}],
				Centrifuge[Sample->"tube",CounterbalanceWeight->{0.9 Gram}]
			}],
			ObjectP[Object[Protocol,SampleManipulation]],
			Stubs:>{$DeveloperSearch=False}
		],
		Test["Populates PlateAdapterPlacements when using plate models that require LiquidHandlerAdapter on liquid handlers:",
			protocol=ExperimentSampleManipulation[{
				Define[Name->"cartridge",Container->Model[Container,Plate,DropletCartridge,"id:6V0npvmVGVlZ"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->20 Microliter,Destination->{"cartridge","A1"}],
				Define[Name->"plate",Container->Model[Container,Plate,"id:Z1lqpMz1EnVL"]],
				Transfer[Source->Model[Sample,"Milli-Q water"],Amount->20 Microliter,Destination->{"plate","A1"}]
			}];
			Download[protocol,PlateAdapterPlacements],
			{
				(* {"Bio-Rad GCR96 Digital PCR Cartridge", "GCR96 droplet cartridge liquid handler adapter", position} *)
				{LinkP[Model[Container,Plate,DropletCartridge,"id:6V0npvmVGVlZ"]],LinkP[Model[Container,Rack,"id:O81aEBZKOqZX"]],"Plate Slot"},
				(* {"96-well Optical Semi-Skirted PCR Plate", "Semi-Skirted PCR plate heater-shaker block", position} *)
				{LinkP[Model[Container,Plate,"id:Z1lqpMz1EnVL"]],LinkP[Model[Container,Rack,"id:lYq9jRxNOzDl"]],"Plate Slot"}
			},
			Stubs:>{$DeveloperSearch=False},
			Variables:>{protocol}
		],
		Test["Populates PlateAdapterPlacements when using plate objects that require LiquidHandlerAdapter on liquid handlers:",
			protocol=ExperimentSampleManipulation[{
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Amount->20 Microliter,
					Destination->{Object[Container,Plate,DropletCartridge,"Droplet cartridge for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"}
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Amount->20 Microliter,
					Destination->{Object[Container,Plate,"Semi-skirted plate for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],"A1"}
				]
			}];
			Download[protocol,PlateAdapterPlacements],
			{
				(* {"Bio-Rad GCR96 Digital PCR Cartridge", "GCR96 droplet cartridge liquid handler adapter", position} *)
				{LinkP[Object[Container,Plate,DropletCartridge,"Droplet cartridge for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Model[Container,Rack,"id:O81aEBZKOqZX"]],"Plate Slot"},
				(* {"96-well Optical Semi-Skirted PCR Plate", "Semi-Skirted PCR plate heater-shaker block", position} *)
				{LinkP[Object[Container,Plate,"Semi-skirted plate for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID]],LinkP[Model[Container,Rack,"id:lYq9jRxNOzDl"]],"Plate Slot"}
			},
			Stubs:>{$DeveloperSearch=False},
			Variables:>{protocol}
		],
		Test["When transferring from the magnet position the MultiProbeHead can't be used:",
			(
				myProtocol=ExperimentSampleManipulation[
					{
						MoveToMagnet[Sample->Object[Container,Plate,"MultiProbeHead Magnet test plate "<>$SessionUUID]],
						Transfer[
							Source->(Object[Sample,#]&/@Table["MultiProbeHead Magnet test sample "<>ToString[x]<>" "<>$SessionUUID,{x,Range[96]}]),
							Destination->({Object[Container,Plate,"MultiProbeHead Magnet test plate "<>$SessionUUID],#} &/@Flatten[AllWells[]]),
							Amount->500 Microliter
						]
					}
				];

				Download[myProtocol,ResolvedManipulations]
			),
			{
				_MoveToMagnet,
				_Transfer?(MatchQ[#[DeviceChannel],{SingleProbe1,SingleProbe2,SingleProbe3,SingleProbe4,SingleProbe5,SingleProbe6,SingleProbe7,SingleProbe8}]&)..
			},
			SetUp:>(
				$CreatedObjects={};

				Module[{plate},

					plate=Upload[
						Association[
							Type->Object[Container,Plate],
							Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
							DeveloperObject->True,
							Name->"MultiProbeHead Magnet test plate "<>$SessionUUID
						]
					];

					UploadSample[
						Table[Model[Sample,"Milli-Q water"],96],
						Map[{#,plate}&,Flatten[AllWells[]]],
						InitialAmount->1.5 Milliliter,
						Name->Table["MultiProbeHead Magnet test sample "<>ToString[x]<>" "<>$SessionUUID,{x,Range[96]}]
					]
				]
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True,Verbose->False]; Unset[$CreatedObjects]),
			TimeConstraint->1000
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		Module[
			{
				filterObjects,objectID,allObjects,existingObjects,
				(* Centrifuge Setup *)
				vesselPacket,platePacket,vessel1,vessel2,plate1,centrifugeSamples,
				(* ReadPlate Setup *)
				numberOfInjectionSamples,injectionSampleNames,vesselPacket2,vessels,injectionSamples,
				saltSampleContainer,saltSample,testBench,testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testGlassVial,testHPLCVial,testChemicals,testSampleModel,testHPLCProtocol
			},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];
			Off[Warning::ExpiredSamples];

			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Product,"Aspirin (tablet, 500 count) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test bottle 1 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test bottle 2 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test bottle 3 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test tablet 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test tablet 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test tablet 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Model[Container,Vessel,"Filter Container with 4L Max Volume for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Model[Instrument,PeristalticPump,"Filter Peristaltic Pump for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Model[Item,Filter,"Filter Membrane Filter for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 1mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 3L (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample in DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample in DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample 2 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 3L (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Test Sample with 500 mL (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample without volume for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 2L sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 1mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 3L sample (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for volume-less sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Test two-part filter (bottom portion) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 15mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 3L sample (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,Filter,"Filter Test two-part filter (top portion) for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Sample,"Centrifuge Test Sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Centrifuge Test Sample 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Centrifuge Test Sample 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Centrifuge Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Centrifuge Sample Tube 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Centrifuge Sample Tube 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Injection test sample 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Injection test sample 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test vessel 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test vessel 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test vessel 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Container,Plate,"Semi-skirted plate for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Sample,"Salt Sample 1 (100 Milligram) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test salt sample container for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,DropletCartridge,"Droplet cartridge for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Bench,"Test bench for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 7 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical in HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Model[Sample,"Test sample model without pipetting method for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];

			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
			$CreatedObjects={};

			If[!DatabaseMemberQ[Model[Sample,"Aspirin (tablet)"]],
				Upload[<|
					TabletWeight->300 Milligram,
					DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
					Density->Quantity[1.4`,("Grams")/("Milliliters")],
					DeveloperObject->True,
					Expires->False,
					Flammable->False,
					Replace[IncompatibleMaterials]->{None},
					Name->"Aspirin (tablet)",
					State->Solid,
					Replace[Synonyms]->{"Aspirin (tablet)"},
					Tablet->True,
					Type->Model[Sample],
					Ventilated->False
				|>]
			];
			If[!DatabaseMemberQ[Object[Product,"Aspirin (tablet, 500 count) for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					CountPerSample->500,
					Packaging->Single,
					Name->"Aspirin (tablet, 500 count) for ExperimentSampleManipulation unit test "<>$SessionUUID,
					ProductModel->Link[Model[Sample,"Aspirin (tablet)"],Products],
					NumberOfItems->1,
					SampleType->Bottle,
					Type->Object[Product],
					DeveloperObject->True
				|>]
			];
			If[!DatabaseMemberQ[Object[Container,Vessel,"Test bottle 1 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					DeveloperObject->True,
					Model->Link[Model[Container,Vessel,"id:aXRlGnZmOONB"],Objects],
					Type->Object[Container,Vessel],
					Name->"Test bottle 1 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID
				|>]
			];
			If[!DatabaseMemberQ[Object[Container,Vessel,"Test bottle 2 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					DeveloperObject->True,
					Model->Link[Model[Container,Vessel,"id:aXRlGnZmOONB"],Objects],
					Type->Object[Container,Vessel],
					Name->"Test bottle 2 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID
				|>]
			];
			If[!DatabaseMemberQ[Object[Container,Vessel,"Test bottle 3 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					DeveloperObject->True,
					Model->Link[Model[Container,Vessel,"id:aXRlGnZmOONB"],Objects],
					Type->Object[Container,Vessel],
					Name->"Test bottle 3 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID
				|>]
			];
			If[!DatabaseMemberQ[Object[Sample,"Test tablet 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					Container->Link[Object[Container,Vessel,"Test bottle 1 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],Contents,2],
					DeveloperObject->True,
					Model->Link[Model[Sample,"Aspirin (tablet)"],Objects],
					Name->"Test tablet 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					Position->"A1",
					Status->Available,
					StorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
					Type->Object[Sample],
					Count->50
				|>]
			];
			If[!DatabaseMemberQ[Object[Sample,"Test tablet 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					Container->Link[Object[Container,Vessel,"Test bottle 2 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],Contents,2],
					DeveloperObject->True,
					Model->Link[Model[Sample,"Aspirin (tablet)"],Objects],
					Name->"Test tablet 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					Position->"A1",
					Status->Available,
					StorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
					Type->Object[Sample],
					Count->50
				|>]
			];
			If[!DatabaseMemberQ[Object[Sample,"Test tablet 3 for ExperimentSampleManipulation unit test "<>$SessionUUID]],
				Upload[<|
					Container->Link[Object[Container,Vessel,"Test bottle 3 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],Contents,2],
					DeveloperObject->True,
					Model->Link[Model[Sample,"Aspirin (tablet)"],Objects],
					Name->"Test tablet 3 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					Position->"A1",
					Status->Available,
					StorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
					Type->Object[Sample],
					Count->50
				|>]
			];

			(* list of test objects for Filter Macro testing *)
			filterObjects={
				Object[Sample,"Filter Sample with 3L (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample with 3L (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Container for 3L sample (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Container for 3L sample (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Container for 2L sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Container for 15mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample with 1mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Container for 1mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample without volume for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Container for volume-less sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Model[Instrument,PeristalticPump,"Filter Peristaltic Pump for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Model[Container,Vessel,"Filter Container with 4L Max Volume for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Model[Item,Filter,"Filter Membrane Filter for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Protocol,Filter,"Filter Template Protocol for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Plate,"DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Plate,"Filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Plate,"Filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample in DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample in DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Sample 2 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,Filter,"Filter Test two-part filter (top portion) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Vessel,"Filter Test two-part filter (bottom portion) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Sample,"Filter Test Sample with 500 mL (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Plate,DropletCartridge,"Droplet cartridge for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],
				Object[Container,Plate,"Semi-skirted plate for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID]
			};

			(*create an ID that we'll use for the kitting*)
			objectID=CreateID[Object[Container,Vessel,Filter]];

			(* upload containers for filter testing *)
			Upload[
				{
					Association[Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"5L Glass Bottle"],Objects],Name->"Filter Container for 3L sample (I) for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"5L Glass Bottle"],Objects],Name->"Filter Container for 3L sample (II) for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2L Glass Bottle"],Objects],Name->"Filter Container for 2L sample for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Name->"Filter Container for 15mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Name->"Filter Container for 1mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"15mL Tube"],Objects],Name->"Filter Container for volume-less sample for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Model[Container,Vessel],Name->"Filter Container with 4L Max Volume for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,MaxVolume->4 Liter],
					Association[Type->Model[Instrument,PeristalticPump],Name->"Filter Peristaltic Pump for ExperimentSampleManipulation unit test "<>$SessionUUID,Replace[SampleHandlingCategories]->{Standard},DeveloperObject->True],
					Association[Type->Model[Item,Filter],Name->"Filter Membrane Filter for ExperimentSampleManipulation unit test "<>$SessionUUID,FilterType->Membrane,MembraneMaterial->PES,PoreSize->.22 Micron,Diameter->142 Millimeter,MinVolume->500 Milliliter,MaxVolume->12 Liter,DeveloperObject->True],
					Association[Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Plate],Model->Link[Model[Container,Plate,Filter,"id:eGakld0955Lo"],Objects],Name->"Filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Plate],Model->Link[Model[Container,Plate,Filter,"id:eGakld0955Lo"],Objects],Name->"Filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Plate,DropletCartridge],Model->Link[Model[Container,Plate,DropletCartridge,"id:6V0npvmVGVlZ"],Objects],Name->"Droplet cartridge for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:Z1lqpMz1EnVL"],Objects],Name->"Semi-skirted plate for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]],
					Association[
						Object->objectID,
						Type->Object[Container,Vessel,Filter],
						Model->Link[Model[Container,Vessel,Filter,"id:KBL5DvYOxMWa"],Objects],
						Name->"Filter Test two-part filter (top portion) for ExperimentSampleManipulation unit test "<>$SessionUUID,
						DeveloperObject->True,
						Site -> Link[$Site]
					],
					Association[
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"id:AEqRl954GGbp"],Objects],
						Name->"Filter Test two-part filter (bottom portion) for ExperimentSampleManipulation unit test "<>$SessionUUID,
						Replace[KitComponents]->{Link[objectID,KitComponents]},
						DeveloperObject->True,
						Site -> Link[$Site]
					]

				}
			];
			(* upload samples for filter testing *)
			UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",Object[Container,Vessel,"Filter Container for 3L sample (I) for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"Filter Container for 3L sample (II) for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"Filter Container for 2L sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"Filter Container for 15mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"Filter Container for 1mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Vessel,"Filter Container for volume-less sample for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Plate,"DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Plate,"Filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Plate,"Filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A2",Object[Container,Plate,"Filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID]},
					{"A1",Object[Container,Vessel,Filter,"Filter Test two-part filter (top portion) for ExperimentSampleManipulation unit test "<>$SessionUUID]}
				},
				InitialAmount->{3 Liter,3 Liter,2 Liter,15 Milliliter,1 Milliliter,Null,1 Milliliter,1 Milliliter,1 Milliliter,1 Milliliter,1 Milliliter,0.5*Liter},
				Name->{
					"Filter Sample with 3L (I) for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample with 3L (II) for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample with 1mL for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample without volume for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample in DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample in DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Sample 2 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Filter Test Sample with 500 mL (II) for ExperimentSampleManipulation unit test "<>$SessionUUID
				}
			];
			Upload[{
				Association[Object->Object[Sample,"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID],Concentration->10 Millimolar,DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample with 3L (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample with 3L (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample with 1mL for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample without volume for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample in DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample in DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Sample 2 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True],
				Association[Object->Object[Sample,"Filter Test Sample with 500 mL (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],DeveloperObject->True]
			}];

			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for ExperimentSampleManipulation unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True,
				Site->Link[$Site]
			|>];

			(* Centrifuge Setup *)
			vesselPacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],DeveloperObject->True,Site->Link[$Site]|>;
			platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Centrifuge Plate for ExperimentSampleManipulation unit test "<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>;

			{vessel1,vessel2,plate1}=Upload[
				Join[
					Append[vesselPacket,Name->#]&/@{"Centrifuge Sample Tube 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,"Centrifuge Sample Tube 2 for ExperimentSampleManipulation unit test "<>$SessionUUID},
					{platePacket}
				]
			];

			centrifugeSamples=UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]},
				{
					{"A1",vessel1},
					{"A1",vessel2},
					{"A1",plate1}},
				InitialAmount->{
					1 Milliliter,
					1 Milliliter,
					1 Milliliter
				},
				Name->{
					"Centrifuge Test Sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Centrifuge Test Sample 2 for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Centrifuge Test Sample 3 for ExperimentSampleManipulation unit test "<>$SessionUUID
				}
			];

			(* ReadPlate SetUp *)
			numberOfInjectionSamples=3;
			injectionSampleNames="Injection test sample "<>ToString[#]<>" for ExperimentSampleManipulation unit test "<>$SessionUUID&/@Range[numberOfInjectionSamples];

			vesselPacket2=<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Site->Link[$Site]|>;

			vessels=Upload@Map[
				Append[vesselPacket2,Name->"Test vessel "<>ToString[#]<>" for ExperimentSampleManipulation unit test "<>$SessionUUID]&,
				Range[numberOfInjectionSamples]
			];

			injectionSamples=UploadSample[
				Table[Model[Sample,StockSolution,"0.2M FITC"],numberOfInjectionSamples],
				Map[{"A1",#}&,vessels],
				Name->injectionSampleNames,
				InitialAmount->ConstantArray[15 Milliliter,numberOfInjectionSamples]
			];

			(* Resuspend SetUp *)
			saltSampleContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test salt sample container for ExperimentSampleManipulation unit test "<>$SessionUUID
			];
			saltSample=UploadSample[
				Model[Sample,"Sodium Chloride"],
				{"A1",saltSampleContainer},
				Name->"Salt Sample 1 (100 Milligram) for ExperimentSampleManipulation unit test "<>$SessionUUID
			];

			(* Once Glorious Water Sample and Chemical in Plate *)
			testEmptyContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID
			];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for ExperimentSampleManipulation unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID
			];
			testGlassVial=UploadSample[
				Model[Container,Vessel,"8x43mm Glass Reaction Vial"],
				{"Work Surface",testBench},
				Name->"Test glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID
			];
			testHPLCVial=UploadSample[
				Model[Container,Vessel,"HPLC vial (high recovery)"],
				{"Work Surface",testBench},
				Name->"Test HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID
			];
			testChemicals=UploadSample[
				{
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"A4",testPlate},
					{"A5",testPlate},
					{"A6",testPlate},
					{"A7",testPlate},
					{"A1",testGlassVial},
					{"A1",testHPLCVial}
				},
				Name->{
					"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical 5 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical 6 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical 7 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID,
					"Test chemical in HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID
				},
				InitialAmount->{
					1.5 Milliliter,
					1.4 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					200 Microliter,
					100 Microliter,
					500 Microliter
				}
			];

			testSampleModel=UploadSampleModel[
				"Test sample model without pipetting method for ExperimentSampleManipulation unit test "<>$SessionUUID,
				Composition -> {{100 VolumePercent, Model[Molecule, "Water"]}},
				Expires -> False,
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				State -> Liquid
			];

			(* Remove PipettingMethod so we can get the default behavior of SM *)
			Upload[<|Object->testSampleModel,PipettingMethod->Null|>];

			(* Upload test HPLC protocol *)
			testHPLCProtocol=Upload[
				<|
					Type->Object[Protocol,HPLC],
					Name->"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID,
					ImageSample->True,
					DeveloperObject->True
				|>
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[centrifugeSamples,injectionSamples,{saltSampleContainer,saltSample,testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testSampleModel},testChemicals]
				]
			]
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Product,"Aspirin (tablet, 500 count) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test bottle 1 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test bottle 2 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test bottle 3 for SM for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test tablet 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test tablet 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test tablet 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Model[Container,Vessel,"Filter Container with 4L Max Volume for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Model[Instrument,PeristalticPump,"Filter Peristaltic Pump for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Model[Item,Filter,"Filter Membrane Filter for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 15mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 1mL for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample 1 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 3L (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample in DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample in DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 2L for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample in filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample 2 in filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample with 3L (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Test Sample with 500 mL (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Filter Sample without volume for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Filter plate 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Filter plate 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 2L sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 1mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 3L sample (II) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for volume-less sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Test two-part filter (bottom portion) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 15mL sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Filter Container for 3L sample (I) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,Filter,"Filter Test two-part filter (top portion) for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Sample,"Centrifuge Test Sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Centrifuge Test Sample 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Centrifuge Test Sample 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Centrifuge Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Centrifuge Sample Tube 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Centrifuge Sample Tube 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Sample,"Injection test sample 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Injection test sample 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Injection test sample 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test vessel 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test vessel 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test vessel 3 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Container,Plate,"Semi-skirted plate for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"DWP 1 for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"DWP 2 for ExperimentSampleManipulation unit test "<>$SessionUUID],

						Object[Sample,"Salt Sample 1 (100 Milligram) for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test salt sample container for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,DropletCartridge,"Droplet cartridge for SM LH adapter testing for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Bench,"Test bench for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 7 in plate for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical in glass vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Sample,"Test chemical in HPLC vial for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Model[Sample,"Test sample model without pipetting method for ExperimentSampleManipulation unit test "<>$SessionUUID],
						Object[Protocol,HPLC,"Test HPLC protocol with Sample Prep for ExperimentSampleManipulation unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];

			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::ExpiredSamples];
		]
	}
];

removeSMObjects[]:=Module[{objects},
	objects={
		Object[Sample,"Centrifuge Test Sample 1"],
		Object[Sample,"Centrifuge Test Sample 2"],
		Object[Sample,"Centrifuge Test Sample 3"],
		Object[Container,Vessel,"Centrifuge Sample Tube 1"],
		Object[Container,Vessel,"Centrifuge Sample Tube 2"],
		Object[Container,Plate,"Centrifuge Plate"]
	};
	EraseObject[
		PickList[objects,DatabaseMemberQ[objects]],
		Force->True,
		Verbose->False
	]
];



(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulationOptions*)


DefineTests[ExperimentSampleManipulationOptions,
	{
		Example[{Basic,"Returns resolved options for ExperimentSampleManipulation when passed a single manipulation:"},
			ExperimentSampleManipulationOptions[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]]},OutputFormat->List],
			{Rule[_,Except[Automatic]]..}
		],
		Example[{Basic,"Returns resolved options for ExperimentSampleManipulation when passed a list of inputs:"},
			ExperimentSampleManipulationOptions[{
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->25 Microliter,Destination->Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]]},
				OutputFormat->List
			],
			{Rule[_,Except[Automatic]]..}
		],
		Example[{Basic,"The returned resolved options do not contain Automatic or $Failed:"},
			ExperimentSampleManipulationOptions[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]]},OutputFormat->List],
			{Rule[_,Except[(Automatic|$Failed)]]..}
		],
		Example[{Options,OutputFormat,"Return the resolved options as a table:"},
			ExperimentSampleManipulationOptions[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]]}],
			Graphics_
		],
		Example[{Options,OutputFormat,"Return the resolved options as a list:"},
			ExperimentSampleManipulationOptions[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]]},OutputFormat->List],
			{Rule[_,Except[(Automatic|$Failed)]]..}
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				testBench,testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testChemicals
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Bench,"Test bench for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testEmptyContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
				Status->Stocked
			];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for ExperimentSampleManipulationOptions unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID
			];
			testChemicals=UploadSample[
				{
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"A4",testPlate},
					{"A5",testPlate},
					{"A6",testPlate}
				},
				Name->{
					"Test chemical 1 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
					"Test chemical 2 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
					"Test chemical 3 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
					"Test chemical 4 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
					"Test chemical 5 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID,
					"Test chemical 6 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID
				},
				InitialAmount->{
					1.5 Milliliter,
					1.4 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter
				}
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{testWaterContainer,testWaterSample,testPlate},testChemicals]
				]
			];
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulationOptions unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentSampleManipulationPreview*)


DefineTests[ExperimentSampleManipulationPreview,
	{
		Example[{Basic,"Returns a summary table for the protocol that would be executed if ExperimentSampleManipulation were called with the requested manipulation:"},
			ExperimentSampleManipulationPreview[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]]}],
			_Pane
		],
		Example[{Basic,"Returns a summary table for the protocol that would be executed if ExperimentSampleManipulation were called with multiple requested manipulations:"},
			ExperimentSampleManipulationPreview[{
				Transfer[Source->Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],Amount->50 Microliter,Destination->Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],Amount->100 Microliter,Destination->Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]],
				Transfer[Source->Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],Amount->25 Microliter,Destination->Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]]}],
			_Pane
		],
		Example[{Basic,"The preview displays the resolved or requested Manipulation scale:"},
			ExperimentSampleManipulationPreview[{Transfer[Source->Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],Amount->25 Milliliter,Destination->Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]]},LiquidHandlingScale->MacroLiquidHandling],
			_Pane
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				testBench,testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testChemicals
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Bench,"Test bench for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testEmptyContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
				Status->Stocked
			];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for ExperimentSampleManipulationPreview unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID
			];
			testChemicals=UploadSample[
				{
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"A4",testPlate},
					{"A5",testPlate},
					{"A6",testPlate}
				},
				Name->{
					"Test chemical 1 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
					"Test chemical 2 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
					"Test chemical 3 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
					"Test chemical 4 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
					"Test chemical 5 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID,
					"Test chemical 6 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID
				},
				InitialAmount->{
					1.5 Milliliter,
					1.4 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter
				}
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{testWaterContainer,testWaterSample,testPlate},testChemicals]
				]
			];
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ExperimentSampleManipulationPreview unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentSampleManipulationQ*)


DefineTests[ValidExperimentSampleManipulationQ,
	{
		Example[{Basic,"Validates a request to perform a single sample manipulation:"},
			ValidExperimentSampleManipulationQ[{
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
					Amount->25 Milliliter,
					Destination->Object[Container,Vessel,"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
				]
			}],
			True
		],
		Example[{Basic,"Validates a request to perform multiple sample manipulation:"},
			ValidExperimentSampleManipulationQ[{
				Transfer[
					Source->Object[Sample,"Test chemical 1 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
					Amount->50 Microliter,
					Destination->Object[Sample,"Test chemical 2 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 3 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
					Amount->100 Microliter,
					Destination->Object[Sample,"Test chemical 4 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
				],
				Transfer[
					Source->Object[Sample,"Test chemical 5 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
					Amount->25 Microliter,
					Destination->Object[Sample,"Test chemical 6 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
				]
			}],
			True
		],
		Example[{Basic,"Validates a request to perform a manipulation while specifying the liquid handling scale:"},
			ValidExperimentSampleManipulationQ[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Amount->25 Milliliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
					]
				},
				LiquidHandlingScale->MacroLiquidHandling
			],
			True
		],
		Example[{Options,OutputFormat,"Check the validity of a request to perform a sample manipulation and return a test summary if OutputFormat -> TestSummary:"},
			ValidExperimentSampleManipulationQ[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Amount->25 Milliliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
					]
				},
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Check the validity of a request to perform a sample manipulation and and indicate the passing and failing tests with the Verbose option:"},
			ValidExperimentSampleManipulationQ[
				{
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Amount->25 Milliliter,
						Destination->Object[Container,Vessel,"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
					]
				},
				Verbose->True
			],
			True
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				testBench,testEmptyContainer,testWaterContainer,testWaterSample,testPlate,testChemicals
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Bench,"Test bench for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testEmptyContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
				Status->Stocked
			];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID
			];
			testChemicals=UploadSample[
				{
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"],
					Model[Sample,"Dimethylformamide, Reagent Grade"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"A4",testPlate},
					{"A5",testPlate},
					{"A6",testPlate}
				},
				Name->{
					"Test chemical 1 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
					"Test chemical 2 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
					"Test chemical 3 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
					"Test chemical 4 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
					"Test chemical 5 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID,
					"Test chemical 6 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID
				},
				InitialAmount->{
					1.5 Milliliter,
					1.4 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter,
					1.5 Milliliter
				}
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{testWaterContainer,testWaterSample,testPlate},testChemicals]
				]
			];
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 2 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 3 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 4 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 5 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 6 in plate for ValidExperimentSampleManipulationQ unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];



(* ::Subsubsection::Closed:: *)
(*OptimizePrimitives*)


DefineTests[OptimizePrimitives,
	{
		Example[{Basic,"Merge liquid handling primitives to be in the most efficient format for the instrument executing the transfers:"},
			OptimizePrimitives[{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->40 Microliter,
					Destination->{"My Plate","A1"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->20 Microliter,
					Destination->{"My Plate","A2"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->20 Microliter,
					Destination->{"My Plate","A3"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->10 Microliter,
					Destination->{"My Plate","A4"}
				]
			}],
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{40 Microliter},
							{20 Microliter},
							{20 Microliter},
							{10 Microliter}
						},
						Destination->{
							{{"My Plate","A1"}},
							{{"My Plate","A2"}},
							{{"My Plate","A3"}},
							{{"My Plate","A4"}}
						}
					],
					AllowForeignKeys->True
				]&)
			}
		],
		Example[{Basic,"Aliquot and Consolidation primitives are merged into Transfer primitives:"},
			OptimizePrimitives[{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->20 Microliter,
					Destination->{"My Plate","A1"}
				],
				Aliquot[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amounts->{20 Microliter,40 Microliter},
					Destinations->{{"My Plate","A2"},{"My Plate","A3"}}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->10 Microliter,
					Destination->{"My Plate","A4"}
				],
				Consolidation[
					Sources->{
						Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID]
					},
					Amounts->{10 Microliter,10 Microliter},
					Destination->{"My Plate","A5"}
				]
			}],
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{20 Microliter},
							{20 Microliter},
							{40 Microliter},
							{10 Microliter},
							{10 Microliter},
							{10 Microliter}
						},
						Destination->{
							{{"My Plate","A1"}},
							{{"My Plate","A2"}},
							{{"My Plate","A3"}},
							{{"My Plate","A4"}},
							{{"My Plate","A5"}},
							{{"My Plate","A5"}}
						}
					],
					AllowForeignKeys->True
				]&)
			}
		],
		Example[{Basic,"Merged transfers will have a maximum Source/Destination pair length of 8, matching the maximum number of liquid handler pipetting channels that can be used simultaneously:"},
			OptimizePrimitives[{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->20 Microliter,
					Destination->{"My Plate","A1"}
				],
				Aliquot[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amounts->{20 Microliter,40 Microliter,40 Microliter,40 Microliter,40 Microliter},
					Destinations->{
						{"My Plate","A2"},
						{"My Plate","A3"},
						{"My Plate","A4"},
						{"My Plate","A5"},
						{"My Plate","A6"}
					}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->10 Microliter,
					Destination->{"My Plate","A7"}
				],
				Consolidation[
					Sources->{
						Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID]
					},
					Amounts->{10 Microliter,10 Microliter},
					Destination->{"My Plate","A8"}
				]
			}],
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{20 Microliter},
							{20 Microliter},
							{40 Microliter},
							{40 Microliter},
							{40 Microliter},
							{40 Microliter},
							{10 Microliter},
							{10 Microliter}
						},
						Destination->{
							{{"My Plate","A1"}},
							{{"My Plate","A2"}},
							{{"My Plate","A3"}},
							{{"My Plate","A4"}},
							{{"My Plate","A5"}},
							{{"My Plate","A6"}},
							{{"My Plate","A7"}},
							{{"My Plate","A8"}}
						}
					],
					AllowForeignKeys->True
				]&),
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{{Object[Sample,"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID]}},
						Amount->{{10 Microliter}},
						Destination->{{{"My Plate","A8"}}}
					],
					AllowForeignKeys->True
				]&)
			}
		],
		Example[{Additional,"If a Transfer's source is a member of the previous optimized Transfer's destinations, the two primitives are not merged since this source should only be aspirated after the previous Transfer pipets into it:"},
			OptimizePrimitives[{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->40 Microliter,
					Destination->{"My Plate","A1"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->40 Microliter,
					Destination->{"My Plate","A2"}
				],
				Transfer[
					Source->{"My Plate","A2"},
					Amount->20 Microliter,
					Destination->{"My Plate","A3"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->10 Microliter,
					Destination->{"My Plate","A4"}
				]
			}],
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{40 Microliter},
							{40 Microliter},
							{10 Microliter}
						},
						Destination->{
							{{"My Plate","A1"}},
							{{"My Plate","A2"}},
							{{"My Plate","A4"}}
						}
					],
					AllowForeignKeys->True
				]&),
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{{"My Plate","A2"}}
						},
						Amount->{{20 Microliter}},
						Destination->{
							{{"My Plate","A3"}}
						}
					],
					AllowForeignKeys->True
				]&)
			}
		],
		Example[{Additional,"Primitives that are not liquid-transfers remain in the same order:"},
			OptimizePrimitives[{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->100 Microliter,
					Destination->{"My Plate","A1"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->100 Microliter,
					Destination->{"My Plate","A2"}
				],
				Wait[Duration->2 Minute],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->100 Microliter,
					Destination->{"My Plate","A3"}
				]
			}],
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{_?((#==100 Microliter)&)},
							{_?((#==100 Microliter)&)}
						},
						Destination->{
							{{"My Plate","A1"}},
							{{"My Plate","A2"}}
						}
					],
					AllowForeignKeys->True
				]&),
				_Wait,
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{_?((#==100 Microliter)&)}
						},
						Destination->{
							{{"My Plate","A3"}}
						}
					],
					AllowForeignKeys->True
				]&)
			}
		],
		Example[{Additional,"Large Transfer volumes will be partitioned such that each partitioned volume can be pipetted by a single channel:"},
			OptimizePrimitives[{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->2 Milliliter,
					Destination->{"My Plate","A1"}
				],
				Transfer[
					Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
					Amount->1.5 Milliliter,
					Destination->{"My Plate","A2"}
				]
			}],
			{
				Define[
					Name->"My Plate",
					Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
				],
				_Transfer?(AssociationMatchQ[First[#],
					Association[
						Source->{
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]},
							{Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID]}
						},
						Amount->{
							{_?((#==970 Microliter)&)},
							{_?((#==970 Microliter)&)},
							{_?((#==970 Microliter)&)},
							{_?((#==530 Microliter)&)},
							{_?((#==60 Microliter)&)}
						},
						Destination->{
							{{"My Plate","A1"}},
							{{"My Plate","A2"}},
							{{"My Plate","A1"}},
							{{"My Plate","A2"}},
							{{"My Plate","A1"}}
						}
					],
					AllowForeignKeys->True
				]&)
			}
		],
		Example[{Additional,"Converts Resuspend primitives into Transfer and (if applicable) Incubate or Mix primitives:"},
			OptimizePrimitives[{
				Define[Sample->Model[Sample,"Milli-Q water"],Container->Model[Container,Vessel,"2mL Tube"],Name->"Sample 2",ContainerName->"Destination Container 1"],
				Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"Destination Container 1",Amount->0.5 Milliliter],
				Resuspend[Sample->"Destination Container 1",Volume->1 Milliliter,IncubationTime->10 Minute]
			}],
			{
				_Define,
				_Transfer,
				_Incubate
			}
		],
		Example[{Additional,"The resulting optimized primitives can be directly passed into ExperimentSampleManipulation:"},
			(
				myOptimizedPrimitives=OptimizePrimitives[{
					Define[
						Name->"My Plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Amount->40 Microliter,
						Destination->{"My Plate","A1"}
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Amount->20 Microliter,
						Destination->{"My Plate","A2"}
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Amount->20 Microliter,
						Destination->{"My Plate","A3"}
					],
					Transfer[
						Source->Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Amount->10 Microliter,
						Destination->{"My Plate","A4"}
					]
				}];

				ExperimentSampleManipulation[myOptimizedPrimitives]
			),
			ObjectP[Object[Protocol,SampleManipulation]],
			SetUp:>(
				$CreatedObjects={};
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True]
			),
			Variables:>{myOptimizedPrimitives}
		],
		Example[{Additional,"384-well Optimization","Transfer operations with 384-well destinations are optimized to reach into every other well in a given column at a time:"},
			(
				myOptimizedPrimitives=OptimizePrimitives[{
					Define[
						Name->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
						Sample->Model[Sample,"Milli-Q water"],
						Container->Model[Container,Plate,"id:54n6evLWKqbG"]
					],
					Define[
						Name->"dest plate",
						Container->Model[Container,Plate,"id:pZx9jo83G0VP"] (* 384-well qPCR Optical Reaction Plate *)
					],
					Transfer[
						Source->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
						Destination->({"dest plate",#}&/@{"A1","B1","C1","D1","E1","F1","G1","H1","I1","J1","K1","L1","M1","N1","O1","P1"}),
						Amount->100 Microliter
					]
				}];
				Lookup[
					Cases[myOptimizedPrimitives,Transfer[assoc_]:>assoc],
					Destination
				][[All,All,All,2]]
			),
			{
				{{"A1"},{"C1"},{"E1"},{"G1"},{"I1"},{"K1"},{"M1"},{"O1"}},
				{{"B1"},{"D1"},{"F1"},{"H1"},{"J1"},{"L1"},{"N1"},{"P1"}}
			},
			Variables:>{myOptimizedPrimitives}
		],
		Example[{Additional,"384-well Optimization","Mix operations on 384-well sources are optimized to reach into every other well in a given column at a time:"},
			(
				myOptimizedPrimitives=OptimizePrimitives[{
					Define[
						Name->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
						Sample->Model[Sample,"Milli-Q water"],
						Container->Model[Container,Plate,"id:54n6evLWKqbG"]
					],
					Define[
						Name->"dest plate",
						Container->Model[Container,Plate,"id:pZx9jo83G0VP"] (* 384-well qPCR Optical Reaction Plate *)
					],
					Transfer[
						Source->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
						Destination->({"dest plate",#}&/@{"A1","B1","C1","D1","E1","F1","G1","H1","I1","J1","K1","L1","M1","N1","O1","P1"}),
						Amount->100 Microliter
					],
					Mix[
						Sample->({"dest plate",#}&/@{"A1","B1","C1","D1","E1","F1","G1","H1","I1","J1","K1","L1","M1","N1","O1","P1"}),
						NumberOfMixes->1,
						MixVolume->50 Microliter
					]
				}];
				Lookup[
					Cases[myOptimizedPrimitives,Mix[assoc_]:>assoc],
					Sample
				][[All,All,2]]
			),
			{
				{"A1","C1","E1","G1","I1","K1","M1","O1"},
				{"B1","D1","F1","H1","J1","L1","N1","P1"}
			},
			Variables:>{myOptimizedPrimitives}
		],
		Example[{Additional,"384-well Optimization","Transfer and Mix operations on 96-well plates operate on wells in order within columns:"},
			(
				myOptimizedPrimitives=OptimizePrimitives[{
					Define[
						Name->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
						Sample->Model[Sample,"Milli-Q water"],
						Container->Model[Container,Plate,"id:54n6evLWKqbG"]
					],
					Define[
						Name->"dest plate",
						Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
						Destination->({"dest plate",#}&/@{"A1","B1","C1","D1","E1","F1","G1","H1"}),
						Amount->100 Microliter
					],
					Mix[
						Sample->({"dest plate",#}&/@{"A1","B1","C1","D1","E1","F1","G1","H1"}),
						NumberOfMixes->1,
						MixVolume->50 Microliter
					]
				}];
				{
					Lookup[
						Cases[myOptimizedPrimitives,Transfer[assoc_]:>assoc],
						Destination
					][[All,All,All,2]],
					Lookup[
						Cases[myOptimizedPrimitives,Mix[assoc_]:>assoc],
						Sample
					][[All,All,2]]
				}
			),
			{
				{{{"A1"},{"B1"},{"C1"},{"D1"},{"E1"},{"F1"},{"G1"},{"H1"}}},
				{{"A1","B1","C1","D1","E1","F1","G1","H1"}}
			},
			Variables:>{myOptimizedPrimitives}
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				testBench,testWaterContainer,testWaterSample,testPlate,testChemical
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						Object[Container,Bench,"Test bench for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for OptimizePrimitives unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for OptimizePrimitives unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for OptimizePrimitives unit test "<>$SessionUUID
			];
			testChemical=UploadSample[
				Model[Sample,"Dimethylformamide, Reagent Grade"],
				{"A1",testPlate},
				Name->"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID,
				InitialAmount->1.5 Milliliter
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{testWaterContainer,testWaterSample,testPlate,testChemical}]
				]
			];
		]
	},
	SymbolTearDown:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for OptimizePrimitives unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for OptimizePrimitives unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*ImportSampleManipulation*)


DefineTests[ImportSampleManipulation,
	{
		Example[{Basic,"Generate a list of Transfer Primitives given a cloud file:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Simple Transfer"]],
			{{SampleManipulationP..}..}
		],

		Example[{Basic,"Generate a list of Transfer Primitives given a path to local excel file:"},
			(
				path=DownloadCloudFile[Object[EmeraldCloudFile,"Simple Transfer"],FileNameJoin[{$TemporaryDirectory,"simpleTransfers.xlsx"}]];
				ImportSampleManipulation[path]
			),
			{{SampleManipulationP..}..}
		],

		Example[{Basic,"Generate a list of Transfer Primitives given raw data:"},
			ImportSampleManipulation[
				{
					{"Object[Sample,\"Blah\"]","Object[Sample,\"Blah2\"]","Object[Sample,\"Blah3\"]"},
					{50.,50.,50.}
				}
			],
			{SampleManipulationP..}
		],

		Example[{Additional,"Generate multiple lists of Transfer Primitives given a list of cloud files, file paths, or raw data:"},
			(
				path=DownloadCloudFile[Object[EmeraldCloudFile,"Simple Transfer2"],FileNameJoin[{$TemporaryDirectory,"simpleTransfers2.xlsx"}]];
				ImportSampleManipulation[
					{
						Object[EmeraldCloudFile,"Simple Transfer"],
						path,
						{
							{"Object[Sample,\"Blah\"]","Object[Sample,\"Blah2\"]","Object[Sample,\"Blah3\"]"},
							{50.,50.,50.}
						}
					}
				]
			),
			{({{SampleManipulationP..}..}|{SampleManipulationP..})..}
		],

		Example[{Additional,"Generate a list of Transfer Primitives with options:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Transfer With Options"]],
			{{SampleManipulationP..}..}
		],

		Example[{Additional,"Generate a list of Sample Manipulation Primitives besides Transfer:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"All Primitives"]],
			{{SampleManipulationP..}..}
		],

		Example[{Additional,"Multiple sheets in the same excel file result in different lists of primitives being generated:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Multiple Sheets"]],
			{{SampleManipulationP..}..}
		],

		Example[{Additional,"Have more control over the destination wells by using the Well header:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Transfer With Well"]],
			{{SampleManipulationP..}..}
		],

		Example[{Additional,"Have more control over Plate Model with Plate Model header:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Transfer With Plate Model"]],
			{{SampleManipulationP..}..}
		],

		Example[{Additional,"Have control over multiple plates with Plate Number header:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Transfer With Plate Number"]],
			{{SampleManipulationP..}..}
		],

		Example[{Options,ReadDirection,"Setting ReadDirection->Column will generate the primitives column by column instead of row by row:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"All Primitives"],ReadDirection->Column],
			{{SampleManipulationP..}..}
		],

		Example[{Messages,"InvalidFormat","Cannot generate primitives from a file with invalid format:"},
			ImportSampleManipulation[Object[EmeraldCloudFile,"Import Sample Manipulation Invalid Format"]],
			{$Failed},
			Messages:>{Error::InvalidFormat}
		]
	}
];


(* ::Subsection:: *)
(*ValidImportSampleManipulationQ*)
DefineTests[ValidImportSampleManipulationQ,
	{
		Example[{Basic,"Validate a request to generate a list of Sample Manipulation Primitives from a cloud file:"},
			ValidImportSampleManipulationQ[Object[EmeraldCloudFile,"Simple Transfer"]],
			True
		],

		Example[{Basic,"Validate a request to generate a list of Sample Manipulation Primitives from a file path:"},
			(
				path=DownloadCloudFile[Object[EmeraldCloudFile,"Simple Transfer"],FileNameJoin[{$TemporaryDirectory,"simpleTransfers.xlsx"}]];
				ValidImportSampleManipulationQ[path]
			),
			True
		],

		Example[{Basic,"Validate a request to generate a list of Sample Manipulation Primitives from raw data:"},
			ValidImportSampleManipulationQ[
				{
					{"Object[Sample,\"Blah\"]","Object[Sample,\"Blah2\"]","Object[Sample,\"Blah3\"]"},
					{50.,50.,50.}
				}
			],
			True
		],

		Example[{Basic,"Validate a request to generate multiple lists of Transfer Primitives given a list of cloud files, file paths, or raw data:"},
			(
				path=DownloadCloudFile[Object[EmeraldCloudFile,"Simple Transfer2"],FileNameJoin[{$TemporaryDirectory,"simpleTransfers2.xlsx"}]];
				ValidImportSampleManipulationQ[
					{
						Object[EmeraldCloudFile,"Simple Transfer"],
						path,
						{
							{"Object[Sample,\"Blah\"]","Object[Sample,\"Blah2\"]","Object[Sample,\"Blah3\"]"},
							{50.,50.,50.}
						}
					}
				]
			),
			{True..}
		],

		Example[{Basic,"Validation will fail if the format of the input is not valid:"},
			ValidImportSampleManipulationQ[Object[EmeraldCloudFile,"Import Sample Manipulation Invalid Format"]],
			False
		],

		Example[{Options,Verbose,"Control the printing of tests performed during validation of the generation of Sample Manipulation primitives:"},
			ValidImportSampleManipulationQ[Object[EmeraldCloudFile,"Simple Transfer2"],Verbose->True],
			True
		]
	}
];
