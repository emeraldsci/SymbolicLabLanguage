(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadMedia*)


(* ::Subsubsection:: *)
(*UploadMedia*)

DefineTests[UploadMedia,
	{
		Example[{Basic,"Create a model for 1L of liquid LB media:"},
			UploadMedia[
				{
					{25Gram,Model[Sample,"LB Broth Miller (Sigma Aldrich)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MediaName->"Liquid LB for UploadMedia"<>$SessionUUID
			],
			{ObjectP[Model[Sample,Media]]}
		],
		Example[{Options,Supplements,"Specify additional substances that would traditionally appear in the name of the media, such as 2% Ampicillin in LB + 2% Ampicillin:"},
			{mediaModel} = UploadMedia[Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID],
				Supplements->{{25Milligram/Liter,Model[Sample,"Ampicillin for UploadMedia"<>$SessionUUID]}}
			];
			Download[mediaModel,BaseMedia],
			ObjectP[Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID]],
			Variables:>{mediaModel}
		],
		Example[{Options,DropOuts,"Specify substances from the Formula of ModelMedia that are completely excluded in the preparation of the media:"},
			{mediaModel} = UploadMedia[Model[Sample,Media,"Test media model 2 for UploadMedia (LB, liquid)"<>$SessionUUID],
				DropOuts->{Model[Molecule,"Sodium Chloride"]}
			];
			Download[mediaModel,BaseMedia],
			ObjectP[Model[Sample,Media,"Test media model 2 for UploadMedia (LB, liquid)"<>$SessionUUID]],
			Variables:>{mediaModel}
		],
		Example[{Options,GellingAgents,"Specify the types and amounts of substances added to solidify the prepared media:"},
			{mediaModel} = UploadMedia[Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID],
				GellingAgents->{{15Gram/Liter,Model[Sample,"Agar for UploadMedia"<>$SessionUUID]}}
			];
			{gellingAgents} = Download[mediaModel,GellingAgents];
			MatchQ[gellingAgents,{_?QuantityQ,LinkP[Model[Sample,"Agar for UploadMedia"<>$SessionUUID]]}],
			True,
			Variables:>{mediaModel,gellingAgents}
		],
		
		(* pH Titration *)
		Example[{Options, AdjustpH, "Specify whether to adjust the pH following component combination and mixing; if AdjustpH->True and NominalpH is not specified, it is automatically set to 7:"},
			mediaModel =UploadMedia[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->True
			];
			Download[mediaModel,NominalpH],
			{_Real..},
			Variables:>{mediaModel}
		],
		Example[{Options, AdjustpH, "Specify whether to adjust the pH following component combination and mixing; if AdjustpH->True and NominalpH is not specified, it is automatically set to 7:"},
			mediaModel =UploadMedia[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->7
			];
			Download[mediaModel,NominalpH],
			{_Real..},
			Variables:>{mediaModel}
		],
		Example[{Options,AdjustpH,"Specify whether to adjust the pH following component combination and mixing; if AdjustpH->True and NominalpH is not specified, it is automatically set to 7:"},
			mediaModel =UploadMedia[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MinpH->7,
				MaxpH->9
			];
			Download[mediaModel,NominalpH],
			{EqualP[8]..},
			Variables:>{mediaModel}
		],
		Example[{Options,Resuspension,"Use Resuspension option to indicate if the stock solution has a fixed amount component that should be resuspended in its original container first:"},
			mediaModel =With[{ampicillin = UploadSampleModel["Fixed amount ampicillin for UploadMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Ampicillin"]}},FixedAmounts->{50Milligram},TransferOutSolventVolumes->{100Milliliter},SingleUse->True,SampleHandling->Fixed,State->Solid,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						{50 Milligram, ampicillin},
						{90 Milliliter, Model[Sample,"Milli-Q water"]}
					},
					Model[Sample,"Milli-Q water"],
					100 Milliliter,
					Resuspension->True
				]
			];
			Download[mediaModel,Resuspension],
			{True..},
			Variables:>{mediaModel}
		],
		Example[{Options,StockSolutionTemplate,"Use preparation defaults from an existing solution for a different formula:"},
			With[{newLB = UploadSampleModel["LB Broth Miller Template Model for UploadMedia"<>$SessionUUID,
				Composition->{
					{20*MassPercent,Model[Molecule,"Yeast Extract"]},
					{40*MassPercent,Model[Molecule,"Tryptone"]},
					{40*MassPercent,Model[Molecule,"Sodium Chloride"]}
				},
				State->Solid, Expires->False, MSDSRequired->False, DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[{{25 Gram,newLB}},
					Model[Sample, "Milli-Q water"],
					1*Liter,
					MediaName->"New LB from a template LB model"<>$SessionUUID,
					StockSolutionTemplate->Model[Sample,Media,"LB Broth, Miller"]
				]
			],
			{ObjectP[Model[Sample,Media]]}
		],
		Example[{Options,DiscardThreshold,"Specify the percentage of the prepared stock solution volume below which the sample will be automatically marked as AwaitingDisposal:"},
			Download[
				UploadMedia[
					{
						{58.44 Gram, Model[Sample,"LB Broth Miller (Sigma Aldrich)"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					DiscardThreshold -> 4 Percent
				],
				DiscardThreshold
			],
			{EqualP[4 Percent]}
		],
		Example[{Messages,"SupplementsForMediaFormula","Throw an error if a user specifies the Supplements option when creating a new media model with a formula:"},
			UploadMedia[
				{
					{25Gram,Model[Sample,"LB Broth Miller (Sigma Aldrich)"]}
				},
				Model[Sample,"Milli-Q water"],
				1Liter,
				Supplements->{{1Gram,Model[Sample,"Potassium Chloride"]}}
			],
			$Failed,
			Messages:>{Error::SupplementsForMediaFormula,Error::InvalidOption}
		],
		Example[{Messages,"DropOutsForMediaFormula","Throw an error if a user specifies the DropOuts option when creating a new media model with a formula:"},
			UploadMedia[
				{
					{25Gram,Model[Sample,"LB Broth Miller (Sigma Aldrich)"]}
				},
				Model[Sample,"Milli-Q water"],
				1Liter,
				DropOuts->{Model[Molecule,"Sodium Chloride"]}
			],
			$Failed,
			Messages:>{Error::DropOutsForMediaFormula,Error::InvalidOption}
		],
		Example[{Messages,"DropOutInSupplements","Throw an error if an identity model specified for the DropOuts option is also present in a component specified for the Supplements option:"},
			UploadMedia[
				Model[Sample,Media,"LB Broth, Miller"],
				Supplements->{{1Gram,Model[Sample,"Sodium Chloride"]}},
				DropOuts->{Model[Molecule,"Sodium Chloride"]}
			],
			$Failed,
			Messages:>{Error::DropOutInSupplements,Warning::RedundantSupplements,Error::InvalidOption}
		],
		Example[{Messages,"DropOutInGellingAgents","Throw an error if an identity model specified for the DropOuts option is also present in a component specified for the GellingAgents option:"},
			UploadMedia[
				Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				GellingAgents->{{10Gram,Model[Sample,"Agar for UploadMedia"<>$SessionUUID]}},
				DropOuts->{Model[Molecule,"Agar"]}
			],
			$Failed,
			Messages:>{Error::DropOutInGellingAgents,Warning::RedundantGellingAgents,Error::InvalidOption}
		],
		Example[{Messages,"GellingAgentMissingMeltingPoint","Throw an error if MeltingPoint is not specified for a component in the specified GellingAgents option:"},
			With[{agarMissingMP = UploadSampleModel["Agar without Melting Point for UploadMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->Null,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						{25 Gram,Model[Sample,"LB Broth Miller (Sigma Aldrich)"]}
					},
					Model[Sample, "Milli-Q water"],
					1*Liter,
					GellingAgents->{{20Gram,agarMissingMP}}
				]
			],
			$Failed,
			{Error::GellingAgentMissingMeltingPoint,Error::InvalidOption}
		],
		Example[{Messages,"GellingAgentsForLiquidMedia","Throw an error if the GellingAgents option is specified while the MediaPhase option is set to Liquid:"},
			UploadMedia[
				Model[Sample,Media,"LB Broth, Miller"],
				MediaPhase->Liquid,
				GellingAgents->{{20Gram,Model[Sample,"Agar for UploadMedia"<>$SessionUUID]}}
			],
			$Failed,
			{Error::GellingAgentsForLiquidMedia,Error::InvalidOption}
		],
		Example[{Messages,"RedundantSupplements","Throw a warning if a component specified for the Supplements option is already present in the formula of the template media model:"},
			UploadMedia[
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Supplements->{{50Milligram,Model[Sample,"Ampicillin for UploadMedia"<>$SessionUUID]}}
			],
			{ObjectP[Model[Sample,Media]]},
			Messages:>{Warning::RedundantSupplements}
		],
		Example[{Messages,"RedundantGellingAgents","Throw a warning if a component specified for the GellingAgents option is already present in the template media model, explaining that a new media model will be created with the same formula and the specified gelling agent in excess of the specified amount:"},
			{mediaModel} = UploadMedia[
				Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				GellingAgents->{{15Gram/Liter,Model[Sample,"Agar for UploadMedia"<>$SessionUUID]}}
			];
			Download[mediaModel,GellingAgents],
			{{_?QuantityQ,LinkP[Model[Sample,"Agar for UploadMedia"<>$SessionUUID]]}},
			Messages:>{Warning::RedundantGellingAgents},
			Variables:>{mediaModel}
		],
		Test["If Autoclave is set to or default to True, the resulted Model[Sample, Media] is automatically populated with Sterile and AsepticHandling as True:",
			UploadMedia[
				{
					{25Gram, Model[Sample, "LB Broth Miller (Sigma Aldrich)"]}
				},
				Model[Sample, "Milli-Q water"],
				1 Liter,
				MediaName -> "Liquid LB Autoclaved for UploadMedia test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, Media, "Liquid LB Autoclaved for UploadMedia test of Sterile field" <> $SessionUUID],
				{Autoclave, Sterile, AsepticHandling}
			],
			{True, True, True}
		],
		Test["If filtering with size at or below 0.22 Micrometer, the resulted Model[Sample, Media] is automatically populated with Sterile and AsepticHandling as True:",
			UploadMedia[
				{
					{25Gram, Model[Sample, "LB Broth Miller (Sigma Aldrich)"]}
				},
				Model[Sample, "Milli-Q water"],
				1 Liter,
				Autoclave -> False,
				Filter -> True,
				FilterSize -> 0.22 Micrometer,
				MediaName -> "Liquid LB Filtered for UploadMedia test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, Media, "Liquid LB Filtered for UploadMedia test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{True, True}
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
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
		Module[{objects,existsFilter,testBench,mediaSampleLabels,mediaModelLabels,allMediaContainerPackets,allMediaSamplePackets},
			objects={
				Object[Container,Bench,"Test bench for UploadMedia tests"<>$SessionUUID],
				Model[Sample,"Ampicillin for UploadMedia"<>$SessionUUID],
				Model[Sample,"Fixed amount ampicillin for UploadMedia"<>$SessionUUID],
				Model[Sample,"Agar for UploadMedia"<>$SessionUUID],
				Model[Sample,"Agar without Melting Point for UploadMedia"<>$SessionUUID],
				Model[Sample,"LB Broth Miller Template Model for UploadMedia"<>$SessionUUID],
				Model[Sample,Media,"Liquid LB for UploadMedia"<>$SessionUUID],
				Model[Sample,Media,"New LB from a template LB model"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model 2 for UploadMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (YPD, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Salt water media model for UploadMedia"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Uracil from Salt Water not possible"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (yeast synthetic complete medium, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (yeast synthetic complete medium, liquid) - Uracil"<>$SessionUUID],
				Object[Sample,"Test sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,"Test sample media 2 for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,"Test sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for UploadMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container 2 for test sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
			
			(* Set up test bench *)
			testBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for UploadMedia tests"<>$SessionUUID,DeveloperObject->True|>];
			
			UploadMedia[{{10*Gram,Model[Sample,"Sodium Chloride"]},{980*Milliliter,Model[Sample,"Milli-Q water"]}},
				Model[Sample,"Milli-Q water"],
				1*Liter,
				MediaName->"Salt water media model for UploadMedia"<>$SessionUUID
			];
			
			(* Test LB solid media with 2% Agar *)
			With[{agar = UploadSampleModel["Agar for UploadMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->85*Celsius,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"Yeast Peptone Dextrose Medium"]
					},
					MediaName->{
						"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID,
						"Test media model 2 for UploadMedia (LB, liquid)"<>$SessionUUID,
						"Test media model for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID,
						"Test media model for UploadMedia (YPD, liquid)"<>$SessionUUID
					},
					GellingAgents->{None,None,{{20*Gram/Liter,agar}},None}
				]
			];
			
			(* Test LB liquid media with 50ug/mL Ampicillin *)
			With[{ampicillin = UploadSampleModel["Ampicillin for UploadMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Ampicillin"]}},State->Solid,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID],
					Supplements->{{50*Milligram,ampicillin}},
					MediaName->"Test media model for UploadMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID
				]
			];
			
			(* Test LB media Object[Sample] *)
			With[{containers = UploadSample[{
				Model[Container, Vessel, "1L Glass Bottle"],
				Model[Container, Vessel, "1L Glass Bottle"],
				Model[Container, Vessel, "1L Glass Bottle"]
			},
				{
					{"Bench Top Slot",Object[Container,Bench,"Test bench for UploadMedia tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Test bench for UploadMedia tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Test bench for UploadMedia tests"<>$SessionUUID]}
				},
				Name->{
					"Container for test sample media for UploadMedia (LB, liquid)"<>$SessionUUID,
					"Container 2 for test sample media for UploadMedia (LB, liquid)"<>$SessionUUID,
					"Container for test sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID
				}]},
				UploadSample[{
					Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID],
					Model[Sample,Media,"Test media model 2 for UploadMedia (LB, liquid)"<>$SessionUUID],
					Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID]
				},
					{
						{"A1",containers[[1]]},
						{"A1",containers[[2]]},
						{"A1",containers[[3]]}
					},
					InitialAmount->{1Liter,1Liter,1Liter},
					Name->{
						"Test sample media for UploadMedia (LB, liquid)"<>$SessionUUID,
						"Test sample media 2 for UploadMedia (LB, liquid)"<>$SessionUUID,
						"Test sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID
					}
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
				Name->"Test container for sample media for UploadMedia "<>#<>$SessionUUID
			]&,mediaSampleLabels];
			
			allMediaSamplePackets=Map[Association[
				Type->Object[Sample,Media],
				Model->Model[Sample,Media,"Test media model for UploadMedia "<>#<>$SessionUUID],
				Amount->1*Liter
			]&,mediaSampleLabels];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		Module[{objects,existsFilter},
			objects={
				Object[Container,Bench,"Test bench for UploadMedia tests"<>$SessionUUID],
				Model[Sample,"Ampicillin for UploadMedia"<>$SessionUUID],
				Model[Sample,"Fixed amount ampicillin for UploadMedia"<>$SessionUUID],
				Model[Sample,"Agar for UploadMedia"<>$SessionUUID],
				Model[Sample,"Agar without Melting Point for UploadMedia"<>$SessionUUID],
				Model[Sample,"LB Broth Miller Template Model for UploadMedia"<>$SessionUUID],
				Model[Sample,Media,"Liquid LB for UploadMedia"<>$SessionUUID],
				Model[Sample,Media,"New LB from a template LB model"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model 2 for UploadMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (YPD, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Salt water media model for UploadMedia"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Uracil from Salt Water not possible"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (yeast synthetic complete medium, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for UploadMedia (yeast synthetic complete medium, liquid) - Uracil"<>$SessionUUID],
				Object[Sample,"Test sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,"Test sample media 2 for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,"Test sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for UploadMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container 2 for test sample media for UploadMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for UploadMedia (LB, solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];