(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMedia*)


(* ::Subsubsection:: *)
(*ExperimentMedia*)

DefineTests[
	ExperimentMedia,
	{
		(* ExperimentMedia options *)
		Example[{Basic,"Create a protocol for the preparation of media:"},
			ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID]],
			{ObjectP[Object[Protocol,StockSolution]]}
		],
		Example[{Options,Supplements,"Use Supplements option to specify any additional media components that should be added beyond what is already included in the Formula of the input media model:"},
			{protocol}=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Supplements->{{40*Microgram/Milliliter,Model[Sample,"Ampicillin for ExperimentMedia"<>$SessionUUID]}},
				MediaName->"Test media model for ExperimentMedia (LB, liquid) + 40ug/mL Ampicillin"<>$SessionUUID
			];
			{revisedFormula}=Download[protocol,StockSolutionModels[Composition]];
			MemberQ[revisedFormula,{_?QuantityQ,LinkP[Model[Molecule,"Ampicillin"]]}],
			True,
			Variables:>{protocol,revisedFormula}
		],
		Example[{Options,DropOuts,"Use DropOuts option to specify any substances from the Formula of the input media model that should be excluded in the preparation of media:"},
			{protocol}=ExperimentMedia[Model[Sample,Media,"Salt water media model for ExperimentMedia"<>$SessionUUID],
				DropOuts->{Model[Molecule,"Sodium Chloride"]},
				MediaName->"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID
			];
			{revisedFormula}=Download[protocol,StockSolutionModels[Composition]];
			Cases[revisedFormula,{_?QuantityQ,LinkP[Model[Molecule,"Sodium Chloride"]]}],
			{},
			Variables:>{protocol,revisedFormula}
		],
		Example[{Options,MediaPhase,"Use MediaPhase option to specify the desired physical state of the prepared media at ambient temperature at pressure. If MediaPhase is set to Solid but the GellingAgents field of the input media model is not populated, or if no GellingAgent is detected in the Formula field of the input model, the GellingAgents option is automatically set to {20 mg/mL, Model[Sample, \"Agar\"]}:"},
			{protocol}=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				MediaPhase->Solid
			];
			{revisedFormula}=Download[protocol,StockSolutionModels[Composition]];
			MemberQ[revisedFormula,{_?QuantityQ,LinkP[Model[Molecule,"Agar"]]},Infinity],
			True,
			Variables:>{protocol,revisedFormula}
		],
		Example[{Options,GellingAgents,"Use GellingAgents option to specify the substances that should be added after preparation of the input media model to prepare a solid media:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				GellingAgents->{{2*Gram/Liter,Model[Sample,"Agar"]}},
				Output->Options
			],
			Lookup[options,MediaPhase],
			{Solid}
		],
		Example[{Options,PlateMedia,"Use PlateMedia option to indicate whether the prepared media should be transferred to plates designated for cell growth and incubation:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateMedia->True,
				Output->Options
			];
			Lookup[options,{PlateOut,NumberOfPlates}],
			{{ObjectP[Model[Container]],_Integer}},
			Variables:>{protocol}
		],
		Example[{Options,PlateOut,"Use PlateOut and NumberOfPlates option to specify the types and number of plates into which the prepared media should be transferred:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				NumberOfPlates->20,
				Output->Options
			],
			Lookup[options, {PlateOut,NumberOfPlates}],
			{ObjectP[Model[Container],_?IntegerQ]},
			Variables:>{options}
		],
		(* ***NOTE: these are to be reincorporated when we bring the plate pourer online ***
		Example[{Options,PlatingMethod,"Use PlatingMethod option to specify whether the prepared media should be transferred to plates designated for cell growth and incubation manually using a serological pipette or via pump on the serial filler instrument. If set to Pump, the PlatePourer option is automatically set to a serial filler instrument that satisfies Model[Instrument,PlatePourer]:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlatingMethod->{Pump},
				Output->Options
			];
			Lookup[options,PlatePourer],
			ObjectP[Model[Instrument,PlatePourer]],
			Variables:>{options}
		],
		Example[{Options,PlatingInstrument,"Use PlatingInstrument option to specify the model of the serial filler instrument that should be used to transfer the prepared media to plates designated for cell growth and incubation:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlatingInstrument->Model[Instrument,PlatePourer,"Serial Filler"],
				Output->Options
			];
			Lookup[options,PlatingInstrument],
			ObjectP[Model[Instrument,PlatePourer]],
			Variables:>{options}
		],*)
		Example[{Options,PrePlatingIncubationTime,"Use PrePlatingIncubationTime option to specify the duration of time for which the media should be heated/cooled with optional stirring to the target PlatingTemperature:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PrePlatingIncubationTime->30*Minute,
				Output->Options
			];
			Lookup[options,PrePlatingIncubationTime],
			{30*Minute},
			Variables:>{options}
		],
		Example[{Options,MaxPrePlatingIncubationTime,"Use MaxPrePlatingIncubationTime option to specify the maximum duration of time for which the media should be heated/cooled with optional stirring to the target PlatingTemperature:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				MaxPrePlatingIncubationTime->3*Hour,
				Output->Options
			];
			Lookup[options,MaxPrePlatingIncubationTime],
			{3*Hour},
			Variables:>{options}
		],
		Example[{Options,PrePlatingMixRate,"Use PrePlatingMixRate option to specify the rate at which the stir bar within the liquid media should be rotated prior to plating the media:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PrePlatingMixRate->200*RPM,
				Output->Options
			];
			Lookup[options,PrePlatingMixRate],
			{200*RPM},
			Variables:>{options}
		],
		Example[{Options,PlatingTemperature,"Use PlatingTemperature option to specify the temperature at which the autoclaved media with gelling agents is incubated prior to and during the media plating process:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlatingTemperature->75*Celsius,
				Output->Options
			];
			Lookup[options,PlatingTemperature],
			{75*Celsius},
			Variables:>{options}
		],
		(*Example[{Options,PumpFlowRate,"Use PumpFlowRate option to specify the volume of liquid media pumped by the serial filler instrument for media plating:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PumpFlowRate->200*Milliliter/Minute,
				Output->Options
			];
			Lookup[options,PumpFlowRate],
			200*Milliliter/Minute,
			Variables:>{options}
		],*)
		Example[{Options,PlatingVolume,"Use PlatingVolume option to specify the volume of liquid media transferred from its source container into each incubation plate:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlatingVolume->30*Milliliter,
				Output->Options
			];
			Lookup[options,PlatingVolume],
			{30*Milliliter},
			Variables:>{options}
		],
		Example[{Options,SolidificationTime,"Use SolidificationTime to specify the duration of time after plating the media that they are held at ambient temperature for the media containing gelling agents to solidify before allowing them to be used for experiments:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				SolidificationTime->1*Hour,
				Output->Options
			];
			Lookup[options,SolidificationTime],
			{1*Hour},
			Variables:>{options}
		],
		Example[{Options,PlatedMediaShelfLife,"Use PlatedMediaShelfLife to specify the duration of time after which the prepared plates are considered to be expired:"},
			options=ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlatedMediaShelfLife->1*Week,
				Output->Options
			];
			Lookup[options,PlatedMediaShelfLife],
			{1*Week},
			Variables:>{options}
		],
		
		(* Warning and Error messages *)
		Example[{Messages,"SupplementPresentInMediaFormula","Throw an error if any of the specified Supplements are already present in the input media model's Composition, advising the user to create a new media model with updated concentrations for the components"},
			ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Supplements->{{50*Microgram/Milliliter,Model[Sample,"Ampicillin for ExperimentMedia"<>$SessionUUID]}},
				MediaName->"Test media model for ExperimentMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID
			],
			{ObjectP[Object[Protocol,StockSolution]]},
			Messages:>{Warning::RedundantSupplements}
		],
		Example[{Messages,"GellingAgentPresentInMediaFormula","Throw an error if the type and/or the amount of gelling agents specified in the GellingAgents option differs from the GellingAgents of the input Model[Sample,Media], advising the user to create a new media model with desired concentration of the specified GellingAgents:"},
			ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				GellingAgents->{{20*Gram/Liter,Model[Sample,"Agar for ExperimentMedia"<>$SessionUUID]}},
				MediaName->"Test media model for ExperimentMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID
			],
			{ObjectP[Object[Protocol,StockSolution]]},
			Messages:>{Warning::RedundantGellingAgents}
		],
		Example[{Messages,"ConflictingMediaPhaseGellingAgentsOptions","Throw an error if MediaPhase is set to Liquid and the GellingAgents option is specified simultaneously:"},
			ExperimentMedia[Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				MediaPhase->Liquid,
				GellingAgents->{{20*Gram/Liter,Model[Sample,"Agar for ExperimentMedia"<>$SessionUUID]}}
			],
			$Failed,
			Messages:>{Error::GellingAgentsForLiquidMedia,Error::InvalidOption}
		],
		Example[{Messages,"MissingDropOutTarget","Throw a warning if any of the specified DropOuts are not present in the input media model's Composition:"},
			ExperimentMedia[Model[Sample,Media,"Salt water media model for ExperimentMedia"<>$SessionUUID],
				DropOuts->{Model[Molecule, "Uracil"]}
			],
			{ObjectP[Object[Protocol,StockSolution]]},
			Messages:>{Warning::DropOutMissingFromTemplate}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,mediaSampleLabels,mediaModelLabels,allMediaContainerPackets,allMediaSamplePackets,testBench,container1},
			objects={
				Object[Container,Bench,"Test bench for ExperimentMedia tests"<> $SessionUUID],
				Object[Container,Vessel,"Container for ExperimentMedia tests"<>$SessionUUID],
				Model[Sample,"Ampicillin for ExperimentMedia"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentMedia"<>$SessionUUID],
				Object[Sample,"Agar object for ExperimentMedia"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (YPD, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Salt water media model for ExperimentMedia"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Uracil from Salt Water not possible"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (yeast synthetic complete medium, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (yeast synthetic complete medium, liquid) - Uracil"<>$SessionUUID],
				Object[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,Media,"Test media model for ExperimentMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			testBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for ExperimentMedia tests"<> $SessionUUID,
					Site -> Link[$Site]
				|>];

			container1 = UploadSample[Model[Container,Vessel,"id:8qZ1VWNmddlD"], {"Work Surface", testBench}, Name-> "Container for ExperimentMedia tests"<>$SessionUUID];

			(* Test YPD & LB liquid media *)
			UploadMedia[
				{
					Model[Sample,Media,"Yeast Peptone Dextrose Medium"],
					Model[Sample,Media,"LB Broth, Miller"]
				},
				MediaName->{
					"Test media model for ExperimentMedia (YPD, liquid)"<>$SessionUUID,
					"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID
				}
			];
			
			UploadMedia[{{10*Gram,Model[Sample,"Sodium Chloride"]},{980*Milliliter,Model[Sample,"Milli-Q water"]}},
				Model[Sample,"Milli-Q water"],
				1*Liter,
				MediaName->"Salt water media model for ExperimentMedia"<>$SessionUUID
			];
			
			(* Test LB liquid media with 50ug/mL Ampicillin *)
			With[{ampicillin = UploadSampleModel["Ampicillin for ExperimentMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Ampicillin"]}},State->Solid,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
					Supplements->{{50*Milligram,ampicillin}},
					MediaName->"Test media model for ExperimentMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID
				]
			];
			
			(* Test LB solid media with 2% Agar *)
			With[{agar = UploadSampleModel["Agar for ExperimentMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->85*Celsius,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadSample[agar, {"A1", container1}, Name -> "Agar object for ExperimentMedia"<>$SessionUUID, InitialAmount -> 30*Gram];
				UploadMedia[
					Model[Sample,Media,"LB Broth, Miller"],
					MediaName->"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID,
					GellingAgents->{{20*Gram/Liter,agar}}
				]
			];
			
			mediaSampleLabels={
				"(LB, liquid)",
				"(LB, solid w/2% Agar)",
				"(LB, partially melted solid w/2% Agar)"
			};
			mediaModelLabels={
				"(LB, liquid)",
				"(LB, solid w/2% Agar)",
				"(LB, partially melted solid w/2% Agar)",
				"(YPD, liquid)",
				"(yeast synthetic complete medium, liquid)",
				"(yeast synthetic complete medium, liquid) - Uracil"
			};
			(* Upload containers for the Test media model objects *)
			allMediaContainerPackets=Map[Association[
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container for sample media for ExperimentMedia "<>#<>$SessionUUID
			]&,mediaSampleLabels];
			
			allMediaSamplePackets=Map[Association[
				Type->Object[Sample,Media],
				Model->Model[Sample,Media,"Test media model for ExperimentMedia "<>#<>$SessionUUID],
				Amount->1*Liter
			]&,mediaSampleLabels];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		Module[{objects,existsFilter},
			objects={
				Object[Container,Bench,"Test bench for ExperimentMedia tests"<> $SessionUUID],
				Object[Container,Vessel,"Container for ExperimentMedia tests"<>$SessionUUID],
				Model[Sample,"Ampicillin for ExperimentMedia"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentMedia"<>$SessionUUID],
				Object[Sample,"Agar object for ExperimentMedia"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (YPD, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Salt water media model for ExperimentMedia"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Uracil from Salt Water not possible"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (yeast synthetic complete medium, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentMedia (yeast synthetic complete medium, liquid) - Uracil"<>$SessionUUID],
				Object[Sample,Media,"Test media model for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,Media,"Test media model for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,Media,"Test media model for ExperimentMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];